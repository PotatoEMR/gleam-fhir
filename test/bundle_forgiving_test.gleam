import fhir/r4/resources
import gleam/json
import gleam/option.{Some}

const one_valid_one_invalid = "{
  \"resourceType\": \"Bundle\",
  \"id\": \"e2d14f63-1c2c-4527-8c39-6eb1bd5a7186\",
  \"meta\": {
    \"lastUpdated\": \"2026-05-21T11:24:06.779+00:00\"
  },
  \"type\": \"searchset\",
  \"link\": [ {
    \"relation\": \"self\",
    \"url\": \"https://hapi.fhir.org/baseR4/DocumentReference\"
  }, {
    \"relation\": \"next\",
    \"url\": \"https://hapi.fhir.org/baseR4?_getpages=e2d14f63-1c2c-4527-8c39-6eb1bd5a7186&_getpagesoffset=20&_count=20&_pretty=true&_bundletype=searchset\"
  } ],
  \"entry\": [ {
    \"fullUrl\": \"https://hapi.fhir.org/baseR4/DocumentReference/103809736\",
    \"resource\": {
      \"resourceType\": \"DocumentReference\",
      \"id\": \"103809736\",
      \"meta\": {
        \"versionId\": \"1\",
        \"lastUpdated\": \"2026-02-10T14:34:41.183+00:00\",
        \"source\": \"#xAggTagtMMZB0Oi1\",
        \"profile\": [ \"https://profiles.ihe.net/ITI/MHD/StructureDefinition/IHE.MHD.Minimal.DocumentReference\" ]
      },
      \"masterIdentifier\": {
        \"system\": \"urn:ietf:rfc:3986\",
        \"value\": \"urn:oid:1.2.87.98.221.159.2026.2.4.16.24.37.77.1\"
      },
      \"status\": \"current\",
      \"subject\": {
        \"reference\": \"http://nisttools.ihe-europe.net:9760/asbestos/proxy/default__default/Patient/5\"
      },
      \"date\": \"INVALID DATE THAT FAILS TO PARSE\",
      \"content\": [ {
        \"attachment\": {
          \"contentType\": \"text/plain\",
          \"url\": \"Binary/103809740\"
        }
      } ]
    },
    \"search\": {
      \"mode\": \"match\"
    }
  }, {
    \"fullUrl\": \"https://hapi.fhir.org/baseR4/DocumentReference/ca2bf16c-a3d9-46ab-9b3f-472c9e754511\",
    \"resource\": {
      \"resourceType\": \"DocumentReference\",
      \"id\": \"ca2bf16c-a3d9-46ab-9b3f-472c9e754511\",
      \"meta\": {
        \"versionId\": \"2\",
        \"lastUpdated\": \"2026-02-10T19:45:46.206+00:00\",
        \"source\": \"#j7TNOPAFYTZAIro9\"
      },
      \"status\": \"current\",
      \"subject\": {
        \"reference\": \"Patient/pacientek2bhealt\"
      },
      \"content\": [ {
        \"attachment\": {
          \"contentType\": \"application/fhir+json\",
          \"url\": \"https://hapi.fhir.org/baseR4/Bundle/c2de9fe3-a2a2-4e43-8c00-e037e9e19b4e\"
        }
      } ]
    },
    \"search\": {
      \"mode\": \"match\"
    }
  }]
}"

pub fn main() {
  let assert Ok(parsed_forgiving) =
    json.parse(one_valid_one_invalid, resources.bundle_decoder_forgiving())
  let assert [bad, good] = parsed_forgiving.entry
  let assert Some(bad_res) = bad.resource
  let assert Error(_err) = bad_res
  let assert Some(good_res) = good.resource
  let assert Ok(_res) = good_res
}
