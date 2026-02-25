import fhir/r5
import gleam/dynamic/decode
import gleam/io
import gleam/json

fn check_roundtrip(in: String, thing_dec: decode.Decoder(a), thing_to_json) {
  let assert Ok(as_dynamic) = json.parse(in, decode.dynamic)
    as { "check_roundtrip decode dynamic" }
  let assert Ok(as_thing) = json.parse(in, thing_dec)
    as { "check_roundtrip decode thing" }

  let assert Ok(as_dynamic_roundtrip) =
    as_thing
    |> thing_to_json
    |> json.to_string
    |> json.parse(decode.dynamic)
  assert as_dynamic == as_dynamic_roundtrip
    as { "check_roundtrip decode + encode roundtrip" }
}

pub fn main() {
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
  check_roundtrip(
    patient_example_sex_and_gender,
    r5.patient_decoder(),
    r5.patient_to_json,
  )
}
