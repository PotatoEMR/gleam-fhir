rm -rf generated_fhir && mkdir generated_fhir
gleam run -m codegen r4 && gleam format
