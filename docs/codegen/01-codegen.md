# Custom Codegen

Generate custom package for profile

```sh
gleam run -m fhir/internal/codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4us download && gleam format
```

download arg downloads files, needed if running for first time

if custom profile, automatically generates custom types for all downloaded extension StructureDefinition json files, can add extensions by putting StructureDefinition in src/fhir/internal/more_custom_extensions

can generate primitive extensions by running with allPrimitiveExt arg (all elements) or putting element names in primitive_extension_list.txt (specific elements)