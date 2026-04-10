//import check_roundtrip
import fhir/primitive_types/datetime
import fhir/r4
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/time/calendar

// ai generated test of decoding custom type extensions
// note the json is different from the extension_test json
// r4us custom type example uses R4 which lacks CodeableReference
// so the extension can't have valueCodeableReference
// r4 only has valueCodeableConcept or valueReference
pub fn extension_notcustom_test() {
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
    json.parse(patient_example_sex_and_gender, r4.patient_decoder())

  assert pat.id == Some("patient-example-sex-and-gender")

  assert list.length(pat.extension) == 6

  let rsg_extensions =
    list.filter(pat.extension, fn(e) {
      e.url
      == "http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender"
    })
  assert list.length(rsg_extensions) == 3
  let find_rsg_by_type_code = fn(exts, code) {
    list.find(exts, fn(e: r4.Extension) {
      case e.ext {
        r4.ExtComplex(children) ->
          case list.find(children, fn(c) { c.url == "type" }) {
            Ok(r4.Extension(
              ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(cc)),
              ..,
            )) -> list.any(cc.coding, fn(c) { c.code == Some(code) })
            _ -> False
          }
        _ -> False
      }
    })
  }
  let assert Ok(r4.Extension(ext: r4.ExtComplex(rsg_bc_children), ..)) =
    find_rsg_by_type_code(rsg_extensions, "76689-9")
  let assert Ok(r4.Extension(ext: r4.ExtComplex(rsg_ic_children), ..)) =
    find_rsg_by_type_code(rsg_extensions, "insurance-card")
  let assert Ok(r4.Extension(ext: r4.ExtComplex(rsg_dl_children), ..)) =
    find_rsg_by_type_code(rsg_extensions, "drivers-license")

  // driver's license
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(dl_value)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "value" })
  let assert [
    r4.Coding(
      system: Some("http://ohio.example.gov/drivers-license-sex"),
      code: Some("M"),
      display: Some("Male"),
      ..,
    ),
  ] = dl_value.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(dl_type)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "type" })
  let assert [
    r4.Coding(
      system: Some(
        "http://jurisdiction-specific.example.com/document-type-code-system",
      ),
      code: Some("drivers-license"),
      display: Some("Driver's License"),
      ..,
    ),
  ] = dl_type.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValuePeriod(dl_effective_period)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "effectivePeriod" })
  assert dl_effective_period.start
    == Some(datetime.YearMonthDay(1974, calendar.December, 25))
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueDatetime(dl_acquisition_date)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "acquisitionDate" })
  assert dl_acquisition_date
    == datetime.YearMonthDay(2005, calendar.December, 6)
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueReference(dl_source_doc)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "sourceDocument" })
  assert dl_source_doc.reference == Some("DocumentReference/1")
  assert list.find(rsg_dl_children, fn(e) { e.url == "sourceField" })
    == Error(Nil)
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(dl_jurisdiction)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "jurisdiction" })
  let assert [
    r4.Coding(
      system: Some("https://www.usps.com/"),
      code: Some("OH"),
      display: Some("Ohio"),
      ..,
    ),
  ] = dl_jurisdiction.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(dl_comment)),
    ..,
  )) = list.find(rsg_dl_children, fn(e) { e.url == "comment" })
  assert dl_comment
    == "Patient transitioned from male to female in 2001, but their driver's license still indicates male."

  // insurance card
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(ic_value)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "value" })
  let assert [
    r4.Coding(
      system: Some("http://hl7.org/fhir/administrative-gender"),
      code: Some("male"),
      display: Some("Male"),
      ..,
    ),
  ] = ic_value.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(ic_type)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "type" })
  let assert [
    r4.Coding(
      system: Some("http://local-code-system.org/recorded-sex-or-gender-type"),
      code: Some("insurance-card"),
      display: Some("Insurance Card"),
      ..,
    ),
  ] = ic_type.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValuePeriod(ic_effective_period)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "effectivePeriod" })
  assert ic_effective_period.start
    == Some(datetime.YearMonthDay(2021, calendar.May, 25))
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueDatetime(ic_acquisition_date)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "acquisitionDate" })
  assert ic_acquisition_date == datetime.YearMonthDay(2021, calendar.June, 06)
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueReference(ic_source_doc)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "sourceDocument" })
  assert ic_source_doc.reference == Some("DocumentReference/2")
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(ic_source_field)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "sourceField" })
  assert ic_source_field == "SEX"
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(ic_jurisdiction)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "jurisdiction" })
  let assert [
    r4.Coding(
      system: Some(
        "http://local-code-system.org/recorded-sex-or-gender-jurisdiction",
      ),
      code: Some("ICCA-P"),
      display: Some("Indigo Crucifix Cobalt Aegis Payer"),
      ..,
    ),
  ] = ic_jurisdiction.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(ic_comment)),
    ..,
  )) = list.find(rsg_ic_children, fn(e) { e.url == "comment" })
  assert ic_comment
    == "Patient transitioned from male to female in 2001, but their insurance card still indicates male."

  // birth certificate
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(bc_value)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "value" })
  let assert [
    r4.Coding(
      system: Some("http://hl7.org/fhir/administrative-gender"),
      code: Some("male"),
      display: Some("Male"),
      ..,
    ),
  ] = bc_value.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(bc_type)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "type" })
  let assert [
    r4.Coding(
      system: Some("http://loinc.org"),
      code: Some("76689-9"),
      display: Some("Sex Assigned At Birth"),
      ..,
    ),
  ] = bc_type.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValuePeriod(bc_effective_period)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "effectivePeriod" })
  assert bc_effective_period.start
    == Some(datetime.YearMonthDay(1974, calendar.December, 25))
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueDatetime(bc_acquisition_date)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "acquisitionDate" })
  assert bc_acquisition_date
    == datetime.YearMonthDay(2005, calendar.December, 06)
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueReference(bc_source_doc)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "sourceDocument" })
  assert bc_source_doc.reference == Some("DocumentReference/1")
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(bc_source_field)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "sourceField" })
  assert bc_source_field == "SEX"
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(bc_jurisdiction)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "jurisdiction" })
  let assert [
    r4.Coding(
      system: Some("https://www.usps.com/"),
      code: Some("OH"),
      display: Some("Ohio"),
      ..,
    ),
  ] = bc_jurisdiction.coding
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(bc_comment)),
    ..,
  )) = list.find(rsg_bc_children, fn(e) { e.url == "comment" })
  assert bc_comment
    == "Patient transitioned from male to female in 2001, but their birth certificate still indicates male."

  // gender identity
  let assert Ok(r4.Extension(ext: r4.ExtComplex(gi_children), ..)) =
    list.find(pat.extension, fn(e) {
      e.url
      == "http://hl7.org/fhir/StructureDefinition/individual-genderIdentity"
    })
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueCodeableconcept(gi_cc)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "value" })
  let assert [gi_coding] = gi_cc.coding
  assert gi_coding.code == Some("446141000124107")
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValuePeriod(gi_period)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "period" })
  assert gi_period.start == Some(datetime.YearMonthDay(2001, calendar.May, 06))
  assert gi_period.end == None
  let assert Ok(r4.Extension(
    ext: r4.ExtSimple(r4.ExtensionValueString(gi_comment)),
    ..,
  )) = list.find(gi_children, fn(e) { e.url == "comment" })
  assert gi_comment == "Patient transitioned from male to female in 2001."
}
