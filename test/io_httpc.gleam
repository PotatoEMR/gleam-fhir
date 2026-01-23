import fhir/r4
import fhir/r4_httpc
import fhir/r4_valuesets
import gleam/option.{Some}

pub fn main() {
  let fc = r4_httpc.fhirclient_new("https://hapi.fhir.org/baseR4")
  let allergy =
    r4.Allergyintolerance(
      ..r4.allergyintolerance_new(
        r4.Reference(..r4.reference_new(), reference: Some("Patient/7011747")),
      ),
      criticality: Some(r4_valuesets.AllergyintolerancecriticalityHigh),
      id: Some("abc"),
    )

  let assert Ok(created) = r4_httpc.allergyintolerance_create(allergy, fc)
  //echo created
  let assert Some(id) = created.id
  let assert Ok(read) = r4_httpc.allergyintolerance_read(id, fc)
  assert created == read
  let changed =
    r4.Allergyintolerance(
      ..created,
      criticality: Some(r4_valuesets.AllergyintolerancecriticalityLow),
    )
  let assert Ok(updated) = r4_httpc.allergyintolerance_update(changed, fc)
  //echo updated
  let assert Ok(_) = r4_httpc.allergyintolerance_delete(updated, fc)
  let assert Error(_) = r4_httpc.allergyintolerance_read(id, fc)
}
