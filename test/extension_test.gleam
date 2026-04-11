import check_roundtrip
import fhir/primitive_types as pt
import fhir/r5
import gleam/dict
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/time/calendar

pub fn extension_test() {
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
  check_roundtrip.check_roundtrip(
    patient_example_sex_and_gender,
    r5.patient_decoder(),
    r5.patient_to_json,
    "extension_test",
  )
  let assert Ok(pat) =
    json.parse(patient_example_sex_and_gender, r5.patient_decoder())
  let pat_exts: r5.ExtDict = r5.exts_to_extdict(pat.extension)
  let assert Ok([ident]) =
    dict.get(
      pat_exts.exts_by_url,
      "http://hl7.org/fhir/StructureDefinition/individual-genderIdentity",
    )
  let assert r5.ExtDictComplex(ident_exts) = ident.content

  let assert Ok([val]) = dict.get(ident_exts.exts_by_url, "value")
  let assert r5.ExtDictSimple(val_cc) = val.content
  let assert r5.ExtensionValueCodeableconcept(ident_cc) = val_cc
  let assert [ident_coding] = ident_cc.coding
  let assert Some("446141000124107") = ident_coding.code

  let assert Ok([when]) = dict.get(ident_exts.exts_by_url, "period")
  let assert r5.ExtDictSimple(val_period) = when.content
  let assert r5.ExtensionValuePeriod(period) = val_period
  let assert Some(pt.DateTime(pt.YearMonthDay(2001, calendar.May, 6), None)) =
    period.start
  let assert None = period.end

  assert 4 == pat_exts.exts_by_url |> dict.keys |> list.length
  let assert Ok([_, _, _]) =
    dict.get(
      pat_exts.exts_by_url,
      "http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender",
    )

  let assert Ok(r5.Extension(ext: r5.ExtComplex(ident_children), ..)) =
    list.find(pat.extension, fn(e) {
      e.url
      == "http://hl7.org/fhir/StructureDefinition/individual-genderIdentity"
    })
  let assert Ok(r5.Extension(
    ext: r5.ExtSimple(r5.ExtensionValueCodeableconcept(ident_cc)),
    ..,
  )) = list.find(ident_children, fn(e) { e.url == "value" })
  let assert [ident_coding] = ident_cc.coding
  assert ident_coding.code == Some("446141000124107")
  let assert Ok(r5.Extension(
    ext: r5.ExtSimple(r5.ExtensionValuePeriod(period)),
    ..,
  )) = list.find(ident_children, fn(e) { e.url == "period" })
  assert period.start
    == Some(pt.DateTime(pt.YearMonthDay(2001, calendar.May, 6), None))
  assert period.end == None
  assert pat.extension
    |> list.map(fn(e) { e.url })
    |> list.unique
    |> list.length
    == 4
  assert list.filter(pat.extension, fn(e) {
      e.url
      == "http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender"
    })
    |> list.length
    == 3
}
