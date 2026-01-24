# Working with resources

## [Import](#import)

```gleam
import r4
```

The r4/r4b/r5 packages provide Gleam types for resources, and types for the data types for elements in resources. They also provide encoder and to_json functions for each resource, and a [resource]_new() that creates a new resource with Option fields as None and List fields as [].

## [Primitive Type vs Complex Type](#primitive-vs-complex)

FHIR [primitive types](https://hl7.org/fhir/datatypes.html#primitive) are a single value. In Gleam, primitive types are a record's fields with a value, rather than with child fields. For example, the [Patient](https://hl7.org/fhir/R4/patient.html) resource has a Patient.active boolean field, which in Gleam is a Bool in [r4.Patient](https://hexdocs.pm/fhir/fhir/r4.html#Patient).

![Patient.Act](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/AllergyIntolerance.png)

```gleam
pub type Patient {
  Patient(
    ...
    active: Option(Bool),
    ...
  )
}
```

FHIR [complex types](https://hl7.org/fhir/datatypes.html#complex) have multiple child elements. In Gleam, complex types are custom types with a record of their child fields. For example, an [Address](https://hl7.org/fhir/datatypes.html#Address) has a bunch of fields, which all are in [r4.Address](https://hexdocs.pm/fhir/fhir/r4.html#Address).

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

## [BackboneElement](#backbone-element)

A backbone element is a group of fields specific to the resource the backbone element is in. In Gleam, backbone elements are custom types with a record of all their child fields, much like complex types except they are only used in one specific resource type. For example, Patient has a Contact backbone element r4.PatientContact. No other resources use that same patient contact type; even if they need a contact they can use their own contact backbone element or the shared [ContactDetail](https://build.fhir.org/metadatatypes.html#ContactDetail) complex type.

Backbone elements let resources have multiple of some group of field (using cardinality).

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

## [Cardinality](#cardinality)

[https://build.fhir.org/conformance-rules.html#cardinality](Cardinality) refers to how many of an element there can or must be.

| Cardinality | Definition | Gleam |
|------------|--------|-------------|
| `1..1` | One mandatory element | x |
| `0..1` | One optional element | Option(x) |
| `0..*` | Any number of elements | List(x) |
| `1..*` | Any >0 number of elements | List(x) |

Gleam's type system enforces that a `1..1` element must exist, so attempting to decode a JSON that does not have a `1..1` element will fail. Note this is not true for `1..*`, although in practice `1..1`, `0..1`, and `0..*` elements are far more common.

For example, a patient may have multiple Communication backbone elements, so the communication field in r4.Patient is a list.

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

A communication may optionally have the if it's the patient's preferred language, or may not, so the preferred field in r4.PatientCommunication is wrapped in an Option. Whereas a communication must have exactly one language, so the language field is not in an Option.

```gleam
pub type PatientCommunication {
  PatientCommunication(
    ...
    language: Codeableconcept,
    preferred: Option(Bool),
  )
}
```

## [Choice Element](#choice-element)

A choice element can be one of multiple types, so in Gleam they are custom types with multiple variants. For example, Patient.multipleBirth[x] can be either multipleBirthBoolean or multipleBirthInteger, which are the the two choices for r4.PatientMultiplebirth:

![Patient.multipleBirth[x]](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientMultiplebirth.png)

```gleam
pub type PatientMultiplebirth {
  PatientMultiplebirthBoolean(multiple_birth: Bool)
  PatientMultiplebirthInteger(multiple_birth: Int)
}
```

## [code](#code)
Many elements may have values only from some fixed set of [code](https://hl7.org/fhir/R4/datatypes.html#code) strings, such as Patient.gender, for which FHIR requires an [AdministrativeGender](https://hl7.org/fhir/R4/valueset-administrative-gender.html) of male | female | other | unknown. In Gleam, codes with a required binding are an enum. Fields without a specific required set of codes do not have an enum in Gleam and are instead a String.

![Patient.gender](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/PatientGender.png)

```gleam
pub type Patient {
  Patient(
    ...
    gender: Option(r4_valuesets.Administrativegender),
    ...
  )
}
```

## [ValueSet](#valueset)

r4_valuesets (or r4b/r5) provides valuesets for fields with that require a certain set of codes.

```gleam
pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}
```

## [Extension](#extension)

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
  ExtSimple(value: Option(ExtensionValue))
}
```

TODO example with updated extension

## [Coding](#coding)

In some code fields, FHIR does not require binding to a specific ValueSet. A [Coding](https://hl7.org/fhir/R4/datatypes.html#Coding) contains both a code field and the system field, which is a uri identifying the set of codes the code comes from. The display field provides a nicer string for human readers.

![TODO](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/TODO.png)

```gleam
TODO
```

## [CodeableConcept](#codeableconcept)

[CodeableConcept](https://hl7.org/fhir/R4/datatypes.html#CodeableConcept) represents one concept with a list of codings, so you can have the same concept in multiple systems.

TODO example

## [id vs Identifier](#id-vs-identifier)

All [https://hl7.org/fhir/R4/resource.html#Resource](resources have a logical id), which says where the resource is. For example, a patient with id 2cda5aad-e409-4070-9a15-e1c35c46ed5a would be at [https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a](https://r4.smarthealthit.org/Patient/2cda5aad-e409-4070-9a15-e1c35c46ed5a) if it exists on the r4.smarthealthit.org server. The FHIR server should always assign an id upon creating a resource, but a resource that has not yet been created by the server will not yet have an id, so id is an Option(String) in Gleam.

An [Identifier](https://build.fhir.org/datatypes.html#Identifier) is a business identifier with a meaning in some system, such as a patient's MRN in a hospital. For instance, the system could be http://hl7.org/fhir/sid/us-ssn for US social security numbers or http://ns.electronichealth.net.au/id/hi/ihi/1.0 for Australian Individual Healthcare Identifier numbers. Not all resourcs have an Identifier (e.g. [AuditEvent](https://hl7.org/fhir/R4/auditevent.html#resource)). A resource with `0..*` Identifier cardinality can have multiple identifiers, which is List(Identifier) in Gleam. For example, a Patient may have an Identifier in many different systems.

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


## [Reference](#reference)

## [CodeableReference](#codeablereference)

## [Bundle](#bundle)

## [Patient Example](#patient-example)
