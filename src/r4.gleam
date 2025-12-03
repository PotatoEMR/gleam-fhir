////FHIR r4 types
////https://hl7.org/fhir/r4

import gleam/option.{type Option}

///http://hl7.org/fhir/r4/StructureDefinition/Element#resource
pub type Element {
  Element(id: Option(String), extension: List(Extension))
}

///http://hl7.org/fhir/r4/StructureDefinition/Address#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Age#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeableConcept#resource
pub type Codeableconcept {
  Codeableconcept(
    id: Option(String),
    extension: List(Extension),
    coding: List(Coding),
    text: Option(String),
  )
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

///http://hl7.org/fhir/r4/StructureDefinition/ContactDetail#resource
pub type Contactdetail {
  Contactdetail(
    id: Option(String),
    extension: List(Extension),
    name: Option(String),
    telecom: List(Contactpoint),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ContactPoint#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Contributor#resource
pub type Contributor {
  Contributor(
    id: Option(String),
    extension: List(Extension),
    type_: String,
    name: String,
    contact: List(Contactdetail),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Count#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource
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
    limit: Option(Int),
    sort: List(Element),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DataRequirement#resource
pub type DatarequirementSubject {
  DatarequirementSubjectCodeableconcept(subject: Codeableconcept)
  DatarequirementSubjectReference(subject: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/Distance#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Duration#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/ElementDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/HumanName#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Identifier#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Money#resource
pub type Money {
  Money(
    id: Option(String),
    extension: List(Extension),
    value: Option(Float),
    currency: Option(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Narrative#resource
pub type Narrative {
  Narrative(
    id: Option(String),
    extension: List(Extension),
    status: String,
    div: String,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ParameterDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Period#resource
pub type Period {
  Period(
    id: Option(String),
    extension: List(Extension),
    start: Option(String),
    end: Option(String),
  )
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

///http://hl7.org/fhir/r4/StructureDefinition/Quantity#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Range#resource
pub type Range {
  Range(
    id: Option(String),
    extension: List(Extension),
    low: Option(Quantity),
    high: Option(Quantity),
  )
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

///http://hl7.org/fhir/r4/StructureDefinition/RelatedArtifact#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TriggerDefinition#resource
pub type Triggerdefinition {
  Triggerdefinition(
    id: Option(String),
    extension: List(Extension),
    type_: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/MoneyQuantity#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/SimpleQuantity#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Resource#resource
pub type Resource {
  Resource(
    id: Option(String),
    meta: Option(Meta),
    implicit_rules: Option(String),
    language: Option(String),
  )
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ActivityDefinition#resource
pub type ActivitydefinitionParticipant {
  ActivitydefinitionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    role: Option(Codeableconcept),
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
    actuality: String,
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
    type_: Option(String),
    category: List(String),
    criticality: Option(String),
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
    severity: Option(String),
    exposure_route: Option(Codeableconcept),
    note: List(Annotation),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Appointment#resource
pub type AppointmentParticipant {
  AppointmentParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: List(Codeableconcept),
    actor: Option(Reference),
    required: Option(String),
    status: String,
    period: Option(Period),
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
    participant_status: String,
    comment: Option(String),
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
    action: Option(String),
    period: Option(Period),
    recorded: String,
    outcome: Option(String),
    outcome_desc: Option(String),
    purpose_of_event: List(Codeableconcept),
    agent: List(AuditeventAgent),
    source: AuditeventSource,
    entity: List(AuditeventEntity),
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

///http://hl7.org/fhir/r4/StructureDefinition/AuditEvent#resource
pub type AuditeventAgentNetwork {
  AuditeventAgentNetwork(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    address: Option(String),
    type_: Option(String),
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
    product_category: Option(String),
    product_code: Option(Codeableconcept),
    status: Option(String),
    request: List(Reference),
    quantity: Option(Int),
    parent: List(Reference),
    collection: Option(BiologicallyderivedproductCollection),
    processing: List(BiologicallyderivedproductProcessing),
    manipulation: Option(BiologicallyderivedproductManipulation),
    storage: List(BiologicallyderivedproductStorage),
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

///http://hl7.org/fhir/r4/StructureDefinition/BiologicallyDerivedProduct#resource
pub type BiologicallyderivedproductStorage {
  BiologicallyderivedproductStorage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    temperature: Option(Float),
    scale: Option(String),
    duration: Option(Period),
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
pub type BundleEntrySearch {
  BundleEntrySearch(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: Option(String),
    score: Option(Float),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Bundle#resource
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
    kind: String,
    instantiates: List(String),
    imports: List(String),
    software: Option(CapabilitystatementSoftware),
    implementation: Option(CapabilitystatementImplementation),
    fhir_version: String,
    format: List(String),
    patch_format: List(String),
    implementation_guide: List(String),
    rest: List(CapabilitystatementRest),
    messaging: List(CapabilitystatementMessaging),
    document: List(CapabilitystatementDocument),
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
    conditional_delete: Option(String),
    reference_policy: List(String),
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(CapabilitystatementRestResourceSearchparam),
    operation: List(CapabilitystatementRestResourceOperation),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestResourceInteraction {
  CapabilitystatementRestResourceInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    documentation: Option(String),
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
    type_: String,
    documentation: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementRestInteraction {
  CapabilitystatementRestInteraction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    documentation: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
pub type CapabilitystatementMessagingSupportedmessage {
  CapabilitystatementMessagingSupportedmessage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    definition: String,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CapabilityStatement#resource
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
    status: String,
    intent: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CarePlan#resource
pub type CareplanActivityDetail {
  CareplanActivityDetail(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: Option(String),
    instantiates_canonical: List(String),
    instantiates_uri: List(String),
    code: Option(Codeableconcept),
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    goal: List(Reference),
    status: String,
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
    status: Option(String),
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
    status: Option(String),
    validity_period: Option(Period),
    valid_to: Option(String),
    last_updated: Option(String),
    additional_characteristic: List(Codeableconcept),
    additional_classification: List(Codeableconcept),
    related_entry: List(CatalogentryRelatedentry),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/CatalogEntry#resource
pub type CatalogentryRelatedentry {
  CatalogentryRelatedentry(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationtype: String,
    item: Reference,
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
    status: String,
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ChargeItemDefinition#resource
pub type ChargeitemdefinitionPropertygroupPricecomponent {
  ChargeitemdefinitionPropertygroupPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
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
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
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
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
    patient: Reference,
    created: String,
    insurer: Reference,
    requestor: Option(Reference),
    request: Option(Reference),
    outcome: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ClaimResponse#resource
pub type ClaimresponseProcessnote {
  ClaimresponseProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(String),
    text: String,
    language: Option(Codeableconcept),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/CodeSystem#resource
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
    reason_code: List(Codeableconcept),
    reason_reference: List(Reference),
    payload: List(CommunicationPayload),
    note: List(Annotation),
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
    status: String,
    status_reason: Option(Codeableconcept),
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

///http://hl7.org/fhir/r4/StructureDefinition/CompartmentDefinition#resource
pub type CompartmentdefinitionResource {
  CompartmentdefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    param: List(String),
    documentation: Option(String),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionAttester {
  CompositionAttester(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    time: Option(String),
    party: Option(Reference),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionRelatesto {
  CompositionRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    target: CompositionRelatestoTarget,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Composition#resource
pub type CompositionRelatestoTarget {
  CompositionRelatestoTargetIdentifier(target: Identifier)
  CompositionRelatestoTargetReference(target: Reference)
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
    mode: Option(String),
    ordered_by: Option(Codeableconcept),
    entry: List(Reference),
    empty_reason: Option(Codeableconcept),
    section: List(Nil),
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupElementTarget {
  ConceptmapGroupElementTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Option(String),
    display: Option(String),
    equivalence: String,
    comment: Option(String),
    depends_on: List(ConceptmapGroupElementTargetDependson),
    product: List(Nil),
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

///http://hl7.org/fhir/r4/StructureDefinition/ConceptMap#resource
pub type ConceptmapGroupUnmapped {
  ConceptmapGroupUnmapped(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    mode: String,
    code: Option(String),
    display: Option(String),
    url: Option(String),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvision {
  ConsentProvision(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/Consent#resource
pub type ConsentProvisionData {
  ConsentProvisionData(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    meaning: String,
    reference: Reference,
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
    publication_status: String,
    copyright: Option(String),
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
    status: String,
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
    status: String,
    priority: Option(Codeableconcept),
    purpose: List(String),
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
    status: String,
    purpose: List(String),
    patient: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseServiced {
  CoverageeligibilityresponseServicedDate(serviced: String)
  CoverageeligibilityresponseServicedPeriod(serviced: Period)
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

///http://hl7.org/fhir/r4/StructureDefinition/CoverageEligibilityResponse#resource
pub type CoverageeligibilityresponseError {
  CoverageeligibilityresponseError(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: Codeableconcept,
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
    status: String,
    code: Option(Codeableconcept),
    severity: Option(String),
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
    status: Option(String),
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
    entry_type: Option(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Device#resource
pub type DeviceDevicename {
  DeviceDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/DeviceDefinition#resource
pub type DevicedefinitionDevicename {
  DevicedefinitionDevicename(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    type_: String,
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
    operational_status: Option(String),
    color: Option(String),
    category: String,
    measurement_period: Option(Timing),
    calibration: List(DevicemetricCalibration),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/DeviceMetric#resource
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
    status: Option(String),
    intent: String,
    priority: Option(String),
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
    status: String,
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
    status: String,
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
    status: String,
    doc_status: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/DocumentReference#resource
pub type DocumentreferenceRelatesto {
  DocumentreferenceRelatesto(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    target: Reference,
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/EffectEvidenceSynthesis#resource
pub type EffectevidencesynthesisResultsbyexposure {
  EffectevidencesynthesisResultsbyexposure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    description: Option(String),
    exposure_state: Option(String),
    variant_state: Option(Codeableconcept),
    risk_evidence_synthesis: Reference,
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterStatushistory {
  EncounterStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    period: Period,
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

///http://hl7.org/fhir/r4/StructureDefinition/Encounter#resource
pub type EncounterLocation {
  EncounterLocation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    location: Reference,
    status: Option(String),
    physical_type: Option(Codeableconcept),
    period: Option(Period),
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
    status: String,
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
    status: Option(String),
    created: Option(String),
    insurer: Option(Reference),
    provider: Option(Reference),
    candidate: Option(Reference),
    coverage: Option(Reference),
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
    status: Option(String),
    request: Option(Reference),
    outcome: Option(String),
    disposition: Option(String),
    created: Option(String),
    organization: Option(Reference),
    request_provider: Option(Reference),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/EpisodeOfCare#resource
pub type EpisodeofcareStatushistory {
  EpisodeofcareStatushistory(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    status: String,
    period: Period,
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
    status: String,
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
    status: String,
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
    type_: Option(String),
    characteristic: List(EvidencevariableCharacteristic),
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
    group_measure: Option(String),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioActor {
  ExamplescenarioActor(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    actor_id: String,
    type_: String,
    name: Option(String),
    description: Option(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ExampleScenario#resource
pub type ExamplescenarioInstance {
  ExamplescenarioInstance(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    resource_id: String,
    resource_type: String,
    name: Option(String),
    description: Option(String),
    version: List(ExamplescenarioInstanceVersion),
    contained_instance: List(ExamplescenarioInstanceContainedinstance),
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
    status: String,
    type_: Codeableconcept,
    sub_type: Option(Codeableconcept),
    use_: String,
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
    outcome: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ExplanationOfBenefit#resource
pub type ExplanationofbenefitProcessnote {
  ExplanationofbenefitProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    number: Option(Int),
    type_: Option(String),
    text: Option(String),
    language: Option(Codeableconcept),
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
    status: String,
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
    status: String,
    category: List(Codeableconcept),
    code: Codeableconcept,
    subject: Reference,
    period: Option(Period),
    encounter: Option(Reference),
    author: Option(Reference),
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
    lifecycle_status: String,
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
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    start: String,
    profile: Option(String),
    link: List(GraphdefinitionLink),
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

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTarget {
  GraphdefinitionLinkTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    params: Option(String),
    profile: Option(String),
    compartment: List(GraphdefinitionLinkTargetCompartment),
    link: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/GraphDefinition#resource
pub type GraphdefinitionLinkTargetCompartment {
  GraphdefinitionLinkTargetCompartment(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    use_: String,
    code: String,
    rule: String,
    expression: Option(String),
    description: Option(String),
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
    type_: String,
    actual: Bool,
    code: Option(Codeableconcept),
    name: Option(String),
    quantity: Option(Int),
    managing_entity: Option(Reference),
    characteristic: List(GroupCharacteristic),
    member: List(GroupMember),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/HealthcareService#resource
pub type HealthcareserviceAvailabletime {
  HealthcareserviceAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
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
    status: String,
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
    status: String,
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
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: Option(String),
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    copyright: Option(String),
    package_id: String,
    license: Option(String),
    fhir_version: List(String),
    depends_on: List(ImplementationguideDependson),
    global: List(ImplementationguideGlobal),
    definition: Option(ImplementationguideDefinition),
    manifest: Option(ImplementationguideManifest),
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideGlobal {
  ImplementationguideGlobal(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    profile: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionResource {
  ImplementationguideDefinitionResource(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    reference: Reference,
    fhir_version: List(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPage {
  ImplementationguideDefinitionPage(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: ImplementationguideDefinitionPageName,
    title: String,
    generation: String,
    page: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionPageName {
  ImplementationguideDefinitionPageNameUrl(name: String)
  ImplementationguideDefinitionPageNameReference(name: Reference)
}

///http://hl7.org/fhir/r4/StructureDefinition/ImplementationGuide#resource
pub type ImplementationguideDefinitionParameter {
  ImplementationguideDefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    code: String,
    value: String,
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
    status: Option(String),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Invoice#resource
pub type InvoiceLineitemPricecomponent {
  InvoiceLineitemPricecomponent(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    code: Option(Codeableconcept),
    factor: Option(Float),
    amount: Option(Money),
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

///http://hl7.org/fhir/r4/StructureDefinition/Linkage#resource
pub type LinkageItem {
  LinkageItem(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    resource: Reference,
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
    status: String,
    mode: String,
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
    status: Option(String),
    operational_status: Option(Coding),
    name: Option(String),
    alias: List(String),
    description: Option(String),
    mode: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/Location#resource
pub type LocationHoursofoperation {
  LocationHoursofoperation(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    opening_time: Option(String),
    closing_time: Option(String),
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
    status: String,
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
    status: String,
    type_: String,
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
    status: String,
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
    status: Option(String),
    manufacturer: Option(Reference),
    form: Option(Codeableconcept),
    amount: Option(Ratio),
    ingredient: List(MedicationIngredient),
    batch: Option(MedicationBatch),
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
    status: String,
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
    status: String,
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
    status: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/MedicationKnowledge#resource
pub type MedicationknowledgeRegulatorySchedule {
  MedicationknowledgeRegulatorySchedule(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    schedule: Codeableconcept,
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
    status: String,
    status_reason: Option(Codeableconcept),
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
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
    status: String,
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
    base: Option(String),
    parent: List(String),
    event: MessagedefinitionEvent,
    category: Option(String),
    focus: List(MessagedefinitionFocus),
    response_required: Option(String),
    allowed_response: List(MessagedefinitionAllowedresponse),
    graph: List(String),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
pub type MessagedefinitionEvent {
  MessagedefinitionEventCoding(event: Coding)
  MessagedefinitionEventUri(event: String)
}

///http://hl7.org/fhir/r4/StructureDefinition/MessageDefinition#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/MessageHeader#resource
pub type MessageheaderResponse {
  MessageheaderResponse(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    identifier: String,
    code: String,
    details: Option(Reference),
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
    type_: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceReferenceseq {
  MolecularsequenceReferenceseq(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    chromosome: Option(Codeableconcept),
    genome_build: Option(String),
    orientation: Option(String),
    reference_seq_id: Option(Codeableconcept),
    reference_seq_pointer: Option(Reference),
    reference_seq_string: Option(String),
    strand: Option(String),
    window_start: Option(Int),
    window_end: Option(Int),
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceQuality {
  MolecularsequenceQuality(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/MolecularSequence#resource
pub type MolecularsequenceRepository {
  MolecularsequenceRepository(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    url: Option(String),
    name: Option(String),
    dataset_id: Option(String),
    variantset_id: Option(String),
    readset_id: Option(String),
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
    status: String,
    kind: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/NamingSystem#resource
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
    status: String,
    intent: String,
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
    permitted_data_type: List(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/ObservationDefinition#resource
pub type ObservationdefinitionQualifiedinterval {
  ObservationdefinitionQualifiedinterval(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    category: Option(String),
    range: Option(Range),
    context: Option(Codeableconcept),
    applies_to: List(Codeableconcept),
    gender: Option(String),
    age: Option(Range),
    gestational_age: Option(Range),
    condition: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameter {
  OperationdefinitionParameter(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    use_: String,
    min: Int,
    max: String,
    documentation: Option(String),
    type_: Option(String),
    target_profile: List(String),
    search_type: Option(String),
    binding: Option(OperationdefinitionParameterBinding),
    referenced_from: List(OperationdefinitionParameterReferencedfrom),
    part: List(Nil),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/OperationDefinition#resource
pub type OperationdefinitionParameterBinding {
  OperationdefinitionParameterBinding(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    strength: String,
    value_set: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/OperationOutcome#resource
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
    gender: Option(String),
    organization: Option(Reference),
    period: Option(Period),
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

///http://hl7.org/fhir/r4/StructureDefinition/Patient#resource
pub type PatientLink {
  PatientLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    other: Reference,
    type_: String,
  )
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
    status: String,
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
    status: String,
    period: Option(Period),
    created: String,
    payment_issuer: Option(Reference),
    request: Option(Reference),
    requestor: Option(Reference),
    outcome: Option(String),
    disposition: Option(String),
    payment_date: String,
    payment_amount: Money,
    payment_identifier: Option(Identifier),
    detail: List(PaymentreconciliationDetail),
    form_code: Option(Codeableconcept),
    process_note: List(PaymentreconciliationProcessnote),
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

///http://hl7.org/fhir/r4/StructureDefinition/PaymentReconciliation#resource
pub type PaymentreconciliationProcessnote {
  PaymentreconciliationProcessnote(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: Option(String),
    text: Option(String),
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
    gender: Option(String),
    birth_date: Option(String),
    address: List(Address),
    photo: Option(Attachment),
    managing_organization: Option(Reference),
    active: Option(Bool),
    link: List(PersonLink),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Person#resource
pub type PersonLink {
  PersonLink(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    target: Reference,
    assurance: Option(String),
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
    priority: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionCondition {
  PlandefinitionActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: String,
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedaction {
  PlandefinitionActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: String,
    offset: Option(PlandefinitionActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionRelatedactionOffset {
  PlandefinitionActionRelatedactionOffsetDuration(offset: Duration)
  PlandefinitionActionRelatedactionOffsetRange(offset: Range)
}

///http://hl7.org/fhir/r4/StructureDefinition/PlanDefinition#resource
pub type PlandefinitionActionParticipant {
  PlandefinitionActionParticipant(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    role: Option(Codeableconcept),
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
    gender: Option(String),
    birth_date: Option(String),
    photo: List(Attachment),
    qualification: List(PractitionerQualification),
    communication: List(Codeableconcept),
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

///http://hl7.org/fhir/r4/StructureDefinition/PractitionerRole#resource
pub type PractitionerroleAvailabletime {
  PractitionerroleAvailabletime(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    days_of_week: List(String),
    all_day: Option(Bool),
    available_start_time: Option(String),
    available_end_time: Option(String),
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
    status: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/Provenance#resource
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
    approval_date: Option(String),
    last_review_date: Option(String),
    effective_period: Option(Period),
    code: List(Coding),
    item: List(QuestionnaireItem),
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
    type_: String,
    enable_when: List(QuestionnaireItemEnablewhen),
    enable_behavior: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/Questionnaire#resource
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
    status: String,
    subject: Option(Reference),
    encounter: Option(Reference),
    authored: Option(String),
    author: Option(Reference),
    source: Option(Reference),
    item: List(QuestionnaireresponseItem),
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
    gender: Option(String),
    birth_date: Option(String),
    address: List(Address),
    photo: List(Attachment),
    period: Option(Period),
    communication: List(RelatedpersonCommunication),
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
    status: String,
    intent: String,
    priority: Option(String),
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
    priority: Option(String),
    code: List(Codeableconcept),
    documentation: List(Relatedartifact),
    condition: List(RequestgroupActionCondition),
    related_action: List(RequestgroupActionRelatedaction),
    timing: Option(RequestgroupActionTiming),
    participant: List(Reference),
    type_: Option(Codeableconcept),
    grouping_behavior: Option(String),
    selection_behavior: Option(String),
    required_behavior: Option(String),
    precheck_behavior: Option(String),
    cardinality_behavior: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionCondition {
  RequestgroupActionCondition(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    kind: String,
    expression: Option(Expression),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedaction {
  RequestgroupActionRelatedaction(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action_id: String,
    relationship: String,
    offset: Option(RequestgroupActionRelatedactionOffset),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/RequestGroup#resource
pub type RequestgroupActionRelatedactionOffset {
  RequestgroupActionRelatedactionOffsetDuration(offset: Duration)
  RequestgroupActionRelatedactionOffsetRange(offset: Range)
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
    status: String,
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
    status: String,
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
    type_: String,
    variable_type: Option(String),
    characteristic: List(ResearchelementdefinitionCharacteristic),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/ResearchElementDefinition#resource
pub type ResearchelementdefinitionSubject {
  ResearchelementdefinitionSubjectCodeableconcept(subject: Codeableconcept)
  ResearchelementdefinitionSubjectReference(subject: Reference)
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
    study_effective_group_measure: Option(String),
    participant_effective_description: Option(String),
    participant_effective: Option(
      ResearchelementdefinitionCharacteristicParticipanteffective,
    ),
    participant_effective_time_from_start: Option(Duration),
    participant_effective_group_measure: Option(String),
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
    status: String,
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
    status: String,
    period: Option(Period),
    study: Reference,
    individual: Reference,
    assigned_arm: Option(String),
    actual_arm: Option(String),
    consent: Option(Reference),
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
    status: String,
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
    status: String,
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
    status: String,
    experimental: Option(Bool),
    date: Option(String),
    publisher: Option(String),
    contact: List(Contactdetail),
    description: String,
    use_context: List(Usagecontext),
    jurisdiction: List(Codeableconcept),
    purpose: Option(String),
    code: String,
    base: List(String),
    type_: String,
    expression: Option(String),
    xpath: Option(String),
    xpath_usage: Option(String),
    target: List(String),
    multiple_or: Option(Bool),
    multiple_and: Option(Bool),
    comparator: List(String),
    modifier: List(String),
    chain: List(String),
    component: List(SearchparameterComponent),
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
    status: String,
    intent: String,
    category: List(Codeableconcept),
    priority: Option(String),
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
    status: String,
    start: String,
    end: String,
    overbooked: Option(Bool),
    comment: Option(String),
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
    status: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/SpecimenDefinition#resource
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
    rejection_criterion: List(Codeableconcept),
    handling: List(SpecimendefinitionTypetestedHandling),
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionContext {
  StructuredefinitionContext(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    expression: String,
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureDefinition#resource
pub type StructuredefinitionDifferential {
  StructuredefinitionDifferential(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    element: List(Elementdefinition),
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
    structure: List(StructuremapStructure),
    import_: List(String),
    group: List(StructuremapGroup),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroup {
  StructuremapGroup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    name: String,
    extends: Option(String),
    type_mode: String,
    documentation: Option(String),
    input: List(StructuremapGroupInput),
    rule: List(StructuremapGroupRule),
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
    mode: String,
    documentation: Option(String),
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
    list_mode: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/StructureMap#resource
pub type StructuremapGroupRuleTarget {
  StructuremapGroupRuleTarget(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    context: Option(String),
    context_type: Option(String),
    element: Option(String),
    variable: Option(String),
    list_mode: List(String),
    list_rule_id: Option(String),
    transform: Option(String),
    parameter: List(StructuremapGroupRuleTargetParameter),
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
    status: String,
    contact: List(Contactpoint),
    end: Option(String),
    reason: String,
    criteria: String,
    error: Option(String),
    channel: SubscriptionChannel,
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/Subscription#resource
pub type SubscriptionChannel {
  SubscriptionChannel(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    type_: String,
    endpoint: Option(String),
    payload: Option(String),
    header: List(String),
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
    status: Option(String),
    category: List(Codeableconcept),
    code: Codeableconcept,
    description: Option(String),
    instance: List(SubstanceInstance),
    ingredient: List(SubstanceIngredient),
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
    status: Option(String),
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
    status: Option(String),
    category: Option(Codeableconcept),
    priority: Option(String),
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
    status: String,
    status_reason: Option(Codeableconcept),
    business_status: Option(Codeableconcept),
    intent: String,
    priority: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesValidatecode {
  TerminologycapabilitiesValidatecode(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translations: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/TerminologyCapabilities#resource
pub type TerminologycapabilitiesClosure {
  TerminologycapabilitiesClosure(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    translation: Option(Bool),
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
    status: String,
    test_script: Reference,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportSetup {
  TestreportSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportSetupAction),
  )
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportSetupActionAssert {
  TestreportSetupActionAssert(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    result: String,
    message: Option(String),
    detail: Option(String),
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

///http://hl7.org/fhir/r4/StructureDefinition/TestReport#resource
pub type TestreportTeardown {
  TestreportTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestreportTeardownAction),
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptSetup {
  TestscriptSetup(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptSetupAction),
  )
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
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
    validate_profile_id: Option(String),
    value: Option(String),
    warning_only: Bool,
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

///http://hl7.org/fhir/r4/StructureDefinition/TestScript#resource
pub type TestscriptTeardown {
  TestscriptTeardown(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    action: List(TestscriptTeardownAction),
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
    compose: Option(ValuesetCompose),
    expansion: Option(ValuesetExpansion),
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

///http://hl7.org/fhir/r4/StructureDefinition/ValueSet#resource
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
    status: String,
    created: String,
    patient: Reference,
    encounter: Option(Reference),
    date_written: String,
    prescriber: Reference,
    lens_specification: List(VisionprescriptionLensspecification),
  )
}

///http://hl7.org/fhir/r4/StructureDefinition/VisionPrescription#resource
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

///http://hl7.org/fhir/r4/StructureDefinition/VisionPrescription#resource
pub type VisionprescriptionLensspecificationPrism {
  VisionprescriptionLensspecificationPrism(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    amount: Float,
    base: String,
  )
}
