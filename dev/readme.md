./dev/gen_everything.sh
gleam format
./dev/copy_src.sh

or ./dev/actual_everything_final_real.sh

gleam run -m codegen r4

gleam run -m codegen r4 download

gleam run -m codegen r4 r4b r5

gleam run -m codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4us && gleam format

beyond that you may have to mess with code yourself, not sure how profiles other than r4 come

valueset expansions from hl7.org/fhir/r4/hl7.fhir.r4.expansions.tgz

because we publish a bunch of example packages for fhir versions and http clients, it's a bit laborious, not terrible but you do have to run a bunch of scripts in order so ok maybe a bit terrible:
./dev/git_push_all_cores.sh
./dev/client_deps_from_repo.sh
./dev/git_push_all_clients.sh
