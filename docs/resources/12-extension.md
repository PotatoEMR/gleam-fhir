# Extension

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

Primitive elements can also have extensions! Still figuring out how common this actually is, and how pleasant it will be to use/not interfere with unmodified primitive elements. If you have a good way of handling primitive elements in mind [please create an issue here](https://github.com/PotatoEMR/gleam-fhir/issues/new)

```gleam
  let name =
    "
  {
      \"use\" : \"official\",
      \"family\" : \"van Hentenryck\",
      \"_family\" : {
        \"extension\" : [{
          \"url\" : \"http://hl7.org/fhir/StructureDefinition/humanname-own-prefix\",
          \"valueString\" : \"van\"
        }, {
          \"url\" : \"http://hl7.org/fhir/StructureDefinition/humanname-own-name\",
          \"valueString\" : \"Hentenryck\"
        }]
      },
      \"given\" : [\"Karen\"]
    }
  "
  // r4.humanname_decoder() should check the _family extension,
  // but where should the decoded extension go?
```
