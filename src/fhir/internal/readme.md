gleam run -m fhir/internal/codegen r4

gleam run -m fhir/internal/codegen r4 download

gleam run -m fhir/internal/codegen r4 r4b r5

gleam run -m fhir/internal/codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4us && gleam format

beyond that you may have to mess with code yourself, not sure how profiles other than r4 come

valueset expansions from hl7.org/fhir/r4/hl7.fhir.r4.expansions.tgz
