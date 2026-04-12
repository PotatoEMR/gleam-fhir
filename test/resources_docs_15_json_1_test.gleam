import fhir/primitive_types as pt
import fhir/r4
import fhir/r4_valuesets
import gleam/json
import gleam/option.{None, Some}
import gleam/time/calendar

pub fn resources_docs_15_json_1_test() {
  let last_updated_instant =
    pt.Instant(
      pt.YearMonthDay(2021, calendar.April, 7),
      pt.Time(2, 57, 18, Some(pt.NanosecWithPrecision(833_000_000, Some(3)))),
      pt.Offset(pt.Minus, 4, 0),
    )
  let recorded_dt =
    pt.DateTime(
      pt.YearMonthDay(1990, calendar.June, 7),
      Some(pt.TimeAndZone(pt.Time(22, 39, 54, None), pt.Offset(pt.Plus, 0, 0))),
    )

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
          last_updated: Some(last_updated_instant),
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
      recorded_date: Some(recorded_dt),
    )
  let shellfish_allergy_json = r4.allergyintolerance_to_json(original_allergy)
  let assert Ok(parsed) =
    shellfish_allergy_json
    |> json.to_string
    |> json.parse(r4.allergyintolerance_decoder())
  assert parsed == original_allergy
}
