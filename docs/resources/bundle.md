# bundle

FHIR uses [Bundle](https://build.fhir.org/bundle.html#resource) to list resources, so operations that return multiple resources, such as Search, will return a Bundle.  The element Bundle.entry has cardinality `0..*` so in Gleam it is `List(BundleEntry)`, and Bundle.entry.resource can be any resource so in Gleam `Resource` has a variant for each resource type.

```gleam
pub type Resource {
  ResourceAccount(Account)
  ResourceActivitydefinition(Activitydefinition)
  ResourceAdverseevent(Adverseevent)
  ResourceAllergyintolerance(Allergyintolerance)
  ResourceAppointment(Appointment)
  ...
  ResourceVisionprescription(Visionprescription)
}
```
