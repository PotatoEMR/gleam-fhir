////FHIR r5 types
////https://hl7.org/fhir/r5

import gleam/option.{type Option, None}
import r5valuesets

///http://hl7.org/fhir/r5/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

pub fn element_new() -> Element {
  Element(extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/Address#resource
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r5valuesets.Addressuse),
    type_: Option(r5valuesets.Addresstype),
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

///http://hl7.org/fhir/r5/StructureDefinition/Age#resource
pub type Age {
  Age(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

pub fn annotation_new(text) -> Annotation {
  Annotation(text:, time: None, author: None, extension: [], id: None)
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

pub fn attachment_new() -> Attachment {
  Attachment(
    pages: None,
    duration: None,
    frames: None,
    width: None,
    height: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Availability#resource
pub type Availability {
  Availability(
    id: Option(String),
    extension: List(Extension),
    available_time: List(Element),
    not_available_time: List(Element),
  )
}

pub fn availability_new() -> Availability {
  Availability(
    not_available_time: [],
    available_time: [],
    extension: [],
    id: None,
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

pub fn backbonetype_new() -> Backbonetype {
  Backbonetype(modifier_extension: [], extension: [], id: None)
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

pub fn codeableconcept_new() -> Codeableconcept {
  Codeableconcept(text: None, coding: [], extension: [], id: None)
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

pub fn codeablereference_new() -> Codeablereference {
  Codeablereference(reference: None, concept: None, extension: [], id: None)
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

///http://hl7.org/fhir/r5/StructureDefinition/ContactDetail#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/ContactPoint#resource
pub type Contactpoint {
  Contactpoint(
    id: Option(String),
    extension: List(Extension),
    system: Option(r5valuesets.Contactpointsystem),
    value: Option(String),
    use_: Option(r5valuesets.Contactpointuse),
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

///http://hl7.org/fhir/r5/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: r5valuesets.Contributortype,
    name: String,
    contact: List(Contactdetail),
  )
}

pub fn contributor_new(name, type_) -> Contributor {
  Contributor(contact: [], name:, type_:, extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/Count#resource
pub type Count {
  Count(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r5/StructureDefinition/DataRequirement#resource
pub type Datarequirement {
  Datarequirement(
    id: Option(String),
    extension: List(Extension),
    type_: r5valuesets.Fhirtypes,
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

pub fn datarequirement_new(type_) -> Datarequirement {
  Datarequirement(
    sort: [],
    limit: None,
    value_filter: [],
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

///http://hl7.org/fhir/r5/StructureDefinition/DataType#resource
pub type Datatype {
  Datatype(id: Option(String), extension: List(Extension))
}

pub fn datatype_new() -> Datatype {
  Datatype(extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/Distance#resource
pub type Distance {
  Distance(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

pub fn dosage_new() -> Dosage {
  Dosage(
    max_dose_per_lifetime: None,
    max_dose_per_administration: None,
    max_dose_per_period: [],
    dose_and_rate: [],
    method: None,
    route: None,
    site: None,
    as_needed_for: [],
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

///http://hl7.org/fhir/r5/StructureDefinition/Duration#resource
pub type Duration {
  Duration(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r5/StructureDefinition/ElementDefinition#resource
pub type Elementdefinition {
  Elementdefinition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    path: String,
    representation: List(r5valuesets.Propertyrepresentation),
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

pub fn elementdefinition_new(path) -> Elementdefinition {
  Elementdefinition(
    mapping: [],
    binding: None,
    is_summary: None,
    is_modifier_reason: None,
    is_modifier: None,
    must_support: None,
    value_alternatives: [],
    must_have_value: None,
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

pub fn expression_new() -> Expression {
  Expression(
    reference: None,
    expression: None,
    language: None,
    name: None,
    description: None,
    extension: [],
    id: None,
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

pub fn extendedcontactdetail_new() -> Extendedcontactdetail {
  Extendedcontactdetail(
    period: None,
    organization: None,
    address: None,
    telecom: [],
    name: [],
    purpose: None,
    extension: [],
    id: None,
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

pub fn extension_new(url) -> Extension {
  Extension(value: None, url:, extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/HumanName#resource
pub type Humanname {
  Humanname(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r5valuesets.Nameuse),
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

///http://hl7.org/fhir/r5/StructureDefinition/Identifier#resource
pub type Identifier {
  Identifier(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r5valuesets.Identifieruse),
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

///http://hl7.org/fhir/r5/StructureDefinition/MonetaryComponent#resource
pub type Monetarycomponent {
  Monetarycomponent(
    id: Option(String),
    extension: List(Extension),
    type_: r5valuesets.Pricecomponenttype,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
  )
}

pub fn monetarycomponent_new(type_) -> Monetarycomponent {
  Monetarycomponent(
    amount: None,
    factor: None,
    code: None,
    type_:,
    extension: [],
    id: None,
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

pub fn money_new() -> Money {
  Money(currency: None, value: None, extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: r5valuesets.Narrativestatus,
    div: String,
  )
}

pub fn narrative_new(div, status) -> Narrative {
  Narrative(div:, status:, extension: [], id: None)
}

///http://hl7.org/fhir/r5/StructureDefinition/ParameterDefinition#resource
pub type Parameterdefinition {
  Parameterdefinition(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    use_: r5valuesets.Operationparameteruse,
    min: Option(Int),
    max: Option(String),
    documentation: Option(String),
    type_: r5valuesets.Fhirtypes,
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

///http://hl7.org/fhir/r5/StructureDefinition/Period#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/PrimitiveType#resource
pub type Primitivetype {
  Primitivetype(id: Option(String), extension: List(Extension))
}

pub fn primitivetype_new() -> Primitivetype {
  Primitivetype(extension: [], id: None)
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

pub fn productshelflife_new() -> Productshelflife {
  Productshelflife(
    special_precautions_for_storage: [],
    period: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Quantity#resource
pub type Quantity {
  Quantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r5/StructureDefinition/Range#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Ratio#resource
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

pub fn ratiorange_new() -> Ratiorange {
  Ratiorange(
    denominator: None,
    high_numerator: None,
    low_numerator: None,
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/RelatedArtifact#resource
pub type Relatedartifact {
  Relatedartifact(
    id: Option(String),
    extension: List(Extension),
    type_: r5valuesets.Relatedartifacttype,
    classifier: List(Codeableconcept),
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    document: Option(Attachment),
    resource: Option(String),
    resource_reference: Option(Reference),
    publication_status: Option(r5valuesets.Publicationstatus),
    publication_date: Option(String),
  )
}

pub fn relatedartifact_new(type_) -> Relatedartifact {
  Relatedartifact(
    publication_date: None,
    publication_status: None,
    resource_reference: None,
    resource: None,
    document: None,
    citation: None,
    display: None,
    label: None,
    classifier: [],
    type_:,
    extension: [],
    id: None,
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

pub fn sampleddata_new(dimensions, interval_unit, origin) -> Sampleddata {
  Sampleddata(
    data: None,
    offsets: None,
    code_map: None,
    dimensions:,
    upper_limit: None,
    lower_limit: None,
    factor: None,
    interval_unit:,
    interval: None,
    origin:,
    extension: [],
    id: None,
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

pub fn signature_new() -> Signature {
  Signature(
    data: None,
    sig_format: None,
    target_format: None,
    on_behalf_of: None,
    who: None,
    when: None,
    type_: [],
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: r5valuesets.Triggertype,
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

pub fn triggerdefinition_new(type_) -> Triggerdefinition {
  Triggerdefinition(
    condition: None,
    data: [],
    timing: None,
    subscription_topic: None,
    code: None,
    name: None,
    type_:,
    extension: [],
    id: None,
  )
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

pub fn usagecontext_new(value, code) -> Usagecontext {
  Usagecontext(value:, code:, extension: [], id: None)
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

pub fn virtualservicedetail_new() -> Virtualservicedetail {
  Virtualservicedetail(
    session_key: None,
    max_participants: None,
    additional_info: [],
    address: None,
    channel_type: None,
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MoneyQuantity#resource
pub type Moneyquantity {
  Moneyquantity(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    comparator: Option(r5valuesets.Quantitycomparator),
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

///http://hl7.org/fhir/r5/StructureDefinition/SimpleQuantity#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/Resource#resource
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
    status: r5valuesets.Accountstatus,
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

pub fn account_new(status) -> Account {
  Account(
    calculated_at: None,
    balance: [],
    currency: None,
    related_account: [],
    procedure: [],
    diagnosis: [],
    guarantor: [],
    description: None,
    owner: None,
    coverage: [],
    service_period: None,
    subject: [],
    name: None,
    type_: None,
    billing_status: None,
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

pub fn account_coverage_new(coverage) -> AccountCoverage {
  AccountCoverage(
    priority: None,
    coverage:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn account_diagnosis_new(condition) -> AccountDiagnosis {
  AccountDiagnosis(
    package_code: [],
    on_admission: None,
    type_: [],
    date_of_diagnosis: None,
    condition:,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn account_procedure_new(code) -> AccountProcedure {
  AccountProcedure(
    device: [],
    package_code: [],
    type_: [],
    date_of_service: None,
    code:,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn account_relatedaccount_new(account) -> AccountRelatedaccount {
  AccountRelatedaccount(
    account:,
    relationship: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn account_balance_new(amount) -> AccountBalance {
  AccountBalance(
    amount:,
    estimate: None,
    term: None,
    aggregate: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    kind: Option(r5valuesets.Requestresourcetypes),
    profile: Option(String),
    code: Option(Codeableconcept),
    intent: Option(r5valuesets.Requestintent),
    priority: Option(r5valuesets.Requestpriority),
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
    as_needed: None,
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
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Actionparticipanttype),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
    function: Option(Codeableconcept),
  )
}

pub fn activitydefinition_participant_new() -> ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    function: None,
    role: None,
    type_reference: None,
    type_canonical: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    type_: r5valuesets.Examplescenarioactortype,
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

pub fn actordefinition_new(type_, status) -> Actordefinition {
  Actordefinition(
    derived_from: [],
    capabilities: None,
    reference: [],
    documentation: None,
    type_:,
    copyright_label: None,
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
    version_algorithm: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn administrableproductdefinition_new(
  status,
) -> Administrableproductdefinition {
  Administrableproductdefinition(
    route_of_administration: [],
    property: [],
    description: None,
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
    status: r5valuesets.Adverseeventstatus,
    actuality: r5valuesets.Adverseeventactuality,
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

pub fn adverseevent_new(subject, actuality, status) -> Adverseevent {
  Adverseevent(
    note: [],
    supporting_info: [],
    mitigating_action: [],
    preventive_action: [],
    contributing_factor: [],
    suspect_entity: [],
    expected_in_research_study: None,
    study: [],
    participant: [],
    recorder: None,
    outcome: [],
    seriousness: None,
    location: None,
    resulting_effect: [],
    recorded_date: None,
    detected: None,
    occurrence: None,
    encounter: None,
    subject:,
    code: None,
    category: [],
    actuality:,
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

pub fn adverseevent_participant_new(actor) -> AdverseeventParticipant {
  AdverseeventParticipant(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn adverseevent_suspectentity_new(instance) -> AdverseeventSuspectentity {
  AdverseeventSuspectentity(
    causality: None,
    instance:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn adverseevent_suspectentity_causality_new() -> AdverseeventSuspectentityCausality {
  AdverseeventSuspectentityCausality(
    author: None,
    entity_relatedness: None,
    assessment_method: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn adverseevent_contributingfactor_new(
  item,
) -> AdverseeventContributingfactor {
  AdverseeventContributingfactor(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn adverseevent_preventiveaction_new(item) -> AdverseeventPreventiveaction {
  AdverseeventPreventiveaction(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn adverseevent_mitigatingaction_new(item) -> AdverseeventMitigatingaction {
  AdverseeventMitigatingaction(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn adverseevent_supportinginfo_new(item) -> AdverseeventSupportinginfo {
  AdverseeventSupportinginfo(
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    category: List(r5valuesets.Allergyintolerancecategory),
    criticality: Option(r5valuesets.Allergyintolerancecriticality),
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

pub fn allergyintolerance_new(patient) -> Allergyintolerance {
  Allergyintolerance(
    reaction: [],
    note: [],
    last_occurrence: None,
    participant: [],
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

pub fn allergyintolerance_participant_new(
  actor,
) -> AllergyintoleranceParticipant {
  AllergyintoleranceParticipant(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    severity: Option(r5valuesets.Reactioneventseverity),
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
    status: r5valuesets.Appointmentstatus,
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

pub fn appointment_new(status) -> Appointment {
  Appointment(
    recurrence_template: [],
    occurrence_changed: None,
    recurrence_id: None,
    participant: [],
    subject: None,
    based_on: [],
    patient_instruction: [],
    note: [],
    cancellation_date: None,
    created: None,
    account: [],
    slot: [],
    requested_period: [],
    minutes_duration: None,
    end: None,
    start: None,
    originating_appointment: None,
    previous_appointment: None,
    supporting_information: [],
    virtual_service: [],
    replaces: [],
    description: None,
    priority: None,
    reason: [],
    appointment_type: None,
    specialty: [],
    service_type: [],
    service_category: [],
    class: [],
    cancellation_reason: None,
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
    status: r5valuesets.Participationstatus,
  )
}

pub fn appointment_participant_new(status) -> AppointmentParticipant {
  AppointmentParticipant(
    status:,
    required: None,
    actor: None,
    period: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn appointment_recurrencetemplate_new(
  recurrence_type,
) -> AppointmentRecurrencetemplate {
  AppointmentRecurrencetemplate(
    excluding_recurrence_id: [],
    excluding_date: [],
    yearly_template: None,
    monthly_template: None,
    weekly_template: None,
    occurrence_date: [],
    occurrence_count: None,
    last_occurrence_date: None,
    recurrence_type:,
    timezone: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn appointment_recurrencetemplate_weeklytemplate_new() -> AppointmentRecurrencetemplateWeeklytemplate {
  AppointmentRecurrencetemplateWeeklytemplate(
    week_interval: None,
    sunday: None,
    saturday: None,
    friday: None,
    thursday: None,
    wednesday: None,
    tuesday: None,
    monday: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn appointment_recurrencetemplate_monthlytemplate_new(
  month_interval,
) -> AppointmentRecurrencetemplateMonthlytemplate {
  AppointmentRecurrencetemplateMonthlytemplate(
    month_interval:,
    day_of_week: None,
    nth_week_of_month: None,
    day_of_month: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn appointment_recurrencetemplate_yearlytemplate_new(
  year_interval,
) -> AppointmentRecurrencetemplateYearlytemplate {
  AppointmentRecurrencetemplateYearlytemplate(
    year_interval:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    participant_status: r5valuesets.Appointmentresponsestatus,
    comment: Option(String),
    recurring: Option(Bool),
    occurrence_date: Option(String),
    recurrence_id: Option(Int),
  )
}

pub fn appointmentresponse_new(
  participant_status,
  appointment,
) -> Appointmentresponse {
  Appointmentresponse(
    recurrence_id: None,
    occurrence_date: None,
    recurring: None,
    comment: None,
    participant_status:,
    actor: None,
    participant_type: [],
    end: None,
    start: None,
    proposed_new_time: None,
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
    workflow_status: Option(r5valuesets.Artifactassessmentworkflowstatus),
    disposition: Option(r5valuesets.Artifactassessmentdisposition),
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

pub fn artifactassessment_new(artifact) -> Artifactassessment {
  Artifactassessment(
    disposition: None,
    workflow_status: None,
    content: [],
    artifact:,
    last_review_date: None,
    approval_date: None,
    copyright: None,
    date: None,
    cite_as: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/ArtifactAssessment#resource
pub type ArtifactassessmentContent {
  ArtifactassessmentContent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    information_type: Option(r5valuesets.Artifactassessmentinformationtype),
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

pub fn artifactassessment_content_new() -> ArtifactassessmentContent {
  ArtifactassessmentContent(
    component: [],
    free_to_share: None,
    related_artifact: [],
    path: [],
    author: None,
    quantity: None,
    classifier: [],
    type_: None,
    summary: None,
    information_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    action: Option(r5valuesets.Auditeventaction),
    severity: Option(r5valuesets.Auditeventseverity),
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

pub fn auditevent_new(source, recorded, code) -> Auditevent {
  Auditevent(
    entity: [],
    source:,
    agent: [],
    encounter: None,
    patient: None,
    based_on: [],
    authorization: [],
    outcome: None,
    recorded:,
    occurred: None,
    severity: None,
    action: None,
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

pub fn auditevent_outcome_new(code) -> AuditeventOutcome {
  AuditeventOutcome(
    detail: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn auditevent_agent_new(who) -> AuditeventAgent {
  AuditeventAgent(
    authorization: [],
    network: None,
    policy: [],
    location: None,
    requestor: None,
    who:,
    role: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn auditevent_entity_new() -> AuditeventEntity {
  AuditeventEntity(
    agent: [],
    detail: [],
    query: None,
    security_label: [],
    role: None,
    what: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn auditevent_entity_detail_new(value, type_) -> AuditeventEntityDetail {
  AuditeventEntityDetail(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn biologicallyderivedproduct_new() -> Biologicallyderivedproduct {
  Biologicallyderivedproduct(
    property: [],
    storage_temp_requirements: None,
    collection: None,
    expiration_date: None,
    product_status: None,
    division: None,
    processing_facility: [],
    biological_source_event: None,
    identifier: [],
    request: [],
    parent: [],
    product_code: None,
    product_category: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
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

pub fn biologicallyderivedproduct_property_new(
  value,
  type_,
) -> BiologicallyderivedproductProperty {
  BiologicallyderivedproductProperty(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Biologicallyderivedproductdispensestatus,
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

pub fn biologicallyderivedproductdispense_new(
  patient,
  product,
  status,
) -> Biologicallyderivedproductdispense {
  Biologicallyderivedproductdispense(
    usage_instruction: None,
    note: [],
    destination: None,
    when_handed_over: None,
    prepared_date: None,
    quantity: None,
    location: None,
    performer: [],
    match_status: None,
    patient:,
    product:,
    origin_relationship_type: None,
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

pub fn biologicallyderivedproductdispense_performer_new(
  actor,
) -> BiologicallyderivedproductdispensePerformer {
  BiologicallyderivedproductdispensePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn bodystructure_new(patient) -> Bodystructure {
  Bodystructure(
    patient:,
    image: [],
    description: None,
    excluded_structure: [],
    included_structure: [],
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

pub fn bodystructure_includedstructure_new(
  structure,
) -> BodystructureIncludedstructure {
  BodystructureIncludedstructure(
    qualifier: [],
    spatial_reference: [],
    body_landmark_orientation: [],
    laterality: None,
    structure:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn bodystructure_includedstructure_bodylandmarkorientation_new() -> BodystructureIncludedstructureBodylandmarkorientation {
  BodystructureIncludedstructureBodylandmarkorientation(
    surface_orientation: [],
    distance_from_landmark: [],
    clock_face_position: [],
    landmark_description: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn bodystructure_includedstructure_bodylandmarkorientation_distancefromlandmark_new() -> BodystructureIncludedstructureBodylandmarkorientationDistancefromlandmark {
  BodystructureIncludedstructureBodylandmarkorientationDistancefromlandmark(
    value: [],
    device: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    type_: r5valuesets.Bundletype,
    timestamp: Option(String),
    total: Option(Int),
    link: List(BundleLink),
    entry: List(BundleEntry),
    signature: Option(Signature),
    issues: Option(Resource),
  )
}

pub fn bundle_new(type_) -> Bundle {
  Bundle(
    issues: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleLink {
  BundleLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relation: r5valuesets.Ianalinkrelations,
    url: String,
  )
}

pub fn bundle_link_new(url, relation) -> BundleLink {
  BundleLink(url:, relation:, modifier_extension: [], extension: [], id: None)
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

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Option(r5valuesets.Searchentrymode),
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

///http://hl7.org/fhir/r5/StructureDefinition/Bundle#resource
pub type BundleEntryRequest {
  BundleEntryRequest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    method: r5valuesets.Httpverb,
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
    status: r5valuesets.Publicationstatus,
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

pub fn canonicalresource_new(status) -> Canonicalresource {
  Canonicalresource(
    copyright_label: None,
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
    version_algorithm: None,
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
    status: r5valuesets.Publicationstatus,
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
    kind: r5valuesets.Capabilitystatementkind,
    instantiates: List(String),
    imports: List(String),
    software: Option(CapabilitystatementSoftware),
    implementation: Option(CapabilitystatementImplementation),
    fhir_version: r5valuesets.Fhirversion,
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
    accept_language: [],
    patch_format: [],
    format: [],
    fhir_version:,
    implementation: None,
    software: None,
    imports: [],
    instantiates: [],
    kind:,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRest {
  CapabilitystatementRest(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r5valuesets.Restfulcapabilitymode,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResource {
  CapabilitystatementRestResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Resourcetypes,
    profile: Option(String),
    supported_profile: List(String),
    documentation: Option(String),
    interaction: List(CapabilitystatementRestResourceInteraction),
    versioning: Option(r5valuesets.Versioningpolicy),
    read_history: Option(Bool),
    update_create: Option(Bool),
    conditional_create: Option(Bool),
    conditional_read: Option(r5valuesets.Conditionalreadstatus),
    conditional_update: Option(Bool),
    conditional_patch: Option(Bool),
    conditional_delete: Option(r5valuesets.Conditionaldeletestatus),
    reference_policy: List(r5valuesets.Referencehandlingpolicy),
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
    conditional_patch: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Typerestfulinteraction,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceSearchparam {
  CapabilitystatementRestResourceSearchparam(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    definition: Option(String),
    type_: r5valuesets.Searchparamtype,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Systemrestfulinteraction,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r5valuesets.Eventcapabilitymode,
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

///http://hl7.org/fhir/r5/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementDocument {
  CapabilitystatementDocument(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r5valuesets.Documentmode,
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
    status: r5valuesets.Requeststatus,
    intent: r5valuesets.Careplanintent,
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

pub fn careplan_new(subject, intent, status) -> Careplan {
  Careplan(
    note: [],
    activity: [],
    goal: [],
    supporting_info: [],
    addresses: [],
    care_team: [],
    contributor: [],
    custodian: None,
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

pub fn careplan_activity_new() -> CareplanActivity {
  CareplanActivity(
    planned_activity_reference: None,
    progress: [],
    performed_activity: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Careteamstatus),
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

pub fn careteam_new() -> Careteam {
  Careteam(
    note: [],
    telecom: [],
    managing_organization: [],
    reason: [],
    participant: [],
    period: None,
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

pub fn careteam_participant_new() -> CareteamParticipant {
  CareteamParticipant(
    coverage: None,
    on_behalf_of: None,
    member: None,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Chargeitemstatus,
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

pub fn chargeitem_new(subject, code, status) -> Chargeitem {
  Chargeitem(
    supporting_information: [],
    note: [],
    account: [],
    product: [],
    service: [],
    reason: [],
    entered_date: None,
    enterer: None,
    override_reason: None,
    total_price_component: None,
    unit_price_component: None,
    bodysite: [],
    quantity: None,
    cost_center: None,
    requesting_organization: None,
    performing_organization: None,
    performer: [],
    occurrence: None,
    encounter: None,
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

pub fn chargeitem_performer_new(actor) -> ChargeitemPerformer {
  ChargeitemPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn chargeitemdefinition_new(status) -> Chargeitemdefinition {
  Chargeitemdefinition(
    property_group: [],
    applicability: [],
    instance: [],
    code: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    replaces: [],
    part_of: [],
    derived_from_uri: [],
    title: None,
    name: None,
    version_algorithm: None,
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

pub fn chargeitemdefinition_applicability_new() -> ChargeitemdefinitionApplicability {
  ChargeitemdefinitionApplicability(
    related_artifact: None,
    effective_period: None,
    condition: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn chargeitemdefinition_propertygroup_new() -> ChargeitemdefinitionPropertygroup {
  ChargeitemdefinitionPropertygroup(
    price_component: [],
    applicability: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn citation_new(status) -> Citation {
  Citation(
    cited_artifact: None,
    related_artifact: [],
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
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn citation_summary_new(text) -> CitationSummary {
  CitationSummary(
    text:,
    style: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn citation_classification_new() -> CitationClassification {
  CitationClassification(
    classifier: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn citation_citedartifact_version_new(value) -> CitationCitedartifactVersion {
  CitationCitedartifactVersion(
    base_citation: None,
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Citation#resource
pub type CitationCitedartifactRelatesto {
  CitationCitedartifactRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Relatedartifacttypeall,
    classifier: List(Codeableconcept),
    label: Option(String),
    display: Option(String),
    citation: Option(String),
    document: Option(Attachment),
    resource: Option(String),
    resource_reference: Option(Reference),
  )
}

pub fn citation_citedartifact_relatesto_new(
  type_,
) -> CitationCitedartifactRelatesto {
  CitationCitedartifactRelatesto(
    resource_reference: None,
    resource: None,
    document: None,
    citation: None,
    display: None,
    label: None,
    classifier: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    publication_date_season: None,
    publication_date_text: None,
    article_date: None,
    issue: None,
    volume: None,
    cited_medium: None,
    published_in: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn citation_citedartifact_weblocation_new() -> CitationCitedartifactWeblocation {
  CitationCitedartifactWeblocation(
    url: None,
    classifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn citation_citedartifact_classification_new() -> CitationCitedartifactClassification {
  CitationCitedartifactClassification(
    artifact_assessment: [],
    classifier: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn citation_citedartifact_contributorship_entry_new(
  contributor,
) -> CitationCitedartifactContributorshipEntry {
  CitationCitedartifactContributorshipEntry(
    ranking_order: None,
    corresponding_contact: None,
    contribution_instance: [],
    role: None,
    contribution_type: [],
    affiliation: [],
    forename_initials: None,
    contributor:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r5valuesets.Claimuse,
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

pub fn claim_new(created, patient, use_, type_, status) -> Claim {
  Claim(
    total: None,
    item: [],
    patient_paid: None,
    accident: None,
    insurance: [],
    procedure: [],
    diagnosis: [],
    supporting_info: [],
    care_team: [],
    event: [],
    diagnosis_related_group: None,
    facility: None,
    encounter: [],
    referral: None,
    payee: None,
    original_prescription: None,
    prescription: None,
    related: [],
    funds_reserve: None,
    priority: None,
    provider: None,
    insurer: None,
    enterer: None,
    created:,
    billable_period: None,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    trace_number: [],
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

pub fn claim_payee_new(type_) -> ClaimPayee {
  ClaimPayee(
    party: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claim_event_new(when, type_) -> ClaimEvent {
  ClaimEvent(when:, type_:, modifier_extension: [], extension: [], id: None)
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

pub fn claim_careteam_new(provider, sequence) -> ClaimCareteam {
  ClaimCareteam(
    specialty: None,
    role: None,
    responsible: None,
    provider:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claim_diagnosis_new(diagnosis, sequence) -> ClaimDiagnosis {
  ClaimDiagnosis(
    on_admission: None,
    type_: [],
    diagnosis:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn claim_item_new(sequence) -> ClaimItem {
  ClaimItem(
    detail: [],
    encounter: [],
    body_site: [],
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    request: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    information_sequence: [],
    procedure_sequence: [],
    diagnosis_sequence: [],
    care_team_sequence: [],
    trace_number: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn claim_item_bodysite_new() -> ClaimItemBodysite {
  ClaimItemBodysite(
    sub_site: [],
    site: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claim_item_detail_new(sequence) -> ClaimItemDetail {
  ClaimItemDetail(
    sub_detail: [],
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    program_code: [],
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    trace_number: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claim_item_detail_subdetail_new(sequence) -> ClaimItemDetailSubdetail {
  ClaimItemDetailSubdetail(
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    program_code: [],
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    trace_number: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Fmstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r5valuesets.Claimuse,
    patient: Reference,
    created: String,
    insurer: Option(Reference),
    requestor: Option(Reference),
    request: Option(Reference),
    outcome: r5valuesets.Claimoutcome,
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

pub fn claimresponse_new(
  outcome,
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
    diagnosis_related_group: None,
    encounter: [],
    payee_type: None,
    event: [],
    pre_auth_period: None,
    pre_auth_ref: None,
    disposition: None,
    decision: None,
    outcome:,
    request: None,
    requestor: None,
    insurer: None,
    created:,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    trace_number: [],
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

pub fn claimresponse_event_new(when, type_) -> ClaimresponseEvent {
  ClaimresponseEvent(
    when:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn claimresponse_item_new(item_sequence) -> ClaimresponseItem {
  ClaimresponseItem(
    detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    trace_number: [],
    item_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_item_reviewoutcome_new() -> ClaimresponseItemReviewoutcome {
  ClaimresponseItemReviewoutcome(
    pre_auth_period: None,
    pre_auth_ref: None,
    reason: [],
    decision: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_item_adjudication_new(
  category,
) -> ClaimresponseItemAdjudication {
  ClaimresponseItemAdjudication(
    quantity: None,
    amount: None,
    reason: None,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_item_detail_new(detail_sequence) -> ClaimresponseItemDetail {
  ClaimresponseItemDetail(
    sub_detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    trace_number: [],
    detail_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_item_detail_subdetail_new(
  sub_detail_sequence,
) -> ClaimresponseItemDetailSubdetail {
  ClaimresponseItemDetailSubdetail(
    adjudication: [],
    review_outcome: None,
    note_number: [],
    trace_number: [],
    sub_detail_sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_additem_new() -> ClaimresponseAdditem {
  ClaimresponseAdditem(
    detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    body_site: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    request: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    provider: [],
    trace_number: [],
    subdetail_sequence: [],
    detail_sequence: [],
    item_sequence: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn claimresponse_additem_bodysite_new() -> ClaimresponseAdditemBodysite {
  ClaimresponseAdditemBodysite(
    sub_site: [],
    site: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_additem_detail_new() -> ClaimresponseAdditemDetail {
  ClaimresponseAdditemDetail(
    sub_detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    trace_number: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_additem_detail_subdetail_new() -> ClaimresponseAdditemDetailSubdetail {
  ClaimresponseAdditemDetailSubdetail(
    adjudication: [],
    review_outcome: None,
    note_number: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    trace_number: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_total_new(amount, category) -> ClaimresponseTotal {
  ClaimresponseTotal(
    amount:,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn claimresponse_error_new(code) -> ClaimresponseError {
  ClaimresponseError(
    expression: [],
    code:,
    sub_detail_sequence: None,
    detail_sequence: None,
    item_sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Eventstatus,
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

pub fn clinicalimpression_new(subject, status) -> Clinicalimpression {
  Clinicalimpression(
    note: [],
    supporting_info: [],
    prognosis_reference: [],
    prognosis_codeable_concept: [],
    finding: [],
    summary: None,
    protocol: [],
    change_pattern: None,
    problem: [],
    previous: None,
    performer: None,
    date: None,
    effective: None,
    encounter: None,
    subject:,
    description: None,
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

pub fn clinicalimpression_finding_new() -> ClinicalimpressionFinding {
  ClinicalimpressionFinding(
    basis: None,
    item: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    type_: r5valuesets.Clinicalusedefinitiontype,
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

pub fn clinicalusedefinition_new(type_) -> Clinicalusedefinition {
  Clinicalusedefinition(
    warning: None,
    undesirable_effect: None,
    library: [],
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

pub fn clinicalusedefinition_contraindication_new() -> ClinicalusedefinitionContraindication {
  ClinicalusedefinitionContraindication(
    other_therapy: [],
    applicability: None,
    indication: [],
    comorbidity: [],
    disease_status: None,
    disease_symptom_procedure: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn clinicalusedefinition_contraindication_othertherapy_new(
  treatment,
  relationship_type,
) -> ClinicalusedefinitionContraindicationOthertherapy {
  ClinicalusedefinitionContraindicationOthertherapy(
    treatment:,
    relationship_type:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn clinicalusedefinition_indication_new() -> ClinicalusedefinitionIndication {
  ClinicalusedefinitionIndication(
    other_therapy: [],
    applicability: None,
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

pub fn clinicalusedefinition_warning_new() -> ClinicalusedefinitionWarning {
  ClinicalusedefinitionWarning(
    code: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    hierarchy_meaning: Option(r5valuesets.Codesystemhierarchymeaning),
    compositional: Option(Bool),
    version_needed: Option(Bool),
    content: r5valuesets.Codesystemcontentmode,
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
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemFilter {
  CodesystemFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    description: Option(String),
    operator: List(r5valuesets.Filteroperator),
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

///http://hl7.org/fhir/r5/StructureDefinition/CodeSystem#resource
pub type CodesystemProperty {
  CodesystemProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: r5valuesets.Conceptpropertytype,
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

pub fn codesystem_concept_designation_new(value) -> CodesystemConceptDesignation {
  CodesystemConceptDesignation(
    value:,
    additional_use: [],
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn codesystem_concept_property_new(value, code) -> CodesystemConceptProperty {
  CodesystemConceptProperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Eventstatus,
    status_reason: Option(Codeableconcept),
    category: List(Codeableconcept),
    priority: Option(r5valuesets.Requestpriority),
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

pub fn communication_new(status) -> Communication {
  Communication(
    note: [],
    payload: [],
    reason: [],
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

pub fn communication_payload_new(content) -> CommunicationPayload {
  CommunicationPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Requeststatus,
    status_reason: Option(Codeableconcept),
    intent: r5valuesets.Requestintent,
    category: List(Codeableconcept),
    priority: Option(r5valuesets.Requestpriority),
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

pub fn communicationrequest_new(intent, status) -> Communicationrequest {
  Communicationrequest(
    note: [],
    reason: [],
    information_provider: [],
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
    intent:,
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

pub fn communicationrequest_payload_new(content) -> CommunicationrequestPayload {
  CommunicationrequestPayload(
    content:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Publicationstatus,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    purpose: Option(String),
    code: r5valuesets.Compartmenttype,
    search: Bool,
    resource: List(CompartmentdefinitionResource),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionVersionalgorithm {
  CompartmentdefinitionVersionalgorithmString(version_algorithm: String)
  CompartmentdefinitionVersionalgorithmCoding(version_algorithm: Coding)
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
    title: None,
    name:,
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Resourcetypes,
    param: List(String),
    documentation: Option(String),
    start_param: Option(String),
    end_param: Option(String),
  )
}

pub fn compartmentdefinition_resource_new(code) -> CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    end_param: None,
    start_param: None,
    documentation: None,
    param: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Compositionstatus,
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

pub fn composition_new(title, date, type_, status) -> Composition {
  Composition(
    section: [],
    event: [],
    relates_to: [],
    custodian: None,
    attester: [],
    note: [],
    title:,
    name: None,
    author: [],
    use_context: [],
    date:,
    encounter: None,
    subject: [],
    category: [],
    type_:,
    status:,
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

pub fn composition_event_new() -> CompositionEvent {
  CompositionEvent(
    detail: [],
    period: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn composition_section_new() -> CompositionSection {
  CompositionSection(
    section: [],
    empty_reason: None,
    entry: [],
    ordered_by: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn conceptmap_new(status) -> Conceptmap {
  Conceptmap(
    group: [],
    target_scope: None,
    source_scope: None,
    additional_attribute: [],
    property: [],
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapProperty {
  ConceptmapProperty(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    uri: Option(String),
    description: Option(String),
    type_: r5valuesets.Conceptmappropertytype,
    system: Option(String),
  )
}

pub fn conceptmap_property_new(type_, code) -> ConceptmapProperty {
  ConceptmapProperty(
    system: None,
    type_:,
    description: None,
    uri: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    type_: r5valuesets.Conceptmapattributetype,
  )
}

pub fn conceptmap_additionalattribute_new(
  type_,
  code,
) -> ConceptmapAdditionalattribute {
  ConceptmapAdditionalattribute(
    type_:,
    description: None,
    uri: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn conceptmap_group_new() -> ConceptmapGroup {
  ConceptmapGroup(
    unmapped: None,
    element: [],
    target: None,
    source: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn conceptmap_group_element_new() -> ConceptmapGroupElement {
  ConceptmapGroupElement(
    target: [],
    no_map: None,
    value_set: None,
    display: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    relationship: r5valuesets.Conceptmaprelationship,
    comment: Option(String),
    property: List(ConceptmapGroupElementTargetProperty),
    depends_on: List(ConceptmapGroupElementTargetDependson),
    product: List(Nil),
  )
}

pub fn conceptmap_group_element_target_new(
  relationship,
) -> ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    product: [],
    depends_on: [],
    property: [],
    comment: None,
    relationship:,
    value_set: None,
    display: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn conceptmap_group_element_target_property_new(
  value,
  code,
) -> ConceptmapGroupElementTargetProperty {
  ConceptmapGroupElementTargetProperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn conceptmap_group_element_target_dependson_new(
  attribute,
) -> ConceptmapGroupElementTargetDependson {
  ConceptmapGroupElementTargetDependson(
    value_set: None,
    value: None,
    attribute:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: r5valuesets.Conceptmapunmappedmode,
    code: Option(String),
    display: Option(String),
    value_set: Option(String),
    relationship: Option(r5valuesets.Conceptmaprelationship),
    other_map: Option(String),
  )
}

pub fn conceptmap_group_unmapped_new(mode) -> ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    other_map: None,
    relationship: None,
    value_set: None,
    display: None,
    code: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn condition_new(subject, clinical_status) -> Condition {
  Condition(
    note: [],
    evidence: [],
    stage: [],
    participant: [],
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
    clinical_status:,
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

pub fn condition_participant_new(actor) -> ConditionParticipant {
  ConditionParticipant(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn conditiondefinition_new(code, status) -> Conditiondefinition {
  Conditiondefinition(
    plan: [],
    questionnaire: [],
    team: [],
    precondition: [],
    medication: [],
    observation: [],
    definition: [],
    has_stage: None,
    has_body_site: None,
    has_severity: None,
    stage: None,
    body_site: None,
    severity: None,
    code:,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version_algorithm: None,
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

pub fn conditiondefinition_observation_new() -> ConditiondefinitionObservation {
  ConditiondefinitionObservation(
    code: None,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn conditiondefinition_medication_new() -> ConditiondefinitionMedication {
  ConditiondefinitionMedication(
    code: None,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionPrecondition {
  ConditiondefinitionPrecondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Conditionpreconditiontype,
    code: Codeableconcept,
    value: Option(ConditiondefinitionPreconditionValue),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionPreconditionValue {
  ConditiondefinitionPreconditionValueCodeableconcept(value: Codeableconcept)
  ConditiondefinitionPreconditionValueQuantity(value: Quantity)
}

pub fn conditiondefinition_precondition_new(
  code,
  type_,
) -> ConditiondefinitionPrecondition {
  ConditiondefinitionPrecondition(
    value: None,
    code:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ConditionDefinition#resource
pub type ConditiondefinitionQuestionnaire {
  ConditiondefinitionQuestionnaire(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    purpose: r5valuesets.Conditionquestionnairepurpose,
    reference: Reference,
  )
}

pub fn conditiondefinition_questionnaire_new(
  reference,
  purpose,
) -> ConditiondefinitionQuestionnaire {
  ConditiondefinitionQuestionnaire(
    reference:,
    purpose:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn conditiondefinition_plan_new(reference) -> ConditiondefinitionPlan {
  ConditiondefinitionPlan(
    reference:,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Consentstatecodes,
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
    decision: Option(r5valuesets.Consentprovisiontype),
    provision: List(ConsentProvision),
  )
}

pub fn consent_new(status) -> Consent {
  Consent(
    provision: [],
    decision: None,
    verification: [],
    policy_text: [],
    policy_basis: None,
    regulatory_basis: [],
    source_reference: [],
    source_attachment: [],
    controller: [],
    manager: [],
    grantee: [],
    grantor: [],
    period: None,
    date: None,
    subject: None,
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

pub fn consent_policybasis_new() -> ConsentPolicybasis {
  ConsentPolicybasis(
    url: None,
    reference: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn consent_verification_new(verified) -> ConsentVerification {
  ConsentVerification(
    verification_date: [],
    verified_with: None,
    verified_by: None,
    verification_type: None,
    verified:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn consent_provision_new() -> ConsentProvision {
  ConsentProvision(
    provision: [],
    expression: None,
    data: [],
    data_period: None,
    code: [],
    resource_type: [],
    document_type: [],
    purpose: [],
    security_label: [],
    action: [],
    actor: [],
    period: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn consent_provision_actor_new() -> ConsentProvisionActor {
  ConsentProvisionActor(
    reference: None,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: r5valuesets.Consentdatameaning,
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
    status: Option(r5valuesets.Contractstatus),
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
    publication_status: r5valuesets.Contractpublicationstatus,
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

pub fn contract_term_offer_party_new(role) -> ContractTermOfferParty {
  ContractTermOfferParty(
    role:,
    reference: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn contract_term_offer_answer_new(value) -> ContractTermOfferAnswer {
  ContractTermOfferAnswer(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn contract_term_action_new(status, intent, type_) -> ContractTermAction {
  ContractTermAction(
    security_label_number: [],
    note: [],
    reason_link_id: [],
    reason: [],
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

pub fn contract_term_action_subject_new() -> ContractTermActionSubject {
  ContractTermActionSubject(
    role: None,
    reference: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn contract_friendly_new(content) -> ContractFriendly {
  ContractFriendly(content:, modifier_extension: [], extension: [], id: None)
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

pub fn contract_legal_new(content) -> ContractLegal {
  ContractLegal(content:, modifier_extension: [], extension: [], id: None)
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

pub fn contract_rule_new(content) -> ContractRule {
  ContractRule(content:, modifier_extension: [], extension: [], id: None)
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
    status: r5valuesets.Fmstatus,
    kind: r5valuesets.Coveragekind,
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

pub fn coverage_new(beneficiary, kind, status) -> Coverage {
  Coverage(
    insurance_plan: None,
    contract: [],
    subrogation: None,
    cost_to_beneficiary: [],
    network: None,
    order: None,
    class: [],
    insurer: None,
    period: None,
    relationship: None,
    dependent: None,
    beneficiary:,
    subscriber_id: [],
    subscriber: None,
    policy_holder: None,
    type_: None,
    payment_by: [],
    kind:,
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

pub fn coverage_paymentby_new(party) -> CoveragePaymentby {
  CoveragePaymentby(
    responsibility: None,
    party:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn coverage_costtobeneficiary_new() -> CoverageCosttobeneficiary {
  CoverageCosttobeneficiary(
    exception: [],
    value: None,
    term: None,
    unit: None,
    network: None,
    category: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Fmstatus,
    priority: Option(Codeableconcept),
    purpose: List(r5valuesets.Eligibilityrequestpurpose),
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
    event: [],
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

pub fn coverageeligibilityrequest_event_new(
  when,
  type_,
) -> CoverageeligibilityrequestEvent {
  CoverageeligibilityrequestEvent(
    when:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn coverageeligibilityrequest_item_diagnosis_new() -> CoverageeligibilityrequestItemDiagnosis {
  CoverageeligibilityrequestItemDiagnosis(
    diagnosis: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Fmstatus,
    purpose: List(r5valuesets.Eligibilityresponsepurpose),
    patient: Reference,
    event: List(CoverageeligibilityresponseEvent),
    serviced: Option(CoverageeligibilityresponseServiced),
    created: String,
    requestor: Option(Reference),
    request: Reference,
    outcome: r5valuesets.Eligibilityoutcome,
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
    event: [],
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

pub fn coverageeligibilityresponse_event_new(
  when,
  type_,
) -> CoverageeligibilityresponseEvent {
  CoverageeligibilityresponseEvent(
    when:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn coverageeligibilityresponse_error_new(
  code,
) -> CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    expression: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Detectedissuestatus,
    category: List(Codeableconcept),
    code: Option(Codeableconcept),
    severity: Option(r5valuesets.Detectedissueseverity),
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

pub fn detectedissue_new(status) -> Detectedissue {
  Detectedissue(
    mitigation: [],
    reference: None,
    detail: None,
    evidence: [],
    implicated: [],
    author: None,
    identified: None,
    encounter: None,
    subject: None,
    severity: None,
    code: None,
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

pub fn detectedissue_evidence_new() -> DetectedissueEvidence {
  DetectedissueEvidence(
    detail: [],
    code: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn detectedissue_mitigation_new(action) -> DetectedissueMitigation {
  DetectedissueMitigation(
    note: [],
    author: None,
    date: None,
    action:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Devicestatus),
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

pub fn device_new() -> Device {
  Device(
    parent: None,
    safety: [],
    note: [],
    gateway: [],
    endpoint: [],
    url: None,
    location: None,
    contact: [],
    owner: None,
    duration: None,
    cycle: None,
    mode: None,
    property: [],
    conforms_to: [],
    version: [],
    type_: [],
    category: [],
    part_number: None,
    model_number: None,
    name: [],
    serial_number: None,
    lot_number: None,
    expiration_date: None,
    manufacture_date: None,
    manufacturer: None,
    biological_source_event: None,
    availability_status: None,
    status: None,
    udi_carrier: [],
    definition: None,
    display_name: None,
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
    entry_type: Option(r5valuesets.Udientrytype),
  )
}

pub fn device_udicarrier_new(issuer, device_identifier) -> DeviceUdicarrier {
  DeviceUdicarrier(
    entry_type: None,
    carrier_hrf: None,
    carrier_aidc: None,
    jurisdiction: None,
    issuer:,
    device_identifier:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Device#resource
pub type DeviceName {
  DeviceName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    value: String,
    type_: r5valuesets.Devicenametype,
    display: Option(Bool),
  )
}

pub fn device_name_new(type_, value) -> DeviceName {
  DeviceName(
    display: None,
    type_:,
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn device_version_new(value) -> DeviceVersion {
  DeviceVersion(
    value:,
    install_date: None,
    component: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn device_conformsto_new(specification) -> DeviceConformsto {
  DeviceConformsto(
    version: None,
    specification:,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn device_property_new(value, type_) -> DeviceProperty {
  DeviceProperty(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn deviceassociation_new(status, device) -> Deviceassociation {
  Deviceassociation(
    operation: [],
    period: None,
    body_structure: None,
    subject: None,
    status_reason: [],
    status:,
    category: [],
    device:,
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

pub fn deviceassociation_operation_new(status) -> DeviceassociationOperation {
  DeviceassociationOperation(
    period: None,
    operator: [],
    status:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    production_identifier_in_udi: List(r5valuesets.Deviceproductidentifierinudi),
    guideline: Option(DevicedefinitionGuideline),
    corrective_action: Option(DevicedefinitionCorrectiveaction),
    charge_item: List(DevicedefinitionChargeitem),
  )
}

pub fn devicedefinition_new() -> Devicedefinition {
  Devicedefinition(
    charge_item: [],
    corrective_action: None,
    guideline: None,
    production_identifier_in_udi: [],
    material: [],
    note: [],
    link: [],
    contact: [],
    owner: None,
    property: [],
    language_code: [],
    shelf_life_storage: [],
    safety: [],
    version: [],
    packaging: [],
    has_part: [],
    conforms_to: [],
    classification: [],
    model_number: None,
    device_name: [],
    manufacturer: None,
    part_number: None,
    regulatory_identifier: [],
    udi_device_identifier: [],
    identifier: [],
    description: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
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

pub fn devicedefinition_udideviceidentifier_new(
  jurisdiction,
  issuer,
  device_identifier,
) -> DevicedefinitionUdideviceidentifier {
  DevicedefinitionUdideviceidentifier(
    market_distribution: [],
    jurisdiction:,
    issuer:,
    device_identifier:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_udideviceidentifier_marketdistribution_new(
  sub_jurisdiction,
  market_period,
) -> DevicedefinitionUdideviceidentifierMarketdistribution {
  DevicedefinitionUdideviceidentifierMarketdistribution(
    sub_jurisdiction:,
    market_period:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionRegulatoryidentifier {
  DevicedefinitionRegulatoryidentifier(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Devicedefinitionregulatoryidentifiertype,
    device_identifier: String,
    issuer: String,
    jurisdiction: String,
  )
}

pub fn devicedefinition_regulatoryidentifier_new(
  jurisdiction,
  issuer,
  device_identifier,
  type_,
) -> DevicedefinitionRegulatoryidentifier {
  DevicedefinitionRegulatoryidentifier(
    jurisdiction:,
    issuer:,
    device_identifier:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: r5valuesets.Devicenametype,
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

pub fn devicedefinition_classification_new(
  type_,
) -> DevicedefinitionClassification {
  DevicedefinitionClassification(
    justification: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_conformsto_new(
  specification,
) -> DevicedefinitionConformsto {
  DevicedefinitionConformsto(
    source: [],
    version: [],
    specification:,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_haspart_new(reference) -> DevicedefinitionHaspart {
  DevicedefinitionHaspart(
    count: None,
    reference:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_packaging_new() -> DevicedefinitionPackaging {
  DevicedefinitionPackaging(
    packaging: [],
    udi_device_identifier: [],
    distributor: [],
    count: None,
    type_: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_packaging_distributor_new() -> DevicedefinitionPackagingDistributor {
  DevicedefinitionPackagingDistributor(
    organization_reference: [],
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_version_new(value) -> DevicedefinitionVersion {
  DevicedefinitionVersion(
    value:,
    component: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_property_new(value, type_) -> DevicedefinitionProperty {
  DevicedefinitionProperty(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn devicedefinition_link_new(
  related_device,
  relation,
) -> DevicedefinitionLink {
  DevicedefinitionLink(
    related_device:,
    relation:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_guideline_new() -> DevicedefinitionGuideline {
  DevicedefinitionGuideline(
    intended_use: None,
    warning: [],
    contraindication: [],
    indication: [],
    related_artifact: [],
    usage_instruction: None,
    use_context: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionCorrectiveaction {
  DevicedefinitionCorrectiveaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    recall: Bool,
    scope: Option(r5valuesets.Devicecorrectiveactionscope),
    period: Period,
  )
}

pub fn devicedefinition_correctiveaction_new(
  period,
  recall,
) -> DevicedefinitionCorrectiveaction {
  DevicedefinitionCorrectiveaction(
    period:,
    scope: None,
    recall:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn devicedefinition_chargeitem_new(
  count,
  charge_item_code,
) -> DevicedefinitionChargeitem {
  DevicedefinitionChargeitem(
    use_context: [],
    effective_period: None,
    count:,
    charge_item_code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Devicedispensestatus,
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

pub fn devicedispense_new(subject, device, status) -> Devicedispense {
  Devicedispense(
    event_history: [],
    usage_instruction: None,
    note: [],
    destination: None,
    when_handed_over: None,
    prepared_date: None,
    quantity: None,
    type_: None,
    location: None,
    performer: [],
    supporting_information: [],
    encounter: None,
    receiver: None,
    subject:,
    device:,
    category: [],
    status_reason: None,
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

pub fn devicedispense_performer_new(actor) -> DevicedispensePerformer {
  DevicedispensePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    operational_status: Option(r5valuesets.Metricoperationalstatus),
    color: Option(r5valuesets.Colorcodes),
    category: r5valuesets.Metriccategory,
    measurement_frequency: Option(Quantity),
    calibration: List(DevicemetricCalibration),
  )
}

pub fn devicemetric_new(category, device, type_) -> Devicemetric {
  Devicemetric(
    calibration: [],
    measurement_frequency: None,
    category:,
    color: None,
    operational_status: None,
    device:,
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

///http://hl7.org/fhir/r5/StructureDefinition/DeviceMetric#resource
pub type DevicemetricCalibration {
  DevicemetricCalibration(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Metriccalibrationtype),
    state: Option(r5valuesets.Metriccalibrationstate),
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
    status: Option(r5valuesets.Requeststatus),
    intent: r5valuesets.Requestintent,
    priority: Option(r5valuesets.Requestpriority),
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

pub fn devicerequest_new(subject, code, intent) -> Devicerequest {
  Devicerequest(
    relevant_history: [],
    note: [],
    supporting_info: [],
    insurance: [],
    as_needed_for: None,
    as_needed: None,
    reason: [],
    performer: None,
    requester: None,
    authored_on: None,
    occurrence: None,
    encounter: None,
    subject:,
    parameter: [],
    quantity: None,
    code:,
    do_not_perform: None,
    priority: None,
    intent:,
    status: None,
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

pub fn devicerequest_parameter_new() -> DevicerequestParameter {
  DevicerequestParameter(
    value: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Deviceusagestatus,
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

pub fn deviceusage_new(device, patient, status) -> Deviceusage {
  Deviceusage(
    note: [],
    body_site: None,
    reason: [],
    device:,
    information_source: None,
    adherence: None,
    usage_reason: [],
    usage_status: None,
    date_asserted: None,
    timing: None,
    context: None,
    derived_from: [],
    patient:,
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

pub fn deviceusage_adherence_new(code) -> DeviceusageAdherence {
  DeviceusageAdherence(
    reason: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Diagnosticreportstatus,
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

pub fn diagnosticreport_new(code, status) -> Diagnosticreport {
  Diagnosticreport(
    presented_form: [],
    conclusion_code: [],
    conclusion: None,
    composition: None,
    media: [],
    supporting_info: [],
    study: [],
    note: [],
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

pub fn diagnosticreport_supportinginfo_new(
  reference,
  type_,
) -> DiagnosticreportSupportinginfo {
  DiagnosticreportSupportinginfo(
    reference:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn diagnosticreport_media_new(link) -> DiagnosticreportMedia {
  DiagnosticreportMedia(
    link:,
    comment: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Documentreferencestatus,
    doc_status: Option(r5valuesets.Compositionstatus),
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

pub fn documentreference_new(status) -> Documentreference {
  Documentreference(
    content: [],
    security_label: [],
    description: None,
    relates_to: [],
    custodian: None,
    attester: [],
    author: [],
    date: None,
    period: None,
    practice_setting: None,
    facility_type: None,
    body_site: [],
    event: [],
    context: [],
    subject: None,
    category: [],
    type_: None,
    modality: [],
    doc_status: None,
    status:,
    based_on: [],
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

pub fn documentreference_attester_new(mode) -> DocumentreferenceAttester {
  DocumentreferenceAttester(
    party: None,
    time: None,
    mode:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn documentreference_content_new(attachment) -> DocumentreferenceContent {
  DocumentreferenceContent(
    profile: [],
    attachment:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn documentreference_content_profile_new(
  value,
) -> DocumentreferenceContentProfile {
  DocumentreferenceContentProfile(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Encounterstatus,
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

pub fn encounter_new(status) -> Encounter {
  Encounter(
    location: [],
    admission: None,
    special_courtesy: [],
    special_arrangement: [],
    diet_preference: [],
    account: [],
    diagnosis: [],
    reason: [],
    length: None,
    planned_end_date: None,
    planned_start_date: None,
    actual_period: None,
    virtual_service: [],
    appointment: [],
    participant: [],
    service_provider: None,
    part_of: None,
    care_team: [],
    based_on: [],
    episode_of_care: [],
    subject_status: None,
    subject: None,
    service_type: [],
    type_: [],
    priority: None,
    class: [],
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

pub fn encounter_participant_new() -> EncounterParticipant {
  EncounterParticipant(
    actor: None,
    period: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn encounter_reason_new() -> EncounterReason {
  EncounterReason(
    value: [],
    use_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn encounter_diagnosis_new() -> EncounterDiagnosis {
  EncounterDiagnosis(
    use_: [],
    condition: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn encounter_admission_new() -> EncounterAdmission {
  EncounterAdmission(
    discharge_disposition: None,
    destination: None,
    re_admission: None,
    admit_source: None,
    origin: None,
    pre_admission_identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(r5valuesets.Encounterlocationstatus),
    form: Option(Codeableconcept),
    period: Option(Period),
  )
}

pub fn encounter_location_new(location) -> EncounterLocation {
  EncounterLocation(
    period: None,
    form: None,
    status: None,
    location:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Encounterstatus,
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

pub fn encounterhistory_new(class, status) -> Encounterhistory {
  Encounterhistory(
    location: [],
    length: None,
    planned_end_date: None,
    planned_start_date: None,
    actual_period: None,
    subject_status: None,
    subject: None,
    service_type: [],
    type_: [],
    class:,
    status:,
    identifier: [],
    encounter: None,
    modifier_extension: [],
    extension: [],
    contained: [],
    text: None,
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
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

pub fn encounterhistory_location_new(location) -> EncounterhistoryLocation {
  EncounterhistoryLocation(
    form: None,
    location:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Endpointstatus,
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

pub fn endpoint_new(address, status) -> Endpoint {
  Endpoint(
    header: [],
    address:,
    payload: [],
    period: None,
    contact: [],
    managing_organization: None,
    environment_type: [],
    description: None,
    name: None,
    connection_type: [],
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

pub fn endpoint_payload_new() -> EndpointPayload {
  EndpointPayload(
    mime_type: [],
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Fmstatus),
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
    status: Option(r5valuesets.Fmstatus),
    request: Option(Reference),
    outcome: Option(r5valuesets.Enrollmentoutcome),
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
    status: r5valuesets.Episodeofcarestatus,
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

pub fn episodeofcare_new(patient, status) -> Episodeofcare {
  Episodeofcare(
    account: [],
    care_team: [],
    care_manager: None,
    referral_request: [],
    period: None,
    managing_organization: None,
    patient:,
    diagnosis: [],
    reason: [],
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

///http://hl7.org/fhir/r5/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: r5valuesets.Episodeofcarestatus,
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

pub fn episodeofcare_reason_new() -> EpisodeofcareReason {
  EpisodeofcareReason(
    value: [],
    use_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn episodeofcare_diagnosis_new() -> EpisodeofcareDiagnosis {
  EpisodeofcareDiagnosis(
    use_: None,
    condition: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    copyright_label: None,
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
    version_algorithm: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn evidence_new(status) -> Evidence {
  Evidence(
    certainty: [],
    statistic: [],
    study_design: [],
    synthesis_type: None,
    variable_definition: [],
    note: [],
    assertion: None,
    description: None,
    related_artifact: [],
    copyright_label: None,
    copyright: None,
    purpose: None,
    use_context: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    contact: [],
    publisher: None,
    last_review_date: None,
    approval_date: None,
    date: None,
    experimental: None,
    status:,
    cite_as: None,
    title: None,
    name: None,
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Evidence#resource
pub type EvidenceStatisticModelcharacteristicVariable {
  EvidenceStatisticModelcharacteristicVariable(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    variable_definition: Reference,
    handling: Option(r5valuesets.Variablehandling),
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
    status: r5valuesets.Publicationstatus,
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

pub fn evidencereport_subject_new() -> EvidencereportSubject {
  EvidencereportSubject(
    note: [],
    characteristic: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceReport#resource
pub type EvidencereportRelatesto {
  EvidencereportRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Reportrelationtype,
    target: EvidencereportRelatestoTarget,
  )
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

pub fn evidencereport_relatesto_target_new() -> EvidencereportRelatestoTarget {
  EvidencereportRelatestoTarget(
    resource: None,
    display: None,
    identifier: None,
    url: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    mode: Option(r5valuesets.Listmode),
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
    status: r5valuesets.Publicationstatus,
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
    handling: Option(r5valuesets.Variablehandling),
    category: List(EvidencevariableCategory),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableVersionalgorithm {
  EvidencevariableVersionalgorithmString(version_algorithm: String)
  EvidencevariableVersionalgorithmCoding(version_algorithm: Coding)
}

pub fn evidencevariable_new(status) -> Evidencevariable {
  Evidencevariable(
    category: [],
    handling: None,
    characteristic: [],
    actual: None,
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
    copyright: None,
    purpose: None,
    use_context: [],
    note: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    experimental: None,
    status:,
    short_title: None,
    title: None,
    name: None,
    version_algorithm: None,
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

pub fn evidencevariable_characteristic_new() -> EvidencevariableCharacteristic {
  EvidencevariableCharacteristic(
    time_from_event: [],
    duration: None,
    instances: None,
    definition_by_combination: None,
    definition_by_type_and_value: None,
    definition_id: None,
    definition_expression: None,
    definition_codeable_concept: None,
    definition_canonical: None,
    definition_reference: None,
    exclude: None,
    note: [],
    description: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn evidencevariable_characteristic_definitionbytypeandvalue_new(
  value,
  type_,
) -> EvidencevariableCharacteristicDefinitionbytypeandvalue {
  EvidencevariableCharacteristicDefinitionbytypeandvalue(
    offset: None,
    value:,
    device: None,
    method: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/EvidenceVariable#resource
pub type EvidencevariableCharacteristicDefinitionbycombination {
  EvidencevariableCharacteristicDefinitionbycombination(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Characteristiccombination,
    threshold: Option(Int),
    characteristic: List(Nil),
  )
}

pub fn evidencevariable_characteristic_definitionbycombination_new(
  code,
) -> EvidencevariableCharacteristicDefinitionbycombination {
  EvidencevariableCharacteristicDefinitionbycombination(
    characteristic: [],
    threshold: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn evidencevariable_characteristic_timefromevent_new() -> EvidencevariableCharacteristicTimefromevent {
  EvidencevariableCharacteristicTimefromevent(
    range: None,
    quantity: None,
    event: None,
    note: [],
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn evidencevariable_category_new() -> EvidencevariableCategory {
  EvidencevariableCategory(
    value: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Publicationstatus,
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

pub fn examplescenario_new(status) -> Examplescenario {
  Examplescenario(
    process: [],
    instance: [],
    actor: [],
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioActor {
  ExamplescenarioActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    type_: r5valuesets.Examplescenarioactortype,
    title: String,
    description: Option(String),
  )
}

pub fn examplescenario_actor_new(title, type_, key) -> ExamplescenarioActor {
  ExamplescenarioActor(
    description: None,
    title:,
    type_:,
    key:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn examplescenario_instance_new(
  title,
  structure_type,
  key,
) -> ExamplescenarioInstance {
  ExamplescenarioInstance(
    contained_instance: [],
    version: [],
    content: None,
    description: None,
    title:,
    structure_profile: None,
    structure_version: None,
    structure_type:,
    key:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn examplescenario_instance_version_new(
  title,
  key,
) -> ExamplescenarioInstanceVersion {
  ExamplescenarioInstanceVersion(
    content: None,
    description: None,
    title:,
    key:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn examplescenario_instance_containedinstance_new(
  instance_reference,
) -> ExamplescenarioInstanceContainedinstance {
  ExamplescenarioInstanceContainedinstance(
    version_reference: None,
    instance_reference:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn examplescenario_process_step_new() -> ExamplescenarioProcessStep {
  ExamplescenarioProcessStep(
    pause: None,
    alternative: [],
    operation: None,
    workflow: None,
    process: None,
    number: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn examplescenario_process_step_operation_new(
  title,
) -> ExamplescenarioProcessStepOperation {
  ExamplescenarioProcessStepOperation(
    response: None,
    request: None,
    receiver_active: None,
    initiator_active: None,
    description: None,
    receiver: None,
    initiator: None,
    title:,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Explanationofbenefitstatus,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: r5valuesets.Claimuse,
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
    outcome: r5valuesets.Claimoutcome,
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

pub fn explanationofbenefit_new(
  outcome,
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
    patient_paid: None,
    accident: None,
    insurance: [],
    precedence: None,
    procedure: [],
    diagnosis: [],
    supporting_info: [],
    care_team: [],
    diagnosis_related_group: None,
    pre_auth_ref_period: [],
    pre_auth_ref: [],
    disposition: None,
    decision: None,
    outcome:,
    claim_response: None,
    claim: None,
    facility: None,
    encounter: [],
    referral: None,
    payee: None,
    event: [],
    original_prescription: None,
    prescription: None,
    related: [],
    funds_reserve: None,
    funds_reserve_requested: None,
    priority: None,
    provider: None,
    insurer: None,
    enterer: None,
    created:,
    billable_period: None,
    patient:,
    use_:,
    sub_type: None,
    type_:,
    status:,
    trace_number: [],
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

pub fn explanationofbenefit_event_new(when, type_) -> ExplanationofbenefitEvent {
  ExplanationofbenefitEvent(
    when:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn explanationofbenefit_payee_new() -> ExplanationofbenefitPayee {
  ExplanationofbenefitPayee(
    party: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_careteam_new(
  provider,
  sequence,
) -> ExplanationofbenefitCareteam {
  ExplanationofbenefitCareteam(
    specialty: None,
    role: None,
    responsible: None,
    provider:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_diagnosis_new(
  diagnosis,
  sequence,
) -> ExplanationofbenefitDiagnosis {
  ExplanationofbenefitDiagnosis(
    on_admission: None,
    type_: [],
    diagnosis:,
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn explanationofbenefit_item_new(sequence) -> ExplanationofbenefitItem {
  ExplanationofbenefitItem(
    detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    encounter: [],
    body_site: [],
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    request: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    trace_number: [],
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

pub fn explanationofbenefit_item_bodysite_new() -> ExplanationofbenefitItemBodysite {
  ExplanationofbenefitItemBodysite(
    sub_site: [],
    site: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_item_reviewoutcome_new() -> ExplanationofbenefitItemReviewoutcome {
  ExplanationofbenefitItemReviewoutcome(
    pre_auth_period: None,
    pre_auth_ref: None,
    reason: [],
    decision: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_item_adjudication_new(
  category,
) -> ExplanationofbenefitItemAdjudication {
  ExplanationofbenefitItemAdjudication(
    quantity: None,
    amount: None,
    reason: None,
    category:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_item_detail_new(
  sequence,
) -> ExplanationofbenefitItemDetail {
  ExplanationofbenefitItemDetail(
    sub_detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    program_code: [],
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    trace_number: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_item_detail_subdetail_new(
  sequence,
) -> ExplanationofbenefitItemDetailSubdetail {
  ExplanationofbenefitItemDetailSubdetail(
    adjudication: [],
    review_outcome: None,
    note_number: [],
    udi: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    program_code: [],
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    category: None,
    revenue: None,
    trace_number: [],
    sequence:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_additem_new() -> ExplanationofbenefitAdditem {
  ExplanationofbenefitAdditem(
    detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    body_site: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    location: None,
    serviced: None,
    program_code: [],
    modifier: [],
    request: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    provider: [],
    trace_number: [],
    sub_detail_sequence: [],
    detail_sequence: [],
    item_sequence: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn explanationofbenefit_additem_bodysite_new() -> ExplanationofbenefitAdditemBodysite {
  ExplanationofbenefitAdditemBodysite(
    sub_site: [],
    site: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_additem_detail_new() -> ExplanationofbenefitAdditemDetail {
  ExplanationofbenefitAdditemDetail(
    sub_detail: [],
    adjudication: [],
    review_outcome: None,
    note_number: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    trace_number: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn explanationofbenefit_additem_detail_subdetail_new() -> ExplanationofbenefitAdditemDetailSubdetail {
  ExplanationofbenefitAdditemDetailSubdetail(
    adjudication: [],
    review_outcome: None,
    note_number: [],
    net: None,
    tax: None,
    factor: None,
    unit_price: None,
    quantity: None,
    patient_paid: None,
    modifier: [],
    product_or_service_end: None,
    product_or_service: None,
    revenue: None,
    trace_number: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Historystatus,
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

pub fn familymemberhistory_new(
  relationship,
  patient,
  status,
) -> Familymemberhistory {
  Familymemberhistory(
    procedure: [],
    condition: [],
    note: [],
    reason: [],
    deceased: None,
    estimated_age: None,
    age: None,
    born: None,
    sex: None,
    relationship:,
    name: None,
    participant: [],
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

pub fn familymemberhistory_participant_new(
  actor,
) -> FamilymemberhistoryParticipant {
  FamilymemberhistoryParticipant(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn familymemberhistory_procedure_new(code) -> FamilymemberhistoryProcedure {
  FamilymemberhistoryProcedure(
    note: [],
    performed: None,
    contributed_to_death: None,
    outcome: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Flagstatus,
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
    status: Option(r5valuesets.Formularyitemstatus),
  )
}

pub fn formularyitem_new() -> Formularyitem {
  Formularyitem(
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
    status: r5valuesets.Genomicstudystatus,
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

pub fn genomicstudy_new(subject, status) -> Genomicstudy {
  Genomicstudy(
    analysis: [],
    description: None,
    note: [],
    instantiates_uri: None,
    instantiates_canonical: None,
    reason: [],
    interpreter: [],
    referrer: None,
    based_on: [],
    start_date: None,
    encounter: None,
    subject:,
    type_: [],
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

pub fn genomicstudy_analysis_new() -> GenomicstudyAnalysis {
  GenomicstudyAnalysis(
    device: [],
    performer: [],
    output: [],
    input: [],
    regions_called: [],
    regions_studied: [],
    protocol_performed: None,
    note: [],
    date: None,
    specimen: [],
    focus: [],
    title: None,
    instantiates_uri: None,
    instantiates_canonical: None,
    genome_build: None,
    change_type: [],
    method_type: [],
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn genomicstudy_analysis_input_new() -> GenomicstudyAnalysisInput {
  GenomicstudyAnalysisInput(
    generated_by: None,
    type_: None,
    file: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn genomicstudy_analysis_output_new() -> GenomicstudyAnalysisOutput {
  GenomicstudyAnalysisOutput(
    type_: None,
    file: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn genomicstudy_analysis_performer_new() -> GenomicstudyAnalysisPerformer {
  GenomicstudyAnalysisPerformer(
    role: None,
    actor: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn genomicstudy_analysis_device_new() -> GenomicstudyAnalysisDevice {
  GenomicstudyAnalysisDevice(
    function: None,
    device: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    lifecycle_status: r5valuesets.Goalstatus,
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

pub fn goal_new(subject, description, lifecycle_status) -> Goal {
  Goal(
    outcome: [],
    note: [],
    addresses: [],
    source: None,
    status_reason: None,
    status_date: None,
    target: [],
    start: None,
    subject:,
    description:,
    priority: None,
    continuous: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn graphdefinition_new(status, name) -> Graphdefinition {
  Graphdefinition(
    link: [],
    node: [],
    start: None,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionNode {
  GraphdefinitionNode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    node_id: String,
    description: Option(String),
    type_: r5valuesets.Versionindependentallresourcetypes,
    profile: Option(String),
  )
}

pub fn graphdefinition_node_new(type_, node_id) -> GraphdefinitionNode {
  GraphdefinitionNode(
    profile: None,
    type_:,
    description: None,
    node_id:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn graphdefinition_link_new(target_id, source_id) -> GraphdefinitionLink {
  GraphdefinitionLink(
    compartment: [],
    params: None,
    target_id:,
    slice_name: None,
    path: None,
    source_id:,
    max: None,
    min: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkCompartment {
  GraphdefinitionLinkCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: r5valuesets.Graphcompartmentuse,
    rule: r5valuesets.Graphcompartmentrule,
    code: r5valuesets.Compartmenttype,
    expression: Option(String),
    description: Option(String),
  )
}

pub fn graphdefinition_link_compartment_new(
  code,
  rule,
  use_,
) -> GraphdefinitionLinkCompartment {
  GraphdefinitionLinkCompartment(
    description: None,
    expression: None,
    code:,
    rule:,
    use_:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    type_: r5valuesets.Grouptype,
    membership: r5valuesets.Groupmembershipbasis,
    code: Option(Codeableconcept),
    name: Option(String),
    description: Option(String),
    quantity: Option(Int),
    managing_entity: Option(Reference),
    characteristic: List(GroupCharacteristic),
    member: List(GroupMember),
  )
}

pub fn group_new(membership, type_) -> Group {
  Group(
    member: [],
    characteristic: [],
    managing_entity: None,
    quantity: None,
    description: None,
    name: None,
    code: None,
    membership:,
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
    status: r5valuesets.Guidanceresponsestatus,
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

pub fn guidanceresponse_new(status, module) -> Guidanceresponse {
  Guidanceresponse(
    data_requirement: [],
    result: [],
    output_parameters: None,
    evaluation_message: None,
    note: [],
    reason: [],
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

pub fn healthcareservice_new() -> Healthcareservice {
  Healthcareservice(
    endpoint: [],
    availability: [],
    appointment_required: None,
    referral_method: [],
    communication: [],
    characteristic: [],
    program: [],
    eligibility: [],
    service_provision_code: [],
    coverage_area: [],
    contact: [],
    photo: None,
    extra_details: None,
    comment: None,
    name: None,
    location: [],
    specialty: [],
    type_: [],
    category: [],
    offered_in: [],
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

pub fn healthcareservice_eligibility_new() -> HealthcareserviceEligibility {
  HealthcareserviceEligibility(
    comment: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Imagingselectionstatus,
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

pub fn imagingselection_new(code, status) -> Imagingselection {
  Imagingselection(
    instance: [],
    focus: [],
    body_site: None,
    frame_of_reference_uid: None,
    series_number: None,
    series_uid: None,
    endpoint: [],
    derived_from: [],
    study_uid: None,
    code:,
    category: [],
    based_on: [],
    performer: [],
    issued: None,
    subject: None,
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

pub fn imagingselection_performer_new() -> ImagingselectionPerformer {
  ImagingselectionPerformer(
    actor: None,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn imagingselection_instance_new(uid) -> ImagingselectionInstance {
  ImagingselectionInstance(
    image_region3_d: [],
    image_region2_d: [],
    subset: [],
    sop_class: None,
    number: None,
    uid:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionInstanceImageregion2d {
  ImagingselectionInstanceImageregion2d(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    region_type: r5valuesets.Imagingselection2dgraphictype,
    coordinate: List(Float),
  )
}

pub fn imagingselection_instance_imageregion2d_new(
  region_type,
) -> ImagingselectionInstanceImageregion2d {
  ImagingselectionInstanceImageregion2d(
    coordinate: [],
    region_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImagingSelection#resource
pub type ImagingselectionInstanceImageregion3d {
  ImagingselectionInstanceImageregion3d(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    region_type: r5valuesets.Imagingselection3dgraphictype,
    coordinate: List(Float),
  )
}

pub fn imagingselection_instance_imageregion3d_new(
  region_type,
) -> ImagingselectionInstanceImageregion3d {
  ImagingselectionInstanceImageregion3d(
    coordinate: [],
    region_type:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Imagingstudystatus,
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

pub fn imagingstudy_new(subject, status) -> Imagingstudy {
  Imagingstudy(
    series: [],
    description: None,
    note: [],
    reason: [],
    location: None,
    procedure: [],
    number_of_instances: None,
    number_of_series: None,
    endpoint: [],
    referrer: None,
    part_of: [],
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

pub fn imagingstudy_series_performer_new(actor) -> ImagingstudySeriesPerformer {
  ImagingstudySeriesPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Immunizationstatus,
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
    subpotent_reason: [],
    is_subpotent: None,
    reason: [],
    note: [],
    performer: [],
    dose_quantity: None,
    route: None,
    site: None,
    location: None,
    information_source: None,
    primary_source: None,
    occurrence:,
    supporting_information: [],
    encounter: None,
    patient:,
    expiration_date: None,
    lot_number: None,
    manufacturer: None,
    administered_product: None,
    vaccine_code:,
    status_reason: None,
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

pub fn immunization_performer_new(actor) -> ImmunizationPerformer {
  ImmunizationPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn immunization_programeligibility_new(
  program_status,
  program,
) -> ImmunizationProgrameligibility {
  ImmunizationProgrameligibility(
    program_status:,
    program:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn immunization_reaction_new() -> ImmunizationReaction {
  ImmunizationReaction(
    reported: None,
    manifestation: None,
    date: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Immunizationevaluationstatus,
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
    target_disease: [],
    vaccine_code: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    license: Option(r5valuesets.Spdxlicense),
    fhir_version: List(r5valuesets.Fhirversion),
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
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn implementationguide_dependson_new(uri) -> ImplementationguideDependson {
  ImplementationguideDependson(
    reason: None,
    version: None,
    package_id: None,
    uri:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideGlobal {
  ImplementationguideGlobal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Resourcetypes,
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

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    fhir_version: List(r5valuesets.Fhirversion),
    name: Option(String),
    description: Option(String),
    is_example: Option(Bool),
    profile: List(String),
    grouping_id: Option(String),
  )
}

pub fn implementationguide_definition_resource_new(
  reference,
) -> ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    grouping_id: None,
    profile: [],
    is_example: None,
    description: None,
    name: None,
    fhir_version: [],
    reference:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    generation: r5valuesets.Guidepagegeneration,
    page: List(Nil),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPageSource {
  ImplementationguideDefinitionPageSourceUrl(source: String)
  ImplementationguideDefinitionPageSourceString(source: String)
  ImplementationguideDefinitionPageSourceMarkdown(source: String)
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
    source: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn implementationguide_manifest_resource_new(
  reference,
) -> ImplementationguideManifestResource {
  ImplementationguideManifestResource(
    relative_path: None,
    profile: [],
    is_example: None,
    reference:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn ingredient_new(substance, role, status) -> Ingredient {
  Ingredient(
    substance:,
    manufacturer: [],
    comment: None,
    allergenic_indicator: None,
    group: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Ingredient#resource
pub type IngredientManufacturer {
  IngredientManufacturer(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: Option(r5valuesets.Ingredientmanufacturerrole),
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

pub fn ingredient_substance_new(code) -> IngredientSubstance {
  IngredientSubstance(
    strength: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn ingredient_substance_strength_new() -> IngredientSubstanceStrength {
  IngredientSubstanceStrength(
    reference_strength: [],
    country: [],
    measurement_point: None,
    basis: None,
    text_concentration: None,
    concentration: None,
    text_presentation: None,
    presentation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn ingredient_substance_strength_referencestrength_new(
  strength,
  substance,
) -> IngredientSubstanceStrengthReferencestrength {
  IngredientSubstanceStrengthReferencestrength(
    country: [],
    measurement_point: None,
    strength:,
    substance:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Publicationstatus),
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

pub fn insuranceplan_coverage_benefit_limit_new() -> InsuranceplanCoverageBenefitLimit {
  InsuranceplanCoverageBenefitLimit(
    code: None,
    value: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Inventoryitemstatus,
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

pub fn inventoryitem_new(status) -> Inventoryitem {
  Inventoryitem(
    product_reference: None,
    instance: None,
    characteristic: [],
    association: [],
    net_content: None,
    base_unit: None,
    inventory_status: [],
    description: None,
    responsible_organization: [],
    name: [],
    code: [],
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

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemName {
  InventoryitemName(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name_type: Coding,
    language: r5valuesets.Languages,
    name: String,
  )
}

pub fn inventoryitem_name_new(name, language, name_type) -> InventoryitemName {
  InventoryitemName(
    name:,
    language:,
    name_type:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn inventoryitem_responsibleorganization_new(
  organization,
  role,
) -> InventoryitemResponsibleorganization {
  InventoryitemResponsibleorganization(
    organization:,
    role:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/InventoryItem#resource
pub type InventoryitemDescription {
  InventoryitemDescription(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    language: Option(r5valuesets.Languages),
    description: Option(String),
  )
}

pub fn inventoryitem_description_new() -> InventoryitemDescription {
  InventoryitemDescription(
    description: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn inventoryitem_association_new(
  quantity,
  related_item,
  association_type,
) -> InventoryitemAssociation {
  InventoryitemAssociation(
    quantity:,
    related_item:,
    association_type:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn inventoryitem_characteristic_new(
  value,
  characteristic_type,
) -> InventoryitemCharacteristic {
  InventoryitemCharacteristic(
    value:,
    characteristic_type:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn inventoryitem_instance_new() -> InventoryitemInstance {
  InventoryitemInstance(
    location: None,
    subject: None,
    expiry: None,
    lot_number: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Inventoryreportstatus,
    count_type: r5valuesets.Inventoryreportcounttype,
    operation_type: Option(Codeableconcept),
    operation_type_reason: Option(Codeableconcept),
    reported_date_time: String,
    reporter: Option(Reference),
    reporting_period: Option(Period),
    inventory_listing: List(InventoryreportInventorylisting),
    note: List(Annotation),
  )
}

pub fn inventoryreport_new(
  reported_date_time,
  count_type,
  status,
) -> Inventoryreport {
  Inventoryreport(
    note: [],
    inventory_listing: [],
    reporting_period: None,
    reporter: None,
    reported_date_time:,
    operation_type_reason: None,
    operation_type: None,
    count_type:,
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

pub fn inventoryreport_inventorylisting_new() -> InventoryreportInventorylisting {
  InventoryreportInventorylisting(
    item: [],
    counting_date_time: None,
    item_status: None,
    location: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn inventoryreport_inventorylisting_item_new(
  item,
  quantity,
) -> InventoryreportInventorylistingItem {
  InventoryreportInventorylistingItem(
    item:,
    quantity:,
    category: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Invoicestatus,
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
    period: None,
    creation: None,
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

pub fn invoice_participant_new(actor) -> InvoiceParticipant {
  InvoiceParticipant(
    actor:,
    role: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn invoice_lineitem_new(charge_item) -> InvoiceLineitem {
  InvoiceLineitem(
    price_component: [],
    charge_item:,
    serviced: None,
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Publicationstatus,
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
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Linkage#resource
pub type LinkageItem {
  LinkageItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Linkagetype,
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
    status: r5valuesets.Liststatus,
    mode: r5valuesets.Listmode,
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

pub fn fhir_list_new(mode, status) -> FhirList {
  FhirList(
    empty_reason: None,
    entry: [],
    note: [],
    ordered_by: None,
    source: None,
    date: None,
    encounter: None,
    subject: [],
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
    status: Option(r5valuesets.Locationstatus),
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(r5valuesets.Locationmode),
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

pub fn location_new() -> Location {
  Location(
    endpoint: [],
    virtual_service: [],
    hours_of_operation: [],
    characteristic: [],
    part_of: None,
    managing_organization: None,
    position: None,
    form: None,
    address: None,
    contact: [],
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
    status: r5valuesets.Publicationstatus,
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

pub fn manufactureditemdefinition_new(
  manufactured_dose_form,
  status,
) -> Manufactureditemdefinition {
  Manufactureditemdefinition(
    component: [],
    property: [],
    ingredient: [],
    marketing_status: [],
    manufacturer: [],
    unit_of_presentation: None,
    manufactured_dose_form:,
    name: None,
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

pub fn manufactureditemdefinition_component_new(
  type_,
) -> ManufactureditemdefinitionComponent {
  ManufactureditemdefinitionComponent(
    component: [],
    property: [],
    constituent: [],
    amount: [],
    function: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn manufactureditemdefinition_component_constituent_new() -> ManufactureditemdefinitionComponentConstituent {
  ManufactureditemdefinitionComponentConstituent(
    has_ingredient: [],
    function: [],
    location: [],
    amount: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
    experimental: Option(Bool),
    subject: Option(MeasureSubject),
    basis: Option(r5valuesets.Fhirtypes),
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

pub fn measure_new(status) -> Measure {
  Measure(
    supplemental_data: [],
    group: [],
    guidance: None,
    term: [],
    improvement_notation: None,
    clinical_recommendation_statement: None,
    rationale: None,
    rate_aggregation: None,
    risk_adjustment: None,
    type_: [],
    composite_scoring: None,
    scoring_unit: None,
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
    copyright_label: None,
    copyright: None,
    usage: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    contact: [],
    publisher: None,
    date: None,
    basis: None,
    subject: None,
    experimental: None,
    status:,
    subtitle: None,
    title: None,
    name: None,
    version_algorithm: None,
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

pub fn measure_term_new() -> MeasureTerm {
  MeasureTerm(
    definition: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    basis: Option(r5valuesets.Fhirtypes),
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

pub fn measure_group_new() -> MeasureGroup {
  MeasureGroup(
    stratifier: [],
    population: [],
    library: [],
    improvement_notation: None,
    rate_aggregation: None,
    scoring_unit: None,
    scoring: None,
    basis: None,
    subject: None,
    type_: [],
    description: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn measure_group_population_new() -> MeasureGroupPopulation {
  MeasureGroupPopulation(
    aggregate_method: None,
    input_population_id: None,
    group_definition: None,
    criteria: None,
    description: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn measure_group_stratifier_new() -> MeasureGroupStratifier {
  MeasureGroupStratifier(
    component: [],
    group_definition: None,
    criteria: None,
    description: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn measure_group_stratifier_component_new() -> MeasureGroupStratifierComponent {
  MeasureGroupStratifierComponent(
    group_definition: None,
    criteria: None,
    description: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn measure_supplementaldata_new(criteria) -> MeasureSupplementaldata {
  MeasureSupplementaldata(
    criteria:,
    description: None,
    usage: [],
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Measurereportstatus,
    type_: r5valuesets.Measurereporttype,
    data_update_type: Option(r5valuesets.Submitdataupdatetype),
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

pub fn measurereport_new(period, type_, status) -> Measurereport {
  Measurereport(
    evaluated_resource: [],
    supplemental_data: [],
    group: [],
    improvement_notation: None,
    scoring: None,
    input_parameters: None,
    period:,
    location: None,
    reporting_vendor: None,
    reporter: None,
    date: None,
    subject: None,
    measure: None,
    data_update_type: None,
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

pub fn measurereport_group_new() -> MeasurereportGroup {
  MeasurereportGroup(
    stratifier: [],
    measure_score: None,
    population: [],
    subject: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn measurereport_group_population_new() -> MeasurereportGroupPopulation {
  MeasurereportGroupPopulation(
    subjects: None,
    subject_report: [],
    subject_results: None,
    count: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn measurereport_group_stratifier_new() -> MeasurereportGroupStratifier {
  MeasurereportGroupStratifier(
    stratum: [],
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn measurereport_group_stratifier_stratum_component_new(
  value,
  code,
) -> MeasurereportGroupStratifierStratumComponent {
  MeasurereportGroupStratifierStratumComponent(
    value:,
    code:,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn measurereport_group_stratifier_stratum_population_new() -> MeasurereportGroupStratifierStratumPopulation {
  MeasurereportGroupStratifierStratumPopulation(
    subjects: None,
    subject_report: [],
    subject_results: None,
    count: None,
    code: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Medicationstatus),
    marketing_authorization_holder: Option(Reference),
    dose_form: Option(Codeableconcept),
    total_volume: Option(Quantity),
    ingredient: List(MedicationIngredient),
    batch: Option(MedicationBatch),
    definition: Option(Reference),
  )
}

pub fn medication_new() -> Medication {
  Medication(
    definition: None,
    batch: None,
    ingredient: [],
    total_volume: None,
    dose_form: None,
    marketing_authorization_holder: None,
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

pub fn medication_batch_new() -> MedicationBatch {
  MedicationBatch(
    expiration_date: None,
    lot_number: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Medicationadminstatus,
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

pub fn medicationadministration_new(
  occurence,
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
    reason: [],
    performer: [],
    sub_potent_reason: [],
    is_sub_potent: None,
    recorded: None,
    occurence:,
    supporting_information: [],
    encounter: None,
    subject:,
    medication:,
    category: [],
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
    status: r5valuesets.Medicationdispensestatus,
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

pub fn medicationdispense_new(subject, medication, status) -> Medicationdispense {
  Medicationdispense(
    event_history: [],
    substitution: None,
    dosage_instruction: [],
    rendered_dosage_instruction: None,
    note: [],
    receiver: [],
    destination: None,
    when_handed_over: None,
    when_prepared: None,
    recorded: None,
    days_supply: None,
    quantity: None,
    type_: None,
    authorizing_prescription: [],
    location: None,
    performer: [],
    supporting_information: [],
    encounter: None,
    subject:,
    medication:,
    category: [],
    status_changed: None,
    not_performed_reason: None,
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

pub fn medicationdispense_performer_new(actor) -> MedicationdispensePerformer {
  MedicationdispensePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationdispense_substitution_new(
  was_substituted,
) -> MedicationdispenseSubstitution {
  MedicationdispenseSubstitution(
    responsible_party: None,
    reason: [],
    type_: None,
    was_substituted:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Medicationknowledgestatus),
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

pub fn medicationknowledge_new() -> Medicationknowledge {
  Medicationknowledge(
    definitional: None,
    regulatory: [],
    storage_guideline: [],
    clinical_use_issue: [],
    packaging: [],
    medicine_classification: [],
    indication_guideline: [],
    monitoring_program: [],
    cost: [],
    preparation_instruction: None,
    monograph: [],
    product_type: [],
    associated_medication: [],
    related_medication_knowledge: [],
    name: [],
    intended_jurisdiction: [],
    author: None,
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

pub fn medicationknowledge_monograph_new() -> MedicationknowledgeMonograph {
  MedicationknowledgeMonograph(
    source: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_cost_new(cost, type_) -> MedicationknowledgeCost {
  MedicationknowledgeCost(
    cost:,
    source: None,
    type_:,
    effective_date: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn medicationknowledge_monitoringprogram_new() -> MedicationknowledgeMonitoringprogram {
  MedicationknowledgeMonitoringprogram(
    name: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_indicationguideline_new() -> MedicationknowledgeIndicationguideline {
  MedicationknowledgeIndicationguideline(
    dosing_guideline: [],
    indication: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_indicationguideline_dosingguideline_new() -> MedicationknowledgeIndicationguidelineDosingguideline {
  MedicationknowledgeIndicationguidelineDosingguideline(
    patient_characteristic: [],
    administration_treatment: None,
    dosage: [],
    treatment_intent: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_indicationguideline_dosingguideline_dosage_new(
  type_,
) -> MedicationknowledgeIndicationguidelineDosingguidelineDosage {
  MedicationknowledgeIndicationguidelineDosingguidelineDosage(
    dosage: [],
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_indicationguideline_dosingguideline_patientcharacteristic_new(
  type_,
) -> MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristic {
  MedicationknowledgeIndicationguidelineDosingguidelinePatientcharacteristic(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_medicineclassification_new(
  type_,
) -> MedicationknowledgeMedicineclassification {
  MedicationknowledgeMedicineclassification(
    classification: [],
    source: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn medicationknowledge_packaging_new() -> MedicationknowledgePackaging {
  MedicationknowledgePackaging(
    packaged_product: None,
    cost: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_storageguideline_new() -> MedicationknowledgeStorageguideline {
  MedicationknowledgeStorageguideline(
    environmental_setting: [],
    stability_duration: None,
    note: [],
    reference: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_storageguideline_environmentalsetting_new(
  value,
  type_,
) -> MedicationknowledgeStorageguidelineEnvironmentalsetting {
  MedicationknowledgeStorageguidelineEnvironmentalsetting(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_definitional_new() -> MedicationknowledgeDefinitional {
  MedicationknowledgeDefinitional(
    drug_characteristic: [],
    ingredient: [],
    intended_route: [],
    dose_form: None,
    definition: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicationknowledge_definitional_ingredient_new(
  item,
) -> MedicationknowledgeDefinitionalIngredient {
  MedicationknowledgeDefinitionalIngredient(
    strength: None,
    type_: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn medicationknowledge_definitional_drugcharacteristic_new() -> MedicationknowledgeDefinitionalDrugcharacteristic {
  MedicationknowledgeDefinitionalDrugcharacteristic(
    value: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Medicationrequeststatus,
    status_reason: Option(Codeableconcept),
    status_changed: Option(String),
    intent: r5valuesets.Medicationrequestintent,
    category: List(Codeableconcept),
    priority: Option(r5valuesets.Requestpriority),
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

pub fn medicationrequest_new(
  subject,
  medication,
  intent,
  status,
) -> Medicationrequest {
  Medicationrequest(
    event_history: [],
    substitution: None,
    dispense_request: None,
    dosage_instruction: [],
    effective_dose_period: None,
    rendered_dosage_instruction: None,
    note: [],
    insurance: [],
    course_of_therapy_type: None,
    reason: [],
    recorder: None,
    device: [],
    performer: [],
    performer_type: None,
    reported: None,
    requester: None,
    authored_on: None,
    supporting_information: [],
    encounter: None,
    information_source: [],
    subject:,
    medication:,
    do_not_perform: None,
    priority: None,
    category: [],
    intent:,
    status_changed: None,
    status_reason: None,
    status:,
    group_identifier: None,
    prior_prescription: None,
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

pub fn medicationrequest_dispenserequest_new() -> MedicationrequestDispenserequest {
  MedicationrequestDispenserequest(
    dose_administration_aid: None,
    dispenser_instruction: [],
    dispenser: None,
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

pub fn medicationrequest_dispenserequest_initialfill_new() -> MedicationrequestDispenserequestInitialfill {
  MedicationrequestDispenserequestInitialfill(
    duration: None,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Medicationstatementstatus,
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

pub fn medicationstatement_new(
  subject,
  medication,
  status,
) -> Medicationstatement {
  Medicationstatement(
    adherence: None,
    dosage: [],
    rendered_dosage_instruction: None,
    related_clinical_information: [],
    note: [],
    reason: [],
    derived_from: [],
    information_source: [],
    date_asserted: None,
    effective: None,
    encounter: None,
    subject:,
    medication:,
    category: [],
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

pub fn medicationstatement_adherence_new(code) -> MedicationstatementAdherence {
  MedicationstatementAdherence(
    reason: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    comprised_of: [],
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

pub fn medicinalproductdefinition_name_new(
  product_name,
) -> MedicinalproductdefinitionName {
  MedicinalproductdefinitionName(
    usage: [],
    part: [],
    type_: None,
    product_name:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicinalproductdefinition_name_part_new(
  type_,
  part,
) -> MedicinalproductdefinitionNamePart {
  MedicinalproductdefinitionNamePart(
    type_:,
    part:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn medicinalproductdefinition_name_usage_new(
  language,
  country,
) -> MedicinalproductdefinitionNameUsage {
  MedicinalproductdefinitionNameUsage(
    language:,
    jurisdiction: None,
    country:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    category: Option(r5valuesets.Messagesignificancecategory),
    focus: List(MessagedefinitionFocus),
    response_required: Option(r5valuesets.Messageheaderresponserequest),
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

pub fn messagedefinition_new(event, date, status) -> Messagedefinition {
  Messagedefinition(
    graph: None,
    allowed_response: [],
    response_required: None,
    focus: [],
    category: None,
    event:,
    parent: [],
    base: None,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionFocus {
  MessagedefinitionFocus(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: r5valuesets.Resourcetypes,
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

pub fn messageheader_new(source, event) -> Messageheader {
  Messageheader(
    definition: None,
    focus: [],
    response: None,
    reason: None,
    responsible: None,
    source:,
    author: None,
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

pub fn messageheader_destination_new() -> MessageheaderDestination {
  MessageheaderDestination(
    receiver: None,
    target: None,
    name: None,
    endpoint: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn messageheader_source_new() -> MessageheaderSource {
  MessageheaderSource(
    contact: None,
    version: None,
    software: None,
    name: None,
    endpoint: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/MessageHeader#resource
pub type MessageheaderResponse {
  MessageheaderResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: Identifier,
    code: r5valuesets.Responsecode,
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
    status: r5valuesets.Publicationstatus,
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

pub fn metadataresource_new(status) -> Metadataresource {
  Metadataresource(
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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
    type_: Option(r5valuesets.Sequencetype),
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

pub fn molecularsequence_new() -> Molecularsequence {
  Molecularsequence(
    relative: [],
    formatted: [],
    literal: None,
    performer: None,
    device: None,
    specimen: None,
    focus: [],
    subject: None,
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

pub fn molecularsequence_relative_new(
  coordinate_system,
) -> MolecularsequenceRelative {
  MolecularsequenceRelative(
    edit: [],
    starting_sequence: None,
    sequence_range: None,
    ordinal_position: None,
    coordinate_system:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    orientation: Option(r5valuesets.Orientationtype),
    strand: Option(r5valuesets.Strandtype),
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

pub fn molecularsequence_relative_startingsequence_new() -> MolecularsequenceRelativeStartingsequence {
  MolecularsequenceRelativeStartingsequence(
    strand: None,
    orientation: None,
    window_end: None,
    window_start: None,
    sequence: None,
    chromosome: None,
    genome_assembly: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn molecularsequence_relative_edit_new() -> MolecularsequenceRelativeEdit {
  MolecularsequenceRelativeEdit(
    replaced_sequence: None,
    replacement_sequence: None,
    end: None,
    start: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
    kind: r5valuesets.Namingsystemtype,
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

pub fn namingsystem_new(date, kind, status, name) -> Namingsystem {
  Namingsystem(
    unique_id: [],
    usage: None,
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
    copyright: None,
    purpose: None,
    jurisdiction: [],
    use_context: [],
    description: None,
    type_: None,
    responsible: None,
    contact: [],
    publisher: None,
    date:,
    experimental: None,
    kind:,
    status:,
    title: None,
    name:,
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/NamingSystem#resource
pub type NamingsystemUniqueid {
  NamingsystemUniqueid(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Namingsystemidentifiertype,
    value: String,
    preferred: Option(Bool),
    comment: Option(String),
    period: Option(Period),
    authoritative: Option(Bool),
  )
}

pub fn namingsystem_uniqueid_new(value, type_) -> NamingsystemUniqueid {
  NamingsystemUniqueid(
    authoritative: None,
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
    status: r5valuesets.Eventstatus,
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

pub fn nutritionintake_new(subject, status) -> Nutritionintake {
  Nutritionintake(
    note: [],
    reason: [],
    derived_from: [],
    location: None,
    performer: [],
    ingredient_label: [],
    consumed_item: [],
    reported: None,
    recorded: None,
    occurrence: None,
    encounter: None,
    subject:,
    code: None,
    status_reason: [],
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

pub fn nutritionintake_consumeditem_new(
  nutrition_product,
  type_,
) -> NutritionintakeConsumeditem {
  NutritionintakeConsumeditem(
    not_consumed_reason: None,
    not_consumed: None,
    rate: None,
    amount: None,
    schedule: None,
    nutrition_product:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionintake_ingredientlabel_new(
  amount,
  nutrient,
) -> NutritionintakeIngredientlabel {
  NutritionintakeIngredientlabel(
    amount:,
    nutrient:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionintake_performer_new(actor) -> NutritionintakePerformer {
  NutritionintakePerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Requeststatus,
    intent: r5valuesets.Requestintent,
    priority: Option(r5valuesets.Requestpriority),
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

pub fn nutritionorder_new(date_time, subject, intent, status) -> Nutritionorder {
  Nutritionorder(
    note: [],
    enteral_formula: None,
    supplement: [],
    oral_diet: None,
    outside_food_allowed: None,
    exclude_food_modifier: [],
    food_preference_modifier: [],
    allergy_intolerance: [],
    performer: [],
    orderer: None,
    date_time:,
    supporting_information: [],
    encounter: None,
    subject:,
    priority: None,
    intent:,
    status:,
    group_identifier: None,
    based_on: [],
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

pub fn nutritionorder_oraldiet_new() -> NutritionorderOraldiet {
  NutritionorderOraldiet(
    instruction: None,
    fluid_consistency_type: [],
    texture: [],
    nutrient: [],
    schedule: None,
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_oraldiet_schedule_new() -> NutritionorderOraldietSchedule {
  NutritionorderOraldietSchedule(
    as_needed_for: None,
    as_needed: None,
    timing: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_oraldiet_nutrient_new() -> NutritionorderOraldietNutrient {
  NutritionorderOraldietNutrient(
    amount: None,
    modifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_oraldiet_texture_new() -> NutritionorderOraldietTexture {
  NutritionorderOraldietTexture(
    food_type: None,
    modifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_supplement_new() -> NutritionorderSupplement {
  NutritionorderSupplement(
    instruction: None,
    quantity: None,
    schedule: None,
    product_name: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_supplement_schedule_new() -> NutritionorderSupplementSchedule {
  NutritionorderSupplementSchedule(
    as_needed_for: None,
    as_needed: None,
    timing: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_enteralformula_new() -> NutritionorderEnteralformula {
  NutritionorderEnteralformula(
    administration_instruction: None,
    max_volume_to_deliver: None,
    administration: [],
    route_of_administration: None,
    caloric_density: None,
    additive: [],
    delivery_device: [],
    base_formula_product_name: None,
    base_formula_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_enteralformula_additive_new() -> NutritionorderEnteralformulaAdditive {
  NutritionorderEnteralformulaAdditive(
    quantity: None,
    product_name: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionorder_enteralformula_administration_schedule_new() -> NutritionorderEnteralformulaAdministrationSchedule {
  NutritionorderEnteralformulaAdministrationSchedule(
    as_needed_for: None,
    as_needed: None,
    timing: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Nutritionproductstatus,
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

pub fn nutritionproduct_new(status) -> Nutritionproduct {
  Nutritionproduct(
    note: [],
    instance: [],
    characteristic: [],
    known_allergen: [],
    ingredient: [],
    nutrient: [],
    manufacturer: [],
    category: [],
    status:,
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

pub fn nutritionproduct_nutrient_new() -> NutritionproductNutrient {
  NutritionproductNutrient(
    amount: [],
    item: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionproduct_ingredient_new(item) -> NutritionproductIngredient {
  NutritionproductIngredient(
    amount: [],
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn nutritionproduct_characteristic_new(
  value,
  type_,
) -> NutritionproductCharacteristic {
  NutritionproductCharacteristic(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn nutritionproduct_instance_new() -> NutritionproductInstance {
  NutritionproductInstance(
    biological_source_event: None,
    use_by: None,
    expiry: None,
    lot_number: None,
    name: None,
    identifier: [],
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Observationstatus,
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

pub fn observation_new(code, status) -> Observation {
  Observation(
    component: [],
    derived_from: [],
    has_member: [],
    reference_range: [],
    device: None,
    specimen: None,
    method: None,
    body_structure: None,
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
    triggered_by: [],
    based_on: [],
    instantiates: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Observation#resource
pub type ObservationTriggeredby {
  ObservationTriggeredby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    observation: Reference,
    type_: r5valuesets.Observationtriggeredbytype,
    reason: Option(String),
  )
}

pub fn observation_triggeredby_new(type_, observation) -> ObservationTriggeredby {
  ObservationTriggeredby(
    reason: None,
    type_:,
    observation:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn observation_referencerange_new() -> ObservationReferencerange {
  ObservationReferencerange(
    text: None,
    age: None,
    applies_to: [],
    type_: None,
    normal_value: None,
    high: None,
    low: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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
    permitted_data_type: List(r5valuesets.Permitteddatatype),
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

pub fn observationdefinition_new(code, status) -> Observationdefinition {
  Observationdefinition(
    component: [],
    has_member: [],
    qualified_value: [],
    permitted_unit: [],
    preferred_report_name: None,
    device: [],
    specimen: [],
    method: None,
    body_site: None,
    multiple_results_allowed: None,
    permitted_data_type: [],
    code:,
    category: [],
    performer_type: None,
    subject: [],
    derived_from_uri: [],
    derived_from_canonical: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedvalue {
  ObservationdefinitionQualifiedvalue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(r5valuesets.Administrativegender),
    age: Option(Range),
    gestational_age: Option(Range),
    condition: Option(String),
    range_category: Option(r5valuesets.Observationrangecategory),
    range: Option(Range),
    valid_coded_value_set: Option(String),
    normal_coded_value_set: Option(String),
    abnormal_coded_value_set: Option(String),
    critical_coded_value_set: Option(String),
  )
}

pub fn observationdefinition_qualifiedvalue_new() -> ObservationdefinitionQualifiedvalue {
  ObservationdefinitionQualifiedvalue(
    critical_coded_value_set: None,
    abnormal_coded_value_set: None,
    normal_coded_value_set: None,
    valid_coded_value_set: None,
    range: None,
    range_category: None,
    condition: None,
    gestational_age: None,
    age: None,
    gender: None,
    applies_to: [],
    context: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionComponent {
  ObservationdefinitionComponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
    permitted_data_type: List(r5valuesets.Permitteddatatype),
    permitted_unit: List(Coding),
    qualified_value: List(Nil),
  )
}

pub fn observationdefinition_component_new(
  code,
) -> ObservationdefinitionComponent {
  ObservationdefinitionComponent(
    qualified_value: [],
    permitted_unit: [],
    permitted_data_type: [],
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
    kind: r5valuesets.Operationkind,
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
    resource: List(r5valuesets.Versionindependentallresourcetypes),
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
    copyright_label: None,
    copyright: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameter {
  OperationdefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    use_: r5valuesets.Operationparameteruse,
    scope: List(r5valuesets.Operationparameterscope),
    min: Int,
    max: String,
    documentation: Option(String),
    type_: Option(r5valuesets.Fhirtypes),
    allowed_type: List(r5valuesets.Fhirtypes),
    target_profile: List(String),
    search_type: Option(r5valuesets.Searchparamtype),
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
    allowed_type: [],
    type_: None,
    documentation: None,
    max:,
    min:,
    scope: [],
    use_:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    strength: r5valuesets.Bindingstrength,
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

pub fn operationdefinition_overload_new() -> OperationdefinitionOverload {
  OperationdefinitionOverload(
    comment: None,
    parameter_name: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/OperationOutcome#resource
pub type OperationoutcomeIssue {
  OperationoutcomeIssue(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    severity: r5valuesets.Issueseverity,
    code: r5valuesets.Issuetype,
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

pub fn organization_new() -> Organization {
  Organization(
    qualification: [],
    endpoint: [],
    part_of: None,
    contact: [],
    description: None,
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

pub fn organization_qualification_new(code) -> OrganizationQualification {
  OrganizationQualification(
    issuer: None,
    period: None,
    code:,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn organizationaffiliation_new() -> Organizationaffiliation {
  Organizationaffiliation(
    endpoint: [],
    contact: [],
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

pub fn packagedproductdefinition_new() -> Packagedproductdefinition {
  Packagedproductdefinition(
    characteristic: [],
    packaging: None,
    attached_document: [],
    manufacturer: [],
    copackaged_indicator: None,
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

pub fn packagedproductdefinition_legalstatusofsupply_new() -> PackagedproductdefinitionLegalstatusofsupply {
  PackagedproductdefinitionLegalstatusofsupply(
    jurisdiction: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn packagedproductdefinition_packaging_new() -> PackagedproductdefinitionPackaging {
  PackagedproductdefinitionPackaging(
    packaging: [],
    contained_item: [],
    property: [],
    manufacturer: [],
    shelf_life_storage: [],
    alternate_material: [],
    material: [],
    quantity: None,
    component_part: None,
    type_: None,
    identifier: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn packagedproductdefinition_packaging_property_new(
  type_,
) -> PackagedproductdefinitionPackagingProperty {
  PackagedproductdefinitionPackagingProperty(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn packagedproductdefinition_packaging_containeditem_new(
  item,
) -> PackagedproductdefinitionPackagingContaineditem {
  PackagedproductdefinitionPackagingContaineditem(
    amount: None,
    item:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn parameters_new() -> Parameters {
  Parameters(
    parameter: [],
    language: None,
    implicit_rules: None,
    meta: None,
    id: None,
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
    gender: Option(r5valuesets.Administrativegender),
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
    gender: Option(r5valuesets.Administrativegender),
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

pub fn patient_communication_new(language) -> PatientCommunication {
  PatientCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: r5valuesets.Linktype,
  )
}

pub fn patient_link_new(type_, other) -> PatientLink {
  PatientLink(type_:, other:, modifier_extension: [], extension: [], id: None)
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
    status: r5valuesets.Fmstatus,
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

pub fn paymentnotice_new(amount, recipient, created, status) -> Paymentnotice {
  Paymentnotice(
    payment_status: None,
    amount:,
    recipient:,
    payee: None,
    payment_date: None,
    payment: None,
    reporter: None,
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
    status: r5valuesets.Fmstatus,
    kind: Option(Codeableconcept),
    period: Option(Period),
    created: String,
    enterer: Option(Reference),
    issuer_type: Option(Codeableconcept),
    payment_issuer: Option(Reference),
    request: Option(Reference),
    requestor: Option(Reference),
    outcome: Option(r5valuesets.Paymentoutcome),
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

pub fn paymentreconciliation_new(
  amount,
  date,
  created,
  status,
  type_,
) -> Paymentreconciliation {
  Paymentreconciliation(
    process_note: [],
    form_code: None,
    allocation: [],
    payment_identifier: None,
    amount:,
    returned_amount: None,
    tendered_amount: None,
    authorization: None,
    reference_number: None,
    processor: None,
    expiration_date: None,
    account_number: None,
    card_brand: None,
    method: None,
    location: None,
    date:,
    disposition: None,
    outcome: None,
    requestor: None,
    request: None,
    payment_issuer: None,
    issuer_type: None,
    enterer: None,
    created:,
    period: None,
    kind: None,
    status:,
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

pub fn paymentreconciliation_allocation_new() -> PaymentreconciliationAllocation {
  PaymentreconciliationAllocation(
    amount: None,
    payee: None,
    responsible: None,
    date: None,
    response: None,
    submitter: None,
    type_: None,
    account: None,
    encounter: None,
    target_item: None,
    target: None,
    predecessor: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Notetype),
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
    status: r5valuesets.Permissionstatus,
    asserter: Option(Reference),
    date: List(String),
    validity: Option(Period),
    justification: Option(PermissionJustification),
    combining: r5valuesets.Permissionrulecombining,
    rule: List(PermissionRule),
  )
}

pub fn permission_new(combining, status) -> Permission {
  Permission(
    rule: [],
    combining:,
    justification: None,
    validity: None,
    date: [],
    asserter: None,
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

pub fn permission_justification_new() -> PermissionJustification {
  PermissionJustification(
    evidence: [],
    basis: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRule {
  PermissionRule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Consentprovisiontype),
    data: List(PermissionRuleData),
    activity: List(PermissionRuleActivity),
    limit: List(Codeableconcept),
  )
}

pub fn permission_rule_new() -> PermissionRule {
  PermissionRule(
    limit: [],
    activity: [],
    data: [],
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn permission_rule_data_new() -> PermissionRuleData {
  PermissionRuleData(
    expression: None,
    period: [],
    security: [],
    resource: [],
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Permission#resource
pub type PermissionRuleDataResource {
  PermissionRuleDataResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: r5valuesets.Consentdatameaning,
    reference: Reference,
  )
}

pub fn permission_rule_data_resource_new(
  reference,
  meaning,
) -> PermissionRuleDataResource {
  PermissionRuleDataResource(
    reference:,
    meaning:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn permission_rule_activity_new() -> PermissionRuleActivity {
  PermissionRuleActivity(
    purpose: [],
    action: [],
    actor: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    gender: Option(r5valuesets.Administrativegender),
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

pub fn person_new() -> Person {
  Person(
    link: [],
    managing_organization: None,
    communication: [],
    photo: [],
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

pub fn person_communication_new(language) -> PersonCommunication {
  PersonCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(r5valuesets.Identityassurancelevel),
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
    status: r5valuesets.Publicationstatus,
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

pub fn plandefinition_new(status) -> Plandefinition {
  Plandefinition(
    as_needed: None,
    action: [],
    actor: [],
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
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn plandefinition_actor_new() -> PlandefinitionActor {
  PlandefinitionActor(
    option: [],
    description: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActorOption {
  PlandefinitionActorOption(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Actionparticipanttype),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
  )
}

pub fn plandefinition_actor_option_new() -> PlandefinitionActorOption {
  PlandefinitionActorOption(
    role: None,
    type_reference: None,
    type_canonical: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    priority: Option(r5valuesets.Requestpriority),
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
    grouping_behavior: Option(r5valuesets.Actiongroupingbehavior),
    selection_behavior: Option(r5valuesets.Actionselectionbehavior),
    required_behavior: Option(r5valuesets.Actionrequiredbehavior),
    precheck_behavior: Option(r5valuesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r5valuesets.Actioncardinalitybehavior),
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
    location: None,
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
    code: None,
    priority: None,
    text_equivalent: None,
    description: None,
    title: None,
    prefix: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r5valuesets.Actionconditionkind,
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

pub fn plandefinition_action_input_new() -> PlandefinitionActionInput {
  PlandefinitionActionInput(
    related_data: None,
    requirement: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn plandefinition_action_output_new() -> PlandefinitionActionOutput {
  PlandefinitionActionOutput(
    related_data: None,
    requirement: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target_id: String,
    relationship: r5valuesets.Actionrelationshiptype,
    end_relationship: Option(r5valuesets.Actionrelationshiptype),
    offset: Option(PlandefinitionActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedactionOffset {
  PlandefinitionActionRelatedactionOffsetDuration(offset: Duration)
  PlandefinitionActionRelatedactionOffsetRange(offset: Range)
}

pub fn plandefinition_action_relatedaction_new(
  relationship,
  target_id,
) -> PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    offset: None,
    end_relationship: None,
    relationship:,
    target_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor_id: Option(String),
    type_: Option(r5valuesets.Actionparticipanttype),
    type_canonical: Option(String),
    type_reference: Option(Reference),
    role: Option(Codeableconcept),
    function: Option(Codeableconcept),
  )
}

pub fn plandefinition_action_participant_new() -> PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    function: None,
    role: None,
    type_reference: None,
    type_canonical: None,
    type_: None,
    actor_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn plandefinition_action_dynamicvalue_new() -> PlandefinitionActionDynamicvalue {
  PlandefinitionActionDynamicvalue(
    expression: None,
    path: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    gender: Option(r5valuesets.Administrativegender),
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

pub fn practitioner_new() -> Practitioner {
  Practitioner(
    communication: [],
    qualification: [],
    photo: [],
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

pub fn practitioner_communication_new(language) -> PractitionerCommunication {
  PractitionerCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn practitionerrole_new() -> Practitionerrole {
  Practitionerrole(
    endpoint: [],
    availability: [],
    communication: [],
    characteristic: [],
    contact: [],
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
    status: r5valuesets.Eventstatus,
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

pub fn procedure_new(subject, status) -> Procedure {
  Procedure(
    supporting_info: [],
    used: [],
    focal_device: [],
    note: [],
    follow_up: [],
    complication: [],
    report: [],
    outcome: None,
    body_site: [],
    reason: [],
    location: None,
    performer: [],
    reported: None,
    recorder: None,
    recorded: None,
    occurrence: None,
    encounter: None,
    focus: None,
    subject:,
    code: None,
    category: [],
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

pub fn procedure_performer_new(actor) -> ProcedurePerformer {
  ProcedurePerformer(
    period: None,
    on_behalf_of: None,
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn procedure_focaldevice_new(manipulated) -> ProcedureFocaldevice {
  ProcedureFocaldevice(
    manipulated:,
    action: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn provenance_new() -> Provenance {
  Provenance(
    signature: [],
    entity: [],
    agent: [],
    encounter: None,
    patient: None,
    based_on: [],
    activity: None,
    authorization: [],
    location: None,
    policy: [],
    recorded: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Provenance#resource
pub type ProvenanceEntity {
  ProvenanceEntity(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    role: r5valuesets.Provenanceentityrole,
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
    status: r5valuesets.Publicationstatus,
    experimental: Option(Bool),
    subject_type: List(r5valuesets.Resourcetypes),
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

pub fn questionnaire_new(status) -> Questionnaire {
  Questionnaire(
    item: [],
    code: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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
    type_: r5valuesets.Itemtype,
    enable_when: List(QuestionnaireItemEnablewhen),
    enable_behavior: Option(r5valuesets.Questionnaireenablebehavior),
    disabled_display: Option(r5valuesets.Questionnairedisableddisplay),
    required: Option(Bool),
    repeats: Option(Bool),
    read_only: Option(Bool),
    max_length: Option(Int),
    answer_constraint: Option(r5valuesets.Questionnaireanswerconstraint),
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
    answer_constraint: None,
    max_length: None,
    read_only: None,
    repeats: None,
    required: None,
    disabled_display: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Questionnaire#resource
pub type QuestionnaireItemEnablewhen {
  QuestionnaireItemEnablewhen(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    question: String,
    operator: r5valuesets.Questionnaireenableoperator,
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

pub fn questionnaire_item_initial_new(value) -> QuestionnaireItemInitial {
  QuestionnaireItemInitial(
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Questionnaireanswersstatus,
    subject: Option(Reference),
    encounter: Option(Reference),
    authored: Option(String),
    author: Option(Reference),
    source: Option(Reference),
    item: List(QuestionnaireresponseItem),
  )
}

pub fn questionnaireresponse_new(status, questionnaire) -> Questionnaireresponse {
  Questionnaireresponse(
    item: [],
    source: None,
    author: None,
    authored: None,
    encounter: None,
    subject: None,
    status:,
    questionnaire:,
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

pub fn questionnaireresponse_item_answer_new(
  value,
) -> QuestionnaireresponseItemAnswer {
  QuestionnaireresponseItemAnswer(
    item: [],
    value:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn regulatedauthorization_new() -> Regulatedauthorization {
  Regulatedauthorization(
    case_: None,
    attached_document: [],
    regulator: None,
    holder: None,
    basis: [],
    intended_use: None,
    indication: [],
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
    gender: Option(r5valuesets.Administrativegender),
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

pub fn relatedperson_communication_new(language) -> RelatedpersonCommunication {
  RelatedpersonCommunication(
    preferred: None,
    language:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Requeststatus,
    intent: r5valuesets.Requestintent,
    priority: Option(r5valuesets.Requestpriority),
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

pub fn requestorchestration_new(intent, status) -> Requestorchestration {
  Requestorchestration(
    action: [],
    note: [],
    goal: [],
    reason: [],
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
    priority: Option(r5valuesets.Requestpriority),
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
    grouping_behavior: Option(r5valuesets.Actiongroupingbehavior),
    selection_behavior: Option(r5valuesets.Actionselectionbehavior),
    required_behavior: Option(r5valuesets.Actionrequiredbehavior),
    precheck_behavior: Option(r5valuesets.Actionprecheckbehavior),
    cardinality_behavior: Option(r5valuesets.Actioncardinalitybehavior),
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

pub fn requestorchestration_action_new() -> RequestorchestrationAction {
  RequestorchestrationAction(
    action: [],
    dynamic_value: [],
    transform: None,
    definition: None,
    resource: None,
    cardinality_behavior: None,
    precheck_behavior: None,
    required_behavior: None,
    selection_behavior: None,
    grouping_behavior: None,
    type_: None,
    participant: [],
    location: None,
    timing: None,
    related_action: [],
    output: [],
    input: [],
    condition: [],
    goal: [],
    documentation: [],
    code: [],
    priority: None,
    text_equivalent: None,
    description: None,
    title: None,
    prefix: None,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionCondition {
  RequestorchestrationActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: r5valuesets.Actionconditionkind,
    expression: Option(Expression),
  )
}

pub fn requestorchestration_action_condition_new(
  kind,
) -> RequestorchestrationActionCondition {
  RequestorchestrationActionCondition(
    expression: None,
    kind:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn requestorchestration_action_input_new() -> RequestorchestrationActionInput {
  RequestorchestrationActionInput(
    related_data: None,
    requirement: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn requestorchestration_action_output_new() -> RequestorchestrationActionOutput {
  RequestorchestrationActionOutput(
    related_data: None,
    requirement: None,
    title: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionRelatedaction {
  RequestorchestrationActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target_id: String,
    relationship: r5valuesets.Actionrelationshiptype,
    end_relationship: Option(r5valuesets.Actionrelationshiptype),
    offset: Option(RequestorchestrationActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionRelatedactionOffset {
  RequestorchestrationActionRelatedactionOffsetDuration(offset: Duration)
  RequestorchestrationActionRelatedactionOffsetRange(offset: Range)
}

pub fn requestorchestration_action_relatedaction_new(
  relationship,
  target_id,
) -> RequestorchestrationActionRelatedaction {
  RequestorchestrationActionRelatedaction(
    offset: None,
    end_relationship: None,
    relationship:,
    target_id:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/RequestOrchestration#resource
pub type RequestorchestrationActionParticipant {
  RequestorchestrationActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(r5valuesets.Actionparticipanttype),
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

pub fn requestorchestration_action_participant_new() -> RequestorchestrationActionParticipant {
  RequestorchestrationActionParticipant(
    actor: None,
    function: None,
    role: None,
    type_reference: None,
    type_canonical: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn requestorchestration_action_dynamicvalue_new() -> RequestorchestrationActionDynamicvalue {
  RequestorchestrationActionDynamicvalue(
    expression: None,
    path: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn requirements_new(status) -> Requirements {
  Requirements(
    statement: [],
    actor: [],
    reference: [],
    derived_from: [],
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/Requirements#resource
pub type RequirementsStatement {
  RequirementsStatement(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    key: String,
    label: Option(String),
    conformance: List(r5valuesets.Conformanceexpectation),
    conditionality: Option(Bool),
    requirement: String,
    derived_from: Option(String),
    parent: Option(String),
    satisfied_by: List(String),
    reference: List(String),
    source: List(Reference),
  )
}

pub fn requirements_statement_new(requirement, key) -> RequirementsStatement {
  RequirementsStatement(
    source: [],
    reference: [],
    satisfied_by: [],
    parent: None,
    derived_from: None,
    requirement:,
    conditionality: None,
    conformance: [],
    label: None,
    key:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn researchstudy_new(status) -> Researchstudy {
  Researchstudy(
    result: [],
    outcome_measure: [],
    objective: [],
    comparison_group: [],
    recruitment: None,
    why_stopped: None,
    progress_status: [],
    associated_party: [],
    classifier: [],
    note: [],
    site: [],
    period: None,
    description: None,
    description_summary: None,
    region: [],
    keyword: [],
    condition: [],
    focus: [],
    study_design: [],
    phase: None,
    primary_purpose_type: None,
    status:,
    date: None,
    related_artifact: [],
    part_of: [],
    protocol: [],
    label: [],
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

pub fn researchstudy_label_new() -> ResearchstudyLabel {
  ResearchstudyLabel(
    value: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_associatedparty_new(role) -> ResearchstudyAssociatedparty {
  ResearchstudyAssociatedparty(
    party: None,
    classifier: [],
    period: [],
    role:,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_progressstatus_new(state) -> ResearchstudyProgressstatus {
  ResearchstudyProgressstatus(
    period: None,
    actual: None,
    state:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_recruitment_new() -> ResearchstudyRecruitment {
  ResearchstudyRecruitment(
    actual_group: None,
    eligibility: None,
    actual_number: None,
    target_number: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_comparisongroup_new(name) -> ResearchstudyComparisongroup {
  ResearchstudyComparisongroup(
    observed_group: None,
    intended_exposure: [],
    description: None,
    type_: None,
    name:,
    link_id: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_objective_new() -> ResearchstudyObjective {
  ResearchstudyObjective(
    description: None,
    type_: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn researchstudy_outcomemeasure_new() -> ResearchstudyOutcomemeasure {
  ResearchstudyOutcomemeasure(
    reference: None,
    description: None,
    type_: [],
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
    progress: List(ResearchsubjectProgress),
    period: Option(Period),
    study: Reference,
    subject: Reference,
    assigned_comparison_group: Option(String),
    actual_comparison_group: Option(String),
    consent: List(Reference),
  )
}

pub fn researchsubject_new(subject, study, status) -> Researchsubject {
  Researchsubject(
    consent: [],
    actual_comparison_group: None,
    assigned_comparison_group: None,
    subject:,
    study:,
    period: None,
    progress: [],
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

pub fn researchsubject_progress_new() -> ResearchsubjectProgress {
  ResearchsubjectProgress(
    end_date: None,
    start_date: None,
    reason: None,
    milestone: None,
    subject_state: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Observationstatus,
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

pub fn riskassessment_new(subject, status) -> Riskassessment {
  Riskassessment(
    note: [],
    mitigation: None,
    prediction: [],
    basis: [],
    reason: [],
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

pub fn schedule_new() -> Schedule {
  Schedule(
    comment: None,
    planning_horizon: None,
    actor: [],
    name: None,
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
    status: r5valuesets.Publicationstatus,
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
    base: List(r5valuesets.Versionindependentallresourcetypes),
    type_: r5valuesets.Searchparamtype,
    expression: Option(String),
    processing_mode: Option(r5valuesets.Searchprocessingmode),
    constraint: Option(String),
    target: List(r5valuesets.Versionindependentallresourcetypes),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(r5valuesets.Searchcomparator),
    modifier: List(r5valuesets.Searchmodifiercode),
    chain: List(String),
    component: List(SearchparameterComponent),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/SearchParameter#resource
pub type SearchparameterVersionalgorithm {
  SearchparameterVersionalgorithmString(version_algorithm: String)
  SearchparameterVersionalgorithmCoding(version_algorithm: Coding)
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
    constraint: None,
    processing_mode: None,
    expression: None,
    type_:,
    base: [],
    code:,
    copyright_label: None,
    copyright: None,
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
    title: None,
    name:,
    version_algorithm: None,
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
    status: r5valuesets.Requeststatus,
    intent: r5valuesets.Requestintent,
    category: List(Codeableconcept),
    priority: Option(r5valuesets.Requestpriority),
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

pub fn servicerequest_new(subject, intent, status) -> Servicerequest {
  Servicerequest(
    relevant_history: [],
    patient_instruction: [],
    note: [],
    body_structure: None,
    body_site: [],
    specimen: [],
    supporting_info: [],
    insurance: [],
    reason: [],
    location: [],
    performer: [],
    performer_type: None,
    requester: None,
    authored_on: None,
    as_needed: None,
    occurrence: None,
    encounter: None,
    focus: [],
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

pub fn servicerequest_orderdetail_new() -> ServicerequestOrderdetail {
  ServicerequestOrderdetail(
    parameter: [],
    parameter_focus: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn servicerequest_orderdetail_parameter_new(
  value,
  code,
) -> ServicerequestOrderdetailParameter {
  ServicerequestOrderdetailParameter(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn servicerequest_patientinstruction_new() -> ServicerequestPatientinstruction {
  ServicerequestPatientinstruction(
    instruction: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Slotstatus,
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
    appointment_type: [],
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
    status: Option(r5valuesets.Specimenstatus),
    type_: Option(Codeableconcept),
    subject: Option(Reference),
    received_time: Option(String),
    parent: List(Reference),
    request: List(Reference),
    combined: Option(r5valuesets.Specimencombined),
    role: List(Codeableconcept),
    feature: List(SpecimenFeature),
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
    feature: [],
    role: [],
    combined: None,
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

pub fn specimen_feature_new(description, type_) -> SpecimenFeature {
  SpecimenFeature(
    description:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn specimen_collection_new() -> SpecimenCollection {
  SpecimenCollection(
    fasting_status: None,
    body_site: None,
    procedure: None,
    device: None,
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

pub fn specimen_processing_new() -> SpecimenProcessing {
  SpecimenProcessing(
    time: None,
    additive: [],
    method: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn specimen_container_new(device) -> SpecimenContainer {
  SpecimenContainer(
    specimen_quantity: None,
    location: None,
    device:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn specimendefinition_new(status) -> Specimendefinition {
  Specimendefinition(
    type_tested: [],
    collection: [],
    time_aspect: None,
    patient_preparation: [],
    type_collected: None,
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
    copyright: None,
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
    derived_from_uri: [],
    derived_from_canonical: [],
    title: None,
    name: None,
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/SpecimenDefinition#resource
pub type SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    is_derived: Option(Bool),
    type_: Option(Codeableconcept),
    preference: r5valuesets.Specimencontainedpreference,
    container: Option(SpecimendefinitionTypetestedContainer),
    requirement: Option(String),
    retention_time: Option(Duration),
    single_use: Option(Bool),
    rejection_criterion: List(Codeableconcept),
    handling: List(SpecimendefinitionTypetestedHandling),
    testing_destination: List(Codeableconcept),
  )
}

pub fn specimendefinition_typetested_new(
  preference,
) -> SpecimendefinitionTypetested {
  SpecimendefinitionTypetested(
    testing_destination: [],
    handling: [],
    rejection_criterion: [],
    single_use: None,
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
    status: r5valuesets.Publicationstatus,
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
    fhir_version: Option(r5valuesets.Fhirversion),
    mapping: List(StructuredefinitionMapping),
    kind: r5valuesets.Structuredefinitionkind,
    abstract: Bool,
    context: List(StructuredefinitionContext),
    context_invariant: List(String),
    type_: String,
    base_definition: Option(String),
    derivation: Option(r5valuesets.Typederivationrule),
    snapshot: Option(StructuredefinitionSnapshot),
    differential: Option(StructuredefinitionDifferential),
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionVersionalgorithm {
  StructuredefinitionVersionalgorithmString(version_algorithm: String)
  StructuredefinitionVersionalgorithmCoding(version_algorithm: Coding)
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
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Extensioncontexttype,
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

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/StructureDefinition#resource
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
    status: r5valuesets.Publicationstatus,
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

pub fn structuremap_new(status, name, url) -> Structuremap {
  Structuremap(
    group: [],
    const_: [],
    import_: [],
    structure: [],
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapStructure {
  StructuremapStructure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    url: String,
    mode: r5valuesets.Mapmodelmode,
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

pub fn structuremap_const_new() -> StructuremapConst {
  StructuremapConst(
    value: None,
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    type_mode: Option(r5valuesets.Mapgrouptypemode),
    documentation: Option(String),
    input: List(StructuremapGroupInput),
    rule: List(StructuremapGroupRule),
  )
}

pub fn structuremap_group_new(name) -> StructuremapGroup {
  StructuremapGroup(
    rule: [],
    input: [],
    documentation: None,
    type_mode: None,
    extends: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    mode: r5valuesets.Mapinputmode,
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

pub fn structuremap_group_rule_new() -> StructuremapGroupRule {
  StructuremapGroupRule(
    documentation: None,
    dependent: [],
    rule: [],
    target: [],
    source: [],
    name: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    list_mode: Option(r5valuesets.Mapsourcelistmode),
    variable: Option(String),
    condition: Option(String),
    check: Option(String),
    log_message: Option(String),
  )
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

///http://hl7.org/fhir/r5/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(String),
    element: Option(String),
    variable: Option(String),
    list_mode: List(r5valuesets.Maptargetlistmode),
    list_rule_id: Option(String),
    transform: Option(r5valuesets.Maptransform),
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
    context: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn structuremap_group_rule_dependent_new(
  name,
) -> StructuremapGroupRuleDependent {
  StructuremapGroupRuleDependent(
    parameter: [],
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Subscriptionstatus,
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
    content: Option(r5valuesets.Subscriptionpayloadcontent),
    max_count: Option(Int),
  )
}

pub fn subscription_new(channel_type, topic, status) -> Subscription {
  Subscription(
    max_count: None,
    content: None,
    content_type: None,
    timeout: None,
    heartbeat_period: None,
    parameter: [],
    endpoint: None,
    channel_type:,
    filter_by: [],
    reason: None,
    managing_entity: None,
    end: None,
    contact: [],
    topic:,
    status:,
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

///http://hl7.org/fhir/r5/StructureDefinition/Subscription#resource
pub type SubscriptionFilterby {
  SubscriptionFilterby(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_type: Option(String),
    filter_parameter: String,
    comparator: Option(r5valuesets.Searchcomparator),
    modifier: Option(r5valuesets.Searchmodifiercode),
    value: String,
  )
}

pub fn subscription_filterby_new(
  value,
  filter_parameter,
) -> SubscriptionFilterby {
  SubscriptionFilterby(
    value:,
    modifier: None,
    comparator: None,
    filter_parameter:,
    resource_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn subscription_parameter_new(value, name) -> SubscriptionParameter {
  SubscriptionParameter(
    value:,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Subscriptionstatus),
    type_: r5valuesets.Subscriptionnotificationtype,
    events_since_subscription_start: Option(Int),
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
    status: r5valuesets.Publicationstatus,
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

pub fn subscriptiontopic_new(status, url) -> Subscriptiontopic {
  Subscriptiontopic(
    notification_shape: [],
    can_filter_by: [],
    event_trigger: [],
    resource_trigger: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    name: None,
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetrigger {
  SubscriptiontopicResourcetrigger(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    resource: String,
    supported_interaction: List(r5valuesets.Interactiontrigger),
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

///http://hl7.org/fhir/r5/StructureDefinition/SubscriptionTopic#resource
pub type SubscriptiontopicResourcetriggerQuerycriteria {
  SubscriptiontopicResourcetriggerQuerycriteria(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    previous: Option(String),
    result_for_create: Option(r5valuesets.Subscriptiontopiccrbehavior),
    current: Option(String),
    result_for_delete: Option(r5valuesets.Subscriptiontopiccrbehavior),
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
    comparator: List(r5valuesets.Searchcomparator),
    modifier: List(r5valuesets.Searchmodifiercode),
  )
}

pub fn subscriptiontopic_canfilterby_new(
  filter_parameter,
) -> SubscriptiontopicCanfilterby {
  SubscriptiontopicCanfilterby(
    modifier: [],
    comparator: [],
    filter_definition: None,
    filter_parameter:,
    resource: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Substancestatus),
    category: List(Codeableconcept),
    code: Codeablereference,
    description: Option(String),
    expiry: Option(String),
    quantity: Option(Quantity),
    ingredient: List(SubstanceIngredient),
  )
}

pub fn substance_new(code, instance) -> Substance {
  Substance(
    ingredient: [],
    quantity: None,
    expiry: None,
    description: None,
    code:,
    category: [],
    status: None,
    instance:,
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

pub fn substance_ingredient_new(substance) -> SubstanceIngredient {
  SubstanceIngredient(
    substance:,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn substancedefinition_new() -> Substancedefinition {
  Substancedefinition(
    source_material: None,
    protein: None,
    polymer: None,
    nucleic_acid: None,
    relationship: [],
    name: [],
    code: [],
    structure: None,
    molecular_weight: [],
    reference_information: None,
    property: [],
    characterization: [],
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

pub fn substancedefinition_characterization_new() -> SubstancedefinitionCharacterization {
  SubstancedefinitionCharacterization(
    file: [],
    description: None,
    form: None,
    technique: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancedefinition_property_new(type_) -> SubstancedefinitionProperty {
  SubstancedefinitionProperty(
    value: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn substancepolymer_new() -> Substancepolymer {
  Substancepolymer(
    repeat: [],
    monomer_set: [],
    modification: None,
    copolymer_connectivity: [],
    geometry: None,
    class: None,
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

pub fn substancepolymer_monomerset_new() -> SubstancepolymerMonomerset {
  SubstancepolymerMonomerset(
    starting_material: [],
    ratio_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancepolymer_monomerset_startingmaterial_new() -> SubstancepolymerMonomersetStartingmaterial {
  SubstancepolymerMonomersetStartingmaterial(
    amount: None,
    is_defining: None,
    category: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancepolymer_repeat_new() -> SubstancepolymerRepeat {
  SubstancepolymerRepeat(
    repeat_unit: [],
    repeat_unit_amount_type: None,
    average_molecular_formula: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancepolymer_repeat_repeatunit_new() -> SubstancepolymerRepeatRepeatunit {
  SubstancepolymerRepeatRepeatunit(
    structural_representation: [],
    degree_of_polymerisation: [],
    amount: None,
    orientation: None,
    unit: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancepolymer_repeat_repeatunit_degreeofpolymerisation_new() -> SubstancepolymerRepeatRepeatunitDegreeofpolymerisation {
  SubstancepolymerRepeatRepeatunitDegreeofpolymerisation(
    high: None,
    low: None,
    average: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancepolymer_repeat_repeatunit_structuralrepresentation_new() -> SubstancepolymerRepeatRepeatunitStructuralrepresentation {
  SubstancepolymerRepeatRepeatunitStructuralrepresentation(
    attachment: None,
    format: None,
    representation: None,
    type_: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancereferenceinformation_new() -> Substancereferenceinformation {
  Substancereferenceinformation(
    target: [],
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

pub fn substancesourcematerial_fractiondescription_new() -> SubstancesourcematerialFractiondescription {
  SubstancesourcematerialFractiondescription(
    material_type: None,
    fraction: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancesourcematerial_organism_author_new() -> SubstancesourcematerialOrganismAuthor {
  SubstancesourcematerialOrganismAuthor(
    author_description: None,
    author_type: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn substancesourcematerial_partdescription_new() -> SubstancesourcematerialPartdescription {
  SubstancesourcematerialPartdescription(
    part_location: None,
    part: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Supplydeliverystatus),
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

pub fn supplydelivery_new() -> Supplydelivery {
  Supplydelivery(
    receiver: [],
    destination: None,
    supplier: None,
    occurrence: None,
    supplied_item: [],
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

pub fn supplydelivery_supplieditem_new() -> SupplydeliverySupplieditem {
  SupplydeliverySupplieditem(
    item: None,
    quantity: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: Option(r5valuesets.Supplyrequeststatus),
    based_on: List(Reference),
    category: Option(Codeableconcept),
    priority: Option(r5valuesets.Requestpriority),
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

pub fn supplyrequest_new(quantity, item) -> Supplyrequest {
  Supplyrequest(
    deliver_to: None,
    deliver_from: None,
    reason: [],
    supplier: [],
    requester: None,
    authored_on: None,
    occurrence: None,
    parameter: [],
    quantity:,
    item:,
    deliver_for: None,
    priority: None,
    category: None,
    based_on: [],
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

pub fn supplyrequest_parameter_new() -> SupplyrequestParameter {
  SupplyrequestParameter(
    value: None,
    code: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Taskstatus,
    status_reason: Option(Codeablereference),
    business_status: Option(Codeableconcept),
    intent: r5valuesets.Taskintent,
    priority: Option(r5valuesets.Requestpriority),
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

pub fn task_new(intent, status) -> Task {
  Task(
    output: [],
    input: [],
    restriction: None,
    relevant_history: [],
    note: [],
    insurance: [],
    reason: [],
    location: None,
    performer: [],
    owner: None,
    requested_performer: [],
    requester: None,
    last_modified: None,
    authored_on: None,
    execution_period: None,
    requested_period: None,
    encounter: None,
    for: None,
    focus: None,
    description: None,
    code: None,
    do_not_perform: None,
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

pub fn task_performer_new(actor) -> TaskPerformer {
  TaskPerformer(
    actor:,
    function: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn task_input_new(value, type_) -> TaskInput {
  TaskInput(value:, type_:, modifier_extension: [], extension: [], id: None)
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

pub fn task_output_new(value, type_) -> TaskOutput {
  TaskOutput(value:, type_:, modifier_extension: [], extension: [], id: None)
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
    status: r5valuesets.Publicationstatus,
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
    kind: r5valuesets.Capabilitystatementkind,
    software: Option(TerminologycapabilitiesSoftware),
    implementation: Option(TerminologycapabilitiesImplementation),
    locked_date: Option(Bool),
    code_system: List(TerminologycapabilitiesCodesystem),
    expansion: Option(TerminologycapabilitiesExpansion),
    code_search: Option(r5valuesets.Codesearchsupport),
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
    copyright_label: None,
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
    version_algorithm: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesCodesystem {
  TerminologycapabilitiesCodesystem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    uri: Option(String),
    version: List(TerminologycapabilitiesCodesystemVersion),
    content: r5valuesets.Codesystemcontentmode,
    subsumption: Option(Bool),
  )
}

pub fn terminologycapabilities_codesystem_new(
  content,
) -> TerminologycapabilitiesCodesystem {
  TerminologycapabilitiesCodesystem(
    subsumption: None,
    content:,
    version: [],
    uri: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    language: List(r5valuesets.Languages),
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

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
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

///http://hl7.org/fhir/r5/StructureDefinition/TerminologyCapabilities#resource
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
    status: r5valuesets.Publicationstatus,
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

pub fn testplan_new(status) -> Testplan {
  Testplan(
    test_case: [],
    exit_criteria: None,
    dependency: [],
    test_tools: None,
    scope: [],
    category: [],
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn testplan_dependency_new() -> TestplanDependency {
  TestplanDependency(
    predecessor: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testplan_testcase_new() -> TestplanTestcase {
  TestplanTestcase(
    assertion: [],
    test_data: [],
    test_run: [],
    dependency: [],
    scope: [],
    sequence: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testplan_testcase_dependency_new() -> TestplanTestcaseDependency {
  TestplanTestcaseDependency(
    predecessor: None,
    description: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testplan_testcase_testrun_new() -> TestplanTestcaseTestrun {
  TestplanTestcaseTestrun(
    script: None,
    narrative: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testplan_testcase_testrun_script_new() -> TestplanTestcaseTestrunScript {
  TestplanTestcaseTestrunScript(
    source: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn testplan_testcase_testdata_new(type_) -> TestplanTestcaseTestdata {
  TestplanTestcaseTestdata(
    source: None,
    content: None,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn testplan_testcase_assertion_new() -> TestplanTestcaseAssertion {
  TestplanTestcaseAssertion(
    result: [],
    object: [],
    type_: [],
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Reportstatuscodes,
    test_script: String,
    result: r5valuesets.Reportresultcodes,
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

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportParticipant {
  TestreportParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: r5valuesets.Reportparticipanttype,
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

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
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

pub fn testreport_setup_action_new() -> TestreportSetupAction {
  TestreportSetupAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionOperation {
  TestreportSetupActionOperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r5valuesets.Reportactionresultcodes,
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

///http://hl7.org/fhir/r5/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: r5valuesets.Reportactionresultcodes,
    message: Option(String),
    detail: Option(String),
    requirement: List(TestreportSetupActionAssertRequirement),
  )
}

pub fn testreport_setup_action_assert_new(result) -> TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    requirement: [],
    detail: None,
    message: None,
    result:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testreport_setup_action_assert_requirement_new() -> TestreportSetupActionAssertRequirement {
  TestreportSetupActionAssertRequirement(
    link: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn testreport_test_action_new() -> TestreportTestAction {
  TestreportTestAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testreport_teardown_new() -> TestreportTeardown {
  TestreportTeardown(
    action: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testreport_teardown_action_new(operation) -> TestreportTeardownAction {
  TestreportTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Publicationstatus,
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

pub fn testscript_new(status, name) -> Testscript {
  Testscript(
    teardown: None,
    test_: [],
    setup: None,
    variable: [],
    profile: [],
    fixture: [],
    scope: [],
    metadata: None,
    destination: [],
    origin: [],
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn testscript_origin_new(profile, index) -> TestscriptOrigin {
  TestscriptOrigin(
    url: None,
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_destination_new(profile, index) -> TestscriptDestination {
  TestscriptDestination(
    url: None,
    profile:,
    index:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_metadata_new() -> TestscriptMetadata {
  TestscriptMetadata(
    capability: [],
    link: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_metadata_link_new(url) -> TestscriptMetadataLink {
  TestscriptMetadataLink(
    description: None,
    url:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_scope_new(artifact) -> TestscriptScope {
  TestscriptScope(
    phase: None,
    conformance: None,
    artifact:,
    modifier_extension: [],
    extension: [],
    id: None,
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

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
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

pub fn testscript_setup_action_new() -> TestscriptSetupAction {
  TestscriptSetupAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    method: Option(r5valuesets.Httpoperations),
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

///http://hl7.org/fhir/r5/StructureDefinition/TestScript#resource
pub type TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    label: Option(String),
    description: Option(String),
    direction: Option(r5valuesets.Assertdirectioncodes),
    compare_to_source_id: Option(String),
    compare_to_source_expression: Option(String),
    compare_to_source_path: Option(String),
    content_type: Option(String),
    default_manual_completion: Option(r5valuesets.Assertmanualcompletioncodes),
    expression: Option(String),
    header_field: Option(String),
    minimum_id: Option(String),
    navigation_links: Option(Bool),
    operator: Option(r5valuesets.Assertoperatorcodes),
    path: Option(String),
    request_method: Option(r5valuesets.Httpoperations),
    request_url: Option(String),
    resource: Option(String),
    response: Option(r5valuesets.Assertresponsecodetypes),
    response_code: Option(String),
    source_id: Option(String),
    stop_test_on_fail: Bool,
    validate_profile_id: Option(String),
    value: Option(String),
    warning_only: Bool,
    requirement: List(TestscriptSetupActionAssertRequirement),
  )
}

pub fn testscript_setup_action_assert_new(
  warning_only,
  stop_test_on_fail,
) -> TestscriptSetupActionAssert {
  TestscriptSetupActionAssert(
    requirement: [],
    warning_only:,
    value: None,
    validate_profile_id: None,
    stop_test_on_fail:,
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
    default_manual_completion: None,
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

pub fn testscript_setup_action_assert_requirement_new() -> TestscriptSetupActionAssertRequirement {
  TestscriptSetupActionAssertRequirement(
    link: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn testscript_test_action_new() -> TestscriptTestAction {
  TestscriptTestAction(
    assert_: None,
    operation: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_teardown_new() -> TestscriptTeardown {
  TestscriptTeardown(
    action: [],
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn testscript_teardown_action_new(operation) -> TestscriptTeardownAction {
  TestscriptTeardownAction(
    operation:,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: Option(r5valuesets.Transportstatus),
    status_reason: Option(Codeableconcept),
    intent: r5valuesets.Transportintent,
    priority: Option(r5valuesets.Requestpriority),
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

pub fn transport_new(current_location, requested_location, intent) -> Transport {
  Transport(
    history: None,
    reason: None,
    current_location:,
    requested_location:,
    output: [],
    input: [],
    restriction: None,
    relevant_history: [],
    note: [],
    insurance: [],
    location: None,
    owner: None,
    performer_type: [],
    requester: None,
    last_modified: None,
    authored_on: None,
    completion_time: None,
    encounter: None,
    for: None,
    focus: None,
    description: None,
    code: None,
    priority: None,
    intent:,
    status_reason: None,
    status: None,
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

pub fn transport_restriction_new() -> TransportRestriction {
  TransportRestriction(
    recipient: [],
    period: None,
    repetitions: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn transport_input_new(value, type_) -> TransportInput {
  TransportInput(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn transport_output_new(value, type_) -> TransportOutput {
  TransportOutput(
    value:,
    type_:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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
    status: r5valuesets.Publicationstatus,
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

pub fn valueset_new(status) -> Valueset {
  Valueset(
    scope: None,
    expansion: None,
    compose: None,
    related_artifact: [],
    endorser: [],
    reviewer: [],
    editor: [],
    author: [],
    topic: [],
    effective_period: None,
    last_review_date: None,
    approval_date: None,
    copyright_label: None,
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
    version_algorithm: None,
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

pub fn valueset_compose_new() -> ValuesetCompose {
  ValuesetCompose(
    property: [],
    exclude: [],
    include: [],
    inactive: None,
    locked_date: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn valueset_compose_include_new() -> ValuesetComposeInclude {
  ValuesetComposeInclude(
    copyright: None,
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

pub fn valueset_compose_include_concept_designation_new(
  value,
) -> ValuesetComposeIncludeConceptDesignation {
  ValuesetComposeIncludeConceptDesignation(
    value:,
    additional_use: [],
    use_: None,
    language: None,
    modifier_extension: [],
    extension: [],
    id: None,
  )
}

///http://hl7.org/fhir/r5/StructureDefinition/ValueSet#resource
pub type ValuesetComposeIncludeFilter {
  ValuesetComposeIncludeFilter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    property: String,
    op: r5valuesets.Filteroperator,
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

pub fn valueset_expansion_new(timestamp) -> ValuesetExpansion {
  ValuesetExpansion(
    contains: [],
    property: [],
    parameter: [],
    offset: None,
    total: None,
    timestamp:,
    next: None,
    identifier: None,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn valueset_expansion_parameter_new(name) -> ValuesetExpansionParameter {
  ValuesetExpansionParameter(
    value: None,
    name:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn valueset_expansion_property_new(code) -> ValuesetExpansionProperty {
  ValuesetExpansionProperty(
    uri: None,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
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

pub fn valueset_expansion_contains_new() -> ValuesetExpansionContains {
  ValuesetExpansionContains(
    contains: [],
    property: [],
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

pub fn valueset_expansion_contains_property_new(
  value,
  code,
) -> ValuesetExpansionContainsProperty {
  ValuesetExpansionContainsProperty(
    sub_property: [],
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn valueset_expansion_contains_property_subproperty_new(
  value,
  code,
) -> ValuesetExpansionContainsPropertySubproperty {
  ValuesetExpansionContainsPropertySubproperty(
    value:,
    code:,
    modifier_extension: [],
    extension: [],
    id: None,
  )
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

pub fn valueset_scope_new() -> ValuesetScope {
  ValuesetScope(
    exclusion_criteria: None,
    inclusion_criteria: None,
    modifier_extension: [],
    extension: [],
    id: None,
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
    status: r5valuesets.Verificationresultstatus,
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
    status: r5valuesets.Fmstatus,
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

///http://hl7.org/fhir/r5/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecification {
  VisionprescriptionLensspecification(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    product: Codeableconcept,
    eye: r5valuesets.Visioneyecodes,
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

///http://hl7.org/fhir/r5/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Float,
    base: r5valuesets.Visionbasecodes,
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
