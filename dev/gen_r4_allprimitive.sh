rm -rf generated_fhir && mkdir generated_fhir
gleam run -m codegen r4 customname=r4p allPrimitiveExt && gleam format
