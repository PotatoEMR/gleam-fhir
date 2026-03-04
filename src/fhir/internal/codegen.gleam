import argv
import fhir/internal/codegen_client
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set
import gleam/string

//is there a way to add these as dev dependencies but not require for users
import shellout
import simplifile

//dogfood r4 to parse valuesets
import fhir/r4

const check_versions = ["r4", "r4b", "r5"]

const zip_file_names = [
  "profiles-resources.json",
  "profiles-types.json",
]

const fhir_url = "https://www.hl7.org/fhir"

fn const_gen_into_dir() {
  "src" |> filepath.join("generated_fhir")
}

fn const_download_dir() {
  "src"
  |> filepath.join("fhir")
  |> filepath.join("internal")
  |> filepath.join("downloads")
}

pub fn main() {
  io.println("🔥🔥🔥 bultaoreune")

  // lower easier but caps matter for urls like
  // https://build.fhir.org/ig/HL7/US-Core/package.tgz
  let args_cased = argv.load().arguments
  let args_lower = args_cased |> list.map(fn(s) { string.lowercase(s) })

  case
    list.contains(args_lower, "r4")
    || list.contains(args_lower, "r4b")
    || list.contains(args_lower, "r5")
  {
    False ->
      panic as "run with args r4 r4b r5 to generate eg gleam run -m fhir/internal/codegen r4 r5"
    True -> Nil
  }

  let download_files = list.contains(args_lower, "download")
  let download_dir = const_download_dir()

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
  case simplifile.delete(const_gen_into_dir()) {
    Ok(_) -> Nil
    Error(simplifile.Enoent) -> Nil
    Error(_) -> panic as "could not remove fhir dir"
  }
  let assert Ok(_) = simplifile.create_directory_all(const_gen_into_dir())

  let profiles_dir = const_download_dir() |> filepath.join("profiles")
  let custom_profile =
    list.find(args_cased, fn(arg) { string.starts_with(arg, "custom=") })
  case custom_profile {
    Error(_) -> Nil
    Ok(custom_profile) -> {
      case download_files {
        False -> Nil
        True -> {
          let assert [_, profile_url] = string.split(custom_profile, "=")
          let assert Ok(req) = request.to(profile_url)
          let assert Ok(resp) = httpc.send_bits(request.set_body(req, <<>>))
          let assert Ok(_) = simplifile.create_directory_all(profiles_dir)
          let tgz_path = profiles_dir |> filepath.join("package.tgz")
          let assert Ok(Nil) =
            simplifile.write_bits(to: tgz_path, bits: resp.body)
          let assert Ok(_) =
            shellout.command(
              "tar",
              ["-xzf", tgz_path, "-C", profiles_dir],
              ".",
              [],
            )
          let more_exts =
            const_download_dir()
            |> filepath.directory_name
            |> filepath.join("more_custom_extensions")
          let package_dir = profiles_dir |> filepath.join("package")
          let _ =
            result.map(simplifile.read_directory(more_exts), fn(files) {
              list.each(files, fn(f) {
                let assert Ok(bits) =
                  simplifile.read_bits(filepath.join(more_exts, f))
                let assert Ok(_) =
                  simplifile.write_bits(filepath.join(package_dir, f), bits)
              })
            })
          io.println("download profile " <> profile_url)
        }
      }
    }
  }

  use fhir_version <- list.map(check_versions)

  let custom_profile_name = case custom_profile {
    Error(_) -> None
    Ok(_) -> {
      let assert Ok(custom_profile_name) =
        list.find(args_cased, fn(arg) { string.starts_with(arg, "customname=") })
        as "if custom=[url] also need arg customname=[pkg name]"
      let assert [_, custom_profile_name] =
        string.split(custom_profile_name, "=")
      Some(custom_profile_name)
    }
  }
  let profiles_dir = profiles_dir |> filepath.join("package")

  let _ = case list.contains(args_lower, fhir_version) {
    True ->
      gen_fhir(fhir_version, download_files, custom_profile_name, profiles_dir)
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
    snapshot: Option(Snapshot),
    resource_type: String,
    id: String,
    name: String,
    url: String,
    kind: Option(String),
    base_definition: Option(String),
    type_: Option(String),
    context: List(StructuredefinitionContext),
  )
}

fn resource_decoder() -> decode.Decoder(Resource) {
  use snapshot <- decode.optional_field(
    "snapshot",
    None,
    decode.optional(snapshot_decoder()),
  )
  use resource_type <- decode.field("resourceType", decode.string)
  use id <- decode.field("id", decode.string)
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
  use context <- decode.optional_field(
    "context",
    [],
    decode.list(structuredefinition_context_decoder()),
  )
  case resource_type {
    "StructureDefinition" -> {
      use type_ <- decode.optional_field(
        "type",
        None,
        decode.optional(decode.string),
      )
      decode.success(Resource(
        snapshot:,
        resource_type:,
        id:,
        name:,
        url:,
        kind:,
        base_definition:,
        type_:,
        context:,
      ))
    }
    _ ->
      decode.success(Resource(
        snapshot:,
        resource_type:,
        id:,
        name:,
        url:,
        kind:,
        base_definition:,
        type_: None,
        context:,
      ))
  }
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
    id: String,
    path: String,
    min: Int,
    max: String,
    type_: List(Type),
    binding: Option(Binding),
    content_reference: Option(String),
  )
}

fn element_decoder() -> decode.Decoder(Element) {
  use id <- decode.field("id", decode.string)
  use path <- decode.field("path", decode.string)
  use min <- decode.field("min", decode.int)
  use max <- decode.field("max", decode.string)
  use type_ <- decode.optional_field("type", [], decode.list(type_decoder()))
  use binding <- decode.optional_field(
    "binding",
    None,
    decode.optional(binding_decoder()),
  )
  use content_reference <- decode.optional_field(
    "contentReference",
    None,
    decode.optional(decode.string),
  )
  decode.success(Element(
    id:,
    path:,
    min:,
    max:,
    type_:,
    binding:,
    content_reference:,
  ))
}

type Type {
  Type(code: String, target_profile: List(String), profile: List(String))
}

fn type_decoder() -> decode.Decoder(Type) {
  use code <- decode.field("code", decode.string)
  use target_profile <- decode.optional_field(
    "targetProfile",
    [],
    decode.list(decode.string),
  )
  use profile <- decode.optional_field(
    "profile",
    [],
    decode.list(decode.string),
  )
  decode.success(Type(code:, target_profile:, profile:))
}

type Binding {
  Binding(strength: String, value_set: Option(String))
}

fn binding_decoder() -> decode.Decoder(Binding) {
  use strength <- decode.field("strength", decode.string)
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  decode.success(Binding(strength:, value_set:))
}

pub type StructuredefinitionContext {
  StructuredefinitionContext(expression: String)
}

pub fn structuredefinition_context_decoder() {
  use expression <- decode.field("expression", decode.string)
  decode.success(StructuredefinitionContext(expression:))
}

fn gen_fhir(
  fhir_version: String,
  download_files: Bool,
  custom_profile_name: Option(String),
  profiles_dir: String,
) -> Nil {
  let gen_into_dir = const_gen_into_dir()
  let extract_dir_ver = const_download_dir() |> filepath.join(fhir_version)

  let _ = case download_files {
    True -> {
      let assert Ok(_) = simplifile.create_directory_all(extract_dir_ver)
      use filename <- list.map(zip_file_names)
      io.println(
        "download "
        <> fhir_url
        <> "/"
        <> string.uppercase(fhir_version)
        <> "/"
        <> filename,
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

  let gen_prefix = case custom_profile_name {
    None -> filepath.join(gen_into_dir, fhir_version)
    Some(name) -> filepath.join(gen_into_dir, name)
  }
  let gen_gleamfile = gen_prefix <> ".gleam"
  let gen_vsfile = gen_prefix <> "_valuesets.gleam"
  let pkg_prefix = case custom_profile_name {
    None -> fhir_version
    Some(name) -> name
  }
  let need_import_result = case custom_profile_name {
    None -> ""
    Some(_) -> "import gleam/result\n"
  }
  let all_types =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") resources\nimport gleam/json.{type Json}
      import gleam/dynamic/decode.{type Decoder}
      import gleam/option.{type Option, None, Some}
      import gleam/bool
      import gleam/int
      import gleam/dict.{type Dict}
      import gleam/list
      import fhir/",
      pkg_prefix,
      "_valuesets\n",
      need_import_result,
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
        fv: pkg_prefix,
        vsfile: gen_vsfile,
        profiles_dir: profiles_dir,
        custom_profile_name: custom_profile_name,
      ),
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
        fv: pkg_prefix,
        vsfile: gen_vsfile,
        profiles_dir: profiles_dir,
        custom_profile_name: custom_profile_name,
      ),
      "
      //std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
      fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
        decode.one_of(d |> decode.map(Some), [decode.success(None)])
      }

      //std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
      fn decode_number() {
        decode.one_of(decode.float, [decode.map(decode.int, int.to_float)])
      }

      pub fn list1_to_json(l: List1(a), tj: fn(a) -> Json) {
        let List1(first:, rest:) = l
        json.array([first, ..rest], tj)
      }

      pub fn list2_to_json(l: List2(a), tj: fn(a) -> Json) {
        let List2(first:, second:, rest:) = l
        json.array([first, second, ..rest], tj)
      }

      pub fn list3_to_json(l: List3(a), tj: fn(a) -> Json) {
        let List3(first:, second:, third:, rest:) = l
        json.array([first, second, third, ..rest], tj)
      }

      pub fn list1_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List1(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, ..rest] -> next(List1(first:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List1(first: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }

      pub fn list2_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List2(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, second, ..rest] -> next(List2(first:, second:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List2(first: fail_decode_to_satisfy_gleam_type, second: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }

      pub fn list3_decoder(
        name: String,
        inner: decode.Decoder(a),
        next: fn(List3(a)) -> decode.Decoder(b),
      ) -> decode.Decoder(b) {
        use lst <- decode.field(name, decode.list(inner))
        case lst {
          [first, second, third, ..rest] -> next(List3(first:, second:, third:, rest:))
          _ -> {
            use fail_decode_to_satisfy_gleam_type <- decode.field(name, inner)
            next(List3(first: fail_decode_to_satisfy_gleam_type, second: fail_decode_to_satisfy_gleam_type, third: fail_decode_to_satisfy_gleam_type, rest: []))
          }
        }
      }
      ",
    ])
  let assert Ok(_) = simplifile.write(to: gen_gleamfile, contents: all_types)
  io.println("generated " <> gen_gleamfile)

  // gen valuesets for resource fields with required code binding
  // which were written as list to file by gen_gleamfile (why this fn needs to know file as temp list)
  let all_vs = valueset_to_types(gen_vsfile, fhir_version, profiles_dir)
  let assert Ok(_) = simplifile.write(to: gen_vsfile, contents: all_vs)
  io.println("generated " <> gen_vsfile)

  let #(sansio, httpc_layer, rsvp_layer) =
    codegen_client.gen(
      spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
      fv: fhir_version,
      pkg_prefix: pkg_prefix,
      custom_profile_name: custom_profile_name,
      profiles_dir: profiles_dir,
    )
  let f_sansio = gen_prefix <> "_sansio.gleam"
  let assert Ok(_) = simplifile.write(to: f_sansio, contents: sansio)
  io.println("generated " <> f_sansio)
  let f_httpc = gen_prefix <> "_httpc.gleam"
  let assert Ok(_) = simplifile.write(to: f_httpc, contents: httpc_layer)
  io.println("generated " <> f_httpc)
  let f_rsvp = gen_prefix <> "_rsvp.gleam"
  let assert Ok(_) = simplifile.write(to: f_rsvp, contents: rsvp_layer)
  io.println("generated " <> f_rsvp)
}

// type safe extensions for profiles only
// look for StructureDefinition in dir, with type Extension
// if found, create type out of extension, plus
// check .context for where resources use it
// create dict of expression -> extension(s)
// then when generating resource we can add extensions to it

type ProfileFiles {
  ProfileFiles(
    resources: dict.Dict(String, List(Resource)),
    extensions: dict.Dict(String, List(#(String, String))),
    // simple_exts: ext_name -> value[x] Element, for simple extensions
    // (those with a value[x] directly on Extension, no child slices)
    simple_exts: dict.Dict(String, Element),
  )
}

fn file_to_types(
  spec_file spec_file: String,
  fv fhir_version: String,
  vsfile gen_vsfile: String,
  profiles_dir profiles_dir: String,
  custom_profile_name custom_profile_name: Option(String),
) -> String {
  // if doing profile it will define new versions of resources
  // so store the new versions in a resourcename -> structure dict
  // to be used when looping through resources to generate
  // if this is just vanilla r4/r4b/r5 and not a profile, will not change anything
  let profile_structures = case custom_profile_name {
    None -> ProfileFiles(dict.new(), dict.new(), dict.new())
    Some(_) -> {
      let assert Ok(files) = simplifile.read_directory(profiles_dir)
        as { "maybe run with download, custom profile not in " <> profiles_dir }
      files
      |> list.filter(fn(f) { string.starts_with(f, "StructureDefinition") })
      |> list.fold(ProfileFiles(dict.new(), dict.new(), dict.new()), fn(acc, f) {
        let fname = profiles_dir |> filepath.join(f)
        let assert Ok(profile_structuredef) = simplifile.read(fname)
        let assert Ok(r) =
          json.parse(from: profile_structuredef, using: resource_decoder())
        let assert Some(type_) = r.type_
        let #(ext, new_simple_exts) = case type_ {
          "Extension" -> {
            let assert Some(snapshot) = r.snapshot
            let slices =
              list.filter(snapshot.element, fn(e) {
                case string.split(e.id, ":") {
                  [_, _] -> True
                  _ -> False
                }
              })
            let new_simple_exts = case slices {
              [] ->
                case
                  list.find(snapshot.element, fn(e) {
                    e.id == "Extension.value[x]"
                  })
                {
                  Ok(velt) ->
                    case velt.type_ {
                      [_] ->
                        dict.insert(
                          acc.simple_exts,
                          r.id |> string.replace("-", "_"),
                          velt,
                        )
                      _ -> acc.simple_exts
                    }
                  Error(_) -> acc.simple_exts
                }
              _ -> acc.simple_exts
            }
            let new_ext =
              list.fold(
                from: acc.extensions,
                over: r.context,
                with: fn(ext_acc, ext_ctx) {
                  let entry = #(r.url, r.id |> string.replace("-", "_"))
                  case dict.get(ext_acc, ext_ctx.expression) {
                    Ok(exprs) ->
                      dict.insert(ext_acc, ext_ctx.expression, [entry, ..exprs])
                    Error(_) ->
                      dict.insert(ext_acc, ext_ctx.expression, [entry])
                  }
                },
              )
            #(new_ext, new_simple_exts)
          }
          _ -> #(acc.extensions, acc.simple_exts)
        }
        let res = case dict.get(acc.resources, type_) {
          Ok(profile_resources) ->
            dict.insert(acc.resources, type_, [r, ..profile_resources])
          Error(_) -> dict.insert(acc.resources, type_, [r])
        }
        ProfileFiles(res, ext, new_simple_exts)
      })
    }
  }

  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in src/fhir/internal/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(bundle) = json.parse(from: spec, using: bundle_decoder())
  let entries =
    list.filter(bundle.entry, fn(e) {
      case e.resource.kind, e.resource.name {
        // _, "AllergyIntolerance" -> True
        // _, _ -> False
        // debug: uncomment to try just allergyintolerance
        _, "Base" -> False
        _, "BackboneElement" -> False
        _, "Resource" -> False
        _, "Element" -> False
        Some("complex-type"), _ -> True
        Some("resource"), _ -> True
        _, _ -> False
      }
    })

  let entries =
    list.fold(entries, [], fn(acc, entry) {
      case profile_structures.resources |> dict.get(entry.resource.name) {
        Error(_) -> [entry.resource, ..acc]
        Ok(profile_structures) -> {
          list.append([entry.resource, ..profile_structures], acc)
        }
      }
    })
    |> list.reverse

  let all_resources_and_types =
    list.fold(entries, "", fn(elt_str_acc, resource: Resource) {
      //map of type -> fields needed to list out all the BackboneElements
      //because they're subcomponents eg Allergy -> Reaction
      //and rather than nested, we want to write fields one after the other
      let starting_res_fields = dict.new() |> dict.insert(resource.name, [])
      //we want to write types in order of parsing backbone elements, but map order random
      //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
      let type_order = [resource.name]
      let assert Some(snapshot) = resource.snapshot
      let snapshot = case resource.base_definition {
        None -> snapshot
        Some(bd) ->
          case string.contains(bd, "StructureDefinition/Extension") {
            False -> snapshot
            True -> {
              let slices =
                list.filter(snapshot.element, fn(e) {
                  case string.split(e.id, ":") {
                    [_, _] -> True
                    _ -> False
                  }
                })
              let synthetic = case slices {
                [] ->
                  list.fold(snapshot.element, [], fn(acc, e) {
                    case e.id {
                      "Extension.value[x]" -> [
                        Element(
                          id: "Extension.value",
                          path: "Extension.value",
                          min: e.min,
                          max: e.max,
                          type_: e.type_,
                          binding: e.binding,
                          content_reference: None,
                        ),
                        ..acc
                      ]
                      _ -> acc
                    }
                  })
                _ ->
                  list.fold(slices, [], fn(acc, slice) {
                    let assert [_, slice_name] = string.split(slice.id, ":")
                    case
                      list.find(snapshot.element, fn(e) {
                        e.id == slice.id <> ".value[x]"
                      })
                    {
                      Error(_) -> acc
                      Ok(value_elt) -> [
                        Element(
                          id: "Extension." <> slice_name,
                          path: "Extension." <> slice_name,
                          min: slice.min,
                          max: case slice.max {
                            "1" -> "1"
                            _ -> "*"
                          },
                          type_: value_elt.type_,
                          binding: value_elt.binding,
                          content_reference: None,
                        ),
                        ..acc
                      ]
                    }
                  })
              }
              Snapshot(element: synthetic)
            }
          }
      }
      // map extension URL -> #(min, max) from snapshot slices
      let extension_cardinalities =
        list.fold(over: snapshot.element, from: dict.new(), with: fn(acc, elt) {
          case string.split(elt.id, ":"), elt.type_ {
            [_, _], [Type(profile: [ext_url, ..], ..)] ->
              dict.insert(acc, ext_url, #(elt.min, elt.max))
            _, _ -> acc
          }
        })
      // add extensions used in profiles as fake elements to res fields
      let starting_res_fields =
        list.fold(
          over: snapshot.element,
          from: starting_res_fields,
          with: fn(rf_acc, elt) {
            case dict.get(profile_structures.extensions, elt.id) {
              Error(_) -> rf_acc
              Ok(ext_names) -> {
                let pathparts =
                  elt.id
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.split(".")
                let assert [_, ..rest] = pathparts
                let field_path = string.join([resource.name, ..rest], "_")
                list.fold(
                  over: ext_names,
                  from: rf_acc,
                  with: fn(rf_inner_acc, ext) {
                    let #(ext_url, ext_name) = ext
                    let #(ext_min, ext_max) =
                      dict.get(extension_cardinalities, ext_url)
                      |> result.unwrap(#(0, "*"))
                    let add_extension_as_elt =
                      Element(
                        id: elt.id <> "." <> ext_name,
                        path: elt.path <> "." <> ext_name,
                        min: ext_min,
                        max: ext_max,
                        type_: [
                          Type(code: ext_name, target_profile: [], profile: []),
                        ],
                        binding: None,
                        content_reference: None,
                      )
                    case dict.get(rf_inner_acc, field_path) {
                      Ok(existing) ->
                        dict.insert(rf_inner_acc, field_path, [
                          add_extension_as_elt,
                          ..existing
                        ])
                      Error(_) ->
                        dict.insert(rf_inner_acc, field_path, [
                          add_extension_as_elt,
                        ])
                    }
                  },
                )
              }
            }
          },
        )

      let f_o = #(starting_res_fields, type_order)

      elt_str_acc
      <> "\n"
      <> {
        let fields_and_order =
          list.fold(over: snapshot.element, from: f_o, with: fn(f_o, elt) {
            let res_fields = f_o.0
            let order = f_o.1

            // check if we have any extensions on this element
            let is_primitive = case elt.type_ {
              [fst, ..] ->
                case fst.code {
                  "base64Binary"
                  | "boolean"
                  | "canonical"
                  | "code"
                  | "date"
                  | "dateTime"
                  | "decimal"
                  | "id"
                  | "instant"
                  | "integer"
                  | "integer64"
                  | "markdown"
                  | "oid"
                  | "positiveInt"
                  | "string"
                  | "time"
                  | "unsignedInt"
                  | "uri"
                  | "url"
                  | "uuid"
                  | "xhtml"
                  | "http://hl7.org/fhirpath/System.String" -> True
                  _ -> False
                }
              _ -> False
            }
            case profile_structures.extensions |> dict.get(elt.id) {
              Error(Nil) -> Nil
              Ok(_) ->
                case is_primitive {
                  False -> Nil
                  True -> io.println(elt.id)
                }
            }
            // done checking if we have any extensions on this element

            let pathparts =
              elt.id
              |> string.replace("-", "")
              |> string.replace(":", ".")
              |> string.split(".")
            let assert [_, ..rest] = pathparts
            let pathparts = [resource.name, ..rest]
            let field_path = string.join(pathparts, "_")
            //there must be a better way to drop last item?
            let pp_minus_last =
              pathparts |> list.reverse |> list.drop(1) |> list.reverse
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
                  "Element" -> [field_path, ..order]
                  _ -> order
                }
              }
              [] -> order
            }
            #(res_fields, order)
          })

        let type_fields = fields_and_order.0
        let type_order = fields_and_order.1

        list.fold(over: type_order, from: "", with: fn(old_type_acc, new_type) {
          let new_doc_link = {
            let link =
              string.concat([
                string.replace(
                  resource.url,
                  "hl7.org/fhir",
                  "hl7.org/fhir/" <> fhir_version,
                ),
                "#resource",
              ])
            "///[" <> link <> "](" <> link <> ")"
          }

          let camel_type = case new_type == resource.name {
            True -> resource.id |> string.replace("-", "_") |> to_camel_case
            False -> new_type |> to_camel_case
          }
          //conflict gleam list
          let camel_type = case camel_type == "List" {
            True -> "Listfhir"
            False -> camel_type
          }
          let snake_type = to_snake_case(camel_type)
          let assert Ok(fields) = dict.get(type_fields, new_type)
          let fields = case resource.name {
            "SimpleQuantity" ->
              list.filter(fields, fn(x) { x.path != "Quantity.comparator" })
            //simplequantity has no comparator
            _ -> fields
          }
          let fields =
            fields
            |> list.filter(fn(elt) {
              //profiles get rid of elements by setting cardinality max 0
              elt.max != "0"
            })
          // simple extension: one field named "value" with a single type,
          // value[x] lives directly on Extension (no child slices)
          let is_simple_ext = case resource.base_definition {
            None -> False
            Some(bd) ->
              case string.contains(bd, "StructureDefinition/Extension") {
                False -> False
                True ->
                  case fields {
                    [elt] ->
                      case elt.id |> string.split(".") |> list.last, elt.type_ {
                        Ok("value"), [_] -> True
                        _, _ -> False
                      }
                    _ -> False
                  }
              }
          }
          // this tuple is important - all the stuff you generate for each field
          // should probably be a custom type
          // also choice fields do one more fold within this, on their type possibilities
          // make field type, its [x] types, type_new() args and fields, to_json args/always+optional, decoder
          let #(
            field_list,
            choicetypes,
            newfunc_args,
            newfunc_fields,
            encoder_args,
            encoder_json_always,
            encoder_json_options,
            decoder_use,
            decoder_success,
            decoder_always_failure_fordr,
            profile_exts,
          ) =
            list.fold(
              from: #("", list.new(), "", "", "", "", "", "", "", "", []),
              over: fields,
              with: fn(acc, elt: Element) {
                //this should clearly be custom type not tuple
                let fields_acc = acc.0
                let choicetypes_acc = acc.1
                let newfunc_args_acc = acc.2
                let newfunc_fields_acc = acc.3
                let encoder_args_acc = acc.4
                let encoder_always_acc = acc.5
                let encoder_optional_acc = acc.6
                let decoder_use_acc = acc.7
                let decoder_success_acc = acc.8
                let decoder_always_failure_acc = acc.9
                let profile_exts_acc = acc.10
                //yeah this should be custom type right
                let allparts =
                  elt.id
                  |> string.replace("-", "")
                  |> string.replace(":", ".")
                  |> string.split(".")
                let assert [_, ..rest_allparts] = allparts
                let allparts = [resource.name, ..rest_allparts]
                let assert Ok(elt_last_part) =
                  list.reverse(allparts) |> list.first
                //for choice types, which will have a custom type
                let elt_last_part_withgleamtype =
                  string.replace(elt_last_part, "[x]", "")
                // withgleamtype still hasnt escaped the gleam types (use, case, etc) but it's expected in json fields
                // so "\"" <> elt_last_part_withgleamtype <> "\"" should always be actual string for json
                let elt_last_part = case elt_last_part_withgleamtype {
                  //field names cant be reserved gleam words
                  "type" -> "type_"
                  "use" -> "use_"
                  "case" -> "case_"
                  "const" -> "const_"
                  "import" -> "import_"
                  "test" -> "test_"
                  "assert" -> "assert_"
                  _ -> elt_last_part_withgleamtype
                }
                let field_name_new =
                  camel_type <> string.capitalise(elt_last_part)
                let field_type = case elt.type_ {
                  [one_type] ->
                    // For simple extension fields, use the value type directly
                    // instead of the wrapper type name
                    case
                      string.contains(one_type.code, "_"),
                      dict.get(profile_structures.simple_exts, one_type.code)
                    {
                      True, Ok(velt) -> {
                        let assert [Type(code: val_code, ..)] = velt.type_
                        string_to_type(
                          val_code,
                          ["Extension", "value"],
                          fhir_version,
                          velt,
                          gen_vsfile,
                        )
                      }
                      _, _ ->
                        string_to_type(
                          one_type.code,
                          allparts,
                          fhir_version,
                          elt,
                          gen_vsfile,
                        )
                    }
                  [] -> {
                    link_type_from(elt.content_reference, resource.name)
                    |> to_camel_case
                  }
                  _ -> field_name_new
                }
                let elt_snake = to_snake_case(elt_last_part)
                let this_type_fields =
                  string.concat([
                    elt_snake,
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
                          //add all fields of this choice type
                          "\n",
                          field_name_new,
                          string.capitalise(typ.code),
                          "(",
                          elt_snake,
                          ": ",
                          string_to_type(
                            typ.code,
                            [
                              "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                            ],
                            fhir_version,
                            elt,
                            gen_vsfile,
                          ),
                          ")",
                        ])
                      }),
                      "}",
                      //each choice type needs its own to_json and decoder
                      "\npub fn ",
                      snake_type,
                      "_",
                      elt_last_part |> string.lowercase(),
                      "_to_json(elt: ",
                      field_name_new,
                      ") -> Json {case elt{",
                      list.fold(over: elt.type_, from: "", with: fn(acc, typ) {
                        //add all cases of choice type to type_to_json()
                        string.concat([
                          acc,
                          field_name_new,
                          string.capitalise(typ.code),
                          "(v) -> ",
                          string_to_encoder_type(
                            typ.code,
                            allparts,
                            fhir_version,
                            elt,
                          ),
                          "(v)\n",
                        ])
                      }),
                      "}}",
                      //now the decoder
                      "\npub fn ",
                      snake_type,
                      "_",
                      elt_last_part |> string.lowercase(),
                      "_decoder() -> Decoder(",
                      field_name_new,
                      "){",
                      // each choice field here needs to decode from not just type but prefixType
                      // dateTime -> onsetDateTime or age -> onsetAge etc
                      // idk will do later!
                      {
                        // need to split types into first and rest for decoder because idk
                        // gleam decode.one_of needs it that way...
                        // to get an error msg from first or something but it is not a joyful api
                        let assert [fst_type_, ..rest_type_] = elt.type_
                        let decode_one_of_first =
                          gen_choice_field_decoder(
                            fst_type_.code,
                            allparts,
                            fhir_version,
                            elt,
                            field_name_new <> string.capitalise(fst_type_.code),
                            elt_last_part_withgleamtype,
                          )
                        let decode_one_of_rest =
                          list.fold(
                            over: rest_type_,
                            from: "",
                            with: fn(acc, typ) {
                              //add all cases of choice type to type_to_json()
                              string.concat([
                                acc,
                                gen_choice_field_decoder(
                                  typ.code,
                                  allparts,
                                  fhir_version,
                                  elt,
                                  field_name_new <> string.capitalise(typ.code),
                                  elt_last_part_withgleamtype,
                                ),
                              ])
                            },
                          )
                        "decode.one_of("
                        <> decode_one_of_first
                        <> "["
                        <> decode_one_of_rest
                        <> "])"
                      },
                      "}",
                    ]),
                    ..choicetypes_acc
                    //add to all choice types
                  ]
                }
                let #(newfunc_arg, newfunc_field) = case elt.min, elt.max {
                  0, "*" -> #("", elt_snake <> ": [],")
                  1, "*" -> {
                    let arg =
                      string.concat([
                        elt_snake,
                        " ",
                        elt_snake,
                        ": List1(",
                        field_type,
                        "),",
                      ])
                    let field = elt_snake <> ":,"
                    #(arg, field)
                  }
                  2, "*" -> {
                    let arg =
                      string.concat([
                        elt_snake,
                        " ",
                        elt_snake,
                        ": List2(",
                        field_type,
                        "),",
                      ])
                    let field = elt_snake <> ":,"
                    #(arg, field)
                  }
                  3, "*" -> {
                    let arg =
                      string.concat([
                        elt_snake,
                        " ",
                        elt_snake,
                        ": List3(",
                        field_type,
                        "),",
                      ])
                    let field = elt_snake <> ":,"
                    #(arg, field)
                  }
                  0, _ -> #("", elt_snake <> ": None,")
                  1, _ -> {
                    let arg =
                      string.concat([
                        elt_snake,
                        " ",
                        elt_snake,
                        ": ",
                        field_type,
                        ",",
                      ])
                    let field = elt_snake <> ":,"
                    #(arg, field)
                  }
                  _, _ -> panic as "cardinality panic 2"
                }
                //all the fields for encoder to convert to json
                let encoder_args_acc = encoder_args_acc <> elt_snake <> ":,"
                let field_type_encoder = case elt.type_ {
                  [one_type] ->
                    string_to_encoder_type(
                      one_type.code,
                      allparts,
                      fhir_version,
                      elt,
                    )
                  [] -> {
                    link_type_from(elt.content_reference, resource.name)
                    <> "_to_json"
                  }
                  _ ->
                    snake_type
                    <> "_"
                    <> elt_last_part |> string.lowercase()
                    <> "_to_json"
                }
                // can't just put all encode json args in one big acc in array
                // because optional ones need case to add to array or not
                // also putting lists as optional_acc so in empty list cast it omits instead of field: []
                // hence two separate accs
                //let elt_is_choice_type = elt.path |> string.ends_with("[x]")
                let is_profile_ext_check = case elt.type_ {
                  [Type(code:, ..)] -> string.contains(code, "_")
                  _ -> False
                }
                let #(
                  encoder_optional_acc,
                  encoder_always_acc,
                  decoder_always_failure_acc,
                ) = case is_profile_ext_check {
                  True -> #(
                    encoder_optional_acc,
                    encoder_always_acc,
                    decoder_always_failure_acc,
                  )
                  False ->
                    case elt.min, elt.max {
                      0, "*" -> {
                        //0..* list: omit from json if empty
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> elt_snake
                          <> " {
                        [] -> fields
                        _ -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", json.array("
                          <> elt_snake
                          <> ","
                          <> field_type_encoder
                          <> ")), ..fields]
                          }"
                        #(opts, encoder_always_acc, decoder_always_failure_acc)
                      }
                      1, "*" -> {
                        //1..* list: always present, destructure List1
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list1_to_json("
                          <> elt_snake
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      2, "*" -> {
                        //2..* list: always present, destructure List2
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list2_to_json("
                          <> elt_snake
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      3, "*" -> {
                        //3..* list: always present, destructure List3
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", list3_to_json("
                          <> elt_snake
                          <> ","
                          <> field_type_encoder
                          <> ")),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      0, "1" -> {
                        //optional case to json, in Some case add to fields list
                        let choicetype_suffixes = case elt.type_ {
                          // choice type encoder requires onsetAge onsetString onsetPeriod whatever to be suffix in json
                          [_, _, ..] ->
                            string.concat([
                              " <> case v {",
                              list.fold(
                                from: "",
                                over: elt.type_,
                                with: fn(suffixes_acc, ct) {
                                  let assert [first_letter, ..rest] =
                                    ct.code |> string.to_graphemes
                                  // unlike string.capitalise this doesnt make everything after first lowercase
                                  // so createdDateTime doesnt become createdDatetime
                                  let capital_ct =
                                    string.concat([
                                      string.uppercase(first_letter),
                                      ..rest
                                    ])
                                  suffixes_acc
                                  <> field_name_new
                                  <> string.capitalise(ct.code)
                                  <> "(_) -> \""
                                  <> capital_ct
                                  <> "\"\n"
                                },
                              ),
                              "}",
                            ])
                          //normal type encoder (not choice type)
                          _ -> ""
                        }
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> elt_snake
                          <> " {
                        Some(v) -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\""
                          <> choicetype_suffixes
                          <> ", "
                          <> field_type_encoder
                          <> "(v)), ..fields]
                          None -> fields
                        }"
                        #(opts, encoder_always_acc, decoder_always_failure_acc)
                      }
                      1, "1" -> {
                        //mandatory case to json, put in first fields list
                        let always =
                          encoder_always_acc
                          <> "#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", "
                          <> field_type_encoder
                          <> "("
                          <> elt_snake
                          <> ")"
                          <> "),"
                        let decoder_always_failure =
                          decoder_always_failure_acc <> elt_snake <> ":, "
                        #(encoder_optional_acc, always, decoder_always_failure)
                      }
                      _, _ -> panic as "cardinality panic 72"
                    }
                }
                let #(is_profile_ext_fake_elt, profile_ext_fn_name) = case
                  elt.type_
                {
                  [Type(code:, ..)] ->
                    case string.contains(code, "_") {
                      True -> #(True, to_snake_case(to_camel_case(code)))
                      False -> #(False, "")
                    }
                  _ -> #(False, "")
                }
                let field_type_decoder = case is_profile_ext_fake_elt {
                  True -> "todo"
                  False ->
                    case elt.type_ {
                      [_] | [] -> {
                        let decoder_itself = case elt.type_ {
                          [one_type] ->
                            string_to_decoder_type(
                              one_type.code,
                              allparts,
                              fhir_version,
                              elt,
                            )
                          [] ->
                            link_type_from(elt.content_reference, resource.name)
                            <> "_decoder()"
                          _ -> panic as "compiler should see this cant happen"
                        }
                        case elt.max {
                          "*" ->
                            case elt.min {
                              0 ->
                                "decode.optional_field(\""
                                <> elt_last_part_withgleamtype
                                <> "\", [], decode.list("
                                <> decoder_itself
                                <> "))"
                              1 ->
                                "list1_decoder(\""
                                <> elt_last_part_withgleamtype
                                <> "\","
                                <> decoder_itself
                                <> ")"
                              2 ->
                                "list2_decoder(\""
                                <> elt_last_part_withgleamtype
                                <> "\","
                                <> decoder_itself
                                <> ")"
                              3 ->
                                "list3_decoder(\""
                                <> elt_last_part_withgleamtype
                                <> "\","
                                <> decoder_itself
                                <> ")"
                              _ -> panic as "list min > 3 not supported"
                            }
                          _ ->
                            case elt.min {
                              0 -> {
                                "decode.optional_field(\""
                                <> elt_last_part_withgleamtype
                                <> "\", None, decode.optional("
                                <> decoder_itself
                                <> "))"
                              }
                              1 -> {
                                "decode.field(\""
                                <> elt_last_part_withgleamtype
                                <> "\","
                                <> decoder_itself
                                <> ")"
                              }
                              _ -> panic as "cardinality panic 3"
                            }
                        }
                      }
                      _ -> {
                        let choicetype_decoder_itself =
                          string.concat([
                            snake_type,
                            "_",
                            elt_last_part |> string.lowercase(),
                            "_decoder()",
                          ])
                        case elt.min {
                          //for choice type case, custom decoder already knows field names, but we need decode.then and omit if empty
                          1 ->
                            "decode.then(" <> choicetype_decoder_itself <> ")"
                          0 ->
                            "decode.then(none_if_omitted("
                            <> choicetype_decoder_itself
                            <> "))"
                          _ -> panic as "card panic 37"
                        }
                      }
                    }
                }

                let #(decoder_use_acc, profile_exts_acc) = case
                  is_profile_ext_fake_elt
                {
                  True -> #(decoder_use_acc, [
                    #(elt_snake, profile_ext_fn_name, elt.min, elt.max),
                    ..profile_exts_acc
                  ])
                  False -> #(
                    string.concat([
                      decoder_use_acc,
                      "use ",
                      elt_snake,
                      " <- ",
                      field_type_decoder,
                      "\n",
                    ]),
                    profile_exts_acc,
                  )
                }
                let decoder_success_acc =
                  decoder_success_acc <> elt_snake <> ":,"
                #(
                  this_type_fields,
                  choicetypes_acc,
                  newfunc_args_acc <> newfunc_arg,
                  newfunc_fields_acc <> newfunc_field,
                  encoder_args_acc,
                  encoder_always_acc,
                  encoder_optional_acc,
                  decoder_use_acc,
                  decoder_success_acc,
                  decoder_always_failure_acc,
                  profile_exts_acc,
                )
              },
            )
          //now have #(field_list, choicetypes, newfunc_args, newfunc_fields) tuple should prolly be custom type or something
          // first elt in tuple is all the fields for this type

          // generate extension fold for profile extensions
          let profile_exts = list.reverse(profile_exts)
          let decoder_use = case profile_exts {
            [] -> decoder_use
            exts -> {
              let n = list.length(exts)
              let tuple_vars =
                string.join(
                  list.append(
                    list.map(exts, fn(p) {
                      let #(name, _, _, _) = p
                      name <> "_"
                    }),
                    ["extension"],
                  ),
                  ", ",
                )
              let from_tuple =
                "#(" <> string.join(list.repeat("[]", n + 1), ", ") <> ")"
              let acc_vars =
                "#("
                <> string.join(
                  list.append(
                    list.index_map(exts, fn(_, i) { "a" <> int.to_string(i) }),
                    ["plain"],
                  ),
                  ", ",
                )
                <> ")"
              let ok_tuple_for = fn(idx) {
                "#("
                <> string.join(
                  list.append(
                    list.index_map(exts, fn(_, i) {
                      case i == idx {
                        True -> "[v, ..a" <> int.to_string(i) <> "]"
                        False -> "a" <> int.to_string(i)
                      }
                    }),
                    ["plain"],
                  ),
                  ", ",
                )
                <> ")"
              }
              let error_tuple =
                "#("
                <> string.join(
                  list.append(
                    list.index_map(exts, fn(_, i) { "a" <> int.to_string(i) }),
                    ["[ext, ..plain]"],
                  ),
                  ", ",
                )
                <> ")"
              let nested_cases =
                list.reverse(
                  list.index_map(exts, fn(p, i) {
                    let #(_, fn_name, _, _) = p
                    #(fn_name, i)
                  }),
                )
                |> list.fold(from: error_tuple, with: fn(inner, pair) {
                  let #(fn_name, idx) = pair
                  "case "
                  <> fn_name
                  <> "_from_ext(ext) { Ok(v) -> "
                  <> ok_tuple_for(idx)
                  <> " Error(_) -> "
                  <> inner
                  <> " }"
                })
              let conversions =
                list.fold(from: "", over: exts, with: fn(acc, p) {
                  let #(name, _, _min, max) = p
                  acc
                  <> case max {
                    "*" -> "let " <> name <> " = " <> name <> "_\n"
                    _ ->
                      "let "
                      <> name
                      <> " = list.first("
                      <> name
                      <> "_) |> option.from_result\n"
                  }
                })
              let fold_code =
                "let #("
                <> tuple_vars
                <> ") = list.fold(from: "
                <> from_tuple
                <> ", over: extension, with: fn(acc, ext) { let "
                <> acc_vars
                <> " = acc "
                <> nested_cases
                <> " },)\n"
                <> conversions
              decoder_use <> fold_code
            }
          }

          let profile_ext_pre_encoder = case profile_exts {
            [] -> ""
            exts -> {
              let ext_lists =
                list.map(exts, fn(p) {
                  let #(name, fn_name, min, max) = p
                  case min, max {
                    0, "1" ->
                      "case "
                      <> name
                      <> " { Some(v) -> ["
                      <> fn_name
                      <> "_to_ext(v)] None -> [] }"
                    0, _ -> "list.map(" <> name <> ", " <> fn_name <> "_to_ext)"
                    1, "1" -> "[" <> fn_name <> "_to_ext(" <> name <> ")]"
                    1, _ ->
                      "list.map(["
                      <> name
                      <> ".first, .."
                      <> name
                      <> ".rest], "
                      <> fn_name
                      <> "_to_ext)"
                    _, _ -> "[]"
                  }
                })
              "\nlet extension = list.flatten([extension, "
              <> string.join(ext_lists, ", ")
              <> "])"
            }
          }

          let type_newfields = case is_simple_ext {
            // Simple extensions need no wrapper type; the value type is used directly
            True -> ""
            False ->
              string.concat([
                "pub type ",
                camel_type,
                "\n{\n",
                camel_type,
                "(",
                field_list,
                ")\n}",
              ])
          }
          let type_new_newfunc =
            string.concat([
              "pub fn ",
              snake_type,
              "_new(",
              newfunc_args,
              ") ->" <> camel_type,
              "{",
              camel_type,
              "(",
              newfunc_fields,
              ")\n}",
            ])
          let type_choicetypes = string.join(choicetypes, "\n")
          let is_domainresource = case resource.kind {
            Some("complex-type") -> False
            Some("resource") -> resource.name == new_type
            _ -> panic as "????"
          }
          // for profiles, resource.name is eg "USCorePatientProfile" but
          // the resourceType in json must be the base FHIR type eg "Patient"
          let assert Some(fhir_resource_type) = resource.type_

          case camel_type {
            "Extension" -> {
              let assert [elt, ..] = fields
              "
              pub type ExtDict {
                ExtDict(exts_by_url: Dict(String, List(ExtDictContent)))
              }

              pub type ExtDictContent {
                ExtDictContent(id: Option(String), content: ExtDictSimpleOrComplex)
              }

              pub type ExtDictSimpleOrComplex {
                ExtDictComplex(children: ExtDict)
                ExtDictSimple(value: ExtensionValue)
              }

              pub fn exts_to_extdict(exts: List(Extension)) -> ExtDict {
                list.fold(from: dict.new(), over: exts, with: fn(acc, ext) {
                  let content = case ext.ext {
                    ExtSimple(v) -> ExtDictSimple(v)
                    ExtComplex(c) -> ExtDictComplex(exts_to_extdict(c))
                  }
                  let new_ext = ExtDictContent(id: ext.id, content:,)
                  let new_ext_list = case dict.get(acc, ext.url) {
                    Ok(exts) -> [new_ext, ..exts]
                    Error(_) -> [new_ext]
                  }
                  acc |> dict.insert(ext.url, new_ext_list)
                })
                |> ExtDict
              }

              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type Extension {
                Extension(id: Option(String), url: String, ext: ExtensionSimpleOrComplex)
              }
              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type ExtensionSimpleOrComplex {
                ExtComplex(children: List(Extension))
                ExtSimple(value: ExtensionValue)
              }
              ///[http://hl7.org/fhir/r4/StructureDefinition/Extension#resource](http://hl7.org/fhir/r4/StructureDefinition/Extension#resource)
              pub type ExtensionValue {
                " <> list.fold(
                over: elt.type_,
                from: "",
                with: fn(acc: String, typ: Type) -> String {
                  string.concat([
                    acc,
                    "ExtensionValue",
                    string.capitalise(typ.code),
                    "(value: ",
                    string_to_type(typ.code, [], "", elt, ""),
                    ")",
                    "\n",
                  ])
                },
              ) <> "
              }
              pub fn extension_to_json(extension: Extension) -> Json {
                let Extension(id:, url:, ext:) = extension
                let fields = [#(\"url\", json.string(url))]
                let fields = case id {
                  Some(v) -> [#(\"id\", json.string(v)), ..fields]
                  None -> fields
                }
                let fields = [ext_simple_or_complex_to_json(ext), ..fields]
                json.object(fields)
              }
              fn ext_simple_or_complex_to_json(ext) {
                case ext {
                  ExtComplex(children) -> #(
                    \"extension\",
                    json.array(children, extension_to_json),
                  )
                  ExtSimple(val) -> extsimple_to_json(val)
                }
              }
              fn extsimple_to_json(v: ExtensionValue) -> #(String, Json) {
                #(
                  \"value\"
                    <> case v {" <> list.fold(
                over: elt.type_,
                from: "",
                with: fn(acc: String, typ: Type) -> String {
                  string.concat([
                    acc,
                    "ExtensionValue",
                    string.capitalise(typ.code),
                    "(_) -> \"",
                    {
                      let assert [fst, ..rest] = string.to_graphemes(typ.code)
                      string.uppercase(fst) <> string.concat(rest)
                    },
                    "\"",
                  ])
                },
              ) <> "},
                  extension_value_to_json(v),
                )
              }
              pub fn extension_value_to_json(elt: ExtensionValue) -> Json {
                case elt {
                  " <> list.fold(
                over: elt.type_,
                from: "",
                with: fn(acc: String, typ: Type) -> String {
                  string.concat([
                    acc,
                    "ExtensionValue",
                    string.capitalise(typ.code),
                    "(v) -> ",
                    string_to_encoder_type(typ.code, [], "", elt),
                    "(v)\n",
                  ])
                },
              ) <> "
              }
              }
              pub fn extension_decoder() -> Decoder(Extension) {
                use url <- decode.field(\"url\", decode.string)
                use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
                use ext <- decode.then(ext_simple_or_complex_decoder())
                decode.success(Extension(url:, id:, ext:))
              }
              pub fn ext_simple_or_complex_decoder() {
                decode.one_of(
                  decode.field(\"extension\", decode.list(extension_decoder()), decode.success)
                    |> decode.map(ExtComplex),
                  [" <> list.fold(
                over: elt.type_,
                from: "",
                with: fn(acc: String, typ: Type) -> String {
                  let assert [fst, ..rest] = string.to_graphemes(typ.code)
                  let first_upper = string.uppercase(fst) <> string.concat(rest)
                  string.concat([
                    acc,
                    "decode.field(\"value"
                      <> first_upper
                      <> "\", "
                      <> string_to_decoder_type(typ.code, [], "", elt)
                      <> ", decode.success)
                       |> decode.map(ExtensionValue"
                      <> string.capitalise(typ.code)
                      <> ")
                       |> decode.map(ExtSimple),",
                  ])
                },
              ) <> "],
                )
              }
              "
            }
            _ -> {
              let assert Some(base_def) = resource.base_definition
              case string.contains(base_def, "StructureDefinition/Extension") {
                True -> {
                  let to_ext_children =
                    list.fold(
                      over: fields,
                      from: [],
                      with: fn(acc, elt: Element) {
                        let assert Ok(slice_url) =
                          elt.id |> string.split(".") |> list.last
                        let slice_field = case slice_url {
                          "type" -> "type_"
                          "use" -> "use_"
                          "case" -> "case_"
                          "const" -> "const_"
                          "import" -> "import_"
                          "test" -> "test_"
                          "assert" -> "assert_"
                          _ -> slice_url
                        }
                        let elt_snake2 = to_snake_case(slice_field)
                        // returns Extension(...) given a placeholder expression for the value
                        let make_child_ext = fn(placeholder) {
                          case elt.type_ {
                            [] -> ""
                            [Type(code:, ..)] -> {
                              // for code+required binding the field is a valueset type, need _to_string
                              let val_expr = case code, elt.binding {
                                "code",
                                  Some(Binding(
                                    strength: "required",
                                    value_set: Some(vs),
                                  ))
                                -> {
                                  let assert [url, ..] = string.split(vs, "|")
                                  fhir_version
                                  <> "_valuesets."
                                  <> string.lowercase(
                                    concept_name_from_url(Some(url)),
                                  )
                                  <> "_to_string("
                                  <> placeholder
                                  <> ")"
                                }
                                _, _ -> placeholder
                              }
                              "Extension(id: None, url: \""
                              <> slice_url
                              <> "\", ext: ExtSimple(ExtensionValue"
                              <> string.capitalise(code)
                              <> "("
                              <> val_expr
                              <> ")))"
                            }
                            types -> {
                              // choice type: case on the variants, each maps to an ExtensionValue*
                              let field_name_new =
                                camel_type <> string.capitalise(slice_field)
                              let case_arms =
                                list.fold(
                                  over: types,
                                  from: "",
                                  with: fn(case_acc, typ) {
                                    case_acc
                                    <> field_name_new
                                    <> string.capitalise(typ.code)
                                    <> "(v) -> Extension(id: None, url: \""
                                    <> slice_url
                                    <> "\", ext: ExtSimple(ExtensionValue"
                                    <> string.capitalise(typ.code)
                                    <> "(v)))\n"
                                  },
                                )
                              "case " <> placeholder <> " {" <> case_arms <> "}"
                            }
                          }
                        }
                        case elt.type_ {
                          [] -> acc
                          _ -> {
                            let list_expr = case elt.min, elt.max {
                              0, "1" ->
                                "case to_ext."
                                <> elt_snake2
                                <> " { None -> [] Some(c) -> ["
                                <> make_child_ext("c")
                                <> "] }"
                              0, _ ->
                                "to_ext."
                                <> elt_snake2
                                <> " |> list.map(fn(c){ "
                                <> make_child_ext("c")
                                <> " })"
                              1, _ ->
                                "["
                                <> make_child_ext("to_ext." <> elt_snake2)
                                <> "]"
                              _, _ -> ""
                            }
                            [list_expr, ..acc]
                          }
                        }
                      },
                    )
                    |> list.reverse
                    |> string.join(",\n")
                  let from_ext_parts =
                    list.fold(
                      over: fields,
                      from: [],
                      with: fn(acc, elt: Element) {
                        case elt.type_ {
                          [] -> acc
                          _ -> {
                            let assert Ok(slice_url) =
                              elt.id |> string.split(".") |> list.last
                            let slice_field = case slice_url {
                              "type" -> "type_"
                              "use" -> "use_"
                              "case" -> "case_"
                              "const" -> "const_"
                              "import" -> "import_"
                              "test" -> "test_"
                              "assert" -> "assert_"
                              _ -> slice_url
                            }
                            let elt_snake2 = to_snake_case(slice_field)
                            let use_binding = case elt.type_ {
                              [Type(code:, ..)] -> {
                                let is_code_binding = case code, elt.binding {
                                  "code",
                                    Some(Binding(
                                      strength: "required",
                                      value_set: Some(_),
                                    ))
                                  -> True
                                  _, _ -> False
                                }
                                case is_code_binding {
                                  True -> {
                                    let assert Some(Binding(
                                      value_set: Some(vs),
                                      ..,
                                    )) = elt.binding
                                    let assert [vs_url, ..] =
                                      string.split(vs, "|")
                                    let from_str =
                                      fhir_version
                                      <> "_valuesets."
                                      <> string.lowercase(
                                        concept_name_from_url(Some(vs_url)),
                                      )
                                      <> "_from_string"
                                    case elt.min, elt.max {
                                      0, "1" ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Ok(None) Ok([ExtDictContent(content: ExtDictSimple(ExtensionValueCode(s)), ..)]) -> "
                                        <> from_str
                                        <> "(s) |> result.map(Some) Ok(_) -> Error(Nil) })"
                                      0, _ ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Ok([]) Ok(entries) -> list.fold(from: Ok([]), over: entries, with: fn(acc, entry) { use so_far <- result.try(acc) case entry.content { ExtDictSimple(ExtensionValueCode(s)) -> "
                                        <> from_str
                                        <> "(s) |> result.map(fn(v){ [v, ..so_far] }) _ -> Error(Nil) } }) })"
                                      1, _ ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Error(Nil) Ok([ExtDictContent(content: ExtDictSimple(ExtensionValueCode(s)), ..)]) -> "
                                        <> from_str
                                        <> "(s) Ok(_) -> Error(Nil) })"
                                      _, _ -> ""
                                    }
                                  }
                                  False -> {
                                    let val_type = string.capitalise(code)
                                    let ext_pat =
                                      "ExtDictSimple(ExtensionValue"
                                      <> val_type
                                      <> "(v))"
                                    case elt.min, elt.max {
                                      0, "1" ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Ok(None) Ok([ExtDictContent(content: "
                                        <> ext_pat
                                        <> ", ..)]) -> Ok(Some(v)) Ok(_) -> Error(Nil) })"
                                      0, _ ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Ok([]) Ok(entries) -> list.fold(from: Ok([]), over: entries, with: fn(acc, entry) { use so_far <- result.try(acc) case entry.content { "
                                        <> ext_pat
                                        <> " -> Ok([v, ..so_far]) _ -> Error(Nil) } }) })"
                                      1, _ ->
                                        "use "
                                        <> elt_snake2
                                        <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                        <> slice_url
                                        <> "\") { Error(_) -> Error(Nil) Ok([ExtDictContent(content: "
                                        <> ext_pat
                                        <> ", ..)]) -> Ok(v) Ok(_) -> Error(Nil) })"
                                      _, _ -> ""
                                    }
                                  }
                                }
                              }
                              types -> {
                                let field_name_new =
                                  camel_type <> string.capitalise(slice_field)
                                let type_arms_some =
                                  list.fold(
                                    over: types,
                                    from: "",
                                    with: fn(case_acc, typ) {
                                      let vt = string.capitalise(typ.code)
                                      case_acc
                                      <> "Ok([ExtDictContent(content: ExtDictSimple(ExtensionValue"
                                      <> vt
                                      <> "(v)), ..)]) -> Ok(Some("
                                      <> field_name_new
                                      <> vt
                                      <> "(v))) "
                                    },
                                  )
                                let type_arms_single =
                                  list.fold(
                                    over: types,
                                    from: "",
                                    with: fn(case_acc, typ) {
                                      let vt = string.capitalise(typ.code)
                                      case_acc
                                      <> "Ok([ExtDictContent(content: ExtDictSimple(ExtensionValue"
                                      <> vt
                                      <> "(v)), ..)]) -> Ok("
                                      <> field_name_new
                                      <> vt
                                      <> "(v)) "
                                    },
                                  )
                                let type_arms_list =
                                  list.fold(
                                    over: types,
                                    from: "",
                                    with: fn(case_acc, typ) {
                                      let vt = string.capitalise(typ.code)
                                      case_acc
                                      <> "ExtDictSimple(ExtensionValue"
                                      <> vt
                                      <> "(v)) -> Ok(["
                                      <> field_name_new
                                      <> vt
                                      <> "(v), ..so_far]) "
                                    },
                                  )
                                case elt.min, elt.max {
                                  0, "1" ->
                                    "use "
                                    <> elt_snake2
                                    <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                    <> slice_url
                                    <> "\") { Error(_) -> Ok(None) "
                                    <> type_arms_some
                                    <> "Ok(_) -> Error(Nil) })"
                                  0, _ ->
                                    "use "
                                    <> elt_snake2
                                    <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                    <> slice_url
                                    <> "\") { Error(_) -> Ok([]) Ok(entries) -> list.fold(from: Ok([]), over: entries, with: fn(acc, entry) { use so_far <- result.try(acc) case entry.content { "
                                    <> type_arms_list
                                    <> "_ -> Error(Nil) } }) })"
                                  1, _ ->
                                    "use "
                                    <> elt_snake2
                                    <> " <- result.try(case dict.get(ext_dict.exts_by_url, \""
                                    <> slice_url
                                    <> "\") { Error(_) -> Error(Nil) "
                                    <> type_arms_single
                                    <> "Ok(_) -> Error(Nil) })"
                                  _, _ -> ""
                                }
                              }
                            }
                            [#(use_binding, elt_snake2), ..acc]
                          }
                        }
                      },
                    )
                    |> list.reverse
                  let from_ext_use_chain =
                    list.map(from_ext_parts, fn(p) { p.0 })
                    |> string.join("\n")
                  let from_ext_fields =
                    list.map(from_ext_parts, fn(p) { p.1 <> ":" })
                    |> string.join(", ")
                  // is_simple_ext is computed early (before the field fold)
                  // and reused here
                  let to_ext_fn = case is_simple_ext {
                    False ->
                      "pub fn "
                      <> snake_type
                      <> "_to_ext(to_ext: "
                      <> camel_type
                      <> ") -> Extension { Extension(id: None, url: \""
                      <> resource.url
                      <> "\", ext: ExtComplex(list.flatten(["
                      <> to_ext_children
                      <> "]))) }"
                    True -> {
                      let assert [elt] = fields
                      let assert [Type(code:, ..)] = elt.type_
                      let val_type = string.capitalise(code)
                      let gleam_val_type =
                        string_to_type(
                          code,
                          ["Extension", "value"],
                          fhir_version,
                          elt,
                          gen_vsfile,
                        )
                      let val_expr = case code, elt.binding {
                        "code",
                          Some(Binding(
                            strength: "required",
                            value_set: Some(vs),
                          ))
                        -> {
                          let assert [vs_url, ..] = string.split(vs, "|")
                          fhir_version
                          <> "_valuesets."
                          <> string.lowercase(
                            concept_name_from_url(Some(vs_url)),
                          )
                          <> "_to_string(value)"
                        }
                        _, _ -> "value"
                      }
                      "pub fn "
                      <> snake_type
                      <> "_to_ext(value: "
                      <> gleam_val_type
                      <> ") -> Extension { Extension(id: None, url: \""
                      <> resource.url
                      <> "\", ext: ExtSimple(ExtensionValue"
                      <> val_type
                      <> "("
                      <> val_expr
                      <> "))) }"
                    }
                  }
                  let #(ext_type_for_sig, ext_to_json_fn, ext_decoder_fn) = case
                    is_simple_ext
                  {
                    False -> {
                      let to_json =
                        "pub fn "
                        <> snake_type
                        <> "_to_json("
                        <> snake_type
                        <> ": "
                        <> camel_type
                        <> ") -> Json { extension_to_json("
                        <> snake_type
                        <> "_to_ext("
                        <> snake_type
                        <> ")) }"
                      let decoder =
                        "pub fn "
                        <> snake_type
                        <> "_decoder() -> Decoder(Result("
                        <> camel_type
                        <> ", Extension)) { use ext <- decode.then(extension_decoder()) case "
                        <> snake_type
                        <> "_from_ext(ext) { Ok(result) -> decode.success(Ok(result)) Error(Nil) -> decode.success(Error(ext)) } }"
                      #(camel_type, to_json, decoder)
                    }
                    True -> {
                      let assert [elt] = fields
                      let assert [Type(code:, ..)] = elt.type_
                      let gleam_val_type =
                        string_to_type(
                          code,
                          ["Extension", "value"],
                          fhir_version,
                          elt,
                          gen_vsfile,
                        )
                      let to_json =
                        "pub fn "
                        <> snake_type
                        <> "_to_json("
                        <> snake_type
                        <> ": "
                        <> gleam_val_type
                        <> ") -> Json { extension_to_json("
                        <> snake_type
                        <> "_to_ext("
                        <> snake_type
                        <> ")) }"
                      let decoder =
                        "pub fn "
                        <> snake_type
                        <> "_decoder() -> Decoder(Result("
                        <> gleam_val_type
                        <> ", Extension)) { use ext <- decode.then(extension_decoder()) case "
                        <> snake_type
                        <> "_from_ext(ext) { Ok(result) -> decode.success(Ok(result)) Error(Nil) -> decode.success(Error(ext)) } }"
                      #(gleam_val_type, to_json, decoder)
                    }
                  }
                  let from_ext_fn = case is_simple_ext {
                    False ->
                      "pub fn "
                      <> snake_type
                      <> "_from_ext(ext: Extension) -> Result("
                      <> ext_type_for_sig
                      <> ", Nil) { case ext.url, ext.ext { \""
                      <> resource.url
                      <> "\", ExtComplex(children) -> { let ext_dict = exts_to_extdict(children) "
                      <> from_ext_use_chain
                      <> " Ok("
                      <> camel_type
                      <> "("
                      <> from_ext_fields
                      <> ")) } _, _ -> Error(Nil) } }"
                    True -> {
                      let assert [elt] = fields
                      let assert [Type(code:, ..)] = elt.type_
                      let val_type = string.capitalise(code)
                      let match_arm = case code, elt.binding {
                        "code",
                          Some(Binding(
                            strength: "required",
                            value_set: Some(vs),
                          ))
                        -> {
                          let assert [vs_url, ..] = string.split(vs, "|")
                          let from_str =
                            fhir_version
                            <> "_valuesets."
                            <> string.lowercase(
                              concept_name_from_url(Some(vs_url)),
                            )
                            <> "_from_string"
                          "ExtSimple(ExtensionValue"
                          <> val_type
                          <> "(s)) -> "
                          <> from_str
                          <> "(s)"
                        }
                        _, _ ->
                          "ExtSimple(ExtensionValue"
                          <> val_type
                          <> "(v)) -> Ok(v)"
                      }
                      "pub fn "
                      <> snake_type
                      <> "_from_ext(ext: Extension) -> Result("
                      <> ext_type_for_sig
                      <> ", Nil) { case ext.url, ext.ext { \""
                      <> resource.url
                      <> "\", "
                      <> match_arm
                      <> " _, _ -> Error(Nil) } }"
                    }
                  }
                  string.join(
                    [
                      new_doc_link,
                      type_newfields,
                      type_choicetypes,
                      to_ext_fn,
                      ext_to_json_fn,
                      ext_decoder_fn,
                      from_ext_fn,
                    ],
                    "\n",
                  )
                }
                False ->
                  string.join(
                    [
                      new_doc_link,
                      type_newfields,
                      type_choicetypes,
                      type_new_newfunc,
                      old_type_acc,
                      gen_res_encoder(
                        fhir_resource_type,
                        camel_type,
                        snake_type,
                        encoder_args,
                        encoder_json_always,
                        profile_ext_pre_encoder <> encoder_json_options,
                        is_domainresource,
                      ),
                      gen_res_decoder(
                        fhir_resource_type,
                        camel_type,
                        snake_type,
                        decoder_use,
                        decoder_success,
                        is_domainresource,
                        decoder_always_failure_fordr,
                      ),
                    ],
                    "\n",
                  )
              }
            }
          }
        })
      }
    })
  case spec_file |> string.ends_with("profiles-resources.json") {
    False -> all_resources_and_types
    True -> {
      let res_entries =
        entries
        |> list.filter(fn(resource) {
          resource.kind == Some("resource") && resource.name != "DomainResource"
        })
        |> list.map(fn(resource) {
          let camel_type =
            resource.id |> string.replace("-", "_") |> to_camel_case
          #(resource, case camel_type {
            "List" -> "Listfhir"
            _ -> camel_type
          })
        })

      let resource_names =
        res_entries
        |> list.map(fn(entry_and_camel_type) {
          let camel_type = entry_and_camel_type.1
          "Resource" <> camel_type <> "(" <> camel_type <> ")\n"
        })
        |> string.concat

      let resource_encoders =
        res_entries
        |> list.map(fn(entry_and_camel_type) {
          let camel_type = entry_and_camel_type.1
          "Resource"
          <> camel_type
          <> "(r) -> "
          <> to_snake_case(camel_type)
          <> "_to_json(r)\n"
        })
        |> string.concat

      let resource_decoders =
        res_entries
        |> list.map(fn(entry_and_camel_type) {
          let camel_type = entry_and_camel_type.1
          let resource: Resource = entry_and_camel_type.0
          // use the base FHIR type (resource.type_) not the profile name (resource.name)
          let assert Some(fhir_resource_type) = resource.type_
          "\""
          <> fhir_resource_type
          <> "\" -> "
          <> to_snake_case(camel_type)
          <> "_decoder()  |> decode.map(Resource"
          <> camel_type
          <> ")\n"
        })
        |> string.concat

      string.concat([
        all_resources_and_types,
        "pub type Resource{",
        resource_names,
        "}\npub fn resource_to_json(res: Resource) {
            case res {",
        resource_encoders,
        "}
        }\n
        pub fn resource_decoder() -> Decoder(Resource) {
          use tag <- decode.field(\"resourceType\", decode.string)
          case tag {" <> resource_decoders <> "
            _ -> decode.failure(ResourceEnrollmentrequest(enrollmentrequest_new()), expected: \"resourceType\")
          }
        }

        /// 1..*
        ///
        /// a list that must have at least 1 element
        pub type List1(a){
          List1(first: a, rest: List(a))
        }

        /// 2..*
        ///
        /// a list that must have at least 2 elements, for instance
        /// https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-blood-pressure.html
        pub type List2(a){
          List2(first: a, second: a, rest: List(a))
        }

        /// 3..*
        ///
        /// a list that must have at least 3 elements
        pub type List3(a){
          List3(first: a, second: a, third: a, rest: List(a))
        }
        ",
      ])
    }
  }
}

fn link_type_from(content_reference: Option(String), resource_name: String) {
  let assert Some(link_type) = content_reference
  let assert [_, link_type] = string.split(link_type, "#")
  let assert [_, ..rest] = string.split(link_type, ".")
  [resource_name, ..rest]
  |> string.join("_")
  |> string.lowercase()
}

fn string_to_type(
  fhir_type: String,
  allparts: List(String),
  fhir_version: String,
  elt: Element,
  gen_vsfile: String,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts |> list.map(string.capitalise) |> string.concat()
    "Element" -> allparts |> list.map(string.capitalise) |> string.concat()
    "base64Binary" -> "String"
    "boolean" -> "Bool"
    "canonical" -> "String"
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" ->
          "String"
        //not a code idk should we even generate this?
        _ -> {
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" -> {
                  case x.value_set {
                    Some(vs) -> {
                      let assert [url, ..] = string.split(vs, "|")
                        as "split vs version"
                      //get rid of |version in http://some.valueset|4.0.1
                      case
                        string.contains(url, "v3-Confidentiality")
                        || string.contains(url, "mimetypes")
                        || string.contains(url, "currencies")
                        || string.contains(url, "all-languages")
                        || string.contains(url, "ucum-units")
                        || string.contains(url, "color-codes")
                      {
                        True -> "String"
                        //idk whats going on here, probably i dont understand valueset composition
                        False -> {
                          let assert Ok(Nil) =
                            simplifile.append(
                              to: gen_vsfile,
                              contents: url <> "\n",
                            )
                          fhir_version
                          <> "_valuesets."
                          <> concept_name_from_url(Some(url))
                        }
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                }
                _ -> "String"
                //mostly just elt.languages doesnt have "required" code binding
              }
            None -> "String"
            //these codes dont have required binding?
          }
        }
      }
    }
    "date" -> "String"
    "dateTime" -> "String"
    "decimal" -> "Float"
    "id" -> "String"
    "instant" -> "String"
    "integer" -> "Int"
    "integer64" -> "String"
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
    _ -> to_camel_case(fhir_type)
    //other complex type case will just be itself eg "Annotation" -> "Annotation"
    // and will require importing that type
  }
}

// this makes the decode.string or decode.int or allergy_intolerance_reaction_decoder() or whatever
// could maybe be combined with very similar previous func
fn string_to_decoder_type(
  fhir_type: String,
  allparts: List(String),
  fhir_version: String,
  elt: Element,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> to_snake_case()
      <> "_decoder()"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> to_snake_case()
      <> "_decoder()"
    "base64Binary" -> "decode.string"
    "boolean" -> "decode.bool"
    "canonical" -> "decode.string"
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" ->
          "String"
        //not a code idk should we even generate this?
        _ -> {
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" -> {
                  case x.value_set {
                    Some(vs) -> {
                      let assert [url, ..] = string.split(vs, "|")
                        as "split vs version"
                      //get rid of |version in http://some.valueset|4.0.1
                      case
                        string.contains(url, "v3-Confidentiality")
                        || string.contains(url, "mimetypes")
                        || string.contains(url, "currencies")
                        || string.contains(url, "all-languages")
                        || string.contains(url, "ucum-units")
                        || string.contains(url, "color-codes")
                      {
                        True -> "decode.string"
                        //idk whats going on here, probably i dont understand valueset composition
                        False ->
                          fhir_version
                          <> "_valuesets."
                          <> Some(url)
                          |> concept_name_from_url()
                          |> to_snake_case
                          <> "_decoder()"
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                }
                _ -> "decode.string"
                //mostly just elt.languages doesnt have "required" code binding
              }
            None -> "decode.string"
            //these codes dont have required binding?
          }
        }
      }
    }
    "date" -> "decode.string"
    "dateTime" -> "decode.string"
    "decimal" -> "decode_number()"
    "id" -> "decode.string"
    "instant" -> "decode.string"
    "integer" -> "decode.int"
    "integer64" -> "decode.string"
    "markdown" -> "decode.string"
    "oid" -> "decode.string"
    "positiveInt" -> "decode.int"
    "string" -> "decode.string"
    "time" -> "decode.string"
    "unsignedInt" -> "decode.int"
    "uri" -> "decode.string"
    "url" -> "decode.string"
    "uuid" -> "decode.string"
    "xhtml" -> "decode.string"
    "http://hl7.org/fhirpath/System.String" -> "decode.string"
    _ -> {
      fhir_type
      |> string.lowercase()
      <> "_decoder()"
    }
    //decoder for backbone element eg visionprescription_lensspecification_decoder()
  }
}

fn string_to_encoder_type(
  fhir_type: String,
  allparts: List(String),
  fhir_version: String,
  elt: Element,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> to_snake_case()
      <> "_to_json"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> to_snake_case()
      <> "_to_json"
    "base64Binary" -> "json.string"
    "boolean" -> "json.bool"
    "canonical" -> "json.string"
    "code" -> {
      let s = allparts |> string.concat()
      case s {
        "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding" ->
          "String"
        //not a code idk should we even generate this?
        _ -> {
          case elt.binding {
            Some(x) ->
              case x.strength {
                "required" -> {
                  case x.value_set {
                    Some(vs) -> {
                      let assert [url, ..] = string.split(vs, "|")
                        as "split vs version"
                      //get rid of |version in http://some.valueset|4.0.1
                      case
                        string.contains(url, "v3-Confidentiality")
                        || string.contains(url, "mimetypes")
                        || string.contains(url, "currencies")
                        || string.contains(url, "all-languages")
                        || string.contains(url, "ucum-units")
                        || string.contains(url, "color-codes")
                      {
                        True -> "json.string"
                        //idk whats going on here, probably i dont understand valueset composition
                        False ->
                          fhir_version
                          <> "_valuesets."
                          <> Some(url)
                          |> concept_name_from_url()
                          |> to_snake_case
                          <> "_to_json"
                      }
                    }
                    _ -> panic as "huh idk 2"
                  }
                }
                _ -> "json.string"
                //mostly just elt.languages doesnt have "required" code binding
              }
            None -> "json.string"
            //these codes dont have required binding?
          }
        }
      }
    }
    "date" -> "json.string"
    "dateTime" -> "json.string"
    "decimal" -> "json.float"
    "id" -> "json.string"
    "instant" -> "json.string"
    "integer" -> "json.int"
    "integer64" -> "json.string"
    "markdown" -> "json.string"
    "oid" -> "json.string"
    "positiveInt" -> "json.int"
    "string" -> "json.string"
    "time" -> "json.string"
    "unsignedInt" -> "json.int"
    "uri" -> "json.string"
    "url" -> "json.string"
    "uuid" -> "json.string"
    "xhtml" -> "json.string"
    "http://hl7.org/fhirpath/System.String" -> "json.string"
    _ -> {
      fhir_type
      |> string.lowercase()
      <> "_to_json"
    }
    //encoder for backbone element eg visionprescription_lensspecification_encoder()
  }
}

fn gen_choice_field_decoder(
  type_code,
  allparts,
  fhir_version,
  elt,
  choice_option_caps,
  choicetype_last_part,
) -> String {
  let assert [fst, ..rest] = type_code |> string.to_graphemes
  let choicetype_parse_label =
    choicetype_last_part <> string.uppercase(fst) <> string.concat(rest)
  let type_decoder =
    string_to_decoder_type(type_code, allparts, fhir_version, elt)
  "decode.field(\""
  <> choicetype_parse_label
  <> "\", "
  <> type_decoder
  <> ", decode.success) |> decode.map("
  <> choice_option_caps
  <> "),"
}

// replace capital HelloThere with lowercase hello_there
// but if the previous character was a capital it will not add an underscore
fn to_snake_case(input: String) -> String {
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

fn to_camel_case(input: String) -> String {
  // only first letter and then each backbone elt is capital
  // so you can see nested backbone elements
  input
  |> string.split("_")
  |> list.map(fn(s) { string.capitalise(s) })
  |> string.concat
}

fn cardinality(fieldtype: String, fieldmin: Int, fieldmax: String) {
  case fieldmin, fieldmax {
    0, "*" -> "List(" <> fieldtype <> ")"
    1, "*" -> "List1(" <> fieldtype <> ")"
    2, "*" -> "List2(" <> fieldtype <> ")"
    3, "*" -> "List3(" <> fieldtype <> ")"
    0, "1" -> "Option(" <> fieldtype <> ")"
    1, "1" -> fieldtype
    _, _ -> panic as "cardinality panic, if you have n..* with n > 3 idk"
  }
}

//probably redundant to have both this and valueset encoder/decoder oh well
fn gen_res_encoder(
  respascal: String,
  rescamel: String,
  reslower: String,
  fields_list: String,
  fields_json_always: String,
  fields_json_options: String,
  is_domainresource: Bool,
) -> String {
  let resource_type = case is_domainresource {
    True ->
      "\n  let fields = [#(\"resourceType\", json.string(\""
      <> respascal
      <> "\")), ..fields]"
    False -> ""
  }
  let template =
    "pub fn RESNAMELOWER_to_json(RESNAMELOWER: RESNAMECAMEL) -> Json {
    let RESNAMECAMEL(" <> fields_list <> ") = RESNAMELOWER
    let fields = [" <> fields_json_always <> "]" <> fields_json_options <> resource_type <> "\njson.object(fields)}
  "
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}

fn gen_res_decoder(
  respascal: String,
  rescamel: String,
  reslower: String,
  use_list: String,
  success_list: String,
  is_domainresource: Bool,
  decoder_always_failure_fordr: String,
) {
  let resource_type = case is_domainresource {
    True -> "\n    use rt <- decode.field(\"resourceType\", decode.string)
      use <- bool.guard(rt != \"" <> respascal <> "\", decode.failure(RESNAMELOWER_new(" <> decoder_always_failure_fordr <> "), \"resourceType\"))"
    False -> ""
  }
  let template = "pub fn RESNAMELOWER_decoder() -> Decoder(RESNAMECAMEL) {
     use <- decode.recursive\n" <> use_list // maybe resource_type should go at beginning so if resourceType not found it doesnt run anything else?
    // but then would have to come up with dummy values for resource required fields, including valuesets
    <> resource_type <> "decode.success(RESNAMECAMEL(" <> success_list <> "))}"
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}

// region valuesets
// note we already have a list of required bindings from resources, now need to fill codes in for those

fn concept_name_from_url(u) {
  let assert Some(url) = u
  let assert Ok(urlname) = url |> string.split("/") |> list.last()
  let assert [fst, ..rest] = string.to_graphemes(urlname)
  let urlname = case fst {
    "0" -> string.concat(["Zero", ..rest])
    "1" -> string.concat(["One", ..rest])
    "2" -> string.concat(["Two", ..rest])
    "3" -> string.concat(["Three", ..rest])
    "4" -> string.concat(["Four", ..rest])
    "5" -> string.concat(["Five", ..rest])
    "6" -> string.concat(["Six", ..rest])
    "7" -> string.concat(["Seven", ..rest])
    "8" -> string.concat(["Eight", ..rest])
    "9" -> string.concat(["Nine", ..rest])
    _ -> urlname
  }
  urlname
  |> string.replace(" ", "")
  |> string.replace("-", "")
  |> string.replace("_", "")
  |> string.replace(".", "")
  |> string.capitalise
}

fn valueset_to_types(vsfile: String, fhir_version: String, profiles_dir: String) {
  //the valueset urls needed by element bindings
  let assert Ok(vs_list) = simplifile.read(vsfile)
  let vs_url_set =
    list.fold(
      from: set.new(),
      over: string.split(vs_list, "\n"),
      with: fn(acc, vs) { acc |> set.insert(vs) },
    )
    |> set.delete("")
    |> set.delete("http://unitsofmeasure.org")
    |> set.delete("http://hl7.org/fhir/ValueSet/color-codes")

  let vs_imports =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") valuesets\n\nimport gleam/dynamic/decode.{type Decoder}\n  import gleam/json.{type Json}\n",
    ])
  let expansion_dir =
    "src"
    |> filepath.join("fhir")
    |> filepath.join("internal")
    |> filepath.join("valueset_expansions")
    |> filepath.join(fhir_version)
  set.fold(from: vs_imports, over: vs_url_set, with: fn(valuesets_acc, vs_url) {
    let vsname = concept_name_from_url(Some(vs_url))
    let vs_codes = get_codes(vs_url, expansion_dir, profiles_dir)
    case vs_codes {
      Error(_) -> {
        // would like to gen valuesets for profiles too but not clear how to expand some of them...
        // eg ValueSet-us-core-condition-code-current.json has filter from snomed is-a
        // for now will have to leave all codes in profiles as strings :/
        // could maybe provide codes for simpler codesystems only
        valuesets_acc
      }
      Ok(vs_codes) -> {
        let vs_named_codes =
          vs_codes
          |> list.map(fn(code) {
            vsname <> string.capitalise(codetovarname(code))
          })
        string.concat([
          "pub type ",
          vsname,
          "{",
          string.join(vs_named_codes, "\n"),
          "}",
          gen_valueset_encoder(vsname, vs_codes),
          gen_valueset_to_string(vsname, vs_codes),
          gen_valueset_from_string(vsname, vs_codes),
          gen_valueset_decoder(vsname, vs_codes),
          valuesets_acc,
        ])
      }
    }
  })
}

// https://chat.fhir.org/#narrow/channel/179166-implementers/topic/Kotlin.20FHIR.20model.20code.20generation.20questions/near/524688061
// kind of pissed after the satisfying experience of getting the recursive valueset/codesystem expansion working in gleam that you can (and must in r4b/r5) simply use the expanded valuesets from terminology download?
fn get_codes(
  url: String,
  expansion_dir: String,
  profiles_dir: String,
) -> Result(List(String), Nil) {
  let assert Ok(vs_file) =
    url |> string.split("/") |> list.reverse |> list.first
  let expansion =
    expansion_dir |> filepath.join("ValueSet-" <> vs_file <> ".json")
  let vs_json = simplifile.read(expansion)
  let vs_json = case vs_json {
    Ok(vs_json) -> vs_json
    Error(_) -> {
      let expansion =
        profiles_dir |> filepath.join("ValueSet-" <> vs_file <> ".json")
      let assert Ok(profile_vs_json) = simplifile.read(expansion)
        as {
          expansion
          <> " valueset expansion should be in either fhir expansions or profile expansions"
        }
      profile_vs_json
    }
  }
  let assert Ok(vs) = vs_json |> json.parse(r4.valueset_decoder())
  // so profiles do not necessarily provide extended valuesets
  // us core will come soon: https://chat.fhir.org/#narrow/channel/179166-implementers/topic/US.20core.20valueset.20expansion.20package.3F/with/574276119
  // this could be a chance to do something clever with recursive codesystem parser
  // for now just going to go 1 level of valueset -> compose -> include
  case vs.expansion {
    Some(vs_expansion) ->
      Ok(
        list.map(vs_expansion.contains, fn(c: r4.ValuesetExpansionContains) {
          let assert Some(code) = c.code
          code
        }),
      )
    None -> {
      case vs.compose {
        None -> Error(Nil)
        Some(vsc) -> {
          let ret =
            list.fold(
              from: [],
              over: [vsc.include.first, ..vsc.include.rest],
              with: fn(outer_acc, vsci) {
                list.fold(
                  from: outer_acc,
                  over: vsci.concept,
                  with: fn(inner_acc, vscic) { [vscic.code, ..inner_acc] },
                )
              },
            )
          Ok(ret)
        }
      }
    }
  }
}

fn codetovarname(c: String) {
  str_replace_many(c, [
    #("-", ""),
    #(".", ""),
    #("_", ""),
    #("/", ""),
    #("!=", "Notequal"),
    #("=", "Equal"),
    #(">=", "Greaterthanoreq"),
    #(">", "Greaterthan"),
    #("<=", "Lessthanoreq"),
    #("<", "Lessthan"),
  ])
}

fn str_replace_many(s: String, badchars: List(#(String, String))) -> String {
  list.fold(from: s, over: badchars, with: fn(acc, bc) {
    string.replace(acc, bc.0, bc.1)
  })
}

fn gen_valueset_encoder(vsname: String, _vs_codes: List(String)) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn CNAMELOWER_to_json(CNAMELOWER: CNAMECAPITAL) -> Json {
    json.string(CNAMELOWER_to_string(CNAMELOWER))
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

fn gen_valueset_to_string(vsname: String, vs_codes: List(String)) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn CNAMELOWER_to_string(CNAMELOWER: CNAMECAPITAL) -> String {
    case CNAMELOWER {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, code: String) {
        acc
        <> "CODETYPE -> \"ACTUALCODE\"\n"
        |> string.replace(
          "CODETYPE",
          vsname <> string.capitalise(codetovarname(code)),
        )
        |> string.replace("ACTUALCODE", code)
      },
    ) <> "}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

fn gen_valueset_decoder(vsname: String, vs_codes: List(String)) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let assert Ok(fail_code) = list.first(vs_codes) as vsname
  let template = "pub fn CNAMELOWER_decoder() -> Decoder(CNAMECAPITAL) {
    use variant <- decode.then(decode.string)
    case variant {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, code: String) {
        acc
        <> "\"ACTUALCODE\" -> decode.success(CODETYPE)\n"
        |> string.replace(
          "CODETYPE",
          vsname <> string.capitalise(codetovarname(code)),
        )
        |> string.replace("ACTUALCODE", code)
      },
    ) <> "_ -> decode.failure(" <> vsname <> string.capitalise(codetovarname(
      fail_code,
    )) <> ", \"CNAMECAPITAL\")}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}

fn gen_valueset_from_string(vsname: String, vs_codes: List(String)) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template =
    "pub fn CNAMELOWER_from_string(s: String) -> Result(CNAMECAPITAL, Nil) {
    case s {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, code: String) {
        acc
        <> "\"ACTUALCODE\" -> Ok(CODETYPE)\n"
        |> string.replace(
          "CODETYPE",
          vsname <> string.capitalise(codetovarname(code)),
        )
        |> string.replace("ACTUALCODE", code)
      },
    ) <> "_ -> Error(Nil)}
  }
  "
  template
  |> string.replace("CNAMELOWER", vsname_lower)
  |> string.replace("CNAMECAPITAL", vsname |> string.capitalise())
}
