# Custom Codegen

Download profile from simplifier using custom=name/version

```sh
gleam run -m codegen r4 custom=hl7.fhir.us.core/9.0.0 customname=r4us download
```

download arg downloads files, needed if running for first time

can generate primitive extensions by running with allPrimitiveExt arg (all elements) or putting element names in primitive_extension_list.txt (specific elements)
