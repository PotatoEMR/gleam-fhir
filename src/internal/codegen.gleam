import argv
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile

const check_versions = ["r4", "r4b", "r5"]

const zip_file_names = [
  "profiles-resources.json",
  "profiles-types.json",
  "valuesets.json",
]

const fhir_url = "https://www.hl7.org/fhir"

const download_dir = "src\\internal\\downloads"

const gen_into_dir = "src"

pub fn main() {
  io.println("🔥🔥🔥 bultaoreune")

  let args = argv.load().arguments

  let download_files = list.contains(args, "download")
  let _ = case download_files {
    True -> {
      case simplifile.delete(download_dir) {
        Ok(_) -> Nil
        Error(simplifile.Enoent) -> Nil
        Error(_) -> panic as "could not remove dir to download fhir into"
      }
      let assert Ok(_) = simplifile.create_directory_all(download_dir)
    }
    False -> {
      io.println("Run with \"download\" arg to download files from fhir")
      Ok(Nil)
    }
  }

  use fhir_version <- list.map(check_versions)

  let _ = case list.contains(args, fhir_version) {
    True -> gen_fhir(fhir_version, download_files)
    False -> Nil
  }

  Nil
}

type Bundle {
  Bundle(entry: List(Entry))
}

fn bundle_decoder() -> decode.Decoder(Bundle) {
  use entry <- decode.field("entry", decode.list(entry_decoder()))
  decode.success(Bundle(entry:))
}

type Entry {
  Entry(resource: Resource)
}

fn entry_decoder() -> decode.Decoder(Entry) {
  use resource <- decode.field("resource", resource_decoder())
  decode.success(Entry(resource:))
}

type Resource {
  Resource(
    rest: List(Rest),
    snapshot: Option(Snapshot),
    resource_type: String,
    name: String,
    url: String,
    kind: Option(String),
    base_definition: Option(String),
  )
}

fn resource_decoder() -> decode.Decoder(Resource) {
  use rest <- decode.optional_field("rest", [], decode.list(rest_decoder()))
  use snapshot <- decode.optional_field(
    "snapshot",
    None,
    decode.optional(snapshot_decoder()),
  )
  use resource_type <- decode.field("resourceType", decode.string)
  use name <- decode.field("name", decode.string)
  use url <- decode.field("url", decode.string)
  use kind <- decode.optional_field(
    "kind",
    None,
    decode.optional(decode.string),
  )
  use base_definition <- decode.optional_field(
    "baseDefinition",
    None,
    decode.optional(decode.string),
  )

  decode.success(Resource(
    rest:,
    snapshot:,
    resource_type:,
    name:,
    url:,
    kind:,
    base_definition:,
  ))
}

type Rest {
  Rest(resource: List(RestResource))
}

fn rest_decoder() -> decode.Decoder(Rest) {
  use resource <- decode.optional_field(
    "resource",
    [],
    decode.list(rest_resource_decoder()),
  )
  decode.success(Rest(resource:))
}

type RestResource {
  RestResource(
    type_: String,
    search_include: List(String),
    search_rev_include: List(String),
    search_param: List(SearchParam),
  )
}

fn rest_resource_decoder() -> decode.Decoder(RestResource) {
  use type_ <- decode.field("type", decode.string)
  use search_include <- decode.optional_field(
    "searchInclude",
    [],
    decode.list(decode.string),
  )
  use search_rev_include <- decode.optional_field(
    "searchRevInclude",
    [],
    decode.list(decode.string),
  )
  use search_param <- decode.optional_field(
    "searchParam",
    [],
    decode.list(search_param_decoder()),
  )
  decode.success(RestResource(
    type_:,
    search_include:,
    search_rev_include:,
    search_param:,
  ))
}

type SearchParam {
  SearchParam(name: String)
}

fn search_param_decoder() -> decode.Decoder(SearchParam) {
  use name <- decode.field("name", decode.string)
  decode.success(SearchParam(name:))
}

type Snapshot {
  Snapshot(element: List(Element))
}

fn snapshot_decoder() -> decode.Decoder(Snapshot) {
  use element <- decode.optional_field(
    "element",
    [],
    decode.list(element_decoder()),
  )
  decode.success(Snapshot(element:))
}

type Element {
  Element(
    path: String,
    min: Int,
    max: String,
    type_: List(Type),
    binding: Option(Binding),
  )
}

//  use type_ <- decode.field("type_", decode.list(todo as "Decoder for Type"))

fn element_decoder() -> decode.Decoder(Element) {
  use path <- decode.field("path", decode.string)
  use min <- decode.field("min", decode.int)
  use max <- decode.field("max", decode.string)
  use type_ <- decode.optional_field("type", [], decode.list(type_decoder()))
  use binding <- decode.optional_field(
    "binding",
    None,
    decode.optional(binding_decoder()),
  )
  decode.success(Element(path:, min:, max:, type_:, binding:))
}

type Type {
  Type(code: String, target_profile: List(String))
}

fn type_decoder() -> decode.Decoder(Type) {
  use code <- decode.field("code", decode.string)
  use target_profile <- decode.optional_field(
    "targetProfile",
    [],
    decode.list(decode.string),
  )
  decode.success(Type(code:, target_profile:))
}

type Binding {
  Binding(strength: String, value_set: Option(String))
}

fn binding_decoder() -> decode.Decoder(Binding) {
  use strength <- decode.field("strength", decode.string)
  use value_set <- decode.optional_field(
    "value_set",
    None,
    decode.optional(decode.string),
  )
  decode.success(Binding(strength:, value_set:))
}

fn gen_fhir(fhir_version: String, download_files: Bool) -> Nil {
  let extract_dir_ver = filepath.join(download_dir, fhir_version)

  let _ = case download_files {
    True -> {
      let assert Ok(_) = simplifile.create_directory_all(extract_dir_ver)
      use filename <- list.map(zip_file_names)
      echo fhir_url <> "/" <> string.uppercase(fhir_version) <> "/" <> filename
      let assert Ok(req) =
        request.to(
          fhir_url <> "/" <> string.uppercase(fhir_version) <> "/" <> filename,
        )
      let assert Ok(resp) = httpc.send(req)
      let write_path = filepath.join(extract_dir_ver, filename)
      let assert Ok(Nil) = simplifile.write(to: write_path, contents: resp.body)
      Nil
    }
    False -> [Nil]
  }

  let generate_dir_ver = filepath.join(gen_into_dir, fhir_version)
  case simplifile.delete(generate_dir_ver) {
    Ok(_) -> Nil
    Error(simplifile.Enoent) -> Nil
    Error(_) -> panic as "could not remove fhir dir"
  }
  let assert Ok(_) = simplifile.create_directory_all(generate_dir_ver)

  file_to_types(
    spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
    gen_dir_ver: generate_dir_ver,
    fv: fhir_version,
    valuesets: [],
    header: "",
    is_domain_resource: False,
  )
  file_to_types(
    spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
    gen_dir_ver: generate_dir_ver,
    fv: fhir_version,
    valuesets: [],
    header: "",
    is_domain_resource: True,
  )
  Nil
}

fn file_to_types(
  spec_file spec_file: String,
  gen_dir_ver generate_dir_ver: String,
  fv fhir_version: String,
  valuesets valuesets: List(string),
  header header: String,
  is_domain_resource is_dr: Bool,
) {
  let assert Ok(spec) = simplifile.read(spec_file)
  let assert Ok(bundle) = json.parse(from: spec, using: bundle_decoder())
  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // uncomment to try just allergyintolerance
        _, "AllergyIntolerance" -> True
        _, _ -> False
        _, "Base" -> False
        _, "BackboneElement" -> False
        Some("complex-type"), _ -> True
        Some("resource"), _ -> True
        _, _ -> False
      }
    })
  use entry <- list.map(entries)

  //map of type -> fields needed to list out all the BackboneElements
  //because they're subcomponents eg Allergy -> Reaction
  //and rather than nested, we want to write fields one after the other
  let starting_res_fields = dict.new() |> dict.insert(entry.resource.name, [])
  //we want to write types in order of parsing backbone elements, but map order random
  //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
  let type_order = [entry.resource.name]
  let fields_and_order = #(starting_res_fields, type_order)

  use snapshot <- option.map(entry.resource.snapshot)

  let fields_and_order =
    list.fold(
      over: snapshot.element,
      from: fields_and_order,
      with: fn(f_o, elt) {
        let res_fields = f_o.0
        let order = f_o.1
        let pp = string.split(elt.path, ".")
        let field_path = string.join(pp, "_")
        //there must be a better way to drop last item?
        let pp_minus_last = pp |> list.reverse |> list.drop(1) |> list.reverse
        let field_path_minus_last = string.join(pp_minus_last, "_")

        let appended_field = case dict.get(res_fields, field_path_minus_last) {
          Ok(field_list) -> [elt, ..field_list]
          Error(_) -> [elt]
        }
        let res_fields =
          dict.insert(res_fields, field_path_minus_last, appended_field)

        let order = case elt.type_ {
          [first, ..] -> {
            case first.code {
              "BackboneElement" -> [field_path, ..order]
              _ -> order
            }
          }
          [] -> order
        }

        #(res_fields, order)
      },
    )

  let type_fields = fields_and_order.0
  let type_order = fields_and_order.1
  echo type_order
  //use res_key <- list.map(dict.keys(type_fields))
  //echo res_key
  //echo dict.get(type_fields, res_key)

  let gleam_fhir_types =
    list.fold(over: type_order, from: "", with: fn(old_type_str, new_type) {
      let new_doc_link =
        string.concat([
          "//",
          string.replace(
            entry.resource.url,
            "hl7.org/fhir",
            "hl7.org/fhir/" <> fhir_version,
          ),
          "#resource",
        ])
      let assert Ok(fields) = dict.get(type_fields, new_type)
      let field_list =
        list.fold(from: "", over: fields, with: fn(str, elt) {
          let field_type = case elt.type_ {
            [] -> "nothing? no types idk"
            [one_type] ->
              case one_type.code {
                "BackboneElement" -> "backbone" <> one_type.code
                "base64Binary" -> "String"
                "boolean" -> "Bool"
                "canonical" -> "String"
                "code" -> "String"
                "date" -> "String"
                "dateTime" -> "String"
                "decimal" -> "Float"
                "id" -> "String"
                "instant" -> "String"
                "integer" -> "Int"
                "integer64" -> "Int"
                "markdown" -> "String"
                "oid" -> "String"
                "positiveInt" -> "Int"
                "string" -> "String"
                "time" -> "String"
                "unsignedInt" -> "Int"
                "uri" -> "String"
                "url" -> "String"
                "uuid" -> "String"
                "xhtml" -> "String"
                "http://hl7.org/fhirpath/System.String" -> "String"
                _ -> one_type.code
              }
            _ -> "multiple types need custom type"
          }
          string.concat([elt.path, ": ", field_type, "\n", str])
        })
      let new_contents =
        string.concat(["pub type ", new_type, "\n{\n", field_list, "\n}"])
      string.join([new_doc_link, new_contents, old_type_str], "\n")
    })

  simplifile.write(
    to: string.lowercase(filepath.join(generate_dir_ver, entry.resource.name))
      <> ".gleam",
    contents: gleam_fhir_types,
  )
}
