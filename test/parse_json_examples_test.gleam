import fhir/r4
import fhir/r4b
import fhir/r5
import filepath

//import gleam/dynamic/decode
import gleam/json
import gleam/list
import simplifile

pub type Timeout(a) {
  Timeout(time: Int, function: fn() -> a)
}

// https://gearsco.de/blog/gleam-test-timeouts/
// a test ending with underscore _test_ can set timeout
// this one parses a lot of jsons so it takes longer
pub fn json_examples_test_() {
  use <- Timeout(1200)
  parse_json_in_dir("r4", r4.resource_decoder(), r4.resource_to_json)
  parse_json_in_dir("r4b", r4b.resource_decoder(), r4b.resource_to_json)
  parse_json_in_dir("r5", r5.resource_decoder(), r5.resource_to_json)
}

pub fn parse_json_in_dir(fv, res_decoder, _res_to_json) {
  let fv_json_examples_dir = filepath.join("test", fv <> "-examples-json")
  let assert Ok(files) = simplifile.read_directory(fv_json_examples_dir)
    as "could not read json_examples directory"
  list.each(files, fn(file) {
    let fp = filepath.join(fv_json_examples_dir, file)
    let assert Ok(f_str) = simplifile.read(fp) as { "read " <> fp }
    let assert Ok(_) = json.parse(f_str, res_decoder) as { "decode " <> fp }
    // need decimal to work to try parsed_resource roundtrip
    // let assert Ok(dynamic_resource) = json.parse(f_str, decode.dynamic)
    // let assert Ok(dynamic_roundtrip_resource) =
    //   parsed_resource
    //   |> res_to_json
    //   |> json.to_string
    //   |> json.parse(decode.dynamic)
    // assert dynamic_resource == dynamic_roundtrip_resource
    //   as { "decode + encode roundtrip " <> fp }
  })
}
