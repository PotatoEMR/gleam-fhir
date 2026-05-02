# reference

A reference identifies another related resource. Reference only goes one direction, from source resource to target resource. The target resource being referenced does not know about the source resource with the reference. The search operation can include referenced resources with the _include parameter, and references to a resource with _revinclude.

There are two types of elements:
- **[canonical](https://build.fhir.org/datatypes.html#canonical)** has a stable URL to a resource of certain [types](https://build.fhir.org/resource.html#canonical) 
- **[Reference](https://build.fhir.org/references.html#reference)** can refer to any resource, by at least one of a reference or identifier (or extension)
    - Literal Reference.reference uses id
    - Logical Reference.identifier uses Identifier

Literal references are preferred as the id can be used to find the resource on the FHIR server, whereas logical references using Identifier are for when the Identifier refers to a target in some business context, but cannot be converted into a literal reference (e.g. a US Social Security Number cannot be used as an id or literal reference). 

![Reference](https://github.com/PotatoEMR/gleam-fhir/raw/refs/heads/main/docs/static/Reference.JPG)

For instance, AllergyIntolerance.patient is a Reference element with cardinality `1..1`, meaning an AllergyIntolerance must reference a patient. Reference.reference Patient/272539c2-e516-4f16-8f47-573923bf9924 refers to the patient at [https://r4.smarthealthit.org/Patient/272539c2-e516-4f16-8f47-573923bf9924](https://r4.smarthealthit.org/Patient/272539c2-e516-4f16-8f47-573923bf9924) 

Although FHIR specifies for each Reference element which types of target resource it can refer to, in Gleam there is one single Reference type which does not enforce target resource type.

```gleam
import fhir/r4/complex_types as ct
import fhir/r4/resources

import gleam/option.{Some}

pub fn main() {
  let allergy =
    resources.Allergyintolerance(
      ..resources.allergyintolerance_new(patient: ct.Reference(
        ..ct.reference_new(),
        reference: Some("Patient/272539c2-e516-4f16-8f47-573923bf9924"),
      )),
      code: Some(
        ct.Codeableconcept(..ct.codeableconcept_new(), coding: [
          ct.Coding(
            ..ct.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("91936005"),
            display: Some("Allergy to penicillin"),
          ),
        ]),
      ),
    )
  echo allergy
}
```
