# Serialization

## [JSON](#json){#json}

In Gleam, creating a JSON always succeeds. Parsing a JSON may return failure if elements are missing or invalid for their Gleam type.

Currently there are no lenient parsing options, e.g. for mostly valid resources with one or two missing fields, but this may change at some point. This package only supports JSON, with no plans for XML, GraphQL, protobuf, etc.

## [[type]_to_json](#tojson){#tojson}

Converts Gleam type to JSON, and for resources adds resource type such as
```json
"resourceType" : "AllergyIntolerance"
```

For example, `allergyintolerance_to_json` always returns a JSON.

```gleam
let original_allergy =
  r4.Allergyintolerance(
    ..r4.allergyintolerance_new(
      patient: r4.Reference(
        ..r4.reference_new(),
        reference: Some("Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112"),
      ),
    ),
    id: Some("9b6a76f1-ee00-4efc-828d-ffbae3cb4220"),
    meta: Some(
      r4.Meta(
        ..r4.meta_new(),
        version_id: Some("4"),
        last_updated: Some("2021-04-07T02:57:18.833-04:00"),
        tag: [
          r4.Coding(
            ..r4.coding_new(),
            system: Some("https://smarthealthit.org/tags"),
            code: Some("synthea-5-2019"),
          ),
        ],
      ),
    ),
    clinical_status: Some(
      r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
        r4.Coding(
          ..r4.coding_new(),
          system: Some(
            "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
          ),
          code: Some("active"),
        ),
      ]),
    ),
    verification_status: Some(
      r4.Codeableconcept(..r4.codeableconcept_new(), coding: [
        r4.Coding(
          ..r4.coding_new(),
          system: Some(
            "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
          ),
          code: Some("confirmed"),
        ),
      ]),
    ),
    type_: Some(r4_valuesets.AllergyintolerancetypeAllergy),
    category: [r4_valuesets.AllergyintolerancecategoryFood],
    criticality: Some(r4_valuesets.AllergyintolerancecriticalityLow),
    code: Some(
      r4.Codeableconcept(
        ..r4.codeableconcept_new(),
        coding: [
          r4.Coding(
            ..r4.coding_new(),
            system: Some("http://snomed.info/sct"),
            code: Some("300913006"),
            display: Some("Shellfish allergy"),
          ),
        ],
        text: Some("Shellfish allergy"),
      ),
    ),
    recorded_date: Some("1990-06-07T22:39:54+00:00"),
  )
let shellfish_allergy_json = r4.allergyintolerance_to_json(original_allergy)
echo shellfish_allergy_json
let assert Ok(parsed) =
  shellfish_allergy_json
  |> json.to_string
  |> json.parse(r4.allergyintolerance_decoder())
assert parsed == original_allergy
```

## [[type]_decoder](#decoder){#decoder}
Parses JSON to Gleam type, and for resources checks resource type such as
```json
"resourceType" : "AllergyIntolerance"
```

The decoder will fail on JSON missing a required element (cardinality `1..1`) or with invalid elements. For instance, a JSON might fail to parse because:
- AllergyIntolerance.patient is missing but required
- AllergyIntolerance.criticality "super-serious" which is not one of required valueset "low", "high", "unable-to-assess"  
- AllergyIntolerance.reaction.description exists as the number 7 but must be a string
If `allergyintolerance_decoder` succeeds it returns a strongly typed Allergyintolerance resource.


```gleam
let good_json =
  "
{
    \"resourceType\"      : \"AllergyIntolerance\",
    \"id\"                : \"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\",
    \"meta\"              : {
        \"versionId\"  : \"4\",
        \"lastUpdated\": \"2021-04-07T02:57:18.833-04:00\",
        \"tag\"        : [ {\"system\": \"https://smarthealthit.org/tags\", \"code\": \"synthea-5-2019\"} ]
    },
    \"clinicalStatus\"    : {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical\",
                \"code\"  : \"active\"
            }
        ]
    },
    \"verificationStatus\": {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-verification\",
                \"code\"  : \"confirmed\"
            }
        ]
    },
    \"type\"              : \"allergy\",
    \"category\"          : [\"food\"],
    \"criticality\"       : \"low\",
    \"code\"              : {
        \"coding\": [
            {
                \"system\" : \"http://snomed.info/sct\",
                \"code\"   : \"300913006\",
                \"display\": \"Shellfish allergy\"
            }
        ],
        \"text\"  : \"Shellfish allergy\"
    },
    \"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},
    \"recordedDate\"      : \"1990-06-07T22:39:54+00:00\"
}
"

let assert Error(json.UnableToDecode([
  decode.DecodeError("Field", "Nothing", ["patient"]),
])) =
  good_json
  |> string.replace(
    "\"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},",
    "",
  )
  |> json.parse(r4.allergyintolerance_decoder())

let assert Error(json.UnableToDecode([
  decode.DecodeError(
    "Allergyintolerancecriticality",
    "String",
    ["criticality"],
  ),
])) =
  good_json
  |> string.replace("\"low\"", "\"super-serious\"")
  |> json.parse(r4.allergyintolerance_decoder())

let assert Error(json.UnableToDecode([
  decode.DecodeError("String", "Int", ["id"]),
])) =
  good_json
  |> string.replace("\"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\"", "123")
  |> json.parse(r4.allergyintolerance_decoder())

let assert Ok(shellfish_allergy) =
  good_json |> json.parse(r4.allergyintolerance_decoder())
assert shellfish_allergy.id == Some("9b6a76f1-ee00-4efc-828d-ffbae3cb4220")
echo shellfish_allergy
```

## [Any resource](#anyresource){#anyresource}

The `Resource` type has a variant for each resource, used for instance in `Bundle` to list resources. `resource_to_json` calls the variant's to_json function, and `resource_decoder` checks the resource type to determine which decoder to use and map to a `Resource` variant, such as `ResourceAllergyintolerance` from

```json
"resourceType" : "AllergyIntolerance"
```

```gleam
let json_could_be_any_resource =
  "
{
    \"resourceType\"      : \"AllergyIntolerance\",
    \"id\"                : \"9b6a76f1-ee00-4efc-828d-ffbae3cb4220\",
    \"meta\"              : {
        \"versionId\"  : \"4\",
        \"lastUpdated\": \"2021-04-07T02:57:18.833-04:00\",
        \"tag\"        : [ {\"system\": \"https://smarthealthit.org/tags\", \"code\": \"synthea-5-2019\"} ]
    },
    \"clinicalStatus\"    : {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical\",
                \"code\"  : \"active\"
            }
        ]
    },
    \"verificationStatus\": {
        \"coding\": [
            {
                \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-verification\",
                \"code\"  : \"confirmed\"
            }
        ]
    },
    \"type\"              : \"allergy\",
    \"category\"          : [\"food\"],
    \"criticality\"       : \"low\",
    \"code\"              : {
        \"coding\": [
            {
                \"system\" : \"http://snomed.info/sct\",
                \"code\"   : \"300913006\",
                \"display\": \"Shellfish allergy\"
            }
        ],
        \"text\"  : \"Shellfish allergy\"
    },
    \"patient\"           : {\"reference\": \"Patient/10fe9427-a075-4d8c-8af7-1d4d24f72112\"},
    \"recordedDate\"      : \"1990-06-07T22:39:54+00:00\"
}
"

let assert Ok(r4.ResourceAllergyintolerance(shellfish_allergy)) =
  json_could_be_any_resource |> json.parse(r4.resource_decoder())
assert shellfish_allergy.criticality
  == Some(r4_valuesets.AllergyintolerancecriticalityLow)
```
