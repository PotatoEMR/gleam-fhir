# Custom Extensions

Without knowing an extension's urls or StructureDefinition ahead of time, the normal [Extension](https://hexdocs.pm/fhir/resources/extension.html) still works, but is somewhat verbose and requires string url keys in order to support extensions of any type. If extensions are known when the the library code is generated, decoders will instead parse them into custom types specfic to that extension. For example r4us is generated with http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender so `r4us.patient_decoder()` parses that extension into its specific type that allows `rsg.source_document`, `rsg.value`, etc. These custom types for extensions allow shorter code without string url keys.

Custom extensions may rearrange the order of a list of extensions (which should not matter?) in a json -> resource -> json roundtrip. See [codegen](https://hexdocs.pm/fhir/profiles/codegen.html) to choose which extensions have custom types.

```gleam
import fhir/r4us
import gleam/json
import gleam/list

pub fn main() {
  let patient_example_sex_and_gender =
    "{
    \"resourceType\": \"Patient\",
    \"id\": \"patient-example-sex-and-gender\",
    \"text\": {
        \"status\": \"generated\",
        \"div\": \"<div>(modified codeablereference -> value[x] with cc and ref, for r4) https://hl7.org/fhir/R5/patient-example-sex-and-gender.json.html</div>\"},
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
                    \"valueReference\": {\"reference\": \"DocumentReference/1\"}
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
                    \"valueReference\": {\"reference\": \"DocumentReference/2\"}
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
                    \"valueReference\": {\"reference\": \"DocumentReference/1\"}
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
                    \"valueReference\": {\"reference\": \"Observation/1\"}
                },
                {
                    \"url\": \"supportingInfo\",
                    \"valueReference\": {\"reference\": \"MedicationStatement/2\"}
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
  let assert Ok(pat) =
    json.parse(patient_example_sex_and_gender, r4us.patient_decoder())

  let assert [rsg, _, _] = pat.individual_recorded_sex_or_gender

  echo rsg.value
  echo rsg.type_
  echo rsg.source_document
}
```
