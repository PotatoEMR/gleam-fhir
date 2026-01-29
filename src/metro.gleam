import fhir/r5
import gleam/json

pub fn main() {
  let pp =
    "{
    \"contentType\": \"application/geo+json\",
    \"data\": \"VGhlbWU6IA0KUmF3UGFyc2VkDQp7InR5cGUiOiJGZWF0dXJlQ29sbGVjdGlvbiIsInByb3BlcnRpZXMiOnsia2luZCI6InN0YXRlIiwic3RhdGUiOiJEQyJ9LCJmZWF0dXJlcyI6Ww0KeyJ0eXBlIjoiRmVhdHVyZSIsInByb3BlcnRpZXMiOnsia2luZCI6ImNvdW50eSIsIm5hbWUiOiJEaXN0cmljdCBvZiBDb2x1bWJpYSIsInN0YXRlIjoiREMifSwiZ2VvbWV0cnkiOnsidHlwZSI6Ik11bHRpUG9seWdvbiIsImNvb3JkaW5hdGVzIjpbW1tbLTc3LjAzNTMsMzguOTkzOV0sWy03Ny4wMDI0LDM4Ljk2NjVdLFstNzYuOTA5MywzOC44OTUzXSxbLTc3LjA0MDcsMzguNzkxMl0sWy03Ny4wNDYyLDM4Ljg0MDVdLFstNzcuMDQwNywzOC44NzM0XSxbLTc3LjExNzQsMzguOTMzNl1dXV19fQ0KXX0u003d\",
    \"url\": \"https://github.com/OpenDataDE/State-zip-code-GeoJSON/raw/master/dc_district_of_columbia_zip_codes_geo.min.json\",
    \"size\": \"389\"
  }"

  echo pp |> json.parse(r5.attachment_decoder())
}
