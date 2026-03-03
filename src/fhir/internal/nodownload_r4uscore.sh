rm -rf src/generated_fhir
gleam run -m fhir/internal/codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4us && gleam format
