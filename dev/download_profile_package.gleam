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

const fallback_registry = "https://packages2.fhir.org/web"

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

  let available = case exists {
    True -> True
    False -> {
      let assert Ok(Nil) = simplifile.create_directory_all(directory)
      let primary_url = registry <> "/" <> name <> "/" <> version
      let assert Ok(primary_request) = request.to(primary_url)
      let assert Ok(primary_response) =
        httpc.send_bits(request.set_body(primary_request, <<>>))

      let #(url, response) = case
        primary_response.status >= 200 && primary_response.status < 300
      {
        True -> #(primary_url, primary_response)
        False -> {
          let fallback_url =
            fallback_registry <> "/" <> name <> "-" <> version <> ".tgz"
          io.println("Retrying from " <> fallback_url)
          let assert Ok(fallback_request) = request.to(fallback_url)
          let assert Ok(fallback_response) =
            httpc.send_bits(request.set_body(fallback_request, <<>>))
          #(fallback_url, fallback_response)
        }
      }

      case response.status >= 200 && response.status < 300 {
        False -> {
          let error =
            "GET " <> url <> " returned HTTP " <> int.to_string(response.status)
          io.println("Skipping " <> name <> "@" <> version <> ": " <> error)
          False
        }
        True -> {
          let archive = directory |> filepath.join("package.tgz")
          let assert Ok(Nil) = simplifile.write_bits(archive, response.body)
          let assert Ok(_) =
            shellout.command("tar", ["-xzf", archive, "-C", directory], ".", [])
          True
        }
      }
    }
  }

  case available {
    False -> []
    True -> {
      let assert Ok(contents) = simplifile.read(package_json)
      let assert Ok(dependencies) = json.parse(contents, dependency_decoder())
      dependencies
      |> dict.to_list
      |> list.map(fn(dependency) { Package(dependency.0, dependency.1) })
    }
  }
}

fn dependency_decoder() {
  use dependencies <- decode.optional_field(
    "dependencies",
    dict.new(),
    decode.dict(decode.string, decode.string),
  )
  decode.success(dependencies)
}
