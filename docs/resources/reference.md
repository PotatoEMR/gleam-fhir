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
