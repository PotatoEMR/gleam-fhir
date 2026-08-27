#!/usr/bin/env bash

set -e

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
examples_dir="$(dirname "$repo_dir")/gleam-fhir-generated"

cd "$repo_dir"
rm -rf generated_fhir && mkdir generated_fhir
gleam run -m codegen r4 custom=hl7.fhir.us.core/7.0.0 customname=r4us7 && gleam format

# cp generated_fhir/r4us7/client_httpc.gleam "$examples_dir/r4us7_client_httpc/src/fhir/r4us7/client_httpc.gleam"
# cp generated_fhir/r4us7/client_rsvp.gleam "$examples_dir/r4us7_client_rsvp/src/fhir/r4us7/client_rsvp.gleam"

cp generated_fhir/r4us7/primitive_types.gleam "$examples_dir/r4us7/src/fhir/r4us7/primitive_types.gleam"
cp generated_fhir/r4us7/complex_types.gleam "$examples_dir/r4us7/src/fhir/r4us7/complex_types.gleam"
cp generated_fhir/r4us7/resources.gleam "$examples_dir/r4us7/src/fhir/r4us7/resources.gleam"
cp generated_fhir/r4us7/sansio.gleam "$examples_dir/r4us7/src/fhir/r4us7/sansio.gleam"
cp generated_fhir/r4us7/search_params.gleam "$examples_dir/r4us7/src/fhir/r4us7/search_params.gleam"
cp generated_fhir/r4us7/valuesets.gleam "$examples_dir/r4us7/src/fhir/r4us7/valuesets.gleam"

cd "$examples_dir/r4us7"
gleam check

# cd "$examples_dir/r4us7_client_httpc"
# gleam check

# cd "$examples_dir/r4us7_client_rsvp"
# gleam check
