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
import gleam/set
import gleam/string
import internal/codegen_client
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
  "src" |> filepath.join("fhir")
}

fn const_download_dir() {
  "src" |> filepath.join("internal") |> filepath.join("downloads")
}

pub fn main() {
  io.println("🔥🔥🔥 bultaoreune")

  let args = argv.load().arguments |> list.map(fn(s) { string.lowercase(s) })

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
    snapshot: Option(Snapshot),
    resource_type: String,
    name: String,
    url: String,
    kind: Option(String),
    base_definition: Option(String),
  )
}

fn resource_decoder() -> decode.Decoder(Resource) {
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
    snapshot:,
    resource_type:,
    name:,
    url:,
    kind:,
    base_definition:,
  ))
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
    content_reference: Option(String),
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
  use content_reference <- decode.optional_field(
    "contentReference",
    None,
    decode.optional(decode.string),
  )
  decode.success(Element(
    path:,
    min:,
    max:,
    type_:,
    binding:,
    content_reference:,
  ))
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
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  decode.success(Binding(strength:, value_set:))
}

fn gen_fhir(fhir_version: String, download_files: Bool) -> Nil {
  let gen_into_dir = const_gen_into_dir()
  let extract_dir_ver = const_download_dir() |> filepath.join(fhir_version)

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

  let gen_gleamfile = filepath.join(gen_into_dir, fhir_version) <> ".gleam"
  let gen_vsfile =
    filepath.join(gen_into_dir, fhir_version) <> "_valuesets.gleam"
  let all_types =
    string.concat([
      "////FHIR ",
      fhir_version,
      " types\n////https://hl7.org/fhir/",
      fhir_version,
      "\nimport gleam/json.{type Json}\nimport gleam/dynamic/decode.{type Decoder}\nimport gleam/option.{type Option, None, Some}\nimport gleam/bool\nimport gleam/int\nimport fhir/",
      fhir_version,
      "_valuesets\n",
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
        fv: fhir_version,
        vsfile: gen_vsfile,
      ),
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
        fv: fhir_version,
        vsfile: gen_vsfile,
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
      ",
    ])
  let assert Ok(_) = simplifile.write(to: gen_gleamfile, contents: all_types)
  io.println("generated " <> gen_gleamfile)

  // gen valuesets for resource fields with required code binding
  // which were written as list to file by gen_gleamfile (why this fn needs to know file as temp list)
  let all_vs = valueset_to_types(gen_vsfile, fhir_version)
  let assert Ok(_) = simplifile.write(to: gen_vsfile, contents: all_vs)
  io.println("generated " <> gen_vsfile)

  let #(sansio, httpc_layer) =
    codegen_client.gen(
      spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
      fv: fhir_version,
    )
  let f_sansio = gen_into_dir |> filepath.join(fhir_version <> "_sansio.gleam")
  let assert Ok(_) = simplifile.write(to: f_sansio, contents: sansio)
  io.println("generated " <> f_sansio)
  let f_httpc = gen_into_dir |> filepath.join(fhir_version <> "_httpc.gleam")
  let assert Ok(_) = simplifile.write(to: f_httpc, contents: httpc_layer)
  io.println("generated " <> f_httpc)
}

fn file_to_types(
  spec_file spec_file: String,
  fv fhir_version: String,
  vsfile gen_vsfile: String,
) -> String {
  let assert Ok(spec) = simplifile.read(spec_file)
    as "spec files should all be downloaded in src/internal/downloads/{r4 r4b r5}, run with download arg if not"
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
  let all_resources_and_types =
    list.fold(entries, "", fn(elt_str_acc, entry: Entry) {
      //map of type -> fields needed to list out all the BackboneElements
      //because they're subcomponents eg Allergy -> Reaction
      //and rather than nested, we want to write fields one after the other
      let starting_res_fields =
        dict.new() |> dict.insert(entry.resource.name, [])
      //we want to write types in order of parsing backbone elements, but map order random
      //put elts into name of current struct, eg AllergyIntolerance, AllergyIntoleranceReaction...
      let type_order = [entry.resource.name]
      let f_o = #(starting_res_fields, type_order)

      elt_str_acc
      <> "\n"
      <> case entry.resource.snapshot {
        None -> ""
        Some(snapshot) -> {
          let fields_and_order =
            list.fold(over: snapshot.element, from: f_o, with: fn(f_o, elt) {
              let res_fields = f_o.0
              let order = f_o.1
              let pp = string.split(elt.path, ".")
              let field_path = string.join(pp, "_")
              //there must be a better way to drop last item?
              let pp_minus_last =
                pp |> list.reverse |> list.drop(1) |> list.reverse
              let field_path_minus_last = string.join(pp_minus_last, "_")

              //idk why but they just make these quantity
              let field_path_minus_last = case entry.resource.name {
                "SimpleQuantity" -> "Simple" <> field_path_minus_last
                "MoneyQuantity" -> "Money" <> field_path_minus_last
                _ -> field_path_minus_last
              }

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
            from: "",
            with: fn(old_type_acc, new_type) {
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

              let camel_type = new_type |> to_camel_case
              //conflict gleam list
              let camel_type = case camel_type == "List" {
                True -> "Listfhir"
                False -> camel_type
              }
              let snake_type = to_snake_case(camel_type)
              let assert Ok(fields) = dict.get(type_fields, new_type)
              let fields = case entry.resource.name {
                "SimpleQuantity" ->
                  list.filter(fields, fn(x) { x.path != "Quantity.comparator" })
                //simplequantity has no comparator
                _ -> fields
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
              ) =
                list.fold(
                  from: #("", list.new(), "", "", "", "", "", "", "", ""),
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
                    //yeah this should be custom type right
                    let allparts = string.split(elt.path, ".")
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
                        string_to_type(
                          one_type.code,
                          allparts,
                          fhir_version,
                          elt,
                          gen_vsfile,
                        )
                      [] -> {
                        link_type_from(elt.content_reference) |> to_camel_case
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
                          list.fold(
                            over: elt.type_,
                            from: "",
                            with: fn(acc, typ) {
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
                            },
                          ),
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
                    let #(newfunc_arg, newfunc_field) = case elt.max {
                      "*" -> #("", elt_snake <> ": [],")
                      _ ->
                        case elt.min {
                          0 -> #("", elt_snake <> ": None,")
                          1 -> {
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
                          _ -> panic as "cardinality panic 2"
                        }
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
                        link_type_from(elt.content_reference) <> "_to_json"
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
                    let #(
                      encoder_optional_acc,
                      encoder_always_acc,
                      decoder_always_failure_acc,
                    ) = case elt.min, elt.max {
                      _, "*" -> {
                        //list case to json, in non empty [] case add to first fields list
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
                    let field_type_decoder = case elt.type_ {
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
                            link_type_from(elt.content_reference)
                            <> "_decoder()"
                          _ -> panic as "compiler should see this cant happen"
                        }
                        case elt.max {
                          "*" ->
                            "decode.optional_field(\""
                            <> elt_last_part_withgleamtype
                            <> "\", [], decode.list("
                            <> decoder_itself
                            <> "))"
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
              let is_domainresource = case entry.resource.kind {
                Some("complex-type") -> False
                Some("resource") -> entry.resource.name == new_type
                _ -> panic as "????"
              }
              string.join(
                [
                  new_doc_link,
                  type_newfields,
                  type_choicetypes,
                  type_new_newfunc,
                  old_type_acc,
                  gen_res_encoder(
                    entry.resource.name,
                    camel_type,
                    snake_type,
                    encoder_args,
                    encoder_json_always,
                    encoder_json_options,
                    is_domainresource,
                  ),
                  gen_res_decoder(
                    entry.resource.name,
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
            },
          )
        }
      }
    })
  case spec_file |> string.ends_with("profiles-resources.json") {
    False -> all_resources_and_types
    True -> {
      let res_entries =
        entries
        |> list.filter(fn(entry) {
          entry.resource.kind == Some("resource")
          && entry.resource.name != "DomainResource"
        })
        |> list.map(fn(entry) {
          let camel_type = entry.resource.name |> to_camel_case
          #(entry, case camel_type {
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
          <> string.lowercase(camel_type)
          <> "_to_json(r)\n"
        })
        |> string.concat

      let resource_decoders =
        res_entries
        |> list.map(fn(entry_and_camel_type) {
          let camel_type = entry_and_camel_type.1
          let entry: Entry = entry_and_camel_type.0
          "\""
          <> entry.resource.name
          <> "\" -> "
          <> string.lowercase(camel_type)
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
            _ -> decode.failure(ResourceCareteam(careteam_new()), expected: \"resourceType\")
          }
        }
        ",
      ])
    }
  }
}

fn link_type_from(content_reference: Option(String)) {
  let assert Some(link_type) = content_reference
  link_type
  |> string.replace(".", "_")
  |> string.replace("#", "")
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
    "integer64" -> "decode.int"
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
    "integer64" -> "json.int"
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
    _, "*" -> "List(" <> fieldtype <> ")"
    //might be missing "must have at least 1" correctness for cases with 1..* but who cares
    0, "1" -> "Option(" <> fieldtype <> ")"
    1, "1" -> fieldtype
    _, _ -> panic as "cardinality panic"
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
  urlname
  |> string.replace(" ", "")
  |> string.replace("-", "")
  |> string.replace("_", "")
  |> string.capitalise
}

fn valueset_to_types(vsfile: String, fhir_version: String) {
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
    "import gleam/dynamic/decode.{type Decoder}
  import gleam/json.{type Json}\n"
  let expansion_dir =
    "src"
    |> filepath.join("internal")
    |> filepath.join("valueset_expansions")
    |> filepath.join(fhir_version)
  set.fold(from: vs_imports, over: vs_url_set, with: fn(valuesets_acc, vs_url) {
    let vsname = concept_name_from_url(Some(vs_url))
    let vs_codes = get_codes(vs_url, expansion_dir)
    let vs_named_codes =
      vs_codes
      |> list.map(fn(code) { vsname <> string.capitalise(codetovarname(code)) })
    string.concat([
      "pub type ",
      vsname,
      "{",
      string.join(vs_named_codes, "\n"),
      "}",
      gen_valueset_encoder(vsname, vs_codes),
      gen_valueset_decoder(vsname, vs_codes),
      valuesets_acc,
    ])
  })
}

// https://chat.fhir.org/#narrow/channel/179166-implementers/topic/Kotlin.20FHIR.20model.20code.20generation.20questions/near/524688061
// kind of pissed after the satisfying experience of getting the recursive valueset/codesystem expansion working in gleam that you can (and must in r4b/r5) simply use the expanded valuesets from terminology download?
fn get_codes(url: String, expansion_dir: String) {
  let assert Ok(vs_file) =
    url |> string.split("/") |> list.reverse |> list.first
  let expansion =
    expansion_dir |> filepath.join("ValueSet-" <> vs_file <> ".json")
  let assert Ok(vs_json) = simplifile.read(expansion) as url
  let assert Ok(vs) = vs_json |> json.parse(r4.valueset_decoder())
  let assert Some(vs_expansion) = vs.expansion
  vs_expansion.contains
  |> list.map(fn(c: r4.ValuesetExpansionContains) {
    let assert Some(code) = c.code
    code
  })
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

fn gen_valueset_encoder(vsname: String, vs_codes: List(String)) -> String {
  let vsname_lower = vsname |> string.lowercase()
  let template = "pub fn CNAMELOWER_to_json(CNAMELOWER: CNAMECAPITAL) -> Json {
    case CNAMELOWER {" <> list.fold(
      from: "",
      over: vs_codes,
      with: fn(acc: String, code: String) {
        acc
        <> "CODETYPE -> json.string(\"ACTUALCODE\")\n"
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
