# Primitive Extensions

FHIR technically allows [extensions on primitive datatypes](https://build.fhir.org/extensibility.html#primitives). This makes primitives go from simple types (bool, string, etc) to basically anything, so if the data does not really need primitive extensions they are probably not worth the extra complexity. In Gleam, elements with primitive extensions are wrapped in `Primitive`, for example `Primitive(String)` has an `id: Option(String)`, `ext: List(Extension)`, and `value: Option(String)`.

```gleam
pub type Primitive(a) {
  Primitive(id: Option(String), ext: List(Extension), value: Option(a))
}
```

Note that the value is *always* optional, *even if cardinality is `1..1`*. So if working with primitive extensions, there is no guarantuee an element will be present despite being required. As such it is never possible to get the value of a primitive directly with thing.value eg `name.family.value \\does not compile`; getting the value always requires a case or assert to get the value out of the `Option` eg `let assert Some(family) = name.family.value`.

In the JSON, instead of field name, primitive extensions go in underscore + name. For instance, a [QuestionnaireResponse](https://build.fhir.org/questionnaireresponse.html) resource normally requires a questionnaire field (after all, it doesn't make sense to respond to a questionnaire without linking the questionnaire type), but the JSON field "questionnaire" can be entirely omitted in favor of "_questionnaire", or both can be present.

In Gleam, `fhir/r4p` is `fhir/r4` but with primitive extensions for all fields. Primitive extensions can be generated for specific elements or all elements, see [Custom Codegen](https://hexdocs.pm/fhir/codegen/codegen.html). Again they are technically valid but much more work and may not be needed.

```gleam
pub fn main() {
  let assert Ok(name) =
    json.parse(name_json, complex_types.humanname_decoder())
  let assert Some(valuesets.NameuseOfficial) = name.use_.value
  let assert Some(family) = name.family.value
  assert family == "van Hentenryck"
  let assert [given] = name.given
  let assert Some(given_value) = given.value
  assert given_value == "Karen"
  let assert Ok(e1) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    own_prefix,
  )) = e1.ext
  assert own_prefix == "van"
  let assert Ok(e2) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    own_name,
  )) = e2.ext
  assert own_name == "Hentenryck"

  let assert Ok(qr) =
    json.parse(
      questionnaireresponse_json,
      resources.questionnaireresponse_decoder(),
    )
  let assert Ok(display) =
    list.find(qr.questionnaire.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/display"
    })
  let assert complex_types.ExtSimple(complex_types.ExtensionValueString(
    display_value,
  )) = display.ext
  assert display_value == "Lifelines"
}
```
