import argv
import codegen_client
import codegen_helpers
import codegen_profile
import codegen_profile_package_download_no_npm
import fhir/r4/resources as r4
import filepath
import gleam/dict
import gleam/http/request
@target(erlang)
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string

//dev dependencies but not required for users
import simplifile

const check_versions = ["r4", "r4b", "r5"]

const zip_file_names = [
  "profiles-resources.json",
  "profiles-types.json",
]

const fhir_url = "https://www.hl7.org/fhir"

const gen_into_dir = "generated_fhir"

fn const_download_dir() {
  "dev" |> filepath.join("downloads")
}

fn simplifier_core_package_version(fhir_version: String) {
  case fhir_version {
    "r4" -> "4.0.1"
    "r4b" -> "4.3.0"
    "r5" -> "5.0.0"
    _ -> panic as "unsupported FHIR version"
  }
}

@target(erlang)
pub fn main() {
  io.println("🔥🔥🔥 bultaoreune")

  // caps used to matter for profile urls, not sure if simplifier cares
  let args_cased = argv.load().arguments
  let args_lower = args_cased |> list.map(fn(s) { string.lowercase(s) })

  case
    list.contains(args_lower, "r4")
    || list.contains(args_lower, "r4b")
    || list.contains(args_lower, "r5")
  {
    False ->
      panic as "run with args r4 r4b r5 to generate eg gleam run -m codegen r4 r5"
    True -> Nil
  }

  let download_files = list.contains(args_lower, "download")
  let all_primitive_ext = list.contains(args_lower, "allprimitiveext")
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
  // on you to rm -rf generated_fhir && mkdir generated_fhir
  // so we can call codegen multiple times in one script
  // case simplifile.delete(gen_into_dir) {
  //   Ok(_) -> Nil
  //   Error(simplifile.Enoent) -> Nil
  //   Error(_) -> panic as "could not remove fhir dir"
  // }
  // let assert Ok(_) = simplifile.create_directory_all(gen_into_dir)

  let profiles_dir = const_download_dir() |> filepath.join("profile_packages")
  let custom_profile =
    list.find(args_cased, fn(arg) { string.starts_with(arg, "custom=") })
  let profiles_dir = case custom_profile {
    Error(_) -> None
    Ok(custom_profile) -> {
      let assert [_, simplifier_profile] = string.split(custom_profile, "=")
      let assert [pkg_name, pkg_version] = string.split(simplifier_profile, "/")
        as "need name and version separated by slash, eg hl7.fhir.us.core/9.0.0"
      case download_files {
        False -> Nil
        True -> {
          let packages =
            codegen_profile_package_download_no_npm.download_package_with_dependencies(
              pkg_name,
              pkg_version,
              profiles_dir,
            )
          let count = packages |> set.size |> int.to_string
          io.println("Resolved " <> count <> " packages into " <> profiles_dir)
        }
      }
      profiles_dir
      |> filepath.join(pkg_name)
      |> filepath.join(pkg_version)
      |> filepath.join("package")
      |> Some
    }
  }

  list.map(check_versions, fn(fhir_version) {
    let custom_profile_name = case
      list.find(args_cased, fn(arg) { string.starts_with(arg, "customname=") })
    {
      Ok(arg) -> {
        let assert [_, name] = string.split(arg, "=")
        Some(name)
      }
      Error(_) ->
        case custom_profile {
          Ok(_) ->
            panic as "if custom=[name/version] also need arg customname=[pkg name] for generated modules prefix"
          Error(_) -> None
        }
    }

    let _ = case list.contains(args_lower, fhir_version) {
      True ->
        gen_fhir(
          fhir_version,
          download_files,
          custom_profile_name,
          profiles_dir,
          all_primitive_ext,
        )
      False -> Nil
    }
  })
}

@target(erlang)
fn gen_fhir(
  fhir_version: String,
  download_files: Bool,
  custom_profile_name: Option(String),
  profiles_dir: Option(String),
  all_primitive_ext: Bool,
) -> Nil {
  let extract_dir_ver = const_download_dir() |> filepath.join(fhir_version)

  let _ = case download_files {
    True -> {
      let _ =
        codegen_profile_package_download_no_npm.download_package_with_dependencies(
          "hl7.fhir." <> fhir_version <> ".core",
          simplifier_core_package_version(fhir_version),
          const_download_dir() |> filepath.join("profile_packages"),
        )
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

  let pkg_prefix = case custom_profile_name {
    Some(name) -> name
    None -> fhir_version
  }
  let gen_dir = filepath.join(gen_into_dir, pkg_prefix)
  let assert Ok(_) = simplifile.create_directory_all(gen_dir)
  let f_primitive_types = filepath.join(gen_dir, "primitive_types.gleam")
  let assert Ok(primitive_types) =
    simplifile.read(filepath.join("dev", "primitive_types.txt"))
  let assert Ok(_) =
    simplifile.write(to: f_primitive_types, contents: primitive_types)
  io.println("generated " <> f_primitive_types)
  let gen_gleamfile = filepath.join(gen_dir, "resources.gleam")
  let gen_vsfile = filepath.join(gen_dir, "valuesets.gleam")
  let shared_imports = "import gleam/json.{type Json}
      import gleam/dynamic/decode.{type Decoder}
      import gleam/option.{type Option, None, Some}
      import gleam/list
      import fhir/" <> pkg_prefix <> "/primitive_types.{type Date, type DateTime, type Instant, type Time} as pt
      import fhir/" <> pkg_prefix <> "/valuesets\n"
  let r_imports = shared_imports <> "import gleam/bool\n"

  let #(complex_types_gen, valueset_acc) =
    file_to_types(
      spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
      fv: pkg_prefix,
      all_primitive_ext: all_primitive_ext,
      current_bucket: codegen_helpers.ComplexTypes,
      valueset_acc: set.new(),
    )
  let #(resources_gen, valueset_acc) =
    file_to_types(
      spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
      fv: pkg_prefix,
      all_primitive_ext: all_primitive_ext,
      current_bucket: codegen_helpers.Resources,
      valueset_acc:,
    )
  let #(profile_complex_types, profile_resources, valueset_acc) = case
    custom_profile_name
  {
    None -> #("", "", valueset_acc)
    Some(_) ->
      codegen_profile.profile_files_to_types(
        profiles_dir,
        all_primitive_ext,
        valueset_acc,
      )
  }
  let complex_types_gen = complex_types_gen <> profile_complex_types
  let resources_gen = resources_gen <> profile_resources
  let ct_imports = shared_imports <> "import gleam/int\n"

  let list_type_defs =
    "
      /// 1..*
      pub type List1(a){ List1(first: a, rest: List(a)) }

      /// 2..*
      pub type List2(a){ List2(first: a, second: a, rest: List(a)) }

      /// 3..*
      pub type List3(a){ List3(first: a, second: a, third: a, rest: List(a)) }

      pub type BoundCoding(required_binding) {
        BoundCoding(
          id: Option(String),
          extension: List(Extension),
          code: required_binding,
          version: Option(String),
          display: Option(String),
          user_selected: Option(Bool),
        )
      }

      pub type BoundCodeableconcept(required_binding) {
        BoundCodeableconcept(
          id: Option(String),
          extension: List(Extension),
          required: BoundCoding(required_binding),
          more: List(Coding),
          text: Option(String),
        )
      }
      "

  let helpers_block =
    "
      //std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
      pub fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
        decode.one_of(d |> decode.map(Some), [decode.success(None)])
      }

      //std lib decode.float will NOT decode numbers without decimal point eg 4, only 4.0
      pub fn decode_number() {
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

      pub type Primitive(a) {
        Primitive(id: Option(String), ext: List(Extension), value: Option(a))
      }

      pub type PrimitiveExtPart {
        PrimitiveExtPart(id: Option(String), ext: List(Extension))
      }

      pub fn primitive_ext_part_to_json(p: Primitive(_)) {
        let Primitive(id, ext, _) = p
        let fields = []
        let fields = case id {
          Some(v) -> [#(\"id\", json.string(v)), ..fields]
          None -> fields
        }
        let fields = case ext {
          [] -> fields
          _ -> [#(\"extension\", json.array(ext, extension_to_json)), ..fields]
        }
        json.object(fields)
      }

      pub fn primitive_to_json(old_fields: List(#(String, Json)), primitive: Primitive(a), field_to_json: fn(a) -> Json, name: String){
        let old_fields = case primitive.id, primitive.ext {
            None, [] -> old_fields
            _, _ -> [#(\"_\" <> name, primitive_ext_part_to_json(primitive)), ..old_fields]
        }
        case primitive.value {
            None -> old_fields
            Some(v) -> [#(name, field_to_json(v)), ..old_fields]
        }
      }

      pub fn primitives_to_json(old_fields: List(#(String, Json)), field: List(Primitive(a)), field_to_json: fn(a) -> Json, name: String){
          let vals = list.map(field, fn(primitive){
              json.nullable(primitive.value, field_to_json)
          })
          let exts = list.map(field, fn(primitive){
              case primitive.id, primitive.ext {
                  None, [] -> json.null()
                  _, _ -> primitive_ext_part_to_json(primitive)
              }
          })
          let old_fields = case list.any(vals, fn(j){j != json.null()}){
              False -> old_fields
              True -> [#(name, json.preprocessed_array(vals)), ..old_fields]
          }
          case list.any(exts, fn(j){j != json.null()}){
              False -> old_fields
              True -> [#(\"_\" <> name, json.preprocessed_array(exts)), ..old_fields]
          }
      }

      pub fn primitive_ext_part_decoder() {
        use ext <- decode.optional_field(
          \"extension\",
          [],
          decode.list(extension_decoder()),
        )
        use id <- decode.optional_field(\"id\", None, decode.optional(decode.string))
        decode.success(PrimitiveExtPart(ext:, id:))
      }

      pub fn primitive_decoder(name: String, thing_decoder: Decoder(a), next: fn(Primitive(a)) -> Decoder(b)) -> Decoder(b){
          use value <- decode.optional_field(name, None, decode.optional(thing_decoder))
          use pwe <- decode.optional_field(\"_\" <> name, None, decode.optional(primitive_ext_part_decoder()))
          let #(id, ext) = case pwe {
            None -> #(None, [])
            Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
          }
          let together = Primitive(id:, ext:, value:,)
          next(together)
      }

      pub fn primitives_decoder(
        name: String,
        thing_decoder: Decoder(a),
        next: fn(List(Primitive(a))) -> Decoder(b),
      ) -> Decoder(b) {
          use values <- decode.optional_field(name, [], decode.list(decode.optional(thing_decoder)))
          use pwes <- decode.optional_field(\"_\" <> name, [], decode.list(decode.optional(primitive_ext_part_decoder())))
          let together = map2_fillnone(pwes, values, fn(pwe, value){
              let #(id, ext) = case pwe {
                  None -> #(None, [])
                  Some(PrimitiveExtPart(id, ext)) -> #(id, ext)
              }
              Primitive(id:, ext:, value:,)
          })
          next(together)
      }

      pub fn map2_fillnone(list1: List(Option(a)), list2: List(Option(b)), with fun: fn(Option(a), Option(b)) -> c) -> List(c) {
        map2_fillnone_loop(list1, list2, fun, [])
      }

      fn map2_fillnone_loop(
        list1: List(Option(a)),
        list2: List(Option(b)),
        fun: fn(Option(a), Option(b)) -> c,
        acc: List(c),
      ) -> List(c) {
        case list1, list2 {
          [], [] -> list.reverse(acc)
          [a, ..as_], [] -> map2_fillnone_loop(as_, [], fun, [fun(a, None), ..acc])
          [], [b, ..bs] -> map2_fillnone_loop([], bs, fun, [fun(None, b), ..acc])
          [a, ..as_], [b, ..bs] -> map2_fillnone_loop(as_, bs, fun, [fun(a, b), ..acc])
        }
      }


      "

  let ct_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") complex types\n",
      ct_imports,
      list_type_defs,
      complex_types_gen,
      helpers_block,
    ])
  let primitive_imports = case string.contains(resources_gen, "Primitive(") {
    False -> ""
    True ->
      ", type Primitive, Primitive, primitive_decoder, primitives_decoder, primitive_to_json, primitives_to_json"
  }
  let r_ct_import =
    "import fhir/"
    <> pkg_prefix
    <> "/complex_types.{type List1, list1_to_json, list1_decoder, none_if_omitted, decode_number"
    <> primitive_imports
    <> "} as ct\n"
  let r_content =
    string.concat([
      "////[https://hl7.org/fhir/",
      fhir_version,
      "](https://hl7.org/fhir/",
      fhir_version,
      ") resources\n",
      r_imports,
      r_ct_import,
      resources_gen,
    ])
  let f_complex_types = filepath.join(gen_dir, "complex_types.gleam")
  let assert Ok(_) = simplifile.write(to: f_complex_types, contents: ct_content)
  io.println("generated " <> f_complex_types)
  let assert Ok(_) = simplifile.write(to: gen_gleamfile, contents: r_content)
  io.println("generated " <> gen_gleamfile)

  let all_vs = valueset_to_types(fhir_version, valueset_acc, profiles_dir)
  let assert Ok(_) = simplifile.write(to: gen_vsfile, contents: all_vs)
  io.println("generated " <> gen_vsfile)

  let #(sansio, httpc_layer, rsvp_layer, search_params) =
    codegen_client.gen(
      filepath.join(extract_dir_ver, "profiles-resources.json"),
      fhir_version,
      pkg_prefix,
      None,
      all_primitive_ext,
      "",
    )
  list.each(
    [
      #("sansio.gleam", sansio),
      #("client_httpc.gleam", httpc_layer),
      #("client_rsvp.gleam", rsvp_layer),
      #("search_params.gleam", search_params),
    ],
    fn(to_file) {
      let file = filepath.join(gen_dir, to_file.0)
      let assert Ok(_) = simplifile.write(to: file, contents: to_file.1)
      io.println("generated " <> to_file.0)
    },
  )
}

fn file_to_types(
  spec_file spec_file: String,
  fv fhir_version: String,
  all_primitive_ext all_primitive_ext: Bool,
  current_bucket current_bucket: codegen_helpers.Category,
  valueset_acc valueset_acc: Set(String),
) -> #(String, Set(String)) {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in dev/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(bundle) =
    json.parse(from: spec, using: codegen_helpers.bundle_decoder())
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

  let entries = list.map(entries, fn(entry) { entry.resource })

  let #(all_resources_and_types, valueset_acc) =
    list.fold(
      entries,
      #("", valueset_acc),
      fn(acc, resource: codegen_helpers.Resource) {
        let #(elt_str_acc, valueset_acc) = acc
        //map of type -> fields needed to list out all the BackboneElements
        //because they're subcomponents eg Allergy -> Reaction
        //and rather than nested, we want to write fields one after the other
        let starting_res_fields = dict.new() |> dict.insert(resource.name, [])
        //we want to write types in order of parsing backbone elements, but map order random
        //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
        let type_order = [resource.name]
        let assert Some(snapshot) = resource.snapshot

        let f_o = #(starting_res_fields, type_order)

        let #(resource_types, valueset_acc) = {
          let fields_and_order =
            list.fold(over: snapshot.element, from: f_o, with: fn(f_o, elt) {
              let res_fields = f_o.0
              let order = f_o.1

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

          list.fold(
            over: type_order,
            from: #("", valueset_acc),
            with: fn(acc, new_type) {
              let #(old_type_acc, valueset_acc) = acc
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
                True ->
                  resource.id
                  |> string.replace("-", "_")
                  |> codegen_helpers.to_camel_case
                False -> new_type |> codegen_helpers.to_camel_case
              }
              //conflict gleam list
              let camel_type = case camel_type == "List" {
                True -> "Listfhir"
                False -> camel_type
              }
              let snake_type = codegen_helpers.to_snake_case(camel_type)
              let assert Ok(fields) = dict.get(type_fields, new_type)
              let fields = case resource.name {
                "SimpleQuantity" ->
                  list.filter(fields, fn(x) { x.path != "Quantity.comparator" })
                //simplequantity has no comparator
                _ -> fields
              }
              let fields =
                fields
                |> list.filter(fn(elt) { elt.max != "0" })
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
                valueset_acc,
              ) =
                list.fold(
                  from: #(
                    "",
                    list.new(),
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    valueset_acc,
                  ),
                  over: fields,
                  with: fn(acc, elt: codegen_helpers.Element) {
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
                    let valueset_acc = acc.10
                    //yeah this should be custom type right
                    let allparts =
                      elt.id
                      |> string.replace("-", "")
                      |> string.replace(":", ".")
                      |> string.split(".")
                    let assert [_, ..rest_allparts] = allparts
                    let allparts = [resource.name, ..rest_allparts]
                    let assert Ok(elt_last_part) = allparts |> list.last
                    //for choice types, which will have a custom type
                    let elt_last_part_withgleamtype =
                      string.replace(elt_last_part, "[x]", "")
                    // withgleamtype still hasnt escaped the gleam types (use, case, etc) but it's expected in json fields
                    // so "\"" <> elt_last_part_withgleamtype <> "\"" should always be actual string for json
                    let elt_last_part =
                      codegen_helpers.escape_field_name(
                        elt_last_part_withgleamtype,
                      )
                    let field_name_new =
                      camel_type <> string.capitalise(elt_last_part)
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
                          | "http://hl7.org/fhirpath/System.String" ->
                            elt_last_part_withgleamtype != "id"
                            && all_primitive_ext
                          _ -> False
                        }
                      _ -> False
                    }
                    let #(field_type, valueset_acc) = case elt.type_ {
                      [one_type] -> {
                        let #(base_type, valueset_acc) =
                          codegen_helpers.string_to_type(
                            one_type.code,
                            allparts,
                            elt,
                            current_bucket,
                            valueset_acc,
                          )
                        let field_type = case is_primitive {
                          True -> "Primitive(" <> base_type <> ")"
                          False -> base_type
                        }
                        #(field_type, valueset_acc)
                      }
                      [] -> #(
                        {
                          codegen_helpers.link_type_from(
                            elt.content_reference,
                            resource.name,
                          )
                          |> codegen_helpers.to_camel_case
                        },
                        valueset_acc,
                      )
                      _ -> #(field_name_new, valueset_acc)
                    }
                    let elt_snake = codegen_helpers.to_snake_case(elt_last_part)
                    let card_min = case is_primitive, elt.max {
                      True, "*" -> 0
                      True, _ -> 1
                      False, _ -> elt.min
                    }
                    let this_type_fields =
                      string.concat([
                        elt_snake,
                        ": ",
                        codegen_helpers.cardinality(
                          field_type,
                          card_min,
                          elt.max,
                        ),
                        ",\n",
                        fields_acc,
                      ])
                    let #(choicetypes_acc, valueset_acc) = case elt.type_ {
                      [] -> #(choicetypes_acc, valueset_acc)
                      [_] -> #(choicetypes_acc, valueset_acc)
                      _ -> {
                        let #(choice_fields, valueset_acc) =
                          list.fold(
                            over: elt.type_,
                            from: #("", valueset_acc),
                            with: fn(acc, typ) {
                              let #(fields_acc, valueset_acc) = acc
                              let #(choice_type, valueset_acc) =
                                codegen_helpers.string_to_type(
                                  typ.code,
                                  [
                                    "somehow this is used in [x] for any type (int, bool, code, etc) and ofc that code has no defined binding",
                                  ],
                                  elt,
                                  current_bucket,
                                  valueset_acc,
                                )
                              #(
                                string.concat([
                                  fields_acc,
                                  //add all fields of this choice type
                                  "\n",
                                  field_name_new,
                                  string.capitalise(typ.code),
                                  "(",
                                  elt_snake,
                                  ": ",
                                  choice_type,
                                  ")",
                                ]),
                                valueset_acc,
                              )
                            },
                          )
                        #(
                          [
                            string.concat([
                              "\n",
                              new_doc_link,
                              "\npub type ",
                              field_name_new,
                              "{",
                              choice_fields,
                              "}",
                              //each choice type needs its own to_json and decoder
                              "\npub fn ",
                              snake_type,
                              "_",
                              elt_last_part |> string.lowercase(),
                              "_to_json(elt: ",
                              field_name_new,
                              ") -> Json {case elt{",
                              list.fold(
                                over: elt.type_,
                                from: "",
                                with: fn(acc, typ) {
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
                                      current_bucket,
                                    ),
                                    "(v)\n",
                                  ])
                                },
                              ),
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
                                    field_name_new
                                      <> string.capitalise(fst_type_.code),
                                    elt_last_part_withgleamtype,
                                    current_bucket,
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
                                          field_name_new
                                            <> string.capitalise(typ.code),
                                          elt_last_part_withgleamtype,
                                          current_bucket,
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
                          ],
                          valueset_acc,
                        )
                      }
                    }
                    let #(newfunc_arg, newfunc_field) = case elt.min, elt.max {
                      0, "*" -> #("", elt_snake <> ": [],")
                      1, "*" ->
                        case is_primitive {
                          True -> #("", elt_snake <> ": [],")
                          False -> {
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
                      0, _ -> #(
                        "",
                        elt_snake
                          <> ": "
                          <> case is_primitive {
                          True -> "Primitive(id: None, ext: [], value: None)"
                          False -> "None"
                        }
                          <> ",",
                      )
                      1, _ ->
                        case is_primitive {
                          True -> #(
                            "",
                            elt_snake
                              <> ": Primitive(id: None, ext: [], value: None),",
                          )
                          False -> {
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
                          current_bucket,
                        )
                      [] -> {
                        codegen_helpers.link_type_from(
                          elt.content_reference,
                          resource.name,
                        )
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
                    let #(
                      encoder_optional_acc,
                      encoder_always_acc,
                      decoder_always_failure_acc,
                    ) = case elt.min, elt.max {
                      0, "*" ->
                        case is_primitive {
                          True -> {
                            let opts =
                              encoder_optional_acc
                              <> "\nlet fields = primitives_to_json(fields, "
                              <> elt_snake
                              <> ", "
                              <> field_type_encoder
                              <> ", \""
                              <> elt_last_part_withgleamtype
                              <> "\")"
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                          False -> {
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
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                        }
                      1, "*" ->
                        case is_primitive {
                          True -> {
                            let opts =
                              encoder_optional_acc
                              <> "\nlet fields = primitives_to_json(fields, "
                              <> elt_snake
                              <> ", "
                              <> field_type_encoder
                              <> ", \""
                              <> elt_last_part_withgleamtype
                              <> "\")"
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                          False -> {
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
                            #(
                              encoder_optional_acc,
                              always,
                              decoder_always_failure,
                            )
                          }
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
                      0, "1" ->
                        case is_primitive {
                          True -> {
                            let opts =
                              encoder_optional_acc
                              <> "\nlet fields = primitive_to_json(fields, "
                              <> elt_snake
                              <> ", "
                              <> field_type_encoder
                              <> ", \""
                              <> elt_last_part_withgleamtype
                              <> "\")"
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                          False -> {
                            //optional case to json, in Some case add to fields list
                            let choicetype_suffixes =
                              gen_choicetype_suffixes(
                                "v",
                                elt.type_,
                                field_name_new,
                              )
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
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                        }
                      1, "1" ->
                        case is_primitive {
                          True -> {
                            let opts =
                              encoder_optional_acc
                              <> "\nlet fields = primitive_to_json(fields, "
                              <> elt_snake
                              <> ", "
                              <> field_type_encoder
                              <> ", \""
                              <> elt_last_part_withgleamtype
                              <> "\")"
                            #(
                              opts,
                              encoder_always_acc,
                              decoder_always_failure_acc,
                            )
                          }
                          False -> {
                            //mandatory case to json, put in first fields list
                            let choicetype_suffixes =
                              gen_choicetype_suffixes(
                                elt_snake,
                                elt.type_,
                                field_name_new,
                              )
                            let always =
                              encoder_always_acc
                              <> "#(\""
                              <> elt_last_part_withgleamtype
                              <> "\""
                              <> choicetype_suffixes
                              <> ", "
                              <> field_type_encoder
                              <> "("
                              <> elt_snake
                              <> ")"
                              <> "),"
                            let decoder_always_failure =
                              decoder_always_failure_acc <> elt_snake <> ":, "
                            #(
                              encoder_optional_acc,
                              always,
                              decoder_always_failure,
                            )
                          }
                        }
                      _, _ -> panic as "cardinality panic 72"
                    }
                    let field_type_decoder = case elt.type_ {
                      [_] | [] -> {
                        let decoder_itself = case elt.type_ {
                          [one_type] ->
                            string_to_decoder_type(
                              one_type.code,
                              allparts,
                              fhir_version,
                              elt,
                              current_bucket,
                            )
                          [] ->
                            codegen_helpers.link_type_from(
                              elt.content_reference,
                              resource.name,
                            )
                            <> "_decoder()"
                          _ -> panic as "compiler should see this cant happen"
                        }
                        case elt.max {
                          "*" ->
                            case elt.min {
                              0 ->
                                case is_primitive {
                                  True ->
                                    "primitives_decoder(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\","
                                    <> decoder_itself
                                    <> ")"
                                  False ->
                                    "decode.optional_field(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\", [], decode.list("
                                    <> decoder_itself
                                    <> "))"
                                }
                              1 ->
                                case is_primitive {
                                  True ->
                                    "primitives_decoder(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\","
                                    <> decoder_itself
                                    <> ")"
                                  False ->
                                    "list1_decoder(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\","
                                    <> decoder_itself
                                    <> ")"
                                }
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
                              0 ->
                                case is_primitive {
                                  True ->
                                    "primitive_decoder(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\","
                                    <> decoder_itself
                                    <> ")"
                                  False ->
                                    "decode.optional_field(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\", None, decode.optional("
                                    <> decoder_itself
                                    <> "))"
                                }
                              1 ->
                                case is_primitive {
                                  True ->
                                    "primitive_decoder(\""
                                    <> elt_last_part_withgleamtype
                                    <> "\","
                                    <> decoder_itself
                                    <> ")"
                                  False ->
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

                    let decoder_use_acc =
                      string.concat([
                        decoder_use_acc,
                        "use ",
                        elt_snake,
                        " <- ",
                        field_type_decoder,
                        "\n",
                      ])
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
                      valueset_acc,
                    )
                  },
                )
              //now have #(field_list, choicetypes, newfunc_args, newfunc_fields) tuple should prolly be custom type or something
              // first elt in tuple is all the fields for this type

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
              let assert Some(fhir_resource_type) = resource.type_

              case camel_type {
                "Extension" -> {
                  let assert [elt, ..] = fields
                  let #(extension_value_types, valueset_acc) =
                    list.fold(
                      over: elt.type_,
                      from: #("", valueset_acc),
                      with: fn(acc, typ: codegen_helpers.Type) {
                        let #(types_acc, valueset_acc) = acc
                        let #(type_, valueset_acc) =
                          codegen_helpers.string_to_type(
                            typ.code,
                            [],
                            elt,
                            codegen_helpers.ComplexTypes,
                            valueset_acc,
                          )
                        #(
                          string.concat([
                            types_acc,
                            "ExtensionValue",
                            string.capitalise(typ.code),
                            "(value: ",
                            type_,
                            ")",
                            "\n",
                          ]),
                          valueset_acc,
                        )
                      },
                    )
                  #("
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
                " <> extension_value_types <> "
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
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      string.concat([
                        acc,
                        "ExtensionValue",
                        string.capitalise(typ.code),
                        "(_) -> \"",
                        {
                          let assert [fst, ..rest] =
                            string.to_graphemes(typ.code)
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
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      string.concat([
                        acc,
                        "ExtensionValue",
                        string.capitalise(typ.code),
                        "(v) -> ",
                        string_to_encoder_type(
                          typ.code,
                          [],
                          "",
                          elt,
                          codegen_helpers.ComplexTypes,
                        ),
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
                    with: fn(acc: String, typ: codegen_helpers.Type) -> String {
                      let assert [fst, ..rest] = string.to_graphemes(typ.code)
                      let first_upper =
                        string.uppercase(fst) <> string.concat(rest)
                      string.concat([
                        acc,
                        "decode.field(\"value"
                          <> first_upper
                          <> "\", "
                          <> string_to_decoder_type(
                          typ.code,
                          [],
                          "",
                          elt,
                          codegen_helpers.ComplexTypes,
                        )
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
              ", valueset_acc)
                }
                _ -> {
                  let decoder =
                    gen_res_decoder(
                      fhir_resource_type,
                      camel_type,
                      snake_type,
                      decoder_use,
                      decoder_success,
                      is_domainresource,
                      decoder_always_failure_fordr,
                    )
                  #(
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
                          encoder_json_options,
                          is_domainresource,
                        ),
                        decoder,
                        add_forgiving_type_and_decoder_if_bundle_or_bundleentry(
                          camel_type,
                          type_newfields,
                          decoder,
                          decoder_success,
                        ),
                      ],
                      "\n",
                    ),
                    valueset_acc,
                  )
                }
              }
            },
          )
        }
        let gen_str = elt_str_acc <> "\n" <> resource_types
        #(gen_str, valueset_acc)
      },
    )
  #(
    case spec_file |> string.ends_with("profiles-resources.json") {
      False -> all_resources_and_types
      True -> {
        let res_entries =
          entries
          |> list.filter(fn(resource) {
            resource.kind == Some("resource")
            && resource.name != "DomainResource"
          })
          |> list.map(fn(resource) {
            let camel_type =
              resource.id
              |> string.replace("-", "_")
              |> codegen_helpers.to_camel_case
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
            <> codegen_helpers.to_snake_case(camel_type)
            <> "_to_json(r)\n"
          })
          |> string.concat

        let resource_decoders =
          res_entries
          |> list.map(fn(entry_and_camel_type) {
            let camel_type = entry_and_camel_type.1
            let resource: codegen_helpers.Resource = entry_and_camel_type.0
            let assert Some(fhir_resource_type) = resource.type_
            "\""
            <> fhir_resource_type
            <> "\" -> "
            <> codegen_helpers.to_snake_case(camel_type)
            <> "_decoder()  |> decode.map(Resource"
            <> camel_type
            <> ")\n"
          })
          |> string.concat

        let resource_type_variants =
          res_entries
          |> list.map(fn(entry_and_camel_type) {
            "Rt" <> entry_and_camel_type.1 <> "\n"
          })
          |> string.concat

        let resource_type_to_string_arms =
          res_entries
          |> list.map(fn(entry_and_camel_type) {
            let resource: codegen_helpers.Resource = entry_and_camel_type.0
            let assert Some(fhir_resource_type) = resource.type_
            "Rt"
            <> entry_and_camel_type.1
            <> " -> \""
            <> fhir_resource_type
            <> "\"\n"
          })
          |> string.concat

        let resource_type_enum =
          string.concat([
            "pub type ResourceType{",
            resource_type_variants,
            "}\npub fn resource_type_to_string(rt: ResourceType) -> String {
            case rt {",
            resource_type_to_string_arms,
            "}
        }\n",
          ])

        let resource_enum =
          string.concat([
            resource_type_enum,
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
            _ ->
              decode.failure(
                ResourceEnrollmentrequest(enrollmentrequest_new()),
                expected: \"\",
              )
              |> decode.map_errors(fn(_errs) {
                [decode.DecodeError(
                  expected: \"one of Account, ActivityDefinition, AdverseEvent, AllergyIntolerance... or any resource name\",
                  found: tag,
                  path: [\"resourceType\"],
                )]
              })
          } |> decode.map_errors(fn(errs){
            list.map(errs, fn(err){
              decode.DecodeError(..err, path: [\"(\" <> tag <> \")\", ..err.path])
            })
          })
        }
        ",
          ])
        all_resources_and_types <> resource_enum
      }
    },
    valueset_acc,
  )
}

// this makes the decode.string or decode.int or allergy_intolerance_reaction_decoder() or whatever
// could maybe be combined with very similar previous func
fn string_to_decoder_type(
  fhir_type: String,
  allparts: List(String),
  _fhir_version: String,
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_decoder()"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
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
                          "valuesets."
                          <> url
                          |> codegen_helpers.concept_name_from_url()
                          |> codegen_helpers.to_snake_case
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
    "date" -> "pt.date_decoder()"
    "dateTime" -> "pt.datetime_decoder()"
    "decimal" -> "decode_number()"
    "id" -> "decode.string"
    "instant" -> "pt.instant_decoder()"
    "integer" -> "decode.int"
    "integer64" -> "decode.string"
    "markdown" -> "decode.string"
    "oid" -> "decode.string"
    "positiveInt" -> "decode.int"
    "string" -> "decode.string"
    "time" -> "pt.time_decoder()"
    "unsignedInt" -> "decode.int"
    "uri" -> "decode.string"
    "url" -> "decode.string"
    "uuid" -> "decode.string"
    "xhtml" -> "decode.string"
    "http://hl7.org/fhirpath/System.String" -> "decode.string"
    _ -> {
      let camel = codegen_helpers.to_camel_case(fhir_type)
      codegen_helpers.bucket_prefix(camel, current)
      <> { fhir_type |> string.lowercase() }
      <> "_decoder()"
    }
    //decoder for backbone element eg visionprescription_lensspecification_decoder()
  }
}

fn string_to_encoder_type(
  fhir_type: String,
  allparts: List(String),
  _fhir_version: String,
  elt: codegen_helpers.Element,
  current: codegen_helpers.Category,
) -> String {
  case fhir_type {
    "BackboneElement" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
      <> "_to_json"
    "Element" ->
      allparts
      |> list.map(string.capitalise)
      |> string.concat()
      |> codegen_helpers.to_snake_case()
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
                          "valuesets."
                          <> url
                          |> codegen_helpers.concept_name_from_url()
                          |> codegen_helpers.to_snake_case
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
    "date" -> "pt.date_to_json"
    "dateTime" -> "pt.datetime_to_json"
    "decimal" -> "json.float"
    "id" -> "json.string"
    "instant" -> "pt.instant_to_json"
    "integer" -> "json.int"
    "integer64" -> "json.string"
    "markdown" -> "json.string"
    "oid" -> "json.string"
    "positiveInt" -> "json.int"
    "string" -> "json.string"
    "time" -> "pt.time_to_json"
    "unsignedInt" -> "json.int"
    "uri" -> "json.string"
    "url" -> "json.string"
    "uuid" -> "json.string"
    "xhtml" -> "json.string"
    "http://hl7.org/fhirpath/System.String" -> "json.string"
    _ -> {
      let camel = codegen_helpers.to_camel_case(fhir_type)
      codegen_helpers.bucket_prefix(camel, current)
      <> { fhir_type |> string.lowercase() }
      <> "_to_json"
    }
    //encoder for backbone element eg visionprescription_lensspecification_encoder()
  }
}

fn gen_choicetype_suffixes(
  match_var: String,
  types: List(codegen_helpers.Type),
  field_name_new: String,
) -> String {
  case types {
    // choice type encoder requires onsetAge onsetString onsetPeriod whatever to be suffix in json
    [_, _, ..] ->
      string.concat([
        " <> case ",
        match_var,
        " {",
        list.fold(from: "", over: types, with: fn(suffixes_acc, ct) {
          let assert [first_letter, ..rest] = ct.code |> string.to_graphemes
          // unlike string.capitalise this doesnt make everything after first lowercase
          // so createdDateTime doesnt become createdDatetime
          let capital_ct =
            string.concat([string.uppercase(first_letter), ..rest])
          suffixes_acc
          <> field_name_new
          <> string.capitalise(ct.code)
          <> "(_) -> \""
          <> capital_ct
          <> "\"\n"
        }),
        "}",
      ])
    //normal type encoder (not choice type)
    _ -> ""
  }
}

fn gen_choice_field_decoder(
  type_code,
  allparts,
  fhir_version,
  elt,
  choice_option_caps,
  choicetype_last_part,
  current: codegen_helpers.Category,
) -> String {
  let assert [fst, ..rest] = type_code |> string.to_graphemes
  let choicetype_parse_label =
    choicetype_last_part <> string.uppercase(fst) <> string.concat(rest)
  let type_decoder =
    string_to_decoder_type(type_code, allparts, fhir_version, elt, current)
  "decode.field(\""
  <> choicetype_parse_label
  <> "\", "
  <> type_decoder
  <> ", decode.success) |> decode.map("
  <> choice_option_caps
  <> "),"
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

fn add_forgiving_type_and_decoder_if_bundle_or_bundleentry(
  camel_type: String,
  type_newfields: String,
  normal_decoder: String,
  decoder_success: String,
) -> String {
  case camel_type {
    "Bundle" -> {
      let typ =
        type_newfields
        |> string.replace("pub type Bundle {", "pub type BundleForgiving {")
        |> string.replace("pub type Bundle\n{", "pub type BundleForgiving\n{")
        |> string.replace("Bundle(", "BundleForgiving(")
        |> string.replace(
          "entry: List(BundleEntry),",
          "entry: List(BundleEntryForgiving),",
        )

      let decoder_success = decoder_success <> "), \"resourceType\")"
      let decoder =
        normal_decoder
        |> string.replace(
          "pub fn bundle_decoder() -> Decoder(Bundle)",
          "pub fn bundle_decoder_forgiving() -> Decoder(BundleForgiving)",
        )
        |> string.replace(
          "decode.list(bundle_entry_decoder())",
          "decode.list(bundle_entry_decoder_forgiving())",
        )
        |> string.replace(
          "decode.success(Bundle(",
          "decode.success(BundleForgiving(",
        )
        |> string.replace(
          "decode.failure(bundle_new(type_:, ), \"resourceType\")",
          "decode.failure(BundleForgiving(" <> decoder_success,
        )
        |> string.replace(
          "decode.failure(bundle_new(), \"resourceType\")",
          "decode.failure(BundleForgiving(" <> decoder_success,
        )

      typ <> "\n" <> decoder
    }
    "BundleEntry" -> {
      let typ =
        type_newfields
        |> string.replace(
          "pub type BundleEntry {",
          "pub type BundleEntryForgiving {",
        )
        |> string.replace(
          "pub type BundleEntry\n{",
          "pub type BundleEntryForgiving\n{",
        )
        |> string.replace("BundleEntry(", "BundleEntryForgiving(")
        |> string.replace(
          "resource: Option(Resource),",
          "resource: Option(Result(Resource, List(decode.DecodeError))),",
        )

      let forgiving_resource_decoder =
        "decode.optional(
      decode.one_of(resource_decoder() |> decode.map(Ok), [
        decode.dynamic
        |> decode.map(fn(res_json) {
          decode.run(res_json, resource_decoder())
        }),
      ]),
    )"

      let decoder =
        normal_decoder
        |> string.replace(
          "pub fn bundle_entry_decoder() -> Decoder(BundleEntry)",
          "pub fn bundle_entry_decoder_forgiving() -> Decoder(BundleEntryForgiving)",
        )
        |> string.replace(
          "decode.optional(resource_decoder())",
          forgiving_resource_decoder,
        )
        |> string.replace(
          "decode.success(BundleEntry(",
          "decode.success(BundleEntryForgiving(",
        )

      typ <> "\n" <> decoder
    }
    _ -> ""
  }
}

// region valuesets
// note we already have a list of required bindings from resources, now need to fill codes in for those

type ValuesetIncludeCodes {
  ValuesetIncludeExpanded(List(String))
  ValuesetIncludeString
}

fn valueset_include_codes(
  include: r4.ValuesetComposeInclude,
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
  exclude_not_selectable: Bool,
) {
  case include.concept, include.filter, include.system {
    [_, ..] as concepts, _, _ ->
      ValuesetIncludeExpanded(list.map(concepts, fn(concept) { concept.code }))
    [], [_first_filter, ..], _ -> ValuesetIncludeString
    [], [], Some(system) ->
      case dict.get(all_vs_or_cs, system) {
        Error(_) -> ValuesetIncludeString
        Ok(_) ->
          case
            codegen_helpers.get_codes(
              system,
              all_vs_or_cs,
              exclude_not_selectable,
            )
          {
            [] -> ValuesetIncludeString
            codes -> ValuesetIncludeExpanded(codes)
          }
      }
    [], [], None -> ValuesetIncludeString
  }
}

fn valueset_include_name(include: r4.ValuesetComposeInclude, index: Int) {
  case include.system, include.value_set {
    Some(system), _ -> codegen_helpers.concept_name_from_url(system)
    None, [value_set, ..] -> codegen_helpers.concept_name_from_url(value_set)
    None, [] -> "Include" <> int.to_string(index)
  }
}

fn valueset_type_source(
  vs_url: String,
  vsname: String,
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
  exclude_not_selectable: Bool,
) {
  case dict.get(all_vs_or_cs, vs_url) {
    Ok(codegen_helpers.VocValueset(valueset)) ->
      case valueset.compose {
        Some(compose) ->
          valueset_compose_type_source(
            compose,
            vsname,
            all_vs_or_cs,
            exclude_not_selectable,
          )
        None -> open_valueset_type_source(vsname)
      }
    _ -> open_valueset_type_source(vsname)
  }
}

fn open_valueset_type_source(vsname: String) {
  "pub type " <> vsname <> "{" <> vsname <> "(value: String)}\n"
}

fn valueset_compose_type_source(
  compose: r4.ValuesetCompose,
  vsname: String,
  all_vs_or_cs: dict.Dict(String, codegen_helpers.VsOrCs),
  exclude_not_selectable: Bool,
) {
  let includes = [compose.include.first, ..compose.include.rest]
  let #(variants, codes, all_expanded, _) =
    list.fold(includes, #("", [], True, 1), fn(acc, include) {
      let #(variants, codes, all_expanded, index) = acc
      case
        valueset_include_codes(include, all_vs_or_cs, exclude_not_selectable)
      {
        ValuesetIncludeExpanded(include_codes) -> #(
          variants
            <> {
            include_codes
            |> list.map(fn(code) {
              vsname <> string.capitalise(codetovarname(code)) <> "\n"
            })
            |> string.concat
          },
          list.append(codes, include_codes),
          all_expanded,
          index + 1,
        )
        ValuesetIncludeString -> #(
          variants
            <> vsname
            <> valueset_include_name(include, index)
            <> "(value: String)\n",
          codes,
          False,
          index + 1,
        )
      }
    })
  let functions = case all_expanded, codes {
    True, [_, ..] ->
      string.concat([
        gen_valueset_encoder(vsname, codes),
        gen_valueset_to_string(vsname, codes),
        gen_valueset_from_string(vsname, codes),
        gen_valueset_decoder(vsname, codes),
      ])
    _, _ -> ""
  }
  "pub type " <> vsname <> "{" <> variants <> "}\n" <> functions
}

fn valueset_to_types(
  fhir_version: String,
  valueset_acc: Set(String),
  profiles_dir: Option(String),
) {
  //the valueset urls needed by element bindings
  let vs_url_set =
    valueset_acc
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
  let simplifier_package_version = simplifier_core_package_version(fhir_version)
  let package_dir = case profiles_dir {
    None ->
      const_download_dir()
      |> filepath.join("profile_packages")
      |> filepath.join("hl7.fhir." <> fhir_version <> ".core")
      |> filepath.join(simplifier_package_version)
      |> filepath.join("package")
    Some(profile_package_dir) -> profile_package_dir
  }
  let all_vs_or_cs = codegen_helpers.load_valuesets(package_dir, vs_url_set)
  let vs_url_sorted =
    set.to_list(vs_url_set)
    |> list.sort(fn(a, b) {
      string.compare(
        string.lowercase(codegen_helpers.concept_name_from_url(a)),
        string.lowercase(codegen_helpers.concept_name_from_url(b)),
      )
    })
  list.fold(
    from: vs_imports,
    over: vs_url_sorted,
    with: fn(valuesets_acc, vs_url) {
      let vsname = codegen_helpers.concept_name_from_url(vs_url)
      valuesets_acc
      <> valueset_type_source(
        vs_url,
        vsname,
        all_vs_or_cs,
        fhir_version == "r4",
      )
    },
  )
}

fn codetovarname(c: String) {
  str_replace_many(c, [
    #("-", ""),
    #(".", ""),
    #("_", ""),
    #("/", ""),
    #("[", ""),
    #("]", ""),
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
