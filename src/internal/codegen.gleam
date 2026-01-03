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
import simplifile

const check_versions = ["r4", "r4b", "r5"]

const zip_file_names = [
  "profiles-resources.json",
  "profiles-types.json",
  "valuesets.json",
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
    filepath.join(gen_into_dir, fhir_version) <> "valuesets.gleam"
  let gen_clientfile =
    filepath.join(gen_into_dir, fhir_version) <> "client.gleam"
  let all_types =
    string.concat([
      "////FHIR ",
      fhir_version,
      " types\n////https://hl7.org/fhir/",
      fhir_version,
      "\nimport gleam/json.{type Json}\nimport gleam/dynamic/decode.{type Decoder}\nimport gleam/option.{type Option, None, Some}\nimport fhir/",
      fhir_version,
      "valuesets\n",
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-types.json"),
        fv: fhir_version,
      ),
      file_to_types(
        spec_file: filepath.join(extract_dir_ver, "profiles-resources.json"),
        fv: fhir_version,
      ),
      "
      //std lib decode.optional supports myfield: null but what if myfield is omitted from json entirely?
      fn none_if_omitted(d: decode.Decoder(a)) -> decode.Decoder(Option(a)) {
        decode.one_of(d |> decode.map(Some), [decode.success(None)])
      }",
    ])
  let assert Ok(_) = simplifile.write(to: gen_gleamfile, contents: all_types)
  io.println("generated " <> gen_gleamfile)

  //gen valuesets for resource fields with required code binding
  let all_vs =
    valueset_to_types(
      resources: filepath.join(extract_dir_ver, "profiles-resources.json"),
      valueset: filepath.join(extract_dir_ver, "valuesets.json"),
      types: filepath.join(extract_dir_ver, "profiles-types.json"),
    )
  let assert Ok(_) = simplifile.write(to: gen_vsfile, contents: all_vs)
  io.println("generated " <> gen_vsfile)

  Nil
}

fn file_to_types(spec_file spec_file: String, fv fhir_version: String) -> String {
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
        _, "Element" -> False
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
          ) =
            list.fold(
              from: #("", list.new(), "", "", "", "", "", "", ""),
              over: fields,
              with: fn(acc, elt: Element) {
                case elt.type_ {
                  [] -> acc
                  //link type, which idk how to handle, and for now will skip entirely
                  _ -> {
                    let fields_acc = acc.0
                    let choicetypes_acc = acc.1
                    let newfunc_args_acc = acc.2
                    let newfunc_fields_acc = acc.3
                    let encoder_args_acc = acc.4
                    let encoder_always_acc = acc.5
                    let encoder_optional_acc = acc.6
                    let decoder_use_acc = acc.7
                    let decoder_success_acc = acc.8
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
                        )
                      [] -> panic as "skipping link types..."
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
                      [] -> panic as "skipping link types..."
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
                    let #(encoder_optional_acc, encoder_always_acc) = case
                      elt.min,
                      elt.max
                    {
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
                        #(opts, encoder_always_acc)
                      }
                      0, "1" -> {
                        //optional case to json, in Some case add to fields list
                        let opts =
                          encoder_optional_acc
                          <> "\nlet fields = case "
                          <> elt_snake
                          <> " {
                          Some(v) -> [#(\""
                          <> elt_last_part_withgleamtype
                          <> "\", "
                          <> field_type_encoder
                          <> "(v)), ..fields]
                          None -> fields
                        }"
                        #(opts, encoder_always_acc)
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
                        #(encoder_optional_acc, always)
                      }
                      _, _ -> panic as "cardinality panic 72"
                    }
                    let field_type_decoder = case elt.type_ {
                      [one_type] -> {
                        let decoder_itself =
                          string_to_decoder_type(
                            one_type.code,
                            allparts,
                            fhir_version,
                            elt,
                          )
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
                      [] -> panic as "skipping link types..."
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
                    )
                  }
                }
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
          string.join(
            [
              new_doc_link,
              type_newfields,
              type_choicetypes,
              type_new_newfunc,
              old_type_acc,
              gen_res_encoder(
                camel_type,
                snake_type,
                encoder_args,
                encoder_json_always,
                encoder_json_options,
              ),
              gen_res_decoder(
                camel_type,
                snake_type,
                decoder_use,
                decoder_success,
              ),
            ],
            "\n",
          )
        })
      }
    }
  })
}

fn string_to_type(
  fhir_type: String,
  allparts: List(String),
  fhir_version: String,
  elt: Element,
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
                      case string.split(vs, "|") {
                        //get rid of |version in http://some.valueset|4.0.1
                        [_] -> panic as "huh idk 3"
                        [url, ..] ->
                          case
                            string.contains(url, "v3-Confidentiality")
                            || string.contains(url, "mimetypes")
                            || string.contains(url, "currencies")
                            || string.contains(url, "all-languages")
                            || string.contains(url, "ucum-units")
                          {
                            True -> "String"
                            //idk whats going on here, probably i dont understand valueset composition
                            False ->
                              fhir_version
                              <> "valuesets."
                              <> concept_name_from_url(Some(url))
                          }
                        [] -> panic as "huh idk"
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
                      case string.split(vs, "|") {
                        //get rid of |version in http://some.valueset|4.0.1
                        [_] -> panic as "huh idk 3"
                        [url, ..] ->
                          case
                            string.contains(url, "v3-Confidentiality")
                            || string.contains(url, "mimetypes")
                            || string.contains(url, "currencies")
                            || string.contains(url, "all-languages")
                            || string.contains(url, "ucum-units")
                          {
                            True -> "decode.string"
                            //idk whats going on here, probably i dont understand valueset composition
                            False ->
                              fhir_version
                              <> "valuesets."
                              <> Some(url)
                              |> concept_name_from_url()
                              |> to_snake_case
                              <> "_decoder()"
                          }
                        [] -> panic as "huh idk"
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
    "decimal" -> "decode.float"
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
                      case string.split(vs, "|") {
                        //get rid of |version in http://some.valueset|4.0.1
                        [_] -> panic as "huh idk 3"
                        [url, ..] ->
                          case
                            string.contains(url, "v3-Confidentiality")
                            || string.contains(url, "mimetypes")
                            || string.contains(url, "currencies")
                            || string.contains(url, "all-languages")
                            || string.contains(url, "ucum-units")
                          {
                            True -> "json.string"
                            //idk whats going on here, probably i dont understand valueset composition
                            False ->
                              fhir_version
                              <> "valuesets."
                              <> Some(url)
                              |> concept_name_from_url()
                              |> to_snake_case
                              <> "_to_json"
                          }
                        [] -> panic as "huh idk"
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
  rescamel: String,
  reslower: String,
  fields_list: String,
  fields_json_always: String,
  fields_json_options: String,
) -> String {
  let template =
    "pub fn RESNAMELOWER_to_json(RESNAMELOWER: RESNAMECAMEL) -> Json {
    let RESNAMECAMEL(" <> fields_list <> ") = RESNAMELOWER
    let fields = [" <> fields_json_always <> "]" <> fields_json_options <> "\njson.object(fields)}
  "
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}

fn gen_res_decoder(
  rescamel: String,
  reslower: String,
  use_list: String,
  success_list: String,
) {
  let template =
    "pub fn RESNAMELOWER_decoder() -> Decoder(RESNAMECAMEL) {"
    <> use_list
    <> "decode.success(RESNAMECAMEL("
    <> success_list
    <> "))}"
  template
  |> string.replace("RESNAMELOWER", reslower)
  |> string.replace("RESNAMECAMEL", rescamel)
}

//region valuesets

type CSBundle {
  CSBundle(entry: List(CSEntry))
}

fn cs_bundle_decoder() -> decode.Decoder(CSBundle) {
  use entry <- decode.field("entry", decode.list(cs_entry_decoder()))
  decode.success(CSBundle(entry:))
}

type CSEntry {
  CSEntry(resource: Codesystem)
}

fn cs_entry_decoder() -> decode.Decoder(CSEntry) {
  use resource <- decode.field("resource", codesystem_decoder())
  decode.success(CSEntry(resource:))
}

pub type Codesystem {
  Codesystem(
    value_set: Option(String),
    name: Option(String),
    url: Option(String),
    concept: List(CodesystemConcept),
  )
}

fn codesystem_decoder() -> decode.Decoder(Codesystem) {
  use value_set <- decode.optional_field(
    "valueSet",
    None,
    decode.optional(decode.string),
  )
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )

  use url <- decode.optional_field("url", None, decode.optional(decode.string))

  use concept <- decode.optional_field(
    "concept",
    [],
    decode.list(codesystem_concept_decoder()),
  )
  decode.success(Codesystem(value_set:, name:, url:, concept:))
}

pub type CodesystemConcept {
  CodesystemConcept(code: String, display: Option(String))
}

fn codesystem_concept_decoder() -> decode.Decoder(CodesystemConcept) {
  use code <- decode.field("code", decode.string)
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  decode.success(CodesystemConcept(code:, display:))
}

//valuesets can include codesystems
type VSBundle {
  VSBundle(entry: List(VSEntry))
}

fn vs_bundle_decoder() -> decode.Decoder(VSBundle) {
  use entry <- decode.field("entry", decode.list(vs_entry_decoder()))
  decode.success(VSBundle(entry:))
}

type VSEntry {
  VSEntry(resource: Valueset)
}

fn vs_entry_decoder() -> decode.Decoder(VSEntry) {
  use resource <- decode.field("resource", valueset_decoder())
  decode.success(VSEntry(resource:))
}

pub type Valueset {
  Valueset(url: Option(String), compose: Option(ValuesetCompose))
}

fn valueset_decoder() -> decode.Decoder(Valueset) {
  use url <- decode.field("url", decode.optional(decode.string))
  use compose <- decode.optional_field(
    "compose",
    None,
    decode.optional(valueset_compose_decoder()),
  )
  decode.success(Valueset(url:, compose:))
}

pub type ValuesetCompose {
  ValuesetCompose(include: List(ValuesetComposeInclude))
}

fn valueset_compose_decoder() -> decode.Decoder(ValuesetCompose) {
  use include <- decode.field(
    "include",
    decode.list(valueset_compose_include_decoder()),
  )
  decode.success(ValuesetCompose(include:))
}

pub type ValuesetComposeInclude {
  ValuesetComposeInclude(
    system: Option(String),
    concept: List(ValuesetComposeIncludeConcept),
    value_set: List(String),
  )
}

fn valueset_compose_include_decoder() -> decode.Decoder(ValuesetComposeInclude) {
  use system <- decode.optional_field(
    "system",
    None,
    decode.optional(decode.string),
  )
  use concept <- decode.optional_field(
    "concept",
    [],
    decode.list(valueset_compose_include_concept_decoder()),
  )
  use value_set <- decode.optional_field(
    "valueSet",
    [],
    decode.list(decode.string),
  )
  decode.success(ValuesetComposeInclude(system:, concept:, value_set:))
}

pub type ValuesetComposeIncludeConcept {
  ValuesetComposeIncludeConcept(code: String, display: Option(String))
}

fn valueset_compose_include_concept_decoder() -> decode.Decoder(
  ValuesetComposeIncludeConcept,
) {
  use code <- decode.field("code", decode.string)
  use display <- decode.optional_field(
    "display",
    None,
    decode.optional(decode.string),
  )
  decode.success(ValuesetComposeIncludeConcept(code:, display:))
}

fn valueset_to_types(
  valueset vs_file: String,
  resources res_file: String,
  types types_file: String,
) {
  // valueset bindings needed by codes, eg
  // http://hl7.org/fhir/ValueSet/allergy-intolerance-criticality
  // ^ concepts in codesystem -> valueset compose
  // http://hl7.org/fhir/ValueSet/immunization-status
  // ^ concepts directly in valueset
  let need_codes =
    set.union(get_needed_codes(res_file), get_needed_codes(types_file))
  let assert Ok(vs_spec) = simplifile.read(vs_file)
    as "spec files should all be downloaded in src/internal/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(vs_bundle) =
    json.parse(from: vs_spec, using: vs_bundle_decoder())
  let assert Ok(cs_bundle) =
    json.parse(from: vs_spec, using: cs_bundle_decoder())
  let system_to_codesystem =
    list.fold(over: cs_bundle.entry, from: dict.new(), with: insert_codesystem)
  let vs_imports =
    "import gleam/json.{type Json}\nimport gleam/dynamic/decode.{type Decoder}\n"
  list.fold(
    from: vs_imports,
    over: vs_bundle.entry,
    with: fn(vs_acc, vs_entry: VSEntry) {
      let vs_url = vs_entry.resource.url
      let assert Some(valueset_url_str) = vs_url
      case set.contains(need_codes, valueset_url_str) {
        True -> {
          //io.println("ok go for it " <> valueset_url_str)
          let cname = concept_name_from_url(vs_entry.resource.url)
          case cname {
            //not trying to make valuesets out of these because they dont have items in the profiles-types json
            "Currencies" -> vs_acc
            "Mimetypes" -> vs_acc
            //r5 problem only
            "Alllanguages" -> vs_acc
            "Ucumunits" -> vs_acc
            _ -> {
              let vs_concepts_list_finally =
                get_vs_concepts(vs_entry.resource, system_to_codesystem)
              string.concat([
                vs_acc,
                get_concepts_str(cname, vs_concepts_list_finally),
                gen_valueset_encoder(cname, vs_concepts_list_finally),
                gen_valueset_decoder(cname, vs_concepts_list_finally),
              ])
            }
          }
        }
        False -> {
          //io.println("not in need_codes " <> valueset_url_str)
          vs_acc
        }
      }
    },
  )
}

fn insert_codesystem(
  sys_to_codesys: dict.Dict(String, Codesystem),
  cse: CSEntry,
) {
  let assert Some(url) = cse.resource.url
  dict.insert(sys_to_codesys, url, cse.resource)
}

fn get_needed_codes(filename: String) {
  let assert Ok(res) = simplifile.read(filename)
    as "spec files should all be downloaded in src/internal/downloads/{r4 r4b r5}, run with download arg if not"
  let assert Ok(res_bundle) = json.parse(from: res, using: bundle_decoder())
  // there must be a much nicer way to chain these
  // will probably be a cool gleam realization moment
  // terrible ugly for now though
  res_bundle.entry
  |> list.fold(set.new(), fn(acc1, e) {
    e.resource.snapshot
    |> option.map(fn(snapshot) {
      snapshot.element
      |> list.fold(acc1, fn(acc2, elt) {
        case elt.type_ {
          [one_type] if one_type.code == "code" -> {
            case elt.binding {
              Some(x) ->
                case x.value_set {
                  Some(vs) -> {
                    case string.split(vs, "|") {
                      //get rid of |version in http://some.valueset|4.0.1
                      [url] -> set.insert(acc2, url)
                      [url, ..] -> set.insert(acc2, url)
                      [] -> acc2
                    }
                  }
                  _ -> acc2
                }
              None -> acc2
            }
          }
          _ -> acc2
        }
      })
    })
    |> option.unwrap(acc1)
  })
}

fn get_vs_concepts(vs_res: Valueset, codesystems: dict.Dict(String, Codesystem)) {
  let assert Some(vs_compose) = vs_res.compose
  let vs_incl: List(ValuesetComposeInclude) = vs_compose.include
  // there are valuesets AND codesystems
  // codesystems are the simple lists of codes but they dont have everything
  // valuesets include code systems which is annoying at best
  // this gets codes either from valuesets directly or by getting code from codesystem included in valueset
  // TODO there can also be weird rules for including (is-a or filter)????? idk
  vs_incl
  |> list.map(fn(vci: ValuesetComposeInclude) {
    case vci.concept {
      [] -> {
        case vci.system {
          None -> []
          Some(vci_sys) -> {
            let cs = dict.get(codesystems, vci_sys)
            case cs {
              Error(_) -> []
              Ok(concept_codesystem) -> {
                list.map(concept_codesystem.concept, fn(cs_c) {
                  ValuesetComposeIncludeConcept(
                    code: cs_c.code,
                    display: cs_c.display,
                  )
                })
              }
            }
          }
        }
      }
      _ -> vci.concept
    }
  })
  |> list.flatten
}

fn get_concepts_str(
  cname: String,
  vs_concept_list: List(ValuesetComposeIncludeConcept),
) {
  string.concat([
    "\npub type ",
    cname,
    "{",
    list.fold(
      over: vs_concept_list,
      from: "",
      with: fn(acc: String, vs_concept_finally: ValuesetComposeIncludeConcept) {
        acc
        <> cname
        <> codetovarname(vs_concept_finally.code)
        |> string.capitalise()
        <> "\n"
      },
    ),
    "}\n",
  ])
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

fn concept_name_from_url(u) {
  let assert Some(url) = u
  let assert Ok(urlname) = url |> string.split("/") |> list.last()
  urlname
  |> string.replace(" ", "")
  |> string.replace("-", "")
  |> string.replace("_", "")
  |> string.capitalise
}

fn str_replace_many(s: String, badchars: List(#(String, String))) -> String {
  list.fold(from: s, over: badchars, with: fn(acc, bc) {
    string.replace(acc, bc.0, bc.1)
  })
}

fn gen_valueset_encoder(
  cname: String,
  vs_concept_list: List(ValuesetComposeIncludeConcept),
) -> String {
  let cname_lower = cname |> string.lowercase()
  let template = "pub fn CNAMELOWER_to_json(CNAMELOWER: CNAMECAPITAL) -> Json {
    case CNAMELOWER {" <> list.fold(
      from: "",
      over: vs_concept_list,
      with: fn(acc: String, concept: ValuesetComposeIncludeConcept) {
        acc
        <> "CODETYPE -> json.string(\"ACTUALCODE\")\n"
        |> string.replace(
          "CODETYPE",
          cname
            <> codetovarname(concept.code)
          |> string.capitalise(),
        )
        |> string.replace("ACTUALCODE", concept.code)
      },
    ) <> "}
  }
  "
  template
  |> string.replace("CNAMELOWER", cname_lower)
  |> string.replace("CNAMECAPITAL", cname |> string.capitalise())
}

fn gen_valueset_decoder(
  cname: String,
  vs_concept_list: List(ValuesetComposeIncludeConcept),
) -> String {
  let cname_lower = cname |> string.lowercase()
  //let assert Ok(failure_code) = list.first(vs_res.concept)
  let assert Ok(fail) = list.first(vs_concept_list)
  let template = "pub fn CNAMELOWER_decoder() -> Decoder(CNAMECAPITAL) {
    use variant <- decode.then(decode.string)
    case variant {" <> list.fold(
      from: "",
      over: vs_concept_list,
      with: fn(acc: String, concept: ValuesetComposeIncludeConcept) {
        acc
        <> "\"ACTUALCODE\" -> decode.success(CODETYPE)\n"
        |> string.replace(
          "CODETYPE",
          cname
            <> codetovarname(concept.code)
          |> string.capitalise(),
        )
        |> string.replace("ACTUALCODE", concept.code)
      },
    ) <> "_ -> decode.failure(" <> cname <> codetovarname(fail.code)
    |> string.capitalise() <> ", \"CNAMECAPITAL\")}
  }
  "
  template
  |> string.replace("CNAMELOWER", cname_lower)
  |> string.replace("CNAMECAPITAL", cname |> string.capitalise())
}
