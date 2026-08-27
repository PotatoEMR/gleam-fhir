codegen.gleam codegen_client.gleam codegen_profile.gleam important files

./dev/gen_everything.sh
gleam format
./dev/copy_src.sh

or ./dev/actual_everything_final_real.sh

gleam run -m codegen r4

gleam run -m codegen r4 download

gleam run -m codegen r4 r4b r5

gleam run -m codegen r4 custom=https://build.fhir.org/ig/HL7/US-Core/package.tgz customname=r4us && gleam format

beyond that you may have to mess with code yourself, not sure how profiles other than r4 come

valueset expansions from hl7.org/fhir/r4/hl7.fhir.r4.expansions.tgz

because we publish a bunch of example packages for fhir versions and http clients, it's a bit laborious, not terrible but you do have to run a bunch of scripts in order so ok maybe a bit terrible:
./dev/git_push_all_cores.sh
./dev/client_deps_from_repo.sh
./dev/git_push_all_clients.sh

todo - https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-practitioner.html

supposed to be 1..* identifier ie at least one identifier, but can be any of 3 different types

could do something like this

pub type UsCorePractitionerIdentifier {
  RegularIdentifier(UsCorePractitionerIdentifierRegular)
  NpiIdentifier(UsCorePractitionerIdentifierNpi)
  NcsbnidIdentifier(UsCorePractitionerIdentifierNcsbnid)
}
identifier: List1(UsCorePractitionerIdentifier)

but then ehh for blood pressure you would not want this because need to guarantuee one of each systolic and diastolic
I mean does anybody care idk

todo download valuesets such as http://loinc.org/LL379-9 from web
currently only download simplifier dependencies


dont destructure?

specific field error?
          _, _, _, _ ->
                  ct.FoundInvalid(
                   "UsCoreBloodPressure.component:diastolic valueQuantity should have value, unit, system, and code",
                 )

component same as base type, unneeded type and conversions that do nothing? particularly open slices

https://chat.fhir.org/#narrow/channel/179262-patient-empowerment/topic/US.20Core.20v8.20and.20Executive.20Order.2014166.3A.20.20what.20now.3F/near/495401257
