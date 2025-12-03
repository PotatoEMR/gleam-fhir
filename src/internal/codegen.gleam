import argv
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
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

  case
    list.contains(args, "r4")
    || list.contains(args, "r4b")
    || list.contains(args, "r5")
  {
    False ->
      io.println(
        "run with args r4 r4b r5 to generate eg gleam run -m internal/codegen r4 r5",
      )
    True -> Nil
  }

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
      io.println(
        fhir_url <> "/" <> string.uppercase(fhir_version) <> "/" <> filename,
      )
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

  let generated_gleamfile =
    filepath.join(gen_into_dir, fhir_version) <> ".gleam"
  case simplifile.delete(generated_gleamfile) {
    Ok(_) -> Nil
    Error(simplifile.Enoent) -> Nil
    Error(_) -> panic as "could not remove fhir dir"
  }
  let all_types =
    string.concat([
      "////hi\nimport gleam/option.{type Option}\n",
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
        fv: fhir_version,
      ),
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
        fv: fhir_version,
      ),
    ])
  let assert Ok(_) =
    simplifile.write(to: generated_gleamfile, contents: all_types)
  Nil
}

fn file_to_types(spec_file spec_file: String, fv fhir_version: String) -> String {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in src/internal/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(bundle) = json.parse(from: spec, using: bundle_decoder())
  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // debug: uncomment to try just allergyintolerance
        // _, "AllergyIntolerance" -> True
        // _, _ -> False
        _, "Base" -> False
        _, "BackboneElement" -> False
        Some("complex-type"), _ -> True
        Some("resource"), _ -> True
        _, _ -> False
      }
    })
  list.fold(entries, "", fn(elt_str_acc, entry: Entry) {
    //map of type -> fields needed to list out all the BackboneElements
    //because they're subcomponents eg Allergy -> Reaction
    //and rather than nested, we want to write fields one after the other
    let starting_res_fields = dict.new() |> dict.insert(entry.resource.name, [])
    //we want to write types in order of parsing backbone elements, but map order random
    //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
    let type_order = [entry.resource.name]
    let fields_and_order = #(starting_res_fields, type_order)

    elt_str_acc
    <> "\n"
    <> case entry.resource.snapshot {
      None -> ""
      Some(snapshot) -> {
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
              let pp_minus_last =
                pp |> list.reverse |> list.drop(1) |> list.reverse
              let field_path_minus_last = string.join(pp_minus_last, "_")

              let appended_field = case
                dict.get(res_fields, field_path_minus_last)
              {
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
        // echo type_order
        //use res_key <- list.map(dict.keys(type_fields))
        //echo res_key
        //echo dict.get(type_fields, res_key)

        list.fold(over: type_order, from: "", with: fn(old_type_acc, new_type) {
          let new_doc_link =
            string.concat([
              "///",
              string.replace(
                entry.resource.url,
                "hl7.org/fhir",
                "hl7.org/fhir/" <> fhir_version,
              ),
              "#resource",
            ])
          // only first letter and then each backbone elt is capital
          // so you can see nested backbone elements
          let camel_type =
            new_type
            |> string.split("_")
            |> list.map(fn(s) { string.capitalise(s) })
            |> string.concat
          //conflict gleam list
          let camel_type = case camel_type == "List" {
            True -> "FhirList"
            False -> camel_type
          }
          let assert Ok(fields) = dict.get(type_fields, new_type)
          let #(field_list, choicetypes) =
            list.fold(
              from: #("", list.new()),
              over: fields,
              with: fn(acc, elt: Element) {
                let fields_acc = acc.0
                let choicetypes_acc = acc.1
                let allparts = string.split(elt.path, ".")
                let assert Ok(elt_last_part) =
                  list.reverse(allparts) |> list.first
                //for choice types, which will have a custom type
                let elt_last_part = string.replace(elt_last_part, "[x]", "")
                let elt_last_part = case elt_last_part {
                  //field names cant be reserved gleam words
                  "type" -> "type_"
                  "use" -> "use_"
                  "case" -> "case_"
                  "const" -> "const_"
                  "import" -> "import_"
                  "test" -> "test_"
                  "assert" -> "assert_"
                  _ -> elt_last_part
                }
                let field_name_new =
                  camel_type <> string.capitalise(elt_last_part)
                let field_type = case elt.type_ {
                  [one_type] -> string_to_type(one_type.code, allparts)
                  [] -> "Nil"
                  _ -> field_name_new
                }
                let this_type_fields =
                  string.concat([
                    to_snake_case(elt_last_part),
                    ": ",
                    cardinality(field_type, elt.min, elt.max),
                    ",\n",
                    fields_acc,
                  ])
                let choicetypes_acc = case elt.type_ {
                  [] -> choicetypes_acc
                  [_] -> choicetypes_acc
                  _ -> [
                    string.concat([
                      "\n",
                      new_doc_link,
                      "\npub type ",
                      field_name_new,
                      "{",
                      list.fold(over: elt.type_, from: "", with: fn(acc, typ) {
                        string.concat([
                          acc,
                          "\n",
                          field_name_new,
                          string.capitalise(typ.code),
                          "(",
                          to_snake_case(elt_last_part),
                          ": ",
                          string_to_type(typ.code, [
                            "should probably pull type switch separate from backbone elt",
                          ]),
                          ")",
                        ])
                      }),
                      "}",
                    ]),
                    ..choicetypes_acc
                  ]
                }
                #(this_type_fields, choicetypes_acc)
              },
            )
          // first elt in tuple is all the fields for this type
          // these quantity ones messed up idk why
          let field_list = case
            list.contains(
              ["SimpleQuantity", "MoneyQuantity"],
              entry.resource.name,
            )
          {
            True ->
              "id: Option(String), extension: List(Extension), value: Option(Float), comparator: Option(String), unit: Option(String), system: Option(String), code: Option(String),"
            False -> field_list
          }
          let type_newfields =
            string.concat([
              "pub type ",
              camel_type,
              "\n{\n",
              camel_type,
              "(",
              field_list,
              ")\n}",
            ])
          let type_choicetypes = string.join(choicetypes, "\n")
          string.join(
            [new_doc_link, type_newfields, type_choicetypes, old_type_acc],
            "\n",
          )
        })
      }
    }
  })
}

fn string_to_type(fhir_type: String, allparts: List(String)) -> String {
  case fhir_type {
    "BackboneElement" -> string.concat(list.map(allparts, string.capitalise))
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
    _ -> string.capitalise(fhir_type)
    //other complex type case will just be itself eg "Annotation" -> "Annotation"
    // and will require importing that type
  }
}

// replace capital HelloThere with lowercase hello_there
// but if the previous character was a capital it will not add an underscore
pub fn to_snake_case(input: String) -> String {
  input
  |> string.to_graphemes
  |> list.fold(#("", False), fn(acc, char) {
    let #(result, prev_was_upper) = acc
    case char == string.uppercase(char) && char != string.lowercase(char) {
      True -> {
        case result, prev_was_upper {
          "", _ -> #(string.lowercase(char), True)
          _, True -> #(result <> string.lowercase(char), True)
          _, False -> #(result <> "_" <> string.lowercase(char), True)
        }
      }
      False -> #(result <> char, False)
    }
  })
  |> fn(pair) { pair.0 }
}

pub fn cardinality(fieldtype: String, fieldmin: Int, fieldmax: String) {
  case fieldmin, fieldmax {
    _, "*" -> "List(" <> fieldtype <> ")"
    //might be missing "must have at least 1" correctness for cases with 1..* but who cares
    0, "1" -> "Option(" <> fieldtype <> ")"
    1, "1" -> fieldtype
    _, _ -> panic as "cardinality panic"
  }
}
