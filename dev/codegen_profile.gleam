import codegen_helpers
import filepath
import gleam/dict
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import gleam/string
import simplifile

type ProfileFiles {
  ProfileFiles(
    resources: dict.Dict(String, List(codegen_helpers.Resource)),
    extensions: dict.Dict(String, List(#(String, String))),
    // simple_exts: ext_name -> value[x] Element, for simple extensions
    // (those with a value[x] directly on Extension, no child slices)
    simple_exts: dict.Dict(String, codegen_helpers.Element),
  )
}

pub fn profile_files_to_types(
  custom_profile_name: String,
  profiles_dir: String,
  all_primitive_ext: Bool,
  valueset_acc: Set(String),
) -> #(String, Set(String)) {
  let assert Ok(files) = simplifile.read_directory(profiles_dir)
  let profile_structures =
    files
    |> list.filter(fn(f) { string.starts_with(f, "StructureDefinition") })
    |> list.fold(ProfileFiles(dict.new(), dict.new(), dict.new()), fn(acc, f) {
      let fname = profiles_dir |> filepath.join(f)
      let assert Ok(profile_structuredef) = simplifile.read(fname)
      let assert Ok(r) =
        json.parse(
          from: profile_structuredef,
          using: codegen_helpers.resource_decoder(),
        )
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
                  Error(_) -> dict.insert(ext_acc, ext_ctx.expression, [entry])
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
  echo profile_structures.extensions |> dict.keys
  echo profile_structures.resources |> dict.keys
  echo profile_structures.simple_exts |> dict.keys
  #("//abc", valueset_acc)
}
