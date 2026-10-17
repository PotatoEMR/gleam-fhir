//// Check public declarations in generated primitive_types, complex_types, and
//// valuesets by following references from public declarations in resources.
////
//// gleam run -m check_unused_generated -- src/fhir/r4_gen
////
//// Exit status is 0 when all declarations are used, 1 when some are unused,
//// and 2 for input errors. Imports alone do not count as usage. Constructors
//// belong to their type. This command only reads files.
//// Functions ending in _new are omitted from the report. Functions ending in
//// _from_code are checked normally through their references.

import argv
import filepath
import glance
import gleam/bit_array
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/set.{type Set}
import gleam/string
import shellout
import simplifile

type Name =
  #(String, String)

type Scope {
  Scope(
    module_name: String,
    aliases: Dict(String, String),
    imports: Dict(String, Name),
    bound: Set(String),
  )
}

type Declaration {
  Declaration(kind: String, public: Bool, start: Int, references: Set(Name))
}

pub type Unused {
  Unused(module_name: String, name: String, kind: String, line: Int)
}

pub fn main() {
  case argv.load().arguments {
    [directory] -> {
      let sources =
        list.try_map(
          ["resources", "primitive_types", "complex_types", "valuesets"],
          fn(module_name) {
            let path = filepath.join(directory, module_name <> ".gleam")
            simplifile.read(path)
            |> result.map(fn(source) { #(module_name, source) })
            |> result.map_error(fn(error) {
              path <> ": " <> string.inspect(error)
            })
          },
        )
      case result.try(sources, unused) {
        Error(error) -> {
          io.println_error(error)
          shellout.exit(2)
        }
        Ok([]) ->
          io.println("All public declarations are used by resources.gleam.")
        Ok(declarations) -> {
          list.each(declarations, fn(declaration) {
            io.println(
              filepath.join(directory, declaration.module_name <> ".gleam")
              <> ":"
              <> int.to_string(declaration.line)
              <> ": unused pub "
              <> declaration.kind
              <> " "
              <> declaration.name,
            )
          })
          io.println(
            int.to_string(list.length(declarations))
            <> " unused public declarations.",
          )
          shellout.exit(1)
        }
      }
    }
    _ -> {
      io.println_error(
        "Usage: gleam run -m check_unused_generated -- DIRECTORY",
      )
      shellout.exit(2)
    }
  }
}

/// Sources are named resources, primitive_types, complex_types, and valuesets.
/// Includes private functions when following references, and ignores groups
/// which only refer to one another without being used by resources.
pub fn unused(
  sources: List(#(String, String)),
) -> Result(List(Unused), String) {
  use modules <- result.try(
    list.try_map(sources, fn(source) {
      glance.module(source.1)
      |> result.map(fn(module_) { #(source.0, module_) })
      |> result.map_error(fn(error) {
        source.0 <> ": " <> string.inspect(error)
      })
    }),
  )
  let module_names =
    list.map(modules, fn(module_) { module_.0 }) |> set.from_list
  use _ <- result.try(case set.contains(module_names, "resources") {
    True -> Ok(Nil)
    False -> Error("Missing resources.gleam")
  })
  let #(declarations, constructors) =
    list.fold(modules, #(dict.new(), dict.new()), fn(acc, entry) {
      let #(module_name, module_) = entry
      let #(aliases, imports) =
        list.fold(
          module_.imports,
          #(dict.new(), dict.new()),
          fn(acc, definition) {
            let #(aliases, imports) = acc
            let import_ = definition.definition
            let assert Ok(last) =
              import_.module |> string.split("/") |> list.last
            let target = case set.contains(module_names, last) {
              True -> last
              False -> import_.module
            }
            let aliases = case import_.alias {
              Some(glance.Discarded(_)) -> aliases
              Some(glance.Named(alias)) -> dict.insert(aliases, alias, target)
              None -> dict.insert(aliases, last, target)
            }
            let imports =
              list.fold(
                list.append(
                  import_.unqualified_types,
                  import_.unqualified_values,
                ),
                imports,
                fn(imports, item) {
                  dict.insert(imports, option.unwrap(item.alias, item.name), #(
                    target,
                    item.name,
                  ))
                },
              )
            #(aliases, imports)
          },
        )
      let scope = Scope(module_name, aliases, imports, set.new())
      let declarations =
        list.fold(module_.functions, acc.0, fn(declarations, definition) {
          let function = definition.definition
          let #(scope, refs) =
            list.fold(
              function.parameters,
              #(scope, set.new()),
              fn(acc, parameter) {
                let #(scope, refs) = acc
                let refs =
                  list.fold(
                    option.values([parameter.type_]),
                    refs,
                    fn(refs, type_) { type_references(type_, scope, refs) },
                  )
                #(bind_name(scope, parameter.name), refs)
              },
            )
          let refs =
            list.fold(option.values([function.return]), refs, fn(refs, type_) {
              type_references(type_, scope, refs)
            })
          let refs = statement_references(function.body, scope, refs)
          dict.insert(
            declarations,
            #(module_name, function.name),
            Declaration(
              "fn",
              function.publicity == glance.Public,
              function.location.start,
              refs,
            ),
          )
        })
      let declarations =
        list.fold(module_.constants, declarations, fn(declarations, definition) {
          let constant = definition.definition
          let refs =
            list.fold(
              option.values([constant.annotation]),
              set.new(),
              fn(refs, type_) { type_references(type_, scope, refs) },
            )
          let refs = expression_references(constant.value, scope, refs)
          dict.insert(
            declarations,
            #(module_name, constant.name),
            Declaration(
              "const",
              constant.publicity == glance.Public,
              constant.location.start,
              refs,
            ),
          )
        })
      let declarations =
        list.fold(
          module_.type_aliases,
          declarations,
          fn(declarations, definition) {
            let alias = definition.definition
            dict.insert(
              declarations,
              #(module_name, alias.name),
              Declaration(
                "type",
                alias.publicity == glance.Public,
                alias.location.start,
                type_references(alias.aliased, scope, set.new()),
              ),
            )
          },
        )
      list.fold(
        module_.custom_types,
        #(declarations, acc.1),
        fn(acc, definition) {
          let type_ = definition.definition
          let key = #(module_name, type_.name)
          let #(refs, constructors) =
            list.fold(type_.variants, #(set.new(), acc.1), fn(acc, variant) {
              let refs =
                list.fold(variant.fields, acc.0, fn(refs, field) {
                  case field {
                    glance.LabelledVariantField(type_, _)
                    | glance.UnlabelledVariantField(type_) ->
                      type_references(type_, scope, refs)
                  }
                })
              #(refs, dict.insert(acc.1, #(module_name, variant.name), key))
            })
          #(
            dict.insert(
              acc.0,
              key,
              Declaration(
                "type",
                type_.publicity == glance.Public,
                type_.location.start,
                refs,
              ),
            ),
            constructors,
          )
        },
      )
    })
  let roots =
    declarations
    |> dict.to_list
    |> list.filter_map(fn(entry) {
      case entry.0.0 == "resources" && entry.1.public {
        True -> Ok(entry.0)
        False -> Error(Nil)
      }
    })
  let used = follow(roots, declarations, constructors, set.new())
  let sources = dict.from_list(sources)
  declarations
  |> dict.to_list
  |> list.filter_map(fn(entry) {
    let #(key, declaration) = entry
    let is_new = declaration.kind == "fn" && string.ends_with(key.1, "_new")
    case
      key.0 != "resources"
      && declaration.public
      && !set.contains(used, key)
      && !is_new
    {
      False -> Error(Nil)
      True -> {
        let assert Ok(source) = dict.get(sources, key.0)
        let assert Ok(prefix) =
          source
          |> bit_array.from_string
          |> bit_array.slice(0, declaration.start)
        let assert Ok(prefix) = bit_array.to_string(prefix)
        let line = prefix |> string.split("\n") |> list.length
        Ok(Unused(key.0, key.1, declaration.kind, line))
      }
    }
  })
  |> list.sort(fn(a, b) {
    case string.compare(a.module_name, b.module_name) {
      order.Eq -> int.compare(a.line, b.line)
      order -> order
    }
  })
  |> Ok
}

fn follow(
  pending: List(Name),
  declarations: Dict(Name, Declaration),
  constructors: Dict(Name, Name),
  used: Set(Name),
) -> Set(Name) {
  case pending {
    [] -> used
    [name, ..rest] -> {
      let name = dict.get(constructors, name) |> result.unwrap(name)
      case set.contains(used, name), dict.get(declarations, name) {
        True, _ | _, Error(_) -> follow(rest, declarations, constructors, used)
        False, Ok(declaration) ->
          follow(
            list.fold(set.to_list(declaration.references), rest, fn(rest, ref) {
              [ref, ..rest]
            }),
            declarations,
            constructors,
            set.insert(used, name),
          )
      }
    }
  }
}

fn bind_name(scope: Scope, name: glance.AssignmentName) -> Scope {
  case name {
    glance.Named(name) -> Scope(..scope, bound: set.insert(scope.bound, name))
    glance.Discarded(_) -> scope
  }
}

fn reference(
  module_: Option(String),
  name: String,
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  case module_ {
    None ->
      case set.contains(scope.bound, name) {
        True -> refs
        False ->
          set.insert(
            refs,
            dict.get(scope.imports, name)
              |> result.unwrap(#(scope.module_name, name)),
          )
      }
    Some(alias) ->
      case set.contains(scope.bound, alias), dict.get(scope.aliases, alias) {
        False, Ok(module_name) -> set.insert(refs, #(module_name, name))
        _, _ -> refs
      }
  }
}

fn type_references(
  type_: glance.Type,
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  case type_ {
    glance.NamedType(_, name, module_, parameters) -> {
      let refs =
        reference(module_, name, Scope(..scope, bound: set.new()), refs)
      list.fold(parameters, refs, fn(refs, type_) {
        type_references(type_, scope, refs)
      })
    }
    glance.TupleType(_, elements) ->
      list.fold(elements, refs, fn(refs, type_) {
        type_references(type_, scope, refs)
      })
    glance.FunctionType(_, parameters, return) -> {
      let refs =
        list.fold(parameters, refs, fn(refs, type_) {
          type_references(type_, scope, refs)
        })
      type_references(return, scope, refs)
    }
    glance.VariableType(..) | glance.HoleType(..) -> refs
  }
}

fn statement_references(
  statements: List(glance.Statement),
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  case statements {
    [] -> refs
    [statement, ..rest] -> {
      let #(scope, refs) = case statement {
        glance.Expression(expression) -> #(
          scope,
          expression_references(expression, scope, refs),
        )
        glance.Assert(_, expression, message) -> {
          let refs = expression_references(expression, scope, refs)
          #(
            scope,
            list.fold(option.values([message]), refs, fn(refs, expression) {
              expression_references(expression, scope, refs)
            }),
          )
        }
        glance.Assignment(_, kind, pattern, annotation, value) -> {
          let refs = expression_references(value, scope, refs)
          let refs =
            list.fold(option.values([annotation]), refs, fn(refs, type_) {
              type_references(type_, scope, refs)
            })
          let refs = case kind {
            glance.Let -> refs
            glance.LetAssert(message) ->
              list.fold(option.values([message]), refs, fn(refs, expression) {
                expression_references(expression, scope, refs)
              })
          }
          pattern_references(pattern, scope, refs)
        }
        glance.Use(_, patterns, function) -> {
          let refs = expression_references(function, scope, refs)
          list.fold(patterns, #(scope, refs), fn(acc, pattern) {
            let refs =
              list.fold(
                option.values([pattern.annotation]),
                acc.1,
                fn(refs, type_) { type_references(type_, acc.0, refs) },
              )
            pattern_references(pattern.pattern, acc.0, refs)
          })
        }
      }
      statement_references(rest, scope, refs)
    }
  }
}

fn pattern_references(
  pattern: glance.Pattern,
  scope: Scope,
  refs: Set(Name),
) -> #(Scope, Set(Name)) {
  case pattern {
    glance.PatternVariable(_, name) -> #(
      bind_name(scope, glance.Named(name)),
      refs,
    )
    glance.PatternAssignment(_, pattern, name) -> {
      let #(scope, refs) = pattern_references(pattern, scope, refs)
      #(bind_name(scope, glance.Named(name)), refs)
    }
    glance.PatternTuple(_, elements) ->
      list.fold(elements, #(scope, refs), fn(acc, pattern) {
        pattern_references(pattern, acc.0, acc.1)
      })
    glance.PatternList(_, elements, tail) ->
      list.fold(
        list.append(elements, option.values([tail])),
        #(scope, refs),
        fn(acc, pattern) { pattern_references(pattern, acc.0, acc.1) },
      )
    glance.PatternConcatenate(_, _, prefix_name, rest_name) -> {
      let scope = list.fold(option.values([prefix_name]), scope, bind_name)
      #(bind_name(scope, rest_name), refs)
    }
    glance.PatternVariant(_, module_, constructor, arguments, _) -> {
      let refs = reference(module_, constructor, scope, refs)
      list.fold(arguments, #(scope, refs), fn(acc, field) {
        case field {
          glance.LabelledField(_, _, pattern)
          | glance.UnlabelledField(pattern) ->
            pattern_references(pattern, acc.0, acc.1)
          glance.ShorthandField(name, _) -> #(
            bind_name(acc.0, glance.Named(name)),
            acc.1,
          )
        }
      })
    }
    glance.PatternBitString(_, segments) ->
      list.fold(segments, #(scope, refs), fn(acc, segment) {
        let refs =
          list.fold(segment.1, acc.1, fn(refs, option_) {
            case option_ {
              glance.SizeValueOption(size) -> size_references(size, acc.0, refs)
              _ -> refs
            }
          })
        pattern_references(segment.0, acc.0, refs)
      })
    glance.PatternInt(..)
    | glance.PatternFloat(..)
    | glance.PatternString(..)
    | glance.PatternDiscard(..) -> #(scope, refs)
  }
}

fn size_references(
  size: glance.BitArraySize,
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  case size {
    glance.BitArraySizeInt(..) -> refs
    glance.BitArraySizeVariable(_, name) -> reference(None, name, scope, refs)
    glance.BitArraySizeBlock(_, inner) -> size_references(inner, scope, refs)
    glance.BitArraySizeBinaryOperator(_, _, left, right) -> {
      let refs = size_references(left, scope, refs)
      size_references(right, scope, refs)
    }
  }
}

fn field_references(
  fields: List(glance.Field(glance.Expression)),
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  list.fold(fields, refs, fn(refs, field) {
    case field {
      glance.LabelledField(_, _, value) | glance.UnlabelledField(value) ->
        expression_references(value, scope, refs)
      glance.ShorthandField(name, _) -> reference(None, name, scope, refs)
    }
  })
}

fn expression_references(
  expression: glance.Expression,
  scope: Scope,
  refs: Set(Name),
) -> Set(Name) {
  case expression {
    glance.Int(..) | glance.Float(..) | glance.String(..) -> refs
    glance.Variable(_, name) -> reference(None, name, scope, refs)
    glance.NegateInt(_, value)
    | glance.NegateBool(_, value)
    | glance.TupleIndex(_, value, _) ->
      expression_references(value, scope, refs)
    glance.Block(_, statements) -> statement_references(statements, scope, refs)
    glance.Panic(_, message) | glance.Todo(_, message) ->
      list.fold(option.values([message]), refs, fn(refs, expression) {
        expression_references(expression, scope, refs)
      })
    glance.Echo(_, expression, message) ->
      list.fold(
        list.append(option.values([expression]), option.values([message])),
        refs,
        fn(refs, expression) { expression_references(expression, scope, refs) },
      )
    glance.Tuple(_, elements) ->
      list.fold(elements, refs, fn(refs, expression) {
        expression_references(expression, scope, refs)
      })
    glance.List(_, elements, rest) -> {
      let refs =
        list.fold(elements, refs, fn(refs, expression) {
          expression_references(expression, scope, refs)
        })
      list.fold(option.values([rest]), refs, fn(refs, expression) {
        expression_references(expression, scope, refs)
      })
    }
    glance.Fn(_, arguments, return_annotation, body) -> {
      let #(scope, refs) =
        list.fold(arguments, #(scope, refs), fn(acc, argument) {
          let refs =
            list.fold(option.values([argument.type_]), acc.1, fn(refs, type_) {
              type_references(type_, acc.0, refs)
            })
          #(bind_name(acc.0, argument.name), refs)
        })
      let refs =
        list.fold(option.values([return_annotation]), refs, fn(refs, type_) {
          type_references(type_, scope, refs)
        })
      statement_references(body, scope, refs)
    }
    glance.FieldAccess(_, glance.Variable(_, alias), label) -> {
      case
        dict.has_key(scope.aliases, alias) && !set.contains(scope.bound, alias)
      {
        True -> reference(Some(alias), label, scope, refs)
        False -> reference(None, alias, scope, refs)
      }
    }
    glance.FieldAccess(_, container, _) ->
      expression_references(container, scope, refs)
    glance.Call(_, function, arguments) -> {
      let refs = expression_references(function, scope, refs)
      field_references(arguments, scope, refs)
    }
    glance.FnCapture(_, _, function, before, after) -> {
      let refs = expression_references(function, scope, refs)
      let refs = field_references(before, scope, refs)
      field_references(after, scope, refs)
    }
    glance.BinaryOperator(_, _, left, right) -> {
      let refs = expression_references(left, scope, refs)
      expression_references(right, scope, refs)
    }
    glance.RecordUpdate(_, module_, constructor, record, fields) -> {
      let refs = reference(module_, constructor, scope, refs)
      let refs = expression_references(record, scope, refs)
      list.fold(fields, refs, fn(refs, field) {
        case field.item {
          Some(value) -> expression_references(value, scope, refs)
          None -> reference(None, field.label, scope, refs)
        }
      })
    }
    glance.BitString(_, segments) ->
      list.fold(segments, refs, fn(refs, segment) {
        let refs = expression_references(segment.0, scope, refs)
        list.fold(segment.1, refs, fn(refs, option_) {
          case option_ {
            glance.SizeValueOption(value) ->
              expression_references(value, scope, refs)
            _ -> refs
          }
        })
      })
    glance.Case(_, subjects, clauses) -> {
      let refs =
        list.fold(subjects, refs, fn(refs, expression) {
          expression_references(expression, scope, refs)
        })
      list.fold(clauses, refs, fn(refs, clause) {
        let #(scope, refs) =
          list.fold(
            list.flatten(clause.patterns),
            #(scope, refs),
            fn(acc, pattern) { pattern_references(pattern, acc.0, acc.1) },
          )
        let refs =
          list.fold(option.values([clause.guard]), refs, fn(refs, expression) {
            expression_references(expression, scope, refs)
          })
        expression_references(clause.body, scope, refs)
      })
    }
  }
}
