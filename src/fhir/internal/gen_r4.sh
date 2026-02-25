rm -rf src/generated_fhir
gleam run -m fhir/internal/codegen r4 && gleam format
