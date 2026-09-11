import child_process
import child_process/stdio
import fhir/r4_gui/complex_types.{type List1, List1} as ct
import fhir/r4_gui/resources
import fhir_gui_reslist
import filepath
import gleam/dict
import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre.{type App}
import lustre/attribute as a
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html as h
import lustre/event
import rsvp
import simplifile

pub fn component() -> App(_, Model, Message) {
  lustre.application(init, update, view)
}

// MODEL -----------------------------------------------------------------------

pub type Model {
  Model(
    codegen_dir: String,
    profile: Option(Profile),
    fhir_version: FhirVersion,
    base_resources: List(ResGen),
    profile_search_results: List(SimplifierProfilePkg),
    simplifier_response_error: Option(String),
    download: Download,
    process_output: List(String),
    custom_name: Option(String),
    generating: Generating,
  )
}

pub type Download {
  Downloading
  NotInProgress
  ParsingJsons
}

pub type Generating {
  Generating
  NotGenerating
}

pub type Profile {
  Profile(
    dir: String,
    resources: List(Result(StructureGen, String)),
    // name of resource in list we currently editing
    editing_resource: Option(String),
  )
}

pub type ResGen {
  ResGen(res: String, gen: Gen)
}

pub type StructureGen {
  StructureGen(
    rg: ResGen,
    structure: resources.Structuredefinition,
    filename: String,
  )
}

pub type Gen {
  Generate
  DontGenerate
}

fn get_edit_resource(model: Model) -> Result(StructureGen, String) {
  case model.profile {
    None -> Error("no profile")
    Some(profile) ->
      case profile.editing_resource {
        None -> Error("no current editing resource")
        Some(editing_resource) ->
          case
            list.find(profile.resources, fn(resource) {
              case resource {
                Error(_) -> False
                Ok(resource) -> resource.structure.name == editing_resource
              }
            })
          {
            Error(_) -> Error("resource " <> editing_resource <> " not found")
            Ok(resource) -> resource
          }
      }
  }
}

fn set_edit_resource(
  model: Model,
  new_structure: resources.Structuredefinition,
) {
  case model.profile {
    None -> #(model, effect.none())
    Some(profile) -> {
      let resources =
        list.fold(
          from: #([], effect.none()),
          over: profile.resources,
          with: fn(acc, resource) {
            case resource {
              Error(_) -> #([resource, ..acc.0], acc.1)
              Ok(resource) ->
                case resource.structure.name == new_structure.name {
                  False -> #([Ok(resource), ..acc.0], acc.1)
                  True -> #(
                    [
                      Ok(StructureGen(..resource, structure: new_structure)),
                      ..acc.0
                    ],
                    save_resource(new_structure, resource.filename),
                  )
                }
            }
          },
        )
      let effect = resources.1
      let resources = list.reverse(resources.0)
      let profile = Some(Profile(..profile, resources:))
      #(Model(..model, profile:), effect)
    }
  }
}

pub fn insert(items: List(ResGen), res: String, gen: Gen) {
  list.fold(from: [], over: items, with: fn(acc, item) {
    case item.res == res {
      False -> [item, ..acc]
      True -> [ResGen(item.res, gen), ..acc]
    }
  })
  |> list.reverse
}

pub fn insert_sg(
  items: List(Result(StructureGen, String)),
  res: String,
  gen: Gen,
) {
  list.fold(from: [], over: items, with: fn(acc, item) {
    case item {
      Error(_) -> [item, ..acc]
      Ok(sg) ->
        case sg.rg.res == res {
          False -> [item, ..acc]
          True -> [Ok(StructureGen(..sg, rg: ResGen(sg.rg.res, gen))), ..acc]
        }
    }
  })
  |> list.reverse
}

pub fn insert_elt(model: Model, elt_id: String, new_elt_fn) {
  case get_edit_resource(model) {
    Error(_) -> #(model, effect.none())
    Ok(edit_resource) -> {
      case edit_resource.structure.snapshot {
        None -> #(model, effect.none())
        Some(snapshot) -> {
          let element = insert_elt_in_list(snapshot.element, elt_id, new_elt_fn)
          let snapshot =
            Some(resources.StructuredefinitionSnapshot(..snapshot, element:))
          let structure =
            resources.Structuredefinition(..edit_resource.structure, snapshot:)
          set_edit_resource(model, structure)
        }
      }
    }
  }
}

pub fn insert_elt_in_list(
  items: List1(ct.Elementdefinition),
  elt_id: String,
  new_elt_fn,
) {
  let rest =
    list.fold(
      from: [],
      over: items.rest,
      with: fn(acc, item: ct.Elementdefinition) {
        case item.id == Some(elt_id) {
          False -> [item, ..acc]
          True -> [new_elt_fn(item), ..acc]
        }
      },
    )
    |> list.reverse
  let first = case items.first.id == Some(elt_id) {
    False -> items.first
    True -> new_elt_fn(items.first)
  }
  List1(first, rest)
}

pub type FhirVersion {
  R4
  R4B
  R5
}

const store_profile_dir = "current_profile"

fn init(_) {
  let assert Ok(pwd) = simplifile.current_directory()
  let codegen_dir = pwd |> filepath.join("dev")
  let already_downloaded_profile =
    simplifile.read(codegen_dir |> filepath.join(store_profile_dir))
  let profile = case already_downloaded_profile {
    Ok(dir) -> Some(Profile(dir:, resources: [], editing_resource: None))
    Error(_) -> None
  }
  let #(simplifier_response_error, parse_structuredefs_effect) = case
    already_downloaded_profile
  {
    Ok(profile_dir) ->
      start_parsing_files(Some(Profile(profile_dir, [], None)), codegen_dir)
    Error(_) -> #(None, effect.none())
  }
  // actually should be if we have start parsing files effect this tuple is demented
  let download = case simplifier_response_error {
    None -> NotInProgress
    Some(_) -> NotInProgress
  }
  let base_resources =
    fhir_gui_reslist.r4 |> list.map(fn(res) { ResGen(res, Generate) })
  let model =
    Model(
      codegen_dir: pwd |> filepath.join("dev"),
      fhir_version: R4,
      base_resources:,
      profile:,
      profile_search_results: [],
      simplifier_response_error:,
      download:,
      process_output: [],
      custom_name: None,
      generating: NotGenerating,
    )
  #(model, parse_structuredefs_effect)
}

// UPDATE ----------------------------------------------------------------------

pub opaque type Message {
  ClickGenerateCode
  ClickFhirVersion(FhirVersion)
  TypeCustomName(String)
  GenResource(res: String, gen: Gen, restype: ResType)
  GenAll(gen: Gen, restype: ResType)
  SearchProfileInput(String)
  SearchProfileResps(Result(List(String), rsvp.Error(String)))
  SearchProfileVersionResps(Result(SimplifierProfilePkg, rsvp.Error(String)))
  DownloadPackageName(String)
  ProcessReturnedLine(String)
  DownloadExited
  GenerateExited
  ParseReturnedStructuredefinition(
    one_structuredef: Result(resources.Structuredefinition, String),
    rest_to_parse: List(String),
    in_dir: String,
    filename: String,
  )
  ClickEditResource(StructureGen)
  RestrictMin(elt_id: String, new_min: String)
  RestrictMax(elt_id: String, new_max: String)
  RestrictMinMax(elt_id: String, new_min: String, new_max: String)
}

pub type ResType {
  Bases
  Profiles
}

// need name and version to download tar
// could also get description but who cares
//
// first get name, will use it to make second call for version
pub fn package_name_decoder() {
  use name <- decode.field("Name", decode.string)
  decode.success(name)
}

pub fn package_names_decoder() {
  decode.list(package_name_decoder())
}

fn get_package_names(search_text) {
  let url = "https://packages.simplifier.net/catalog?name=" <> search_text
  let handler = rsvp.expect_json(package_names_decoder(), SearchProfileResps)
  rsvp.get(url, handler)
}

pub type SimplifierProfilePkg {
  SimplifierProfilePkg(name: String, versions: List(String))
}

//now we have pkg name, search for versions
fn package_versions_decoder() {
  use name <- decode.field("name", decode.string)
  use versions <- decode.field(
    "versions",
    decode.dict(decode.string, decode.dynamic),
  )
  let versions = versions |> dict.keys
  decode.success(SimplifierProfilePkg(name:, versions:))
}

fn get_package_versions(search_text) {
  let url = "https://packages.simplifier.net/" <> search_text
  let handler =
    rsvp.expect_json(package_versions_decoder(), SearchProfileVersionResps)
  rsvp.get(url, handler)
}

fn run_proc_set_first_cmd(model, name, args, donemsg) {
  let model =
    Model(..model, process_output: [
      string.join([name, ..args], " "),
    ])
  let run_effect = run_process(name, args, donemsg)
  #(model, run_effect)
}

fn run_process(name, args, donemsg) -> Effect(Message) {
  effect.from(fn(dispatch) {
    let _ =
      child_process.from_name(name)
      |> child_process.args(args)
      |> child_process.spawn(
        stdio.lines(fn(line) { dispatch(ProcessReturnedLine(line)) })
        |> stdio.on_exit(fn(_status) { dispatch(donemsg) }),
      )
    Nil
  })
}

fn parse_structuredefs(dir, structuredefs) -> Effect(Message) {
  effect.from(fn(dispatch) {
    case structuredefs {
      [] -> Nil
      [first_structuredef_filename, ..rest_structuredef_filenames] -> {
        let path = dir |> filepath.join(first_structuredef_filename)
        let res = case simplifile.read(path) {
          // unfortunately we also get errors for files that are not structuredefinitions
          // could do a check or something idk
          // for now just not including errors we return that contain string "resourceType"
          Error(_) -> Error("failed to read file: " <> path)
          Ok(content) ->
            case json.parse(content, resources.structuredefinition_decoder()) {
              Error(err) ->
                Error(
                  "failed to decode StructureDefinition "
                  <> path
                  <> " error: "
                  <> json_err_to_string(err),
                )
              Ok(value) -> Ok(value)
            }
        }
        dispatch(ParseReturnedStructuredefinition(
          res,
          rest_structuredef_filenames,
          dir,
          path,
        ))
      }
    }
  })
}

fn save_resource(resource: resources.Structuredefinition, filename: String) {
  effect.from(fn(_dispatch) {
    let contents =
      resource |> resources.structuredefinition_to_json |> json.to_string
    let _ = simplifile.write(to: filename, contents:)
    Nil
  })
}

fn update(model: Model, message: Message) {
  case message {
    ClickGenerateCode -> {
      let name = "gleam"
      let args = ["run", "-m", "codegen"]
      let more_args = [
        case model.fhir_version {
          R4 -> "r4"
          R4B -> "r4b"
          R5 -> "r5"
        },
      ]
      let more_args = case model.custom_name {
        None -> more_args
        Some(custom_name) -> ["customname=" <> custom_name, ..more_args]
      }
      let profile_rg = case model.profile {
        None -> []
        Some(profile) ->
          profile.resources
          |> list.filter_map(fn(sg) {
            case sg {
              Error(_) -> Error(Nil)
              Ok(sg) -> Ok(sg.rg)
            }
          })
      }
      let all_rg = model.base_resources |> list.append(profile_rg)
      let dont_gen_a_res =
        all_rg
        |> list.any(fn(res) { res.gen == DontGenerate })
      let more_args = case dont_gen_a_res {
        False -> more_args
        True -> {
          echo all_rg
          let gen_res_arg =
            all_rg
            |> list.filter_map(fn(rg) {
              case rg.gen {
                Generate -> Ok(rg.res)
                DontGenerate -> Error(Nil)
              }
            })
            |> string.join(",")
          ["resources=" <> gen_res_arg, ..more_args]
        }
      }
      let args = args |> list.append(more_args)
      let model = Model(..model, generating: Generating)
      run_proc_set_first_cmd(model, name, args, GenerateExited)
    }
    ClickFhirVersion(fhir_version) -> {
      let res_list = case fhir_version {
        R4 -> fhir_gui_reslist.r4
        R4B -> fhir_gui_reslist.r4b
        R5 -> fhir_gui_reslist.r5
      }
      let base_resources =
        res_list |> list.map(fn(res) { ResGen(res, Generate) })
      #(Model(..model, fhir_version:, base_resources:), effect.none())
    }
    TypeCustomName(custom_name) -> {
      let custom_name = case custom_name {
        "" -> None
        _ -> Some(custom_name)
      }
      let model = Model(..model, custom_name:)
      #(model, effect.none())
    }
    GenResource(res, gen, restype) -> {
      let model = case restype {
        Bases -> {
          let base_resources = model.base_resources |> insert(res, gen)
          Model(..model, base_resources:)
        }
        Profiles -> {
          case model.profile {
            None -> model
            Some(p) -> {
              let resources = p.resources |> insert_sg(res, gen)
              let profile = Some(Profile(..p, resources:))
              Model(..model, profile:)
            }
          }
        }
      }
      #(model, effect.none())
    }
    GenAll(gen, restype) -> {
      let model = case restype {
        Bases ->
          Model(
            ..model,
            base_resources: model.base_resources
              |> list.map(fn(resgen) { ResGen(resgen.res, gen) }),
          )
        Profiles ->
          case model.profile {
            None -> model
            Some(p) -> {
              let resources =
                p.resources
                |> list.map(fn(sg) {
                  case sg {
                    Error(_) -> sg
                    Ok(sg) -> {
                      let rg = ResGen(sg.rg.res, gen)
                      Ok(StructureGen(..sg, rg:))
                    }
                  }
                })
              let profile = Some(Profile(..p, resources:))
              Model(..model, profile:)
            }
          }
      }
      #(model, effect.none())
    }
    SearchProfileInput(partial_profile_name) -> {
      let search_effect = case model.download {
        NotInProgress -> get_package_names(partial_profile_name)
        Downloading | ParsingJsons -> effect.none()
      }
      #(model, search_effect)
    }
    SearchProfileResps(resp) ->
      case resp {
        Error(err) -> #(
          Model(..model, simplifier_response_error: Some(err_to_string(err))),
          effect.none(),
        )
        Ok(package_names) -> {
          let search_pkg_effects =
            package_names |> list.map(get_package_versions)
          let num = package_names |> list.length |> int.to_string
          let simplifier_response_error =
            Some("found " <> num <> " package names, searching their versions")
          let model =
            Model(
              ..model,
              simplifier_response_error:,
              profile_search_results: [],
            )
          // should rename this from error
          #(model, effect.batch(search_pkg_effects))
        }
      }
    SearchProfileVersionResps(resp) -> {
      let model = case resp {
        Ok(pkg) ->
          Model(
            ..model,
            profile_search_results: [pkg, ..model.profile_search_results],
            simplifier_response_error: None,
          )
        Error(err) ->
          Model(..model, simplifier_response_error: Some(err_to_string(err)))
      }
      #(model, effect.none())
    }
    DownloadPackageName(opt) ->
      case opt |> string.split("/") {
        [pkg_name, pkg_version] -> {
          let profiles_dir =
            model.codegen_dir
            |> filepath.join("downloads")
            |> filepath.join("profile_package")
          let name = "gleam"
          let args = [
            "run",
            "-m",
            "download_profile_package",
            pkg_name,
            pkg_version,
            profiles_dir,
          ]
          let profile =
            Some(Profile(
              dir: profiles_dir
                |> filepath.join(pkg_name)
                |> filepath.join(pkg_version)
                |> filepath.join("package"),
              resources: [],
              editing_resource: None,
            ))
          let model = Model(..model, download: Downloading, profile:)
          run_proc_set_first_cmd(model, name, args, DownloadExited)
        }
        _ -> #(model, effect.none())
      }
    ProcessReturnedLine(line) -> {
      let model = Model(..model, process_output: [line, ..model.process_output])
      #(model, effect.none())
    }
    DownloadExited -> {
      let #(simplifier_response_error, parse_structuredefs_effect) =
        start_parsing_files(model.profile, model.codegen_dir)
      let model = Model(..model, simplifier_response_error:)
      #(model, parse_structuredefs_effect)
    }
    GenerateExited -> {
      let model = Model(..model, generating: NotGenerating)
      #(model, effect.none())
    }
    ParseReturnedStructuredefinition(sd_res, rest_sds, dir, filename) -> {
      case model.profile {
        None -> #(model, effect.none())
        Some(profile) -> {
          let resources = case sd_res {
            Error(err) ->
              case string.contains(err, "resourceType") {
                True -> profile.resources
                False -> [Error(err), ..profile.resources]
              }
            Ok(sd_res) -> [
              Ok(StructureGen(ResGen(sd_res.name, Generate), sd_res, filename)),
              ..profile.resources
            ]
          }
          let profile = Some(Profile(..profile, resources:))
          // this is kind of clever, we parse one structuredefinition json at a time
          // so you see them stream in instead of waiting while showing nothing until they all parse
          // (or rather give lustre effect to parse one at a time)
          let parse_rest_sds = parse_structuredefs(dir, rest_sds)
          let download = case rest_sds {
            [] -> NotInProgress
            _ -> ParsingJsons
          }
          #(Model(..model, profile:, download:), parse_rest_sds)
        }
      }
    }
    ClickEditResource(sg) -> {
      let profile = case model.profile {
        None -> None
        Some(p) -> Some(Profile(..p, editing_resource: Some(sg.structure.name)))
      }
      #(Model(..model, profile:), effect.none())
    }
    RestrictMin(elt_id, new_min) -> restrict_min(model, elt_id, new_min)
    RestrictMax(elt_id, new_max) -> restrict_max(model, elt_id, new_max)
    RestrictMinMax(elt_id, new_min, new_max) -> {
      let #(model, _) = restrict_min(model, elt_id, new_min)
      restrict_max(model, elt_id, new_max)
    }
  }
}

fn restrict_min(model, elt_id, new_min) {
  case int.parse(new_min) {
    Error(_) -> #(model, effect.none())
    Ok(new_min) ->
      insert_elt(model, elt_id, fn(elt) {
        ct.Elementdefinition(..elt, min: Some(new_min))
      })
  }
}

fn restrict_max(model, elt_id, new_max) {
  insert_elt(model, elt_id, fn(elt) {
    ct.Elementdefinition(..elt, max: Some(new_max))
  })
}

fn start_parsing_files(profile: Option(Profile), store_profile_dir_in: String) {
  let res = case profile {
    None ->
      Error(
        "download finished but don't have profile? weird state, should probably reload page",
      )
    Some(profile) ->
      case simplifile.read_directory(profile.dir) {
        Error(_) -> Error("failed to read dir: " <> profile.dir)
        Ok(structuredefs) -> {
          let _ =
            simplifile.write(
              to: store_profile_dir_in |> filepath.join(store_profile_dir),
              contents: profile.dir,
            )
          let structuredefs =
            structuredefs
            |> list.filter(fn(structure_definition_path) {
              case simplifile.is_file(profile.dir |> filepath.join(structure_definition_path)) {
                Ok(True) -> True
                _ -> False
              }
            })
            |> list.sort(string.compare)
          Ok(parse_structuredefs(profile.dir, structuredefs))
        }
      }
  }
  case res {
    Ok(res) -> #(None, res)
    Error(err) -> #(Some(err), effect.none())
  }
}

fn err_to_string(err: rsvp.Error(String)) {
  case err {
    rsvp.BadBody -> "bad body"
    rsvp.BadUrl(url) -> "bad url: " <> url
    rsvp.HttpError(_resp) -> "http error"
    rsvp.UnhandledResponse(_resp) -> "rsvp error"
    rsvp.JsonError(err) -> json_err_to_string(err)
    rsvp.NetworkError -> "network error"
  }
}

fn json_err_to_string(err) {
  case err {
    json.UnexpectedEndOfInput -> "unexpected end of input"
    json.UnexpectedByte(byte) -> "unexpected byte: " <> byte
    json.UnexpectedSequence(seq) -> "unexpected sequence: " <> seq
    json.UnableToDecode(errs) ->
      list.map(errs, fn(err) {
        "at "
        <> string.join(err.path, ".")
        <> " expected "
        <> err.expected
        <> " but found "
        <> err.found
      })
      |> string.join("\n")
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Message) {
  let main =
    h.main(
      [
        a.styles([
          #("display", "flex"),
          #("flex-wrap", "wrap"),
        ]),
      ],
      [
        h.div(
          [
            a.styles([
              #("padding", "15px"),
            ]),
          ],
          [
            h.div([], [
              h.h2([], [h.text("Choose base resources")]),
              h.label([event.on_click(ClickFhirVersion(R4))], [
                h.input([
                  a.name("fhirversion"),
                  a.type_("radio"),
                  a.checked(True),
                ]),
                h.text("R4"),
              ]),
              h.label([event.on_click(ClickFhirVersion(R4B))], [
                h.input([a.name("fhirversion"), a.type_("radio")]),
                h.text("R4B"),
              ]),
              h.label([event.on_click(ClickFhirVersion(R5))], [
                h.input([a.name("fhirversion"), a.type_("radio")]),
                h.text("R5"),
              ]),
            ]),
            h.button([event.on_click(GenAll(DontGenerate, Bases))], [
              h.text("uncheck all"),
            ]),
            h.button([event.on_click(GenAll(Generate, Bases))], [
              h.text("check all"),
            ]),
            h.div(
              [
                a.styles([
                  #("height", "55vh"),
                  #("overflow", "auto"),
                  #("margin-top", "5px"),
                ]),
              ],
              list.map(model.base_resources, fn(resgen) {
                h.div([], [
                  h.label([], [
                    h.input([
                      event.on_check(fn(check) {
                        case check {
                          True -> GenResource(resgen.res, Generate, Bases)
                          False -> GenResource(resgen.res, DontGenerate, Bases)
                        }
                      }),
                      a.type_("checkbox"),
                      { a.checked(resgen.gen == Generate) },
                    ]),
                    h.text(resgen.res),
                  ]),
                ])
              }),
            ),
          ],
        ),
        h.div(
          [
            a.styles([
              #("padding", "15px"),
              #("width", "30em"),
              #("display", "flex"),
              #("flex-direction", "column"),
            ]),
          ],
          [
            h.h2([], [h.text("Download profile")]),
            h.input([
              a.disabled(model.download == Downloading || model.download == ParsingJsons),
              a.list("results"),
              event.on_input(SearchProfileInput) |> event.debounce(150),
              // a.name("package_name"),
              // event.on_submit(fn(values) {
              //   let assert Ok(name) = list.key_find(values, "package_name")
              //   DownloadPackageName(name)
              // }),
              event.on_change(DownloadPackageName),
            ]),
            h.datalist([a.id("results")], {
              let opts =
                list.fold(
                  from: [],
                  over: model.profile_search_results,
                  with: fn(outer_acc, pkg) {
                    list.fold(
                      from: outer_acc,
                      over: pkg.versions,
                      with: fn(inner_acc, version) {
                        [pkg.name <> "/" <> version, ..inner_acc]
                      },
                    )
                  },
                )
              list.map(opts, fn(opt) {
                h.option(
                  [
                    a.value(opt),
                  ],
                  opt,
                )
              })
            }),
            h.div(
              [
                a.style("margin-bottom", "5px"),
              ],
              [
                h.text(case model.download {
                  Downloading -> "downloading profile packages..."
                  ParsingJsons -> "parsing StructureDefinitions..."
                  NotInProgress ->
                    case model.simplifier_response_error {
                      None -> "search profile to download from simplifier.net"
                      Some(err) -> err
                    }
                }),
              ],
            ),
            h.div(
              [
                a.id("terminal"),
                a.styles([
                  #("display", "flex"),
                  // reversing flex direction keeps scrollbar on bottom, per my good friend see hat gippitty
                  // would do it with js but when running server component seems weird or idk
                  #("flex-direction", "column-reverse"),
                  #("height", "55vh"),
                  #("overflow", "auto"),
                ]),
              ],
              list.map(model.process_output, fn(line) {
                h.div([], [h.text(line)])
              }),
            ),
          ],
        ),
        h.div(
          [
            a.styles([
              #("padding", "15px"),
              #("width", "600px"),
            ]),
          ],
          case model.profile {
            None -> [element.none()]
            Some(profile) -> [
              h.h2([], [h.text("Choose profile resources")]),
              h.button([event.on_click(GenAll(DontGenerate, Profiles))], [
                h.text("uncheck all"),
              ]),
              h.button([event.on_click(GenAll(Generate, Profiles))], [
                h.text("check all"),
              ]),
              h.div(
                [
                  a.styles([
                    #("height", "55vh"),
                    #("overflow", "auto"),
                    #("margin-top", "5px"),
                  ]),
                ],
                list.map(profile.resources |> list.reverse, fn(resgen) {
                  h.div([], [
                    case resgen {
                      Error(err) -> h.text(err)
                      Ok(resgen) ->
                        h.div([], [
                          h.button([event.on_click(ClickEditResource(resgen))], [
                            h.text("edit"),
                          ]),
                          h.label([], [
                            h.input([
                              event.on_check(fn(check) {
                                case check {
                                  True ->
                                    GenResource(resgen.rg.res, Generate, Bases)
                                  False ->
                                    GenResource(
                                      resgen.rg.res,
                                      DontGenerate,
                                      Bases,
                                    )
                                }
                              }),
                              a.type_("checkbox"),
                              { a.checked(resgen.rg.gen == Generate) },
                            ]),
                            h.text(resgen.rg.res),
                          ]),
                        ])
                    },
                  ])
                }),
              ),
            ]
          },
        ),
        h.div(
          [
            a.styles([
              #("padding", "15px"),
              #("width", "90vw"),
            ]),
          ],
          [
            case get_edit_resource(model) {
              Error(_) -> element.none()
              Ok(editing_resource) ->
                h.div([], case editing_resource.structure.snapshot {
                  None -> [
                    h.text("no snapshot found for " <> editing_resource.rg.res),
                  ]
                  Some(snapshot) -> {
                    // crossing out 0..0 elts and their child elts
                    // could probably do this in one pass but oh well
                    let crossed_out_prefixes =
                      snapshot.element.rest
                      |> list.filter(fn(elt) { elt.max == Some("0") })
                    let crossed_out_prefixes = case snapshot.element.first.max {
                      Some("0") -> [
                        snapshot.element.first,
                        ..crossed_out_prefixes
                      ]
                      _ -> crossed_out_prefixes
                    }
                    let crossed_out_prefixes =
                      crossed_out_prefixes
                      |> list.filter_map(fn(elt) {
                        case elt.id {
                          Some(id) -> Ok(id)
                          None -> Error(Nil)
                        }
                      })

                    [
                      h.h2([], [h.text("Edit " <> editing_resource.rg.res)]),
                      h.div(
                        [
                          a.style("overflow", "auto"),
                          a.style("height", "75vh"),
                        ],
                        [
                          h.table(
                            [],
                            list.map(
                              [snapshot.element.first, ..snapshot.element.rest],
                              fn(elt) {
                                h.tr([], case elt.id {
                                  None -> [
                                    h.td([], [h.text(elt.path <> " has no id?")]),
                                  ]
                                  Some(elt_id) -> [
                                    h.td(
                                      [],
                                      case
                                        list.find(
                                          crossed_out_prefixes,
                                          fn(prefix) {
                                            elt_id |> string.starts_with(prefix)
                                          },
                                        )
                                      {
                                        Ok(_) -> [h.s([], [h.text(elt_id)])]
                                        Error(_) -> [h.text(elt_id)]
                                      },
                                    ),
                                    h.td([], case elt.min, elt.max {
                                      Some(min), Some(max) -> [
                                        h.input([
                                          event.on_change(fn(new_min) {
                                            RestrictMin(elt_id, new_min)
                                          }),
                                          a.style("width", "1em"),
                                          a.value(int.to_string(min)),
                                        ]),
                                        h.text(".."),
                                        h.input([
                                          event.on_change(fn(new_max) {
                                            RestrictMin(elt_id, new_max)
                                          }),
                                          a.style("width", "1em"),
                                          a.style("margin-right", "5px"),
                                          a.value(max),
                                        ]),
                                        cardinality_btn(elt_id, "0", "0"),
                                        cardinality_btn(elt_id, "0", "1"),
                                        cardinality_btn(elt_id, "0", "*"),
                                        cardinality_btn(elt_id, "1", "1"),
                                        cardinality_btn(elt_id, "1", "*"),
                                      ]
                                      _, _ -> [
                                        h.text(
                                          "does not have min/max cardinality in snapshot",
                                        ),
                                      ]
                                    }),
                                    h.td([], [
                                      h.text(
                                        elt.type_
                                        |> list.map(fn(elt_def_type) {
                                          elt_def_type.code
                                        })
                                        |> string.join(" "),
                                      ),
                                    ]),
                                  ]
                                })
                              },
                            ),
                          ),
                        ],
                      ),
                    ]
                  }
                })
            },
          ],
        ),
      ],
    )
  h.div([], [
    h.div(
      [
        a.style("display", "flex"),
        a.style("gap", "10px"),
        a.style("align-items", "flex-end"),
      ],
      [
        h.button(
          [
            a.disabled(model.generating == Generating),
            event.on_click(ClickGenerateCode),
          ],
          [
            h.h2(
              [
                a.style("width", "8em"),
              ],
              [
                case model.generating {
                  NotGenerating -> h.text("Generate code")
                  Generating -> h.text("Generating...")
                },
              ],
            ),
          ],
        ),
        h.label([], [
          h.input([a.style("width", "3em"), event.on_change(TypeCustomName)]),
          h.text("custom name module prefix"),
        ]),
      ],
    ),
    main,
  ])
}

fn cardinality_btn(elt_id, min, max) {
  h.button(
    [
      a.style("margin-left", "5px"),
      event.on_click(RestrictMinMax(elt_id, min, max)),
    ],
    [h.text(min <> ".." <> max)],
  )
}
