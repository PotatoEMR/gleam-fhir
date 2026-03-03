//import check_roundtrip
import fhir/r4us
import gleam/json
import gleam/list
import gleam/option.{None, Some}

// ai generated test of decoding custom type extensions
// note the json is different from the extension_test json
// r4us custom type example uses R4 which lacks CodeableReference
// so the extension can't have valueCodeableReference
// r4 only has valueCodeableConcept or valueReference
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

  assert pat.id == Some("patient-example-sex-and-gender")

  assert list.length(pat.extension) == 3

  assert list.length(pat.individual_recorded_sex_or_gender) == 3
  let has_type_code = fn(rsg: r4us.IndividualRecordedsexorgender, code) {
    case rsg.type_ {
      Some(cc) -> list.any(cc.coding, fn(c) { c.code == Some(code) })
      None -> False
    }
  }
  let assert Ok(rsg_dl) =
    list.find(pat.individual_recorded_sex_or_gender, fn(rsg) {
      has_type_code(rsg, "drivers-license")
    })
  let assert Ok(rsg_ic) =
    list.find(pat.individual_recorded_sex_or_gender, fn(rsg) {
      has_type_code(rsg, "insurance-card")
    })
  let assert Ok(rsg_bc) =
    list.find(pat.individual_recorded_sex_or_gender, fn(rsg) {
      has_type_code(rsg, "76689-9")
    })

  let assert r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("http://ohio.example.gov/drivers-license-sex"),
        code: Some("M"),
        display: Some("Male"),
        ..,
      ),
    ],
    ..,
  ) = rsg_dl.value
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some(
          "http://jurisdiction-specific.example.com/document-type-code-system",
        ),
        code: Some("drivers-license"),
        display: Some("Driver's License"),
        ..,
      ),
    ],
    ..,
  )) = rsg_dl.type_
  let assert Some(r4us.Period(start: Some("1974-12-25"), ..)) =
    rsg_dl.effective_period
  assert rsg_dl.acquisition_date == Some("2005-12-06")
  let assert Some(r4us.IndividualRecordedsexorgenderSourcedocumentReference(r4us.Reference(
    reference: Some("DocumentReference/1"),
    ..,
  ))) = rsg_dl.source_document
  assert rsg_dl.source_field == None
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("https://www.usps.com/"),
        code: Some("OH"),
        display: Some("Ohio"),
        ..,
      ),
    ],
    ..,
  )) = rsg_dl.jurisdiction
  assert rsg_dl.comment
    == Some(
      "Patient transitioned from male to female in 2001, but their driver's license still indicates male.",
    )

  let assert r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("http://hl7.org/fhir/administrative-gender"),
        code: Some("male"),
        display: Some("Male"),
        ..,
      ),
    ],
    ..,
  ) = rsg_ic.value
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("http://local-code-system.org/recorded-sex-or-gender-type"),
        code: Some("insurance-card"),
        display: Some("Insurance Card"),
        ..,
      ),
    ],
    ..,
  )) = rsg_ic.type_
  let assert Some(r4us.Period(start: Some("2021-05-25"), ..)) =
    rsg_ic.effective_period
  assert rsg_ic.acquisition_date == Some("2021-06-06")
  let assert Some(r4us.IndividualRecordedsexorgenderSourcedocumentReference(r4us.Reference(
    reference: Some("DocumentReference/2"),
    ..,
  ))) = rsg_ic.source_document
  assert rsg_ic.source_field == Some("SEX")
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some(
          "http://local-code-system.org/recorded-sex-or-gender-jurisdiction",
        ),
        code: Some("ICCA-P"),
        display: Some("Indigo Crucifix Cobalt Aegis Payer"),
        ..,
      ),
    ],
    ..,
  )) = rsg_ic.jurisdiction
  assert rsg_ic.comment
    == Some(
      "Patient transitioned from male to female in 2001, but their insurance card still indicates male.",
    )

  let assert r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("http://hl7.org/fhir/administrative-gender"),
        code: Some("male"),
        display: Some("Male"),
        ..,
      ),
    ],
    ..,
  ) = rsg_bc.value
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("http://loinc.org"),
        code: Some("76689-9"),
        display: Some("Sex Assigned At Birth"),
        ..,
      ),
    ],
    ..,
  )) = rsg_bc.type_
  let assert Some(r4us.Period(start: Some("1974-12-25"), ..)) =
    rsg_bc.effective_period
  assert rsg_bc.acquisition_date == Some("2005-12-06")
  let assert Some(r4us.IndividualRecordedsexorgenderSourcedocumentReference(r4us.Reference(
    reference: Some("DocumentReference/1"),
    ..,
  ))) = rsg_bc.source_document
  assert rsg_bc.source_field == Some("SEX")
  let assert Some(r4us.Codeableconcept(
    coding: [
      r4us.Coding(
        system: Some("https://www.usps.com/"),
        code: Some("OH"),
        display: Some("Ohio"),
        ..,
      ),
    ],
    ..,
  )) = rsg_bc.jurisdiction
  assert rsg_bc.comment
    == Some(
      "Patient transitioned from male to female in 2001, but their birth certificate still indicates male.",
    )

  let assert Ok(r4us.Extension(ext: r4us.ExtComplex(gi_children), ..)) =
    list.find(pat.extension, fn(e) {
      e.url
      == "http://hl7.org/fhir/StructureDefinition/individual-genderIdentity"
    })
  let assert Ok(r4us.Extension(
    ext: r4us.ExtSimple(r4us.ExtensionValueCodeableconcept(gi_cc)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "value" })
  let assert [gi_coding] = gi_cc.coding
  assert gi_coding.code == Some("446141000124107")
  let assert Ok(r4us.Extension(
    ext: r4us.ExtSimple(r4us.ExtensionValuePeriod(gi_period)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "period" })
  assert gi_period.start == Some("2001-05-06")
  assert gi_period.end == None
  let assert Ok(r4us.Extension(
    ext: r4us.ExtSimple(r4us.ExtensionValueString(gi_comment)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "comment" })
  assert gi_comment == "Patient transitioned from male to female in 2001."
}
