# Working with resources

## [Import](#import){#import}

```gleam
import r4
```

The r4/r4b/r5 packages provide Gleam types for resources, and types for the data types for elements in resources. They also provide `[resource]_encoder()` and `[resource]_to_json()` functions for each resource, and a `[resource]_new()` that creates a new resource with `Option` fields as `None` and `List` fields as `[]`.

## [Primitive Type](#primitivetype){#primitivetype}

FHIR [primitive types](https://hl7.org/fhir/datatypes.html#primitive) are a single value. In Gleam, primitive types are record fields with a single value, rather than with child fields. For example, the [Patient](https://hl7.org/fhir/R4/patient.html) resource has a Patient.active boolean element, which in Gleam is a `Bool` in [r4.Patient](https://hexdocs.pm/fhir/fhir/r4.html#Patient).

![Patient.active](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientActive.JPG)

```gleam
pub type Patient {
  Patient(
    ...
    active: Option(Bool),
    ...
  )
}
```
## [Complex Type](#complextype){#complextype}

FHIR [complex types](https://hl7.org/fhir/datatypes.html#complex) have multiple child elements. In Gleam, complex types are custom types with a record of their child fields. For example, an [Address](https://hl7.org/fhir/datatypes.html#Address) has a bunch of elements, which all are in [r4.Address](https://hexdocs.pm/fhir/fhir/r4.html#Address).

![Address](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Address.png)
```gleam
pub type Address {
  Address(
    id: Option(String),
    extension: List(Extension),
    use_: Option(r4_valuesets.Addressuse),
    type_: Option(r4_valuesets.Addresstype),
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
```

## [BackboneElement](#backbone-element){#backbone-element}

A backbone element is a group of elements specific to the resource the backbone element is in. In Gleam, backbone elements are custom types with a record of all their child fields, much like complex types except they are only used in one specific resource type. For example, the [Patient.contact](https://hl7.org/fhir/R4/patient-definitions.html#Patient.contact) backbone element, r4.PatientContact in Gleam, is not used by any other resources. Whereas Patient.contact.telecom uses the [ContactPoint](https://hl7.org/fhir/R4/datatypes.html#ContactPoint) complex type, r4.Contactpoint in Gleam, which is used by many different resources.

Backbone elements let resources have multiple of some group of elements (using cardinality).

![PatientContact](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientContact.png)

```gleam
pub type PatientContact {
  PatientContact(
    id: Option(String),
    extension: List(Extension),
    modifier_extension: List(Extension),
    relationship: List(Codeableconcept),
    name: Option(Humanname),
    telecom: List(Contactpoint),
    address: Option(Address),
    gender: Option(r4_valuesets.Administrativegender),
    organization: Option(Reference),
    period: Option(Period),
  )
}
```

## [Cardinality](#cardinality){#cardinality}

[https://build.fhir.org/conformance-rules.html#cardinality](Cardinality) refers to how many of an element there can or must be.

| Cardinality | Definition | Gleam |
|------------|--------|-------------|
| `1..1` | One mandatory element | `x` |
| `0..1` | One optional element | `Option(x)` |
| `0..*` | Any number of elements | `List(x)` |
| `1..*` | Any >0 number of elements | `List(x)` |

Gleam's type system enforces that a `1..1` element must exist, so attempting to decode a JSON that does not have a `1..1` element will fail. Note this is not true for `1..*`, although in practice `1..1`, `0..1`, and `0..*` elements are far more common.

For example, a patient may have multiple Communication backbone elements, so the communication field in r4.Patient is a `List(PatientCommunication)`.

![PatientCommunication](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientCommunication.png)

```gleam
pub type Patient {
  Patient(
    ...
    communication: List(PatientCommunication),
    ...
  )
}
```

A communication may optionally have the if it's the patient's preferred language, or may not, so the preferred field in r4.PatientCommunication is wrapped in an `Option`. Whereas a communication must have exactly one language, so the language field is not in an `Option`.

```gleam
pub type PatientCommunication {
  PatientCommunication(
    ...
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}
```

## [Choice Element](#choice-element){#choice-element}

A choice element can be one of multiple types, so in Gleam they are custom types with multiple variants. For example, Patient.multipleBirth[x] can be either multipleBirthBoolean or multipleBirthInteger, which are the the two choices for r4.PatientMultiplebirth:

![Patient.multipleBirth[x]](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientMultiplebirth.png)

```gleam
pub type PatientMultiplebirth {
  PatientMultiplebirthBoolean(multiple_birth: Bool)
  PatientMultiplebirthInteger(multiple_birth: Int)
}
```
## [id vs Identifier](#id-vs-identifier){#id-vs-identifier}

All [resources](https://hl7.org/fhir/R4/resource.html#Resource) have an id, which says where the resource is. For example, a patient with id 2cda5aad-e409-4070-9a15-e1c35c46ed5a would be at [https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a](https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a) if it exists on the r4.smarthealthit.org server. The FHIR server should always assign an id upon creating a resource, but a resource that has not yet been created on the server will not yet have an id, so id is an `Option(String)` in Gleam.

An [Identifier](https://build.fhir.org/datatypes.html#Identifier) is a business identifier with a meaning in some system, such as a patient's MRN in a hospital. 
For instance, the system could be http://hl7.org/fhir/sid/us-ssn for US social security numbers or http://ns.electronichealth.net.au/id/hi/ihi/1.0 for Australian Individual Healthcare Identifier numbers. Not all resourcs have an Identifier (e.g. [AuditEvent](https://hl7.org/fhir/R4/auditevent.html#resource)). A resource with `0..*` Identifier cardinality can have multiple identifiers, which is `List(Identifier)` in Gleam. For example, a Patient may have an Identifier in many different systems.

```gleam
let identifier_list = [
  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: None,
    system: Some("https://github.com/synthetichealth/synthea"),
    value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("MR"),
          display: Some("Medical Record Number"),
          user_selected: None,
        ),
      ],
      text: Some("Medical Record Number"),
    )),
    system: Some("http://hospital.smarthealthit.org"),
    value: Some("73a7d6b7-0310-4fff-9b0b-7891a5e390f5"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("SS"),
          display: Some("Social Security Number"),
          user_selected: None,
        ),
      ],
      text: Some("Social Security Number"),
    )),
    system: Some("http://hl7.org/fhir/sid/us-ssn"),
    value: Some("999-91-2751"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("DL"),
          display: Some("Driver's License"),
          user_selected: None,
        ),
      ],
      text: Some("Driver's License"),
    )),
    system: Some("urn:oid:2.16.840.1.113883.4.3.25"),
    value: Some("S99987436"),
    period: None,
    assigner: None,
  ),

  Identifier(
    id: None,
    extension: [],
    use_: None,
    type_: Some(Codeableconcept(
      id: None,
      extension: [],
      coding: [
        Coding(
          id: None,
          extension: [],
          system: Some("http://terminology.hl7.org/CodeSystem/v2-0203"),
          version: None,
          code: Some("PPN"),
          display: Some("Passport Number"),
          user_selected: None,
        ),
      ],
      text: Some("Passport Number"),
    )),
    system: Some(
      "http://standardhealthrecord.org/fhir/StructureDefinition/passportNumber",
    ),
    value: Some("X60445896X"),
    period: None,
    assigner: None,
  ),
]
```


## [Reference](#reference){#reference}

A reference identifies another related resource. Reference only goes one direction, from source resource to target resource. The target resource being referenced does not know about the source resource with the reference, but can search for it using _revinclude.

There are two types of elements:
- **[canonical](https://build.fhir.org/datatypes.html#canonical)** has a stable URL to a resource of certain [types](https://build.fhir.org/resource.html#canonical) 
- **[Reference](https://build.fhir.org/references.html#reference)** can refer to any resource, by at least one of a reference or identifier (or extension)
    - Literal Reference.reference uses id
    - Logical Reference.identifier uses Identifier

Literal references are preferred as the id can be used to find the resource on the FHIR server, whereas logical references using Identifier are for when the Identifier refers to a target in some business context, but cannot be converted into a literal reference (e.g. a US Social Security Number cannot be used as an id or literal reference). 

![Reference](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Reference.JPG)

For instance, AllergyIntolerance.patient is a Reference element with cardinality `1..1`, meaning an AllergyIntolerance must reference a patient. Reference.reference Patient/272539c2-e516-4f16-8f47-573923bf9924 refers to the patient at [https://r4.smarthealthit.org/Patient/272539c2-e516-4f16-8f47-573923bf9924](https://r4.smarthealthit.org/Patient/272539c2-e516-4f16-8f47-573923bf9924) 

```gleam
let a =
  r4.Allergyintolerance(
    ...
    r4.Reference(
      id: None,
      extension: [],
      reference: Some("Patient/272539c2-e516-4f16-8f47-573923bf9924"),
      type_: None,
      identifier: None,
      display: None,
    ),
    ...
  )
```

Although FHIR specifies for each Reference element which types of target resource it can refer to, in Gleam there is one single Reference type which does not enforce target resource type.

## [code](#code){#code}

[code](https://hl7.org/fhir/R4/datatypes.html#code) elements must be [one of a set of strings](https://hl7.org/fhir/R4/terminologies.html)

Many code elements require using a specific ValueSet to draw from. For example, Patient.gender requires [AdministrativeGender](https://hl7.org/fhir/R4/valueset-administrative-gender.html). In Gleam, code elements with a required binding use an enum from r4_valuesets (or r4b/r5).

Other code elements do not have a required binding to a specific ValueSet. In Gleam these have no enum, and are defined as `String`.

Having stronger and weaker bindings lets FHIR keep interoperability simple and practical but also stay flexible enough to meet many terminology requirements. Required bindings to a specific valueset make it possible to use a type-safe enum, which makes them easy to work with in Gleam. [Coding](#coding) code elements are more powerful in that they can use any system of codes, and in Gleam are not type-safe.

[Extension](#extension) elements similarly let FHIR keep core elements relatively simple by allowing users to define new elements. 

![Patient.gender](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientGender.png)

```gleam
//In r4.gleam
pub type Patient {
  Patient(
    ...
    gender: Option(r4_valuesets.Administrativegender),
    ...
  )
}
```

```gleam
//In r4_valuesets.gleam
pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}
```

## [Coding](#coding){#coding}

[Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) contains both a code element and system element, which is a uri identifying the set that the code comes from. The display element provides a nicer string to show humans. In Gleam, both Coding.system and Coding.code are type `String`, meaning the compiler does not enforce that a code is valid in some system.

```gleam
let terrible_news =
  r4.Coding(
    ..r4.coding_new(),
    system: Some("http://snomed.info/sct"),
    code: Some("267425008"),
    display: Some("Lactose intolerance"),
  )
let another_way_to_put_it = r4.Coding(
    ..r4.coding_new(),
    system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
    code: Some("E73.9"),
  ),
```

## [CodeableConcept](#codeableconcept){#codeableconcept}

There are many different systems of codes for healthcare data, with many overlapping concepts. Hypothetically,
- system http://snomed.info/sct has code "260385009" meaning negative
- system https://acme.lab/resultcodes has code "NEG" meaning negative
Both mean negative, so we want a way to represent that single concept in multiple systems.

[CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents one concept with multiple Codings, so you can have the same concept as different codes in their respective systems. CodeableConcept also has an optional string element for the text the user selected. In Gleam, CodeableConcept.coding is type `List(Coding)` and CodeableConcept.text is type `Option(String)`.

For example, AllergyIntolerance.code can identify lactose intolerance in both SNOMED and ICD-10.

```gleam
let terrible_news =
  r4.Codeableconcept(
    id: None,
    extension: [],
    coding: [
      r4.Coding(
        ..r4.coding_new(),
        system: Some("http://snomed.info/sct"),
        code: Some("267425008"),
        display: Some("Lactose intolerance"),
      ),
      r4.Coding(
        ..r4.coding_new(),
        system: Some("http://hl7.org/fhir/sid/icd-10-cm"),
        code: Some("E73.9"),
      ),
    ],
    text: Some("Lactose intolerance"),
  )
```

## [CodeableReference](#codeablereference){#codeablereference}

[CodeableReference](https://build.fhir.org/references.html#codeablereference) exists only in R5; it does *not* exist in R4/R4B. 

>A common pattern in healthcare records is that a single element may refer to either a concept in principle, or a specific instance of the concept as seen in practice.

CodeableReference has both CodeableConcept and Reference, so it can refer to a general concept or a specific resource. For example, AllergyIntolerance.reaction.manifestation can have
- code "2070002" in the SNOMED CT clinical finding valueset, representing the general concept of burning sensation in eye
- Reference to an Observation resource, recording a specific instance of when someone had a burning sensation in their eye

![Manifestation](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Manifestation.JPG)

```gleam
let manifestation_1 =
  r5.Codeablereference(
    id: None,
    extension: [],
    concept: None,
    reference: Some(r5.Reference(
      id: None,
      extension: [],
      reference: Some("Observation/123"),
      type_: None,
      identifier: None,
      display: None,
    )),
  )

let manifestation_2 =
  r5.Codeablereference(
    id: None,
    extension: [],
    concept: Some(r5.Codeableconcept(
      id: None,
      extension: [],
      coding: [
        r5.Coding(
          id: None,
          extension: [],
          system: Some("http://snomed.info/sct"),
          version: None,
          code: Some("310008"),
          display: None,
          user_selected: None,
        ),
      ],
      text: None,
    )),
    reference: None,
  )
```

To recap, [code](https://hl7.org/fhir/R4/datatypes.html#code) comes from a set of values. [Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) has code plus system the code comes from. [CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents a concept in different systems using Coding list. [CodeableReference](https://build.fhir.org/references.html#codeablereference) can have a CodeableConcept with a general concept, or a Reference with a specific instance. 

## [Extension](#extension){#extension}

FHIR is used in many different systems and countries, making it very difficult for all systems to implement all requirements of all other systems, even though they may be valid requirements. FHIR therefore allows [Extensions](https://build.fhir.org/extensibility.html) to resources and datatypes.

> there can be no stigma associated with the use of extensions by any application, project, or standard - regardless of the institution or jurisdiction that uses or defines the extensions. The use of extensions is what allows the FHIR specification to retain a core simplicity for everyone.

An extension element may have either a value or more child extensions, but not both. So extensions become a tree: simple extensions as leaf nodes with values, and complex nodes as branch nodes with child extensions.

Extensions must have a uri for meaning. The value of an extension may be any primitive value.

![Extension](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Extension.png)

```gleam
pub type Extension {
  Extension(id: Option(String), url: String, ext: ExtensionSimpleOrComplex)
}

pub type ExtensionSimpleOrComplex {
  ExtComplex(children: List(Extension))
  ExtSimple(value: ExtensionValue)
}

pub type ExtensionValue {
  ExtensionValueBase64binary(value: String)
  ExtensionValueBoolean(value: Bool)
  ExtensionValueCanonical(value: String)
  ...
  ExtensionValueMeta(value: Meta)
}
```

```gleam
  let patient_example_sex_and_gender =
    "{
    \"resourceType\": \"Patient\",
    \"id\": \"patient-example-sex-and-gender\",
    \"text\": {
        \"status\": \"generated\",
        \"div\": \"<div>https://hl7.org/fhir/R5/patient-example-sex-and-gender.json.html</div>\"},
    \"extension\": [
        {
            \"url\"      : \"http://hl7.org/fhir/StructureDefinition/individual-genderIdentity\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://snomed.info/sct\",
                                \"code\"   : \"446141000124107\",
                                \"display\": \"Identifies as female gender (finding)\"
                            }
                        ]
                    }
                },
                { \"url\": \"period\", \"valuePeriod\": {\"start\": \"2001-05-06\"} },
                {
                    \"url\"        : \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001.\"
                }
            ]
        },
        {
            \"url\"      : \"http://hl7.org/fhir/StructureDefinition/individual-pronouns\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://loinc.org\",
                                \"code\"   : \"LA29519-8\",
                                \"display\": \"she/her/her/hers/herself\"
                            }
                        ]
                    }
                },
                { \"url\": \"period\", \"valuePeriod\": {\"start\": \"2001-05-06\"} },
                {
                    \"url\"        : \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001.\"
                }
            ]
        },
        {
            \"url\"      : \"http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://hl7.org/fhir/administrative-gender\",
                                \"code\"   : \"male\",
                                \"display\": \"Male\"
                            }
                        ]
                    }
                },
                {
                    \"url\": \"type\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://loinc.org\",
                                \"code\"   : \"76689-9\",
                                \"display\": \"Sex Assigned At Birth\"
                            }
                        ]
                    }
                },
                { \"url\": \"effectivePeriod\", \"valuePeriod\": {\"start\": \"1974-12-25\"} },
                {\"url\": \"acquisitionDate\", \"valueDateTime\": \"2005-12-06\"},
                {
                    \"url\": \"sourceDocument\",
                    \"valueCodeableReference\": { \"reference\": {\"reference\": \"DocumentReference/1\"} }
                },
                {\"url\": \"sourceField\", \"valueString\": \"SEX\"},
                {
                    \"url\": \"jurisdiction\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {\"system\": \"https://www.usps.com/\", \"code\": \"OH\", \"display\": \"Ohio\"}
                        ]
                    }
                },
                {
                    \"url\": \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001, but their birth certificate still indicates male.\"
                }
            ]
        },
        {
            \"url\"      : \"http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://hl7.org/fhir/administrative-gender\",
                                \"code\"   : \"male\",
                                \"display\": \"Male\"
                            }
                        ]
                    }
                },
                {
                    \"url\": \"type\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\": \"http://local-code-system.org/recorded-sex-or-gender-type\",
                                \"code\": \"insurance-card\",
                                \"display\": \"Insurance Card\"
                            }
                        ]
                    }
                },
                { \"url\": \"effectivePeriod\", \"valuePeriod\": {\"start\": \"2021-05-25\"} },
                {\"url\": \"acquisitionDate\", \"valueDateTime\": \"2021-06-06\"},
                {
                    \"url\": \"sourceDocument\",
                    \"valueCodeableReference\": { \"reference\": {\"reference\": \"DocumentReference/2\"} }
                },
                {\"url\": \"sourceField\", \"valueString\": \"SEX\"},
                {
                    \"url\": \"jurisdiction\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\": \"http://local-code-system.org/recorded-sex-or-gender-jurisdiction\",
                                \"code\": \"ICCA-P\",
                                \"display\": \"Indigo Crucifix Cobalt Aegis Payer\"
                            }
                        ]
                    }
                },
                {
                    \"url\": \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001, but their insurance card still indicates male.\"
                }
            ]
        },
        {
            \"url\"      : \"http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\" : \"http://ohio.example.gov/drivers-license-sex\",
                                \"code\"   : \"M\",
                                \"display\": \"Male\"
                            }
                        ]
                    }
                },
                {
                    \"url\": \"type\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\": \"http://jurisdiction-specific.example.com/document-type-code-system\",
                                \"code\": \"drivers-license\",
                                \"display\": \"Driver's License\"
                            }
                        ]
                    }
                },
                { \"url\": \"effectivePeriod\", \"valuePeriod\": {\"start\": \"1974-12-25\"} },
                {\"url\": \"acquisitionDate\", \"valueDateTime\": \"2005-12-06\"},
                {
                    \"url\": \"sourceDocument\",
                    \"valueCodeableReference\": { \"reference\": {\"reference\": \"DocumentReference/1\"} }
                },
                {
                    \"url\": \"jurisdiction\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {\"system\": \"https://www.usps.com/\", \"code\": \"OH\", \"display\": \"Ohio\"}
                        ]
                    }
                },
                {
                    \"url\": \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001, but their driver's license still indicates male.\"
                }
            ]
        },
        {
            \"url\": \"http://hl7.org/fhir/StructureDefinition/patient-sexParameterForClinicalUse\",
            \"extension\": [
                {
                    \"url\": \"value\",
                    \"valueCodeableConcept\": {
                        \"coding\": [
                            {
                                \"system\": \"http://terminology.hl7.org/CodeSystem/sex-parameter-for-clinical-use\",
                                \"code\": \"specified\",
                                \"display\": \"Apply specified setting or reference range\"
                            }
                        ]
                    }
                },
                { \"url\": \"period\", \"valuePeriod\": {\"start\": \"2002-07-13\"} },
                {
                    \"url\"        : \"comment\",
                    \"valueString\": \"Patient transitioned from male to female in 2001.\"
                },
                {
                    \"url\": \"supportingInfo\",
                    \"valueCodeableReference\": { \"reference\": {\"reference\": \"Observation/1\"} }
                },
                {
                    \"url\": \"supportingInfo\",
                    \"valueCodeableReference\": {
                        \"reference\": {\"reference\": \"MedicationStatement/2\"}
                    }
                }
            ]
        }
    ],
    \"identifier\": [
        {
            \"use\"   : \"usual\",
            \"type\"  : {
                \"coding\": [
                    {\"system\": \"http://terminology.hl7.org/CodeSystem/v2-0203\", \"code\": \"MR\"}
                ]
            },
            \"system\": \"urn:oid:1.2.36.146.595.217.0.1\",
            \"value\" : \"12345\"
        }
    ],
    \"active\": true,
    \"name\": [
        { \"use\": \"official\", \"family\": \"Roth\", \"given\": [\"Patrick\" ] },
        { \"use\": \"usual\",    \"family\": \"Roth\", \"given\": [\"Patricia\"] },
        { \"use\": \"nickname\",                   \"given\": [\"Pat\"     ] }
    ],
    \"gender\": \"male\",
    \"birthDate\": \"1974-12-25\",
    \"deceasedBoolean\": false,
    \"managingOrganization\": {\"reference\": \"Organization/1\"}
  }"
  let assert Ok(patient) =
    patient_example_sex_and_gender |> json.parse(r5.patient_decoder())
  // note r5, on r4 this json would fail to decode because
  // valueCodeableReference uses CodeableReference which is not in r4
```

## [Bundle](#bundle){#bundle}

FHIR uses [Bundle](https://build.fhir.org/bundle.html#resource) to list resources, so operations that return multiple resources, such as Search, will return a Bundle.  The element Bundle.entry has cardinality `0..*` so in Gleam it is `List(BundleEntry)`, and Bundle.entry.resource can be any resource so in Gleam `Resource` has a variant for each resource type.

```gleam
pub type Resource {
  ResourceAccount(Account)
  ResourceActivitydefinition(Activitydefinition)
  ResourceAdverseevent(Adverseevent)
  ResourceAllergyintolerance(Allergyintolerance)
  ResourceAppointment(Appointment)
  ...
  ResourceVisionprescription(Visionprescription)
}
```

## [Patient Example](#patient-example){#patient-example}

Note [Patient](https://hl7.org/fhir/R4/patient.html) has no required fields, so in Gleam `patient_new()` takes no arguments. By contrast, resources with elements of cardinality `1..1` require arguments as those elements cannot be `None`, for instance `allergyintolerance_new(reference_to_my_patient)` requires a reference to a patient resource (not an `r4.Patient` but an `r4.Reference`).

```gleam
let pat =
  r4.Patient(
    ..r4.patient_new(),
    name: [
      r4.Humanname(
        ..r4.humanname_new(),
        given: ["Anakin"],
        family: Some("Skywalker"),
      ),
    ],
    deceased: Some(r4.PatientDeceasedBoolean(False)),
  )
echo pat
let pat =
  r4.Patient(..pat, deceased: Some(r4.PatientDeceasedBoolean(True)), contact: [
    r4.PatientContact(
      ..r4.patient_contact_new(),
      relationship: [
        r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
          r4.Coding(
            ..r4.coding_new(),
            code: Some("N"),
            system: Some("http://terminology.hl7.org/CodeSystem/v2-0131"),
          ),
        ]),
      ],
      name: Some(
        r4.Humanname(
          ..r4.humanname_new(),
          given: ["Luke"],
          family: Some("Skywalker"),
        ),
      ),
      telecom: [
        r4.Contactpoint(
          ..r4.contactpoint_new(),
          system: Some(r4_valuesets.ContactpointsystemFax),
          value: Some("0123456789"),
          use_: Some(r4_valuesets.ContactpointuseWork),
        ),
      ],
    ),
  ])
echo pat
let pat_allergy = r4.patient_new()
```
