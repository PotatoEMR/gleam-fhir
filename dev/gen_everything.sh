rm -rf generated_fhir && mkdir generated_fhir
gleam run -m codegen r4 r4b r5 download
gleam run -m codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz download customname=r4us
gleam run -m codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4usp allPrimitiveExt
