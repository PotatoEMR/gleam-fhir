////FHIR r4 types
////https://hl7.org/fhir/r4

import gleam/option.{type Option, None}
import r4valuesets

///http://hl7.org/fhir/r4/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

pub fn element_new() -> Element {
  Element(extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Address#resource
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4valuesets.Addressuse),
    type_: Option(r4valuesets.Addresstype),
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

///http://hl7.org/fhir/r4/StructureDefinition/Age#resource
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource
pub type Annotation {
  Annotation(
    id: Option(String),
    extension: List(Extension),
    author: Option(AnnotationAuthor),
    time: Option(String),
    text: String,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Annotation#resource
pub type AnnotationAuthor {
  AnnotationAuthorReference(author: Reference)
  AnnotationAuthorString(author: String)
}

pub fn annotation_new(text text: String) -> Annotation {
  Annotation(text:, time: None, author: None, extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Attachment#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeableConcept#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Coding#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ContactDetail#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ContactPoint#resource
pub type Contactpoint {
  Contactpoint(
    id: Option(String),
    extension: List(Extension),
    system: Option(r4valuesets.Contactpointsystem),
    value: Option(String),
    use_: Option(r4valuesets.Contactpointuse),
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

///http://hl7.org/fhir/r4/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: r4valuesets.Contributortype,
    name: String,
    contact: List(Contactdetail),
  )
}

pub fn contributor_new(
  name name: String,
  type_ type_: r4valuesets.Contributortype,
) -> Contributor {
  Contributor(contact: [], name:, type_:, extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Count#resource
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: r4valuesets.Alltypes,
    profile: List(String),
    subject: Option(DatarequirementSubject),
    must_support: List(String),
    code_filter: List(Element),
    date_filter: List(Element),
    limit: Option(Int),
    sort: List(Element),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

pub fn datarequirement_new(type_ type_: r4valuesets.Alltypes) -> Datarequirement {
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

///http://hl7.org/fhir/r4/StructureDefinition/Distance#resource
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Dosage#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Duration#resource
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
pub type Elementdefinition {
  Elementdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    representation: List(r4valuesets.Propertyrepresentation),
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

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionDefaultvalueMeta(default_value: Meta)
}

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionFixedMeta(fixed: Meta)
}

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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
  ElementdefinitionPatternMeta(pattern: Meta)
}

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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

pub fn elementdefinition_new(path path: String) -> Elementdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Expression#resource
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

pub fn expression_new(language language: String) -> Expression {
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

///http://hl7.org/fhir/r4/StructureDefinition/Extension#resource
pub type Extension {
  Extension(
    id: Option(String),
    extension: List(Extension),
    url: String,
    value: Option(ExtensionValue),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Extension#resource
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
  ExtensionValueMeta(value: Meta)
}

pub fn extension_new(url url: String) -> Extension {
  Extension(value: None, url:, extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/HumanName#resource
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4valuesets.Nameuse),
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

///http://hl7.org/fhir/r4/StructureDefinition/Identifier#resource
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4valuesets.Identifieruse),
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

///http://hl7.org/fhir/r4/StructureDefinition/MarketingStatus#resource
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

pub fn marketingstatus_new(
  date_range date_range: Period,
  status status: Codeableconcept,
  country country: Codeableconcept,
) -> Marketingstatus {
  Marketingstatus(
    restore_date: None,
    date_range:,
    status:,
    jurisdiction: None,
    country:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Meta#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Money#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: r4valuesets.Narrativestatus,
    div: String,
  )
}

pub fn narrative_new(
  div div: String,
  status status: r4valuesets.Narrativestatus,
) -> Narrative {
  Narrative(div:, status:, extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/ParameterDefinition#resource
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: r4valuesets.Operationparameteruse,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: r4valuesets.Alltypes,
    profile: Option(String),
  )
}

pub fn parameterdefinition_new(
  type_ type_: r4valuesets.Alltypes,
  use_ use_: r4valuesets.Operationparameteruse,
) -> Parameterdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Period#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Population#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Population#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ProdCharacteristic#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ProductShelfLife#resource
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

pub fn productshelflife_new(
  period period: Quantity,
  type_ type_: Codeableconcept,
) -> Productshelflife {
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

///http://hl7.org/fhir/r4/StructureDefinition/Quantity#resource
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/Range#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Ratio#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Reference#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/RelatedArtifact#resource
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: r4valuesets.Relatedartifacttype,
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    url: Option(String),
    document: Option(Attachment),
    resource: Option(String),
  )
}

pub fn relatedartifact_new(
  type_ type_: r4valuesets.Relatedartifacttype,
) -> Relatedartifact {
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

///http://hl7.org/fhir/r4/StructureDefinition/SampledData#resource
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

pub fn sampleddata_new(
  dimensions dimensions: Int,
  period period: Float,
  origin origin: Quantity,
) -> Sampleddata {
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

///http://hl7.org/fhir/r4/StructureDefinition/Signature#resource
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

pub fn signature_new(who who: Reference, when when: String) -> Signature {
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceAmount#resource
pub type Substanceamount {
  Substanceamount(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Option(SubstanceamountAmount),
    amount_type: Option(Codeableconcept),
    amount_text: Option(String),
    reference_range: Option(Element),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceAmount#resource
pub type SubstanceamountAmount {
  SubstanceamountAmountQuantity(amount: Quantity)
  SubstanceamountAmountRange(amount: Range)
  SubstanceamountAmountString(amount: String)
}

pub fn substanceamount_new() -> Substanceamount {
  Substanceamount(
    reference_range: None,
    amount_text: None,
    amount_type: None,
    amount: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Timing#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: r4valuesets.Triggertype,
    name: Option(String),
    timing: Option(TriggerdefinitionTiming),
    data: List(Datarequirement),
    condition: Option(Expression),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource
pub type TriggerdefinitionTiming {
  TriggerdefinitionTimingTiming(timing: Timing)
  TriggerdefinitionTimingReference(timing: Reference)
  TriggerdefinitionTimingDate(timing: String)
  TriggerdefinitionTimingDatetime(timing: String)
}

pub fn triggerdefinition_new(
  type_ type_: r4valuesets.Triggertype,
) -> Triggerdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource
pub type Usagecontext {
  Usagecontext(
    id: Option(String),
    extension: List(Extension),
    code: Coding,
    value: UsagecontextValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/UsageContext#resource
pub type UsagecontextValue {
  UsagecontextValueCodeableconcept(value: Codeableconcept)
  UsagecontextValueQuantity(value: Quantity)
  UsagecontextValueRange(value: Range)
  UsagecontextValueReference(value: Reference)
}

pub fn usagecontext_new(
  value value: UsagecontextValue,
  code code: Coding,
) -> Usagecontext {
  Usagecontext(value:, code:, extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/MoneyQuantity#resource
pub type Moneyquantity {
  Moneyquantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r4valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r4/StructureDefinition/SimpleQuantity#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Resource#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Account#resource
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
    status: r4valuesets.Accountstatus,
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

pub fn account_new(status status: r4valuesets.Accountstatus) -> Account {
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

///http://hl7.org/fhir/r4/StructureDefinition/Account#resource
pub type AccountCoverage {
  AccountCoverage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    coverage: Reference,
    priority: Option(Int),
  )
}

pub fn account_coverage_new(coverage coverage: Reference) -> AccountCoverage {
  AccountCoverage(
    priority: None,
    coverage:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Account#resource
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

pub fn account_guarantor_new(party party: Reference) -> AccountGuarantor {
  AccountGuarantor(
    period: None,
    on_hold: None,
    party:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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
    kind: Option(r4valuesets.Requestresourcetypes),
    profile: Option(String),
    code: Option(Codeableconcept),
    intent: Option(r4valuesets.Requestintent),
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionSubject {
  ActivitydefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ActivitydefinitionSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionTiming {
  ActivitydefinitionTimingTiming(timing: Timing)
  ActivitydefinitionTimingDatetime(timing: String)
  ActivitydefinitionTimingAge(timing: Age)
  ActivitydefinitionTimingPeriod(timing: Period)
  ActivitydefinitionTimingRange(timing: Range)
  ActivitydefinitionTimingDuration(timing: Duration)
}

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionProduct {
  ActivitydefinitionProductReference(product: Reference)
  ActivitydefinitionProductCodeableconcept(product: Codeableconcept)
}

pub fn activitydefinition_new(
  status status: r4valuesets.Publicationstatus,
) -> Activitydefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Actionparticipanttype,
    role: Option(Codeableconcept),
  )
}

pub fn activitydefinition_participant_new(
  type_ type_: r4valuesets.Actionparticipanttype,
) -> ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    role: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
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
  expression expression: Expression,
  path path: String,
) -> ActivitydefinitionDynamicvalue {
  ActivitydefinitionDynamicvalue(
    expression:,
    path:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
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
    actuality: r4valuesets.Adverseeventactuality,
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

pub fn adverseevent_new(
  subject subject: Reference,
  actuality actuality: r4valuesets.Adverseeventactuality,
) -> Adverseevent {
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

///http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
pub type AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    instance: Reference,
    causality: List(AdverseeventSuspectentityCausality),
  )
}

pub fn adverseevent_suspectentity_new(
  instance instance: Reference,
) -> AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    causality: [],
    instance:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/AdverseEvent#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/AllergyIntolerance#resource
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
    type_: Option(r4valuesets.Allergyintolerancetype),
    category: List(r4valuesets.Allergyintolerancecategory),
    criticality: Option(r4valuesets.Allergyintolerancecriticality),
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

///http://hl7.org/fhir/r4/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceOnset {
  AllergyintoleranceOnsetDatetime(onset: String)
  AllergyintoleranceOnsetAge(onset: Age)
  AllergyintoleranceOnsetPeriod(onset: Period)
  AllergyintoleranceOnsetRange(onset: Range)
  AllergyintoleranceOnsetString(onset: String)
}

pub fn allergyintolerance_new(patient patient: Reference) -> Allergyintolerance {
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

///http://hl7.org/fhir/r4/StructureDefinition/AllergyIntolerance#resource
pub type AllergyintoleranceReaction {
  AllergyintoleranceReaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeableconcept),
    manifestation: List(Codeableconcept),
    description: Option(String),
    onset: Option(String),
    severity: Option(r4valuesets.Reactioneventseverity),
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

///http://hl7.org/fhir/r4/StructureDefinition/Appointment#resource
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
    status: r4valuesets.Appointmentstatus,
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

pub fn appointment_new(
  status status: r4valuesets.Appointmentstatus,
) -> Appointment {
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

///http://hl7.org/fhir/r4/StructureDefinition/Appointment#resource
pub type AppointmentParticipant {
  AppointmentParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    actor: Option(Reference),
    required: Option(r4valuesets.Participantrequired),
    status: r4valuesets.Participationstatus,
    period: Option(Period),
  )
}

pub fn appointment_participant_new(
  status status: r4valuesets.Participationstatus,
) -> AppointmentParticipant {
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

///http://hl7.org/fhir/r4/StructureDefinition/AppointmentResponse#resource
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
    participant_status: r4valuesets.Participationstatus,
    comment: Option(String),
  )
}

pub fn appointmentresponse_new(
  participant_status participant_status: r4valuesets.Participationstatus,
  appointment appointment: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
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
    action: Option(r4valuesets.Auditeventaction),
    period: Option(Period),
    recorded: String,
    outcome: Option(r4valuesets.Auditeventoutcome),
    outcome_desc: Option(String),
    purpose_of_event: List(Codeableconcept),
    agent: List(AuditeventAgent),
    source: AuditeventSource,
    entity: List(AuditeventEntity),
  )
}

pub fn auditevent_new(
  source source: AuditeventSource,
  recorded recorded: String,
  type_ type_: Coding,
) -> Auditevent {
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
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

pub fn auditevent_agent_new(requestor requestor: Bool) -> AuditeventAgent {
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventAgentNetwork {
  AuditeventAgentNetwork(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    address: Option(String),
    type_: Option(r4valuesets.Networktype),
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
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

pub fn auditevent_source_new(observer observer: Reference) -> AuditeventSource {
  AuditeventSource(
    type_: [],
    observer:,
    site: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetail {
  AuditeventEntityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    value: AuditeventEntityDetailValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventEntityDetailValue {
  AuditeventEntityDetailValueString(value: String)
  AuditeventEntityDetailValueBase64binary(value: String)
}

pub fn auditevent_entity_detail_new(
  value value: AuditeventEntityDetailValue,
  type_ type_: String,
) -> AuditeventEntityDetail {
  AuditeventEntityDetail(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Basic#resource
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

pub fn basic_new(code code: Codeableconcept) -> Basic {
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

///http://hl7.org/fhir/r4/StructureDefinition/Binary#resource
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

pub fn binary_new(content_type content_type: String) -> Binary {
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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
    product_category: Option(r4valuesets.Productcategory),
    product_code: Option(Codeableconcept),
    status: Option(r4valuesets.Productstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductManipulation {
  BiologicallyderivedproductManipulation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    time: Option(BiologicallyderivedproductManipulationTime),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductStorage {
  BiologicallyderivedproductStorage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    temperature: Option(Float),
    scale: Option(r4valuesets.Productstoragescale),
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

///http://hl7.org/fhir/r4/StructureDefinition/BodyStructure#resource
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

pub fn bodystructure_new(patient patient: Reference) -> Bodystructure {
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
pub type Bundle {
  Bundle(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    identifier: Option(Identifier),
    type_: r4valuesets.Bundletype,
    timestamp: Option(String),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntry),
    signature: Option(Signature),
  )
}

pub fn bundle_new(type_ type_: r4valuesets.Bundletype) -> Bundle {
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
pub type BundleLink {
  BundleLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relation: String,
    url: String,
  )
}

pub fn bundle_link_new(url url: String, relation relation: String) -> BundleLink {
  BundleLink(url:, relation:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Option(r4valuesets.Searchentrymode),
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
pub type BundleEntryRequest {
  BundleEntryRequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: r4valuesets.Httpverb,
    url: String,
    if_none_match: Option(String),
    if_modified_since: Option(String),
    if_match: Option(String),
    if_none_exist: Option(String),
  )
}

pub fn bundle_entry_request_new(
  url url: String,
  method method: r4valuesets.Httpverb,
) -> BundleEntryRequest {
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
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

pub fn bundle_entry_response_new(status status: String) -> BundleEntryResponse {
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    kind: r4valuesets.Capabilitystatementkind,
    instantiates: List(String),
    imports: List(String),
    software: Option(CapabilitystatementSoftware),
    implementation: Option(CapabilitystatementImplementation),
    fhir_version: r4valuesets.Fhirversion,
    format: List(String),
    patch_format: List(String),
    implementation_guide: List(String),
    rest: List(CapabilitystatementRest),
    messaging: List(CapabilitystatementMessaging),
    document: List(CapabilitystatementDocument),
  )
}

pub fn capabilitystatement_new(
  fhir_version fhir_version: r4valuesets.Fhirversion,
  kind kind: r4valuesets.Capabilitystatementkind,
  date date: String,
  status status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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

pub fn capabilitystatement_software_new(
  name name: String,
) -> CapabilitystatementSoftware {
  CapabilitystatementSoftware(
    release_date: None,
    version: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
  description description: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRest {
  CapabilitystatementRest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4valuesets.Restfulcapabilitymode,
    documentation: Option(String),
    security: Option(CapabilitystatementRestSecurity),
    resource: List(CapabilitystatementRestResource),
    interaction: List(CapabilitystatementRestInteraction),
    search_param: List(Nil),
    operation: List(Nil),
    compartment: List(String),
  )
}

pub fn capabilitystatement_rest_new(
  mode mode: r4valuesets.Restfulcapabilitymode,
) -> CapabilitystatementRest {
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResource {
  CapabilitystatementRestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Resourcetypes,
    profile: Option(String),
    supported_profile: List(String),
    documentation: Option(String),
    interaction: List(CapabilitystatementRestResourceInteraction),
    versioning: Option(r4valuesets.Versioningpolicy),
    read_history: Option(Bool),
    update_create: Option(Bool),
    conditional_create: Option(Bool),
    conditional_read: Option(r4valuesets.Conditionalreadstatus),
    conditional_update: Option(Bool),
    conditional_delete: Option(r4valuesets.Conditionaldeletestatus),
    reference_policy: List(r4valuesets.Referencehandlingpolicy),
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(CapabilitystatementRestResourceSearchparam),
    operation: List(CapabilitystatementRestResourceOperation),
  )
}

pub fn capabilitystatement_rest_resource_new(
  type_ type_: r4valuesets.Resourcetypes,
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Typerestfulinteraction,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_resource_interaction_new(
  code code: r4valuesets.Typerestfulinteraction,
) -> CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    documentation: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceSearchparam {
  CapabilitystatementRestResourceSearchparam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    definition: Option(String),
    type_: r4valuesets.Searchparamtype,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_resource_searchparam_new(
  type_ type_: r4valuesets.Searchparamtype,
  name name: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
  definition definition: String,
  name name: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Systemrestfulinteraction,
    documentation: Option(String),
  )
}

pub fn capabilitystatement_rest_interaction_new(
  code code: r4valuesets.Systemrestfulinteraction,
) -> CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    documentation: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
  address address: String,
  protocol protocol: Coding,
) -> CapabilitystatementMessagingEndpoint {
  CapabilitystatementMessagingEndpoint(
    address:,
    protocol:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4valuesets.Eventcapabilitymode,
    definition: String,
  )
}

pub fn capabilitystatement_messaging_supportedmessage_new(
  definition definition: String,
  mode mode: r4valuesets.Eventcapabilitymode,
) -> CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    definition:,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementDocument {
  CapabilitystatementDocument(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4valuesets.Documentmode,
    documentation: Option(String),
    profile: String,
  )
}

pub fn capabilitystatement_document_new(
  profile profile: String,
  mode mode: r4valuesets.Documentmode,
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

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
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
    status: r4valuesets.Requeststatus,
    intent: r4valuesets.Careplanintent,
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

pub fn careplan_new(
  subject subject: Reference,
  intent intent: r4valuesets.Careplanintent,
  status status: r4valuesets.Requeststatus,
) -> Careplan {
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

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetail {
  CareplanActivityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: Option(r4valuesets.Careplanactivitykind),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    code: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    goal: List(Reference),
    status: r4valuesets.Careplanactivitystatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetailScheduled {
  CareplanActivityDetailScheduledTiming(scheduled: Timing)
  CareplanActivityDetailScheduledPeriod(scheduled: Period)
  CareplanActivityDetailScheduledString(scheduled: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetailProduct {
  CareplanActivityDetailProductCodeableconcept(product: Codeableconcept)
  CareplanActivityDetailProductReference(product: Reference)
}

pub fn careplan_activity_detail_new(
  status status: r4valuesets.Careplanactivitystatus,
) -> CareplanActivityDetail {
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

///http://hl7.org/fhir/r4/StructureDefinition/CareTeam#resource
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
    status: Option(r4valuesets.Careteamstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/CareTeam#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CatalogEntry#resource
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
    status: Option(r4valuesets.Publicationstatus),
    validity_period: Option(Period),
    valid_to: Option(String),
    last_updated: Option(String),
    additional_characteristic: List(Codeableconcept),
    additional_classification: List(Codeableconcept),
    related_entry: List(CatalogentryRelatedentry),
  )
}

pub fn catalogentry_new(
  referenced_item referenced_item: Reference,
  orderable orderable: Bool,
) -> Catalogentry {
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

///http://hl7.org/fhir/r4/StructureDefinition/CatalogEntry#resource
pub type CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationtype: r4valuesets.Relationtype,
    item: Reference,
  )
}

pub fn catalogentry_relatedentry_new(
  item item: Reference,
  relationtype relationtype: r4valuesets.Relationtype,
) -> CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    item:,
    relationtype:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItem#resource
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
    status: r4valuesets.Chargeitemstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItem#resource
pub type ChargeitemOccurrence {
  ChargeitemOccurrenceDatetime(occurrence: String)
  ChargeitemOccurrencePeriod(occurrence: Period)
  ChargeitemOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItem#resource
pub type ChargeitemProduct {
  ChargeitemProductReference(product: Reference)
  ChargeitemProductCodeableconcept(product: Codeableconcept)
}

pub fn chargeitem_new(
  subject subject: Reference,
  code code: Codeableconcept,
  status status: r4valuesets.Chargeitemstatus,
) -> Chargeitem {
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItem#resource
pub type ChargeitemPerformer {
  ChargeitemPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn chargeitem_performer_new(actor actor: Reference) -> ChargeitemPerformer {
  ChargeitemPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItemDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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

pub fn chargeitemdefinition_new(
  status status: r4valuesets.Publicationstatus,
  url url: String,
) -> Chargeitemdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItemDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItemDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionPropertygroupPricecomponent {
  ChargeitemdefinitionPropertygroupPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Invoicepricecomponenttype,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

pub fn chargeitemdefinition_propertygroup_pricecomponent_new(
  type_ type_: r4valuesets.Invoicepricecomponenttype,
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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
    status: r4valuesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4valuesets.Claimuse,
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
  priority priority: Codeableconcept,
  provider provider: Reference,
  created created: String,
  patient patient: Reference,
  use_ use_: r4valuesets.Claimuse,
  type_ type_: Codeableconcept,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimPayee {
  ClaimPayee(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    party: Option(Reference),
  )
}

pub fn claim_payee_new(type_ type_: Codeableconcept) -> ClaimPayee {
  ClaimPayee(
    party: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

pub fn claim_careteam_new(
  provider provider: Reference,
  sequence sequence: Int,
) -> ClaimCareteam {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoTiming {
  ClaimSupportinginfoTimingDate(timing: String)
  ClaimSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimSupportinginfoValue {
  ClaimSupportinginfoValueBoolean(value: Bool)
  ClaimSupportinginfoValueString(value: String)
  ClaimSupportinginfoValueQuantity(value: Quantity)
  ClaimSupportinginfoValueAttachment(value: Attachment)
  ClaimSupportinginfoValueReference(value: Reference)
}

pub fn claim_supportinginfo_new(
  category category: Codeableconcept,
  sequence sequence: Int,
) -> ClaimSupportinginfo {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimDiagnosisDiagnosis {
  ClaimDiagnosisDiagnosisCodeableconcept(diagnosis: Codeableconcept)
  ClaimDiagnosisDiagnosisReference(diagnosis: Reference)
}

pub fn claim_diagnosis_new(
  diagnosis diagnosis: ClaimDiagnosisDiagnosis,
  sequence sequence: Int,
) -> ClaimDiagnosis {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimProcedureProcedure {
  ClaimProcedureProcedureCodeableconcept(procedure: Codeableconcept)
  ClaimProcedureProcedureReference(procedure: Reference)
}

pub fn claim_procedure_new(
  procedure procedure: ClaimProcedureProcedure,
  sequence sequence: Int,
) -> ClaimProcedure {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

pub fn claim_insurance_new(
  coverage coverage: Reference,
  focal focal: Bool,
  sequence sequence: Int,
) -> ClaimInsurance {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimAccidentLocation {
  ClaimAccidentLocationAddress(location: Address)
  ClaimAccidentLocationReference(location: Reference)
}

pub fn claim_accident_new(date date: String) -> ClaimAccident {
  ClaimAccident(
    location: None,
    type_: None,
    date:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimItemServiced {
  ClaimItemServicedDate(serviced: String)
  ClaimItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
pub type ClaimItemLocation {
  ClaimItemLocationCodeableconcept(location: Codeableconcept)
  ClaimItemLocationAddress(location: Address)
  ClaimItemLocationReference(location: Reference)
}

pub fn claim_item_new(
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
) -> ClaimItem {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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

pub fn claim_item_detail_new(
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
) -> ClaimItemDetail {
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

///http://hl7.org/fhir/r4/StructureDefinition/Claim#resource
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
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
    status: r4valuesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4valuesets.Claimuse,
    patient: Reference,
    created: String,
    insurer: Reference,
    requestor: Option(Reference),
    request: Option(Reference),
    outcome: r4valuesets.Remittanceoutcome,
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
  outcome outcome: r4valuesets.Remittanceoutcome,
  insurer insurer: Reference,
  created created: String,
  patient patient: Reference,
  use_ use_: r4valuesets.Claimuse,
  type_ type_: Codeableconcept,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_item_new(
  item_sequence item_sequence: Int,
) -> ClaimresponseItem {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
  category category: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_item_detail_new(
  detail_sequence detail_sequence: Int,
) -> ClaimresponseItemDetail {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
  sub_detail_sequence sub_detail_sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemServiced {
  ClaimresponseAdditemServicedDate(serviced: String)
  ClaimresponseAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseAdditemLocation {
  ClaimresponseAdditemLocationCodeableconcept(location: Codeableconcept)
  ClaimresponseAdditemLocationAddress(location: Address)
  ClaimresponseAdditemLocationReference(location: Reference)
}

pub fn claimresponse_additem_new(
  product_or_service product_or_service: Codeableconcept,
) -> ClaimresponseAdditem {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
  product_or_service product_or_service: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
  product_or_service product_or_service: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseTotal {
  ClaimresponseTotal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Codeableconcept,
    amount: Money,
  )
}

pub fn claimresponse_total_new(
  amount amount: Money,
  category category: Codeableconcept,
) -> ClaimresponseTotal {
  ClaimresponseTotal(
    amount:,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_payment_new(
  amount amount: Money,
  type_ type_: Codeableconcept,
) -> ClaimresponsePayment {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseProcessnote {
  ClaimresponseProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(r4valuesets.Notetype),
    text: String,
    language: Option(Codeableconcept),
  )
}

pub fn claimresponse_processnote_new(
  text text: String,
) -> ClaimresponseProcessnote {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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
  coverage coverage: Reference,
  focal focal: Bool,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
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

pub fn claimresponse_error_new(code code: Codeableconcept) -> ClaimresponseError {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
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
    status: r4valuesets.Clinicalimpressionstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
pub type ClinicalimpressionEffective {
  ClinicalimpressionEffectiveDatetime(effective: String)
  ClinicalimpressionEffectivePeriod(effective: Period)
}

pub fn clinicalimpression_new(
  subject subject: Reference,
  status status: r4valuesets.Clinicalimpressionstatus,
) -> Clinicalimpression {
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

///http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
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
  code code: Codeableconcept,
) -> ClinicalimpressionInvestigation {
  ClinicalimpressionInvestigation(
    item: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ClinicalImpression#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
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
    status: r4valuesets.Publicationstatus,
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
    hierarchy_meaning: Option(r4valuesets.Codesystemhierarchymeaning),
    compositional: Option(Bool),
    version_needed: Option(Bool),
    content: r4valuesets.Codesystemcontentmode,
    supplements: Option(String),
    count: Option(Int),
    filter: List(CodesystemFilter),
    property: List(CodesystemProperty),
    concept: List(CodesystemConcept),
  )
}

pub fn codesystem_new(
  content content: r4valuesets.Codesystemcontentmode,
  status status: r4valuesets.Publicationstatus,
) -> Codesystem {
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
pub type CodesystemFilter {
  CodesystemFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    description: Option(String),
    operator: List(r4valuesets.Filteroperator),
    value: String,
  )
}

pub fn codesystem_filter_new(
  value value: String,
  code code: String,
) -> CodesystemFilter {
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
pub type CodesystemProperty {
  CodesystemProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: r4valuesets.Conceptpropertytype,
  )
}

pub fn codesystem_property_new(
  type_ type_: r4valuesets.Conceptpropertytype,
  code code: String,
) -> CodesystemProperty {
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
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

pub fn codesystem_concept_new(code code: String) -> CodesystemConcept {
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
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

pub fn codesystem_concept_designation_new(
  value value: String,
) -> CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    value:,
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptProperty {
  CodesystemConceptProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: CodesystemConceptPropertyValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
pub type CodesystemConceptPropertyValue {
  CodesystemConceptPropertyValueCode(value: String)
  CodesystemConceptPropertyValueCoding(value: Coding)
  CodesystemConceptPropertyValueString(value: String)
  CodesystemConceptPropertyValueInteger(value: Int)
  CodesystemConceptPropertyValueBoolean(value: Bool)
  CodesystemConceptPropertyValueDatetime(value: String)
  CodesystemConceptPropertyValueDecimal(value: Float)
}

pub fn codesystem_concept_property_new(
  value value: CodesystemConceptPropertyValue,
  code code: String,
) -> CodesystemConceptProperty {
  CodesystemConceptProperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Communication#resource
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
    status: r4valuesets.Eventstatus,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(r4valuesets.Requestpriority),
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

pub fn communication_new(
  status status: r4valuesets.Eventstatus,
) -> Communication {
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

///http://hl7.org/fhir/r4/StructureDefinition/Communication#resource
pub type CommunicationPayload {
  CommunicationPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationPayloadContent,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Communication#resource
pub type CommunicationPayloadContent {
  CommunicationPayloadContentString(content: String)
  CommunicationPayloadContentAttachment(content: Attachment)
  CommunicationPayloadContentReference(content: Reference)
}

pub fn communication_payload_new(
  content content: CommunicationPayloadContent,
) -> CommunicationPayload {
  CommunicationPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CommunicationRequest#resource
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
    status: r4valuesets.Requeststatus,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestOccurrence {
  CommunicationrequestOccurrenceDatetime(occurrence: String)
  CommunicationrequestOccurrencePeriod(occurrence: Period)
}

pub fn communicationrequest_new(
  status status: r4valuesets.Requeststatus,
) -> Communicationrequest {
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

///http://hl7.org/fhir/r4/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayload {
  CommunicationrequestPayload(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: CommunicationrequestPayloadContent,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CommunicationRequest#resource
pub type CommunicationrequestPayloadContent {
  CommunicationrequestPayloadContentString(content: String)
  CommunicationrequestPayloadContentAttachment(content: Attachment)
  CommunicationrequestPayloadContentReference(content: Reference)
}

pub fn communicationrequest_payload_new(
  content content: CommunicationrequestPayloadContent,
) -> CommunicationrequestPayload {
  CommunicationrequestPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CompartmentDefinition#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    purpose: Option(String),
    code: r4valuesets.Compartmenttype,
    search: Bool,
    resource: List(CompartmentdefinitionResource),
  )
}

pub fn compartmentdefinition_new(
  search search: Bool,
  code code: r4valuesets.Compartmenttype,
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Resourcetypes,
    param: List(String),
    documentation: Option(String),
  )
}

pub fn compartmentdefinition_resource_new(
  code code: r4valuesets.Resourcetypes,
) -> CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    documentation: None,
    param: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
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
    status: r4valuesets.Compositionstatus,
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

pub fn composition_new(
  title title: String,
  date date: String,
  type_ type_: Codeableconcept,
  status status: r4valuesets.Compositionstatus,
) -> Composition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionAttester {
  CompositionAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4valuesets.Compositionattestationmode,
    time: Option(String),
    party: Option(Reference),
  )
}

pub fn composition_attester_new(
  mode mode: r4valuesets.Compositionattestationmode,
) -> CompositionAttester {
  CompositionAttester(
    party: None,
    time: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionRelatesto {
  CompositionRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Documentrelationshiptype,
    target: CompositionRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionRelatestoTarget {
  CompositionRelatestoTargetIdentifier(target: Identifier)
  CompositionRelatestoTargetReference(target: Reference)
}

pub fn composition_relatesto_new(
  target target: CompositionRelatestoTarget,
  code code: r4valuesets.Documentrelationshiptype,
) -> CompositionRelatesto {
  CompositionRelatesto(
    target:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
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
    mode: Option(r4valuesets.Listmode),
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapSource {
  ConceptmapSourceUri(source: String)
  ConceptmapSourceCanonical(source: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapTarget {
  ConceptmapTargetUri(target: String)
  ConceptmapTargetCanonical(target: String)
}

pub fn conceptmap_new(
  status status: r4valuesets.Publicationstatus,
) -> Conceptmap {
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    equivalence: r4valuesets.Conceptmapequivalence,
    comment: Option(String),
    depends_on: List(ConceptmapGroupElementTargetDependson),
    product: List(Nil),
  )
}

pub fn conceptmap_group_element_target_new(
  equivalence equivalence: r4valuesets.Conceptmapequivalence,
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
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
  value value: String,
  property property: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r4valuesets.Conceptmapunmappedmode,
    code: Option(String),
    display: Option(String),
    url: Option(String),
  )
}

pub fn conceptmap_group_unmapped_new(
  mode mode: r4valuesets.Conceptmapunmappedmode,
) -> ConceptmapGroupUnmapped {
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

///http://hl7.org/fhir/r4/StructureDefinition/Condition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Condition#resource
pub type ConditionOnset {
  ConditionOnsetDatetime(onset: String)
  ConditionOnsetAge(onset: Age)
  ConditionOnsetPeriod(onset: Period)
  ConditionOnsetRange(onset: Range)
  ConditionOnsetString(onset: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/Condition#resource
pub type ConditionAbatement {
  ConditionAbatementDatetime(abatement: String)
  ConditionAbatementAge(abatement: Age)
  ConditionAbatementPeriod(abatement: Period)
  ConditionAbatementRange(abatement: Range)
  ConditionAbatementString(abatement: String)
}

pub fn condition_new(subject subject: Reference) -> Condition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Condition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Condition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
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
    status: r4valuesets.Consentstatecodes,
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentSource {
  ConsentSourceAttachment(source: Attachment)
  ConsentSourceReference(source: Reference)
}

pub fn consent_new(
  scope scope: Codeableconcept,
  status status: r4valuesets.Consentstatecodes,
) -> Consent {
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
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

pub fn consent_verification_new(verified verified: Bool) -> ConsentVerification {
  ConsentVerification(
    verification_date: None,
    verified_with: None,
    verified:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvision {
  ConsentProvision(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4valuesets.Consentprovisiontype),
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvisionActor {
  ConsentProvisionActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Codeableconcept,
    reference: Reference,
  )
}

pub fn consent_provision_actor_new(
  reference reference: Reference,
  role role: Codeableconcept,
) -> ConsentProvisionActor {
  ConsentProvisionActor(
    reference:,
    role:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: r4valuesets.Consentdatameaning,
    reference: Reference,
  )
}

pub fn consent_provision_data_new(
  reference reference: Reference,
  meaning meaning: r4valuesets.Consentdatameaning,
) -> ConsentProvisionData {
  ConsentProvisionData(
    reference:,
    meaning:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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
    status: Option(r4valuesets.Contractstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractTopic {
  ContractTopicCodeableconcept(topic: Codeableconcept)
  ContractTopicReference(topic: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractContentdefinition {
  ContractContentdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    publisher: Option(Reference),
    publication_date: Option(String),
    publication_status: r4valuesets.Contractpublicationstatus,
    copyright: Option(String),
  )
}

pub fn contract_contentdefinition_new(
  publication_status publication_status: r4valuesets.Contractpublicationstatus,
  type_ type_: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractTermTopic {
  ContractTermTopicCodeableconcept(topic: Codeableconcept)
  ContractTermTopicReference(topic: Reference)
}

pub fn contract_term_new(offer offer: ContractTermOffer) -> ContractTerm {
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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
  classification classification: Coding,
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractTermOfferParty {
  ContractTermOfferParty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: List(Reference),
    role: Codeableconcept,
  )
}

pub fn contract_term_offer_party_new(
  role role: Codeableconcept,
) -> ContractTermOfferParty {
  ContractTermOfferParty(
    role:,
    reference: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: ContractTermOfferAnswerValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

pub fn contract_term_offer_answer_new(
  value value: ContractTermOfferAnswerValue,
) -> ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractTermActionOccurrence {
  ContractTermActionOccurrenceDatetime(occurrence: String)
  ContractTermActionOccurrencePeriod(occurrence: Period)
  ContractTermActionOccurrenceTiming(occurrence: Timing)
}

pub fn contract_term_action_new(
  status status: Codeableconcept,
  intent intent: Codeableconcept,
  type_ type_: Codeableconcept,
) -> ContractTermAction {
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
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

pub fn contract_signer_new(
  party party: Reference,
  type_ type_: Coding,
) -> ContractSigner {
  ContractSigner(
    signature: [],
    party:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractFriendly {
  ContractFriendly(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractFriendlyContent,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractFriendlyContent {
  ContractFriendlyContentAttachment(content: Attachment)
  ContractFriendlyContentReference(content: Reference)
}

pub fn contract_friendly_new(
  content content: ContractFriendlyContent,
) -> ContractFriendly {
  ContractFriendly(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractLegal {
  ContractLegal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractLegalContent,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractLegalContent {
  ContractLegalContentAttachment(content: Attachment)
  ContractLegalContentReference(content: Reference)
}

pub fn contract_legal_new(
  content content: ContractLegalContent,
) -> ContractLegal {
  ContractLegal(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractRule {
  ContractRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    content: ContractRuleContent,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Contract#resource
pub type ContractRuleContent {
  ContractRuleContentAttachment(content: Attachment)
  ContractRuleContentReference(content: Reference)
}

pub fn contract_rule_new(content content: ContractRuleContent) -> ContractRule {
  ContractRule(content:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Coverage#resource
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
    status: r4valuesets.Fmstatus,
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

pub fn coverage_new(
  beneficiary beneficiary: Reference,
  status status: r4valuesets.Fmstatus,
) -> Coverage {
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

///http://hl7.org/fhir/r4/StructureDefinition/Coverage#resource
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

pub fn coverage_class_new(
  value value: String,
  type_ type_: Codeableconcept,
) -> CoverageClass {
  CoverageClass(
    name: None,
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Coverage#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Coverage#resource
pub type CoverageCosttobeneficiaryValue {
  CoverageCosttobeneficiaryValueQuantity(value: Quantity)
  CoverageCosttobeneficiaryValueMoney(value: Money)
}

pub fn coverage_costtobeneficiary_new(
  value value: CoverageCosttobeneficiaryValue,
) -> CoverageCosttobeneficiary {
  CoverageCosttobeneficiary(
    exception: [],
    value:,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Coverage#resource
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
  type_ type_: Codeableconcept,
) -> CoverageCosttobeneficiaryException {
  CoverageCosttobeneficiaryException(
    period: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
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
    status: r4valuesets.Fmstatus,
    priority: Option(Codeableconcept),
    purpose: List(r4valuesets.Eligibilityrequestpurpose),
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestServiced {
  CoverageeligibilityrequestServicedDate(serviced: String)
  CoverageeligibilityrequestServicedPeriod(serviced: Period)
}

pub fn coverageeligibilityrequest_new(
  insurer insurer: Reference,
  created created: String,
  patient patient: Reference,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
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
  information information: Reference,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
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
  coverage coverage: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
pub type CoverageeligibilityrequestItemDiagnosis {
  CoverageeligibilityrequestItemDiagnosis(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    diagnosis: Option(CoverageeligibilityrequestItemDiagnosisDiagnosis),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
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
    status: r4valuesets.Fmstatus,
    purpose: List(r4valuesets.Eligibilityresponsepurpose),
    patient: Reference,
    serviced: Option(CoverageeligibilityresponseServiced),
    created: String,
    requestor: Option(Reference),
    request: Reference,
    outcome: r4valuesets.Remittanceoutcome,
    disposition: Option(String),
    insurer: Reference,
    insurance: List(CoverageeligibilityresponseInsurance),
    pre_auth_ref: Option(String),
    form: Option(Codeableconcept),
    error: List(CoverageeligibilityresponseError),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseServiced {
  CoverageeligibilityresponseServicedDate(serviced: String)
  CoverageeligibilityresponseServicedPeriod(serviced: Period)
}

pub fn coverageeligibilityresponse_new(
  insurer insurer: Reference,
  outcome outcome: r4valuesets.Remittanceoutcome,
  request request: Reference,
  created created: String,
  patient patient: Reference,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
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
  coverage coverage: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitAllowed {
  CoverageeligibilityresponseInsuranceItemBenefitAllowedUnsignedint(
    allowed: Int,
  )
  CoverageeligibilityresponseInsuranceItemBenefitAllowedString(allowed: String)
  CoverageeligibilityresponseInsuranceItemBenefitAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseInsuranceItemBenefitUsed {
  CoverageeligibilityresponseInsuranceItemBenefitUsedUnsignedint(used: Int)
  CoverageeligibilityresponseInsuranceItemBenefitUsedString(used: String)
  CoverageeligibilityresponseInsuranceItemBenefitUsedMoney(used: Money)
}

pub fn coverageeligibilityresponse_insurance_item_benefit_new(
  type_ type_: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
  )
}

pub fn coverageeligibilityresponse_error_new(
  code code: Codeableconcept,
) -> CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DetectedIssue#resource
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
    status: r4valuesets.Observationstatus,
    code: Option(Codeableconcept),
    severity: Option(r4valuesets.Detectedissueseverity),
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

///http://hl7.org/fhir/r4/StructureDefinition/DetectedIssue#resource
pub type DetectedissueIdentified {
  DetectedissueIdentifiedDatetime(identified: String)
  DetectedissueIdentifiedPeriod(identified: Period)
}

pub fn detectedissue_new(
  status status: r4valuesets.Observationstatus,
) -> Detectedissue {
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

///http://hl7.org/fhir/r4/StructureDefinition/DetectedIssue#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DetectedIssue#resource
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

pub fn detectedissue_mitigation_new(
  action action: Codeableconcept,
) -> DetectedissueMitigation {
  DetectedissueMitigation(
    author: None,
    date: None,
    action:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
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
    status: Option(r4valuesets.Devicestatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
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
    entry_type: Option(r4valuesets.Udientrytype),
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

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceDevicename {
  DeviceDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: r4valuesets.Devicenametype,
  )
}

pub fn device_devicename_new(
  type_ type_: r4valuesets.Devicenametype,
  name name: String,
) -> DeviceDevicename {
  DeviceDevicename(
    type_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceSpecialization {
  DeviceSpecialization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    system_type: Codeableconcept,
    version: Option(String),
  )
}

pub fn device_specialization_new(
  system_type system_type: Codeableconcept,
) -> DeviceSpecialization {
  DeviceSpecialization(
    version: None,
    system_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
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

pub fn device_version_new(value value: String) -> DeviceVersion {
  DeviceVersion(
    value:,
    component: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
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

pub fn device_property_new(type_ type_: Codeableconcept) -> DeviceProperty {
  DeviceProperty(
    value_code: [],
    value_quantity: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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
  jurisdiction jurisdiction: String,
  issuer issuer: String,
  device_identifier device_identifier: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: r4valuesets.Devicenametype,
  )
}

pub fn devicedefinition_devicename_new(
  type_ type_: r4valuesets.Devicenametype,
  name name: String,
) -> DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    type_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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
  system_type system_type: String,
) -> DevicedefinitionSpecialization {
  DevicedefinitionSpecialization(
    version: None,
    system_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionCapability {
  DevicedefinitionCapability(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    description: List(Codeableconcept),
  )
}

pub fn devicedefinition_capability_new(
  type_ type_: Codeableconcept,
) -> DevicedefinitionCapability {
  DevicedefinitionCapability(
    description: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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

pub fn devicedefinition_property_new(
  type_ type_: Codeableconcept,
) -> DevicedefinitionProperty {
  DevicedefinitionProperty(
    value_code: [],
    value_quantity: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
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

pub fn devicedefinition_material_new(
  substance substance: Codeableconcept,
) -> DevicedefinitionMaterial {
  DevicedefinitionMaterial(
    allergenic_indicator: None,
    alternate: None,
    substance:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceMetric#resource
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
    operational_status: Option(r4valuesets.Metricoperationalstatus),
    color: Option(r4valuesets.Metriccolor),
    category: r4valuesets.Metriccategory,
    measurement_period: Option(Timing),
    calibration: List(DevicemetricCalibration),
  )
}

pub fn devicemetric_new(
  category category: r4valuesets.Metriccategory,
  type_ type_: Codeableconcept,
) -> Devicemetric {
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceMetric#resource
pub type DevicemetricCalibration {
  DevicemetricCalibration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4valuesets.Metriccalibrationtype),
    state: Option(r4valuesets.Metriccalibrationstate),
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceRequest#resource
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
    status: Option(r4valuesets.Requeststatus),
    intent: r4valuesets.Requestintent,
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceRequest#resource
pub type DevicerequestCode {
  DevicerequestCodeReference(code: Reference)
  DevicerequestCodeCodeableconcept(code: Codeableconcept)
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceRequest#resource
pub type DevicerequestOccurrence {
  DevicerequestOccurrenceDatetime(occurrence: String)
  DevicerequestOccurrencePeriod(occurrence: Period)
  DevicerequestOccurrenceTiming(occurrence: Timing)
}

pub fn devicerequest_new(
  subject subject: Reference,
  code code: DevicerequestCode,
  intent intent: r4valuesets.Requestintent,
) -> Devicerequest {
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceRequest#resource
pub type DevicerequestParameter {
  DevicerequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(DevicerequestParameterValue),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceUseStatement#resource
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
    status: r4valuesets.Devicestatementstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceUseStatement#resource
pub type DeviceusestatementTiming {
  DeviceusestatementTimingTiming(timing: Timing)
  DeviceusestatementTimingPeriod(timing: Period)
  DeviceusestatementTimingDatetime(timing: String)
}

pub fn deviceusestatement_new(
  device device: Reference,
  subject subject: Reference,
  status status: r4valuesets.Devicestatementstatus,
) -> Deviceusestatement {
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

///http://hl7.org/fhir/r4/StructureDefinition/DiagnosticReport#resource
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
    status: r4valuesets.Diagnosticreportstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportEffective {
  DiagnosticreportEffectiveDatetime(effective: String)
  DiagnosticreportEffectivePeriod(effective: Period)
}

pub fn diagnosticreport_new(
  code code: Codeableconcept,
  status status: r4valuesets.Diagnosticreportstatus,
) -> Diagnosticreport {
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

///http://hl7.org/fhir/r4/StructureDefinition/DiagnosticReport#resource
pub type DiagnosticreportMedia {
  DiagnosticreportMedia(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    comment: Option(String),
    link: Reference,
  )
}

pub fn diagnosticreport_media_new(link link: Reference) -> DiagnosticreportMedia {
  DiagnosticreportMedia(
    link:,
    comment: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DocumentManifest#resource
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
    status: r4valuesets.Documentreferencestatus,
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

pub fn documentmanifest_new(
  status status: r4valuesets.Documentreferencestatus,
) -> Documentmanifest {
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

///http://hl7.org/fhir/r4/StructureDefinition/DocumentManifest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
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
    status: r4valuesets.Documentreferencestatus,
    doc_status: Option(r4valuesets.Compositionstatus),
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

pub fn documentreference_new(
  status status: r4valuesets.Documentreferencestatus,
) -> Documentreference {
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

///http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Documentrelationshiptype,
    target: Reference,
  )
}

pub fn documentreference_relatesto_new(
  target target: Reference,
  code code: r4valuesets.Documentrelationshiptype,
) -> DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    target:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceContent {
  DocumentreferenceContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    attachment: Attachment,
    format: Option(Coding),
  )
}

pub fn documentreference_content_new(
  attachment attachment: Attachment,
) -> DocumentreferenceContent {
  DocumentreferenceContent(
    format: None,
    attachment:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DomainResource#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type Effectevidencesynthesis {
  Effectevidencesynthesis(
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
    status: r4valuesets.Publicationstatus,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
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
    synthesis_type: Option(Codeableconcept),
    study_type: Option(Codeableconcept),
    population: Reference,
    exposure: Reference,
    exposure_alternative: Reference,
    outcome: Reference,
    sample_size: Option(EffectevidencesynthesisSamplesize),
    results_by_exposure: List(EffectevidencesynthesisResultsbyexposure),
    effect_estimate: List(EffectevidencesynthesisEffectestimate),
    certainty: List(EffectevidencesynthesisCertainty),
  )
}

pub fn effectevidencesynthesis_new(
  outcome outcome: Reference,
  exposure_alternative exposure_alternative: Reference,
  exposure exposure: Reference,
  population population: Reference,
  status status: r4valuesets.Publicationstatus,
) -> Effectevidencesynthesis {
  Effectevidencesynthesis(
    certainty: [],
    effect_estimate: [],
    results_by_exposure: [],
    sample_size: None,
    outcome:,
    exposure_alternative:,
    exposure:,
    population:,
    study_type: None,
    synthesis_type: None,
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
    jurisdiction: [],
    use_context: [],
    note: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisSamplesize {
  EffectevidencesynthesisSamplesize(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    number_of_studies: Option(Int),
    number_of_participants: Option(Int),
  )
}

pub fn effectevidencesynthesis_samplesize_new() -> EffectevidencesynthesisSamplesize {
  EffectevidencesynthesisSamplesize(
    number_of_participants: None,
    number_of_studies: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisResultsbyexposure {
  EffectevidencesynthesisResultsbyexposure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    exposure_state: Option(r4valuesets.Exposurestate),
    variant_state: Option(Codeableconcept),
    risk_evidence_synthesis: Reference,
  )
}

pub fn effectevidencesynthesis_resultsbyexposure_new(
  risk_evidence_synthesis risk_evidence_synthesis: Reference,
) -> EffectevidencesynthesisResultsbyexposure {
  EffectevidencesynthesisResultsbyexposure(
    risk_evidence_synthesis:,
    variant_state: None,
    exposure_state: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisEffectestimate {
  EffectevidencesynthesisEffectestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    type_: Option(Codeableconcept),
    variant_state: Option(Codeableconcept),
    value: Option(Float),
    unit_of_measure: Option(Codeableconcept),
    precision_estimate: List(
      EffectevidencesynthesisEffectestimatePrecisionestimate,
    ),
  )
}

pub fn effectevidencesynthesis_effectestimate_new() -> EffectevidencesynthesisEffectestimate {
  EffectevidencesynthesisEffectestimate(
    precision_estimate: [],
    unit_of_measure: None,
    value: None,
    variant_state: None,
    type_: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisEffectestimatePrecisionestimate {
  EffectevidencesynthesisEffectestimatePrecisionestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    level: Option(Float),
    from: Option(Float),
    to: Option(Float),
  )
}

pub fn effectevidencesynthesis_effectestimate_precisionestimate_new() -> EffectevidencesynthesisEffectestimatePrecisionestimate {
  EffectevidencesynthesisEffectestimatePrecisionestimate(
    to: None,
    from: None,
    level: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisCertainty {
  EffectevidencesynthesisCertainty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    rating: List(Codeableconcept),
    note: List(Annotation),
    certainty_subcomponent: List(
      EffectevidencesynthesisCertaintyCertaintysubcomponent,
    ),
  )
}

pub fn effectevidencesynthesis_certainty_new() -> EffectevidencesynthesisCertainty {
  EffectevidencesynthesisCertainty(
    certainty_subcomponent: [],
    note: [],
    rating: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisCertaintyCertaintysubcomponent {
  EffectevidencesynthesisCertaintyCertaintysubcomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    rating: List(Codeableconcept),
    note: List(Annotation),
  )
}

pub fn effectevidencesynthesis_certainty_certaintysubcomponent_new() -> EffectevidencesynthesisCertaintyCertaintysubcomponent {
  EffectevidencesynthesisCertaintyCertaintysubcomponent(
    note: [],
    rating: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
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
    status: r4valuesets.Encounterstatus,
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

pub fn encounter_new(
  class class: Coding,
  status status: r4valuesets.Encounterstatus,
) -> Encounter {
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

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterStatushistory {
  EncounterStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: r4valuesets.Encounterstatus,
    period: Period,
  )
}

pub fn encounter_statushistory_new(
  period period: Period,
  status status: r4valuesets.Encounterstatus,
) -> EncounterStatushistory {
  EncounterStatushistory(
    period:,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterClasshistory {
  EncounterClasshistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    class: Coding,
    period: Period,
  )
}

pub fn encounter_classhistory_new(
  period period: Period,
  class class: Coding,
) -> EncounterClasshistory {
  EncounterClasshistory(
    period:,
    class:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
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

pub fn encounter_diagnosis_new(
  condition condition: Reference,
) -> EncounterDiagnosis {
  EncounterDiagnosis(
    rank: None,
    use_: None,
    condition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(r4valuesets.Encounterlocationstatus),
    physical_type: Option(Codeableconcept),
    period: Option(Period),
  )
}

pub fn encounter_location_new(location location: Reference) -> EncounterLocation {
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

///http://hl7.org/fhir/r4/StructureDefinition/Endpoint#resource
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
    status: r4valuesets.Endpointstatus,
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

pub fn endpoint_new(
  address address: String,
  connection_type connection_type: Coding,
  status status: r4valuesets.Endpointstatus,
) -> Endpoint {
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

///http://hl7.org/fhir/r4/StructureDefinition/EnrollmentRequest#resource
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
    status: Option(r4valuesets.Fmstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/EnrollmentResponse#resource
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
    status: Option(r4valuesets.Fmstatus),
    request: Option(Reference),
    outcome: Option(r4valuesets.Remittanceoutcome),
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

///http://hl7.org/fhir/r4/StructureDefinition/EpisodeOfCare#resource
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
    status: r4valuesets.Episodeofcarestatus,
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

pub fn episodeofcare_new(
  patient patient: Reference,
  status status: r4valuesets.Episodeofcarestatus,
) -> Episodeofcare {
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

///http://hl7.org/fhir/r4/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: r4valuesets.Episodeofcarestatus,
    period: Period,
  )
}

pub fn episodeofcare_statushistory_new(
  period period: Period,
  status status: r4valuesets.Episodeofcarestatus,
) -> EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    period:,
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EpisodeOfCare#resource
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

pub fn episodeofcare_diagnosis_new(
  condition condition: Reference,
) -> EpisodeofcareDiagnosis {
  EpisodeofcareDiagnosis(
    rank: None,
    role: None,
    condition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EventDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/EventDefinition#resource
pub type EventdefinitionSubject {
  EventdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  EventdefinitionSubjectReference(subject: Reference)
}

pub fn eventdefinition_new(
  status status: r4valuesets.Publicationstatus,
) -> Eventdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Evidence#resource
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
    name: Option(String),
    title: Option(String),
    short_title: Option(String),
    subtitle: Option(String),
    status: r4valuesets.Publicationstatus,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
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
    exposure_background: Reference,
    exposure_variant: List(Reference),
    outcome: List(Reference),
  )
}

pub fn evidence_new(
  exposure_background exposure_background: Reference,
  status status: r4valuesets.Publicationstatus,
) -> Evidence {
  Evidence(
    outcome: [],
    exposure_variant: [],
    exposure_background:,
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
    jurisdiction: [],
    use_context: [],
    note: [],
    description: None,
    contact: [],
    publisher: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
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
    status: r4valuesets.Publicationstatus,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
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
    type_: Option(r4valuesets.Variabletype),
    characteristic: List(EvidencevariableCharacteristic),
  )
}

pub fn evidencevariable_new(
  status status: r4valuesets.Publicationstatus,
) -> Evidencevariable {
  Evidencevariable(
    characteristic: [],
    type_: None,
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
    jurisdiction: [],
    use_context: [],
    note: [],
    description: None,
    contact: [],
    publisher: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    definition: EvidencevariableCharacteristicDefinition,
    usage_context: List(Usagecontext),
    exclude: Option(Bool),
    participant_effective: Option(
      EvidencevariableCharacteristicParticipanteffective,
    ),
    time_from_start: Option(Duration),
    group_measure: Option(r4valuesets.Groupmeasure),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinition {
  EvidencevariableCharacteristicDefinitionReference(definition: Reference)
  EvidencevariableCharacteristicDefinitionCanonical(definition: String)
  EvidencevariableCharacteristicDefinitionCodeableconcept(
    definition: Codeableconcept,
  )
  EvidencevariableCharacteristicDefinitionExpression(definition: Expression)
  EvidencevariableCharacteristicDefinitionDatarequirement(
    definition: Datarequirement,
  )
  EvidencevariableCharacteristicDefinitionTriggerdefinition(
    definition: Triggerdefinition,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicParticipanteffective {
  EvidencevariableCharacteristicParticipanteffectiveDatetime(
    participant_effective: String,
  )
  EvidencevariableCharacteristicParticipanteffectivePeriod(
    participant_effective: Period,
  )
  EvidencevariableCharacteristicParticipanteffectiveDuration(
    participant_effective: Duration,
  )
  EvidencevariableCharacteristicParticipanteffectiveTiming(
    participant_effective: Timing,
  )
}

pub fn evidencevariable_characteristic_new(
  definition definition: EvidencevariableCharacteristicDefinition,
) -> EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    group_measure: None,
    time_from_start: None,
    participant_effective: None,
    exclude: None,
    usage_context: [],
    definition:,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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
    status: r4valuesets.Publicationstatus,
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

pub fn examplescenario_new(
  status status: r4valuesets.Publicationstatus,
) -> Examplescenario {
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioActor {
  ExamplescenarioActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor_id: String,
    type_: r4valuesets.Examplescenarioactortype,
    name: Option(String),
    description: Option(String),
  )
}

pub fn examplescenario_actor_new(
  type_ type_: r4valuesets.Examplescenarioactortype,
  actor_id actor_id: String,
) -> ExamplescenarioActor {
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstance {
  ExamplescenarioInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_id: String,
    resource_type: r4valuesets.Resourcetypes,
    name: Option(String),
    description: Option(String),
    version: List(ExamplescenarioInstanceVersion),
    contained_instance: List(ExamplescenarioInstanceContainedinstance),
  )
}

pub fn examplescenario_instance_new(
  resource_type resource_type: r4valuesets.Resourcetypes,
  resource_id resource_id: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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
  description description: String,
  version_id version_id: String,
) -> ExamplescenarioInstanceVersion {
  ExamplescenarioInstanceVersion(
    description:,
    version_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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
  resource_id resource_id: String,
) -> ExamplescenarioInstanceContainedinstance {
  ExamplescenarioInstanceContainedinstance(
    version_id: None,
    resource_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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

pub fn examplescenario_process_new(
  title title: String,
) -> ExamplescenarioProcess {
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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
  number number: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
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
  title title: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
    status: r4valuesets.Explanationofbenefitstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r4valuesets.Claimuse,
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
    outcome: r4valuesets.Remittanceoutcome,
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
  outcome outcome: r4valuesets.Remittanceoutcome,
  provider provider: Reference,
  insurer insurer: Reference,
  created created: String,
  patient patient: Reference,
  use_ use_: r4valuesets.Claimuse,
  type_ type_: Codeableconcept,
  status status: r4valuesets.Explanationofbenefitstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  provider provider: Reference,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoTiming {
  ExplanationofbenefitSupportinginfoTimingDate(timing: String)
  ExplanationofbenefitSupportinginfoTimingPeriod(timing: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitSupportinginfoValue {
  ExplanationofbenefitSupportinginfoValueBoolean(value: Bool)
  ExplanationofbenefitSupportinginfoValueString(value: String)
  ExplanationofbenefitSupportinginfoValueQuantity(value: Quantity)
  ExplanationofbenefitSupportinginfoValueAttachment(value: Attachment)
  ExplanationofbenefitSupportinginfoValueReference(value: Reference)
}

pub fn explanationofbenefit_supportinginfo_new(
  category category: Codeableconcept,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitDiagnosisDiagnosis {
  ExplanationofbenefitDiagnosisDiagnosisCodeableconcept(
    diagnosis: Codeableconcept,
  )
  ExplanationofbenefitDiagnosisDiagnosisReference(diagnosis: Reference)
}

pub fn explanationofbenefit_diagnosis_new(
  diagnosis diagnosis: ExplanationofbenefitDiagnosisDiagnosis,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcedureProcedure {
  ExplanationofbenefitProcedureProcedureCodeableconcept(
    procedure: Codeableconcept,
  )
  ExplanationofbenefitProcedureProcedureReference(procedure: Reference)
}

pub fn explanationofbenefit_procedure_new(
  procedure procedure: ExplanationofbenefitProcedureProcedure,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  coverage coverage: Reference,
  focal focal: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemServiced {
  ExplanationofbenefitItemServicedDate(serviced: String)
  ExplanationofbenefitItemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitItemLocation {
  ExplanationofbenefitItemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitItemLocationAddress(location: Address)
  ExplanationofbenefitItemLocationReference(location: Reference)
}

pub fn explanationofbenefit_item_new(
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  category category: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  product_or_service product_or_service: Codeableconcept,
  sequence sequence: Int,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemServiced {
  ExplanationofbenefitAdditemServicedDate(serviced: String)
  ExplanationofbenefitAdditemServicedPeriod(serviced: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitAdditemLocation {
  ExplanationofbenefitAdditemLocationCodeableconcept(location: Codeableconcept)
  ExplanationofbenefitAdditemLocationAddress(location: Address)
  ExplanationofbenefitAdditemLocationReference(location: Reference)
}

pub fn explanationofbenefit_additem_new(
  product_or_service product_or_service: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  product_or_service product_or_service: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  product_or_service product_or_service: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  amount amount: Money,
  category category: Codeableconcept,
) -> ExplanationofbenefitTotal {
  ExplanationofbenefitTotal(
    amount:,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcessnote {
  ExplanationofbenefitProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(r4valuesets.Notetype),
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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
  category category: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialAllowed {
  ExplanationofbenefitBenefitbalanceFinancialAllowedUnsignedint(allowed: Int)
  ExplanationofbenefitBenefitbalanceFinancialAllowedString(allowed: String)
  ExplanationofbenefitBenefitbalanceFinancialAllowedMoney(allowed: Money)
}

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitBenefitbalanceFinancialUsed {
  ExplanationofbenefitBenefitbalanceFinancialUsedUnsignedint(used: Int)
  ExplanationofbenefitBenefitbalanceFinancialUsedMoney(used: Money)
}

pub fn explanationofbenefit_benefitbalance_financial_new(
  type_ type_: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
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
    status: r4valuesets.Historystatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryBorn {
  FamilymemberhistoryBornPeriod(born: Period)
  FamilymemberhistoryBornDate(born: String)
  FamilymemberhistoryBornString(born: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryAge {
  FamilymemberhistoryAgeAge(age: Age)
  FamilymemberhistoryAgeRange(age: Range)
  FamilymemberhistoryAgeString(age: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryDeceased {
  FamilymemberhistoryDeceasedBoolean(deceased: Bool)
  FamilymemberhistoryDeceasedAge(deceased: Age)
  FamilymemberhistoryDeceasedRange(deceased: Range)
  FamilymemberhistoryDeceasedDate(deceased: String)
  FamilymemberhistoryDeceasedString(deceased: String)
}

pub fn familymemberhistory_new(
  relationship relationship: Codeableconcept,
  patient patient: Reference,
  status status: r4valuesets.Historystatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/FamilyMemberHistory#resource
pub type FamilymemberhistoryConditionOnset {
  FamilymemberhistoryConditionOnsetAge(onset: Age)
  FamilymemberhistoryConditionOnsetRange(onset: Range)
  FamilymemberhistoryConditionOnsetPeriod(onset: Period)
  FamilymemberhistoryConditionOnsetString(onset: String)
}

pub fn familymemberhistory_condition_new(
  code code: Codeableconcept,
) -> FamilymemberhistoryCondition {
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

///http://hl7.org/fhir/r4/StructureDefinition/Flag#resource
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
    status: r4valuesets.Flagstatus,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Reference,
    period: Option(Period),
    encounter: Option(Reference),
    author: Option(Reference),
  )
}

pub fn flag_new(
  subject subject: Reference,
  code code: Codeableconcept,
  status status: r4valuesets.Flagstatus,
) -> Flag {
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

///http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
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
    lifecycle_status: r4valuesets.Goalstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
pub type GoalStart {
  GoalStartDate(start: String)
  GoalStartCodeableconcept(start: Codeableconcept)
}

pub fn goal_new(
  subject subject: Reference,
  description description: Codeableconcept,
  lifecycle_status lifecycle_status: r4valuesets.Goalstatus,
) -> Goal {
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

///http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
pub type GoalTargetDetail {
  GoalTargetDetailQuantity(detail: Quantity)
  GoalTargetDetailRange(detail: Range)
  GoalTargetDetailCodeableconcept(detail: Codeableconcept)
  GoalTargetDetailString(detail: String)
  GoalTargetDetailBoolean(detail: Bool)
  GoalTargetDetailInteger(detail: Int)
  GoalTargetDetailRatio(detail: Ratio)
}

///http://hl7.org/fhir/r4/StructureDefinition/Goal#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    start: r4valuesets.Resourcetypes,
    profile: Option(String),
    link: List(GraphdefinitionLink),
  )
}

pub fn graphdefinition_new(
  start start: r4valuesets.Resourcetypes,
  status status: r4valuesets.Publicationstatus,
  name name: String,
) -> Graphdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTarget {
  GraphdefinitionLinkTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Resourcetypes,
    params: Option(String),
    profile: Option(String),
    compartment: List(GraphdefinitionLinkTargetCompartment),
    link: List(Nil),
  )
}

pub fn graphdefinition_link_target_new(
  type_ type_: r4valuesets.Resourcetypes,
) -> GraphdefinitionLinkTarget {
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

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTargetCompartment {
  GraphdefinitionLinkTargetCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: r4valuesets.Graphcompartmentuse,
    code: r4valuesets.Compartmenttype,
    rule: r4valuesets.Graphcompartmentrule,
    expression: Option(String),
    description: Option(String),
  )
}

pub fn graphdefinition_link_target_compartment_new(
  rule rule: r4valuesets.Graphcompartmentrule,
  code code: r4valuesets.Compartmenttype,
  use_ use_: r4valuesets.Graphcompartmentuse,
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

///http://hl7.org/fhir/r4/StructureDefinition/Group#resource
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
    type_: r4valuesets.Grouptype,
    actual: Bool,
    code: Option(Codeableconcept),
    name: Option(String),
    quantity: Option(Int),
    managing_entity: Option(Reference),
    characteristic: List(GroupCharacteristic),
    member: List(GroupMember),
  )
}

pub fn group_new(
  actual actual: Bool,
  type_ type_: r4valuesets.Grouptype,
) -> Group {
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

///http://hl7.org/fhir/r4/StructureDefinition/Group#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Group#resource
pub type GroupCharacteristicValue {
  GroupCharacteristicValueCodeableconcept(value: Codeableconcept)
  GroupCharacteristicValueBoolean(value: Bool)
  GroupCharacteristicValueQuantity(value: Quantity)
  GroupCharacteristicValueRange(value: Range)
  GroupCharacteristicValueReference(value: Reference)
}

pub fn group_characteristic_new(
  exclude exclude: Bool,
  value value: GroupCharacteristicValue,
  code code: Codeableconcept,
) -> GroupCharacteristic {
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

///http://hl7.org/fhir/r4/StructureDefinition/Group#resource
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

pub fn group_member_new(entity entity: Reference) -> GroupMember {
  GroupMember(
    inactive: None,
    period: None,
    entity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/GuidanceResponse#resource
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
    status: r4valuesets.Guidanceresponsestatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/GuidanceResponse#resource
pub type GuidanceresponseModule {
  GuidanceresponseModuleUri(module: String)
  GuidanceresponseModuleCanonical(module: String)
  GuidanceresponseModuleCodeableconcept(module: Codeableconcept)
}

pub fn guidanceresponse_new(
  status status: r4valuesets.Guidanceresponsestatus,
  module module: GuidanceresponseModule,
) -> Guidanceresponse {
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

///http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceAvailabletime {
  HealthcareserviceAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4valuesets.Daysofweek),
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

///http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
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
  description description: String,
) -> HealthcareserviceNotavailable {
  HealthcareserviceNotavailable(
    during: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImagingStudy#resource
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
    status: r4valuesets.Imagingstudystatus,
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

pub fn imagingstudy_new(
  subject subject: Reference,
  status status: r4valuesets.Imagingstudystatus,
) -> Imagingstudy {
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

///http://hl7.org/fhir/r4/StructureDefinition/ImagingStudy#resource
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

pub fn imagingstudy_series_new(
  modality modality: Coding,
  uid uid: String,
) -> ImagingstudySeries {
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

///http://hl7.org/fhir/r4/StructureDefinition/ImagingStudy#resource
pub type ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn imagingstudy_series_performer_new(
  actor actor: Reference,
) -> ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImagingStudy#resource
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
  sop_class sop_class: Coding,
  uid uid: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
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
    status: r4valuesets.Immunizationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationOccurrence {
  ImmunizationOccurrenceDatetime(occurrence: String)
  ImmunizationOccurrenceString(occurrence: String)
}

pub fn immunization_new(
  occurrence occurrence: ImmunizationOccurrence,
  patient patient: Reference,
  vaccine_code vaccine_code: Codeableconcept,
  status status: r4valuesets.Immunizationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationPerformer {
  ImmunizationPerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn immunization_performer_new(
  actor actor: Reference,
) -> ImmunizationPerformer {
  ImmunizationPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolappliedDosenumber {
  ImmunizationProtocolappliedDosenumberPositiveint(dose_number: Int)
  ImmunizationProtocolappliedDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/Immunization#resource
pub type ImmunizationProtocolappliedSeriesdoses {
  ImmunizationProtocolappliedSeriesdosesPositiveint(series_doses: Int)
  ImmunizationProtocolappliedSeriesdosesString(series_doses: String)
}

pub fn immunization_protocolapplied_new(
  dose_number dose_number: ImmunizationProtocolappliedDosenumber,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationEvaluation#resource
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
    status: r4valuesets.Immunizationevaluationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationEvaluation#resource
pub type ImmunizationevaluationDosenumber {
  ImmunizationevaluationDosenumberPositiveint(dose_number: Int)
  ImmunizationevaluationDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationEvaluation#resource
pub type ImmunizationevaluationSeriesdoses {
  ImmunizationevaluationSeriesdosesPositiveint(series_doses: Int)
  ImmunizationevaluationSeriesdosesString(series_doses: String)
}

pub fn immunizationevaluation_new(
  dose_status dose_status: Codeableconcept,
  immunization_event immunization_event: Reference,
  target_disease target_disease: Codeableconcept,
  patient patient: Reference,
  status status: r4valuesets.Immunizationevaluationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationRecommendation#resource
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
  date date: String,
  patient patient: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationRecommendation#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationDosenumber {
  ImmunizationrecommendationRecommendationDosenumberPositiveint(
    dose_number: Int,
  )
  ImmunizationrecommendationRecommendationDosenumberString(dose_number: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationRecommendation#resource
pub type ImmunizationrecommendationRecommendationSeriesdoses {
  ImmunizationrecommendationRecommendationSeriesdosesPositiveint(
    series_doses: Int,
  )
  ImmunizationrecommendationRecommendationSeriesdosesString(
    series_doses: String,
  )
}

pub fn immunizationrecommendation_recommendation_new(
  forecast_status forecast_status: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImmunizationRecommendation#resource
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
  value value: String,
  code code: Codeableconcept,
) -> ImmunizationrecommendationRecommendationDatecriterion {
  ImmunizationrecommendationRecommendationDatecriterion(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    package_id: String,
    license: Option(r4valuesets.Spdxlicense),
    fhir_version: List(r4valuesets.Fhirversion),
    depends_on: List(ImplementationguideDependson),
    global: List(ImplementationguideGlobal),
    definition: Option(ImplementationguideDefinition),
    manifest: Option(ImplementationguideManifest),
  )
}

pub fn implementationguide_new(
  package_id package_id: String,
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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

pub fn implementationguide_dependson_new(
  uri uri: String,
) -> ImplementationguideDependson {
  ImplementationguideDependson(
    version: None,
    package_id: None,
    uri:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideGlobal {
  ImplementationguideGlobal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Resourcetypes,
    profile: String,
  )
}

pub fn implementationguide_global_new(
  profile profile: String,
  type_ type_: r4valuesets.Resourcetypes,
) -> ImplementationguideGlobal {
  ImplementationguideGlobal(
    profile:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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
  name name: String,
) -> ImplementationguideDefinitionGrouping {
  ImplementationguideDefinitionGrouping(
    description: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    fhir_version: List(r4valuesets.Fhirversion),
    name: Option(String),
    description: Option(String),
    example: Option(ImplementationguideDefinitionResourceExample),
    grouping_id: Option(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResourceExample {
  ImplementationguideDefinitionResourceExampleBoolean(example: Bool)
  ImplementationguideDefinitionResourceExampleCanonical(example: String)
}

pub fn implementationguide_definition_resource_new(
  reference reference: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPage {
  ImplementationguideDefinitionPage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: ImplementationguideDefinitionPageName,
    title: String,
    generation: r4valuesets.Guidepagegeneration,
    page: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPageName {
  ImplementationguideDefinitionPageNameUrl(name: String)
  ImplementationguideDefinitionPageNameReference(name: Reference)
}

pub fn implementationguide_definition_page_new(
  generation generation: r4valuesets.Guidepagegeneration,
  title title: String,
  name name: ImplementationguideDefinitionPageName,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Guideparametercode,
    value: String,
  )
}

pub fn implementationguide_definition_parameter_new(
  value value: String,
  code code: r4valuesets.Guideparametercode,
) -> ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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
  source source: String,
  code code: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideManifestResourceExample {
  ImplementationguideManifestResourceExampleBoolean(example: Bool)
  ImplementationguideManifestResourceExampleCanonical(example: String)
}

pub fn implementationguide_manifest_resource_new(
  reference reference: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
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
  name name: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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
    status: Option(r4valuesets.Publicationstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_coverage_new(
  type_ type_: Codeableconcept,
) -> InsuranceplanCoverage {
  InsuranceplanCoverage(
    benefit: [],
    network: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

pub fn insuranceplan_coverage_benefit_new(
  type_ type_: Codeableconcept,
) -> InsuranceplanCoverageBenefit {
  InsuranceplanCoverageBenefit(
    limit: [],
    requirement: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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
  category category: Codeableconcept,
) -> InsuranceplanPlanSpecificcost {
  InsuranceplanPlanSpecificcost(
    benefit: [],
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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
  type_ type_: Codeableconcept,
) -> InsuranceplanPlanSpecificcostBenefit {
  InsuranceplanPlanSpecificcostBenefit(
    cost: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/InsurancePlan#resource
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
  type_ type_: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
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
    status: r4valuesets.Invoicestatus,
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

pub fn invoice_new(status status: r4valuesets.Invoicestatus) -> Invoice {
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

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
pub type InvoiceParticipant {
  InvoiceParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn invoice_participant_new(actor actor: Reference) -> InvoiceParticipant {
  InvoiceParticipant(
    actor:,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
pub type InvoiceLineitemChargeitem {
  InvoiceLineitemChargeitemReference(charge_item: Reference)
  InvoiceLineitemChargeitemCodeableconcept(charge_item: Codeableconcept)
}

pub fn invoice_lineitem_new(
  charge_item charge_item: InvoiceLineitemChargeitem,
) -> InvoiceLineitem {
  InvoiceLineitem(
    price_component: [],
    charge_item:,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
pub type InvoiceLineitemPricecomponent {
  InvoiceLineitemPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Invoicepricecomponenttype,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

pub fn invoice_lineitem_pricecomponent_new(
  type_ type_: r4valuesets.Invoicepricecomponenttype,
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

///http://hl7.org/fhir/r4/StructureDefinition/Library#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Library#resource
pub type LibrarySubject {
  LibrarySubjectCodeableconcept(subject: Codeableconcept)
  LibrarySubjectReference(subject: Reference)
}

pub fn library_new(
  type_ type_: Codeableconcept,
  status status: r4valuesets.Publicationstatus,
) -> Library {
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

///http://hl7.org/fhir/r4/StructureDefinition/Linkage#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Linkage#resource
pub type LinkageItem {
  LinkageItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Linkagetype,
    resource: Reference,
  )
}

pub fn linkage_item_new(
  resource resource: Reference,
  type_ type_: r4valuesets.Linkagetype,
) -> LinkageItem {
  LinkageItem(
    resource:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/List#resource
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
    status: r4valuesets.Liststatus,
    mode: r4valuesets.Listmode,
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

pub fn fhir_list_new(
  mode mode: r4valuesets.Listmode,
  status status: r4valuesets.Liststatus,
) -> FhirList {
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

///http://hl7.org/fhir/r4/StructureDefinition/List#resource
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

pub fn list_entry_new(item item: Reference) -> ListEntry {
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

///http://hl7.org/fhir/r4/StructureDefinition/Location#resource
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
    status: Option(r4valuesets.Locationstatus),
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(r4valuesets.Locationmode),
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

///http://hl7.org/fhir/r4/StructureDefinition/Location#resource
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

pub fn location_position_new(
  latitude latitude: Float,
  longitude longitude: Float,
) -> LocationPosition {
  LocationPosition(
    altitude: None,
    latitude:,
    longitude:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Location#resource
pub type LocationHoursofoperation {
  LocationHoursofoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4valuesets.Daysofweek),
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
pub type MeasureSubject {
  MeasureSubjectCodeableconcept(subject: Codeableconcept)
  MeasureSubjectReference(subject: Reference)
}

pub fn measure_new(status status: r4valuesets.Publicationstatus) -> Measure {
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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

pub fn measure_group_population_new(
  criteria criteria: Expression,
) -> MeasureGroupPopulation {
  MeasureGroupPopulation(
    criteria:,
    description: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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
  criteria criteria: Expression,
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

///http://hl7.org/fhir/r4/StructureDefinition/Measure#resource
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

pub fn measure_supplementaldata_new(
  criteria criteria: Expression,
) -> MeasureSupplementaldata {
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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
    status: r4valuesets.Measurereportstatus,
    type_: r4valuesets.Measurereporttype,
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

pub fn measurereport_new(
  period period: Period,
  measure measure: String,
  type_ type_: r4valuesets.Measurereporttype,
  status status: r4valuesets.Measurereportstatus,
) -> Measurereport {
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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
  value value: Codeableconcept,
  code code: Codeableconcept,
) -> MeasurereportGroupStratifierStratumComponent {
  MeasurereportGroupStratifierStratumComponent(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MeasureReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Media#resource
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
    status: r4valuesets.Eventstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Media#resource
pub type MediaCreated {
  MediaCreatedDatetime(created: String)
  MediaCreatedPeriod(created: Period)
}

pub fn media_new(
  content content: Attachment,
  status status: r4valuesets.Eventstatus,
) -> Media {
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

///http://hl7.org/fhir/r4/StructureDefinition/Medication#resource
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
    status: Option(r4valuesets.Medicationstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/Medication#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Medication#resource
pub type MedicationIngredientItem {
  MedicationIngredientItemCodeableconcept(item: Codeableconcept)
  MedicationIngredientItemReference(item: Reference)
}

pub fn medication_ingredient_new(
  item item: MedicationIngredientItem,
) -> MedicationIngredient {
  MedicationIngredient(
    strength: None,
    is_active: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Medication#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
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
    status: r4valuesets.Medicationadminstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationMedication {
  MedicationadministrationMedicationCodeableconcept(medication: Codeableconcept)
  MedicationadministrationMedicationReference(medication: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
pub type MedicationadministrationEffective {
  MedicationadministrationEffectiveDatetime(effective: String)
  MedicationadministrationEffectivePeriod(effective: Period)
}

pub fn medicationadministration_new(
  effective effective: MedicationadministrationEffective,
  subject subject: Reference,
  medication medication: MedicationadministrationMedication,
  status status: r4valuesets.Medicationadminstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
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
  actor actor: Reference,
) -> MedicationadministrationPerformer {
  MedicationadministrationPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationAdministration#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationDispense#resource
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
    status: r4valuesets.Medicationdispensestatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseStatusreason {
  MedicationdispenseStatusreasonCodeableconcept(status_reason: Codeableconcept)
  MedicationdispenseStatusreasonReference(status_reason: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationDispense#resource
pub type MedicationdispenseMedication {
  MedicationdispenseMedicationCodeableconcept(medication: Codeableconcept)
  MedicationdispenseMedicationReference(medication: Reference)
}

pub fn medicationdispense_new(
  medication medication: MedicationdispenseMedication,
  status status: r4valuesets.Medicationdispensestatus,
) -> Medicationdispense {
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationDispense#resource
pub type MedicationdispensePerformer {
  MedicationdispensePerformer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    function: Option(Codeableconcept),
    actor: Reference,
  )
}

pub fn medicationdispense_performer_new(
  actor actor: Reference,
) -> MedicationdispensePerformer {
  MedicationdispensePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationDispense#resource
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
  was_substituted was_substituted: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
    status: Option(r4valuesets.Medicationknowledgestatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  type_ type_: Codeableconcept,
) -> MedicationknowledgeRelatedmedicationknowledge {
  MedicationknowledgeRelatedmedicationknowledge(
    reference: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeIngredientItem {
  MedicationknowledgeIngredientItemCodeableconcept(item: Codeableconcept)
  MedicationknowledgeIngredientItemReference(item: Reference)
}

pub fn medicationknowledge_ingredient_new(
  item item: MedicationknowledgeIngredientItem,
) -> MedicationknowledgeIngredient {
  MedicationknowledgeIngredient(
    strength: None,
    is_active: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

pub fn medicationknowledge_cost_new(
  cost cost: Money,
  type_ type_: Codeableconcept,
) -> MedicationknowledgeCost {
  MedicationknowledgeCost(
    cost:,
    source: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  type_ type_: Codeableconcept,
) -> MedicationknowledgeAdministrationguidelinesDosage {
  MedicationknowledgeAdministrationguidelinesDosage(
    dosage: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesPatientcharacteristics {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    characteristic: MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristic,
    value: List(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristic {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristicCodeableconcept(
    characteristic: Codeableconcept,
  )
  MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristicQuantity(
    characteristic: Quantity,
  )
}

pub fn medicationknowledge_administrationguidelines_patientcharacteristics_new(
  characteristic characteristic: MedicationknowledgeAdministrationguidelinesPatientcharacteristicsCharacteristic,
) -> MedicationknowledgeAdministrationguidelinesPatientcharacteristics {
  MedicationknowledgeAdministrationguidelinesPatientcharacteristics(
    value: [],
    characteristic:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  type_ type_: Codeableconcept,
) -> MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    classification: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeDrugcharacteristic {
  MedicationknowledgeDrugcharacteristic(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    value: Option(MedicationknowledgeDrugcharacteristicValue),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  regulatory_authority regulatory_authority: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  allowed allowed: Bool,
  type_ type_: Codeableconcept,
) -> MedicationknowledgeRegulatorySubstitution {
  MedicationknowledgeRegulatorySubstitution(
    allowed:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Codeableconcept,
  )
}

pub fn medicationknowledge_regulatory_schedule_new(
  schedule schedule: Codeableconcept,
) -> MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    schedule:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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
  quantity quantity: Quantity,
) -> MedicationknowledgeRegulatoryMaxdispense {
  MedicationknowledgeRegulatoryMaxdispense(
    period: None,
    quantity:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
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
    status: r4valuesets.Medicationrequeststatus,
    status_reason: Option(Codeableconcept),
    intent: r4valuesets.Medicationrequestintent,
    category: List(Codeableconcept),
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestReported {
  MedicationrequestReportedBoolean(reported: Bool)
  MedicationrequestReportedReference(reported: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestMedication {
  MedicationrequestMedicationCodeableconcept(medication: Codeableconcept)
  MedicationrequestMedicationReference(medication: Reference)
}

pub fn medicationrequest_new(
  subject subject: Reference,
  medication medication: MedicationrequestMedication,
  intent intent: r4valuesets.Medicationrequestintent,
  status status: r4valuesets.Medicationrequeststatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    allowed: MedicationrequestSubstitutionAllowed,
    reason: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationRequest#resource
pub type MedicationrequestSubstitutionAllowed {
  MedicationrequestSubstitutionAllowedBoolean(allowed: Bool)
  MedicationrequestSubstitutionAllowedCodeableconcept(allowed: Codeableconcept)
}

pub fn medicationrequest_substitution_new(
  allowed allowed: MedicationrequestSubstitutionAllowed,
) -> MedicationrequestSubstitution {
  MedicationrequestSubstitution(
    reason: None,
    allowed:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationStatement#resource
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
    status: r4valuesets.Medicationstatementstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementMedication {
  MedicationstatementMedicationCodeableconcept(medication: Codeableconcept)
  MedicationstatementMedicationReference(medication: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicationStatement#resource
pub type MedicationstatementEffective {
  MedicationstatementEffectiveDatetime(effective: String)
  MedicationstatementEffectivePeriod(effective: Period)
}

pub fn medicationstatement_new(
  subject subject: Reference,
  medication medication: MedicationstatementMedication,
  status status: r4valuesets.Medicationstatementstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type Medicinalproduct {
  Medicinalproduct(
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
    domain: Option(Coding),
    combined_pharmaceutical_dose_form: Option(Codeableconcept),
    legal_status_of_supply: Option(Codeableconcept),
    additional_monitoring_indicator: Option(Codeableconcept),
    special_measures: List(String),
    paediatric_use_indicator: Option(Codeableconcept),
    product_classification: List(Codeableconcept),
    marketing_status: List(Marketingstatus),
    pharmaceutical_product: List(Reference),
    packaged_medicinal_product: List(Reference),
    attached_document: List(Reference),
    master_file: List(Reference),
    contact: List(Reference),
    clinical_trial: List(Reference),
    name: List(MedicinalproductName),
    cross_reference: List(Identifier),
    manufacturing_business_operation: List(
      MedicinalproductManufacturingbusinessoperation,
    ),
    special_designation: List(MedicinalproductSpecialdesignation),
  )
}

pub fn medicinalproduct_new() -> Medicinalproduct {
  Medicinalproduct(
    special_designation: [],
    manufacturing_business_operation: [],
    cross_reference: [],
    name: [],
    clinical_trial: [],
    contact: [],
    master_file: [],
    attached_document: [],
    packaged_medicinal_product: [],
    pharmaceutical_product: [],
    marketing_status: [],
    product_classification: [],
    paediatric_use_indicator: None,
    special_measures: [],
    additional_monitoring_indicator: None,
    legal_status_of_supply: None,
    combined_pharmaceutical_dose_form: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductName {
  MedicinalproductName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product_name: String,
    name_part: List(MedicinalproductNameNamepart),
    country_language: List(MedicinalproductNameCountrylanguage),
  )
}

pub fn medicinalproduct_name_new(
  product_name product_name: String,
) -> MedicinalproductName {
  MedicinalproductName(
    country_language: [],
    name_part: [],
    product_name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductNameNamepart {
  MedicinalproductNameNamepart(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: String,
    type_: Coding,
  )
}

pub fn medicinalproduct_name_namepart_new(
  type_ type_: Coding,
  part part: String,
) -> MedicinalproductNameNamepart {
  MedicinalproductNameNamepart(
    type_:,
    part:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductNameCountrylanguage {
  MedicinalproductNameCountrylanguage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    country: Codeableconcept,
    jurisdiction: Option(Codeableconcept),
    language: Codeableconcept,
  )
}

pub fn medicinalproduct_name_countrylanguage_new(
  language language: Codeableconcept,
  country country: Codeableconcept,
) -> MedicinalproductNameCountrylanguage {
  MedicinalproductNameCountrylanguage(
    language:,
    jurisdiction: None,
    country:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductManufacturingbusinessoperation {
  MedicinalproductManufacturingbusinessoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation_type: Option(Codeableconcept),
    authorisation_reference_number: Option(Identifier),
    effective_date: Option(String),
    confidentiality_indicator: Option(Codeableconcept),
    manufacturer: List(Reference),
    regulator: Option(Reference),
  )
}

pub fn medicinalproduct_manufacturingbusinessoperation_new() -> MedicinalproductManufacturingbusinessoperation {
  MedicinalproductManufacturingbusinessoperation(
    regulator: None,
    manufacturer: [],
    confidentiality_indicator: None,
    effective_date: None,
    authorisation_reference_number: None,
    operation_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductSpecialdesignation {
  MedicinalproductSpecialdesignation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Option(Codeableconcept),
    intended_use: Option(Codeableconcept),
    indication: Option(MedicinalproductSpecialdesignationIndication),
    status: Option(Codeableconcept),
    date: Option(String),
    species: Option(Codeableconcept),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProduct#resource
pub type MedicinalproductSpecialdesignationIndication {
  MedicinalproductSpecialdesignationIndicationCodeableconcept(
    indication: Codeableconcept,
  )
  MedicinalproductSpecialdesignationIndicationReference(indication: Reference)
}

pub fn medicinalproduct_specialdesignation_new() -> MedicinalproductSpecialdesignation {
  MedicinalproductSpecialdesignation(
    species: None,
    date: None,
    status: None,
    indication: None,
    intended_use: None,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type Medicinalproductauthorization {
  Medicinalproductauthorization(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    subject: Option(Reference),
    country: List(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    restore_date: Option(String),
    validity_period: Option(Period),
    data_exclusivity_period: Option(Period),
    date_of_first_authorization: Option(String),
    international_birth_date: Option(String),
    legal_basis: Option(Codeableconcept),
    jurisdictional_authorization: List(
      MedicinalproductauthorizationJurisdictionalauthorization,
    ),
    holder: Option(Reference),
    regulator: Option(Reference),
    procedure: Option(MedicinalproductauthorizationProcedure),
  )
}

pub fn medicinalproductauthorization_new() -> Medicinalproductauthorization {
  Medicinalproductauthorization(
    procedure: None,
    regulator: None,
    holder: None,
    jurisdictional_authorization: [],
    legal_basis: None,
    international_birth_date: None,
    date_of_first_authorization: None,
    data_exclusivity_period: None,
    validity_period: None,
    restore_date: None,
    status_date: None,
    status: None,
    jurisdiction: [],
    country: [],
    subject: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type MedicinalproductauthorizationJurisdictionalauthorization {
  MedicinalproductauthorizationJurisdictionalauthorization(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    country: Option(Codeableconcept),
    jurisdiction: List(Codeableconcept),
    legal_status_of_supply: Option(Codeableconcept),
    validity_period: Option(Period),
  )
}

pub fn medicinalproductauthorization_jurisdictionalauthorization_new() -> MedicinalproductauthorizationJurisdictionalauthorization {
  MedicinalproductauthorizationJurisdictionalauthorization(
    validity_period: None,
    legal_status_of_supply: None,
    jurisdiction: [],
    country: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type MedicinalproductauthorizationProcedure {
  MedicinalproductauthorizationProcedure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Codeableconcept,
    date: Option(MedicinalproductauthorizationProcedureDate),
    application: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductAuthorization#resource
pub type MedicinalproductauthorizationProcedureDate {
  MedicinalproductauthorizationProcedureDatePeriod(date: Period)
  MedicinalproductauthorizationProcedureDateDatetime(date: String)
}

pub fn medicinalproductauthorization_procedure_new(
  type_ type_: Codeableconcept,
) -> MedicinalproductauthorizationProcedure {
  MedicinalproductauthorizationProcedure(
    application: [],
    date: None,
    type_:,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductContraindication#resource
pub type Medicinalproductcontraindication {
  Medicinalproductcontraindication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    disease: Option(Codeableconcept),
    disease_status: Option(Codeableconcept),
    comorbidity: List(Codeableconcept),
    therapeutic_indication: List(Reference),
    other_therapy: List(MedicinalproductcontraindicationOthertherapy),
    population: List(Population),
  )
}

pub fn medicinalproductcontraindication_new() -> Medicinalproductcontraindication {
  Medicinalproductcontraindication(
    population: [],
    other_therapy: [],
    therapeutic_indication: [],
    comorbidity: [],
    disease_status: None,
    disease: None,
    subject: [],
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductContraindication#resource
pub type MedicinalproductcontraindicationOthertherapy {
  MedicinalproductcontraindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    therapy_relationship_type: Codeableconcept,
    medication: MedicinalproductcontraindicationOthertherapyMedication,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductContraindication#resource
pub type MedicinalproductcontraindicationOthertherapyMedication {
  MedicinalproductcontraindicationOthertherapyMedicationCodeableconcept(
    medication: Codeableconcept,
  )
  MedicinalproductcontraindicationOthertherapyMedicationReference(
    medication: Reference,
  )
}

pub fn medicinalproductcontraindication_othertherapy_new(
  medication medication: MedicinalproductcontraindicationOthertherapyMedication,
  therapy_relationship_type therapy_relationship_type: Codeableconcept,
) -> MedicinalproductcontraindicationOthertherapy {
  MedicinalproductcontraindicationOthertherapy(
    medication:,
    therapy_relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIndication#resource
pub type Medicinalproductindication {
  Medicinalproductindication(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    disease_symptom_procedure: Option(Codeableconcept),
    disease_status: Option(Codeableconcept),
    comorbidity: List(Codeableconcept),
    intended_effect: Option(Codeableconcept),
    duration: Option(Quantity),
    other_therapy: List(MedicinalproductindicationOthertherapy),
    undesirable_effect: List(Reference),
    population: List(Population),
  )
}

pub fn medicinalproductindication_new() -> Medicinalproductindication {
  Medicinalproductindication(
    population: [],
    undesirable_effect: [],
    other_therapy: [],
    duration: None,
    intended_effect: None,
    comorbidity: [],
    disease_status: None,
    disease_symptom_procedure: None,
    subject: [],
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIndication#resource
pub type MedicinalproductindicationOthertherapy {
  MedicinalproductindicationOthertherapy(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    therapy_relationship_type: Codeableconcept,
    medication: MedicinalproductindicationOthertherapyMedication,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIndication#resource
pub type MedicinalproductindicationOthertherapyMedication {
  MedicinalproductindicationOthertherapyMedicationCodeableconcept(
    medication: Codeableconcept,
  )
  MedicinalproductindicationOthertherapyMedicationReference(
    medication: Reference,
  )
}

pub fn medicinalproductindication_othertherapy_new(
  medication medication: MedicinalproductindicationOthertherapyMedication,
  therapy_relationship_type therapy_relationship_type: Codeableconcept,
) -> MedicinalproductindicationOthertherapy {
  MedicinalproductindicationOthertherapy(
    medication:,
    therapy_relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type Medicinalproductingredient {
  Medicinalproductingredient(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    role: Codeableconcept,
    allergenic_indicator: Option(Bool),
    manufacturer: List(Reference),
    specified_substance: List(MedicinalproductingredientSpecifiedsubstance),
    substance: Option(MedicinalproductingredientSubstance),
  )
}

pub fn medicinalproductingredient_new(
  role role: Codeableconcept,
) -> Medicinalproductingredient {
  Medicinalproductingredient(
    substance: None,
    specified_substance: [],
    manufacturer: [],
    allergenic_indicator: None,
    role:,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstance {
  MedicinalproductingredientSpecifiedsubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    group: Codeableconcept,
    confidentiality: Option(Codeableconcept),
    strength: List(MedicinalproductingredientSpecifiedsubstanceStrength),
  )
}

pub fn medicinalproductingredient_specifiedsubstance_new(
  group group: Codeableconcept,
  code code: Codeableconcept,
) -> MedicinalproductingredientSpecifiedsubstance {
  MedicinalproductingredientSpecifiedsubstance(
    strength: [],
    confidentiality: None,
    group:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstanceStrength {
  MedicinalproductingredientSpecifiedsubstanceStrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    presentation: Ratio,
    presentation_low_limit: Option(Ratio),
    concentration: Option(Ratio),
    concentration_low_limit: Option(Ratio),
    measurement_point: Option(String),
    country: List(Codeableconcept),
    reference_strength: List(
      MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength,
    ),
  )
}

pub fn medicinalproductingredient_specifiedsubstance_strength_new(
  presentation presentation: Ratio,
) -> MedicinalproductingredientSpecifiedsubstanceStrength {
  MedicinalproductingredientSpecifiedsubstanceStrength(
    reference_strength: [],
    country: [],
    measurement_point: None,
    concentration_low_limit: None,
    concentration: None,
    presentation_low_limit: None,
    presentation:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength {
  MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(Codeableconcept),
    strength: Ratio,
    strength_low_limit: Option(Ratio),
    measurement_point: Option(String),
    country: List(Codeableconcept),
  )
}

pub fn medicinalproductingredient_specifiedsubstance_strength_referencestrength_new(
  strength strength: Ratio,
) -> MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength {
  MedicinalproductingredientSpecifiedsubstanceStrengthReferencestrength(
    country: [],
    measurement_point: None,
    strength_low_limit: None,
    strength:,
    substance: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductIngredient#resource
pub type MedicinalproductingredientSubstance {
  MedicinalproductingredientSubstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    strength: List(Nil),
  )
}

pub fn medicinalproductingredient_substance_new(
  code code: Codeableconcept,
) -> MedicinalproductingredientSubstance {
  MedicinalproductingredientSubstance(
    strength: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductInteraction#resource
pub type Medicinalproductinteraction {
  Medicinalproductinteraction(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    description: Option(String),
    interactant: List(MedicinalproductinteractionInteractant),
    type_: Option(Codeableconcept),
    effect: Option(Codeableconcept),
    incidence: Option(Codeableconcept),
    management: Option(Codeableconcept),
  )
}

pub fn medicinalproductinteraction_new() -> Medicinalproductinteraction {
  Medicinalproductinteraction(
    management: None,
    incidence: None,
    effect: None,
    type_: None,
    interactant: [],
    description: None,
    subject: [],
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductInteraction#resource
pub type MedicinalproductinteractionInteractant {
  MedicinalproductinteractionInteractant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    item: MedicinalproductinteractionInteractantItem,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductInteraction#resource
pub type MedicinalproductinteractionInteractantItem {
  MedicinalproductinteractionInteractantItemReference(item: Reference)
  MedicinalproductinteractionInteractantItemCodeableconcept(
    item: Codeableconcept,
  )
}

pub fn medicinalproductinteraction_interactant_new(
  item item: MedicinalproductinteractionInteractantItem,
) -> MedicinalproductinteractionInteractant {
  MedicinalproductinteractionInteractant(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductManufactured#resource
pub type Medicinalproductmanufactured {
  Medicinalproductmanufactured(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    manufactured_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    quantity: Quantity,
    manufacturer: List(Reference),
    ingredient: List(Reference),
    physical_characteristics: Option(Prodcharacteristic),
    other_characteristics: List(Codeableconcept),
  )
}

pub fn medicinalproductmanufactured_new(
  quantity quantity: Quantity,
  manufactured_dose_form manufactured_dose_form: Codeableconcept,
) -> Medicinalproductmanufactured {
  Medicinalproductmanufactured(
    other_characteristics: [],
    physical_characteristics: None,
    ingredient: [],
    manufacturer: [],
    quantity:,
    unit_of_presentation: None,
    manufactured_dose_form:,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type Medicinalproductpackaged {
  Medicinalproductpackaged(
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
    description: Option(String),
    legal_status_of_supply: Option(Codeableconcept),
    marketing_status: List(Marketingstatus),
    marketing_authorization: Option(Reference),
    manufacturer: List(Reference),
    batch_identifier: List(MedicinalproductpackagedBatchidentifier),
    package_item: List(MedicinalproductpackagedPackageitem),
  )
}

pub fn medicinalproductpackaged_new() -> Medicinalproductpackaged {
  Medicinalproductpackaged(
    package_item: [],
    batch_identifier: [],
    manufacturer: [],
    marketing_authorization: None,
    marketing_status: [],
    legal_status_of_supply: None,
    description: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type MedicinalproductpackagedBatchidentifier {
  MedicinalproductpackagedBatchidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    outer_packaging: Identifier,
    immediate_packaging: Option(Identifier),
  )
}

pub fn medicinalproductpackaged_batchidentifier_new(
  outer_packaging outer_packaging: Identifier,
) -> MedicinalproductpackagedBatchidentifier {
  MedicinalproductpackagedBatchidentifier(
    immediate_packaging: None,
    outer_packaging:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPackaged#resource
pub type MedicinalproductpackagedPackageitem {
  MedicinalproductpackagedPackageitem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    type_: Codeableconcept,
    quantity: Quantity,
    material: List(Codeableconcept),
    alternate_material: List(Codeableconcept),
    device: List(Reference),
    manufactured_item: List(Reference),
    package_item: List(Nil),
    physical_characteristics: Option(Prodcharacteristic),
    other_characteristics: List(Codeableconcept),
    shelf_life_storage: List(Productshelflife),
    manufacturer: List(Reference),
  )
}

pub fn medicinalproductpackaged_packageitem_new(
  quantity quantity: Quantity,
  type_ type_: Codeableconcept,
) -> MedicinalproductpackagedPackageitem {
  MedicinalproductpackagedPackageitem(
    manufacturer: [],
    shelf_life_storage: [],
    other_characteristics: [],
    physical_characteristics: None,
    package_item: [],
    manufactured_item: [],
    device: [],
    alternate_material: [],
    material: [],
    quantity:,
    type_:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type Medicinalproductpharmaceutical {
  Medicinalproductpharmaceutical(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: List(Identifier),
    administrable_dose_form: Codeableconcept,
    unit_of_presentation: Option(Codeableconcept),
    ingredient: List(Reference),
    device: List(Reference),
    characteristics: List(MedicinalproductpharmaceuticalCharacteristics),
    route_of_administration: List(
      MedicinalproductpharmaceuticalRouteofadministration,
    ),
  )
}

pub fn medicinalproductpharmaceutical_new(
  administrable_dose_form administrable_dose_form: Codeableconcept,
) -> Medicinalproductpharmaceutical {
  Medicinalproductpharmaceutical(
    route_of_administration: [],
    characteristics: [],
    device: [],
    ingredient: [],
    unit_of_presentation: None,
    administrable_dose_form:,
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalCharacteristics {
  MedicinalproductpharmaceuticalCharacteristics(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    status: Option(Codeableconcept),
  )
}

pub fn medicinalproductpharmaceutical_characteristics_new(
  code code: Codeableconcept,
) -> MedicinalproductpharmaceuticalCharacteristics {
  MedicinalproductpharmaceuticalCharacteristics(
    status: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministration {
  MedicinalproductpharmaceuticalRouteofadministration(
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
      MedicinalproductpharmaceuticalRouteofadministrationTargetspecies,
    ),
  )
}

pub fn medicinalproductpharmaceutical_routeofadministration_new(
  code code: Codeableconcept,
) -> MedicinalproductpharmaceuticalRouteofadministration {
  MedicinalproductpharmaceuticalRouteofadministration(
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministrationTargetspecies {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspecies(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    withdrawal_period: List(
      MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod,
    ),
  )
}

pub fn medicinalproductpharmaceutical_routeofadministration_targetspecies_new(
  code code: Codeableconcept,
) -> MedicinalproductpharmaceuticalRouteofadministrationTargetspecies {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspecies(
    withdrawal_period: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductPharmaceutical#resource
pub type MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    tissue: Codeableconcept,
    value: Quantity,
    supporting_information: Option(String),
  )
}

pub fn medicinalproductpharmaceutical_routeofadministration_targetspecies_withdrawalperiod_new(
  value value: Quantity,
  tissue tissue: Codeableconcept,
) -> MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod {
  MedicinalproductpharmaceuticalRouteofadministrationTargetspeciesWithdrawalperiod(
    supporting_information: None,
    value:,
    tissue:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MedicinalProductUndesirableEffect#resource
pub type Medicinalproductundesirableeffect {
  Medicinalproductundesirableeffect(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    subject: List(Reference),
    symptom_condition_effect: Option(Codeableconcept),
    classification: Option(Codeableconcept),
    frequency_of_occurrence: Option(Codeableconcept),
    population: List(Population),
  )
}

pub fn medicinalproductundesirableeffect_new() -> Medicinalproductundesirableeffect {
  Medicinalproductundesirableeffect(
    population: [],
    frequency_of_occurrence: None,
    classification: None,
    symptom_condition_effect: None,
    subject: [],
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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
    category: Option(r4valuesets.Messagesignificancecategory),
    focus: List(MessagedefinitionFocus),
    response_required: Option(r4valuesets.Messageheaderresponserequest),
    allowed_response: List(MessagedefinitionAllowedresponse),
    graph: List(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionEvent {
  MessagedefinitionEventCoding(event: Coding)
  MessagedefinitionEventUri(event: String)
}

pub fn messagedefinition_new(
  event event: MessagedefinitionEvent,
  date date: String,
  status status: r4valuesets.Publicationstatus,
) -> Messagedefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionFocus {
  MessagedefinitionFocus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r4valuesets.Resourcetypes,
    profile: Option(String),
    min: Int,
    max: Option(String),
  )
}

pub fn messagedefinition_focus_new(
  min min: Int,
  code code: r4valuesets.Resourcetypes,
) -> MessagedefinitionFocus {
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
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
  message message: String,
) -> MessagedefinitionAllowedresponse {
  MessagedefinitionAllowedresponse(
    situation: None,
    message:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
pub type MessageheaderEvent {
  MessageheaderEventCoding(event: Coding)
  MessageheaderEventUri(event: String)
}

pub fn messageheader_new(
  source source: MessageheaderSource,
  event event: MessageheaderEvent,
) -> Messageheader {
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
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

pub fn messageheader_destination_new(
  endpoint endpoint: String,
) -> MessageheaderDestination {
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
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

pub fn messageheader_source_new(
  endpoint endpoint: String,
) -> MessageheaderSource {
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
pub type MessageheaderResponse {
  MessageheaderResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: String,
    code: r4valuesets.Responsecode,
    details: Option(Reference),
  )
}

pub fn messageheader_response_new(
  code code: r4valuesets.Responsecode,
  identifier identifier: String,
) -> MessageheaderResponse {
  MessageheaderResponse(
    details: None,
    code:,
    identifier:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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
    type_: Option(r4valuesets.Sequencetype),
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

pub fn molecularsequence_new(
  coordinate_system coordinate_system: Int,
) -> Molecularsequence {
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceReferenceseq {
  MolecularsequenceReferenceseq(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    chromosome: Option(Codeableconcept),
    genome_build: Option(String),
    orientation: Option(r4valuesets.Orientationtype),
    reference_seq_id: Option(Codeableconcept),
    reference_seq_pointer: Option(Reference),
    reference_seq_string: Option(String),
    strand: Option(r4valuesets.Strandtype),
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQuality {
  MolecularsequenceQuality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Qualitytype,
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

pub fn molecularsequence_quality_new(
  type_ type_: r4valuesets.Qualitytype,
) -> MolecularsequenceQuality {
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRepository {
  MolecularsequenceRepository(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Repositorytype,
    url: Option(String),
    name: Option(String),
    dataset_id: Option(String),
    variantset_id: Option(String),
    readset_id: Option(String),
  )
}

pub fn molecularsequence_repository_new(
  type_ type_: r4valuesets.Repositorytype,
) -> MolecularsequenceRepository {
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NamingSystem#resource
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
    status: r4valuesets.Publicationstatus,
    kind: r4valuesets.Namingsystemtype,
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

pub fn namingsystem_new(
  date date: String,
  kind kind: r4valuesets.Namingsystemtype,
  status status: r4valuesets.Publicationstatus,
  name name: String,
) -> Namingsystem {
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

///http://hl7.org/fhir/r4/StructureDefinition/NamingSystem#resource
pub type NamingsystemUniqueid {
  NamingsystemUniqueid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Namingsystemidentifiertype,
    value: String,
    preferred: Option(Bool),
    comment: Option(String),
    period: Option(Period),
  )
}

pub fn namingsystem_uniqueid_new(
  value value: String,
  type_ type_: r4valuesets.Namingsystemidentifiertype,
) -> NamingsystemUniqueid {
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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
    status: r4valuesets.Requeststatus,
    intent: r4valuesets.Requestintent,
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

pub fn nutritionorder_new(
  date_time date_time: String,
  patient patient: Reference,
  intent intent: r4valuesets.Requestintent,
  status status: r4valuesets.Requeststatus,
) -> Nutritionorder {
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/NutritionOrder#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
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
    status: r4valuesets.Observationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
pub type ObservationEffective {
  ObservationEffectiveDatetime(effective: String)
  ObservationEffectivePeriod(effective: Period)
  ObservationEffectiveTiming(effective: Timing)
  ObservationEffectiveInstant(effective: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
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

pub fn observation_new(
  code code: Codeableconcept,
  status status: r4valuesets.Observationstatus,
) -> Observation {
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

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Observation#resource
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

pub fn observation_component_new(
  code code: Codeableconcept,
) -> ObservationComponent {
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

///http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
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
    permitted_data_type: List(r4valuesets.Permitteddatatype),
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

pub fn observationdefinition_new(
  code code: Codeableconcept,
) -> Observationdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedinterval {
  ObservationdefinitionQualifiedinterval(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(r4valuesets.Observationrangecategory),
    range: Option(Range),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(r4valuesets.Administrativegender),
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
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
    status: r4valuesets.Publicationstatus,
    kind: r4valuesets.Operationkind,
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
    resource: List(r4valuesets.Resourcetypes),
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
  instance instance: Bool,
  type_ type_: Bool,
  system system: Bool,
  code code: String,
  kind kind: r4valuesets.Operationkind,
  status status: r4valuesets.Publicationstatus,
  name name: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameter {
  OperationdefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    use_: r4valuesets.Operationparameteruse,
    min: Int,
    max: String,
    documentation: Option(String),
    type_: Option(r4valuesets.Alltypes),
    target_profile: List(String),
    search_type: Option(r4valuesets.Searchparamtype),
    binding: Option(OperationdefinitionParameterBinding),
    referenced_from: List(OperationdefinitionParameterReferencedfrom),
    part: List(Nil),
  )
}

pub fn operationdefinition_parameter_new(
  max max: String,
  min min: Int,
  use_ use_: r4valuesets.Operationparameteruse,
  name name: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    strength: r4valuesets.Bindingstrength,
    value_set: String,
  )
}

pub fn operationdefinition_parameter_binding_new(
  value_set value_set: String,
  strength strength: r4valuesets.Bindingstrength,
) -> OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    value_set:,
    strength:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
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
  source source: String,
) -> OperationdefinitionParameterReferencedfrom {
  OperationdefinitionParameterReferencedfrom(
    source_id: None,
    source:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource
pub type OperationoutcomeIssue {
  OperationoutcomeIssue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    severity: r4valuesets.Issueseverity,
    code: r4valuesets.Issuetype,
    details: Option(Codeableconcept),
    diagnostics: Option(String),
    location: List(String),
    expression: List(String),
  )
}

pub fn operationoutcome_issue_new(
  code code: r4valuesets.Issuetype,
  severity severity: r4valuesets.Issueseverity,
) -> OperationoutcomeIssue {
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

///http://hl7.org/fhir/r4/StructureDefinition/Organization#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Organization#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/OrganizationAffiliation#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Parameters#resource
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

pub fn parameters_parameter_new(name name: String) -> ParametersParameter {
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

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
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
    gender: Option(r4valuesets.Administrativegender),
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

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientDeceased {
  PatientDeceasedBoolean(deceased: Bool)
  PatientDeceasedDatetime(deceased: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(r4valuesets.Administrativegender),
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

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientCommunication {
  PatientCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

pub fn patient_communication_new(
  language language: Codeableconcept,
) -> PatientCommunication {
  PatientCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: r4valuesets.Linktype,
  )
}

pub fn patient_link_new(
  type_ type_: r4valuesets.Linktype,
  other other: Reference,
) -> PatientLink {
  PatientLink(type_:, other:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/PaymentNotice#resource
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
    status: r4valuesets.Fmstatus,
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
  amount amount: Money,
  recipient recipient: Reference,
  payment payment: Reference,
  created created: String,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/PaymentReconciliation#resource
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
    status: r4valuesets.Fmstatus,
    period: Option(Period),
    created: String,
    payment_issuer: Option(Reference),
    request: Option(Reference),
    requestor: Option(Reference),
    outcome: Option(r4valuesets.Remittanceoutcome),
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
  payment_amount payment_amount: Money,
  payment_date payment_date: String,
  created created: String,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/PaymentReconciliation#resource
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

pub fn paymentreconciliation_detail_new(
  type_ type_: Codeableconcept,
) -> PaymentreconciliationDetail {
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

///http://hl7.org/fhir/r4/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r4valuesets.Notetype),
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

///http://hl7.org/fhir/r4/StructureDefinition/Person#resource
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
    gender: Option(r4valuesets.Administrativegender),
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

///http://hl7.org/fhir/r4/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(r4valuesets.Identityassurancelevel),
  )
}

pub fn person_link_new(target target: Reference) -> PersonLink {
  PersonLink(
    assurance: None,
    target:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionSubject {
  PlandefinitionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionSubjectReference(subject: Reference)
}

pub fn plandefinition_new(
  status status: r4valuesets.Publicationstatus,
) -> Plandefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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

pub fn plandefinition_goal_new(
  description description: Codeableconcept,
) -> PlandefinitionGoal {
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionAction {
  PlandefinitionAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(r4valuesets.Requestpriority),
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
    grouping_behavior: Option(r4valuesets.Actiongroupingbehavior),
    selection_behavior: Option(r4valuesets.Actionselectionbehavior),
    required_behavior: Option(r4valuesets.Actionrequiredbehavior),
    precheck_behavior: Option(r4valuesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r4valuesets.Actioncardinalitybehavior),
    definition: Option(PlandefinitionActionDefinition),
    transform: Option(String),
    dynamic_value: List(PlandefinitionActionDynamicvalue),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionSubject {
  PlandefinitionActionSubjectCodeableconcept(subject: Codeableconcept)
  PlandefinitionActionSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionTiming {
  PlandefinitionActionTimingDatetime(timing: String)
  PlandefinitionActionTimingAge(timing: Age)
  PlandefinitionActionTimingPeriod(timing: Period)
  PlandefinitionActionTimingDuration(timing: Duration)
  PlandefinitionActionTimingRange(timing: Range)
  PlandefinitionActionTimingTiming(timing: Timing)
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r4valuesets.Actionconditionkind,
    expression: Option(Expression),
  )
}

pub fn plandefinition_action_condition_new(
  kind kind: r4valuesets.Actionconditionkind,
) -> PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    expression: None,
    kind:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: r4valuesets.Actionrelationshiptype,
    offset: Option(PlandefinitionActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedactionOffset {
  PlandefinitionActionRelatedactionOffsetDuration(offset: Duration)
  PlandefinitionActionRelatedactionOffsetRange(offset: Range)
}

pub fn plandefinition_action_relatedaction_new(
  relationship relationship: r4valuesets.Actionrelationshiptype,
  action_id action_id: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Actionparticipanttype,
    role: Option(Codeableconcept),
  )
}

pub fn plandefinition_action_participant_new(
  type_ type_: r4valuesets.Actionparticipanttype,
) -> PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    role: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Practitioner#resource
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
    gender: Option(r4valuesets.Administrativegender),
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

///http://hl7.org/fhir/r4/StructureDefinition/Practitioner#resource
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

pub fn practitioner_qualification_new(
  code code: Codeableconcept,
) -> PractitionerQualification {
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

///http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleAvailabletime {
  PractitionerroleAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(r4valuesets.Daysofweek),
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

///http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
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
  description description: String,
) -> PractitionerroleNotavailable {
  PractitionerroleNotavailable(
    during: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
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
    status: r4valuesets.Eventstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
pub type ProcedurePerformed {
  ProcedurePerformedDatetime(performed: String)
  ProcedurePerformedPeriod(performed: Period)
  ProcedurePerformedString(performed: String)
  ProcedurePerformedAge(performed: Age)
  ProcedurePerformedRange(performed: Range)
}

pub fn procedure_new(
  subject subject: Reference,
  status status: r4valuesets.Eventstatus,
) -> Procedure {
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

///http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
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

pub fn procedure_performer_new(actor actor: Reference) -> ProcedurePerformer {
  ProcedurePerformer(
    on_behalf_of: None,
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Procedure#resource
pub type ProcedureFocaldevice {
  ProcedureFocaldevice(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: Option(Codeableconcept),
    manipulated: Reference,
  )
}

pub fn procedure_focaldevice_new(
  manipulated manipulated: Reference,
) -> ProcedureFocaldevice {
  ProcedureFocaldevice(
    manipulated:,
    action: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
pub type ProvenanceOccurred {
  ProvenanceOccurredPeriod(occurred: Period)
  ProvenanceOccurredDatetime(occurred: String)
}

pub fn provenance_new(recorded recorded: String) -> Provenance {
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

///http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
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

pub fn provenance_agent_new(who who: Reference) -> ProvenanceAgent {
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

///http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
pub type ProvenanceEntity {
  ProvenanceEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: r4valuesets.Provenanceentityrole,
    what: Reference,
    agent: List(Nil),
  )
}

pub fn provenance_entity_new(
  what what: Reference,
  role role: r4valuesets.Provenanceentityrole,
) -> ProvenanceEntity {
  ProvenanceEntity(
    agent: [],
    what:,
    role:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    subject_type: List(r4valuesets.Resourcetypes),
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

pub fn questionnaire_new(
  status status: r4valuesets.Publicationstatus,
) -> Questionnaire {
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

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
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
    type_: r4valuesets.Itemtype,
    enable_when: List(QuestionnaireItemEnablewhen),
    enable_behavior: Option(r4valuesets.Questionnaireenablebehavior),
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

pub fn questionnaire_item_new(
  type_ type_: r4valuesets.Itemtype,
  link_id link_id: String,
) -> QuestionnaireItem {
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

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemEnablewhen {
  QuestionnaireItemEnablewhen(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    question: String,
    operator: r4valuesets.Questionnaireenableoperator,
    answer: QuestionnaireItemEnablewhenAnswer,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
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
  answer answer: QuestionnaireItemEnablewhenAnswer,
  operator operator: r4valuesets.Questionnaireenableoperator,
  question question: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroption {
  QuestionnaireItemAnsweroption(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemAnsweroptionValue,
    initial_selected: Option(Bool),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemAnsweroptionValue {
  QuestionnaireItemAnsweroptionValueInteger(value: Int)
  QuestionnaireItemAnsweroptionValueDate(value: String)
  QuestionnaireItemAnsweroptionValueTime(value: String)
  QuestionnaireItemAnsweroptionValueString(value: String)
  QuestionnaireItemAnsweroptionValueCoding(value: Coding)
  QuestionnaireItemAnsweroptionValueReference(value: Reference)
}

pub fn questionnaire_item_answeroption_new(
  value value: QuestionnaireItemAnsweroptionValue,
) -> QuestionnaireItemAnsweroption {
  QuestionnaireItemAnsweroption(
    initial_selected: None,
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: QuestionnaireItemInitialValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
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

pub fn questionnaire_item_initial_new(
  value value: QuestionnaireItemInitialValue,
) -> QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/QuestionnaireResponse#resource
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
    status: r4valuesets.Questionnaireanswersstatus,
    subject: Option(Reference),
    encounter: Option(Reference),
    authored: Option(String),
    author: Option(Reference),
    source: Option(Reference),
    item: List(QuestionnaireresponseItem),
  )
}

pub fn questionnaireresponse_new(
  status status: r4valuesets.Questionnaireanswersstatus,
) -> Questionnaireresponse {
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

///http://hl7.org/fhir/r4/StructureDefinition/QuestionnaireResponse#resource
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

pub fn questionnaireresponse_item_new(
  link_id link_id: String,
) -> QuestionnaireresponseItem {
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

///http://hl7.org/fhir/r4/StructureDefinition/QuestionnaireResponse#resource
pub type QuestionnaireresponseItemAnswer {
  QuestionnaireresponseItemAnswer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: Option(QuestionnaireresponseItemAnswerValue),
    item: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/QuestionnaireResponse#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/RelatedPerson#resource
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
    gender: Option(r4valuesets.Administrativegender),
    birth_date: Option(String),
    address: List(Address),
    photo: List(Attachment),
    period: Option(Period),
    communication: List(RelatedpersonCommunication),
  )
}

pub fn relatedperson_new(patient patient: Reference) -> Relatedperson {
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

///http://hl7.org/fhir/r4/StructureDefinition/RelatedPerson#resource
pub type RelatedpersonCommunication {
  RelatedpersonCommunication(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}

pub fn relatedperson_communication_new(
  language language: Codeableconcept,
) -> RelatedpersonCommunication {
  RelatedpersonCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
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
    status: r4valuesets.Requeststatus,
    intent: r4valuesets.Requestintent,
    priority: Option(r4valuesets.Requestpriority),
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

pub fn requestgroup_new(
  intent intent: r4valuesets.Requestintent,
  status status: r4valuesets.Requeststatus,
) -> Requestgroup {
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

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupAction {
  RequestgroupAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    prefix: Option(String),
    title: Option(String),
    description: Option(String),
    text_equivalent: Option(String),
    priority: Option(r4valuesets.Requestpriority),
    code: List(Codeableconcept),
    documentation: List(Relatedartifact),
    condition: List(RequestgroupActionCondition),
    related_action: List(RequestgroupActionRelatedaction),
    timing: Option(RequestgroupActionTiming),
    participant: List(Reference),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(r4valuesets.Actiongroupingbehavior),
    selection_behavior: Option(r4valuesets.Actionselectionbehavior),
    required_behavior: Option(r4valuesets.Actionrequiredbehavior),
    precheck_behavior: Option(r4valuesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r4valuesets.Actioncardinalitybehavior),
    resource: Option(Reference),
    action: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionCondition {
  RequestgroupActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r4valuesets.Actionconditionkind,
    expression: Option(Expression),
  )
}

pub fn requestgroup_action_condition_new(
  kind kind: r4valuesets.Actionconditionkind,
) -> RequestgroupActionCondition {
  RequestgroupActionCondition(
    expression: None,
    kind:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedaction {
  RequestgroupActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: r4valuesets.Actionrelationshiptype,
    offset: Option(RequestgroupActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedactionOffset {
  RequestgroupActionRelatedactionOffsetDuration(offset: Duration)
  RequestgroupActionRelatedactionOffsetRange(offset: Range)
}

pub fn requestgroup_action_relatedaction_new(
  relationship relationship: r4valuesets.Actionrelationshiptype,
  action_id action_id: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchDefinition#resource
pub type ResearchdefinitionSubject {
  ResearchdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ResearchdefinitionSubjectReference(subject: Reference)
}

pub fn researchdefinition_new(
  population population: Reference,
  status status: r4valuesets.Publicationstatus,
) -> Researchdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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
    type_: r4valuesets.Researchelementtype,
    variable_type: Option(r4valuesets.Variabletype),
    characteristic: List(ResearchelementdefinitionCharacteristic),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionSubject {
  ResearchelementdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ResearchelementdefinitionSubjectReference(subject: Reference)
}

pub fn researchelementdefinition_new(
  type_ type_: r4valuesets.Researchelementtype,
  status status: r4valuesets.Publicationstatus,
) -> Researchelementdefinition {
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
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
    study_effective_group_measure: Option(r4valuesets.Groupmeasure),
    participant_effective_description: Option(String),
    participant_effective: Option(
      ResearchelementdefinitionCharacteristicParticipanteffective,
    ),
    participant_effective_time_from_start: Option(Duration),
    participant_effective_group_measure: Option(r4valuesets.Groupmeasure),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
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
  definition definition: ResearchelementdefinitionCharacteristicDefinition,
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
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
    status: r4valuesets.Researchstudystatus,
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

pub fn researchstudy_new(
  status status: r4valuesets.Researchstudystatus,
) -> Researchstudy {
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
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

pub fn researchstudy_arm_new(name name: String) -> ResearchstudyArm {
  ResearchstudyArm(
    description: None,
    type_: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ResearchStudy#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ResearchSubject#resource
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
    status: r4valuesets.Researchsubjectstatus,
    period: Option(Period),
    study: Reference,
    individual: Reference,
    assigned_arm: Option(String),
    actual_arm: Option(String),
    consent: Option(Reference),
  )
}

pub fn researchsubject_new(
  individual individual: Reference,
  study study: Reference,
  status status: r4valuesets.Researchsubjectstatus,
) -> Researchsubject {
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskAssessment#resource
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
    status: r4valuesets.Observationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentOccurrence {
  RiskassessmentOccurrenceDatetime(occurrence: String)
  RiskassessmentOccurrencePeriod(occurrence: Period)
}

pub fn riskassessment_new(
  subject subject: Reference,
  status status: r4valuesets.Observationstatus,
) -> Riskassessment {
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskAssessment#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskAssessment#resource
pub type RiskassessmentPredictionProbability {
  RiskassessmentPredictionProbabilityDecimal(probability: Float)
  RiskassessmentPredictionProbabilityRange(probability: Range)
}

///http://hl7.org/fhir/r4/StructureDefinition/RiskAssessment#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type Riskevidencesynthesis {
  Riskevidencesynthesis(
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
    status: r4valuesets.Publicationstatus,
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    note: List(Annotation),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
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
    synthesis_type: Option(Codeableconcept),
    study_type: Option(Codeableconcept),
    population: Reference,
    exposure: Option(Reference),
    outcome: Reference,
    sample_size: Option(RiskevidencesynthesisSamplesize),
    risk_estimate: Option(RiskevidencesynthesisRiskestimate),
    certainty: List(RiskevidencesynthesisCertainty),
  )
}

pub fn riskevidencesynthesis_new(
  outcome outcome: Reference,
  population population: Reference,
  status status: r4valuesets.Publicationstatus,
) -> Riskevidencesynthesis {
  Riskevidencesynthesis(
    certainty: [],
    risk_estimate: None,
    sample_size: None,
    outcome:,
    exposure: None,
    population:,
    study_type: None,
    synthesis_type: None,
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
    jurisdiction: [],
    use_context: [],
    note: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisSamplesize {
  RiskevidencesynthesisSamplesize(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    number_of_studies: Option(Int),
    number_of_participants: Option(Int),
  )
}

pub fn riskevidencesynthesis_samplesize_new() -> RiskevidencesynthesisSamplesize {
  RiskevidencesynthesisSamplesize(
    number_of_participants: None,
    number_of_studies: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisRiskestimate {
  RiskevidencesynthesisRiskestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    type_: Option(Codeableconcept),
    value: Option(Float),
    unit_of_measure: Option(Codeableconcept),
    denominator_count: Option(Int),
    numerator_count: Option(Int),
    precision_estimate: List(RiskevidencesynthesisRiskestimatePrecisionestimate),
  )
}

pub fn riskevidencesynthesis_riskestimate_new() -> RiskevidencesynthesisRiskestimate {
  RiskevidencesynthesisRiskestimate(
    precision_estimate: [],
    numerator_count: None,
    denominator_count: None,
    unit_of_measure: None,
    value: None,
    type_: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisRiskestimatePrecisionestimate {
  RiskevidencesynthesisRiskestimatePrecisionestimate(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    level: Option(Float),
    from: Option(Float),
    to: Option(Float),
  )
}

pub fn riskevidencesynthesis_riskestimate_precisionestimate_new() -> RiskevidencesynthesisRiskestimatePrecisionestimate {
  RiskevidencesynthesisRiskestimatePrecisionestimate(
    to: None,
    from: None,
    level: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisCertainty {
  RiskevidencesynthesisCertainty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    rating: List(Codeableconcept),
    note: List(Annotation),
    certainty_subcomponent: List(
      RiskevidencesynthesisCertaintyCertaintysubcomponent,
    ),
  )
}

pub fn riskevidencesynthesis_certainty_new() -> RiskevidencesynthesisCertainty {
  RiskevidencesynthesisCertainty(
    certainty_subcomponent: [],
    note: [],
    rating: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RiskEvidenceSynthesis#resource
pub type RiskevidencesynthesisCertaintyCertaintysubcomponent {
  RiskevidencesynthesisCertaintyCertaintysubcomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    rating: List(Codeableconcept),
    note: List(Annotation),
  )
}

pub fn riskevidencesynthesis_certainty_certaintysubcomponent_new() -> RiskevidencesynthesisCertaintyCertaintysubcomponent {
  RiskevidencesynthesisCertaintyCertaintysubcomponent(
    note: [],
    rating: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Schedule#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SearchParameter#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: String,
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    code: String,
    base: List(r4valuesets.Resourcetypes),
    type_: r4valuesets.Searchparamtype,
    expression: Option(String),
    xpath: Option(String),
    xpath_usage: Option(r4valuesets.Searchxpathusage),
    target: List(r4valuesets.Resourcetypes),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(r4valuesets.Searchcomparator),
    modifier: List(r4valuesets.Searchmodifiercode),
    chain: List(String),
    component: List(SearchparameterComponent),
  )
}

pub fn searchparameter_new(
  type_ type_: r4valuesets.Searchparamtype,
  code code: String,
  description description: String,
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/SearchParameter#resource
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
  expression expression: String,
  definition definition: String,
) -> SearchparameterComponent {
  SearchparameterComponent(
    expression:,
    definition:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ServiceRequest#resource
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
    status: r4valuesets.Requeststatus,
    intent: r4valuesets.Requestintent,
    category: List(Codeableconcept),
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/ServiceRequest#resource
pub type ServicerequestQuantity {
  ServicerequestQuantityQuantity(quantity: Quantity)
  ServicerequestQuantityRatio(quantity: Ratio)
  ServicerequestQuantityRange(quantity: Range)
}

///http://hl7.org/fhir/r4/StructureDefinition/ServiceRequest#resource
pub type ServicerequestOccurrence {
  ServicerequestOccurrenceDatetime(occurrence: String)
  ServicerequestOccurrencePeriod(occurrence: Period)
  ServicerequestOccurrenceTiming(occurrence: Timing)
}

///http://hl7.org/fhir/r4/StructureDefinition/ServiceRequest#resource
pub type ServicerequestAsneeded {
  ServicerequestAsneededBoolean(as_needed: Bool)
  ServicerequestAsneededCodeableconcept(as_needed: Codeableconcept)
}

pub fn servicerequest_new(
  subject subject: Reference,
  intent intent: r4valuesets.Requestintent,
  status status: r4valuesets.Requeststatus,
) -> Servicerequest {
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

///http://hl7.org/fhir/r4/StructureDefinition/Slot#resource
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
    status: r4valuesets.Slotstatus,
    start: String,
    end: String,
    overbooked: Option(Bool),
    comment: Option(String),
  )
}

pub fn slot_new(
  end end: String,
  start start: String,
  status status: r4valuesets.Slotstatus,
  schedule schedule: Reference,
) -> Slot {
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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
    status: Option(r4valuesets.Specimenstatus),
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
pub type SpecimenCollectionCollected {
  SpecimenCollectionCollectedDatetime(collected: String)
  SpecimenCollectionCollectedPeriod(collected: Period)
}

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Specimen#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    is_derived: Option(Bool),
    type_: Option(Codeableconcept),
    preference: r4valuesets.Specimencontainedpreference,
    container: Option(SpecimendefinitionTypetestedContainer),
    requirement: Option(String),
    retention_time: Option(Duration),
    rejection_criterion: List(Codeableconcept),
    handling: List(SpecimendefinitionTypetestedHandling),
  )
}

pub fn specimendefinition_typetested_new(
  preference preference: r4valuesets.Specimencontainedpreference,
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditive {
  SpecimendefinitionTypetestedContainerAdditive(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    additive: SpecimendefinitionTypetestedContainerAdditiveAdditive,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetestedContainerAdditiveAdditive {
  SpecimendefinitionTypetestedContainerAdditiveAdditiveCodeableconcept(
    additive: Codeableconcept,
  )
  SpecimendefinitionTypetestedContainerAdditiveAdditiveReference(
    additive: Reference,
  )
}

pub fn specimendefinition_typetested_container_additive_new(
  additive additive: SpecimendefinitionTypetestedContainerAdditiveAdditive,
) -> SpecimendefinitionTypetestedContainerAdditive {
  SpecimendefinitionTypetestedContainerAdditive(
    additive:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
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
    status: r4valuesets.Publicationstatus,
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
    fhir_version: Option(r4valuesets.Fhirversion),
    mapping: List(StructuredefinitionMapping),
    kind: r4valuesets.Structuredefinitionkind,
    abstract: Bool,
    context: List(StructuredefinitionContext),
    context_invariant: List(String),
    type_: String,
    base_definition: Option(String),
    derivation: Option(r4valuesets.Typederivationrule),
    snapshot: Option(StructuredefinitionSnapshot),
    differential: Option(StructuredefinitionDifferential),
  )
}

pub fn structuredefinition_new(
  type_ type_: String,
  abstract abstract: Bool,
  kind kind: r4valuesets.Structuredefinitionkind,
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
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

pub fn structuredefinition_mapping_new(
  identity identity: String,
) -> StructuredefinitionMapping {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Extensioncontexttype,
    expression: String,
  )
}

pub fn structuredefinition_context_new(
  expression expression: String,
  type_ type_: r4valuesets.Extensioncontexttype,
) -> StructuredefinitionContext {
  StructuredefinitionContext(
    expression:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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
    status: r4valuesets.Publicationstatus,
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

pub fn structuremap_new(
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
) -> Structuremap {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapStructure {
  StructuremapStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    mode: r4valuesets.Mapmodelmode,
    alias: Option(String),
    documentation: Option(String),
  )
}

pub fn structuremap_structure_new(
  mode mode: r4valuesets.Mapmodelmode,
  url url: String,
) -> StructuremapStructure {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroup {
  StructuremapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    extends: Option(String),
    type_mode: r4valuesets.Mapgrouptypemode,
    documentation: Option(String),
    input: List(StructuremapGroupInput),
    rule: List(StructuremapGroupRule),
  )
}

pub fn structuremap_group_new(
  type_mode type_mode: r4valuesets.Mapgrouptypemode,
  name name: String,
) -> StructuremapGroup {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroupInput {
  StructuremapGroupInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: Option(String),
    mode: r4valuesets.Mapinputmode,
    documentation: Option(String),
  )
}

pub fn structuremap_group_input_new(
  mode mode: r4valuesets.Mapinputmode,
  name name: String,
) -> StructuremapGroupInput {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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

pub fn structuremap_group_rule_new(name name: String) -> StructuremapGroupRule {
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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
    list_mode: Option(r4valuesets.Mapsourcelistmode),
    variable: Option(String),
    condition: Option(String),
    check: Option(String),
    log_message: Option(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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
  context context: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(String),
    context_type: Option(r4valuesets.Mapcontexttype),
    element: Option(String),
    variable: Option(String),
    list_mode: List(r4valuesets.Maptargetlistmode),
    list_rule_id: Option(String),
    transform: Option(r4valuesets.Maptransform),
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameter {
  StructuremapGroupRuleTargetParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: StructuremapGroupRuleTargetParameterValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTargetParameterValue {
  StructuremapGroupRuleTargetParameterValueId(value: String)
  StructuremapGroupRuleTargetParameterValueString(value: String)
  StructuremapGroupRuleTargetParameterValueBoolean(value: Bool)
  StructuremapGroupRuleTargetParameterValueInteger(value: Int)
  StructuremapGroupRuleTargetParameterValueDecimal(value: Float)
}

pub fn structuremap_group_rule_target_parameter_new(
  value value: StructuremapGroupRuleTargetParameterValue,
) -> StructuremapGroupRuleTargetParameter {
  StructuremapGroupRuleTargetParameter(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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
  name name: String,
) -> StructuremapGroupRuleDependent {
  StructuremapGroupRuleDependent(
    variable: [],
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Subscription#resource
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
    status: r4valuesets.Subscriptionstatus,
    contact: List(Contactpoint),
    end: Option(String),
    reason: String,
    criteria: String,
    error: Option(String),
    channel: SubscriptionChannel,
  )
}

pub fn subscription_new(
  channel channel: SubscriptionChannel,
  criteria criteria: String,
  reason reason: String,
  status status: r4valuesets.Subscriptionstatus,
) -> Subscription {
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

///http://hl7.org/fhir/r4/StructureDefinition/Subscription#resource
pub type SubscriptionChannel {
  SubscriptionChannel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Subscriptionchanneltype,
    endpoint: Option(String),
    payload: Option(String),
    header: List(String),
  )
}

pub fn subscription_channel_new(
  type_ type_: r4valuesets.Subscriptionchanneltype,
) -> SubscriptionChannel {
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

///http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
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
    status: Option(r4valuesets.Substancestatus),
    category: List(Codeableconcept),
    code: Codeableconcept,
    description: Option(String),
    instance: List(SubstanceInstance),
    ingredient: List(SubstanceIngredient),
  )
}

pub fn substance_new(code code: Codeableconcept) -> Substance {
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

///http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
pub type SubstanceIngredient {
  SubstanceIngredient(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Ratio),
    substance: SubstanceIngredientSubstance,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Substance#resource
pub type SubstanceIngredientSubstance {
  SubstanceIngredientSubstanceCodeableconcept(substance: Codeableconcept)
  SubstanceIngredientSubstanceReference(substance: Reference)
}

pub fn substance_ingredient_new(
  substance substance: SubstanceIngredientSubstance,
) -> SubstanceIngredient {
  SubstanceIngredient(
    substance:,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
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

pub fn substancenucleicacid_new() -> Substancenucleicacid {
  Substancenucleicacid(
    subunit: [],
    oligo_nucleotide_type: None,
    area_of_hybridisation: None,
    number_of_subunits: None,
    sequence_type: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
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

pub fn substancenucleicacid_subunit_new() -> SubstancenucleicacidSubunit {
  SubstancenucleicacidSubunit(
    sugar: [],
    linkage: [],
    three_prime: None,
    five_prime: None,
    sequence_attachment: None,
    length: None,
    sequence: None,
    subunit: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
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

pub fn substancenucleicacid_subunit_linkage_new() -> SubstancenucleicacidSubunitLinkage {
  SubstancenucleicacidSubunitLinkage(
    residue_site: None,
    name: None,
    identifier: None,
    connectivity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceNucleicAcid#resource
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

pub fn substancenucleicacid_subunit_sugar_new() -> SubstancenucleicacidSubunitSugar {
  SubstancenucleicacidSubunitSugar(
    residue_site: None,
    name: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
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
    class: Option(Codeableconcept),
    geometry: Option(Codeableconcept),
    copolymer_connectivity: List(Codeableconcept),
    modification: List(String),
    monomer_set: List(SubstancepolymerMonomerset),
    repeat: List(SubstancepolymerRepeat),
  )
}

pub fn substancepolymer_new() -> Substancepolymer {
  Substancepolymer(
    repeat: [],
    monomer_set: [],
    modification: [],
    copolymer_connectivity: [],
    geometry: None,
    class: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomerset {
  SubstancepolymerMonomerset(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    ratio_type: Option(Codeableconcept),
    starting_material: List(SubstancepolymerMonomersetStartingmaterial),
  )
}

pub fn substancepolymer_monomerset_new() -> SubstancepolymerMonomerset {
  SubstancepolymerMonomerset(
    starting_material: [],
    ratio_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerMonomersetStartingmaterial {
  SubstancepolymerMonomersetStartingmaterial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    material: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    is_defining: Option(Bool),
    amount: Option(Substanceamount),
  )
}

pub fn substancepolymer_monomerset_startingmaterial_new() -> SubstancepolymerMonomersetStartingmaterial {
  SubstancepolymerMonomersetStartingmaterial(
    amount: None,
    is_defining: None,
    type_: None,
    material: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeat {
  SubstancepolymerRepeat(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number_of_units: Option(Int),
    average_molecular_formula: Option(String),
    repeat_unit_amount_type: Option(Codeableconcept),
    repeat_unit: List(SubstancepolymerRepeatRepeatunit),
  )
}

pub fn substancepolymer_repeat_new() -> SubstancepolymerRepeat {
  SubstancepolymerRepeat(
    repeat_unit: [],
    repeat_unit_amount_type: None,
    average_molecular_formula: None,
    number_of_units: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunit {
  SubstancepolymerRepeatRepeatunit(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    orientation_of_polymerisation: Option(Codeableconcept),
    repeat_unit: Option(String),
    amount: Option(Substanceamount),
    degree_of_polymerisation: List(
      SubstancepolymerRepeatRepeatunitDegreeofpolymerisation,
    ),
    structural_representation: List(
      SubstancepolymerRepeatRepeatunitStructuralrepresentation,
    ),
  )
}

pub fn substancepolymer_repeat_repeatunit_new() -> SubstancepolymerRepeatRepeatunit {
  SubstancepolymerRepeatRepeatunit(
    structural_representation: [],
    degree_of_polymerisation: [],
    amount: None,
    repeat_unit: None,
    orientation_of_polymerisation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitDegreeofpolymerisation {
  SubstancepolymerRepeatRepeatunitDegreeofpolymerisation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    degree: Option(Codeableconcept),
    amount: Option(Substanceamount),
  )
}

pub fn substancepolymer_repeat_repeatunit_degreeofpolymerisation_new() -> SubstancepolymerRepeatRepeatunitDegreeofpolymerisation {
  SubstancepolymerRepeatRepeatunitDegreeofpolymerisation(
    amount: None,
    degree: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstancePolymer#resource
pub type SubstancepolymerRepeatRepeatunitStructuralrepresentation {
  SubstancepolymerRepeatRepeatunitStructuralrepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    attachment: Option(Attachment),
  )
}

pub fn substancepolymer_repeat_repeatunit_structuralrepresentation_new() -> SubstancepolymerRepeatRepeatunitStructuralrepresentation {
  SubstancepolymerRepeatRepeatunitStructuralrepresentation(
    attachment: None,
    representation: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceProtein#resource
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

pub fn substanceprotein_new() -> Substanceprotein {
  Substanceprotein(
    subunit: [],
    disulfide_linkage: [],
    number_of_subunits: None,
    sequence_type: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceProtein#resource
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

pub fn substanceprotein_subunit_new() -> SubstanceproteinSubunit {
  SubstanceproteinSubunit(
    c_terminal_modification: None,
    c_terminal_modification_id: None,
    n_terminal_modification: None,
    n_terminal_modification_id: None,
    sequence_attachment: None,
    length: None,
    sequence: None,
    subunit: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
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
    classification: List(SubstancereferenceinformationClassification),
    target: List(SubstancereferenceinformationTarget),
  )
}

pub fn substancereferenceinformation_new() -> Substancereferenceinformation {
  Substancereferenceinformation(
    target: [],
    classification: [],
    gene_element: [],
    gene: [],
    comment: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
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

pub fn substancereferenceinformation_gene_new() -> SubstancereferenceinformationGene {
  SubstancereferenceinformationGene(
    source: [],
    gene: None,
    gene_sequence_origin: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
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

pub fn substancereferenceinformation_geneelement_new() -> SubstancereferenceinformationGeneelement {
  SubstancereferenceinformationGeneelement(
    source: [],
    element: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationClassification {
  SubstancereferenceinformationClassification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    domain: Option(Codeableconcept),
    classification: Option(Codeableconcept),
    subtype: List(Codeableconcept),
    source: List(Reference),
  )
}

pub fn substancereferenceinformation_classification_new() -> SubstancereferenceinformationClassification {
  SubstancereferenceinformationClassification(
    source: [],
    subtype: [],
    classification: None,
    domain: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceReferenceInformation#resource
pub type SubstancereferenceinformationTargetAmount {
  SubstancereferenceinformationTargetAmountQuantity(amount: Quantity)
  SubstancereferenceinformationTargetAmountRange(amount: Range)
  SubstancereferenceinformationTargetAmountString(amount: String)
}

pub fn substancereferenceinformation_target_new() -> SubstancereferenceinformationTarget {
  SubstancereferenceinformationTarget(
    source: [],
    amount_type: None,
    amount: None,
    organism_type: None,
    organism: None,
    interaction: None,
    type_: None,
    target: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
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

pub fn substancesourcematerial_new() -> Substancesourcematerial {
  Substancesourcematerial(
    part_description: [],
    organism: None,
    fraction_description: [],
    development_stage: None,
    geographical_location: [],
    country_of_origin: [],
    parent_substance_name: [],
    parent_substance_id: [],
    organism_name: None,
    organism_id: None,
    source_material_state: None,
    source_material_type: None,
    source_material_class: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialFractiondescription {
  SubstancesourcematerialFractiondescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    fraction: Option(String),
    material_type: Option(Codeableconcept),
  )
}

pub fn substancesourcematerial_fractiondescription_new() -> SubstancesourcematerialFractiondescription {
  SubstancesourcematerialFractiondescription(
    material_type: None,
    fraction: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
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

pub fn substancesourcematerial_organism_new() -> SubstancesourcematerialOrganism {
  SubstancesourcematerialOrganism(
    organism_general: None,
    hybrid: None,
    author: [],
    intraspecific_description: None,
    intraspecific_type: None,
    species: None,
    genus: None,
    family: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialOrganismAuthor {
  SubstancesourcematerialOrganismAuthor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    author_type: Option(Codeableconcept),
    author_description: Option(String),
  )
}

pub fn substancesourcematerial_organism_author_new() -> SubstancesourcematerialOrganismAuthor {
  SubstancesourcematerialOrganismAuthor(
    author_description: None,
    author_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
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

pub fn substancesourcematerial_organism_hybrid_new() -> SubstancesourcematerialOrganismHybrid {
  SubstancesourcematerialOrganismHybrid(
    hybrid_type: None,
    paternal_organism_name: None,
    paternal_organism_id: None,
    maternal_organism_name: None,
    maternal_organism_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
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

pub fn substancesourcematerial_organism_organismgeneral_new() -> SubstancesourcematerialOrganismOrganismgeneral {
  SubstancesourcematerialOrganismOrganismgeneral(
    order: None,
    class: None,
    phylum: None,
    kingdom: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSourceMaterial#resource
pub type SubstancesourcematerialPartdescription {
  SubstancesourcematerialPartdescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    part: Option(Codeableconcept),
    part_location: Option(Codeableconcept),
  )
}

pub fn substancesourcematerial_partdescription_new() -> SubstancesourcematerialPartdescription {
  SubstancesourcematerialPartdescription(
    part_location: None,
    part: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type Substancespecification {
  Substancespecification(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
    text: Option(Narrative),
    contained: List(Resource),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    type_: Option(Codeableconcept),
    status: Option(Codeableconcept),
    domain: Option(Codeableconcept),
    description: Option(String),
    source: List(Reference),
    comment: Option(String),
    moiety: List(SubstancespecificationMoiety),
    property: List(SubstancespecificationProperty),
    reference_information: Option(Reference),
    structure: Option(SubstancespecificationStructure),
    code: List(SubstancespecificationCode),
    name: List(SubstancespecificationName),
    molecular_weight: List(Nil),
    relationship: List(SubstancespecificationRelationship),
    nucleic_acid: Option(Reference),
    polymer: Option(Reference),
    protein: Option(Reference),
    source_material: Option(Reference),
  )
}

pub fn substancespecification_new() -> Substancespecification {
  Substancespecification(
    source_material: None,
    protein: None,
    polymer: None,
    nucleic_acid: None,
    relationship: [],
    molecular_weight: [],
    name: [],
    code: [],
    structure: None,
    reference_information: None,
    property: [],
    moiety: [],
    comment: None,
    source: [],
    description: None,
    domain: None,
    status: None,
    type_: None,
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationMoiety {
  SubstancespecificationMoiety(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(Codeableconcept),
    identifier: Option(Identifier),
    name: Option(String),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    amount: Option(SubstancespecificationMoietyAmount),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationMoietyAmount {
  SubstancespecificationMoietyAmountQuantity(amount: Quantity)
  SubstancespecificationMoietyAmountString(amount: String)
}

pub fn substancespecification_moiety_new() -> SubstancespecificationMoiety {
  SubstancespecificationMoiety(
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationProperty {
  SubstancespecificationProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(Codeableconcept),
    code: Option(Codeableconcept),
    parameters: Option(String),
    defining_substance: Option(SubstancespecificationPropertyDefiningsubstance),
    amount: Option(SubstancespecificationPropertyAmount),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationPropertyDefiningsubstance {
  SubstancespecificationPropertyDefiningsubstanceReference(
    defining_substance: Reference,
  )
  SubstancespecificationPropertyDefiningsubstanceCodeableconcept(
    defining_substance: Codeableconcept,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationPropertyAmount {
  SubstancespecificationPropertyAmountQuantity(amount: Quantity)
  SubstancespecificationPropertyAmountString(amount: String)
}

pub fn substancespecification_property_new() -> SubstancespecificationProperty {
  SubstancespecificationProperty(
    amount: None,
    defining_substance: None,
    parameters: None,
    code: None,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructure {
  SubstancespecificationStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    stereochemistry: Option(Codeableconcept),
    optical_activity: Option(Codeableconcept),
    molecular_formula: Option(String),
    molecular_formula_by_moiety: Option(String),
    isotope: List(SubstancespecificationStructureIsotope),
    molecular_weight: Option(Nil),
    source: List(Reference),
    representation: List(SubstancespecificationStructureRepresentation),
  )
}

pub fn substancespecification_structure_new() -> SubstancespecificationStructure {
  SubstancespecificationStructure(
    representation: [],
    source: [],
    molecular_weight: None,
    isotope: [],
    molecular_formula_by_moiety: None,
    molecular_formula: None,
    optical_activity: None,
    stereochemistry: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureIsotope {
  SubstancespecificationStructureIsotope(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Option(Identifier),
    name: Option(Codeableconcept),
    substitution: Option(Codeableconcept),
    half_life: Option(Quantity),
    molecular_weight: Option(
      SubstancespecificationStructureIsotopeMolecularweight,
    ),
  )
}

pub fn substancespecification_structure_isotope_new() -> SubstancespecificationStructureIsotope {
  SubstancespecificationStructureIsotope(
    molecular_weight: None,
    half_life: None,
    substitution: None,
    name: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureIsotopeMolecularweight {
  SubstancespecificationStructureIsotopeMolecularweight(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: Option(Codeableconcept),
    type_: Option(Codeableconcept),
    amount: Option(Quantity),
  )
}

pub fn substancespecification_structure_isotope_molecularweight_new() -> SubstancespecificationStructureIsotopeMolecularweight {
  SubstancespecificationStructureIsotopeMolecularweight(
    amount: None,
    type_: None,
    method: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationStructureRepresentation {
  SubstancespecificationStructureRepresentation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Codeableconcept),
    representation: Option(String),
    attachment: Option(Attachment),
  )
}

pub fn substancespecification_structure_representation_new() -> SubstancespecificationStructureRepresentation {
  SubstancespecificationStructureRepresentation(
    attachment: None,
    representation: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationCode {
  SubstancespecificationCode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    status: Option(Codeableconcept),
    status_date: Option(String),
    comment: Option(String),
    source: List(Reference),
  )
}

pub fn substancespecification_code_new() -> SubstancespecificationCode {
  SubstancespecificationCode(
    source: [],
    comment: None,
    status_date: None,
    status: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationName {
  SubstancespecificationName(
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
    official: List(SubstancespecificationNameOfficial),
    source: List(Reference),
  )
}

pub fn substancespecification_name_new(
  name name: String,
) -> SubstancespecificationName {
  SubstancespecificationName(
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

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationNameOfficial {
  SubstancespecificationNameOfficial(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    authority: Option(Codeableconcept),
    status: Option(Codeableconcept),
    date: Option(String),
  )
}

pub fn substancespecification_name_official_new() -> SubstancespecificationNameOfficial {
  SubstancespecificationNameOfficial(
    date: None,
    status: None,
    authority: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationRelationship {
  SubstancespecificationRelationship(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    substance: Option(SubstancespecificationRelationshipSubstance),
    relationship: Option(Codeableconcept),
    is_defining: Option(Bool),
    amount: Option(SubstancespecificationRelationshipAmount),
    amount_ratio_low_limit: Option(Ratio),
    amount_type: Option(Codeableconcept),
    source: List(Reference),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationRelationshipSubstance {
  SubstancespecificationRelationshipSubstanceReference(substance: Reference)
  SubstancespecificationRelationshipSubstanceCodeableconcept(
    substance: Codeableconcept,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SubstanceSpecification#resource
pub type SubstancespecificationRelationshipAmount {
  SubstancespecificationRelationshipAmountQuantity(amount: Quantity)
  SubstancespecificationRelationshipAmountRange(amount: Range)
  SubstancespecificationRelationshipAmountRatio(amount: Ratio)
  SubstancespecificationRelationshipAmountString(amount: String)
}

pub fn substancespecification_relationship_new() -> SubstancespecificationRelationship {
  SubstancespecificationRelationship(
    source: [],
    amount_type: None,
    amount_ratio_low_limit: None,
    amount: None,
    is_defining: None,
    relationship: None,
    substance: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SupplyDelivery#resource
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
    status: Option(r4valuesets.Supplydeliverystatus),
    patient: Option(Reference),
    type_: Option(Codeableconcept),
    supplied_item: Option(SupplydeliverySupplieditem),
    occurrence: Option(SupplydeliveryOccurrence),
    supplier: Option(Reference),
    destination: Option(Reference),
    receiver: List(Reference),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SupplyDelivery#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SupplyDelivery#resource
pub type SupplydeliverySupplieditem {
  SupplydeliverySupplieditem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    quantity: Option(Quantity),
    item: Option(SupplydeliverySupplieditemItem),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SupplyDelivery#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
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
    status: Option(r4valuesets.Supplyrequeststatus),
    category: Option(Codeableconcept),
    priority: Option(r4valuesets.Requestpriority),
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

///http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestItem {
  SupplyrequestItemCodeableconcept(item: Codeableconcept)
  SupplyrequestItemReference(item: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestOccurrence {
  SupplyrequestOccurrenceDatetime(occurrence: String)
  SupplyrequestOccurrencePeriod(occurrence: Period)
  SupplyrequestOccurrenceTiming(occurrence: Timing)
}

pub fn supplyrequest_new(
  quantity quantity: Quantity,
  item item: SupplyrequestItem,
) -> Supplyrequest {
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

///http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
pub type SupplyrequestParameter {
  SupplyrequestParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(Codeableconcept),
    value: Option(SupplyrequestParameterValue),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/SupplyRequest#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
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
    status: r4valuesets.Taskstatus,
    status_reason: Option(Codeableconcept),
    business_status: Option(Codeableconcept),
    intent: r4valuesets.Taskintent,
    priority: Option(r4valuesets.Requestpriority),
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

pub fn task_new(
  intent intent: r4valuesets.Taskintent,
  status status: r4valuesets.Taskstatus,
) -> Task {
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

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
pub type TaskInput {
  TaskInput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskInputValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
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

pub fn task_input_new(
  value value: TaskInputValue,
  type_ type_: Codeableconcept,
) -> TaskInput {
  TaskInput(value:, type_:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
pub type TaskOutput {
  TaskOutput(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Codeableconcept,
    value: TaskOutputValue,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Task#resource
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

pub fn task_output_new(
  value value: TaskOutputValue,
  type_ type_: Codeableconcept,
) -> TaskOutput {
  TaskOutput(value:, type_:, modifier_extension: [], extension: [], id: None)
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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
    status: r4valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: String,
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    copyright: Option(String),
    kind: r4valuesets.Capabilitystatementkind,
    software: Option(TerminologycapabilitiesSoftware),
    implementation: Option(TerminologycapabilitiesImplementation),
    locked_date: Option(Bool),
    code_system: List(TerminologycapabilitiesCodesystem),
    expansion: Option(TerminologycapabilitiesExpansion),
    code_search: Option(r4valuesets.Codesearchsupport),
    validate_code: Option(TerminologycapabilitiesValidatecode),
    translation: Option(TerminologycapabilitiesTranslation),
    closure: Option(TerminologycapabilitiesClosure),
  )
}

pub fn terminologycapabilities_new(
  kind kind: r4valuesets.Capabilitystatementkind,
  date date: String,
  status status: r4valuesets.Publicationstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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
  name name: String,
) -> TerminologycapabilitiesSoftware {
  TerminologycapabilitiesSoftware(
    version: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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
  description description: String,
) -> TerminologycapabilitiesImplementation {
  TerminologycapabilitiesImplementation(
    url: None,
    description:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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
  code code: String,
) -> TerminologycapabilitiesCodesystemVersionFilter {
  TerminologycapabilitiesCodesystemVersionFilter(
    op: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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
  name name: String,
) -> TerminologycapabilitiesExpansionParameter {
  TerminologycapabilitiesExpansionParameter(
    documentation: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translations: Bool,
  )
}

pub fn terminologycapabilities_validatecode_new(
  translations translations: Bool,
) -> TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    translations:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesTranslation {
  TerminologycapabilitiesTranslation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    needs_map: Bool,
  )
}

pub fn terminologycapabilities_translation_new(
  needs_map needs_map: Bool,
) -> TerminologycapabilitiesTranslation {
  TerminologycapabilitiesTranslation(
    needs_map:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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
    status: r4valuesets.Reportstatuscodes,
    test_script: Reference,
    result: r4valuesets.Reportresultcodes,
    score: Option(Float),
    tester: Option(String),
    issued: Option(String),
    participant: List(TestreportParticipant),
    setup: Option(TestreportSetup),
    test_: List(TestreportTest),
    teardown: Option(TestreportTeardown),
  )
}

pub fn testreport_new(
  result result: r4valuesets.Reportresultcodes,
  test_script test_script: Reference,
  status status: r4valuesets.Reportstatuscodes,
) -> Testreport {
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportParticipant {
  TestreportParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r4valuesets.Reportparticipanttype,
    uri: String,
    display: Option(String),
  )
}

pub fn testreport_participant_new(
  uri uri: String,
  type_ type_: r4valuesets.Reportparticipanttype,
) -> TestreportParticipant {
  TestreportParticipant(
    display: None,
    uri:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportSetupActionOperation {
  TestreportSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r4valuesets.Reportactionresultcodes,
    message: Option(String),
    detail: Option(String),
  )
}

pub fn testreport_setup_action_operation_new(
  result result: r4valuesets.Reportactionresultcodes,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r4valuesets.Reportactionresultcodes,
    message: Option(String),
    detail: Option(String),
  )
}

pub fn testreport_setup_action_assert_new(
  result result: r4valuesets.Reportactionresultcodes,
) -> TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    detail: None,
    message: None,
    result:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportTeardownAction {
  TestreportTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

pub fn testreport_teardown_action_new(
  operation operation: Nil,
) -> TestreportTeardownAction {
  TestreportTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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
    status: r4valuesets.Publicationstatus,
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

pub fn testscript_new(
  status status: r4valuesets.Publicationstatus,
  name name: String,
  url url: String,
) -> Testscript {
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptOrigin {
  TestscriptOrigin(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
  )
}

pub fn testscript_origin_new(
  profile profile: Coding,
  index index: Int,
) -> TestscriptOrigin {
  TestscriptOrigin(
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptDestination {
  TestscriptDestination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    index: Int,
    profile: Coding,
  )
}

pub fn testscript_destination_new(
  profile profile: Coding,
  index index: Int,
) -> TestscriptDestination {
  TestscriptDestination(
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptMetadataLink {
  TestscriptMetadataLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    description: Option(String),
  )
}

pub fn testscript_metadata_link_new(url url: String) -> TestscriptMetadataLink {
  TestscriptMetadataLink(
    description: None,
    url:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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
  capabilities capabilities: String,
  validated validated: Bool,
  required required: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

pub fn testscript_fixture_new(
  autodelete autodelete: Bool,
  autocreate autocreate: Bool,
) -> TestscriptFixture {
  TestscriptFixture(
    resource: None,
    autodelete:,
    autocreate:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

pub fn testscript_variable_new(name name: String) -> TestscriptVariable {
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionOperation {
  TestscriptSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(Coding),
    resource: Option(r4valuesets.Definedtypes),
    label: Option(String),
    description: Option(String),
    accept: Option(String),
    content_type: Option(String),
    destination: Option(Int),
    encode_request_url: Bool,
    method: Option(r4valuesets.Httpoperations),
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
  encode_request_url encode_request_url: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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
  value value: String,
  field field: String,
) -> TestscriptSetupActionOperationRequestheader {
  TestscriptSetupActionOperationRequestheader(
    value:,
    field:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    label: Option(String),
    description: Option(String),
    direction: Option(r4valuesets.Assertdirectioncodes),
    compare_to_source_id: Option(String),
    compare_to_source_expression: Option(String),
    compare_to_source_path: Option(String),
    content_type: Option(String),
    expression: Option(String),
    header_field: Option(String),
    minimum_id: Option(String),
    navigation_links: Option(Bool),
    operator: Option(r4valuesets.Assertoperatorcodes),
    path: Option(String),
    request_method: Option(r4valuesets.Httpoperations),
    request_url: Option(String),
    resource: Option(r4valuesets.Definedtypes),
    response: Option(r4valuesets.Assertresponsecodetypes),
    response_code: Option(String),
    source_id: Option(String),
    validate_profile_id: Option(String),
    value: Option(String),
    warning_only: Bool,
  )
}

pub fn testscript_setup_action_assert_new(
  warning_only warning_only: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptTeardownAction {
  TestscriptTeardownAction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    operation: Nil,
  )
}

pub fn testscript_teardown_action_new(
  operation operation: Nil,
) -> TestscriptTeardownAction {
  TestscriptTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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
    status: r4valuesets.Publicationstatus,
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

pub fn valueset_new(status status: r4valuesets.Publicationstatus) -> Valueset {
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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
  code code: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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
  value value: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    property: String,
    op: r4valuesets.Filteroperator,
    value: String,
  )
}

pub fn valueset_compose_include_filter_new(
  value value: String,
  op op: r4valuesets.Filteroperator,
  property property: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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

pub fn valueset_expansion_new(timestamp timestamp: String) -> ValuesetExpansion {
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    value: Option(ValuesetExpansionParameterValue),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
pub type ValuesetExpansionParameterValue {
  ValuesetExpansionParameterValueString(value: String)
  ValuesetExpansionParameterValueBoolean(value: Bool)
  ValuesetExpansionParameterValueInteger(value: Int)
  ValuesetExpansionParameterValueDecimal(value: Float)
  ValuesetExpansionParameterValueUri(value: String)
  ValuesetExpansionParameterValueCode(value: String)
  ValuesetExpansionParameterValueDatetime(value: String)
}

pub fn valueset_expansion_parameter_new(
  name name: String,
) -> ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/VerificationResult#resource
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
    status: r4valuesets.Verificationresultstatus,
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

pub fn verificationresult_new(
  status status: r4valuesets.Verificationresultstatus,
) -> Verificationresult {
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

///http://hl7.org/fhir/r4/StructureDefinition/VerificationResult#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/VerificationResult#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/VerificationResult#resource
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
  organization organization: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/VisionPrescription#resource
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
    status: r4valuesets.Fmstatus,
    created: String,
    patient: Reference,
    encounter: Option(Reference),
    date_written: String,
    prescriber: Reference,
    lens_specification: List(VisionprescriptionLensspecification),
  )
}

pub fn visionprescription_new(
  prescriber prescriber: Reference,
  date_written date_written: String,
  patient patient: Reference,
  created created: String,
  status status: r4valuesets.Fmstatus,
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

///http://hl7.org/fhir/r4/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecification {
  VisionprescriptionLensspecification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeableconcept,
    eye: r4valuesets.Visioneyecodes,
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
  eye eye: r4valuesets.Visioneyecodes,
  product product: Codeableconcept,
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

///http://hl7.org/fhir/r4/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Float,
    base: r4valuesets.Visionbasecodes,
  )
}

pub fn visionprescription_lensspecification_prism_new(
  base base: r4valuesets.Visionbasecodes,
  amount amount: Float,
) -> VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    base:,
    amount:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}
