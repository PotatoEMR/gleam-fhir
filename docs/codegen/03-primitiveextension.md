# Primitive Extensions

FHIR technically allows [extensions on primitive datatypes](https://build.fhir.org/extensibility.html#primitives). This makes primitives go from simple types (bool, string, etc) to basically anything, so if the data does not really need primitive extensions they are probably not worth the extra complexity. In Gleam, elements with primitive extensions are wrapped in `Primitive`, for example `Primitive(String)` has an `id: Option(String)`, `ext: List(Extension)`, and `value: Option(String)`.

Note that the value is *always* optional, *even if cardinality is `1..1`*. So if working with primitive extensions, there is no guarantuee an element will be present despite being required. As such it is never possible to get the value of a primitive directly with thing.value eg `name.family.value \\does not compile`; getting the value always requires a case or assert to get the value out of the `Option` eg `let assert Some(family) = name.family.value`.

In the JSON, instead of field name, primitive extensions go in underscore + name. For instance, a [QuestionnaireResponse](https://build.fhir.org/questionnaireresponse.html) resource normally requires a questionnaire field, but "questionnaire" can be entirely omitted in favor of "_questionnaire", or both can be present.

`r4usp` is `r4us` but with primitive extensions for all fields. Primitive extensions can be generated for specific elements or all elements, see [Custom Codegen](https://hexdocs.pm/fhir/codegen/codegen.html). Again they are technically valid but much more work and may not be needed.

```json
  "_questionnaire": {
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/display",
        "valueString": "Lifelines"
      }
    ]
  },
```

```gleam
pub type Primitive(a) {
  Primitive(id: Option(String), ext: List(Extension), value: Option(a))
}
```

```gleam
import fhir/r4usp
import fhir/r4usp_valuesets
import gleam/json
import gleam/option.{Some}
import gleam/list

const name_json = "
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

pub fn main() {
  let assert Ok(name) = json.parse(name_json, r4usp.humanname_decoder())
  let assert Some(r4usp_valuesets.NameuseOfficial) = name.use_.value
  let assert Some("van Hentenryck") = name.family.value
  let assert [given] = name.given
  let assert Some("Karen") = given.value
  let assert Ok(e1) = list.find(name.family.ext, fn(ext){
    ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix"
  })
  let assert r4usp.ExtSimple(r4usp.ExtensionValueString("van")) = e1.ext
  let assert Ok(e2) = list.find(name.family.ext, fn(ext){
    ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
  })
  let assert r4usp.ExtSimple(r4usp.ExtensionValueString("Hentenryck")) = e2.ext
}
```
