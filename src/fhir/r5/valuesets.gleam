////[https://hl7.org/fhir/r5](https://hl7.org/fhir/r5) valuesets

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}

pub type Accountstatus {
  AccountstatusActive
  AccountstatusInactive
  AccountstatusEnteredinerror
  AccountstatusOnhold
  AccountstatusUnknown
}

pub fn accountstatus_to_json(accountstatus: Accountstatus) -> Json {
  json.string(accountstatus_to_string(accountstatus))
}

pub fn accountstatus_to_string(accountstatus: Accountstatus) -> String {
  case accountstatus {
    AccountstatusActive -> "active"
    AccountstatusInactive -> "inactive"
    AccountstatusEnteredinerror -> "entered-in-error"
    AccountstatusOnhold -> "on-hold"
    AccountstatusUnknown -> "unknown"
  }
}

pub fn accountstatus_from_string(s: String) -> Result(Accountstatus, Nil) {
  case s {
    "active" -> Ok(AccountstatusActive)
    "inactive" -> Ok(AccountstatusInactive)
    "entered-in-error" -> Ok(AccountstatusEnteredinerror)
    "on-hold" -> Ok(AccountstatusOnhold)
    "unknown" -> Ok(AccountstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn accountstatus_decoder() -> Decoder(Accountstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(AccountstatusActive)
    "inactive" -> decode.success(AccountstatusInactive)
    "entered-in-error" -> decode.success(AccountstatusEnteredinerror)
    "on-hold" -> decode.success(AccountstatusOnhold)
    "unknown" -> decode.success(AccountstatusUnknown)
    _ -> decode.failure(AccountstatusActive, "Accountstatus")
  }
}

pub type Actioncardinalitybehavior {
  ActioncardinalitybehaviorSingle
  ActioncardinalitybehaviorMultiple
}

pub fn actioncardinalitybehavior_to_json(
  actioncardinalitybehavior: Actioncardinalitybehavior,
) -> Json {
  json.string(actioncardinalitybehavior_to_string(actioncardinalitybehavior))
}

pub fn actioncardinalitybehavior_to_string(
  actioncardinalitybehavior: Actioncardinalitybehavior,
) -> String {
  case actioncardinalitybehavior {
    ActioncardinalitybehaviorSingle -> "single"
    ActioncardinalitybehaviorMultiple -> "multiple"
  }
}

pub fn actioncardinalitybehavior_from_string(
  s: String,
) -> Result(Actioncardinalitybehavior, Nil) {
  case s {
    "single" -> Ok(ActioncardinalitybehaviorSingle)
    "multiple" -> Ok(ActioncardinalitybehaviorMultiple)
    _ -> Error(Nil)
  }
}

pub fn actioncardinalitybehavior_decoder() -> Decoder(Actioncardinalitybehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "single" -> decode.success(ActioncardinalitybehaviorSingle)
    "multiple" -> decode.success(ActioncardinalitybehaviorMultiple)
    _ ->
      decode.failure(
        ActioncardinalitybehaviorSingle,
        "Actioncardinalitybehavior",
      )
  }
}

pub type Actionconditionkind {
  ActionconditionkindApplicability
  ActionconditionkindStart
  ActionconditionkindStop
}

pub fn actionconditionkind_to_json(
  actionconditionkind: Actionconditionkind,
) -> Json {
  json.string(actionconditionkind_to_string(actionconditionkind))
}

pub fn actionconditionkind_to_string(
  actionconditionkind: Actionconditionkind,
) -> String {
  case actionconditionkind {
    ActionconditionkindApplicability -> "applicability"
    ActionconditionkindStart -> "start"
    ActionconditionkindStop -> "stop"
  }
}

pub fn actionconditionkind_from_string(
  s: String,
) -> Result(Actionconditionkind, Nil) {
  case s {
    "applicability" -> Ok(ActionconditionkindApplicability)
    "start" -> Ok(ActionconditionkindStart)
    "stop" -> Ok(ActionconditionkindStop)
    _ -> Error(Nil)
  }
}

pub fn actionconditionkind_decoder() -> Decoder(Actionconditionkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "applicability" -> decode.success(ActionconditionkindApplicability)
    "start" -> decode.success(ActionconditionkindStart)
    "stop" -> decode.success(ActionconditionkindStop)
    _ -> decode.failure(ActionconditionkindApplicability, "Actionconditionkind")
  }
}

pub type Actiongroupingbehavior {
  ActiongroupingbehaviorVisualgroup
  ActiongroupingbehaviorLogicalgroup
  ActiongroupingbehaviorSentencegroup
}

pub fn actiongroupingbehavior_to_json(
  actiongroupingbehavior: Actiongroupingbehavior,
) -> Json {
  json.string(actiongroupingbehavior_to_string(actiongroupingbehavior))
}

pub fn actiongroupingbehavior_to_string(
  actiongroupingbehavior: Actiongroupingbehavior,
) -> String {
  case actiongroupingbehavior {
    ActiongroupingbehaviorVisualgroup -> "visual-group"
    ActiongroupingbehaviorLogicalgroup -> "logical-group"
    ActiongroupingbehaviorSentencegroup -> "sentence-group"
  }
}

pub fn actiongroupingbehavior_from_string(
  s: String,
) -> Result(Actiongroupingbehavior, Nil) {
  case s {
    "visual-group" -> Ok(ActiongroupingbehaviorVisualgroup)
    "logical-group" -> Ok(ActiongroupingbehaviorLogicalgroup)
    "sentence-group" -> Ok(ActiongroupingbehaviorSentencegroup)
    _ -> Error(Nil)
  }
}

pub fn actiongroupingbehavior_decoder() -> Decoder(Actiongroupingbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "visual-group" -> decode.success(ActiongroupingbehaviorVisualgroup)
    "logical-group" -> decode.success(ActiongroupingbehaviorLogicalgroup)
    "sentence-group" -> decode.success(ActiongroupingbehaviorSentencegroup)
    _ ->
      decode.failure(
        ActiongroupingbehaviorVisualgroup,
        "Actiongroupingbehavior",
      )
  }
}

pub type Actionparticipanttype {
  ActionparticipanttypeCareteam
  ActionparticipanttypeDevice
  ActionparticipanttypeGroup
  ActionparticipanttypeHealthcareservice
  ActionparticipanttypeLocation
  ActionparticipanttypeOrganization
  ActionparticipanttypePatient
  ActionparticipanttypePractitioner
  ActionparticipanttypePractitionerrole
  ActionparticipanttypeRelatedperson
}

pub fn actionparticipanttype_to_json(
  actionparticipanttype: Actionparticipanttype,
) -> Json {
  json.string(actionparticipanttype_to_string(actionparticipanttype))
}

pub fn actionparticipanttype_to_string(
  actionparticipanttype: Actionparticipanttype,
) -> String {
  case actionparticipanttype {
    ActionparticipanttypeCareteam -> "careteam"
    ActionparticipanttypeDevice -> "device"
    ActionparticipanttypeGroup -> "group"
    ActionparticipanttypeHealthcareservice -> "healthcareservice"
    ActionparticipanttypeLocation -> "location"
    ActionparticipanttypeOrganization -> "organization"
    ActionparticipanttypePatient -> "patient"
    ActionparticipanttypePractitioner -> "practitioner"
    ActionparticipanttypePractitionerrole -> "practitionerrole"
    ActionparticipanttypeRelatedperson -> "relatedperson"
  }
}

pub fn actionparticipanttype_from_string(
  s: String,
) -> Result(Actionparticipanttype, Nil) {
  case s {
    "careteam" -> Ok(ActionparticipanttypeCareteam)
    "device" -> Ok(ActionparticipanttypeDevice)
    "group" -> Ok(ActionparticipanttypeGroup)
    "healthcareservice" -> Ok(ActionparticipanttypeHealthcareservice)
    "location" -> Ok(ActionparticipanttypeLocation)
    "organization" -> Ok(ActionparticipanttypeOrganization)
    "patient" -> Ok(ActionparticipanttypePatient)
    "practitioner" -> Ok(ActionparticipanttypePractitioner)
    "practitionerrole" -> Ok(ActionparticipanttypePractitionerrole)
    "relatedperson" -> Ok(ActionparticipanttypeRelatedperson)
    _ -> Error(Nil)
  }
}

pub fn actionparticipanttype_decoder() -> Decoder(Actionparticipanttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "careteam" -> decode.success(ActionparticipanttypeCareteam)
    "device" -> decode.success(ActionparticipanttypeDevice)
    "group" -> decode.success(ActionparticipanttypeGroup)
    "healthcareservice" ->
      decode.success(ActionparticipanttypeHealthcareservice)
    "location" -> decode.success(ActionparticipanttypeLocation)
    "organization" -> decode.success(ActionparticipanttypeOrganization)
    "patient" -> decode.success(ActionparticipanttypePatient)
    "practitioner" -> decode.success(ActionparticipanttypePractitioner)
    "practitionerrole" -> decode.success(ActionparticipanttypePractitionerrole)
    "relatedperson" -> decode.success(ActionparticipanttypeRelatedperson)
    _ -> decode.failure(ActionparticipanttypeCareteam, "Actionparticipanttype")
  }
}

pub type Actionprecheckbehavior {
  ActionprecheckbehaviorYes
  ActionprecheckbehaviorNo
}

pub fn actionprecheckbehavior_to_json(
  actionprecheckbehavior: Actionprecheckbehavior,
) -> Json {
  json.string(actionprecheckbehavior_to_string(actionprecheckbehavior))
}

pub fn actionprecheckbehavior_to_string(
  actionprecheckbehavior: Actionprecheckbehavior,
) -> String {
  case actionprecheckbehavior {
    ActionprecheckbehaviorYes -> "yes"
    ActionprecheckbehaviorNo -> "no"
  }
}

pub fn actionprecheckbehavior_from_string(
  s: String,
) -> Result(Actionprecheckbehavior, Nil) {
  case s {
    "yes" -> Ok(ActionprecheckbehaviorYes)
    "no" -> Ok(ActionprecheckbehaviorNo)
    _ -> Error(Nil)
  }
}

pub fn actionprecheckbehavior_decoder() -> Decoder(Actionprecheckbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "yes" -> decode.success(ActionprecheckbehaviorYes)
    "no" -> decode.success(ActionprecheckbehaviorNo)
    _ -> decode.failure(ActionprecheckbehaviorYes, "Actionprecheckbehavior")
  }
}

pub type Actionrelationshiptype {
  ActionrelationshiptypeBefore
  ActionrelationshiptypeBeforestart
  ActionrelationshiptypeBeforeend
  ActionrelationshiptypeConcurrent
  ActionrelationshiptypeConcurrentwithstart
  ActionrelationshiptypeConcurrentwithend
  ActionrelationshiptypeAfter
  ActionrelationshiptypeAfterstart
  ActionrelationshiptypeAfterend
}

pub fn actionrelationshiptype_to_json(
  actionrelationshiptype: Actionrelationshiptype,
) -> Json {
  json.string(actionrelationshiptype_to_string(actionrelationshiptype))
}

pub fn actionrelationshiptype_to_string(
  actionrelationshiptype: Actionrelationshiptype,
) -> String {
  case actionrelationshiptype {
    ActionrelationshiptypeBefore -> "before"
    ActionrelationshiptypeBeforestart -> "before-start"
    ActionrelationshiptypeBeforeend -> "before-end"
    ActionrelationshiptypeConcurrent -> "concurrent"
    ActionrelationshiptypeConcurrentwithstart -> "concurrent-with-start"
    ActionrelationshiptypeConcurrentwithend -> "concurrent-with-end"
    ActionrelationshiptypeAfter -> "after"
    ActionrelationshiptypeAfterstart -> "after-start"
    ActionrelationshiptypeAfterend -> "after-end"
  }
}

pub fn actionrelationshiptype_from_string(
  s: String,
) -> Result(Actionrelationshiptype, Nil) {
  case s {
    "before" -> Ok(ActionrelationshiptypeBefore)
    "before-start" -> Ok(ActionrelationshiptypeBeforestart)
    "before-end" -> Ok(ActionrelationshiptypeBeforeend)
    "concurrent" -> Ok(ActionrelationshiptypeConcurrent)
    "concurrent-with-start" -> Ok(ActionrelationshiptypeConcurrentwithstart)
    "concurrent-with-end" -> Ok(ActionrelationshiptypeConcurrentwithend)
    "after" -> Ok(ActionrelationshiptypeAfter)
    "after-start" -> Ok(ActionrelationshiptypeAfterstart)
    "after-end" -> Ok(ActionrelationshiptypeAfterend)
    _ -> Error(Nil)
  }
}

pub fn actionrelationshiptype_decoder() -> Decoder(Actionrelationshiptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "before" -> decode.success(ActionrelationshiptypeBefore)
    "before-start" -> decode.success(ActionrelationshiptypeBeforestart)
    "before-end" -> decode.success(ActionrelationshiptypeBeforeend)
    "concurrent" -> decode.success(ActionrelationshiptypeConcurrent)
    "concurrent-with-start" ->
      decode.success(ActionrelationshiptypeConcurrentwithstart)
    "concurrent-with-end" ->
      decode.success(ActionrelationshiptypeConcurrentwithend)
    "after" -> decode.success(ActionrelationshiptypeAfter)
    "after-start" -> decode.success(ActionrelationshiptypeAfterstart)
    "after-end" -> decode.success(ActionrelationshiptypeAfterend)
    _ -> decode.failure(ActionrelationshiptypeBefore, "Actionrelationshiptype")
  }
}

pub type Actionrequiredbehavior {
  ActionrequiredbehaviorMust
  ActionrequiredbehaviorCould
  ActionrequiredbehaviorMustunlessdocumented
}

pub fn actionrequiredbehavior_to_json(
  actionrequiredbehavior: Actionrequiredbehavior,
) -> Json {
  json.string(actionrequiredbehavior_to_string(actionrequiredbehavior))
}

pub fn actionrequiredbehavior_to_string(
  actionrequiredbehavior: Actionrequiredbehavior,
) -> String {
  case actionrequiredbehavior {
    ActionrequiredbehaviorMust -> "must"
    ActionrequiredbehaviorCould -> "could"
    ActionrequiredbehaviorMustunlessdocumented -> "must-unless-documented"
  }
}

pub fn actionrequiredbehavior_from_string(
  s: String,
) -> Result(Actionrequiredbehavior, Nil) {
  case s {
    "must" -> Ok(ActionrequiredbehaviorMust)
    "could" -> Ok(ActionrequiredbehaviorCould)
    "must-unless-documented" -> Ok(ActionrequiredbehaviorMustunlessdocumented)
    _ -> Error(Nil)
  }
}

pub fn actionrequiredbehavior_decoder() -> Decoder(Actionrequiredbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "must" -> decode.success(ActionrequiredbehaviorMust)
    "could" -> decode.success(ActionrequiredbehaviorCould)
    "must-unless-documented" ->
      decode.success(ActionrequiredbehaviorMustunlessdocumented)
    _ -> decode.failure(ActionrequiredbehaviorMust, "Actionrequiredbehavior")
  }
}

pub type Actionselectionbehavior {
  ActionselectionbehaviorAny
  ActionselectionbehaviorAll
  ActionselectionbehaviorAllornone
  ActionselectionbehaviorExactlyone
  ActionselectionbehaviorAtmostone
  ActionselectionbehaviorOneormore
}

pub fn actionselectionbehavior_to_json(
  actionselectionbehavior: Actionselectionbehavior,
) -> Json {
  json.string(actionselectionbehavior_to_string(actionselectionbehavior))
}

pub fn actionselectionbehavior_to_string(
  actionselectionbehavior: Actionselectionbehavior,
) -> String {
  case actionselectionbehavior {
    ActionselectionbehaviorAny -> "any"
    ActionselectionbehaviorAll -> "all"
    ActionselectionbehaviorAllornone -> "all-or-none"
    ActionselectionbehaviorExactlyone -> "exactly-one"
    ActionselectionbehaviorAtmostone -> "at-most-one"
    ActionselectionbehaviorOneormore -> "one-or-more"
  }
}

pub fn actionselectionbehavior_from_string(
  s: String,
) -> Result(Actionselectionbehavior, Nil) {
  case s {
    "any" -> Ok(ActionselectionbehaviorAny)
    "all" -> Ok(ActionselectionbehaviorAll)
    "all-or-none" -> Ok(ActionselectionbehaviorAllornone)
    "exactly-one" -> Ok(ActionselectionbehaviorExactlyone)
    "at-most-one" -> Ok(ActionselectionbehaviorAtmostone)
    "one-or-more" -> Ok(ActionselectionbehaviorOneormore)
    _ -> Error(Nil)
  }
}

pub fn actionselectionbehavior_decoder() -> Decoder(Actionselectionbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "any" -> decode.success(ActionselectionbehaviorAny)
    "all" -> decode.success(ActionselectionbehaviorAll)
    "all-or-none" -> decode.success(ActionselectionbehaviorAllornone)
    "exactly-one" -> decode.success(ActionselectionbehaviorExactlyone)
    "at-most-one" -> decode.success(ActionselectionbehaviorAtmostone)
    "one-or-more" -> decode.success(ActionselectionbehaviorOneormore)
    _ -> decode.failure(ActionselectionbehaviorAny, "Actionselectionbehavior")
  }
}

pub type Additionalbindingpurpose {
  AdditionalbindingpurposeMaximum
  AdditionalbindingpurposeMinimum
  AdditionalbindingpurposeRequired
  AdditionalbindingpurposeExtensible
  AdditionalbindingpurposeCandidate
  AdditionalbindingpurposeCurrent
  AdditionalbindingpurposePreferred
  AdditionalbindingpurposeUi
  AdditionalbindingpurposeStarter
  AdditionalbindingpurposeComponent
}

pub fn additionalbindingpurpose_to_json(
  additionalbindingpurpose: Additionalbindingpurpose,
) -> Json {
  json.string(additionalbindingpurpose_to_string(additionalbindingpurpose))
}

pub fn additionalbindingpurpose_to_string(
  additionalbindingpurpose: Additionalbindingpurpose,
) -> String {
  case additionalbindingpurpose {
    AdditionalbindingpurposeMaximum -> "maximum"
    AdditionalbindingpurposeMinimum -> "minimum"
    AdditionalbindingpurposeRequired -> "required"
    AdditionalbindingpurposeExtensible -> "extensible"
    AdditionalbindingpurposeCandidate -> "candidate"
    AdditionalbindingpurposeCurrent -> "current"
    AdditionalbindingpurposePreferred -> "preferred"
    AdditionalbindingpurposeUi -> "ui"
    AdditionalbindingpurposeStarter -> "starter"
    AdditionalbindingpurposeComponent -> "component"
  }
}

pub fn additionalbindingpurpose_from_string(
  s: String,
) -> Result(Additionalbindingpurpose, Nil) {
  case s {
    "maximum" -> Ok(AdditionalbindingpurposeMaximum)
    "minimum" -> Ok(AdditionalbindingpurposeMinimum)
    "required" -> Ok(AdditionalbindingpurposeRequired)
    "extensible" -> Ok(AdditionalbindingpurposeExtensible)
    "candidate" -> Ok(AdditionalbindingpurposeCandidate)
    "current" -> Ok(AdditionalbindingpurposeCurrent)
    "preferred" -> Ok(AdditionalbindingpurposePreferred)
    "ui" -> Ok(AdditionalbindingpurposeUi)
    "starter" -> Ok(AdditionalbindingpurposeStarter)
    "component" -> Ok(AdditionalbindingpurposeComponent)
    _ -> Error(Nil)
  }
}

pub fn additionalbindingpurpose_decoder() -> Decoder(Additionalbindingpurpose) {
  use variant <- decode.then(decode.string)
  case variant {
    "maximum" -> decode.success(AdditionalbindingpurposeMaximum)
    "minimum" -> decode.success(AdditionalbindingpurposeMinimum)
    "required" -> decode.success(AdditionalbindingpurposeRequired)
    "extensible" -> decode.success(AdditionalbindingpurposeExtensible)
    "candidate" -> decode.success(AdditionalbindingpurposeCandidate)
    "current" -> decode.success(AdditionalbindingpurposeCurrent)
    "preferred" -> decode.success(AdditionalbindingpurposePreferred)
    "ui" -> decode.success(AdditionalbindingpurposeUi)
    "starter" -> decode.success(AdditionalbindingpurposeStarter)
    "component" -> decode.success(AdditionalbindingpurposeComponent)
    _ ->
      decode.failure(
        AdditionalbindingpurposeMaximum,
        "Additionalbindingpurpose",
      )
  }
}

pub type Addresstype {
  AddresstypePostal
  AddresstypePhysical
  AddresstypeBoth
}

pub fn addresstype_to_json(addresstype: Addresstype) -> Json {
  json.string(addresstype_to_string(addresstype))
}

pub fn addresstype_to_string(addresstype: Addresstype) -> String {
  case addresstype {
    AddresstypePostal -> "postal"
    AddresstypePhysical -> "physical"
    AddresstypeBoth -> "both"
  }
}

pub fn addresstype_from_string(s: String) -> Result(Addresstype, Nil) {
  case s {
    "postal" -> Ok(AddresstypePostal)
    "physical" -> Ok(AddresstypePhysical)
    "both" -> Ok(AddresstypeBoth)
    _ -> Error(Nil)
  }
}

pub fn addresstype_decoder() -> Decoder(Addresstype) {
  use variant <- decode.then(decode.string)
  case variant {
    "postal" -> decode.success(AddresstypePostal)
    "physical" -> decode.success(AddresstypePhysical)
    "both" -> decode.success(AddresstypeBoth)
    _ -> decode.failure(AddresstypePostal, "Addresstype")
  }
}

pub type Addressuse {
  AddressuseHome
  AddressuseWork
  AddressuseTemp
  AddressuseOld
  AddressuseBilling
}

pub fn addressuse_to_json(addressuse: Addressuse) -> Json {
  json.string(addressuse_to_string(addressuse))
}

pub fn addressuse_to_string(addressuse: Addressuse) -> String {
  case addressuse {
    AddressuseHome -> "home"
    AddressuseWork -> "work"
    AddressuseTemp -> "temp"
    AddressuseOld -> "old"
    AddressuseBilling -> "billing"
  }
}

pub fn addressuse_from_string(s: String) -> Result(Addressuse, Nil) {
  case s {
    "home" -> Ok(AddressuseHome)
    "work" -> Ok(AddressuseWork)
    "temp" -> Ok(AddressuseTemp)
    "old" -> Ok(AddressuseOld)
    "billing" -> Ok(AddressuseBilling)
    _ -> Error(Nil)
  }
}

pub fn addressuse_decoder() -> Decoder(Addressuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "home" -> decode.success(AddressuseHome)
    "work" -> decode.success(AddressuseWork)
    "temp" -> decode.success(AddressuseTemp)
    "old" -> decode.success(AddressuseOld)
    "billing" -> decode.success(AddressuseBilling)
    _ -> decode.failure(AddressuseHome, "Addressuse")
  }
}

pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}

pub fn administrativegender_to_json(
  administrativegender: Administrativegender,
) -> Json {
  json.string(administrativegender_to_string(administrativegender))
}

pub fn administrativegender_to_string(
  administrativegender: Administrativegender,
) -> String {
  case administrativegender {
    AdministrativegenderMale -> "male"
    AdministrativegenderFemale -> "female"
    AdministrativegenderOther -> "other"
    AdministrativegenderUnknown -> "unknown"
  }
}

pub fn administrativegender_from_string(
  s: String,
) -> Result(Administrativegender, Nil) {
  case s {
    "male" -> Ok(AdministrativegenderMale)
    "female" -> Ok(AdministrativegenderFemale)
    "other" -> Ok(AdministrativegenderOther)
    "unknown" -> Ok(AdministrativegenderUnknown)
    _ -> Error(Nil)
  }
}

pub fn administrativegender_decoder() -> Decoder(Administrativegender) {
  use variant <- decode.then(decode.string)
  case variant {
    "male" -> decode.success(AdministrativegenderMale)
    "female" -> decode.success(AdministrativegenderFemale)
    "other" -> decode.success(AdministrativegenderOther)
    "unknown" -> decode.success(AdministrativegenderUnknown)
    _ -> decode.failure(AdministrativegenderMale, "Administrativegender")
  }
}

pub type Adverseeventactuality {
  AdverseeventactualityActual
  AdverseeventactualityPotential
}

pub fn adverseeventactuality_to_json(
  adverseeventactuality: Adverseeventactuality,
) -> Json {
  json.string(adverseeventactuality_to_string(adverseeventactuality))
}

pub fn adverseeventactuality_to_string(
  adverseeventactuality: Adverseeventactuality,
) -> String {
  case adverseeventactuality {
    AdverseeventactualityActual -> "actual"
    AdverseeventactualityPotential -> "potential"
  }
}

pub fn adverseeventactuality_from_string(
  s: String,
) -> Result(Adverseeventactuality, Nil) {
  case s {
    "actual" -> Ok(AdverseeventactualityActual)
    "potential" -> Ok(AdverseeventactualityPotential)
    _ -> Error(Nil)
  }
}

pub fn adverseeventactuality_decoder() -> Decoder(Adverseeventactuality) {
  use variant <- decode.then(decode.string)
  case variant {
    "actual" -> decode.success(AdverseeventactualityActual)
    "potential" -> decode.success(AdverseeventactualityPotential)
    _ -> decode.failure(AdverseeventactualityActual, "Adverseeventactuality")
  }
}

pub type Adverseeventstatus {
  AdverseeventstatusInprogress
  AdverseeventstatusCompleted
  AdverseeventstatusEnteredinerror
  AdverseeventstatusUnknown
}

pub fn adverseeventstatus_to_json(
  adverseeventstatus: Adverseeventstatus,
) -> Json {
  json.string(adverseeventstatus_to_string(adverseeventstatus))
}

pub fn adverseeventstatus_to_string(
  adverseeventstatus: Adverseeventstatus,
) -> String {
  case adverseeventstatus {
    AdverseeventstatusInprogress -> "in-progress"
    AdverseeventstatusCompleted -> "completed"
    AdverseeventstatusEnteredinerror -> "entered-in-error"
    AdverseeventstatusUnknown -> "unknown"
  }
}

pub fn adverseeventstatus_from_string(
  s: String,
) -> Result(Adverseeventstatus, Nil) {
  case s {
    "in-progress" -> Ok(AdverseeventstatusInprogress)
    "completed" -> Ok(AdverseeventstatusCompleted)
    "entered-in-error" -> Ok(AdverseeventstatusEnteredinerror)
    "unknown" -> Ok(AdverseeventstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn adverseeventstatus_decoder() -> Decoder(Adverseeventstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(AdverseeventstatusInprogress)
    "completed" -> decode.success(AdverseeventstatusCompleted)
    "entered-in-error" -> decode.success(AdverseeventstatusEnteredinerror)
    "unknown" -> decode.success(AdverseeventstatusUnknown)
    _ -> decode.failure(AdverseeventstatusInprogress, "Adverseeventstatus")
  }
}

pub type Allergyintolerancecategory {
  AllergyintolerancecategoryFood
  AllergyintolerancecategoryMedication
  AllergyintolerancecategoryEnvironment
  AllergyintolerancecategoryBiologic
}

pub fn allergyintolerancecategory_to_json(
  allergyintolerancecategory: Allergyintolerancecategory,
) -> Json {
  json.string(allergyintolerancecategory_to_string(allergyintolerancecategory))
}

pub fn allergyintolerancecategory_to_string(
  allergyintolerancecategory: Allergyintolerancecategory,
) -> String {
  case allergyintolerancecategory {
    AllergyintolerancecategoryFood -> "food"
    AllergyintolerancecategoryMedication -> "medication"
    AllergyintolerancecategoryEnvironment -> "environment"
    AllergyintolerancecategoryBiologic -> "biologic"
  }
}

pub fn allergyintolerancecategory_from_string(
  s: String,
) -> Result(Allergyintolerancecategory, Nil) {
  case s {
    "food" -> Ok(AllergyintolerancecategoryFood)
    "medication" -> Ok(AllergyintolerancecategoryMedication)
    "environment" -> Ok(AllergyintolerancecategoryEnvironment)
    "biologic" -> Ok(AllergyintolerancecategoryBiologic)
    _ -> Error(Nil)
  }
}

pub fn allergyintolerancecategory_decoder() -> Decoder(
  Allergyintolerancecategory,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "food" -> decode.success(AllergyintolerancecategoryFood)
    "medication" -> decode.success(AllergyintolerancecategoryMedication)
    "environment" -> decode.success(AllergyintolerancecategoryEnvironment)
    "biologic" -> decode.success(AllergyintolerancecategoryBiologic)
    _ ->
      decode.failure(
        AllergyintolerancecategoryFood,
        "Allergyintolerancecategory",
      )
  }
}

pub type Allergyintolerancecriticality {
  AllergyintolerancecriticalityLow
  AllergyintolerancecriticalityHigh
  AllergyintolerancecriticalityUnabletoassess
}

pub fn allergyintolerancecriticality_to_json(
  allergyintolerancecriticality: Allergyintolerancecriticality,
) -> Json {
  json.string(allergyintolerancecriticality_to_string(
    allergyintolerancecriticality,
  ))
}

pub fn allergyintolerancecriticality_to_string(
  allergyintolerancecriticality: Allergyintolerancecriticality,
) -> String {
  case allergyintolerancecriticality {
    AllergyintolerancecriticalityLow -> "low"
    AllergyintolerancecriticalityHigh -> "high"
    AllergyintolerancecriticalityUnabletoassess -> "unable-to-assess"
  }
}

pub fn allergyintolerancecriticality_from_string(
  s: String,
) -> Result(Allergyintolerancecriticality, Nil) {
  case s {
    "low" -> Ok(AllergyintolerancecriticalityLow)
    "high" -> Ok(AllergyintolerancecriticalityHigh)
    "unable-to-assess" -> Ok(AllergyintolerancecriticalityUnabletoassess)
    _ -> Error(Nil)
  }
}

pub fn allergyintolerancecriticality_decoder() -> Decoder(
  Allergyintolerancecriticality,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "low" -> decode.success(AllergyintolerancecriticalityLow)
    "high" -> decode.success(AllergyintolerancecriticalityHigh)
    "unable-to-assess" ->
      decode.success(AllergyintolerancecriticalityUnabletoassess)
    _ ->
      decode.failure(
        AllergyintolerancecriticalityLow,
        "Allergyintolerancecriticality",
      )
  }
}

pub type Appointmentresponsestatus {
  AppointmentresponsestatusAccepted
  AppointmentresponsestatusDeclined
  AppointmentresponsestatusTentative
  AppointmentresponsestatusNeedsaction
  AppointmentresponsestatusEnteredinerror
}

pub fn appointmentresponsestatus_to_json(
  appointmentresponsestatus: Appointmentresponsestatus,
) -> Json {
  json.string(appointmentresponsestatus_to_string(appointmentresponsestatus))
}

pub fn appointmentresponsestatus_to_string(
  appointmentresponsestatus: Appointmentresponsestatus,
) -> String {
  case appointmentresponsestatus {
    AppointmentresponsestatusAccepted -> "accepted"
    AppointmentresponsestatusDeclined -> "declined"
    AppointmentresponsestatusTentative -> "tentative"
    AppointmentresponsestatusNeedsaction -> "needs-action"
    AppointmentresponsestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn appointmentresponsestatus_from_string(
  s: String,
) -> Result(Appointmentresponsestatus, Nil) {
  case s {
    "accepted" -> Ok(AppointmentresponsestatusAccepted)
    "declined" -> Ok(AppointmentresponsestatusDeclined)
    "tentative" -> Ok(AppointmentresponsestatusTentative)
    "needs-action" -> Ok(AppointmentresponsestatusNeedsaction)
    "entered-in-error" -> Ok(AppointmentresponsestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn appointmentresponsestatus_decoder() -> Decoder(Appointmentresponsestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "accepted" -> decode.success(AppointmentresponsestatusAccepted)
    "declined" -> decode.success(AppointmentresponsestatusDeclined)
    "tentative" -> decode.success(AppointmentresponsestatusTentative)
    "needs-action" -> decode.success(AppointmentresponsestatusNeedsaction)
    "entered-in-error" ->
      decode.success(AppointmentresponsestatusEnteredinerror)
    _ ->
      decode.failure(
        AppointmentresponsestatusAccepted,
        "Appointmentresponsestatus",
      )
  }
}

pub type Appointmentstatus {
  AppointmentstatusProposed
  AppointmentstatusPending
  AppointmentstatusBooked
  AppointmentstatusArrived
  AppointmentstatusFulfilled
  AppointmentstatusCancelled
  AppointmentstatusNoshow
  AppointmentstatusEnteredinerror
  AppointmentstatusCheckedin
  AppointmentstatusWaitlist
}

pub fn appointmentstatus_to_json(appointmentstatus: Appointmentstatus) -> Json {
  json.string(appointmentstatus_to_string(appointmentstatus))
}

pub fn appointmentstatus_to_string(
  appointmentstatus: Appointmentstatus,
) -> String {
  case appointmentstatus {
    AppointmentstatusProposed -> "proposed"
    AppointmentstatusPending -> "pending"
    AppointmentstatusBooked -> "booked"
    AppointmentstatusArrived -> "arrived"
    AppointmentstatusFulfilled -> "fulfilled"
    AppointmentstatusCancelled -> "cancelled"
    AppointmentstatusNoshow -> "noshow"
    AppointmentstatusEnteredinerror -> "entered-in-error"
    AppointmentstatusCheckedin -> "checked-in"
    AppointmentstatusWaitlist -> "waitlist"
  }
}

pub fn appointmentstatus_from_string(
  s: String,
) -> Result(Appointmentstatus, Nil) {
  case s {
    "proposed" -> Ok(AppointmentstatusProposed)
    "pending" -> Ok(AppointmentstatusPending)
    "booked" -> Ok(AppointmentstatusBooked)
    "arrived" -> Ok(AppointmentstatusArrived)
    "fulfilled" -> Ok(AppointmentstatusFulfilled)
    "cancelled" -> Ok(AppointmentstatusCancelled)
    "noshow" -> Ok(AppointmentstatusNoshow)
    "entered-in-error" -> Ok(AppointmentstatusEnteredinerror)
    "checked-in" -> Ok(AppointmentstatusCheckedin)
    "waitlist" -> Ok(AppointmentstatusWaitlist)
    _ -> Error(Nil)
  }
}

pub fn appointmentstatus_decoder() -> Decoder(Appointmentstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposed" -> decode.success(AppointmentstatusProposed)
    "pending" -> decode.success(AppointmentstatusPending)
    "booked" -> decode.success(AppointmentstatusBooked)
    "arrived" -> decode.success(AppointmentstatusArrived)
    "fulfilled" -> decode.success(AppointmentstatusFulfilled)
    "cancelled" -> decode.success(AppointmentstatusCancelled)
    "noshow" -> decode.success(AppointmentstatusNoshow)
    "entered-in-error" -> decode.success(AppointmentstatusEnteredinerror)
    "checked-in" -> decode.success(AppointmentstatusCheckedin)
    "waitlist" -> decode.success(AppointmentstatusWaitlist)
    _ -> decode.failure(AppointmentstatusProposed, "Appointmentstatus")
  }
}

pub type Artifactassessmentdisposition {
  ArtifactassessmentdispositionUnresolved
  ArtifactassessmentdispositionNotpersuasive
  ArtifactassessmentdispositionPersuasive
  ArtifactassessmentdispositionPersuasivewithmodification
  ArtifactassessmentdispositionNotpersuasivewithmodification
}

pub fn artifactassessmentdisposition_to_json(
  artifactassessmentdisposition: Artifactassessmentdisposition,
) -> Json {
  json.string(artifactassessmentdisposition_to_string(
    artifactassessmentdisposition,
  ))
}

pub fn artifactassessmentdisposition_to_string(
  artifactassessmentdisposition: Artifactassessmentdisposition,
) -> String {
  case artifactassessmentdisposition {
    ArtifactassessmentdispositionUnresolved -> "unresolved"
    ArtifactassessmentdispositionNotpersuasive -> "not-persuasive"
    ArtifactassessmentdispositionPersuasive -> "persuasive"
    ArtifactassessmentdispositionPersuasivewithmodification ->
      "persuasive-with-modification"
    ArtifactassessmentdispositionNotpersuasivewithmodification ->
      "not-persuasive-with-modification"
  }
}

pub fn artifactassessmentdisposition_from_string(
  s: String,
) -> Result(Artifactassessmentdisposition, Nil) {
  case s {
    "unresolved" -> Ok(ArtifactassessmentdispositionUnresolved)
    "not-persuasive" -> Ok(ArtifactassessmentdispositionNotpersuasive)
    "persuasive" -> Ok(ArtifactassessmentdispositionPersuasive)
    "persuasive-with-modification" ->
      Ok(ArtifactassessmentdispositionPersuasivewithmodification)
    "not-persuasive-with-modification" ->
      Ok(ArtifactassessmentdispositionNotpersuasivewithmodification)
    _ -> Error(Nil)
  }
}

pub fn artifactassessmentdisposition_decoder() -> Decoder(
  Artifactassessmentdisposition,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "unresolved" -> decode.success(ArtifactassessmentdispositionUnresolved)
    "not-persuasive" ->
      decode.success(ArtifactassessmentdispositionNotpersuasive)
    "persuasive" -> decode.success(ArtifactassessmentdispositionPersuasive)
    "persuasive-with-modification" ->
      decode.success(ArtifactassessmentdispositionPersuasivewithmodification)
    "not-persuasive-with-modification" ->
      decode.success(ArtifactassessmentdispositionNotpersuasivewithmodification)
    _ ->
      decode.failure(
        ArtifactassessmentdispositionUnresolved,
        "Artifactassessmentdisposition",
      )
  }
}

pub type Artifactassessmentinformationtype {
  ArtifactassessmentinformationtypeComment
  ArtifactassessmentinformationtypeClassifier
  ArtifactassessmentinformationtypeRating
  ArtifactassessmentinformationtypeContainer
  ArtifactassessmentinformationtypeResponse
  ArtifactassessmentinformationtypeChangerequest
}

pub fn artifactassessmentinformationtype_to_json(
  artifactassessmentinformationtype: Artifactassessmentinformationtype,
) -> Json {
  json.string(artifactassessmentinformationtype_to_string(
    artifactassessmentinformationtype,
  ))
}

pub fn artifactassessmentinformationtype_to_string(
  artifactassessmentinformationtype: Artifactassessmentinformationtype,
) -> String {
  case artifactassessmentinformationtype {
    ArtifactassessmentinformationtypeComment -> "comment"
    ArtifactassessmentinformationtypeClassifier -> "classifier"
    ArtifactassessmentinformationtypeRating -> "rating"
    ArtifactassessmentinformationtypeContainer -> "container"
    ArtifactassessmentinformationtypeResponse -> "response"
    ArtifactassessmentinformationtypeChangerequest -> "change-request"
  }
}

pub fn artifactassessmentinformationtype_from_string(
  s: String,
) -> Result(Artifactassessmentinformationtype, Nil) {
  case s {
    "comment" -> Ok(ArtifactassessmentinformationtypeComment)
    "classifier" -> Ok(ArtifactassessmentinformationtypeClassifier)
    "rating" -> Ok(ArtifactassessmentinformationtypeRating)
    "container" -> Ok(ArtifactassessmentinformationtypeContainer)
    "response" -> Ok(ArtifactassessmentinformationtypeResponse)
    "change-request" -> Ok(ArtifactassessmentinformationtypeChangerequest)
    _ -> Error(Nil)
  }
}

pub fn artifactassessmentinformationtype_decoder() -> Decoder(
  Artifactassessmentinformationtype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "comment" -> decode.success(ArtifactassessmentinformationtypeComment)
    "classifier" -> decode.success(ArtifactassessmentinformationtypeClassifier)
    "rating" -> decode.success(ArtifactassessmentinformationtypeRating)
    "container" -> decode.success(ArtifactassessmentinformationtypeContainer)
    "response" -> decode.success(ArtifactassessmentinformationtypeResponse)
    "change-request" ->
      decode.success(ArtifactassessmentinformationtypeChangerequest)
    _ ->
      decode.failure(
        ArtifactassessmentinformationtypeComment,
        "Artifactassessmentinformationtype",
      )
  }
}

pub type Artifactassessmentworkflowstatus {
  ArtifactassessmentworkflowstatusSubmitted
  ArtifactassessmentworkflowstatusTriaged
  ArtifactassessmentworkflowstatusWaitingforinput
  ArtifactassessmentworkflowstatusResolvednochange
  ArtifactassessmentworkflowstatusResolvedchangerequired
  ArtifactassessmentworkflowstatusDeferred
  ArtifactassessmentworkflowstatusDuplicate
  ArtifactassessmentworkflowstatusApplied
  ArtifactassessmentworkflowstatusPublished
  ArtifactassessmentworkflowstatusEnteredinerror
}

pub fn artifactassessmentworkflowstatus_to_json(
  artifactassessmentworkflowstatus: Artifactassessmentworkflowstatus,
) -> Json {
  json.string(artifactassessmentworkflowstatus_to_string(
    artifactassessmentworkflowstatus,
  ))
}

pub fn artifactassessmentworkflowstatus_to_string(
  artifactassessmentworkflowstatus: Artifactassessmentworkflowstatus,
) -> String {
  case artifactassessmentworkflowstatus {
    ArtifactassessmentworkflowstatusSubmitted -> "submitted"
    ArtifactassessmentworkflowstatusTriaged -> "triaged"
    ArtifactassessmentworkflowstatusWaitingforinput -> "waiting-for-input"
    ArtifactassessmentworkflowstatusResolvednochange -> "resolved-no-change"
    ArtifactassessmentworkflowstatusResolvedchangerequired ->
      "resolved-change-required"
    ArtifactassessmentworkflowstatusDeferred -> "deferred"
    ArtifactassessmentworkflowstatusDuplicate -> "duplicate"
    ArtifactassessmentworkflowstatusApplied -> "applied"
    ArtifactassessmentworkflowstatusPublished -> "published"
    ArtifactassessmentworkflowstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn artifactassessmentworkflowstatus_from_string(
  s: String,
) -> Result(Artifactassessmentworkflowstatus, Nil) {
  case s {
    "submitted" -> Ok(ArtifactassessmentworkflowstatusSubmitted)
    "triaged" -> Ok(ArtifactassessmentworkflowstatusTriaged)
    "waiting-for-input" -> Ok(ArtifactassessmentworkflowstatusWaitingforinput)
    "resolved-no-change" -> Ok(ArtifactassessmentworkflowstatusResolvednochange)
    "resolved-change-required" ->
      Ok(ArtifactassessmentworkflowstatusResolvedchangerequired)
    "deferred" -> Ok(ArtifactassessmentworkflowstatusDeferred)
    "duplicate" -> Ok(ArtifactassessmentworkflowstatusDuplicate)
    "applied" -> Ok(ArtifactassessmentworkflowstatusApplied)
    "published" -> Ok(ArtifactassessmentworkflowstatusPublished)
    "entered-in-error" -> Ok(ArtifactassessmentworkflowstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn artifactassessmentworkflowstatus_decoder() -> Decoder(
  Artifactassessmentworkflowstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "submitted" -> decode.success(ArtifactassessmentworkflowstatusSubmitted)
    "triaged" -> decode.success(ArtifactassessmentworkflowstatusTriaged)
    "waiting-for-input" ->
      decode.success(ArtifactassessmentworkflowstatusWaitingforinput)
    "resolved-no-change" ->
      decode.success(ArtifactassessmentworkflowstatusResolvednochange)
    "resolved-change-required" ->
      decode.success(ArtifactassessmentworkflowstatusResolvedchangerequired)
    "deferred" -> decode.success(ArtifactassessmentworkflowstatusDeferred)
    "duplicate" -> decode.success(ArtifactassessmentworkflowstatusDuplicate)
    "applied" -> decode.success(ArtifactassessmentworkflowstatusApplied)
    "published" -> decode.success(ArtifactassessmentworkflowstatusPublished)
    "entered-in-error" ->
      decode.success(ArtifactassessmentworkflowstatusEnteredinerror)
    _ ->
      decode.failure(
        ArtifactassessmentworkflowstatusSubmitted,
        "Artifactassessmentworkflowstatus",
      )
  }
}

pub type Assertdirectioncodes {
  AssertdirectioncodesResponse
  AssertdirectioncodesRequest
}

pub fn assertdirectioncodes_to_json(
  assertdirectioncodes: Assertdirectioncodes,
) -> Json {
  json.string(assertdirectioncodes_to_string(assertdirectioncodes))
}

pub fn assertdirectioncodes_to_string(
  assertdirectioncodes: Assertdirectioncodes,
) -> String {
  case assertdirectioncodes {
    AssertdirectioncodesResponse -> "response"
    AssertdirectioncodesRequest -> "request"
  }
}

pub fn assertdirectioncodes_from_string(
  s: String,
) -> Result(Assertdirectioncodes, Nil) {
  case s {
    "response" -> Ok(AssertdirectioncodesResponse)
    "request" -> Ok(AssertdirectioncodesRequest)
    _ -> Error(Nil)
  }
}

pub fn assertdirectioncodes_decoder() -> Decoder(Assertdirectioncodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "response" -> decode.success(AssertdirectioncodesResponse)
    "request" -> decode.success(AssertdirectioncodesRequest)
    _ -> decode.failure(AssertdirectioncodesResponse, "Assertdirectioncodes")
  }
}

pub type Assertmanualcompletioncodes {
  AssertmanualcompletioncodesFail
  AssertmanualcompletioncodesPass
  AssertmanualcompletioncodesSkip
  AssertmanualcompletioncodesStop
}

pub fn assertmanualcompletioncodes_to_json(
  assertmanualcompletioncodes: Assertmanualcompletioncodes,
) -> Json {
  json.string(assertmanualcompletioncodes_to_string(assertmanualcompletioncodes))
}

pub fn assertmanualcompletioncodes_to_string(
  assertmanualcompletioncodes: Assertmanualcompletioncodes,
) -> String {
  case assertmanualcompletioncodes {
    AssertmanualcompletioncodesFail -> "fail"
    AssertmanualcompletioncodesPass -> "pass"
    AssertmanualcompletioncodesSkip -> "skip"
    AssertmanualcompletioncodesStop -> "stop"
  }
}

pub fn assertmanualcompletioncodes_from_string(
  s: String,
) -> Result(Assertmanualcompletioncodes, Nil) {
  case s {
    "fail" -> Ok(AssertmanualcompletioncodesFail)
    "pass" -> Ok(AssertmanualcompletioncodesPass)
    "skip" -> Ok(AssertmanualcompletioncodesSkip)
    "stop" -> Ok(AssertmanualcompletioncodesStop)
    _ -> Error(Nil)
  }
}

pub fn assertmanualcompletioncodes_decoder() -> Decoder(
  Assertmanualcompletioncodes,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "fail" -> decode.success(AssertmanualcompletioncodesFail)
    "pass" -> decode.success(AssertmanualcompletioncodesPass)
    "skip" -> decode.success(AssertmanualcompletioncodesSkip)
    "stop" -> decode.success(AssertmanualcompletioncodesStop)
    _ ->
      decode.failure(
        AssertmanualcompletioncodesFail,
        "Assertmanualcompletioncodes",
      )
  }
}

pub type Assertoperatorcodes {
  AssertoperatorcodesEquals
  AssertoperatorcodesNotequals
  AssertoperatorcodesIn
  AssertoperatorcodesNotin
  AssertoperatorcodesGreaterthan
  AssertoperatorcodesLessthan
  AssertoperatorcodesEmpty
  AssertoperatorcodesNotempty
  AssertoperatorcodesContains
  AssertoperatorcodesNotcontains
  AssertoperatorcodesEval
  AssertoperatorcodesManualeval
}

pub fn assertoperatorcodes_to_json(
  assertoperatorcodes: Assertoperatorcodes,
) -> Json {
  json.string(assertoperatorcodes_to_string(assertoperatorcodes))
}

pub fn assertoperatorcodes_to_string(
  assertoperatorcodes: Assertoperatorcodes,
) -> String {
  case assertoperatorcodes {
    AssertoperatorcodesEquals -> "equals"
    AssertoperatorcodesNotequals -> "notEquals"
    AssertoperatorcodesIn -> "in"
    AssertoperatorcodesNotin -> "notIn"
    AssertoperatorcodesGreaterthan -> "greaterThan"
    AssertoperatorcodesLessthan -> "lessThan"
    AssertoperatorcodesEmpty -> "empty"
    AssertoperatorcodesNotempty -> "notEmpty"
    AssertoperatorcodesContains -> "contains"
    AssertoperatorcodesNotcontains -> "notContains"
    AssertoperatorcodesEval -> "eval"
    AssertoperatorcodesManualeval -> "manualEval"
  }
}

pub fn assertoperatorcodes_from_string(
  s: String,
) -> Result(Assertoperatorcodes, Nil) {
  case s {
    "equals" -> Ok(AssertoperatorcodesEquals)
    "notEquals" -> Ok(AssertoperatorcodesNotequals)
    "in" -> Ok(AssertoperatorcodesIn)
    "notIn" -> Ok(AssertoperatorcodesNotin)
    "greaterThan" -> Ok(AssertoperatorcodesGreaterthan)
    "lessThan" -> Ok(AssertoperatorcodesLessthan)
    "empty" -> Ok(AssertoperatorcodesEmpty)
    "notEmpty" -> Ok(AssertoperatorcodesNotempty)
    "contains" -> Ok(AssertoperatorcodesContains)
    "notContains" -> Ok(AssertoperatorcodesNotcontains)
    "eval" -> Ok(AssertoperatorcodesEval)
    "manualEval" -> Ok(AssertoperatorcodesManualeval)
    _ -> Error(Nil)
  }
}

pub fn assertoperatorcodes_decoder() -> Decoder(Assertoperatorcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "equals" -> decode.success(AssertoperatorcodesEquals)
    "notEquals" -> decode.success(AssertoperatorcodesNotequals)
    "in" -> decode.success(AssertoperatorcodesIn)
    "notIn" -> decode.success(AssertoperatorcodesNotin)
    "greaterThan" -> decode.success(AssertoperatorcodesGreaterthan)
    "lessThan" -> decode.success(AssertoperatorcodesLessthan)
    "empty" -> decode.success(AssertoperatorcodesEmpty)
    "notEmpty" -> decode.success(AssertoperatorcodesNotempty)
    "contains" -> decode.success(AssertoperatorcodesContains)
    "notContains" -> decode.success(AssertoperatorcodesNotcontains)
    "eval" -> decode.success(AssertoperatorcodesEval)
    "manualEval" -> decode.success(AssertoperatorcodesManualeval)
    _ -> decode.failure(AssertoperatorcodesEquals, "Assertoperatorcodes")
  }
}

pub type Assertresponsecodetypes {
  AssertresponsecodetypesContinue
  AssertresponsecodetypesSwitchingprotocols
  AssertresponsecodetypesOkay
  AssertresponsecodetypesCreated
  AssertresponsecodetypesAccepted
  AssertresponsecodetypesNonauthoritativeinformation
  AssertresponsecodetypesNocontent
  AssertresponsecodetypesResetcontent
  AssertresponsecodetypesPartialcontent
  AssertresponsecodetypesMultiplechoices
  AssertresponsecodetypesMovedpermanently
  AssertresponsecodetypesFound
  AssertresponsecodetypesSeeother
  AssertresponsecodetypesNotmodified
  AssertresponsecodetypesUseproxy
  AssertresponsecodetypesTemporaryredirect
  AssertresponsecodetypesPermanentredirect
  AssertresponsecodetypesBadrequest
  AssertresponsecodetypesUnauthorized
  AssertresponsecodetypesPaymentrequired
  AssertresponsecodetypesForbidden
  AssertresponsecodetypesNotfound
  AssertresponsecodetypesMethodnotallowed
  AssertresponsecodetypesNotacceptable
  AssertresponsecodetypesProxyauthenticationrequired
  AssertresponsecodetypesRequesttimeout
  AssertresponsecodetypesConflict
  AssertresponsecodetypesGone
  AssertresponsecodetypesLengthrequired
  AssertresponsecodetypesPreconditionfailed
  AssertresponsecodetypesContenttoolarge
  AssertresponsecodetypesUritoolong
  AssertresponsecodetypesUnsupportedmediatype
  AssertresponsecodetypesRangenotsatisfiable
  AssertresponsecodetypesExpectationfailed
  AssertresponsecodetypesMisdirectedrequest
  AssertresponsecodetypesUnprocessablecontent
  AssertresponsecodetypesUpgraderequired
  AssertresponsecodetypesInternalservererror
  AssertresponsecodetypesNotimplemented
  AssertresponsecodetypesBadgateway
  AssertresponsecodetypesServiceunavailable
  AssertresponsecodetypesGatewaytimeout
  AssertresponsecodetypesHttpversionnotsupported
}

pub fn assertresponsecodetypes_to_json(
  assertresponsecodetypes: Assertresponsecodetypes,
) -> Json {
  json.string(assertresponsecodetypes_to_string(assertresponsecodetypes))
}

pub fn assertresponsecodetypes_to_string(
  assertresponsecodetypes: Assertresponsecodetypes,
) -> String {
  case assertresponsecodetypes {
    AssertresponsecodetypesContinue -> "continue"
    AssertresponsecodetypesSwitchingprotocols -> "switchingProtocols"
    AssertresponsecodetypesOkay -> "okay"
    AssertresponsecodetypesCreated -> "created"
    AssertresponsecodetypesAccepted -> "accepted"
    AssertresponsecodetypesNonauthoritativeinformation ->
      "nonAuthoritativeInformation"
    AssertresponsecodetypesNocontent -> "noContent"
    AssertresponsecodetypesResetcontent -> "resetContent"
    AssertresponsecodetypesPartialcontent -> "partialContent"
    AssertresponsecodetypesMultiplechoices -> "multipleChoices"
    AssertresponsecodetypesMovedpermanently -> "movedPermanently"
    AssertresponsecodetypesFound -> "found"
    AssertresponsecodetypesSeeother -> "seeOther"
    AssertresponsecodetypesNotmodified -> "notModified"
    AssertresponsecodetypesUseproxy -> "useProxy"
    AssertresponsecodetypesTemporaryredirect -> "temporaryRedirect"
    AssertresponsecodetypesPermanentredirect -> "permanentRedirect"
    AssertresponsecodetypesBadrequest -> "badRequest"
    AssertresponsecodetypesUnauthorized -> "unauthorized"
    AssertresponsecodetypesPaymentrequired -> "paymentRequired"
    AssertresponsecodetypesForbidden -> "forbidden"
    AssertresponsecodetypesNotfound -> "notFound"
    AssertresponsecodetypesMethodnotallowed -> "methodNotAllowed"
    AssertresponsecodetypesNotacceptable -> "notAcceptable"
    AssertresponsecodetypesProxyauthenticationrequired ->
      "proxyAuthenticationRequired"
    AssertresponsecodetypesRequesttimeout -> "requestTimeout"
    AssertresponsecodetypesConflict -> "conflict"
    AssertresponsecodetypesGone -> "gone"
    AssertresponsecodetypesLengthrequired -> "lengthRequired"
    AssertresponsecodetypesPreconditionfailed -> "preconditionFailed"
    AssertresponsecodetypesContenttoolarge -> "contentTooLarge"
    AssertresponsecodetypesUritoolong -> "uriTooLong"
    AssertresponsecodetypesUnsupportedmediatype -> "unsupportedMediaType"
    AssertresponsecodetypesRangenotsatisfiable -> "rangeNotSatisfiable"
    AssertresponsecodetypesExpectationfailed -> "expectationFailed"
    AssertresponsecodetypesMisdirectedrequest -> "misdirectedRequest"
    AssertresponsecodetypesUnprocessablecontent -> "unprocessableContent"
    AssertresponsecodetypesUpgraderequired -> "upgradeRequired"
    AssertresponsecodetypesInternalservererror -> "internalServerError"
    AssertresponsecodetypesNotimplemented -> "notImplemented"
    AssertresponsecodetypesBadgateway -> "badGateway"
    AssertresponsecodetypesServiceunavailable -> "serviceUnavailable"
    AssertresponsecodetypesGatewaytimeout -> "gatewayTimeout"
    AssertresponsecodetypesHttpversionnotsupported -> "httpVersionNotSupported"
  }
}

pub fn assertresponsecodetypes_from_string(
  s: String,
) -> Result(Assertresponsecodetypes, Nil) {
  case s {
    "continue" -> Ok(AssertresponsecodetypesContinue)
    "switchingProtocols" -> Ok(AssertresponsecodetypesSwitchingprotocols)
    "okay" -> Ok(AssertresponsecodetypesOkay)
    "created" -> Ok(AssertresponsecodetypesCreated)
    "accepted" -> Ok(AssertresponsecodetypesAccepted)
    "nonAuthoritativeInformation" ->
      Ok(AssertresponsecodetypesNonauthoritativeinformation)
    "noContent" -> Ok(AssertresponsecodetypesNocontent)
    "resetContent" -> Ok(AssertresponsecodetypesResetcontent)
    "partialContent" -> Ok(AssertresponsecodetypesPartialcontent)
    "multipleChoices" -> Ok(AssertresponsecodetypesMultiplechoices)
    "movedPermanently" -> Ok(AssertresponsecodetypesMovedpermanently)
    "found" -> Ok(AssertresponsecodetypesFound)
    "seeOther" -> Ok(AssertresponsecodetypesSeeother)
    "notModified" -> Ok(AssertresponsecodetypesNotmodified)
    "useProxy" -> Ok(AssertresponsecodetypesUseproxy)
    "temporaryRedirect" -> Ok(AssertresponsecodetypesTemporaryredirect)
    "permanentRedirect" -> Ok(AssertresponsecodetypesPermanentredirect)
    "badRequest" -> Ok(AssertresponsecodetypesBadrequest)
    "unauthorized" -> Ok(AssertresponsecodetypesUnauthorized)
    "paymentRequired" -> Ok(AssertresponsecodetypesPaymentrequired)
    "forbidden" -> Ok(AssertresponsecodetypesForbidden)
    "notFound" -> Ok(AssertresponsecodetypesNotfound)
    "methodNotAllowed" -> Ok(AssertresponsecodetypesMethodnotallowed)
    "notAcceptable" -> Ok(AssertresponsecodetypesNotacceptable)
    "proxyAuthenticationRequired" ->
      Ok(AssertresponsecodetypesProxyauthenticationrequired)
    "requestTimeout" -> Ok(AssertresponsecodetypesRequesttimeout)
    "conflict" -> Ok(AssertresponsecodetypesConflict)
    "gone" -> Ok(AssertresponsecodetypesGone)
    "lengthRequired" -> Ok(AssertresponsecodetypesLengthrequired)
    "preconditionFailed" -> Ok(AssertresponsecodetypesPreconditionfailed)
    "contentTooLarge" -> Ok(AssertresponsecodetypesContenttoolarge)
    "uriTooLong" -> Ok(AssertresponsecodetypesUritoolong)
    "unsupportedMediaType" -> Ok(AssertresponsecodetypesUnsupportedmediatype)
    "rangeNotSatisfiable" -> Ok(AssertresponsecodetypesRangenotsatisfiable)
    "expectationFailed" -> Ok(AssertresponsecodetypesExpectationfailed)
    "misdirectedRequest" -> Ok(AssertresponsecodetypesMisdirectedrequest)
    "unprocessableContent" -> Ok(AssertresponsecodetypesUnprocessablecontent)
    "upgradeRequired" -> Ok(AssertresponsecodetypesUpgraderequired)
    "internalServerError" -> Ok(AssertresponsecodetypesInternalservererror)
    "notImplemented" -> Ok(AssertresponsecodetypesNotimplemented)
    "badGateway" -> Ok(AssertresponsecodetypesBadgateway)
    "serviceUnavailable" -> Ok(AssertresponsecodetypesServiceunavailable)
    "gatewayTimeout" -> Ok(AssertresponsecodetypesGatewaytimeout)
    "httpVersionNotSupported" ->
      Ok(AssertresponsecodetypesHttpversionnotsupported)
    _ -> Error(Nil)
  }
}

pub fn assertresponsecodetypes_decoder() -> Decoder(Assertresponsecodetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "continue" -> decode.success(AssertresponsecodetypesContinue)
    "switchingProtocols" ->
      decode.success(AssertresponsecodetypesSwitchingprotocols)
    "okay" -> decode.success(AssertresponsecodetypesOkay)
    "created" -> decode.success(AssertresponsecodetypesCreated)
    "accepted" -> decode.success(AssertresponsecodetypesAccepted)
    "nonAuthoritativeInformation" ->
      decode.success(AssertresponsecodetypesNonauthoritativeinformation)
    "noContent" -> decode.success(AssertresponsecodetypesNocontent)
    "resetContent" -> decode.success(AssertresponsecodetypesResetcontent)
    "partialContent" -> decode.success(AssertresponsecodetypesPartialcontent)
    "multipleChoices" -> decode.success(AssertresponsecodetypesMultiplechoices)
    "movedPermanently" ->
      decode.success(AssertresponsecodetypesMovedpermanently)
    "found" -> decode.success(AssertresponsecodetypesFound)
    "seeOther" -> decode.success(AssertresponsecodetypesSeeother)
    "notModified" -> decode.success(AssertresponsecodetypesNotmodified)
    "useProxy" -> decode.success(AssertresponsecodetypesUseproxy)
    "temporaryRedirect" ->
      decode.success(AssertresponsecodetypesTemporaryredirect)
    "permanentRedirect" ->
      decode.success(AssertresponsecodetypesPermanentredirect)
    "badRequest" -> decode.success(AssertresponsecodetypesBadrequest)
    "unauthorized" -> decode.success(AssertresponsecodetypesUnauthorized)
    "paymentRequired" -> decode.success(AssertresponsecodetypesPaymentrequired)
    "forbidden" -> decode.success(AssertresponsecodetypesForbidden)
    "notFound" -> decode.success(AssertresponsecodetypesNotfound)
    "methodNotAllowed" ->
      decode.success(AssertresponsecodetypesMethodnotallowed)
    "notAcceptable" -> decode.success(AssertresponsecodetypesNotacceptable)
    "proxyAuthenticationRequired" ->
      decode.success(AssertresponsecodetypesProxyauthenticationrequired)
    "requestTimeout" -> decode.success(AssertresponsecodetypesRequesttimeout)
    "conflict" -> decode.success(AssertresponsecodetypesConflict)
    "gone" -> decode.success(AssertresponsecodetypesGone)
    "lengthRequired" -> decode.success(AssertresponsecodetypesLengthrequired)
    "preconditionFailed" ->
      decode.success(AssertresponsecodetypesPreconditionfailed)
    "contentTooLarge" -> decode.success(AssertresponsecodetypesContenttoolarge)
    "uriTooLong" -> decode.success(AssertresponsecodetypesUritoolong)
    "unsupportedMediaType" ->
      decode.success(AssertresponsecodetypesUnsupportedmediatype)
    "rangeNotSatisfiable" ->
      decode.success(AssertresponsecodetypesRangenotsatisfiable)
    "expectationFailed" ->
      decode.success(AssertresponsecodetypesExpectationfailed)
    "misdirectedRequest" ->
      decode.success(AssertresponsecodetypesMisdirectedrequest)
    "unprocessableContent" ->
      decode.success(AssertresponsecodetypesUnprocessablecontent)
    "upgradeRequired" -> decode.success(AssertresponsecodetypesUpgraderequired)
    "internalServerError" ->
      decode.success(AssertresponsecodetypesInternalservererror)
    "notImplemented" -> decode.success(AssertresponsecodetypesNotimplemented)
    "badGateway" -> decode.success(AssertresponsecodetypesBadgateway)
    "serviceUnavailable" ->
      decode.success(AssertresponsecodetypesServiceunavailable)
    "gatewayTimeout" -> decode.success(AssertresponsecodetypesGatewaytimeout)
    "httpVersionNotSupported" ->
      decode.success(AssertresponsecodetypesHttpversionnotsupported)
    _ ->
      decode.failure(AssertresponsecodetypesContinue, "Assertresponsecodetypes")
  }
}

pub type Auditeventaction {
  AuditeventactionC
  AuditeventactionR
  AuditeventactionU
  AuditeventactionD
  AuditeventactionE
}

pub fn auditeventaction_to_json(auditeventaction: Auditeventaction) -> Json {
  json.string(auditeventaction_to_string(auditeventaction))
}

pub fn auditeventaction_to_string(auditeventaction: Auditeventaction) -> String {
  case auditeventaction {
    AuditeventactionC -> "C"
    AuditeventactionR -> "R"
    AuditeventactionU -> "U"
    AuditeventactionD -> "D"
    AuditeventactionE -> "E"
  }
}

pub fn auditeventaction_from_string(s: String) -> Result(Auditeventaction, Nil) {
  case s {
    "C" -> Ok(AuditeventactionC)
    "R" -> Ok(AuditeventactionR)
    "U" -> Ok(AuditeventactionU)
    "D" -> Ok(AuditeventactionD)
    "E" -> Ok(AuditeventactionE)
    _ -> Error(Nil)
  }
}

pub fn auditeventaction_decoder() -> Decoder(Auditeventaction) {
  use variant <- decode.then(decode.string)
  case variant {
    "C" -> decode.success(AuditeventactionC)
    "R" -> decode.success(AuditeventactionR)
    "U" -> decode.success(AuditeventactionU)
    "D" -> decode.success(AuditeventactionD)
    "E" -> decode.success(AuditeventactionE)
    _ -> decode.failure(AuditeventactionC, "Auditeventaction")
  }
}

pub type Auditeventseverity {
  AuditeventseverityEmergency
  AuditeventseverityAlert
  AuditeventseverityCritical
  AuditeventseverityError
  AuditeventseverityWarning
  AuditeventseverityNotice
  AuditeventseverityInformational
  AuditeventseverityDebug
}

pub fn auditeventseverity_to_json(
  auditeventseverity: Auditeventseverity,
) -> Json {
  json.string(auditeventseverity_to_string(auditeventseverity))
}

pub fn auditeventseverity_to_string(
  auditeventseverity: Auditeventseverity,
) -> String {
  case auditeventseverity {
    AuditeventseverityEmergency -> "emergency"
    AuditeventseverityAlert -> "alert"
    AuditeventseverityCritical -> "critical"
    AuditeventseverityError -> "error"
    AuditeventseverityWarning -> "warning"
    AuditeventseverityNotice -> "notice"
    AuditeventseverityInformational -> "informational"
    AuditeventseverityDebug -> "debug"
  }
}

pub fn auditeventseverity_from_string(
  s: String,
) -> Result(Auditeventseverity, Nil) {
  case s {
    "emergency" -> Ok(AuditeventseverityEmergency)
    "alert" -> Ok(AuditeventseverityAlert)
    "critical" -> Ok(AuditeventseverityCritical)
    "error" -> Ok(AuditeventseverityError)
    "warning" -> Ok(AuditeventseverityWarning)
    "notice" -> Ok(AuditeventseverityNotice)
    "informational" -> Ok(AuditeventseverityInformational)
    "debug" -> Ok(AuditeventseverityDebug)
    _ -> Error(Nil)
  }
}

pub fn auditeventseverity_decoder() -> Decoder(Auditeventseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "emergency" -> decode.success(AuditeventseverityEmergency)
    "alert" -> decode.success(AuditeventseverityAlert)
    "critical" -> decode.success(AuditeventseverityCritical)
    "error" -> decode.success(AuditeventseverityError)
    "warning" -> decode.success(AuditeventseverityWarning)
    "notice" -> decode.success(AuditeventseverityNotice)
    "informational" -> decode.success(AuditeventseverityInformational)
    "debug" -> decode.success(AuditeventseverityDebug)
    _ -> decode.failure(AuditeventseverityEmergency, "Auditeventseverity")
  }
}

pub type Bindingstrength {
  BindingstrengthRequired
  BindingstrengthExtensible
  BindingstrengthPreferred
  BindingstrengthExample
}

pub fn bindingstrength_to_json(bindingstrength: Bindingstrength) -> Json {
  json.string(bindingstrength_to_string(bindingstrength))
}

pub fn bindingstrength_to_string(bindingstrength: Bindingstrength) -> String {
  case bindingstrength {
    BindingstrengthRequired -> "required"
    BindingstrengthExtensible -> "extensible"
    BindingstrengthPreferred -> "preferred"
    BindingstrengthExample -> "example"
  }
}

pub fn bindingstrength_from_string(s: String) -> Result(Bindingstrength, Nil) {
  case s {
    "required" -> Ok(BindingstrengthRequired)
    "extensible" -> Ok(BindingstrengthExtensible)
    "preferred" -> Ok(BindingstrengthPreferred)
    "example" -> Ok(BindingstrengthExample)
    _ -> Error(Nil)
  }
}

pub fn bindingstrength_decoder() -> Decoder(Bindingstrength) {
  use variant <- decode.then(decode.string)
  case variant {
    "required" -> decode.success(BindingstrengthRequired)
    "extensible" -> decode.success(BindingstrengthExtensible)
    "preferred" -> decode.success(BindingstrengthPreferred)
    "example" -> decode.success(BindingstrengthExample)
    _ -> decode.failure(BindingstrengthRequired, "Bindingstrength")
  }
}

pub type Biologicallyderivedproductdispensestatus {
  BiologicallyderivedproductdispensestatusPreparation
  BiologicallyderivedproductdispensestatusInprogress
  BiologicallyderivedproductdispensestatusAllocated
  BiologicallyderivedproductdispensestatusIssued
  BiologicallyderivedproductdispensestatusUnfulfilled
  BiologicallyderivedproductdispensestatusReturned
  BiologicallyderivedproductdispensestatusEnteredinerror
  BiologicallyderivedproductdispensestatusUnknown
}

pub fn biologicallyderivedproductdispensestatus_to_json(
  biologicallyderivedproductdispensestatus: Biologicallyderivedproductdispensestatus,
) -> Json {
  json.string(biologicallyderivedproductdispensestatus_to_string(
    biologicallyderivedproductdispensestatus,
  ))
}

pub fn biologicallyderivedproductdispensestatus_to_string(
  biologicallyderivedproductdispensestatus: Biologicallyderivedproductdispensestatus,
) -> String {
  case biologicallyderivedproductdispensestatus {
    BiologicallyderivedproductdispensestatusPreparation -> "preparation"
    BiologicallyderivedproductdispensestatusInprogress -> "in-progress"
    BiologicallyderivedproductdispensestatusAllocated -> "allocated"
    BiologicallyderivedproductdispensestatusIssued -> "issued"
    BiologicallyderivedproductdispensestatusUnfulfilled -> "unfulfilled"
    BiologicallyderivedproductdispensestatusReturned -> "returned"
    BiologicallyderivedproductdispensestatusEnteredinerror -> "entered-in-error"
    BiologicallyderivedproductdispensestatusUnknown -> "unknown"
  }
}

pub fn biologicallyderivedproductdispensestatus_from_string(
  s: String,
) -> Result(Biologicallyderivedproductdispensestatus, Nil) {
  case s {
    "preparation" -> Ok(BiologicallyderivedproductdispensestatusPreparation)
    "in-progress" -> Ok(BiologicallyderivedproductdispensestatusInprogress)
    "allocated" -> Ok(BiologicallyderivedproductdispensestatusAllocated)
    "issued" -> Ok(BiologicallyderivedproductdispensestatusIssued)
    "unfulfilled" -> Ok(BiologicallyderivedproductdispensestatusUnfulfilled)
    "returned" -> Ok(BiologicallyderivedproductdispensestatusReturned)
    "entered-in-error" ->
      Ok(BiologicallyderivedproductdispensestatusEnteredinerror)
    "unknown" -> Ok(BiologicallyderivedproductdispensestatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn biologicallyderivedproductdispensestatus_decoder() -> Decoder(
  Biologicallyderivedproductdispensestatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "preparation" ->
      decode.success(BiologicallyderivedproductdispensestatusPreparation)
    "in-progress" ->
      decode.success(BiologicallyderivedproductdispensestatusInprogress)
    "allocated" ->
      decode.success(BiologicallyderivedproductdispensestatusAllocated)
    "issued" -> decode.success(BiologicallyderivedproductdispensestatusIssued)
    "unfulfilled" ->
      decode.success(BiologicallyderivedproductdispensestatusUnfulfilled)
    "returned" ->
      decode.success(BiologicallyderivedproductdispensestatusReturned)
    "entered-in-error" ->
      decode.success(BiologicallyderivedproductdispensestatusEnteredinerror)
    "unknown" -> decode.success(BiologicallyderivedproductdispensestatusUnknown)
    _ ->
      decode.failure(
        BiologicallyderivedproductdispensestatusPreparation,
        "Biologicallyderivedproductdispensestatus",
      )
  }
}

pub type Bundletype {
  BundletypeDocument
  BundletypeMessage
  BundletypeTransaction
  BundletypeTransactionresponse
  BundletypeBatch
  BundletypeBatchresponse
  BundletypeHistory
  BundletypeSearchset
  BundletypeCollection
  BundletypeSubscriptionnotification
}

pub fn bundletype_to_json(bundletype: Bundletype) -> Json {
  json.string(bundletype_to_string(bundletype))
}

pub fn bundletype_to_string(bundletype: Bundletype) -> String {
  case bundletype {
    BundletypeDocument -> "document"
    BundletypeMessage -> "message"
    BundletypeTransaction -> "transaction"
    BundletypeTransactionresponse -> "transaction-response"
    BundletypeBatch -> "batch"
    BundletypeBatchresponse -> "batch-response"
    BundletypeHistory -> "history"
    BundletypeSearchset -> "searchset"
    BundletypeCollection -> "collection"
    BundletypeSubscriptionnotification -> "subscription-notification"
  }
}

pub fn bundletype_from_string(s: String) -> Result(Bundletype, Nil) {
  case s {
    "document" -> Ok(BundletypeDocument)
    "message" -> Ok(BundletypeMessage)
    "transaction" -> Ok(BundletypeTransaction)
    "transaction-response" -> Ok(BundletypeTransactionresponse)
    "batch" -> Ok(BundletypeBatch)
    "batch-response" -> Ok(BundletypeBatchresponse)
    "history" -> Ok(BundletypeHistory)
    "searchset" -> Ok(BundletypeSearchset)
    "collection" -> Ok(BundletypeCollection)
    "subscription-notification" -> Ok(BundletypeSubscriptionnotification)
    _ -> Error(Nil)
  }
}

pub fn bundletype_decoder() -> Decoder(Bundletype) {
  use variant <- decode.then(decode.string)
  case variant {
    "document" -> decode.success(BundletypeDocument)
    "message" -> decode.success(BundletypeMessage)
    "transaction" -> decode.success(BundletypeTransaction)
    "transaction-response" -> decode.success(BundletypeTransactionresponse)
    "batch" -> decode.success(BundletypeBatch)
    "batch-response" -> decode.success(BundletypeBatchresponse)
    "history" -> decode.success(BundletypeHistory)
    "searchset" -> decode.success(BundletypeSearchset)
    "collection" -> decode.success(BundletypeCollection)
    "subscription-notification" ->
      decode.success(BundletypeSubscriptionnotification)
    _ -> decode.failure(BundletypeDocument, "Bundletype")
  }
}

pub type Capabilitystatementkind {
  CapabilitystatementkindInstance
  CapabilitystatementkindCapability
  CapabilitystatementkindRequirements
}

pub fn capabilitystatementkind_to_json(
  capabilitystatementkind: Capabilitystatementkind,
) -> Json {
  json.string(capabilitystatementkind_to_string(capabilitystatementkind))
}

pub fn capabilitystatementkind_to_string(
  capabilitystatementkind: Capabilitystatementkind,
) -> String {
  case capabilitystatementkind {
    CapabilitystatementkindInstance -> "instance"
    CapabilitystatementkindCapability -> "capability"
    CapabilitystatementkindRequirements -> "requirements"
  }
}

pub fn capabilitystatementkind_from_string(
  s: String,
) -> Result(Capabilitystatementkind, Nil) {
  case s {
    "instance" -> Ok(CapabilitystatementkindInstance)
    "capability" -> Ok(CapabilitystatementkindCapability)
    "requirements" -> Ok(CapabilitystatementkindRequirements)
    _ -> Error(Nil)
  }
}

pub fn capabilitystatementkind_decoder() -> Decoder(Capabilitystatementkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "instance" -> decode.success(CapabilitystatementkindInstance)
    "capability" -> decode.success(CapabilitystatementkindCapability)
    "requirements" -> decode.success(CapabilitystatementkindRequirements)
    _ ->
      decode.failure(CapabilitystatementkindInstance, "Capabilitystatementkind")
  }
}

pub type Careplanintent {
  CareplanintentProposal
  CareplanintentPlan
  CareplanintentOrder
  CareplanintentOption
  CareplanintentDirective
}

pub fn careplanintent_to_json(careplanintent: Careplanintent) -> Json {
  json.string(careplanintent_to_string(careplanintent))
}

pub fn careplanintent_to_string(careplanintent: Careplanintent) -> String {
  case careplanintent {
    CareplanintentProposal -> "proposal"
    CareplanintentPlan -> "plan"
    CareplanintentOrder -> "order"
    CareplanintentOption -> "option"
    CareplanintentDirective -> "directive"
  }
}

pub fn careplanintent_from_string(s: String) -> Result(Careplanintent, Nil) {
  case s {
    "proposal" -> Ok(CareplanintentProposal)
    "plan" -> Ok(CareplanintentPlan)
    "order" -> Ok(CareplanintentOrder)
    "option" -> Ok(CareplanintentOption)
    "directive" -> Ok(CareplanintentDirective)
    _ -> Error(Nil)
  }
}

pub fn careplanintent_decoder() -> Decoder(Careplanintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposal" -> decode.success(CareplanintentProposal)
    "plan" -> decode.success(CareplanintentPlan)
    "order" -> decode.success(CareplanintentOrder)
    "option" -> decode.success(CareplanintentOption)
    "directive" -> decode.success(CareplanintentDirective)
    _ -> decode.failure(CareplanintentProposal, "Careplanintent")
  }
}

pub type Careteamstatus {
  CareteamstatusProposed
  CareteamstatusActive
  CareteamstatusSuspended
  CareteamstatusInactive
  CareteamstatusEnteredinerror
}

pub fn careteamstatus_to_json(careteamstatus: Careteamstatus) -> Json {
  json.string(careteamstatus_to_string(careteamstatus))
}

pub fn careteamstatus_to_string(careteamstatus: Careteamstatus) -> String {
  case careteamstatus {
    CareteamstatusProposed -> "proposed"
    CareteamstatusActive -> "active"
    CareteamstatusSuspended -> "suspended"
    CareteamstatusInactive -> "inactive"
    CareteamstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn careteamstatus_from_string(s: String) -> Result(Careteamstatus, Nil) {
  case s {
    "proposed" -> Ok(CareteamstatusProposed)
    "active" -> Ok(CareteamstatusActive)
    "suspended" -> Ok(CareteamstatusSuspended)
    "inactive" -> Ok(CareteamstatusInactive)
    "entered-in-error" -> Ok(CareteamstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn careteamstatus_decoder() -> Decoder(Careteamstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposed" -> decode.success(CareteamstatusProposed)
    "active" -> decode.success(CareteamstatusActive)
    "suspended" -> decode.success(CareteamstatusSuspended)
    "inactive" -> decode.success(CareteamstatusInactive)
    "entered-in-error" -> decode.success(CareteamstatusEnteredinerror)
    _ -> decode.failure(CareteamstatusProposed, "Careteamstatus")
  }
}

pub type Characteristiccombination {
  CharacteristiccombinationAllof
  CharacteristiccombinationAnyof
  CharacteristiccombinationAtleast
  CharacteristiccombinationAtmost
  CharacteristiccombinationStatistical
  CharacteristiccombinationNeteffect
  CharacteristiccombinationDataset
}

pub fn characteristiccombination_to_json(
  characteristiccombination: Characteristiccombination,
) -> Json {
  json.string(characteristiccombination_to_string(characteristiccombination))
}

pub fn characteristiccombination_to_string(
  characteristiccombination: Characteristiccombination,
) -> String {
  case characteristiccombination {
    CharacteristiccombinationAllof -> "all-of"
    CharacteristiccombinationAnyof -> "any-of"
    CharacteristiccombinationAtleast -> "at-least"
    CharacteristiccombinationAtmost -> "at-most"
    CharacteristiccombinationStatistical -> "statistical"
    CharacteristiccombinationNeteffect -> "net-effect"
    CharacteristiccombinationDataset -> "dataset"
  }
}

pub fn characteristiccombination_from_string(
  s: String,
) -> Result(Characteristiccombination, Nil) {
  case s {
    "all-of" -> Ok(CharacteristiccombinationAllof)
    "any-of" -> Ok(CharacteristiccombinationAnyof)
    "at-least" -> Ok(CharacteristiccombinationAtleast)
    "at-most" -> Ok(CharacteristiccombinationAtmost)
    "statistical" -> Ok(CharacteristiccombinationStatistical)
    "net-effect" -> Ok(CharacteristiccombinationNeteffect)
    "dataset" -> Ok(CharacteristiccombinationDataset)
    _ -> Error(Nil)
  }
}

pub fn characteristiccombination_decoder() -> Decoder(Characteristiccombination) {
  use variant <- decode.then(decode.string)
  case variant {
    "all-of" -> decode.success(CharacteristiccombinationAllof)
    "any-of" -> decode.success(CharacteristiccombinationAnyof)
    "at-least" -> decode.success(CharacteristiccombinationAtleast)
    "at-most" -> decode.success(CharacteristiccombinationAtmost)
    "statistical" -> decode.success(CharacteristiccombinationStatistical)
    "net-effect" -> decode.success(CharacteristiccombinationNeteffect)
    "dataset" -> decode.success(CharacteristiccombinationDataset)
    _ ->
      decode.failure(
        CharacteristiccombinationAllof,
        "Characteristiccombination",
      )
  }
}

pub type Chargeitemstatus {
  ChargeitemstatusPlanned
  ChargeitemstatusBillable
  ChargeitemstatusNotbillable
  ChargeitemstatusAborted
  ChargeitemstatusBilled
  ChargeitemstatusEnteredinerror
  ChargeitemstatusUnknown
}

pub fn chargeitemstatus_to_json(chargeitemstatus: Chargeitemstatus) -> Json {
  json.string(chargeitemstatus_to_string(chargeitemstatus))
}

pub fn chargeitemstatus_to_string(chargeitemstatus: Chargeitemstatus) -> String {
  case chargeitemstatus {
    ChargeitemstatusPlanned -> "planned"
    ChargeitemstatusBillable -> "billable"
    ChargeitemstatusNotbillable -> "not-billable"
    ChargeitemstatusAborted -> "aborted"
    ChargeitemstatusBilled -> "billed"
    ChargeitemstatusEnteredinerror -> "entered-in-error"
    ChargeitemstatusUnknown -> "unknown"
  }
}

pub fn chargeitemstatus_from_string(s: String) -> Result(Chargeitemstatus, Nil) {
  case s {
    "planned" -> Ok(ChargeitemstatusPlanned)
    "billable" -> Ok(ChargeitemstatusBillable)
    "not-billable" -> Ok(ChargeitemstatusNotbillable)
    "aborted" -> Ok(ChargeitemstatusAborted)
    "billed" -> Ok(ChargeitemstatusBilled)
    "entered-in-error" -> Ok(ChargeitemstatusEnteredinerror)
    "unknown" -> Ok(ChargeitemstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn chargeitemstatus_decoder() -> Decoder(Chargeitemstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "planned" -> decode.success(ChargeitemstatusPlanned)
    "billable" -> decode.success(ChargeitemstatusBillable)
    "not-billable" -> decode.success(ChargeitemstatusNotbillable)
    "aborted" -> decode.success(ChargeitemstatusAborted)
    "billed" -> decode.success(ChargeitemstatusBilled)
    "entered-in-error" -> decode.success(ChargeitemstatusEnteredinerror)
    "unknown" -> decode.success(ChargeitemstatusUnknown)
    _ -> decode.failure(ChargeitemstatusPlanned, "Chargeitemstatus")
  }
}

pub type Claimoutcome {
  ClaimoutcomeQueued
  ClaimoutcomeComplete
  ClaimoutcomeError
  ClaimoutcomePartial
}

pub fn claimoutcome_to_json(claimoutcome: Claimoutcome) -> Json {
  json.string(claimoutcome_to_string(claimoutcome))
}

pub fn claimoutcome_to_string(claimoutcome: Claimoutcome) -> String {
  case claimoutcome {
    ClaimoutcomeQueued -> "queued"
    ClaimoutcomeComplete -> "complete"
    ClaimoutcomeError -> "error"
    ClaimoutcomePartial -> "partial"
  }
}

pub fn claimoutcome_from_string(s: String) -> Result(Claimoutcome, Nil) {
  case s {
    "queued" -> Ok(ClaimoutcomeQueued)
    "complete" -> Ok(ClaimoutcomeComplete)
    "error" -> Ok(ClaimoutcomeError)
    "partial" -> Ok(ClaimoutcomePartial)
    _ -> Error(Nil)
  }
}

pub fn claimoutcome_decoder() -> Decoder(Claimoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "queued" -> decode.success(ClaimoutcomeQueued)
    "complete" -> decode.success(ClaimoutcomeComplete)
    "error" -> decode.success(ClaimoutcomeError)
    "partial" -> decode.success(ClaimoutcomePartial)
    _ -> decode.failure(ClaimoutcomeQueued, "Claimoutcome")
  }
}

pub type Claimuse {
  ClaimuseClaim
  ClaimusePreauthorization
  ClaimusePredetermination
}

pub fn claimuse_to_json(claimuse: Claimuse) -> Json {
  json.string(claimuse_to_string(claimuse))
}

pub fn claimuse_to_string(claimuse: Claimuse) -> String {
  case claimuse {
    ClaimuseClaim -> "claim"
    ClaimusePreauthorization -> "preauthorization"
    ClaimusePredetermination -> "predetermination"
  }
}

pub fn claimuse_from_string(s: String) -> Result(Claimuse, Nil) {
  case s {
    "claim" -> Ok(ClaimuseClaim)
    "preauthorization" -> Ok(ClaimusePreauthorization)
    "predetermination" -> Ok(ClaimusePredetermination)
    _ -> Error(Nil)
  }
}

pub fn claimuse_decoder() -> Decoder(Claimuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "claim" -> decode.success(ClaimuseClaim)
    "preauthorization" -> decode.success(ClaimusePreauthorization)
    "predetermination" -> decode.success(ClaimusePredetermination)
    _ -> decode.failure(ClaimuseClaim, "Claimuse")
  }
}

pub type Clinicalusedefinitiontype {
  ClinicalusedefinitiontypeIndication
  ClinicalusedefinitiontypeContraindication
  ClinicalusedefinitiontypeInteraction
  ClinicalusedefinitiontypeUndesirableeffect
  ClinicalusedefinitiontypeWarning
}

pub fn clinicalusedefinitiontype_to_json(
  clinicalusedefinitiontype: Clinicalusedefinitiontype,
) -> Json {
  json.string(clinicalusedefinitiontype_to_string(clinicalusedefinitiontype))
}

pub fn clinicalusedefinitiontype_to_string(
  clinicalusedefinitiontype: Clinicalusedefinitiontype,
) -> String {
  case clinicalusedefinitiontype {
    ClinicalusedefinitiontypeIndication -> "indication"
    ClinicalusedefinitiontypeContraindication -> "contraindication"
    ClinicalusedefinitiontypeInteraction -> "interaction"
    ClinicalusedefinitiontypeUndesirableeffect -> "undesirable-effect"
    ClinicalusedefinitiontypeWarning -> "warning"
  }
}

pub fn clinicalusedefinitiontype_from_string(
  s: String,
) -> Result(Clinicalusedefinitiontype, Nil) {
  case s {
    "indication" -> Ok(ClinicalusedefinitiontypeIndication)
    "contraindication" -> Ok(ClinicalusedefinitiontypeContraindication)
    "interaction" -> Ok(ClinicalusedefinitiontypeInteraction)
    "undesirable-effect" -> Ok(ClinicalusedefinitiontypeUndesirableeffect)
    "warning" -> Ok(ClinicalusedefinitiontypeWarning)
    _ -> Error(Nil)
  }
}

pub fn clinicalusedefinitiontype_decoder() -> Decoder(Clinicalusedefinitiontype) {
  use variant <- decode.then(decode.string)
  case variant {
    "indication" -> decode.success(ClinicalusedefinitiontypeIndication)
    "contraindication" ->
      decode.success(ClinicalusedefinitiontypeContraindication)
    "interaction" -> decode.success(ClinicalusedefinitiontypeInteraction)
    "undesirable-effect" ->
      decode.success(ClinicalusedefinitiontypeUndesirableeffect)
    "warning" -> decode.success(ClinicalusedefinitiontypeWarning)
    _ ->
      decode.failure(
        ClinicalusedefinitiontypeIndication,
        "Clinicalusedefinitiontype",
      )
  }
}

pub type Codesearchsupport {
  CodesearchsupportIncompose
  CodesearchsupportInexpansion
  CodesearchsupportIncomposeorexpansion
}

pub fn codesearchsupport_to_json(codesearchsupport: Codesearchsupport) -> Json {
  json.string(codesearchsupport_to_string(codesearchsupport))
}

pub fn codesearchsupport_to_string(
  codesearchsupport: Codesearchsupport,
) -> String {
  case codesearchsupport {
    CodesearchsupportIncompose -> "in-compose"
    CodesearchsupportInexpansion -> "in-expansion"
    CodesearchsupportIncomposeorexpansion -> "in-compose-or-expansion"
  }
}

pub fn codesearchsupport_from_string(
  s: String,
) -> Result(Codesearchsupport, Nil) {
  case s {
    "in-compose" -> Ok(CodesearchsupportIncompose)
    "in-expansion" -> Ok(CodesearchsupportInexpansion)
    "in-compose-or-expansion" -> Ok(CodesearchsupportIncomposeorexpansion)
    _ -> Error(Nil)
  }
}

pub fn codesearchsupport_decoder() -> Decoder(Codesearchsupport) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-compose" -> decode.success(CodesearchsupportIncompose)
    "in-expansion" -> decode.success(CodesearchsupportInexpansion)
    "in-compose-or-expansion" ->
      decode.success(CodesearchsupportIncomposeorexpansion)
    _ -> decode.failure(CodesearchsupportIncompose, "Codesearchsupport")
  }
}

pub type Codesystemcontentmode {
  CodesystemcontentmodeNotpresent
  CodesystemcontentmodeExample
  CodesystemcontentmodeFragment
  CodesystemcontentmodeComplete
  CodesystemcontentmodeSupplement
}

pub fn codesystemcontentmode_to_json(
  codesystemcontentmode: Codesystemcontentmode,
) -> Json {
  json.string(codesystemcontentmode_to_string(codesystemcontentmode))
}

pub fn codesystemcontentmode_to_string(
  codesystemcontentmode: Codesystemcontentmode,
) -> String {
  case codesystemcontentmode {
    CodesystemcontentmodeNotpresent -> "not-present"
    CodesystemcontentmodeExample -> "example"
    CodesystemcontentmodeFragment -> "fragment"
    CodesystemcontentmodeComplete -> "complete"
    CodesystemcontentmodeSupplement -> "supplement"
  }
}

pub fn codesystemcontentmode_from_string(
  s: String,
) -> Result(Codesystemcontentmode, Nil) {
  case s {
    "not-present" -> Ok(CodesystemcontentmodeNotpresent)
    "example" -> Ok(CodesystemcontentmodeExample)
    "fragment" -> Ok(CodesystemcontentmodeFragment)
    "complete" -> Ok(CodesystemcontentmodeComplete)
    "supplement" -> Ok(CodesystemcontentmodeSupplement)
    _ -> Error(Nil)
  }
}

pub fn codesystemcontentmode_decoder() -> Decoder(Codesystemcontentmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-present" -> decode.success(CodesystemcontentmodeNotpresent)
    "example" -> decode.success(CodesystemcontentmodeExample)
    "fragment" -> decode.success(CodesystemcontentmodeFragment)
    "complete" -> decode.success(CodesystemcontentmodeComplete)
    "supplement" -> decode.success(CodesystemcontentmodeSupplement)
    _ ->
      decode.failure(CodesystemcontentmodeNotpresent, "Codesystemcontentmode")
  }
}

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningGroupedby
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningClassifiedwith
}

pub fn codesystemhierarchymeaning_to_json(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> Json {
  json.string(codesystemhierarchymeaning_to_string(codesystemhierarchymeaning))
}

pub fn codesystemhierarchymeaning_to_string(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> String {
  case codesystemhierarchymeaning {
    CodesystemhierarchymeaningGroupedby -> "grouped-by"
    CodesystemhierarchymeaningIsa -> "is-a"
    CodesystemhierarchymeaningPartof -> "part-of"
    CodesystemhierarchymeaningClassifiedwith -> "classified-with"
  }
}

pub fn codesystemhierarchymeaning_from_string(
  s: String,
) -> Result(Codesystemhierarchymeaning, Nil) {
  case s {
    "grouped-by" -> Ok(CodesystemhierarchymeaningGroupedby)
    "is-a" -> Ok(CodesystemhierarchymeaningIsa)
    "part-of" -> Ok(CodesystemhierarchymeaningPartof)
    "classified-with" -> Ok(CodesystemhierarchymeaningClassifiedwith)
    _ -> Error(Nil)
  }
}

pub fn codesystemhierarchymeaning_decoder() -> Decoder(
  Codesystemhierarchymeaning,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "grouped-by" -> decode.success(CodesystemhierarchymeaningGroupedby)
    "is-a" -> decode.success(CodesystemhierarchymeaningIsa)
    "part-of" -> decode.success(CodesystemhierarchymeaningPartof)
    "classified-with" ->
      decode.success(CodesystemhierarchymeaningClassifiedwith)
    _ ->
      decode.failure(
        CodesystemhierarchymeaningGroupedby,
        "Codesystemhierarchymeaning",
      )
  }
}

pub type Compartmenttype {
  CompartmenttypePatient
  CompartmenttypeEncounter
  CompartmenttypeRelatedperson
  CompartmenttypePractitioner
  CompartmenttypeDevice
  CompartmenttypeEpisodeofcare
}

pub fn compartmenttype_to_json(compartmenttype: Compartmenttype) -> Json {
  json.string(compartmenttype_to_string(compartmenttype))
}

pub fn compartmenttype_to_string(compartmenttype: Compartmenttype) -> String {
  case compartmenttype {
    CompartmenttypePatient -> "Patient"
    CompartmenttypeEncounter -> "Encounter"
    CompartmenttypeRelatedperson -> "RelatedPerson"
    CompartmenttypePractitioner -> "Practitioner"
    CompartmenttypeDevice -> "Device"
    CompartmenttypeEpisodeofcare -> "EpisodeOfCare"
  }
}

pub fn compartmenttype_from_string(s: String) -> Result(Compartmenttype, Nil) {
  case s {
    "Patient" -> Ok(CompartmenttypePatient)
    "Encounter" -> Ok(CompartmenttypeEncounter)
    "RelatedPerson" -> Ok(CompartmenttypeRelatedperson)
    "Practitioner" -> Ok(CompartmenttypePractitioner)
    "Device" -> Ok(CompartmenttypeDevice)
    "EpisodeOfCare" -> Ok(CompartmenttypeEpisodeofcare)
    _ -> Error(Nil)
  }
}

pub fn compartmenttype_decoder() -> Decoder(Compartmenttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "Patient" -> decode.success(CompartmenttypePatient)
    "Encounter" -> decode.success(CompartmenttypeEncounter)
    "RelatedPerson" -> decode.success(CompartmenttypeRelatedperson)
    "Practitioner" -> decode.success(CompartmenttypePractitioner)
    "Device" -> decode.success(CompartmenttypeDevice)
    "EpisodeOfCare" -> decode.success(CompartmenttypeEpisodeofcare)
    _ -> decode.failure(CompartmenttypePatient, "Compartmenttype")
  }
}

pub type Compositionstatus {
  CompositionstatusRegistered
  CompositionstatusPartial
  CompositionstatusPreliminary
  CompositionstatusFinal
  CompositionstatusAmended
  CompositionstatusCorrected
  CompositionstatusAppended
  CompositionstatusCancelled
  CompositionstatusEnteredinerror
  CompositionstatusDeprecated
  CompositionstatusUnknown
}

pub fn compositionstatus_to_json(compositionstatus: Compositionstatus) -> Json {
  json.string(compositionstatus_to_string(compositionstatus))
}

pub fn compositionstatus_to_string(
  compositionstatus: Compositionstatus,
) -> String {
  case compositionstatus {
    CompositionstatusRegistered -> "registered"
    CompositionstatusPartial -> "partial"
    CompositionstatusPreliminary -> "preliminary"
    CompositionstatusFinal -> "final"
    CompositionstatusAmended -> "amended"
    CompositionstatusCorrected -> "corrected"
    CompositionstatusAppended -> "appended"
    CompositionstatusCancelled -> "cancelled"
    CompositionstatusEnteredinerror -> "entered-in-error"
    CompositionstatusDeprecated -> "deprecated"
    CompositionstatusUnknown -> "unknown"
  }
}

pub fn compositionstatus_from_string(
  s: String,
) -> Result(Compositionstatus, Nil) {
  case s {
    "registered" -> Ok(CompositionstatusRegistered)
    "partial" -> Ok(CompositionstatusPartial)
    "preliminary" -> Ok(CompositionstatusPreliminary)
    "final" -> Ok(CompositionstatusFinal)
    "amended" -> Ok(CompositionstatusAmended)
    "corrected" -> Ok(CompositionstatusCorrected)
    "appended" -> Ok(CompositionstatusAppended)
    "cancelled" -> Ok(CompositionstatusCancelled)
    "entered-in-error" -> Ok(CompositionstatusEnteredinerror)
    "deprecated" -> Ok(CompositionstatusDeprecated)
    "unknown" -> Ok(CompositionstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn compositionstatus_decoder() -> Decoder(Compositionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered" -> decode.success(CompositionstatusRegistered)
    "partial" -> decode.success(CompositionstatusPartial)
    "preliminary" -> decode.success(CompositionstatusPreliminary)
    "final" -> decode.success(CompositionstatusFinal)
    "amended" -> decode.success(CompositionstatusAmended)
    "corrected" -> decode.success(CompositionstatusCorrected)
    "appended" -> decode.success(CompositionstatusAppended)
    "cancelled" -> decode.success(CompositionstatusCancelled)
    "entered-in-error" -> decode.success(CompositionstatusEnteredinerror)
    "deprecated" -> decode.success(CompositionstatusDeprecated)
    "unknown" -> decode.success(CompositionstatusUnknown)
    _ -> decode.failure(CompositionstatusRegistered, "Compositionstatus")
  }
}

pub type Conceptmapattributetype {
  ConceptmapattributetypeCode
  ConceptmapattributetypeCoding
  ConceptmapattributetypeString
  ConceptmapattributetypeBoolean
  ConceptmapattributetypeQuantity
}

pub fn conceptmapattributetype_to_json(
  conceptmapattributetype: Conceptmapattributetype,
) -> Json {
  json.string(conceptmapattributetype_to_string(conceptmapattributetype))
}

pub fn conceptmapattributetype_to_string(
  conceptmapattributetype: Conceptmapattributetype,
) -> String {
  case conceptmapattributetype {
    ConceptmapattributetypeCode -> "code"
    ConceptmapattributetypeCoding -> "Coding"
    ConceptmapattributetypeString -> "string"
    ConceptmapattributetypeBoolean -> "boolean"
    ConceptmapattributetypeQuantity -> "Quantity"
  }
}

pub fn conceptmapattributetype_from_string(
  s: String,
) -> Result(Conceptmapattributetype, Nil) {
  case s {
    "code" -> Ok(ConceptmapattributetypeCode)
    "Coding" -> Ok(ConceptmapattributetypeCoding)
    "string" -> Ok(ConceptmapattributetypeString)
    "boolean" -> Ok(ConceptmapattributetypeBoolean)
    "Quantity" -> Ok(ConceptmapattributetypeQuantity)
    _ -> Error(Nil)
  }
}

pub fn conceptmapattributetype_decoder() -> Decoder(Conceptmapattributetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "code" -> decode.success(ConceptmapattributetypeCode)
    "Coding" -> decode.success(ConceptmapattributetypeCoding)
    "string" -> decode.success(ConceptmapattributetypeString)
    "boolean" -> decode.success(ConceptmapattributetypeBoolean)
    "Quantity" -> decode.success(ConceptmapattributetypeQuantity)
    _ -> decode.failure(ConceptmapattributetypeCode, "Conceptmapattributetype")
  }
}

pub type Conceptmappropertytype {
  ConceptmappropertytypeCoding
  ConceptmappropertytypeString
  ConceptmappropertytypeInteger
  ConceptmappropertytypeBoolean
  ConceptmappropertytypeDatetime
  ConceptmappropertytypeDecimal
  ConceptmappropertytypeCode
}

pub fn conceptmappropertytype_to_json(
  conceptmappropertytype: Conceptmappropertytype,
) -> Json {
  json.string(conceptmappropertytype_to_string(conceptmappropertytype))
}

pub fn conceptmappropertytype_to_string(
  conceptmappropertytype: Conceptmappropertytype,
) -> String {
  case conceptmappropertytype {
    ConceptmappropertytypeCoding -> "Coding"
    ConceptmappropertytypeString -> "string"
    ConceptmappropertytypeInteger -> "integer"
    ConceptmappropertytypeBoolean -> "boolean"
    ConceptmappropertytypeDatetime -> "dateTime"
    ConceptmappropertytypeDecimal -> "decimal"
    ConceptmappropertytypeCode -> "code"
  }
}

pub fn conceptmappropertytype_from_string(
  s: String,
) -> Result(Conceptmappropertytype, Nil) {
  case s {
    "Coding" -> Ok(ConceptmappropertytypeCoding)
    "string" -> Ok(ConceptmappropertytypeString)
    "integer" -> Ok(ConceptmappropertytypeInteger)
    "boolean" -> Ok(ConceptmappropertytypeBoolean)
    "dateTime" -> Ok(ConceptmappropertytypeDatetime)
    "decimal" -> Ok(ConceptmappropertytypeDecimal)
    "code" -> Ok(ConceptmappropertytypeCode)
    _ -> Error(Nil)
  }
}

pub fn conceptmappropertytype_decoder() -> Decoder(Conceptmappropertytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "Coding" -> decode.success(ConceptmappropertytypeCoding)
    "string" -> decode.success(ConceptmappropertytypeString)
    "integer" -> decode.success(ConceptmappropertytypeInteger)
    "boolean" -> decode.success(ConceptmappropertytypeBoolean)
    "dateTime" -> decode.success(ConceptmappropertytypeDatetime)
    "decimal" -> decode.success(ConceptmappropertytypeDecimal)
    "code" -> decode.success(ConceptmappropertytypeCode)
    _ -> decode.failure(ConceptmappropertytypeCoding, "Conceptmappropertytype")
  }
}

pub type Conceptmaprelationship {
  ConceptmaprelationshipRelatedto
  ConceptmaprelationshipEquivalent
  ConceptmaprelationshipSourceisnarrowerthantarget
  ConceptmaprelationshipSourceisbroaderthantarget
  ConceptmaprelationshipNotrelatedto
}

pub fn conceptmaprelationship_to_json(
  conceptmaprelationship: Conceptmaprelationship,
) -> Json {
  json.string(conceptmaprelationship_to_string(conceptmaprelationship))
}

pub fn conceptmaprelationship_to_string(
  conceptmaprelationship: Conceptmaprelationship,
) -> String {
  case conceptmaprelationship {
    ConceptmaprelationshipRelatedto -> "related-to"
    ConceptmaprelationshipEquivalent -> "equivalent"
    ConceptmaprelationshipSourceisnarrowerthantarget ->
      "source-is-narrower-than-target"
    ConceptmaprelationshipSourceisbroaderthantarget ->
      "source-is-broader-than-target"
    ConceptmaprelationshipNotrelatedto -> "not-related-to"
  }
}

pub fn conceptmaprelationship_from_string(
  s: String,
) -> Result(Conceptmaprelationship, Nil) {
  case s {
    "related-to" -> Ok(ConceptmaprelationshipRelatedto)
    "equivalent" -> Ok(ConceptmaprelationshipEquivalent)
    "source-is-narrower-than-target" ->
      Ok(ConceptmaprelationshipSourceisnarrowerthantarget)
    "source-is-broader-than-target" ->
      Ok(ConceptmaprelationshipSourceisbroaderthantarget)
    "not-related-to" -> Ok(ConceptmaprelationshipNotrelatedto)
    _ -> Error(Nil)
  }
}

pub fn conceptmaprelationship_decoder() -> Decoder(Conceptmaprelationship) {
  use variant <- decode.then(decode.string)
  case variant {
    "related-to" -> decode.success(ConceptmaprelationshipRelatedto)
    "equivalent" -> decode.success(ConceptmaprelationshipEquivalent)
    "source-is-narrower-than-target" ->
      decode.success(ConceptmaprelationshipSourceisnarrowerthantarget)
    "source-is-broader-than-target" ->
      decode.success(ConceptmaprelationshipSourceisbroaderthantarget)
    "not-related-to" -> decode.success(ConceptmaprelationshipNotrelatedto)
    _ ->
      decode.failure(ConceptmaprelationshipRelatedto, "Conceptmaprelationship")
  }
}

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeUsesourcecode
  ConceptmapunmappedmodeFixed
  ConceptmapunmappedmodeOthermap
}

pub fn conceptmapunmappedmode_to_json(
  conceptmapunmappedmode: Conceptmapunmappedmode,
) -> Json {
  json.string(conceptmapunmappedmode_to_string(conceptmapunmappedmode))
}

pub fn conceptmapunmappedmode_to_string(
  conceptmapunmappedmode: Conceptmapunmappedmode,
) -> String {
  case conceptmapunmappedmode {
    ConceptmapunmappedmodeUsesourcecode -> "use-source-code"
    ConceptmapunmappedmodeFixed -> "fixed"
    ConceptmapunmappedmodeOthermap -> "other-map"
  }
}

pub fn conceptmapunmappedmode_from_string(
  s: String,
) -> Result(Conceptmapunmappedmode, Nil) {
  case s {
    "use-source-code" -> Ok(ConceptmapunmappedmodeUsesourcecode)
    "fixed" -> Ok(ConceptmapunmappedmodeFixed)
    "other-map" -> Ok(ConceptmapunmappedmodeOthermap)
    _ -> Error(Nil)
  }
}

pub fn conceptmapunmappedmode_decoder() -> Decoder(Conceptmapunmappedmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "use-source-code" -> decode.success(ConceptmapunmappedmodeUsesourcecode)
    "fixed" -> decode.success(ConceptmapunmappedmodeFixed)
    "other-map" -> decode.success(ConceptmapunmappedmodeOthermap)
    _ ->
      decode.failure(
        ConceptmapunmappedmodeUsesourcecode,
        "Conceptmapunmappedmode",
      )
  }
}

pub type Conceptpropertytype {
  ConceptpropertytypeCode
  ConceptpropertytypeCoding
  ConceptpropertytypeString
  ConceptpropertytypeInteger
  ConceptpropertytypeBoolean
  ConceptpropertytypeDatetime
  ConceptpropertytypeDecimal
}

pub fn conceptpropertytype_to_json(
  conceptpropertytype: Conceptpropertytype,
) -> Json {
  json.string(conceptpropertytype_to_string(conceptpropertytype))
}

pub fn conceptpropertytype_to_string(
  conceptpropertytype: Conceptpropertytype,
) -> String {
  case conceptpropertytype {
    ConceptpropertytypeCode -> "code"
    ConceptpropertytypeCoding -> "Coding"
    ConceptpropertytypeString -> "string"
    ConceptpropertytypeInteger -> "integer"
    ConceptpropertytypeBoolean -> "boolean"
    ConceptpropertytypeDatetime -> "dateTime"
    ConceptpropertytypeDecimal -> "decimal"
  }
}

pub fn conceptpropertytype_from_string(
  s: String,
) -> Result(Conceptpropertytype, Nil) {
  case s {
    "code" -> Ok(ConceptpropertytypeCode)
    "Coding" -> Ok(ConceptpropertytypeCoding)
    "string" -> Ok(ConceptpropertytypeString)
    "integer" -> Ok(ConceptpropertytypeInteger)
    "boolean" -> Ok(ConceptpropertytypeBoolean)
    "dateTime" -> Ok(ConceptpropertytypeDatetime)
    "decimal" -> Ok(ConceptpropertytypeDecimal)
    _ -> Error(Nil)
  }
}

pub fn conceptpropertytype_decoder() -> Decoder(Conceptpropertytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "code" -> decode.success(ConceptpropertytypeCode)
    "Coding" -> decode.success(ConceptpropertytypeCoding)
    "string" -> decode.success(ConceptpropertytypeString)
    "integer" -> decode.success(ConceptpropertytypeInteger)
    "boolean" -> decode.success(ConceptpropertytypeBoolean)
    "dateTime" -> decode.success(ConceptpropertytypeDatetime)
    "decimal" -> decode.success(ConceptpropertytypeDecimal)
    _ -> decode.failure(ConceptpropertytypeCode, "Conceptpropertytype")
  }
}

pub type Conditionaldeletestatus {
  ConditionaldeletestatusNotsupported
  ConditionaldeletestatusSingle
  ConditionaldeletestatusMultiple
}

pub fn conditionaldeletestatus_to_json(
  conditionaldeletestatus: Conditionaldeletestatus,
) -> Json {
  json.string(conditionaldeletestatus_to_string(conditionaldeletestatus))
}

pub fn conditionaldeletestatus_to_string(
  conditionaldeletestatus: Conditionaldeletestatus,
) -> String {
  case conditionaldeletestatus {
    ConditionaldeletestatusNotsupported -> "not-supported"
    ConditionaldeletestatusSingle -> "single"
    ConditionaldeletestatusMultiple -> "multiple"
  }
}

pub fn conditionaldeletestatus_from_string(
  s: String,
) -> Result(Conditionaldeletestatus, Nil) {
  case s {
    "not-supported" -> Ok(ConditionaldeletestatusNotsupported)
    "single" -> Ok(ConditionaldeletestatusSingle)
    "multiple" -> Ok(ConditionaldeletestatusMultiple)
    _ -> Error(Nil)
  }
}

pub fn conditionaldeletestatus_decoder() -> Decoder(Conditionaldeletestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-supported" -> decode.success(ConditionaldeletestatusNotsupported)
    "single" -> decode.success(ConditionaldeletestatusSingle)
    "multiple" -> decode.success(ConditionaldeletestatusMultiple)
    _ ->
      decode.failure(
        ConditionaldeletestatusNotsupported,
        "Conditionaldeletestatus",
      )
  }
}

pub type Conditionalreadstatus {
  ConditionalreadstatusNotsupported
  ConditionalreadstatusModifiedsince
  ConditionalreadstatusNotmatch
  ConditionalreadstatusFullsupport
}

pub fn conditionalreadstatus_to_json(
  conditionalreadstatus: Conditionalreadstatus,
) -> Json {
  json.string(conditionalreadstatus_to_string(conditionalreadstatus))
}

pub fn conditionalreadstatus_to_string(
  conditionalreadstatus: Conditionalreadstatus,
) -> String {
  case conditionalreadstatus {
    ConditionalreadstatusNotsupported -> "not-supported"
    ConditionalreadstatusModifiedsince -> "modified-since"
    ConditionalreadstatusNotmatch -> "not-match"
    ConditionalreadstatusFullsupport -> "full-support"
  }
}

pub fn conditionalreadstatus_from_string(
  s: String,
) -> Result(Conditionalreadstatus, Nil) {
  case s {
    "not-supported" -> Ok(ConditionalreadstatusNotsupported)
    "modified-since" -> Ok(ConditionalreadstatusModifiedsince)
    "not-match" -> Ok(ConditionalreadstatusNotmatch)
    "full-support" -> Ok(ConditionalreadstatusFullsupport)
    _ -> Error(Nil)
  }
}

pub fn conditionalreadstatus_decoder() -> Decoder(Conditionalreadstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-supported" -> decode.success(ConditionalreadstatusNotsupported)
    "modified-since" -> decode.success(ConditionalreadstatusModifiedsince)
    "not-match" -> decode.success(ConditionalreadstatusNotmatch)
    "full-support" -> decode.success(ConditionalreadstatusFullsupport)
    _ ->
      decode.failure(ConditionalreadstatusNotsupported, "Conditionalreadstatus")
  }
}

pub type Conditionpreconditiontype {
  ConditionpreconditiontypeSensitive
  ConditionpreconditiontypeSpecific
}

pub fn conditionpreconditiontype_to_json(
  conditionpreconditiontype: Conditionpreconditiontype,
) -> Json {
  json.string(conditionpreconditiontype_to_string(conditionpreconditiontype))
}

pub fn conditionpreconditiontype_to_string(
  conditionpreconditiontype: Conditionpreconditiontype,
) -> String {
  case conditionpreconditiontype {
    ConditionpreconditiontypeSensitive -> "sensitive"
    ConditionpreconditiontypeSpecific -> "specific"
  }
}

pub fn conditionpreconditiontype_from_string(
  s: String,
) -> Result(Conditionpreconditiontype, Nil) {
  case s {
    "sensitive" -> Ok(ConditionpreconditiontypeSensitive)
    "specific" -> Ok(ConditionpreconditiontypeSpecific)
    _ -> Error(Nil)
  }
}

pub fn conditionpreconditiontype_decoder() -> Decoder(Conditionpreconditiontype) {
  use variant <- decode.then(decode.string)
  case variant {
    "sensitive" -> decode.success(ConditionpreconditiontypeSensitive)
    "specific" -> decode.success(ConditionpreconditiontypeSpecific)
    _ ->
      decode.failure(
        ConditionpreconditiontypeSensitive,
        "Conditionpreconditiontype",
      )
  }
}

pub type Conditionquestionnairepurpose {
  ConditionquestionnairepurposePreadmit
  ConditionquestionnairepurposeDiffdiagnosis
  ConditionquestionnairepurposeOutcome
}

pub fn conditionquestionnairepurpose_to_json(
  conditionquestionnairepurpose: Conditionquestionnairepurpose,
) -> Json {
  json.string(conditionquestionnairepurpose_to_string(
    conditionquestionnairepurpose,
  ))
}

pub fn conditionquestionnairepurpose_to_string(
  conditionquestionnairepurpose: Conditionquestionnairepurpose,
) -> String {
  case conditionquestionnairepurpose {
    ConditionquestionnairepurposePreadmit -> "preadmit"
    ConditionquestionnairepurposeDiffdiagnosis -> "diff-diagnosis"
    ConditionquestionnairepurposeOutcome -> "outcome"
  }
}

pub fn conditionquestionnairepurpose_from_string(
  s: String,
) -> Result(Conditionquestionnairepurpose, Nil) {
  case s {
    "preadmit" -> Ok(ConditionquestionnairepurposePreadmit)
    "diff-diagnosis" -> Ok(ConditionquestionnairepurposeDiffdiagnosis)
    "outcome" -> Ok(ConditionquestionnairepurposeOutcome)
    _ -> Error(Nil)
  }
}

pub fn conditionquestionnairepurpose_decoder() -> Decoder(
  Conditionquestionnairepurpose,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "preadmit" -> decode.success(ConditionquestionnairepurposePreadmit)
    "diff-diagnosis" ->
      decode.success(ConditionquestionnairepurposeDiffdiagnosis)
    "outcome" -> decode.success(ConditionquestionnairepurposeOutcome)
    _ ->
      decode.failure(
        ConditionquestionnairepurposePreadmit,
        "Conditionquestionnairepurpose",
      )
  }
}

pub type Conformanceexpectation {
  ConformanceexpectationShall
  ConformanceexpectationShould
  ConformanceexpectationMay
  ConformanceexpectationShouldnot
}

pub fn conformanceexpectation_to_json(
  conformanceexpectation: Conformanceexpectation,
) -> Json {
  json.string(conformanceexpectation_to_string(conformanceexpectation))
}

pub fn conformanceexpectation_to_string(
  conformanceexpectation: Conformanceexpectation,
) -> String {
  case conformanceexpectation {
    ConformanceexpectationShall -> "SHALL"
    ConformanceexpectationShould -> "SHOULD"
    ConformanceexpectationMay -> "MAY"
    ConformanceexpectationShouldnot -> "SHOULD-NOT"
  }
}

pub fn conformanceexpectation_from_string(
  s: String,
) -> Result(Conformanceexpectation, Nil) {
  case s {
    "SHALL" -> Ok(ConformanceexpectationShall)
    "SHOULD" -> Ok(ConformanceexpectationShould)
    "MAY" -> Ok(ConformanceexpectationMay)
    "SHOULD-NOT" -> Ok(ConformanceexpectationShouldnot)
    _ -> Error(Nil)
  }
}

pub fn conformanceexpectation_decoder() -> Decoder(Conformanceexpectation) {
  use variant <- decode.then(decode.string)
  case variant {
    "SHALL" -> decode.success(ConformanceexpectationShall)
    "SHOULD" -> decode.success(ConformanceexpectationShould)
    "MAY" -> decode.success(ConformanceexpectationMay)
    "SHOULD-NOT" -> decode.success(ConformanceexpectationShouldnot)
    _ -> decode.failure(ConformanceexpectationShall, "Conformanceexpectation")
  }
}

pub type Consentdatameaning {
  ConsentdatameaningInstance
  ConsentdatameaningRelated
  ConsentdatameaningDependents
  ConsentdatameaningAuthoredby
}

pub fn consentdatameaning_to_json(
  consentdatameaning: Consentdatameaning,
) -> Json {
  json.string(consentdatameaning_to_string(consentdatameaning))
}

pub fn consentdatameaning_to_string(
  consentdatameaning: Consentdatameaning,
) -> String {
  case consentdatameaning {
    ConsentdatameaningInstance -> "instance"
    ConsentdatameaningRelated -> "related"
    ConsentdatameaningDependents -> "dependents"
    ConsentdatameaningAuthoredby -> "authoredby"
  }
}

pub fn consentdatameaning_from_string(
  s: String,
) -> Result(Consentdatameaning, Nil) {
  case s {
    "instance" -> Ok(ConsentdatameaningInstance)
    "related" -> Ok(ConsentdatameaningRelated)
    "dependents" -> Ok(ConsentdatameaningDependents)
    "authoredby" -> Ok(ConsentdatameaningAuthoredby)
    _ -> Error(Nil)
  }
}

pub fn consentdatameaning_decoder() -> Decoder(Consentdatameaning) {
  use variant <- decode.then(decode.string)
  case variant {
    "instance" -> decode.success(ConsentdatameaningInstance)
    "related" -> decode.success(ConsentdatameaningRelated)
    "dependents" -> decode.success(ConsentdatameaningDependents)
    "authoredby" -> decode.success(ConsentdatameaningAuthoredby)
    _ -> decode.failure(ConsentdatameaningInstance, "Consentdatameaning")
  }
}

pub type Consentprovisiontype {
  ConsentprovisiontypeDeny
  ConsentprovisiontypePermit
}

pub fn consentprovisiontype_to_json(
  consentprovisiontype: Consentprovisiontype,
) -> Json {
  json.string(consentprovisiontype_to_string(consentprovisiontype))
}

pub fn consentprovisiontype_to_string(
  consentprovisiontype: Consentprovisiontype,
) -> String {
  case consentprovisiontype {
    ConsentprovisiontypeDeny -> "deny"
    ConsentprovisiontypePermit -> "permit"
  }
}

pub fn consentprovisiontype_from_string(
  s: String,
) -> Result(Consentprovisiontype, Nil) {
  case s {
    "deny" -> Ok(ConsentprovisiontypeDeny)
    "permit" -> Ok(ConsentprovisiontypePermit)
    _ -> Error(Nil)
  }
}

pub fn consentprovisiontype_decoder() -> Decoder(Consentprovisiontype) {
  use variant <- decode.then(decode.string)
  case variant {
    "deny" -> decode.success(ConsentprovisiontypeDeny)
    "permit" -> decode.success(ConsentprovisiontypePermit)
    _ -> decode.failure(ConsentprovisiontypeDeny, "Consentprovisiontype")
  }
}

pub type Consentstatecodes {
  ConsentstatecodesDraft
  ConsentstatecodesActive
  ConsentstatecodesInactive
  ConsentstatecodesNotdone
  ConsentstatecodesEnteredinerror
  ConsentstatecodesUnknown
}

pub fn consentstatecodes_to_json(consentstatecodes: Consentstatecodes) -> Json {
  json.string(consentstatecodes_to_string(consentstatecodes))
}

pub fn consentstatecodes_to_string(
  consentstatecodes: Consentstatecodes,
) -> String {
  case consentstatecodes {
    ConsentstatecodesDraft -> "draft"
    ConsentstatecodesActive -> "active"
    ConsentstatecodesInactive -> "inactive"
    ConsentstatecodesNotdone -> "not-done"
    ConsentstatecodesEnteredinerror -> "entered-in-error"
    ConsentstatecodesUnknown -> "unknown"
  }
}

pub fn consentstatecodes_from_string(
  s: String,
) -> Result(Consentstatecodes, Nil) {
  case s {
    "draft" -> Ok(ConsentstatecodesDraft)
    "active" -> Ok(ConsentstatecodesActive)
    "inactive" -> Ok(ConsentstatecodesInactive)
    "not-done" -> Ok(ConsentstatecodesNotdone)
    "entered-in-error" -> Ok(ConsentstatecodesEnteredinerror)
    "unknown" -> Ok(ConsentstatecodesUnknown)
    _ -> Error(Nil)
  }
}

pub fn consentstatecodes_decoder() -> Decoder(Consentstatecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(ConsentstatecodesDraft)
    "active" -> decode.success(ConsentstatecodesActive)
    "inactive" -> decode.success(ConsentstatecodesInactive)
    "not-done" -> decode.success(ConsentstatecodesNotdone)
    "entered-in-error" -> decode.success(ConsentstatecodesEnteredinerror)
    "unknown" -> decode.success(ConsentstatecodesUnknown)
    _ -> decode.failure(ConsentstatecodesDraft, "Consentstatecodes")
  }
}

pub type Constraintseverity {
  ConstraintseverityError
  ConstraintseverityWarning
}

pub fn constraintseverity_to_json(
  constraintseverity: Constraintseverity,
) -> Json {
  json.string(constraintseverity_to_string(constraintseverity))
}

pub fn constraintseverity_to_string(
  constraintseverity: Constraintseverity,
) -> String {
  case constraintseverity {
    ConstraintseverityError -> "error"
    ConstraintseverityWarning -> "warning"
  }
}

pub fn constraintseverity_from_string(
  s: String,
) -> Result(Constraintseverity, Nil) {
  case s {
    "error" -> Ok(ConstraintseverityError)
    "warning" -> Ok(ConstraintseverityWarning)
    _ -> Error(Nil)
  }
}

pub fn constraintseverity_decoder() -> Decoder(Constraintseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "error" -> decode.success(ConstraintseverityError)
    "warning" -> decode.success(ConstraintseverityWarning)
    _ -> decode.failure(ConstraintseverityError, "Constraintseverity")
  }
}

pub type Contactpointsystem {
  ContactpointsystemPhone
  ContactpointsystemFax
  ContactpointsystemEmail
  ContactpointsystemPager
  ContactpointsystemUrl
  ContactpointsystemSms
  ContactpointsystemOther
}

pub fn contactpointsystem_to_json(
  contactpointsystem: Contactpointsystem,
) -> Json {
  json.string(contactpointsystem_to_string(contactpointsystem))
}

pub fn contactpointsystem_to_string(
  contactpointsystem: Contactpointsystem,
) -> String {
  case contactpointsystem {
    ContactpointsystemPhone -> "phone"
    ContactpointsystemFax -> "fax"
    ContactpointsystemEmail -> "email"
    ContactpointsystemPager -> "pager"
    ContactpointsystemUrl -> "url"
    ContactpointsystemSms -> "sms"
    ContactpointsystemOther -> "other"
  }
}

pub fn contactpointsystem_from_string(
  s: String,
) -> Result(Contactpointsystem, Nil) {
  case s {
    "phone" -> Ok(ContactpointsystemPhone)
    "fax" -> Ok(ContactpointsystemFax)
    "email" -> Ok(ContactpointsystemEmail)
    "pager" -> Ok(ContactpointsystemPager)
    "url" -> Ok(ContactpointsystemUrl)
    "sms" -> Ok(ContactpointsystemSms)
    "other" -> Ok(ContactpointsystemOther)
    _ -> Error(Nil)
  }
}

pub fn contactpointsystem_decoder() -> Decoder(Contactpointsystem) {
  use variant <- decode.then(decode.string)
  case variant {
    "phone" -> decode.success(ContactpointsystemPhone)
    "fax" -> decode.success(ContactpointsystemFax)
    "email" -> decode.success(ContactpointsystemEmail)
    "pager" -> decode.success(ContactpointsystemPager)
    "url" -> decode.success(ContactpointsystemUrl)
    "sms" -> decode.success(ContactpointsystemSms)
    "other" -> decode.success(ContactpointsystemOther)
    _ -> decode.failure(ContactpointsystemPhone, "Contactpointsystem")
  }
}

pub type Contactpointuse {
  ContactpointuseHome
  ContactpointuseWork
  ContactpointuseTemp
  ContactpointuseOld
  ContactpointuseMobile
}

pub fn contactpointuse_to_json(contactpointuse: Contactpointuse) -> Json {
  json.string(contactpointuse_to_string(contactpointuse))
}

pub fn contactpointuse_to_string(contactpointuse: Contactpointuse) -> String {
  case contactpointuse {
    ContactpointuseHome -> "home"
    ContactpointuseWork -> "work"
    ContactpointuseTemp -> "temp"
    ContactpointuseOld -> "old"
    ContactpointuseMobile -> "mobile"
  }
}

pub fn contactpointuse_from_string(s: String) -> Result(Contactpointuse, Nil) {
  case s {
    "home" -> Ok(ContactpointuseHome)
    "work" -> Ok(ContactpointuseWork)
    "temp" -> Ok(ContactpointuseTemp)
    "old" -> Ok(ContactpointuseOld)
    "mobile" -> Ok(ContactpointuseMobile)
    _ -> Error(Nil)
  }
}

pub fn contactpointuse_decoder() -> Decoder(Contactpointuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "home" -> decode.success(ContactpointuseHome)
    "work" -> decode.success(ContactpointuseWork)
    "temp" -> decode.success(ContactpointuseTemp)
    "old" -> decode.success(ContactpointuseOld)
    "mobile" -> decode.success(ContactpointuseMobile)
    _ -> decode.failure(ContactpointuseHome, "Contactpointuse")
  }
}

pub type Contractpublicationstatus {
  ContractpublicationstatusAmended
  ContractpublicationstatusAppended
  ContractpublicationstatusCancelled
  ContractpublicationstatusDisputed
  ContractpublicationstatusEnteredinerror
  ContractpublicationstatusExecutable
  ContractpublicationstatusExecuted
  ContractpublicationstatusNegotiable
  ContractpublicationstatusOffered
  ContractpublicationstatusPolicy
  ContractpublicationstatusRejected
  ContractpublicationstatusRenewed
  ContractpublicationstatusRevoked
  ContractpublicationstatusResolved
  ContractpublicationstatusTerminated
}

pub fn contractpublicationstatus_to_json(
  contractpublicationstatus: Contractpublicationstatus,
) -> Json {
  json.string(contractpublicationstatus_to_string(contractpublicationstatus))
}

pub fn contractpublicationstatus_to_string(
  contractpublicationstatus: Contractpublicationstatus,
) -> String {
  case contractpublicationstatus {
    ContractpublicationstatusAmended -> "amended"
    ContractpublicationstatusAppended -> "appended"
    ContractpublicationstatusCancelled -> "cancelled"
    ContractpublicationstatusDisputed -> "disputed"
    ContractpublicationstatusEnteredinerror -> "entered-in-error"
    ContractpublicationstatusExecutable -> "executable"
    ContractpublicationstatusExecuted -> "executed"
    ContractpublicationstatusNegotiable -> "negotiable"
    ContractpublicationstatusOffered -> "offered"
    ContractpublicationstatusPolicy -> "policy"
    ContractpublicationstatusRejected -> "rejected"
    ContractpublicationstatusRenewed -> "renewed"
    ContractpublicationstatusRevoked -> "revoked"
    ContractpublicationstatusResolved -> "resolved"
    ContractpublicationstatusTerminated -> "terminated"
  }
}

pub fn contractpublicationstatus_from_string(
  s: String,
) -> Result(Contractpublicationstatus, Nil) {
  case s {
    "amended" -> Ok(ContractpublicationstatusAmended)
    "appended" -> Ok(ContractpublicationstatusAppended)
    "cancelled" -> Ok(ContractpublicationstatusCancelled)
    "disputed" -> Ok(ContractpublicationstatusDisputed)
    "entered-in-error" -> Ok(ContractpublicationstatusEnteredinerror)
    "executable" -> Ok(ContractpublicationstatusExecutable)
    "executed" -> Ok(ContractpublicationstatusExecuted)
    "negotiable" -> Ok(ContractpublicationstatusNegotiable)
    "offered" -> Ok(ContractpublicationstatusOffered)
    "policy" -> Ok(ContractpublicationstatusPolicy)
    "rejected" -> Ok(ContractpublicationstatusRejected)
    "renewed" -> Ok(ContractpublicationstatusRenewed)
    "revoked" -> Ok(ContractpublicationstatusRevoked)
    "resolved" -> Ok(ContractpublicationstatusResolved)
    "terminated" -> Ok(ContractpublicationstatusTerminated)
    _ -> Error(Nil)
  }
}

pub fn contractpublicationstatus_decoder() -> Decoder(Contractpublicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "amended" -> decode.success(ContractpublicationstatusAmended)
    "appended" -> decode.success(ContractpublicationstatusAppended)
    "cancelled" -> decode.success(ContractpublicationstatusCancelled)
    "disputed" -> decode.success(ContractpublicationstatusDisputed)
    "entered-in-error" ->
      decode.success(ContractpublicationstatusEnteredinerror)
    "executable" -> decode.success(ContractpublicationstatusExecutable)
    "executed" -> decode.success(ContractpublicationstatusExecuted)
    "negotiable" -> decode.success(ContractpublicationstatusNegotiable)
    "offered" -> decode.success(ContractpublicationstatusOffered)
    "policy" -> decode.success(ContractpublicationstatusPolicy)
    "rejected" -> decode.success(ContractpublicationstatusRejected)
    "renewed" -> decode.success(ContractpublicationstatusRenewed)
    "revoked" -> decode.success(ContractpublicationstatusRevoked)
    "resolved" -> decode.success(ContractpublicationstatusResolved)
    "terminated" -> decode.success(ContractpublicationstatusTerminated)
    _ ->
      decode.failure(
        ContractpublicationstatusAmended,
        "Contractpublicationstatus",
      )
  }
}

pub type Contractstatus {
  ContractstatusAmended
  ContractstatusAppended
  ContractstatusCancelled
  ContractstatusDisputed
  ContractstatusEnteredinerror
  ContractstatusExecutable
  ContractstatusExecuted
  ContractstatusNegotiable
  ContractstatusOffered
  ContractstatusPolicy
  ContractstatusRejected
  ContractstatusRenewed
  ContractstatusRevoked
  ContractstatusResolved
  ContractstatusTerminated
}

pub fn contractstatus_to_json(contractstatus: Contractstatus) -> Json {
  json.string(contractstatus_to_string(contractstatus))
}

pub fn contractstatus_to_string(contractstatus: Contractstatus) -> String {
  case contractstatus {
    ContractstatusAmended -> "amended"
    ContractstatusAppended -> "appended"
    ContractstatusCancelled -> "cancelled"
    ContractstatusDisputed -> "disputed"
    ContractstatusEnteredinerror -> "entered-in-error"
    ContractstatusExecutable -> "executable"
    ContractstatusExecuted -> "executed"
    ContractstatusNegotiable -> "negotiable"
    ContractstatusOffered -> "offered"
    ContractstatusPolicy -> "policy"
    ContractstatusRejected -> "rejected"
    ContractstatusRenewed -> "renewed"
    ContractstatusRevoked -> "revoked"
    ContractstatusResolved -> "resolved"
    ContractstatusTerminated -> "terminated"
  }
}

pub fn contractstatus_from_string(s: String) -> Result(Contractstatus, Nil) {
  case s {
    "amended" -> Ok(ContractstatusAmended)
    "appended" -> Ok(ContractstatusAppended)
    "cancelled" -> Ok(ContractstatusCancelled)
    "disputed" -> Ok(ContractstatusDisputed)
    "entered-in-error" -> Ok(ContractstatusEnteredinerror)
    "executable" -> Ok(ContractstatusExecutable)
    "executed" -> Ok(ContractstatusExecuted)
    "negotiable" -> Ok(ContractstatusNegotiable)
    "offered" -> Ok(ContractstatusOffered)
    "policy" -> Ok(ContractstatusPolicy)
    "rejected" -> Ok(ContractstatusRejected)
    "renewed" -> Ok(ContractstatusRenewed)
    "revoked" -> Ok(ContractstatusRevoked)
    "resolved" -> Ok(ContractstatusResolved)
    "terminated" -> Ok(ContractstatusTerminated)
    _ -> Error(Nil)
  }
}

pub fn contractstatus_decoder() -> Decoder(Contractstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "amended" -> decode.success(ContractstatusAmended)
    "appended" -> decode.success(ContractstatusAppended)
    "cancelled" -> decode.success(ContractstatusCancelled)
    "disputed" -> decode.success(ContractstatusDisputed)
    "entered-in-error" -> decode.success(ContractstatusEnteredinerror)
    "executable" -> decode.success(ContractstatusExecutable)
    "executed" -> decode.success(ContractstatusExecuted)
    "negotiable" -> decode.success(ContractstatusNegotiable)
    "offered" -> decode.success(ContractstatusOffered)
    "policy" -> decode.success(ContractstatusPolicy)
    "rejected" -> decode.success(ContractstatusRejected)
    "renewed" -> decode.success(ContractstatusRenewed)
    "revoked" -> decode.success(ContractstatusRevoked)
    "resolved" -> decode.success(ContractstatusResolved)
    "terminated" -> decode.success(ContractstatusTerminated)
    _ -> decode.failure(ContractstatusAmended, "Contractstatus")
  }
}

pub type Contributortype {
  ContributortypeAuthor
  ContributortypeEditor
  ContributortypeReviewer
  ContributortypeEndorser
}

pub fn contributortype_to_json(contributortype: Contributortype) -> Json {
  json.string(contributortype_to_string(contributortype))
}

pub fn contributortype_to_string(contributortype: Contributortype) -> String {
  case contributortype {
    ContributortypeAuthor -> "author"
    ContributortypeEditor -> "editor"
    ContributortypeReviewer -> "reviewer"
    ContributortypeEndorser -> "endorser"
  }
}

pub fn contributortype_from_string(s: String) -> Result(Contributortype, Nil) {
  case s {
    "author" -> Ok(ContributortypeAuthor)
    "editor" -> Ok(ContributortypeEditor)
    "reviewer" -> Ok(ContributortypeReviewer)
    "endorser" -> Ok(ContributortypeEndorser)
    _ -> Error(Nil)
  }
}

pub fn contributortype_decoder() -> Decoder(Contributortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "author" -> decode.success(ContributortypeAuthor)
    "editor" -> decode.success(ContributortypeEditor)
    "reviewer" -> decode.success(ContributortypeReviewer)
    "endorser" -> decode.success(ContributortypeEndorser)
    _ -> decode.failure(ContributortypeAuthor, "Contributortype")
  }
}

pub type Coveragekind {
  CoveragekindInsurance
  CoveragekindSelfpay
  CoveragekindOther
}

pub fn coveragekind_to_json(coveragekind: Coveragekind) -> Json {
  json.string(coveragekind_to_string(coveragekind))
}

pub fn coveragekind_to_string(coveragekind: Coveragekind) -> String {
  case coveragekind {
    CoveragekindInsurance -> "insurance"
    CoveragekindSelfpay -> "self-pay"
    CoveragekindOther -> "other"
  }
}

pub fn coveragekind_from_string(s: String) -> Result(Coveragekind, Nil) {
  case s {
    "insurance" -> Ok(CoveragekindInsurance)
    "self-pay" -> Ok(CoveragekindSelfpay)
    "other" -> Ok(CoveragekindOther)
    _ -> Error(Nil)
  }
}

pub fn coveragekind_decoder() -> Decoder(Coveragekind) {
  use variant <- decode.then(decode.string)
  case variant {
    "insurance" -> decode.success(CoveragekindInsurance)
    "self-pay" -> decode.success(CoveragekindSelfpay)
    "other" -> decode.success(CoveragekindOther)
    _ -> decode.failure(CoveragekindInsurance, "Coveragekind")
  }
}

pub type Daysofweek {
  DaysofweekMon
  DaysofweekTue
  DaysofweekWed
  DaysofweekThu
  DaysofweekFri
  DaysofweekSat
  DaysofweekSun
}

pub fn daysofweek_to_json(daysofweek: Daysofweek) -> Json {
  json.string(daysofweek_to_string(daysofweek))
}

pub fn daysofweek_to_string(daysofweek: Daysofweek) -> String {
  case daysofweek {
    DaysofweekMon -> "mon"
    DaysofweekTue -> "tue"
    DaysofweekWed -> "wed"
    DaysofweekThu -> "thu"
    DaysofweekFri -> "fri"
    DaysofweekSat -> "sat"
    DaysofweekSun -> "sun"
  }
}

pub fn daysofweek_from_string(s: String) -> Result(Daysofweek, Nil) {
  case s {
    "mon" -> Ok(DaysofweekMon)
    "tue" -> Ok(DaysofweekTue)
    "wed" -> Ok(DaysofweekWed)
    "thu" -> Ok(DaysofweekThu)
    "fri" -> Ok(DaysofweekFri)
    "sat" -> Ok(DaysofweekSat)
    "sun" -> Ok(DaysofweekSun)
    _ -> Error(Nil)
  }
}

pub fn daysofweek_decoder() -> Decoder(Daysofweek) {
  use variant <- decode.then(decode.string)
  case variant {
    "mon" -> decode.success(DaysofweekMon)
    "tue" -> decode.success(DaysofweekTue)
    "wed" -> decode.success(DaysofweekWed)
    "thu" -> decode.success(DaysofweekThu)
    "fri" -> decode.success(DaysofweekFri)
    "sat" -> decode.success(DaysofweekSat)
    "sun" -> decode.success(DaysofweekSun)
    _ -> decode.failure(DaysofweekMon, "Daysofweek")
  }
}

pub type Detectedissueseverity {
  DetectedissueseverityHigh
  DetectedissueseverityModerate
  DetectedissueseverityLow
}

pub fn detectedissueseverity_to_json(
  detectedissueseverity: Detectedissueseverity,
) -> Json {
  json.string(detectedissueseverity_to_string(detectedissueseverity))
}

pub fn detectedissueseverity_to_string(
  detectedissueseverity: Detectedissueseverity,
) -> String {
  case detectedissueseverity {
    DetectedissueseverityHigh -> "high"
    DetectedissueseverityModerate -> "moderate"
    DetectedissueseverityLow -> "low"
  }
}

pub fn detectedissueseverity_from_string(
  s: String,
) -> Result(Detectedissueseverity, Nil) {
  case s {
    "high" -> Ok(DetectedissueseverityHigh)
    "moderate" -> Ok(DetectedissueseverityModerate)
    "low" -> Ok(DetectedissueseverityLow)
    _ -> Error(Nil)
  }
}

pub fn detectedissueseverity_decoder() -> Decoder(Detectedissueseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "high" -> decode.success(DetectedissueseverityHigh)
    "moderate" -> decode.success(DetectedissueseverityModerate)
    "low" -> decode.success(DetectedissueseverityLow)
    _ -> decode.failure(DetectedissueseverityHigh, "Detectedissueseverity")
  }
}

pub type Detectedissuestatus {
  DetectedissuestatusPreliminary
  DetectedissuestatusFinal
  DetectedissuestatusEnteredinerror
  DetectedissuestatusMitigated
}

pub fn detectedissuestatus_to_json(
  detectedissuestatus: Detectedissuestatus,
) -> Json {
  json.string(detectedissuestatus_to_string(detectedissuestatus))
}

pub fn detectedissuestatus_to_string(
  detectedissuestatus: Detectedissuestatus,
) -> String {
  case detectedissuestatus {
    DetectedissuestatusPreliminary -> "preliminary"
    DetectedissuestatusFinal -> "final"
    DetectedissuestatusEnteredinerror -> "entered-in-error"
    DetectedissuestatusMitigated -> "mitigated"
  }
}

pub fn detectedissuestatus_from_string(
  s: String,
) -> Result(Detectedissuestatus, Nil) {
  case s {
    "preliminary" -> Ok(DetectedissuestatusPreliminary)
    "final" -> Ok(DetectedissuestatusFinal)
    "entered-in-error" -> Ok(DetectedissuestatusEnteredinerror)
    "mitigated" -> Ok(DetectedissuestatusMitigated)
    _ -> Error(Nil)
  }
}

pub fn detectedissuestatus_decoder() -> Decoder(Detectedissuestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "preliminary" -> decode.success(DetectedissuestatusPreliminary)
    "final" -> decode.success(DetectedissuestatusFinal)
    "entered-in-error" -> decode.success(DetectedissuestatusEnteredinerror)
    "mitigated" -> decode.success(DetectedissuestatusMitigated)
    _ -> decode.failure(DetectedissuestatusPreliminary, "Detectedissuestatus")
  }
}

pub type Devicecorrectiveactionscope {
  DevicecorrectiveactionscopeModel
  DevicecorrectiveactionscopeLotnumbers
  DevicecorrectiveactionscopeSerialnumbers
}

pub fn devicecorrectiveactionscope_to_json(
  devicecorrectiveactionscope: Devicecorrectiveactionscope,
) -> Json {
  json.string(devicecorrectiveactionscope_to_string(devicecorrectiveactionscope))
}

pub fn devicecorrectiveactionscope_to_string(
  devicecorrectiveactionscope: Devicecorrectiveactionscope,
) -> String {
  case devicecorrectiveactionscope {
    DevicecorrectiveactionscopeModel -> "model"
    DevicecorrectiveactionscopeLotnumbers -> "lot-numbers"
    DevicecorrectiveactionscopeSerialnumbers -> "serial-numbers"
  }
}

pub fn devicecorrectiveactionscope_from_string(
  s: String,
) -> Result(Devicecorrectiveactionscope, Nil) {
  case s {
    "model" -> Ok(DevicecorrectiveactionscopeModel)
    "lot-numbers" -> Ok(DevicecorrectiveactionscopeLotnumbers)
    "serial-numbers" -> Ok(DevicecorrectiveactionscopeSerialnumbers)
    _ -> Error(Nil)
  }
}

pub fn devicecorrectiveactionscope_decoder() -> Decoder(
  Devicecorrectiveactionscope,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "model" -> decode.success(DevicecorrectiveactionscopeModel)
    "lot-numbers" -> decode.success(DevicecorrectiveactionscopeLotnumbers)
    "serial-numbers" -> decode.success(DevicecorrectiveactionscopeSerialnumbers)
    _ ->
      decode.failure(
        DevicecorrectiveactionscopeModel,
        "Devicecorrectiveactionscope",
      )
  }
}

pub type Devicedefinitionregulatoryidentifiertype {
  DevicedefinitionregulatoryidentifiertypeBasic
  DevicedefinitionregulatoryidentifiertypeMaster
  DevicedefinitionregulatoryidentifiertypeLicense
}

pub fn devicedefinitionregulatoryidentifiertype_to_json(
  devicedefinitionregulatoryidentifiertype: Devicedefinitionregulatoryidentifiertype,
) -> Json {
  json.string(devicedefinitionregulatoryidentifiertype_to_string(
    devicedefinitionregulatoryidentifiertype,
  ))
}

pub fn devicedefinitionregulatoryidentifiertype_to_string(
  devicedefinitionregulatoryidentifiertype: Devicedefinitionregulatoryidentifiertype,
) -> String {
  case devicedefinitionregulatoryidentifiertype {
    DevicedefinitionregulatoryidentifiertypeBasic -> "basic"
    DevicedefinitionregulatoryidentifiertypeMaster -> "master"
    DevicedefinitionregulatoryidentifiertypeLicense -> "license"
  }
}

pub fn devicedefinitionregulatoryidentifiertype_from_string(
  s: String,
) -> Result(Devicedefinitionregulatoryidentifiertype, Nil) {
  case s {
    "basic" -> Ok(DevicedefinitionregulatoryidentifiertypeBasic)
    "master" -> Ok(DevicedefinitionregulatoryidentifiertypeMaster)
    "license" -> Ok(DevicedefinitionregulatoryidentifiertypeLicense)
    _ -> Error(Nil)
  }
}

pub fn devicedefinitionregulatoryidentifiertype_decoder() -> Decoder(
  Devicedefinitionregulatoryidentifiertype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "basic" -> decode.success(DevicedefinitionregulatoryidentifiertypeBasic)
    "master" -> decode.success(DevicedefinitionregulatoryidentifiertypeMaster)
    "license" -> decode.success(DevicedefinitionregulatoryidentifiertypeLicense)
    _ ->
      decode.failure(
        DevicedefinitionregulatoryidentifiertypeBasic,
        "Devicedefinitionregulatoryidentifiertype",
      )
  }
}

pub type Devicedispensestatus {
  DevicedispensestatusPreparation
  DevicedispensestatusInprogress
  DevicedispensestatusCancelled
  DevicedispensestatusOnhold
  DevicedispensestatusCompleted
  DevicedispensestatusEnteredinerror
  DevicedispensestatusStopped
  DevicedispensestatusDeclined
  DevicedispensestatusUnknown
}

pub fn devicedispensestatus_to_json(
  devicedispensestatus: Devicedispensestatus,
) -> Json {
  json.string(devicedispensestatus_to_string(devicedispensestatus))
}

pub fn devicedispensestatus_to_string(
  devicedispensestatus: Devicedispensestatus,
) -> String {
  case devicedispensestatus {
    DevicedispensestatusPreparation -> "preparation"
    DevicedispensestatusInprogress -> "in-progress"
    DevicedispensestatusCancelled -> "cancelled"
    DevicedispensestatusOnhold -> "on-hold"
    DevicedispensestatusCompleted -> "completed"
    DevicedispensestatusEnteredinerror -> "entered-in-error"
    DevicedispensestatusStopped -> "stopped"
    DevicedispensestatusDeclined -> "declined"
    DevicedispensestatusUnknown -> "unknown"
  }
}

pub fn devicedispensestatus_from_string(
  s: String,
) -> Result(Devicedispensestatus, Nil) {
  case s {
    "preparation" -> Ok(DevicedispensestatusPreparation)
    "in-progress" -> Ok(DevicedispensestatusInprogress)
    "cancelled" -> Ok(DevicedispensestatusCancelled)
    "on-hold" -> Ok(DevicedispensestatusOnhold)
    "completed" -> Ok(DevicedispensestatusCompleted)
    "entered-in-error" -> Ok(DevicedispensestatusEnteredinerror)
    "stopped" -> Ok(DevicedispensestatusStopped)
    "declined" -> Ok(DevicedispensestatusDeclined)
    "unknown" -> Ok(DevicedispensestatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn devicedispensestatus_decoder() -> Decoder(Devicedispensestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "preparation" -> decode.success(DevicedispensestatusPreparation)
    "in-progress" -> decode.success(DevicedispensestatusInprogress)
    "cancelled" -> decode.success(DevicedispensestatusCancelled)
    "on-hold" -> decode.success(DevicedispensestatusOnhold)
    "completed" -> decode.success(DevicedispensestatusCompleted)
    "entered-in-error" -> decode.success(DevicedispensestatusEnteredinerror)
    "stopped" -> decode.success(DevicedispensestatusStopped)
    "declined" -> decode.success(DevicedispensestatusDeclined)
    "unknown" -> decode.success(DevicedispensestatusUnknown)
    _ -> decode.failure(DevicedispensestatusPreparation, "Devicedispensestatus")
  }
}

pub type Devicenametype {
  DevicenametypeRegisteredname
  DevicenametypeUserfriendlyname
  DevicenametypePatientreportedname
}

pub fn devicenametype_to_json(devicenametype: Devicenametype) -> Json {
  json.string(devicenametype_to_string(devicenametype))
}

pub fn devicenametype_to_string(devicenametype: Devicenametype) -> String {
  case devicenametype {
    DevicenametypeRegisteredname -> "registered-name"
    DevicenametypeUserfriendlyname -> "user-friendly-name"
    DevicenametypePatientreportedname -> "patient-reported-name"
  }
}

pub fn devicenametype_from_string(s: String) -> Result(Devicenametype, Nil) {
  case s {
    "registered-name" -> Ok(DevicenametypeRegisteredname)
    "user-friendly-name" -> Ok(DevicenametypeUserfriendlyname)
    "patient-reported-name" -> Ok(DevicenametypePatientreportedname)
    _ -> Error(Nil)
  }
}

pub fn devicenametype_decoder() -> Decoder(Devicenametype) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered-name" -> decode.success(DevicenametypeRegisteredname)
    "user-friendly-name" -> decode.success(DevicenametypeUserfriendlyname)
    "patient-reported-name" -> decode.success(DevicenametypePatientreportedname)
    _ -> decode.failure(DevicenametypeRegisteredname, "Devicenametype")
  }
}

pub type Deviceproductidentifierinudi {
  DeviceproductidentifierinudiLotnumber
  DeviceproductidentifierinudiManufactureddate
  DeviceproductidentifierinudiSerialnumber
  DeviceproductidentifierinudiExpirationdate
  DeviceproductidentifierinudiBiologicalsource
  DeviceproductidentifierinudiSoftwareversion
}

pub fn deviceproductidentifierinudi_to_json(
  deviceproductidentifierinudi: Deviceproductidentifierinudi,
) -> Json {
  json.string(deviceproductidentifierinudi_to_string(
    deviceproductidentifierinudi,
  ))
}

pub fn deviceproductidentifierinudi_to_string(
  deviceproductidentifierinudi: Deviceproductidentifierinudi,
) -> String {
  case deviceproductidentifierinudi {
    DeviceproductidentifierinudiLotnumber -> "lot-number"
    DeviceproductidentifierinudiManufactureddate -> "manufactured-date"
    DeviceproductidentifierinudiSerialnumber -> "serial-number"
    DeviceproductidentifierinudiExpirationdate -> "expiration-date"
    DeviceproductidentifierinudiBiologicalsource -> "biological-source"
    DeviceproductidentifierinudiSoftwareversion -> "software-version"
  }
}

pub fn deviceproductidentifierinudi_from_string(
  s: String,
) -> Result(Deviceproductidentifierinudi, Nil) {
  case s {
    "lot-number" -> Ok(DeviceproductidentifierinudiLotnumber)
    "manufactured-date" -> Ok(DeviceproductidentifierinudiManufactureddate)
    "serial-number" -> Ok(DeviceproductidentifierinudiSerialnumber)
    "expiration-date" -> Ok(DeviceproductidentifierinudiExpirationdate)
    "biological-source" -> Ok(DeviceproductidentifierinudiBiologicalsource)
    "software-version" -> Ok(DeviceproductidentifierinudiSoftwareversion)
    _ -> Error(Nil)
  }
}

pub fn deviceproductidentifierinudi_decoder() -> Decoder(
  Deviceproductidentifierinudi,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "lot-number" -> decode.success(DeviceproductidentifierinudiLotnumber)
    "manufactured-date" ->
      decode.success(DeviceproductidentifierinudiManufactureddate)
    "serial-number" -> decode.success(DeviceproductidentifierinudiSerialnumber)
    "expiration-date" ->
      decode.success(DeviceproductidentifierinudiExpirationdate)
    "biological-source" ->
      decode.success(DeviceproductidentifierinudiBiologicalsource)
    "software-version" ->
      decode.success(DeviceproductidentifierinudiSoftwareversion)
    _ ->
      decode.failure(
        DeviceproductidentifierinudiLotnumber,
        "Deviceproductidentifierinudi",
      )
  }
}

pub type Devicestatus {
  DevicestatusActive
  DevicestatusInactive
  DevicestatusEnteredinerror
}

pub fn devicestatus_to_json(devicestatus: Devicestatus) -> Json {
  json.string(devicestatus_to_string(devicestatus))
}

pub fn devicestatus_to_string(devicestatus: Devicestatus) -> String {
  case devicestatus {
    DevicestatusActive -> "active"
    DevicestatusInactive -> "inactive"
    DevicestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn devicestatus_from_string(s: String) -> Result(Devicestatus, Nil) {
  case s {
    "active" -> Ok(DevicestatusActive)
    "inactive" -> Ok(DevicestatusInactive)
    "entered-in-error" -> Ok(DevicestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn devicestatus_decoder() -> Decoder(Devicestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(DevicestatusActive)
    "inactive" -> decode.success(DevicestatusInactive)
    "entered-in-error" -> decode.success(DevicestatusEnteredinerror)
    _ -> decode.failure(DevicestatusActive, "Devicestatus")
  }
}

pub type Deviceusagestatus {
  DeviceusagestatusActive
  DeviceusagestatusCompleted
  DeviceusagestatusNotdone
  DeviceusagestatusEnteredinerror
  DeviceusagestatusIntended
  DeviceusagestatusStopped
  DeviceusagestatusOnhold
}

pub fn deviceusagestatus_to_json(deviceusagestatus: Deviceusagestatus) -> Json {
  json.string(deviceusagestatus_to_string(deviceusagestatus))
}

pub fn deviceusagestatus_to_string(
  deviceusagestatus: Deviceusagestatus,
) -> String {
  case deviceusagestatus {
    DeviceusagestatusActive -> "active"
    DeviceusagestatusCompleted -> "completed"
    DeviceusagestatusNotdone -> "not-done"
    DeviceusagestatusEnteredinerror -> "entered-in-error"
    DeviceusagestatusIntended -> "intended"
    DeviceusagestatusStopped -> "stopped"
    DeviceusagestatusOnhold -> "on-hold"
  }
}

pub fn deviceusagestatus_from_string(
  s: String,
) -> Result(Deviceusagestatus, Nil) {
  case s {
    "active" -> Ok(DeviceusagestatusActive)
    "completed" -> Ok(DeviceusagestatusCompleted)
    "not-done" -> Ok(DeviceusagestatusNotdone)
    "entered-in-error" -> Ok(DeviceusagestatusEnteredinerror)
    "intended" -> Ok(DeviceusagestatusIntended)
    "stopped" -> Ok(DeviceusagestatusStopped)
    "on-hold" -> Ok(DeviceusagestatusOnhold)
    _ -> Error(Nil)
  }
}

pub fn deviceusagestatus_decoder() -> Decoder(Deviceusagestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(DeviceusagestatusActive)
    "completed" -> decode.success(DeviceusagestatusCompleted)
    "not-done" -> decode.success(DeviceusagestatusNotdone)
    "entered-in-error" -> decode.success(DeviceusagestatusEnteredinerror)
    "intended" -> decode.success(DeviceusagestatusIntended)
    "stopped" -> decode.success(DeviceusagestatusStopped)
    "on-hold" -> decode.success(DeviceusagestatusOnhold)
    _ -> decode.failure(DeviceusagestatusActive, "Deviceusagestatus")
  }
}

pub type Diagnosticreportstatus {
  DiagnosticreportstatusRegistered
  DiagnosticreportstatusPartial
  DiagnosticreportstatusPreliminary
  DiagnosticreportstatusModified
  DiagnosticreportstatusFinal
  DiagnosticreportstatusAmended
  DiagnosticreportstatusCorrected
  DiagnosticreportstatusAppended
  DiagnosticreportstatusCancelled
  DiagnosticreportstatusEnteredinerror
  DiagnosticreportstatusUnknown
}

pub fn diagnosticreportstatus_to_json(
  diagnosticreportstatus: Diagnosticreportstatus,
) -> Json {
  json.string(diagnosticreportstatus_to_string(diagnosticreportstatus))
}

pub fn diagnosticreportstatus_to_string(
  diagnosticreportstatus: Diagnosticreportstatus,
) -> String {
  case diagnosticreportstatus {
    DiagnosticreportstatusRegistered -> "registered"
    DiagnosticreportstatusPartial -> "partial"
    DiagnosticreportstatusPreliminary -> "preliminary"
    DiagnosticreportstatusModified -> "modified"
    DiagnosticreportstatusFinal -> "final"
    DiagnosticreportstatusAmended -> "amended"
    DiagnosticreportstatusCorrected -> "corrected"
    DiagnosticreportstatusAppended -> "appended"
    DiagnosticreportstatusCancelled -> "cancelled"
    DiagnosticreportstatusEnteredinerror -> "entered-in-error"
    DiagnosticreportstatusUnknown -> "unknown"
  }
}

pub fn diagnosticreportstatus_from_string(
  s: String,
) -> Result(Diagnosticreportstatus, Nil) {
  case s {
    "registered" -> Ok(DiagnosticreportstatusRegistered)
    "partial" -> Ok(DiagnosticreportstatusPartial)
    "preliminary" -> Ok(DiagnosticreportstatusPreliminary)
    "modified" -> Ok(DiagnosticreportstatusModified)
    "final" -> Ok(DiagnosticreportstatusFinal)
    "amended" -> Ok(DiagnosticreportstatusAmended)
    "corrected" -> Ok(DiagnosticreportstatusCorrected)
    "appended" -> Ok(DiagnosticreportstatusAppended)
    "cancelled" -> Ok(DiagnosticreportstatusCancelled)
    "entered-in-error" -> Ok(DiagnosticreportstatusEnteredinerror)
    "unknown" -> Ok(DiagnosticreportstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn diagnosticreportstatus_decoder() -> Decoder(Diagnosticreportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered" -> decode.success(DiagnosticreportstatusRegistered)
    "partial" -> decode.success(DiagnosticreportstatusPartial)
    "preliminary" -> decode.success(DiagnosticreportstatusPreliminary)
    "modified" -> decode.success(DiagnosticreportstatusModified)
    "final" -> decode.success(DiagnosticreportstatusFinal)
    "amended" -> decode.success(DiagnosticreportstatusAmended)
    "corrected" -> decode.success(DiagnosticreportstatusCorrected)
    "appended" -> decode.success(DiagnosticreportstatusAppended)
    "cancelled" -> decode.success(DiagnosticreportstatusCancelled)
    "entered-in-error" -> decode.success(DiagnosticreportstatusEnteredinerror)
    "unknown" -> decode.success(DiagnosticreportstatusUnknown)
    _ ->
      decode.failure(DiagnosticreportstatusRegistered, "Diagnosticreportstatus")
  }
}

pub type Discriminatortype {
  DiscriminatortypeValue
  DiscriminatortypeExists
  DiscriminatortypePattern
  DiscriminatortypeType
  DiscriminatortypeProfile
  DiscriminatortypePosition
}

pub fn discriminatortype_to_json(discriminatortype: Discriminatortype) -> Json {
  json.string(discriminatortype_to_string(discriminatortype))
}

pub fn discriminatortype_to_string(
  discriminatortype: Discriminatortype,
) -> String {
  case discriminatortype {
    DiscriminatortypeValue -> "value"
    DiscriminatortypeExists -> "exists"
    DiscriminatortypePattern -> "pattern"
    DiscriminatortypeType -> "type"
    DiscriminatortypeProfile -> "profile"
    DiscriminatortypePosition -> "position"
  }
}

pub fn discriminatortype_from_string(
  s: String,
) -> Result(Discriminatortype, Nil) {
  case s {
    "value" -> Ok(DiscriminatortypeValue)
    "exists" -> Ok(DiscriminatortypeExists)
    "pattern" -> Ok(DiscriminatortypePattern)
    "type" -> Ok(DiscriminatortypeType)
    "profile" -> Ok(DiscriminatortypeProfile)
    "position" -> Ok(DiscriminatortypePosition)
    _ -> Error(Nil)
  }
}

pub fn discriminatortype_decoder() -> Decoder(Discriminatortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "value" -> decode.success(DiscriminatortypeValue)
    "exists" -> decode.success(DiscriminatortypeExists)
    "pattern" -> decode.success(DiscriminatortypePattern)
    "type" -> decode.success(DiscriminatortypeType)
    "profile" -> decode.success(DiscriminatortypeProfile)
    "position" -> decode.success(DiscriminatortypePosition)
    _ -> decode.failure(DiscriminatortypeValue, "Discriminatortype")
  }
}

pub type Documentmode {
  DocumentmodeProducer
  DocumentmodeConsumer
}

pub fn documentmode_to_json(documentmode: Documentmode) -> Json {
  json.string(documentmode_to_string(documentmode))
}

pub fn documentmode_to_string(documentmode: Documentmode) -> String {
  case documentmode {
    DocumentmodeProducer -> "producer"
    DocumentmodeConsumer -> "consumer"
  }
}

pub fn documentmode_from_string(s: String) -> Result(Documentmode, Nil) {
  case s {
    "producer" -> Ok(DocumentmodeProducer)
    "consumer" -> Ok(DocumentmodeConsumer)
    _ -> Error(Nil)
  }
}

pub fn documentmode_decoder() -> Decoder(Documentmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "producer" -> decode.success(DocumentmodeProducer)
    "consumer" -> decode.success(DocumentmodeConsumer)
    _ -> decode.failure(DocumentmodeProducer, "Documentmode")
  }
}

pub type Documentreferencestatus {
  DocumentreferencestatusCurrent
  DocumentreferencestatusSuperseded
  DocumentreferencestatusEnteredinerror
}

pub fn documentreferencestatus_to_json(
  documentreferencestatus: Documentreferencestatus,
) -> Json {
  json.string(documentreferencestatus_to_string(documentreferencestatus))
}

pub fn documentreferencestatus_to_string(
  documentreferencestatus: Documentreferencestatus,
) -> String {
  case documentreferencestatus {
    DocumentreferencestatusCurrent -> "current"
    DocumentreferencestatusSuperseded -> "superseded"
    DocumentreferencestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn documentreferencestatus_from_string(
  s: String,
) -> Result(Documentreferencestatus, Nil) {
  case s {
    "current" -> Ok(DocumentreferencestatusCurrent)
    "superseded" -> Ok(DocumentreferencestatusSuperseded)
    "entered-in-error" -> Ok(DocumentreferencestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn documentreferencestatus_decoder() -> Decoder(Documentreferencestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "current" -> decode.success(DocumentreferencestatusCurrent)
    "superseded" -> decode.success(DocumentreferencestatusSuperseded)
    "entered-in-error" -> decode.success(DocumentreferencestatusEnteredinerror)
    _ ->
      decode.failure(DocumentreferencestatusCurrent, "Documentreferencestatus")
  }
}

pub type Eligibilityoutcome {
  EligibilityoutcomeQueued
  EligibilityoutcomeComplete
  EligibilityoutcomeError
  EligibilityoutcomePartial
}

pub fn eligibilityoutcome_to_json(
  eligibilityoutcome: Eligibilityoutcome,
) -> Json {
  json.string(eligibilityoutcome_to_string(eligibilityoutcome))
}

pub fn eligibilityoutcome_to_string(
  eligibilityoutcome: Eligibilityoutcome,
) -> String {
  case eligibilityoutcome {
    EligibilityoutcomeQueued -> "queued"
    EligibilityoutcomeComplete -> "complete"
    EligibilityoutcomeError -> "error"
    EligibilityoutcomePartial -> "partial"
  }
}

pub fn eligibilityoutcome_from_string(
  s: String,
) -> Result(Eligibilityoutcome, Nil) {
  case s {
    "queued" -> Ok(EligibilityoutcomeQueued)
    "complete" -> Ok(EligibilityoutcomeComplete)
    "error" -> Ok(EligibilityoutcomeError)
    "partial" -> Ok(EligibilityoutcomePartial)
    _ -> Error(Nil)
  }
}

pub fn eligibilityoutcome_decoder() -> Decoder(Eligibilityoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "queued" -> decode.success(EligibilityoutcomeQueued)
    "complete" -> decode.success(EligibilityoutcomeComplete)
    "error" -> decode.success(EligibilityoutcomeError)
    "partial" -> decode.success(EligibilityoutcomePartial)
    _ -> decode.failure(EligibilityoutcomeQueued, "Eligibilityoutcome")
  }
}

pub type Eligibilityrequestpurpose {
  EligibilityrequestpurposeAuthrequirements
  EligibilityrequestpurposeBenefits
  EligibilityrequestpurposeDiscovery
  EligibilityrequestpurposeValidation
}

pub fn eligibilityrequestpurpose_to_json(
  eligibilityrequestpurpose: Eligibilityrequestpurpose,
) -> Json {
  json.string(eligibilityrequestpurpose_to_string(eligibilityrequestpurpose))
}

pub fn eligibilityrequestpurpose_to_string(
  eligibilityrequestpurpose: Eligibilityrequestpurpose,
) -> String {
  case eligibilityrequestpurpose {
    EligibilityrequestpurposeAuthrequirements -> "auth-requirements"
    EligibilityrequestpurposeBenefits -> "benefits"
    EligibilityrequestpurposeDiscovery -> "discovery"
    EligibilityrequestpurposeValidation -> "validation"
  }
}

pub fn eligibilityrequestpurpose_from_string(
  s: String,
) -> Result(Eligibilityrequestpurpose, Nil) {
  case s {
    "auth-requirements" -> Ok(EligibilityrequestpurposeAuthrequirements)
    "benefits" -> Ok(EligibilityrequestpurposeBenefits)
    "discovery" -> Ok(EligibilityrequestpurposeDiscovery)
    "validation" -> Ok(EligibilityrequestpurposeValidation)
    _ -> Error(Nil)
  }
}

pub fn eligibilityrequestpurpose_decoder() -> Decoder(Eligibilityrequestpurpose) {
  use variant <- decode.then(decode.string)
  case variant {
    "auth-requirements" ->
      decode.success(EligibilityrequestpurposeAuthrequirements)
    "benefits" -> decode.success(EligibilityrequestpurposeBenefits)
    "discovery" -> decode.success(EligibilityrequestpurposeDiscovery)
    "validation" -> decode.success(EligibilityrequestpurposeValidation)
    _ ->
      decode.failure(
        EligibilityrequestpurposeAuthrequirements,
        "Eligibilityrequestpurpose",
      )
  }
}

pub type Eligibilityresponsepurpose {
  EligibilityresponsepurposeAuthrequirements
  EligibilityresponsepurposeBenefits
  EligibilityresponsepurposeDiscovery
  EligibilityresponsepurposeValidation
}

pub fn eligibilityresponsepurpose_to_json(
  eligibilityresponsepurpose: Eligibilityresponsepurpose,
) -> Json {
  json.string(eligibilityresponsepurpose_to_string(eligibilityresponsepurpose))
}

pub fn eligibilityresponsepurpose_to_string(
  eligibilityresponsepurpose: Eligibilityresponsepurpose,
) -> String {
  case eligibilityresponsepurpose {
    EligibilityresponsepurposeAuthrequirements -> "auth-requirements"
    EligibilityresponsepurposeBenefits -> "benefits"
    EligibilityresponsepurposeDiscovery -> "discovery"
    EligibilityresponsepurposeValidation -> "validation"
  }
}

pub fn eligibilityresponsepurpose_from_string(
  s: String,
) -> Result(Eligibilityresponsepurpose, Nil) {
  case s {
    "auth-requirements" -> Ok(EligibilityresponsepurposeAuthrequirements)
    "benefits" -> Ok(EligibilityresponsepurposeBenefits)
    "discovery" -> Ok(EligibilityresponsepurposeDiscovery)
    "validation" -> Ok(EligibilityresponsepurposeValidation)
    _ -> Error(Nil)
  }
}

pub fn eligibilityresponsepurpose_decoder() -> Decoder(
  Eligibilityresponsepurpose,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "auth-requirements" ->
      decode.success(EligibilityresponsepurposeAuthrequirements)
    "benefits" -> decode.success(EligibilityresponsepurposeBenefits)
    "discovery" -> decode.success(EligibilityresponsepurposeDiscovery)
    "validation" -> decode.success(EligibilityresponsepurposeValidation)
    _ ->
      decode.failure(
        EligibilityresponsepurposeAuthrequirements,
        "Eligibilityresponsepurpose",
      )
  }
}

pub type Encounterlocationstatus {
  EncounterlocationstatusPlanned
  EncounterlocationstatusActive
  EncounterlocationstatusReserved
  EncounterlocationstatusCompleted
}

pub fn encounterlocationstatus_to_json(
  encounterlocationstatus: Encounterlocationstatus,
) -> Json {
  json.string(encounterlocationstatus_to_string(encounterlocationstatus))
}

pub fn encounterlocationstatus_to_string(
  encounterlocationstatus: Encounterlocationstatus,
) -> String {
  case encounterlocationstatus {
    EncounterlocationstatusPlanned -> "planned"
    EncounterlocationstatusActive -> "active"
    EncounterlocationstatusReserved -> "reserved"
    EncounterlocationstatusCompleted -> "completed"
  }
}

pub fn encounterlocationstatus_from_string(
  s: String,
) -> Result(Encounterlocationstatus, Nil) {
  case s {
    "planned" -> Ok(EncounterlocationstatusPlanned)
    "active" -> Ok(EncounterlocationstatusActive)
    "reserved" -> Ok(EncounterlocationstatusReserved)
    "completed" -> Ok(EncounterlocationstatusCompleted)
    _ -> Error(Nil)
  }
}

pub fn encounterlocationstatus_decoder() -> Decoder(Encounterlocationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "planned" -> decode.success(EncounterlocationstatusPlanned)
    "active" -> decode.success(EncounterlocationstatusActive)
    "reserved" -> decode.success(EncounterlocationstatusReserved)
    "completed" -> decode.success(EncounterlocationstatusCompleted)
    _ ->
      decode.failure(EncounterlocationstatusPlanned, "Encounterlocationstatus")
  }
}

pub type Encounterstatus {
  EncounterstatusPlanned
  EncounterstatusInprogress
  EncounterstatusOnhold
  EncounterstatusDischarged
  EncounterstatusCompleted
  EncounterstatusCancelled
  EncounterstatusDiscontinued
  EncounterstatusEnteredinerror
  EncounterstatusUnknown
}

pub fn encounterstatus_to_json(encounterstatus: Encounterstatus) -> Json {
  json.string(encounterstatus_to_string(encounterstatus))
}

pub fn encounterstatus_to_string(encounterstatus: Encounterstatus) -> String {
  case encounterstatus {
    EncounterstatusPlanned -> "planned"
    EncounterstatusInprogress -> "in-progress"
    EncounterstatusOnhold -> "on-hold"
    EncounterstatusDischarged -> "discharged"
    EncounterstatusCompleted -> "completed"
    EncounterstatusCancelled -> "cancelled"
    EncounterstatusDiscontinued -> "discontinued"
    EncounterstatusEnteredinerror -> "entered-in-error"
    EncounterstatusUnknown -> "unknown"
  }
}

pub fn encounterstatus_from_string(s: String) -> Result(Encounterstatus, Nil) {
  case s {
    "planned" -> Ok(EncounterstatusPlanned)
    "in-progress" -> Ok(EncounterstatusInprogress)
    "on-hold" -> Ok(EncounterstatusOnhold)
    "discharged" -> Ok(EncounterstatusDischarged)
    "completed" -> Ok(EncounterstatusCompleted)
    "cancelled" -> Ok(EncounterstatusCancelled)
    "discontinued" -> Ok(EncounterstatusDiscontinued)
    "entered-in-error" -> Ok(EncounterstatusEnteredinerror)
    "unknown" -> Ok(EncounterstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn encounterstatus_decoder() -> Decoder(Encounterstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "planned" -> decode.success(EncounterstatusPlanned)
    "in-progress" -> decode.success(EncounterstatusInprogress)
    "on-hold" -> decode.success(EncounterstatusOnhold)
    "discharged" -> decode.success(EncounterstatusDischarged)
    "completed" -> decode.success(EncounterstatusCompleted)
    "cancelled" -> decode.success(EncounterstatusCancelled)
    "discontinued" -> decode.success(EncounterstatusDiscontinued)
    "entered-in-error" -> decode.success(EncounterstatusEnteredinerror)
    "unknown" -> decode.success(EncounterstatusUnknown)
    _ -> decode.failure(EncounterstatusPlanned, "Encounterstatus")
  }
}

pub type Endpointstatus {
  EndpointstatusActive
  EndpointstatusSuspended
  EndpointstatusError
  EndpointstatusOff
  EndpointstatusEnteredinerror
}

pub fn endpointstatus_to_json(endpointstatus: Endpointstatus) -> Json {
  json.string(endpointstatus_to_string(endpointstatus))
}

pub fn endpointstatus_to_string(endpointstatus: Endpointstatus) -> String {
  case endpointstatus {
    EndpointstatusActive -> "active"
    EndpointstatusSuspended -> "suspended"
    EndpointstatusError -> "error"
    EndpointstatusOff -> "off"
    EndpointstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn endpointstatus_from_string(s: String) -> Result(Endpointstatus, Nil) {
  case s {
    "active" -> Ok(EndpointstatusActive)
    "suspended" -> Ok(EndpointstatusSuspended)
    "error" -> Ok(EndpointstatusError)
    "off" -> Ok(EndpointstatusOff)
    "entered-in-error" -> Ok(EndpointstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn endpointstatus_decoder() -> Decoder(Endpointstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(EndpointstatusActive)
    "suspended" -> decode.success(EndpointstatusSuspended)
    "error" -> decode.success(EndpointstatusError)
    "off" -> decode.success(EndpointstatusOff)
    "entered-in-error" -> decode.success(EndpointstatusEnteredinerror)
    _ -> decode.failure(EndpointstatusActive, "Endpointstatus")
  }
}

pub type Enrollmentoutcome {
  EnrollmentoutcomeQueued
  EnrollmentoutcomeComplete
  EnrollmentoutcomeError
  EnrollmentoutcomePartial
}

pub fn enrollmentoutcome_to_json(enrollmentoutcome: Enrollmentoutcome) -> Json {
  json.string(enrollmentoutcome_to_string(enrollmentoutcome))
}

pub fn enrollmentoutcome_to_string(
  enrollmentoutcome: Enrollmentoutcome,
) -> String {
  case enrollmentoutcome {
    EnrollmentoutcomeQueued -> "queued"
    EnrollmentoutcomeComplete -> "complete"
    EnrollmentoutcomeError -> "error"
    EnrollmentoutcomePartial -> "partial"
  }
}

pub fn enrollmentoutcome_from_string(
  s: String,
) -> Result(Enrollmentoutcome, Nil) {
  case s {
    "queued" -> Ok(EnrollmentoutcomeQueued)
    "complete" -> Ok(EnrollmentoutcomeComplete)
    "error" -> Ok(EnrollmentoutcomeError)
    "partial" -> Ok(EnrollmentoutcomePartial)
    _ -> Error(Nil)
  }
}

pub fn enrollmentoutcome_decoder() -> Decoder(Enrollmentoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "queued" -> decode.success(EnrollmentoutcomeQueued)
    "complete" -> decode.success(EnrollmentoutcomeComplete)
    "error" -> decode.success(EnrollmentoutcomeError)
    "partial" -> decode.success(EnrollmentoutcomePartial)
    _ -> decode.failure(EnrollmentoutcomeQueued, "Enrollmentoutcome")
  }
}

pub type Episodeofcarestatus {
  EpisodeofcarestatusPlanned
  EpisodeofcarestatusWaitlist
  EpisodeofcarestatusActive
  EpisodeofcarestatusOnhold
  EpisodeofcarestatusFinished
  EpisodeofcarestatusCancelled
  EpisodeofcarestatusEnteredinerror
}

pub fn episodeofcarestatus_to_json(
  episodeofcarestatus: Episodeofcarestatus,
) -> Json {
  json.string(episodeofcarestatus_to_string(episodeofcarestatus))
}

pub fn episodeofcarestatus_to_string(
  episodeofcarestatus: Episodeofcarestatus,
) -> String {
  case episodeofcarestatus {
    EpisodeofcarestatusPlanned -> "planned"
    EpisodeofcarestatusWaitlist -> "waitlist"
    EpisodeofcarestatusActive -> "active"
    EpisodeofcarestatusOnhold -> "onhold"
    EpisodeofcarestatusFinished -> "finished"
    EpisodeofcarestatusCancelled -> "cancelled"
    EpisodeofcarestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn episodeofcarestatus_from_string(
  s: String,
) -> Result(Episodeofcarestatus, Nil) {
  case s {
    "planned" -> Ok(EpisodeofcarestatusPlanned)
    "waitlist" -> Ok(EpisodeofcarestatusWaitlist)
    "active" -> Ok(EpisodeofcarestatusActive)
    "onhold" -> Ok(EpisodeofcarestatusOnhold)
    "finished" -> Ok(EpisodeofcarestatusFinished)
    "cancelled" -> Ok(EpisodeofcarestatusCancelled)
    "entered-in-error" -> Ok(EpisodeofcarestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn episodeofcarestatus_decoder() -> Decoder(Episodeofcarestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "planned" -> decode.success(EpisodeofcarestatusPlanned)
    "waitlist" -> decode.success(EpisodeofcarestatusWaitlist)
    "active" -> decode.success(EpisodeofcarestatusActive)
    "onhold" -> decode.success(EpisodeofcarestatusOnhold)
    "finished" -> decode.success(EpisodeofcarestatusFinished)
    "cancelled" -> decode.success(EpisodeofcarestatusCancelled)
    "entered-in-error" -> decode.success(EpisodeofcarestatusEnteredinerror)
    _ -> decode.failure(EpisodeofcarestatusPlanned, "Episodeofcarestatus")
  }
}

pub type Eventcapabilitymode {
  EventcapabilitymodeSender
  EventcapabilitymodeReceiver
}

pub fn eventcapabilitymode_to_json(
  eventcapabilitymode: Eventcapabilitymode,
) -> Json {
  json.string(eventcapabilitymode_to_string(eventcapabilitymode))
}

pub fn eventcapabilitymode_to_string(
  eventcapabilitymode: Eventcapabilitymode,
) -> String {
  case eventcapabilitymode {
    EventcapabilitymodeSender -> "sender"
    EventcapabilitymodeReceiver -> "receiver"
  }
}

pub fn eventcapabilitymode_from_string(
  s: String,
) -> Result(Eventcapabilitymode, Nil) {
  case s {
    "sender" -> Ok(EventcapabilitymodeSender)
    "receiver" -> Ok(EventcapabilitymodeReceiver)
    _ -> Error(Nil)
  }
}

pub fn eventcapabilitymode_decoder() -> Decoder(Eventcapabilitymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "sender" -> decode.success(EventcapabilitymodeSender)
    "receiver" -> decode.success(EventcapabilitymodeReceiver)
    _ -> decode.failure(EventcapabilitymodeSender, "Eventcapabilitymode")
  }
}

pub type Eventstatus {
  EventstatusPreparation
  EventstatusInprogress
  EventstatusNotdone
  EventstatusOnhold
  EventstatusStopped
  EventstatusCompleted
  EventstatusEnteredinerror
  EventstatusUnknown
}

pub fn eventstatus_to_json(eventstatus: Eventstatus) -> Json {
  json.string(eventstatus_to_string(eventstatus))
}

pub fn eventstatus_to_string(eventstatus: Eventstatus) -> String {
  case eventstatus {
    EventstatusPreparation -> "preparation"
    EventstatusInprogress -> "in-progress"
    EventstatusNotdone -> "not-done"
    EventstatusOnhold -> "on-hold"
    EventstatusStopped -> "stopped"
    EventstatusCompleted -> "completed"
    EventstatusEnteredinerror -> "entered-in-error"
    EventstatusUnknown -> "unknown"
  }
}

pub fn eventstatus_from_string(s: String) -> Result(Eventstatus, Nil) {
  case s {
    "preparation" -> Ok(EventstatusPreparation)
    "in-progress" -> Ok(EventstatusInprogress)
    "not-done" -> Ok(EventstatusNotdone)
    "on-hold" -> Ok(EventstatusOnhold)
    "stopped" -> Ok(EventstatusStopped)
    "completed" -> Ok(EventstatusCompleted)
    "entered-in-error" -> Ok(EventstatusEnteredinerror)
    "unknown" -> Ok(EventstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn eventstatus_decoder() -> Decoder(Eventstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "preparation" -> decode.success(EventstatusPreparation)
    "in-progress" -> decode.success(EventstatusInprogress)
    "not-done" -> decode.success(EventstatusNotdone)
    "on-hold" -> decode.success(EventstatusOnhold)
    "stopped" -> decode.success(EventstatusStopped)
    "completed" -> decode.success(EventstatusCompleted)
    "entered-in-error" -> decode.success(EventstatusEnteredinerror)
    "unknown" -> decode.success(EventstatusUnknown)
    _ -> decode.failure(EventstatusPreparation, "Eventstatus")
  }
}

pub type Eventtiming {
  EventtimingMorn
  EventtimingMornearly
  EventtimingMornlate
  EventtimingNoon
  EventtimingAft
  EventtimingAftearly
  EventtimingAftlate
  EventtimingEve
  EventtimingEveearly
  EventtimingEvelate
  EventtimingNight
  EventtimingPhs
  EventtimingImd
  EventtimingHs
  EventtimingWake
  EventtimingC
  EventtimingCm
  EventtimingCd
  EventtimingCv
  EventtimingAc
  EventtimingAcm
  EventtimingAcd
  EventtimingAcv
  EventtimingPc
  EventtimingPcm
  EventtimingPcd
  EventtimingPcv
}

pub fn eventtiming_to_json(eventtiming: Eventtiming) -> Json {
  json.string(eventtiming_to_string(eventtiming))
}

pub fn eventtiming_to_string(eventtiming: Eventtiming) -> String {
  case eventtiming {
    EventtimingMorn -> "MORN"
    EventtimingMornearly -> "MORN.early"
    EventtimingMornlate -> "MORN.late"
    EventtimingNoon -> "NOON"
    EventtimingAft -> "AFT"
    EventtimingAftearly -> "AFT.early"
    EventtimingAftlate -> "AFT.late"
    EventtimingEve -> "EVE"
    EventtimingEveearly -> "EVE.early"
    EventtimingEvelate -> "EVE.late"
    EventtimingNight -> "NIGHT"
    EventtimingPhs -> "PHS"
    EventtimingImd -> "IMD"
    EventtimingHs -> "HS"
    EventtimingWake -> "WAKE"
    EventtimingC -> "C"
    EventtimingCm -> "CM"
    EventtimingCd -> "CD"
    EventtimingCv -> "CV"
    EventtimingAc -> "AC"
    EventtimingAcm -> "ACM"
    EventtimingAcd -> "ACD"
    EventtimingAcv -> "ACV"
    EventtimingPc -> "PC"
    EventtimingPcm -> "PCM"
    EventtimingPcd -> "PCD"
    EventtimingPcv -> "PCV"
  }
}

pub fn eventtiming_from_string(s: String) -> Result(Eventtiming, Nil) {
  case s {
    "MORN" -> Ok(EventtimingMorn)
    "MORN.early" -> Ok(EventtimingMornearly)
    "MORN.late" -> Ok(EventtimingMornlate)
    "NOON" -> Ok(EventtimingNoon)
    "AFT" -> Ok(EventtimingAft)
    "AFT.early" -> Ok(EventtimingAftearly)
    "AFT.late" -> Ok(EventtimingAftlate)
    "EVE" -> Ok(EventtimingEve)
    "EVE.early" -> Ok(EventtimingEveearly)
    "EVE.late" -> Ok(EventtimingEvelate)
    "NIGHT" -> Ok(EventtimingNight)
    "PHS" -> Ok(EventtimingPhs)
    "IMD" -> Ok(EventtimingImd)
    "HS" -> Ok(EventtimingHs)
    "WAKE" -> Ok(EventtimingWake)
    "C" -> Ok(EventtimingC)
    "CM" -> Ok(EventtimingCm)
    "CD" -> Ok(EventtimingCd)
    "CV" -> Ok(EventtimingCv)
    "AC" -> Ok(EventtimingAc)
    "ACM" -> Ok(EventtimingAcm)
    "ACD" -> Ok(EventtimingAcd)
    "ACV" -> Ok(EventtimingAcv)
    "PC" -> Ok(EventtimingPc)
    "PCM" -> Ok(EventtimingPcm)
    "PCD" -> Ok(EventtimingPcd)
    "PCV" -> Ok(EventtimingPcv)
    _ -> Error(Nil)
  }
}

pub fn eventtiming_decoder() -> Decoder(Eventtiming) {
  use variant <- decode.then(decode.string)
  case variant {
    "MORN" -> decode.success(EventtimingMorn)
    "MORN.early" -> decode.success(EventtimingMornearly)
    "MORN.late" -> decode.success(EventtimingMornlate)
    "NOON" -> decode.success(EventtimingNoon)
    "AFT" -> decode.success(EventtimingAft)
    "AFT.early" -> decode.success(EventtimingAftearly)
    "AFT.late" -> decode.success(EventtimingAftlate)
    "EVE" -> decode.success(EventtimingEve)
    "EVE.early" -> decode.success(EventtimingEveearly)
    "EVE.late" -> decode.success(EventtimingEvelate)
    "NIGHT" -> decode.success(EventtimingNight)
    "PHS" -> decode.success(EventtimingPhs)
    "IMD" -> decode.success(EventtimingImd)
    "HS" -> decode.success(EventtimingHs)
    "WAKE" -> decode.success(EventtimingWake)
    "C" -> decode.success(EventtimingC)
    "CM" -> decode.success(EventtimingCm)
    "CD" -> decode.success(EventtimingCd)
    "CV" -> decode.success(EventtimingCv)
    "AC" -> decode.success(EventtimingAc)
    "ACM" -> decode.success(EventtimingAcm)
    "ACD" -> decode.success(EventtimingAcd)
    "ACV" -> decode.success(EventtimingAcv)
    "PC" -> decode.success(EventtimingPc)
    "PCM" -> decode.success(EventtimingPcm)
    "PCD" -> decode.success(EventtimingPcd)
    "PCV" -> decode.success(EventtimingPcv)
    _ -> decode.failure(EventtimingMorn, "Eventtiming")
  }
}

pub type Examplescenarioactortype {
  ExamplescenarioactortypePerson
  ExamplescenarioactortypeSystem
}

pub fn examplescenarioactortype_to_json(
  examplescenarioactortype: Examplescenarioactortype,
) -> Json {
  json.string(examplescenarioactortype_to_string(examplescenarioactortype))
}

pub fn examplescenarioactortype_to_string(
  examplescenarioactortype: Examplescenarioactortype,
) -> String {
  case examplescenarioactortype {
    ExamplescenarioactortypePerson -> "person"
    ExamplescenarioactortypeSystem -> "system"
  }
}

pub fn examplescenarioactortype_from_string(
  s: String,
) -> Result(Examplescenarioactortype, Nil) {
  case s {
    "person" -> Ok(ExamplescenarioactortypePerson)
    "system" -> Ok(ExamplescenarioactortypeSystem)
    _ -> Error(Nil)
  }
}

pub fn examplescenarioactortype_decoder() -> Decoder(Examplescenarioactortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "person" -> decode.success(ExamplescenarioactortypePerson)
    "system" -> decode.success(ExamplescenarioactortypeSystem)
    _ ->
      decode.failure(ExamplescenarioactortypePerson, "Examplescenarioactortype")
  }
}

pub type Explanationofbenefitstatus {
  ExplanationofbenefitstatusActive
  ExplanationofbenefitstatusCancelled
  ExplanationofbenefitstatusDraft
  ExplanationofbenefitstatusEnteredinerror
}

pub fn explanationofbenefitstatus_to_json(
  explanationofbenefitstatus: Explanationofbenefitstatus,
) -> Json {
  json.string(explanationofbenefitstatus_to_string(explanationofbenefitstatus))
}

pub fn explanationofbenefitstatus_to_string(
  explanationofbenefitstatus: Explanationofbenefitstatus,
) -> String {
  case explanationofbenefitstatus {
    ExplanationofbenefitstatusActive -> "active"
    ExplanationofbenefitstatusCancelled -> "cancelled"
    ExplanationofbenefitstatusDraft -> "draft"
    ExplanationofbenefitstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn explanationofbenefitstatus_from_string(
  s: String,
) -> Result(Explanationofbenefitstatus, Nil) {
  case s {
    "active" -> Ok(ExplanationofbenefitstatusActive)
    "cancelled" -> Ok(ExplanationofbenefitstatusCancelled)
    "draft" -> Ok(ExplanationofbenefitstatusDraft)
    "entered-in-error" -> Ok(ExplanationofbenefitstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn explanationofbenefitstatus_decoder() -> Decoder(
  Explanationofbenefitstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(ExplanationofbenefitstatusActive)
    "cancelled" -> decode.success(ExplanationofbenefitstatusCancelled)
    "draft" -> decode.success(ExplanationofbenefitstatusDraft)
    "entered-in-error" ->
      decode.success(ExplanationofbenefitstatusEnteredinerror)
    _ ->
      decode.failure(
        ExplanationofbenefitstatusActive,
        "Explanationofbenefitstatus",
      )
  }
}

pub type Extensioncontexttype {
  ExtensioncontexttypeFhirpath
  ExtensioncontexttypeElement
  ExtensioncontexttypeExtension
}

pub fn extensioncontexttype_to_json(
  extensioncontexttype: Extensioncontexttype,
) -> Json {
  json.string(extensioncontexttype_to_string(extensioncontexttype))
}

pub fn extensioncontexttype_to_string(
  extensioncontexttype: Extensioncontexttype,
) -> String {
  case extensioncontexttype {
    ExtensioncontexttypeFhirpath -> "fhirpath"
    ExtensioncontexttypeElement -> "element"
    ExtensioncontexttypeExtension -> "extension"
  }
}

pub fn extensioncontexttype_from_string(
  s: String,
) -> Result(Extensioncontexttype, Nil) {
  case s {
    "fhirpath" -> Ok(ExtensioncontexttypeFhirpath)
    "element" -> Ok(ExtensioncontexttypeElement)
    "extension" -> Ok(ExtensioncontexttypeExtension)
    _ -> Error(Nil)
  }
}

pub fn extensioncontexttype_decoder() -> Decoder(Extensioncontexttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "fhirpath" -> decode.success(ExtensioncontexttypeFhirpath)
    "element" -> decode.success(ExtensioncontexttypeElement)
    "extension" -> decode.success(ExtensioncontexttypeExtension)
    _ -> decode.failure(ExtensioncontexttypeFhirpath, "Extensioncontexttype")
  }
}

pub type Fhirtypes {
  FhirtypesBase
  FhirtypesElement
  FhirtypesBackboneelement
  FhirtypesDatatype
  FhirtypesAddress
  FhirtypesAnnotation
  FhirtypesAttachment
  FhirtypesAvailability
  FhirtypesBackbonetype
  FhirtypesDosage
  FhirtypesElementdefinition
  FhirtypesMarketingstatus
  FhirtypesProductshelflife
  FhirtypesTiming
  FhirtypesCodeableconcept
  FhirtypesCodeablereference
  FhirtypesCoding
  FhirtypesContactdetail
  FhirtypesContactpoint
  FhirtypesContributor
  FhirtypesDatarequirement
  FhirtypesExpression
  FhirtypesExtendedcontactdetail
  FhirtypesExtension
  FhirtypesHumanname
  FhirtypesIdentifier
  FhirtypesMeta
  FhirtypesMonetarycomponent
  FhirtypesMoney
  FhirtypesNarrative
  FhirtypesParameterdefinition
  FhirtypesPeriod
  FhirtypesPrimitivetype
  FhirtypesBase64binary
  FhirtypesBoolean
  FhirtypesDate
  FhirtypesDatetime
  FhirtypesDecimal
  FhirtypesInstant
  FhirtypesInteger
  FhirtypesPositiveint
  FhirtypesUnsignedint
  FhirtypesInteger64
  FhirtypesString
  FhirtypesCode
  FhirtypesId
  FhirtypesMarkdown
  FhirtypesTime
  FhirtypesUri
  FhirtypesCanonical
  FhirtypesOid
  FhirtypesUrl
  FhirtypesUuid
  FhirtypesQuantity
  FhirtypesAge
  FhirtypesCount
  FhirtypesDistance
  FhirtypesDuration
  FhirtypesRange
  FhirtypesRatio
  FhirtypesRatiorange
  FhirtypesReference
  FhirtypesRelatedartifact
  FhirtypesSampleddata
  FhirtypesSignature
  FhirtypesTriggerdefinition
  FhirtypesUsagecontext
  FhirtypesVirtualservicedetail
  FhirtypesXhtml
  FhirtypesResource
  FhirtypesBinary
  FhirtypesBundle
  FhirtypesDomainresource
  FhirtypesAccount
  FhirtypesActivitydefinition
  FhirtypesActordefinition
  FhirtypesAdministrableproductdefinition
  FhirtypesAdverseevent
  FhirtypesAllergyintolerance
  FhirtypesAppointment
  FhirtypesAppointmentresponse
  FhirtypesArtifactassessment
  FhirtypesAuditevent
  FhirtypesBasic
  FhirtypesBiologicallyderivedproduct
  FhirtypesBiologicallyderivedproductdispense
  FhirtypesBodystructure
  FhirtypesCanonicalresource
  FhirtypesCapabilitystatement
  FhirtypesCareplan
  FhirtypesCareteam
  FhirtypesChargeitem
  FhirtypesChargeitemdefinition
  FhirtypesCitation
  FhirtypesClaim
  FhirtypesClaimresponse
  FhirtypesClinicalimpression
  FhirtypesClinicalusedefinition
  FhirtypesCodesystem
  FhirtypesCommunication
  FhirtypesCommunicationrequest
  FhirtypesCompartmentdefinition
  FhirtypesComposition
  FhirtypesConceptmap
  FhirtypesCondition
  FhirtypesConditiondefinition
  FhirtypesConsent
  FhirtypesContract
  FhirtypesCoverage
  FhirtypesCoverageeligibilityrequest
  FhirtypesCoverageeligibilityresponse
  FhirtypesDetectedissue
  FhirtypesDevice
  FhirtypesDeviceassociation
  FhirtypesDevicedefinition
  FhirtypesDevicedispense
  FhirtypesDevicemetric
  FhirtypesDevicerequest
  FhirtypesDeviceusage
  FhirtypesDiagnosticreport
  FhirtypesDocumentreference
  FhirtypesEncounter
  FhirtypesEncounterhistory
  FhirtypesEndpoint
  FhirtypesEnrollmentrequest
  FhirtypesEnrollmentresponse
  FhirtypesEpisodeofcare
  FhirtypesEventdefinition
  FhirtypesEvidence
  FhirtypesEvidencereport
  FhirtypesEvidencevariable
  FhirtypesExamplescenario
  FhirtypesExplanationofbenefit
  FhirtypesFamilymemberhistory
  FhirtypesFlag
  FhirtypesFormularyitem
  FhirtypesGenomicstudy
  FhirtypesGoal
  FhirtypesGraphdefinition
  FhirtypesGroup
  FhirtypesGuidanceresponse
  FhirtypesHealthcareservice
  FhirtypesImagingselection
  FhirtypesImagingstudy
  FhirtypesImmunization
  FhirtypesImmunizationevaluation
  FhirtypesImmunizationrecommendation
  FhirtypesImplementationguide
  FhirtypesIngredient
  FhirtypesInsuranceplan
  FhirtypesInventoryitem
  FhirtypesInventoryreport
  FhirtypesInvoice
  FhirtypesLibrary
  FhirtypesLinkage
  FhirtypesList
  FhirtypesLocation
  FhirtypesManufactureditemdefinition
  FhirtypesMeasure
  FhirtypesMeasurereport
  FhirtypesMedication
  FhirtypesMedicationadministration
  FhirtypesMedicationdispense
  FhirtypesMedicationknowledge
  FhirtypesMedicationrequest
  FhirtypesMedicationstatement
  FhirtypesMedicinalproductdefinition
  FhirtypesMessagedefinition
  FhirtypesMessageheader
  FhirtypesMetadataresource
  FhirtypesMolecularsequence
  FhirtypesNamingsystem
  FhirtypesNutritionintake
  FhirtypesNutritionorder
  FhirtypesNutritionproduct
  FhirtypesObservation
  FhirtypesObservationdefinition
  FhirtypesOperationdefinition
  FhirtypesOperationoutcome
  FhirtypesOrganization
  FhirtypesOrganizationaffiliation
  FhirtypesPackagedproductdefinition
  FhirtypesPatient
  FhirtypesPaymentnotice
  FhirtypesPaymentreconciliation
  FhirtypesPermission
  FhirtypesPerson
  FhirtypesPlandefinition
  FhirtypesPractitioner
  FhirtypesPractitionerrole
  FhirtypesProcedure
  FhirtypesProvenance
  FhirtypesQuestionnaire
  FhirtypesQuestionnaireresponse
  FhirtypesRegulatedauthorization
  FhirtypesRelatedperson
  FhirtypesRequestorchestration
  FhirtypesRequirements
  FhirtypesResearchstudy
  FhirtypesResearchsubject
  FhirtypesRiskassessment
  FhirtypesSchedule
  FhirtypesSearchparameter
  FhirtypesServicerequest
  FhirtypesSlot
  FhirtypesSpecimen
  FhirtypesSpecimendefinition
  FhirtypesStructuredefinition
  FhirtypesStructuremap
  FhirtypesSubscription
  FhirtypesSubscriptionstatus
  FhirtypesSubscriptiontopic
  FhirtypesSubstance
  FhirtypesSubstancedefinition
  FhirtypesSubstancenucleicacid
  FhirtypesSubstancepolymer
  FhirtypesSubstanceprotein
  FhirtypesSubstancereferenceinformation
  FhirtypesSubstancesourcematerial
  FhirtypesSupplydelivery
  FhirtypesSupplyrequest
  FhirtypesTask
  FhirtypesTerminologycapabilities
  FhirtypesTestplan
  FhirtypesTestreport
  FhirtypesTestscript
  FhirtypesTransport
  FhirtypesValueset
  FhirtypesVerificationresult
  FhirtypesVisionprescription
  FhirtypesParameters
}

pub fn fhirtypes_to_json(fhirtypes: Fhirtypes) -> Json {
  json.string(fhirtypes_to_string(fhirtypes))
}

pub fn fhirtypes_to_string(fhirtypes: Fhirtypes) -> String {
  case fhirtypes {
    FhirtypesBase -> "Base"
    FhirtypesElement -> "Element"
    FhirtypesBackboneelement -> "BackboneElement"
    FhirtypesDatatype -> "DataType"
    FhirtypesAddress -> "Address"
    FhirtypesAnnotation -> "Annotation"
    FhirtypesAttachment -> "Attachment"
    FhirtypesAvailability -> "Availability"
    FhirtypesBackbonetype -> "BackboneType"
    FhirtypesDosage -> "Dosage"
    FhirtypesElementdefinition -> "ElementDefinition"
    FhirtypesMarketingstatus -> "MarketingStatus"
    FhirtypesProductshelflife -> "ProductShelfLife"
    FhirtypesTiming -> "Timing"
    FhirtypesCodeableconcept -> "CodeableConcept"
    FhirtypesCodeablereference -> "CodeableReference"
    FhirtypesCoding -> "Coding"
    FhirtypesContactdetail -> "ContactDetail"
    FhirtypesContactpoint -> "ContactPoint"
    FhirtypesContributor -> "Contributor"
    FhirtypesDatarequirement -> "DataRequirement"
    FhirtypesExpression -> "Expression"
    FhirtypesExtendedcontactdetail -> "ExtendedContactDetail"
    FhirtypesExtension -> "Extension"
    FhirtypesHumanname -> "HumanName"
    FhirtypesIdentifier -> "Identifier"
    FhirtypesMeta -> "Meta"
    FhirtypesMonetarycomponent -> "MonetaryComponent"
    FhirtypesMoney -> "Money"
    FhirtypesNarrative -> "Narrative"
    FhirtypesParameterdefinition -> "ParameterDefinition"
    FhirtypesPeriod -> "Period"
    FhirtypesPrimitivetype -> "PrimitiveType"
    FhirtypesBase64binary -> "base64Binary"
    FhirtypesBoolean -> "boolean"
    FhirtypesDate -> "date"
    FhirtypesDatetime -> "dateTime"
    FhirtypesDecimal -> "decimal"
    FhirtypesInstant -> "instant"
    FhirtypesInteger -> "integer"
    FhirtypesPositiveint -> "positiveInt"
    FhirtypesUnsignedint -> "unsignedInt"
    FhirtypesInteger64 -> "integer64"
    FhirtypesString -> "string"
    FhirtypesCode -> "code"
    FhirtypesId -> "id"
    FhirtypesMarkdown -> "markdown"
    FhirtypesTime -> "time"
    FhirtypesUri -> "uri"
    FhirtypesCanonical -> "canonical"
    FhirtypesOid -> "oid"
    FhirtypesUrl -> "url"
    FhirtypesUuid -> "uuid"
    FhirtypesQuantity -> "Quantity"
    FhirtypesAge -> "Age"
    FhirtypesCount -> "Count"
    FhirtypesDistance -> "Distance"
    FhirtypesDuration -> "Duration"
    FhirtypesRange -> "Range"
    FhirtypesRatio -> "Ratio"
    FhirtypesRatiorange -> "RatioRange"
    FhirtypesReference -> "Reference"
    FhirtypesRelatedartifact -> "RelatedArtifact"
    FhirtypesSampleddata -> "SampledData"
    FhirtypesSignature -> "Signature"
    FhirtypesTriggerdefinition -> "TriggerDefinition"
    FhirtypesUsagecontext -> "UsageContext"
    FhirtypesVirtualservicedetail -> "VirtualServiceDetail"
    FhirtypesXhtml -> "xhtml"
    FhirtypesResource -> "Resource"
    FhirtypesBinary -> "Binary"
    FhirtypesBundle -> "Bundle"
    FhirtypesDomainresource -> "DomainResource"
    FhirtypesAccount -> "Account"
    FhirtypesActivitydefinition -> "ActivityDefinition"
    FhirtypesActordefinition -> "ActorDefinition"
    FhirtypesAdministrableproductdefinition -> "AdministrableProductDefinition"
    FhirtypesAdverseevent -> "AdverseEvent"
    FhirtypesAllergyintolerance -> "AllergyIntolerance"
    FhirtypesAppointment -> "Appointment"
    FhirtypesAppointmentresponse -> "AppointmentResponse"
    FhirtypesArtifactassessment -> "ArtifactAssessment"
    FhirtypesAuditevent -> "AuditEvent"
    FhirtypesBasic -> "Basic"
    FhirtypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    FhirtypesBiologicallyderivedproductdispense ->
      "BiologicallyDerivedProductDispense"
    FhirtypesBodystructure -> "BodyStructure"
    FhirtypesCanonicalresource -> "CanonicalResource"
    FhirtypesCapabilitystatement -> "CapabilityStatement"
    FhirtypesCareplan -> "CarePlan"
    FhirtypesCareteam -> "CareTeam"
    FhirtypesChargeitem -> "ChargeItem"
    FhirtypesChargeitemdefinition -> "ChargeItemDefinition"
    FhirtypesCitation -> "Citation"
    FhirtypesClaim -> "Claim"
    FhirtypesClaimresponse -> "ClaimResponse"
    FhirtypesClinicalimpression -> "ClinicalImpression"
    FhirtypesClinicalusedefinition -> "ClinicalUseDefinition"
    FhirtypesCodesystem -> "CodeSystem"
    FhirtypesCommunication -> "Communication"
    FhirtypesCommunicationrequest -> "CommunicationRequest"
    FhirtypesCompartmentdefinition -> "CompartmentDefinition"
    FhirtypesComposition -> "Composition"
    FhirtypesConceptmap -> "ConceptMap"
    FhirtypesCondition -> "Condition"
    FhirtypesConditiondefinition -> "ConditionDefinition"
    FhirtypesConsent -> "Consent"
    FhirtypesContract -> "Contract"
    FhirtypesCoverage -> "Coverage"
    FhirtypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    FhirtypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    FhirtypesDetectedissue -> "DetectedIssue"
    FhirtypesDevice -> "Device"
    FhirtypesDeviceassociation -> "DeviceAssociation"
    FhirtypesDevicedefinition -> "DeviceDefinition"
    FhirtypesDevicedispense -> "DeviceDispense"
    FhirtypesDevicemetric -> "DeviceMetric"
    FhirtypesDevicerequest -> "DeviceRequest"
    FhirtypesDeviceusage -> "DeviceUsage"
    FhirtypesDiagnosticreport -> "DiagnosticReport"
    FhirtypesDocumentreference -> "DocumentReference"
    FhirtypesEncounter -> "Encounter"
    FhirtypesEncounterhistory -> "EncounterHistory"
    FhirtypesEndpoint -> "Endpoint"
    FhirtypesEnrollmentrequest -> "EnrollmentRequest"
    FhirtypesEnrollmentresponse -> "EnrollmentResponse"
    FhirtypesEpisodeofcare -> "EpisodeOfCare"
    FhirtypesEventdefinition -> "EventDefinition"
    FhirtypesEvidence -> "Evidence"
    FhirtypesEvidencereport -> "EvidenceReport"
    FhirtypesEvidencevariable -> "EvidenceVariable"
    FhirtypesExamplescenario -> "ExampleScenario"
    FhirtypesExplanationofbenefit -> "ExplanationOfBenefit"
    FhirtypesFamilymemberhistory -> "FamilyMemberHistory"
    FhirtypesFlag -> "Flag"
    FhirtypesFormularyitem -> "FormularyItem"
    FhirtypesGenomicstudy -> "GenomicStudy"
    FhirtypesGoal -> "Goal"
    FhirtypesGraphdefinition -> "GraphDefinition"
    FhirtypesGroup -> "Group"
    FhirtypesGuidanceresponse -> "GuidanceResponse"
    FhirtypesHealthcareservice -> "HealthcareService"
    FhirtypesImagingselection -> "ImagingSelection"
    FhirtypesImagingstudy -> "ImagingStudy"
    FhirtypesImmunization -> "Immunization"
    FhirtypesImmunizationevaluation -> "ImmunizationEvaluation"
    FhirtypesImmunizationrecommendation -> "ImmunizationRecommendation"
    FhirtypesImplementationguide -> "ImplementationGuide"
    FhirtypesIngredient -> "Ingredient"
    FhirtypesInsuranceplan -> "InsurancePlan"
    FhirtypesInventoryitem -> "InventoryItem"
    FhirtypesInventoryreport -> "InventoryReport"
    FhirtypesInvoice -> "Invoice"
    FhirtypesLibrary -> "Library"
    FhirtypesLinkage -> "Linkage"
    FhirtypesList -> "List"
    FhirtypesLocation -> "Location"
    FhirtypesManufactureditemdefinition -> "ManufacturedItemDefinition"
    FhirtypesMeasure -> "Measure"
    FhirtypesMeasurereport -> "MeasureReport"
    FhirtypesMedication -> "Medication"
    FhirtypesMedicationadministration -> "MedicationAdministration"
    FhirtypesMedicationdispense -> "MedicationDispense"
    FhirtypesMedicationknowledge -> "MedicationKnowledge"
    FhirtypesMedicationrequest -> "MedicationRequest"
    FhirtypesMedicationstatement -> "MedicationStatement"
    FhirtypesMedicinalproductdefinition -> "MedicinalProductDefinition"
    FhirtypesMessagedefinition -> "MessageDefinition"
    FhirtypesMessageheader -> "MessageHeader"
    FhirtypesMetadataresource -> "MetadataResource"
    FhirtypesMolecularsequence -> "MolecularSequence"
    FhirtypesNamingsystem -> "NamingSystem"
    FhirtypesNutritionintake -> "NutritionIntake"
    FhirtypesNutritionorder -> "NutritionOrder"
    FhirtypesNutritionproduct -> "NutritionProduct"
    FhirtypesObservation -> "Observation"
    FhirtypesObservationdefinition -> "ObservationDefinition"
    FhirtypesOperationdefinition -> "OperationDefinition"
    FhirtypesOperationoutcome -> "OperationOutcome"
    FhirtypesOrganization -> "Organization"
    FhirtypesOrganizationaffiliation -> "OrganizationAffiliation"
    FhirtypesPackagedproductdefinition -> "PackagedProductDefinition"
    FhirtypesPatient -> "Patient"
    FhirtypesPaymentnotice -> "PaymentNotice"
    FhirtypesPaymentreconciliation -> "PaymentReconciliation"
    FhirtypesPermission -> "Permission"
    FhirtypesPerson -> "Person"
    FhirtypesPlandefinition -> "PlanDefinition"
    FhirtypesPractitioner -> "Practitioner"
    FhirtypesPractitionerrole -> "PractitionerRole"
    FhirtypesProcedure -> "Procedure"
    FhirtypesProvenance -> "Provenance"
    FhirtypesQuestionnaire -> "Questionnaire"
    FhirtypesQuestionnaireresponse -> "QuestionnaireResponse"
    FhirtypesRegulatedauthorization -> "RegulatedAuthorization"
    FhirtypesRelatedperson -> "RelatedPerson"
    FhirtypesRequestorchestration -> "RequestOrchestration"
    FhirtypesRequirements -> "Requirements"
    FhirtypesResearchstudy -> "ResearchStudy"
    FhirtypesResearchsubject -> "ResearchSubject"
    FhirtypesRiskassessment -> "RiskAssessment"
    FhirtypesSchedule -> "Schedule"
    FhirtypesSearchparameter -> "SearchParameter"
    FhirtypesServicerequest -> "ServiceRequest"
    FhirtypesSlot -> "Slot"
    FhirtypesSpecimen -> "Specimen"
    FhirtypesSpecimendefinition -> "SpecimenDefinition"
    FhirtypesStructuredefinition -> "StructureDefinition"
    FhirtypesStructuremap -> "StructureMap"
    FhirtypesSubscription -> "Subscription"
    FhirtypesSubscriptionstatus -> "SubscriptionStatus"
    FhirtypesSubscriptiontopic -> "SubscriptionTopic"
    FhirtypesSubstance -> "Substance"
    FhirtypesSubstancedefinition -> "SubstanceDefinition"
    FhirtypesSubstancenucleicacid -> "SubstanceNucleicAcid"
    FhirtypesSubstancepolymer -> "SubstancePolymer"
    FhirtypesSubstanceprotein -> "SubstanceProtein"
    FhirtypesSubstancereferenceinformation -> "SubstanceReferenceInformation"
    FhirtypesSubstancesourcematerial -> "SubstanceSourceMaterial"
    FhirtypesSupplydelivery -> "SupplyDelivery"
    FhirtypesSupplyrequest -> "SupplyRequest"
    FhirtypesTask -> "Task"
    FhirtypesTerminologycapabilities -> "TerminologyCapabilities"
    FhirtypesTestplan -> "TestPlan"
    FhirtypesTestreport -> "TestReport"
    FhirtypesTestscript -> "TestScript"
    FhirtypesTransport -> "Transport"
    FhirtypesValueset -> "ValueSet"
    FhirtypesVerificationresult -> "VerificationResult"
    FhirtypesVisionprescription -> "VisionPrescription"
    FhirtypesParameters -> "Parameters"
  }
}

pub fn fhirtypes_from_string(s: String) -> Result(Fhirtypes, Nil) {
  case s {
    "Base" -> Ok(FhirtypesBase)
    "Element" -> Ok(FhirtypesElement)
    "BackboneElement" -> Ok(FhirtypesBackboneelement)
    "DataType" -> Ok(FhirtypesDatatype)
    "Address" -> Ok(FhirtypesAddress)
    "Annotation" -> Ok(FhirtypesAnnotation)
    "Attachment" -> Ok(FhirtypesAttachment)
    "Availability" -> Ok(FhirtypesAvailability)
    "BackboneType" -> Ok(FhirtypesBackbonetype)
    "Dosage" -> Ok(FhirtypesDosage)
    "ElementDefinition" -> Ok(FhirtypesElementdefinition)
    "MarketingStatus" -> Ok(FhirtypesMarketingstatus)
    "ProductShelfLife" -> Ok(FhirtypesProductshelflife)
    "Timing" -> Ok(FhirtypesTiming)
    "CodeableConcept" -> Ok(FhirtypesCodeableconcept)
    "CodeableReference" -> Ok(FhirtypesCodeablereference)
    "Coding" -> Ok(FhirtypesCoding)
    "ContactDetail" -> Ok(FhirtypesContactdetail)
    "ContactPoint" -> Ok(FhirtypesContactpoint)
    "Contributor" -> Ok(FhirtypesContributor)
    "DataRequirement" -> Ok(FhirtypesDatarequirement)
    "Expression" -> Ok(FhirtypesExpression)
    "ExtendedContactDetail" -> Ok(FhirtypesExtendedcontactdetail)
    "Extension" -> Ok(FhirtypesExtension)
    "HumanName" -> Ok(FhirtypesHumanname)
    "Identifier" -> Ok(FhirtypesIdentifier)
    "Meta" -> Ok(FhirtypesMeta)
    "MonetaryComponent" -> Ok(FhirtypesMonetarycomponent)
    "Money" -> Ok(FhirtypesMoney)
    "Narrative" -> Ok(FhirtypesNarrative)
    "ParameterDefinition" -> Ok(FhirtypesParameterdefinition)
    "Period" -> Ok(FhirtypesPeriod)
    "PrimitiveType" -> Ok(FhirtypesPrimitivetype)
    "base64Binary" -> Ok(FhirtypesBase64binary)
    "boolean" -> Ok(FhirtypesBoolean)
    "date" -> Ok(FhirtypesDate)
    "dateTime" -> Ok(FhirtypesDatetime)
    "decimal" -> Ok(FhirtypesDecimal)
    "instant" -> Ok(FhirtypesInstant)
    "integer" -> Ok(FhirtypesInteger)
    "positiveInt" -> Ok(FhirtypesPositiveint)
    "unsignedInt" -> Ok(FhirtypesUnsignedint)
    "integer64" -> Ok(FhirtypesInteger64)
    "string" -> Ok(FhirtypesString)
    "code" -> Ok(FhirtypesCode)
    "id" -> Ok(FhirtypesId)
    "markdown" -> Ok(FhirtypesMarkdown)
    "time" -> Ok(FhirtypesTime)
    "uri" -> Ok(FhirtypesUri)
    "canonical" -> Ok(FhirtypesCanonical)
    "oid" -> Ok(FhirtypesOid)
    "url" -> Ok(FhirtypesUrl)
    "uuid" -> Ok(FhirtypesUuid)
    "Quantity" -> Ok(FhirtypesQuantity)
    "Age" -> Ok(FhirtypesAge)
    "Count" -> Ok(FhirtypesCount)
    "Distance" -> Ok(FhirtypesDistance)
    "Duration" -> Ok(FhirtypesDuration)
    "Range" -> Ok(FhirtypesRange)
    "Ratio" -> Ok(FhirtypesRatio)
    "RatioRange" -> Ok(FhirtypesRatiorange)
    "Reference" -> Ok(FhirtypesReference)
    "RelatedArtifact" -> Ok(FhirtypesRelatedartifact)
    "SampledData" -> Ok(FhirtypesSampleddata)
    "Signature" -> Ok(FhirtypesSignature)
    "TriggerDefinition" -> Ok(FhirtypesTriggerdefinition)
    "UsageContext" -> Ok(FhirtypesUsagecontext)
    "VirtualServiceDetail" -> Ok(FhirtypesVirtualservicedetail)
    "xhtml" -> Ok(FhirtypesXhtml)
    "Resource" -> Ok(FhirtypesResource)
    "Binary" -> Ok(FhirtypesBinary)
    "Bundle" -> Ok(FhirtypesBundle)
    "DomainResource" -> Ok(FhirtypesDomainresource)
    "Account" -> Ok(FhirtypesAccount)
    "ActivityDefinition" -> Ok(FhirtypesActivitydefinition)
    "ActorDefinition" -> Ok(FhirtypesActordefinition)
    "AdministrableProductDefinition" ->
      Ok(FhirtypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(FhirtypesAdverseevent)
    "AllergyIntolerance" -> Ok(FhirtypesAllergyintolerance)
    "Appointment" -> Ok(FhirtypesAppointment)
    "AppointmentResponse" -> Ok(FhirtypesAppointmentresponse)
    "ArtifactAssessment" -> Ok(FhirtypesArtifactassessment)
    "AuditEvent" -> Ok(FhirtypesAuditevent)
    "Basic" -> Ok(FhirtypesBasic)
    "BiologicallyDerivedProduct" -> Ok(FhirtypesBiologicallyderivedproduct)
    "BiologicallyDerivedProductDispense" ->
      Ok(FhirtypesBiologicallyderivedproductdispense)
    "BodyStructure" -> Ok(FhirtypesBodystructure)
    "CanonicalResource" -> Ok(FhirtypesCanonicalresource)
    "CapabilityStatement" -> Ok(FhirtypesCapabilitystatement)
    "CarePlan" -> Ok(FhirtypesCareplan)
    "CareTeam" -> Ok(FhirtypesCareteam)
    "ChargeItem" -> Ok(FhirtypesChargeitem)
    "ChargeItemDefinition" -> Ok(FhirtypesChargeitemdefinition)
    "Citation" -> Ok(FhirtypesCitation)
    "Claim" -> Ok(FhirtypesClaim)
    "ClaimResponse" -> Ok(FhirtypesClaimresponse)
    "ClinicalImpression" -> Ok(FhirtypesClinicalimpression)
    "ClinicalUseDefinition" -> Ok(FhirtypesClinicalusedefinition)
    "CodeSystem" -> Ok(FhirtypesCodesystem)
    "Communication" -> Ok(FhirtypesCommunication)
    "CommunicationRequest" -> Ok(FhirtypesCommunicationrequest)
    "CompartmentDefinition" -> Ok(FhirtypesCompartmentdefinition)
    "Composition" -> Ok(FhirtypesComposition)
    "ConceptMap" -> Ok(FhirtypesConceptmap)
    "Condition" -> Ok(FhirtypesCondition)
    "ConditionDefinition" -> Ok(FhirtypesConditiondefinition)
    "Consent" -> Ok(FhirtypesConsent)
    "Contract" -> Ok(FhirtypesContract)
    "Coverage" -> Ok(FhirtypesCoverage)
    "CoverageEligibilityRequest" -> Ok(FhirtypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" -> Ok(FhirtypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(FhirtypesDetectedissue)
    "Device" -> Ok(FhirtypesDevice)
    "DeviceAssociation" -> Ok(FhirtypesDeviceassociation)
    "DeviceDefinition" -> Ok(FhirtypesDevicedefinition)
    "DeviceDispense" -> Ok(FhirtypesDevicedispense)
    "DeviceMetric" -> Ok(FhirtypesDevicemetric)
    "DeviceRequest" -> Ok(FhirtypesDevicerequest)
    "DeviceUsage" -> Ok(FhirtypesDeviceusage)
    "DiagnosticReport" -> Ok(FhirtypesDiagnosticreport)
    "DocumentReference" -> Ok(FhirtypesDocumentreference)
    "Encounter" -> Ok(FhirtypesEncounter)
    "EncounterHistory" -> Ok(FhirtypesEncounterhistory)
    "Endpoint" -> Ok(FhirtypesEndpoint)
    "EnrollmentRequest" -> Ok(FhirtypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(FhirtypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(FhirtypesEpisodeofcare)
    "EventDefinition" -> Ok(FhirtypesEventdefinition)
    "Evidence" -> Ok(FhirtypesEvidence)
    "EvidenceReport" -> Ok(FhirtypesEvidencereport)
    "EvidenceVariable" -> Ok(FhirtypesEvidencevariable)
    "ExampleScenario" -> Ok(FhirtypesExamplescenario)
    "ExplanationOfBenefit" -> Ok(FhirtypesExplanationofbenefit)
    "FamilyMemberHistory" -> Ok(FhirtypesFamilymemberhistory)
    "Flag" -> Ok(FhirtypesFlag)
    "FormularyItem" -> Ok(FhirtypesFormularyitem)
    "GenomicStudy" -> Ok(FhirtypesGenomicstudy)
    "Goal" -> Ok(FhirtypesGoal)
    "GraphDefinition" -> Ok(FhirtypesGraphdefinition)
    "Group" -> Ok(FhirtypesGroup)
    "GuidanceResponse" -> Ok(FhirtypesGuidanceresponse)
    "HealthcareService" -> Ok(FhirtypesHealthcareservice)
    "ImagingSelection" -> Ok(FhirtypesImagingselection)
    "ImagingStudy" -> Ok(FhirtypesImagingstudy)
    "Immunization" -> Ok(FhirtypesImmunization)
    "ImmunizationEvaluation" -> Ok(FhirtypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(FhirtypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(FhirtypesImplementationguide)
    "Ingredient" -> Ok(FhirtypesIngredient)
    "InsurancePlan" -> Ok(FhirtypesInsuranceplan)
    "InventoryItem" -> Ok(FhirtypesInventoryitem)
    "InventoryReport" -> Ok(FhirtypesInventoryreport)
    "Invoice" -> Ok(FhirtypesInvoice)
    "Library" -> Ok(FhirtypesLibrary)
    "Linkage" -> Ok(FhirtypesLinkage)
    "List" -> Ok(FhirtypesList)
    "Location" -> Ok(FhirtypesLocation)
    "ManufacturedItemDefinition" -> Ok(FhirtypesManufactureditemdefinition)
    "Measure" -> Ok(FhirtypesMeasure)
    "MeasureReport" -> Ok(FhirtypesMeasurereport)
    "Medication" -> Ok(FhirtypesMedication)
    "MedicationAdministration" -> Ok(FhirtypesMedicationadministration)
    "MedicationDispense" -> Ok(FhirtypesMedicationdispense)
    "MedicationKnowledge" -> Ok(FhirtypesMedicationknowledge)
    "MedicationRequest" -> Ok(FhirtypesMedicationrequest)
    "MedicationStatement" -> Ok(FhirtypesMedicationstatement)
    "MedicinalProductDefinition" -> Ok(FhirtypesMedicinalproductdefinition)
    "MessageDefinition" -> Ok(FhirtypesMessagedefinition)
    "MessageHeader" -> Ok(FhirtypesMessageheader)
    "MetadataResource" -> Ok(FhirtypesMetadataresource)
    "MolecularSequence" -> Ok(FhirtypesMolecularsequence)
    "NamingSystem" -> Ok(FhirtypesNamingsystem)
    "NutritionIntake" -> Ok(FhirtypesNutritionintake)
    "NutritionOrder" -> Ok(FhirtypesNutritionorder)
    "NutritionProduct" -> Ok(FhirtypesNutritionproduct)
    "Observation" -> Ok(FhirtypesObservation)
    "ObservationDefinition" -> Ok(FhirtypesObservationdefinition)
    "OperationDefinition" -> Ok(FhirtypesOperationdefinition)
    "OperationOutcome" -> Ok(FhirtypesOperationoutcome)
    "Organization" -> Ok(FhirtypesOrganization)
    "OrganizationAffiliation" -> Ok(FhirtypesOrganizationaffiliation)
    "PackagedProductDefinition" -> Ok(FhirtypesPackagedproductdefinition)
    "Patient" -> Ok(FhirtypesPatient)
    "PaymentNotice" -> Ok(FhirtypesPaymentnotice)
    "PaymentReconciliation" -> Ok(FhirtypesPaymentreconciliation)
    "Permission" -> Ok(FhirtypesPermission)
    "Person" -> Ok(FhirtypesPerson)
    "PlanDefinition" -> Ok(FhirtypesPlandefinition)
    "Practitioner" -> Ok(FhirtypesPractitioner)
    "PractitionerRole" -> Ok(FhirtypesPractitionerrole)
    "Procedure" -> Ok(FhirtypesProcedure)
    "Provenance" -> Ok(FhirtypesProvenance)
    "Questionnaire" -> Ok(FhirtypesQuestionnaire)
    "QuestionnaireResponse" -> Ok(FhirtypesQuestionnaireresponse)
    "RegulatedAuthorization" -> Ok(FhirtypesRegulatedauthorization)
    "RelatedPerson" -> Ok(FhirtypesRelatedperson)
    "RequestOrchestration" -> Ok(FhirtypesRequestorchestration)
    "Requirements" -> Ok(FhirtypesRequirements)
    "ResearchStudy" -> Ok(FhirtypesResearchstudy)
    "ResearchSubject" -> Ok(FhirtypesResearchsubject)
    "RiskAssessment" -> Ok(FhirtypesRiskassessment)
    "Schedule" -> Ok(FhirtypesSchedule)
    "SearchParameter" -> Ok(FhirtypesSearchparameter)
    "ServiceRequest" -> Ok(FhirtypesServicerequest)
    "Slot" -> Ok(FhirtypesSlot)
    "Specimen" -> Ok(FhirtypesSpecimen)
    "SpecimenDefinition" -> Ok(FhirtypesSpecimendefinition)
    "StructureDefinition" -> Ok(FhirtypesStructuredefinition)
    "StructureMap" -> Ok(FhirtypesStructuremap)
    "Subscription" -> Ok(FhirtypesSubscription)
    "SubscriptionStatus" -> Ok(FhirtypesSubscriptionstatus)
    "SubscriptionTopic" -> Ok(FhirtypesSubscriptiontopic)
    "Substance" -> Ok(FhirtypesSubstance)
    "SubstanceDefinition" -> Ok(FhirtypesSubstancedefinition)
    "SubstanceNucleicAcid" -> Ok(FhirtypesSubstancenucleicacid)
    "SubstancePolymer" -> Ok(FhirtypesSubstancepolymer)
    "SubstanceProtein" -> Ok(FhirtypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      Ok(FhirtypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> Ok(FhirtypesSubstancesourcematerial)
    "SupplyDelivery" -> Ok(FhirtypesSupplydelivery)
    "SupplyRequest" -> Ok(FhirtypesSupplyrequest)
    "Task" -> Ok(FhirtypesTask)
    "TerminologyCapabilities" -> Ok(FhirtypesTerminologycapabilities)
    "TestPlan" -> Ok(FhirtypesTestplan)
    "TestReport" -> Ok(FhirtypesTestreport)
    "TestScript" -> Ok(FhirtypesTestscript)
    "Transport" -> Ok(FhirtypesTransport)
    "ValueSet" -> Ok(FhirtypesValueset)
    "VerificationResult" -> Ok(FhirtypesVerificationresult)
    "VisionPrescription" -> Ok(FhirtypesVisionprescription)
    "Parameters" -> Ok(FhirtypesParameters)
    _ -> Error(Nil)
  }
}

pub fn fhirtypes_decoder() -> Decoder(Fhirtypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Base" -> decode.success(FhirtypesBase)
    "Element" -> decode.success(FhirtypesElement)
    "BackboneElement" -> decode.success(FhirtypesBackboneelement)
    "DataType" -> decode.success(FhirtypesDatatype)
    "Address" -> decode.success(FhirtypesAddress)
    "Annotation" -> decode.success(FhirtypesAnnotation)
    "Attachment" -> decode.success(FhirtypesAttachment)
    "Availability" -> decode.success(FhirtypesAvailability)
    "BackboneType" -> decode.success(FhirtypesBackbonetype)
    "Dosage" -> decode.success(FhirtypesDosage)
    "ElementDefinition" -> decode.success(FhirtypesElementdefinition)
    "MarketingStatus" -> decode.success(FhirtypesMarketingstatus)
    "ProductShelfLife" -> decode.success(FhirtypesProductshelflife)
    "Timing" -> decode.success(FhirtypesTiming)
    "CodeableConcept" -> decode.success(FhirtypesCodeableconcept)
    "CodeableReference" -> decode.success(FhirtypesCodeablereference)
    "Coding" -> decode.success(FhirtypesCoding)
    "ContactDetail" -> decode.success(FhirtypesContactdetail)
    "ContactPoint" -> decode.success(FhirtypesContactpoint)
    "Contributor" -> decode.success(FhirtypesContributor)
    "DataRequirement" -> decode.success(FhirtypesDatarequirement)
    "Expression" -> decode.success(FhirtypesExpression)
    "ExtendedContactDetail" -> decode.success(FhirtypesExtendedcontactdetail)
    "Extension" -> decode.success(FhirtypesExtension)
    "HumanName" -> decode.success(FhirtypesHumanname)
    "Identifier" -> decode.success(FhirtypesIdentifier)
    "Meta" -> decode.success(FhirtypesMeta)
    "MonetaryComponent" -> decode.success(FhirtypesMonetarycomponent)
    "Money" -> decode.success(FhirtypesMoney)
    "Narrative" -> decode.success(FhirtypesNarrative)
    "ParameterDefinition" -> decode.success(FhirtypesParameterdefinition)
    "Period" -> decode.success(FhirtypesPeriod)
    "PrimitiveType" -> decode.success(FhirtypesPrimitivetype)
    "base64Binary" -> decode.success(FhirtypesBase64binary)
    "boolean" -> decode.success(FhirtypesBoolean)
    "date" -> decode.success(FhirtypesDate)
    "dateTime" -> decode.success(FhirtypesDatetime)
    "decimal" -> decode.success(FhirtypesDecimal)
    "instant" -> decode.success(FhirtypesInstant)
    "integer" -> decode.success(FhirtypesInteger)
    "positiveInt" -> decode.success(FhirtypesPositiveint)
    "unsignedInt" -> decode.success(FhirtypesUnsignedint)
    "integer64" -> decode.success(FhirtypesInteger64)
    "string" -> decode.success(FhirtypesString)
    "code" -> decode.success(FhirtypesCode)
    "id" -> decode.success(FhirtypesId)
    "markdown" -> decode.success(FhirtypesMarkdown)
    "time" -> decode.success(FhirtypesTime)
    "uri" -> decode.success(FhirtypesUri)
    "canonical" -> decode.success(FhirtypesCanonical)
    "oid" -> decode.success(FhirtypesOid)
    "url" -> decode.success(FhirtypesUrl)
    "uuid" -> decode.success(FhirtypesUuid)
    "Quantity" -> decode.success(FhirtypesQuantity)
    "Age" -> decode.success(FhirtypesAge)
    "Count" -> decode.success(FhirtypesCount)
    "Distance" -> decode.success(FhirtypesDistance)
    "Duration" -> decode.success(FhirtypesDuration)
    "Range" -> decode.success(FhirtypesRange)
    "Ratio" -> decode.success(FhirtypesRatio)
    "RatioRange" -> decode.success(FhirtypesRatiorange)
    "Reference" -> decode.success(FhirtypesReference)
    "RelatedArtifact" -> decode.success(FhirtypesRelatedartifact)
    "SampledData" -> decode.success(FhirtypesSampleddata)
    "Signature" -> decode.success(FhirtypesSignature)
    "TriggerDefinition" -> decode.success(FhirtypesTriggerdefinition)
    "UsageContext" -> decode.success(FhirtypesUsagecontext)
    "VirtualServiceDetail" -> decode.success(FhirtypesVirtualservicedetail)
    "xhtml" -> decode.success(FhirtypesXhtml)
    "Resource" -> decode.success(FhirtypesResource)
    "Binary" -> decode.success(FhirtypesBinary)
    "Bundle" -> decode.success(FhirtypesBundle)
    "DomainResource" -> decode.success(FhirtypesDomainresource)
    "Account" -> decode.success(FhirtypesAccount)
    "ActivityDefinition" -> decode.success(FhirtypesActivitydefinition)
    "ActorDefinition" -> decode.success(FhirtypesActordefinition)
    "AdministrableProductDefinition" ->
      decode.success(FhirtypesAdministrableproductdefinition)
    "AdverseEvent" -> decode.success(FhirtypesAdverseevent)
    "AllergyIntolerance" -> decode.success(FhirtypesAllergyintolerance)
    "Appointment" -> decode.success(FhirtypesAppointment)
    "AppointmentResponse" -> decode.success(FhirtypesAppointmentresponse)
    "ArtifactAssessment" -> decode.success(FhirtypesArtifactassessment)
    "AuditEvent" -> decode.success(FhirtypesAuditevent)
    "Basic" -> decode.success(FhirtypesBasic)
    "BiologicallyDerivedProduct" ->
      decode.success(FhirtypesBiologicallyderivedproduct)
    "BiologicallyDerivedProductDispense" ->
      decode.success(FhirtypesBiologicallyderivedproductdispense)
    "BodyStructure" -> decode.success(FhirtypesBodystructure)
    "CanonicalResource" -> decode.success(FhirtypesCanonicalresource)
    "CapabilityStatement" -> decode.success(FhirtypesCapabilitystatement)
    "CarePlan" -> decode.success(FhirtypesCareplan)
    "CareTeam" -> decode.success(FhirtypesCareteam)
    "ChargeItem" -> decode.success(FhirtypesChargeitem)
    "ChargeItemDefinition" -> decode.success(FhirtypesChargeitemdefinition)
    "Citation" -> decode.success(FhirtypesCitation)
    "Claim" -> decode.success(FhirtypesClaim)
    "ClaimResponse" -> decode.success(FhirtypesClaimresponse)
    "ClinicalImpression" -> decode.success(FhirtypesClinicalimpression)
    "ClinicalUseDefinition" -> decode.success(FhirtypesClinicalusedefinition)
    "CodeSystem" -> decode.success(FhirtypesCodesystem)
    "Communication" -> decode.success(FhirtypesCommunication)
    "CommunicationRequest" -> decode.success(FhirtypesCommunicationrequest)
    "CompartmentDefinition" -> decode.success(FhirtypesCompartmentdefinition)
    "Composition" -> decode.success(FhirtypesComposition)
    "ConceptMap" -> decode.success(FhirtypesConceptmap)
    "Condition" -> decode.success(FhirtypesCondition)
    "ConditionDefinition" -> decode.success(FhirtypesConditiondefinition)
    "Consent" -> decode.success(FhirtypesConsent)
    "Contract" -> decode.success(FhirtypesContract)
    "Coverage" -> decode.success(FhirtypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(FhirtypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(FhirtypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(FhirtypesDetectedissue)
    "Device" -> decode.success(FhirtypesDevice)
    "DeviceAssociation" -> decode.success(FhirtypesDeviceassociation)
    "DeviceDefinition" -> decode.success(FhirtypesDevicedefinition)
    "DeviceDispense" -> decode.success(FhirtypesDevicedispense)
    "DeviceMetric" -> decode.success(FhirtypesDevicemetric)
    "DeviceRequest" -> decode.success(FhirtypesDevicerequest)
    "DeviceUsage" -> decode.success(FhirtypesDeviceusage)
    "DiagnosticReport" -> decode.success(FhirtypesDiagnosticreport)
    "DocumentReference" -> decode.success(FhirtypesDocumentreference)
    "Encounter" -> decode.success(FhirtypesEncounter)
    "EncounterHistory" -> decode.success(FhirtypesEncounterhistory)
    "Endpoint" -> decode.success(FhirtypesEndpoint)
    "EnrollmentRequest" -> decode.success(FhirtypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(FhirtypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(FhirtypesEpisodeofcare)
    "EventDefinition" -> decode.success(FhirtypesEventdefinition)
    "Evidence" -> decode.success(FhirtypesEvidence)
    "EvidenceReport" -> decode.success(FhirtypesEvidencereport)
    "EvidenceVariable" -> decode.success(FhirtypesEvidencevariable)
    "ExampleScenario" -> decode.success(FhirtypesExamplescenario)
    "ExplanationOfBenefit" -> decode.success(FhirtypesExplanationofbenefit)
    "FamilyMemberHistory" -> decode.success(FhirtypesFamilymemberhistory)
    "Flag" -> decode.success(FhirtypesFlag)
    "FormularyItem" -> decode.success(FhirtypesFormularyitem)
    "GenomicStudy" -> decode.success(FhirtypesGenomicstudy)
    "Goal" -> decode.success(FhirtypesGoal)
    "GraphDefinition" -> decode.success(FhirtypesGraphdefinition)
    "Group" -> decode.success(FhirtypesGroup)
    "GuidanceResponse" -> decode.success(FhirtypesGuidanceresponse)
    "HealthcareService" -> decode.success(FhirtypesHealthcareservice)
    "ImagingSelection" -> decode.success(FhirtypesImagingselection)
    "ImagingStudy" -> decode.success(FhirtypesImagingstudy)
    "Immunization" -> decode.success(FhirtypesImmunization)
    "ImmunizationEvaluation" -> decode.success(FhirtypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(FhirtypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(FhirtypesImplementationguide)
    "Ingredient" -> decode.success(FhirtypesIngredient)
    "InsurancePlan" -> decode.success(FhirtypesInsuranceplan)
    "InventoryItem" -> decode.success(FhirtypesInventoryitem)
    "InventoryReport" -> decode.success(FhirtypesInventoryreport)
    "Invoice" -> decode.success(FhirtypesInvoice)
    "Library" -> decode.success(FhirtypesLibrary)
    "Linkage" -> decode.success(FhirtypesLinkage)
    "List" -> decode.success(FhirtypesList)
    "Location" -> decode.success(FhirtypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(FhirtypesManufactureditemdefinition)
    "Measure" -> decode.success(FhirtypesMeasure)
    "MeasureReport" -> decode.success(FhirtypesMeasurereport)
    "Medication" -> decode.success(FhirtypesMedication)
    "MedicationAdministration" ->
      decode.success(FhirtypesMedicationadministration)
    "MedicationDispense" -> decode.success(FhirtypesMedicationdispense)
    "MedicationKnowledge" -> decode.success(FhirtypesMedicationknowledge)
    "MedicationRequest" -> decode.success(FhirtypesMedicationrequest)
    "MedicationStatement" -> decode.success(FhirtypesMedicationstatement)
    "MedicinalProductDefinition" ->
      decode.success(FhirtypesMedicinalproductdefinition)
    "MessageDefinition" -> decode.success(FhirtypesMessagedefinition)
    "MessageHeader" -> decode.success(FhirtypesMessageheader)
    "MetadataResource" -> decode.success(FhirtypesMetadataresource)
    "MolecularSequence" -> decode.success(FhirtypesMolecularsequence)
    "NamingSystem" -> decode.success(FhirtypesNamingsystem)
    "NutritionIntake" -> decode.success(FhirtypesNutritionintake)
    "NutritionOrder" -> decode.success(FhirtypesNutritionorder)
    "NutritionProduct" -> decode.success(FhirtypesNutritionproduct)
    "Observation" -> decode.success(FhirtypesObservation)
    "ObservationDefinition" -> decode.success(FhirtypesObservationdefinition)
    "OperationDefinition" -> decode.success(FhirtypesOperationdefinition)
    "OperationOutcome" -> decode.success(FhirtypesOperationoutcome)
    "Organization" -> decode.success(FhirtypesOrganization)
    "OrganizationAffiliation" ->
      decode.success(FhirtypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      decode.success(FhirtypesPackagedproductdefinition)
    "Patient" -> decode.success(FhirtypesPatient)
    "PaymentNotice" -> decode.success(FhirtypesPaymentnotice)
    "PaymentReconciliation" -> decode.success(FhirtypesPaymentreconciliation)
    "Permission" -> decode.success(FhirtypesPermission)
    "Person" -> decode.success(FhirtypesPerson)
    "PlanDefinition" -> decode.success(FhirtypesPlandefinition)
    "Practitioner" -> decode.success(FhirtypesPractitioner)
    "PractitionerRole" -> decode.success(FhirtypesPractitionerrole)
    "Procedure" -> decode.success(FhirtypesProcedure)
    "Provenance" -> decode.success(FhirtypesProvenance)
    "Questionnaire" -> decode.success(FhirtypesQuestionnaire)
    "QuestionnaireResponse" -> decode.success(FhirtypesQuestionnaireresponse)
    "RegulatedAuthorization" -> decode.success(FhirtypesRegulatedauthorization)
    "RelatedPerson" -> decode.success(FhirtypesRelatedperson)
    "RequestOrchestration" -> decode.success(FhirtypesRequestorchestration)
    "Requirements" -> decode.success(FhirtypesRequirements)
    "ResearchStudy" -> decode.success(FhirtypesResearchstudy)
    "ResearchSubject" -> decode.success(FhirtypesResearchsubject)
    "RiskAssessment" -> decode.success(FhirtypesRiskassessment)
    "Schedule" -> decode.success(FhirtypesSchedule)
    "SearchParameter" -> decode.success(FhirtypesSearchparameter)
    "ServiceRequest" -> decode.success(FhirtypesServicerequest)
    "Slot" -> decode.success(FhirtypesSlot)
    "Specimen" -> decode.success(FhirtypesSpecimen)
    "SpecimenDefinition" -> decode.success(FhirtypesSpecimendefinition)
    "StructureDefinition" -> decode.success(FhirtypesStructuredefinition)
    "StructureMap" -> decode.success(FhirtypesStructuremap)
    "Subscription" -> decode.success(FhirtypesSubscription)
    "SubscriptionStatus" -> decode.success(FhirtypesSubscriptionstatus)
    "SubscriptionTopic" -> decode.success(FhirtypesSubscriptiontopic)
    "Substance" -> decode.success(FhirtypesSubstance)
    "SubstanceDefinition" -> decode.success(FhirtypesSubstancedefinition)
    "SubstanceNucleicAcid" -> decode.success(FhirtypesSubstancenucleicacid)
    "SubstancePolymer" -> decode.success(FhirtypesSubstancepolymer)
    "SubstanceProtein" -> decode.success(FhirtypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      decode.success(FhirtypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" ->
      decode.success(FhirtypesSubstancesourcematerial)
    "SupplyDelivery" -> decode.success(FhirtypesSupplydelivery)
    "SupplyRequest" -> decode.success(FhirtypesSupplyrequest)
    "Task" -> decode.success(FhirtypesTask)
    "TerminologyCapabilities" ->
      decode.success(FhirtypesTerminologycapabilities)
    "TestPlan" -> decode.success(FhirtypesTestplan)
    "TestReport" -> decode.success(FhirtypesTestreport)
    "TestScript" -> decode.success(FhirtypesTestscript)
    "Transport" -> decode.success(FhirtypesTransport)
    "ValueSet" -> decode.success(FhirtypesValueset)
    "VerificationResult" -> decode.success(FhirtypesVerificationresult)
    "VisionPrescription" -> decode.success(FhirtypesVisionprescription)
    "Parameters" -> decode.success(FhirtypesParameters)
    _ -> decode.failure(FhirtypesBase, "Fhirtypes")
  }
}

pub type Fhirversion {
  Fhirversion001
  Fhirversion005
  Fhirversion006
  Fhirversion011
  Fhirversion00
  Fhirversion0080
  Fhirversion0081
  Fhirversion0082
  Fhirversion04
  Fhirversion040
  Fhirversion05
  Fhirversion050
  Fhirversion10
  Fhirversion100
  Fhirversion101
  Fhirversion102
  Fhirversion11
  Fhirversion110
  Fhirversion14
  Fhirversion140
  Fhirversion16
  Fhirversion160
  Fhirversion18
  Fhirversion180
  Fhirversion30
  Fhirversion300
  Fhirversion301
  Fhirversion302
  Fhirversion33
  Fhirversion330
  Fhirversion35
  Fhirversion350
  Fhirversion40
  Fhirversion400
  Fhirversion401
  Fhirversion41
  Fhirversion410
  Fhirversion42
  Fhirversion420
  Fhirversion43
  Fhirversion430
  Fhirversion430cibuild
  Fhirversion430snapshot1
  Fhirversion44
  Fhirversion440
  Fhirversion45
  Fhirversion450
  Fhirversion46
  Fhirversion460
  Fhirversion50
  Fhirversion500
  Fhirversion500cibuild
  Fhirversion500snapshot1
  Fhirversion500snapshot2
  Fhirversion500ballot
  Fhirversion500snapshot3
  Fhirversion500draftfinal
}

pub fn fhirversion_to_json(fhirversion: Fhirversion) -> Json {
  json.string(fhirversion_to_string(fhirversion))
}

pub fn fhirversion_to_string(fhirversion: Fhirversion) -> String {
  case fhirversion {
    Fhirversion001 -> "0.01"
    Fhirversion005 -> "0.05"
    Fhirversion006 -> "0.06"
    Fhirversion011 -> "0.11"
    Fhirversion00 -> "0.0"
    Fhirversion0080 -> "0.0.80"
    Fhirversion0081 -> "0.0.81"
    Fhirversion0082 -> "0.0.82"
    Fhirversion04 -> "0.4"
    Fhirversion040 -> "0.4.0"
    Fhirversion05 -> "0.5"
    Fhirversion050 -> "0.5.0"
    Fhirversion10 -> "1.0"
    Fhirversion100 -> "1.0.0"
    Fhirversion101 -> "1.0.1"
    Fhirversion102 -> "1.0.2"
    Fhirversion11 -> "1.1"
    Fhirversion110 -> "1.1.0"
    Fhirversion14 -> "1.4"
    Fhirversion140 -> "1.4.0"
    Fhirversion16 -> "1.6"
    Fhirversion160 -> "1.6.0"
    Fhirversion18 -> "1.8"
    Fhirversion180 -> "1.8.0"
    Fhirversion30 -> "3.0"
    Fhirversion300 -> "3.0.0"
    Fhirversion301 -> "3.0.1"
    Fhirversion302 -> "3.0.2"
    Fhirversion33 -> "3.3"
    Fhirversion330 -> "3.3.0"
    Fhirversion35 -> "3.5"
    Fhirversion350 -> "3.5.0"
    Fhirversion40 -> "4.0"
    Fhirversion400 -> "4.0.0"
    Fhirversion401 -> "4.0.1"
    Fhirversion41 -> "4.1"
    Fhirversion410 -> "4.1.0"
    Fhirversion42 -> "4.2"
    Fhirversion420 -> "4.2.0"
    Fhirversion43 -> "4.3"
    Fhirversion430 -> "4.3.0"
    Fhirversion430cibuild -> "4.3.0-cibuild"
    Fhirversion430snapshot1 -> "4.3.0-snapshot1"
    Fhirversion44 -> "4.4"
    Fhirversion440 -> "4.4.0"
    Fhirversion45 -> "4.5"
    Fhirversion450 -> "4.5.0"
    Fhirversion46 -> "4.6"
    Fhirversion460 -> "4.6.0"
    Fhirversion50 -> "5.0"
    Fhirversion500 -> "5.0.0"
    Fhirversion500cibuild -> "5.0.0-cibuild"
    Fhirversion500snapshot1 -> "5.0.0-snapshot1"
    Fhirversion500snapshot2 -> "5.0.0-snapshot2"
    Fhirversion500ballot -> "5.0.0-ballot"
    Fhirversion500snapshot3 -> "5.0.0-snapshot3"
    Fhirversion500draftfinal -> "5.0.0-draft-final"
  }
}

pub fn fhirversion_from_string(s: String) -> Result(Fhirversion, Nil) {
  case s {
    "0.01" -> Ok(Fhirversion001)
    "0.05" -> Ok(Fhirversion005)
    "0.06" -> Ok(Fhirversion006)
    "0.11" -> Ok(Fhirversion011)
    "0.0" -> Ok(Fhirversion00)
    "0.0.80" -> Ok(Fhirversion0080)
    "0.0.81" -> Ok(Fhirversion0081)
    "0.0.82" -> Ok(Fhirversion0082)
    "0.4" -> Ok(Fhirversion04)
    "0.4.0" -> Ok(Fhirversion040)
    "0.5" -> Ok(Fhirversion05)
    "0.5.0" -> Ok(Fhirversion050)
    "1.0" -> Ok(Fhirversion10)
    "1.0.0" -> Ok(Fhirversion100)
    "1.0.1" -> Ok(Fhirversion101)
    "1.0.2" -> Ok(Fhirversion102)
    "1.1" -> Ok(Fhirversion11)
    "1.1.0" -> Ok(Fhirversion110)
    "1.4" -> Ok(Fhirversion14)
    "1.4.0" -> Ok(Fhirversion140)
    "1.6" -> Ok(Fhirversion16)
    "1.6.0" -> Ok(Fhirversion160)
    "1.8" -> Ok(Fhirversion18)
    "1.8.0" -> Ok(Fhirversion180)
    "3.0" -> Ok(Fhirversion30)
    "3.0.0" -> Ok(Fhirversion300)
    "3.0.1" -> Ok(Fhirversion301)
    "3.0.2" -> Ok(Fhirversion302)
    "3.3" -> Ok(Fhirversion33)
    "3.3.0" -> Ok(Fhirversion330)
    "3.5" -> Ok(Fhirversion35)
    "3.5.0" -> Ok(Fhirversion350)
    "4.0" -> Ok(Fhirversion40)
    "4.0.0" -> Ok(Fhirversion400)
    "4.0.1" -> Ok(Fhirversion401)
    "4.1" -> Ok(Fhirversion41)
    "4.1.0" -> Ok(Fhirversion410)
    "4.2" -> Ok(Fhirversion42)
    "4.2.0" -> Ok(Fhirversion420)
    "4.3" -> Ok(Fhirversion43)
    "4.3.0" -> Ok(Fhirversion430)
    "4.3.0-cibuild" -> Ok(Fhirversion430cibuild)
    "4.3.0-snapshot1" -> Ok(Fhirversion430snapshot1)
    "4.4" -> Ok(Fhirversion44)
    "4.4.0" -> Ok(Fhirversion440)
    "4.5" -> Ok(Fhirversion45)
    "4.5.0" -> Ok(Fhirversion450)
    "4.6" -> Ok(Fhirversion46)
    "4.6.0" -> Ok(Fhirversion460)
    "5.0" -> Ok(Fhirversion50)
    "5.0.0" -> Ok(Fhirversion500)
    "5.0.0-cibuild" -> Ok(Fhirversion500cibuild)
    "5.0.0-snapshot1" -> Ok(Fhirversion500snapshot1)
    "5.0.0-snapshot2" -> Ok(Fhirversion500snapshot2)
    "5.0.0-ballot" -> Ok(Fhirversion500ballot)
    "5.0.0-snapshot3" -> Ok(Fhirversion500snapshot3)
    "5.0.0-draft-final" -> Ok(Fhirversion500draftfinal)
    _ -> Error(Nil)
  }
}

pub fn fhirversion_decoder() -> Decoder(Fhirversion) {
  use variant <- decode.then(decode.string)
  case variant {
    "0.01" -> decode.success(Fhirversion001)
    "0.05" -> decode.success(Fhirversion005)
    "0.06" -> decode.success(Fhirversion006)
    "0.11" -> decode.success(Fhirversion011)
    "0.0" -> decode.success(Fhirversion00)
    "0.0.80" -> decode.success(Fhirversion0080)
    "0.0.81" -> decode.success(Fhirversion0081)
    "0.0.82" -> decode.success(Fhirversion0082)
    "0.4" -> decode.success(Fhirversion04)
    "0.4.0" -> decode.success(Fhirversion040)
    "0.5" -> decode.success(Fhirversion05)
    "0.5.0" -> decode.success(Fhirversion050)
    "1.0" -> decode.success(Fhirversion10)
    "1.0.0" -> decode.success(Fhirversion100)
    "1.0.1" -> decode.success(Fhirversion101)
    "1.0.2" -> decode.success(Fhirversion102)
    "1.1" -> decode.success(Fhirversion11)
    "1.1.0" -> decode.success(Fhirversion110)
    "1.4" -> decode.success(Fhirversion14)
    "1.4.0" -> decode.success(Fhirversion140)
    "1.6" -> decode.success(Fhirversion16)
    "1.6.0" -> decode.success(Fhirversion160)
    "1.8" -> decode.success(Fhirversion18)
    "1.8.0" -> decode.success(Fhirversion180)
    "3.0" -> decode.success(Fhirversion30)
    "3.0.0" -> decode.success(Fhirversion300)
    "3.0.1" -> decode.success(Fhirversion301)
    "3.0.2" -> decode.success(Fhirversion302)
    "3.3" -> decode.success(Fhirversion33)
    "3.3.0" -> decode.success(Fhirversion330)
    "3.5" -> decode.success(Fhirversion35)
    "3.5.0" -> decode.success(Fhirversion350)
    "4.0" -> decode.success(Fhirversion40)
    "4.0.0" -> decode.success(Fhirversion400)
    "4.0.1" -> decode.success(Fhirversion401)
    "4.1" -> decode.success(Fhirversion41)
    "4.1.0" -> decode.success(Fhirversion410)
    "4.2" -> decode.success(Fhirversion42)
    "4.2.0" -> decode.success(Fhirversion420)
    "4.3" -> decode.success(Fhirversion43)
    "4.3.0" -> decode.success(Fhirversion430)
    "4.3.0-cibuild" -> decode.success(Fhirversion430cibuild)
    "4.3.0-snapshot1" -> decode.success(Fhirversion430snapshot1)
    "4.4" -> decode.success(Fhirversion44)
    "4.4.0" -> decode.success(Fhirversion440)
    "4.5" -> decode.success(Fhirversion45)
    "4.5.0" -> decode.success(Fhirversion450)
    "4.6" -> decode.success(Fhirversion46)
    "4.6.0" -> decode.success(Fhirversion460)
    "5.0" -> decode.success(Fhirversion50)
    "5.0.0" -> decode.success(Fhirversion500)
    "5.0.0-cibuild" -> decode.success(Fhirversion500cibuild)
    "5.0.0-snapshot1" -> decode.success(Fhirversion500snapshot1)
    "5.0.0-snapshot2" -> decode.success(Fhirversion500snapshot2)
    "5.0.0-ballot" -> decode.success(Fhirversion500ballot)
    "5.0.0-snapshot3" -> decode.success(Fhirversion500snapshot3)
    "5.0.0-draft-final" -> decode.success(Fhirversion500draftfinal)
    _ -> decode.failure(Fhirversion001, "Fhirversion")
  }
}

pub type Filteroperator {
  FilteroperatorEqual
  FilteroperatorIsa
  FilteroperatorDescendentof
  FilteroperatorIsnota
  FilteroperatorRegex
  FilteroperatorIn
  FilteroperatorNotin
  FilteroperatorGeneralizes
  FilteroperatorChildof
  FilteroperatorDescendentleaf
  FilteroperatorExists
}

pub fn filteroperator_to_json(filteroperator: Filteroperator) -> Json {
  json.string(filteroperator_to_string(filteroperator))
}

pub fn filteroperator_to_string(filteroperator: Filteroperator) -> String {
  case filteroperator {
    FilteroperatorEqual -> "="
    FilteroperatorIsa -> "is-a"
    FilteroperatorDescendentof -> "descendent-of"
    FilteroperatorIsnota -> "is-not-a"
    FilteroperatorRegex -> "regex"
    FilteroperatorIn -> "in"
    FilteroperatorNotin -> "not-in"
    FilteroperatorGeneralizes -> "generalizes"
    FilteroperatorChildof -> "child-of"
    FilteroperatorDescendentleaf -> "descendent-leaf"
    FilteroperatorExists -> "exists"
  }
}

pub fn filteroperator_from_string(s: String) -> Result(Filteroperator, Nil) {
  case s {
    "=" -> Ok(FilteroperatorEqual)
    "is-a" -> Ok(FilteroperatorIsa)
    "descendent-of" -> Ok(FilteroperatorDescendentof)
    "is-not-a" -> Ok(FilteroperatorIsnota)
    "regex" -> Ok(FilteroperatorRegex)
    "in" -> Ok(FilteroperatorIn)
    "not-in" -> Ok(FilteroperatorNotin)
    "generalizes" -> Ok(FilteroperatorGeneralizes)
    "child-of" -> Ok(FilteroperatorChildof)
    "descendent-leaf" -> Ok(FilteroperatorDescendentleaf)
    "exists" -> Ok(FilteroperatorExists)
    _ -> Error(Nil)
  }
}

pub fn filteroperator_decoder() -> Decoder(Filteroperator) {
  use variant <- decode.then(decode.string)
  case variant {
    "=" -> decode.success(FilteroperatorEqual)
    "is-a" -> decode.success(FilteroperatorIsa)
    "descendent-of" -> decode.success(FilteroperatorDescendentof)
    "is-not-a" -> decode.success(FilteroperatorIsnota)
    "regex" -> decode.success(FilteroperatorRegex)
    "in" -> decode.success(FilteroperatorIn)
    "not-in" -> decode.success(FilteroperatorNotin)
    "generalizes" -> decode.success(FilteroperatorGeneralizes)
    "child-of" -> decode.success(FilteroperatorChildof)
    "descendent-leaf" -> decode.success(FilteroperatorDescendentleaf)
    "exists" -> decode.success(FilteroperatorExists)
    _ -> decode.failure(FilteroperatorEqual, "Filteroperator")
  }
}

pub type Flagstatus {
  FlagstatusActive
  FlagstatusInactive
  FlagstatusEnteredinerror
}

pub fn flagstatus_to_json(flagstatus: Flagstatus) -> Json {
  json.string(flagstatus_to_string(flagstatus))
}

pub fn flagstatus_to_string(flagstatus: Flagstatus) -> String {
  case flagstatus {
    FlagstatusActive -> "active"
    FlagstatusInactive -> "inactive"
    FlagstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn flagstatus_from_string(s: String) -> Result(Flagstatus, Nil) {
  case s {
    "active" -> Ok(FlagstatusActive)
    "inactive" -> Ok(FlagstatusInactive)
    "entered-in-error" -> Ok(FlagstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn flagstatus_decoder() -> Decoder(Flagstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(FlagstatusActive)
    "inactive" -> decode.success(FlagstatusInactive)
    "entered-in-error" -> decode.success(FlagstatusEnteredinerror)
    _ -> decode.failure(FlagstatusActive, "Flagstatus")
  }
}

pub type Fmstatus {
  FmstatusActive
  FmstatusCancelled
  FmstatusDraft
  FmstatusEnteredinerror
}

pub fn fmstatus_to_json(fmstatus: Fmstatus) -> Json {
  json.string(fmstatus_to_string(fmstatus))
}

pub fn fmstatus_to_string(fmstatus: Fmstatus) -> String {
  case fmstatus {
    FmstatusActive -> "active"
    FmstatusCancelled -> "cancelled"
    FmstatusDraft -> "draft"
    FmstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn fmstatus_from_string(s: String) -> Result(Fmstatus, Nil) {
  case s {
    "active" -> Ok(FmstatusActive)
    "cancelled" -> Ok(FmstatusCancelled)
    "draft" -> Ok(FmstatusDraft)
    "entered-in-error" -> Ok(FmstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn fmstatus_decoder() -> Decoder(Fmstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(FmstatusActive)
    "cancelled" -> decode.success(FmstatusCancelled)
    "draft" -> decode.success(FmstatusDraft)
    "entered-in-error" -> decode.success(FmstatusEnteredinerror)
    _ -> decode.failure(FmstatusActive, "Fmstatus")
  }
}

pub type Formularyitemstatus {
  FormularyitemstatusActive
  FormularyitemstatusEnteredinerror
  FormularyitemstatusInactive
}

pub fn formularyitemstatus_to_json(
  formularyitemstatus: Formularyitemstatus,
) -> Json {
  json.string(formularyitemstatus_to_string(formularyitemstatus))
}

pub fn formularyitemstatus_to_string(
  formularyitemstatus: Formularyitemstatus,
) -> String {
  case formularyitemstatus {
    FormularyitemstatusActive -> "active"
    FormularyitemstatusEnteredinerror -> "entered-in-error"
    FormularyitemstatusInactive -> "inactive"
  }
}

pub fn formularyitemstatus_from_string(
  s: String,
) -> Result(Formularyitemstatus, Nil) {
  case s {
    "active" -> Ok(FormularyitemstatusActive)
    "entered-in-error" -> Ok(FormularyitemstatusEnteredinerror)
    "inactive" -> Ok(FormularyitemstatusInactive)
    _ -> Error(Nil)
  }
}

pub fn formularyitemstatus_decoder() -> Decoder(Formularyitemstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(FormularyitemstatusActive)
    "entered-in-error" -> decode.success(FormularyitemstatusEnteredinerror)
    "inactive" -> decode.success(FormularyitemstatusInactive)
    _ -> decode.failure(FormularyitemstatusActive, "Formularyitemstatus")
  }
}

pub type Genomicstudystatus {
  GenomicstudystatusRegistered
  GenomicstudystatusAvailable
  GenomicstudystatusCancelled
  GenomicstudystatusEnteredinerror
  GenomicstudystatusUnknown
}

pub fn genomicstudystatus_to_json(
  genomicstudystatus: Genomicstudystatus,
) -> Json {
  json.string(genomicstudystatus_to_string(genomicstudystatus))
}

pub fn genomicstudystatus_to_string(
  genomicstudystatus: Genomicstudystatus,
) -> String {
  case genomicstudystatus {
    GenomicstudystatusRegistered -> "registered"
    GenomicstudystatusAvailable -> "available"
    GenomicstudystatusCancelled -> "cancelled"
    GenomicstudystatusEnteredinerror -> "entered-in-error"
    GenomicstudystatusUnknown -> "unknown"
  }
}

pub fn genomicstudystatus_from_string(
  s: String,
) -> Result(Genomicstudystatus, Nil) {
  case s {
    "registered" -> Ok(GenomicstudystatusRegistered)
    "available" -> Ok(GenomicstudystatusAvailable)
    "cancelled" -> Ok(GenomicstudystatusCancelled)
    "entered-in-error" -> Ok(GenomicstudystatusEnteredinerror)
    "unknown" -> Ok(GenomicstudystatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn genomicstudystatus_decoder() -> Decoder(Genomicstudystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered" -> decode.success(GenomicstudystatusRegistered)
    "available" -> decode.success(GenomicstudystatusAvailable)
    "cancelled" -> decode.success(GenomicstudystatusCancelled)
    "entered-in-error" -> decode.success(GenomicstudystatusEnteredinerror)
    "unknown" -> decode.success(GenomicstudystatusUnknown)
    _ -> decode.failure(GenomicstudystatusRegistered, "Genomicstudystatus")
  }
}

pub type Goalstatus {
  GoalstatusProposed
  GoalstatusPlanned
  GoalstatusAccepted
  GoalstatusActive
  GoalstatusOnhold
  GoalstatusCompleted
  GoalstatusCancelled
  GoalstatusEnteredinerror
  GoalstatusRejected
}

pub fn goalstatus_to_json(goalstatus: Goalstatus) -> Json {
  json.string(goalstatus_to_string(goalstatus))
}

pub fn goalstatus_to_string(goalstatus: Goalstatus) -> String {
  case goalstatus {
    GoalstatusProposed -> "proposed"
    GoalstatusPlanned -> "planned"
    GoalstatusAccepted -> "accepted"
    GoalstatusActive -> "active"
    GoalstatusOnhold -> "on-hold"
    GoalstatusCompleted -> "completed"
    GoalstatusCancelled -> "cancelled"
    GoalstatusEnteredinerror -> "entered-in-error"
    GoalstatusRejected -> "rejected"
  }
}

pub fn goalstatus_from_string(s: String) -> Result(Goalstatus, Nil) {
  case s {
    "proposed" -> Ok(GoalstatusProposed)
    "planned" -> Ok(GoalstatusPlanned)
    "accepted" -> Ok(GoalstatusAccepted)
    "active" -> Ok(GoalstatusActive)
    "on-hold" -> Ok(GoalstatusOnhold)
    "completed" -> Ok(GoalstatusCompleted)
    "cancelled" -> Ok(GoalstatusCancelled)
    "entered-in-error" -> Ok(GoalstatusEnteredinerror)
    "rejected" -> Ok(GoalstatusRejected)
    _ -> Error(Nil)
  }
}

pub fn goalstatus_decoder() -> Decoder(Goalstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposed" -> decode.success(GoalstatusProposed)
    "planned" -> decode.success(GoalstatusPlanned)
    "accepted" -> decode.success(GoalstatusAccepted)
    "active" -> decode.success(GoalstatusActive)
    "on-hold" -> decode.success(GoalstatusOnhold)
    "completed" -> decode.success(GoalstatusCompleted)
    "cancelled" -> decode.success(GoalstatusCancelled)
    "entered-in-error" -> decode.success(GoalstatusEnteredinerror)
    "rejected" -> decode.success(GoalstatusRejected)
    _ -> decode.failure(GoalstatusProposed, "Goalstatus")
  }
}

pub type Graphcompartmentrule {
  GraphcompartmentruleIdentical
  GraphcompartmentruleMatching
  GraphcompartmentruleDifferent
  GraphcompartmentruleCustom
}

pub fn graphcompartmentrule_to_json(
  graphcompartmentrule: Graphcompartmentrule,
) -> Json {
  json.string(graphcompartmentrule_to_string(graphcompartmentrule))
}

pub fn graphcompartmentrule_to_string(
  graphcompartmentrule: Graphcompartmentrule,
) -> String {
  case graphcompartmentrule {
    GraphcompartmentruleIdentical -> "identical"
    GraphcompartmentruleMatching -> "matching"
    GraphcompartmentruleDifferent -> "different"
    GraphcompartmentruleCustom -> "custom"
  }
}

pub fn graphcompartmentrule_from_string(
  s: String,
) -> Result(Graphcompartmentrule, Nil) {
  case s {
    "identical" -> Ok(GraphcompartmentruleIdentical)
    "matching" -> Ok(GraphcompartmentruleMatching)
    "different" -> Ok(GraphcompartmentruleDifferent)
    "custom" -> Ok(GraphcompartmentruleCustom)
    _ -> Error(Nil)
  }
}

pub fn graphcompartmentrule_decoder() -> Decoder(Graphcompartmentrule) {
  use variant <- decode.then(decode.string)
  case variant {
    "identical" -> decode.success(GraphcompartmentruleIdentical)
    "matching" -> decode.success(GraphcompartmentruleMatching)
    "different" -> decode.success(GraphcompartmentruleDifferent)
    "custom" -> decode.success(GraphcompartmentruleCustom)
    _ -> decode.failure(GraphcompartmentruleIdentical, "Graphcompartmentrule")
  }
}

pub type Graphcompartmentuse {
  GraphcompartmentuseWhere
  GraphcompartmentuseRequires
}

pub fn graphcompartmentuse_to_json(
  graphcompartmentuse: Graphcompartmentuse,
) -> Json {
  json.string(graphcompartmentuse_to_string(graphcompartmentuse))
}

pub fn graphcompartmentuse_to_string(
  graphcompartmentuse: Graphcompartmentuse,
) -> String {
  case graphcompartmentuse {
    GraphcompartmentuseWhere -> "where"
    GraphcompartmentuseRequires -> "requires"
  }
}

pub fn graphcompartmentuse_from_string(
  s: String,
) -> Result(Graphcompartmentuse, Nil) {
  case s {
    "where" -> Ok(GraphcompartmentuseWhere)
    "requires" -> Ok(GraphcompartmentuseRequires)
    _ -> Error(Nil)
  }
}

pub fn graphcompartmentuse_decoder() -> Decoder(Graphcompartmentuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "where" -> decode.success(GraphcompartmentuseWhere)
    "requires" -> decode.success(GraphcompartmentuseRequires)
    _ -> decode.failure(GraphcompartmentuseWhere, "Graphcompartmentuse")
  }
}

pub type Groupmembershipbasis {
  GroupmembershipbasisDefinitional
  GroupmembershipbasisEnumerated
}

pub fn groupmembershipbasis_to_json(
  groupmembershipbasis: Groupmembershipbasis,
) -> Json {
  json.string(groupmembershipbasis_to_string(groupmembershipbasis))
}

pub fn groupmembershipbasis_to_string(
  groupmembershipbasis: Groupmembershipbasis,
) -> String {
  case groupmembershipbasis {
    GroupmembershipbasisDefinitional -> "definitional"
    GroupmembershipbasisEnumerated -> "enumerated"
  }
}

pub fn groupmembershipbasis_from_string(
  s: String,
) -> Result(Groupmembershipbasis, Nil) {
  case s {
    "definitional" -> Ok(GroupmembershipbasisDefinitional)
    "enumerated" -> Ok(GroupmembershipbasisEnumerated)
    _ -> Error(Nil)
  }
}

pub fn groupmembershipbasis_decoder() -> Decoder(Groupmembershipbasis) {
  use variant <- decode.then(decode.string)
  case variant {
    "definitional" -> decode.success(GroupmembershipbasisDefinitional)
    "enumerated" -> decode.success(GroupmembershipbasisEnumerated)
    _ ->
      decode.failure(GroupmembershipbasisDefinitional, "Groupmembershipbasis")
  }
}

pub type Grouptype {
  GrouptypePerson
  GrouptypeAnimal
  GrouptypePractitioner
  GrouptypeDevice
  GrouptypeCareteam
  GrouptypeHealthcareservice
  GrouptypeLocation
  GrouptypeOrganization
  GrouptypeRelatedperson
  GrouptypeSpecimen
}

pub fn grouptype_to_json(grouptype: Grouptype) -> Json {
  json.string(grouptype_to_string(grouptype))
}

pub fn grouptype_to_string(grouptype: Grouptype) -> String {
  case grouptype {
    GrouptypePerson -> "person"
    GrouptypeAnimal -> "animal"
    GrouptypePractitioner -> "practitioner"
    GrouptypeDevice -> "device"
    GrouptypeCareteam -> "careteam"
    GrouptypeHealthcareservice -> "healthcareservice"
    GrouptypeLocation -> "location"
    GrouptypeOrganization -> "organization"
    GrouptypeRelatedperson -> "relatedperson"
    GrouptypeSpecimen -> "specimen"
  }
}

pub fn grouptype_from_string(s: String) -> Result(Grouptype, Nil) {
  case s {
    "person" -> Ok(GrouptypePerson)
    "animal" -> Ok(GrouptypeAnimal)
    "practitioner" -> Ok(GrouptypePractitioner)
    "device" -> Ok(GrouptypeDevice)
    "careteam" -> Ok(GrouptypeCareteam)
    "healthcareservice" -> Ok(GrouptypeHealthcareservice)
    "location" -> Ok(GrouptypeLocation)
    "organization" -> Ok(GrouptypeOrganization)
    "relatedperson" -> Ok(GrouptypeRelatedperson)
    "specimen" -> Ok(GrouptypeSpecimen)
    _ -> Error(Nil)
  }
}

pub fn grouptype_decoder() -> Decoder(Grouptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "person" -> decode.success(GrouptypePerson)
    "animal" -> decode.success(GrouptypeAnimal)
    "practitioner" -> decode.success(GrouptypePractitioner)
    "device" -> decode.success(GrouptypeDevice)
    "careteam" -> decode.success(GrouptypeCareteam)
    "healthcareservice" -> decode.success(GrouptypeHealthcareservice)
    "location" -> decode.success(GrouptypeLocation)
    "organization" -> decode.success(GrouptypeOrganization)
    "relatedperson" -> decode.success(GrouptypeRelatedperson)
    "specimen" -> decode.success(GrouptypeSpecimen)
    _ -> decode.failure(GrouptypePerson, "Grouptype")
  }
}

pub type Guidanceresponsestatus {
  GuidanceresponsestatusSuccess
  GuidanceresponsestatusDatarequested
  GuidanceresponsestatusDatarequired
  GuidanceresponsestatusInprogress
  GuidanceresponsestatusFailure
  GuidanceresponsestatusEnteredinerror
}

pub fn guidanceresponsestatus_to_json(
  guidanceresponsestatus: Guidanceresponsestatus,
) -> Json {
  json.string(guidanceresponsestatus_to_string(guidanceresponsestatus))
}

pub fn guidanceresponsestatus_to_string(
  guidanceresponsestatus: Guidanceresponsestatus,
) -> String {
  case guidanceresponsestatus {
    GuidanceresponsestatusSuccess -> "success"
    GuidanceresponsestatusDatarequested -> "data-requested"
    GuidanceresponsestatusDatarequired -> "data-required"
    GuidanceresponsestatusInprogress -> "in-progress"
    GuidanceresponsestatusFailure -> "failure"
    GuidanceresponsestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn guidanceresponsestatus_from_string(
  s: String,
) -> Result(Guidanceresponsestatus, Nil) {
  case s {
    "success" -> Ok(GuidanceresponsestatusSuccess)
    "data-requested" -> Ok(GuidanceresponsestatusDatarequested)
    "data-required" -> Ok(GuidanceresponsestatusDatarequired)
    "in-progress" -> Ok(GuidanceresponsestatusInprogress)
    "failure" -> Ok(GuidanceresponsestatusFailure)
    "entered-in-error" -> Ok(GuidanceresponsestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn guidanceresponsestatus_decoder() -> Decoder(Guidanceresponsestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "success" -> decode.success(GuidanceresponsestatusSuccess)
    "data-requested" -> decode.success(GuidanceresponsestatusDatarequested)
    "data-required" -> decode.success(GuidanceresponsestatusDatarequired)
    "in-progress" -> decode.success(GuidanceresponsestatusInprogress)
    "failure" -> decode.success(GuidanceresponsestatusFailure)
    "entered-in-error" -> decode.success(GuidanceresponsestatusEnteredinerror)
    _ -> decode.failure(GuidanceresponsestatusSuccess, "Guidanceresponsestatus")
  }
}

pub type Guidepagegeneration {
  GuidepagegenerationHtml
  GuidepagegenerationMarkdown
  GuidepagegenerationXml
  GuidepagegenerationGenerated
}

pub fn guidepagegeneration_to_json(
  guidepagegeneration: Guidepagegeneration,
) -> Json {
  json.string(guidepagegeneration_to_string(guidepagegeneration))
}

pub fn guidepagegeneration_to_string(
  guidepagegeneration: Guidepagegeneration,
) -> String {
  case guidepagegeneration {
    GuidepagegenerationHtml -> "html"
    GuidepagegenerationMarkdown -> "markdown"
    GuidepagegenerationXml -> "xml"
    GuidepagegenerationGenerated -> "generated"
  }
}

pub fn guidepagegeneration_from_string(
  s: String,
) -> Result(Guidepagegeneration, Nil) {
  case s {
    "html" -> Ok(GuidepagegenerationHtml)
    "markdown" -> Ok(GuidepagegenerationMarkdown)
    "xml" -> Ok(GuidepagegenerationXml)
    "generated" -> Ok(GuidepagegenerationGenerated)
    _ -> Error(Nil)
  }
}

pub fn guidepagegeneration_decoder() -> Decoder(Guidepagegeneration) {
  use variant <- decode.then(decode.string)
  case variant {
    "html" -> decode.success(GuidepagegenerationHtml)
    "markdown" -> decode.success(GuidepagegenerationMarkdown)
    "xml" -> decode.success(GuidepagegenerationXml)
    "generated" -> decode.success(GuidepagegenerationGenerated)
    _ -> decode.failure(GuidepagegenerationHtml, "Guidepagegeneration")
  }
}

pub type Historystatus {
  HistorystatusPartial
  HistorystatusCompleted
  HistorystatusEnteredinerror
  HistorystatusHealthunknown
}

pub fn historystatus_to_json(historystatus: Historystatus) -> Json {
  json.string(historystatus_to_string(historystatus))
}

pub fn historystatus_to_string(historystatus: Historystatus) -> String {
  case historystatus {
    HistorystatusPartial -> "partial"
    HistorystatusCompleted -> "completed"
    HistorystatusEnteredinerror -> "entered-in-error"
    HistorystatusHealthunknown -> "health-unknown"
  }
}

pub fn historystatus_from_string(s: String) -> Result(Historystatus, Nil) {
  case s {
    "partial" -> Ok(HistorystatusPartial)
    "completed" -> Ok(HistorystatusCompleted)
    "entered-in-error" -> Ok(HistorystatusEnteredinerror)
    "health-unknown" -> Ok(HistorystatusHealthunknown)
    _ -> Error(Nil)
  }
}

pub fn historystatus_decoder() -> Decoder(Historystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "partial" -> decode.success(HistorystatusPartial)
    "completed" -> decode.success(HistorystatusCompleted)
    "entered-in-error" -> decode.success(HistorystatusEnteredinerror)
    "health-unknown" -> decode.success(HistorystatusHealthunknown)
    _ -> decode.failure(HistorystatusPartial, "Historystatus")
  }
}

pub type Httpoperations {
  HttpoperationsDelete
  HttpoperationsGet
  HttpoperationsOptions
  HttpoperationsPatch
  HttpoperationsPost
  HttpoperationsPut
  HttpoperationsHead
}

pub fn httpoperations_to_json(httpoperations: Httpoperations) -> Json {
  json.string(httpoperations_to_string(httpoperations))
}

pub fn httpoperations_to_string(httpoperations: Httpoperations) -> String {
  case httpoperations {
    HttpoperationsDelete -> "delete"
    HttpoperationsGet -> "get"
    HttpoperationsOptions -> "options"
    HttpoperationsPatch -> "patch"
    HttpoperationsPost -> "post"
    HttpoperationsPut -> "put"
    HttpoperationsHead -> "head"
  }
}

pub fn httpoperations_from_string(s: String) -> Result(Httpoperations, Nil) {
  case s {
    "delete" -> Ok(HttpoperationsDelete)
    "get" -> Ok(HttpoperationsGet)
    "options" -> Ok(HttpoperationsOptions)
    "patch" -> Ok(HttpoperationsPatch)
    "post" -> Ok(HttpoperationsPost)
    "put" -> Ok(HttpoperationsPut)
    "head" -> Ok(HttpoperationsHead)
    _ -> Error(Nil)
  }
}

pub fn httpoperations_decoder() -> Decoder(Httpoperations) {
  use variant <- decode.then(decode.string)
  case variant {
    "delete" -> decode.success(HttpoperationsDelete)
    "get" -> decode.success(HttpoperationsGet)
    "options" -> decode.success(HttpoperationsOptions)
    "patch" -> decode.success(HttpoperationsPatch)
    "post" -> decode.success(HttpoperationsPost)
    "put" -> decode.success(HttpoperationsPut)
    "head" -> decode.success(HttpoperationsHead)
    _ -> decode.failure(HttpoperationsDelete, "Httpoperations")
  }
}

pub type Httpverb {
  HttpverbGet
  HttpverbHead
  HttpverbPost
  HttpverbPut
  HttpverbDelete
  HttpverbPatch
}

pub fn httpverb_to_json(httpverb: Httpverb) -> Json {
  json.string(httpverb_to_string(httpverb))
}

pub fn httpverb_to_string(httpverb: Httpverb) -> String {
  case httpverb {
    HttpverbGet -> "GET"
    HttpverbHead -> "HEAD"
    HttpverbPost -> "POST"
    HttpverbPut -> "PUT"
    HttpverbDelete -> "DELETE"
    HttpverbPatch -> "PATCH"
  }
}

pub fn httpverb_from_string(s: String) -> Result(Httpverb, Nil) {
  case s {
    "GET" -> Ok(HttpverbGet)
    "HEAD" -> Ok(HttpverbHead)
    "POST" -> Ok(HttpverbPost)
    "PUT" -> Ok(HttpverbPut)
    "DELETE" -> Ok(HttpverbDelete)
    "PATCH" -> Ok(HttpverbPatch)
    _ -> Error(Nil)
  }
}

pub fn httpverb_decoder() -> Decoder(Httpverb) {
  use variant <- decode.then(decode.string)
  case variant {
    "GET" -> decode.success(HttpverbGet)
    "HEAD" -> decode.success(HttpverbHead)
    "POST" -> decode.success(HttpverbPost)
    "PUT" -> decode.success(HttpverbPut)
    "DELETE" -> decode.success(HttpverbDelete)
    "PATCH" -> decode.success(HttpverbPatch)
    _ -> decode.failure(HttpverbGet, "Httpverb")
  }
}

pub type Ianalinkrelations {
  IanalinkrelationsAbout
  IanalinkrelationsAcl
  IanalinkrelationsAlternate
  IanalinkrelationsAmphtml
  IanalinkrelationsAppendix
  IanalinkrelationsAppletouchicon
  IanalinkrelationsAppletouchstartupimage
  IanalinkrelationsArchives
  IanalinkrelationsAuthor
  IanalinkrelationsBlockedby
  IanalinkrelationsBookmark
  IanalinkrelationsCanonical
  IanalinkrelationsChapter
  IanalinkrelationsCiteas
  IanalinkrelationsCollection
  IanalinkrelationsContents
  IanalinkrelationsConvertedfrom
  IanalinkrelationsCopyright
  IanalinkrelationsCreateform
  IanalinkrelationsCurrent
  IanalinkrelationsDescribedby
  IanalinkrelationsDescribes
  IanalinkrelationsDisclosure
  IanalinkrelationsDnsprefetch
  IanalinkrelationsDuplicate
  IanalinkrelationsEdit
  IanalinkrelationsEditform
  IanalinkrelationsEditmedia
  IanalinkrelationsEnclosure
  IanalinkrelationsExternal
  IanalinkrelationsFirst
  IanalinkrelationsGlossary
  IanalinkrelationsHelp
  IanalinkrelationsHosts
  IanalinkrelationsHub
  IanalinkrelationsIcon
  IanalinkrelationsIndex
  IanalinkrelationsIntervalafter
  IanalinkrelationsIntervalbefore
  IanalinkrelationsIntervalcontains
  IanalinkrelationsIntervaldisjoint
  IanalinkrelationsIntervalduring
  IanalinkrelationsIntervalequals
  IanalinkrelationsIntervalfinishedby
  IanalinkrelationsIntervalfinishes
  IanalinkrelationsIntervalin
  IanalinkrelationsIntervalmeets
  IanalinkrelationsIntervalmetby
  IanalinkrelationsIntervaloverlappedby
  IanalinkrelationsIntervaloverlaps
  IanalinkrelationsIntervalstartedby
  IanalinkrelationsIntervalstarts
  IanalinkrelationsItem
  IanalinkrelationsLast
  IanalinkrelationsLatestversion
  IanalinkrelationsLicense
  IanalinkrelationsLinkset
  IanalinkrelationsLrdd
  IanalinkrelationsManifest
  IanalinkrelationsMaskicon
  IanalinkrelationsMediafeed
  IanalinkrelationsMemento
  IanalinkrelationsMicropub
  IanalinkrelationsModulepreload
  IanalinkrelationsMonitor
  IanalinkrelationsMonitorgroup
  IanalinkrelationsNext
  IanalinkrelationsNextarchive
  IanalinkrelationsNofollow
  IanalinkrelationsNoopener
  IanalinkrelationsNoreferrer
  IanalinkrelationsOpener
  IanalinkrelationsOpenid2localid
  IanalinkrelationsOpenid2provider
  IanalinkrelationsOriginal
  IanalinkrelationsP3pv1
  IanalinkrelationsPayment
  IanalinkrelationsPingback
  IanalinkrelationsPreconnect
  IanalinkrelationsPredecessorversion
  IanalinkrelationsPrefetch
  IanalinkrelationsPreload
  IanalinkrelationsPrerender
  IanalinkrelationsPrev
  IanalinkrelationsPreview
  IanalinkrelationsPrevious
  IanalinkrelationsPrevarchive
  IanalinkrelationsPrivacypolicy
  IanalinkrelationsProfile
  IanalinkrelationsPublication
  IanalinkrelationsRelated
  IanalinkrelationsRestconf
  IanalinkrelationsReplies
  IanalinkrelationsRuleinput
  IanalinkrelationsSearch
  IanalinkrelationsSection
  IanalinkrelationsSelf
  IanalinkrelationsService
  IanalinkrelationsServicedesc
  IanalinkrelationsServicedoc
  IanalinkrelationsServicemeta
  IanalinkrelationsSponsored
  IanalinkrelationsStart
  IanalinkrelationsStatus
  IanalinkrelationsStylesheet
  IanalinkrelationsSubsection
  IanalinkrelationsSuccessorversion
  IanalinkrelationsSunset
  IanalinkrelationsTag
  IanalinkrelationsTermsofservice
  IanalinkrelationsTimegate
  IanalinkrelationsTimemap
  IanalinkrelationsType
  IanalinkrelationsUgc
  IanalinkrelationsUp
  IanalinkrelationsVersionhistory
  IanalinkrelationsVia
  IanalinkrelationsWebmention
  IanalinkrelationsWorkingcopy
  IanalinkrelationsWorkingcopyof
}

pub fn ianalinkrelations_to_json(ianalinkrelations: Ianalinkrelations) -> Json {
  json.string(ianalinkrelations_to_string(ianalinkrelations))
}

pub fn ianalinkrelations_to_string(
  ianalinkrelations: Ianalinkrelations,
) -> String {
  case ianalinkrelations {
    IanalinkrelationsAbout -> "about"
    IanalinkrelationsAcl -> "acl"
    IanalinkrelationsAlternate -> "alternate"
    IanalinkrelationsAmphtml -> "amphtml"
    IanalinkrelationsAppendix -> "appendix"
    IanalinkrelationsAppletouchicon -> "apple-touch-icon"
    IanalinkrelationsAppletouchstartupimage -> "apple-touch-startup-image"
    IanalinkrelationsArchives -> "archives"
    IanalinkrelationsAuthor -> "author"
    IanalinkrelationsBlockedby -> "blocked-by"
    IanalinkrelationsBookmark -> "bookmark"
    IanalinkrelationsCanonical -> "canonical"
    IanalinkrelationsChapter -> "chapter"
    IanalinkrelationsCiteas -> "cite-as"
    IanalinkrelationsCollection -> "collection"
    IanalinkrelationsContents -> "contents"
    IanalinkrelationsConvertedfrom -> "convertedFrom"
    IanalinkrelationsCopyright -> "copyright"
    IanalinkrelationsCreateform -> "create-form"
    IanalinkrelationsCurrent -> "current"
    IanalinkrelationsDescribedby -> "describedby"
    IanalinkrelationsDescribes -> "describes"
    IanalinkrelationsDisclosure -> "disclosure"
    IanalinkrelationsDnsprefetch -> "dns-prefetch"
    IanalinkrelationsDuplicate -> "duplicate"
    IanalinkrelationsEdit -> "edit"
    IanalinkrelationsEditform -> "edit-form"
    IanalinkrelationsEditmedia -> "edit-media"
    IanalinkrelationsEnclosure -> "enclosure"
    IanalinkrelationsExternal -> "external"
    IanalinkrelationsFirst -> "first"
    IanalinkrelationsGlossary -> "glossary"
    IanalinkrelationsHelp -> "help"
    IanalinkrelationsHosts -> "hosts"
    IanalinkrelationsHub -> "hub"
    IanalinkrelationsIcon -> "icon"
    IanalinkrelationsIndex -> "index"
    IanalinkrelationsIntervalafter -> "intervalAfter"
    IanalinkrelationsIntervalbefore -> "intervalBefore"
    IanalinkrelationsIntervalcontains -> "intervalContains"
    IanalinkrelationsIntervaldisjoint -> "intervalDisjoint"
    IanalinkrelationsIntervalduring -> "intervalDuring"
    IanalinkrelationsIntervalequals -> "intervalEquals"
    IanalinkrelationsIntervalfinishedby -> "intervalFinishedBy"
    IanalinkrelationsIntervalfinishes -> "intervalFinishes"
    IanalinkrelationsIntervalin -> "intervalIn"
    IanalinkrelationsIntervalmeets -> "intervalMeets"
    IanalinkrelationsIntervalmetby -> "intervalMetBy"
    IanalinkrelationsIntervaloverlappedby -> "intervalOverlappedBy"
    IanalinkrelationsIntervaloverlaps -> "intervalOverlaps"
    IanalinkrelationsIntervalstartedby -> "intervalStartedBy"
    IanalinkrelationsIntervalstarts -> "intervalStarts"
    IanalinkrelationsItem -> "item"
    IanalinkrelationsLast -> "last"
    IanalinkrelationsLatestversion -> "latest-version"
    IanalinkrelationsLicense -> "license"
    IanalinkrelationsLinkset -> "linkset"
    IanalinkrelationsLrdd -> "lrdd"
    IanalinkrelationsManifest -> "manifest"
    IanalinkrelationsMaskicon -> "mask-icon"
    IanalinkrelationsMediafeed -> "media-feed"
    IanalinkrelationsMemento -> "memento"
    IanalinkrelationsMicropub -> "micropub"
    IanalinkrelationsModulepreload -> "modulepreload"
    IanalinkrelationsMonitor -> "monitor"
    IanalinkrelationsMonitorgroup -> "monitor-group"
    IanalinkrelationsNext -> "next"
    IanalinkrelationsNextarchive -> "next-archive"
    IanalinkrelationsNofollow -> "nofollow"
    IanalinkrelationsNoopener -> "noopener"
    IanalinkrelationsNoreferrer -> "noreferrer"
    IanalinkrelationsOpener -> "opener"
    IanalinkrelationsOpenid2localid -> "openid2.local_id"
    IanalinkrelationsOpenid2provider -> "openid2.provider"
    IanalinkrelationsOriginal -> "original"
    IanalinkrelationsP3pv1 -> "P3Pv1"
    IanalinkrelationsPayment -> "payment"
    IanalinkrelationsPingback -> "pingback"
    IanalinkrelationsPreconnect -> "preconnect"
    IanalinkrelationsPredecessorversion -> "predecessor-version"
    IanalinkrelationsPrefetch -> "prefetch"
    IanalinkrelationsPreload -> "preload"
    IanalinkrelationsPrerender -> "prerender"
    IanalinkrelationsPrev -> "prev"
    IanalinkrelationsPreview -> "preview"
    IanalinkrelationsPrevious -> "previous"
    IanalinkrelationsPrevarchive -> "prev-archive"
    IanalinkrelationsPrivacypolicy -> "privacy-policy"
    IanalinkrelationsProfile -> "profile"
    IanalinkrelationsPublication -> "publication"
    IanalinkrelationsRelated -> "related"
    IanalinkrelationsRestconf -> "restconf"
    IanalinkrelationsReplies -> "replies"
    IanalinkrelationsRuleinput -> "ruleinput"
    IanalinkrelationsSearch -> "search"
    IanalinkrelationsSection -> "section"
    IanalinkrelationsSelf -> "self"
    IanalinkrelationsService -> "service"
    IanalinkrelationsServicedesc -> "service-desc"
    IanalinkrelationsServicedoc -> "service-doc"
    IanalinkrelationsServicemeta -> "service-meta"
    IanalinkrelationsSponsored -> "sponsored"
    IanalinkrelationsStart -> "start"
    IanalinkrelationsStatus -> "status"
    IanalinkrelationsStylesheet -> "stylesheet"
    IanalinkrelationsSubsection -> "subsection"
    IanalinkrelationsSuccessorversion -> "successor-version"
    IanalinkrelationsSunset -> "sunset"
    IanalinkrelationsTag -> "tag"
    IanalinkrelationsTermsofservice -> "terms-of-service"
    IanalinkrelationsTimegate -> "timegate"
    IanalinkrelationsTimemap -> "timemap"
    IanalinkrelationsType -> "type"
    IanalinkrelationsUgc -> "ugc"
    IanalinkrelationsUp -> "up"
    IanalinkrelationsVersionhistory -> "version-history"
    IanalinkrelationsVia -> "via"
    IanalinkrelationsWebmention -> "webmention"
    IanalinkrelationsWorkingcopy -> "working-copy"
    IanalinkrelationsWorkingcopyof -> "working-copy-of"
  }
}

pub fn ianalinkrelations_from_string(
  s: String,
) -> Result(Ianalinkrelations, Nil) {
  case s {
    "about" -> Ok(IanalinkrelationsAbout)
    "acl" -> Ok(IanalinkrelationsAcl)
    "alternate" -> Ok(IanalinkrelationsAlternate)
    "amphtml" -> Ok(IanalinkrelationsAmphtml)
    "appendix" -> Ok(IanalinkrelationsAppendix)
    "apple-touch-icon" -> Ok(IanalinkrelationsAppletouchicon)
    "apple-touch-startup-image" -> Ok(IanalinkrelationsAppletouchstartupimage)
    "archives" -> Ok(IanalinkrelationsArchives)
    "author" -> Ok(IanalinkrelationsAuthor)
    "blocked-by" -> Ok(IanalinkrelationsBlockedby)
    "bookmark" -> Ok(IanalinkrelationsBookmark)
    "canonical" -> Ok(IanalinkrelationsCanonical)
    "chapter" -> Ok(IanalinkrelationsChapter)
    "cite-as" -> Ok(IanalinkrelationsCiteas)
    "collection" -> Ok(IanalinkrelationsCollection)
    "contents" -> Ok(IanalinkrelationsContents)
    "convertedFrom" -> Ok(IanalinkrelationsConvertedfrom)
    "copyright" -> Ok(IanalinkrelationsCopyright)
    "create-form" -> Ok(IanalinkrelationsCreateform)
    "current" -> Ok(IanalinkrelationsCurrent)
    "describedby" -> Ok(IanalinkrelationsDescribedby)
    "describes" -> Ok(IanalinkrelationsDescribes)
    "disclosure" -> Ok(IanalinkrelationsDisclosure)
    "dns-prefetch" -> Ok(IanalinkrelationsDnsprefetch)
    "duplicate" -> Ok(IanalinkrelationsDuplicate)
    "edit" -> Ok(IanalinkrelationsEdit)
    "edit-form" -> Ok(IanalinkrelationsEditform)
    "edit-media" -> Ok(IanalinkrelationsEditmedia)
    "enclosure" -> Ok(IanalinkrelationsEnclosure)
    "external" -> Ok(IanalinkrelationsExternal)
    "first" -> Ok(IanalinkrelationsFirst)
    "glossary" -> Ok(IanalinkrelationsGlossary)
    "help" -> Ok(IanalinkrelationsHelp)
    "hosts" -> Ok(IanalinkrelationsHosts)
    "hub" -> Ok(IanalinkrelationsHub)
    "icon" -> Ok(IanalinkrelationsIcon)
    "index" -> Ok(IanalinkrelationsIndex)
    "intervalAfter" -> Ok(IanalinkrelationsIntervalafter)
    "intervalBefore" -> Ok(IanalinkrelationsIntervalbefore)
    "intervalContains" -> Ok(IanalinkrelationsIntervalcontains)
    "intervalDisjoint" -> Ok(IanalinkrelationsIntervaldisjoint)
    "intervalDuring" -> Ok(IanalinkrelationsIntervalduring)
    "intervalEquals" -> Ok(IanalinkrelationsIntervalequals)
    "intervalFinishedBy" -> Ok(IanalinkrelationsIntervalfinishedby)
    "intervalFinishes" -> Ok(IanalinkrelationsIntervalfinishes)
    "intervalIn" -> Ok(IanalinkrelationsIntervalin)
    "intervalMeets" -> Ok(IanalinkrelationsIntervalmeets)
    "intervalMetBy" -> Ok(IanalinkrelationsIntervalmetby)
    "intervalOverlappedBy" -> Ok(IanalinkrelationsIntervaloverlappedby)
    "intervalOverlaps" -> Ok(IanalinkrelationsIntervaloverlaps)
    "intervalStartedBy" -> Ok(IanalinkrelationsIntervalstartedby)
    "intervalStarts" -> Ok(IanalinkrelationsIntervalstarts)
    "item" -> Ok(IanalinkrelationsItem)
    "last" -> Ok(IanalinkrelationsLast)
    "latest-version" -> Ok(IanalinkrelationsLatestversion)
    "license" -> Ok(IanalinkrelationsLicense)
    "linkset" -> Ok(IanalinkrelationsLinkset)
    "lrdd" -> Ok(IanalinkrelationsLrdd)
    "manifest" -> Ok(IanalinkrelationsManifest)
    "mask-icon" -> Ok(IanalinkrelationsMaskicon)
    "media-feed" -> Ok(IanalinkrelationsMediafeed)
    "memento" -> Ok(IanalinkrelationsMemento)
    "micropub" -> Ok(IanalinkrelationsMicropub)
    "modulepreload" -> Ok(IanalinkrelationsModulepreload)
    "monitor" -> Ok(IanalinkrelationsMonitor)
    "monitor-group" -> Ok(IanalinkrelationsMonitorgroup)
    "next" -> Ok(IanalinkrelationsNext)
    "next-archive" -> Ok(IanalinkrelationsNextarchive)
    "nofollow" -> Ok(IanalinkrelationsNofollow)
    "noopener" -> Ok(IanalinkrelationsNoopener)
    "noreferrer" -> Ok(IanalinkrelationsNoreferrer)
    "opener" -> Ok(IanalinkrelationsOpener)
    "openid2.local_id" -> Ok(IanalinkrelationsOpenid2localid)
    "openid2.provider" -> Ok(IanalinkrelationsOpenid2provider)
    "original" -> Ok(IanalinkrelationsOriginal)
    "P3Pv1" -> Ok(IanalinkrelationsP3pv1)
    "payment" -> Ok(IanalinkrelationsPayment)
    "pingback" -> Ok(IanalinkrelationsPingback)
    "preconnect" -> Ok(IanalinkrelationsPreconnect)
    "predecessor-version" -> Ok(IanalinkrelationsPredecessorversion)
    "prefetch" -> Ok(IanalinkrelationsPrefetch)
    "preload" -> Ok(IanalinkrelationsPreload)
    "prerender" -> Ok(IanalinkrelationsPrerender)
    "prev" -> Ok(IanalinkrelationsPrev)
    "preview" -> Ok(IanalinkrelationsPreview)
    "previous" -> Ok(IanalinkrelationsPrevious)
    "prev-archive" -> Ok(IanalinkrelationsPrevarchive)
    "privacy-policy" -> Ok(IanalinkrelationsPrivacypolicy)
    "profile" -> Ok(IanalinkrelationsProfile)
    "publication" -> Ok(IanalinkrelationsPublication)
    "related" -> Ok(IanalinkrelationsRelated)
    "restconf" -> Ok(IanalinkrelationsRestconf)
    "replies" -> Ok(IanalinkrelationsReplies)
    "ruleinput" -> Ok(IanalinkrelationsRuleinput)
    "search" -> Ok(IanalinkrelationsSearch)
    "section" -> Ok(IanalinkrelationsSection)
    "self" -> Ok(IanalinkrelationsSelf)
    "service" -> Ok(IanalinkrelationsService)
    "service-desc" -> Ok(IanalinkrelationsServicedesc)
    "service-doc" -> Ok(IanalinkrelationsServicedoc)
    "service-meta" -> Ok(IanalinkrelationsServicemeta)
    "sponsored" -> Ok(IanalinkrelationsSponsored)
    "start" -> Ok(IanalinkrelationsStart)
    "status" -> Ok(IanalinkrelationsStatus)
    "stylesheet" -> Ok(IanalinkrelationsStylesheet)
    "subsection" -> Ok(IanalinkrelationsSubsection)
    "successor-version" -> Ok(IanalinkrelationsSuccessorversion)
    "sunset" -> Ok(IanalinkrelationsSunset)
    "tag" -> Ok(IanalinkrelationsTag)
    "terms-of-service" -> Ok(IanalinkrelationsTermsofservice)
    "timegate" -> Ok(IanalinkrelationsTimegate)
    "timemap" -> Ok(IanalinkrelationsTimemap)
    "type" -> Ok(IanalinkrelationsType)
    "ugc" -> Ok(IanalinkrelationsUgc)
    "up" -> Ok(IanalinkrelationsUp)
    "version-history" -> Ok(IanalinkrelationsVersionhistory)
    "via" -> Ok(IanalinkrelationsVia)
    "webmention" -> Ok(IanalinkrelationsWebmention)
    "working-copy" -> Ok(IanalinkrelationsWorkingcopy)
    "working-copy-of" -> Ok(IanalinkrelationsWorkingcopyof)
    _ -> Error(Nil)
  }
}

pub fn ianalinkrelations_decoder() -> Decoder(Ianalinkrelations) {
  use variant <- decode.then(decode.string)
  case variant {
    "about" -> decode.success(IanalinkrelationsAbout)
    "acl" -> decode.success(IanalinkrelationsAcl)
    "alternate" -> decode.success(IanalinkrelationsAlternate)
    "amphtml" -> decode.success(IanalinkrelationsAmphtml)
    "appendix" -> decode.success(IanalinkrelationsAppendix)
    "apple-touch-icon" -> decode.success(IanalinkrelationsAppletouchicon)
    "apple-touch-startup-image" ->
      decode.success(IanalinkrelationsAppletouchstartupimage)
    "archives" -> decode.success(IanalinkrelationsArchives)
    "author" -> decode.success(IanalinkrelationsAuthor)
    "blocked-by" -> decode.success(IanalinkrelationsBlockedby)
    "bookmark" -> decode.success(IanalinkrelationsBookmark)
    "canonical" -> decode.success(IanalinkrelationsCanonical)
    "chapter" -> decode.success(IanalinkrelationsChapter)
    "cite-as" -> decode.success(IanalinkrelationsCiteas)
    "collection" -> decode.success(IanalinkrelationsCollection)
    "contents" -> decode.success(IanalinkrelationsContents)
    "convertedFrom" -> decode.success(IanalinkrelationsConvertedfrom)
    "copyright" -> decode.success(IanalinkrelationsCopyright)
    "create-form" -> decode.success(IanalinkrelationsCreateform)
    "current" -> decode.success(IanalinkrelationsCurrent)
    "describedby" -> decode.success(IanalinkrelationsDescribedby)
    "describes" -> decode.success(IanalinkrelationsDescribes)
    "disclosure" -> decode.success(IanalinkrelationsDisclosure)
    "dns-prefetch" -> decode.success(IanalinkrelationsDnsprefetch)
    "duplicate" -> decode.success(IanalinkrelationsDuplicate)
    "edit" -> decode.success(IanalinkrelationsEdit)
    "edit-form" -> decode.success(IanalinkrelationsEditform)
    "edit-media" -> decode.success(IanalinkrelationsEditmedia)
    "enclosure" -> decode.success(IanalinkrelationsEnclosure)
    "external" -> decode.success(IanalinkrelationsExternal)
    "first" -> decode.success(IanalinkrelationsFirst)
    "glossary" -> decode.success(IanalinkrelationsGlossary)
    "help" -> decode.success(IanalinkrelationsHelp)
    "hosts" -> decode.success(IanalinkrelationsHosts)
    "hub" -> decode.success(IanalinkrelationsHub)
    "icon" -> decode.success(IanalinkrelationsIcon)
    "index" -> decode.success(IanalinkrelationsIndex)
    "intervalAfter" -> decode.success(IanalinkrelationsIntervalafter)
    "intervalBefore" -> decode.success(IanalinkrelationsIntervalbefore)
    "intervalContains" -> decode.success(IanalinkrelationsIntervalcontains)
    "intervalDisjoint" -> decode.success(IanalinkrelationsIntervaldisjoint)
    "intervalDuring" -> decode.success(IanalinkrelationsIntervalduring)
    "intervalEquals" -> decode.success(IanalinkrelationsIntervalequals)
    "intervalFinishedBy" -> decode.success(IanalinkrelationsIntervalfinishedby)
    "intervalFinishes" -> decode.success(IanalinkrelationsIntervalfinishes)
    "intervalIn" -> decode.success(IanalinkrelationsIntervalin)
    "intervalMeets" -> decode.success(IanalinkrelationsIntervalmeets)
    "intervalMetBy" -> decode.success(IanalinkrelationsIntervalmetby)
    "intervalOverlappedBy" ->
      decode.success(IanalinkrelationsIntervaloverlappedby)
    "intervalOverlaps" -> decode.success(IanalinkrelationsIntervaloverlaps)
    "intervalStartedBy" -> decode.success(IanalinkrelationsIntervalstartedby)
    "intervalStarts" -> decode.success(IanalinkrelationsIntervalstarts)
    "item" -> decode.success(IanalinkrelationsItem)
    "last" -> decode.success(IanalinkrelationsLast)
    "latest-version" -> decode.success(IanalinkrelationsLatestversion)
    "license" -> decode.success(IanalinkrelationsLicense)
    "linkset" -> decode.success(IanalinkrelationsLinkset)
    "lrdd" -> decode.success(IanalinkrelationsLrdd)
    "manifest" -> decode.success(IanalinkrelationsManifest)
    "mask-icon" -> decode.success(IanalinkrelationsMaskicon)
    "media-feed" -> decode.success(IanalinkrelationsMediafeed)
    "memento" -> decode.success(IanalinkrelationsMemento)
    "micropub" -> decode.success(IanalinkrelationsMicropub)
    "modulepreload" -> decode.success(IanalinkrelationsModulepreload)
    "monitor" -> decode.success(IanalinkrelationsMonitor)
    "monitor-group" -> decode.success(IanalinkrelationsMonitorgroup)
    "next" -> decode.success(IanalinkrelationsNext)
    "next-archive" -> decode.success(IanalinkrelationsNextarchive)
    "nofollow" -> decode.success(IanalinkrelationsNofollow)
    "noopener" -> decode.success(IanalinkrelationsNoopener)
    "noreferrer" -> decode.success(IanalinkrelationsNoreferrer)
    "opener" -> decode.success(IanalinkrelationsOpener)
    "openid2.local_id" -> decode.success(IanalinkrelationsOpenid2localid)
    "openid2.provider" -> decode.success(IanalinkrelationsOpenid2provider)
    "original" -> decode.success(IanalinkrelationsOriginal)
    "P3Pv1" -> decode.success(IanalinkrelationsP3pv1)
    "payment" -> decode.success(IanalinkrelationsPayment)
    "pingback" -> decode.success(IanalinkrelationsPingback)
    "preconnect" -> decode.success(IanalinkrelationsPreconnect)
    "predecessor-version" -> decode.success(IanalinkrelationsPredecessorversion)
    "prefetch" -> decode.success(IanalinkrelationsPrefetch)
    "preload" -> decode.success(IanalinkrelationsPreload)
    "prerender" -> decode.success(IanalinkrelationsPrerender)
    "prev" -> decode.success(IanalinkrelationsPrev)
    "preview" -> decode.success(IanalinkrelationsPreview)
    "previous" -> decode.success(IanalinkrelationsPrevious)
    "prev-archive" -> decode.success(IanalinkrelationsPrevarchive)
    "privacy-policy" -> decode.success(IanalinkrelationsPrivacypolicy)
    "profile" -> decode.success(IanalinkrelationsProfile)
    "publication" -> decode.success(IanalinkrelationsPublication)
    "related" -> decode.success(IanalinkrelationsRelated)
    "restconf" -> decode.success(IanalinkrelationsRestconf)
    "replies" -> decode.success(IanalinkrelationsReplies)
    "ruleinput" -> decode.success(IanalinkrelationsRuleinput)
    "search" -> decode.success(IanalinkrelationsSearch)
    "section" -> decode.success(IanalinkrelationsSection)
    "self" -> decode.success(IanalinkrelationsSelf)
    "service" -> decode.success(IanalinkrelationsService)
    "service-desc" -> decode.success(IanalinkrelationsServicedesc)
    "service-doc" -> decode.success(IanalinkrelationsServicedoc)
    "service-meta" -> decode.success(IanalinkrelationsServicemeta)
    "sponsored" -> decode.success(IanalinkrelationsSponsored)
    "start" -> decode.success(IanalinkrelationsStart)
    "status" -> decode.success(IanalinkrelationsStatus)
    "stylesheet" -> decode.success(IanalinkrelationsStylesheet)
    "subsection" -> decode.success(IanalinkrelationsSubsection)
    "successor-version" -> decode.success(IanalinkrelationsSuccessorversion)
    "sunset" -> decode.success(IanalinkrelationsSunset)
    "tag" -> decode.success(IanalinkrelationsTag)
    "terms-of-service" -> decode.success(IanalinkrelationsTermsofservice)
    "timegate" -> decode.success(IanalinkrelationsTimegate)
    "timemap" -> decode.success(IanalinkrelationsTimemap)
    "type" -> decode.success(IanalinkrelationsType)
    "ugc" -> decode.success(IanalinkrelationsUgc)
    "up" -> decode.success(IanalinkrelationsUp)
    "version-history" -> decode.success(IanalinkrelationsVersionhistory)
    "via" -> decode.success(IanalinkrelationsVia)
    "webmention" -> decode.success(IanalinkrelationsWebmention)
    "working-copy" -> decode.success(IanalinkrelationsWorkingcopy)
    "working-copy-of" -> decode.success(IanalinkrelationsWorkingcopyof)
    _ -> decode.failure(IanalinkrelationsAbout, "Ianalinkrelations")
  }
}

pub type Identifieruse {
  IdentifieruseUsual
  IdentifieruseOfficial
  IdentifieruseTemp
  IdentifieruseSecondary
  IdentifieruseOld
}

pub fn identifieruse_to_json(identifieruse: Identifieruse) -> Json {
  json.string(identifieruse_to_string(identifieruse))
}

pub fn identifieruse_to_string(identifieruse: Identifieruse) -> String {
  case identifieruse {
    IdentifieruseUsual -> "usual"
    IdentifieruseOfficial -> "official"
    IdentifieruseTemp -> "temp"
    IdentifieruseSecondary -> "secondary"
    IdentifieruseOld -> "old"
  }
}

pub fn identifieruse_from_string(s: String) -> Result(Identifieruse, Nil) {
  case s {
    "usual" -> Ok(IdentifieruseUsual)
    "official" -> Ok(IdentifieruseOfficial)
    "temp" -> Ok(IdentifieruseTemp)
    "secondary" -> Ok(IdentifieruseSecondary)
    "old" -> Ok(IdentifieruseOld)
    _ -> Error(Nil)
  }
}

pub fn identifieruse_decoder() -> Decoder(Identifieruse) {
  use variant <- decode.then(decode.string)
  case variant {
    "usual" -> decode.success(IdentifieruseUsual)
    "official" -> decode.success(IdentifieruseOfficial)
    "temp" -> decode.success(IdentifieruseTemp)
    "secondary" -> decode.success(IdentifieruseSecondary)
    "old" -> decode.success(IdentifieruseOld)
    _ -> decode.failure(IdentifieruseUsual, "Identifieruse")
  }
}

pub type Identityassurancelevel {
  IdentityassurancelevelLevel1
  IdentityassurancelevelLevel2
  IdentityassurancelevelLevel3
  IdentityassurancelevelLevel4
}

pub fn identityassurancelevel_to_json(
  identityassurancelevel: Identityassurancelevel,
) -> Json {
  json.string(identityassurancelevel_to_string(identityassurancelevel))
}

pub fn identityassurancelevel_to_string(
  identityassurancelevel: Identityassurancelevel,
) -> String {
  case identityassurancelevel {
    IdentityassurancelevelLevel1 -> "level1"
    IdentityassurancelevelLevel2 -> "level2"
    IdentityassurancelevelLevel3 -> "level3"
    IdentityassurancelevelLevel4 -> "level4"
  }
}

pub fn identityassurancelevel_from_string(
  s: String,
) -> Result(Identityassurancelevel, Nil) {
  case s {
    "level1" -> Ok(IdentityassurancelevelLevel1)
    "level2" -> Ok(IdentityassurancelevelLevel2)
    "level3" -> Ok(IdentityassurancelevelLevel3)
    "level4" -> Ok(IdentityassurancelevelLevel4)
    _ -> Error(Nil)
  }
}

pub fn identityassurancelevel_decoder() -> Decoder(Identityassurancelevel) {
  use variant <- decode.then(decode.string)
  case variant {
    "level1" -> decode.success(IdentityassurancelevelLevel1)
    "level2" -> decode.success(IdentityassurancelevelLevel2)
    "level3" -> decode.success(IdentityassurancelevelLevel3)
    "level4" -> decode.success(IdentityassurancelevelLevel4)
    _ -> decode.failure(IdentityassurancelevelLevel1, "Identityassurancelevel")
  }
}

pub type Imagingselection2dgraphictype {
  Imagingselection2dgraphictypePoint
  Imagingselection2dgraphictypePolyline
  Imagingselection2dgraphictypeInterpolated
  Imagingselection2dgraphictypeCircle
  Imagingselection2dgraphictypeEllipse
}

pub fn imagingselection2dgraphictype_to_json(
  imagingselection2dgraphictype: Imagingselection2dgraphictype,
) -> Json {
  json.string(imagingselection2dgraphictype_to_string(
    imagingselection2dgraphictype,
  ))
}

pub fn imagingselection2dgraphictype_to_string(
  imagingselection2dgraphictype: Imagingselection2dgraphictype,
) -> String {
  case imagingselection2dgraphictype {
    Imagingselection2dgraphictypePoint -> "point"
    Imagingselection2dgraphictypePolyline -> "polyline"
    Imagingselection2dgraphictypeInterpolated -> "interpolated"
    Imagingselection2dgraphictypeCircle -> "circle"
    Imagingselection2dgraphictypeEllipse -> "ellipse"
  }
}

pub fn imagingselection2dgraphictype_from_string(
  s: String,
) -> Result(Imagingselection2dgraphictype, Nil) {
  case s {
    "point" -> Ok(Imagingselection2dgraphictypePoint)
    "polyline" -> Ok(Imagingselection2dgraphictypePolyline)
    "interpolated" -> Ok(Imagingselection2dgraphictypeInterpolated)
    "circle" -> Ok(Imagingselection2dgraphictypeCircle)
    "ellipse" -> Ok(Imagingselection2dgraphictypeEllipse)
    _ -> Error(Nil)
  }
}

pub fn imagingselection2dgraphictype_decoder() -> Decoder(
  Imagingselection2dgraphictype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "point" -> decode.success(Imagingselection2dgraphictypePoint)
    "polyline" -> decode.success(Imagingselection2dgraphictypePolyline)
    "interpolated" -> decode.success(Imagingselection2dgraphictypeInterpolated)
    "circle" -> decode.success(Imagingselection2dgraphictypeCircle)
    "ellipse" -> decode.success(Imagingselection2dgraphictypeEllipse)
    _ ->
      decode.failure(
        Imagingselection2dgraphictypePoint,
        "Imagingselection2dgraphictype",
      )
  }
}

pub type Imagingselection3dgraphictype {
  Imagingselection3dgraphictypePoint
  Imagingselection3dgraphictypeMultipoint
  Imagingselection3dgraphictypePolyline
  Imagingselection3dgraphictypePolygon
  Imagingselection3dgraphictypeEllipse
  Imagingselection3dgraphictypeEllipsoid
}

pub fn imagingselection3dgraphictype_to_json(
  imagingselection3dgraphictype: Imagingselection3dgraphictype,
) -> Json {
  json.string(imagingselection3dgraphictype_to_string(
    imagingselection3dgraphictype,
  ))
}

pub fn imagingselection3dgraphictype_to_string(
  imagingselection3dgraphictype: Imagingselection3dgraphictype,
) -> String {
  case imagingselection3dgraphictype {
    Imagingselection3dgraphictypePoint -> "point"
    Imagingselection3dgraphictypeMultipoint -> "multipoint"
    Imagingselection3dgraphictypePolyline -> "polyline"
    Imagingselection3dgraphictypePolygon -> "polygon"
    Imagingselection3dgraphictypeEllipse -> "ellipse"
    Imagingselection3dgraphictypeEllipsoid -> "ellipsoid"
  }
}

pub fn imagingselection3dgraphictype_from_string(
  s: String,
) -> Result(Imagingselection3dgraphictype, Nil) {
  case s {
    "point" -> Ok(Imagingselection3dgraphictypePoint)
    "multipoint" -> Ok(Imagingselection3dgraphictypeMultipoint)
    "polyline" -> Ok(Imagingselection3dgraphictypePolyline)
    "polygon" -> Ok(Imagingselection3dgraphictypePolygon)
    "ellipse" -> Ok(Imagingselection3dgraphictypeEllipse)
    "ellipsoid" -> Ok(Imagingselection3dgraphictypeEllipsoid)
    _ -> Error(Nil)
  }
}

pub fn imagingselection3dgraphictype_decoder() -> Decoder(
  Imagingselection3dgraphictype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "point" -> decode.success(Imagingselection3dgraphictypePoint)
    "multipoint" -> decode.success(Imagingselection3dgraphictypeMultipoint)
    "polyline" -> decode.success(Imagingselection3dgraphictypePolyline)
    "polygon" -> decode.success(Imagingselection3dgraphictypePolygon)
    "ellipse" -> decode.success(Imagingselection3dgraphictypeEllipse)
    "ellipsoid" -> decode.success(Imagingselection3dgraphictypeEllipsoid)
    _ ->
      decode.failure(
        Imagingselection3dgraphictypePoint,
        "Imagingselection3dgraphictype",
      )
  }
}

pub type Imagingselectionstatus {
  ImagingselectionstatusAvailable
  ImagingselectionstatusEnteredinerror
  ImagingselectionstatusUnknown
}

pub fn imagingselectionstatus_to_json(
  imagingselectionstatus: Imagingselectionstatus,
) -> Json {
  json.string(imagingselectionstatus_to_string(imagingselectionstatus))
}

pub fn imagingselectionstatus_to_string(
  imagingselectionstatus: Imagingselectionstatus,
) -> String {
  case imagingselectionstatus {
    ImagingselectionstatusAvailable -> "available"
    ImagingselectionstatusEnteredinerror -> "entered-in-error"
    ImagingselectionstatusUnknown -> "unknown"
  }
}

pub fn imagingselectionstatus_from_string(
  s: String,
) -> Result(Imagingselectionstatus, Nil) {
  case s {
    "available" -> Ok(ImagingselectionstatusAvailable)
    "entered-in-error" -> Ok(ImagingselectionstatusEnteredinerror)
    "unknown" -> Ok(ImagingselectionstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn imagingselectionstatus_decoder() -> Decoder(Imagingselectionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "available" -> decode.success(ImagingselectionstatusAvailable)
    "entered-in-error" -> decode.success(ImagingselectionstatusEnteredinerror)
    "unknown" -> decode.success(ImagingselectionstatusUnknown)
    _ ->
      decode.failure(ImagingselectionstatusAvailable, "Imagingselectionstatus")
  }
}

pub type Imagingstudystatus {
  ImagingstudystatusRegistered
  ImagingstudystatusAvailable
  ImagingstudystatusCancelled
  ImagingstudystatusEnteredinerror
  ImagingstudystatusUnknown
}

pub fn imagingstudystatus_to_json(
  imagingstudystatus: Imagingstudystatus,
) -> Json {
  json.string(imagingstudystatus_to_string(imagingstudystatus))
}

pub fn imagingstudystatus_to_string(
  imagingstudystatus: Imagingstudystatus,
) -> String {
  case imagingstudystatus {
    ImagingstudystatusRegistered -> "registered"
    ImagingstudystatusAvailable -> "available"
    ImagingstudystatusCancelled -> "cancelled"
    ImagingstudystatusEnteredinerror -> "entered-in-error"
    ImagingstudystatusUnknown -> "unknown"
  }
}

pub fn imagingstudystatus_from_string(
  s: String,
) -> Result(Imagingstudystatus, Nil) {
  case s {
    "registered" -> Ok(ImagingstudystatusRegistered)
    "available" -> Ok(ImagingstudystatusAvailable)
    "cancelled" -> Ok(ImagingstudystatusCancelled)
    "entered-in-error" -> Ok(ImagingstudystatusEnteredinerror)
    "unknown" -> Ok(ImagingstudystatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn imagingstudystatus_decoder() -> Decoder(Imagingstudystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered" -> decode.success(ImagingstudystatusRegistered)
    "available" -> decode.success(ImagingstudystatusAvailable)
    "cancelled" -> decode.success(ImagingstudystatusCancelled)
    "entered-in-error" -> decode.success(ImagingstudystatusEnteredinerror)
    "unknown" -> decode.success(ImagingstudystatusUnknown)
    _ -> decode.failure(ImagingstudystatusRegistered, "Imagingstudystatus")
  }
}

pub type Immunizationevaluationstatus {
  ImmunizationevaluationstatusCompleted
  ImmunizationevaluationstatusEnteredinerror
}

pub fn immunizationevaluationstatus_to_json(
  immunizationevaluationstatus: Immunizationevaluationstatus,
) -> Json {
  json.string(immunizationevaluationstatus_to_string(
    immunizationevaluationstatus,
  ))
}

pub fn immunizationevaluationstatus_to_string(
  immunizationevaluationstatus: Immunizationevaluationstatus,
) -> String {
  case immunizationevaluationstatus {
    ImmunizationevaluationstatusCompleted -> "completed"
    ImmunizationevaluationstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn immunizationevaluationstatus_from_string(
  s: String,
) -> Result(Immunizationevaluationstatus, Nil) {
  case s {
    "completed" -> Ok(ImmunizationevaluationstatusCompleted)
    "entered-in-error" -> Ok(ImmunizationevaluationstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn immunizationevaluationstatus_decoder() -> Decoder(
  Immunizationevaluationstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "completed" -> decode.success(ImmunizationevaluationstatusCompleted)
    "entered-in-error" ->
      decode.success(ImmunizationevaluationstatusEnteredinerror)
    _ ->
      decode.failure(
        ImmunizationevaluationstatusCompleted,
        "Immunizationevaluationstatus",
      )
  }
}

pub type Immunizationstatus {
  ImmunizationstatusCompleted
  ImmunizationstatusEnteredinerror
  ImmunizationstatusNotdone
}

pub fn immunizationstatus_to_json(
  immunizationstatus: Immunizationstatus,
) -> Json {
  json.string(immunizationstatus_to_string(immunizationstatus))
}

pub fn immunizationstatus_to_string(
  immunizationstatus: Immunizationstatus,
) -> String {
  case immunizationstatus {
    ImmunizationstatusCompleted -> "completed"
    ImmunizationstatusEnteredinerror -> "entered-in-error"
    ImmunizationstatusNotdone -> "not-done"
  }
}

pub fn immunizationstatus_from_string(
  s: String,
) -> Result(Immunizationstatus, Nil) {
  case s {
    "completed" -> Ok(ImmunizationstatusCompleted)
    "entered-in-error" -> Ok(ImmunizationstatusEnteredinerror)
    "not-done" -> Ok(ImmunizationstatusNotdone)
    _ -> Error(Nil)
  }
}

pub fn immunizationstatus_decoder() -> Decoder(Immunizationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "completed" -> decode.success(ImmunizationstatusCompleted)
    "entered-in-error" -> decode.success(ImmunizationstatusEnteredinerror)
    "not-done" -> decode.success(ImmunizationstatusNotdone)
    _ -> decode.failure(ImmunizationstatusCompleted, "Immunizationstatus")
  }
}

pub type Ingredientmanufacturerrole {
  IngredientmanufacturerroleAllowed
  IngredientmanufacturerrolePossible
  IngredientmanufacturerroleActual
}

pub fn ingredientmanufacturerrole_to_json(
  ingredientmanufacturerrole: Ingredientmanufacturerrole,
) -> Json {
  json.string(ingredientmanufacturerrole_to_string(ingredientmanufacturerrole))
}

pub fn ingredientmanufacturerrole_to_string(
  ingredientmanufacturerrole: Ingredientmanufacturerrole,
) -> String {
  case ingredientmanufacturerrole {
    IngredientmanufacturerroleAllowed -> "allowed"
    IngredientmanufacturerrolePossible -> "possible"
    IngredientmanufacturerroleActual -> "actual"
  }
}

pub fn ingredientmanufacturerrole_from_string(
  s: String,
) -> Result(Ingredientmanufacturerrole, Nil) {
  case s {
    "allowed" -> Ok(IngredientmanufacturerroleAllowed)
    "possible" -> Ok(IngredientmanufacturerrolePossible)
    "actual" -> Ok(IngredientmanufacturerroleActual)
    _ -> Error(Nil)
  }
}

pub fn ingredientmanufacturerrole_decoder() -> Decoder(
  Ingredientmanufacturerrole,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "allowed" -> decode.success(IngredientmanufacturerroleAllowed)
    "possible" -> decode.success(IngredientmanufacturerrolePossible)
    "actual" -> decode.success(IngredientmanufacturerroleActual)
    _ ->
      decode.failure(
        IngredientmanufacturerroleAllowed,
        "Ingredientmanufacturerrole",
      )
  }
}

pub type Interactiontrigger {
  InteractiontriggerCreate
  InteractiontriggerUpdate
  InteractiontriggerDelete
}

pub fn interactiontrigger_to_json(
  interactiontrigger: Interactiontrigger,
) -> Json {
  json.string(interactiontrigger_to_string(interactiontrigger))
}

pub fn interactiontrigger_to_string(
  interactiontrigger: Interactiontrigger,
) -> String {
  case interactiontrigger {
    InteractiontriggerCreate -> "create"
    InteractiontriggerUpdate -> "update"
    InteractiontriggerDelete -> "delete"
  }
}

pub fn interactiontrigger_from_string(
  s: String,
) -> Result(Interactiontrigger, Nil) {
  case s {
    "create" -> Ok(InteractiontriggerCreate)
    "update" -> Ok(InteractiontriggerUpdate)
    "delete" -> Ok(InteractiontriggerDelete)
    _ -> Error(Nil)
  }
}

pub fn interactiontrigger_decoder() -> Decoder(Interactiontrigger) {
  use variant <- decode.then(decode.string)
  case variant {
    "create" -> decode.success(InteractiontriggerCreate)
    "update" -> decode.success(InteractiontriggerUpdate)
    "delete" -> decode.success(InteractiontriggerDelete)
    _ -> decode.failure(InteractiontriggerCreate, "Interactiontrigger")
  }
}

pub type Inventoryitemstatus {
  InventoryitemstatusActive
  InventoryitemstatusInactive
  InventoryitemstatusEnteredinerror
  InventoryitemstatusUnknown
}

pub fn inventoryitemstatus_to_json(
  inventoryitemstatus: Inventoryitemstatus,
) -> Json {
  json.string(inventoryitemstatus_to_string(inventoryitemstatus))
}

pub fn inventoryitemstatus_to_string(
  inventoryitemstatus: Inventoryitemstatus,
) -> String {
  case inventoryitemstatus {
    InventoryitemstatusActive -> "active"
    InventoryitemstatusInactive -> "inactive"
    InventoryitemstatusEnteredinerror -> "entered-in-error"
    InventoryitemstatusUnknown -> "unknown"
  }
}

pub fn inventoryitemstatus_from_string(
  s: String,
) -> Result(Inventoryitemstatus, Nil) {
  case s {
    "active" -> Ok(InventoryitemstatusActive)
    "inactive" -> Ok(InventoryitemstatusInactive)
    "entered-in-error" -> Ok(InventoryitemstatusEnteredinerror)
    "unknown" -> Ok(InventoryitemstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn inventoryitemstatus_decoder() -> Decoder(Inventoryitemstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(InventoryitemstatusActive)
    "inactive" -> decode.success(InventoryitemstatusInactive)
    "entered-in-error" -> decode.success(InventoryitemstatusEnteredinerror)
    "unknown" -> decode.success(InventoryitemstatusUnknown)
    _ -> decode.failure(InventoryitemstatusActive, "Inventoryitemstatus")
  }
}

pub type Inventoryreportcounttype {
  InventoryreportcounttypeSnapshot
  InventoryreportcounttypeDifference
}

pub fn inventoryreportcounttype_to_json(
  inventoryreportcounttype: Inventoryreportcounttype,
) -> Json {
  json.string(inventoryreportcounttype_to_string(inventoryreportcounttype))
}

pub fn inventoryreportcounttype_to_string(
  inventoryreportcounttype: Inventoryreportcounttype,
) -> String {
  case inventoryreportcounttype {
    InventoryreportcounttypeSnapshot -> "snapshot"
    InventoryreportcounttypeDifference -> "difference"
  }
}

pub fn inventoryreportcounttype_from_string(
  s: String,
) -> Result(Inventoryreportcounttype, Nil) {
  case s {
    "snapshot" -> Ok(InventoryreportcounttypeSnapshot)
    "difference" -> Ok(InventoryreportcounttypeDifference)
    _ -> Error(Nil)
  }
}

pub fn inventoryreportcounttype_decoder() -> Decoder(Inventoryreportcounttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "snapshot" -> decode.success(InventoryreportcounttypeSnapshot)
    "difference" -> decode.success(InventoryreportcounttypeDifference)
    _ ->
      decode.failure(
        InventoryreportcounttypeSnapshot,
        "Inventoryreportcounttype",
      )
  }
}

pub type Inventoryreportstatus {
  InventoryreportstatusDraft
  InventoryreportstatusRequested
  InventoryreportstatusActive
  InventoryreportstatusEnteredinerror
}

pub fn inventoryreportstatus_to_json(
  inventoryreportstatus: Inventoryreportstatus,
) -> Json {
  json.string(inventoryreportstatus_to_string(inventoryreportstatus))
}

pub fn inventoryreportstatus_to_string(
  inventoryreportstatus: Inventoryreportstatus,
) -> String {
  case inventoryreportstatus {
    InventoryreportstatusDraft -> "draft"
    InventoryreportstatusRequested -> "requested"
    InventoryreportstatusActive -> "active"
    InventoryreportstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn inventoryreportstatus_from_string(
  s: String,
) -> Result(Inventoryreportstatus, Nil) {
  case s {
    "draft" -> Ok(InventoryreportstatusDraft)
    "requested" -> Ok(InventoryreportstatusRequested)
    "active" -> Ok(InventoryreportstatusActive)
    "entered-in-error" -> Ok(InventoryreportstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn inventoryreportstatus_decoder() -> Decoder(Inventoryreportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(InventoryreportstatusDraft)
    "requested" -> decode.success(InventoryreportstatusRequested)
    "active" -> decode.success(InventoryreportstatusActive)
    "entered-in-error" -> decode.success(InventoryreportstatusEnteredinerror)
    _ -> decode.failure(InventoryreportstatusDraft, "Inventoryreportstatus")
  }
}

pub type Invoicestatus {
  InvoicestatusDraft
  InvoicestatusIssued
  InvoicestatusBalanced
  InvoicestatusCancelled
  InvoicestatusEnteredinerror
}

pub fn invoicestatus_to_json(invoicestatus: Invoicestatus) -> Json {
  json.string(invoicestatus_to_string(invoicestatus))
}

pub fn invoicestatus_to_string(invoicestatus: Invoicestatus) -> String {
  case invoicestatus {
    InvoicestatusDraft -> "draft"
    InvoicestatusIssued -> "issued"
    InvoicestatusBalanced -> "balanced"
    InvoicestatusCancelled -> "cancelled"
    InvoicestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn invoicestatus_from_string(s: String) -> Result(Invoicestatus, Nil) {
  case s {
    "draft" -> Ok(InvoicestatusDraft)
    "issued" -> Ok(InvoicestatusIssued)
    "balanced" -> Ok(InvoicestatusBalanced)
    "cancelled" -> Ok(InvoicestatusCancelled)
    "entered-in-error" -> Ok(InvoicestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn invoicestatus_decoder() -> Decoder(Invoicestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(InvoicestatusDraft)
    "issued" -> decode.success(InvoicestatusIssued)
    "balanced" -> decode.success(InvoicestatusBalanced)
    "cancelled" -> decode.success(InvoicestatusCancelled)
    "entered-in-error" -> decode.success(InvoicestatusEnteredinerror)
    _ -> decode.failure(InvoicestatusDraft, "Invoicestatus")
  }
}

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
  IssueseveritySuccess
}

pub fn issueseverity_to_json(issueseverity: Issueseverity) -> Json {
  json.string(issueseverity_to_string(issueseverity))
}

pub fn issueseverity_to_string(issueseverity: Issueseverity) -> String {
  case issueseverity {
    IssueseverityFatal -> "fatal"
    IssueseverityError -> "error"
    IssueseverityWarning -> "warning"
    IssueseverityInformation -> "information"
    IssueseveritySuccess -> "success"
  }
}

pub fn issueseverity_from_string(s: String) -> Result(Issueseverity, Nil) {
  case s {
    "fatal" -> Ok(IssueseverityFatal)
    "error" -> Ok(IssueseverityError)
    "warning" -> Ok(IssueseverityWarning)
    "information" -> Ok(IssueseverityInformation)
    "success" -> Ok(IssueseveritySuccess)
    _ -> Error(Nil)
  }
}

pub fn issueseverity_decoder() -> Decoder(Issueseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "fatal" -> decode.success(IssueseverityFatal)
    "error" -> decode.success(IssueseverityError)
    "warning" -> decode.success(IssueseverityWarning)
    "information" -> decode.success(IssueseverityInformation)
    "success" -> decode.success(IssueseveritySuccess)
    _ -> decode.failure(IssueseverityFatal, "Issueseverity")
  }
}

pub type Issuetype {
  IssuetypeInvalid
  IssuetypeStructure
  IssuetypeRequired
  IssuetypeValue
  IssuetypeInvariant
  IssuetypeSecurity
  IssuetypeLogin
  IssuetypeUnknown
  IssuetypeExpired
  IssuetypeForbidden
  IssuetypeSuppressed
  IssuetypeProcessing
  IssuetypeNotsupported
  IssuetypeDuplicate
  IssuetypeMultiplematches
  IssuetypeNotfound
  IssuetypeDeleted
  IssuetypeToolong
  IssuetypeCodeinvalid
  IssuetypeExtension
  IssuetypeToocostly
  IssuetypeBusinessrule
  IssuetypeConflict
  IssuetypeLimitedfilter
  IssuetypeTransient
  IssuetypeLockerror
  IssuetypeNostore
  IssuetypeException
  IssuetypeTimeout
  IssuetypeIncomplete
  IssuetypeThrottled
  IssuetypeInformational
  IssuetypeSuccess
}

pub fn issuetype_to_json(issuetype: Issuetype) -> Json {
  json.string(issuetype_to_string(issuetype))
}

pub fn issuetype_to_string(issuetype: Issuetype) -> String {
  case issuetype {
    IssuetypeInvalid -> "invalid"
    IssuetypeStructure -> "structure"
    IssuetypeRequired -> "required"
    IssuetypeValue -> "value"
    IssuetypeInvariant -> "invariant"
    IssuetypeSecurity -> "security"
    IssuetypeLogin -> "login"
    IssuetypeUnknown -> "unknown"
    IssuetypeExpired -> "expired"
    IssuetypeForbidden -> "forbidden"
    IssuetypeSuppressed -> "suppressed"
    IssuetypeProcessing -> "processing"
    IssuetypeNotsupported -> "not-supported"
    IssuetypeDuplicate -> "duplicate"
    IssuetypeMultiplematches -> "multiple-matches"
    IssuetypeNotfound -> "not-found"
    IssuetypeDeleted -> "deleted"
    IssuetypeToolong -> "too-long"
    IssuetypeCodeinvalid -> "code-invalid"
    IssuetypeExtension -> "extension"
    IssuetypeToocostly -> "too-costly"
    IssuetypeBusinessrule -> "business-rule"
    IssuetypeConflict -> "conflict"
    IssuetypeLimitedfilter -> "limited-filter"
    IssuetypeTransient -> "transient"
    IssuetypeLockerror -> "lock-error"
    IssuetypeNostore -> "no-store"
    IssuetypeException -> "exception"
    IssuetypeTimeout -> "timeout"
    IssuetypeIncomplete -> "incomplete"
    IssuetypeThrottled -> "throttled"
    IssuetypeInformational -> "informational"
    IssuetypeSuccess -> "success"
  }
}

pub fn issuetype_from_string(s: String) -> Result(Issuetype, Nil) {
  case s {
    "invalid" -> Ok(IssuetypeInvalid)
    "structure" -> Ok(IssuetypeStructure)
    "required" -> Ok(IssuetypeRequired)
    "value" -> Ok(IssuetypeValue)
    "invariant" -> Ok(IssuetypeInvariant)
    "security" -> Ok(IssuetypeSecurity)
    "login" -> Ok(IssuetypeLogin)
    "unknown" -> Ok(IssuetypeUnknown)
    "expired" -> Ok(IssuetypeExpired)
    "forbidden" -> Ok(IssuetypeForbidden)
    "suppressed" -> Ok(IssuetypeSuppressed)
    "processing" -> Ok(IssuetypeProcessing)
    "not-supported" -> Ok(IssuetypeNotsupported)
    "duplicate" -> Ok(IssuetypeDuplicate)
    "multiple-matches" -> Ok(IssuetypeMultiplematches)
    "not-found" -> Ok(IssuetypeNotfound)
    "deleted" -> Ok(IssuetypeDeleted)
    "too-long" -> Ok(IssuetypeToolong)
    "code-invalid" -> Ok(IssuetypeCodeinvalid)
    "extension" -> Ok(IssuetypeExtension)
    "too-costly" -> Ok(IssuetypeToocostly)
    "business-rule" -> Ok(IssuetypeBusinessrule)
    "conflict" -> Ok(IssuetypeConflict)
    "limited-filter" -> Ok(IssuetypeLimitedfilter)
    "transient" -> Ok(IssuetypeTransient)
    "lock-error" -> Ok(IssuetypeLockerror)
    "no-store" -> Ok(IssuetypeNostore)
    "exception" -> Ok(IssuetypeException)
    "timeout" -> Ok(IssuetypeTimeout)
    "incomplete" -> Ok(IssuetypeIncomplete)
    "throttled" -> Ok(IssuetypeThrottled)
    "informational" -> Ok(IssuetypeInformational)
    "success" -> Ok(IssuetypeSuccess)
    _ -> Error(Nil)
  }
}

pub fn issuetype_decoder() -> Decoder(Issuetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "invalid" -> decode.success(IssuetypeInvalid)
    "structure" -> decode.success(IssuetypeStructure)
    "required" -> decode.success(IssuetypeRequired)
    "value" -> decode.success(IssuetypeValue)
    "invariant" -> decode.success(IssuetypeInvariant)
    "security" -> decode.success(IssuetypeSecurity)
    "login" -> decode.success(IssuetypeLogin)
    "unknown" -> decode.success(IssuetypeUnknown)
    "expired" -> decode.success(IssuetypeExpired)
    "forbidden" -> decode.success(IssuetypeForbidden)
    "suppressed" -> decode.success(IssuetypeSuppressed)
    "processing" -> decode.success(IssuetypeProcessing)
    "not-supported" -> decode.success(IssuetypeNotsupported)
    "duplicate" -> decode.success(IssuetypeDuplicate)
    "multiple-matches" -> decode.success(IssuetypeMultiplematches)
    "not-found" -> decode.success(IssuetypeNotfound)
    "deleted" -> decode.success(IssuetypeDeleted)
    "too-long" -> decode.success(IssuetypeToolong)
    "code-invalid" -> decode.success(IssuetypeCodeinvalid)
    "extension" -> decode.success(IssuetypeExtension)
    "too-costly" -> decode.success(IssuetypeToocostly)
    "business-rule" -> decode.success(IssuetypeBusinessrule)
    "conflict" -> decode.success(IssuetypeConflict)
    "limited-filter" -> decode.success(IssuetypeLimitedfilter)
    "transient" -> decode.success(IssuetypeTransient)
    "lock-error" -> decode.success(IssuetypeLockerror)
    "no-store" -> decode.success(IssuetypeNostore)
    "exception" -> decode.success(IssuetypeException)
    "timeout" -> decode.success(IssuetypeTimeout)
    "incomplete" -> decode.success(IssuetypeIncomplete)
    "throttled" -> decode.success(IssuetypeThrottled)
    "informational" -> decode.success(IssuetypeInformational)
    "success" -> decode.success(IssuetypeSuccess)
    _ -> decode.failure(IssuetypeInvalid, "Issuetype")
  }
}

pub type Itemtype {
  ItemtypeGroup
  ItemtypeDisplay
  ItemtypeQuestion
  ItemtypeBoolean
  ItemtypeDecimal
  ItemtypeInteger
  ItemtypeDate
  ItemtypeDatetime
  ItemtypeTime
  ItemtypeString
  ItemtypeText
  ItemtypeUrl
  ItemtypeCoding
  ItemtypeAttachment
  ItemtypeReference
  ItemtypeQuantity
}

pub fn itemtype_to_json(itemtype: Itemtype) -> Json {
  json.string(itemtype_to_string(itemtype))
}

pub fn itemtype_to_string(itemtype: Itemtype) -> String {
  case itemtype {
    ItemtypeGroup -> "group"
    ItemtypeDisplay -> "display"
    ItemtypeQuestion -> "question"
    ItemtypeBoolean -> "boolean"
    ItemtypeDecimal -> "decimal"
    ItemtypeInteger -> "integer"
    ItemtypeDate -> "date"
    ItemtypeDatetime -> "dateTime"
    ItemtypeTime -> "time"
    ItemtypeString -> "string"
    ItemtypeText -> "text"
    ItemtypeUrl -> "url"
    ItemtypeCoding -> "coding"
    ItemtypeAttachment -> "attachment"
    ItemtypeReference -> "reference"
    ItemtypeQuantity -> "quantity"
  }
}

pub fn itemtype_from_string(s: String) -> Result(Itemtype, Nil) {
  case s {
    "group" -> Ok(ItemtypeGroup)
    "display" -> Ok(ItemtypeDisplay)
    "question" -> Ok(ItemtypeQuestion)
    "boolean" -> Ok(ItemtypeBoolean)
    "decimal" -> Ok(ItemtypeDecimal)
    "integer" -> Ok(ItemtypeInteger)
    "date" -> Ok(ItemtypeDate)
    "dateTime" -> Ok(ItemtypeDatetime)
    "time" -> Ok(ItemtypeTime)
    "string" -> Ok(ItemtypeString)
    "text" -> Ok(ItemtypeText)
    "url" -> Ok(ItemtypeUrl)
    "coding" -> Ok(ItemtypeCoding)
    "attachment" -> Ok(ItemtypeAttachment)
    "reference" -> Ok(ItemtypeReference)
    "quantity" -> Ok(ItemtypeQuantity)
    _ -> Error(Nil)
  }
}

pub fn itemtype_decoder() -> Decoder(Itemtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "group" -> decode.success(ItemtypeGroup)
    "display" -> decode.success(ItemtypeDisplay)
    "question" -> decode.success(ItemtypeQuestion)
    "boolean" -> decode.success(ItemtypeBoolean)
    "decimal" -> decode.success(ItemtypeDecimal)
    "integer" -> decode.success(ItemtypeInteger)
    "date" -> decode.success(ItemtypeDate)
    "dateTime" -> decode.success(ItemtypeDatetime)
    "time" -> decode.success(ItemtypeTime)
    "string" -> decode.success(ItemtypeString)
    "text" -> decode.success(ItemtypeText)
    "url" -> decode.success(ItemtypeUrl)
    "coding" -> decode.success(ItemtypeCoding)
    "attachment" -> decode.success(ItemtypeAttachment)
    "reference" -> decode.success(ItemtypeReference)
    "quantity" -> decode.success(ItemtypeQuantity)
    _ -> decode.failure(ItemtypeGroup, "Itemtype")
  }
}

pub type Languages {
  LanguagesAr
  LanguagesBg
  LanguagesBgbg
  LanguagesBn
  LanguagesCs
  LanguagesCscz
  LanguagesBs
  LanguagesBsba
  LanguagesDa
  LanguagesDadk
  LanguagesDe
  LanguagesDeat
  LanguagesDech
  LanguagesDede
  LanguagesEl
  LanguagesElgr
  LanguagesEn
  LanguagesEnau
  LanguagesEnca
  LanguagesEngb
  LanguagesEnin
  LanguagesEnnz
  LanguagesEnsg
  LanguagesEnus
  LanguagesEs
  LanguagesEsar
  LanguagesEses
  LanguagesEsuy
  LanguagesEt
  LanguagesEtee
  LanguagesFi
  LanguagesFr
  LanguagesFrbe
  LanguagesFrch
  LanguagesFrfr
  LanguagesFifi
  LanguagesFrca
  LanguagesFy
  LanguagesFynl
  LanguagesHi
  LanguagesHr
  LanguagesHrhr
  LanguagesIs
  LanguagesIsis
  LanguagesIt
  LanguagesItch
  LanguagesItit
  LanguagesJa
  LanguagesKo
  LanguagesLt
  LanguagesLtlt
  LanguagesLv
  LanguagesLvlv
  LanguagesNl
  LanguagesNlbe
  LanguagesNlnl
  LanguagesNo
  LanguagesNono
  LanguagesPa
  LanguagesPl
  LanguagesPlpl
  LanguagesPt
  LanguagesPtpt
  LanguagesPtbr
  LanguagesRo
  LanguagesRoro
  LanguagesRu
  LanguagesRuru
  LanguagesSk
  LanguagesSksk
  LanguagesSl
  LanguagesSlsi
  LanguagesSr
  LanguagesSrrs
  LanguagesSv
  LanguagesSvse
  LanguagesTe
  LanguagesZh
  LanguagesZhcn
  LanguagesZhhk
  LanguagesZhsg
  LanguagesZhtw
}

pub fn languages_to_json(languages: Languages) -> Json {
  json.string(languages_to_string(languages))
}

pub fn languages_to_string(languages: Languages) -> String {
  case languages {
    LanguagesAr -> "ar"
    LanguagesBg -> "bg"
    LanguagesBgbg -> "bg-BG"
    LanguagesBn -> "bn"
    LanguagesCs -> "cs"
    LanguagesCscz -> "cs-CZ"
    LanguagesBs -> "bs"
    LanguagesBsba -> "bs-BA"
    LanguagesDa -> "da"
    LanguagesDadk -> "da-DK"
    LanguagesDe -> "de"
    LanguagesDeat -> "de-AT"
    LanguagesDech -> "de-CH"
    LanguagesDede -> "de-DE"
    LanguagesEl -> "el"
    LanguagesElgr -> "el-GR"
    LanguagesEn -> "en"
    LanguagesEnau -> "en-AU"
    LanguagesEnca -> "en-CA"
    LanguagesEngb -> "en-GB"
    LanguagesEnin -> "en-IN"
    LanguagesEnnz -> "en-NZ"
    LanguagesEnsg -> "en-SG"
    LanguagesEnus -> "en-US"
    LanguagesEs -> "es"
    LanguagesEsar -> "es-AR"
    LanguagesEses -> "es-ES"
    LanguagesEsuy -> "es-UY"
    LanguagesEt -> "et"
    LanguagesEtee -> "et-EE"
    LanguagesFi -> "fi"
    LanguagesFr -> "fr"
    LanguagesFrbe -> "fr-BE"
    LanguagesFrch -> "fr-CH"
    LanguagesFrfr -> "fr-FR"
    LanguagesFifi -> "fi-FI"
    LanguagesFrca -> "fr-CA"
    LanguagesFy -> "fy"
    LanguagesFynl -> "fy-NL"
    LanguagesHi -> "hi"
    LanguagesHr -> "hr"
    LanguagesHrhr -> "hr-HR"
    LanguagesIs -> "is"
    LanguagesIsis -> "is-IS"
    LanguagesIt -> "it"
    LanguagesItch -> "it-CH"
    LanguagesItit -> "it-IT"
    LanguagesJa -> "ja"
    LanguagesKo -> "ko"
    LanguagesLt -> "lt"
    LanguagesLtlt -> "lt-LT"
    LanguagesLv -> "lv"
    LanguagesLvlv -> "lv-LV"
    LanguagesNl -> "nl"
    LanguagesNlbe -> "nl-BE"
    LanguagesNlnl -> "nl-NL"
    LanguagesNo -> "no"
    LanguagesNono -> "no-NO"
    LanguagesPa -> "pa"
    LanguagesPl -> "pl"
    LanguagesPlpl -> "pl-PL"
    LanguagesPt -> "pt"
    LanguagesPtpt -> "pt-PT"
    LanguagesPtbr -> "pt-BR"
    LanguagesRo -> "ro"
    LanguagesRoro -> "ro-RO"
    LanguagesRu -> "ru"
    LanguagesRuru -> "ru-RU"
    LanguagesSk -> "sk"
    LanguagesSksk -> "sk-SK"
    LanguagesSl -> "sl"
    LanguagesSlsi -> "sl-SI"
    LanguagesSr -> "sr"
    LanguagesSrrs -> "sr-RS"
    LanguagesSv -> "sv"
    LanguagesSvse -> "sv-SE"
    LanguagesTe -> "te"
    LanguagesZh -> "zh"
    LanguagesZhcn -> "zh-CN"
    LanguagesZhhk -> "zh-HK"
    LanguagesZhsg -> "zh-SG"
    LanguagesZhtw -> "zh-TW"
  }
}

pub fn languages_from_string(s: String) -> Result(Languages, Nil) {
  case s {
    "ar" -> Ok(LanguagesAr)
    "bg" -> Ok(LanguagesBg)
    "bg-BG" -> Ok(LanguagesBgbg)
    "bn" -> Ok(LanguagesBn)
    "cs" -> Ok(LanguagesCs)
    "cs-CZ" -> Ok(LanguagesCscz)
    "bs" -> Ok(LanguagesBs)
    "bs-BA" -> Ok(LanguagesBsba)
    "da" -> Ok(LanguagesDa)
    "da-DK" -> Ok(LanguagesDadk)
    "de" -> Ok(LanguagesDe)
    "de-AT" -> Ok(LanguagesDeat)
    "de-CH" -> Ok(LanguagesDech)
    "de-DE" -> Ok(LanguagesDede)
    "el" -> Ok(LanguagesEl)
    "el-GR" -> Ok(LanguagesElgr)
    "en" -> Ok(LanguagesEn)
    "en-AU" -> Ok(LanguagesEnau)
    "en-CA" -> Ok(LanguagesEnca)
    "en-GB" -> Ok(LanguagesEngb)
    "en-IN" -> Ok(LanguagesEnin)
    "en-NZ" -> Ok(LanguagesEnnz)
    "en-SG" -> Ok(LanguagesEnsg)
    "en-US" -> Ok(LanguagesEnus)
    "es" -> Ok(LanguagesEs)
    "es-AR" -> Ok(LanguagesEsar)
    "es-ES" -> Ok(LanguagesEses)
    "es-UY" -> Ok(LanguagesEsuy)
    "et" -> Ok(LanguagesEt)
    "et-EE" -> Ok(LanguagesEtee)
    "fi" -> Ok(LanguagesFi)
    "fr" -> Ok(LanguagesFr)
    "fr-BE" -> Ok(LanguagesFrbe)
    "fr-CH" -> Ok(LanguagesFrch)
    "fr-FR" -> Ok(LanguagesFrfr)
    "fi-FI" -> Ok(LanguagesFifi)
    "fr-CA" -> Ok(LanguagesFrca)
    "fy" -> Ok(LanguagesFy)
    "fy-NL" -> Ok(LanguagesFynl)
    "hi" -> Ok(LanguagesHi)
    "hr" -> Ok(LanguagesHr)
    "hr-HR" -> Ok(LanguagesHrhr)
    "is" -> Ok(LanguagesIs)
    "is-IS" -> Ok(LanguagesIsis)
    "it" -> Ok(LanguagesIt)
    "it-CH" -> Ok(LanguagesItch)
    "it-IT" -> Ok(LanguagesItit)
    "ja" -> Ok(LanguagesJa)
    "ko" -> Ok(LanguagesKo)
    "lt" -> Ok(LanguagesLt)
    "lt-LT" -> Ok(LanguagesLtlt)
    "lv" -> Ok(LanguagesLv)
    "lv-LV" -> Ok(LanguagesLvlv)
    "nl" -> Ok(LanguagesNl)
    "nl-BE" -> Ok(LanguagesNlbe)
    "nl-NL" -> Ok(LanguagesNlnl)
    "no" -> Ok(LanguagesNo)
    "no-NO" -> Ok(LanguagesNono)
    "pa" -> Ok(LanguagesPa)
    "pl" -> Ok(LanguagesPl)
    "pl-PL" -> Ok(LanguagesPlpl)
    "pt" -> Ok(LanguagesPt)
    "pt-PT" -> Ok(LanguagesPtpt)
    "pt-BR" -> Ok(LanguagesPtbr)
    "ro" -> Ok(LanguagesRo)
    "ro-RO" -> Ok(LanguagesRoro)
    "ru" -> Ok(LanguagesRu)
    "ru-RU" -> Ok(LanguagesRuru)
    "sk" -> Ok(LanguagesSk)
    "sk-SK" -> Ok(LanguagesSksk)
    "sl" -> Ok(LanguagesSl)
    "sl-SI" -> Ok(LanguagesSlsi)
    "sr" -> Ok(LanguagesSr)
    "sr-RS" -> Ok(LanguagesSrrs)
    "sv" -> Ok(LanguagesSv)
    "sv-SE" -> Ok(LanguagesSvse)
    "te" -> Ok(LanguagesTe)
    "zh" -> Ok(LanguagesZh)
    "zh-CN" -> Ok(LanguagesZhcn)
    "zh-HK" -> Ok(LanguagesZhhk)
    "zh-SG" -> Ok(LanguagesZhsg)
    "zh-TW" -> Ok(LanguagesZhtw)
    _ -> Error(Nil)
  }
}

pub fn languages_decoder() -> Decoder(Languages) {
  use variant <- decode.then(decode.string)
  case variant {
    "ar" -> decode.success(LanguagesAr)
    "bg" -> decode.success(LanguagesBg)
    "bg-BG" -> decode.success(LanguagesBgbg)
    "bn" -> decode.success(LanguagesBn)
    "cs" -> decode.success(LanguagesCs)
    "cs-CZ" -> decode.success(LanguagesCscz)
    "bs" -> decode.success(LanguagesBs)
    "bs-BA" -> decode.success(LanguagesBsba)
    "da" -> decode.success(LanguagesDa)
    "da-DK" -> decode.success(LanguagesDadk)
    "de" -> decode.success(LanguagesDe)
    "de-AT" -> decode.success(LanguagesDeat)
    "de-CH" -> decode.success(LanguagesDech)
    "de-DE" -> decode.success(LanguagesDede)
    "el" -> decode.success(LanguagesEl)
    "el-GR" -> decode.success(LanguagesElgr)
    "en" -> decode.success(LanguagesEn)
    "en-AU" -> decode.success(LanguagesEnau)
    "en-CA" -> decode.success(LanguagesEnca)
    "en-GB" -> decode.success(LanguagesEngb)
    "en-IN" -> decode.success(LanguagesEnin)
    "en-NZ" -> decode.success(LanguagesEnnz)
    "en-SG" -> decode.success(LanguagesEnsg)
    "en-US" -> decode.success(LanguagesEnus)
    "es" -> decode.success(LanguagesEs)
    "es-AR" -> decode.success(LanguagesEsar)
    "es-ES" -> decode.success(LanguagesEses)
    "es-UY" -> decode.success(LanguagesEsuy)
    "et" -> decode.success(LanguagesEt)
    "et-EE" -> decode.success(LanguagesEtee)
    "fi" -> decode.success(LanguagesFi)
    "fr" -> decode.success(LanguagesFr)
    "fr-BE" -> decode.success(LanguagesFrbe)
    "fr-CH" -> decode.success(LanguagesFrch)
    "fr-FR" -> decode.success(LanguagesFrfr)
    "fi-FI" -> decode.success(LanguagesFifi)
    "fr-CA" -> decode.success(LanguagesFrca)
    "fy" -> decode.success(LanguagesFy)
    "fy-NL" -> decode.success(LanguagesFynl)
    "hi" -> decode.success(LanguagesHi)
    "hr" -> decode.success(LanguagesHr)
    "hr-HR" -> decode.success(LanguagesHrhr)
    "is" -> decode.success(LanguagesIs)
    "is-IS" -> decode.success(LanguagesIsis)
    "it" -> decode.success(LanguagesIt)
    "it-CH" -> decode.success(LanguagesItch)
    "it-IT" -> decode.success(LanguagesItit)
    "ja" -> decode.success(LanguagesJa)
    "ko" -> decode.success(LanguagesKo)
    "lt" -> decode.success(LanguagesLt)
    "lt-LT" -> decode.success(LanguagesLtlt)
    "lv" -> decode.success(LanguagesLv)
    "lv-LV" -> decode.success(LanguagesLvlv)
    "nl" -> decode.success(LanguagesNl)
    "nl-BE" -> decode.success(LanguagesNlbe)
    "nl-NL" -> decode.success(LanguagesNlnl)
    "no" -> decode.success(LanguagesNo)
    "no-NO" -> decode.success(LanguagesNono)
    "pa" -> decode.success(LanguagesPa)
    "pl" -> decode.success(LanguagesPl)
    "pl-PL" -> decode.success(LanguagesPlpl)
    "pt" -> decode.success(LanguagesPt)
    "pt-PT" -> decode.success(LanguagesPtpt)
    "pt-BR" -> decode.success(LanguagesPtbr)
    "ro" -> decode.success(LanguagesRo)
    "ro-RO" -> decode.success(LanguagesRoro)
    "ru" -> decode.success(LanguagesRu)
    "ru-RU" -> decode.success(LanguagesRuru)
    "sk" -> decode.success(LanguagesSk)
    "sk-SK" -> decode.success(LanguagesSksk)
    "sl" -> decode.success(LanguagesSl)
    "sl-SI" -> decode.success(LanguagesSlsi)
    "sr" -> decode.success(LanguagesSr)
    "sr-RS" -> decode.success(LanguagesSrrs)
    "sv" -> decode.success(LanguagesSv)
    "sv-SE" -> decode.success(LanguagesSvse)
    "te" -> decode.success(LanguagesTe)
    "zh" -> decode.success(LanguagesZh)
    "zh-CN" -> decode.success(LanguagesZhcn)
    "zh-HK" -> decode.success(LanguagesZhhk)
    "zh-SG" -> decode.success(LanguagesZhsg)
    "zh-TW" -> decode.success(LanguagesZhtw)
    _ -> decode.failure(LanguagesAr, "Languages")
  }
}

pub type Linkagetype {
  LinkagetypeSource
  LinkagetypeAlternate
  LinkagetypeHistorical
}

pub fn linkagetype_to_json(linkagetype: Linkagetype) -> Json {
  json.string(linkagetype_to_string(linkagetype))
}

pub fn linkagetype_to_string(linkagetype: Linkagetype) -> String {
  case linkagetype {
    LinkagetypeSource -> "source"
    LinkagetypeAlternate -> "alternate"
    LinkagetypeHistorical -> "historical"
  }
}

pub fn linkagetype_from_string(s: String) -> Result(Linkagetype, Nil) {
  case s {
    "source" -> Ok(LinkagetypeSource)
    "alternate" -> Ok(LinkagetypeAlternate)
    "historical" -> Ok(LinkagetypeHistorical)
    _ -> Error(Nil)
  }
}

pub fn linkagetype_decoder() -> Decoder(Linkagetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "source" -> decode.success(LinkagetypeSource)
    "alternate" -> decode.success(LinkagetypeAlternate)
    "historical" -> decode.success(LinkagetypeHistorical)
    _ -> decode.failure(LinkagetypeSource, "Linkagetype")
  }
}

pub type Linktype {
  LinktypeReplacedby
  LinktypeReplaces
  LinktypeRefer
  LinktypeSeealso
}

pub fn linktype_to_json(linktype: Linktype) -> Json {
  json.string(linktype_to_string(linktype))
}

pub fn linktype_to_string(linktype: Linktype) -> String {
  case linktype {
    LinktypeReplacedby -> "replaced-by"
    LinktypeReplaces -> "replaces"
    LinktypeRefer -> "refer"
    LinktypeSeealso -> "seealso"
  }
}

pub fn linktype_from_string(s: String) -> Result(Linktype, Nil) {
  case s {
    "replaced-by" -> Ok(LinktypeReplacedby)
    "replaces" -> Ok(LinktypeReplaces)
    "refer" -> Ok(LinktypeRefer)
    "seealso" -> Ok(LinktypeSeealso)
    _ -> Error(Nil)
  }
}

pub fn linktype_decoder() -> Decoder(Linktype) {
  use variant <- decode.then(decode.string)
  case variant {
    "replaced-by" -> decode.success(LinktypeReplacedby)
    "replaces" -> decode.success(LinktypeReplaces)
    "refer" -> decode.success(LinktypeRefer)
    "seealso" -> decode.success(LinktypeSeealso)
    _ -> decode.failure(LinktypeReplacedby, "Linktype")
  }
}

pub type Listmode {
  ListmodeWorking
  ListmodeSnapshot
  ListmodeChanges
}

pub fn listmode_to_json(listmode: Listmode) -> Json {
  json.string(listmode_to_string(listmode))
}

pub fn listmode_to_string(listmode: Listmode) -> String {
  case listmode {
    ListmodeWorking -> "working"
    ListmodeSnapshot -> "snapshot"
    ListmodeChanges -> "changes"
  }
}

pub fn listmode_from_string(s: String) -> Result(Listmode, Nil) {
  case s {
    "working" -> Ok(ListmodeWorking)
    "snapshot" -> Ok(ListmodeSnapshot)
    "changes" -> Ok(ListmodeChanges)
    _ -> Error(Nil)
  }
}

pub fn listmode_decoder() -> Decoder(Listmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "working" -> decode.success(ListmodeWorking)
    "snapshot" -> decode.success(ListmodeSnapshot)
    "changes" -> decode.success(ListmodeChanges)
    _ -> decode.failure(ListmodeWorking, "Listmode")
  }
}

pub type Liststatus {
  ListstatusCurrent
  ListstatusRetired
  ListstatusEnteredinerror
}

pub fn liststatus_to_json(liststatus: Liststatus) -> Json {
  json.string(liststatus_to_string(liststatus))
}

pub fn liststatus_to_string(liststatus: Liststatus) -> String {
  case liststatus {
    ListstatusCurrent -> "current"
    ListstatusRetired -> "retired"
    ListstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn liststatus_from_string(s: String) -> Result(Liststatus, Nil) {
  case s {
    "current" -> Ok(ListstatusCurrent)
    "retired" -> Ok(ListstatusRetired)
    "entered-in-error" -> Ok(ListstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn liststatus_decoder() -> Decoder(Liststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "current" -> decode.success(ListstatusCurrent)
    "retired" -> decode.success(ListstatusRetired)
    "entered-in-error" -> decode.success(ListstatusEnteredinerror)
    _ -> decode.failure(ListstatusCurrent, "Liststatus")
  }
}

pub type Locationmode {
  LocationmodeInstance
  LocationmodeKind
}

pub fn locationmode_to_json(locationmode: Locationmode) -> Json {
  json.string(locationmode_to_string(locationmode))
}

pub fn locationmode_to_string(locationmode: Locationmode) -> String {
  case locationmode {
    LocationmodeInstance -> "instance"
    LocationmodeKind -> "kind"
  }
}

pub fn locationmode_from_string(s: String) -> Result(Locationmode, Nil) {
  case s {
    "instance" -> Ok(LocationmodeInstance)
    "kind" -> Ok(LocationmodeKind)
    _ -> Error(Nil)
  }
}

pub fn locationmode_decoder() -> Decoder(Locationmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "instance" -> decode.success(LocationmodeInstance)
    "kind" -> decode.success(LocationmodeKind)
    _ -> decode.failure(LocationmodeInstance, "Locationmode")
  }
}

pub type Locationstatus {
  LocationstatusActive
  LocationstatusSuspended
  LocationstatusInactive
}

pub fn locationstatus_to_json(locationstatus: Locationstatus) -> Json {
  json.string(locationstatus_to_string(locationstatus))
}

pub fn locationstatus_to_string(locationstatus: Locationstatus) -> String {
  case locationstatus {
    LocationstatusActive -> "active"
    LocationstatusSuspended -> "suspended"
    LocationstatusInactive -> "inactive"
  }
}

pub fn locationstatus_from_string(s: String) -> Result(Locationstatus, Nil) {
  case s {
    "active" -> Ok(LocationstatusActive)
    "suspended" -> Ok(LocationstatusSuspended)
    "inactive" -> Ok(LocationstatusInactive)
    _ -> Error(Nil)
  }
}

pub fn locationstatus_decoder() -> Decoder(Locationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(LocationstatusActive)
    "suspended" -> decode.success(LocationstatusSuspended)
    "inactive" -> decode.success(LocationstatusInactive)
    _ -> decode.failure(LocationstatusActive, "Locationstatus")
  }
}

pub type Mapgrouptypemode {
  MapgrouptypemodeTypes
  MapgrouptypemodeTypeandtypes
}

pub fn mapgrouptypemode_to_json(mapgrouptypemode: Mapgrouptypemode) -> Json {
  json.string(mapgrouptypemode_to_string(mapgrouptypemode))
}

pub fn mapgrouptypemode_to_string(mapgrouptypemode: Mapgrouptypemode) -> String {
  case mapgrouptypemode {
    MapgrouptypemodeTypes -> "types"
    MapgrouptypemodeTypeandtypes -> "type-and-types"
  }
}

pub fn mapgrouptypemode_from_string(s: String) -> Result(Mapgrouptypemode, Nil) {
  case s {
    "types" -> Ok(MapgrouptypemodeTypes)
    "type-and-types" -> Ok(MapgrouptypemodeTypeandtypes)
    _ -> Error(Nil)
  }
}

pub fn mapgrouptypemode_decoder() -> Decoder(Mapgrouptypemode) {
  use variant <- decode.then(decode.string)
  case variant {
    "types" -> decode.success(MapgrouptypemodeTypes)
    "type-and-types" -> decode.success(MapgrouptypemodeTypeandtypes)
    _ -> decode.failure(MapgrouptypemodeTypes, "Mapgrouptypemode")
  }
}

pub type Mapinputmode {
  MapinputmodeSource
  MapinputmodeTarget
}

pub fn mapinputmode_to_json(mapinputmode: Mapinputmode) -> Json {
  json.string(mapinputmode_to_string(mapinputmode))
}

pub fn mapinputmode_to_string(mapinputmode: Mapinputmode) -> String {
  case mapinputmode {
    MapinputmodeSource -> "source"
    MapinputmodeTarget -> "target"
  }
}

pub fn mapinputmode_from_string(s: String) -> Result(Mapinputmode, Nil) {
  case s {
    "source" -> Ok(MapinputmodeSource)
    "target" -> Ok(MapinputmodeTarget)
    _ -> Error(Nil)
  }
}

pub fn mapinputmode_decoder() -> Decoder(Mapinputmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "source" -> decode.success(MapinputmodeSource)
    "target" -> decode.success(MapinputmodeTarget)
    _ -> decode.failure(MapinputmodeSource, "Mapinputmode")
  }
}

pub type Mapmodelmode {
  MapmodelmodeSource
  MapmodelmodeQueried
  MapmodelmodeTarget
  MapmodelmodeProduced
}

pub fn mapmodelmode_to_json(mapmodelmode: Mapmodelmode) -> Json {
  json.string(mapmodelmode_to_string(mapmodelmode))
}

pub fn mapmodelmode_to_string(mapmodelmode: Mapmodelmode) -> String {
  case mapmodelmode {
    MapmodelmodeSource -> "source"
    MapmodelmodeQueried -> "queried"
    MapmodelmodeTarget -> "target"
    MapmodelmodeProduced -> "produced"
  }
}

pub fn mapmodelmode_from_string(s: String) -> Result(Mapmodelmode, Nil) {
  case s {
    "source" -> Ok(MapmodelmodeSource)
    "queried" -> Ok(MapmodelmodeQueried)
    "target" -> Ok(MapmodelmodeTarget)
    "produced" -> Ok(MapmodelmodeProduced)
    _ -> Error(Nil)
  }
}

pub fn mapmodelmode_decoder() -> Decoder(Mapmodelmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "source" -> decode.success(MapmodelmodeSource)
    "queried" -> decode.success(MapmodelmodeQueried)
    "target" -> decode.success(MapmodelmodeTarget)
    "produced" -> decode.success(MapmodelmodeProduced)
    _ -> decode.failure(MapmodelmodeSource, "Mapmodelmode")
  }
}

pub type Mapsourcelistmode {
  MapsourcelistmodeFirst
  MapsourcelistmodeNotfirst
  MapsourcelistmodeLast
  MapsourcelistmodeNotlast
  MapsourcelistmodeOnlyone
}

pub fn mapsourcelistmode_to_json(mapsourcelistmode: Mapsourcelistmode) -> Json {
  json.string(mapsourcelistmode_to_string(mapsourcelistmode))
}

pub fn mapsourcelistmode_to_string(
  mapsourcelistmode: Mapsourcelistmode,
) -> String {
  case mapsourcelistmode {
    MapsourcelistmodeFirst -> "first"
    MapsourcelistmodeNotfirst -> "not_first"
    MapsourcelistmodeLast -> "last"
    MapsourcelistmodeNotlast -> "not_last"
    MapsourcelistmodeOnlyone -> "only_one"
  }
}

pub fn mapsourcelistmode_from_string(
  s: String,
) -> Result(Mapsourcelistmode, Nil) {
  case s {
    "first" -> Ok(MapsourcelistmodeFirst)
    "not_first" -> Ok(MapsourcelistmodeNotfirst)
    "last" -> Ok(MapsourcelistmodeLast)
    "not_last" -> Ok(MapsourcelistmodeNotlast)
    "only_one" -> Ok(MapsourcelistmodeOnlyone)
    _ -> Error(Nil)
  }
}

pub fn mapsourcelistmode_decoder() -> Decoder(Mapsourcelistmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "first" -> decode.success(MapsourcelistmodeFirst)
    "not_first" -> decode.success(MapsourcelistmodeNotfirst)
    "last" -> decode.success(MapsourcelistmodeLast)
    "not_last" -> decode.success(MapsourcelistmodeNotlast)
    "only_one" -> decode.success(MapsourcelistmodeOnlyone)
    _ -> decode.failure(MapsourcelistmodeFirst, "Mapsourcelistmode")
  }
}

pub type Maptargetlistmode {
  MaptargetlistmodeFirst
  MaptargetlistmodeShare
  MaptargetlistmodeLast
  MaptargetlistmodeSingle
}

pub fn maptargetlistmode_to_json(maptargetlistmode: Maptargetlistmode) -> Json {
  json.string(maptargetlistmode_to_string(maptargetlistmode))
}

pub fn maptargetlistmode_to_string(
  maptargetlistmode: Maptargetlistmode,
) -> String {
  case maptargetlistmode {
    MaptargetlistmodeFirst -> "first"
    MaptargetlistmodeShare -> "share"
    MaptargetlistmodeLast -> "last"
    MaptargetlistmodeSingle -> "single"
  }
}

pub fn maptargetlistmode_from_string(
  s: String,
) -> Result(Maptargetlistmode, Nil) {
  case s {
    "first" -> Ok(MaptargetlistmodeFirst)
    "share" -> Ok(MaptargetlistmodeShare)
    "last" -> Ok(MaptargetlistmodeLast)
    "single" -> Ok(MaptargetlistmodeSingle)
    _ -> Error(Nil)
  }
}

pub fn maptargetlistmode_decoder() -> Decoder(Maptargetlistmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "first" -> decode.success(MaptargetlistmodeFirst)
    "share" -> decode.success(MaptargetlistmodeShare)
    "last" -> decode.success(MaptargetlistmodeLast)
    "single" -> decode.success(MaptargetlistmodeSingle)
    _ -> decode.failure(MaptargetlistmodeFirst, "Maptargetlistmode")
  }
}

pub type Maptransform {
  MaptransformCreate
  MaptransformCopy
  MaptransformTruncate
  MaptransformEscape
  MaptransformCast
  MaptransformAppend
  MaptransformTranslate
  MaptransformReference
  MaptransformDateop
  MaptransformUuid
  MaptransformPointer
  MaptransformEvaluate
  MaptransformCc
  MaptransformC
  MaptransformQty
  MaptransformId
  MaptransformCp
}

pub fn maptransform_to_json(maptransform: Maptransform) -> Json {
  json.string(maptransform_to_string(maptransform))
}

pub fn maptransform_to_string(maptransform: Maptransform) -> String {
  case maptransform {
    MaptransformCreate -> "create"
    MaptransformCopy -> "copy"
    MaptransformTruncate -> "truncate"
    MaptransformEscape -> "escape"
    MaptransformCast -> "cast"
    MaptransformAppend -> "append"
    MaptransformTranslate -> "translate"
    MaptransformReference -> "reference"
    MaptransformDateop -> "dateOp"
    MaptransformUuid -> "uuid"
    MaptransformPointer -> "pointer"
    MaptransformEvaluate -> "evaluate"
    MaptransformCc -> "cc"
    MaptransformC -> "c"
    MaptransformQty -> "qty"
    MaptransformId -> "id"
    MaptransformCp -> "cp"
  }
}

pub fn maptransform_from_string(s: String) -> Result(Maptransform, Nil) {
  case s {
    "create" -> Ok(MaptransformCreate)
    "copy" -> Ok(MaptransformCopy)
    "truncate" -> Ok(MaptransformTruncate)
    "escape" -> Ok(MaptransformEscape)
    "cast" -> Ok(MaptransformCast)
    "append" -> Ok(MaptransformAppend)
    "translate" -> Ok(MaptransformTranslate)
    "reference" -> Ok(MaptransformReference)
    "dateOp" -> Ok(MaptransformDateop)
    "uuid" -> Ok(MaptransformUuid)
    "pointer" -> Ok(MaptransformPointer)
    "evaluate" -> Ok(MaptransformEvaluate)
    "cc" -> Ok(MaptransformCc)
    "c" -> Ok(MaptransformC)
    "qty" -> Ok(MaptransformQty)
    "id" -> Ok(MaptransformId)
    "cp" -> Ok(MaptransformCp)
    _ -> Error(Nil)
  }
}

pub fn maptransform_decoder() -> Decoder(Maptransform) {
  use variant <- decode.then(decode.string)
  case variant {
    "create" -> decode.success(MaptransformCreate)
    "copy" -> decode.success(MaptransformCopy)
    "truncate" -> decode.success(MaptransformTruncate)
    "escape" -> decode.success(MaptransformEscape)
    "cast" -> decode.success(MaptransformCast)
    "append" -> decode.success(MaptransformAppend)
    "translate" -> decode.success(MaptransformTranslate)
    "reference" -> decode.success(MaptransformReference)
    "dateOp" -> decode.success(MaptransformDateop)
    "uuid" -> decode.success(MaptransformUuid)
    "pointer" -> decode.success(MaptransformPointer)
    "evaluate" -> decode.success(MaptransformEvaluate)
    "cc" -> decode.success(MaptransformCc)
    "c" -> decode.success(MaptransformC)
    "qty" -> decode.success(MaptransformQty)
    "id" -> decode.success(MaptransformId)
    "cp" -> decode.success(MaptransformCp)
    _ -> decode.failure(MaptransformCreate, "Maptransform")
  }
}

pub type Measurereportstatus {
  MeasurereportstatusComplete
  MeasurereportstatusPending
  MeasurereportstatusError
}

pub fn measurereportstatus_to_json(
  measurereportstatus: Measurereportstatus,
) -> Json {
  json.string(measurereportstatus_to_string(measurereportstatus))
}

pub fn measurereportstatus_to_string(
  measurereportstatus: Measurereportstatus,
) -> String {
  case measurereportstatus {
    MeasurereportstatusComplete -> "complete"
    MeasurereportstatusPending -> "pending"
    MeasurereportstatusError -> "error"
  }
}

pub fn measurereportstatus_from_string(
  s: String,
) -> Result(Measurereportstatus, Nil) {
  case s {
    "complete" -> Ok(MeasurereportstatusComplete)
    "pending" -> Ok(MeasurereportstatusPending)
    "error" -> Ok(MeasurereportstatusError)
    _ -> Error(Nil)
  }
}

pub fn measurereportstatus_decoder() -> Decoder(Measurereportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "complete" -> decode.success(MeasurereportstatusComplete)
    "pending" -> decode.success(MeasurereportstatusPending)
    "error" -> decode.success(MeasurereportstatusError)
    _ -> decode.failure(MeasurereportstatusComplete, "Measurereportstatus")
  }
}

pub type Measurereporttype {
  MeasurereporttypeIndividual
  MeasurereporttypeSubjectlist
  MeasurereporttypeSummary
  MeasurereporttypeDataexchange
}

pub fn measurereporttype_to_json(measurereporttype: Measurereporttype) -> Json {
  json.string(measurereporttype_to_string(measurereporttype))
}

pub fn measurereporttype_to_string(
  measurereporttype: Measurereporttype,
) -> String {
  case measurereporttype {
    MeasurereporttypeIndividual -> "individual"
    MeasurereporttypeSubjectlist -> "subject-list"
    MeasurereporttypeSummary -> "summary"
    MeasurereporttypeDataexchange -> "data-exchange"
  }
}

pub fn measurereporttype_from_string(
  s: String,
) -> Result(Measurereporttype, Nil) {
  case s {
    "individual" -> Ok(MeasurereporttypeIndividual)
    "subject-list" -> Ok(MeasurereporttypeSubjectlist)
    "summary" -> Ok(MeasurereporttypeSummary)
    "data-exchange" -> Ok(MeasurereporttypeDataexchange)
    _ -> Error(Nil)
  }
}

pub fn measurereporttype_decoder() -> Decoder(Measurereporttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "individual" -> decode.success(MeasurereporttypeIndividual)
    "subject-list" -> decode.success(MeasurereporttypeSubjectlist)
    "summary" -> decode.success(MeasurereporttypeSummary)
    "data-exchange" -> decode.success(MeasurereporttypeDataexchange)
    _ -> decode.failure(MeasurereporttypeIndividual, "Measurereporttype")
  }
}

pub type Medicationadminstatus {
  MedicationadminstatusInprogress
  MedicationadminstatusNotdone
  MedicationadminstatusOnhold
  MedicationadminstatusCompleted
  MedicationadminstatusEnteredinerror
  MedicationadminstatusStopped
  MedicationadminstatusUnknown
}

pub fn medicationadminstatus_to_json(
  medicationadminstatus: Medicationadminstatus,
) -> Json {
  json.string(medicationadminstatus_to_string(medicationadminstatus))
}

pub fn medicationadminstatus_to_string(
  medicationadminstatus: Medicationadminstatus,
) -> String {
  case medicationadminstatus {
    MedicationadminstatusInprogress -> "in-progress"
    MedicationadminstatusNotdone -> "not-done"
    MedicationadminstatusOnhold -> "on-hold"
    MedicationadminstatusCompleted -> "completed"
    MedicationadminstatusEnteredinerror -> "entered-in-error"
    MedicationadminstatusStopped -> "stopped"
    MedicationadminstatusUnknown -> "unknown"
  }
}

pub fn medicationadminstatus_from_string(
  s: String,
) -> Result(Medicationadminstatus, Nil) {
  case s {
    "in-progress" -> Ok(MedicationadminstatusInprogress)
    "not-done" -> Ok(MedicationadminstatusNotdone)
    "on-hold" -> Ok(MedicationadminstatusOnhold)
    "completed" -> Ok(MedicationadminstatusCompleted)
    "entered-in-error" -> Ok(MedicationadminstatusEnteredinerror)
    "stopped" -> Ok(MedicationadminstatusStopped)
    "unknown" -> Ok(MedicationadminstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn medicationadminstatus_decoder() -> Decoder(Medicationadminstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(MedicationadminstatusInprogress)
    "not-done" -> decode.success(MedicationadminstatusNotdone)
    "on-hold" -> decode.success(MedicationadminstatusOnhold)
    "completed" -> decode.success(MedicationadminstatusCompleted)
    "entered-in-error" -> decode.success(MedicationadminstatusEnteredinerror)
    "stopped" -> decode.success(MedicationadminstatusStopped)
    "unknown" -> decode.success(MedicationadminstatusUnknown)
    _ ->
      decode.failure(MedicationadminstatusInprogress, "Medicationadminstatus")
  }
}

pub type Medicationdispensestatus {
  MedicationdispensestatusPreparation
  MedicationdispensestatusInprogress
  MedicationdispensestatusCancelled
  MedicationdispensestatusOnhold
  MedicationdispensestatusCompleted
  MedicationdispensestatusEnteredinerror
  MedicationdispensestatusStopped
  MedicationdispensestatusDeclined
  MedicationdispensestatusUnknown
}

pub fn medicationdispensestatus_to_json(
  medicationdispensestatus: Medicationdispensestatus,
) -> Json {
  json.string(medicationdispensestatus_to_string(medicationdispensestatus))
}

pub fn medicationdispensestatus_to_string(
  medicationdispensestatus: Medicationdispensestatus,
) -> String {
  case medicationdispensestatus {
    MedicationdispensestatusPreparation -> "preparation"
    MedicationdispensestatusInprogress -> "in-progress"
    MedicationdispensestatusCancelled -> "cancelled"
    MedicationdispensestatusOnhold -> "on-hold"
    MedicationdispensestatusCompleted -> "completed"
    MedicationdispensestatusEnteredinerror -> "entered-in-error"
    MedicationdispensestatusStopped -> "stopped"
    MedicationdispensestatusDeclined -> "declined"
    MedicationdispensestatusUnknown -> "unknown"
  }
}

pub fn medicationdispensestatus_from_string(
  s: String,
) -> Result(Medicationdispensestatus, Nil) {
  case s {
    "preparation" -> Ok(MedicationdispensestatusPreparation)
    "in-progress" -> Ok(MedicationdispensestatusInprogress)
    "cancelled" -> Ok(MedicationdispensestatusCancelled)
    "on-hold" -> Ok(MedicationdispensestatusOnhold)
    "completed" -> Ok(MedicationdispensestatusCompleted)
    "entered-in-error" -> Ok(MedicationdispensestatusEnteredinerror)
    "stopped" -> Ok(MedicationdispensestatusStopped)
    "declined" -> Ok(MedicationdispensestatusDeclined)
    "unknown" -> Ok(MedicationdispensestatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn medicationdispensestatus_decoder() -> Decoder(Medicationdispensestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "preparation" -> decode.success(MedicationdispensestatusPreparation)
    "in-progress" -> decode.success(MedicationdispensestatusInprogress)
    "cancelled" -> decode.success(MedicationdispensestatusCancelled)
    "on-hold" -> decode.success(MedicationdispensestatusOnhold)
    "completed" -> decode.success(MedicationdispensestatusCompleted)
    "entered-in-error" -> decode.success(MedicationdispensestatusEnteredinerror)
    "stopped" -> decode.success(MedicationdispensestatusStopped)
    "declined" -> decode.success(MedicationdispensestatusDeclined)
    "unknown" -> decode.success(MedicationdispensestatusUnknown)
    _ ->
      decode.failure(
        MedicationdispensestatusPreparation,
        "Medicationdispensestatus",
      )
  }
}

pub type Medicationknowledgestatus {
  MedicationknowledgestatusActive
  MedicationknowledgestatusEnteredinerror
  MedicationknowledgestatusInactive
}

pub fn medicationknowledgestatus_to_json(
  medicationknowledgestatus: Medicationknowledgestatus,
) -> Json {
  json.string(medicationknowledgestatus_to_string(medicationknowledgestatus))
}

pub fn medicationknowledgestatus_to_string(
  medicationknowledgestatus: Medicationknowledgestatus,
) -> String {
  case medicationknowledgestatus {
    MedicationknowledgestatusActive -> "active"
    MedicationknowledgestatusEnteredinerror -> "entered-in-error"
    MedicationknowledgestatusInactive -> "inactive"
  }
}

pub fn medicationknowledgestatus_from_string(
  s: String,
) -> Result(Medicationknowledgestatus, Nil) {
  case s {
    "active" -> Ok(MedicationknowledgestatusActive)
    "entered-in-error" -> Ok(MedicationknowledgestatusEnteredinerror)
    "inactive" -> Ok(MedicationknowledgestatusInactive)
    _ -> Error(Nil)
  }
}

pub fn medicationknowledgestatus_decoder() -> Decoder(Medicationknowledgestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(MedicationknowledgestatusActive)
    "entered-in-error" ->
      decode.success(MedicationknowledgestatusEnteredinerror)
    "inactive" -> decode.success(MedicationknowledgestatusInactive)
    _ ->
      decode.failure(
        MedicationknowledgestatusActive,
        "Medicationknowledgestatus",
      )
  }
}

pub type Medicationrequestintent {
  MedicationrequestintentProposal
  MedicationrequestintentPlan
  MedicationrequestintentOrder
  MedicationrequestintentOriginalorder
  MedicationrequestintentReflexorder
  MedicationrequestintentFillerorder
  MedicationrequestintentInstanceorder
  MedicationrequestintentOption
}

pub fn medicationrequestintent_to_json(
  medicationrequestintent: Medicationrequestintent,
) -> Json {
  json.string(medicationrequestintent_to_string(medicationrequestintent))
}

pub fn medicationrequestintent_to_string(
  medicationrequestintent: Medicationrequestintent,
) -> String {
  case medicationrequestintent {
    MedicationrequestintentProposal -> "proposal"
    MedicationrequestintentPlan -> "plan"
    MedicationrequestintentOrder -> "order"
    MedicationrequestintentOriginalorder -> "original-order"
    MedicationrequestintentReflexorder -> "reflex-order"
    MedicationrequestintentFillerorder -> "filler-order"
    MedicationrequestintentInstanceorder -> "instance-order"
    MedicationrequestintentOption -> "option"
  }
}

pub fn medicationrequestintent_from_string(
  s: String,
) -> Result(Medicationrequestintent, Nil) {
  case s {
    "proposal" -> Ok(MedicationrequestintentProposal)
    "plan" -> Ok(MedicationrequestintentPlan)
    "order" -> Ok(MedicationrequestintentOrder)
    "original-order" -> Ok(MedicationrequestintentOriginalorder)
    "reflex-order" -> Ok(MedicationrequestintentReflexorder)
    "filler-order" -> Ok(MedicationrequestintentFillerorder)
    "instance-order" -> Ok(MedicationrequestintentInstanceorder)
    "option" -> Ok(MedicationrequestintentOption)
    _ -> Error(Nil)
  }
}

pub fn medicationrequestintent_decoder() -> Decoder(Medicationrequestintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposal" -> decode.success(MedicationrequestintentProposal)
    "plan" -> decode.success(MedicationrequestintentPlan)
    "order" -> decode.success(MedicationrequestintentOrder)
    "original-order" -> decode.success(MedicationrequestintentOriginalorder)
    "reflex-order" -> decode.success(MedicationrequestintentReflexorder)
    "filler-order" -> decode.success(MedicationrequestintentFillerorder)
    "instance-order" -> decode.success(MedicationrequestintentInstanceorder)
    "option" -> decode.success(MedicationrequestintentOption)
    _ ->
      decode.failure(MedicationrequestintentProposal, "Medicationrequestintent")
  }
}

pub type Medicationrequeststatus {
  MedicationrequeststatusActive
  MedicationrequeststatusOnhold
  MedicationrequeststatusEnded
  MedicationrequeststatusStopped
  MedicationrequeststatusCompleted
  MedicationrequeststatusCancelled
  MedicationrequeststatusEnteredinerror
  MedicationrequeststatusDraft
  MedicationrequeststatusUnknown
}

pub fn medicationrequeststatus_to_json(
  medicationrequeststatus: Medicationrequeststatus,
) -> Json {
  json.string(medicationrequeststatus_to_string(medicationrequeststatus))
}

pub fn medicationrequeststatus_to_string(
  medicationrequeststatus: Medicationrequeststatus,
) -> String {
  case medicationrequeststatus {
    MedicationrequeststatusActive -> "active"
    MedicationrequeststatusOnhold -> "on-hold"
    MedicationrequeststatusEnded -> "ended"
    MedicationrequeststatusStopped -> "stopped"
    MedicationrequeststatusCompleted -> "completed"
    MedicationrequeststatusCancelled -> "cancelled"
    MedicationrequeststatusEnteredinerror -> "entered-in-error"
    MedicationrequeststatusDraft -> "draft"
    MedicationrequeststatusUnknown -> "unknown"
  }
}

pub fn medicationrequeststatus_from_string(
  s: String,
) -> Result(Medicationrequeststatus, Nil) {
  case s {
    "active" -> Ok(MedicationrequeststatusActive)
    "on-hold" -> Ok(MedicationrequeststatusOnhold)
    "ended" -> Ok(MedicationrequeststatusEnded)
    "stopped" -> Ok(MedicationrequeststatusStopped)
    "completed" -> Ok(MedicationrequeststatusCompleted)
    "cancelled" -> Ok(MedicationrequeststatusCancelled)
    "entered-in-error" -> Ok(MedicationrequeststatusEnteredinerror)
    "draft" -> Ok(MedicationrequeststatusDraft)
    "unknown" -> Ok(MedicationrequeststatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn medicationrequeststatus_decoder() -> Decoder(Medicationrequeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(MedicationrequeststatusActive)
    "on-hold" -> decode.success(MedicationrequeststatusOnhold)
    "ended" -> decode.success(MedicationrequeststatusEnded)
    "stopped" -> decode.success(MedicationrequeststatusStopped)
    "completed" -> decode.success(MedicationrequeststatusCompleted)
    "cancelled" -> decode.success(MedicationrequeststatusCancelled)
    "entered-in-error" -> decode.success(MedicationrequeststatusEnteredinerror)
    "draft" -> decode.success(MedicationrequeststatusDraft)
    "unknown" -> decode.success(MedicationrequeststatusUnknown)
    _ ->
      decode.failure(MedicationrequeststatusActive, "Medicationrequeststatus")
  }
}

pub type Medicationstatementstatus {
  MedicationstatementstatusRecorded
  MedicationstatementstatusEnteredinerror
  MedicationstatementstatusDraft
}

pub fn medicationstatementstatus_to_json(
  medicationstatementstatus: Medicationstatementstatus,
) -> Json {
  json.string(medicationstatementstatus_to_string(medicationstatementstatus))
}

pub fn medicationstatementstatus_to_string(
  medicationstatementstatus: Medicationstatementstatus,
) -> String {
  case medicationstatementstatus {
    MedicationstatementstatusRecorded -> "recorded"
    MedicationstatementstatusEnteredinerror -> "entered-in-error"
    MedicationstatementstatusDraft -> "draft"
  }
}

pub fn medicationstatementstatus_from_string(
  s: String,
) -> Result(Medicationstatementstatus, Nil) {
  case s {
    "recorded" -> Ok(MedicationstatementstatusRecorded)
    "entered-in-error" -> Ok(MedicationstatementstatusEnteredinerror)
    "draft" -> Ok(MedicationstatementstatusDraft)
    _ -> Error(Nil)
  }
}

pub fn medicationstatementstatus_decoder() -> Decoder(Medicationstatementstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "recorded" -> decode.success(MedicationstatementstatusRecorded)
    "entered-in-error" ->
      decode.success(MedicationstatementstatusEnteredinerror)
    "draft" -> decode.success(MedicationstatementstatusDraft)
    _ ->
      decode.failure(
        MedicationstatementstatusRecorded,
        "Medicationstatementstatus",
      )
  }
}

pub type Medicationstatus {
  MedicationstatusActive
  MedicationstatusInactive
  MedicationstatusEnteredinerror
}

pub fn medicationstatus_to_json(medicationstatus: Medicationstatus) -> Json {
  json.string(medicationstatus_to_string(medicationstatus))
}

pub fn medicationstatus_to_string(medicationstatus: Medicationstatus) -> String {
  case medicationstatus {
    MedicationstatusActive -> "active"
    MedicationstatusInactive -> "inactive"
    MedicationstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn medicationstatus_from_string(s: String) -> Result(Medicationstatus, Nil) {
  case s {
    "active" -> Ok(MedicationstatusActive)
    "inactive" -> Ok(MedicationstatusInactive)
    "entered-in-error" -> Ok(MedicationstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn medicationstatus_decoder() -> Decoder(Medicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(MedicationstatusActive)
    "inactive" -> decode.success(MedicationstatusInactive)
    "entered-in-error" -> decode.success(MedicationstatusEnteredinerror)
    _ -> decode.failure(MedicationstatusActive, "Medicationstatus")
  }
}

pub type Messageheaderresponserequest {
  MessageheaderresponserequestAlways
  MessageheaderresponserequestOnerror
  MessageheaderresponserequestNever
  MessageheaderresponserequestOnsuccess
}

pub fn messageheaderresponserequest_to_json(
  messageheaderresponserequest: Messageheaderresponserequest,
) -> Json {
  json.string(messageheaderresponserequest_to_string(
    messageheaderresponserequest,
  ))
}

pub fn messageheaderresponserequest_to_string(
  messageheaderresponserequest: Messageheaderresponserequest,
) -> String {
  case messageheaderresponserequest {
    MessageheaderresponserequestAlways -> "always"
    MessageheaderresponserequestOnerror -> "on-error"
    MessageheaderresponserequestNever -> "never"
    MessageheaderresponserequestOnsuccess -> "on-success"
  }
}

pub fn messageheaderresponserequest_from_string(
  s: String,
) -> Result(Messageheaderresponserequest, Nil) {
  case s {
    "always" -> Ok(MessageheaderresponserequestAlways)
    "on-error" -> Ok(MessageheaderresponserequestOnerror)
    "never" -> Ok(MessageheaderresponserequestNever)
    "on-success" -> Ok(MessageheaderresponserequestOnsuccess)
    _ -> Error(Nil)
  }
}

pub fn messageheaderresponserequest_decoder() -> Decoder(
  Messageheaderresponserequest,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "always" -> decode.success(MessageheaderresponserequestAlways)
    "on-error" -> decode.success(MessageheaderresponserequestOnerror)
    "never" -> decode.success(MessageheaderresponserequestNever)
    "on-success" -> decode.success(MessageheaderresponserequestOnsuccess)
    _ ->
      decode.failure(
        MessageheaderresponserequestAlways,
        "Messageheaderresponserequest",
      )
  }
}

pub type Messagesignificancecategory {
  MessagesignificancecategoryConsequence
  MessagesignificancecategoryCurrency
  MessagesignificancecategoryNotification
}

pub fn messagesignificancecategory_to_json(
  messagesignificancecategory: Messagesignificancecategory,
) -> Json {
  json.string(messagesignificancecategory_to_string(messagesignificancecategory))
}

pub fn messagesignificancecategory_to_string(
  messagesignificancecategory: Messagesignificancecategory,
) -> String {
  case messagesignificancecategory {
    MessagesignificancecategoryConsequence -> "consequence"
    MessagesignificancecategoryCurrency -> "currency"
    MessagesignificancecategoryNotification -> "notification"
  }
}

pub fn messagesignificancecategory_from_string(
  s: String,
) -> Result(Messagesignificancecategory, Nil) {
  case s {
    "consequence" -> Ok(MessagesignificancecategoryConsequence)
    "currency" -> Ok(MessagesignificancecategoryCurrency)
    "notification" -> Ok(MessagesignificancecategoryNotification)
    _ -> Error(Nil)
  }
}

pub fn messagesignificancecategory_decoder() -> Decoder(
  Messagesignificancecategory,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "consequence" -> decode.success(MessagesignificancecategoryConsequence)
    "currency" -> decode.success(MessagesignificancecategoryCurrency)
    "notification" -> decode.success(MessagesignificancecategoryNotification)
    _ ->
      decode.failure(
        MessagesignificancecategoryConsequence,
        "Messagesignificancecategory",
      )
  }
}

pub type Metriccalibrationstate {
  MetriccalibrationstateNotcalibrated
  MetriccalibrationstateCalibrationrequired
  MetriccalibrationstateCalibrated
  MetriccalibrationstateUnspecified
}

pub fn metriccalibrationstate_to_json(
  metriccalibrationstate: Metriccalibrationstate,
) -> Json {
  json.string(metriccalibrationstate_to_string(metriccalibrationstate))
}

pub fn metriccalibrationstate_to_string(
  metriccalibrationstate: Metriccalibrationstate,
) -> String {
  case metriccalibrationstate {
    MetriccalibrationstateNotcalibrated -> "not-calibrated"
    MetriccalibrationstateCalibrationrequired -> "calibration-required"
    MetriccalibrationstateCalibrated -> "calibrated"
    MetriccalibrationstateUnspecified -> "unspecified"
  }
}

pub fn metriccalibrationstate_from_string(
  s: String,
) -> Result(Metriccalibrationstate, Nil) {
  case s {
    "not-calibrated" -> Ok(MetriccalibrationstateNotcalibrated)
    "calibration-required" -> Ok(MetriccalibrationstateCalibrationrequired)
    "calibrated" -> Ok(MetriccalibrationstateCalibrated)
    "unspecified" -> Ok(MetriccalibrationstateUnspecified)
    _ -> Error(Nil)
  }
}

pub fn metriccalibrationstate_decoder() -> Decoder(Metriccalibrationstate) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-calibrated" -> decode.success(MetriccalibrationstateNotcalibrated)
    "calibration-required" ->
      decode.success(MetriccalibrationstateCalibrationrequired)
    "calibrated" -> decode.success(MetriccalibrationstateCalibrated)
    "unspecified" -> decode.success(MetriccalibrationstateUnspecified)
    _ ->
      decode.failure(
        MetriccalibrationstateNotcalibrated,
        "Metriccalibrationstate",
      )
  }
}

pub type Metriccalibrationtype {
  MetriccalibrationtypeUnspecified
  MetriccalibrationtypeOffset
  MetriccalibrationtypeGain
  MetriccalibrationtypeTwopoint
}

pub fn metriccalibrationtype_to_json(
  metriccalibrationtype: Metriccalibrationtype,
) -> Json {
  json.string(metriccalibrationtype_to_string(metriccalibrationtype))
}

pub fn metriccalibrationtype_to_string(
  metriccalibrationtype: Metriccalibrationtype,
) -> String {
  case metriccalibrationtype {
    MetriccalibrationtypeUnspecified -> "unspecified"
    MetriccalibrationtypeOffset -> "offset"
    MetriccalibrationtypeGain -> "gain"
    MetriccalibrationtypeTwopoint -> "two-point"
  }
}

pub fn metriccalibrationtype_from_string(
  s: String,
) -> Result(Metriccalibrationtype, Nil) {
  case s {
    "unspecified" -> Ok(MetriccalibrationtypeUnspecified)
    "offset" -> Ok(MetriccalibrationtypeOffset)
    "gain" -> Ok(MetriccalibrationtypeGain)
    "two-point" -> Ok(MetriccalibrationtypeTwopoint)
    _ -> Error(Nil)
  }
}

pub fn metriccalibrationtype_decoder() -> Decoder(Metriccalibrationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "unspecified" -> decode.success(MetriccalibrationtypeUnspecified)
    "offset" -> decode.success(MetriccalibrationtypeOffset)
    "gain" -> decode.success(MetriccalibrationtypeGain)
    "two-point" -> decode.success(MetriccalibrationtypeTwopoint)
    _ ->
      decode.failure(MetriccalibrationtypeUnspecified, "Metriccalibrationtype")
  }
}

pub type Metriccategory {
  MetriccategoryMeasurement
  MetriccategorySetting
  MetriccategoryCalculation
  MetriccategoryUnspecified
}

pub fn metriccategory_to_json(metriccategory: Metriccategory) -> Json {
  json.string(metriccategory_to_string(metriccategory))
}

pub fn metriccategory_to_string(metriccategory: Metriccategory) -> String {
  case metriccategory {
    MetriccategoryMeasurement -> "measurement"
    MetriccategorySetting -> "setting"
    MetriccategoryCalculation -> "calculation"
    MetriccategoryUnspecified -> "unspecified"
  }
}

pub fn metriccategory_from_string(s: String) -> Result(Metriccategory, Nil) {
  case s {
    "measurement" -> Ok(MetriccategoryMeasurement)
    "setting" -> Ok(MetriccategorySetting)
    "calculation" -> Ok(MetriccategoryCalculation)
    "unspecified" -> Ok(MetriccategoryUnspecified)
    _ -> Error(Nil)
  }
}

pub fn metriccategory_decoder() -> Decoder(Metriccategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "measurement" -> decode.success(MetriccategoryMeasurement)
    "setting" -> decode.success(MetriccategorySetting)
    "calculation" -> decode.success(MetriccategoryCalculation)
    "unspecified" -> decode.success(MetriccategoryUnspecified)
    _ -> decode.failure(MetriccategoryMeasurement, "Metriccategory")
  }
}

pub type Metricoperationalstatus {
  MetricoperationalstatusOn
  MetricoperationalstatusOff
  MetricoperationalstatusStandby
  MetricoperationalstatusEnteredinerror
}

pub fn metricoperationalstatus_to_json(
  metricoperationalstatus: Metricoperationalstatus,
) -> Json {
  json.string(metricoperationalstatus_to_string(metricoperationalstatus))
}

pub fn metricoperationalstatus_to_string(
  metricoperationalstatus: Metricoperationalstatus,
) -> String {
  case metricoperationalstatus {
    MetricoperationalstatusOn -> "on"
    MetricoperationalstatusOff -> "off"
    MetricoperationalstatusStandby -> "standby"
    MetricoperationalstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn metricoperationalstatus_from_string(
  s: String,
) -> Result(Metricoperationalstatus, Nil) {
  case s {
    "on" -> Ok(MetricoperationalstatusOn)
    "off" -> Ok(MetricoperationalstatusOff)
    "standby" -> Ok(MetricoperationalstatusStandby)
    "entered-in-error" -> Ok(MetricoperationalstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn metricoperationalstatus_decoder() -> Decoder(Metricoperationalstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "on" -> decode.success(MetricoperationalstatusOn)
    "off" -> decode.success(MetricoperationalstatusOff)
    "standby" -> decode.success(MetricoperationalstatusStandby)
    "entered-in-error" -> decode.success(MetricoperationalstatusEnteredinerror)
    _ -> decode.failure(MetricoperationalstatusOn, "Metricoperationalstatus")
  }
}

pub type Nameuse {
  NameuseUsual
  NameuseOfficial
  NameuseTemp
  NameuseNickname
  NameuseAnonymous
  NameuseOld
  NameuseMaiden
}

pub fn nameuse_to_json(nameuse: Nameuse) -> Json {
  json.string(nameuse_to_string(nameuse))
}

pub fn nameuse_to_string(nameuse: Nameuse) -> String {
  case nameuse {
    NameuseUsual -> "usual"
    NameuseOfficial -> "official"
    NameuseTemp -> "temp"
    NameuseNickname -> "nickname"
    NameuseAnonymous -> "anonymous"
    NameuseOld -> "old"
    NameuseMaiden -> "maiden"
  }
}

pub fn nameuse_from_string(s: String) -> Result(Nameuse, Nil) {
  case s {
    "usual" -> Ok(NameuseUsual)
    "official" -> Ok(NameuseOfficial)
    "temp" -> Ok(NameuseTemp)
    "nickname" -> Ok(NameuseNickname)
    "anonymous" -> Ok(NameuseAnonymous)
    "old" -> Ok(NameuseOld)
    "maiden" -> Ok(NameuseMaiden)
    _ -> Error(Nil)
  }
}

pub fn nameuse_decoder() -> Decoder(Nameuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "usual" -> decode.success(NameuseUsual)
    "official" -> decode.success(NameuseOfficial)
    "temp" -> decode.success(NameuseTemp)
    "nickname" -> decode.success(NameuseNickname)
    "anonymous" -> decode.success(NameuseAnonymous)
    "old" -> decode.success(NameuseOld)
    "maiden" -> decode.success(NameuseMaiden)
    _ -> decode.failure(NameuseUsual, "Nameuse")
  }
}

pub type Namingsystemidentifiertype {
  NamingsystemidentifiertypeOid
  NamingsystemidentifiertypeUuid
  NamingsystemidentifiertypeUri
  NamingsystemidentifiertypeIristem
  NamingsystemidentifiertypeV2csmnemonic
  NamingsystemidentifiertypeOther
}

pub fn namingsystemidentifiertype_to_json(
  namingsystemidentifiertype: Namingsystemidentifiertype,
) -> Json {
  json.string(namingsystemidentifiertype_to_string(namingsystemidentifiertype))
}

pub fn namingsystemidentifiertype_to_string(
  namingsystemidentifiertype: Namingsystemidentifiertype,
) -> String {
  case namingsystemidentifiertype {
    NamingsystemidentifiertypeOid -> "oid"
    NamingsystemidentifiertypeUuid -> "uuid"
    NamingsystemidentifiertypeUri -> "uri"
    NamingsystemidentifiertypeIristem -> "iri-stem"
    NamingsystemidentifiertypeV2csmnemonic -> "v2csmnemonic"
    NamingsystemidentifiertypeOther -> "other"
  }
}

pub fn namingsystemidentifiertype_from_string(
  s: String,
) -> Result(Namingsystemidentifiertype, Nil) {
  case s {
    "oid" -> Ok(NamingsystemidentifiertypeOid)
    "uuid" -> Ok(NamingsystemidentifiertypeUuid)
    "uri" -> Ok(NamingsystemidentifiertypeUri)
    "iri-stem" -> Ok(NamingsystemidentifiertypeIristem)
    "v2csmnemonic" -> Ok(NamingsystemidentifiertypeV2csmnemonic)
    "other" -> Ok(NamingsystemidentifiertypeOther)
    _ -> Error(Nil)
  }
}

pub fn namingsystemidentifiertype_decoder() -> Decoder(
  Namingsystemidentifiertype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "oid" -> decode.success(NamingsystemidentifiertypeOid)
    "uuid" -> decode.success(NamingsystemidentifiertypeUuid)
    "uri" -> decode.success(NamingsystemidentifiertypeUri)
    "iri-stem" -> decode.success(NamingsystemidentifiertypeIristem)
    "v2csmnemonic" -> decode.success(NamingsystemidentifiertypeV2csmnemonic)
    "other" -> decode.success(NamingsystemidentifiertypeOther)
    _ ->
      decode.failure(
        NamingsystemidentifiertypeOid,
        "Namingsystemidentifiertype",
      )
  }
}

pub type Namingsystemtype {
  NamingsystemtypeCodesystem
  NamingsystemtypeIdentifier
  NamingsystemtypeRoot
}

pub fn namingsystemtype_to_json(namingsystemtype: Namingsystemtype) -> Json {
  json.string(namingsystemtype_to_string(namingsystemtype))
}

pub fn namingsystemtype_to_string(namingsystemtype: Namingsystemtype) -> String {
  case namingsystemtype {
    NamingsystemtypeCodesystem -> "codesystem"
    NamingsystemtypeIdentifier -> "identifier"
    NamingsystemtypeRoot -> "root"
  }
}

pub fn namingsystemtype_from_string(s: String) -> Result(Namingsystemtype, Nil) {
  case s {
    "codesystem" -> Ok(NamingsystemtypeCodesystem)
    "identifier" -> Ok(NamingsystemtypeIdentifier)
    "root" -> Ok(NamingsystemtypeRoot)
    _ -> Error(Nil)
  }
}

pub fn namingsystemtype_decoder() -> Decoder(Namingsystemtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "codesystem" -> decode.success(NamingsystemtypeCodesystem)
    "identifier" -> decode.success(NamingsystemtypeIdentifier)
    "root" -> decode.success(NamingsystemtypeRoot)
    _ -> decode.failure(NamingsystemtypeCodesystem, "Namingsystemtype")
  }
}

pub type Narrativestatus {
  NarrativestatusGenerated
  NarrativestatusExtensions
  NarrativestatusAdditional
  NarrativestatusEmpty
}

pub fn narrativestatus_to_json(narrativestatus: Narrativestatus) -> Json {
  json.string(narrativestatus_to_string(narrativestatus))
}

pub fn narrativestatus_to_string(narrativestatus: Narrativestatus) -> String {
  case narrativestatus {
    NarrativestatusGenerated -> "generated"
    NarrativestatusExtensions -> "extensions"
    NarrativestatusAdditional -> "additional"
    NarrativestatusEmpty -> "empty"
  }
}

pub fn narrativestatus_from_string(s: String) -> Result(Narrativestatus, Nil) {
  case s {
    "generated" -> Ok(NarrativestatusGenerated)
    "extensions" -> Ok(NarrativestatusExtensions)
    "additional" -> Ok(NarrativestatusAdditional)
    "empty" -> Ok(NarrativestatusEmpty)
    _ -> Error(Nil)
  }
}

pub fn narrativestatus_decoder() -> Decoder(Narrativestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "generated" -> decode.success(NarrativestatusGenerated)
    "extensions" -> decode.success(NarrativestatusExtensions)
    "additional" -> decode.success(NarrativestatusAdditional)
    "empty" -> decode.success(NarrativestatusEmpty)
    _ -> decode.failure(NarrativestatusGenerated, "Narrativestatus")
  }
}

pub type Notetype {
  NotetypeDisplay
  NotetypePrint
  NotetypePrintoper
}

pub fn notetype_to_json(notetype: Notetype) -> Json {
  json.string(notetype_to_string(notetype))
}

pub fn notetype_to_string(notetype: Notetype) -> String {
  case notetype {
    NotetypeDisplay -> "display"
    NotetypePrint -> "print"
    NotetypePrintoper -> "printoper"
  }
}

pub fn notetype_from_string(s: String) -> Result(Notetype, Nil) {
  case s {
    "display" -> Ok(NotetypeDisplay)
    "print" -> Ok(NotetypePrint)
    "printoper" -> Ok(NotetypePrintoper)
    _ -> Error(Nil)
  }
}

pub fn notetype_decoder() -> Decoder(Notetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "display" -> decode.success(NotetypeDisplay)
    "print" -> decode.success(NotetypePrint)
    "printoper" -> decode.success(NotetypePrintoper)
    _ -> decode.failure(NotetypeDisplay, "Notetype")
  }
}

pub type Nutritionproductstatus {
  NutritionproductstatusActive
  NutritionproductstatusInactive
  NutritionproductstatusEnteredinerror
}

pub fn nutritionproductstatus_to_json(
  nutritionproductstatus: Nutritionproductstatus,
) -> Json {
  json.string(nutritionproductstatus_to_string(nutritionproductstatus))
}

pub fn nutritionproductstatus_to_string(
  nutritionproductstatus: Nutritionproductstatus,
) -> String {
  case nutritionproductstatus {
    NutritionproductstatusActive -> "active"
    NutritionproductstatusInactive -> "inactive"
    NutritionproductstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn nutritionproductstatus_from_string(
  s: String,
) -> Result(Nutritionproductstatus, Nil) {
  case s {
    "active" -> Ok(NutritionproductstatusActive)
    "inactive" -> Ok(NutritionproductstatusInactive)
    "entered-in-error" -> Ok(NutritionproductstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn nutritionproductstatus_decoder() -> Decoder(Nutritionproductstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(NutritionproductstatusActive)
    "inactive" -> decode.success(NutritionproductstatusInactive)
    "entered-in-error" -> decode.success(NutritionproductstatusEnteredinerror)
    _ -> decode.failure(NutritionproductstatusActive, "Nutritionproductstatus")
  }
}

pub type Observationrangecategory {
  ObservationrangecategoryReference
  ObservationrangecategoryCritical
  ObservationrangecategoryAbsolute
}

pub fn observationrangecategory_to_json(
  observationrangecategory: Observationrangecategory,
) -> Json {
  json.string(observationrangecategory_to_string(observationrangecategory))
}

pub fn observationrangecategory_to_string(
  observationrangecategory: Observationrangecategory,
) -> String {
  case observationrangecategory {
    ObservationrangecategoryReference -> "reference"
    ObservationrangecategoryCritical -> "critical"
    ObservationrangecategoryAbsolute -> "absolute"
  }
}

pub fn observationrangecategory_from_string(
  s: String,
) -> Result(Observationrangecategory, Nil) {
  case s {
    "reference" -> Ok(ObservationrangecategoryReference)
    "critical" -> Ok(ObservationrangecategoryCritical)
    "absolute" -> Ok(ObservationrangecategoryAbsolute)
    _ -> Error(Nil)
  }
}

pub fn observationrangecategory_decoder() -> Decoder(Observationrangecategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "reference" -> decode.success(ObservationrangecategoryReference)
    "critical" -> decode.success(ObservationrangecategoryCritical)
    "absolute" -> decode.success(ObservationrangecategoryAbsolute)
    _ ->
      decode.failure(
        ObservationrangecategoryReference,
        "Observationrangecategory",
      )
  }
}

pub type Observationstatus {
  ObservationstatusRegistered
  ObservationstatusPreliminary
  ObservationstatusFinal
  ObservationstatusAmended
  ObservationstatusCorrected
  ObservationstatusCancelled
  ObservationstatusEnteredinerror
  ObservationstatusUnknown
}

pub fn observationstatus_to_json(observationstatus: Observationstatus) -> Json {
  json.string(observationstatus_to_string(observationstatus))
}

pub fn observationstatus_to_string(
  observationstatus: Observationstatus,
) -> String {
  case observationstatus {
    ObservationstatusRegistered -> "registered"
    ObservationstatusPreliminary -> "preliminary"
    ObservationstatusFinal -> "final"
    ObservationstatusAmended -> "amended"
    ObservationstatusCorrected -> "corrected"
    ObservationstatusCancelled -> "cancelled"
    ObservationstatusEnteredinerror -> "entered-in-error"
    ObservationstatusUnknown -> "unknown"
  }
}

pub fn observationstatus_from_string(
  s: String,
) -> Result(Observationstatus, Nil) {
  case s {
    "registered" -> Ok(ObservationstatusRegistered)
    "preliminary" -> Ok(ObservationstatusPreliminary)
    "final" -> Ok(ObservationstatusFinal)
    "amended" -> Ok(ObservationstatusAmended)
    "corrected" -> Ok(ObservationstatusCorrected)
    "cancelled" -> Ok(ObservationstatusCancelled)
    "entered-in-error" -> Ok(ObservationstatusEnteredinerror)
    "unknown" -> Ok(ObservationstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn observationstatus_decoder() -> Decoder(Observationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "registered" -> decode.success(ObservationstatusRegistered)
    "preliminary" -> decode.success(ObservationstatusPreliminary)
    "final" -> decode.success(ObservationstatusFinal)
    "amended" -> decode.success(ObservationstatusAmended)
    "corrected" -> decode.success(ObservationstatusCorrected)
    "cancelled" -> decode.success(ObservationstatusCancelled)
    "entered-in-error" -> decode.success(ObservationstatusEnteredinerror)
    "unknown" -> decode.success(ObservationstatusUnknown)
    _ -> decode.failure(ObservationstatusRegistered, "Observationstatus")
  }
}

pub type Observationtriggeredbytype {
  ObservationtriggeredbytypeReflex
  ObservationtriggeredbytypeRepeat
  ObservationtriggeredbytypeRerun
}

pub fn observationtriggeredbytype_to_json(
  observationtriggeredbytype: Observationtriggeredbytype,
) -> Json {
  json.string(observationtriggeredbytype_to_string(observationtriggeredbytype))
}

pub fn observationtriggeredbytype_to_string(
  observationtriggeredbytype: Observationtriggeredbytype,
) -> String {
  case observationtriggeredbytype {
    ObservationtriggeredbytypeReflex -> "reflex"
    ObservationtriggeredbytypeRepeat -> "repeat"
    ObservationtriggeredbytypeRerun -> "re-run"
  }
}

pub fn observationtriggeredbytype_from_string(
  s: String,
) -> Result(Observationtriggeredbytype, Nil) {
  case s {
    "reflex" -> Ok(ObservationtriggeredbytypeReflex)
    "repeat" -> Ok(ObservationtriggeredbytypeRepeat)
    "re-run" -> Ok(ObservationtriggeredbytypeRerun)
    _ -> Error(Nil)
  }
}

pub fn observationtriggeredbytype_decoder() -> Decoder(
  Observationtriggeredbytype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "reflex" -> decode.success(ObservationtriggeredbytypeReflex)
    "repeat" -> decode.success(ObservationtriggeredbytypeRepeat)
    "re-run" -> decode.success(ObservationtriggeredbytypeRerun)
    _ ->
      decode.failure(
        ObservationtriggeredbytypeReflex,
        "Observationtriggeredbytype",
      )
  }
}

pub type Operationkind {
  OperationkindOperation
  OperationkindQuery
}

pub fn operationkind_to_json(operationkind: Operationkind) -> Json {
  json.string(operationkind_to_string(operationkind))
}

pub fn operationkind_to_string(operationkind: Operationkind) -> String {
  case operationkind {
    OperationkindOperation -> "operation"
    OperationkindQuery -> "query"
  }
}

pub fn operationkind_from_string(s: String) -> Result(Operationkind, Nil) {
  case s {
    "operation" -> Ok(OperationkindOperation)
    "query" -> Ok(OperationkindQuery)
    _ -> Error(Nil)
  }
}

pub fn operationkind_decoder() -> Decoder(Operationkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "operation" -> decode.success(OperationkindOperation)
    "query" -> decode.success(OperationkindQuery)
    _ -> decode.failure(OperationkindOperation, "Operationkind")
  }
}

pub type Operationparameterscope {
  OperationparameterscopeInstance
  OperationparameterscopeType
  OperationparameterscopeSystem
}

pub fn operationparameterscope_to_json(
  operationparameterscope: Operationparameterscope,
) -> Json {
  json.string(operationparameterscope_to_string(operationparameterscope))
}

pub fn operationparameterscope_to_string(
  operationparameterscope: Operationparameterscope,
) -> String {
  case operationparameterscope {
    OperationparameterscopeInstance -> "instance"
    OperationparameterscopeType -> "type"
    OperationparameterscopeSystem -> "system"
  }
}

pub fn operationparameterscope_from_string(
  s: String,
) -> Result(Operationparameterscope, Nil) {
  case s {
    "instance" -> Ok(OperationparameterscopeInstance)
    "type" -> Ok(OperationparameterscopeType)
    "system" -> Ok(OperationparameterscopeSystem)
    _ -> Error(Nil)
  }
}

pub fn operationparameterscope_decoder() -> Decoder(Operationparameterscope) {
  use variant <- decode.then(decode.string)
  case variant {
    "instance" -> decode.success(OperationparameterscopeInstance)
    "type" -> decode.success(OperationparameterscopeType)
    "system" -> decode.success(OperationparameterscopeSystem)
    _ ->
      decode.failure(OperationparameterscopeInstance, "Operationparameterscope")
  }
}

pub type Operationparameteruse {
  OperationparameteruseIn
  OperationparameteruseOut
}

pub fn operationparameteruse_to_json(
  operationparameteruse: Operationparameteruse,
) -> Json {
  json.string(operationparameteruse_to_string(operationparameteruse))
}

pub fn operationparameteruse_to_string(
  operationparameteruse: Operationparameteruse,
) -> String {
  case operationparameteruse {
    OperationparameteruseIn -> "in"
    OperationparameteruseOut -> "out"
  }
}

pub fn operationparameteruse_from_string(
  s: String,
) -> Result(Operationparameteruse, Nil) {
  case s {
    "in" -> Ok(OperationparameteruseIn)
    "out" -> Ok(OperationparameteruseOut)
    _ -> Error(Nil)
  }
}

pub fn operationparameteruse_decoder() -> Decoder(Operationparameteruse) {
  use variant <- decode.then(decode.string)
  case variant {
    "in" -> decode.success(OperationparameteruseIn)
    "out" -> decode.success(OperationparameteruseOut)
    _ -> decode.failure(OperationparameteruseIn, "Operationparameteruse")
  }
}

pub type Orientationtype {
  OrientationtypeSense
  OrientationtypeAntisense
}

pub fn orientationtype_to_json(orientationtype: Orientationtype) -> Json {
  json.string(orientationtype_to_string(orientationtype))
}

pub fn orientationtype_to_string(orientationtype: Orientationtype) -> String {
  case orientationtype {
    OrientationtypeSense -> "sense"
    OrientationtypeAntisense -> "antisense"
  }
}

pub fn orientationtype_from_string(s: String) -> Result(Orientationtype, Nil) {
  case s {
    "sense" -> Ok(OrientationtypeSense)
    "antisense" -> Ok(OrientationtypeAntisense)
    _ -> Error(Nil)
  }
}

pub fn orientationtype_decoder() -> Decoder(Orientationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "sense" -> decode.success(OrientationtypeSense)
    "antisense" -> decode.success(OrientationtypeAntisense)
    _ -> decode.failure(OrientationtypeSense, "Orientationtype")
  }
}

pub type Participationstatus {
  ParticipationstatusAccepted
  ParticipationstatusDeclined
  ParticipationstatusTentative
  ParticipationstatusNeedsaction
}

pub fn participationstatus_to_json(
  participationstatus: Participationstatus,
) -> Json {
  json.string(participationstatus_to_string(participationstatus))
}

pub fn participationstatus_to_string(
  participationstatus: Participationstatus,
) -> String {
  case participationstatus {
    ParticipationstatusAccepted -> "accepted"
    ParticipationstatusDeclined -> "declined"
    ParticipationstatusTentative -> "tentative"
    ParticipationstatusNeedsaction -> "needs-action"
  }
}

pub fn participationstatus_from_string(
  s: String,
) -> Result(Participationstatus, Nil) {
  case s {
    "accepted" -> Ok(ParticipationstatusAccepted)
    "declined" -> Ok(ParticipationstatusDeclined)
    "tentative" -> Ok(ParticipationstatusTentative)
    "needs-action" -> Ok(ParticipationstatusNeedsaction)
    _ -> Error(Nil)
  }
}

pub fn participationstatus_decoder() -> Decoder(Participationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "accepted" -> decode.success(ParticipationstatusAccepted)
    "declined" -> decode.success(ParticipationstatusDeclined)
    "tentative" -> decode.success(ParticipationstatusTentative)
    "needs-action" -> decode.success(ParticipationstatusNeedsaction)
    _ -> decode.failure(ParticipationstatusAccepted, "Participationstatus")
  }
}

pub type Paymentoutcome {
  PaymentoutcomeQueued
  PaymentoutcomeComplete
  PaymentoutcomeError
  PaymentoutcomePartial
}

pub fn paymentoutcome_to_json(paymentoutcome: Paymentoutcome) -> Json {
  json.string(paymentoutcome_to_string(paymentoutcome))
}

pub fn paymentoutcome_to_string(paymentoutcome: Paymentoutcome) -> String {
  case paymentoutcome {
    PaymentoutcomeQueued -> "queued"
    PaymentoutcomeComplete -> "complete"
    PaymentoutcomeError -> "error"
    PaymentoutcomePartial -> "partial"
  }
}

pub fn paymentoutcome_from_string(s: String) -> Result(Paymentoutcome, Nil) {
  case s {
    "queued" -> Ok(PaymentoutcomeQueued)
    "complete" -> Ok(PaymentoutcomeComplete)
    "error" -> Ok(PaymentoutcomeError)
    "partial" -> Ok(PaymentoutcomePartial)
    _ -> Error(Nil)
  }
}

pub fn paymentoutcome_decoder() -> Decoder(Paymentoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "queued" -> decode.success(PaymentoutcomeQueued)
    "complete" -> decode.success(PaymentoutcomeComplete)
    "error" -> decode.success(PaymentoutcomeError)
    "partial" -> decode.success(PaymentoutcomePartial)
    _ -> decode.failure(PaymentoutcomeQueued, "Paymentoutcome")
  }
}

pub type Permissionrulecombining {
  PermissionrulecombiningDenyoverrides
  PermissionrulecombiningPermitoverrides
  PermissionrulecombiningOrdereddenyoverrides
  PermissionrulecombiningOrderedpermitoverrides
  PermissionrulecombiningDenyunlesspermit
  PermissionrulecombiningPermitunlessdeny
}

pub fn permissionrulecombining_to_json(
  permissionrulecombining: Permissionrulecombining,
) -> Json {
  json.string(permissionrulecombining_to_string(permissionrulecombining))
}

pub fn permissionrulecombining_to_string(
  permissionrulecombining: Permissionrulecombining,
) -> String {
  case permissionrulecombining {
    PermissionrulecombiningDenyoverrides -> "deny-overrides"
    PermissionrulecombiningPermitoverrides -> "permit-overrides"
    PermissionrulecombiningOrdereddenyoverrides -> "ordered-deny-overrides"
    PermissionrulecombiningOrderedpermitoverrides -> "ordered-permit-overrides"
    PermissionrulecombiningDenyunlesspermit -> "deny-unless-permit"
    PermissionrulecombiningPermitunlessdeny -> "permit-unless-deny"
  }
}

pub fn permissionrulecombining_from_string(
  s: String,
) -> Result(Permissionrulecombining, Nil) {
  case s {
    "deny-overrides" -> Ok(PermissionrulecombiningDenyoverrides)
    "permit-overrides" -> Ok(PermissionrulecombiningPermitoverrides)
    "ordered-deny-overrides" -> Ok(PermissionrulecombiningOrdereddenyoverrides)
    "ordered-permit-overrides" ->
      Ok(PermissionrulecombiningOrderedpermitoverrides)
    "deny-unless-permit" -> Ok(PermissionrulecombiningDenyunlesspermit)
    "permit-unless-deny" -> Ok(PermissionrulecombiningPermitunlessdeny)
    _ -> Error(Nil)
  }
}

pub fn permissionrulecombining_decoder() -> Decoder(Permissionrulecombining) {
  use variant <- decode.then(decode.string)
  case variant {
    "deny-overrides" -> decode.success(PermissionrulecombiningDenyoverrides)
    "permit-overrides" -> decode.success(PermissionrulecombiningPermitoverrides)
    "ordered-deny-overrides" ->
      decode.success(PermissionrulecombiningOrdereddenyoverrides)
    "ordered-permit-overrides" ->
      decode.success(PermissionrulecombiningOrderedpermitoverrides)
    "deny-unless-permit" ->
      decode.success(PermissionrulecombiningDenyunlesspermit)
    "permit-unless-deny" ->
      decode.success(PermissionrulecombiningPermitunlessdeny)
    _ ->
      decode.failure(
        PermissionrulecombiningDenyoverrides,
        "Permissionrulecombining",
      )
  }
}

pub type Permissionstatus {
  PermissionstatusActive
  PermissionstatusEnteredinerror
  PermissionstatusDraft
  PermissionstatusRejected
}

pub fn permissionstatus_to_json(permissionstatus: Permissionstatus) -> Json {
  json.string(permissionstatus_to_string(permissionstatus))
}

pub fn permissionstatus_to_string(permissionstatus: Permissionstatus) -> String {
  case permissionstatus {
    PermissionstatusActive -> "active"
    PermissionstatusEnteredinerror -> "entered-in-error"
    PermissionstatusDraft -> "draft"
    PermissionstatusRejected -> "rejected"
  }
}

pub fn permissionstatus_from_string(s: String) -> Result(Permissionstatus, Nil) {
  case s {
    "active" -> Ok(PermissionstatusActive)
    "entered-in-error" -> Ok(PermissionstatusEnteredinerror)
    "draft" -> Ok(PermissionstatusDraft)
    "rejected" -> Ok(PermissionstatusRejected)
    _ -> Error(Nil)
  }
}

pub fn permissionstatus_decoder() -> Decoder(Permissionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(PermissionstatusActive)
    "entered-in-error" -> decode.success(PermissionstatusEnteredinerror)
    "draft" -> decode.success(PermissionstatusDraft)
    "rejected" -> decode.success(PermissionstatusRejected)
    _ -> decode.failure(PermissionstatusActive, "Permissionstatus")
  }
}

pub type Permitteddatatype {
  PermitteddatatypeQuantity
  PermitteddatatypeCodeableconcept
  PermitteddatatypeString
  PermitteddatatypeBoolean
  PermitteddatatypeInteger
  PermitteddatatypeRange
  PermitteddatatypeRatio
  PermitteddatatypeSampleddata
  PermitteddatatypeTime
  PermitteddatatypeDatetime
  PermitteddatatypePeriod
}

pub fn permitteddatatype_to_json(permitteddatatype: Permitteddatatype) -> Json {
  json.string(permitteddatatype_to_string(permitteddatatype))
}

pub fn permitteddatatype_to_string(
  permitteddatatype: Permitteddatatype,
) -> String {
  case permitteddatatype {
    PermitteddatatypeQuantity -> "Quantity"
    PermitteddatatypeCodeableconcept -> "CodeableConcept"
    PermitteddatatypeString -> "string"
    PermitteddatatypeBoolean -> "boolean"
    PermitteddatatypeInteger -> "integer"
    PermitteddatatypeRange -> "Range"
    PermitteddatatypeRatio -> "Ratio"
    PermitteddatatypeSampleddata -> "SampledData"
    PermitteddatatypeTime -> "time"
    PermitteddatatypeDatetime -> "dateTime"
    PermitteddatatypePeriod -> "Period"
  }
}

pub fn permitteddatatype_from_string(
  s: String,
) -> Result(Permitteddatatype, Nil) {
  case s {
    "Quantity" -> Ok(PermitteddatatypeQuantity)
    "CodeableConcept" -> Ok(PermitteddatatypeCodeableconcept)
    "string" -> Ok(PermitteddatatypeString)
    "boolean" -> Ok(PermitteddatatypeBoolean)
    "integer" -> Ok(PermitteddatatypeInteger)
    "Range" -> Ok(PermitteddatatypeRange)
    "Ratio" -> Ok(PermitteddatatypeRatio)
    "SampledData" -> Ok(PermitteddatatypeSampleddata)
    "time" -> Ok(PermitteddatatypeTime)
    "dateTime" -> Ok(PermitteddatatypeDatetime)
    "Period" -> Ok(PermitteddatatypePeriod)
    _ -> Error(Nil)
  }
}

pub fn permitteddatatype_decoder() -> Decoder(Permitteddatatype) {
  use variant <- decode.then(decode.string)
  case variant {
    "Quantity" -> decode.success(PermitteddatatypeQuantity)
    "CodeableConcept" -> decode.success(PermitteddatatypeCodeableconcept)
    "string" -> decode.success(PermitteddatatypeString)
    "boolean" -> decode.success(PermitteddatatypeBoolean)
    "integer" -> decode.success(PermitteddatatypeInteger)
    "Range" -> decode.success(PermitteddatatypeRange)
    "Ratio" -> decode.success(PermitteddatatypeRatio)
    "SampledData" -> decode.success(PermitteddatatypeSampleddata)
    "time" -> decode.success(PermitteddatatypeTime)
    "dateTime" -> decode.success(PermitteddatatypeDatetime)
    "Period" -> decode.success(PermitteddatatypePeriod)
    _ -> decode.failure(PermitteddatatypeQuantity, "Permitteddatatype")
  }
}

pub type Pricecomponenttype {
  PricecomponenttypeBase
  PricecomponenttypeSurcharge
  PricecomponenttypeDeduction
  PricecomponenttypeDiscount
  PricecomponenttypeTax
  PricecomponenttypeInformational
}

pub fn pricecomponenttype_to_json(
  pricecomponenttype: Pricecomponenttype,
) -> Json {
  json.string(pricecomponenttype_to_string(pricecomponenttype))
}

pub fn pricecomponenttype_to_string(
  pricecomponenttype: Pricecomponenttype,
) -> String {
  case pricecomponenttype {
    PricecomponenttypeBase -> "base"
    PricecomponenttypeSurcharge -> "surcharge"
    PricecomponenttypeDeduction -> "deduction"
    PricecomponenttypeDiscount -> "discount"
    PricecomponenttypeTax -> "tax"
    PricecomponenttypeInformational -> "informational"
  }
}

pub fn pricecomponenttype_from_string(
  s: String,
) -> Result(Pricecomponenttype, Nil) {
  case s {
    "base" -> Ok(PricecomponenttypeBase)
    "surcharge" -> Ok(PricecomponenttypeSurcharge)
    "deduction" -> Ok(PricecomponenttypeDeduction)
    "discount" -> Ok(PricecomponenttypeDiscount)
    "tax" -> Ok(PricecomponenttypeTax)
    "informational" -> Ok(PricecomponenttypeInformational)
    _ -> Error(Nil)
  }
}

pub fn pricecomponenttype_decoder() -> Decoder(Pricecomponenttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "base" -> decode.success(PricecomponenttypeBase)
    "surcharge" -> decode.success(PricecomponenttypeSurcharge)
    "deduction" -> decode.success(PricecomponenttypeDeduction)
    "discount" -> decode.success(PricecomponenttypeDiscount)
    "tax" -> decode.success(PricecomponenttypeTax)
    "informational" -> decode.success(PricecomponenttypeInformational)
    _ -> decode.failure(PricecomponenttypeBase, "Pricecomponenttype")
  }
}

pub type Propertyrepresentation {
  PropertyrepresentationXmlattr
  PropertyrepresentationXmltext
  PropertyrepresentationTypeattr
  PropertyrepresentationCdatext
  PropertyrepresentationXhtml
}

pub fn propertyrepresentation_to_json(
  propertyrepresentation: Propertyrepresentation,
) -> Json {
  json.string(propertyrepresentation_to_string(propertyrepresentation))
}

pub fn propertyrepresentation_to_string(
  propertyrepresentation: Propertyrepresentation,
) -> String {
  case propertyrepresentation {
    PropertyrepresentationXmlattr -> "xmlAttr"
    PropertyrepresentationXmltext -> "xmlText"
    PropertyrepresentationTypeattr -> "typeAttr"
    PropertyrepresentationCdatext -> "cdaText"
    PropertyrepresentationXhtml -> "xhtml"
  }
}

pub fn propertyrepresentation_from_string(
  s: String,
) -> Result(Propertyrepresentation, Nil) {
  case s {
    "xmlAttr" -> Ok(PropertyrepresentationXmlattr)
    "xmlText" -> Ok(PropertyrepresentationXmltext)
    "typeAttr" -> Ok(PropertyrepresentationTypeattr)
    "cdaText" -> Ok(PropertyrepresentationCdatext)
    "xhtml" -> Ok(PropertyrepresentationXhtml)
    _ -> Error(Nil)
  }
}

pub fn propertyrepresentation_decoder() -> Decoder(Propertyrepresentation) {
  use variant <- decode.then(decode.string)
  case variant {
    "xmlAttr" -> decode.success(PropertyrepresentationXmlattr)
    "xmlText" -> decode.success(PropertyrepresentationXmltext)
    "typeAttr" -> decode.success(PropertyrepresentationTypeattr)
    "cdaText" -> decode.success(PropertyrepresentationCdatext)
    "xhtml" -> decode.success(PropertyrepresentationXhtml)
    _ -> decode.failure(PropertyrepresentationXmlattr, "Propertyrepresentation")
  }
}

pub type Provenanceentityrole {
  ProvenanceentityroleRevision
  ProvenanceentityroleQuotation
  ProvenanceentityroleSource
  ProvenanceentityroleInstantiates
  ProvenanceentityroleRemoval
}

pub fn provenanceentityrole_to_json(
  provenanceentityrole: Provenanceentityrole,
) -> Json {
  json.string(provenanceentityrole_to_string(provenanceentityrole))
}

pub fn provenanceentityrole_to_string(
  provenanceentityrole: Provenanceentityrole,
) -> String {
  case provenanceentityrole {
    ProvenanceentityroleRevision -> "revision"
    ProvenanceentityroleQuotation -> "quotation"
    ProvenanceentityroleSource -> "source"
    ProvenanceentityroleInstantiates -> "instantiates"
    ProvenanceentityroleRemoval -> "removal"
  }
}

pub fn provenanceentityrole_from_string(
  s: String,
) -> Result(Provenanceentityrole, Nil) {
  case s {
    "revision" -> Ok(ProvenanceentityroleRevision)
    "quotation" -> Ok(ProvenanceentityroleQuotation)
    "source" -> Ok(ProvenanceentityroleSource)
    "instantiates" -> Ok(ProvenanceentityroleInstantiates)
    "removal" -> Ok(ProvenanceentityroleRemoval)
    _ -> Error(Nil)
  }
}

pub fn provenanceentityrole_decoder() -> Decoder(Provenanceentityrole) {
  use variant <- decode.then(decode.string)
  case variant {
    "revision" -> decode.success(ProvenanceentityroleRevision)
    "quotation" -> decode.success(ProvenanceentityroleQuotation)
    "source" -> decode.success(ProvenanceentityroleSource)
    "instantiates" -> decode.success(ProvenanceentityroleInstantiates)
    "removal" -> decode.success(ProvenanceentityroleRemoval)
    _ -> decode.failure(ProvenanceentityroleRevision, "Provenanceentityrole")
  }
}

pub type Publicationstatus {
  PublicationstatusDraft
  PublicationstatusActive
  PublicationstatusRetired
  PublicationstatusUnknown
}

pub fn publicationstatus_to_json(publicationstatus: Publicationstatus) -> Json {
  json.string(publicationstatus_to_string(publicationstatus))
}

pub fn publicationstatus_to_string(
  publicationstatus: Publicationstatus,
) -> String {
  case publicationstatus {
    PublicationstatusDraft -> "draft"
    PublicationstatusActive -> "active"
    PublicationstatusRetired -> "retired"
    PublicationstatusUnknown -> "unknown"
  }
}

pub fn publicationstatus_from_string(
  s: String,
) -> Result(Publicationstatus, Nil) {
  case s {
    "draft" -> Ok(PublicationstatusDraft)
    "active" -> Ok(PublicationstatusActive)
    "retired" -> Ok(PublicationstatusRetired)
    "unknown" -> Ok(PublicationstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn publicationstatus_decoder() -> Decoder(Publicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(PublicationstatusDraft)
    "active" -> decode.success(PublicationstatusActive)
    "retired" -> decode.success(PublicationstatusRetired)
    "unknown" -> decode.success(PublicationstatusUnknown)
    _ -> decode.failure(PublicationstatusDraft, "Publicationstatus")
  }
}

pub type Quantitycomparator {
  QuantitycomparatorLessthan
  QuantitycomparatorLessthanequal
  QuantitycomparatorGreaterthanequal
  QuantitycomparatorGreaterthan
  QuantitycomparatorAd
}

pub fn quantitycomparator_to_json(
  quantitycomparator: Quantitycomparator,
) -> Json {
  json.string(quantitycomparator_to_string(quantitycomparator))
}

pub fn quantitycomparator_to_string(
  quantitycomparator: Quantitycomparator,
) -> String {
  case quantitycomparator {
    QuantitycomparatorLessthan -> "<"
    QuantitycomparatorLessthanequal -> "<="
    QuantitycomparatorGreaterthanequal -> ">="
    QuantitycomparatorGreaterthan -> ">"
    QuantitycomparatorAd -> "ad"
  }
}

pub fn quantitycomparator_from_string(
  s: String,
) -> Result(Quantitycomparator, Nil) {
  case s {
    "<" -> Ok(QuantitycomparatorLessthan)
    "<=" -> Ok(QuantitycomparatorLessthanequal)
    ">=" -> Ok(QuantitycomparatorGreaterthanequal)
    ">" -> Ok(QuantitycomparatorGreaterthan)
    "ad" -> Ok(QuantitycomparatorAd)
    _ -> Error(Nil)
  }
}

pub fn quantitycomparator_decoder() -> Decoder(Quantitycomparator) {
  use variant <- decode.then(decode.string)
  case variant {
    "<" -> decode.success(QuantitycomparatorLessthan)
    "<=" -> decode.success(QuantitycomparatorLessthanequal)
    ">=" -> decode.success(QuantitycomparatorGreaterthanequal)
    ">" -> decode.success(QuantitycomparatorGreaterthan)
    "ad" -> decode.success(QuantitycomparatorAd)
    _ -> decode.failure(QuantitycomparatorLessthan, "Quantitycomparator")
  }
}

pub type Questionnaireanswerconstraint {
  QuestionnaireanswerconstraintOptionsonly
  QuestionnaireanswerconstraintOptionsortype
  QuestionnaireanswerconstraintOptionsorstring
}

pub fn questionnaireanswerconstraint_to_json(
  questionnaireanswerconstraint: Questionnaireanswerconstraint,
) -> Json {
  json.string(questionnaireanswerconstraint_to_string(
    questionnaireanswerconstraint,
  ))
}

pub fn questionnaireanswerconstraint_to_string(
  questionnaireanswerconstraint: Questionnaireanswerconstraint,
) -> String {
  case questionnaireanswerconstraint {
    QuestionnaireanswerconstraintOptionsonly -> "optionsOnly"
    QuestionnaireanswerconstraintOptionsortype -> "optionsOrType"
    QuestionnaireanswerconstraintOptionsorstring -> "optionsOrString"
  }
}

pub fn questionnaireanswerconstraint_from_string(
  s: String,
) -> Result(Questionnaireanswerconstraint, Nil) {
  case s {
    "optionsOnly" -> Ok(QuestionnaireanswerconstraintOptionsonly)
    "optionsOrType" -> Ok(QuestionnaireanswerconstraintOptionsortype)
    "optionsOrString" -> Ok(QuestionnaireanswerconstraintOptionsorstring)
    _ -> Error(Nil)
  }
}

pub fn questionnaireanswerconstraint_decoder() -> Decoder(
  Questionnaireanswerconstraint,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "optionsOnly" -> decode.success(QuestionnaireanswerconstraintOptionsonly)
    "optionsOrType" ->
      decode.success(QuestionnaireanswerconstraintOptionsortype)
    "optionsOrString" ->
      decode.success(QuestionnaireanswerconstraintOptionsorstring)
    _ ->
      decode.failure(
        QuestionnaireanswerconstraintOptionsonly,
        "Questionnaireanswerconstraint",
      )
  }
}

pub type Questionnaireanswersstatus {
  QuestionnaireanswersstatusInprogress
  QuestionnaireanswersstatusCompleted
  QuestionnaireanswersstatusAmended
  QuestionnaireanswersstatusEnteredinerror
  QuestionnaireanswersstatusStopped
}

pub fn questionnaireanswersstatus_to_json(
  questionnaireanswersstatus: Questionnaireanswersstatus,
) -> Json {
  json.string(questionnaireanswersstatus_to_string(questionnaireanswersstatus))
}

pub fn questionnaireanswersstatus_to_string(
  questionnaireanswersstatus: Questionnaireanswersstatus,
) -> String {
  case questionnaireanswersstatus {
    QuestionnaireanswersstatusInprogress -> "in-progress"
    QuestionnaireanswersstatusCompleted -> "completed"
    QuestionnaireanswersstatusAmended -> "amended"
    QuestionnaireanswersstatusEnteredinerror -> "entered-in-error"
    QuestionnaireanswersstatusStopped -> "stopped"
  }
}

pub fn questionnaireanswersstatus_from_string(
  s: String,
) -> Result(Questionnaireanswersstatus, Nil) {
  case s {
    "in-progress" -> Ok(QuestionnaireanswersstatusInprogress)
    "completed" -> Ok(QuestionnaireanswersstatusCompleted)
    "amended" -> Ok(QuestionnaireanswersstatusAmended)
    "entered-in-error" -> Ok(QuestionnaireanswersstatusEnteredinerror)
    "stopped" -> Ok(QuestionnaireanswersstatusStopped)
    _ -> Error(Nil)
  }
}

pub fn questionnaireanswersstatus_decoder() -> Decoder(
  Questionnaireanswersstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(QuestionnaireanswersstatusInprogress)
    "completed" -> decode.success(QuestionnaireanswersstatusCompleted)
    "amended" -> decode.success(QuestionnaireanswersstatusAmended)
    "entered-in-error" ->
      decode.success(QuestionnaireanswersstatusEnteredinerror)
    "stopped" -> decode.success(QuestionnaireanswersstatusStopped)
    _ ->
      decode.failure(
        QuestionnaireanswersstatusInprogress,
        "Questionnaireanswersstatus",
      )
  }
}

pub type Questionnairedisableddisplay {
  QuestionnairedisableddisplayHidden
  QuestionnairedisableddisplayProtected
}

pub fn questionnairedisableddisplay_to_json(
  questionnairedisableddisplay: Questionnairedisableddisplay,
) -> Json {
  json.string(questionnairedisableddisplay_to_string(
    questionnairedisableddisplay,
  ))
}

pub fn questionnairedisableddisplay_to_string(
  questionnairedisableddisplay: Questionnairedisableddisplay,
) -> String {
  case questionnairedisableddisplay {
    QuestionnairedisableddisplayHidden -> "hidden"
    QuestionnairedisableddisplayProtected -> "protected"
  }
}

pub fn questionnairedisableddisplay_from_string(
  s: String,
) -> Result(Questionnairedisableddisplay, Nil) {
  case s {
    "hidden" -> Ok(QuestionnairedisableddisplayHidden)
    "protected" -> Ok(QuestionnairedisableddisplayProtected)
    _ -> Error(Nil)
  }
}

pub fn questionnairedisableddisplay_decoder() -> Decoder(
  Questionnairedisableddisplay,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "hidden" -> decode.success(QuestionnairedisableddisplayHidden)
    "protected" -> decode.success(QuestionnairedisableddisplayProtected)
    _ ->
      decode.failure(
        QuestionnairedisableddisplayHidden,
        "Questionnairedisableddisplay",
      )
  }
}

pub type Questionnaireenablebehavior {
  QuestionnaireenablebehaviorAll
  QuestionnaireenablebehaviorAny
}

pub fn questionnaireenablebehavior_to_json(
  questionnaireenablebehavior: Questionnaireenablebehavior,
) -> Json {
  json.string(questionnaireenablebehavior_to_string(questionnaireenablebehavior))
}

pub fn questionnaireenablebehavior_to_string(
  questionnaireenablebehavior: Questionnaireenablebehavior,
) -> String {
  case questionnaireenablebehavior {
    QuestionnaireenablebehaviorAll -> "all"
    QuestionnaireenablebehaviorAny -> "any"
  }
}

pub fn questionnaireenablebehavior_from_string(
  s: String,
) -> Result(Questionnaireenablebehavior, Nil) {
  case s {
    "all" -> Ok(QuestionnaireenablebehaviorAll)
    "any" -> Ok(QuestionnaireenablebehaviorAny)
    _ -> Error(Nil)
  }
}

pub fn questionnaireenablebehavior_decoder() -> Decoder(
  Questionnaireenablebehavior,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "all" -> decode.success(QuestionnaireenablebehaviorAll)
    "any" -> decode.success(QuestionnaireenablebehaviorAny)
    _ ->
      decode.failure(
        QuestionnaireenablebehaviorAll,
        "Questionnaireenablebehavior",
      )
  }
}

pub type Questionnaireenableoperator {
  QuestionnaireenableoperatorExists
  QuestionnaireenableoperatorEqual
  QuestionnaireenableoperatorNotequal
  QuestionnaireenableoperatorGreaterthan
  QuestionnaireenableoperatorLessthan
  QuestionnaireenableoperatorGreaterthanequal
  QuestionnaireenableoperatorLessthanequal
}

pub fn questionnaireenableoperator_to_json(
  questionnaireenableoperator: Questionnaireenableoperator,
) -> Json {
  json.string(questionnaireenableoperator_to_string(questionnaireenableoperator))
}

pub fn questionnaireenableoperator_to_string(
  questionnaireenableoperator: Questionnaireenableoperator,
) -> String {
  case questionnaireenableoperator {
    QuestionnaireenableoperatorExists -> "exists"
    QuestionnaireenableoperatorEqual -> "="
    QuestionnaireenableoperatorNotequal -> "!="
    QuestionnaireenableoperatorGreaterthan -> ">"
    QuestionnaireenableoperatorLessthan -> "<"
    QuestionnaireenableoperatorGreaterthanequal -> ">="
    QuestionnaireenableoperatorLessthanequal -> "<="
  }
}

pub fn questionnaireenableoperator_from_string(
  s: String,
) -> Result(Questionnaireenableoperator, Nil) {
  case s {
    "exists" -> Ok(QuestionnaireenableoperatorExists)
    "=" -> Ok(QuestionnaireenableoperatorEqual)
    "!=" -> Ok(QuestionnaireenableoperatorNotequal)
    ">" -> Ok(QuestionnaireenableoperatorGreaterthan)
    "<" -> Ok(QuestionnaireenableoperatorLessthan)
    ">=" -> Ok(QuestionnaireenableoperatorGreaterthanequal)
    "<=" -> Ok(QuestionnaireenableoperatorLessthanequal)
    _ -> Error(Nil)
  }
}

pub fn questionnaireenableoperator_decoder() -> Decoder(
  Questionnaireenableoperator,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "exists" -> decode.success(QuestionnaireenableoperatorExists)
    "=" -> decode.success(QuestionnaireenableoperatorEqual)
    "!=" -> decode.success(QuestionnaireenableoperatorNotequal)
    ">" -> decode.success(QuestionnaireenableoperatorGreaterthan)
    "<" -> decode.success(QuestionnaireenableoperatorLessthan)
    ">=" -> decode.success(QuestionnaireenableoperatorGreaterthanequal)
    "<=" -> decode.success(QuestionnaireenableoperatorLessthanequal)
    _ ->
      decode.failure(
        QuestionnaireenableoperatorExists,
        "Questionnaireenableoperator",
      )
  }
}

pub type Reactioneventseverity {
  ReactioneventseverityMild
  ReactioneventseverityModerate
  ReactioneventseveritySevere
}

pub fn reactioneventseverity_to_json(
  reactioneventseverity: Reactioneventseverity,
) -> Json {
  json.string(reactioneventseverity_to_string(reactioneventseverity))
}

pub fn reactioneventseverity_to_string(
  reactioneventseverity: Reactioneventseverity,
) -> String {
  case reactioneventseverity {
    ReactioneventseverityMild -> "mild"
    ReactioneventseverityModerate -> "moderate"
    ReactioneventseveritySevere -> "severe"
  }
}

pub fn reactioneventseverity_from_string(
  s: String,
) -> Result(Reactioneventseverity, Nil) {
  case s {
    "mild" -> Ok(ReactioneventseverityMild)
    "moderate" -> Ok(ReactioneventseverityModerate)
    "severe" -> Ok(ReactioneventseveritySevere)
    _ -> Error(Nil)
  }
}

pub fn reactioneventseverity_decoder() -> Decoder(Reactioneventseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "mild" -> decode.success(ReactioneventseverityMild)
    "moderate" -> decode.success(ReactioneventseverityModerate)
    "severe" -> decode.success(ReactioneventseveritySevere)
    _ -> decode.failure(ReactioneventseverityMild, "Reactioneventseverity")
  }
}

pub type Referencehandlingpolicy {
  ReferencehandlingpolicyLiteral
  ReferencehandlingpolicyLogical
  ReferencehandlingpolicyResolves
  ReferencehandlingpolicyEnforced
  ReferencehandlingpolicyLocal
}

pub fn referencehandlingpolicy_to_json(
  referencehandlingpolicy: Referencehandlingpolicy,
) -> Json {
  json.string(referencehandlingpolicy_to_string(referencehandlingpolicy))
}

pub fn referencehandlingpolicy_to_string(
  referencehandlingpolicy: Referencehandlingpolicy,
) -> String {
  case referencehandlingpolicy {
    ReferencehandlingpolicyLiteral -> "literal"
    ReferencehandlingpolicyLogical -> "logical"
    ReferencehandlingpolicyResolves -> "resolves"
    ReferencehandlingpolicyEnforced -> "enforced"
    ReferencehandlingpolicyLocal -> "local"
  }
}

pub fn referencehandlingpolicy_from_string(
  s: String,
) -> Result(Referencehandlingpolicy, Nil) {
  case s {
    "literal" -> Ok(ReferencehandlingpolicyLiteral)
    "logical" -> Ok(ReferencehandlingpolicyLogical)
    "resolves" -> Ok(ReferencehandlingpolicyResolves)
    "enforced" -> Ok(ReferencehandlingpolicyEnforced)
    "local" -> Ok(ReferencehandlingpolicyLocal)
    _ -> Error(Nil)
  }
}

pub fn referencehandlingpolicy_decoder() -> Decoder(Referencehandlingpolicy) {
  use variant <- decode.then(decode.string)
  case variant {
    "literal" -> decode.success(ReferencehandlingpolicyLiteral)
    "logical" -> decode.success(ReferencehandlingpolicyLogical)
    "resolves" -> decode.success(ReferencehandlingpolicyResolves)
    "enforced" -> decode.success(ReferencehandlingpolicyEnforced)
    "local" -> decode.success(ReferencehandlingpolicyLocal)
    _ ->
      decode.failure(ReferencehandlingpolicyLiteral, "Referencehandlingpolicy")
  }
}

pub type Referenceversionrules {
  ReferenceversionrulesEither
  ReferenceversionrulesIndependent
  ReferenceversionrulesSpecific
}

pub fn referenceversionrules_to_json(
  referenceversionrules: Referenceversionrules,
) -> Json {
  json.string(referenceversionrules_to_string(referenceversionrules))
}

pub fn referenceversionrules_to_string(
  referenceversionrules: Referenceversionrules,
) -> String {
  case referenceversionrules {
    ReferenceversionrulesEither -> "either"
    ReferenceversionrulesIndependent -> "independent"
    ReferenceversionrulesSpecific -> "specific"
  }
}

pub fn referenceversionrules_from_string(
  s: String,
) -> Result(Referenceversionrules, Nil) {
  case s {
    "either" -> Ok(ReferenceversionrulesEither)
    "independent" -> Ok(ReferenceversionrulesIndependent)
    "specific" -> Ok(ReferenceversionrulesSpecific)
    _ -> Error(Nil)
  }
}

pub fn referenceversionrules_decoder() -> Decoder(Referenceversionrules) {
  use variant <- decode.then(decode.string)
  case variant {
    "either" -> decode.success(ReferenceversionrulesEither)
    "independent" -> decode.success(ReferenceversionrulesIndependent)
    "specific" -> decode.success(ReferenceversionrulesSpecific)
    _ -> decode.failure(ReferenceversionrulesEither, "Referenceversionrules")
  }
}

pub type Relatedartifacttype {
  RelatedartifacttypeDocumentation
  RelatedartifacttypeJustification
  RelatedartifacttypeCitation
  RelatedartifacttypePredecessor
  RelatedartifacttypeSuccessor
  RelatedartifacttypeDerivedfrom
  RelatedartifacttypeDependson
  RelatedartifacttypeComposedof
  RelatedartifacttypePartof
  RelatedartifacttypeAmends
  RelatedartifacttypeAmendedwith
  RelatedartifacttypeAppends
  RelatedartifacttypeAppendedwith
  RelatedartifacttypeCites
  RelatedartifacttypeCitedby
  RelatedartifacttypeCommentson
  RelatedartifacttypeCommentin
  RelatedartifacttypeContains
  RelatedartifacttypeContainedin
  RelatedartifacttypeCorrects
  RelatedartifacttypeCorrectionin
  RelatedartifacttypeReplaces
  RelatedartifacttypeReplacedwith
  RelatedartifacttypeRetracts
  RelatedartifacttypeRetractedby
  RelatedartifacttypeSigns
  RelatedartifacttypeSimilarto
  RelatedartifacttypeSupports
  RelatedartifacttypeSupportedwith
  RelatedartifacttypeTransforms
  RelatedartifacttypeTransformedinto
  RelatedartifacttypeTransformedwith
  RelatedartifacttypeDocuments
  RelatedartifacttypeSpecificationof
  RelatedartifacttypeCreatedwith
  RelatedartifacttypeCiteas
}

pub fn relatedartifacttype_to_json(
  relatedartifacttype: Relatedartifacttype,
) -> Json {
  json.string(relatedartifacttype_to_string(relatedartifacttype))
}

pub fn relatedartifacttype_to_string(
  relatedartifacttype: Relatedartifacttype,
) -> String {
  case relatedartifacttype {
    RelatedartifacttypeDocumentation -> "documentation"
    RelatedartifacttypeJustification -> "justification"
    RelatedartifacttypeCitation -> "citation"
    RelatedartifacttypePredecessor -> "predecessor"
    RelatedartifacttypeSuccessor -> "successor"
    RelatedartifacttypeDerivedfrom -> "derived-from"
    RelatedartifacttypeDependson -> "depends-on"
    RelatedartifacttypeComposedof -> "composed-of"
    RelatedartifacttypePartof -> "part-of"
    RelatedartifacttypeAmends -> "amends"
    RelatedartifacttypeAmendedwith -> "amended-with"
    RelatedartifacttypeAppends -> "appends"
    RelatedartifacttypeAppendedwith -> "appended-with"
    RelatedartifacttypeCites -> "cites"
    RelatedartifacttypeCitedby -> "cited-by"
    RelatedartifacttypeCommentson -> "comments-on"
    RelatedartifacttypeCommentin -> "comment-in"
    RelatedartifacttypeContains -> "contains"
    RelatedartifacttypeContainedin -> "contained-in"
    RelatedartifacttypeCorrects -> "corrects"
    RelatedartifacttypeCorrectionin -> "correction-in"
    RelatedartifacttypeReplaces -> "replaces"
    RelatedartifacttypeReplacedwith -> "replaced-with"
    RelatedartifacttypeRetracts -> "retracts"
    RelatedartifacttypeRetractedby -> "retracted-by"
    RelatedartifacttypeSigns -> "signs"
    RelatedartifacttypeSimilarto -> "similar-to"
    RelatedartifacttypeSupports -> "supports"
    RelatedartifacttypeSupportedwith -> "supported-with"
    RelatedartifacttypeTransforms -> "transforms"
    RelatedartifacttypeTransformedinto -> "transformed-into"
    RelatedartifacttypeTransformedwith -> "transformed-with"
    RelatedartifacttypeDocuments -> "documents"
    RelatedartifacttypeSpecificationof -> "specification-of"
    RelatedartifacttypeCreatedwith -> "created-with"
    RelatedartifacttypeCiteas -> "cite-as"
  }
}

pub fn relatedartifacttype_from_string(
  s: String,
) -> Result(Relatedartifacttype, Nil) {
  case s {
    "documentation" -> Ok(RelatedartifacttypeDocumentation)
    "justification" -> Ok(RelatedartifacttypeJustification)
    "citation" -> Ok(RelatedartifacttypeCitation)
    "predecessor" -> Ok(RelatedartifacttypePredecessor)
    "successor" -> Ok(RelatedartifacttypeSuccessor)
    "derived-from" -> Ok(RelatedartifacttypeDerivedfrom)
    "depends-on" -> Ok(RelatedartifacttypeDependson)
    "composed-of" -> Ok(RelatedartifacttypeComposedof)
    "part-of" -> Ok(RelatedartifacttypePartof)
    "amends" -> Ok(RelatedartifacttypeAmends)
    "amended-with" -> Ok(RelatedartifacttypeAmendedwith)
    "appends" -> Ok(RelatedartifacttypeAppends)
    "appended-with" -> Ok(RelatedartifacttypeAppendedwith)
    "cites" -> Ok(RelatedartifacttypeCites)
    "cited-by" -> Ok(RelatedartifacttypeCitedby)
    "comments-on" -> Ok(RelatedartifacttypeCommentson)
    "comment-in" -> Ok(RelatedartifacttypeCommentin)
    "contains" -> Ok(RelatedartifacttypeContains)
    "contained-in" -> Ok(RelatedartifacttypeContainedin)
    "corrects" -> Ok(RelatedartifacttypeCorrects)
    "correction-in" -> Ok(RelatedartifacttypeCorrectionin)
    "replaces" -> Ok(RelatedartifacttypeReplaces)
    "replaced-with" -> Ok(RelatedartifacttypeReplacedwith)
    "retracts" -> Ok(RelatedartifacttypeRetracts)
    "retracted-by" -> Ok(RelatedartifacttypeRetractedby)
    "signs" -> Ok(RelatedartifacttypeSigns)
    "similar-to" -> Ok(RelatedartifacttypeSimilarto)
    "supports" -> Ok(RelatedartifacttypeSupports)
    "supported-with" -> Ok(RelatedartifacttypeSupportedwith)
    "transforms" -> Ok(RelatedartifacttypeTransforms)
    "transformed-into" -> Ok(RelatedartifacttypeTransformedinto)
    "transformed-with" -> Ok(RelatedartifacttypeTransformedwith)
    "documents" -> Ok(RelatedartifacttypeDocuments)
    "specification-of" -> Ok(RelatedartifacttypeSpecificationof)
    "created-with" -> Ok(RelatedartifacttypeCreatedwith)
    "cite-as" -> Ok(RelatedartifacttypeCiteas)
    _ -> Error(Nil)
  }
}

pub fn relatedartifacttype_decoder() -> Decoder(Relatedartifacttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "documentation" -> decode.success(RelatedartifacttypeDocumentation)
    "justification" -> decode.success(RelatedartifacttypeJustification)
    "citation" -> decode.success(RelatedartifacttypeCitation)
    "predecessor" -> decode.success(RelatedartifacttypePredecessor)
    "successor" -> decode.success(RelatedartifacttypeSuccessor)
    "derived-from" -> decode.success(RelatedartifacttypeDerivedfrom)
    "depends-on" -> decode.success(RelatedartifacttypeDependson)
    "composed-of" -> decode.success(RelatedartifacttypeComposedof)
    "part-of" -> decode.success(RelatedartifacttypePartof)
    "amends" -> decode.success(RelatedartifacttypeAmends)
    "amended-with" -> decode.success(RelatedartifacttypeAmendedwith)
    "appends" -> decode.success(RelatedartifacttypeAppends)
    "appended-with" -> decode.success(RelatedartifacttypeAppendedwith)
    "cites" -> decode.success(RelatedartifacttypeCites)
    "cited-by" -> decode.success(RelatedartifacttypeCitedby)
    "comments-on" -> decode.success(RelatedartifacttypeCommentson)
    "comment-in" -> decode.success(RelatedartifacttypeCommentin)
    "contains" -> decode.success(RelatedartifacttypeContains)
    "contained-in" -> decode.success(RelatedartifacttypeContainedin)
    "corrects" -> decode.success(RelatedartifacttypeCorrects)
    "correction-in" -> decode.success(RelatedartifacttypeCorrectionin)
    "replaces" -> decode.success(RelatedartifacttypeReplaces)
    "replaced-with" -> decode.success(RelatedartifacttypeReplacedwith)
    "retracts" -> decode.success(RelatedartifacttypeRetracts)
    "retracted-by" -> decode.success(RelatedartifacttypeRetractedby)
    "signs" -> decode.success(RelatedartifacttypeSigns)
    "similar-to" -> decode.success(RelatedartifacttypeSimilarto)
    "supports" -> decode.success(RelatedartifacttypeSupports)
    "supported-with" -> decode.success(RelatedartifacttypeSupportedwith)
    "transforms" -> decode.success(RelatedartifacttypeTransforms)
    "transformed-into" -> decode.success(RelatedartifacttypeTransformedinto)
    "transformed-with" -> decode.success(RelatedartifacttypeTransformedwith)
    "documents" -> decode.success(RelatedartifacttypeDocuments)
    "specification-of" -> decode.success(RelatedartifacttypeSpecificationof)
    "created-with" -> decode.success(RelatedartifacttypeCreatedwith)
    "cite-as" -> decode.success(RelatedartifacttypeCiteas)
    _ -> decode.failure(RelatedartifacttypeDocumentation, "Relatedartifacttype")
  }
}

pub type Relatedartifacttypeall {
  RelatedartifacttypeallDocumentation
  RelatedartifacttypeallJustification
  RelatedartifacttypeallCitation
  RelatedartifacttypeallPredecessor
  RelatedartifacttypeallSuccessor
  RelatedartifacttypeallDerivedfrom
  RelatedartifacttypeallDependson
  RelatedartifacttypeallComposedof
  RelatedartifacttypeallPartof
  RelatedartifacttypeallAmends
  RelatedartifacttypeallAmendedwith
  RelatedartifacttypeallAppends
  RelatedartifacttypeallAppendedwith
  RelatedartifacttypeallCites
  RelatedartifacttypeallCitedby
  RelatedartifacttypeallCommentson
  RelatedartifacttypeallCommentin
  RelatedartifacttypeallContains
  RelatedartifacttypeallContainedin
  RelatedartifacttypeallCorrects
  RelatedartifacttypeallCorrectionin
  RelatedartifacttypeallReplaces
  RelatedartifacttypeallReplacedwith
  RelatedartifacttypeallRetracts
  RelatedartifacttypeallRetractedby
  RelatedartifacttypeallSigns
  RelatedartifacttypeallSimilarto
  RelatedartifacttypeallSupports
  RelatedartifacttypeallSupportedwith
  RelatedartifacttypeallTransforms
  RelatedartifacttypeallTransformedinto
  RelatedartifacttypeallTransformedwith
  RelatedartifacttypeallDocuments
  RelatedartifacttypeallSpecificationof
  RelatedartifacttypeallCreatedwith
  RelatedartifacttypeallCiteas
  RelatedartifacttypeallReprint
  RelatedartifacttypeallReprintof
}

pub fn relatedartifacttypeall_to_json(
  relatedartifacttypeall: Relatedartifacttypeall,
) -> Json {
  json.string(relatedartifacttypeall_to_string(relatedartifacttypeall))
}

pub fn relatedartifacttypeall_to_string(
  relatedartifacttypeall: Relatedartifacttypeall,
) -> String {
  case relatedartifacttypeall {
    RelatedartifacttypeallDocumentation -> "documentation"
    RelatedartifacttypeallJustification -> "justification"
    RelatedartifacttypeallCitation -> "citation"
    RelatedartifacttypeallPredecessor -> "predecessor"
    RelatedartifacttypeallSuccessor -> "successor"
    RelatedartifacttypeallDerivedfrom -> "derived-from"
    RelatedartifacttypeallDependson -> "depends-on"
    RelatedartifacttypeallComposedof -> "composed-of"
    RelatedartifacttypeallPartof -> "part-of"
    RelatedartifacttypeallAmends -> "amends"
    RelatedartifacttypeallAmendedwith -> "amended-with"
    RelatedartifacttypeallAppends -> "appends"
    RelatedartifacttypeallAppendedwith -> "appended-with"
    RelatedartifacttypeallCites -> "cites"
    RelatedartifacttypeallCitedby -> "cited-by"
    RelatedartifacttypeallCommentson -> "comments-on"
    RelatedartifacttypeallCommentin -> "comment-in"
    RelatedartifacttypeallContains -> "contains"
    RelatedartifacttypeallContainedin -> "contained-in"
    RelatedartifacttypeallCorrects -> "corrects"
    RelatedartifacttypeallCorrectionin -> "correction-in"
    RelatedartifacttypeallReplaces -> "replaces"
    RelatedartifacttypeallReplacedwith -> "replaced-with"
    RelatedartifacttypeallRetracts -> "retracts"
    RelatedartifacttypeallRetractedby -> "retracted-by"
    RelatedartifacttypeallSigns -> "signs"
    RelatedartifacttypeallSimilarto -> "similar-to"
    RelatedartifacttypeallSupports -> "supports"
    RelatedartifacttypeallSupportedwith -> "supported-with"
    RelatedartifacttypeallTransforms -> "transforms"
    RelatedartifacttypeallTransformedinto -> "transformed-into"
    RelatedartifacttypeallTransformedwith -> "transformed-with"
    RelatedartifacttypeallDocuments -> "documents"
    RelatedartifacttypeallSpecificationof -> "specification-of"
    RelatedartifacttypeallCreatedwith -> "created-with"
    RelatedartifacttypeallCiteas -> "cite-as"
    RelatedartifacttypeallReprint -> "reprint"
    RelatedartifacttypeallReprintof -> "reprint-of"
  }
}

pub fn relatedartifacttypeall_from_string(
  s: String,
) -> Result(Relatedartifacttypeall, Nil) {
  case s {
    "documentation" -> Ok(RelatedartifacttypeallDocumentation)
    "justification" -> Ok(RelatedartifacttypeallJustification)
    "citation" -> Ok(RelatedartifacttypeallCitation)
    "predecessor" -> Ok(RelatedartifacttypeallPredecessor)
    "successor" -> Ok(RelatedartifacttypeallSuccessor)
    "derived-from" -> Ok(RelatedartifacttypeallDerivedfrom)
    "depends-on" -> Ok(RelatedartifacttypeallDependson)
    "composed-of" -> Ok(RelatedartifacttypeallComposedof)
    "part-of" -> Ok(RelatedartifacttypeallPartof)
    "amends" -> Ok(RelatedartifacttypeallAmends)
    "amended-with" -> Ok(RelatedartifacttypeallAmendedwith)
    "appends" -> Ok(RelatedartifacttypeallAppends)
    "appended-with" -> Ok(RelatedartifacttypeallAppendedwith)
    "cites" -> Ok(RelatedartifacttypeallCites)
    "cited-by" -> Ok(RelatedartifacttypeallCitedby)
    "comments-on" -> Ok(RelatedartifacttypeallCommentson)
    "comment-in" -> Ok(RelatedartifacttypeallCommentin)
    "contains" -> Ok(RelatedartifacttypeallContains)
    "contained-in" -> Ok(RelatedartifacttypeallContainedin)
    "corrects" -> Ok(RelatedartifacttypeallCorrects)
    "correction-in" -> Ok(RelatedartifacttypeallCorrectionin)
    "replaces" -> Ok(RelatedartifacttypeallReplaces)
    "replaced-with" -> Ok(RelatedartifacttypeallReplacedwith)
    "retracts" -> Ok(RelatedartifacttypeallRetracts)
    "retracted-by" -> Ok(RelatedartifacttypeallRetractedby)
    "signs" -> Ok(RelatedartifacttypeallSigns)
    "similar-to" -> Ok(RelatedartifacttypeallSimilarto)
    "supports" -> Ok(RelatedartifacttypeallSupports)
    "supported-with" -> Ok(RelatedartifacttypeallSupportedwith)
    "transforms" -> Ok(RelatedartifacttypeallTransforms)
    "transformed-into" -> Ok(RelatedartifacttypeallTransformedinto)
    "transformed-with" -> Ok(RelatedartifacttypeallTransformedwith)
    "documents" -> Ok(RelatedartifacttypeallDocuments)
    "specification-of" -> Ok(RelatedartifacttypeallSpecificationof)
    "created-with" -> Ok(RelatedartifacttypeallCreatedwith)
    "cite-as" -> Ok(RelatedartifacttypeallCiteas)
    "reprint" -> Ok(RelatedartifacttypeallReprint)
    "reprint-of" -> Ok(RelatedartifacttypeallReprintof)
    _ -> Error(Nil)
  }
}

pub fn relatedartifacttypeall_decoder() -> Decoder(Relatedartifacttypeall) {
  use variant <- decode.then(decode.string)
  case variant {
    "documentation" -> decode.success(RelatedartifacttypeallDocumentation)
    "justification" -> decode.success(RelatedartifacttypeallJustification)
    "citation" -> decode.success(RelatedartifacttypeallCitation)
    "predecessor" -> decode.success(RelatedartifacttypeallPredecessor)
    "successor" -> decode.success(RelatedartifacttypeallSuccessor)
    "derived-from" -> decode.success(RelatedartifacttypeallDerivedfrom)
    "depends-on" -> decode.success(RelatedartifacttypeallDependson)
    "composed-of" -> decode.success(RelatedartifacttypeallComposedof)
    "part-of" -> decode.success(RelatedartifacttypeallPartof)
    "amends" -> decode.success(RelatedartifacttypeallAmends)
    "amended-with" -> decode.success(RelatedartifacttypeallAmendedwith)
    "appends" -> decode.success(RelatedartifacttypeallAppends)
    "appended-with" -> decode.success(RelatedartifacttypeallAppendedwith)
    "cites" -> decode.success(RelatedartifacttypeallCites)
    "cited-by" -> decode.success(RelatedartifacttypeallCitedby)
    "comments-on" -> decode.success(RelatedartifacttypeallCommentson)
    "comment-in" -> decode.success(RelatedartifacttypeallCommentin)
    "contains" -> decode.success(RelatedartifacttypeallContains)
    "contained-in" -> decode.success(RelatedartifacttypeallContainedin)
    "corrects" -> decode.success(RelatedartifacttypeallCorrects)
    "correction-in" -> decode.success(RelatedartifacttypeallCorrectionin)
    "replaces" -> decode.success(RelatedartifacttypeallReplaces)
    "replaced-with" -> decode.success(RelatedartifacttypeallReplacedwith)
    "retracts" -> decode.success(RelatedartifacttypeallRetracts)
    "retracted-by" -> decode.success(RelatedartifacttypeallRetractedby)
    "signs" -> decode.success(RelatedartifacttypeallSigns)
    "similar-to" -> decode.success(RelatedartifacttypeallSimilarto)
    "supports" -> decode.success(RelatedartifacttypeallSupports)
    "supported-with" -> decode.success(RelatedartifacttypeallSupportedwith)
    "transforms" -> decode.success(RelatedartifacttypeallTransforms)
    "transformed-into" -> decode.success(RelatedartifacttypeallTransformedinto)
    "transformed-with" -> decode.success(RelatedartifacttypeallTransformedwith)
    "documents" -> decode.success(RelatedartifacttypeallDocuments)
    "specification-of" -> decode.success(RelatedartifacttypeallSpecificationof)
    "created-with" -> decode.success(RelatedartifacttypeallCreatedwith)
    "cite-as" -> decode.success(RelatedartifacttypeallCiteas)
    "reprint" -> decode.success(RelatedartifacttypeallReprint)
    "reprint-of" -> decode.success(RelatedartifacttypeallReprintof)
    _ ->
      decode.failure(
        RelatedartifacttypeallDocumentation,
        "Relatedartifacttypeall",
      )
  }
}

pub type Reportactionresultcodes {
  ReportactionresultcodesPass
  ReportactionresultcodesSkip
  ReportactionresultcodesFail
  ReportactionresultcodesWarning
  ReportactionresultcodesError
}

pub fn reportactionresultcodes_to_json(
  reportactionresultcodes: Reportactionresultcodes,
) -> Json {
  json.string(reportactionresultcodes_to_string(reportactionresultcodes))
}

pub fn reportactionresultcodes_to_string(
  reportactionresultcodes: Reportactionresultcodes,
) -> String {
  case reportactionresultcodes {
    ReportactionresultcodesPass -> "pass"
    ReportactionresultcodesSkip -> "skip"
    ReportactionresultcodesFail -> "fail"
    ReportactionresultcodesWarning -> "warning"
    ReportactionresultcodesError -> "error"
  }
}

pub fn reportactionresultcodes_from_string(
  s: String,
) -> Result(Reportactionresultcodes, Nil) {
  case s {
    "pass" -> Ok(ReportactionresultcodesPass)
    "skip" -> Ok(ReportactionresultcodesSkip)
    "fail" -> Ok(ReportactionresultcodesFail)
    "warning" -> Ok(ReportactionresultcodesWarning)
    "error" -> Ok(ReportactionresultcodesError)
    _ -> Error(Nil)
  }
}

pub fn reportactionresultcodes_decoder() -> Decoder(Reportactionresultcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "pass" -> decode.success(ReportactionresultcodesPass)
    "skip" -> decode.success(ReportactionresultcodesSkip)
    "fail" -> decode.success(ReportactionresultcodesFail)
    "warning" -> decode.success(ReportactionresultcodesWarning)
    "error" -> decode.success(ReportactionresultcodesError)
    _ -> decode.failure(ReportactionresultcodesPass, "Reportactionresultcodes")
  }
}

pub type Reportparticipanttype {
  ReportparticipanttypeTestengine
  ReportparticipanttypeClient
  ReportparticipanttypeServer
}

pub fn reportparticipanttype_to_json(
  reportparticipanttype: Reportparticipanttype,
) -> Json {
  json.string(reportparticipanttype_to_string(reportparticipanttype))
}

pub fn reportparticipanttype_to_string(
  reportparticipanttype: Reportparticipanttype,
) -> String {
  case reportparticipanttype {
    ReportparticipanttypeTestengine -> "test-engine"
    ReportparticipanttypeClient -> "client"
    ReportparticipanttypeServer -> "server"
  }
}

pub fn reportparticipanttype_from_string(
  s: String,
) -> Result(Reportparticipanttype, Nil) {
  case s {
    "test-engine" -> Ok(ReportparticipanttypeTestengine)
    "client" -> Ok(ReportparticipanttypeClient)
    "server" -> Ok(ReportparticipanttypeServer)
    _ -> Error(Nil)
  }
}

pub fn reportparticipanttype_decoder() -> Decoder(Reportparticipanttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "test-engine" -> decode.success(ReportparticipanttypeTestengine)
    "client" -> decode.success(ReportparticipanttypeClient)
    "server" -> decode.success(ReportparticipanttypeServer)
    _ ->
      decode.failure(ReportparticipanttypeTestengine, "Reportparticipanttype")
  }
}

pub type Reportrelationtype {
  ReportrelationtypeReplaces
  ReportrelationtypeAmends
  ReportrelationtypeAppends
  ReportrelationtypeTransforms
  ReportrelationtypeReplacedwith
  ReportrelationtypeAmendedwith
  ReportrelationtypeAppendedwith
  ReportrelationtypeTransformedwith
}

pub fn reportrelationtype_to_json(
  reportrelationtype: Reportrelationtype,
) -> Json {
  json.string(reportrelationtype_to_string(reportrelationtype))
}

pub fn reportrelationtype_to_string(
  reportrelationtype: Reportrelationtype,
) -> String {
  case reportrelationtype {
    ReportrelationtypeReplaces -> "replaces"
    ReportrelationtypeAmends -> "amends"
    ReportrelationtypeAppends -> "appends"
    ReportrelationtypeTransforms -> "transforms"
    ReportrelationtypeReplacedwith -> "replacedWith"
    ReportrelationtypeAmendedwith -> "amendedWith"
    ReportrelationtypeAppendedwith -> "appendedWith"
    ReportrelationtypeTransformedwith -> "transformedWith"
  }
}

pub fn reportrelationtype_from_string(
  s: String,
) -> Result(Reportrelationtype, Nil) {
  case s {
    "replaces" -> Ok(ReportrelationtypeReplaces)
    "amends" -> Ok(ReportrelationtypeAmends)
    "appends" -> Ok(ReportrelationtypeAppends)
    "transforms" -> Ok(ReportrelationtypeTransforms)
    "replacedWith" -> Ok(ReportrelationtypeReplacedwith)
    "amendedWith" -> Ok(ReportrelationtypeAmendedwith)
    "appendedWith" -> Ok(ReportrelationtypeAppendedwith)
    "transformedWith" -> Ok(ReportrelationtypeTransformedwith)
    _ -> Error(Nil)
  }
}

pub fn reportrelationtype_decoder() -> Decoder(Reportrelationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "replaces" -> decode.success(ReportrelationtypeReplaces)
    "amends" -> decode.success(ReportrelationtypeAmends)
    "appends" -> decode.success(ReportrelationtypeAppends)
    "transforms" -> decode.success(ReportrelationtypeTransforms)
    "replacedWith" -> decode.success(ReportrelationtypeReplacedwith)
    "amendedWith" -> decode.success(ReportrelationtypeAmendedwith)
    "appendedWith" -> decode.success(ReportrelationtypeAppendedwith)
    "transformedWith" -> decode.success(ReportrelationtypeTransformedwith)
    _ -> decode.failure(ReportrelationtypeReplaces, "Reportrelationtype")
  }
}

pub type Reportresultcodes {
  ReportresultcodesPass
  ReportresultcodesFail
  ReportresultcodesPending
}

pub fn reportresultcodes_to_json(reportresultcodes: Reportresultcodes) -> Json {
  json.string(reportresultcodes_to_string(reportresultcodes))
}

pub fn reportresultcodes_to_string(
  reportresultcodes: Reportresultcodes,
) -> String {
  case reportresultcodes {
    ReportresultcodesPass -> "pass"
    ReportresultcodesFail -> "fail"
    ReportresultcodesPending -> "pending"
  }
}

pub fn reportresultcodes_from_string(
  s: String,
) -> Result(Reportresultcodes, Nil) {
  case s {
    "pass" -> Ok(ReportresultcodesPass)
    "fail" -> Ok(ReportresultcodesFail)
    "pending" -> Ok(ReportresultcodesPending)
    _ -> Error(Nil)
  }
}

pub fn reportresultcodes_decoder() -> Decoder(Reportresultcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "pass" -> decode.success(ReportresultcodesPass)
    "fail" -> decode.success(ReportresultcodesFail)
    "pending" -> decode.success(ReportresultcodesPending)
    _ -> decode.failure(ReportresultcodesPass, "Reportresultcodes")
  }
}

pub type Reportstatuscodes {
  ReportstatuscodesCompleted
  ReportstatuscodesInprogress
  ReportstatuscodesWaiting
  ReportstatuscodesStopped
  ReportstatuscodesEnteredinerror
}

pub fn reportstatuscodes_to_json(reportstatuscodes: Reportstatuscodes) -> Json {
  json.string(reportstatuscodes_to_string(reportstatuscodes))
}

pub fn reportstatuscodes_to_string(
  reportstatuscodes: Reportstatuscodes,
) -> String {
  case reportstatuscodes {
    ReportstatuscodesCompleted -> "completed"
    ReportstatuscodesInprogress -> "in-progress"
    ReportstatuscodesWaiting -> "waiting"
    ReportstatuscodesStopped -> "stopped"
    ReportstatuscodesEnteredinerror -> "entered-in-error"
  }
}

pub fn reportstatuscodes_from_string(
  s: String,
) -> Result(Reportstatuscodes, Nil) {
  case s {
    "completed" -> Ok(ReportstatuscodesCompleted)
    "in-progress" -> Ok(ReportstatuscodesInprogress)
    "waiting" -> Ok(ReportstatuscodesWaiting)
    "stopped" -> Ok(ReportstatuscodesStopped)
    "entered-in-error" -> Ok(ReportstatuscodesEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn reportstatuscodes_decoder() -> Decoder(Reportstatuscodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "completed" -> decode.success(ReportstatuscodesCompleted)
    "in-progress" -> decode.success(ReportstatuscodesInprogress)
    "waiting" -> decode.success(ReportstatuscodesWaiting)
    "stopped" -> decode.success(ReportstatuscodesStopped)
    "entered-in-error" -> decode.success(ReportstatuscodesEnteredinerror)
    _ -> decode.failure(ReportstatuscodesCompleted, "Reportstatuscodes")
  }
}

pub type Requestintent {
  RequestintentProposal
  RequestintentPlan
  RequestintentDirective
  RequestintentOrder
  RequestintentOriginalorder
  RequestintentReflexorder
  RequestintentFillerorder
  RequestintentInstanceorder
  RequestintentOption
}

pub fn requestintent_to_json(requestintent: Requestintent) -> Json {
  json.string(requestintent_to_string(requestintent))
}

pub fn requestintent_to_string(requestintent: Requestintent) -> String {
  case requestintent {
    RequestintentProposal -> "proposal"
    RequestintentPlan -> "plan"
    RequestintentDirective -> "directive"
    RequestintentOrder -> "order"
    RequestintentOriginalorder -> "original-order"
    RequestintentReflexorder -> "reflex-order"
    RequestintentFillerorder -> "filler-order"
    RequestintentInstanceorder -> "instance-order"
    RequestintentOption -> "option"
  }
}

pub fn requestintent_from_string(s: String) -> Result(Requestintent, Nil) {
  case s {
    "proposal" -> Ok(RequestintentProposal)
    "plan" -> Ok(RequestintentPlan)
    "directive" -> Ok(RequestintentDirective)
    "order" -> Ok(RequestintentOrder)
    "original-order" -> Ok(RequestintentOriginalorder)
    "reflex-order" -> Ok(RequestintentReflexorder)
    "filler-order" -> Ok(RequestintentFillerorder)
    "instance-order" -> Ok(RequestintentInstanceorder)
    "option" -> Ok(RequestintentOption)
    _ -> Error(Nil)
  }
}

pub fn requestintent_decoder() -> Decoder(Requestintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "proposal" -> decode.success(RequestintentProposal)
    "plan" -> decode.success(RequestintentPlan)
    "directive" -> decode.success(RequestintentDirective)
    "order" -> decode.success(RequestintentOrder)
    "original-order" -> decode.success(RequestintentOriginalorder)
    "reflex-order" -> decode.success(RequestintentReflexorder)
    "filler-order" -> decode.success(RequestintentFillerorder)
    "instance-order" -> decode.success(RequestintentInstanceorder)
    "option" -> decode.success(RequestintentOption)
    _ -> decode.failure(RequestintentProposal, "Requestintent")
  }
}

pub type Requestpriority {
  RequestpriorityRoutine
  RequestpriorityUrgent
  RequestpriorityAsap
  RequestpriorityStat
}

pub fn requestpriority_to_json(requestpriority: Requestpriority) -> Json {
  json.string(requestpriority_to_string(requestpriority))
}

pub fn requestpriority_to_string(requestpriority: Requestpriority) -> String {
  case requestpriority {
    RequestpriorityRoutine -> "routine"
    RequestpriorityUrgent -> "urgent"
    RequestpriorityAsap -> "asap"
    RequestpriorityStat -> "stat"
  }
}

pub fn requestpriority_from_string(s: String) -> Result(Requestpriority, Nil) {
  case s {
    "routine" -> Ok(RequestpriorityRoutine)
    "urgent" -> Ok(RequestpriorityUrgent)
    "asap" -> Ok(RequestpriorityAsap)
    "stat" -> Ok(RequestpriorityStat)
    _ -> Error(Nil)
  }
}

pub fn requestpriority_decoder() -> Decoder(Requestpriority) {
  use variant <- decode.then(decode.string)
  case variant {
    "routine" -> decode.success(RequestpriorityRoutine)
    "urgent" -> decode.success(RequestpriorityUrgent)
    "asap" -> decode.success(RequestpriorityAsap)
    "stat" -> decode.success(RequestpriorityStat)
    _ -> decode.failure(RequestpriorityRoutine, "Requestpriority")
  }
}

pub type Requestresourcetypes {
  RequestresourcetypesAppointment
  RequestresourcetypesAppointmentresponse
  RequestresourcetypesCareplan
  RequestresourcetypesClaim
  RequestresourcetypesCommunicationrequest
  RequestresourcetypesCoverageeligibilityrequest
  RequestresourcetypesDevicerequest
  RequestresourcetypesEnrollmentrequest
  RequestresourcetypesImmunizationrecommendation
  RequestresourcetypesMedicationrequest
  RequestresourcetypesNutritionorder
  RequestresourcetypesRequestorchestration
  RequestresourcetypesServicerequest
  RequestresourcetypesSupplyrequest
  RequestresourcetypesTask
  RequestresourcetypesTransport
  RequestresourcetypesVisionprescription
}

pub fn requestresourcetypes_to_json(
  requestresourcetypes: Requestresourcetypes,
) -> Json {
  json.string(requestresourcetypes_to_string(requestresourcetypes))
}

pub fn requestresourcetypes_to_string(
  requestresourcetypes: Requestresourcetypes,
) -> String {
  case requestresourcetypes {
    RequestresourcetypesAppointment -> "Appointment"
    RequestresourcetypesAppointmentresponse -> "AppointmentResponse"
    RequestresourcetypesCareplan -> "CarePlan"
    RequestresourcetypesClaim -> "Claim"
    RequestresourcetypesCommunicationrequest -> "CommunicationRequest"
    RequestresourcetypesCoverageeligibilityrequest ->
      "CoverageEligibilityRequest"
    RequestresourcetypesDevicerequest -> "DeviceRequest"
    RequestresourcetypesEnrollmentrequest -> "EnrollmentRequest"
    RequestresourcetypesImmunizationrecommendation ->
      "ImmunizationRecommendation"
    RequestresourcetypesMedicationrequest -> "MedicationRequest"
    RequestresourcetypesNutritionorder -> "NutritionOrder"
    RequestresourcetypesRequestorchestration -> "RequestOrchestration"
    RequestresourcetypesServicerequest -> "ServiceRequest"
    RequestresourcetypesSupplyrequest -> "SupplyRequest"
    RequestresourcetypesTask -> "Task"
    RequestresourcetypesTransport -> "Transport"
    RequestresourcetypesVisionprescription -> "VisionPrescription"
  }
}

pub fn requestresourcetypes_from_string(
  s: String,
) -> Result(Requestresourcetypes, Nil) {
  case s {
    "Appointment" -> Ok(RequestresourcetypesAppointment)
    "AppointmentResponse" -> Ok(RequestresourcetypesAppointmentresponse)
    "CarePlan" -> Ok(RequestresourcetypesCareplan)
    "Claim" -> Ok(RequestresourcetypesClaim)
    "CommunicationRequest" -> Ok(RequestresourcetypesCommunicationrequest)
    "CoverageEligibilityRequest" ->
      Ok(RequestresourcetypesCoverageeligibilityrequest)
    "DeviceRequest" -> Ok(RequestresourcetypesDevicerequest)
    "EnrollmentRequest" -> Ok(RequestresourcetypesEnrollmentrequest)
    "ImmunizationRecommendation" ->
      Ok(RequestresourcetypesImmunizationrecommendation)
    "MedicationRequest" -> Ok(RequestresourcetypesMedicationrequest)
    "NutritionOrder" -> Ok(RequestresourcetypesNutritionorder)
    "RequestOrchestration" -> Ok(RequestresourcetypesRequestorchestration)
    "ServiceRequest" -> Ok(RequestresourcetypesServicerequest)
    "SupplyRequest" -> Ok(RequestresourcetypesSupplyrequest)
    "Task" -> Ok(RequestresourcetypesTask)
    "Transport" -> Ok(RequestresourcetypesTransport)
    "VisionPrescription" -> Ok(RequestresourcetypesVisionprescription)
    _ -> Error(Nil)
  }
}

pub fn requestresourcetypes_decoder() -> Decoder(Requestresourcetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Appointment" -> decode.success(RequestresourcetypesAppointment)
    "AppointmentResponse" ->
      decode.success(RequestresourcetypesAppointmentresponse)
    "CarePlan" -> decode.success(RequestresourcetypesCareplan)
    "Claim" -> decode.success(RequestresourcetypesClaim)
    "CommunicationRequest" ->
      decode.success(RequestresourcetypesCommunicationrequest)
    "CoverageEligibilityRequest" ->
      decode.success(RequestresourcetypesCoverageeligibilityrequest)
    "DeviceRequest" -> decode.success(RequestresourcetypesDevicerequest)
    "EnrollmentRequest" -> decode.success(RequestresourcetypesEnrollmentrequest)
    "ImmunizationRecommendation" ->
      decode.success(RequestresourcetypesImmunizationrecommendation)
    "MedicationRequest" -> decode.success(RequestresourcetypesMedicationrequest)
    "NutritionOrder" -> decode.success(RequestresourcetypesNutritionorder)
    "RequestOrchestration" ->
      decode.success(RequestresourcetypesRequestorchestration)
    "ServiceRequest" -> decode.success(RequestresourcetypesServicerequest)
    "SupplyRequest" -> decode.success(RequestresourcetypesSupplyrequest)
    "Task" -> decode.success(RequestresourcetypesTask)
    "Transport" -> decode.success(RequestresourcetypesTransport)
    "VisionPrescription" ->
      decode.success(RequestresourcetypesVisionprescription)
    _ -> decode.failure(RequestresourcetypesAppointment, "Requestresourcetypes")
  }
}

pub type Requeststatus {
  RequeststatusDraft
  RequeststatusActive
  RequeststatusOnhold
  RequeststatusRevoked
  RequeststatusCompleted
  RequeststatusEnteredinerror
  RequeststatusUnknown
}

pub fn requeststatus_to_json(requeststatus: Requeststatus) -> Json {
  json.string(requeststatus_to_string(requeststatus))
}

pub fn requeststatus_to_string(requeststatus: Requeststatus) -> String {
  case requeststatus {
    RequeststatusDraft -> "draft"
    RequeststatusActive -> "active"
    RequeststatusOnhold -> "on-hold"
    RequeststatusRevoked -> "revoked"
    RequeststatusCompleted -> "completed"
    RequeststatusEnteredinerror -> "entered-in-error"
    RequeststatusUnknown -> "unknown"
  }
}

pub fn requeststatus_from_string(s: String) -> Result(Requeststatus, Nil) {
  case s {
    "draft" -> Ok(RequeststatusDraft)
    "active" -> Ok(RequeststatusActive)
    "on-hold" -> Ok(RequeststatusOnhold)
    "revoked" -> Ok(RequeststatusRevoked)
    "completed" -> Ok(RequeststatusCompleted)
    "entered-in-error" -> Ok(RequeststatusEnteredinerror)
    "unknown" -> Ok(RequeststatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn requeststatus_decoder() -> Decoder(Requeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(RequeststatusDraft)
    "active" -> decode.success(RequeststatusActive)
    "on-hold" -> decode.success(RequeststatusOnhold)
    "revoked" -> decode.success(RequeststatusRevoked)
    "completed" -> decode.success(RequeststatusCompleted)
    "entered-in-error" -> decode.success(RequeststatusEnteredinerror)
    "unknown" -> decode.success(RequeststatusUnknown)
    _ -> decode.failure(RequeststatusDraft, "Requeststatus")
  }
}

pub type Resourceaggregationmode {
  ResourceaggregationmodeContained
  ResourceaggregationmodeReferenced
  ResourceaggregationmodeBundled
}

pub fn resourceaggregationmode_to_json(
  resourceaggregationmode: Resourceaggregationmode,
) -> Json {
  json.string(resourceaggregationmode_to_string(resourceaggregationmode))
}

pub fn resourceaggregationmode_to_string(
  resourceaggregationmode: Resourceaggregationmode,
) -> String {
  case resourceaggregationmode {
    ResourceaggregationmodeContained -> "contained"
    ResourceaggregationmodeReferenced -> "referenced"
    ResourceaggregationmodeBundled -> "bundled"
  }
}

pub fn resourceaggregationmode_from_string(
  s: String,
) -> Result(Resourceaggregationmode, Nil) {
  case s {
    "contained" -> Ok(ResourceaggregationmodeContained)
    "referenced" -> Ok(ResourceaggregationmodeReferenced)
    "bundled" -> Ok(ResourceaggregationmodeBundled)
    _ -> Error(Nil)
  }
}

pub fn resourceaggregationmode_decoder() -> Decoder(Resourceaggregationmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "contained" -> decode.success(ResourceaggregationmodeContained)
    "referenced" -> decode.success(ResourceaggregationmodeReferenced)
    "bundled" -> decode.success(ResourceaggregationmodeBundled)
    _ ->
      decode.failure(
        ResourceaggregationmodeContained,
        "Resourceaggregationmode",
      )
  }
}

pub type Resourceslicingrules {
  ResourceslicingrulesClosed
  ResourceslicingrulesOpen
  ResourceslicingrulesOpenatend
}

pub fn resourceslicingrules_to_json(
  resourceslicingrules: Resourceslicingrules,
) -> Json {
  json.string(resourceslicingrules_to_string(resourceslicingrules))
}

pub fn resourceslicingrules_to_string(
  resourceslicingrules: Resourceslicingrules,
) -> String {
  case resourceslicingrules {
    ResourceslicingrulesClosed -> "closed"
    ResourceslicingrulesOpen -> "open"
    ResourceslicingrulesOpenatend -> "openAtEnd"
  }
}

pub fn resourceslicingrules_from_string(
  s: String,
) -> Result(Resourceslicingrules, Nil) {
  case s {
    "closed" -> Ok(ResourceslicingrulesClosed)
    "open" -> Ok(ResourceslicingrulesOpen)
    "openAtEnd" -> Ok(ResourceslicingrulesOpenatend)
    _ -> Error(Nil)
  }
}

pub fn resourceslicingrules_decoder() -> Decoder(Resourceslicingrules) {
  use variant <- decode.then(decode.string)
  case variant {
    "closed" -> decode.success(ResourceslicingrulesClosed)
    "open" -> decode.success(ResourceslicingrulesOpen)
    "openAtEnd" -> decode.success(ResourceslicingrulesOpenatend)
    _ -> decode.failure(ResourceslicingrulesClosed, "Resourceslicingrules")
  }
}

pub type Resourcetypes {
  ResourcetypesAccount
  ResourcetypesActivitydefinition
  ResourcetypesActordefinition
  ResourcetypesAdministrableproductdefinition
  ResourcetypesAdverseevent
  ResourcetypesAllergyintolerance
  ResourcetypesAppointment
  ResourcetypesAppointmentresponse
  ResourcetypesArtifactassessment
  ResourcetypesAuditevent
  ResourcetypesBasic
  ResourcetypesBinary
  ResourcetypesBiologicallyderivedproduct
  ResourcetypesBiologicallyderivedproductdispense
  ResourcetypesBodystructure
  ResourcetypesBundle
  ResourcetypesCapabilitystatement
  ResourcetypesCareplan
  ResourcetypesCareteam
  ResourcetypesChargeitem
  ResourcetypesChargeitemdefinition
  ResourcetypesCitation
  ResourcetypesClaim
  ResourcetypesClaimresponse
  ResourcetypesClinicalimpression
  ResourcetypesClinicalusedefinition
  ResourcetypesCodesystem
  ResourcetypesCommunication
  ResourcetypesCommunicationrequest
  ResourcetypesCompartmentdefinition
  ResourcetypesComposition
  ResourcetypesConceptmap
  ResourcetypesCondition
  ResourcetypesConditiondefinition
  ResourcetypesConsent
  ResourcetypesContract
  ResourcetypesCoverage
  ResourcetypesCoverageeligibilityrequest
  ResourcetypesCoverageeligibilityresponse
  ResourcetypesDetectedissue
  ResourcetypesDevice
  ResourcetypesDeviceassociation
  ResourcetypesDevicedefinition
  ResourcetypesDevicedispense
  ResourcetypesDevicemetric
  ResourcetypesDevicerequest
  ResourcetypesDeviceusage
  ResourcetypesDiagnosticreport
  ResourcetypesDocumentreference
  ResourcetypesEncounter
  ResourcetypesEncounterhistory
  ResourcetypesEndpoint
  ResourcetypesEnrollmentrequest
  ResourcetypesEnrollmentresponse
  ResourcetypesEpisodeofcare
  ResourcetypesEventdefinition
  ResourcetypesEvidence
  ResourcetypesEvidencereport
  ResourcetypesEvidencevariable
  ResourcetypesExamplescenario
  ResourcetypesExplanationofbenefit
  ResourcetypesFamilymemberhistory
  ResourcetypesFlag
  ResourcetypesFormularyitem
  ResourcetypesGenomicstudy
  ResourcetypesGoal
  ResourcetypesGraphdefinition
  ResourcetypesGroup
  ResourcetypesGuidanceresponse
  ResourcetypesHealthcareservice
  ResourcetypesImagingselection
  ResourcetypesImagingstudy
  ResourcetypesImmunization
  ResourcetypesImmunizationevaluation
  ResourcetypesImmunizationrecommendation
  ResourcetypesImplementationguide
  ResourcetypesIngredient
  ResourcetypesInsuranceplan
  ResourcetypesInventoryitem
  ResourcetypesInventoryreport
  ResourcetypesInvoice
  ResourcetypesLibrary
  ResourcetypesLinkage
  ResourcetypesList
  ResourcetypesLocation
  ResourcetypesManufactureditemdefinition
  ResourcetypesMeasure
  ResourcetypesMeasurereport
  ResourcetypesMedication
  ResourcetypesMedicationadministration
  ResourcetypesMedicationdispense
  ResourcetypesMedicationknowledge
  ResourcetypesMedicationrequest
  ResourcetypesMedicationstatement
  ResourcetypesMedicinalproductdefinition
  ResourcetypesMessagedefinition
  ResourcetypesMessageheader
  ResourcetypesMolecularsequence
  ResourcetypesNamingsystem
  ResourcetypesNutritionintake
  ResourcetypesNutritionorder
  ResourcetypesNutritionproduct
  ResourcetypesObservation
  ResourcetypesObservationdefinition
  ResourcetypesOperationdefinition
  ResourcetypesOperationoutcome
  ResourcetypesOrganization
  ResourcetypesOrganizationaffiliation
  ResourcetypesPackagedproductdefinition
  ResourcetypesParameters
  ResourcetypesPatient
  ResourcetypesPaymentnotice
  ResourcetypesPaymentreconciliation
  ResourcetypesPermission
  ResourcetypesPerson
  ResourcetypesPlandefinition
  ResourcetypesPractitioner
  ResourcetypesPractitionerrole
  ResourcetypesProcedure
  ResourcetypesProvenance
  ResourcetypesQuestionnaire
  ResourcetypesQuestionnaireresponse
  ResourcetypesRegulatedauthorization
  ResourcetypesRelatedperson
  ResourcetypesRequestorchestration
  ResourcetypesRequirements
  ResourcetypesResearchstudy
  ResourcetypesResearchsubject
  ResourcetypesRiskassessment
  ResourcetypesSchedule
  ResourcetypesSearchparameter
  ResourcetypesServicerequest
  ResourcetypesSlot
  ResourcetypesSpecimen
  ResourcetypesSpecimendefinition
  ResourcetypesStructuredefinition
  ResourcetypesStructuremap
  ResourcetypesSubscription
  ResourcetypesSubscriptionstatus
  ResourcetypesSubscriptiontopic
  ResourcetypesSubstance
  ResourcetypesSubstancedefinition
  ResourcetypesSubstancenucleicacid
  ResourcetypesSubstancepolymer
  ResourcetypesSubstanceprotein
  ResourcetypesSubstancereferenceinformation
  ResourcetypesSubstancesourcematerial
  ResourcetypesSupplydelivery
  ResourcetypesSupplyrequest
  ResourcetypesTask
  ResourcetypesTerminologycapabilities
  ResourcetypesTestplan
  ResourcetypesTestreport
  ResourcetypesTestscript
  ResourcetypesTransport
  ResourcetypesValueset
  ResourcetypesVerificationresult
  ResourcetypesVisionprescription
}

pub fn resourcetypes_to_json(resourcetypes: Resourcetypes) -> Json {
  json.string(resourcetypes_to_string(resourcetypes))
}

pub fn resourcetypes_to_string(resourcetypes: Resourcetypes) -> String {
  case resourcetypes {
    ResourcetypesAccount -> "Account"
    ResourcetypesActivitydefinition -> "ActivityDefinition"
    ResourcetypesActordefinition -> "ActorDefinition"
    ResourcetypesAdministrableproductdefinition ->
      "AdministrableProductDefinition"
    ResourcetypesAdverseevent -> "AdverseEvent"
    ResourcetypesAllergyintolerance -> "AllergyIntolerance"
    ResourcetypesAppointment -> "Appointment"
    ResourcetypesAppointmentresponse -> "AppointmentResponse"
    ResourcetypesArtifactassessment -> "ArtifactAssessment"
    ResourcetypesAuditevent -> "AuditEvent"
    ResourcetypesBasic -> "Basic"
    ResourcetypesBinary -> "Binary"
    ResourcetypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    ResourcetypesBiologicallyderivedproductdispense ->
      "BiologicallyDerivedProductDispense"
    ResourcetypesBodystructure -> "BodyStructure"
    ResourcetypesBundle -> "Bundle"
    ResourcetypesCapabilitystatement -> "CapabilityStatement"
    ResourcetypesCareplan -> "CarePlan"
    ResourcetypesCareteam -> "CareTeam"
    ResourcetypesChargeitem -> "ChargeItem"
    ResourcetypesChargeitemdefinition -> "ChargeItemDefinition"
    ResourcetypesCitation -> "Citation"
    ResourcetypesClaim -> "Claim"
    ResourcetypesClaimresponse -> "ClaimResponse"
    ResourcetypesClinicalimpression -> "ClinicalImpression"
    ResourcetypesClinicalusedefinition -> "ClinicalUseDefinition"
    ResourcetypesCodesystem -> "CodeSystem"
    ResourcetypesCommunication -> "Communication"
    ResourcetypesCommunicationrequest -> "CommunicationRequest"
    ResourcetypesCompartmentdefinition -> "CompartmentDefinition"
    ResourcetypesComposition -> "Composition"
    ResourcetypesConceptmap -> "ConceptMap"
    ResourcetypesCondition -> "Condition"
    ResourcetypesConditiondefinition -> "ConditionDefinition"
    ResourcetypesConsent -> "Consent"
    ResourcetypesContract -> "Contract"
    ResourcetypesCoverage -> "Coverage"
    ResourcetypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    ResourcetypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    ResourcetypesDetectedissue -> "DetectedIssue"
    ResourcetypesDevice -> "Device"
    ResourcetypesDeviceassociation -> "DeviceAssociation"
    ResourcetypesDevicedefinition -> "DeviceDefinition"
    ResourcetypesDevicedispense -> "DeviceDispense"
    ResourcetypesDevicemetric -> "DeviceMetric"
    ResourcetypesDevicerequest -> "DeviceRequest"
    ResourcetypesDeviceusage -> "DeviceUsage"
    ResourcetypesDiagnosticreport -> "DiagnosticReport"
    ResourcetypesDocumentreference -> "DocumentReference"
    ResourcetypesEncounter -> "Encounter"
    ResourcetypesEncounterhistory -> "EncounterHistory"
    ResourcetypesEndpoint -> "Endpoint"
    ResourcetypesEnrollmentrequest -> "EnrollmentRequest"
    ResourcetypesEnrollmentresponse -> "EnrollmentResponse"
    ResourcetypesEpisodeofcare -> "EpisodeOfCare"
    ResourcetypesEventdefinition -> "EventDefinition"
    ResourcetypesEvidence -> "Evidence"
    ResourcetypesEvidencereport -> "EvidenceReport"
    ResourcetypesEvidencevariable -> "EvidenceVariable"
    ResourcetypesExamplescenario -> "ExampleScenario"
    ResourcetypesExplanationofbenefit -> "ExplanationOfBenefit"
    ResourcetypesFamilymemberhistory -> "FamilyMemberHistory"
    ResourcetypesFlag -> "Flag"
    ResourcetypesFormularyitem -> "FormularyItem"
    ResourcetypesGenomicstudy -> "GenomicStudy"
    ResourcetypesGoal -> "Goal"
    ResourcetypesGraphdefinition -> "GraphDefinition"
    ResourcetypesGroup -> "Group"
    ResourcetypesGuidanceresponse -> "GuidanceResponse"
    ResourcetypesHealthcareservice -> "HealthcareService"
    ResourcetypesImagingselection -> "ImagingSelection"
    ResourcetypesImagingstudy -> "ImagingStudy"
    ResourcetypesImmunization -> "Immunization"
    ResourcetypesImmunizationevaluation -> "ImmunizationEvaluation"
    ResourcetypesImmunizationrecommendation -> "ImmunizationRecommendation"
    ResourcetypesImplementationguide -> "ImplementationGuide"
    ResourcetypesIngredient -> "Ingredient"
    ResourcetypesInsuranceplan -> "InsurancePlan"
    ResourcetypesInventoryitem -> "InventoryItem"
    ResourcetypesInventoryreport -> "InventoryReport"
    ResourcetypesInvoice -> "Invoice"
    ResourcetypesLibrary -> "Library"
    ResourcetypesLinkage -> "Linkage"
    ResourcetypesList -> "List"
    ResourcetypesLocation -> "Location"
    ResourcetypesManufactureditemdefinition -> "ManufacturedItemDefinition"
    ResourcetypesMeasure -> "Measure"
    ResourcetypesMeasurereport -> "MeasureReport"
    ResourcetypesMedication -> "Medication"
    ResourcetypesMedicationadministration -> "MedicationAdministration"
    ResourcetypesMedicationdispense -> "MedicationDispense"
    ResourcetypesMedicationknowledge -> "MedicationKnowledge"
    ResourcetypesMedicationrequest -> "MedicationRequest"
    ResourcetypesMedicationstatement -> "MedicationStatement"
    ResourcetypesMedicinalproductdefinition -> "MedicinalProductDefinition"
    ResourcetypesMessagedefinition -> "MessageDefinition"
    ResourcetypesMessageheader -> "MessageHeader"
    ResourcetypesMolecularsequence -> "MolecularSequence"
    ResourcetypesNamingsystem -> "NamingSystem"
    ResourcetypesNutritionintake -> "NutritionIntake"
    ResourcetypesNutritionorder -> "NutritionOrder"
    ResourcetypesNutritionproduct -> "NutritionProduct"
    ResourcetypesObservation -> "Observation"
    ResourcetypesObservationdefinition -> "ObservationDefinition"
    ResourcetypesOperationdefinition -> "OperationDefinition"
    ResourcetypesOperationoutcome -> "OperationOutcome"
    ResourcetypesOrganization -> "Organization"
    ResourcetypesOrganizationaffiliation -> "OrganizationAffiliation"
    ResourcetypesPackagedproductdefinition -> "PackagedProductDefinition"
    ResourcetypesParameters -> "Parameters"
    ResourcetypesPatient -> "Patient"
    ResourcetypesPaymentnotice -> "PaymentNotice"
    ResourcetypesPaymentreconciliation -> "PaymentReconciliation"
    ResourcetypesPermission -> "Permission"
    ResourcetypesPerson -> "Person"
    ResourcetypesPlandefinition -> "PlanDefinition"
    ResourcetypesPractitioner -> "Practitioner"
    ResourcetypesPractitionerrole -> "PractitionerRole"
    ResourcetypesProcedure -> "Procedure"
    ResourcetypesProvenance -> "Provenance"
    ResourcetypesQuestionnaire -> "Questionnaire"
    ResourcetypesQuestionnaireresponse -> "QuestionnaireResponse"
    ResourcetypesRegulatedauthorization -> "RegulatedAuthorization"
    ResourcetypesRelatedperson -> "RelatedPerson"
    ResourcetypesRequestorchestration -> "RequestOrchestration"
    ResourcetypesRequirements -> "Requirements"
    ResourcetypesResearchstudy -> "ResearchStudy"
    ResourcetypesResearchsubject -> "ResearchSubject"
    ResourcetypesRiskassessment -> "RiskAssessment"
    ResourcetypesSchedule -> "Schedule"
    ResourcetypesSearchparameter -> "SearchParameter"
    ResourcetypesServicerequest -> "ServiceRequest"
    ResourcetypesSlot -> "Slot"
    ResourcetypesSpecimen -> "Specimen"
    ResourcetypesSpecimendefinition -> "SpecimenDefinition"
    ResourcetypesStructuredefinition -> "StructureDefinition"
    ResourcetypesStructuremap -> "StructureMap"
    ResourcetypesSubscription -> "Subscription"
    ResourcetypesSubscriptionstatus -> "SubscriptionStatus"
    ResourcetypesSubscriptiontopic -> "SubscriptionTopic"
    ResourcetypesSubstance -> "Substance"
    ResourcetypesSubstancedefinition -> "SubstanceDefinition"
    ResourcetypesSubstancenucleicacid -> "SubstanceNucleicAcid"
    ResourcetypesSubstancepolymer -> "SubstancePolymer"
    ResourcetypesSubstanceprotein -> "SubstanceProtein"
    ResourcetypesSubstancereferenceinformation ->
      "SubstanceReferenceInformation"
    ResourcetypesSubstancesourcematerial -> "SubstanceSourceMaterial"
    ResourcetypesSupplydelivery -> "SupplyDelivery"
    ResourcetypesSupplyrequest -> "SupplyRequest"
    ResourcetypesTask -> "Task"
    ResourcetypesTerminologycapabilities -> "TerminologyCapabilities"
    ResourcetypesTestplan -> "TestPlan"
    ResourcetypesTestreport -> "TestReport"
    ResourcetypesTestscript -> "TestScript"
    ResourcetypesTransport -> "Transport"
    ResourcetypesValueset -> "ValueSet"
    ResourcetypesVerificationresult -> "VerificationResult"
    ResourcetypesVisionprescription -> "VisionPrescription"
  }
}

pub fn resourcetypes_from_string(s: String) -> Result(Resourcetypes, Nil) {
  case s {
    "Account" -> Ok(ResourcetypesAccount)
    "ActivityDefinition" -> Ok(ResourcetypesActivitydefinition)
    "ActorDefinition" -> Ok(ResourcetypesActordefinition)
    "AdministrableProductDefinition" ->
      Ok(ResourcetypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(ResourcetypesAdverseevent)
    "AllergyIntolerance" -> Ok(ResourcetypesAllergyintolerance)
    "Appointment" -> Ok(ResourcetypesAppointment)
    "AppointmentResponse" -> Ok(ResourcetypesAppointmentresponse)
    "ArtifactAssessment" -> Ok(ResourcetypesArtifactassessment)
    "AuditEvent" -> Ok(ResourcetypesAuditevent)
    "Basic" -> Ok(ResourcetypesBasic)
    "Binary" -> Ok(ResourcetypesBinary)
    "BiologicallyDerivedProduct" -> Ok(ResourcetypesBiologicallyderivedproduct)
    "BiologicallyDerivedProductDispense" ->
      Ok(ResourcetypesBiologicallyderivedproductdispense)
    "BodyStructure" -> Ok(ResourcetypesBodystructure)
    "Bundle" -> Ok(ResourcetypesBundle)
    "CapabilityStatement" -> Ok(ResourcetypesCapabilitystatement)
    "CarePlan" -> Ok(ResourcetypesCareplan)
    "CareTeam" -> Ok(ResourcetypesCareteam)
    "ChargeItem" -> Ok(ResourcetypesChargeitem)
    "ChargeItemDefinition" -> Ok(ResourcetypesChargeitemdefinition)
    "Citation" -> Ok(ResourcetypesCitation)
    "Claim" -> Ok(ResourcetypesClaim)
    "ClaimResponse" -> Ok(ResourcetypesClaimresponse)
    "ClinicalImpression" -> Ok(ResourcetypesClinicalimpression)
    "ClinicalUseDefinition" -> Ok(ResourcetypesClinicalusedefinition)
    "CodeSystem" -> Ok(ResourcetypesCodesystem)
    "Communication" -> Ok(ResourcetypesCommunication)
    "CommunicationRequest" -> Ok(ResourcetypesCommunicationrequest)
    "CompartmentDefinition" -> Ok(ResourcetypesCompartmentdefinition)
    "Composition" -> Ok(ResourcetypesComposition)
    "ConceptMap" -> Ok(ResourcetypesConceptmap)
    "Condition" -> Ok(ResourcetypesCondition)
    "ConditionDefinition" -> Ok(ResourcetypesConditiondefinition)
    "Consent" -> Ok(ResourcetypesConsent)
    "Contract" -> Ok(ResourcetypesContract)
    "Coverage" -> Ok(ResourcetypesCoverage)
    "CoverageEligibilityRequest" -> Ok(ResourcetypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      Ok(ResourcetypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(ResourcetypesDetectedissue)
    "Device" -> Ok(ResourcetypesDevice)
    "DeviceAssociation" -> Ok(ResourcetypesDeviceassociation)
    "DeviceDefinition" -> Ok(ResourcetypesDevicedefinition)
    "DeviceDispense" -> Ok(ResourcetypesDevicedispense)
    "DeviceMetric" -> Ok(ResourcetypesDevicemetric)
    "DeviceRequest" -> Ok(ResourcetypesDevicerequest)
    "DeviceUsage" -> Ok(ResourcetypesDeviceusage)
    "DiagnosticReport" -> Ok(ResourcetypesDiagnosticreport)
    "DocumentReference" -> Ok(ResourcetypesDocumentreference)
    "Encounter" -> Ok(ResourcetypesEncounter)
    "EncounterHistory" -> Ok(ResourcetypesEncounterhistory)
    "Endpoint" -> Ok(ResourcetypesEndpoint)
    "EnrollmentRequest" -> Ok(ResourcetypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(ResourcetypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(ResourcetypesEpisodeofcare)
    "EventDefinition" -> Ok(ResourcetypesEventdefinition)
    "Evidence" -> Ok(ResourcetypesEvidence)
    "EvidenceReport" -> Ok(ResourcetypesEvidencereport)
    "EvidenceVariable" -> Ok(ResourcetypesEvidencevariable)
    "ExampleScenario" -> Ok(ResourcetypesExamplescenario)
    "ExplanationOfBenefit" -> Ok(ResourcetypesExplanationofbenefit)
    "FamilyMemberHistory" -> Ok(ResourcetypesFamilymemberhistory)
    "Flag" -> Ok(ResourcetypesFlag)
    "FormularyItem" -> Ok(ResourcetypesFormularyitem)
    "GenomicStudy" -> Ok(ResourcetypesGenomicstudy)
    "Goal" -> Ok(ResourcetypesGoal)
    "GraphDefinition" -> Ok(ResourcetypesGraphdefinition)
    "Group" -> Ok(ResourcetypesGroup)
    "GuidanceResponse" -> Ok(ResourcetypesGuidanceresponse)
    "HealthcareService" -> Ok(ResourcetypesHealthcareservice)
    "ImagingSelection" -> Ok(ResourcetypesImagingselection)
    "ImagingStudy" -> Ok(ResourcetypesImagingstudy)
    "Immunization" -> Ok(ResourcetypesImmunization)
    "ImmunizationEvaluation" -> Ok(ResourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(ResourcetypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(ResourcetypesImplementationguide)
    "Ingredient" -> Ok(ResourcetypesIngredient)
    "InsurancePlan" -> Ok(ResourcetypesInsuranceplan)
    "InventoryItem" -> Ok(ResourcetypesInventoryitem)
    "InventoryReport" -> Ok(ResourcetypesInventoryreport)
    "Invoice" -> Ok(ResourcetypesInvoice)
    "Library" -> Ok(ResourcetypesLibrary)
    "Linkage" -> Ok(ResourcetypesLinkage)
    "List" -> Ok(ResourcetypesList)
    "Location" -> Ok(ResourcetypesLocation)
    "ManufacturedItemDefinition" -> Ok(ResourcetypesManufactureditemdefinition)
    "Measure" -> Ok(ResourcetypesMeasure)
    "MeasureReport" -> Ok(ResourcetypesMeasurereport)
    "Medication" -> Ok(ResourcetypesMedication)
    "MedicationAdministration" -> Ok(ResourcetypesMedicationadministration)
    "MedicationDispense" -> Ok(ResourcetypesMedicationdispense)
    "MedicationKnowledge" -> Ok(ResourcetypesMedicationknowledge)
    "MedicationRequest" -> Ok(ResourcetypesMedicationrequest)
    "MedicationStatement" -> Ok(ResourcetypesMedicationstatement)
    "MedicinalProductDefinition" -> Ok(ResourcetypesMedicinalproductdefinition)
    "MessageDefinition" -> Ok(ResourcetypesMessagedefinition)
    "MessageHeader" -> Ok(ResourcetypesMessageheader)
    "MolecularSequence" -> Ok(ResourcetypesMolecularsequence)
    "NamingSystem" -> Ok(ResourcetypesNamingsystem)
    "NutritionIntake" -> Ok(ResourcetypesNutritionintake)
    "NutritionOrder" -> Ok(ResourcetypesNutritionorder)
    "NutritionProduct" -> Ok(ResourcetypesNutritionproduct)
    "Observation" -> Ok(ResourcetypesObservation)
    "ObservationDefinition" -> Ok(ResourcetypesObservationdefinition)
    "OperationDefinition" -> Ok(ResourcetypesOperationdefinition)
    "OperationOutcome" -> Ok(ResourcetypesOperationoutcome)
    "Organization" -> Ok(ResourcetypesOrganization)
    "OrganizationAffiliation" -> Ok(ResourcetypesOrganizationaffiliation)
    "PackagedProductDefinition" -> Ok(ResourcetypesPackagedproductdefinition)
    "Parameters" -> Ok(ResourcetypesParameters)
    "Patient" -> Ok(ResourcetypesPatient)
    "PaymentNotice" -> Ok(ResourcetypesPaymentnotice)
    "PaymentReconciliation" -> Ok(ResourcetypesPaymentreconciliation)
    "Permission" -> Ok(ResourcetypesPermission)
    "Person" -> Ok(ResourcetypesPerson)
    "PlanDefinition" -> Ok(ResourcetypesPlandefinition)
    "Practitioner" -> Ok(ResourcetypesPractitioner)
    "PractitionerRole" -> Ok(ResourcetypesPractitionerrole)
    "Procedure" -> Ok(ResourcetypesProcedure)
    "Provenance" -> Ok(ResourcetypesProvenance)
    "Questionnaire" -> Ok(ResourcetypesQuestionnaire)
    "QuestionnaireResponse" -> Ok(ResourcetypesQuestionnaireresponse)
    "RegulatedAuthorization" -> Ok(ResourcetypesRegulatedauthorization)
    "RelatedPerson" -> Ok(ResourcetypesRelatedperson)
    "RequestOrchestration" -> Ok(ResourcetypesRequestorchestration)
    "Requirements" -> Ok(ResourcetypesRequirements)
    "ResearchStudy" -> Ok(ResourcetypesResearchstudy)
    "ResearchSubject" -> Ok(ResourcetypesResearchsubject)
    "RiskAssessment" -> Ok(ResourcetypesRiskassessment)
    "Schedule" -> Ok(ResourcetypesSchedule)
    "SearchParameter" -> Ok(ResourcetypesSearchparameter)
    "ServiceRequest" -> Ok(ResourcetypesServicerequest)
    "Slot" -> Ok(ResourcetypesSlot)
    "Specimen" -> Ok(ResourcetypesSpecimen)
    "SpecimenDefinition" -> Ok(ResourcetypesSpecimendefinition)
    "StructureDefinition" -> Ok(ResourcetypesStructuredefinition)
    "StructureMap" -> Ok(ResourcetypesStructuremap)
    "Subscription" -> Ok(ResourcetypesSubscription)
    "SubscriptionStatus" -> Ok(ResourcetypesSubscriptionstatus)
    "SubscriptionTopic" -> Ok(ResourcetypesSubscriptiontopic)
    "Substance" -> Ok(ResourcetypesSubstance)
    "SubstanceDefinition" -> Ok(ResourcetypesSubstancedefinition)
    "SubstanceNucleicAcid" -> Ok(ResourcetypesSubstancenucleicacid)
    "SubstancePolymer" -> Ok(ResourcetypesSubstancepolymer)
    "SubstanceProtein" -> Ok(ResourcetypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      Ok(ResourcetypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> Ok(ResourcetypesSubstancesourcematerial)
    "SupplyDelivery" -> Ok(ResourcetypesSupplydelivery)
    "SupplyRequest" -> Ok(ResourcetypesSupplyrequest)
    "Task" -> Ok(ResourcetypesTask)
    "TerminologyCapabilities" -> Ok(ResourcetypesTerminologycapabilities)
    "TestPlan" -> Ok(ResourcetypesTestplan)
    "TestReport" -> Ok(ResourcetypesTestreport)
    "TestScript" -> Ok(ResourcetypesTestscript)
    "Transport" -> Ok(ResourcetypesTransport)
    "ValueSet" -> Ok(ResourcetypesValueset)
    "VerificationResult" -> Ok(ResourcetypesVerificationresult)
    "VisionPrescription" -> Ok(ResourcetypesVisionprescription)
    _ -> Error(Nil)
  }
}

pub fn resourcetypes_decoder() -> Decoder(Resourcetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Account" -> decode.success(ResourcetypesAccount)
    "ActivityDefinition" -> decode.success(ResourcetypesActivitydefinition)
    "ActorDefinition" -> decode.success(ResourcetypesActordefinition)
    "AdministrableProductDefinition" ->
      decode.success(ResourcetypesAdministrableproductdefinition)
    "AdverseEvent" -> decode.success(ResourcetypesAdverseevent)
    "AllergyIntolerance" -> decode.success(ResourcetypesAllergyintolerance)
    "Appointment" -> decode.success(ResourcetypesAppointment)
    "AppointmentResponse" -> decode.success(ResourcetypesAppointmentresponse)
    "ArtifactAssessment" -> decode.success(ResourcetypesArtifactassessment)
    "AuditEvent" -> decode.success(ResourcetypesAuditevent)
    "Basic" -> decode.success(ResourcetypesBasic)
    "Binary" -> decode.success(ResourcetypesBinary)
    "BiologicallyDerivedProduct" ->
      decode.success(ResourcetypesBiologicallyderivedproduct)
    "BiologicallyDerivedProductDispense" ->
      decode.success(ResourcetypesBiologicallyderivedproductdispense)
    "BodyStructure" -> decode.success(ResourcetypesBodystructure)
    "Bundle" -> decode.success(ResourcetypesBundle)
    "CapabilityStatement" -> decode.success(ResourcetypesCapabilitystatement)
    "CarePlan" -> decode.success(ResourcetypesCareplan)
    "CareTeam" -> decode.success(ResourcetypesCareteam)
    "ChargeItem" -> decode.success(ResourcetypesChargeitem)
    "ChargeItemDefinition" -> decode.success(ResourcetypesChargeitemdefinition)
    "Citation" -> decode.success(ResourcetypesCitation)
    "Claim" -> decode.success(ResourcetypesClaim)
    "ClaimResponse" -> decode.success(ResourcetypesClaimresponse)
    "ClinicalImpression" -> decode.success(ResourcetypesClinicalimpression)
    "ClinicalUseDefinition" ->
      decode.success(ResourcetypesClinicalusedefinition)
    "CodeSystem" -> decode.success(ResourcetypesCodesystem)
    "Communication" -> decode.success(ResourcetypesCommunication)
    "CommunicationRequest" -> decode.success(ResourcetypesCommunicationrequest)
    "CompartmentDefinition" ->
      decode.success(ResourcetypesCompartmentdefinition)
    "Composition" -> decode.success(ResourcetypesComposition)
    "ConceptMap" -> decode.success(ResourcetypesConceptmap)
    "Condition" -> decode.success(ResourcetypesCondition)
    "ConditionDefinition" -> decode.success(ResourcetypesConditiondefinition)
    "Consent" -> decode.success(ResourcetypesConsent)
    "Contract" -> decode.success(ResourcetypesContract)
    "Coverage" -> decode.success(ResourcetypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(ResourcetypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(ResourcetypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(ResourcetypesDetectedissue)
    "Device" -> decode.success(ResourcetypesDevice)
    "DeviceAssociation" -> decode.success(ResourcetypesDeviceassociation)
    "DeviceDefinition" -> decode.success(ResourcetypesDevicedefinition)
    "DeviceDispense" -> decode.success(ResourcetypesDevicedispense)
    "DeviceMetric" -> decode.success(ResourcetypesDevicemetric)
    "DeviceRequest" -> decode.success(ResourcetypesDevicerequest)
    "DeviceUsage" -> decode.success(ResourcetypesDeviceusage)
    "DiagnosticReport" -> decode.success(ResourcetypesDiagnosticreport)
    "DocumentReference" -> decode.success(ResourcetypesDocumentreference)
    "Encounter" -> decode.success(ResourcetypesEncounter)
    "EncounterHistory" -> decode.success(ResourcetypesEncounterhistory)
    "Endpoint" -> decode.success(ResourcetypesEndpoint)
    "EnrollmentRequest" -> decode.success(ResourcetypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(ResourcetypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(ResourcetypesEpisodeofcare)
    "EventDefinition" -> decode.success(ResourcetypesEventdefinition)
    "Evidence" -> decode.success(ResourcetypesEvidence)
    "EvidenceReport" -> decode.success(ResourcetypesEvidencereport)
    "EvidenceVariable" -> decode.success(ResourcetypesEvidencevariable)
    "ExampleScenario" -> decode.success(ResourcetypesExamplescenario)
    "ExplanationOfBenefit" -> decode.success(ResourcetypesExplanationofbenefit)
    "FamilyMemberHistory" -> decode.success(ResourcetypesFamilymemberhistory)
    "Flag" -> decode.success(ResourcetypesFlag)
    "FormularyItem" -> decode.success(ResourcetypesFormularyitem)
    "GenomicStudy" -> decode.success(ResourcetypesGenomicstudy)
    "Goal" -> decode.success(ResourcetypesGoal)
    "GraphDefinition" -> decode.success(ResourcetypesGraphdefinition)
    "Group" -> decode.success(ResourcetypesGroup)
    "GuidanceResponse" -> decode.success(ResourcetypesGuidanceresponse)
    "HealthcareService" -> decode.success(ResourcetypesHealthcareservice)
    "ImagingSelection" -> decode.success(ResourcetypesImagingselection)
    "ImagingStudy" -> decode.success(ResourcetypesImagingstudy)
    "Immunization" -> decode.success(ResourcetypesImmunization)
    "ImmunizationEvaluation" ->
      decode.success(ResourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(ResourcetypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(ResourcetypesImplementationguide)
    "Ingredient" -> decode.success(ResourcetypesIngredient)
    "InsurancePlan" -> decode.success(ResourcetypesInsuranceplan)
    "InventoryItem" -> decode.success(ResourcetypesInventoryitem)
    "InventoryReport" -> decode.success(ResourcetypesInventoryreport)
    "Invoice" -> decode.success(ResourcetypesInvoice)
    "Library" -> decode.success(ResourcetypesLibrary)
    "Linkage" -> decode.success(ResourcetypesLinkage)
    "List" -> decode.success(ResourcetypesList)
    "Location" -> decode.success(ResourcetypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(ResourcetypesManufactureditemdefinition)
    "Measure" -> decode.success(ResourcetypesMeasure)
    "MeasureReport" -> decode.success(ResourcetypesMeasurereport)
    "Medication" -> decode.success(ResourcetypesMedication)
    "MedicationAdministration" ->
      decode.success(ResourcetypesMedicationadministration)
    "MedicationDispense" -> decode.success(ResourcetypesMedicationdispense)
    "MedicationKnowledge" -> decode.success(ResourcetypesMedicationknowledge)
    "MedicationRequest" -> decode.success(ResourcetypesMedicationrequest)
    "MedicationStatement" -> decode.success(ResourcetypesMedicationstatement)
    "MedicinalProductDefinition" ->
      decode.success(ResourcetypesMedicinalproductdefinition)
    "MessageDefinition" -> decode.success(ResourcetypesMessagedefinition)
    "MessageHeader" -> decode.success(ResourcetypesMessageheader)
    "MolecularSequence" -> decode.success(ResourcetypesMolecularsequence)
    "NamingSystem" -> decode.success(ResourcetypesNamingsystem)
    "NutritionIntake" -> decode.success(ResourcetypesNutritionintake)
    "NutritionOrder" -> decode.success(ResourcetypesNutritionorder)
    "NutritionProduct" -> decode.success(ResourcetypesNutritionproduct)
    "Observation" -> decode.success(ResourcetypesObservation)
    "ObservationDefinition" ->
      decode.success(ResourcetypesObservationdefinition)
    "OperationDefinition" -> decode.success(ResourcetypesOperationdefinition)
    "OperationOutcome" -> decode.success(ResourcetypesOperationoutcome)
    "Organization" -> decode.success(ResourcetypesOrganization)
    "OrganizationAffiliation" ->
      decode.success(ResourcetypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      decode.success(ResourcetypesPackagedproductdefinition)
    "Parameters" -> decode.success(ResourcetypesParameters)
    "Patient" -> decode.success(ResourcetypesPatient)
    "PaymentNotice" -> decode.success(ResourcetypesPaymentnotice)
    "PaymentReconciliation" ->
      decode.success(ResourcetypesPaymentreconciliation)
    "Permission" -> decode.success(ResourcetypesPermission)
    "Person" -> decode.success(ResourcetypesPerson)
    "PlanDefinition" -> decode.success(ResourcetypesPlandefinition)
    "Practitioner" -> decode.success(ResourcetypesPractitioner)
    "PractitionerRole" -> decode.success(ResourcetypesPractitionerrole)
    "Procedure" -> decode.success(ResourcetypesProcedure)
    "Provenance" -> decode.success(ResourcetypesProvenance)
    "Questionnaire" -> decode.success(ResourcetypesQuestionnaire)
    "QuestionnaireResponse" ->
      decode.success(ResourcetypesQuestionnaireresponse)
    "RegulatedAuthorization" ->
      decode.success(ResourcetypesRegulatedauthorization)
    "RelatedPerson" -> decode.success(ResourcetypesRelatedperson)
    "RequestOrchestration" -> decode.success(ResourcetypesRequestorchestration)
    "Requirements" -> decode.success(ResourcetypesRequirements)
    "ResearchStudy" -> decode.success(ResourcetypesResearchstudy)
    "ResearchSubject" -> decode.success(ResourcetypesResearchsubject)
    "RiskAssessment" -> decode.success(ResourcetypesRiskassessment)
    "Schedule" -> decode.success(ResourcetypesSchedule)
    "SearchParameter" -> decode.success(ResourcetypesSearchparameter)
    "ServiceRequest" -> decode.success(ResourcetypesServicerequest)
    "Slot" -> decode.success(ResourcetypesSlot)
    "Specimen" -> decode.success(ResourcetypesSpecimen)
    "SpecimenDefinition" -> decode.success(ResourcetypesSpecimendefinition)
    "StructureDefinition" -> decode.success(ResourcetypesStructuredefinition)
    "StructureMap" -> decode.success(ResourcetypesStructuremap)
    "Subscription" -> decode.success(ResourcetypesSubscription)
    "SubscriptionStatus" -> decode.success(ResourcetypesSubscriptionstatus)
    "SubscriptionTopic" -> decode.success(ResourcetypesSubscriptiontopic)
    "Substance" -> decode.success(ResourcetypesSubstance)
    "SubstanceDefinition" -> decode.success(ResourcetypesSubstancedefinition)
    "SubstanceNucleicAcid" -> decode.success(ResourcetypesSubstancenucleicacid)
    "SubstancePolymer" -> decode.success(ResourcetypesSubstancepolymer)
    "SubstanceProtein" -> decode.success(ResourcetypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      decode.success(ResourcetypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" ->
      decode.success(ResourcetypesSubstancesourcematerial)
    "SupplyDelivery" -> decode.success(ResourcetypesSupplydelivery)
    "SupplyRequest" -> decode.success(ResourcetypesSupplyrequest)
    "Task" -> decode.success(ResourcetypesTask)
    "TerminologyCapabilities" ->
      decode.success(ResourcetypesTerminologycapabilities)
    "TestPlan" -> decode.success(ResourcetypesTestplan)
    "TestReport" -> decode.success(ResourcetypesTestreport)
    "TestScript" -> decode.success(ResourcetypesTestscript)
    "Transport" -> decode.success(ResourcetypesTransport)
    "ValueSet" -> decode.success(ResourcetypesValueset)
    "VerificationResult" -> decode.success(ResourcetypesVerificationresult)
    "VisionPrescription" -> decode.success(ResourcetypesVisionprescription)
    _ -> decode.failure(ResourcetypesAccount, "Resourcetypes")
  }
}

pub type Responsecode {
  ResponsecodeOk
  ResponsecodeTransienterror
  ResponsecodeFatalerror
}

pub fn responsecode_to_json(responsecode: Responsecode) -> Json {
  json.string(responsecode_to_string(responsecode))
}

pub fn responsecode_to_string(responsecode: Responsecode) -> String {
  case responsecode {
    ResponsecodeOk -> "ok"
    ResponsecodeTransienterror -> "transient-error"
    ResponsecodeFatalerror -> "fatal-error"
  }
}

pub fn responsecode_from_string(s: String) -> Result(Responsecode, Nil) {
  case s {
    "ok" -> Ok(ResponsecodeOk)
    "transient-error" -> Ok(ResponsecodeTransienterror)
    "fatal-error" -> Ok(ResponsecodeFatalerror)
    _ -> Error(Nil)
  }
}

pub fn responsecode_decoder() -> Decoder(Responsecode) {
  use variant <- decode.then(decode.string)
  case variant {
    "ok" -> decode.success(ResponsecodeOk)
    "transient-error" -> decode.success(ResponsecodeTransienterror)
    "fatal-error" -> decode.success(ResponsecodeFatalerror)
    _ -> decode.failure(ResponsecodeOk, "Responsecode")
  }
}

pub type Restfulcapabilitymode {
  RestfulcapabilitymodeClient
  RestfulcapabilitymodeServer
}

pub fn restfulcapabilitymode_to_json(
  restfulcapabilitymode: Restfulcapabilitymode,
) -> Json {
  json.string(restfulcapabilitymode_to_string(restfulcapabilitymode))
}

pub fn restfulcapabilitymode_to_string(
  restfulcapabilitymode: Restfulcapabilitymode,
) -> String {
  case restfulcapabilitymode {
    RestfulcapabilitymodeClient -> "client"
    RestfulcapabilitymodeServer -> "server"
  }
}

pub fn restfulcapabilitymode_from_string(
  s: String,
) -> Result(Restfulcapabilitymode, Nil) {
  case s {
    "client" -> Ok(RestfulcapabilitymodeClient)
    "server" -> Ok(RestfulcapabilitymodeServer)
    _ -> Error(Nil)
  }
}

pub fn restfulcapabilitymode_decoder() -> Decoder(Restfulcapabilitymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "client" -> decode.success(RestfulcapabilitymodeClient)
    "server" -> decode.success(RestfulcapabilitymodeServer)
    _ -> decode.failure(RestfulcapabilitymodeClient, "Restfulcapabilitymode")
  }
}

pub type Searchcomparator {
  SearchcomparatorEq
  SearchcomparatorNe
  SearchcomparatorGt
  SearchcomparatorLt
  SearchcomparatorGe
  SearchcomparatorLe
  SearchcomparatorSa
  SearchcomparatorEb
  SearchcomparatorAp
}

pub fn searchcomparator_to_json(searchcomparator: Searchcomparator) -> Json {
  json.string(searchcomparator_to_string(searchcomparator))
}

pub fn searchcomparator_to_string(searchcomparator: Searchcomparator) -> String {
  case searchcomparator {
    SearchcomparatorEq -> "eq"
    SearchcomparatorNe -> "ne"
    SearchcomparatorGt -> "gt"
    SearchcomparatorLt -> "lt"
    SearchcomparatorGe -> "ge"
    SearchcomparatorLe -> "le"
    SearchcomparatorSa -> "sa"
    SearchcomparatorEb -> "eb"
    SearchcomparatorAp -> "ap"
  }
}

pub fn searchcomparator_from_string(s: String) -> Result(Searchcomparator, Nil) {
  case s {
    "eq" -> Ok(SearchcomparatorEq)
    "ne" -> Ok(SearchcomparatorNe)
    "gt" -> Ok(SearchcomparatorGt)
    "lt" -> Ok(SearchcomparatorLt)
    "ge" -> Ok(SearchcomparatorGe)
    "le" -> Ok(SearchcomparatorLe)
    "sa" -> Ok(SearchcomparatorSa)
    "eb" -> Ok(SearchcomparatorEb)
    "ap" -> Ok(SearchcomparatorAp)
    _ -> Error(Nil)
  }
}

pub fn searchcomparator_decoder() -> Decoder(Searchcomparator) {
  use variant <- decode.then(decode.string)
  case variant {
    "eq" -> decode.success(SearchcomparatorEq)
    "ne" -> decode.success(SearchcomparatorNe)
    "gt" -> decode.success(SearchcomparatorGt)
    "lt" -> decode.success(SearchcomparatorLt)
    "ge" -> decode.success(SearchcomparatorGe)
    "le" -> decode.success(SearchcomparatorLe)
    "sa" -> decode.success(SearchcomparatorSa)
    "eb" -> decode.success(SearchcomparatorEb)
    "ap" -> decode.success(SearchcomparatorAp)
    _ -> decode.failure(SearchcomparatorEq, "Searchcomparator")
  }
}

pub type Searchentrymode {
  SearchentrymodeMatch
  SearchentrymodeInclude
  SearchentrymodeOutcome
}

pub fn searchentrymode_to_json(searchentrymode: Searchentrymode) -> Json {
  json.string(searchentrymode_to_string(searchentrymode))
}

pub fn searchentrymode_to_string(searchentrymode: Searchentrymode) -> String {
  case searchentrymode {
    SearchentrymodeMatch -> "match"
    SearchentrymodeInclude -> "include"
    SearchentrymodeOutcome -> "outcome"
  }
}

pub fn searchentrymode_from_string(s: String) -> Result(Searchentrymode, Nil) {
  case s {
    "match" -> Ok(SearchentrymodeMatch)
    "include" -> Ok(SearchentrymodeInclude)
    "outcome" -> Ok(SearchentrymodeOutcome)
    _ -> Error(Nil)
  }
}

pub fn searchentrymode_decoder() -> Decoder(Searchentrymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "match" -> decode.success(SearchentrymodeMatch)
    "include" -> decode.success(SearchentrymodeInclude)
    "outcome" -> decode.success(SearchentrymodeOutcome)
    _ -> decode.failure(SearchentrymodeMatch, "Searchentrymode")
  }
}

pub type Searchmodifiercode {
  SearchmodifiercodeMissing
  SearchmodifiercodeExact
  SearchmodifiercodeContains
  SearchmodifiercodeNot
  SearchmodifiercodeText
  SearchmodifiercodeIn
  SearchmodifiercodeNotin
  SearchmodifiercodeBelow
  SearchmodifiercodeAbove
  SearchmodifiercodeType
  SearchmodifiercodeIdentifier
  SearchmodifiercodeOftype
  SearchmodifiercodeCodetext
  SearchmodifiercodeTextadvanced
  SearchmodifiercodeIterate
}

pub fn searchmodifiercode_to_json(
  searchmodifiercode: Searchmodifiercode,
) -> Json {
  json.string(searchmodifiercode_to_string(searchmodifiercode))
}

pub fn searchmodifiercode_to_string(
  searchmodifiercode: Searchmodifiercode,
) -> String {
  case searchmodifiercode {
    SearchmodifiercodeMissing -> "missing"
    SearchmodifiercodeExact -> "exact"
    SearchmodifiercodeContains -> "contains"
    SearchmodifiercodeNot -> "not"
    SearchmodifiercodeText -> "text"
    SearchmodifiercodeIn -> "in"
    SearchmodifiercodeNotin -> "not-in"
    SearchmodifiercodeBelow -> "below"
    SearchmodifiercodeAbove -> "above"
    SearchmodifiercodeType -> "type"
    SearchmodifiercodeIdentifier -> "identifier"
    SearchmodifiercodeOftype -> "of-type"
    SearchmodifiercodeCodetext -> "code-text"
    SearchmodifiercodeTextadvanced -> "text-advanced"
    SearchmodifiercodeIterate -> "iterate"
  }
}

pub fn searchmodifiercode_from_string(
  s: String,
) -> Result(Searchmodifiercode, Nil) {
  case s {
    "missing" -> Ok(SearchmodifiercodeMissing)
    "exact" -> Ok(SearchmodifiercodeExact)
    "contains" -> Ok(SearchmodifiercodeContains)
    "not" -> Ok(SearchmodifiercodeNot)
    "text" -> Ok(SearchmodifiercodeText)
    "in" -> Ok(SearchmodifiercodeIn)
    "not-in" -> Ok(SearchmodifiercodeNotin)
    "below" -> Ok(SearchmodifiercodeBelow)
    "above" -> Ok(SearchmodifiercodeAbove)
    "type" -> Ok(SearchmodifiercodeType)
    "identifier" -> Ok(SearchmodifiercodeIdentifier)
    "of-type" -> Ok(SearchmodifiercodeOftype)
    "code-text" -> Ok(SearchmodifiercodeCodetext)
    "text-advanced" -> Ok(SearchmodifiercodeTextadvanced)
    "iterate" -> Ok(SearchmodifiercodeIterate)
    _ -> Error(Nil)
  }
}

pub fn searchmodifiercode_decoder() -> Decoder(Searchmodifiercode) {
  use variant <- decode.then(decode.string)
  case variant {
    "missing" -> decode.success(SearchmodifiercodeMissing)
    "exact" -> decode.success(SearchmodifiercodeExact)
    "contains" -> decode.success(SearchmodifiercodeContains)
    "not" -> decode.success(SearchmodifiercodeNot)
    "text" -> decode.success(SearchmodifiercodeText)
    "in" -> decode.success(SearchmodifiercodeIn)
    "not-in" -> decode.success(SearchmodifiercodeNotin)
    "below" -> decode.success(SearchmodifiercodeBelow)
    "above" -> decode.success(SearchmodifiercodeAbove)
    "type" -> decode.success(SearchmodifiercodeType)
    "identifier" -> decode.success(SearchmodifiercodeIdentifier)
    "of-type" -> decode.success(SearchmodifiercodeOftype)
    "code-text" -> decode.success(SearchmodifiercodeCodetext)
    "text-advanced" -> decode.success(SearchmodifiercodeTextadvanced)
    "iterate" -> decode.success(SearchmodifiercodeIterate)
    _ -> decode.failure(SearchmodifiercodeMissing, "Searchmodifiercode")
  }
}

pub type Searchparamtype {
  SearchparamtypeNumber
  SearchparamtypeDate
  SearchparamtypeString
  SearchparamtypeToken
  SearchparamtypeReference
  SearchparamtypeComposite
  SearchparamtypeQuantity
  SearchparamtypeUri
  SearchparamtypeSpecial
}

pub fn searchparamtype_to_json(searchparamtype: Searchparamtype) -> Json {
  json.string(searchparamtype_to_string(searchparamtype))
}

pub fn searchparamtype_to_string(searchparamtype: Searchparamtype) -> String {
  case searchparamtype {
    SearchparamtypeNumber -> "number"
    SearchparamtypeDate -> "date"
    SearchparamtypeString -> "string"
    SearchparamtypeToken -> "token"
    SearchparamtypeReference -> "reference"
    SearchparamtypeComposite -> "composite"
    SearchparamtypeQuantity -> "quantity"
    SearchparamtypeUri -> "uri"
    SearchparamtypeSpecial -> "special"
  }
}

pub fn searchparamtype_from_string(s: String) -> Result(Searchparamtype, Nil) {
  case s {
    "number" -> Ok(SearchparamtypeNumber)
    "date" -> Ok(SearchparamtypeDate)
    "string" -> Ok(SearchparamtypeString)
    "token" -> Ok(SearchparamtypeToken)
    "reference" -> Ok(SearchparamtypeReference)
    "composite" -> Ok(SearchparamtypeComposite)
    "quantity" -> Ok(SearchparamtypeQuantity)
    "uri" -> Ok(SearchparamtypeUri)
    "special" -> Ok(SearchparamtypeSpecial)
    _ -> Error(Nil)
  }
}

pub fn searchparamtype_decoder() -> Decoder(Searchparamtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "number" -> decode.success(SearchparamtypeNumber)
    "date" -> decode.success(SearchparamtypeDate)
    "string" -> decode.success(SearchparamtypeString)
    "token" -> decode.success(SearchparamtypeToken)
    "reference" -> decode.success(SearchparamtypeReference)
    "composite" -> decode.success(SearchparamtypeComposite)
    "quantity" -> decode.success(SearchparamtypeQuantity)
    "uri" -> decode.success(SearchparamtypeUri)
    "special" -> decode.success(SearchparamtypeSpecial)
    _ -> decode.failure(SearchparamtypeNumber, "Searchparamtype")
  }
}

pub type Searchprocessingmode {
  SearchprocessingmodeNormal
  SearchprocessingmodePhonetic
  SearchprocessingmodeOther
}

pub fn searchprocessingmode_to_json(
  searchprocessingmode: Searchprocessingmode,
) -> Json {
  json.string(searchprocessingmode_to_string(searchprocessingmode))
}

pub fn searchprocessingmode_to_string(
  searchprocessingmode: Searchprocessingmode,
) -> String {
  case searchprocessingmode {
    SearchprocessingmodeNormal -> "normal"
    SearchprocessingmodePhonetic -> "phonetic"
    SearchprocessingmodeOther -> "other"
  }
}

pub fn searchprocessingmode_from_string(
  s: String,
) -> Result(Searchprocessingmode, Nil) {
  case s {
    "normal" -> Ok(SearchprocessingmodeNormal)
    "phonetic" -> Ok(SearchprocessingmodePhonetic)
    "other" -> Ok(SearchprocessingmodeOther)
    _ -> Error(Nil)
  }
}

pub fn searchprocessingmode_decoder() -> Decoder(Searchprocessingmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "normal" -> decode.success(SearchprocessingmodeNormal)
    "phonetic" -> decode.success(SearchprocessingmodePhonetic)
    "other" -> decode.success(SearchprocessingmodeOther)
    _ -> decode.failure(SearchprocessingmodeNormal, "Searchprocessingmode")
  }
}

pub type Sequencetype {
  SequencetypeAa
  SequencetypeDna
  SequencetypeRna
}

pub fn sequencetype_to_json(sequencetype: Sequencetype) -> Json {
  json.string(sequencetype_to_string(sequencetype))
}

pub fn sequencetype_to_string(sequencetype: Sequencetype) -> String {
  case sequencetype {
    SequencetypeAa -> "aa"
    SequencetypeDna -> "dna"
    SequencetypeRna -> "rna"
  }
}

pub fn sequencetype_from_string(s: String) -> Result(Sequencetype, Nil) {
  case s {
    "aa" -> Ok(SequencetypeAa)
    "dna" -> Ok(SequencetypeDna)
    "rna" -> Ok(SequencetypeRna)
    _ -> Error(Nil)
  }
}

pub fn sequencetype_decoder() -> Decoder(Sequencetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "aa" -> decode.success(SequencetypeAa)
    "dna" -> decode.success(SequencetypeDna)
    "rna" -> decode.success(SequencetypeRna)
    _ -> decode.failure(SequencetypeAa, "Sequencetype")
  }
}

pub type Slotstatus {
  SlotstatusBusy
  SlotstatusFree
  SlotstatusBusyunavailable
  SlotstatusBusytentative
  SlotstatusEnteredinerror
}

pub fn slotstatus_to_json(slotstatus: Slotstatus) -> Json {
  json.string(slotstatus_to_string(slotstatus))
}

pub fn slotstatus_to_string(slotstatus: Slotstatus) -> String {
  case slotstatus {
    SlotstatusBusy -> "busy"
    SlotstatusFree -> "free"
    SlotstatusBusyunavailable -> "busy-unavailable"
    SlotstatusBusytentative -> "busy-tentative"
    SlotstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn slotstatus_from_string(s: String) -> Result(Slotstatus, Nil) {
  case s {
    "busy" -> Ok(SlotstatusBusy)
    "free" -> Ok(SlotstatusFree)
    "busy-unavailable" -> Ok(SlotstatusBusyunavailable)
    "busy-tentative" -> Ok(SlotstatusBusytentative)
    "entered-in-error" -> Ok(SlotstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn slotstatus_decoder() -> Decoder(Slotstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "busy" -> decode.success(SlotstatusBusy)
    "free" -> decode.success(SlotstatusFree)
    "busy-unavailable" -> decode.success(SlotstatusBusyunavailable)
    "busy-tentative" -> decode.success(SlotstatusBusytentative)
    "entered-in-error" -> decode.success(SlotstatusEnteredinerror)
    _ -> decode.failure(SlotstatusBusy, "Slotstatus")
  }
}

pub type Sortdirection {
  SortdirectionAscending
  SortdirectionDescending
}

pub fn sortdirection_to_json(sortdirection: Sortdirection) -> Json {
  json.string(sortdirection_to_string(sortdirection))
}

pub fn sortdirection_to_string(sortdirection: Sortdirection) -> String {
  case sortdirection {
    SortdirectionAscending -> "ascending"
    SortdirectionDescending -> "descending"
  }
}

pub fn sortdirection_from_string(s: String) -> Result(Sortdirection, Nil) {
  case s {
    "ascending" -> Ok(SortdirectionAscending)
    "descending" -> Ok(SortdirectionDescending)
    _ -> Error(Nil)
  }
}

pub fn sortdirection_decoder() -> Decoder(Sortdirection) {
  use variant <- decode.then(decode.string)
  case variant {
    "ascending" -> decode.success(SortdirectionAscending)
    "descending" -> decode.success(SortdirectionDescending)
    _ -> decode.failure(SortdirectionAscending, "Sortdirection")
  }
}

pub type Spdxlicense {
  SpdxlicenseNotopensource
  Spdxlicense0bsd
  SpdxlicenseAal
  SpdxlicenseAbstyles
  SpdxlicenseAdobe2006
  SpdxlicenseAdobeglyph
  SpdxlicenseAdsl
  SpdxlicenseAfl11
  SpdxlicenseAfl12
  SpdxlicenseAfl20
  SpdxlicenseAfl21
  SpdxlicenseAfl30
  SpdxlicenseAfmparse
  SpdxlicenseAgpl10only
  SpdxlicenseAgpl10orlater
  SpdxlicenseAgpl30only
  SpdxlicenseAgpl30orlater
  SpdxlicenseAladdin
  SpdxlicenseAmdplpa
  SpdxlicenseAml
  SpdxlicenseAmpas
  SpdxlicenseAntlrpd
  SpdxlicenseApache10
  SpdxlicenseApache11
  SpdxlicenseApache20
  SpdxlicenseApafml
  SpdxlicenseApl10
  SpdxlicenseApsl10
  SpdxlicenseApsl11
  SpdxlicenseApsl12
  SpdxlicenseApsl20
  SpdxlicenseArtistic10cl8
  SpdxlicenseArtistic10perl
  SpdxlicenseArtistic10
  SpdxlicenseArtistic20
  SpdxlicenseBahyph
  SpdxlicenseBarr
  SpdxlicenseBeerware
  SpdxlicenseBittorrent10
  SpdxlicenseBittorrent11
  SpdxlicenseBorceux
  SpdxlicenseBsd1clause
  SpdxlicenseBsd2clausefreebsd
  SpdxlicenseBsd2clausenetbsd
  SpdxlicenseBsd2clausepatent
  SpdxlicenseBsd2clause
  SpdxlicenseBsd3clauseattribution
  SpdxlicenseBsd3clauseclear
  SpdxlicenseBsd3clauselbnl
  SpdxlicenseBsd3clausenonuclearlicense2014
  SpdxlicenseBsd3clausenonuclearlicense
  SpdxlicenseBsd3clausenonuclearwarranty
  SpdxlicenseBsd3clause
  SpdxlicenseBsd4clauseuc
  SpdxlicenseBsd4clause
  SpdxlicenseBsdprotection
  SpdxlicenseBsdsourcecode
  SpdxlicenseBsl10
  SpdxlicenseBzip2105
  SpdxlicenseBzip2106
  SpdxlicenseCaldera
  SpdxlicenseCatosl11
  SpdxlicenseCcby10
  SpdxlicenseCcby20
  SpdxlicenseCcby25
  SpdxlicenseCcby30
  SpdxlicenseCcby40
  SpdxlicenseCcbync10
  SpdxlicenseCcbync20
  SpdxlicenseCcbync25
  SpdxlicenseCcbync30
  SpdxlicenseCcbync40
  SpdxlicenseCcbyncnd10
  SpdxlicenseCcbyncnd20
  SpdxlicenseCcbyncnd25
  SpdxlicenseCcbyncnd30
  SpdxlicenseCcbyncnd40
  SpdxlicenseCcbyncsa10
  SpdxlicenseCcbyncsa20
  SpdxlicenseCcbyncsa25
  SpdxlicenseCcbyncsa30
  SpdxlicenseCcbyncsa40
  SpdxlicenseCcbynd10
  SpdxlicenseCcbynd20
  SpdxlicenseCcbynd25
  SpdxlicenseCcbynd30
  SpdxlicenseCcbynd40
  SpdxlicenseCcbysa10
  SpdxlicenseCcbysa20
  SpdxlicenseCcbysa25
  SpdxlicenseCcbysa30
  SpdxlicenseCcbysa40
  SpdxlicenseCc010
  SpdxlicenseCddl10
  SpdxlicenseCddl11
  SpdxlicenseCdlapermissive10
  SpdxlicenseCdlasharing10
  SpdxlicenseCecill10
  SpdxlicenseCecill11
  SpdxlicenseCecill20
  SpdxlicenseCecill21
  SpdxlicenseCecillb
  SpdxlicenseCecillc
  SpdxlicenseClartistic
  SpdxlicenseCnrijython
  SpdxlicenseCnripythongplcompatible
  SpdxlicenseCnripython
  SpdxlicenseCondor11
  SpdxlicenseCpal10
  SpdxlicenseCpl10
  SpdxlicenseCpol102
  SpdxlicenseCrossword
  SpdxlicenseCrystalstacker
  SpdxlicenseCuaopl10
  SpdxlicenseCube
  SpdxlicenseCurl
  SpdxlicenseDfsl10
  SpdxlicenseDiffmark
  SpdxlicenseDoc
  SpdxlicenseDotseqn
  SpdxlicenseDsdp
  SpdxlicenseDvipdfm
  SpdxlicenseEcl10
  SpdxlicenseEcl20
  SpdxlicenseEfl10
  SpdxlicenseEfl20
  SpdxlicenseEgenix
  SpdxlicenseEntessa
  SpdxlicenseEpl10
  SpdxlicenseEpl20
  SpdxlicenseErlpl11
  SpdxlicenseEudatagrid
  SpdxlicenseEupl10
  SpdxlicenseEupl11
  SpdxlicenseEupl12
  SpdxlicenseEurosym
  SpdxlicenseFair
  SpdxlicenseFrameworx10
  SpdxlicenseFreeimage
  SpdxlicenseFsfap
  SpdxlicenseFsful
  SpdxlicenseFsfullr
  SpdxlicenseFtl
  SpdxlicenseGfdl11only
  SpdxlicenseGfdl11orlater
  SpdxlicenseGfdl12only
  SpdxlicenseGfdl12orlater
  SpdxlicenseGfdl13only
  SpdxlicenseGfdl13orlater
  SpdxlicenseGiftware
  SpdxlicenseGl2ps
  SpdxlicenseGlide
  SpdxlicenseGlulxe
  SpdxlicenseGnuplot
  SpdxlicenseGpl10only
  SpdxlicenseGpl10orlater
  SpdxlicenseGpl20only
  SpdxlicenseGpl20orlater
  SpdxlicenseGpl30only
  SpdxlicenseGpl30orlater
  SpdxlicenseGsoap13b
  SpdxlicenseHaskellreport
  SpdxlicenseHpnd
  SpdxlicenseIbmpibs
  SpdxlicenseIcu
  SpdxlicenseIjg
  SpdxlicenseImagemagick
  SpdxlicenseImatix
  SpdxlicenseImlib2
  SpdxlicenseInfozip
  SpdxlicenseIntelacpi
  SpdxlicenseIntel
  SpdxlicenseInterbase10
  SpdxlicenseIpa
  SpdxlicenseIpl10
  SpdxlicenseIsc
  SpdxlicenseJasper20
  SpdxlicenseJson
  SpdxlicenseLal12
  SpdxlicenseLal13
  SpdxlicenseLatex2e
  SpdxlicenseLeptonica
  SpdxlicenseLgpl20only
  SpdxlicenseLgpl20orlater
  SpdxlicenseLgpl21only
  SpdxlicenseLgpl21orlater
  SpdxlicenseLgpl30only
  SpdxlicenseLgpl30orlater
  SpdxlicenseLgpllr
  SpdxlicenseLibpng
  SpdxlicenseLibtiff
  SpdxlicenseLiliqp11
  SpdxlicenseLiliqr11
  SpdxlicenseLiliqrplus11
  SpdxlicenseLinuxopenib
  SpdxlicenseLpl10
  SpdxlicenseLpl102
  SpdxlicenseLppl10
  SpdxlicenseLppl11
  SpdxlicenseLppl12
  SpdxlicenseLppl13a
  SpdxlicenseLppl13c
  SpdxlicenseMakeindex
  SpdxlicenseMiros
  SpdxlicenseMit0
  SpdxlicenseMitadvertising
  SpdxlicenseMitcmu
  SpdxlicenseMitenna
  SpdxlicenseMitfeh
  SpdxlicenseMit
  SpdxlicenseMitnfa
  SpdxlicenseMotosoto
  SpdxlicenseMpich2
  SpdxlicenseMpl10
  SpdxlicenseMpl11
  SpdxlicenseMpl20nocopyleftexception
  SpdxlicenseMpl20
  SpdxlicenseMspl
  SpdxlicenseMsrl
  SpdxlicenseMtll
  SpdxlicenseMultics
  SpdxlicenseMup
  SpdxlicenseNasa13
  SpdxlicenseNaumen
  SpdxlicenseNbpl10
  SpdxlicenseNcsa
  SpdxlicenseNetsnmp
  SpdxlicenseNetcdf
  SpdxlicenseNewsletr
  SpdxlicenseNgpl
  SpdxlicenseNlod10
  SpdxlicenseNlpl
  SpdxlicenseNokia
  SpdxlicenseNosl
  SpdxlicenseNoweb
  SpdxlicenseNpl10
  SpdxlicenseNpl11
  SpdxlicenseNposl30
  SpdxlicenseNrl
  SpdxlicenseNtp
  SpdxlicenseOcctpl
  SpdxlicenseOclc20
  SpdxlicenseOdbl10
  SpdxlicenseOfl10
  SpdxlicenseOfl11
  SpdxlicenseOgtsl
  SpdxlicenseOldap11
  SpdxlicenseOldap12
  SpdxlicenseOldap13
  SpdxlicenseOldap14
  SpdxlicenseOldap201
  SpdxlicenseOldap20
  SpdxlicenseOldap21
  SpdxlicenseOldap221
  SpdxlicenseOldap222
  SpdxlicenseOldap22
  SpdxlicenseOldap23
  SpdxlicenseOldap24
  SpdxlicenseOldap25
  SpdxlicenseOldap26
  SpdxlicenseOldap27
  SpdxlicenseOldap28
  SpdxlicenseOml
  SpdxlicenseOpenssl
  SpdxlicenseOpl10
  SpdxlicenseOsetpl21
  SpdxlicenseOsl10
  SpdxlicenseOsl11
  SpdxlicenseOsl20
  SpdxlicenseOsl21
  SpdxlicenseOsl30
  SpdxlicensePddl10
  SpdxlicensePhp30
  SpdxlicensePhp301
  SpdxlicensePlexus
  SpdxlicensePostgresql
  SpdxlicensePsfrag
  SpdxlicensePsutils
  SpdxlicensePython20
  SpdxlicenseQhull
  SpdxlicenseQpl10
  SpdxlicenseRdisc
  SpdxlicenseRhecos11
  SpdxlicenseRpl11
  SpdxlicenseRpl15
  SpdxlicenseRpsl10
  SpdxlicenseRsamd
  SpdxlicenseRscpl
  SpdxlicenseRuby
  SpdxlicenseSaxpd
  SpdxlicenseSaxpath
  SpdxlicenseScea
  SpdxlicenseSendmail
  SpdxlicenseSgib10
  SpdxlicenseSgib11
  SpdxlicenseSgib20
  SpdxlicenseSimpl20
  SpdxlicenseSissl12
  SpdxlicenseSissl
  SpdxlicenseSleepycat
  SpdxlicenseSmlnj
  SpdxlicenseSmppl
  SpdxlicenseSnia
  SpdxlicenseSpencer86
  SpdxlicenseSpencer94
  SpdxlicenseSpencer99
  SpdxlicenseSpl10
  SpdxlicenseSugarcrm113
  SpdxlicenseSwl
  SpdxlicenseTcl
  SpdxlicenseTcpwrappers
  SpdxlicenseTmate
  SpdxlicenseTorque11
  SpdxlicenseTosl
  SpdxlicenseUnicodedfs2015
  SpdxlicenseUnicodedfs2016
  SpdxlicenseUnicodetou
  SpdxlicenseUnlicense
  SpdxlicenseUpl10
  SpdxlicenseVim
  SpdxlicenseVostrom
  SpdxlicenseVsl10
  SpdxlicenseW3c19980720
  SpdxlicenseW3c20150513
  SpdxlicenseW3c
  SpdxlicenseWatcom10
  SpdxlicenseWsuipa
  SpdxlicenseWtfpl
  SpdxlicenseX11
  SpdxlicenseXerox
  SpdxlicenseXfree8611
  SpdxlicenseXinetd
  SpdxlicenseXnet
  SpdxlicenseXpp
  SpdxlicenseXskat
  SpdxlicenseYpl10
  SpdxlicenseYpl11
  SpdxlicenseZed
  SpdxlicenseZend20
  SpdxlicenseZimbra13
  SpdxlicenseZimbra14
  SpdxlicenseZlibacknowledgement
  SpdxlicenseZlib
  SpdxlicenseZpl11
  SpdxlicenseZpl20
  SpdxlicenseZpl21
}

pub fn spdxlicense_to_json(spdxlicense: Spdxlicense) -> Json {
  json.string(spdxlicense_to_string(spdxlicense))
}

pub fn spdxlicense_to_string(spdxlicense: Spdxlicense) -> String {
  case spdxlicense {
    SpdxlicenseNotopensource -> "not-open-source"
    Spdxlicense0bsd -> "0BSD"
    SpdxlicenseAal -> "AAL"
    SpdxlicenseAbstyles -> "Abstyles"
    SpdxlicenseAdobe2006 -> "Adobe-2006"
    SpdxlicenseAdobeglyph -> "Adobe-Glyph"
    SpdxlicenseAdsl -> "ADSL"
    SpdxlicenseAfl11 -> "AFL-1.1"
    SpdxlicenseAfl12 -> "AFL-1.2"
    SpdxlicenseAfl20 -> "AFL-2.0"
    SpdxlicenseAfl21 -> "AFL-2.1"
    SpdxlicenseAfl30 -> "AFL-3.0"
    SpdxlicenseAfmparse -> "Afmparse"
    SpdxlicenseAgpl10only -> "AGPL-1.0-only"
    SpdxlicenseAgpl10orlater -> "AGPL-1.0-or-later"
    SpdxlicenseAgpl30only -> "AGPL-3.0-only"
    SpdxlicenseAgpl30orlater -> "AGPL-3.0-or-later"
    SpdxlicenseAladdin -> "Aladdin"
    SpdxlicenseAmdplpa -> "AMDPLPA"
    SpdxlicenseAml -> "AML"
    SpdxlicenseAmpas -> "AMPAS"
    SpdxlicenseAntlrpd -> "ANTLR-PD"
    SpdxlicenseApache10 -> "Apache-1.0"
    SpdxlicenseApache11 -> "Apache-1.1"
    SpdxlicenseApache20 -> "Apache-2.0"
    SpdxlicenseApafml -> "APAFML"
    SpdxlicenseApl10 -> "APL-1.0"
    SpdxlicenseApsl10 -> "APSL-1.0"
    SpdxlicenseApsl11 -> "APSL-1.1"
    SpdxlicenseApsl12 -> "APSL-1.2"
    SpdxlicenseApsl20 -> "APSL-2.0"
    SpdxlicenseArtistic10cl8 -> "Artistic-1.0-cl8"
    SpdxlicenseArtistic10perl -> "Artistic-1.0-Perl"
    SpdxlicenseArtistic10 -> "Artistic-1.0"
    SpdxlicenseArtistic20 -> "Artistic-2.0"
    SpdxlicenseBahyph -> "Bahyph"
    SpdxlicenseBarr -> "Barr"
    SpdxlicenseBeerware -> "Beerware"
    SpdxlicenseBittorrent10 -> "BitTorrent-1.0"
    SpdxlicenseBittorrent11 -> "BitTorrent-1.1"
    SpdxlicenseBorceux -> "Borceux"
    SpdxlicenseBsd1clause -> "BSD-1-Clause"
    SpdxlicenseBsd2clausefreebsd -> "BSD-2-Clause-FreeBSD"
    SpdxlicenseBsd2clausenetbsd -> "BSD-2-Clause-NetBSD"
    SpdxlicenseBsd2clausepatent -> "BSD-2-Clause-Patent"
    SpdxlicenseBsd2clause -> "BSD-2-Clause"
    SpdxlicenseBsd3clauseattribution -> "BSD-3-Clause-Attribution"
    SpdxlicenseBsd3clauseclear -> "BSD-3-Clause-Clear"
    SpdxlicenseBsd3clauselbnl -> "BSD-3-Clause-LBNL"
    SpdxlicenseBsd3clausenonuclearlicense2014 ->
      "BSD-3-Clause-No-Nuclear-License-2014"
    SpdxlicenseBsd3clausenonuclearlicense -> "BSD-3-Clause-No-Nuclear-License"
    SpdxlicenseBsd3clausenonuclearwarranty -> "BSD-3-Clause-No-Nuclear-Warranty"
    SpdxlicenseBsd3clause -> "BSD-3-Clause"
    SpdxlicenseBsd4clauseuc -> "BSD-4-Clause-UC"
    SpdxlicenseBsd4clause -> "BSD-4-Clause"
    SpdxlicenseBsdprotection -> "BSD-Protection"
    SpdxlicenseBsdsourcecode -> "BSD-Source-Code"
    SpdxlicenseBsl10 -> "BSL-1.0"
    SpdxlicenseBzip2105 -> "bzip2-1.0.5"
    SpdxlicenseBzip2106 -> "bzip2-1.0.6"
    SpdxlicenseCaldera -> "Caldera"
    SpdxlicenseCatosl11 -> "CATOSL-1.1"
    SpdxlicenseCcby10 -> "CC-BY-1.0"
    SpdxlicenseCcby20 -> "CC-BY-2.0"
    SpdxlicenseCcby25 -> "CC-BY-2.5"
    SpdxlicenseCcby30 -> "CC-BY-3.0"
    SpdxlicenseCcby40 -> "CC-BY-4.0"
    SpdxlicenseCcbync10 -> "CC-BY-NC-1.0"
    SpdxlicenseCcbync20 -> "CC-BY-NC-2.0"
    SpdxlicenseCcbync25 -> "CC-BY-NC-2.5"
    SpdxlicenseCcbync30 -> "CC-BY-NC-3.0"
    SpdxlicenseCcbync40 -> "CC-BY-NC-4.0"
    SpdxlicenseCcbyncnd10 -> "CC-BY-NC-ND-1.0"
    SpdxlicenseCcbyncnd20 -> "CC-BY-NC-ND-2.0"
    SpdxlicenseCcbyncnd25 -> "CC-BY-NC-ND-2.5"
    SpdxlicenseCcbyncnd30 -> "CC-BY-NC-ND-3.0"
    SpdxlicenseCcbyncnd40 -> "CC-BY-NC-ND-4.0"
    SpdxlicenseCcbyncsa10 -> "CC-BY-NC-SA-1.0"
    SpdxlicenseCcbyncsa20 -> "CC-BY-NC-SA-2.0"
    SpdxlicenseCcbyncsa25 -> "CC-BY-NC-SA-2.5"
    SpdxlicenseCcbyncsa30 -> "CC-BY-NC-SA-3.0"
    SpdxlicenseCcbyncsa40 -> "CC-BY-NC-SA-4.0"
    SpdxlicenseCcbynd10 -> "CC-BY-ND-1.0"
    SpdxlicenseCcbynd20 -> "CC-BY-ND-2.0"
    SpdxlicenseCcbynd25 -> "CC-BY-ND-2.5"
    SpdxlicenseCcbynd30 -> "CC-BY-ND-3.0"
    SpdxlicenseCcbynd40 -> "CC-BY-ND-4.0"
    SpdxlicenseCcbysa10 -> "CC-BY-SA-1.0"
    SpdxlicenseCcbysa20 -> "CC-BY-SA-2.0"
    SpdxlicenseCcbysa25 -> "CC-BY-SA-2.5"
    SpdxlicenseCcbysa30 -> "CC-BY-SA-3.0"
    SpdxlicenseCcbysa40 -> "CC-BY-SA-4.0"
    SpdxlicenseCc010 -> "CC0-1.0"
    SpdxlicenseCddl10 -> "CDDL-1.0"
    SpdxlicenseCddl11 -> "CDDL-1.1"
    SpdxlicenseCdlapermissive10 -> "CDLA-Permissive-1.0"
    SpdxlicenseCdlasharing10 -> "CDLA-Sharing-1.0"
    SpdxlicenseCecill10 -> "CECILL-1.0"
    SpdxlicenseCecill11 -> "CECILL-1.1"
    SpdxlicenseCecill20 -> "CECILL-2.0"
    SpdxlicenseCecill21 -> "CECILL-2.1"
    SpdxlicenseCecillb -> "CECILL-B"
    SpdxlicenseCecillc -> "CECILL-C"
    SpdxlicenseClartistic -> "ClArtistic"
    SpdxlicenseCnrijython -> "CNRI-Jython"
    SpdxlicenseCnripythongplcompatible -> "CNRI-Python-GPL-Compatible"
    SpdxlicenseCnripython -> "CNRI-Python"
    SpdxlicenseCondor11 -> "Condor-1.1"
    SpdxlicenseCpal10 -> "CPAL-1.0"
    SpdxlicenseCpl10 -> "CPL-1.0"
    SpdxlicenseCpol102 -> "CPOL-1.02"
    SpdxlicenseCrossword -> "Crossword"
    SpdxlicenseCrystalstacker -> "CrystalStacker"
    SpdxlicenseCuaopl10 -> "CUA-OPL-1.0"
    SpdxlicenseCube -> "Cube"
    SpdxlicenseCurl -> "curl"
    SpdxlicenseDfsl10 -> "D-FSL-1.0"
    SpdxlicenseDiffmark -> "diffmark"
    SpdxlicenseDoc -> "DOC"
    SpdxlicenseDotseqn -> "Dotseqn"
    SpdxlicenseDsdp -> "DSDP"
    SpdxlicenseDvipdfm -> "dvipdfm"
    SpdxlicenseEcl10 -> "ECL-1.0"
    SpdxlicenseEcl20 -> "ECL-2.0"
    SpdxlicenseEfl10 -> "EFL-1.0"
    SpdxlicenseEfl20 -> "EFL-2.0"
    SpdxlicenseEgenix -> "eGenix"
    SpdxlicenseEntessa -> "Entessa"
    SpdxlicenseEpl10 -> "EPL-1.0"
    SpdxlicenseEpl20 -> "EPL-2.0"
    SpdxlicenseErlpl11 -> "ErlPL-1.1"
    SpdxlicenseEudatagrid -> "EUDatagrid"
    SpdxlicenseEupl10 -> "EUPL-1.0"
    SpdxlicenseEupl11 -> "EUPL-1.1"
    SpdxlicenseEupl12 -> "EUPL-1.2"
    SpdxlicenseEurosym -> "Eurosym"
    SpdxlicenseFair -> "Fair"
    SpdxlicenseFrameworx10 -> "Frameworx-1.0"
    SpdxlicenseFreeimage -> "FreeImage"
    SpdxlicenseFsfap -> "FSFAP"
    SpdxlicenseFsful -> "FSFUL"
    SpdxlicenseFsfullr -> "FSFULLR"
    SpdxlicenseFtl -> "FTL"
    SpdxlicenseGfdl11only -> "GFDL-1.1-only"
    SpdxlicenseGfdl11orlater -> "GFDL-1.1-or-later"
    SpdxlicenseGfdl12only -> "GFDL-1.2-only"
    SpdxlicenseGfdl12orlater -> "GFDL-1.2-or-later"
    SpdxlicenseGfdl13only -> "GFDL-1.3-only"
    SpdxlicenseGfdl13orlater -> "GFDL-1.3-or-later"
    SpdxlicenseGiftware -> "Giftware"
    SpdxlicenseGl2ps -> "GL2PS"
    SpdxlicenseGlide -> "Glide"
    SpdxlicenseGlulxe -> "Glulxe"
    SpdxlicenseGnuplot -> "gnuplot"
    SpdxlicenseGpl10only -> "GPL-1.0-only"
    SpdxlicenseGpl10orlater -> "GPL-1.0-or-later"
    SpdxlicenseGpl20only -> "GPL-2.0-only"
    SpdxlicenseGpl20orlater -> "GPL-2.0-or-later"
    SpdxlicenseGpl30only -> "GPL-3.0-only"
    SpdxlicenseGpl30orlater -> "GPL-3.0-or-later"
    SpdxlicenseGsoap13b -> "gSOAP-1.3b"
    SpdxlicenseHaskellreport -> "HaskellReport"
    SpdxlicenseHpnd -> "HPND"
    SpdxlicenseIbmpibs -> "IBM-pibs"
    SpdxlicenseIcu -> "ICU"
    SpdxlicenseIjg -> "IJG"
    SpdxlicenseImagemagick -> "ImageMagick"
    SpdxlicenseImatix -> "iMatix"
    SpdxlicenseImlib2 -> "Imlib2"
    SpdxlicenseInfozip -> "Info-ZIP"
    SpdxlicenseIntelacpi -> "Intel-ACPI"
    SpdxlicenseIntel -> "Intel"
    SpdxlicenseInterbase10 -> "Interbase-1.0"
    SpdxlicenseIpa -> "IPA"
    SpdxlicenseIpl10 -> "IPL-1.0"
    SpdxlicenseIsc -> "ISC"
    SpdxlicenseJasper20 -> "JasPer-2.0"
    SpdxlicenseJson -> "JSON"
    SpdxlicenseLal12 -> "LAL-1.2"
    SpdxlicenseLal13 -> "LAL-1.3"
    SpdxlicenseLatex2e -> "Latex2e"
    SpdxlicenseLeptonica -> "Leptonica"
    SpdxlicenseLgpl20only -> "LGPL-2.0-only"
    SpdxlicenseLgpl20orlater -> "LGPL-2.0-or-later"
    SpdxlicenseLgpl21only -> "LGPL-2.1-only"
    SpdxlicenseLgpl21orlater -> "LGPL-2.1-or-later"
    SpdxlicenseLgpl30only -> "LGPL-3.0-only"
    SpdxlicenseLgpl30orlater -> "LGPL-3.0-or-later"
    SpdxlicenseLgpllr -> "LGPLLR"
    SpdxlicenseLibpng -> "Libpng"
    SpdxlicenseLibtiff -> "libtiff"
    SpdxlicenseLiliqp11 -> "LiLiQ-P-1.1"
    SpdxlicenseLiliqr11 -> "LiLiQ-R-1.1"
    SpdxlicenseLiliqrplus11 -> "LiLiQ-Rplus-1.1"
    SpdxlicenseLinuxopenib -> "Linux-OpenIB"
    SpdxlicenseLpl10 -> "LPL-1.0"
    SpdxlicenseLpl102 -> "LPL-1.02"
    SpdxlicenseLppl10 -> "LPPL-1.0"
    SpdxlicenseLppl11 -> "LPPL-1.1"
    SpdxlicenseLppl12 -> "LPPL-1.2"
    SpdxlicenseLppl13a -> "LPPL-1.3a"
    SpdxlicenseLppl13c -> "LPPL-1.3c"
    SpdxlicenseMakeindex -> "MakeIndex"
    SpdxlicenseMiros -> "MirOS"
    SpdxlicenseMit0 -> "MIT-0"
    SpdxlicenseMitadvertising -> "MIT-advertising"
    SpdxlicenseMitcmu -> "MIT-CMU"
    SpdxlicenseMitenna -> "MIT-enna"
    SpdxlicenseMitfeh -> "MIT-feh"
    SpdxlicenseMit -> "MIT"
    SpdxlicenseMitnfa -> "MITNFA"
    SpdxlicenseMotosoto -> "Motosoto"
    SpdxlicenseMpich2 -> "mpich2"
    SpdxlicenseMpl10 -> "MPL-1.0"
    SpdxlicenseMpl11 -> "MPL-1.1"
    SpdxlicenseMpl20nocopyleftexception -> "MPL-2.0-no-copyleft-exception"
    SpdxlicenseMpl20 -> "MPL-2.0"
    SpdxlicenseMspl -> "MS-PL"
    SpdxlicenseMsrl -> "MS-RL"
    SpdxlicenseMtll -> "MTLL"
    SpdxlicenseMultics -> "Multics"
    SpdxlicenseMup -> "Mup"
    SpdxlicenseNasa13 -> "NASA-1.3"
    SpdxlicenseNaumen -> "Naumen"
    SpdxlicenseNbpl10 -> "NBPL-1.0"
    SpdxlicenseNcsa -> "NCSA"
    SpdxlicenseNetsnmp -> "Net-SNMP"
    SpdxlicenseNetcdf -> "NetCDF"
    SpdxlicenseNewsletr -> "Newsletr"
    SpdxlicenseNgpl -> "NGPL"
    SpdxlicenseNlod10 -> "NLOD-1.0"
    SpdxlicenseNlpl -> "NLPL"
    SpdxlicenseNokia -> "Nokia"
    SpdxlicenseNosl -> "NOSL"
    SpdxlicenseNoweb -> "Noweb"
    SpdxlicenseNpl10 -> "NPL-1.0"
    SpdxlicenseNpl11 -> "NPL-1.1"
    SpdxlicenseNposl30 -> "NPOSL-3.0"
    SpdxlicenseNrl -> "NRL"
    SpdxlicenseNtp -> "NTP"
    SpdxlicenseOcctpl -> "OCCT-PL"
    SpdxlicenseOclc20 -> "OCLC-2.0"
    SpdxlicenseOdbl10 -> "ODbL-1.0"
    SpdxlicenseOfl10 -> "OFL-1.0"
    SpdxlicenseOfl11 -> "OFL-1.1"
    SpdxlicenseOgtsl -> "OGTSL"
    SpdxlicenseOldap11 -> "OLDAP-1.1"
    SpdxlicenseOldap12 -> "OLDAP-1.2"
    SpdxlicenseOldap13 -> "OLDAP-1.3"
    SpdxlicenseOldap14 -> "OLDAP-1.4"
    SpdxlicenseOldap201 -> "OLDAP-2.0.1"
    SpdxlicenseOldap20 -> "OLDAP-2.0"
    SpdxlicenseOldap21 -> "OLDAP-2.1"
    SpdxlicenseOldap221 -> "OLDAP-2.2.1"
    SpdxlicenseOldap222 -> "OLDAP-2.2.2"
    SpdxlicenseOldap22 -> "OLDAP-2.2"
    SpdxlicenseOldap23 -> "OLDAP-2.3"
    SpdxlicenseOldap24 -> "OLDAP-2.4"
    SpdxlicenseOldap25 -> "OLDAP-2.5"
    SpdxlicenseOldap26 -> "OLDAP-2.6"
    SpdxlicenseOldap27 -> "OLDAP-2.7"
    SpdxlicenseOldap28 -> "OLDAP-2.8"
    SpdxlicenseOml -> "OML"
    SpdxlicenseOpenssl -> "OpenSSL"
    SpdxlicenseOpl10 -> "OPL-1.0"
    SpdxlicenseOsetpl21 -> "OSET-PL-2.1"
    SpdxlicenseOsl10 -> "OSL-1.0"
    SpdxlicenseOsl11 -> "OSL-1.1"
    SpdxlicenseOsl20 -> "OSL-2.0"
    SpdxlicenseOsl21 -> "OSL-2.1"
    SpdxlicenseOsl30 -> "OSL-3.0"
    SpdxlicensePddl10 -> "PDDL-1.0"
    SpdxlicensePhp30 -> "PHP-3.0"
    SpdxlicensePhp301 -> "PHP-3.01"
    SpdxlicensePlexus -> "Plexus"
    SpdxlicensePostgresql -> "PostgreSQL"
    SpdxlicensePsfrag -> "psfrag"
    SpdxlicensePsutils -> "psutils"
    SpdxlicensePython20 -> "Python-2.0"
    SpdxlicenseQhull -> "Qhull"
    SpdxlicenseQpl10 -> "QPL-1.0"
    SpdxlicenseRdisc -> "Rdisc"
    SpdxlicenseRhecos11 -> "RHeCos-1.1"
    SpdxlicenseRpl11 -> "RPL-1.1"
    SpdxlicenseRpl15 -> "RPL-1.5"
    SpdxlicenseRpsl10 -> "RPSL-1.0"
    SpdxlicenseRsamd -> "RSA-MD"
    SpdxlicenseRscpl -> "RSCPL"
    SpdxlicenseRuby -> "Ruby"
    SpdxlicenseSaxpd -> "SAX-PD"
    SpdxlicenseSaxpath -> "Saxpath"
    SpdxlicenseScea -> "SCEA"
    SpdxlicenseSendmail -> "Sendmail"
    SpdxlicenseSgib10 -> "SGI-B-1.0"
    SpdxlicenseSgib11 -> "SGI-B-1.1"
    SpdxlicenseSgib20 -> "SGI-B-2.0"
    SpdxlicenseSimpl20 -> "SimPL-2.0"
    SpdxlicenseSissl12 -> "SISSL-1.2"
    SpdxlicenseSissl -> "SISSL"
    SpdxlicenseSleepycat -> "Sleepycat"
    SpdxlicenseSmlnj -> "SMLNJ"
    SpdxlicenseSmppl -> "SMPPL"
    SpdxlicenseSnia -> "SNIA"
    SpdxlicenseSpencer86 -> "Spencer-86"
    SpdxlicenseSpencer94 -> "Spencer-94"
    SpdxlicenseSpencer99 -> "Spencer-99"
    SpdxlicenseSpl10 -> "SPL-1.0"
    SpdxlicenseSugarcrm113 -> "SugarCRM-1.1.3"
    SpdxlicenseSwl -> "SWL"
    SpdxlicenseTcl -> "TCL"
    SpdxlicenseTcpwrappers -> "TCP-wrappers"
    SpdxlicenseTmate -> "TMate"
    SpdxlicenseTorque11 -> "TORQUE-1.1"
    SpdxlicenseTosl -> "TOSL"
    SpdxlicenseUnicodedfs2015 -> "Unicode-DFS-2015"
    SpdxlicenseUnicodedfs2016 -> "Unicode-DFS-2016"
    SpdxlicenseUnicodetou -> "Unicode-TOU"
    SpdxlicenseUnlicense -> "Unlicense"
    SpdxlicenseUpl10 -> "UPL-1.0"
    SpdxlicenseVim -> "Vim"
    SpdxlicenseVostrom -> "VOSTROM"
    SpdxlicenseVsl10 -> "VSL-1.0"
    SpdxlicenseW3c19980720 -> "W3C-19980720"
    SpdxlicenseW3c20150513 -> "W3C-20150513"
    SpdxlicenseW3c -> "W3C"
    SpdxlicenseWatcom10 -> "Watcom-1.0"
    SpdxlicenseWsuipa -> "Wsuipa"
    SpdxlicenseWtfpl -> "WTFPL"
    SpdxlicenseX11 -> "X11"
    SpdxlicenseXerox -> "Xerox"
    SpdxlicenseXfree8611 -> "XFree86-1.1"
    SpdxlicenseXinetd -> "xinetd"
    SpdxlicenseXnet -> "Xnet"
    SpdxlicenseXpp -> "xpp"
    SpdxlicenseXskat -> "XSkat"
    SpdxlicenseYpl10 -> "YPL-1.0"
    SpdxlicenseYpl11 -> "YPL-1.1"
    SpdxlicenseZed -> "Zed"
    SpdxlicenseZend20 -> "Zend-2.0"
    SpdxlicenseZimbra13 -> "Zimbra-1.3"
    SpdxlicenseZimbra14 -> "Zimbra-1.4"
    SpdxlicenseZlibacknowledgement -> "zlib-acknowledgement"
    SpdxlicenseZlib -> "Zlib"
    SpdxlicenseZpl11 -> "ZPL-1.1"
    SpdxlicenseZpl20 -> "ZPL-2.0"
    SpdxlicenseZpl21 -> "ZPL-2.1"
  }
}

pub fn spdxlicense_from_string(s: String) -> Result(Spdxlicense, Nil) {
  case s {
    "not-open-source" -> Ok(SpdxlicenseNotopensource)
    "0BSD" -> Ok(Spdxlicense0bsd)
    "AAL" -> Ok(SpdxlicenseAal)
    "Abstyles" -> Ok(SpdxlicenseAbstyles)
    "Adobe-2006" -> Ok(SpdxlicenseAdobe2006)
    "Adobe-Glyph" -> Ok(SpdxlicenseAdobeglyph)
    "ADSL" -> Ok(SpdxlicenseAdsl)
    "AFL-1.1" -> Ok(SpdxlicenseAfl11)
    "AFL-1.2" -> Ok(SpdxlicenseAfl12)
    "AFL-2.0" -> Ok(SpdxlicenseAfl20)
    "AFL-2.1" -> Ok(SpdxlicenseAfl21)
    "AFL-3.0" -> Ok(SpdxlicenseAfl30)
    "Afmparse" -> Ok(SpdxlicenseAfmparse)
    "AGPL-1.0-only" -> Ok(SpdxlicenseAgpl10only)
    "AGPL-1.0-or-later" -> Ok(SpdxlicenseAgpl10orlater)
    "AGPL-3.0-only" -> Ok(SpdxlicenseAgpl30only)
    "AGPL-3.0-or-later" -> Ok(SpdxlicenseAgpl30orlater)
    "Aladdin" -> Ok(SpdxlicenseAladdin)
    "AMDPLPA" -> Ok(SpdxlicenseAmdplpa)
    "AML" -> Ok(SpdxlicenseAml)
    "AMPAS" -> Ok(SpdxlicenseAmpas)
    "ANTLR-PD" -> Ok(SpdxlicenseAntlrpd)
    "Apache-1.0" -> Ok(SpdxlicenseApache10)
    "Apache-1.1" -> Ok(SpdxlicenseApache11)
    "Apache-2.0" -> Ok(SpdxlicenseApache20)
    "APAFML" -> Ok(SpdxlicenseApafml)
    "APL-1.0" -> Ok(SpdxlicenseApl10)
    "APSL-1.0" -> Ok(SpdxlicenseApsl10)
    "APSL-1.1" -> Ok(SpdxlicenseApsl11)
    "APSL-1.2" -> Ok(SpdxlicenseApsl12)
    "APSL-2.0" -> Ok(SpdxlicenseApsl20)
    "Artistic-1.0-cl8" -> Ok(SpdxlicenseArtistic10cl8)
    "Artistic-1.0-Perl" -> Ok(SpdxlicenseArtistic10perl)
    "Artistic-1.0" -> Ok(SpdxlicenseArtistic10)
    "Artistic-2.0" -> Ok(SpdxlicenseArtistic20)
    "Bahyph" -> Ok(SpdxlicenseBahyph)
    "Barr" -> Ok(SpdxlicenseBarr)
    "Beerware" -> Ok(SpdxlicenseBeerware)
    "BitTorrent-1.0" -> Ok(SpdxlicenseBittorrent10)
    "BitTorrent-1.1" -> Ok(SpdxlicenseBittorrent11)
    "Borceux" -> Ok(SpdxlicenseBorceux)
    "BSD-1-Clause" -> Ok(SpdxlicenseBsd1clause)
    "BSD-2-Clause-FreeBSD" -> Ok(SpdxlicenseBsd2clausefreebsd)
    "BSD-2-Clause-NetBSD" -> Ok(SpdxlicenseBsd2clausenetbsd)
    "BSD-2-Clause-Patent" -> Ok(SpdxlicenseBsd2clausepatent)
    "BSD-2-Clause" -> Ok(SpdxlicenseBsd2clause)
    "BSD-3-Clause-Attribution" -> Ok(SpdxlicenseBsd3clauseattribution)
    "BSD-3-Clause-Clear" -> Ok(SpdxlicenseBsd3clauseclear)
    "BSD-3-Clause-LBNL" -> Ok(SpdxlicenseBsd3clauselbnl)
    "BSD-3-Clause-No-Nuclear-License-2014" ->
      Ok(SpdxlicenseBsd3clausenonuclearlicense2014)
    "BSD-3-Clause-No-Nuclear-License" ->
      Ok(SpdxlicenseBsd3clausenonuclearlicense)
    "BSD-3-Clause-No-Nuclear-Warranty" ->
      Ok(SpdxlicenseBsd3clausenonuclearwarranty)
    "BSD-3-Clause" -> Ok(SpdxlicenseBsd3clause)
    "BSD-4-Clause-UC" -> Ok(SpdxlicenseBsd4clauseuc)
    "BSD-4-Clause" -> Ok(SpdxlicenseBsd4clause)
    "BSD-Protection" -> Ok(SpdxlicenseBsdprotection)
    "BSD-Source-Code" -> Ok(SpdxlicenseBsdsourcecode)
    "BSL-1.0" -> Ok(SpdxlicenseBsl10)
    "bzip2-1.0.5" -> Ok(SpdxlicenseBzip2105)
    "bzip2-1.0.6" -> Ok(SpdxlicenseBzip2106)
    "Caldera" -> Ok(SpdxlicenseCaldera)
    "CATOSL-1.1" -> Ok(SpdxlicenseCatosl11)
    "CC-BY-1.0" -> Ok(SpdxlicenseCcby10)
    "CC-BY-2.0" -> Ok(SpdxlicenseCcby20)
    "CC-BY-2.5" -> Ok(SpdxlicenseCcby25)
    "CC-BY-3.0" -> Ok(SpdxlicenseCcby30)
    "CC-BY-4.0" -> Ok(SpdxlicenseCcby40)
    "CC-BY-NC-1.0" -> Ok(SpdxlicenseCcbync10)
    "CC-BY-NC-2.0" -> Ok(SpdxlicenseCcbync20)
    "CC-BY-NC-2.5" -> Ok(SpdxlicenseCcbync25)
    "CC-BY-NC-3.0" -> Ok(SpdxlicenseCcbync30)
    "CC-BY-NC-4.0" -> Ok(SpdxlicenseCcbync40)
    "CC-BY-NC-ND-1.0" -> Ok(SpdxlicenseCcbyncnd10)
    "CC-BY-NC-ND-2.0" -> Ok(SpdxlicenseCcbyncnd20)
    "CC-BY-NC-ND-2.5" -> Ok(SpdxlicenseCcbyncnd25)
    "CC-BY-NC-ND-3.0" -> Ok(SpdxlicenseCcbyncnd30)
    "CC-BY-NC-ND-4.0" -> Ok(SpdxlicenseCcbyncnd40)
    "CC-BY-NC-SA-1.0" -> Ok(SpdxlicenseCcbyncsa10)
    "CC-BY-NC-SA-2.0" -> Ok(SpdxlicenseCcbyncsa20)
    "CC-BY-NC-SA-2.5" -> Ok(SpdxlicenseCcbyncsa25)
    "CC-BY-NC-SA-3.0" -> Ok(SpdxlicenseCcbyncsa30)
    "CC-BY-NC-SA-4.0" -> Ok(SpdxlicenseCcbyncsa40)
    "CC-BY-ND-1.0" -> Ok(SpdxlicenseCcbynd10)
    "CC-BY-ND-2.0" -> Ok(SpdxlicenseCcbynd20)
    "CC-BY-ND-2.5" -> Ok(SpdxlicenseCcbynd25)
    "CC-BY-ND-3.0" -> Ok(SpdxlicenseCcbynd30)
    "CC-BY-ND-4.0" -> Ok(SpdxlicenseCcbynd40)
    "CC-BY-SA-1.0" -> Ok(SpdxlicenseCcbysa10)
    "CC-BY-SA-2.0" -> Ok(SpdxlicenseCcbysa20)
    "CC-BY-SA-2.5" -> Ok(SpdxlicenseCcbysa25)
    "CC-BY-SA-3.0" -> Ok(SpdxlicenseCcbysa30)
    "CC-BY-SA-4.0" -> Ok(SpdxlicenseCcbysa40)
    "CC0-1.0" -> Ok(SpdxlicenseCc010)
    "CDDL-1.0" -> Ok(SpdxlicenseCddl10)
    "CDDL-1.1" -> Ok(SpdxlicenseCddl11)
    "CDLA-Permissive-1.0" -> Ok(SpdxlicenseCdlapermissive10)
    "CDLA-Sharing-1.0" -> Ok(SpdxlicenseCdlasharing10)
    "CECILL-1.0" -> Ok(SpdxlicenseCecill10)
    "CECILL-1.1" -> Ok(SpdxlicenseCecill11)
    "CECILL-2.0" -> Ok(SpdxlicenseCecill20)
    "CECILL-2.1" -> Ok(SpdxlicenseCecill21)
    "CECILL-B" -> Ok(SpdxlicenseCecillb)
    "CECILL-C" -> Ok(SpdxlicenseCecillc)
    "ClArtistic" -> Ok(SpdxlicenseClartistic)
    "CNRI-Jython" -> Ok(SpdxlicenseCnrijython)
    "CNRI-Python-GPL-Compatible" -> Ok(SpdxlicenseCnripythongplcompatible)
    "CNRI-Python" -> Ok(SpdxlicenseCnripython)
    "Condor-1.1" -> Ok(SpdxlicenseCondor11)
    "CPAL-1.0" -> Ok(SpdxlicenseCpal10)
    "CPL-1.0" -> Ok(SpdxlicenseCpl10)
    "CPOL-1.02" -> Ok(SpdxlicenseCpol102)
    "Crossword" -> Ok(SpdxlicenseCrossword)
    "CrystalStacker" -> Ok(SpdxlicenseCrystalstacker)
    "CUA-OPL-1.0" -> Ok(SpdxlicenseCuaopl10)
    "Cube" -> Ok(SpdxlicenseCube)
    "curl" -> Ok(SpdxlicenseCurl)
    "D-FSL-1.0" -> Ok(SpdxlicenseDfsl10)
    "diffmark" -> Ok(SpdxlicenseDiffmark)
    "DOC" -> Ok(SpdxlicenseDoc)
    "Dotseqn" -> Ok(SpdxlicenseDotseqn)
    "DSDP" -> Ok(SpdxlicenseDsdp)
    "dvipdfm" -> Ok(SpdxlicenseDvipdfm)
    "ECL-1.0" -> Ok(SpdxlicenseEcl10)
    "ECL-2.0" -> Ok(SpdxlicenseEcl20)
    "EFL-1.0" -> Ok(SpdxlicenseEfl10)
    "EFL-2.0" -> Ok(SpdxlicenseEfl20)
    "eGenix" -> Ok(SpdxlicenseEgenix)
    "Entessa" -> Ok(SpdxlicenseEntessa)
    "EPL-1.0" -> Ok(SpdxlicenseEpl10)
    "EPL-2.0" -> Ok(SpdxlicenseEpl20)
    "ErlPL-1.1" -> Ok(SpdxlicenseErlpl11)
    "EUDatagrid" -> Ok(SpdxlicenseEudatagrid)
    "EUPL-1.0" -> Ok(SpdxlicenseEupl10)
    "EUPL-1.1" -> Ok(SpdxlicenseEupl11)
    "EUPL-1.2" -> Ok(SpdxlicenseEupl12)
    "Eurosym" -> Ok(SpdxlicenseEurosym)
    "Fair" -> Ok(SpdxlicenseFair)
    "Frameworx-1.0" -> Ok(SpdxlicenseFrameworx10)
    "FreeImage" -> Ok(SpdxlicenseFreeimage)
    "FSFAP" -> Ok(SpdxlicenseFsfap)
    "FSFUL" -> Ok(SpdxlicenseFsful)
    "FSFULLR" -> Ok(SpdxlicenseFsfullr)
    "FTL" -> Ok(SpdxlicenseFtl)
    "GFDL-1.1-only" -> Ok(SpdxlicenseGfdl11only)
    "GFDL-1.1-or-later" -> Ok(SpdxlicenseGfdl11orlater)
    "GFDL-1.2-only" -> Ok(SpdxlicenseGfdl12only)
    "GFDL-1.2-or-later" -> Ok(SpdxlicenseGfdl12orlater)
    "GFDL-1.3-only" -> Ok(SpdxlicenseGfdl13only)
    "GFDL-1.3-or-later" -> Ok(SpdxlicenseGfdl13orlater)
    "Giftware" -> Ok(SpdxlicenseGiftware)
    "GL2PS" -> Ok(SpdxlicenseGl2ps)
    "Glide" -> Ok(SpdxlicenseGlide)
    "Glulxe" -> Ok(SpdxlicenseGlulxe)
    "gnuplot" -> Ok(SpdxlicenseGnuplot)
    "GPL-1.0-only" -> Ok(SpdxlicenseGpl10only)
    "GPL-1.0-or-later" -> Ok(SpdxlicenseGpl10orlater)
    "GPL-2.0-only" -> Ok(SpdxlicenseGpl20only)
    "GPL-2.0-or-later" -> Ok(SpdxlicenseGpl20orlater)
    "GPL-3.0-only" -> Ok(SpdxlicenseGpl30only)
    "GPL-3.0-or-later" -> Ok(SpdxlicenseGpl30orlater)
    "gSOAP-1.3b" -> Ok(SpdxlicenseGsoap13b)
    "HaskellReport" -> Ok(SpdxlicenseHaskellreport)
    "HPND" -> Ok(SpdxlicenseHpnd)
    "IBM-pibs" -> Ok(SpdxlicenseIbmpibs)
    "ICU" -> Ok(SpdxlicenseIcu)
    "IJG" -> Ok(SpdxlicenseIjg)
    "ImageMagick" -> Ok(SpdxlicenseImagemagick)
    "iMatix" -> Ok(SpdxlicenseImatix)
    "Imlib2" -> Ok(SpdxlicenseImlib2)
    "Info-ZIP" -> Ok(SpdxlicenseInfozip)
    "Intel-ACPI" -> Ok(SpdxlicenseIntelacpi)
    "Intel" -> Ok(SpdxlicenseIntel)
    "Interbase-1.0" -> Ok(SpdxlicenseInterbase10)
    "IPA" -> Ok(SpdxlicenseIpa)
    "IPL-1.0" -> Ok(SpdxlicenseIpl10)
    "ISC" -> Ok(SpdxlicenseIsc)
    "JasPer-2.0" -> Ok(SpdxlicenseJasper20)
    "JSON" -> Ok(SpdxlicenseJson)
    "LAL-1.2" -> Ok(SpdxlicenseLal12)
    "LAL-1.3" -> Ok(SpdxlicenseLal13)
    "Latex2e" -> Ok(SpdxlicenseLatex2e)
    "Leptonica" -> Ok(SpdxlicenseLeptonica)
    "LGPL-2.0-only" -> Ok(SpdxlicenseLgpl20only)
    "LGPL-2.0-or-later" -> Ok(SpdxlicenseLgpl20orlater)
    "LGPL-2.1-only" -> Ok(SpdxlicenseLgpl21only)
    "LGPL-2.1-or-later" -> Ok(SpdxlicenseLgpl21orlater)
    "LGPL-3.0-only" -> Ok(SpdxlicenseLgpl30only)
    "LGPL-3.0-or-later" -> Ok(SpdxlicenseLgpl30orlater)
    "LGPLLR" -> Ok(SpdxlicenseLgpllr)
    "Libpng" -> Ok(SpdxlicenseLibpng)
    "libtiff" -> Ok(SpdxlicenseLibtiff)
    "LiLiQ-P-1.1" -> Ok(SpdxlicenseLiliqp11)
    "LiLiQ-R-1.1" -> Ok(SpdxlicenseLiliqr11)
    "LiLiQ-Rplus-1.1" -> Ok(SpdxlicenseLiliqrplus11)
    "Linux-OpenIB" -> Ok(SpdxlicenseLinuxopenib)
    "LPL-1.0" -> Ok(SpdxlicenseLpl10)
    "LPL-1.02" -> Ok(SpdxlicenseLpl102)
    "LPPL-1.0" -> Ok(SpdxlicenseLppl10)
    "LPPL-1.1" -> Ok(SpdxlicenseLppl11)
    "LPPL-1.2" -> Ok(SpdxlicenseLppl12)
    "LPPL-1.3a" -> Ok(SpdxlicenseLppl13a)
    "LPPL-1.3c" -> Ok(SpdxlicenseLppl13c)
    "MakeIndex" -> Ok(SpdxlicenseMakeindex)
    "MirOS" -> Ok(SpdxlicenseMiros)
    "MIT-0" -> Ok(SpdxlicenseMit0)
    "MIT-advertising" -> Ok(SpdxlicenseMitadvertising)
    "MIT-CMU" -> Ok(SpdxlicenseMitcmu)
    "MIT-enna" -> Ok(SpdxlicenseMitenna)
    "MIT-feh" -> Ok(SpdxlicenseMitfeh)
    "MIT" -> Ok(SpdxlicenseMit)
    "MITNFA" -> Ok(SpdxlicenseMitnfa)
    "Motosoto" -> Ok(SpdxlicenseMotosoto)
    "mpich2" -> Ok(SpdxlicenseMpich2)
    "MPL-1.0" -> Ok(SpdxlicenseMpl10)
    "MPL-1.1" -> Ok(SpdxlicenseMpl11)
    "MPL-2.0-no-copyleft-exception" -> Ok(SpdxlicenseMpl20nocopyleftexception)
    "MPL-2.0" -> Ok(SpdxlicenseMpl20)
    "MS-PL" -> Ok(SpdxlicenseMspl)
    "MS-RL" -> Ok(SpdxlicenseMsrl)
    "MTLL" -> Ok(SpdxlicenseMtll)
    "Multics" -> Ok(SpdxlicenseMultics)
    "Mup" -> Ok(SpdxlicenseMup)
    "NASA-1.3" -> Ok(SpdxlicenseNasa13)
    "Naumen" -> Ok(SpdxlicenseNaumen)
    "NBPL-1.0" -> Ok(SpdxlicenseNbpl10)
    "NCSA" -> Ok(SpdxlicenseNcsa)
    "Net-SNMP" -> Ok(SpdxlicenseNetsnmp)
    "NetCDF" -> Ok(SpdxlicenseNetcdf)
    "Newsletr" -> Ok(SpdxlicenseNewsletr)
    "NGPL" -> Ok(SpdxlicenseNgpl)
    "NLOD-1.0" -> Ok(SpdxlicenseNlod10)
    "NLPL" -> Ok(SpdxlicenseNlpl)
    "Nokia" -> Ok(SpdxlicenseNokia)
    "NOSL" -> Ok(SpdxlicenseNosl)
    "Noweb" -> Ok(SpdxlicenseNoweb)
    "NPL-1.0" -> Ok(SpdxlicenseNpl10)
    "NPL-1.1" -> Ok(SpdxlicenseNpl11)
    "NPOSL-3.0" -> Ok(SpdxlicenseNposl30)
    "NRL" -> Ok(SpdxlicenseNrl)
    "NTP" -> Ok(SpdxlicenseNtp)
    "OCCT-PL" -> Ok(SpdxlicenseOcctpl)
    "OCLC-2.0" -> Ok(SpdxlicenseOclc20)
    "ODbL-1.0" -> Ok(SpdxlicenseOdbl10)
    "OFL-1.0" -> Ok(SpdxlicenseOfl10)
    "OFL-1.1" -> Ok(SpdxlicenseOfl11)
    "OGTSL" -> Ok(SpdxlicenseOgtsl)
    "OLDAP-1.1" -> Ok(SpdxlicenseOldap11)
    "OLDAP-1.2" -> Ok(SpdxlicenseOldap12)
    "OLDAP-1.3" -> Ok(SpdxlicenseOldap13)
    "OLDAP-1.4" -> Ok(SpdxlicenseOldap14)
    "OLDAP-2.0.1" -> Ok(SpdxlicenseOldap201)
    "OLDAP-2.0" -> Ok(SpdxlicenseOldap20)
    "OLDAP-2.1" -> Ok(SpdxlicenseOldap21)
    "OLDAP-2.2.1" -> Ok(SpdxlicenseOldap221)
    "OLDAP-2.2.2" -> Ok(SpdxlicenseOldap222)
    "OLDAP-2.2" -> Ok(SpdxlicenseOldap22)
    "OLDAP-2.3" -> Ok(SpdxlicenseOldap23)
    "OLDAP-2.4" -> Ok(SpdxlicenseOldap24)
    "OLDAP-2.5" -> Ok(SpdxlicenseOldap25)
    "OLDAP-2.6" -> Ok(SpdxlicenseOldap26)
    "OLDAP-2.7" -> Ok(SpdxlicenseOldap27)
    "OLDAP-2.8" -> Ok(SpdxlicenseOldap28)
    "OML" -> Ok(SpdxlicenseOml)
    "OpenSSL" -> Ok(SpdxlicenseOpenssl)
    "OPL-1.0" -> Ok(SpdxlicenseOpl10)
    "OSET-PL-2.1" -> Ok(SpdxlicenseOsetpl21)
    "OSL-1.0" -> Ok(SpdxlicenseOsl10)
    "OSL-1.1" -> Ok(SpdxlicenseOsl11)
    "OSL-2.0" -> Ok(SpdxlicenseOsl20)
    "OSL-2.1" -> Ok(SpdxlicenseOsl21)
    "OSL-3.0" -> Ok(SpdxlicenseOsl30)
    "PDDL-1.0" -> Ok(SpdxlicensePddl10)
    "PHP-3.0" -> Ok(SpdxlicensePhp30)
    "PHP-3.01" -> Ok(SpdxlicensePhp301)
    "Plexus" -> Ok(SpdxlicensePlexus)
    "PostgreSQL" -> Ok(SpdxlicensePostgresql)
    "psfrag" -> Ok(SpdxlicensePsfrag)
    "psutils" -> Ok(SpdxlicensePsutils)
    "Python-2.0" -> Ok(SpdxlicensePython20)
    "Qhull" -> Ok(SpdxlicenseQhull)
    "QPL-1.0" -> Ok(SpdxlicenseQpl10)
    "Rdisc" -> Ok(SpdxlicenseRdisc)
    "RHeCos-1.1" -> Ok(SpdxlicenseRhecos11)
    "RPL-1.1" -> Ok(SpdxlicenseRpl11)
    "RPL-1.5" -> Ok(SpdxlicenseRpl15)
    "RPSL-1.0" -> Ok(SpdxlicenseRpsl10)
    "RSA-MD" -> Ok(SpdxlicenseRsamd)
    "RSCPL" -> Ok(SpdxlicenseRscpl)
    "Ruby" -> Ok(SpdxlicenseRuby)
    "SAX-PD" -> Ok(SpdxlicenseSaxpd)
    "Saxpath" -> Ok(SpdxlicenseSaxpath)
    "SCEA" -> Ok(SpdxlicenseScea)
    "Sendmail" -> Ok(SpdxlicenseSendmail)
    "SGI-B-1.0" -> Ok(SpdxlicenseSgib10)
    "SGI-B-1.1" -> Ok(SpdxlicenseSgib11)
    "SGI-B-2.0" -> Ok(SpdxlicenseSgib20)
    "SimPL-2.0" -> Ok(SpdxlicenseSimpl20)
    "SISSL-1.2" -> Ok(SpdxlicenseSissl12)
    "SISSL" -> Ok(SpdxlicenseSissl)
    "Sleepycat" -> Ok(SpdxlicenseSleepycat)
    "SMLNJ" -> Ok(SpdxlicenseSmlnj)
    "SMPPL" -> Ok(SpdxlicenseSmppl)
    "SNIA" -> Ok(SpdxlicenseSnia)
    "Spencer-86" -> Ok(SpdxlicenseSpencer86)
    "Spencer-94" -> Ok(SpdxlicenseSpencer94)
    "Spencer-99" -> Ok(SpdxlicenseSpencer99)
    "SPL-1.0" -> Ok(SpdxlicenseSpl10)
    "SugarCRM-1.1.3" -> Ok(SpdxlicenseSugarcrm113)
    "SWL" -> Ok(SpdxlicenseSwl)
    "TCL" -> Ok(SpdxlicenseTcl)
    "TCP-wrappers" -> Ok(SpdxlicenseTcpwrappers)
    "TMate" -> Ok(SpdxlicenseTmate)
    "TORQUE-1.1" -> Ok(SpdxlicenseTorque11)
    "TOSL" -> Ok(SpdxlicenseTosl)
    "Unicode-DFS-2015" -> Ok(SpdxlicenseUnicodedfs2015)
    "Unicode-DFS-2016" -> Ok(SpdxlicenseUnicodedfs2016)
    "Unicode-TOU" -> Ok(SpdxlicenseUnicodetou)
    "Unlicense" -> Ok(SpdxlicenseUnlicense)
    "UPL-1.0" -> Ok(SpdxlicenseUpl10)
    "Vim" -> Ok(SpdxlicenseVim)
    "VOSTROM" -> Ok(SpdxlicenseVostrom)
    "VSL-1.0" -> Ok(SpdxlicenseVsl10)
    "W3C-19980720" -> Ok(SpdxlicenseW3c19980720)
    "W3C-20150513" -> Ok(SpdxlicenseW3c20150513)
    "W3C" -> Ok(SpdxlicenseW3c)
    "Watcom-1.0" -> Ok(SpdxlicenseWatcom10)
    "Wsuipa" -> Ok(SpdxlicenseWsuipa)
    "WTFPL" -> Ok(SpdxlicenseWtfpl)
    "X11" -> Ok(SpdxlicenseX11)
    "Xerox" -> Ok(SpdxlicenseXerox)
    "XFree86-1.1" -> Ok(SpdxlicenseXfree8611)
    "xinetd" -> Ok(SpdxlicenseXinetd)
    "Xnet" -> Ok(SpdxlicenseXnet)
    "xpp" -> Ok(SpdxlicenseXpp)
    "XSkat" -> Ok(SpdxlicenseXskat)
    "YPL-1.0" -> Ok(SpdxlicenseYpl10)
    "YPL-1.1" -> Ok(SpdxlicenseYpl11)
    "Zed" -> Ok(SpdxlicenseZed)
    "Zend-2.0" -> Ok(SpdxlicenseZend20)
    "Zimbra-1.3" -> Ok(SpdxlicenseZimbra13)
    "Zimbra-1.4" -> Ok(SpdxlicenseZimbra14)
    "zlib-acknowledgement" -> Ok(SpdxlicenseZlibacknowledgement)
    "Zlib" -> Ok(SpdxlicenseZlib)
    "ZPL-1.1" -> Ok(SpdxlicenseZpl11)
    "ZPL-2.0" -> Ok(SpdxlicenseZpl20)
    "ZPL-2.1" -> Ok(SpdxlicenseZpl21)
    _ -> Error(Nil)
  }
}

pub fn spdxlicense_decoder() -> Decoder(Spdxlicense) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-open-source" -> decode.success(SpdxlicenseNotopensource)
    "0BSD" -> decode.success(Spdxlicense0bsd)
    "AAL" -> decode.success(SpdxlicenseAal)
    "Abstyles" -> decode.success(SpdxlicenseAbstyles)
    "Adobe-2006" -> decode.success(SpdxlicenseAdobe2006)
    "Adobe-Glyph" -> decode.success(SpdxlicenseAdobeglyph)
    "ADSL" -> decode.success(SpdxlicenseAdsl)
    "AFL-1.1" -> decode.success(SpdxlicenseAfl11)
    "AFL-1.2" -> decode.success(SpdxlicenseAfl12)
    "AFL-2.0" -> decode.success(SpdxlicenseAfl20)
    "AFL-2.1" -> decode.success(SpdxlicenseAfl21)
    "AFL-3.0" -> decode.success(SpdxlicenseAfl30)
    "Afmparse" -> decode.success(SpdxlicenseAfmparse)
    "AGPL-1.0-only" -> decode.success(SpdxlicenseAgpl10only)
    "AGPL-1.0-or-later" -> decode.success(SpdxlicenseAgpl10orlater)
    "AGPL-3.0-only" -> decode.success(SpdxlicenseAgpl30only)
    "AGPL-3.0-or-later" -> decode.success(SpdxlicenseAgpl30orlater)
    "Aladdin" -> decode.success(SpdxlicenseAladdin)
    "AMDPLPA" -> decode.success(SpdxlicenseAmdplpa)
    "AML" -> decode.success(SpdxlicenseAml)
    "AMPAS" -> decode.success(SpdxlicenseAmpas)
    "ANTLR-PD" -> decode.success(SpdxlicenseAntlrpd)
    "Apache-1.0" -> decode.success(SpdxlicenseApache10)
    "Apache-1.1" -> decode.success(SpdxlicenseApache11)
    "Apache-2.0" -> decode.success(SpdxlicenseApache20)
    "APAFML" -> decode.success(SpdxlicenseApafml)
    "APL-1.0" -> decode.success(SpdxlicenseApl10)
    "APSL-1.0" -> decode.success(SpdxlicenseApsl10)
    "APSL-1.1" -> decode.success(SpdxlicenseApsl11)
    "APSL-1.2" -> decode.success(SpdxlicenseApsl12)
    "APSL-2.0" -> decode.success(SpdxlicenseApsl20)
    "Artistic-1.0-cl8" -> decode.success(SpdxlicenseArtistic10cl8)
    "Artistic-1.0-Perl" -> decode.success(SpdxlicenseArtistic10perl)
    "Artistic-1.0" -> decode.success(SpdxlicenseArtistic10)
    "Artistic-2.0" -> decode.success(SpdxlicenseArtistic20)
    "Bahyph" -> decode.success(SpdxlicenseBahyph)
    "Barr" -> decode.success(SpdxlicenseBarr)
    "Beerware" -> decode.success(SpdxlicenseBeerware)
    "BitTorrent-1.0" -> decode.success(SpdxlicenseBittorrent10)
    "BitTorrent-1.1" -> decode.success(SpdxlicenseBittorrent11)
    "Borceux" -> decode.success(SpdxlicenseBorceux)
    "BSD-1-Clause" -> decode.success(SpdxlicenseBsd1clause)
    "BSD-2-Clause-FreeBSD" -> decode.success(SpdxlicenseBsd2clausefreebsd)
    "BSD-2-Clause-NetBSD" -> decode.success(SpdxlicenseBsd2clausenetbsd)
    "BSD-2-Clause-Patent" -> decode.success(SpdxlicenseBsd2clausepatent)
    "BSD-2-Clause" -> decode.success(SpdxlicenseBsd2clause)
    "BSD-3-Clause-Attribution" ->
      decode.success(SpdxlicenseBsd3clauseattribution)
    "BSD-3-Clause-Clear" -> decode.success(SpdxlicenseBsd3clauseclear)
    "BSD-3-Clause-LBNL" -> decode.success(SpdxlicenseBsd3clauselbnl)
    "BSD-3-Clause-No-Nuclear-License-2014" ->
      decode.success(SpdxlicenseBsd3clausenonuclearlicense2014)
    "BSD-3-Clause-No-Nuclear-License" ->
      decode.success(SpdxlicenseBsd3clausenonuclearlicense)
    "BSD-3-Clause-No-Nuclear-Warranty" ->
      decode.success(SpdxlicenseBsd3clausenonuclearwarranty)
    "BSD-3-Clause" -> decode.success(SpdxlicenseBsd3clause)
    "BSD-4-Clause-UC" -> decode.success(SpdxlicenseBsd4clauseuc)
    "BSD-4-Clause" -> decode.success(SpdxlicenseBsd4clause)
    "BSD-Protection" -> decode.success(SpdxlicenseBsdprotection)
    "BSD-Source-Code" -> decode.success(SpdxlicenseBsdsourcecode)
    "BSL-1.0" -> decode.success(SpdxlicenseBsl10)
    "bzip2-1.0.5" -> decode.success(SpdxlicenseBzip2105)
    "bzip2-1.0.6" -> decode.success(SpdxlicenseBzip2106)
    "Caldera" -> decode.success(SpdxlicenseCaldera)
    "CATOSL-1.1" -> decode.success(SpdxlicenseCatosl11)
    "CC-BY-1.0" -> decode.success(SpdxlicenseCcby10)
    "CC-BY-2.0" -> decode.success(SpdxlicenseCcby20)
    "CC-BY-2.5" -> decode.success(SpdxlicenseCcby25)
    "CC-BY-3.0" -> decode.success(SpdxlicenseCcby30)
    "CC-BY-4.0" -> decode.success(SpdxlicenseCcby40)
    "CC-BY-NC-1.0" -> decode.success(SpdxlicenseCcbync10)
    "CC-BY-NC-2.0" -> decode.success(SpdxlicenseCcbync20)
    "CC-BY-NC-2.5" -> decode.success(SpdxlicenseCcbync25)
    "CC-BY-NC-3.0" -> decode.success(SpdxlicenseCcbync30)
    "CC-BY-NC-4.0" -> decode.success(SpdxlicenseCcbync40)
    "CC-BY-NC-ND-1.0" -> decode.success(SpdxlicenseCcbyncnd10)
    "CC-BY-NC-ND-2.0" -> decode.success(SpdxlicenseCcbyncnd20)
    "CC-BY-NC-ND-2.5" -> decode.success(SpdxlicenseCcbyncnd25)
    "CC-BY-NC-ND-3.0" -> decode.success(SpdxlicenseCcbyncnd30)
    "CC-BY-NC-ND-4.0" -> decode.success(SpdxlicenseCcbyncnd40)
    "CC-BY-NC-SA-1.0" -> decode.success(SpdxlicenseCcbyncsa10)
    "CC-BY-NC-SA-2.0" -> decode.success(SpdxlicenseCcbyncsa20)
    "CC-BY-NC-SA-2.5" -> decode.success(SpdxlicenseCcbyncsa25)
    "CC-BY-NC-SA-3.0" -> decode.success(SpdxlicenseCcbyncsa30)
    "CC-BY-NC-SA-4.0" -> decode.success(SpdxlicenseCcbyncsa40)
    "CC-BY-ND-1.0" -> decode.success(SpdxlicenseCcbynd10)
    "CC-BY-ND-2.0" -> decode.success(SpdxlicenseCcbynd20)
    "CC-BY-ND-2.5" -> decode.success(SpdxlicenseCcbynd25)
    "CC-BY-ND-3.0" -> decode.success(SpdxlicenseCcbynd30)
    "CC-BY-ND-4.0" -> decode.success(SpdxlicenseCcbynd40)
    "CC-BY-SA-1.0" -> decode.success(SpdxlicenseCcbysa10)
    "CC-BY-SA-2.0" -> decode.success(SpdxlicenseCcbysa20)
    "CC-BY-SA-2.5" -> decode.success(SpdxlicenseCcbysa25)
    "CC-BY-SA-3.0" -> decode.success(SpdxlicenseCcbysa30)
    "CC-BY-SA-4.0" -> decode.success(SpdxlicenseCcbysa40)
    "CC0-1.0" -> decode.success(SpdxlicenseCc010)
    "CDDL-1.0" -> decode.success(SpdxlicenseCddl10)
    "CDDL-1.1" -> decode.success(SpdxlicenseCddl11)
    "CDLA-Permissive-1.0" -> decode.success(SpdxlicenseCdlapermissive10)
    "CDLA-Sharing-1.0" -> decode.success(SpdxlicenseCdlasharing10)
    "CECILL-1.0" -> decode.success(SpdxlicenseCecill10)
    "CECILL-1.1" -> decode.success(SpdxlicenseCecill11)
    "CECILL-2.0" -> decode.success(SpdxlicenseCecill20)
    "CECILL-2.1" -> decode.success(SpdxlicenseCecill21)
    "CECILL-B" -> decode.success(SpdxlicenseCecillb)
    "CECILL-C" -> decode.success(SpdxlicenseCecillc)
    "ClArtistic" -> decode.success(SpdxlicenseClartistic)
    "CNRI-Jython" -> decode.success(SpdxlicenseCnrijython)
    "CNRI-Python-GPL-Compatible" ->
      decode.success(SpdxlicenseCnripythongplcompatible)
    "CNRI-Python" -> decode.success(SpdxlicenseCnripython)
    "Condor-1.1" -> decode.success(SpdxlicenseCondor11)
    "CPAL-1.0" -> decode.success(SpdxlicenseCpal10)
    "CPL-1.0" -> decode.success(SpdxlicenseCpl10)
    "CPOL-1.02" -> decode.success(SpdxlicenseCpol102)
    "Crossword" -> decode.success(SpdxlicenseCrossword)
    "CrystalStacker" -> decode.success(SpdxlicenseCrystalstacker)
    "CUA-OPL-1.0" -> decode.success(SpdxlicenseCuaopl10)
    "Cube" -> decode.success(SpdxlicenseCube)
    "curl" -> decode.success(SpdxlicenseCurl)
    "D-FSL-1.0" -> decode.success(SpdxlicenseDfsl10)
    "diffmark" -> decode.success(SpdxlicenseDiffmark)
    "DOC" -> decode.success(SpdxlicenseDoc)
    "Dotseqn" -> decode.success(SpdxlicenseDotseqn)
    "DSDP" -> decode.success(SpdxlicenseDsdp)
    "dvipdfm" -> decode.success(SpdxlicenseDvipdfm)
    "ECL-1.0" -> decode.success(SpdxlicenseEcl10)
    "ECL-2.0" -> decode.success(SpdxlicenseEcl20)
    "EFL-1.0" -> decode.success(SpdxlicenseEfl10)
    "EFL-2.0" -> decode.success(SpdxlicenseEfl20)
    "eGenix" -> decode.success(SpdxlicenseEgenix)
    "Entessa" -> decode.success(SpdxlicenseEntessa)
    "EPL-1.0" -> decode.success(SpdxlicenseEpl10)
    "EPL-2.0" -> decode.success(SpdxlicenseEpl20)
    "ErlPL-1.1" -> decode.success(SpdxlicenseErlpl11)
    "EUDatagrid" -> decode.success(SpdxlicenseEudatagrid)
    "EUPL-1.0" -> decode.success(SpdxlicenseEupl10)
    "EUPL-1.1" -> decode.success(SpdxlicenseEupl11)
    "EUPL-1.2" -> decode.success(SpdxlicenseEupl12)
    "Eurosym" -> decode.success(SpdxlicenseEurosym)
    "Fair" -> decode.success(SpdxlicenseFair)
    "Frameworx-1.0" -> decode.success(SpdxlicenseFrameworx10)
    "FreeImage" -> decode.success(SpdxlicenseFreeimage)
    "FSFAP" -> decode.success(SpdxlicenseFsfap)
    "FSFUL" -> decode.success(SpdxlicenseFsful)
    "FSFULLR" -> decode.success(SpdxlicenseFsfullr)
    "FTL" -> decode.success(SpdxlicenseFtl)
    "GFDL-1.1-only" -> decode.success(SpdxlicenseGfdl11only)
    "GFDL-1.1-or-later" -> decode.success(SpdxlicenseGfdl11orlater)
    "GFDL-1.2-only" -> decode.success(SpdxlicenseGfdl12only)
    "GFDL-1.2-or-later" -> decode.success(SpdxlicenseGfdl12orlater)
    "GFDL-1.3-only" -> decode.success(SpdxlicenseGfdl13only)
    "GFDL-1.3-or-later" -> decode.success(SpdxlicenseGfdl13orlater)
    "Giftware" -> decode.success(SpdxlicenseGiftware)
    "GL2PS" -> decode.success(SpdxlicenseGl2ps)
    "Glide" -> decode.success(SpdxlicenseGlide)
    "Glulxe" -> decode.success(SpdxlicenseGlulxe)
    "gnuplot" -> decode.success(SpdxlicenseGnuplot)
    "GPL-1.0-only" -> decode.success(SpdxlicenseGpl10only)
    "GPL-1.0-or-later" -> decode.success(SpdxlicenseGpl10orlater)
    "GPL-2.0-only" -> decode.success(SpdxlicenseGpl20only)
    "GPL-2.0-or-later" -> decode.success(SpdxlicenseGpl20orlater)
    "GPL-3.0-only" -> decode.success(SpdxlicenseGpl30only)
    "GPL-3.0-or-later" -> decode.success(SpdxlicenseGpl30orlater)
    "gSOAP-1.3b" -> decode.success(SpdxlicenseGsoap13b)
    "HaskellReport" -> decode.success(SpdxlicenseHaskellreport)
    "HPND" -> decode.success(SpdxlicenseHpnd)
    "IBM-pibs" -> decode.success(SpdxlicenseIbmpibs)
    "ICU" -> decode.success(SpdxlicenseIcu)
    "IJG" -> decode.success(SpdxlicenseIjg)
    "ImageMagick" -> decode.success(SpdxlicenseImagemagick)
    "iMatix" -> decode.success(SpdxlicenseImatix)
    "Imlib2" -> decode.success(SpdxlicenseImlib2)
    "Info-ZIP" -> decode.success(SpdxlicenseInfozip)
    "Intel-ACPI" -> decode.success(SpdxlicenseIntelacpi)
    "Intel" -> decode.success(SpdxlicenseIntel)
    "Interbase-1.0" -> decode.success(SpdxlicenseInterbase10)
    "IPA" -> decode.success(SpdxlicenseIpa)
    "IPL-1.0" -> decode.success(SpdxlicenseIpl10)
    "ISC" -> decode.success(SpdxlicenseIsc)
    "JasPer-2.0" -> decode.success(SpdxlicenseJasper20)
    "JSON" -> decode.success(SpdxlicenseJson)
    "LAL-1.2" -> decode.success(SpdxlicenseLal12)
    "LAL-1.3" -> decode.success(SpdxlicenseLal13)
    "Latex2e" -> decode.success(SpdxlicenseLatex2e)
    "Leptonica" -> decode.success(SpdxlicenseLeptonica)
    "LGPL-2.0-only" -> decode.success(SpdxlicenseLgpl20only)
    "LGPL-2.0-or-later" -> decode.success(SpdxlicenseLgpl20orlater)
    "LGPL-2.1-only" -> decode.success(SpdxlicenseLgpl21only)
    "LGPL-2.1-or-later" -> decode.success(SpdxlicenseLgpl21orlater)
    "LGPL-3.0-only" -> decode.success(SpdxlicenseLgpl30only)
    "LGPL-3.0-or-later" -> decode.success(SpdxlicenseLgpl30orlater)
    "LGPLLR" -> decode.success(SpdxlicenseLgpllr)
    "Libpng" -> decode.success(SpdxlicenseLibpng)
    "libtiff" -> decode.success(SpdxlicenseLibtiff)
    "LiLiQ-P-1.1" -> decode.success(SpdxlicenseLiliqp11)
    "LiLiQ-R-1.1" -> decode.success(SpdxlicenseLiliqr11)
    "LiLiQ-Rplus-1.1" -> decode.success(SpdxlicenseLiliqrplus11)
    "Linux-OpenIB" -> decode.success(SpdxlicenseLinuxopenib)
    "LPL-1.0" -> decode.success(SpdxlicenseLpl10)
    "LPL-1.02" -> decode.success(SpdxlicenseLpl102)
    "LPPL-1.0" -> decode.success(SpdxlicenseLppl10)
    "LPPL-1.1" -> decode.success(SpdxlicenseLppl11)
    "LPPL-1.2" -> decode.success(SpdxlicenseLppl12)
    "LPPL-1.3a" -> decode.success(SpdxlicenseLppl13a)
    "LPPL-1.3c" -> decode.success(SpdxlicenseLppl13c)
    "MakeIndex" -> decode.success(SpdxlicenseMakeindex)
    "MirOS" -> decode.success(SpdxlicenseMiros)
    "MIT-0" -> decode.success(SpdxlicenseMit0)
    "MIT-advertising" -> decode.success(SpdxlicenseMitadvertising)
    "MIT-CMU" -> decode.success(SpdxlicenseMitcmu)
    "MIT-enna" -> decode.success(SpdxlicenseMitenna)
    "MIT-feh" -> decode.success(SpdxlicenseMitfeh)
    "MIT" -> decode.success(SpdxlicenseMit)
    "MITNFA" -> decode.success(SpdxlicenseMitnfa)
    "Motosoto" -> decode.success(SpdxlicenseMotosoto)
    "mpich2" -> decode.success(SpdxlicenseMpich2)
    "MPL-1.0" -> decode.success(SpdxlicenseMpl10)
    "MPL-1.1" -> decode.success(SpdxlicenseMpl11)
    "MPL-2.0-no-copyleft-exception" ->
      decode.success(SpdxlicenseMpl20nocopyleftexception)
    "MPL-2.0" -> decode.success(SpdxlicenseMpl20)
    "MS-PL" -> decode.success(SpdxlicenseMspl)
    "MS-RL" -> decode.success(SpdxlicenseMsrl)
    "MTLL" -> decode.success(SpdxlicenseMtll)
    "Multics" -> decode.success(SpdxlicenseMultics)
    "Mup" -> decode.success(SpdxlicenseMup)
    "NASA-1.3" -> decode.success(SpdxlicenseNasa13)
    "Naumen" -> decode.success(SpdxlicenseNaumen)
    "NBPL-1.0" -> decode.success(SpdxlicenseNbpl10)
    "NCSA" -> decode.success(SpdxlicenseNcsa)
    "Net-SNMP" -> decode.success(SpdxlicenseNetsnmp)
    "NetCDF" -> decode.success(SpdxlicenseNetcdf)
    "Newsletr" -> decode.success(SpdxlicenseNewsletr)
    "NGPL" -> decode.success(SpdxlicenseNgpl)
    "NLOD-1.0" -> decode.success(SpdxlicenseNlod10)
    "NLPL" -> decode.success(SpdxlicenseNlpl)
    "Nokia" -> decode.success(SpdxlicenseNokia)
    "NOSL" -> decode.success(SpdxlicenseNosl)
    "Noweb" -> decode.success(SpdxlicenseNoweb)
    "NPL-1.0" -> decode.success(SpdxlicenseNpl10)
    "NPL-1.1" -> decode.success(SpdxlicenseNpl11)
    "NPOSL-3.0" -> decode.success(SpdxlicenseNposl30)
    "NRL" -> decode.success(SpdxlicenseNrl)
    "NTP" -> decode.success(SpdxlicenseNtp)
    "OCCT-PL" -> decode.success(SpdxlicenseOcctpl)
    "OCLC-2.0" -> decode.success(SpdxlicenseOclc20)
    "ODbL-1.0" -> decode.success(SpdxlicenseOdbl10)
    "OFL-1.0" -> decode.success(SpdxlicenseOfl10)
    "OFL-1.1" -> decode.success(SpdxlicenseOfl11)
    "OGTSL" -> decode.success(SpdxlicenseOgtsl)
    "OLDAP-1.1" -> decode.success(SpdxlicenseOldap11)
    "OLDAP-1.2" -> decode.success(SpdxlicenseOldap12)
    "OLDAP-1.3" -> decode.success(SpdxlicenseOldap13)
    "OLDAP-1.4" -> decode.success(SpdxlicenseOldap14)
    "OLDAP-2.0.1" -> decode.success(SpdxlicenseOldap201)
    "OLDAP-2.0" -> decode.success(SpdxlicenseOldap20)
    "OLDAP-2.1" -> decode.success(SpdxlicenseOldap21)
    "OLDAP-2.2.1" -> decode.success(SpdxlicenseOldap221)
    "OLDAP-2.2.2" -> decode.success(SpdxlicenseOldap222)
    "OLDAP-2.2" -> decode.success(SpdxlicenseOldap22)
    "OLDAP-2.3" -> decode.success(SpdxlicenseOldap23)
    "OLDAP-2.4" -> decode.success(SpdxlicenseOldap24)
    "OLDAP-2.5" -> decode.success(SpdxlicenseOldap25)
    "OLDAP-2.6" -> decode.success(SpdxlicenseOldap26)
    "OLDAP-2.7" -> decode.success(SpdxlicenseOldap27)
    "OLDAP-2.8" -> decode.success(SpdxlicenseOldap28)
    "OML" -> decode.success(SpdxlicenseOml)
    "OpenSSL" -> decode.success(SpdxlicenseOpenssl)
    "OPL-1.0" -> decode.success(SpdxlicenseOpl10)
    "OSET-PL-2.1" -> decode.success(SpdxlicenseOsetpl21)
    "OSL-1.0" -> decode.success(SpdxlicenseOsl10)
    "OSL-1.1" -> decode.success(SpdxlicenseOsl11)
    "OSL-2.0" -> decode.success(SpdxlicenseOsl20)
    "OSL-2.1" -> decode.success(SpdxlicenseOsl21)
    "OSL-3.0" -> decode.success(SpdxlicenseOsl30)
    "PDDL-1.0" -> decode.success(SpdxlicensePddl10)
    "PHP-3.0" -> decode.success(SpdxlicensePhp30)
    "PHP-3.01" -> decode.success(SpdxlicensePhp301)
    "Plexus" -> decode.success(SpdxlicensePlexus)
    "PostgreSQL" -> decode.success(SpdxlicensePostgresql)
    "psfrag" -> decode.success(SpdxlicensePsfrag)
    "psutils" -> decode.success(SpdxlicensePsutils)
    "Python-2.0" -> decode.success(SpdxlicensePython20)
    "Qhull" -> decode.success(SpdxlicenseQhull)
    "QPL-1.0" -> decode.success(SpdxlicenseQpl10)
    "Rdisc" -> decode.success(SpdxlicenseRdisc)
    "RHeCos-1.1" -> decode.success(SpdxlicenseRhecos11)
    "RPL-1.1" -> decode.success(SpdxlicenseRpl11)
    "RPL-1.5" -> decode.success(SpdxlicenseRpl15)
    "RPSL-1.0" -> decode.success(SpdxlicenseRpsl10)
    "RSA-MD" -> decode.success(SpdxlicenseRsamd)
    "RSCPL" -> decode.success(SpdxlicenseRscpl)
    "Ruby" -> decode.success(SpdxlicenseRuby)
    "SAX-PD" -> decode.success(SpdxlicenseSaxpd)
    "Saxpath" -> decode.success(SpdxlicenseSaxpath)
    "SCEA" -> decode.success(SpdxlicenseScea)
    "Sendmail" -> decode.success(SpdxlicenseSendmail)
    "SGI-B-1.0" -> decode.success(SpdxlicenseSgib10)
    "SGI-B-1.1" -> decode.success(SpdxlicenseSgib11)
    "SGI-B-2.0" -> decode.success(SpdxlicenseSgib20)
    "SimPL-2.0" -> decode.success(SpdxlicenseSimpl20)
    "SISSL-1.2" -> decode.success(SpdxlicenseSissl12)
    "SISSL" -> decode.success(SpdxlicenseSissl)
    "Sleepycat" -> decode.success(SpdxlicenseSleepycat)
    "SMLNJ" -> decode.success(SpdxlicenseSmlnj)
    "SMPPL" -> decode.success(SpdxlicenseSmppl)
    "SNIA" -> decode.success(SpdxlicenseSnia)
    "Spencer-86" -> decode.success(SpdxlicenseSpencer86)
    "Spencer-94" -> decode.success(SpdxlicenseSpencer94)
    "Spencer-99" -> decode.success(SpdxlicenseSpencer99)
    "SPL-1.0" -> decode.success(SpdxlicenseSpl10)
    "SugarCRM-1.1.3" -> decode.success(SpdxlicenseSugarcrm113)
    "SWL" -> decode.success(SpdxlicenseSwl)
    "TCL" -> decode.success(SpdxlicenseTcl)
    "TCP-wrappers" -> decode.success(SpdxlicenseTcpwrappers)
    "TMate" -> decode.success(SpdxlicenseTmate)
    "TORQUE-1.1" -> decode.success(SpdxlicenseTorque11)
    "TOSL" -> decode.success(SpdxlicenseTosl)
    "Unicode-DFS-2015" -> decode.success(SpdxlicenseUnicodedfs2015)
    "Unicode-DFS-2016" -> decode.success(SpdxlicenseUnicodedfs2016)
    "Unicode-TOU" -> decode.success(SpdxlicenseUnicodetou)
    "Unlicense" -> decode.success(SpdxlicenseUnlicense)
    "UPL-1.0" -> decode.success(SpdxlicenseUpl10)
    "Vim" -> decode.success(SpdxlicenseVim)
    "VOSTROM" -> decode.success(SpdxlicenseVostrom)
    "VSL-1.0" -> decode.success(SpdxlicenseVsl10)
    "W3C-19980720" -> decode.success(SpdxlicenseW3c19980720)
    "W3C-20150513" -> decode.success(SpdxlicenseW3c20150513)
    "W3C" -> decode.success(SpdxlicenseW3c)
    "Watcom-1.0" -> decode.success(SpdxlicenseWatcom10)
    "Wsuipa" -> decode.success(SpdxlicenseWsuipa)
    "WTFPL" -> decode.success(SpdxlicenseWtfpl)
    "X11" -> decode.success(SpdxlicenseX11)
    "Xerox" -> decode.success(SpdxlicenseXerox)
    "XFree86-1.1" -> decode.success(SpdxlicenseXfree8611)
    "xinetd" -> decode.success(SpdxlicenseXinetd)
    "Xnet" -> decode.success(SpdxlicenseXnet)
    "xpp" -> decode.success(SpdxlicenseXpp)
    "XSkat" -> decode.success(SpdxlicenseXskat)
    "YPL-1.0" -> decode.success(SpdxlicenseYpl10)
    "YPL-1.1" -> decode.success(SpdxlicenseYpl11)
    "Zed" -> decode.success(SpdxlicenseZed)
    "Zend-2.0" -> decode.success(SpdxlicenseZend20)
    "Zimbra-1.3" -> decode.success(SpdxlicenseZimbra13)
    "Zimbra-1.4" -> decode.success(SpdxlicenseZimbra14)
    "zlib-acknowledgement" -> decode.success(SpdxlicenseZlibacknowledgement)
    "Zlib" -> decode.success(SpdxlicenseZlib)
    "ZPL-1.1" -> decode.success(SpdxlicenseZpl11)
    "ZPL-2.0" -> decode.success(SpdxlicenseZpl20)
    "ZPL-2.1" -> decode.success(SpdxlicenseZpl21)
    _ -> decode.failure(SpdxlicenseNotopensource, "Spdxlicense")
  }
}

pub type Specimencombined {
  SpecimencombinedGrouped
  SpecimencombinedPooled
}

pub fn specimencombined_to_json(specimencombined: Specimencombined) -> Json {
  json.string(specimencombined_to_string(specimencombined))
}

pub fn specimencombined_to_string(specimencombined: Specimencombined) -> String {
  case specimencombined {
    SpecimencombinedGrouped -> "grouped"
    SpecimencombinedPooled -> "pooled"
  }
}

pub fn specimencombined_from_string(s: String) -> Result(Specimencombined, Nil) {
  case s {
    "grouped" -> Ok(SpecimencombinedGrouped)
    "pooled" -> Ok(SpecimencombinedPooled)
    _ -> Error(Nil)
  }
}

pub fn specimencombined_decoder() -> Decoder(Specimencombined) {
  use variant <- decode.then(decode.string)
  case variant {
    "grouped" -> decode.success(SpecimencombinedGrouped)
    "pooled" -> decode.success(SpecimencombinedPooled)
    _ -> decode.failure(SpecimencombinedGrouped, "Specimencombined")
  }
}

pub type Specimencontainedpreference {
  SpecimencontainedpreferencePreferred
  SpecimencontainedpreferenceAlternate
}

pub fn specimencontainedpreference_to_json(
  specimencontainedpreference: Specimencontainedpreference,
) -> Json {
  json.string(specimencontainedpreference_to_string(specimencontainedpreference))
}

pub fn specimencontainedpreference_to_string(
  specimencontainedpreference: Specimencontainedpreference,
) -> String {
  case specimencontainedpreference {
    SpecimencontainedpreferencePreferred -> "preferred"
    SpecimencontainedpreferenceAlternate -> "alternate"
  }
}

pub fn specimencontainedpreference_from_string(
  s: String,
) -> Result(Specimencontainedpreference, Nil) {
  case s {
    "preferred" -> Ok(SpecimencontainedpreferencePreferred)
    "alternate" -> Ok(SpecimencontainedpreferenceAlternate)
    _ -> Error(Nil)
  }
}

pub fn specimencontainedpreference_decoder() -> Decoder(
  Specimencontainedpreference,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "preferred" -> decode.success(SpecimencontainedpreferencePreferred)
    "alternate" -> decode.success(SpecimencontainedpreferenceAlternate)
    _ ->
      decode.failure(
        SpecimencontainedpreferencePreferred,
        "Specimencontainedpreference",
      )
  }
}

pub type Specimenstatus {
  SpecimenstatusAvailable
  SpecimenstatusUnavailable
  SpecimenstatusUnsatisfactory
  SpecimenstatusEnteredinerror
}

pub fn specimenstatus_to_json(specimenstatus: Specimenstatus) -> Json {
  json.string(specimenstatus_to_string(specimenstatus))
}

pub fn specimenstatus_to_string(specimenstatus: Specimenstatus) -> String {
  case specimenstatus {
    SpecimenstatusAvailable -> "available"
    SpecimenstatusUnavailable -> "unavailable"
    SpecimenstatusUnsatisfactory -> "unsatisfactory"
    SpecimenstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn specimenstatus_from_string(s: String) -> Result(Specimenstatus, Nil) {
  case s {
    "available" -> Ok(SpecimenstatusAvailable)
    "unavailable" -> Ok(SpecimenstatusUnavailable)
    "unsatisfactory" -> Ok(SpecimenstatusUnsatisfactory)
    "entered-in-error" -> Ok(SpecimenstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn specimenstatus_decoder() -> Decoder(Specimenstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "available" -> decode.success(SpecimenstatusAvailable)
    "unavailable" -> decode.success(SpecimenstatusUnavailable)
    "unsatisfactory" -> decode.success(SpecimenstatusUnsatisfactory)
    "entered-in-error" -> decode.success(SpecimenstatusEnteredinerror)
    _ -> decode.failure(SpecimenstatusAvailable, "Specimenstatus")
  }
}

pub type Strandtype {
  StrandtypeWatson
  StrandtypeCrick
}

pub fn strandtype_to_json(strandtype: Strandtype) -> Json {
  json.string(strandtype_to_string(strandtype))
}

pub fn strandtype_to_string(strandtype: Strandtype) -> String {
  case strandtype {
    StrandtypeWatson -> "watson"
    StrandtypeCrick -> "crick"
  }
}

pub fn strandtype_from_string(s: String) -> Result(Strandtype, Nil) {
  case s {
    "watson" -> Ok(StrandtypeWatson)
    "crick" -> Ok(StrandtypeCrick)
    _ -> Error(Nil)
  }
}

pub fn strandtype_decoder() -> Decoder(Strandtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "watson" -> decode.success(StrandtypeWatson)
    "crick" -> decode.success(StrandtypeCrick)
    _ -> decode.failure(StrandtypeWatson, "Strandtype")
  }
}

pub type Structuredefinitionkind {
  StructuredefinitionkindPrimitivetype
  StructuredefinitionkindComplextype
  StructuredefinitionkindResource
  StructuredefinitionkindLogical
}

pub fn structuredefinitionkind_to_json(
  structuredefinitionkind: Structuredefinitionkind,
) -> Json {
  json.string(structuredefinitionkind_to_string(structuredefinitionkind))
}

pub fn structuredefinitionkind_to_string(
  structuredefinitionkind: Structuredefinitionkind,
) -> String {
  case structuredefinitionkind {
    StructuredefinitionkindPrimitivetype -> "primitive-type"
    StructuredefinitionkindComplextype -> "complex-type"
    StructuredefinitionkindResource -> "resource"
    StructuredefinitionkindLogical -> "logical"
  }
}

pub fn structuredefinitionkind_from_string(
  s: String,
) -> Result(Structuredefinitionkind, Nil) {
  case s {
    "primitive-type" -> Ok(StructuredefinitionkindPrimitivetype)
    "complex-type" -> Ok(StructuredefinitionkindComplextype)
    "resource" -> Ok(StructuredefinitionkindResource)
    "logical" -> Ok(StructuredefinitionkindLogical)
    _ -> Error(Nil)
  }
}

pub fn structuredefinitionkind_decoder() -> Decoder(Structuredefinitionkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "primitive-type" -> decode.success(StructuredefinitionkindPrimitivetype)
    "complex-type" -> decode.success(StructuredefinitionkindComplextype)
    "resource" -> decode.success(StructuredefinitionkindResource)
    "logical" -> decode.success(StructuredefinitionkindLogical)
    _ ->
      decode.failure(
        StructuredefinitionkindPrimitivetype,
        "Structuredefinitionkind",
      )
  }
}

pub type Submitdataupdatetype {
  SubmitdataupdatetypeIncremental
  SubmitdataupdatetypeSnapshot
}

pub fn submitdataupdatetype_to_json(
  submitdataupdatetype: Submitdataupdatetype,
) -> Json {
  json.string(submitdataupdatetype_to_string(submitdataupdatetype))
}

pub fn submitdataupdatetype_to_string(
  submitdataupdatetype: Submitdataupdatetype,
) -> String {
  case submitdataupdatetype {
    SubmitdataupdatetypeIncremental -> "incremental"
    SubmitdataupdatetypeSnapshot -> "snapshot"
  }
}

pub fn submitdataupdatetype_from_string(
  s: String,
) -> Result(Submitdataupdatetype, Nil) {
  case s {
    "incremental" -> Ok(SubmitdataupdatetypeIncremental)
    "snapshot" -> Ok(SubmitdataupdatetypeSnapshot)
    _ -> Error(Nil)
  }
}

pub fn submitdataupdatetype_decoder() -> Decoder(Submitdataupdatetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "incremental" -> decode.success(SubmitdataupdatetypeIncremental)
    "snapshot" -> decode.success(SubmitdataupdatetypeSnapshot)
    _ -> decode.failure(SubmitdataupdatetypeIncremental, "Submitdataupdatetype")
  }
}

pub type Subscriptionnotificationtype {
  SubscriptionnotificationtypeHandshake
  SubscriptionnotificationtypeHeartbeat
  SubscriptionnotificationtypeEventnotification
  SubscriptionnotificationtypeQuerystatus
  SubscriptionnotificationtypeQueryevent
}

pub fn subscriptionnotificationtype_to_json(
  subscriptionnotificationtype: Subscriptionnotificationtype,
) -> Json {
  json.string(subscriptionnotificationtype_to_string(
    subscriptionnotificationtype,
  ))
}

pub fn subscriptionnotificationtype_to_string(
  subscriptionnotificationtype: Subscriptionnotificationtype,
) -> String {
  case subscriptionnotificationtype {
    SubscriptionnotificationtypeHandshake -> "handshake"
    SubscriptionnotificationtypeHeartbeat -> "heartbeat"
    SubscriptionnotificationtypeEventnotification -> "event-notification"
    SubscriptionnotificationtypeQuerystatus -> "query-status"
    SubscriptionnotificationtypeQueryevent -> "query-event"
  }
}

pub fn subscriptionnotificationtype_from_string(
  s: String,
) -> Result(Subscriptionnotificationtype, Nil) {
  case s {
    "handshake" -> Ok(SubscriptionnotificationtypeHandshake)
    "heartbeat" -> Ok(SubscriptionnotificationtypeHeartbeat)
    "event-notification" -> Ok(SubscriptionnotificationtypeEventnotification)
    "query-status" -> Ok(SubscriptionnotificationtypeQuerystatus)
    "query-event" -> Ok(SubscriptionnotificationtypeQueryevent)
    _ -> Error(Nil)
  }
}

pub fn subscriptionnotificationtype_decoder() -> Decoder(
  Subscriptionnotificationtype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "handshake" -> decode.success(SubscriptionnotificationtypeHandshake)
    "heartbeat" -> decode.success(SubscriptionnotificationtypeHeartbeat)
    "event-notification" ->
      decode.success(SubscriptionnotificationtypeEventnotification)
    "query-status" -> decode.success(SubscriptionnotificationtypeQuerystatus)
    "query-event" -> decode.success(SubscriptionnotificationtypeQueryevent)
    _ ->
      decode.failure(
        SubscriptionnotificationtypeHandshake,
        "Subscriptionnotificationtype",
      )
  }
}

pub type Subscriptionpayloadcontent {
  SubscriptionpayloadcontentEmpty
  SubscriptionpayloadcontentIdonly
  SubscriptionpayloadcontentFullresource
}

pub fn subscriptionpayloadcontent_to_json(
  subscriptionpayloadcontent: Subscriptionpayloadcontent,
) -> Json {
  json.string(subscriptionpayloadcontent_to_string(subscriptionpayloadcontent))
}

pub fn subscriptionpayloadcontent_to_string(
  subscriptionpayloadcontent: Subscriptionpayloadcontent,
) -> String {
  case subscriptionpayloadcontent {
    SubscriptionpayloadcontentEmpty -> "empty"
    SubscriptionpayloadcontentIdonly -> "id-only"
    SubscriptionpayloadcontentFullresource -> "full-resource"
  }
}

pub fn subscriptionpayloadcontent_from_string(
  s: String,
) -> Result(Subscriptionpayloadcontent, Nil) {
  case s {
    "empty" -> Ok(SubscriptionpayloadcontentEmpty)
    "id-only" -> Ok(SubscriptionpayloadcontentIdonly)
    "full-resource" -> Ok(SubscriptionpayloadcontentFullresource)
    _ -> Error(Nil)
  }
}

pub fn subscriptionpayloadcontent_decoder() -> Decoder(
  Subscriptionpayloadcontent,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "empty" -> decode.success(SubscriptionpayloadcontentEmpty)
    "id-only" -> decode.success(SubscriptionpayloadcontentIdonly)
    "full-resource" -> decode.success(SubscriptionpayloadcontentFullresource)
    _ ->
      decode.failure(
        SubscriptionpayloadcontentEmpty,
        "Subscriptionpayloadcontent",
      )
  }
}

pub type Subscriptionstatus {
  SubscriptionstatusRequested
  SubscriptionstatusActive
  SubscriptionstatusError
  SubscriptionstatusOff
  SubscriptionstatusEnteredinerror
}

pub fn subscriptionstatus_to_json(
  subscriptionstatus: Subscriptionstatus,
) -> Json {
  json.string(subscriptionstatus_to_string(subscriptionstatus))
}

pub fn subscriptionstatus_to_string(
  subscriptionstatus: Subscriptionstatus,
) -> String {
  case subscriptionstatus {
    SubscriptionstatusRequested -> "requested"
    SubscriptionstatusActive -> "active"
    SubscriptionstatusError -> "error"
    SubscriptionstatusOff -> "off"
    SubscriptionstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn subscriptionstatus_from_string(
  s: String,
) -> Result(Subscriptionstatus, Nil) {
  case s {
    "requested" -> Ok(SubscriptionstatusRequested)
    "active" -> Ok(SubscriptionstatusActive)
    "error" -> Ok(SubscriptionstatusError)
    "off" -> Ok(SubscriptionstatusOff)
    "entered-in-error" -> Ok(SubscriptionstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn subscriptionstatus_decoder() -> Decoder(Subscriptionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "requested" -> decode.success(SubscriptionstatusRequested)
    "active" -> decode.success(SubscriptionstatusActive)
    "error" -> decode.success(SubscriptionstatusError)
    "off" -> decode.success(SubscriptionstatusOff)
    "entered-in-error" -> decode.success(SubscriptionstatusEnteredinerror)
    _ -> decode.failure(SubscriptionstatusRequested, "Subscriptionstatus")
  }
}

pub type Subscriptiontopiccrbehavior {
  SubscriptiontopiccrbehaviorTestpasses
  SubscriptiontopiccrbehaviorTestfails
}

pub fn subscriptiontopiccrbehavior_to_json(
  subscriptiontopiccrbehavior: Subscriptiontopiccrbehavior,
) -> Json {
  json.string(subscriptiontopiccrbehavior_to_string(subscriptiontopiccrbehavior))
}

pub fn subscriptiontopiccrbehavior_to_string(
  subscriptiontopiccrbehavior: Subscriptiontopiccrbehavior,
) -> String {
  case subscriptiontopiccrbehavior {
    SubscriptiontopiccrbehaviorTestpasses -> "test-passes"
    SubscriptiontopiccrbehaviorTestfails -> "test-fails"
  }
}

pub fn subscriptiontopiccrbehavior_from_string(
  s: String,
) -> Result(Subscriptiontopiccrbehavior, Nil) {
  case s {
    "test-passes" -> Ok(SubscriptiontopiccrbehaviorTestpasses)
    "test-fails" -> Ok(SubscriptiontopiccrbehaviorTestfails)
    _ -> Error(Nil)
  }
}

pub fn subscriptiontopiccrbehavior_decoder() -> Decoder(
  Subscriptiontopiccrbehavior,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "test-passes" -> decode.success(SubscriptiontopiccrbehaviorTestpasses)
    "test-fails" -> decode.success(SubscriptiontopiccrbehaviorTestfails)
    _ ->
      decode.failure(
        SubscriptiontopiccrbehaviorTestpasses,
        "Subscriptiontopiccrbehavior",
      )
  }
}

pub type Substancestatus {
  SubstancestatusActive
  SubstancestatusInactive
  SubstancestatusEnteredinerror
}

pub fn substancestatus_to_json(substancestatus: Substancestatus) -> Json {
  json.string(substancestatus_to_string(substancestatus))
}

pub fn substancestatus_to_string(substancestatus: Substancestatus) -> String {
  case substancestatus {
    SubstancestatusActive -> "active"
    SubstancestatusInactive -> "inactive"
    SubstancestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn substancestatus_from_string(s: String) -> Result(Substancestatus, Nil) {
  case s {
    "active" -> Ok(SubstancestatusActive)
    "inactive" -> Ok(SubstancestatusInactive)
    "entered-in-error" -> Ok(SubstancestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn substancestatus_decoder() -> Decoder(Substancestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(SubstancestatusActive)
    "inactive" -> decode.success(SubstancestatusInactive)
    "entered-in-error" -> decode.success(SubstancestatusEnteredinerror)
    _ -> decode.failure(SubstancestatusActive, "Substancestatus")
  }
}

pub type Supplydeliverystatus {
  SupplydeliverystatusInprogress
  SupplydeliverystatusCompleted
  SupplydeliverystatusAbandoned
  SupplydeliverystatusEnteredinerror
}

pub fn supplydeliverystatus_to_json(
  supplydeliverystatus: Supplydeliverystatus,
) -> Json {
  json.string(supplydeliverystatus_to_string(supplydeliverystatus))
}

pub fn supplydeliverystatus_to_string(
  supplydeliverystatus: Supplydeliverystatus,
) -> String {
  case supplydeliverystatus {
    SupplydeliverystatusInprogress -> "in-progress"
    SupplydeliverystatusCompleted -> "completed"
    SupplydeliverystatusAbandoned -> "abandoned"
    SupplydeliverystatusEnteredinerror -> "entered-in-error"
  }
}

pub fn supplydeliverystatus_from_string(
  s: String,
) -> Result(Supplydeliverystatus, Nil) {
  case s {
    "in-progress" -> Ok(SupplydeliverystatusInprogress)
    "completed" -> Ok(SupplydeliverystatusCompleted)
    "abandoned" -> Ok(SupplydeliverystatusAbandoned)
    "entered-in-error" -> Ok(SupplydeliverystatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn supplydeliverystatus_decoder() -> Decoder(Supplydeliverystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(SupplydeliverystatusInprogress)
    "completed" -> decode.success(SupplydeliverystatusCompleted)
    "abandoned" -> decode.success(SupplydeliverystatusAbandoned)
    "entered-in-error" -> decode.success(SupplydeliverystatusEnteredinerror)
    _ -> decode.failure(SupplydeliverystatusInprogress, "Supplydeliverystatus")
  }
}

pub type Supplyrequeststatus {
  SupplyrequeststatusDraft
  SupplyrequeststatusActive
  SupplyrequeststatusSuspended
  SupplyrequeststatusCancelled
  SupplyrequeststatusCompleted
  SupplyrequeststatusEnteredinerror
  SupplyrequeststatusUnknown
}

pub fn supplyrequeststatus_to_json(
  supplyrequeststatus: Supplyrequeststatus,
) -> Json {
  json.string(supplyrequeststatus_to_string(supplyrequeststatus))
}

pub fn supplyrequeststatus_to_string(
  supplyrequeststatus: Supplyrequeststatus,
) -> String {
  case supplyrequeststatus {
    SupplyrequeststatusDraft -> "draft"
    SupplyrequeststatusActive -> "active"
    SupplyrequeststatusSuspended -> "suspended"
    SupplyrequeststatusCancelled -> "cancelled"
    SupplyrequeststatusCompleted -> "completed"
    SupplyrequeststatusEnteredinerror -> "entered-in-error"
    SupplyrequeststatusUnknown -> "unknown"
  }
}

pub fn supplyrequeststatus_from_string(
  s: String,
) -> Result(Supplyrequeststatus, Nil) {
  case s {
    "draft" -> Ok(SupplyrequeststatusDraft)
    "active" -> Ok(SupplyrequeststatusActive)
    "suspended" -> Ok(SupplyrequeststatusSuspended)
    "cancelled" -> Ok(SupplyrequeststatusCancelled)
    "completed" -> Ok(SupplyrequeststatusCompleted)
    "entered-in-error" -> Ok(SupplyrequeststatusEnteredinerror)
    "unknown" -> Ok(SupplyrequeststatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn supplyrequeststatus_decoder() -> Decoder(Supplyrequeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(SupplyrequeststatusDraft)
    "active" -> decode.success(SupplyrequeststatusActive)
    "suspended" -> decode.success(SupplyrequeststatusSuspended)
    "cancelled" -> decode.success(SupplyrequeststatusCancelled)
    "completed" -> decode.success(SupplyrequeststatusCompleted)
    "entered-in-error" -> decode.success(SupplyrequeststatusEnteredinerror)
    "unknown" -> decode.success(SupplyrequeststatusUnknown)
    _ -> decode.failure(SupplyrequeststatusDraft, "Supplyrequeststatus")
  }
}

pub type Systemrestfulinteraction {
  SystemrestfulinteractionTransaction
  SystemrestfulinteractionBatch
  SystemrestfulinteractionSearchsystem
  SystemrestfulinteractionHistorysystem
}

pub fn systemrestfulinteraction_to_json(
  systemrestfulinteraction: Systemrestfulinteraction,
) -> Json {
  json.string(systemrestfulinteraction_to_string(systemrestfulinteraction))
}

pub fn systemrestfulinteraction_to_string(
  systemrestfulinteraction: Systemrestfulinteraction,
) -> String {
  case systemrestfulinteraction {
    SystemrestfulinteractionTransaction -> "transaction"
    SystemrestfulinteractionBatch -> "batch"
    SystemrestfulinteractionSearchsystem -> "search-system"
    SystemrestfulinteractionHistorysystem -> "history-system"
  }
}

pub fn systemrestfulinteraction_from_string(
  s: String,
) -> Result(Systemrestfulinteraction, Nil) {
  case s {
    "transaction" -> Ok(SystemrestfulinteractionTransaction)
    "batch" -> Ok(SystemrestfulinteractionBatch)
    "search-system" -> Ok(SystemrestfulinteractionSearchsystem)
    "history-system" -> Ok(SystemrestfulinteractionHistorysystem)
    _ -> Error(Nil)
  }
}

pub fn systemrestfulinteraction_decoder() -> Decoder(Systemrestfulinteraction) {
  use variant <- decode.then(decode.string)
  case variant {
    "transaction" -> decode.success(SystemrestfulinteractionTransaction)
    "batch" -> decode.success(SystemrestfulinteractionBatch)
    "search-system" -> decode.success(SystemrestfulinteractionSearchsystem)
    "history-system" -> decode.success(SystemrestfulinteractionHistorysystem)
    _ ->
      decode.failure(
        SystemrestfulinteractionTransaction,
        "Systemrestfulinteraction",
      )
  }
}

pub type Taskintent {
  TaskintentUnknown
  TaskintentProposal
  TaskintentPlan
  TaskintentOrder
  TaskintentOriginalorder
  TaskintentReflexorder
  TaskintentFillerorder
  TaskintentInstanceorder
  TaskintentOption
}

pub fn taskintent_to_json(taskintent: Taskintent) -> Json {
  json.string(taskintent_to_string(taskintent))
}

pub fn taskintent_to_string(taskintent: Taskintent) -> String {
  case taskintent {
    TaskintentUnknown -> "unknown"
    TaskintentProposal -> "proposal"
    TaskintentPlan -> "plan"
    TaskintentOrder -> "order"
    TaskintentOriginalorder -> "original-order"
    TaskintentReflexorder -> "reflex-order"
    TaskintentFillerorder -> "filler-order"
    TaskintentInstanceorder -> "instance-order"
    TaskintentOption -> "option"
  }
}

pub fn taskintent_from_string(s: String) -> Result(Taskintent, Nil) {
  case s {
    "unknown" -> Ok(TaskintentUnknown)
    "proposal" -> Ok(TaskintentProposal)
    "plan" -> Ok(TaskintentPlan)
    "order" -> Ok(TaskintentOrder)
    "original-order" -> Ok(TaskintentOriginalorder)
    "reflex-order" -> Ok(TaskintentReflexorder)
    "filler-order" -> Ok(TaskintentFillerorder)
    "instance-order" -> Ok(TaskintentInstanceorder)
    "option" -> Ok(TaskintentOption)
    _ -> Error(Nil)
  }
}

pub fn taskintent_decoder() -> Decoder(Taskintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(TaskintentUnknown)
    "proposal" -> decode.success(TaskintentProposal)
    "plan" -> decode.success(TaskintentPlan)
    "order" -> decode.success(TaskintentOrder)
    "original-order" -> decode.success(TaskintentOriginalorder)
    "reflex-order" -> decode.success(TaskintentReflexorder)
    "filler-order" -> decode.success(TaskintentFillerorder)
    "instance-order" -> decode.success(TaskintentInstanceorder)
    "option" -> decode.success(TaskintentOption)
    _ -> decode.failure(TaskintentUnknown, "Taskintent")
  }
}

pub type Taskstatus {
  TaskstatusDraft
  TaskstatusRequested
  TaskstatusReceived
  TaskstatusAccepted
  TaskstatusRejected
  TaskstatusReady
  TaskstatusCancelled
  TaskstatusInprogress
  TaskstatusOnhold
  TaskstatusFailed
  TaskstatusCompleted
  TaskstatusEnteredinerror
}

pub fn taskstatus_to_json(taskstatus: Taskstatus) -> Json {
  json.string(taskstatus_to_string(taskstatus))
}

pub fn taskstatus_to_string(taskstatus: Taskstatus) -> String {
  case taskstatus {
    TaskstatusDraft -> "draft"
    TaskstatusRequested -> "requested"
    TaskstatusReceived -> "received"
    TaskstatusAccepted -> "accepted"
    TaskstatusRejected -> "rejected"
    TaskstatusReady -> "ready"
    TaskstatusCancelled -> "cancelled"
    TaskstatusInprogress -> "in-progress"
    TaskstatusOnhold -> "on-hold"
    TaskstatusFailed -> "failed"
    TaskstatusCompleted -> "completed"
    TaskstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn taskstatus_from_string(s: String) -> Result(Taskstatus, Nil) {
  case s {
    "draft" -> Ok(TaskstatusDraft)
    "requested" -> Ok(TaskstatusRequested)
    "received" -> Ok(TaskstatusReceived)
    "accepted" -> Ok(TaskstatusAccepted)
    "rejected" -> Ok(TaskstatusRejected)
    "ready" -> Ok(TaskstatusReady)
    "cancelled" -> Ok(TaskstatusCancelled)
    "in-progress" -> Ok(TaskstatusInprogress)
    "on-hold" -> Ok(TaskstatusOnhold)
    "failed" -> Ok(TaskstatusFailed)
    "completed" -> Ok(TaskstatusCompleted)
    "entered-in-error" -> Ok(TaskstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn taskstatus_decoder() -> Decoder(Taskstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(TaskstatusDraft)
    "requested" -> decode.success(TaskstatusRequested)
    "received" -> decode.success(TaskstatusReceived)
    "accepted" -> decode.success(TaskstatusAccepted)
    "rejected" -> decode.success(TaskstatusRejected)
    "ready" -> decode.success(TaskstatusReady)
    "cancelled" -> decode.success(TaskstatusCancelled)
    "in-progress" -> decode.success(TaskstatusInprogress)
    "on-hold" -> decode.success(TaskstatusOnhold)
    "failed" -> decode.success(TaskstatusFailed)
    "completed" -> decode.success(TaskstatusCompleted)
    "entered-in-error" -> decode.success(TaskstatusEnteredinerror)
    _ -> decode.failure(TaskstatusDraft, "Taskstatus")
  }
}

pub type Transportintent {
  TransportintentUnknown
  TransportintentProposal
  TransportintentPlan
  TransportintentOrder
  TransportintentOriginalorder
  TransportintentReflexorder
  TransportintentFillerorder
  TransportintentInstanceorder
  TransportintentOption
}

pub fn transportintent_to_json(transportintent: Transportintent) -> Json {
  json.string(transportintent_to_string(transportintent))
}

pub fn transportintent_to_string(transportintent: Transportintent) -> String {
  case transportintent {
    TransportintentUnknown -> "unknown"
    TransportintentProposal -> "proposal"
    TransportintentPlan -> "plan"
    TransportintentOrder -> "order"
    TransportintentOriginalorder -> "original-order"
    TransportintentReflexorder -> "reflex-order"
    TransportintentFillerorder -> "filler-order"
    TransportintentInstanceorder -> "instance-order"
    TransportintentOption -> "option"
  }
}

pub fn transportintent_from_string(s: String) -> Result(Transportintent, Nil) {
  case s {
    "unknown" -> Ok(TransportintentUnknown)
    "proposal" -> Ok(TransportintentProposal)
    "plan" -> Ok(TransportintentPlan)
    "order" -> Ok(TransportintentOrder)
    "original-order" -> Ok(TransportintentOriginalorder)
    "reflex-order" -> Ok(TransportintentReflexorder)
    "filler-order" -> Ok(TransportintentFillerorder)
    "instance-order" -> Ok(TransportintentInstanceorder)
    "option" -> Ok(TransportintentOption)
    _ -> Error(Nil)
  }
}

pub fn transportintent_decoder() -> Decoder(Transportintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(TransportintentUnknown)
    "proposal" -> decode.success(TransportintentProposal)
    "plan" -> decode.success(TransportintentPlan)
    "order" -> decode.success(TransportintentOrder)
    "original-order" -> decode.success(TransportintentOriginalorder)
    "reflex-order" -> decode.success(TransportintentReflexorder)
    "filler-order" -> decode.success(TransportintentFillerorder)
    "instance-order" -> decode.success(TransportintentInstanceorder)
    "option" -> decode.success(TransportintentOption)
    _ -> decode.failure(TransportintentUnknown, "Transportintent")
  }
}

pub type Transportstatus {
  TransportstatusInprogress
  TransportstatusCompleted
  TransportstatusAbandoned
  TransportstatusCancelled
  TransportstatusPlanned
  TransportstatusEnteredinerror
}

pub fn transportstatus_to_json(transportstatus: Transportstatus) -> Json {
  json.string(transportstatus_to_string(transportstatus))
}

pub fn transportstatus_to_string(transportstatus: Transportstatus) -> String {
  case transportstatus {
    TransportstatusInprogress -> "in-progress"
    TransportstatusCompleted -> "completed"
    TransportstatusAbandoned -> "abandoned"
    TransportstatusCancelled -> "cancelled"
    TransportstatusPlanned -> "planned"
    TransportstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn transportstatus_from_string(s: String) -> Result(Transportstatus, Nil) {
  case s {
    "in-progress" -> Ok(TransportstatusInprogress)
    "completed" -> Ok(TransportstatusCompleted)
    "abandoned" -> Ok(TransportstatusAbandoned)
    "cancelled" -> Ok(TransportstatusCancelled)
    "planned" -> Ok(TransportstatusPlanned)
    "entered-in-error" -> Ok(TransportstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn transportstatus_decoder() -> Decoder(Transportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(TransportstatusInprogress)
    "completed" -> decode.success(TransportstatusCompleted)
    "abandoned" -> decode.success(TransportstatusAbandoned)
    "cancelled" -> decode.success(TransportstatusCancelled)
    "planned" -> decode.success(TransportstatusPlanned)
    "entered-in-error" -> decode.success(TransportstatusEnteredinerror)
    _ -> decode.failure(TransportstatusInprogress, "Transportstatus")
  }
}

pub type Triggertype {
  TriggertypeNamedevent
  TriggertypePeriodic
  TriggertypeDatachanged
  TriggertypeDataadded
  TriggertypeDatamodified
  TriggertypeDataremoved
  TriggertypeDataaccessed
  TriggertypeDataaccessended
}

pub fn triggertype_to_json(triggertype: Triggertype) -> Json {
  json.string(triggertype_to_string(triggertype))
}

pub fn triggertype_to_string(triggertype: Triggertype) -> String {
  case triggertype {
    TriggertypeNamedevent -> "named-event"
    TriggertypePeriodic -> "periodic"
    TriggertypeDatachanged -> "data-changed"
    TriggertypeDataadded -> "data-added"
    TriggertypeDatamodified -> "data-modified"
    TriggertypeDataremoved -> "data-removed"
    TriggertypeDataaccessed -> "data-accessed"
    TriggertypeDataaccessended -> "data-access-ended"
  }
}

pub fn triggertype_from_string(s: String) -> Result(Triggertype, Nil) {
  case s {
    "named-event" -> Ok(TriggertypeNamedevent)
    "periodic" -> Ok(TriggertypePeriodic)
    "data-changed" -> Ok(TriggertypeDatachanged)
    "data-added" -> Ok(TriggertypeDataadded)
    "data-modified" -> Ok(TriggertypeDatamodified)
    "data-removed" -> Ok(TriggertypeDataremoved)
    "data-accessed" -> Ok(TriggertypeDataaccessed)
    "data-access-ended" -> Ok(TriggertypeDataaccessended)
    _ -> Error(Nil)
  }
}

pub fn triggertype_decoder() -> Decoder(Triggertype) {
  use variant <- decode.then(decode.string)
  case variant {
    "named-event" -> decode.success(TriggertypeNamedevent)
    "periodic" -> decode.success(TriggertypePeriodic)
    "data-changed" -> decode.success(TriggertypeDatachanged)
    "data-added" -> decode.success(TriggertypeDataadded)
    "data-modified" -> decode.success(TriggertypeDatamodified)
    "data-removed" -> decode.success(TriggertypeDataremoved)
    "data-accessed" -> decode.success(TriggertypeDataaccessed)
    "data-access-ended" -> decode.success(TriggertypeDataaccessended)
    _ -> decode.failure(TriggertypeNamedevent, "Triggertype")
  }
}

pub type Typederivationrule {
  TypederivationruleSpecialization
  TypederivationruleConstraint
}

pub fn typederivationrule_to_json(
  typederivationrule: Typederivationrule,
) -> Json {
  json.string(typederivationrule_to_string(typederivationrule))
}

pub fn typederivationrule_to_string(
  typederivationrule: Typederivationrule,
) -> String {
  case typederivationrule {
    TypederivationruleSpecialization -> "specialization"
    TypederivationruleConstraint -> "constraint"
  }
}

pub fn typederivationrule_from_string(
  s: String,
) -> Result(Typederivationrule, Nil) {
  case s {
    "specialization" -> Ok(TypederivationruleSpecialization)
    "constraint" -> Ok(TypederivationruleConstraint)
    _ -> Error(Nil)
  }
}

pub fn typederivationrule_decoder() -> Decoder(Typederivationrule) {
  use variant <- decode.then(decode.string)
  case variant {
    "specialization" -> decode.success(TypederivationruleSpecialization)
    "constraint" -> decode.success(TypederivationruleConstraint)
    _ -> decode.failure(TypederivationruleSpecialization, "Typederivationrule")
  }
}

pub type Typerestfulinteraction {
  TyperestfulinteractionRead
  TyperestfulinteractionVread
  TyperestfulinteractionUpdate
  TyperestfulinteractionPatch
  TyperestfulinteractionDelete
  TyperestfulinteractionHistoryinstance
  TyperestfulinteractionHistorytype
  TyperestfulinteractionCreate
  TyperestfulinteractionSearchtype
}

pub fn typerestfulinteraction_to_json(
  typerestfulinteraction: Typerestfulinteraction,
) -> Json {
  json.string(typerestfulinteraction_to_string(typerestfulinteraction))
}

pub fn typerestfulinteraction_to_string(
  typerestfulinteraction: Typerestfulinteraction,
) -> String {
  case typerestfulinteraction {
    TyperestfulinteractionRead -> "read"
    TyperestfulinteractionVread -> "vread"
    TyperestfulinteractionUpdate -> "update"
    TyperestfulinteractionPatch -> "patch"
    TyperestfulinteractionDelete -> "delete"
    TyperestfulinteractionHistoryinstance -> "history-instance"
    TyperestfulinteractionHistorytype -> "history-type"
    TyperestfulinteractionCreate -> "create"
    TyperestfulinteractionSearchtype -> "search-type"
  }
}

pub fn typerestfulinteraction_from_string(
  s: String,
) -> Result(Typerestfulinteraction, Nil) {
  case s {
    "read" -> Ok(TyperestfulinteractionRead)
    "vread" -> Ok(TyperestfulinteractionVread)
    "update" -> Ok(TyperestfulinteractionUpdate)
    "patch" -> Ok(TyperestfulinteractionPatch)
    "delete" -> Ok(TyperestfulinteractionDelete)
    "history-instance" -> Ok(TyperestfulinteractionHistoryinstance)
    "history-type" -> Ok(TyperestfulinteractionHistorytype)
    "create" -> Ok(TyperestfulinteractionCreate)
    "search-type" -> Ok(TyperestfulinteractionSearchtype)
    _ -> Error(Nil)
  }
}

pub fn typerestfulinteraction_decoder() -> Decoder(Typerestfulinteraction) {
  use variant <- decode.then(decode.string)
  case variant {
    "read" -> decode.success(TyperestfulinteractionRead)
    "vread" -> decode.success(TyperestfulinteractionVread)
    "update" -> decode.success(TyperestfulinteractionUpdate)
    "patch" -> decode.success(TyperestfulinteractionPatch)
    "delete" -> decode.success(TyperestfulinteractionDelete)
    "history-instance" -> decode.success(TyperestfulinteractionHistoryinstance)
    "history-type" -> decode.success(TyperestfulinteractionHistorytype)
    "create" -> decode.success(TyperestfulinteractionCreate)
    "search-type" -> decode.success(TyperestfulinteractionSearchtype)
    _ -> decode.failure(TyperestfulinteractionRead, "Typerestfulinteraction")
  }
}

pub type Udientrytype {
  UdientrytypeBarcode
  UdientrytypeRfid
  UdientrytypeManual
  UdientrytypeCard
  UdientrytypeSelfreported
  UdientrytypeElectronictransmission
  UdientrytypeUnknown
}

pub fn udientrytype_to_json(udientrytype: Udientrytype) -> Json {
  json.string(udientrytype_to_string(udientrytype))
}

pub fn udientrytype_to_string(udientrytype: Udientrytype) -> String {
  case udientrytype {
    UdientrytypeBarcode -> "barcode"
    UdientrytypeRfid -> "rfid"
    UdientrytypeManual -> "manual"
    UdientrytypeCard -> "card"
    UdientrytypeSelfreported -> "self-reported"
    UdientrytypeElectronictransmission -> "electronic-transmission"
    UdientrytypeUnknown -> "unknown"
  }
}

pub fn udientrytype_from_string(s: String) -> Result(Udientrytype, Nil) {
  case s {
    "barcode" -> Ok(UdientrytypeBarcode)
    "rfid" -> Ok(UdientrytypeRfid)
    "manual" -> Ok(UdientrytypeManual)
    "card" -> Ok(UdientrytypeCard)
    "self-reported" -> Ok(UdientrytypeSelfreported)
    "electronic-transmission" -> Ok(UdientrytypeElectronictransmission)
    "unknown" -> Ok(UdientrytypeUnknown)
    _ -> Error(Nil)
  }
}

pub fn udientrytype_decoder() -> Decoder(Udientrytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "barcode" -> decode.success(UdientrytypeBarcode)
    "rfid" -> decode.success(UdientrytypeRfid)
    "manual" -> decode.success(UdientrytypeManual)
    "card" -> decode.success(UdientrytypeCard)
    "self-reported" -> decode.success(UdientrytypeSelfreported)
    "electronic-transmission" ->
      decode.success(UdientrytypeElectronictransmission)
    "unknown" -> decode.success(UdientrytypeUnknown)
    _ -> decode.failure(UdientrytypeBarcode, "Udientrytype")
  }
}

pub type Unitsoftime {
  UnitsoftimeS
  UnitsoftimeMin
  UnitsoftimeH
  UnitsoftimeD
  UnitsoftimeWk
  UnitsoftimeMo
  UnitsoftimeA
}

pub fn unitsoftime_to_json(unitsoftime: Unitsoftime) -> Json {
  json.string(unitsoftime_to_string(unitsoftime))
}

pub fn unitsoftime_to_string(unitsoftime: Unitsoftime) -> String {
  case unitsoftime {
    UnitsoftimeS -> "s"
    UnitsoftimeMin -> "min"
    UnitsoftimeH -> "h"
    UnitsoftimeD -> "d"
    UnitsoftimeWk -> "wk"
    UnitsoftimeMo -> "mo"
    UnitsoftimeA -> "a"
  }
}

pub fn unitsoftime_from_string(s: String) -> Result(Unitsoftime, Nil) {
  case s {
    "s" -> Ok(UnitsoftimeS)
    "min" -> Ok(UnitsoftimeMin)
    "h" -> Ok(UnitsoftimeH)
    "d" -> Ok(UnitsoftimeD)
    "wk" -> Ok(UnitsoftimeWk)
    "mo" -> Ok(UnitsoftimeMo)
    "a" -> Ok(UnitsoftimeA)
    _ -> Error(Nil)
  }
}

pub fn unitsoftime_decoder() -> Decoder(Unitsoftime) {
  use variant <- decode.then(decode.string)
  case variant {
    "s" -> decode.success(UnitsoftimeS)
    "min" -> decode.success(UnitsoftimeMin)
    "h" -> decode.success(UnitsoftimeH)
    "d" -> decode.success(UnitsoftimeD)
    "wk" -> decode.success(UnitsoftimeWk)
    "mo" -> decode.success(UnitsoftimeMo)
    "a" -> decode.success(UnitsoftimeA)
    _ -> decode.failure(UnitsoftimeS, "Unitsoftime")
  }
}

pub type Valuefiltercomparator {
  ValuefiltercomparatorEq
  ValuefiltercomparatorGt
  ValuefiltercomparatorLt
  ValuefiltercomparatorGe
  ValuefiltercomparatorLe
  ValuefiltercomparatorSa
  ValuefiltercomparatorEb
}

pub fn valuefiltercomparator_to_json(
  valuefiltercomparator: Valuefiltercomparator,
) -> Json {
  json.string(valuefiltercomparator_to_string(valuefiltercomparator))
}

pub fn valuefiltercomparator_to_string(
  valuefiltercomparator: Valuefiltercomparator,
) -> String {
  case valuefiltercomparator {
    ValuefiltercomparatorEq -> "eq"
    ValuefiltercomparatorGt -> "gt"
    ValuefiltercomparatorLt -> "lt"
    ValuefiltercomparatorGe -> "ge"
    ValuefiltercomparatorLe -> "le"
    ValuefiltercomparatorSa -> "sa"
    ValuefiltercomparatorEb -> "eb"
  }
}

pub fn valuefiltercomparator_from_string(
  s: String,
) -> Result(Valuefiltercomparator, Nil) {
  case s {
    "eq" -> Ok(ValuefiltercomparatorEq)
    "gt" -> Ok(ValuefiltercomparatorGt)
    "lt" -> Ok(ValuefiltercomparatorLt)
    "ge" -> Ok(ValuefiltercomparatorGe)
    "le" -> Ok(ValuefiltercomparatorLe)
    "sa" -> Ok(ValuefiltercomparatorSa)
    "eb" -> Ok(ValuefiltercomparatorEb)
    _ -> Error(Nil)
  }
}

pub fn valuefiltercomparator_decoder() -> Decoder(Valuefiltercomparator) {
  use variant <- decode.then(decode.string)
  case variant {
    "eq" -> decode.success(ValuefiltercomparatorEq)
    "gt" -> decode.success(ValuefiltercomparatorGt)
    "lt" -> decode.success(ValuefiltercomparatorLt)
    "ge" -> decode.success(ValuefiltercomparatorGe)
    "le" -> decode.success(ValuefiltercomparatorLe)
    "sa" -> decode.success(ValuefiltercomparatorSa)
    "eb" -> decode.success(ValuefiltercomparatorEb)
    _ -> decode.failure(ValuefiltercomparatorEq, "Valuefiltercomparator")
  }
}

pub type Variablehandling {
  VariablehandlingContinuous
  VariablehandlingDichotomous
  VariablehandlingOrdinal
  VariablehandlingPolychotomous
}

pub fn variablehandling_to_json(variablehandling: Variablehandling) -> Json {
  json.string(variablehandling_to_string(variablehandling))
}

pub fn variablehandling_to_string(variablehandling: Variablehandling) -> String {
  case variablehandling {
    VariablehandlingContinuous -> "continuous"
    VariablehandlingDichotomous -> "dichotomous"
    VariablehandlingOrdinal -> "ordinal"
    VariablehandlingPolychotomous -> "polychotomous"
  }
}

pub fn variablehandling_from_string(s: String) -> Result(Variablehandling, Nil) {
  case s {
    "continuous" -> Ok(VariablehandlingContinuous)
    "dichotomous" -> Ok(VariablehandlingDichotomous)
    "ordinal" -> Ok(VariablehandlingOrdinal)
    "polychotomous" -> Ok(VariablehandlingPolychotomous)
    _ -> Error(Nil)
  }
}

pub fn variablehandling_decoder() -> Decoder(Variablehandling) {
  use variant <- decode.then(decode.string)
  case variant {
    "continuous" -> decode.success(VariablehandlingContinuous)
    "dichotomous" -> decode.success(VariablehandlingDichotomous)
    "ordinal" -> decode.success(VariablehandlingOrdinal)
    "polychotomous" -> decode.success(VariablehandlingPolychotomous)
    _ -> decode.failure(VariablehandlingContinuous, "Variablehandling")
  }
}

pub type Verificationresultstatus {
  VerificationresultstatusAttested
  VerificationresultstatusValidated
  VerificationresultstatusInprocess
  VerificationresultstatusReqrevalid
  VerificationresultstatusValfail
  VerificationresultstatusRevalfail
  VerificationresultstatusEnteredinerror
}

pub fn verificationresultstatus_to_json(
  verificationresultstatus: Verificationresultstatus,
) -> Json {
  json.string(verificationresultstatus_to_string(verificationresultstatus))
}

pub fn verificationresultstatus_to_string(
  verificationresultstatus: Verificationresultstatus,
) -> String {
  case verificationresultstatus {
    VerificationresultstatusAttested -> "attested"
    VerificationresultstatusValidated -> "validated"
    VerificationresultstatusInprocess -> "in-process"
    VerificationresultstatusReqrevalid -> "req-revalid"
    VerificationresultstatusValfail -> "val-fail"
    VerificationresultstatusRevalfail -> "reval-fail"
    VerificationresultstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn verificationresultstatus_from_string(
  s: String,
) -> Result(Verificationresultstatus, Nil) {
  case s {
    "attested" -> Ok(VerificationresultstatusAttested)
    "validated" -> Ok(VerificationresultstatusValidated)
    "in-process" -> Ok(VerificationresultstatusInprocess)
    "req-revalid" -> Ok(VerificationresultstatusReqrevalid)
    "val-fail" -> Ok(VerificationresultstatusValfail)
    "reval-fail" -> Ok(VerificationresultstatusRevalfail)
    "entered-in-error" -> Ok(VerificationresultstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn verificationresultstatus_decoder() -> Decoder(Verificationresultstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "attested" -> decode.success(VerificationresultstatusAttested)
    "validated" -> decode.success(VerificationresultstatusValidated)
    "in-process" -> decode.success(VerificationresultstatusInprocess)
    "req-revalid" -> decode.success(VerificationresultstatusReqrevalid)
    "val-fail" -> decode.success(VerificationresultstatusValfail)
    "reval-fail" -> decode.success(VerificationresultstatusRevalfail)
    "entered-in-error" -> decode.success(VerificationresultstatusEnteredinerror)
    _ ->
      decode.failure(
        VerificationresultstatusAttested,
        "Verificationresultstatus",
      )
  }
}

pub type Versionindependentallresourcetypes {
  VersionindependentallresourcetypesAccount
  VersionindependentallresourcetypesActivitydefinition
  VersionindependentallresourcetypesActordefinition
  VersionindependentallresourcetypesAdministrableproductdefinition
  VersionindependentallresourcetypesAdverseevent
  VersionindependentallresourcetypesAllergyintolerance
  VersionindependentallresourcetypesAppointment
  VersionindependentallresourcetypesAppointmentresponse
  VersionindependentallresourcetypesArtifactassessment
  VersionindependentallresourcetypesAuditevent
  VersionindependentallresourcetypesBasic
  VersionindependentallresourcetypesBinary
  VersionindependentallresourcetypesBiologicallyderivedproduct
  VersionindependentallresourcetypesBiologicallyderivedproductdispense
  VersionindependentallresourcetypesBodystructure
  VersionindependentallresourcetypesBundle
  VersionindependentallresourcetypesCanonicalresource
  VersionindependentallresourcetypesCapabilitystatement
  VersionindependentallresourcetypesCareplan
  VersionindependentallresourcetypesCareteam
  VersionindependentallresourcetypesChargeitem
  VersionindependentallresourcetypesChargeitemdefinition
  VersionindependentallresourcetypesCitation
  VersionindependentallresourcetypesClaim
  VersionindependentallresourcetypesClaimresponse
  VersionindependentallresourcetypesClinicalimpression
  VersionindependentallresourcetypesClinicalusedefinition
  VersionindependentallresourcetypesCodesystem
  VersionindependentallresourcetypesCommunication
  VersionindependentallresourcetypesCommunicationrequest
  VersionindependentallresourcetypesCompartmentdefinition
  VersionindependentallresourcetypesComposition
  VersionindependentallresourcetypesConceptmap
  VersionindependentallresourcetypesCondition
  VersionindependentallresourcetypesConditiondefinition
  VersionindependentallresourcetypesConsent
  VersionindependentallresourcetypesContract
  VersionindependentallresourcetypesCoverage
  VersionindependentallresourcetypesCoverageeligibilityrequest
  VersionindependentallresourcetypesCoverageeligibilityresponse
  VersionindependentallresourcetypesDetectedissue
  VersionindependentallresourcetypesDevice
  VersionindependentallresourcetypesDeviceassociation
  VersionindependentallresourcetypesDevicedefinition
  VersionindependentallresourcetypesDevicedispense
  VersionindependentallresourcetypesDevicemetric
  VersionindependentallresourcetypesDevicerequest
  VersionindependentallresourcetypesDeviceusage
  VersionindependentallresourcetypesDiagnosticreport
  VersionindependentallresourcetypesDocumentreference
  VersionindependentallresourcetypesDomainresource
  VersionindependentallresourcetypesEncounter
  VersionindependentallresourcetypesEncounterhistory
  VersionindependentallresourcetypesEndpoint
  VersionindependentallresourcetypesEnrollmentrequest
  VersionindependentallresourcetypesEnrollmentresponse
  VersionindependentallresourcetypesEpisodeofcare
  VersionindependentallresourcetypesEventdefinition
  VersionindependentallresourcetypesEvidence
  VersionindependentallresourcetypesEvidencereport
  VersionindependentallresourcetypesEvidencevariable
  VersionindependentallresourcetypesExamplescenario
  VersionindependentallresourcetypesExplanationofbenefit
  VersionindependentallresourcetypesFamilymemberhistory
  VersionindependentallresourcetypesFlag
  VersionindependentallresourcetypesFormularyitem
  VersionindependentallresourcetypesGenomicstudy
  VersionindependentallresourcetypesGoal
  VersionindependentallresourcetypesGraphdefinition
  VersionindependentallresourcetypesGroup
  VersionindependentallresourcetypesGuidanceresponse
  VersionindependentallresourcetypesHealthcareservice
  VersionindependentallresourcetypesImagingselection
  VersionindependentallresourcetypesImagingstudy
  VersionindependentallresourcetypesImmunization
  VersionindependentallresourcetypesImmunizationevaluation
  VersionindependentallresourcetypesImmunizationrecommendation
  VersionindependentallresourcetypesImplementationguide
  VersionindependentallresourcetypesIngredient
  VersionindependentallresourcetypesInsuranceplan
  VersionindependentallresourcetypesInventoryitem
  VersionindependentallresourcetypesInventoryreport
  VersionindependentallresourcetypesInvoice
  VersionindependentallresourcetypesLibrary
  VersionindependentallresourcetypesLinkage
  VersionindependentallresourcetypesList
  VersionindependentallresourcetypesLocation
  VersionindependentallresourcetypesManufactureditemdefinition
  VersionindependentallresourcetypesMeasure
  VersionindependentallresourcetypesMeasurereport
  VersionindependentallresourcetypesMedication
  VersionindependentallresourcetypesMedicationadministration
  VersionindependentallresourcetypesMedicationdispense
  VersionindependentallresourcetypesMedicationknowledge
  VersionindependentallresourcetypesMedicationrequest
  VersionindependentallresourcetypesMedicationstatement
  VersionindependentallresourcetypesMedicinalproductdefinition
  VersionindependentallresourcetypesMessagedefinition
  VersionindependentallresourcetypesMessageheader
  VersionindependentallresourcetypesMetadataresource
  VersionindependentallresourcetypesMolecularsequence
  VersionindependentallresourcetypesNamingsystem
  VersionindependentallresourcetypesNutritionintake
  VersionindependentallresourcetypesNutritionorder
  VersionindependentallresourcetypesNutritionproduct
  VersionindependentallresourcetypesObservation
  VersionindependentallresourcetypesObservationdefinition
  VersionindependentallresourcetypesOperationdefinition
  VersionindependentallresourcetypesOperationoutcome
  VersionindependentallresourcetypesOrganization
  VersionindependentallresourcetypesOrganizationaffiliation
  VersionindependentallresourcetypesPackagedproductdefinition
  VersionindependentallresourcetypesParameters
  VersionindependentallresourcetypesPatient
  VersionindependentallresourcetypesPaymentnotice
  VersionindependentallresourcetypesPaymentreconciliation
  VersionindependentallresourcetypesPermission
  VersionindependentallresourcetypesPerson
  VersionindependentallresourcetypesPlandefinition
  VersionindependentallresourcetypesPractitioner
  VersionindependentallresourcetypesPractitionerrole
  VersionindependentallresourcetypesProcedure
  VersionindependentallresourcetypesProvenance
  VersionindependentallresourcetypesQuestionnaire
  VersionindependentallresourcetypesQuestionnaireresponse
  VersionindependentallresourcetypesRegulatedauthorization
  VersionindependentallresourcetypesRelatedperson
  VersionindependentallresourcetypesRequestorchestration
  VersionindependentallresourcetypesRequirements
  VersionindependentallresourcetypesResearchstudy
  VersionindependentallresourcetypesResearchsubject
  VersionindependentallresourcetypesResource
  VersionindependentallresourcetypesRiskassessment
  VersionindependentallresourcetypesSchedule
  VersionindependentallresourcetypesSearchparameter
  VersionindependentallresourcetypesServicerequest
  VersionindependentallresourcetypesSlot
  VersionindependentallresourcetypesSpecimen
  VersionindependentallresourcetypesSpecimendefinition
  VersionindependentallresourcetypesStructuredefinition
  VersionindependentallresourcetypesStructuremap
  VersionindependentallresourcetypesSubscription
  VersionindependentallresourcetypesSubscriptionstatus
  VersionindependentallresourcetypesSubscriptiontopic
  VersionindependentallresourcetypesSubstance
  VersionindependentallresourcetypesSubstancedefinition
  VersionindependentallresourcetypesSubstancenucleicacid
  VersionindependentallresourcetypesSubstancepolymer
  VersionindependentallresourcetypesSubstanceprotein
  VersionindependentallresourcetypesSubstancereferenceinformation
  VersionindependentallresourcetypesSubstancesourcematerial
  VersionindependentallresourcetypesSupplydelivery
  VersionindependentallresourcetypesSupplyrequest
  VersionindependentallresourcetypesTask
  VersionindependentallresourcetypesTerminologycapabilities
  VersionindependentallresourcetypesTestplan
  VersionindependentallresourcetypesTestreport
  VersionindependentallresourcetypesTestscript
  VersionindependentallresourcetypesTransport
  VersionindependentallresourcetypesValueset
  VersionindependentallresourcetypesVerificationresult
  VersionindependentallresourcetypesVisionprescription
  VersionindependentallresourcetypesBodysite
  VersionindependentallresourcetypesCatalogentry
  VersionindependentallresourcetypesConformance
  VersionindependentallresourcetypesDataelement
  VersionindependentallresourcetypesDevicecomponent
  VersionindependentallresourcetypesDeviceuserequest
  VersionindependentallresourcetypesDeviceusestatement
  VersionindependentallresourcetypesDiagnosticorder
  VersionindependentallresourcetypesDocumentmanifest
  VersionindependentallresourcetypesEffectevidencesynthesis
  VersionindependentallresourcetypesEligibilityrequest
  VersionindependentallresourcetypesEligibilityresponse
  VersionindependentallresourcetypesExpansionprofile
  VersionindependentallresourcetypesImagingmanifest
  VersionindependentallresourcetypesImagingobjectselection
  VersionindependentallresourcetypesMedia
  VersionindependentallresourcetypesMedicationorder
  VersionindependentallresourcetypesMedicationusage
  VersionindependentallresourcetypesMedicinalproduct
  VersionindependentallresourcetypesMedicinalproductauthorization
  VersionindependentallresourcetypesMedicinalproductcontraindication
  VersionindependentallresourcetypesMedicinalproductindication
  VersionindependentallresourcetypesMedicinalproductingredient
  VersionindependentallresourcetypesMedicinalproductinteraction
  VersionindependentallresourcetypesMedicinalproductmanufactured
  VersionindependentallresourcetypesMedicinalproductpackaged
  VersionindependentallresourcetypesMedicinalproductpharmaceutical
  VersionindependentallresourcetypesMedicinalproductundesirableeffect
  VersionindependentallresourcetypesOrder
  VersionindependentallresourcetypesOrderresponse
  VersionindependentallresourcetypesProcedurerequest
  VersionindependentallresourcetypesProcessrequest
  VersionindependentallresourcetypesProcessresponse
  VersionindependentallresourcetypesReferralrequest
  VersionindependentallresourcetypesRequestgroup
  VersionindependentallresourcetypesResearchdefinition
  VersionindependentallresourcetypesResearchelementdefinition
  VersionindependentallresourcetypesRiskevidencesynthesis
  VersionindependentallresourcetypesSequence
  VersionindependentallresourcetypesServicedefinition
  VersionindependentallresourcetypesSubstancespecification
}

pub fn versionindependentallresourcetypes_to_json(
  versionindependentallresourcetypes: Versionindependentallresourcetypes,
) -> Json {
  json.string(versionindependentallresourcetypes_to_string(
    versionindependentallresourcetypes,
  ))
}

pub fn versionindependentallresourcetypes_to_string(
  versionindependentallresourcetypes: Versionindependentallresourcetypes,
) -> String {
  case versionindependentallresourcetypes {
    VersionindependentallresourcetypesAccount -> "Account"
    VersionindependentallresourcetypesActivitydefinition -> "ActivityDefinition"
    VersionindependentallresourcetypesActordefinition -> "ActorDefinition"
    VersionindependentallresourcetypesAdministrableproductdefinition ->
      "AdministrableProductDefinition"
    VersionindependentallresourcetypesAdverseevent -> "AdverseEvent"
    VersionindependentallresourcetypesAllergyintolerance -> "AllergyIntolerance"
    VersionindependentallresourcetypesAppointment -> "Appointment"
    VersionindependentallresourcetypesAppointmentresponse ->
      "AppointmentResponse"
    VersionindependentallresourcetypesArtifactassessment -> "ArtifactAssessment"
    VersionindependentallresourcetypesAuditevent -> "AuditEvent"
    VersionindependentallresourcetypesBasic -> "Basic"
    VersionindependentallresourcetypesBinary -> "Binary"
    VersionindependentallresourcetypesBiologicallyderivedproduct ->
      "BiologicallyDerivedProduct"
    VersionindependentallresourcetypesBiologicallyderivedproductdispense ->
      "BiologicallyDerivedProductDispense"
    VersionindependentallresourcetypesBodystructure -> "BodyStructure"
    VersionindependentallresourcetypesBundle -> "Bundle"
    VersionindependentallresourcetypesCanonicalresource -> "CanonicalResource"
    VersionindependentallresourcetypesCapabilitystatement ->
      "CapabilityStatement"
    VersionindependentallresourcetypesCareplan -> "CarePlan"
    VersionindependentallresourcetypesCareteam -> "CareTeam"
    VersionindependentallresourcetypesChargeitem -> "ChargeItem"
    VersionindependentallresourcetypesChargeitemdefinition ->
      "ChargeItemDefinition"
    VersionindependentallresourcetypesCitation -> "Citation"
    VersionindependentallresourcetypesClaim -> "Claim"
    VersionindependentallresourcetypesClaimresponse -> "ClaimResponse"
    VersionindependentallresourcetypesClinicalimpression -> "ClinicalImpression"
    VersionindependentallresourcetypesClinicalusedefinition ->
      "ClinicalUseDefinition"
    VersionindependentallresourcetypesCodesystem -> "CodeSystem"
    VersionindependentallresourcetypesCommunication -> "Communication"
    VersionindependentallresourcetypesCommunicationrequest ->
      "CommunicationRequest"
    VersionindependentallresourcetypesCompartmentdefinition ->
      "CompartmentDefinition"
    VersionindependentallresourcetypesComposition -> "Composition"
    VersionindependentallresourcetypesConceptmap -> "ConceptMap"
    VersionindependentallresourcetypesCondition -> "Condition"
    VersionindependentallresourcetypesConditiondefinition ->
      "ConditionDefinition"
    VersionindependentallresourcetypesConsent -> "Consent"
    VersionindependentallresourcetypesContract -> "Contract"
    VersionindependentallresourcetypesCoverage -> "Coverage"
    VersionindependentallresourcetypesCoverageeligibilityrequest ->
      "CoverageEligibilityRequest"
    VersionindependentallresourcetypesCoverageeligibilityresponse ->
      "CoverageEligibilityResponse"
    VersionindependentallresourcetypesDetectedissue -> "DetectedIssue"
    VersionindependentallresourcetypesDevice -> "Device"
    VersionindependentallresourcetypesDeviceassociation -> "DeviceAssociation"
    VersionindependentallresourcetypesDevicedefinition -> "DeviceDefinition"
    VersionindependentallresourcetypesDevicedispense -> "DeviceDispense"
    VersionindependentallresourcetypesDevicemetric -> "DeviceMetric"
    VersionindependentallresourcetypesDevicerequest -> "DeviceRequest"
    VersionindependentallresourcetypesDeviceusage -> "DeviceUsage"
    VersionindependentallresourcetypesDiagnosticreport -> "DiagnosticReport"
    VersionindependentallresourcetypesDocumentreference -> "DocumentReference"
    VersionindependentallresourcetypesDomainresource -> "DomainResource"
    VersionindependentallresourcetypesEncounter -> "Encounter"
    VersionindependentallresourcetypesEncounterhistory -> "EncounterHistory"
    VersionindependentallresourcetypesEndpoint -> "Endpoint"
    VersionindependentallresourcetypesEnrollmentrequest -> "EnrollmentRequest"
    VersionindependentallresourcetypesEnrollmentresponse -> "EnrollmentResponse"
    VersionindependentallresourcetypesEpisodeofcare -> "EpisodeOfCare"
    VersionindependentallresourcetypesEventdefinition -> "EventDefinition"
    VersionindependentallresourcetypesEvidence -> "Evidence"
    VersionindependentallresourcetypesEvidencereport -> "EvidenceReport"
    VersionindependentallresourcetypesEvidencevariable -> "EvidenceVariable"
    VersionindependentallresourcetypesExamplescenario -> "ExampleScenario"
    VersionindependentallresourcetypesExplanationofbenefit ->
      "ExplanationOfBenefit"
    VersionindependentallresourcetypesFamilymemberhistory ->
      "FamilyMemberHistory"
    VersionindependentallresourcetypesFlag -> "Flag"
    VersionindependentallresourcetypesFormularyitem -> "FormularyItem"
    VersionindependentallresourcetypesGenomicstudy -> "GenomicStudy"
    VersionindependentallresourcetypesGoal -> "Goal"
    VersionindependentallresourcetypesGraphdefinition -> "GraphDefinition"
    VersionindependentallresourcetypesGroup -> "Group"
    VersionindependentallresourcetypesGuidanceresponse -> "GuidanceResponse"
    VersionindependentallresourcetypesHealthcareservice -> "HealthcareService"
    VersionindependentallresourcetypesImagingselection -> "ImagingSelection"
    VersionindependentallresourcetypesImagingstudy -> "ImagingStudy"
    VersionindependentallresourcetypesImmunization -> "Immunization"
    VersionindependentallresourcetypesImmunizationevaluation ->
      "ImmunizationEvaluation"
    VersionindependentallresourcetypesImmunizationrecommendation ->
      "ImmunizationRecommendation"
    VersionindependentallresourcetypesImplementationguide ->
      "ImplementationGuide"
    VersionindependentallresourcetypesIngredient -> "Ingredient"
    VersionindependentallresourcetypesInsuranceplan -> "InsurancePlan"
    VersionindependentallresourcetypesInventoryitem -> "InventoryItem"
    VersionindependentallresourcetypesInventoryreport -> "InventoryReport"
    VersionindependentallresourcetypesInvoice -> "Invoice"
    VersionindependentallresourcetypesLibrary -> "Library"
    VersionindependentallresourcetypesLinkage -> "Linkage"
    VersionindependentallresourcetypesList -> "List"
    VersionindependentallresourcetypesLocation -> "Location"
    VersionindependentallresourcetypesManufactureditemdefinition ->
      "ManufacturedItemDefinition"
    VersionindependentallresourcetypesMeasure -> "Measure"
    VersionindependentallresourcetypesMeasurereport -> "MeasureReport"
    VersionindependentallresourcetypesMedication -> "Medication"
    VersionindependentallresourcetypesMedicationadministration ->
      "MedicationAdministration"
    VersionindependentallresourcetypesMedicationdispense -> "MedicationDispense"
    VersionindependentallresourcetypesMedicationknowledge ->
      "MedicationKnowledge"
    VersionindependentallresourcetypesMedicationrequest -> "MedicationRequest"
    VersionindependentallresourcetypesMedicationstatement ->
      "MedicationStatement"
    VersionindependentallresourcetypesMedicinalproductdefinition ->
      "MedicinalProductDefinition"
    VersionindependentallresourcetypesMessagedefinition -> "MessageDefinition"
    VersionindependentallresourcetypesMessageheader -> "MessageHeader"
    VersionindependentallresourcetypesMetadataresource -> "MetadataResource"
    VersionindependentallresourcetypesMolecularsequence -> "MolecularSequence"
    VersionindependentallresourcetypesNamingsystem -> "NamingSystem"
    VersionindependentallresourcetypesNutritionintake -> "NutritionIntake"
    VersionindependentallresourcetypesNutritionorder -> "NutritionOrder"
    VersionindependentallresourcetypesNutritionproduct -> "NutritionProduct"
    VersionindependentallresourcetypesObservation -> "Observation"
    VersionindependentallresourcetypesObservationdefinition ->
      "ObservationDefinition"
    VersionindependentallresourcetypesOperationdefinition ->
      "OperationDefinition"
    VersionindependentallresourcetypesOperationoutcome -> "OperationOutcome"
    VersionindependentallresourcetypesOrganization -> "Organization"
    VersionindependentallresourcetypesOrganizationaffiliation ->
      "OrganizationAffiliation"
    VersionindependentallresourcetypesPackagedproductdefinition ->
      "PackagedProductDefinition"
    VersionindependentallresourcetypesParameters -> "Parameters"
    VersionindependentallresourcetypesPatient -> "Patient"
    VersionindependentallresourcetypesPaymentnotice -> "PaymentNotice"
    VersionindependentallresourcetypesPaymentreconciliation ->
      "PaymentReconciliation"
    VersionindependentallresourcetypesPermission -> "Permission"
    VersionindependentallresourcetypesPerson -> "Person"
    VersionindependentallresourcetypesPlandefinition -> "PlanDefinition"
    VersionindependentallresourcetypesPractitioner -> "Practitioner"
    VersionindependentallresourcetypesPractitionerrole -> "PractitionerRole"
    VersionindependentallresourcetypesProcedure -> "Procedure"
    VersionindependentallresourcetypesProvenance -> "Provenance"
    VersionindependentallresourcetypesQuestionnaire -> "Questionnaire"
    VersionindependentallresourcetypesQuestionnaireresponse ->
      "QuestionnaireResponse"
    VersionindependentallresourcetypesRegulatedauthorization ->
      "RegulatedAuthorization"
    VersionindependentallresourcetypesRelatedperson -> "RelatedPerson"
    VersionindependentallresourcetypesRequestorchestration ->
      "RequestOrchestration"
    VersionindependentallresourcetypesRequirements -> "Requirements"
    VersionindependentallresourcetypesResearchstudy -> "ResearchStudy"
    VersionindependentallresourcetypesResearchsubject -> "ResearchSubject"
    VersionindependentallresourcetypesResource -> "Resource"
    VersionindependentallresourcetypesRiskassessment -> "RiskAssessment"
    VersionindependentallresourcetypesSchedule -> "Schedule"
    VersionindependentallresourcetypesSearchparameter -> "SearchParameter"
    VersionindependentallresourcetypesServicerequest -> "ServiceRequest"
    VersionindependentallresourcetypesSlot -> "Slot"
    VersionindependentallresourcetypesSpecimen -> "Specimen"
    VersionindependentallresourcetypesSpecimendefinition -> "SpecimenDefinition"
    VersionindependentallresourcetypesStructuredefinition ->
      "StructureDefinition"
    VersionindependentallresourcetypesStructuremap -> "StructureMap"
    VersionindependentallresourcetypesSubscription -> "Subscription"
    VersionindependentallresourcetypesSubscriptionstatus -> "SubscriptionStatus"
    VersionindependentallresourcetypesSubscriptiontopic -> "SubscriptionTopic"
    VersionindependentallresourcetypesSubstance -> "Substance"
    VersionindependentallresourcetypesSubstancedefinition ->
      "SubstanceDefinition"
    VersionindependentallresourcetypesSubstancenucleicacid ->
      "SubstanceNucleicAcid"
    VersionindependentallresourcetypesSubstancepolymer -> "SubstancePolymer"
    VersionindependentallresourcetypesSubstanceprotein -> "SubstanceProtein"
    VersionindependentallresourcetypesSubstancereferenceinformation ->
      "SubstanceReferenceInformation"
    VersionindependentallresourcetypesSubstancesourcematerial ->
      "SubstanceSourceMaterial"
    VersionindependentallresourcetypesSupplydelivery -> "SupplyDelivery"
    VersionindependentallresourcetypesSupplyrequest -> "SupplyRequest"
    VersionindependentallresourcetypesTask -> "Task"
    VersionindependentallresourcetypesTerminologycapabilities ->
      "TerminologyCapabilities"
    VersionindependentallresourcetypesTestplan -> "TestPlan"
    VersionindependentallresourcetypesTestreport -> "TestReport"
    VersionindependentallresourcetypesTestscript -> "TestScript"
    VersionindependentallresourcetypesTransport -> "Transport"
    VersionindependentallresourcetypesValueset -> "ValueSet"
    VersionindependentallresourcetypesVerificationresult -> "VerificationResult"
    VersionindependentallresourcetypesVisionprescription -> "VisionPrescription"
    VersionindependentallresourcetypesBodysite -> "BodySite"
    VersionindependentallresourcetypesCatalogentry -> "CatalogEntry"
    VersionindependentallresourcetypesConformance -> "Conformance"
    VersionindependentallresourcetypesDataelement -> "DataElement"
    VersionindependentallresourcetypesDevicecomponent -> "DeviceComponent"
    VersionindependentallresourcetypesDeviceuserequest -> "DeviceUseRequest"
    VersionindependentallresourcetypesDeviceusestatement -> "DeviceUseStatement"
    VersionindependentallresourcetypesDiagnosticorder -> "DiagnosticOrder"
    VersionindependentallresourcetypesDocumentmanifest -> "DocumentManifest"
    VersionindependentallresourcetypesEffectevidencesynthesis ->
      "EffectEvidenceSynthesis"
    VersionindependentallresourcetypesEligibilityrequest -> "EligibilityRequest"
    VersionindependentallresourcetypesEligibilityresponse ->
      "EligibilityResponse"
    VersionindependentallresourcetypesExpansionprofile -> "ExpansionProfile"
    VersionindependentallresourcetypesImagingmanifest -> "ImagingManifest"
    VersionindependentallresourcetypesImagingobjectselection ->
      "ImagingObjectSelection"
    VersionindependentallresourcetypesMedia -> "Media"
    VersionindependentallresourcetypesMedicationorder -> "MedicationOrder"
    VersionindependentallresourcetypesMedicationusage -> "MedicationUsage"
    VersionindependentallresourcetypesMedicinalproduct -> "MedicinalProduct"
    VersionindependentallresourcetypesMedicinalproductauthorization ->
      "MedicinalProductAuthorization"
    VersionindependentallresourcetypesMedicinalproductcontraindication ->
      "MedicinalProductContraindication"
    VersionindependentallresourcetypesMedicinalproductindication ->
      "MedicinalProductIndication"
    VersionindependentallresourcetypesMedicinalproductingredient ->
      "MedicinalProductIngredient"
    VersionindependentallresourcetypesMedicinalproductinteraction ->
      "MedicinalProductInteraction"
    VersionindependentallresourcetypesMedicinalproductmanufactured ->
      "MedicinalProductManufactured"
    VersionindependentallresourcetypesMedicinalproductpackaged ->
      "MedicinalProductPackaged"
    VersionindependentallresourcetypesMedicinalproductpharmaceutical ->
      "MedicinalProductPharmaceutical"
    VersionindependentallresourcetypesMedicinalproductundesirableeffect ->
      "MedicinalProductUndesirableEffect"
    VersionindependentallresourcetypesOrder -> "Order"
    VersionindependentallresourcetypesOrderresponse -> "OrderResponse"
    VersionindependentallresourcetypesProcedurerequest -> "ProcedureRequest"
    VersionindependentallresourcetypesProcessrequest -> "ProcessRequest"
    VersionindependentallresourcetypesProcessresponse -> "ProcessResponse"
    VersionindependentallresourcetypesReferralrequest -> "ReferralRequest"
    VersionindependentallresourcetypesRequestgroup -> "RequestGroup"
    VersionindependentallresourcetypesResearchdefinition -> "ResearchDefinition"
    VersionindependentallresourcetypesResearchelementdefinition ->
      "ResearchElementDefinition"
    VersionindependentallresourcetypesRiskevidencesynthesis ->
      "RiskEvidenceSynthesis"
    VersionindependentallresourcetypesSequence -> "Sequence"
    VersionindependentallresourcetypesServicedefinition -> "ServiceDefinition"
    VersionindependentallresourcetypesSubstancespecification ->
      "SubstanceSpecification"
  }
}

pub fn versionindependentallresourcetypes_from_string(
  s: String,
) -> Result(Versionindependentallresourcetypes, Nil) {
  case s {
    "Account" -> Ok(VersionindependentallresourcetypesAccount)
    "ActivityDefinition" ->
      Ok(VersionindependentallresourcetypesActivitydefinition)
    "ActorDefinition" -> Ok(VersionindependentallresourcetypesActordefinition)
    "AdministrableProductDefinition" ->
      Ok(VersionindependentallresourcetypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(VersionindependentallresourcetypesAdverseevent)
    "AllergyIntolerance" ->
      Ok(VersionindependentallresourcetypesAllergyintolerance)
    "Appointment" -> Ok(VersionindependentallresourcetypesAppointment)
    "AppointmentResponse" ->
      Ok(VersionindependentallresourcetypesAppointmentresponse)
    "ArtifactAssessment" ->
      Ok(VersionindependentallresourcetypesArtifactassessment)
    "AuditEvent" -> Ok(VersionindependentallresourcetypesAuditevent)
    "Basic" -> Ok(VersionindependentallresourcetypesBasic)
    "Binary" -> Ok(VersionindependentallresourcetypesBinary)
    "BiologicallyDerivedProduct" ->
      Ok(VersionindependentallresourcetypesBiologicallyderivedproduct)
    "BiologicallyDerivedProductDispense" ->
      Ok(VersionindependentallresourcetypesBiologicallyderivedproductdispense)
    "BodyStructure" -> Ok(VersionindependentallresourcetypesBodystructure)
    "Bundle" -> Ok(VersionindependentallresourcetypesBundle)
    "CanonicalResource" ->
      Ok(VersionindependentallresourcetypesCanonicalresource)
    "CapabilityStatement" ->
      Ok(VersionindependentallresourcetypesCapabilitystatement)
    "CarePlan" -> Ok(VersionindependentallresourcetypesCareplan)
    "CareTeam" -> Ok(VersionindependentallresourcetypesCareteam)
    "ChargeItem" -> Ok(VersionindependentallresourcetypesChargeitem)
    "ChargeItemDefinition" ->
      Ok(VersionindependentallresourcetypesChargeitemdefinition)
    "Citation" -> Ok(VersionindependentallresourcetypesCitation)
    "Claim" -> Ok(VersionindependentallresourcetypesClaim)
    "ClaimResponse" -> Ok(VersionindependentallresourcetypesClaimresponse)
    "ClinicalImpression" ->
      Ok(VersionindependentallresourcetypesClinicalimpression)
    "ClinicalUseDefinition" ->
      Ok(VersionindependentallresourcetypesClinicalusedefinition)
    "CodeSystem" -> Ok(VersionindependentallresourcetypesCodesystem)
    "Communication" -> Ok(VersionindependentallresourcetypesCommunication)
    "CommunicationRequest" ->
      Ok(VersionindependentallresourcetypesCommunicationrequest)
    "CompartmentDefinition" ->
      Ok(VersionindependentallresourcetypesCompartmentdefinition)
    "Composition" -> Ok(VersionindependentallresourcetypesComposition)
    "ConceptMap" -> Ok(VersionindependentallresourcetypesConceptmap)
    "Condition" -> Ok(VersionindependentallresourcetypesCondition)
    "ConditionDefinition" ->
      Ok(VersionindependentallresourcetypesConditiondefinition)
    "Consent" -> Ok(VersionindependentallresourcetypesConsent)
    "Contract" -> Ok(VersionindependentallresourcetypesContract)
    "Coverage" -> Ok(VersionindependentallresourcetypesCoverage)
    "CoverageEligibilityRequest" ->
      Ok(VersionindependentallresourcetypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      Ok(VersionindependentallresourcetypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(VersionindependentallresourcetypesDetectedissue)
    "Device" -> Ok(VersionindependentallresourcetypesDevice)
    "DeviceAssociation" ->
      Ok(VersionindependentallresourcetypesDeviceassociation)
    "DeviceDefinition" -> Ok(VersionindependentallresourcetypesDevicedefinition)
    "DeviceDispense" -> Ok(VersionindependentallresourcetypesDevicedispense)
    "DeviceMetric" -> Ok(VersionindependentallresourcetypesDevicemetric)
    "DeviceRequest" -> Ok(VersionindependentallresourcetypesDevicerequest)
    "DeviceUsage" -> Ok(VersionindependentallresourcetypesDeviceusage)
    "DiagnosticReport" -> Ok(VersionindependentallresourcetypesDiagnosticreport)
    "DocumentReference" ->
      Ok(VersionindependentallresourcetypesDocumentreference)
    "DomainResource" -> Ok(VersionindependentallresourcetypesDomainresource)
    "Encounter" -> Ok(VersionindependentallresourcetypesEncounter)
    "EncounterHistory" -> Ok(VersionindependentallresourcetypesEncounterhistory)
    "Endpoint" -> Ok(VersionindependentallresourcetypesEndpoint)
    "EnrollmentRequest" ->
      Ok(VersionindependentallresourcetypesEnrollmentrequest)
    "EnrollmentResponse" ->
      Ok(VersionindependentallresourcetypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(VersionindependentallresourcetypesEpisodeofcare)
    "EventDefinition" -> Ok(VersionindependentallresourcetypesEventdefinition)
    "Evidence" -> Ok(VersionindependentallresourcetypesEvidence)
    "EvidenceReport" -> Ok(VersionindependentallresourcetypesEvidencereport)
    "EvidenceVariable" -> Ok(VersionindependentallresourcetypesEvidencevariable)
    "ExampleScenario" -> Ok(VersionindependentallresourcetypesExamplescenario)
    "ExplanationOfBenefit" ->
      Ok(VersionindependentallresourcetypesExplanationofbenefit)
    "FamilyMemberHistory" ->
      Ok(VersionindependentallresourcetypesFamilymemberhistory)
    "Flag" -> Ok(VersionindependentallresourcetypesFlag)
    "FormularyItem" -> Ok(VersionindependentallresourcetypesFormularyitem)
    "GenomicStudy" -> Ok(VersionindependentallresourcetypesGenomicstudy)
    "Goal" -> Ok(VersionindependentallresourcetypesGoal)
    "GraphDefinition" -> Ok(VersionindependentallresourcetypesGraphdefinition)
    "Group" -> Ok(VersionindependentallresourcetypesGroup)
    "GuidanceResponse" -> Ok(VersionindependentallresourcetypesGuidanceresponse)
    "HealthcareService" ->
      Ok(VersionindependentallresourcetypesHealthcareservice)
    "ImagingSelection" -> Ok(VersionindependentallresourcetypesImagingselection)
    "ImagingStudy" -> Ok(VersionindependentallresourcetypesImagingstudy)
    "Immunization" -> Ok(VersionindependentallresourcetypesImmunization)
    "ImmunizationEvaluation" ->
      Ok(VersionindependentallresourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      Ok(VersionindependentallresourcetypesImmunizationrecommendation)
    "ImplementationGuide" ->
      Ok(VersionindependentallresourcetypesImplementationguide)
    "Ingredient" -> Ok(VersionindependentallresourcetypesIngredient)
    "InsurancePlan" -> Ok(VersionindependentallresourcetypesInsuranceplan)
    "InventoryItem" -> Ok(VersionindependentallresourcetypesInventoryitem)
    "InventoryReport" -> Ok(VersionindependentallresourcetypesInventoryreport)
    "Invoice" -> Ok(VersionindependentallresourcetypesInvoice)
    "Library" -> Ok(VersionindependentallresourcetypesLibrary)
    "Linkage" -> Ok(VersionindependentallresourcetypesLinkage)
    "List" -> Ok(VersionindependentallresourcetypesList)
    "Location" -> Ok(VersionindependentallresourcetypesLocation)
    "ManufacturedItemDefinition" ->
      Ok(VersionindependentallresourcetypesManufactureditemdefinition)
    "Measure" -> Ok(VersionindependentallresourcetypesMeasure)
    "MeasureReport" -> Ok(VersionindependentallresourcetypesMeasurereport)
    "Medication" -> Ok(VersionindependentallresourcetypesMedication)
    "MedicationAdministration" ->
      Ok(VersionindependentallresourcetypesMedicationadministration)
    "MedicationDispense" ->
      Ok(VersionindependentallresourcetypesMedicationdispense)
    "MedicationKnowledge" ->
      Ok(VersionindependentallresourcetypesMedicationknowledge)
    "MedicationRequest" ->
      Ok(VersionindependentallresourcetypesMedicationrequest)
    "MedicationStatement" ->
      Ok(VersionindependentallresourcetypesMedicationstatement)
    "MedicinalProductDefinition" ->
      Ok(VersionindependentallresourcetypesMedicinalproductdefinition)
    "MessageDefinition" ->
      Ok(VersionindependentallresourcetypesMessagedefinition)
    "MessageHeader" -> Ok(VersionindependentallresourcetypesMessageheader)
    "MetadataResource" -> Ok(VersionindependentallresourcetypesMetadataresource)
    "MolecularSequence" ->
      Ok(VersionindependentallresourcetypesMolecularsequence)
    "NamingSystem" -> Ok(VersionindependentallresourcetypesNamingsystem)
    "NutritionIntake" -> Ok(VersionindependentallresourcetypesNutritionintake)
    "NutritionOrder" -> Ok(VersionindependentallresourcetypesNutritionorder)
    "NutritionProduct" -> Ok(VersionindependentallresourcetypesNutritionproduct)
    "Observation" -> Ok(VersionindependentallresourcetypesObservation)
    "ObservationDefinition" ->
      Ok(VersionindependentallresourcetypesObservationdefinition)
    "OperationDefinition" ->
      Ok(VersionindependentallresourcetypesOperationdefinition)
    "OperationOutcome" -> Ok(VersionindependentallresourcetypesOperationoutcome)
    "Organization" -> Ok(VersionindependentallresourcetypesOrganization)
    "OrganizationAffiliation" ->
      Ok(VersionindependentallresourcetypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      Ok(VersionindependentallresourcetypesPackagedproductdefinition)
    "Parameters" -> Ok(VersionindependentallresourcetypesParameters)
    "Patient" -> Ok(VersionindependentallresourcetypesPatient)
    "PaymentNotice" -> Ok(VersionindependentallresourcetypesPaymentnotice)
    "PaymentReconciliation" ->
      Ok(VersionindependentallresourcetypesPaymentreconciliation)
    "Permission" -> Ok(VersionindependentallresourcetypesPermission)
    "Person" -> Ok(VersionindependentallresourcetypesPerson)
    "PlanDefinition" -> Ok(VersionindependentallresourcetypesPlandefinition)
    "Practitioner" -> Ok(VersionindependentallresourcetypesPractitioner)
    "PractitionerRole" -> Ok(VersionindependentallresourcetypesPractitionerrole)
    "Procedure" -> Ok(VersionindependentallresourcetypesProcedure)
    "Provenance" -> Ok(VersionindependentallresourcetypesProvenance)
    "Questionnaire" -> Ok(VersionindependentallresourcetypesQuestionnaire)
    "QuestionnaireResponse" ->
      Ok(VersionindependentallresourcetypesQuestionnaireresponse)
    "RegulatedAuthorization" ->
      Ok(VersionindependentallresourcetypesRegulatedauthorization)
    "RelatedPerson" -> Ok(VersionindependentallresourcetypesRelatedperson)
    "RequestOrchestration" ->
      Ok(VersionindependentallresourcetypesRequestorchestration)
    "Requirements" -> Ok(VersionindependentallresourcetypesRequirements)
    "ResearchStudy" -> Ok(VersionindependentallresourcetypesResearchstudy)
    "ResearchSubject" -> Ok(VersionindependentallresourcetypesResearchsubject)
    "Resource" -> Ok(VersionindependentallresourcetypesResource)
    "RiskAssessment" -> Ok(VersionindependentallresourcetypesRiskassessment)
    "Schedule" -> Ok(VersionindependentallresourcetypesSchedule)
    "SearchParameter" -> Ok(VersionindependentallresourcetypesSearchparameter)
    "ServiceRequest" -> Ok(VersionindependentallresourcetypesServicerequest)
    "Slot" -> Ok(VersionindependentallresourcetypesSlot)
    "Specimen" -> Ok(VersionindependentallresourcetypesSpecimen)
    "SpecimenDefinition" ->
      Ok(VersionindependentallresourcetypesSpecimendefinition)
    "StructureDefinition" ->
      Ok(VersionindependentallresourcetypesStructuredefinition)
    "StructureMap" -> Ok(VersionindependentallresourcetypesStructuremap)
    "Subscription" -> Ok(VersionindependentallresourcetypesSubscription)
    "SubscriptionStatus" ->
      Ok(VersionindependentallresourcetypesSubscriptionstatus)
    "SubscriptionTopic" ->
      Ok(VersionindependentallresourcetypesSubscriptiontopic)
    "Substance" -> Ok(VersionindependentallresourcetypesSubstance)
    "SubstanceDefinition" ->
      Ok(VersionindependentallresourcetypesSubstancedefinition)
    "SubstanceNucleicAcid" ->
      Ok(VersionindependentallresourcetypesSubstancenucleicacid)
    "SubstancePolymer" -> Ok(VersionindependentallresourcetypesSubstancepolymer)
    "SubstanceProtein" -> Ok(VersionindependentallresourcetypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      Ok(VersionindependentallresourcetypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" ->
      Ok(VersionindependentallresourcetypesSubstancesourcematerial)
    "SupplyDelivery" -> Ok(VersionindependentallresourcetypesSupplydelivery)
    "SupplyRequest" -> Ok(VersionindependentallresourcetypesSupplyrequest)
    "Task" -> Ok(VersionindependentallresourcetypesTask)
    "TerminologyCapabilities" ->
      Ok(VersionindependentallresourcetypesTerminologycapabilities)
    "TestPlan" -> Ok(VersionindependentallresourcetypesTestplan)
    "TestReport" -> Ok(VersionindependentallresourcetypesTestreport)
    "TestScript" -> Ok(VersionindependentallresourcetypesTestscript)
    "Transport" -> Ok(VersionindependentallresourcetypesTransport)
    "ValueSet" -> Ok(VersionindependentallresourcetypesValueset)
    "VerificationResult" ->
      Ok(VersionindependentallresourcetypesVerificationresult)
    "VisionPrescription" ->
      Ok(VersionindependentallresourcetypesVisionprescription)
    "BodySite" -> Ok(VersionindependentallresourcetypesBodysite)
    "CatalogEntry" -> Ok(VersionindependentallresourcetypesCatalogentry)
    "Conformance" -> Ok(VersionindependentallresourcetypesConformance)
    "DataElement" -> Ok(VersionindependentallresourcetypesDataelement)
    "DeviceComponent" -> Ok(VersionindependentallresourcetypesDevicecomponent)
    "DeviceUseRequest" -> Ok(VersionindependentallresourcetypesDeviceuserequest)
    "DeviceUseStatement" ->
      Ok(VersionindependentallresourcetypesDeviceusestatement)
    "DiagnosticOrder" -> Ok(VersionindependentallresourcetypesDiagnosticorder)
    "DocumentManifest" -> Ok(VersionindependentallresourcetypesDocumentmanifest)
    "EffectEvidenceSynthesis" ->
      Ok(VersionindependentallresourcetypesEffectevidencesynthesis)
    "EligibilityRequest" ->
      Ok(VersionindependentallresourcetypesEligibilityrequest)
    "EligibilityResponse" ->
      Ok(VersionindependentallresourcetypesEligibilityresponse)
    "ExpansionProfile" -> Ok(VersionindependentallresourcetypesExpansionprofile)
    "ImagingManifest" -> Ok(VersionindependentallresourcetypesImagingmanifest)
    "ImagingObjectSelection" ->
      Ok(VersionindependentallresourcetypesImagingobjectselection)
    "Media" -> Ok(VersionindependentallresourcetypesMedia)
    "MedicationOrder" -> Ok(VersionindependentallresourcetypesMedicationorder)
    "MedicationUsage" -> Ok(VersionindependentallresourcetypesMedicationusage)
    "MedicinalProduct" -> Ok(VersionindependentallresourcetypesMedicinalproduct)
    "MedicinalProductAuthorization" ->
      Ok(VersionindependentallresourcetypesMedicinalproductauthorization)
    "MedicinalProductContraindication" ->
      Ok(VersionindependentallresourcetypesMedicinalproductcontraindication)
    "MedicinalProductIndication" ->
      Ok(VersionindependentallresourcetypesMedicinalproductindication)
    "MedicinalProductIngredient" ->
      Ok(VersionindependentallresourcetypesMedicinalproductingredient)
    "MedicinalProductInteraction" ->
      Ok(VersionindependentallresourcetypesMedicinalproductinteraction)
    "MedicinalProductManufactured" ->
      Ok(VersionindependentallresourcetypesMedicinalproductmanufactured)
    "MedicinalProductPackaged" ->
      Ok(VersionindependentallresourcetypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      Ok(VersionindependentallresourcetypesMedicinalproductpharmaceutical)
    "MedicinalProductUndesirableEffect" ->
      Ok(VersionindependentallresourcetypesMedicinalproductundesirableeffect)
    "Order" -> Ok(VersionindependentallresourcetypesOrder)
    "OrderResponse" -> Ok(VersionindependentallresourcetypesOrderresponse)
    "ProcedureRequest" -> Ok(VersionindependentallresourcetypesProcedurerequest)
    "ProcessRequest" -> Ok(VersionindependentallresourcetypesProcessrequest)
    "ProcessResponse" -> Ok(VersionindependentallresourcetypesProcessresponse)
    "ReferralRequest" -> Ok(VersionindependentallresourcetypesReferralrequest)
    "RequestGroup" -> Ok(VersionindependentallresourcetypesRequestgroup)
    "ResearchDefinition" ->
      Ok(VersionindependentallresourcetypesResearchdefinition)
    "ResearchElementDefinition" ->
      Ok(VersionindependentallresourcetypesResearchelementdefinition)
    "RiskEvidenceSynthesis" ->
      Ok(VersionindependentallresourcetypesRiskevidencesynthesis)
    "Sequence" -> Ok(VersionindependentallresourcetypesSequence)
    "ServiceDefinition" ->
      Ok(VersionindependentallresourcetypesServicedefinition)
    "SubstanceSpecification" ->
      Ok(VersionindependentallresourcetypesSubstancespecification)
    _ -> Error(Nil)
  }
}

pub fn versionindependentallresourcetypes_decoder() -> Decoder(
  Versionindependentallresourcetypes,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "Account" -> decode.success(VersionindependentallresourcetypesAccount)
    "ActivityDefinition" ->
      decode.success(VersionindependentallresourcetypesActivitydefinition)
    "ActorDefinition" ->
      decode.success(VersionindependentallresourcetypesActordefinition)
    "AdministrableProductDefinition" ->
      decode.success(
        VersionindependentallresourcetypesAdministrableproductdefinition,
      )
    "AdverseEvent" ->
      decode.success(VersionindependentallresourcetypesAdverseevent)
    "AllergyIntolerance" ->
      decode.success(VersionindependentallresourcetypesAllergyintolerance)
    "Appointment" ->
      decode.success(VersionindependentallresourcetypesAppointment)
    "AppointmentResponse" ->
      decode.success(VersionindependentallresourcetypesAppointmentresponse)
    "ArtifactAssessment" ->
      decode.success(VersionindependentallresourcetypesArtifactassessment)
    "AuditEvent" -> decode.success(VersionindependentallresourcetypesAuditevent)
    "Basic" -> decode.success(VersionindependentallresourcetypesBasic)
    "Binary" -> decode.success(VersionindependentallresourcetypesBinary)
    "BiologicallyDerivedProduct" ->
      decode.success(
        VersionindependentallresourcetypesBiologicallyderivedproduct,
      )
    "BiologicallyDerivedProductDispense" ->
      decode.success(
        VersionindependentallresourcetypesBiologicallyderivedproductdispense,
      )
    "BodyStructure" ->
      decode.success(VersionindependentallresourcetypesBodystructure)
    "Bundle" -> decode.success(VersionindependentallresourcetypesBundle)
    "CanonicalResource" ->
      decode.success(VersionindependentallresourcetypesCanonicalresource)
    "CapabilityStatement" ->
      decode.success(VersionindependentallresourcetypesCapabilitystatement)
    "CarePlan" -> decode.success(VersionindependentallresourcetypesCareplan)
    "CareTeam" -> decode.success(VersionindependentallresourcetypesCareteam)
    "ChargeItem" -> decode.success(VersionindependentallresourcetypesChargeitem)
    "ChargeItemDefinition" ->
      decode.success(VersionindependentallresourcetypesChargeitemdefinition)
    "Citation" -> decode.success(VersionindependentallresourcetypesCitation)
    "Claim" -> decode.success(VersionindependentallresourcetypesClaim)
    "ClaimResponse" ->
      decode.success(VersionindependentallresourcetypesClaimresponse)
    "ClinicalImpression" ->
      decode.success(VersionindependentallresourcetypesClinicalimpression)
    "ClinicalUseDefinition" ->
      decode.success(VersionindependentallresourcetypesClinicalusedefinition)
    "CodeSystem" -> decode.success(VersionindependentallresourcetypesCodesystem)
    "Communication" ->
      decode.success(VersionindependentallresourcetypesCommunication)
    "CommunicationRequest" ->
      decode.success(VersionindependentallresourcetypesCommunicationrequest)
    "CompartmentDefinition" ->
      decode.success(VersionindependentallresourcetypesCompartmentdefinition)
    "Composition" ->
      decode.success(VersionindependentallresourcetypesComposition)
    "ConceptMap" -> decode.success(VersionindependentallresourcetypesConceptmap)
    "Condition" -> decode.success(VersionindependentallresourcetypesCondition)
    "ConditionDefinition" ->
      decode.success(VersionindependentallresourcetypesConditiondefinition)
    "Consent" -> decode.success(VersionindependentallresourcetypesConsent)
    "Contract" -> decode.success(VersionindependentallresourcetypesContract)
    "Coverage" -> decode.success(VersionindependentallresourcetypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(
        VersionindependentallresourcetypesCoverageeligibilityrequest,
      )
    "CoverageEligibilityResponse" ->
      decode.success(
        VersionindependentallresourcetypesCoverageeligibilityresponse,
      )
    "DetectedIssue" ->
      decode.success(VersionindependentallresourcetypesDetectedissue)
    "Device" -> decode.success(VersionindependentallresourcetypesDevice)
    "DeviceAssociation" ->
      decode.success(VersionindependentallresourcetypesDeviceassociation)
    "DeviceDefinition" ->
      decode.success(VersionindependentallresourcetypesDevicedefinition)
    "DeviceDispense" ->
      decode.success(VersionindependentallresourcetypesDevicedispense)
    "DeviceMetric" ->
      decode.success(VersionindependentallresourcetypesDevicemetric)
    "DeviceRequest" ->
      decode.success(VersionindependentallresourcetypesDevicerequest)
    "DeviceUsage" ->
      decode.success(VersionindependentallresourcetypesDeviceusage)
    "DiagnosticReport" ->
      decode.success(VersionindependentallresourcetypesDiagnosticreport)
    "DocumentReference" ->
      decode.success(VersionindependentallresourcetypesDocumentreference)
    "DomainResource" ->
      decode.success(VersionindependentallresourcetypesDomainresource)
    "Encounter" -> decode.success(VersionindependentallresourcetypesEncounter)
    "EncounterHistory" ->
      decode.success(VersionindependentallresourcetypesEncounterhistory)
    "Endpoint" -> decode.success(VersionindependentallresourcetypesEndpoint)
    "EnrollmentRequest" ->
      decode.success(VersionindependentallresourcetypesEnrollmentrequest)
    "EnrollmentResponse" ->
      decode.success(VersionindependentallresourcetypesEnrollmentresponse)
    "EpisodeOfCare" ->
      decode.success(VersionindependentallresourcetypesEpisodeofcare)
    "EventDefinition" ->
      decode.success(VersionindependentallresourcetypesEventdefinition)
    "Evidence" -> decode.success(VersionindependentallresourcetypesEvidence)
    "EvidenceReport" ->
      decode.success(VersionindependentallresourcetypesEvidencereport)
    "EvidenceVariable" ->
      decode.success(VersionindependentallresourcetypesEvidencevariable)
    "ExampleScenario" ->
      decode.success(VersionindependentallresourcetypesExamplescenario)
    "ExplanationOfBenefit" ->
      decode.success(VersionindependentallresourcetypesExplanationofbenefit)
    "FamilyMemberHistory" ->
      decode.success(VersionindependentallresourcetypesFamilymemberhistory)
    "Flag" -> decode.success(VersionindependentallresourcetypesFlag)
    "FormularyItem" ->
      decode.success(VersionindependentallresourcetypesFormularyitem)
    "GenomicStudy" ->
      decode.success(VersionindependentallresourcetypesGenomicstudy)
    "Goal" -> decode.success(VersionindependentallresourcetypesGoal)
    "GraphDefinition" ->
      decode.success(VersionindependentallresourcetypesGraphdefinition)
    "Group" -> decode.success(VersionindependentallresourcetypesGroup)
    "GuidanceResponse" ->
      decode.success(VersionindependentallresourcetypesGuidanceresponse)
    "HealthcareService" ->
      decode.success(VersionindependentallresourcetypesHealthcareservice)
    "ImagingSelection" ->
      decode.success(VersionindependentallresourcetypesImagingselection)
    "ImagingStudy" ->
      decode.success(VersionindependentallresourcetypesImagingstudy)
    "Immunization" ->
      decode.success(VersionindependentallresourcetypesImmunization)
    "ImmunizationEvaluation" ->
      decode.success(VersionindependentallresourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(
        VersionindependentallresourcetypesImmunizationrecommendation,
      )
    "ImplementationGuide" ->
      decode.success(VersionindependentallresourcetypesImplementationguide)
    "Ingredient" -> decode.success(VersionindependentallresourcetypesIngredient)
    "InsurancePlan" ->
      decode.success(VersionindependentallresourcetypesInsuranceplan)
    "InventoryItem" ->
      decode.success(VersionindependentallresourcetypesInventoryitem)
    "InventoryReport" ->
      decode.success(VersionindependentallresourcetypesInventoryreport)
    "Invoice" -> decode.success(VersionindependentallresourcetypesInvoice)
    "Library" -> decode.success(VersionindependentallresourcetypesLibrary)
    "Linkage" -> decode.success(VersionindependentallresourcetypesLinkage)
    "List" -> decode.success(VersionindependentallresourcetypesList)
    "Location" -> decode.success(VersionindependentallresourcetypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(
        VersionindependentallresourcetypesManufactureditemdefinition,
      )
    "Measure" -> decode.success(VersionindependentallresourcetypesMeasure)
    "MeasureReport" ->
      decode.success(VersionindependentallresourcetypesMeasurereport)
    "Medication" -> decode.success(VersionindependentallresourcetypesMedication)
    "MedicationAdministration" ->
      decode.success(VersionindependentallresourcetypesMedicationadministration)
    "MedicationDispense" ->
      decode.success(VersionindependentallresourcetypesMedicationdispense)
    "MedicationKnowledge" ->
      decode.success(VersionindependentallresourcetypesMedicationknowledge)
    "MedicationRequest" ->
      decode.success(VersionindependentallresourcetypesMedicationrequest)
    "MedicationStatement" ->
      decode.success(VersionindependentallresourcetypesMedicationstatement)
    "MedicinalProductDefinition" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductdefinition,
      )
    "MessageDefinition" ->
      decode.success(VersionindependentallresourcetypesMessagedefinition)
    "MessageHeader" ->
      decode.success(VersionindependentallresourcetypesMessageheader)
    "MetadataResource" ->
      decode.success(VersionindependentallresourcetypesMetadataresource)
    "MolecularSequence" ->
      decode.success(VersionindependentallresourcetypesMolecularsequence)
    "NamingSystem" ->
      decode.success(VersionindependentallresourcetypesNamingsystem)
    "NutritionIntake" ->
      decode.success(VersionindependentallresourcetypesNutritionintake)
    "NutritionOrder" ->
      decode.success(VersionindependentallresourcetypesNutritionorder)
    "NutritionProduct" ->
      decode.success(VersionindependentallresourcetypesNutritionproduct)
    "Observation" ->
      decode.success(VersionindependentallresourcetypesObservation)
    "ObservationDefinition" ->
      decode.success(VersionindependentallresourcetypesObservationdefinition)
    "OperationDefinition" ->
      decode.success(VersionindependentallresourcetypesOperationdefinition)
    "OperationOutcome" ->
      decode.success(VersionindependentallresourcetypesOperationoutcome)
    "Organization" ->
      decode.success(VersionindependentallresourcetypesOrganization)
    "OrganizationAffiliation" ->
      decode.success(VersionindependentallresourcetypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      decode.success(
        VersionindependentallresourcetypesPackagedproductdefinition,
      )
    "Parameters" -> decode.success(VersionindependentallresourcetypesParameters)
    "Patient" -> decode.success(VersionindependentallresourcetypesPatient)
    "PaymentNotice" ->
      decode.success(VersionindependentallresourcetypesPaymentnotice)
    "PaymentReconciliation" ->
      decode.success(VersionindependentallresourcetypesPaymentreconciliation)
    "Permission" -> decode.success(VersionindependentallresourcetypesPermission)
    "Person" -> decode.success(VersionindependentallresourcetypesPerson)
    "PlanDefinition" ->
      decode.success(VersionindependentallresourcetypesPlandefinition)
    "Practitioner" ->
      decode.success(VersionindependentallresourcetypesPractitioner)
    "PractitionerRole" ->
      decode.success(VersionindependentallresourcetypesPractitionerrole)
    "Procedure" -> decode.success(VersionindependentallresourcetypesProcedure)
    "Provenance" -> decode.success(VersionindependentallresourcetypesProvenance)
    "Questionnaire" ->
      decode.success(VersionindependentallresourcetypesQuestionnaire)
    "QuestionnaireResponse" ->
      decode.success(VersionindependentallresourcetypesQuestionnaireresponse)
    "RegulatedAuthorization" ->
      decode.success(VersionindependentallresourcetypesRegulatedauthorization)
    "RelatedPerson" ->
      decode.success(VersionindependentallresourcetypesRelatedperson)
    "RequestOrchestration" ->
      decode.success(VersionindependentallresourcetypesRequestorchestration)
    "Requirements" ->
      decode.success(VersionindependentallresourcetypesRequirements)
    "ResearchStudy" ->
      decode.success(VersionindependentallresourcetypesResearchstudy)
    "ResearchSubject" ->
      decode.success(VersionindependentallresourcetypesResearchsubject)
    "Resource" -> decode.success(VersionindependentallresourcetypesResource)
    "RiskAssessment" ->
      decode.success(VersionindependentallresourcetypesRiskassessment)
    "Schedule" -> decode.success(VersionindependentallresourcetypesSchedule)
    "SearchParameter" ->
      decode.success(VersionindependentallresourcetypesSearchparameter)
    "ServiceRequest" ->
      decode.success(VersionindependentallresourcetypesServicerequest)
    "Slot" -> decode.success(VersionindependentallresourcetypesSlot)
    "Specimen" -> decode.success(VersionindependentallresourcetypesSpecimen)
    "SpecimenDefinition" ->
      decode.success(VersionindependentallresourcetypesSpecimendefinition)
    "StructureDefinition" ->
      decode.success(VersionindependentallresourcetypesStructuredefinition)
    "StructureMap" ->
      decode.success(VersionindependentallresourcetypesStructuremap)
    "Subscription" ->
      decode.success(VersionindependentallresourcetypesSubscription)
    "SubscriptionStatus" ->
      decode.success(VersionindependentallresourcetypesSubscriptionstatus)
    "SubscriptionTopic" ->
      decode.success(VersionindependentallresourcetypesSubscriptiontopic)
    "Substance" -> decode.success(VersionindependentallresourcetypesSubstance)
    "SubstanceDefinition" ->
      decode.success(VersionindependentallresourcetypesSubstancedefinition)
    "SubstanceNucleicAcid" ->
      decode.success(VersionindependentallresourcetypesSubstancenucleicacid)
    "SubstancePolymer" ->
      decode.success(VersionindependentallresourcetypesSubstancepolymer)
    "SubstanceProtein" ->
      decode.success(VersionindependentallresourcetypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      decode.success(
        VersionindependentallresourcetypesSubstancereferenceinformation,
      )
    "SubstanceSourceMaterial" ->
      decode.success(VersionindependentallresourcetypesSubstancesourcematerial)
    "SupplyDelivery" ->
      decode.success(VersionindependentallresourcetypesSupplydelivery)
    "SupplyRequest" ->
      decode.success(VersionindependentallresourcetypesSupplyrequest)
    "Task" -> decode.success(VersionindependentallresourcetypesTask)
    "TerminologyCapabilities" ->
      decode.success(VersionindependentallresourcetypesTerminologycapabilities)
    "TestPlan" -> decode.success(VersionindependentallresourcetypesTestplan)
    "TestReport" -> decode.success(VersionindependentallresourcetypesTestreport)
    "TestScript" -> decode.success(VersionindependentallresourcetypesTestscript)
    "Transport" -> decode.success(VersionindependentallresourcetypesTransport)
    "ValueSet" -> decode.success(VersionindependentallresourcetypesValueset)
    "VerificationResult" ->
      decode.success(VersionindependentallresourcetypesVerificationresult)
    "VisionPrescription" ->
      decode.success(VersionindependentallresourcetypesVisionprescription)
    "BodySite" -> decode.success(VersionindependentallresourcetypesBodysite)
    "CatalogEntry" ->
      decode.success(VersionindependentallresourcetypesCatalogentry)
    "Conformance" ->
      decode.success(VersionindependentallresourcetypesConformance)
    "DataElement" ->
      decode.success(VersionindependentallresourcetypesDataelement)
    "DeviceComponent" ->
      decode.success(VersionindependentallresourcetypesDevicecomponent)
    "DeviceUseRequest" ->
      decode.success(VersionindependentallresourcetypesDeviceuserequest)
    "DeviceUseStatement" ->
      decode.success(VersionindependentallresourcetypesDeviceusestatement)
    "DiagnosticOrder" ->
      decode.success(VersionindependentallresourcetypesDiagnosticorder)
    "DocumentManifest" ->
      decode.success(VersionindependentallresourcetypesDocumentmanifest)
    "EffectEvidenceSynthesis" ->
      decode.success(VersionindependentallresourcetypesEffectevidencesynthesis)
    "EligibilityRequest" ->
      decode.success(VersionindependentallresourcetypesEligibilityrequest)
    "EligibilityResponse" ->
      decode.success(VersionindependentallresourcetypesEligibilityresponse)
    "ExpansionProfile" ->
      decode.success(VersionindependentallresourcetypesExpansionprofile)
    "ImagingManifest" ->
      decode.success(VersionindependentallresourcetypesImagingmanifest)
    "ImagingObjectSelection" ->
      decode.success(VersionindependentallresourcetypesImagingobjectselection)
    "Media" -> decode.success(VersionindependentallresourcetypesMedia)
    "MedicationOrder" ->
      decode.success(VersionindependentallresourcetypesMedicationorder)
    "MedicationUsage" ->
      decode.success(VersionindependentallresourcetypesMedicationusage)
    "MedicinalProduct" ->
      decode.success(VersionindependentallresourcetypesMedicinalproduct)
    "MedicinalProductAuthorization" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductauthorization,
      )
    "MedicinalProductContraindication" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductcontraindication,
      )
    "MedicinalProductIndication" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductindication,
      )
    "MedicinalProductIngredient" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductingredient,
      )
    "MedicinalProductInteraction" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductinteraction,
      )
    "MedicinalProductManufactured" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductmanufactured,
      )
    "MedicinalProductPackaged" ->
      decode.success(VersionindependentallresourcetypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductpharmaceutical,
      )
    "MedicinalProductUndesirableEffect" ->
      decode.success(
        VersionindependentallresourcetypesMedicinalproductundesirableeffect,
      )
    "Order" -> decode.success(VersionindependentallresourcetypesOrder)
    "OrderResponse" ->
      decode.success(VersionindependentallresourcetypesOrderresponse)
    "ProcedureRequest" ->
      decode.success(VersionindependentallresourcetypesProcedurerequest)
    "ProcessRequest" ->
      decode.success(VersionindependentallresourcetypesProcessrequest)
    "ProcessResponse" ->
      decode.success(VersionindependentallresourcetypesProcessresponse)
    "ReferralRequest" ->
      decode.success(VersionindependentallresourcetypesReferralrequest)
    "RequestGroup" ->
      decode.success(VersionindependentallresourcetypesRequestgroup)
    "ResearchDefinition" ->
      decode.success(VersionindependentallresourcetypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(
        VersionindependentallresourcetypesResearchelementdefinition,
      )
    "RiskEvidenceSynthesis" ->
      decode.success(VersionindependentallresourcetypesRiskevidencesynthesis)
    "Sequence" -> decode.success(VersionindependentallresourcetypesSequence)
    "ServiceDefinition" ->
      decode.success(VersionindependentallresourcetypesServicedefinition)
    "SubstanceSpecification" ->
      decode.success(VersionindependentallresourcetypesSubstancespecification)
    _ ->
      decode.failure(
        VersionindependentallresourcetypesAccount,
        "Versionindependentallresourcetypes",
      )
  }
}

pub type Versioningpolicy {
  VersioningpolicyNoversion
  VersioningpolicyVersioned
  VersioningpolicyVersionedupdate
}

pub fn versioningpolicy_to_json(versioningpolicy: Versioningpolicy) -> Json {
  json.string(versioningpolicy_to_string(versioningpolicy))
}

pub fn versioningpolicy_to_string(versioningpolicy: Versioningpolicy) -> String {
  case versioningpolicy {
    VersioningpolicyNoversion -> "no-version"
    VersioningpolicyVersioned -> "versioned"
    VersioningpolicyVersionedupdate -> "versioned-update"
  }
}

pub fn versioningpolicy_from_string(s: String) -> Result(Versioningpolicy, Nil) {
  case s {
    "no-version" -> Ok(VersioningpolicyNoversion)
    "versioned" -> Ok(VersioningpolicyVersioned)
    "versioned-update" -> Ok(VersioningpolicyVersionedupdate)
    _ -> Error(Nil)
  }
}

pub fn versioningpolicy_decoder() -> Decoder(Versioningpolicy) {
  use variant <- decode.then(decode.string)
  case variant {
    "no-version" -> decode.success(VersioningpolicyNoversion)
    "versioned" -> decode.success(VersioningpolicyVersioned)
    "versioned-update" -> decode.success(VersioningpolicyVersionedupdate)
    _ -> decode.failure(VersioningpolicyNoversion, "Versioningpolicy")
  }
}

pub type Visionbasecodes {
  VisionbasecodesUp
  VisionbasecodesDown
  VisionbasecodesIn
  VisionbasecodesOut
}

pub fn visionbasecodes_to_json(visionbasecodes: Visionbasecodes) -> Json {
  json.string(visionbasecodes_to_string(visionbasecodes))
}

pub fn visionbasecodes_to_string(visionbasecodes: Visionbasecodes) -> String {
  case visionbasecodes {
    VisionbasecodesUp -> "up"
    VisionbasecodesDown -> "down"
    VisionbasecodesIn -> "in"
    VisionbasecodesOut -> "out"
  }
}

pub fn visionbasecodes_from_string(s: String) -> Result(Visionbasecodes, Nil) {
  case s {
    "up" -> Ok(VisionbasecodesUp)
    "down" -> Ok(VisionbasecodesDown)
    "in" -> Ok(VisionbasecodesIn)
    "out" -> Ok(VisionbasecodesOut)
    _ -> Error(Nil)
  }
}

pub fn visionbasecodes_decoder() -> Decoder(Visionbasecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "up" -> decode.success(VisionbasecodesUp)
    "down" -> decode.success(VisionbasecodesDown)
    "in" -> decode.success(VisionbasecodesIn)
    "out" -> decode.success(VisionbasecodesOut)
    _ -> decode.failure(VisionbasecodesUp, "Visionbasecodes")
  }
}

pub type Visioneyecodes {
  VisioneyecodesRight
  VisioneyecodesLeft
}

pub fn visioneyecodes_to_json(visioneyecodes: Visioneyecodes) -> Json {
  json.string(visioneyecodes_to_string(visioneyecodes))
}

pub fn visioneyecodes_to_string(visioneyecodes: Visioneyecodes) -> String {
  case visioneyecodes {
    VisioneyecodesRight -> "right"
    VisioneyecodesLeft -> "left"
  }
}

pub fn visioneyecodes_from_string(s: String) -> Result(Visioneyecodes, Nil) {
  case s {
    "right" -> Ok(VisioneyecodesRight)
    "left" -> Ok(VisioneyecodesLeft)
    _ -> Error(Nil)
  }
}

pub fn visioneyecodes_decoder() -> Decoder(Visioneyecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "right" -> decode.success(VisioneyecodesRight)
    "left" -> decode.success(VisioneyecodesLeft)
    _ -> decode.failure(VisioneyecodesRight, "Visioneyecodes")
  }
}
