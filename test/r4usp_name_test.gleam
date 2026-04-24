import fhir/r4usp/complex_types as ct
import fhir/r4usp/valuesets

import check_roundtrip
import gleam/json
import gleam/list
import gleam/option.{Some}

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
  check_roundtrip.check_roundtrip(
    name_json,
    ct.humanname_decoder(),
    ct.humanname_to_json,
    "r4usp_name_test",
  )
  let assert Ok(name) = json.parse(name_json, ct.humanname_decoder())
  let assert Some(valuesets.NameuseOfficial) = name.use_.value
  let assert Some("van Hentenryck") = name.family.value
  let assert [given] = name.given
  let assert Some("Karen") = given.value
  let assert Ok(e1) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix"
    })
  let assert ct.ExtSimple(ct.ExtensionValueString("van")) = e1.ext
  let assert Ok(e2) =
    list.find(name.family.ext, fn(ext) {
      ext.url == "http://hl7.org/fhir/StructureDefinition/humanname-own-name"
    })
  let assert ct.ExtSimple(ct.ExtensionValueString("Hentenryck")) = e2.ext
}
