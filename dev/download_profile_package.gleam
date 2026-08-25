//// ai generated code to download package and its dependencies from simplifier
//// could alternatively depend on npm
//// or could mess around with this if there are problems

import argv
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/set.{type Set}
import shellout
import simplifile

const registry = "https://packages.simplifier.net"

type Package {
  Package(name: String, version: String)
}

pub fn main() {
  let assert [name, version, output] = argv.load().arguments
  download_package_with_dependencies(name:, version:, output:)
}

pub fn download_package_with_dependencies(
  name name: String,
  version version: String,
  output output: String,
) -> Set(String) {
  let assert Ok(Nil) = simplifile.create_directory_all(output)
  resolve(Package(name, version), output, set.new())
}

fn resolve(
  package: Package,
  output: String,
  visited: Set(String),
) -> Set(String) {
  let Package(name, version) = package
  let key = name <> "@" <> version

  case set.contains(visited, key) {
    True -> visited
    False -> {
      io.println("Downloading " <> key)
      dependencies(package, output)
      |> list.fold(set.insert(visited, key), fn(visited, dependency) {
        resolve(dependency, output, visited)
      })
    }
  }
}

fn dependencies(package: Package, output: String) -> List(Package) {
  let Package(name, version) = package
  let directory = output |> filepath.join(name) |> filepath.join(version)
  let package_json = directory |> filepath.join("package/package.json")
  let assert Ok(exists) = simplifile.is_file(package_json)

  case exists {
    True -> Nil
    False -> {
      let assert Ok(Nil) = simplifile.create_directory_all(directory)
      let url = registry <> "/" <> name <> "/" <> version
      let assert Ok(request) = request.to(url)
      let assert Ok(response) = httpc.send_bits(request.set_body(request, <<>>))

      let _ = case response.status >= 200 && response.status < 300 {
        False -> {
          let error =
            "GET " <> url <> " returned HTTP " <> int.to_string(response.status)
          panic as error
        }
        True -> Nil
      }

      let archive = directory |> filepath.join("package.tgz")
      let assert Ok(Nil) = simplifile.write_bits(archive, response.body)
      let assert Ok(_) =
        shellout.command("tar", ["-xzf", archive, "-C", directory], ".", [])
      Nil
    }
  }

  let assert Ok(contents) = simplifile.read(package_json)
  let assert Ok(dependencies) = json.parse(contents, dependency_decoder())
  dependencies
  |> dict.to_list
  |> list.map(fn(dependency) { Package(dependency.0, dependency.1) })
}

fn dependency_decoder() {
  use dependencies <- decode.optional_field(
    "dependencies",
    dict.new(),
    decode.dict(decode.string, decode.string),
  )
  decode.success(dependencies)
}
