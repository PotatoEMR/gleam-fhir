rm -rf generated_fhir && mkdir generated_fhir
gleam run -m codegen r4 custom=hl7.fhir.us.core/9.0.0 customname=r4us download && gleam format
