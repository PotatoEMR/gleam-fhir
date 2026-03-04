import gleam/dynamic/decode
import gleam/json

pub fn check_roundtrip(
  in: String,
  thing_dec: decode.Decoder(a),
  thing_to_json,
  from_test: String,
) {
  let assert Ok(as_dynamic) = json.parse(in, decode.dynamic)
    as { from_test <> " check_roundtrip decode dynamic" }
  let assert Ok(as_thing) = json.parse(in, thing_dec)
    as { from_test <> " check_roundtrip decode thing" }

  let assert Ok(as_dynamic_roundtrip) =
    as_thing
    |> thing_to_json
    |> json.to_string
    |> json.parse(decode.dynamic)
  assert as_dynamic == as_dynamic_roundtrip
    as { from_test <> " check_roundtrip decode + encode roundtrip" }
}
