## 0.1.0 Feb 07, 2026
- Breaking change: integer64 from `Int` to `String` in Gleam, as integer64 is sent as string in JSON, and is relatively uncommon, R5 only
- Add `search_any` in clients, which takes a flexible but not necessarily correct `String` rather than typed search parameters
- Add `operation_any` in clients, which similarly lets user choose operation name and parameters

## 0.0.0 Feb 01, 2026
- Gleam types for FHIR data types and resources
- JSON encoder and to_json functions
- Enums for valuesets with required binding
- Sans-io request/response for Create, Read, Update, Delete, Search
- Search parameter types for each resource, but basic params only
- Client layers over sans-io for httpc and rsvp
- Supports R4, R4B, R5
- Parses many valid FHIR JSON examples, but does *not* guarantee json -> encode -> to_json roundtrip will output same json as original, in particular there is a loss of implicit precision in decimal types, contrary to FHIR spec. At some point the decimal type will change, which will be a breaking change
- Uses String for Date and DateTime, which will at some point change to a real time type in a breaking change
- *No* primitive extensions support, so primitive elements will change in some undecided way
- This is an initial release with various problems, so there could be breaking changes in any module

[Version number MAJOR.MINOR.PATCH means:](https://semver.org/#semantic-versioning-200)

MAJOR - incompatible API changes

MINOR - backward-compatible functionality added

PATCH - backward-compatible bug fixes

Gleam fhir is a work in progress, tracking todo items at [https://github.com/PotatoEMR/gleam-fhir/issues](https://github.com/PotatoEMR/gleam-fhir/issues), if anything is incorrect, missing, or hard to use, please add an issue.
