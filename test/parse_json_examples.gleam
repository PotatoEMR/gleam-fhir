import fhir/r4
import filepath
import gleam/io
import gleam/json
import gleam/list
import simplifile

pub fn json_examples_test() {
  let r4_json_examples_dir = filepath.join("test", "r4_json_examples")
  case simplifile.read_directory(r4_json_examples_dir) {
    Error(_) -> {
      io.println("Error: Could not read json_examples directory")
    }
    Ok(files) -> {
      list.each(files, fn(file) {
        let assert Ok(f_str) =
          simplifile.read(filepath.join(r4_json_examples_dir, file))
        let assert Ok(parsed_resource) =
          json.parse(f_str, r4.resource_decoder())
        echo parsed_resource
      })
    }
  }
}
