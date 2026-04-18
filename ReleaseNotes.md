## 0.5.0 April 17, 2026
- Add batch request that takes list of Request(Option(Json))
  - In order to create batch all requests go from String to Option(Json)
- Fix 0.4.0 bug where search/operation expect res_type but server returns different reosurc
- Add sansio get next paginated bundle, and httpc get all paginated bundles at once

## 0.4.0 April 12, 2026
- Change response parsing to check for resource of given type (eg AllergyIntolerance) or OperationOutcome rather than go off of http status
- Change delete operation response parsing
- - If no response body, can still return Ok response if http status code < 300
- - If response body has OperationOutcome, return it in Ok or Error depending on http status code < 300
- Separate sansio errors for creating request and parsing response

## 0.3.0 April 11, 2026
- Fix incorrect to_json for 1..1 choice type
- Parse date, dateTime, instant, and time into custom type, instead of String
- When parsing resource of potentially type, on failure, include resource type (eg Immunization) in DecodeError path

## 0.2.0 Mar 15, 2026
- Remove r4 and r4b to fit in hex.pm size limit (probably due to recent change https://github.com/hexpm/hex_core/commit/4383e1b08aaf7d6dd325154d02f91e37f55b16b4, modules need to be reorganized at some point for package size and compilation/LSP speed)
- Add custom types for complex extensions
- Add primitive extensions
- Add r4us with us core extensions
- Generate r4usp, but not publish due to size limit

## 0.1.0 Feb 07, 2026
- Change integer64 from `Int` to `String` in Gleam, as integer64 is sent as string in JSON, and is relatively uncommon, R5 only
- Remove unused `SpInclude` with _include and _revinclude from resource search params 
- Add `search_any` in clients, which takes a flexible (includes, modifiers, prefixes, etc.) but not necessarily correct `String` rather than statically typed search params
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

(once on 1.0.0) [Version number MAJOR.MINOR.PATCH means:](https://semver.org/#semantic-versioning-200)

MAJOR - incompatible API changes

MINOR - backward-compatible functionality added

PATCH - backward-compatible bug fixes

Gleam fhir is a work in progress, tracking todo items at [https://github.com/PotatoEMR/gleam-fhir/issues](https://github.com/PotatoEMR/gleam-fhir/issues), if anything is incorrect, missing, or hard to use, please add an issue.
