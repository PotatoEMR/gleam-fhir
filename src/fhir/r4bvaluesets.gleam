import gleam/json.{type Json}
import gleam/dynamic/decode.{type Decoder}

pub type Conditionalreadstatus{ConditionalreadstatusNotsupported
ConditionalreadstatusModifiedsince
ConditionalreadstatusNotmatch
ConditionalreadstatusFullsupport
}
pub fn conditionalreadstatus_to_json(conditionalreadstatus: Conditionalreadstatus) -> Json {
    case conditionalreadstatus {ConditionalreadstatusNotsupported -> json.string("not-supported")
ConditionalreadstatusModifiedsince -> json.string("modified-since")
ConditionalreadstatusNotmatch -> json.string("not-match")
ConditionalreadstatusFullsupport -> json.string("full-support")
}
  }
  pub fn conditionalreadstatus_decoder() -> Decoder(Conditionalreadstatus) {
    use variant <- decode.then(decode.string)
    case variant {"not-supported" -> decode.success(ConditionalreadstatusNotsupported)
"modified-since" -> decode.success(ConditionalreadstatusModifiedsince)
"not-match" -> decode.success(ConditionalreadstatusNotmatch)
"full-support" -> decode.success(ConditionalreadstatusFullsupport)
_ -> decode.failure(ConditionalreadstatusNotsupported, "Conditionalreadstatus")}
  }
  
pub type Immunizationstatus{ImmunizationstatusCompleted
ImmunizationstatusEnteredinerror
ImmunizationstatusNotdone
}
pub fn immunizationstatus_to_json(immunizationstatus: Immunizationstatus) -> Json {
    case immunizationstatus {ImmunizationstatusCompleted -> json.string("completed")
ImmunizationstatusEnteredinerror -> json.string("entered-in-error")
ImmunizationstatusNotdone -> json.string("not-done")
}
  }
  pub fn immunizationstatus_decoder() -> Decoder(Immunizationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"completed" -> decode.success(ImmunizationstatusCompleted)
"entered-in-error" -> decode.success(ImmunizationstatusEnteredinerror)
"not-done" -> decode.success(ImmunizationstatusNotdone)
_ -> decode.failure(ImmunizationstatusCompleted, "Immunizationstatus")}
  }
  
pub type Detectedissueseverity{DetectedissueseverityHigh
DetectedissueseverityModerate
DetectedissueseverityLow
}
pub fn detectedissueseverity_to_json(detectedissueseverity: Detectedissueseverity) -> Json {
    case detectedissueseverity {DetectedissueseverityHigh -> json.string("high")
DetectedissueseverityModerate -> json.string("moderate")
DetectedissueseverityLow -> json.string("low")
}
  }
  pub fn detectedissueseverity_decoder() -> Decoder(Detectedissueseverity) {
    use variant <- decode.then(decode.string)
    case variant {"high" -> decode.success(DetectedissueseverityHigh)
"moderate" -> decode.success(DetectedissueseverityModerate)
"low" -> decode.success(DetectedissueseverityLow)
_ -> decode.failure(DetectedissueseverityHigh, "Detectedissueseverity")}
  }
  
pub type Fmstatus{FmstatusActive
FmstatusCancelled
FmstatusDraft
FmstatusEnteredinerror
}
pub fn fmstatus_to_json(fmstatus: Fmstatus) -> Json {
    case fmstatus {FmstatusActive -> json.string("active")
FmstatusCancelled -> json.string("cancelled")
FmstatusDraft -> json.string("draft")
FmstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn fmstatus_decoder() -> Decoder(Fmstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(FmstatusActive)
"cancelled" -> decode.success(FmstatusCancelled)
"draft" -> decode.success(FmstatusDraft)
"entered-in-error" -> decode.success(FmstatusEnteredinerror)
_ -> decode.failure(FmstatusActive, "Fmstatus")}
  }
  
pub type Actioncardinalitybehavior{ActioncardinalitybehaviorSingle
ActioncardinalitybehaviorMultiple
}
pub fn actioncardinalitybehavior_to_json(actioncardinalitybehavior: Actioncardinalitybehavior) -> Json {
    case actioncardinalitybehavior {ActioncardinalitybehaviorSingle -> json.string("single")
ActioncardinalitybehaviorMultiple -> json.string("multiple")
}
  }
  pub fn actioncardinalitybehavior_decoder() -> Decoder(Actioncardinalitybehavior) {
    use variant <- decode.then(decode.string)
    case variant {"single" -> decode.success(ActioncardinalitybehaviorSingle)
"multiple" -> decode.success(ActioncardinalitybehaviorMultiple)
_ -> decode.failure(ActioncardinalitybehaviorSingle, "Actioncardinalitybehavior")}
  }
  
pub type Conceptmapunmappedmode{ConceptmapunmappedmodeProvided
ConceptmapunmappedmodeFixed
ConceptmapunmappedmodeOthermap
}
pub fn conceptmapunmappedmode_to_json(conceptmapunmappedmode: Conceptmapunmappedmode) -> Json {
    case conceptmapunmappedmode {ConceptmapunmappedmodeProvided -> json.string("provided")
ConceptmapunmappedmodeFixed -> json.string("fixed")
ConceptmapunmappedmodeOthermap -> json.string("other-map")
}
  }
  pub fn conceptmapunmappedmode_decoder() -> Decoder(Conceptmapunmappedmode) {
    use variant <- decode.then(decode.string)
    case variant {"provided" -> decode.success(ConceptmapunmappedmodeProvided)
"fixed" -> decode.success(ConceptmapunmappedmodeFixed)
"other-map" -> decode.success(ConceptmapunmappedmodeOthermap)
_ -> decode.failure(ConceptmapunmappedmodeProvided, "Conceptmapunmappedmode")}
  }
  
pub type Compositionattestationmode{CompositionattestationmodePersonal
CompositionattestationmodeProfessional
CompositionattestationmodeLegal
CompositionattestationmodeOfficial
}
pub fn compositionattestationmode_to_json(compositionattestationmode: Compositionattestationmode) -> Json {
    case compositionattestationmode {CompositionattestationmodePersonal -> json.string("personal")
CompositionattestationmodeProfessional -> json.string("professional")
CompositionattestationmodeLegal -> json.string("legal")
CompositionattestationmodeOfficial -> json.string("official")
}
  }
  pub fn compositionattestationmode_decoder() -> Decoder(Compositionattestationmode) {
    use variant <- decode.then(decode.string)
    case variant {"personal" -> decode.success(CompositionattestationmodePersonal)
"professional" -> decode.success(CompositionattestationmodeProfessional)
"legal" -> decode.success(CompositionattestationmodeLegal)
"official" -> decode.success(CompositionattestationmodeOfficial)
_ -> decode.failure(CompositionattestationmodePersonal, "Compositionattestationmode")}
  }
  
pub type Locationstatus{LocationstatusActive
LocationstatusSuspended
LocationstatusInactive
}
pub fn locationstatus_to_json(locationstatus: Locationstatus) -> Json {
    case locationstatus {LocationstatusActive -> json.string("active")
LocationstatusSuspended -> json.string("suspended")
LocationstatusInactive -> json.string("inactive")
}
  }
  pub fn locationstatus_decoder() -> Decoder(Locationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(LocationstatusActive)
"suspended" -> decode.success(LocationstatusSuspended)
"inactive" -> decode.success(LocationstatusInactive)
_ -> decode.failure(LocationstatusActive, "Locationstatus")}
  }
  
pub type Claimuse{ClaimuseClaim
ClaimusePreauthorization
ClaimusePredetermination
}
pub fn claimuse_to_json(claimuse: Claimuse) -> Json {
    case claimuse {ClaimuseClaim -> json.string("claim")
ClaimusePreauthorization -> json.string("preauthorization")
ClaimusePredetermination -> json.string("predetermination")
}
  }
  pub fn claimuse_decoder() -> Decoder(Claimuse) {
    use variant <- decode.then(decode.string)
    case variant {"claim" -> decode.success(ClaimuseClaim)
"preauthorization" -> decode.success(ClaimusePreauthorization)
"predetermination" -> decode.success(ClaimusePredetermination)
_ -> decode.failure(ClaimuseClaim, "Claimuse")}
  }
  
pub type Identifieruse{IdentifieruseUsual
IdentifieruseOfficial
IdentifieruseTemp
IdentifieruseSecondary
IdentifieruseOld
}
pub fn identifieruse_to_json(identifieruse: Identifieruse) -> Json {
    case identifieruse {IdentifieruseUsual -> json.string("usual")
IdentifieruseOfficial -> json.string("official")
IdentifieruseTemp -> json.string("temp")
IdentifieruseSecondary -> json.string("secondary")
IdentifieruseOld -> json.string("old")
}
  }
  pub fn identifieruse_decoder() -> Decoder(Identifieruse) {
    use variant <- decode.then(decode.string)
    case variant {"usual" -> decode.success(IdentifieruseUsual)
"official" -> decode.success(IdentifieruseOfficial)
"temp" -> decode.success(IdentifieruseTemp)
"secondary" -> decode.success(IdentifieruseSecondary)
"old" -> decode.success(IdentifieruseOld)
_ -> decode.failure(IdentifieruseUsual, "Identifieruse")}
  }
  
pub type Locationmode{LocationmodeInstance
LocationmodeKind
}
pub fn locationmode_to_json(locationmode: Locationmode) -> Json {
    case locationmode {LocationmodeInstance -> json.string("instance")
LocationmodeKind -> json.string("kind")
}
  }
  pub fn locationmode_decoder() -> Decoder(Locationmode) {
    use variant <- decode.then(decode.string)
    case variant {"instance" -> decode.success(LocationmodeInstance)
"kind" -> decode.success(LocationmodeKind)
_ -> decode.failure(LocationmodeInstance, "Locationmode")}
  }
  
pub type Propertyrepresentation{PropertyrepresentationXmlattr
PropertyrepresentationXmltext
PropertyrepresentationTypeattr
PropertyrepresentationCdatext
PropertyrepresentationXhtml
}
pub fn propertyrepresentation_to_json(propertyrepresentation: Propertyrepresentation) -> Json {
    case propertyrepresentation {PropertyrepresentationXmlattr -> json.string("xmlAttr")
PropertyrepresentationXmltext -> json.string("xmlText")
PropertyrepresentationTypeattr -> json.string("typeAttr")
PropertyrepresentationCdatext -> json.string("cdaText")
PropertyrepresentationXhtml -> json.string("xhtml")
}
  }
  pub fn propertyrepresentation_decoder() -> Decoder(Propertyrepresentation) {
    use variant <- decode.then(decode.string)
    case variant {"xmlAttr" -> decode.success(PropertyrepresentationXmlattr)
"xmlText" -> decode.success(PropertyrepresentationXmltext)
"typeAttr" -> decode.success(PropertyrepresentationTypeattr)
"cdaText" -> decode.success(PropertyrepresentationCdatext)
"xhtml" -> decode.success(PropertyrepresentationXhtml)
_ -> decode.failure(PropertyrepresentationXmlattr, "Propertyrepresentation")}
  }
  
pub type Auditeventaction{AuditeventactionC
AuditeventactionR
AuditeventactionU
AuditeventactionD
AuditeventactionE
}
pub fn auditeventaction_to_json(auditeventaction: Auditeventaction) -> Json {
    case auditeventaction {AuditeventactionC -> json.string("C")
AuditeventactionR -> json.string("R")
AuditeventactionU -> json.string("U")
AuditeventactionD -> json.string("D")
AuditeventactionE -> json.string("E")
}
  }
  pub fn auditeventaction_decoder() -> Decoder(Auditeventaction) {
    use variant <- decode.then(decode.string)
    case variant {"C" -> decode.success(AuditeventactionC)
"R" -> decode.success(AuditeventactionR)
"U" -> decode.success(AuditeventactionU)
"D" -> decode.success(AuditeventactionD)
"E" -> decode.success(AuditeventactionE)
_ -> decode.failure(AuditeventactionC, "Auditeventaction")}
  }
  
pub type Supplyrequeststatus{SupplyrequeststatusDraft
SupplyrequeststatusActive
SupplyrequeststatusSuspended
SupplyrequeststatusCancelled
SupplyrequeststatusCompleted
SupplyrequeststatusEnteredinerror
SupplyrequeststatusUnknown
}
pub fn supplyrequeststatus_to_json(supplyrequeststatus: Supplyrequeststatus) -> Json {
    case supplyrequeststatus {SupplyrequeststatusDraft -> json.string("draft")
SupplyrequeststatusActive -> json.string("active")
SupplyrequeststatusSuspended -> json.string("suspended")
SupplyrequeststatusCancelled -> json.string("cancelled")
SupplyrequeststatusCompleted -> json.string("completed")
SupplyrequeststatusEnteredinerror -> json.string("entered-in-error")
SupplyrequeststatusUnknown -> json.string("unknown")
}
  }
  pub fn supplyrequeststatus_decoder() -> Decoder(Supplyrequeststatus) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(SupplyrequeststatusDraft)
"active" -> decode.success(SupplyrequeststatusActive)
"suspended" -> decode.success(SupplyrequeststatusSuspended)
"cancelled" -> decode.success(SupplyrequeststatusCancelled)
"completed" -> decode.success(SupplyrequeststatusCompleted)
"entered-in-error" -> decode.success(SupplyrequeststatusEnteredinerror)
"unknown" -> decode.success(SupplyrequeststatusUnknown)
_ -> decode.failure(SupplyrequeststatusDraft, "Supplyrequeststatus")}
  }
  
pub type Researchstudystatus{ResearchstudystatusActive
ResearchstudystatusAdministrativelycompleted
ResearchstudystatusApproved
ResearchstudystatusClosedtoaccrual
ResearchstudystatusClosedtoaccrualandintervention
ResearchstudystatusCompleted
ResearchstudystatusDisapproved
ResearchstudystatusInreview
ResearchstudystatusTemporarilyclosedtoaccrual
ResearchstudystatusTemporarilyclosedtoaccrualandintervention
ResearchstudystatusWithdrawn
}
pub fn researchstudystatus_to_json(researchstudystatus: Researchstudystatus) -> Json {
    case researchstudystatus {ResearchstudystatusActive -> json.string("active")
ResearchstudystatusAdministrativelycompleted -> json.string("administratively-completed")
ResearchstudystatusApproved -> json.string("approved")
ResearchstudystatusClosedtoaccrual -> json.string("closed-to-accrual")
ResearchstudystatusClosedtoaccrualandintervention -> json.string("closed-to-accrual-and-intervention")
ResearchstudystatusCompleted -> json.string("completed")
ResearchstudystatusDisapproved -> json.string("disapproved")
ResearchstudystatusInreview -> json.string("in-review")
ResearchstudystatusTemporarilyclosedtoaccrual -> json.string("temporarily-closed-to-accrual")
ResearchstudystatusTemporarilyclosedtoaccrualandintervention -> json.string("temporarily-closed-to-accrual-and-intervention")
ResearchstudystatusWithdrawn -> json.string("withdrawn")
}
  }
  pub fn researchstudystatus_decoder() -> Decoder(Researchstudystatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(ResearchstudystatusActive)
"administratively-completed" -> decode.success(ResearchstudystatusAdministrativelycompleted)
"approved" -> decode.success(ResearchstudystatusApproved)
"closed-to-accrual" -> decode.success(ResearchstudystatusClosedtoaccrual)
"closed-to-accrual-and-intervention" -> decode.success(ResearchstudystatusClosedtoaccrualandintervention)
"completed" -> decode.success(ResearchstudystatusCompleted)
"disapproved" -> decode.success(ResearchstudystatusDisapproved)
"in-review" -> decode.success(ResearchstudystatusInreview)
"temporarily-closed-to-accrual" -> decode.success(ResearchstudystatusTemporarilyclosedtoaccrual)
"temporarily-closed-to-accrual-and-intervention" -> decode.success(ResearchstudystatusTemporarilyclosedtoaccrualandintervention)
"withdrawn" -> decode.success(ResearchstudystatusWithdrawn)
_ -> decode.failure(ResearchstudystatusActive, "Researchstudystatus")}
  }
  
pub type Liststatus{ListstatusCurrent
ListstatusRetired
ListstatusEnteredinerror
}
pub fn liststatus_to_json(liststatus: Liststatus) -> Json {
    case liststatus {ListstatusCurrent -> json.string("current")
ListstatusRetired -> json.string("retired")
ListstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn liststatus_decoder() -> Decoder(Liststatus) {
    use variant <- decode.then(decode.string)
    case variant {"current" -> decode.success(ListstatusCurrent)
"retired" -> decode.success(ListstatusRetired)
"entered-in-error" -> decode.success(ListstatusEnteredinerror)
_ -> decode.failure(ListstatusCurrent, "Liststatus")}
  }
  
pub type Mapinputmode{MapinputmodeSource
MapinputmodeTarget
}
pub fn mapinputmode_to_json(mapinputmode: Mapinputmode) -> Json {
    case mapinputmode {MapinputmodeSource -> json.string("source")
MapinputmodeTarget -> json.string("target")
}
  }
  pub fn mapinputmode_decoder() -> Decoder(Mapinputmode) {
    use variant <- decode.then(decode.string)
    case variant {"source" -> decode.success(MapinputmodeSource)
"target" -> decode.success(MapinputmodeTarget)
_ -> decode.failure(MapinputmodeSource, "Mapinputmode")}
  }
  
pub type Resourcetypes{ResourcetypesResource
}
pub fn resourcetypes_to_json(resourcetypes: Resourcetypes) -> Json {
    case resourcetypes {ResourcetypesResource -> json.string("Resource")
}
  }
  pub fn resourcetypes_decoder() -> Decoder(Resourcetypes) {
    use variant <- decode.then(decode.string)
    case variant {"Resource" -> decode.success(ResourcetypesResource)
_ -> decode.failure(ResourcetypesResource, "Resourcetypes")}
  }
  
pub type Capabilitystatementkind{CapabilitystatementkindInstance
CapabilitystatementkindCapability
CapabilitystatementkindRequirements
}
pub fn capabilitystatementkind_to_json(capabilitystatementkind: Capabilitystatementkind) -> Json {
    case capabilitystatementkind {CapabilitystatementkindInstance -> json.string("instance")
CapabilitystatementkindCapability -> json.string("capability")
CapabilitystatementkindRequirements -> json.string("requirements")
}
  }
  pub fn capabilitystatementkind_decoder() -> Decoder(Capabilitystatementkind) {
    use variant <- decode.then(decode.string)
    case variant {"instance" -> decode.success(CapabilitystatementkindInstance)
"capability" -> decode.success(CapabilitystatementkindCapability)
"requirements" -> decode.success(CapabilitystatementkindRequirements)
_ -> decode.failure(CapabilitystatementkindInstance, "Capabilitystatementkind")}
  }
  
pub type Questionnaireanswersstatus{QuestionnaireanswersstatusInprogress
QuestionnaireanswersstatusCompleted
QuestionnaireanswersstatusAmended
QuestionnaireanswersstatusEnteredinerror
QuestionnaireanswersstatusStopped
}
pub fn questionnaireanswersstatus_to_json(questionnaireanswersstatus: Questionnaireanswersstatus) -> Json {
    case questionnaireanswersstatus {QuestionnaireanswersstatusInprogress -> json.string("in-progress")
QuestionnaireanswersstatusCompleted -> json.string("completed")
QuestionnaireanswersstatusAmended -> json.string("amended")
QuestionnaireanswersstatusEnteredinerror -> json.string("entered-in-error")
QuestionnaireanswersstatusStopped -> json.string("stopped")
}
  }
  pub fn questionnaireanswersstatus_decoder() -> Decoder(Questionnaireanswersstatus) {
    use variant <- decode.then(decode.string)
    case variant {"in-progress" -> decode.success(QuestionnaireanswersstatusInprogress)
"completed" -> decode.success(QuestionnaireanswersstatusCompleted)
"amended" -> decode.success(QuestionnaireanswersstatusAmended)
"entered-in-error" -> decode.success(QuestionnaireanswersstatusEnteredinerror)
"stopped" -> decode.success(QuestionnaireanswersstatusStopped)
_ -> decode.failure(QuestionnaireanswersstatusInprogress, "Questionnaireanswersstatus")}
  }
  
pub type Careteamstatus{CareteamstatusProposed
CareteamstatusActive
CareteamstatusSuspended
CareteamstatusInactive
CareteamstatusEnteredinerror
}
pub fn careteamstatus_to_json(careteamstatus: Careteamstatus) -> Json {
    case careteamstatus {CareteamstatusProposed -> json.string("proposed")
CareteamstatusActive -> json.string("active")
CareteamstatusSuspended -> json.string("suspended")
CareteamstatusInactive -> json.string("inactive")
CareteamstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn careteamstatus_decoder() -> Decoder(Careteamstatus) {
    use variant <- decode.then(decode.string)
    case variant {"proposed" -> decode.success(CareteamstatusProposed)
"active" -> decode.success(CareteamstatusActive)
"suspended" -> decode.success(CareteamstatusSuspended)
"inactive" -> decode.success(CareteamstatusInactive)
"entered-in-error" -> decode.success(CareteamstatusEnteredinerror)
_ -> decode.failure(CareteamstatusProposed, "Careteamstatus")}
  }
  
pub type Auditeventoutcome{Auditeventoutcome0
Auditeventoutcome4
Auditeventoutcome8
Auditeventoutcome12
}
pub fn auditeventoutcome_to_json(auditeventoutcome: Auditeventoutcome) -> Json {
    case auditeventoutcome {Auditeventoutcome0 -> json.string("0")
Auditeventoutcome4 -> json.string("4")
Auditeventoutcome8 -> json.string("8")
Auditeventoutcome12 -> json.string("12")
}
  }
  pub fn auditeventoutcome_decoder() -> Decoder(Auditeventoutcome) {
    use variant <- decode.then(decode.string)
    case variant {"0" -> decode.success(Auditeventoutcome0)
"4" -> decode.success(Auditeventoutcome4)
"8" -> decode.success(Auditeventoutcome8)
"12" -> decode.success(Auditeventoutcome12)
_ -> decode.failure(Auditeventoutcome0, "Auditeventoutcome")}
  }
  
pub type Mapcontexttype{MapcontexttypeType
MapcontexttypeVariable
}
pub fn mapcontexttype_to_json(mapcontexttype: Mapcontexttype) -> Json {
    case mapcontexttype {MapcontexttypeType -> json.string("type")
MapcontexttypeVariable -> json.string("variable")
}
  }
  pub fn mapcontexttype_decoder() -> Decoder(Mapcontexttype) {
    use variant <- decode.then(decode.string)
    case variant {"type" -> decode.success(MapcontexttypeType)
"variable" -> decode.success(MapcontexttypeVariable)
_ -> decode.failure(MapcontexttypeType, "Mapcontexttype")}
  }
  
pub type Medicationstatementstatus{MedicationstatementstatusActive
MedicationstatementstatusCompleted
MedicationstatementstatusEnteredinerror
MedicationstatementstatusIntended
MedicationstatementstatusStopped
MedicationstatementstatusOnhold
MedicationstatementstatusUnknown
MedicationstatementstatusNottaken
}
pub fn medicationstatementstatus_to_json(medicationstatementstatus: Medicationstatementstatus) -> Json {
    case medicationstatementstatus {MedicationstatementstatusActive -> json.string("active")
MedicationstatementstatusCompleted -> json.string("completed")
MedicationstatementstatusEnteredinerror -> json.string("entered-in-error")
MedicationstatementstatusIntended -> json.string("intended")
MedicationstatementstatusStopped -> json.string("stopped")
MedicationstatementstatusOnhold -> json.string("on-hold")
MedicationstatementstatusUnknown -> json.string("unknown")
MedicationstatementstatusNottaken -> json.string("not-taken")
}
  }
  pub fn medicationstatementstatus_decoder() -> Decoder(Medicationstatementstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(MedicationstatementstatusActive)
"completed" -> decode.success(MedicationstatementstatusCompleted)
"entered-in-error" -> decode.success(MedicationstatementstatusEnteredinerror)
"intended" -> decode.success(MedicationstatementstatusIntended)
"stopped" -> decode.success(MedicationstatementstatusStopped)
"on-hold" -> decode.success(MedicationstatementstatusOnhold)
"unknown" -> decode.success(MedicationstatementstatusUnknown)
"not-taken" -> decode.success(MedicationstatementstatusNottaken)
_ -> decode.failure(MedicationstatementstatusActive, "Medicationstatementstatus")}
  }
  
pub type Mapgrouptypemode{MapgrouptypemodeNone
MapgrouptypemodeTypes
MapgrouptypemodeTypeandtypes
}
pub fn mapgrouptypemode_to_json(mapgrouptypemode: Mapgrouptypemode) -> Json {
    case mapgrouptypemode {MapgrouptypemodeNone -> json.string("none")
MapgrouptypemodeTypes -> json.string("types")
MapgrouptypemodeTypeandtypes -> json.string("type-and-types")
}
  }
  pub fn mapgrouptypemode_decoder() -> Decoder(Mapgrouptypemode) {
    use variant <- decode.then(decode.string)
    case variant {"none" -> decode.success(MapgrouptypemodeNone)
"types" -> decode.success(MapgrouptypemodeTypes)
"type-and-types" -> decode.success(MapgrouptypemodeTypeandtypes)
_ -> decode.failure(MapgrouptypemodeNone, "Mapgrouptypemode")}
  }
  
pub type Allergyintolerancetype{AllergyintolerancetypeAllergy
AllergyintolerancetypeIntolerance
}
pub fn allergyintolerancetype_to_json(allergyintolerancetype: Allergyintolerancetype) -> Json {
    case allergyintolerancetype {AllergyintolerancetypeAllergy -> json.string("allergy")
AllergyintolerancetypeIntolerance -> json.string("intolerance")
}
  }
  pub fn allergyintolerancetype_decoder() -> Decoder(Allergyintolerancetype) {
    use variant <- decode.then(decode.string)
    case variant {"allergy" -> decode.success(AllergyintolerancetypeAllergy)
"intolerance" -> decode.success(AllergyintolerancetypeIntolerance)
_ -> decode.failure(AllergyintolerancetypeAllergy, "Allergyintolerancetype")}
  }
  
pub type Groupmeasure{GroupmeasureMean
GroupmeasureMedian
GroupmeasureMeanofmean
GroupmeasureMeanofmedian
GroupmeasureMedianofmean
GroupmeasureMedianofmedian
}
pub fn groupmeasure_to_json(groupmeasure: Groupmeasure) -> Json {
    case groupmeasure {GroupmeasureMean -> json.string("mean")
GroupmeasureMedian -> json.string("median")
GroupmeasureMeanofmean -> json.string("mean-of-mean")
GroupmeasureMeanofmedian -> json.string("mean-of-median")
GroupmeasureMedianofmean -> json.string("median-of-mean")
GroupmeasureMedianofmedian -> json.string("median-of-median")
}
  }
  pub fn groupmeasure_decoder() -> Decoder(Groupmeasure) {
    use variant <- decode.then(decode.string)
    case variant {"mean" -> decode.success(GroupmeasureMean)
"median" -> decode.success(GroupmeasureMedian)
"mean-of-mean" -> decode.success(GroupmeasureMeanofmean)
"mean-of-median" -> decode.success(GroupmeasureMeanofmedian)
"median-of-mean" -> decode.success(GroupmeasureMedianofmean)
"median-of-median" -> decode.success(GroupmeasureMedianofmedian)
_ -> decode.failure(GroupmeasureMean, "Groupmeasure")}
  }
  
pub type Operationparameteruse{OperationparameteruseIn
OperationparameteruseOut
}
pub fn operationparameteruse_to_json(operationparameteruse: Operationparameteruse) -> Json {
    case operationparameteruse {OperationparameteruseIn -> json.string("in")
OperationparameteruseOut -> json.string("out")
}
  }
  pub fn operationparameteruse_decoder() -> Decoder(Operationparameteruse) {
    use variant <- decode.then(decode.string)
    case variant {"in" -> decode.success(OperationparameteruseIn)
"out" -> decode.success(OperationparameteruseOut)
_ -> decode.failure(OperationparameteruseIn, "Operationparameteruse")}
  }
  
pub type Codesearchsupport{CodesearchsupportExplicit
CodesearchsupportAll
}
pub fn codesearchsupport_to_json(codesearchsupport: Codesearchsupport) -> Json {
    case codesearchsupport {CodesearchsupportExplicit -> json.string("explicit")
CodesearchsupportAll -> json.string("all")
}
  }
  pub fn codesearchsupport_decoder() -> Decoder(Codesearchsupport) {
    use variant <- decode.then(decode.string)
    case variant {"explicit" -> decode.success(CodesearchsupportExplicit)
"all" -> decode.success(CodesearchsupportAll)
_ -> decode.failure(CodesearchsupportExplicit, "Codesearchsupport")}
  }
  
pub type Devicenametype{DevicenametypeUdilabelname
DevicenametypeUserfriendlyname
DevicenametypePatientreportedname
DevicenametypeManufacturername
DevicenametypeModelname
DevicenametypeOther
}
pub fn devicenametype_to_json(devicenametype: Devicenametype) -> Json {
    case devicenametype {DevicenametypeUdilabelname -> json.string("udi-label-name")
DevicenametypeUserfriendlyname -> json.string("user-friendly-name")
DevicenametypePatientreportedname -> json.string("patient-reported-name")
DevicenametypeManufacturername -> json.string("manufacturer-name")
DevicenametypeModelname -> json.string("model-name")
DevicenametypeOther -> json.string("other")
}
  }
  pub fn devicenametype_decoder() -> Decoder(Devicenametype) {
    use variant <- decode.then(decode.string)
    case variant {"udi-label-name" -> decode.success(DevicenametypeUdilabelname)
"user-friendly-name" -> decode.success(DevicenametypeUserfriendlyname)
"patient-reported-name" -> decode.success(DevicenametypePatientreportedname)
"manufacturer-name" -> decode.success(DevicenametypeManufacturername)
"model-name" -> decode.success(DevicenametypeModelname)
"other" -> decode.success(DevicenametypeOther)
_ -> decode.failure(DevicenametypeUdilabelname, "Devicenametype")}
  }
  
pub type Encounterlocationstatus{EncounterlocationstatusPlanned
EncounterlocationstatusActive
EncounterlocationstatusReserved
EncounterlocationstatusCompleted
}
pub fn encounterlocationstatus_to_json(encounterlocationstatus: Encounterlocationstatus) -> Json {
    case encounterlocationstatus {EncounterlocationstatusPlanned -> json.string("planned")
EncounterlocationstatusActive -> json.string("active")
EncounterlocationstatusReserved -> json.string("reserved")
EncounterlocationstatusCompleted -> json.string("completed")
}
  }
  pub fn encounterlocationstatus_decoder() -> Decoder(Encounterlocationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"planned" -> decode.success(EncounterlocationstatusPlanned)
"active" -> decode.success(EncounterlocationstatusActive)
"reserved" -> decode.success(EncounterlocationstatusReserved)
"completed" -> decode.success(EncounterlocationstatusCompleted)
_ -> decode.failure(EncounterlocationstatusPlanned, "Encounterlocationstatus")}
  }
  
pub type Examplescenarioactortype{ExamplescenarioactortypePerson
ExamplescenarioactortypeEntity
}
pub fn examplescenarioactortype_to_json(examplescenarioactortype: Examplescenarioactortype) -> Json {
    case examplescenarioactortype {ExamplescenarioactortypePerson -> json.string("person")
ExamplescenarioactortypeEntity -> json.string("entity")
}
  }
  pub fn examplescenarioactortype_decoder() -> Decoder(Examplescenarioactortype) {
    use variant <- decode.then(decode.string)
    case variant {"person" -> decode.success(ExamplescenarioactortypePerson)
"entity" -> decode.success(ExamplescenarioactortypeEntity)
_ -> decode.failure(ExamplescenarioactortypePerson, "Examplescenarioactortype")}
  }
  
pub type Careplanactivitykind{CareplanactivitykindAppointment
CareplanactivitykindCommunicationrequest
CareplanactivitykindDevicerequest
CareplanactivitykindMedicationrequest
CareplanactivitykindNutritionorder
CareplanactivitykindTask
CareplanactivitykindServicerequest
CareplanactivitykindVisionprescription
}
pub fn careplanactivitykind_to_json(careplanactivitykind: Careplanactivitykind) -> Json {
    case careplanactivitykind {CareplanactivitykindAppointment -> json.string("Appointment")
CareplanactivitykindCommunicationrequest -> json.string("CommunicationRequest")
CareplanactivitykindDevicerequest -> json.string("DeviceRequest")
CareplanactivitykindMedicationrequest -> json.string("MedicationRequest")
CareplanactivitykindNutritionorder -> json.string("NutritionOrder")
CareplanactivitykindTask -> json.string("Task")
CareplanactivitykindServicerequest -> json.string("ServiceRequest")
CareplanactivitykindVisionprescription -> json.string("VisionPrescription")
}
  }
  pub fn careplanactivitykind_decoder() -> Decoder(Careplanactivitykind) {
    use variant <- decode.then(decode.string)
    case variant {"Appointment" -> decode.success(CareplanactivitykindAppointment)
"CommunicationRequest" -> decode.success(CareplanactivitykindCommunicationrequest)
"DeviceRequest" -> decode.success(CareplanactivitykindDevicerequest)
"MedicationRequest" -> decode.success(CareplanactivitykindMedicationrequest)
"NutritionOrder" -> decode.success(CareplanactivitykindNutritionorder)
"Task" -> decode.success(CareplanactivitykindTask)
"ServiceRequest" -> decode.success(CareplanactivitykindServicerequest)
"VisionPrescription" -> decode.success(CareplanactivitykindVisionprescription)
_ -> decode.failure(CareplanactivitykindAppointment, "Careplanactivitykind")}
  }
  
pub type Reportrelationtype{ReportrelationtypeReplaces
ReportrelationtypeAmends
ReportrelationtypeAppends
ReportrelationtypeTransforms
ReportrelationtypeReplacedwith
ReportrelationtypeAmendedwith
ReportrelationtypeAppendedwith
ReportrelationtypeTransformedwith
}
pub fn reportrelationtype_to_json(reportrelationtype: Reportrelationtype) -> Json {
    case reportrelationtype {ReportrelationtypeReplaces -> json.string("replaces")
ReportrelationtypeAmends -> json.string("amends")
ReportrelationtypeAppends -> json.string("appends")
ReportrelationtypeTransforms -> json.string("transforms")
ReportrelationtypeReplacedwith -> json.string("replacedWith")
ReportrelationtypeAmendedwith -> json.string("amendedWith")
ReportrelationtypeAppendedwith -> json.string("appendedWith")
ReportrelationtypeTransformedwith -> json.string("transformedWith")
}
  }
  pub fn reportrelationtype_decoder() -> Decoder(Reportrelationtype) {
    use variant <- decode.then(decode.string)
    case variant {"replaces" -> decode.success(ReportrelationtypeReplaces)
"amends" -> decode.success(ReportrelationtypeAmends)
"appends" -> decode.success(ReportrelationtypeAppends)
"transforms" -> decode.success(ReportrelationtypeTransforms)
"replacedWith" -> decode.success(ReportrelationtypeReplacedwith)
"amendedWith" -> decode.success(ReportrelationtypeAmendedwith)
"appendedWith" -> decode.success(ReportrelationtypeAppendedwith)
"transformedWith" -> decode.success(ReportrelationtypeTransformedwith)
_ -> decode.failure(ReportrelationtypeReplaces, "Reportrelationtype")}
  }
  
pub type Filteroperator{FilteroperatorEqual
FilteroperatorIsa
FilteroperatorDescendentof
FilteroperatorIsnota
FilteroperatorRegex
FilteroperatorIn
FilteroperatorNotin
FilteroperatorGeneralizes
FilteroperatorExists
}
pub fn filteroperator_to_json(filteroperator: Filteroperator) -> Json {
    case filteroperator {FilteroperatorEqual -> json.string("=")
FilteroperatorIsa -> json.string("is-a")
FilteroperatorDescendentof -> json.string("descendent-of")
FilteroperatorIsnota -> json.string("is-not-a")
FilteroperatorRegex -> json.string("regex")
FilteroperatorIn -> json.string("in")
FilteroperatorNotin -> json.string("not-in")
FilteroperatorGeneralizes -> json.string("generalizes")
FilteroperatorExists -> json.string("exists")
}
  }
  pub fn filteroperator_decoder() -> Decoder(Filteroperator) {
    use variant <- decode.then(decode.string)
    case variant {"=" -> decode.success(FilteroperatorEqual)
"is-a" -> decode.success(FilteroperatorIsa)
"descendent-of" -> decode.success(FilteroperatorDescendentof)
"is-not-a" -> decode.success(FilteroperatorIsnota)
"regex" -> decode.success(FilteroperatorRegex)
"in" -> decode.success(FilteroperatorIn)
"not-in" -> decode.success(FilteroperatorNotin)
"generalizes" -> decode.success(FilteroperatorGeneralizes)
"exists" -> decode.success(FilteroperatorExists)
_ -> decode.failure(FilteroperatorEqual, "Filteroperator")}
  }
  
pub type Adverseeventactuality{AdverseeventactualityActual
AdverseeventactualityPotential
}
pub fn adverseeventactuality_to_json(adverseeventactuality: Adverseeventactuality) -> Json {
    case adverseeventactuality {AdverseeventactualityActual -> json.string("actual")
AdverseeventactualityPotential -> json.string("potential")
}
  }
  pub fn adverseeventactuality_decoder() -> Decoder(Adverseeventactuality) {
    use variant <- decode.then(decode.string)
    case variant {"actual" -> decode.success(AdverseeventactualityActual)
"potential" -> decode.success(AdverseeventactualityPotential)
_ -> decode.failure(AdverseeventactualityActual, "Adverseeventactuality")}
  }
  
pub type Actionselectionbehavior{ActionselectionbehaviorAny
ActionselectionbehaviorAll
ActionselectionbehaviorAllornone
ActionselectionbehaviorExactlyone
ActionselectionbehaviorAtmostone
ActionselectionbehaviorOneormore
}
pub fn actionselectionbehavior_to_json(actionselectionbehavior: Actionselectionbehavior) -> Json {
    case actionselectionbehavior {ActionselectionbehaviorAny -> json.string("any")
ActionselectionbehaviorAll -> json.string("all")
ActionselectionbehaviorAllornone -> json.string("all-or-none")
ActionselectionbehaviorExactlyone -> json.string("exactly-one")
ActionselectionbehaviorAtmostone -> json.string("at-most-one")
ActionselectionbehaviorOneormore -> json.string("one-or-more")
}
  }
  pub fn actionselectionbehavior_decoder() -> Decoder(Actionselectionbehavior) {
    use variant <- decode.then(decode.string)
    case variant {"any" -> decode.success(ActionselectionbehaviorAny)
"all" -> decode.success(ActionselectionbehaviorAll)
"all-or-none" -> decode.success(ActionselectionbehaviorAllornone)
"exactly-one" -> decode.success(ActionselectionbehaviorExactlyone)
"at-most-one" -> decode.success(ActionselectionbehaviorAtmostone)
"one-or-more" -> decode.success(ActionselectionbehaviorOneormore)
_ -> decode.failure(ActionselectionbehaviorAny, "Actionselectionbehavior")}
  }
  
pub type Variabletype{VariabletypeDichotomous
VariabletypeContinuous
VariabletypeDescriptive
}
pub fn variabletype_to_json(variabletype: Variabletype) -> Json {
    case variabletype {VariabletypeDichotomous -> json.string("dichotomous")
VariabletypeContinuous -> json.string("continuous")
VariabletypeDescriptive -> json.string("descriptive")
}
  }
  pub fn variabletype_decoder() -> Decoder(Variabletype) {
    use variant <- decode.then(decode.string)
    case variant {"dichotomous" -> decode.success(VariabletypeDichotomous)
"continuous" -> decode.success(VariabletypeContinuous)
"descriptive" -> decode.success(VariabletypeDescriptive)
_ -> decode.failure(VariabletypeDichotomous, "Variabletype")}
  }
  
pub type Subscriptionstatus{SubscriptionstatusRequested
SubscriptionstatusActive
SubscriptionstatusError
SubscriptionstatusOff
}
pub fn subscriptionstatus_to_json(subscriptionstatus: Subscriptionstatus) -> Json {
    case subscriptionstatus {SubscriptionstatusRequested -> json.string("requested")
SubscriptionstatusActive -> json.string("active")
SubscriptionstatusError -> json.string("error")
SubscriptionstatusOff -> json.string("off")
}
  }
  pub fn subscriptionstatus_decoder() -> Decoder(Subscriptionstatus) {
    use variant <- decode.then(decode.string)
    case variant {"requested" -> decode.success(SubscriptionstatusRequested)
"active" -> decode.success(SubscriptionstatusActive)
"error" -> decode.success(SubscriptionstatusError)
"off" -> decode.success(SubscriptionstatusOff)
_ -> decode.failure(SubscriptionstatusRequested, "Subscriptionstatus")}
  }
  
pub type Actionconditionkind{ActionconditionkindApplicability
ActionconditionkindStart
ActionconditionkindStop
}
pub fn actionconditionkind_to_json(actionconditionkind: Actionconditionkind) -> Json {
    case actionconditionkind {ActionconditionkindApplicability -> json.string("applicability")
ActionconditionkindStart -> json.string("start")
ActionconditionkindStop -> json.string("stop")
}
  }
  pub fn actionconditionkind_decoder() -> Decoder(Actionconditionkind) {
    use variant <- decode.then(decode.string)
    case variant {"applicability" -> decode.success(ActionconditionkindApplicability)
"start" -> decode.success(ActionconditionkindStart)
"stop" -> decode.success(ActionconditionkindStop)
_ -> decode.failure(ActionconditionkindApplicability, "Actionconditionkind")}
  }
  
pub type Compartmenttype{CompartmenttypePatient
CompartmenttypeEncounter
CompartmenttypeRelatedperson
CompartmenttypePractitioner
CompartmenttypeDevice
}
pub fn compartmenttype_to_json(compartmenttype: Compartmenttype) -> Json {
    case compartmenttype {CompartmenttypePatient -> json.string("Patient")
CompartmenttypeEncounter -> json.string("Encounter")
CompartmenttypeRelatedperson -> json.string("RelatedPerson")
CompartmenttypePractitioner -> json.string("Practitioner")
CompartmenttypeDevice -> json.string("Device")
}
  }
  pub fn compartmenttype_decoder() -> Decoder(Compartmenttype) {
    use variant <- decode.then(decode.string)
    case variant {"Patient" -> decode.success(CompartmenttypePatient)
"Encounter" -> decode.success(CompartmenttypeEncounter)
"RelatedPerson" -> decode.success(CompartmenttypeRelatedperson)
"Practitioner" -> decode.success(CompartmenttypePractitioner)
"Device" -> decode.success(CompartmenttypeDevice)
_ -> decode.failure(CompartmenttypePatient, "Compartmenttype")}
  }
  
pub type Observationrangecategory{ObservationrangecategoryReference
ObservationrangecategoryCritical
ObservationrangecategoryAbsolute
}
pub fn observationrangecategory_to_json(observationrangecategory: Observationrangecategory) -> Json {
    case observationrangecategory {ObservationrangecategoryReference -> json.string("reference")
ObservationrangecategoryCritical -> json.string("critical")
ObservationrangecategoryAbsolute -> json.string("absolute")
}
  }
  pub fn observationrangecategory_decoder() -> Decoder(Observationrangecategory) {
    use variant <- decode.then(decode.string)
    case variant {"reference" -> decode.success(ObservationrangecategoryReference)
"critical" -> decode.success(ObservationrangecategoryCritical)
"absolute" -> decode.success(ObservationrangecategoryAbsolute)
_ -> decode.failure(ObservationrangecategoryReference, "Observationrangecategory")}
  }
  
pub type Conceptmapequivalence{ConceptmapequivalenceRelatedto
ConceptmapequivalenceUnmatched
}
pub fn conceptmapequivalence_to_json(conceptmapequivalence: Conceptmapequivalence) -> Json {
    case conceptmapequivalence {ConceptmapequivalenceRelatedto -> json.string("relatedto")
ConceptmapequivalenceUnmatched -> json.string("unmatched")
}
  }
  pub fn conceptmapequivalence_decoder() -> Decoder(Conceptmapequivalence) {
    use variant <- decode.then(decode.string)
    case variant {"relatedto" -> decode.success(ConceptmapequivalenceRelatedto)
"unmatched" -> decode.success(ConceptmapequivalenceUnmatched)
_ -> decode.failure(ConceptmapequivalenceRelatedto, "Conceptmapequivalence")}
  }
  
pub type Udientrytype{UdientrytypeBarcode
UdientrytypeRfid
UdientrytypeManual
UdientrytypeCard
UdientrytypeSelfreported
UdientrytypeUnknown
}
pub fn udientrytype_to_json(udientrytype: Udientrytype) -> Json {
    case udientrytype {UdientrytypeBarcode -> json.string("barcode")
UdientrytypeRfid -> json.string("rfid")
UdientrytypeManual -> json.string("manual")
UdientrytypeCard -> json.string("card")
UdientrytypeSelfreported -> json.string("self-reported")
UdientrytypeUnknown -> json.string("unknown")
}
  }
  pub fn udientrytype_decoder() -> Decoder(Udientrytype) {
    use variant <- decode.then(decode.string)
    case variant {"barcode" -> decode.success(UdientrytypeBarcode)
"rfid" -> decode.success(UdientrytypeRfid)
"manual" -> decode.success(UdientrytypeManual)
"card" -> decode.success(UdientrytypeCard)
"self-reported" -> decode.success(UdientrytypeSelfreported)
"unknown" -> decode.success(UdientrytypeUnknown)
_ -> decode.failure(UdientrytypeBarcode, "Udientrytype")}
  }
  
pub type Actionparticipanttype{ActionparticipanttypePatient
ActionparticipanttypePractitioner
ActionparticipanttypeRelatedperson
ActionparticipanttypeDevice
}
pub fn actionparticipanttype_to_json(actionparticipanttype: Actionparticipanttype) -> Json {
    case actionparticipanttype {ActionparticipanttypePatient -> json.string("patient")
ActionparticipanttypePractitioner -> json.string("practitioner")
ActionparticipanttypeRelatedperson -> json.string("related-person")
ActionparticipanttypeDevice -> json.string("device")
}
  }
  pub fn actionparticipanttype_decoder() -> Decoder(Actionparticipanttype) {
    use variant <- decode.then(decode.string)
    case variant {"patient" -> decode.success(ActionparticipanttypePatient)
"practitioner" -> decode.success(ActionparticipanttypePractitioner)
"related-person" -> decode.success(ActionparticipanttypeRelatedperson)
"device" -> decode.success(ActionparticipanttypeDevice)
_ -> decode.failure(ActionparticipanttypePatient, "Actionparticipanttype")}
  }
  
pub type Appointmentstatus{AppointmentstatusProposed
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
    case appointmentstatus {AppointmentstatusProposed -> json.string("proposed")
AppointmentstatusPending -> json.string("pending")
AppointmentstatusBooked -> json.string("booked")
AppointmentstatusArrived -> json.string("arrived")
AppointmentstatusFulfilled -> json.string("fulfilled")
AppointmentstatusCancelled -> json.string("cancelled")
AppointmentstatusNoshow -> json.string("noshow")
AppointmentstatusEnteredinerror -> json.string("entered-in-error")
AppointmentstatusCheckedin -> json.string("checked-in")
AppointmentstatusWaitlist -> json.string("waitlist")
}
  }
  pub fn appointmentstatus_decoder() -> Decoder(Appointmentstatus) {
    use variant <- decode.then(decode.string)
    case variant {"proposed" -> decode.success(AppointmentstatusProposed)
"pending" -> decode.success(AppointmentstatusPending)
"booked" -> decode.success(AppointmentstatusBooked)
"arrived" -> decode.success(AppointmentstatusArrived)
"fulfilled" -> decode.success(AppointmentstatusFulfilled)
"cancelled" -> decode.success(AppointmentstatusCancelled)
"noshow" -> decode.success(AppointmentstatusNoshow)
"entered-in-error" -> decode.success(AppointmentstatusEnteredinerror)
"checked-in" -> decode.success(AppointmentstatusCheckedin)
"waitlist" -> decode.success(AppointmentstatusWaitlist)
_ -> decode.failure(AppointmentstatusProposed, "Appointmentstatus")}
  }
  
pub type Requestpriority{RequestpriorityRoutine
RequestpriorityUrgent
RequestpriorityAsap
RequestpriorityStat
}
pub fn requestpriority_to_json(requestpriority: Requestpriority) -> Json {
    case requestpriority {RequestpriorityRoutine -> json.string("routine")
RequestpriorityUrgent -> json.string("urgent")
RequestpriorityAsap -> json.string("asap")
RequestpriorityStat -> json.string("stat")
}
  }
  pub fn requestpriority_decoder() -> Decoder(Requestpriority) {
    use variant <- decode.then(decode.string)
    case variant {"routine" -> decode.success(RequestpriorityRoutine)
"urgent" -> decode.success(RequestpriorityUrgent)
"asap" -> decode.success(RequestpriorityAsap)
"stat" -> decode.success(RequestpriorityStat)
_ -> decode.failure(RequestpriorityRoutine, "Requestpriority")}
  }
  
pub type Responsecode{ResponsecodeOk
ResponsecodeTransienterror
ResponsecodeFatalerror
}
pub fn responsecode_to_json(responsecode: Responsecode) -> Json {
    case responsecode {ResponsecodeOk -> json.string("ok")
ResponsecodeTransienterror -> json.string("transient-error")
ResponsecodeFatalerror -> json.string("fatal-error")
}
  }
  pub fn responsecode_decoder() -> Decoder(Responsecode) {
    use variant <- decode.then(decode.string)
    case variant {"ok" -> decode.success(ResponsecodeOk)
"transient-error" -> decode.success(ResponsecodeTransienterror)
"fatal-error" -> decode.success(ResponsecodeFatalerror)
_ -> decode.failure(ResponsecodeOk, "Responsecode")}
  }
  
pub type Httpverb{HttpverbGet
HttpverbHead
HttpverbPost
HttpverbPut
HttpverbDelete
HttpverbPatch
}
pub fn httpverb_to_json(httpverb: Httpverb) -> Json {
    case httpverb {HttpverbGet -> json.string("GET")
HttpverbHead -> json.string("HEAD")
HttpverbPost -> json.string("POST")
HttpverbPut -> json.string("PUT")
HttpverbDelete -> json.string("DELETE")
HttpverbPatch -> json.string("PATCH")
}
  }
  pub fn httpverb_decoder() -> Decoder(Httpverb) {
    use variant <- decode.then(decode.string)
    case variant {"GET" -> decode.success(HttpverbGet)
"HEAD" -> decode.success(HttpverbHead)
"POST" -> decode.success(HttpverbPost)
"PUT" -> decode.success(HttpverbPut)
"DELETE" -> decode.success(HttpverbDelete)
"PATCH" -> decode.success(HttpverbPatch)
_ -> decode.failure(HttpverbGet, "Httpverb")}
  }
  
pub type Codesystemhierarchymeaning{CodesystemhierarchymeaningGroupedby
CodesystemhierarchymeaningIsa
CodesystemhierarchymeaningPartof
CodesystemhierarchymeaningClassifiedwith
}
pub fn codesystemhierarchymeaning_to_json(codesystemhierarchymeaning: Codesystemhierarchymeaning) -> Json {
    case codesystemhierarchymeaning {CodesystemhierarchymeaningGroupedby -> json.string("grouped-by")
CodesystemhierarchymeaningIsa -> json.string("is-a")
CodesystemhierarchymeaningPartof -> json.string("part-of")
CodesystemhierarchymeaningClassifiedwith -> json.string("classified-with")
}
  }
  pub fn codesystemhierarchymeaning_decoder() -> Decoder(Codesystemhierarchymeaning) {
    use variant <- decode.then(decode.string)
    case variant {"grouped-by" -> decode.success(CodesystemhierarchymeaningGroupedby)
"is-a" -> decode.success(CodesystemhierarchymeaningIsa)
"part-of" -> decode.success(CodesystemhierarchymeaningPartof)
"classified-with" -> decode.success(CodesystemhierarchymeaningClassifiedwith)
_ -> decode.failure(CodesystemhierarchymeaningGroupedby, "Codesystemhierarchymeaning")}
  }
  
pub type Contractstatus{ContractstatusAmended
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
    case contractstatus {ContractstatusAmended -> json.string("amended")
ContractstatusAppended -> json.string("appended")
ContractstatusCancelled -> json.string("cancelled")
ContractstatusDisputed -> json.string("disputed")
ContractstatusEnteredinerror -> json.string("entered-in-error")
ContractstatusExecutable -> json.string("executable")
ContractstatusExecuted -> json.string("executed")
ContractstatusNegotiable -> json.string("negotiable")
ContractstatusOffered -> json.string("offered")
ContractstatusPolicy -> json.string("policy")
ContractstatusRejected -> json.string("rejected")
ContractstatusRenewed -> json.string("renewed")
ContractstatusRevoked -> json.string("revoked")
ContractstatusResolved -> json.string("resolved")
ContractstatusTerminated -> json.string("terminated")
}
  }
  pub fn contractstatus_decoder() -> Decoder(Contractstatus) {
    use variant <- decode.then(decode.string)
    case variant {"amended" -> decode.success(ContractstatusAmended)
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
_ -> decode.failure(ContractstatusAmended, "Contractstatus")}
  }
  
pub type Unitsoftime{UnitsoftimeS
UnitsoftimeMin
UnitsoftimeH
UnitsoftimeD
UnitsoftimeWk
UnitsoftimeMo
UnitsoftimeA
}
pub fn unitsoftime_to_json(unitsoftime: Unitsoftime) -> Json {
    case unitsoftime {UnitsoftimeS -> json.string("s")
UnitsoftimeMin -> json.string("min")
UnitsoftimeH -> json.string("h")
UnitsoftimeD -> json.string("d")
UnitsoftimeWk -> json.string("wk")
UnitsoftimeMo -> json.string("mo")
UnitsoftimeA -> json.string("a")
}
  }
  pub fn unitsoftime_decoder() -> Decoder(Unitsoftime) {
    use variant <- decode.then(decode.string)
    case variant {"s" -> decode.success(UnitsoftimeS)
"min" -> decode.success(UnitsoftimeMin)
"h" -> decode.success(UnitsoftimeH)
"d" -> decode.success(UnitsoftimeD)
"wk" -> decode.success(UnitsoftimeWk)
"mo" -> decode.success(UnitsoftimeMo)
"a" -> decode.success(UnitsoftimeA)
_ -> decode.failure(UnitsoftimeS, "Unitsoftime")}
  }
  
pub type Flagstatus{FlagstatusActive
FlagstatusInactive
FlagstatusEnteredinerror
}
pub fn flagstatus_to_json(flagstatus: Flagstatus) -> Json {
    case flagstatus {FlagstatusActive -> json.string("active")
FlagstatusInactive -> json.string("inactive")
FlagstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn flagstatus_decoder() -> Decoder(Flagstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(FlagstatusActive)
"inactive" -> decode.success(FlagstatusInactive)
"entered-in-error" -> decode.success(FlagstatusEnteredinerror)
_ -> decode.failure(FlagstatusActive, "Flagstatus")}
  }
  
pub type Medicationknowledgestatus{MedicationknowledgestatusActive
MedicationknowledgestatusInactive
MedicationknowledgestatusEnteredinerror
}
pub fn medicationknowledgestatus_to_json(medicationknowledgestatus: Medicationknowledgestatus) -> Json {
    case medicationknowledgestatus {MedicationknowledgestatusActive -> json.string("active")
MedicationknowledgestatusInactive -> json.string("inactive")
MedicationknowledgestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn medicationknowledgestatus_decoder() -> Decoder(Medicationknowledgestatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(MedicationknowledgestatusActive)
"inactive" -> decode.success(MedicationknowledgestatusInactive)
"entered-in-error" -> decode.success(MedicationknowledgestatusEnteredinerror)
_ -> decode.failure(MedicationknowledgestatusActive, "Medicationknowledgestatus")}
  }
  
pub type Taskintent{TaskintentUnknown
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
    case taskintent {TaskintentUnknown -> json.string("unknown")
TaskintentProposal -> json.string("proposal")
TaskintentPlan -> json.string("plan")
TaskintentOrder -> json.string("order")
TaskintentOriginalorder -> json.string("original-order")
TaskintentReflexorder -> json.string("reflex-order")
TaskintentFillerorder -> json.string("filler-order")
TaskintentInstanceorder -> json.string("instance-order")
TaskintentOption -> json.string("option")
}
  }
  pub fn taskintent_decoder() -> Decoder(Taskintent) {
    use variant <- decode.then(decode.string)
    case variant {"unknown" -> decode.success(TaskintentUnknown)
"proposal" -> decode.success(TaskintentProposal)
"plan" -> decode.success(TaskintentPlan)
"order" -> decode.success(TaskintentOrder)
"original-order" -> decode.success(TaskintentOriginalorder)
"reflex-order" -> decode.success(TaskintentReflexorder)
"filler-order" -> decode.success(TaskintentFillerorder)
"instance-order" -> decode.success(TaskintentInstanceorder)
"option" -> decode.success(TaskintentOption)
_ -> decode.failure(TaskintentUnknown, "Taskintent")}
  }
  
pub type Productstatus{ProductstatusAvailable
ProductstatusUnavailable
}
pub fn productstatus_to_json(productstatus: Productstatus) -> Json {
    case productstatus {ProductstatusAvailable -> json.string("available")
ProductstatusUnavailable -> json.string("unavailable")
}
  }
  pub fn productstatus_decoder() -> Decoder(Productstatus) {
    use variant <- decode.then(decode.string)
    case variant {"available" -> decode.success(ProductstatusAvailable)
"unavailable" -> decode.success(ProductstatusUnavailable)
_ -> decode.failure(ProductstatusAvailable, "Productstatus")}
  }
  
pub type Measurereporttype{MeasurereporttypeIndividual
MeasurereporttypeSubjectlist
MeasurereporttypeSummary
MeasurereporttypeDatacollection
}
pub fn measurereporttype_to_json(measurereporttype: Measurereporttype) -> Json {
    case measurereporttype {MeasurereporttypeIndividual -> json.string("individual")
MeasurereporttypeSubjectlist -> json.string("subject-list")
MeasurereporttypeSummary -> json.string("summary")
MeasurereporttypeDatacollection -> json.string("data-collection")
}
  }
  pub fn measurereporttype_decoder() -> Decoder(Measurereporttype) {
    use variant <- decode.then(decode.string)
    case variant {"individual" -> decode.success(MeasurereporttypeIndividual)
"subject-list" -> decode.success(MeasurereporttypeSubjectlist)
"summary" -> decode.success(MeasurereporttypeSummary)
"data-collection" -> decode.success(MeasurereporttypeDatacollection)
_ -> decode.failure(MeasurereporttypeIndividual, "Measurereporttype")}
  }
  
pub type Messageheaderresponserequest{MessageheaderresponserequestAlways
MessageheaderresponserequestOnerror
MessageheaderresponserequestNever
MessageheaderresponserequestOnsuccess
}
pub fn messageheaderresponserequest_to_json(messageheaderresponserequest: Messageheaderresponserequest) -> Json {
    case messageheaderresponserequest {MessageheaderresponserequestAlways -> json.string("always")
MessageheaderresponserequestOnerror -> json.string("on-error")
MessageheaderresponserequestNever -> json.string("never")
MessageheaderresponserequestOnsuccess -> json.string("on-success")
}
  }
  pub fn messageheaderresponserequest_decoder() -> Decoder(Messageheaderresponserequest) {
    use variant <- decode.then(decode.string)
    case variant {"always" -> decode.success(MessageheaderresponserequestAlways)
"on-error" -> decode.success(MessageheaderresponserequestOnerror)
"never" -> decode.success(MessageheaderresponserequestNever)
"on-success" -> decode.success(MessageheaderresponserequestOnsuccess)
_ -> decode.failure(MessageheaderresponserequestAlways, "Messageheaderresponserequest")}
  }
  
pub type Documentmode{DocumentmodeProducer
DocumentmodeConsumer
}
pub fn documentmode_to_json(documentmode: Documentmode) -> Json {
    case documentmode {DocumentmodeProducer -> json.string("producer")
DocumentmodeConsumer -> json.string("consumer")
}
  }
  pub fn documentmode_decoder() -> Decoder(Documentmode) {
    use variant <- decode.then(decode.string)
    case variant {"producer" -> decode.success(DocumentmodeProducer)
"consumer" -> decode.success(DocumentmodeConsumer)
_ -> decode.failure(DocumentmodeProducer, "Documentmode")}
  }
  
pub type Guidepagegeneration{GuidepagegenerationHtml
GuidepagegenerationMarkdown
GuidepagegenerationXml
GuidepagegenerationGenerated
}
pub fn guidepagegeneration_to_json(guidepagegeneration: Guidepagegeneration) -> Json {
    case guidepagegeneration {GuidepagegenerationHtml -> json.string("html")
GuidepagegenerationMarkdown -> json.string("markdown")
GuidepagegenerationXml -> json.string("xml")
GuidepagegenerationGenerated -> json.string("generated")
}
  }
  pub fn guidepagegeneration_decoder() -> Decoder(Guidepagegeneration) {
    use variant <- decode.then(decode.string)
    case variant {"html" -> decode.success(GuidepagegenerationHtml)
"markdown" -> decode.success(GuidepagegenerationMarkdown)
"xml" -> decode.success(GuidepagegenerationXml)
"generated" -> decode.success(GuidepagegenerationGenerated)
_ -> decode.failure(GuidepagegenerationHtml, "Guidepagegeneration")}
  }
  
pub type Contractpublicationstatus{ContractpublicationstatusAmended
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
pub fn contractpublicationstatus_to_json(contractpublicationstatus: Contractpublicationstatus) -> Json {
    case contractpublicationstatus {ContractpublicationstatusAmended -> json.string("amended")
ContractpublicationstatusAppended -> json.string("appended")
ContractpublicationstatusCancelled -> json.string("cancelled")
ContractpublicationstatusDisputed -> json.string("disputed")
ContractpublicationstatusEnteredinerror -> json.string("entered-in-error")
ContractpublicationstatusExecutable -> json.string("executable")
ContractpublicationstatusExecuted -> json.string("executed")
ContractpublicationstatusNegotiable -> json.string("negotiable")
ContractpublicationstatusOffered -> json.string("offered")
ContractpublicationstatusPolicy -> json.string("policy")
ContractpublicationstatusRejected -> json.string("rejected")
ContractpublicationstatusRenewed -> json.string("renewed")
ContractpublicationstatusRevoked -> json.string("revoked")
ContractpublicationstatusResolved -> json.string("resolved")
ContractpublicationstatusTerminated -> json.string("terminated")
}
  }
  pub fn contractpublicationstatus_decoder() -> Decoder(Contractpublicationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"amended" -> decode.success(ContractpublicationstatusAmended)
"appended" -> decode.success(ContractpublicationstatusAppended)
"cancelled" -> decode.success(ContractpublicationstatusCancelled)
"disputed" -> decode.success(ContractpublicationstatusDisputed)
"entered-in-error" -> decode.success(ContractpublicationstatusEnteredinerror)
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
_ -> decode.failure(ContractpublicationstatusAmended, "Contractpublicationstatus")}
  }
  
pub type Expressionlanguage{ExpressionlanguageTextcql
ExpressionlanguageTextfhirpath
ExpressionlanguageApplicationxfhirquery
ExpressionlanguageTextcqlidentifier
ExpressionlanguageTextcqlexpression
}
pub fn expressionlanguage_to_json(expressionlanguage: Expressionlanguage) -> Json {
    case expressionlanguage {ExpressionlanguageTextcql -> json.string("text/cql")
ExpressionlanguageTextfhirpath -> json.string("text/fhirpath")
ExpressionlanguageApplicationxfhirquery -> json.string("application/x-fhir-query")
ExpressionlanguageTextcqlidentifier -> json.string("text/cql-identifier")
ExpressionlanguageTextcqlexpression -> json.string("text/cql-expression")
}
  }
  pub fn expressionlanguage_decoder() -> Decoder(Expressionlanguage) {
    use variant <- decode.then(decode.string)
    case variant {"text/cql" -> decode.success(ExpressionlanguageTextcql)
"text/fhirpath" -> decode.success(ExpressionlanguageTextfhirpath)
"application/x-fhir-query" -> decode.success(ExpressionlanguageApplicationxfhirquery)
"text/cql-identifier" -> decode.success(ExpressionlanguageTextcqlidentifier)
"text/cql-expression" -> decode.success(ExpressionlanguageTextcqlexpression)
_ -> decode.failure(ExpressionlanguageTextcql, "Expressionlanguage")}
  }
  
pub type Spdxlicense{SpdxlicenseNotopensource
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
    case spdxlicense {SpdxlicenseNotopensource -> json.string("not-open-source")
Spdxlicense0bsd -> json.string("0BSD")
SpdxlicenseAal -> json.string("AAL")
SpdxlicenseAbstyles -> json.string("Abstyles")
SpdxlicenseAdobe2006 -> json.string("Adobe-2006")
SpdxlicenseAdobeglyph -> json.string("Adobe-Glyph")
SpdxlicenseAdsl -> json.string("ADSL")
SpdxlicenseAfl11 -> json.string("AFL-1.1")
SpdxlicenseAfl12 -> json.string("AFL-1.2")
SpdxlicenseAfl20 -> json.string("AFL-2.0")
SpdxlicenseAfl21 -> json.string("AFL-2.1")
SpdxlicenseAfl30 -> json.string("AFL-3.0")
SpdxlicenseAfmparse -> json.string("Afmparse")
SpdxlicenseAgpl10only -> json.string("AGPL-1.0-only")
SpdxlicenseAgpl10orlater -> json.string("AGPL-1.0-or-later")
SpdxlicenseAgpl30only -> json.string("AGPL-3.0-only")
SpdxlicenseAgpl30orlater -> json.string("AGPL-3.0-or-later")
SpdxlicenseAladdin -> json.string("Aladdin")
SpdxlicenseAmdplpa -> json.string("AMDPLPA")
SpdxlicenseAml -> json.string("AML")
SpdxlicenseAmpas -> json.string("AMPAS")
SpdxlicenseAntlrpd -> json.string("ANTLR-PD")
SpdxlicenseApache10 -> json.string("Apache-1.0")
SpdxlicenseApache11 -> json.string("Apache-1.1")
SpdxlicenseApache20 -> json.string("Apache-2.0")
SpdxlicenseApafml -> json.string("APAFML")
SpdxlicenseApl10 -> json.string("APL-1.0")
SpdxlicenseApsl10 -> json.string("APSL-1.0")
SpdxlicenseApsl11 -> json.string("APSL-1.1")
SpdxlicenseApsl12 -> json.string("APSL-1.2")
SpdxlicenseApsl20 -> json.string("APSL-2.0")
SpdxlicenseArtistic10cl8 -> json.string("Artistic-1.0-cl8")
SpdxlicenseArtistic10perl -> json.string("Artistic-1.0-Perl")
SpdxlicenseArtistic10 -> json.string("Artistic-1.0")
SpdxlicenseArtistic20 -> json.string("Artistic-2.0")
SpdxlicenseBahyph -> json.string("Bahyph")
SpdxlicenseBarr -> json.string("Barr")
SpdxlicenseBeerware -> json.string("Beerware")
SpdxlicenseBittorrent10 -> json.string("BitTorrent-1.0")
SpdxlicenseBittorrent11 -> json.string("BitTorrent-1.1")
SpdxlicenseBorceux -> json.string("Borceux")
SpdxlicenseBsd1clause -> json.string("BSD-1-Clause")
SpdxlicenseBsd2clausefreebsd -> json.string("BSD-2-Clause-FreeBSD")
SpdxlicenseBsd2clausenetbsd -> json.string("BSD-2-Clause-NetBSD")
SpdxlicenseBsd2clausepatent -> json.string("BSD-2-Clause-Patent")
SpdxlicenseBsd2clause -> json.string("BSD-2-Clause")
SpdxlicenseBsd3clauseattribution -> json.string("BSD-3-Clause-Attribution")
SpdxlicenseBsd3clauseclear -> json.string("BSD-3-Clause-Clear")
SpdxlicenseBsd3clauselbnl -> json.string("BSD-3-Clause-LBNL")
SpdxlicenseBsd3clausenonuclearlicense2014 -> json.string("BSD-3-Clause-No-Nuclear-License-2014")
SpdxlicenseBsd3clausenonuclearlicense -> json.string("BSD-3-Clause-No-Nuclear-License")
SpdxlicenseBsd3clausenonuclearwarranty -> json.string("BSD-3-Clause-No-Nuclear-Warranty")
SpdxlicenseBsd3clause -> json.string("BSD-3-Clause")
SpdxlicenseBsd4clauseuc -> json.string("BSD-4-Clause-UC")
SpdxlicenseBsd4clause -> json.string("BSD-4-Clause")
SpdxlicenseBsdprotection -> json.string("BSD-Protection")
SpdxlicenseBsdsourcecode -> json.string("BSD-Source-Code")
SpdxlicenseBsl10 -> json.string("BSL-1.0")
SpdxlicenseBzip2105 -> json.string("bzip2-1.0.5")
SpdxlicenseBzip2106 -> json.string("bzip2-1.0.6")
SpdxlicenseCaldera -> json.string("Caldera")
SpdxlicenseCatosl11 -> json.string("CATOSL-1.1")
SpdxlicenseCcby10 -> json.string("CC-BY-1.0")
SpdxlicenseCcby20 -> json.string("CC-BY-2.0")
SpdxlicenseCcby25 -> json.string("CC-BY-2.5")
SpdxlicenseCcby30 -> json.string("CC-BY-3.0")
SpdxlicenseCcby40 -> json.string("CC-BY-4.0")
SpdxlicenseCcbync10 -> json.string("CC-BY-NC-1.0")
SpdxlicenseCcbync20 -> json.string("CC-BY-NC-2.0")
SpdxlicenseCcbync25 -> json.string("CC-BY-NC-2.5")
SpdxlicenseCcbync30 -> json.string("CC-BY-NC-3.0")
SpdxlicenseCcbync40 -> json.string("CC-BY-NC-4.0")
SpdxlicenseCcbyncnd10 -> json.string("CC-BY-NC-ND-1.0")
SpdxlicenseCcbyncnd20 -> json.string("CC-BY-NC-ND-2.0")
SpdxlicenseCcbyncnd25 -> json.string("CC-BY-NC-ND-2.5")
SpdxlicenseCcbyncnd30 -> json.string("CC-BY-NC-ND-3.0")
SpdxlicenseCcbyncnd40 -> json.string("CC-BY-NC-ND-4.0")
SpdxlicenseCcbyncsa10 -> json.string("CC-BY-NC-SA-1.0")
SpdxlicenseCcbyncsa20 -> json.string("CC-BY-NC-SA-2.0")
SpdxlicenseCcbyncsa25 -> json.string("CC-BY-NC-SA-2.5")
SpdxlicenseCcbyncsa30 -> json.string("CC-BY-NC-SA-3.0")
SpdxlicenseCcbyncsa40 -> json.string("CC-BY-NC-SA-4.0")
SpdxlicenseCcbynd10 -> json.string("CC-BY-ND-1.0")
SpdxlicenseCcbynd20 -> json.string("CC-BY-ND-2.0")
SpdxlicenseCcbynd25 -> json.string("CC-BY-ND-2.5")
SpdxlicenseCcbynd30 -> json.string("CC-BY-ND-3.0")
SpdxlicenseCcbynd40 -> json.string("CC-BY-ND-4.0")
SpdxlicenseCcbysa10 -> json.string("CC-BY-SA-1.0")
SpdxlicenseCcbysa20 -> json.string("CC-BY-SA-2.0")
SpdxlicenseCcbysa25 -> json.string("CC-BY-SA-2.5")
SpdxlicenseCcbysa30 -> json.string("CC-BY-SA-3.0")
SpdxlicenseCcbysa40 -> json.string("CC-BY-SA-4.0")
SpdxlicenseCc010 -> json.string("CC0-1.0")
SpdxlicenseCddl10 -> json.string("CDDL-1.0")
SpdxlicenseCddl11 -> json.string("CDDL-1.1")
SpdxlicenseCdlapermissive10 -> json.string("CDLA-Permissive-1.0")
SpdxlicenseCdlasharing10 -> json.string("CDLA-Sharing-1.0")
SpdxlicenseCecill10 -> json.string("CECILL-1.0")
SpdxlicenseCecill11 -> json.string("CECILL-1.1")
SpdxlicenseCecill20 -> json.string("CECILL-2.0")
SpdxlicenseCecill21 -> json.string("CECILL-2.1")
SpdxlicenseCecillb -> json.string("CECILL-B")
SpdxlicenseCecillc -> json.string("CECILL-C")
SpdxlicenseClartistic -> json.string("ClArtistic")
SpdxlicenseCnrijython -> json.string("CNRI-Jython")
SpdxlicenseCnripythongplcompatible -> json.string("CNRI-Python-GPL-Compatible")
SpdxlicenseCnripython -> json.string("CNRI-Python")
SpdxlicenseCondor11 -> json.string("Condor-1.1")
SpdxlicenseCpal10 -> json.string("CPAL-1.0")
SpdxlicenseCpl10 -> json.string("CPL-1.0")
SpdxlicenseCpol102 -> json.string("CPOL-1.02")
SpdxlicenseCrossword -> json.string("Crossword")
SpdxlicenseCrystalstacker -> json.string("CrystalStacker")
SpdxlicenseCuaopl10 -> json.string("CUA-OPL-1.0")
SpdxlicenseCube -> json.string("Cube")
SpdxlicenseCurl -> json.string("curl")
SpdxlicenseDfsl10 -> json.string("D-FSL-1.0")
SpdxlicenseDiffmark -> json.string("diffmark")
SpdxlicenseDoc -> json.string("DOC")
SpdxlicenseDotseqn -> json.string("Dotseqn")
SpdxlicenseDsdp -> json.string("DSDP")
SpdxlicenseDvipdfm -> json.string("dvipdfm")
SpdxlicenseEcl10 -> json.string("ECL-1.0")
SpdxlicenseEcl20 -> json.string("ECL-2.0")
SpdxlicenseEfl10 -> json.string("EFL-1.0")
SpdxlicenseEfl20 -> json.string("EFL-2.0")
SpdxlicenseEgenix -> json.string("eGenix")
SpdxlicenseEntessa -> json.string("Entessa")
SpdxlicenseEpl10 -> json.string("EPL-1.0")
SpdxlicenseEpl20 -> json.string("EPL-2.0")
SpdxlicenseErlpl11 -> json.string("ErlPL-1.1")
SpdxlicenseEudatagrid -> json.string("EUDatagrid")
SpdxlicenseEupl10 -> json.string("EUPL-1.0")
SpdxlicenseEupl11 -> json.string("EUPL-1.1")
SpdxlicenseEupl12 -> json.string("EUPL-1.2")
SpdxlicenseEurosym -> json.string("Eurosym")
SpdxlicenseFair -> json.string("Fair")
SpdxlicenseFrameworx10 -> json.string("Frameworx-1.0")
SpdxlicenseFreeimage -> json.string("FreeImage")
SpdxlicenseFsfap -> json.string("FSFAP")
SpdxlicenseFsful -> json.string("FSFUL")
SpdxlicenseFsfullr -> json.string("FSFULLR")
SpdxlicenseFtl -> json.string("FTL")
SpdxlicenseGfdl11only -> json.string("GFDL-1.1-only")
SpdxlicenseGfdl11orlater -> json.string("GFDL-1.1-or-later")
SpdxlicenseGfdl12only -> json.string("GFDL-1.2-only")
SpdxlicenseGfdl12orlater -> json.string("GFDL-1.2-or-later")
SpdxlicenseGfdl13only -> json.string("GFDL-1.3-only")
SpdxlicenseGfdl13orlater -> json.string("GFDL-1.3-or-later")
SpdxlicenseGiftware -> json.string("Giftware")
SpdxlicenseGl2ps -> json.string("GL2PS")
SpdxlicenseGlide -> json.string("Glide")
SpdxlicenseGlulxe -> json.string("Glulxe")
SpdxlicenseGnuplot -> json.string("gnuplot")
SpdxlicenseGpl10only -> json.string("GPL-1.0-only")
SpdxlicenseGpl10orlater -> json.string("GPL-1.0-or-later")
SpdxlicenseGpl20only -> json.string("GPL-2.0-only")
SpdxlicenseGpl20orlater -> json.string("GPL-2.0-or-later")
SpdxlicenseGpl30only -> json.string("GPL-3.0-only")
SpdxlicenseGpl30orlater -> json.string("GPL-3.0-or-later")
SpdxlicenseGsoap13b -> json.string("gSOAP-1.3b")
SpdxlicenseHaskellreport -> json.string("HaskellReport")
SpdxlicenseHpnd -> json.string("HPND")
SpdxlicenseIbmpibs -> json.string("IBM-pibs")
SpdxlicenseIcu -> json.string("ICU")
SpdxlicenseIjg -> json.string("IJG")
SpdxlicenseImagemagick -> json.string("ImageMagick")
SpdxlicenseImatix -> json.string("iMatix")
SpdxlicenseImlib2 -> json.string("Imlib2")
SpdxlicenseInfozip -> json.string("Info-ZIP")
SpdxlicenseIntelacpi -> json.string("Intel-ACPI")
SpdxlicenseIntel -> json.string("Intel")
SpdxlicenseInterbase10 -> json.string("Interbase-1.0")
SpdxlicenseIpa -> json.string("IPA")
SpdxlicenseIpl10 -> json.string("IPL-1.0")
SpdxlicenseIsc -> json.string("ISC")
SpdxlicenseJasper20 -> json.string("JasPer-2.0")
SpdxlicenseJson -> json.string("JSON")
SpdxlicenseLal12 -> json.string("LAL-1.2")
SpdxlicenseLal13 -> json.string("LAL-1.3")
SpdxlicenseLatex2e -> json.string("Latex2e")
SpdxlicenseLeptonica -> json.string("Leptonica")
SpdxlicenseLgpl20only -> json.string("LGPL-2.0-only")
SpdxlicenseLgpl20orlater -> json.string("LGPL-2.0-or-later")
SpdxlicenseLgpl21only -> json.string("LGPL-2.1-only")
SpdxlicenseLgpl21orlater -> json.string("LGPL-2.1-or-later")
SpdxlicenseLgpl30only -> json.string("LGPL-3.0-only")
SpdxlicenseLgpl30orlater -> json.string("LGPL-3.0-or-later")
SpdxlicenseLgpllr -> json.string("LGPLLR")
SpdxlicenseLibpng -> json.string("Libpng")
SpdxlicenseLibtiff -> json.string("libtiff")
SpdxlicenseLiliqp11 -> json.string("LiLiQ-P-1.1")
SpdxlicenseLiliqr11 -> json.string("LiLiQ-R-1.1")
SpdxlicenseLiliqrplus11 -> json.string("LiLiQ-Rplus-1.1")
SpdxlicenseLinuxopenib -> json.string("Linux-OpenIB")
SpdxlicenseLpl10 -> json.string("LPL-1.0")
SpdxlicenseLpl102 -> json.string("LPL-1.02")
SpdxlicenseLppl10 -> json.string("LPPL-1.0")
SpdxlicenseLppl11 -> json.string("LPPL-1.1")
SpdxlicenseLppl12 -> json.string("LPPL-1.2")
SpdxlicenseLppl13a -> json.string("LPPL-1.3a")
SpdxlicenseLppl13c -> json.string("LPPL-1.3c")
SpdxlicenseMakeindex -> json.string("MakeIndex")
SpdxlicenseMiros -> json.string("MirOS")
SpdxlicenseMit0 -> json.string("MIT-0")
SpdxlicenseMitadvertising -> json.string("MIT-advertising")
SpdxlicenseMitcmu -> json.string("MIT-CMU")
SpdxlicenseMitenna -> json.string("MIT-enna")
SpdxlicenseMitfeh -> json.string("MIT-feh")
SpdxlicenseMit -> json.string("MIT")
SpdxlicenseMitnfa -> json.string("MITNFA")
SpdxlicenseMotosoto -> json.string("Motosoto")
SpdxlicenseMpich2 -> json.string("mpich2")
SpdxlicenseMpl10 -> json.string("MPL-1.0")
SpdxlicenseMpl11 -> json.string("MPL-1.1")
SpdxlicenseMpl20nocopyleftexception -> json.string("MPL-2.0-no-copyleft-exception")
SpdxlicenseMpl20 -> json.string("MPL-2.0")
SpdxlicenseMspl -> json.string("MS-PL")
SpdxlicenseMsrl -> json.string("MS-RL")
SpdxlicenseMtll -> json.string("MTLL")
SpdxlicenseMultics -> json.string("Multics")
SpdxlicenseMup -> json.string("Mup")
SpdxlicenseNasa13 -> json.string("NASA-1.3")
SpdxlicenseNaumen -> json.string("Naumen")
SpdxlicenseNbpl10 -> json.string("NBPL-1.0")
SpdxlicenseNcsa -> json.string("NCSA")
SpdxlicenseNetsnmp -> json.string("Net-SNMP")
SpdxlicenseNetcdf -> json.string("NetCDF")
SpdxlicenseNewsletr -> json.string("Newsletr")
SpdxlicenseNgpl -> json.string("NGPL")
SpdxlicenseNlod10 -> json.string("NLOD-1.0")
SpdxlicenseNlpl -> json.string("NLPL")
SpdxlicenseNokia -> json.string("Nokia")
SpdxlicenseNosl -> json.string("NOSL")
SpdxlicenseNoweb -> json.string("Noweb")
SpdxlicenseNpl10 -> json.string("NPL-1.0")
SpdxlicenseNpl11 -> json.string("NPL-1.1")
SpdxlicenseNposl30 -> json.string("NPOSL-3.0")
SpdxlicenseNrl -> json.string("NRL")
SpdxlicenseNtp -> json.string("NTP")
SpdxlicenseOcctpl -> json.string("OCCT-PL")
SpdxlicenseOclc20 -> json.string("OCLC-2.0")
SpdxlicenseOdbl10 -> json.string("ODbL-1.0")
SpdxlicenseOfl10 -> json.string("OFL-1.0")
SpdxlicenseOfl11 -> json.string("OFL-1.1")
SpdxlicenseOgtsl -> json.string("OGTSL")
SpdxlicenseOldap11 -> json.string("OLDAP-1.1")
SpdxlicenseOldap12 -> json.string("OLDAP-1.2")
SpdxlicenseOldap13 -> json.string("OLDAP-1.3")
SpdxlicenseOldap14 -> json.string("OLDAP-1.4")
SpdxlicenseOldap201 -> json.string("OLDAP-2.0.1")
SpdxlicenseOldap20 -> json.string("OLDAP-2.0")
SpdxlicenseOldap21 -> json.string("OLDAP-2.1")
SpdxlicenseOldap221 -> json.string("OLDAP-2.2.1")
SpdxlicenseOldap222 -> json.string("OLDAP-2.2.2")
SpdxlicenseOldap22 -> json.string("OLDAP-2.2")
SpdxlicenseOldap23 -> json.string("OLDAP-2.3")
SpdxlicenseOldap24 -> json.string("OLDAP-2.4")
SpdxlicenseOldap25 -> json.string("OLDAP-2.5")
SpdxlicenseOldap26 -> json.string("OLDAP-2.6")
SpdxlicenseOldap27 -> json.string("OLDAP-2.7")
SpdxlicenseOldap28 -> json.string("OLDAP-2.8")
SpdxlicenseOml -> json.string("OML")
SpdxlicenseOpenssl -> json.string("OpenSSL")
SpdxlicenseOpl10 -> json.string("OPL-1.0")
SpdxlicenseOsetpl21 -> json.string("OSET-PL-2.1")
SpdxlicenseOsl10 -> json.string("OSL-1.0")
SpdxlicenseOsl11 -> json.string("OSL-1.1")
SpdxlicenseOsl20 -> json.string("OSL-2.0")
SpdxlicenseOsl21 -> json.string("OSL-2.1")
SpdxlicenseOsl30 -> json.string("OSL-3.0")
SpdxlicensePddl10 -> json.string("PDDL-1.0")
SpdxlicensePhp30 -> json.string("PHP-3.0")
SpdxlicensePhp301 -> json.string("PHP-3.01")
SpdxlicensePlexus -> json.string("Plexus")
SpdxlicensePostgresql -> json.string("PostgreSQL")
SpdxlicensePsfrag -> json.string("psfrag")
SpdxlicensePsutils -> json.string("psutils")
SpdxlicensePython20 -> json.string("Python-2.0")
SpdxlicenseQhull -> json.string("Qhull")
SpdxlicenseQpl10 -> json.string("QPL-1.0")
SpdxlicenseRdisc -> json.string("Rdisc")
SpdxlicenseRhecos11 -> json.string("RHeCos-1.1")
SpdxlicenseRpl11 -> json.string("RPL-1.1")
SpdxlicenseRpl15 -> json.string("RPL-1.5")
SpdxlicenseRpsl10 -> json.string("RPSL-1.0")
SpdxlicenseRsamd -> json.string("RSA-MD")
SpdxlicenseRscpl -> json.string("RSCPL")
SpdxlicenseRuby -> json.string("Ruby")
SpdxlicenseSaxpd -> json.string("SAX-PD")
SpdxlicenseSaxpath -> json.string("Saxpath")
SpdxlicenseScea -> json.string("SCEA")
SpdxlicenseSendmail -> json.string("Sendmail")
SpdxlicenseSgib10 -> json.string("SGI-B-1.0")
SpdxlicenseSgib11 -> json.string("SGI-B-1.1")
SpdxlicenseSgib20 -> json.string("SGI-B-2.0")
SpdxlicenseSimpl20 -> json.string("SimPL-2.0")
SpdxlicenseSissl12 -> json.string("SISSL-1.2")
SpdxlicenseSissl -> json.string("SISSL")
SpdxlicenseSleepycat -> json.string("Sleepycat")
SpdxlicenseSmlnj -> json.string("SMLNJ")
SpdxlicenseSmppl -> json.string("SMPPL")
SpdxlicenseSnia -> json.string("SNIA")
SpdxlicenseSpencer86 -> json.string("Spencer-86")
SpdxlicenseSpencer94 -> json.string("Spencer-94")
SpdxlicenseSpencer99 -> json.string("Spencer-99")
SpdxlicenseSpl10 -> json.string("SPL-1.0")
SpdxlicenseSugarcrm113 -> json.string("SugarCRM-1.1.3")
SpdxlicenseSwl -> json.string("SWL")
SpdxlicenseTcl -> json.string("TCL")
SpdxlicenseTcpwrappers -> json.string("TCP-wrappers")
SpdxlicenseTmate -> json.string("TMate")
SpdxlicenseTorque11 -> json.string("TORQUE-1.1")
SpdxlicenseTosl -> json.string("TOSL")
SpdxlicenseUnicodedfs2015 -> json.string("Unicode-DFS-2015")
SpdxlicenseUnicodedfs2016 -> json.string("Unicode-DFS-2016")
SpdxlicenseUnicodetou -> json.string("Unicode-TOU")
SpdxlicenseUnlicense -> json.string("Unlicense")
SpdxlicenseUpl10 -> json.string("UPL-1.0")
SpdxlicenseVim -> json.string("Vim")
SpdxlicenseVostrom -> json.string("VOSTROM")
SpdxlicenseVsl10 -> json.string("VSL-1.0")
SpdxlicenseW3c19980720 -> json.string("W3C-19980720")
SpdxlicenseW3c20150513 -> json.string("W3C-20150513")
SpdxlicenseW3c -> json.string("W3C")
SpdxlicenseWatcom10 -> json.string("Watcom-1.0")
SpdxlicenseWsuipa -> json.string("Wsuipa")
SpdxlicenseWtfpl -> json.string("WTFPL")
SpdxlicenseX11 -> json.string("X11")
SpdxlicenseXerox -> json.string("Xerox")
SpdxlicenseXfree8611 -> json.string("XFree86-1.1")
SpdxlicenseXinetd -> json.string("xinetd")
SpdxlicenseXnet -> json.string("Xnet")
SpdxlicenseXpp -> json.string("xpp")
SpdxlicenseXskat -> json.string("XSkat")
SpdxlicenseYpl10 -> json.string("YPL-1.0")
SpdxlicenseYpl11 -> json.string("YPL-1.1")
SpdxlicenseZed -> json.string("Zed")
SpdxlicenseZend20 -> json.string("Zend-2.0")
SpdxlicenseZimbra13 -> json.string("Zimbra-1.3")
SpdxlicenseZimbra14 -> json.string("Zimbra-1.4")
SpdxlicenseZlibacknowledgement -> json.string("zlib-acknowledgement")
SpdxlicenseZlib -> json.string("Zlib")
SpdxlicenseZpl11 -> json.string("ZPL-1.1")
SpdxlicenseZpl20 -> json.string("ZPL-2.0")
SpdxlicenseZpl21 -> json.string("ZPL-2.1")
}
  }
  pub fn spdxlicense_decoder() -> Decoder(Spdxlicense) {
    use variant <- decode.then(decode.string)
    case variant {"not-open-source" -> decode.success(SpdxlicenseNotopensource)
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
"BSD-3-Clause-Attribution" -> decode.success(SpdxlicenseBsd3clauseattribution)
"BSD-3-Clause-Clear" -> decode.success(SpdxlicenseBsd3clauseclear)
"BSD-3-Clause-LBNL" -> decode.success(SpdxlicenseBsd3clauselbnl)
"BSD-3-Clause-No-Nuclear-License-2014" -> decode.success(SpdxlicenseBsd3clausenonuclearlicense2014)
"BSD-3-Clause-No-Nuclear-License" -> decode.success(SpdxlicenseBsd3clausenonuclearlicense)
"BSD-3-Clause-No-Nuclear-Warranty" -> decode.success(SpdxlicenseBsd3clausenonuclearwarranty)
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
"CNRI-Python-GPL-Compatible" -> decode.success(SpdxlicenseCnripythongplcompatible)
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
"MPL-2.0-no-copyleft-exception" -> decode.success(SpdxlicenseMpl20nocopyleftexception)
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
_ -> decode.failure(SpdxlicenseNotopensource, "Spdxlicense")}
  }
  
pub type Narrativestatus{NarrativestatusGenerated
NarrativestatusExtensions
NarrativestatusAdditional
NarrativestatusEmpty
}
pub fn narrativestatus_to_json(narrativestatus: Narrativestatus) -> Json {
    case narrativestatus {NarrativestatusGenerated -> json.string("generated")
NarrativestatusExtensions -> json.string("extensions")
NarrativestatusAdditional -> json.string("additional")
NarrativestatusEmpty -> json.string("empty")
}
  }
  pub fn narrativestatus_decoder() -> Decoder(Narrativestatus) {
    use variant <- decode.then(decode.string)
    case variant {"generated" -> decode.success(NarrativestatusGenerated)
"extensions" -> decode.success(NarrativestatusExtensions)
"additional" -> decode.success(NarrativestatusAdditional)
"empty" -> decode.success(NarrativestatusEmpty)
_ -> decode.failure(NarrativestatusGenerated, "Narrativestatus")}
  }
  
pub type Nameuse{NameuseUsual
NameuseOfficial
NameuseTemp
NameuseNickname
NameuseAnonymous
NameuseOld
}
pub fn nameuse_to_json(nameuse: Nameuse) -> Json {
    case nameuse {NameuseUsual -> json.string("usual")
NameuseOfficial -> json.string("official")
NameuseTemp -> json.string("temp")
NameuseNickname -> json.string("nickname")
NameuseAnonymous -> json.string("anonymous")
NameuseOld -> json.string("old")
}
  }
  pub fn nameuse_decoder() -> Decoder(Nameuse) {
    use variant <- decode.then(decode.string)
    case variant {"usual" -> decode.success(NameuseUsual)
"official" -> decode.success(NameuseOfficial)
"temp" -> decode.success(NameuseTemp)
"nickname" -> decode.success(NameuseNickname)
"anonymous" -> decode.success(NameuseAnonymous)
"old" -> decode.success(NameuseOld)
_ -> decode.failure(NameuseUsual, "Nameuse")}
  }
  
pub type Invoicepricecomponenttype{InvoicepricecomponenttypeBase
InvoicepricecomponenttypeSurcharge
InvoicepricecomponenttypeDeduction
InvoicepricecomponenttypeDiscount
InvoicepricecomponenttypeTax
InvoicepricecomponenttypeInformational
}
pub fn invoicepricecomponenttype_to_json(invoicepricecomponenttype: Invoicepricecomponenttype) -> Json {
    case invoicepricecomponenttype {InvoicepricecomponenttypeBase -> json.string("base")
InvoicepricecomponenttypeSurcharge -> json.string("surcharge")
InvoicepricecomponenttypeDeduction -> json.string("deduction")
InvoicepricecomponenttypeDiscount -> json.string("discount")
InvoicepricecomponenttypeTax -> json.string("tax")
InvoicepricecomponenttypeInformational -> json.string("informational")
}
  }
  pub fn invoicepricecomponenttype_decoder() -> Decoder(Invoicepricecomponenttype) {
    use variant <- decode.then(decode.string)
    case variant {"base" -> decode.success(InvoicepricecomponenttypeBase)
"surcharge" -> decode.success(InvoicepricecomponenttypeSurcharge)
"deduction" -> decode.success(InvoicepricecomponenttypeDeduction)
"discount" -> decode.success(InvoicepricecomponenttypeDiscount)
"tax" -> decode.success(InvoicepricecomponenttypeTax)
"informational" -> decode.success(InvoicepricecomponenttypeInformational)
_ -> decode.failure(InvoicepricecomponenttypeBase, "Invoicepricecomponenttype")}
  }
  
pub type Daysofweek{DaysofweekMon
DaysofweekTue
DaysofweekWed
DaysofweekThu
DaysofweekFri
DaysofweekSat
DaysofweekSun
}
pub fn daysofweek_to_json(daysofweek: Daysofweek) -> Json {
    case daysofweek {DaysofweekMon -> json.string("mon")
DaysofweekTue -> json.string("tue")
DaysofweekWed -> json.string("wed")
DaysofweekThu -> json.string("thu")
DaysofweekFri -> json.string("fri")
DaysofweekSat -> json.string("sat")
DaysofweekSun -> json.string("sun")
}
  }
  pub fn daysofweek_decoder() -> Decoder(Daysofweek) {
    use variant <- decode.then(decode.string)
    case variant {"mon" -> decode.success(DaysofweekMon)
"tue" -> decode.success(DaysofweekTue)
"wed" -> decode.success(DaysofweekWed)
"thu" -> decode.success(DaysofweekThu)
"fri" -> decode.success(DaysofweekFri)
"sat" -> decode.success(DaysofweekSat)
"sun" -> decode.success(DaysofweekSun)
_ -> decode.failure(DaysofweekMon, "Daysofweek")}
  }
  
pub type Permitteddatatype{PermitteddatatypeQuantity
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
    case permitteddatatype {PermitteddatatypeQuantity -> json.string("Quantity")
PermitteddatatypeCodeableconcept -> json.string("CodeableConcept")
PermitteddatatypeString -> json.string("string")
PermitteddatatypeBoolean -> json.string("boolean")
PermitteddatatypeInteger -> json.string("integer")
PermitteddatatypeRange -> json.string("Range")
PermitteddatatypeRatio -> json.string("Ratio")
PermitteddatatypeSampleddata -> json.string("SampledData")
PermitteddatatypeTime -> json.string("time")
PermitteddatatypeDatetime -> json.string("dateTime")
PermitteddatatypePeriod -> json.string("Period")
}
  }
  pub fn permitteddatatype_decoder() -> Decoder(Permitteddatatype) {
    use variant <- decode.then(decode.string)
    case variant {"Quantity" -> decode.success(PermitteddatatypeQuantity)
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
_ -> decode.failure(PermitteddatatypeQuantity, "Permitteddatatype")}
  }
  
pub type Metriccolor{MetriccolorBlack
MetriccolorRed
MetriccolorGreen
MetriccolorYellow
MetriccolorBlue
MetriccolorMagenta
MetriccolorCyan
MetriccolorWhite
}
pub fn metriccolor_to_json(metriccolor: Metriccolor) -> Json {
    case metriccolor {MetriccolorBlack -> json.string("black")
MetriccolorRed -> json.string("red")
MetriccolorGreen -> json.string("green")
MetriccolorYellow -> json.string("yellow")
MetriccolorBlue -> json.string("blue")
MetriccolorMagenta -> json.string("magenta")
MetriccolorCyan -> json.string("cyan")
MetriccolorWhite -> json.string("white")
}
  }
  pub fn metriccolor_decoder() -> Decoder(Metriccolor) {
    use variant <- decode.then(decode.string)
    case variant {"black" -> decode.success(MetriccolorBlack)
"red" -> decode.success(MetriccolorRed)
"green" -> decode.success(MetriccolorGreen)
"yellow" -> decode.success(MetriccolorYellow)
"blue" -> decode.success(MetriccolorBlue)
"magenta" -> decode.success(MetriccolorMagenta)
"cyan" -> decode.success(MetriccolorCyan)
"white" -> decode.success(MetriccolorWhite)
_ -> decode.failure(MetriccolorBlack, "Metriccolor")}
  }
  
pub type Encounterstatus{EncounterstatusPlanned
EncounterstatusArrived
EncounterstatusTriaged
EncounterstatusInprogress
EncounterstatusOnleave
EncounterstatusFinished
EncounterstatusCancelled
EncounterstatusEnteredinerror
EncounterstatusUnknown
}
pub fn encounterstatus_to_json(encounterstatus: Encounterstatus) -> Json {
    case encounterstatus {EncounterstatusPlanned -> json.string("planned")
EncounterstatusArrived -> json.string("arrived")
EncounterstatusTriaged -> json.string("triaged")
EncounterstatusInprogress -> json.string("in-progress")
EncounterstatusOnleave -> json.string("onleave")
EncounterstatusFinished -> json.string("finished")
EncounterstatusCancelled -> json.string("cancelled")
EncounterstatusEnteredinerror -> json.string("entered-in-error")
EncounterstatusUnknown -> json.string("unknown")
}
  }
  pub fn encounterstatus_decoder() -> Decoder(Encounterstatus) {
    use variant <- decode.then(decode.string)
    case variant {"planned" -> decode.success(EncounterstatusPlanned)
"arrived" -> decode.success(EncounterstatusArrived)
"triaged" -> decode.success(EncounterstatusTriaged)
"in-progress" -> decode.success(EncounterstatusInprogress)
"onleave" -> decode.success(EncounterstatusOnleave)
"finished" -> decode.success(EncounterstatusFinished)
"cancelled" -> decode.success(EncounterstatusCancelled)
"entered-in-error" -> decode.success(EncounterstatusEnteredinerror)
"unknown" -> decode.success(EncounterstatusUnknown)
_ -> decode.failure(EncounterstatusPlanned, "Encounterstatus")}
  }
  
pub type Allergyintolerancecategory{AllergyintolerancecategoryFood
AllergyintolerancecategoryMedication
AllergyintolerancecategoryEnvironment
AllergyintolerancecategoryBiologic
}
pub fn allergyintolerancecategory_to_json(allergyintolerancecategory: Allergyintolerancecategory) -> Json {
    case allergyintolerancecategory {AllergyintolerancecategoryFood -> json.string("food")
AllergyintolerancecategoryMedication -> json.string("medication")
AllergyintolerancecategoryEnvironment -> json.string("environment")
AllergyintolerancecategoryBiologic -> json.string("biologic")
}
  }
  pub fn allergyintolerancecategory_decoder() -> Decoder(Allergyintolerancecategory) {
    use variant <- decode.then(decode.string)
    case variant {"food" -> decode.success(AllergyintolerancecategoryFood)
"medication" -> decode.success(AllergyintolerancecategoryMedication)
"environment" -> decode.success(AllergyintolerancecategoryEnvironment)
"biologic" -> decode.success(AllergyintolerancecategoryBiologic)
_ -> decode.failure(AllergyintolerancecategoryFood, "Allergyintolerancecategory")}
  }
  
pub type Participantrequired{ParticipantrequiredRequired
ParticipantrequiredOptional
ParticipantrequiredInformationonly
}
pub fn participantrequired_to_json(participantrequired: Participantrequired) -> Json {
    case participantrequired {ParticipantrequiredRequired -> json.string("required")
ParticipantrequiredOptional -> json.string("optional")
ParticipantrequiredInformationonly -> json.string("information-only")
}
  }
  pub fn participantrequired_decoder() -> Decoder(Participantrequired) {
    use variant <- decode.then(decode.string)
    case variant {"required" -> decode.success(ParticipantrequiredRequired)
"optional" -> decode.success(ParticipantrequiredOptional)
"information-only" -> decode.success(ParticipantrequiredInformationonly)
_ -> decode.failure(ParticipantrequiredRequired, "Participantrequired")}
  }
  
pub type Interactiontrigger{InteractiontriggerCreate
InteractiontriggerUpdate
InteractiontriggerDelete
}
pub fn interactiontrigger_to_json(interactiontrigger: Interactiontrigger) -> Json {
    case interactiontrigger {InteractiontriggerCreate -> json.string("create")
InteractiontriggerUpdate -> json.string("update")
InteractiontriggerDelete -> json.string("delete")
}
  }
  pub fn interactiontrigger_decoder() -> Decoder(Interactiontrigger) {
    use variant <- decode.then(decode.string)
    case variant {"create" -> decode.success(InteractiontriggerCreate)
"update" -> decode.success(InteractiontriggerUpdate)
"delete" -> decode.success(InteractiontriggerDelete)
_ -> decode.failure(InteractiontriggerCreate, "Interactiontrigger")}
  }
  
pub type Identityassurancelevel{IdentityassurancelevelLevel1
IdentityassurancelevelLevel2
IdentityassurancelevelLevel3
IdentityassurancelevelLevel4
}
pub fn identityassurancelevel_to_json(identityassurancelevel: Identityassurancelevel) -> Json {
    case identityassurancelevel {IdentityassurancelevelLevel1 -> json.string("level1")
IdentityassurancelevelLevel2 -> json.string("level2")
IdentityassurancelevelLevel3 -> json.string("level3")
IdentityassurancelevelLevel4 -> json.string("level4")
}
  }
  pub fn identityassurancelevel_decoder() -> Decoder(Identityassurancelevel) {
    use variant <- decode.then(decode.string)
    case variant {"level1" -> decode.success(IdentityassurancelevelLevel1)
"level2" -> decode.success(IdentityassurancelevelLevel2)
"level3" -> decode.success(IdentityassurancelevelLevel3)
"level4" -> decode.success(IdentityassurancelevelLevel4)
_ -> decode.failure(IdentityassurancelevelLevel1, "Identityassurancelevel")}
  }
  
pub type Networktype{Networktype1
Networktype2
Networktype3
Networktype4
Networktype5
}
pub fn networktype_to_json(networktype: Networktype) -> Json {
    case networktype {Networktype1 -> json.string("1")
Networktype2 -> json.string("2")
Networktype3 -> json.string("3")
Networktype4 -> json.string("4")
Networktype5 -> json.string("5")
}
  }
  pub fn networktype_decoder() -> Decoder(Networktype) {
    use variant <- decode.then(decode.string)
    case variant {"1" -> decode.success(Networktype1)
"2" -> decode.success(Networktype2)
"3" -> decode.success(Networktype3)
"4" -> decode.success(Networktype4)
"5" -> decode.success(Networktype5)
_ -> decode.failure(Networktype1, "Networktype")}
  }
  
pub type Visionbasecodes{VisionbasecodesUp
VisionbasecodesDown
VisionbasecodesIn
VisionbasecodesOut
}
pub fn visionbasecodes_to_json(visionbasecodes: Visionbasecodes) -> Json {
    case visionbasecodes {VisionbasecodesUp -> json.string("up")
VisionbasecodesDown -> json.string("down")
VisionbasecodesIn -> json.string("in")
VisionbasecodesOut -> json.string("out")
}
  }
  pub fn visionbasecodes_decoder() -> Decoder(Visionbasecodes) {
    use variant <- decode.then(decode.string)
    case variant {"up" -> decode.success(VisionbasecodesUp)
"down" -> decode.success(VisionbasecodesDown)
"in" -> decode.success(VisionbasecodesIn)
"out" -> decode.success(VisionbasecodesOut)
_ -> decode.failure(VisionbasecodesUp, "Visionbasecodes")}
  }
  
pub type Specimenstatus{SpecimenstatusAvailable
SpecimenstatusUnavailable
SpecimenstatusUnsatisfactory
SpecimenstatusEnteredinerror
}
pub fn specimenstatus_to_json(specimenstatus: Specimenstatus) -> Json {
    case specimenstatus {SpecimenstatusAvailable -> json.string("available")
SpecimenstatusUnavailable -> json.string("unavailable")
SpecimenstatusUnsatisfactory -> json.string("unsatisfactory")
SpecimenstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn specimenstatus_decoder() -> Decoder(Specimenstatus) {
    use variant <- decode.then(decode.string)
    case variant {"available" -> decode.success(SpecimenstatusAvailable)
"unavailable" -> decode.success(SpecimenstatusUnavailable)
"unsatisfactory" -> decode.success(SpecimenstatusUnsatisfactory)
"entered-in-error" -> decode.success(SpecimenstatusEnteredinerror)
_ -> decode.failure(SpecimenstatusAvailable, "Specimenstatus")}
  }
  
pub type Verificationresultstatus{VerificationresultstatusAttested
VerificationresultstatusValidated
VerificationresultstatusInprocess
VerificationresultstatusReqrevalid
VerificationresultstatusValfail
VerificationresultstatusRevalfail
}
pub fn verificationresultstatus_to_json(verificationresultstatus: Verificationresultstatus) -> Json {
    case verificationresultstatus {VerificationresultstatusAttested -> json.string("attested")
VerificationresultstatusValidated -> json.string("validated")
VerificationresultstatusInprocess -> json.string("in-process")
VerificationresultstatusReqrevalid -> json.string("req-revalid")
VerificationresultstatusValfail -> json.string("val-fail")
VerificationresultstatusRevalfail -> json.string("reval-fail")
}
  }
  pub fn verificationresultstatus_decoder() -> Decoder(Verificationresultstatus) {
    use variant <- decode.then(decode.string)
    case variant {"attested" -> decode.success(VerificationresultstatusAttested)
"validated" -> decode.success(VerificationresultstatusValidated)
"in-process" -> decode.success(VerificationresultstatusInprocess)
"req-revalid" -> decode.success(VerificationresultstatusReqrevalid)
"val-fail" -> decode.success(VerificationresultstatusValfail)
"reval-fail" -> decode.success(VerificationresultstatusRevalfail)
_ -> decode.failure(VerificationresultstatusAttested, "Verificationresultstatus")}
  }
  
pub type Restfulcapabilitymode{RestfulcapabilitymodeClient
RestfulcapabilitymodeServer
}
pub fn restfulcapabilitymode_to_json(restfulcapabilitymode: Restfulcapabilitymode) -> Json {
    case restfulcapabilitymode {RestfulcapabilitymodeClient -> json.string("client")
RestfulcapabilitymodeServer -> json.string("server")
}
  }
  pub fn restfulcapabilitymode_decoder() -> Decoder(Restfulcapabilitymode) {
    use variant <- decode.then(decode.string)
    case variant {"client" -> decode.success(RestfulcapabilitymodeClient)
"server" -> decode.success(RestfulcapabilitymodeServer)
_ -> decode.failure(RestfulcapabilitymodeClient, "Restfulcapabilitymode")}
  }
  
pub type Subscriptiontopiccrbehavior{SubscriptiontopiccrbehaviorTestpasses
SubscriptiontopiccrbehaviorTestfails
}
pub fn subscriptiontopiccrbehavior_to_json(subscriptiontopiccrbehavior: Subscriptiontopiccrbehavior) -> Json {
    case subscriptiontopiccrbehavior {SubscriptiontopiccrbehaviorTestpasses -> json.string("test-passes")
SubscriptiontopiccrbehaviorTestfails -> json.string("test-fails")
}
  }
  pub fn subscriptiontopiccrbehavior_decoder() -> Decoder(Subscriptiontopiccrbehavior) {
    use variant <- decode.then(decode.string)
    case variant {"test-passes" -> decode.success(SubscriptiontopiccrbehaviorTestpasses)
"test-fails" -> decode.success(SubscriptiontopiccrbehaviorTestfails)
_ -> decode.failure(SubscriptiontopiccrbehaviorTestpasses, "Subscriptiontopiccrbehavior")}
  }
  
pub type Searchcomparator{SearchcomparatorEq
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
    case searchcomparator {SearchcomparatorEq -> json.string("eq")
SearchcomparatorNe -> json.string("ne")
SearchcomparatorGt -> json.string("gt")
SearchcomparatorLt -> json.string("lt")
SearchcomparatorGe -> json.string("ge")
SearchcomparatorLe -> json.string("le")
SearchcomparatorSa -> json.string("sa")
SearchcomparatorEb -> json.string("eb")
SearchcomparatorAp -> json.string("ap")
}
  }
  pub fn searchcomparator_decoder() -> Decoder(Searchcomparator) {
    use variant <- decode.then(decode.string)
    case variant {"eq" -> decode.success(SearchcomparatorEq)
"ne" -> decode.success(SearchcomparatorNe)
"gt" -> decode.success(SearchcomparatorGt)
"lt" -> decode.success(SearchcomparatorLt)
"ge" -> decode.success(SearchcomparatorGe)
"le" -> decode.success(SearchcomparatorLe)
"sa" -> decode.success(SearchcomparatorSa)
"eb" -> decode.success(SearchcomparatorEb)
"ap" -> decode.success(SearchcomparatorAp)
_ -> decode.failure(SearchcomparatorEq, "Searchcomparator")}
  }
  
pub type Metricoperationalstatus{MetricoperationalstatusOn
MetricoperationalstatusOff
MetricoperationalstatusStandby
MetricoperationalstatusEnteredinerror
}
pub fn metricoperationalstatus_to_json(metricoperationalstatus: Metricoperationalstatus) -> Json {
    case metricoperationalstatus {MetricoperationalstatusOn -> json.string("on")
MetricoperationalstatusOff -> json.string("off")
MetricoperationalstatusStandby -> json.string("standby")
MetricoperationalstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn metricoperationalstatus_decoder() -> Decoder(Metricoperationalstatus) {
    use variant <- decode.then(decode.string)
    case variant {"on" -> decode.success(MetricoperationalstatusOn)
"off" -> decode.success(MetricoperationalstatusOff)
"standby" -> decode.success(MetricoperationalstatusStandby)
"entered-in-error" -> decode.success(MetricoperationalstatusEnteredinerror)
_ -> decode.failure(MetricoperationalstatusOn, "Metricoperationalstatus")}
  }
  
pub type Fhirversion{Fhirversion001
Fhirversion005
Fhirversion006
Fhirversion011
Fhirversion0080
Fhirversion0081
Fhirversion0082
Fhirversion040
Fhirversion050
Fhirversion100
Fhirversion101
Fhirversion102
Fhirversion110
Fhirversion140
Fhirversion160
Fhirversion180
Fhirversion300
Fhirversion301
Fhirversion302
Fhirversion330
Fhirversion350
Fhirversion400
Fhirversion401
Fhirversion410
Fhirversion430cibuild
Fhirversion430snapshot1
Fhirversion430
}
pub fn fhirversion_to_json(fhirversion: Fhirversion) -> Json {
    case fhirversion {Fhirversion001 -> json.string("0.01")
Fhirversion005 -> json.string("0.05")
Fhirversion006 -> json.string("0.06")
Fhirversion011 -> json.string("0.11")
Fhirversion0080 -> json.string("0.0.80")
Fhirversion0081 -> json.string("0.0.81")
Fhirversion0082 -> json.string("0.0.82")
Fhirversion040 -> json.string("0.4.0")
Fhirversion050 -> json.string("0.5.0")
Fhirversion100 -> json.string("1.0.0")
Fhirversion101 -> json.string("1.0.1")
Fhirversion102 -> json.string("1.0.2")
Fhirversion110 -> json.string("1.1.0")
Fhirversion140 -> json.string("1.4.0")
Fhirversion160 -> json.string("1.6.0")
Fhirversion180 -> json.string("1.8.0")
Fhirversion300 -> json.string("3.0.0")
Fhirversion301 -> json.string("3.0.1")
Fhirversion302 -> json.string("3.0.2")
Fhirversion330 -> json.string("3.3.0")
Fhirversion350 -> json.string("3.5.0")
Fhirversion400 -> json.string("4.0.0")
Fhirversion401 -> json.string("4.0.1")
Fhirversion410 -> json.string("4.1.0")
Fhirversion430cibuild -> json.string("4.3.0-cibuild")
Fhirversion430snapshot1 -> json.string("4.3.0-snapshot1")
Fhirversion430 -> json.string("4.3.0")
}
  }
  pub fn fhirversion_decoder() -> Decoder(Fhirversion) {
    use variant <- decode.then(decode.string)
    case variant {"0.01" -> decode.success(Fhirversion001)
"0.05" -> decode.success(Fhirversion005)
"0.06" -> decode.success(Fhirversion006)
"0.11" -> decode.success(Fhirversion011)
"0.0.80" -> decode.success(Fhirversion0080)
"0.0.81" -> decode.success(Fhirversion0081)
"0.0.82" -> decode.success(Fhirversion0082)
"0.4.0" -> decode.success(Fhirversion040)
"0.5.0" -> decode.success(Fhirversion050)
"1.0.0" -> decode.success(Fhirversion100)
"1.0.1" -> decode.success(Fhirversion101)
"1.0.2" -> decode.success(Fhirversion102)
"1.1.0" -> decode.success(Fhirversion110)
"1.4.0" -> decode.success(Fhirversion140)
"1.6.0" -> decode.success(Fhirversion160)
"1.8.0" -> decode.success(Fhirversion180)
"3.0.0" -> decode.success(Fhirversion300)
"3.0.1" -> decode.success(Fhirversion301)
"3.0.2" -> decode.success(Fhirversion302)
"3.3.0" -> decode.success(Fhirversion330)
"3.5.0" -> decode.success(Fhirversion350)
"4.0.0" -> decode.success(Fhirversion400)
"4.0.1" -> decode.success(Fhirversion401)
"4.1.0" -> decode.success(Fhirversion410)
"4.3.0-cibuild" -> decode.success(Fhirversion430cibuild)
"4.3.0-snapshot1" -> decode.success(Fhirversion430snapshot1)
"4.3.0" -> decode.success(Fhirversion430)
_ -> decode.failure(Fhirversion001, "Fhirversion")}
  }
  
pub type Bundletype{BundletypeDocument
BundletypeMessage
BundletypeTransaction
BundletypeTransactionresponse
BundletypeBatch
BundletypeBatchresponse
BundletypeHistory
BundletypeSearchset
BundletypeCollection
}
pub fn bundletype_to_json(bundletype: Bundletype) -> Json {
    case bundletype {BundletypeDocument -> json.string("document")
BundletypeMessage -> json.string("message")
BundletypeTransaction -> json.string("transaction")
BundletypeTransactionresponse -> json.string("transaction-response")
BundletypeBatch -> json.string("batch")
BundletypeBatchresponse -> json.string("batch-response")
BundletypeHistory -> json.string("history")
BundletypeSearchset -> json.string("searchset")
BundletypeCollection -> json.string("collection")
}
  }
  pub fn bundletype_decoder() -> Decoder(Bundletype) {
    use variant <- decode.then(decode.string)
    case variant {"document" -> decode.success(BundletypeDocument)
"message" -> decode.success(BundletypeMessage)
"transaction" -> decode.success(BundletypeTransaction)
"transaction-response" -> decode.success(BundletypeTransactionresponse)
"batch" -> decode.success(BundletypeBatch)
"batch-response" -> decode.success(BundletypeBatchresponse)
"history" -> decode.success(BundletypeHistory)
"searchset" -> decode.success(BundletypeSearchset)
"collection" -> decode.success(BundletypeCollection)
_ -> decode.failure(BundletypeDocument, "Bundletype")}
  }
  
pub type Reportstatuscodes{ReportstatuscodesCompleted
ReportstatuscodesInprogress
ReportstatuscodesWaiting
ReportstatuscodesStopped
ReportstatuscodesEnteredinerror
}
pub fn reportstatuscodes_to_json(reportstatuscodes: Reportstatuscodes) -> Json {
    case reportstatuscodes {ReportstatuscodesCompleted -> json.string("completed")
ReportstatuscodesInprogress -> json.string("in-progress")
ReportstatuscodesWaiting -> json.string("waiting")
ReportstatuscodesStopped -> json.string("stopped")
ReportstatuscodesEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn reportstatuscodes_decoder() -> Decoder(Reportstatuscodes) {
    use variant <- decode.then(decode.string)
    case variant {"completed" -> decode.success(ReportstatuscodesCompleted)
"in-progress" -> decode.success(ReportstatuscodesInprogress)
"waiting" -> decode.success(ReportstatuscodesWaiting)
"stopped" -> decode.success(ReportstatuscodesStopped)
"entered-in-error" -> decode.success(ReportstatuscodesEnteredinerror)
_ -> decode.failure(ReportstatuscodesCompleted, "Reportstatuscodes")}
  }
  
pub type Imagingstudystatus{ImagingstudystatusRegistered
ImagingstudystatusAvailable
ImagingstudystatusCancelled
ImagingstudystatusEnteredinerror
ImagingstudystatusUnknown
}
pub fn imagingstudystatus_to_json(imagingstudystatus: Imagingstudystatus) -> Json {
    case imagingstudystatus {ImagingstudystatusRegistered -> json.string("registered")
ImagingstudystatusAvailable -> json.string("available")
ImagingstudystatusCancelled -> json.string("cancelled")
ImagingstudystatusEnteredinerror -> json.string("entered-in-error")
ImagingstudystatusUnknown -> json.string("unknown")
}
  }
  pub fn imagingstudystatus_decoder() -> Decoder(Imagingstudystatus) {
    use variant <- decode.then(decode.string)
    case variant {"registered" -> decode.success(ImagingstudystatusRegistered)
"available" -> decode.success(ImagingstudystatusAvailable)
"cancelled" -> decode.success(ImagingstudystatusCancelled)
"entered-in-error" -> decode.success(ImagingstudystatusEnteredinerror)
"unknown" -> decode.success(ImagingstudystatusUnknown)
_ -> decode.failure(ImagingstudystatusRegistered, "Imagingstudystatus")}
  }
  
pub type Assertdirectioncodes{AssertdirectioncodesResponse
AssertdirectioncodesRequest
}
pub fn assertdirectioncodes_to_json(assertdirectioncodes: Assertdirectioncodes) -> Json {
    case assertdirectioncodes {AssertdirectioncodesResponse -> json.string("response")
AssertdirectioncodesRequest -> json.string("request")
}
  }
  pub fn assertdirectioncodes_decoder() -> Decoder(Assertdirectioncodes) {
    use variant <- decode.then(decode.string)
    case variant {"response" -> decode.success(AssertdirectioncodesResponse)
"request" -> decode.success(AssertdirectioncodesRequest)
_ -> decode.failure(AssertdirectioncodesResponse, "Assertdirectioncodes")}
  }
  
pub type Mapmodelmode{MapmodelmodeSource
MapmodelmodeQueried
MapmodelmodeTarget
MapmodelmodeProduced
}
pub fn mapmodelmode_to_json(mapmodelmode: Mapmodelmode) -> Json {
    case mapmodelmode {MapmodelmodeSource -> json.string("source")
MapmodelmodeQueried -> json.string("queried")
MapmodelmodeTarget -> json.string("target")
MapmodelmodeProduced -> json.string("produced")
}
  }
  pub fn mapmodelmode_decoder() -> Decoder(Mapmodelmode) {
    use variant <- decode.then(decode.string)
    case variant {"source" -> decode.success(MapmodelmodeSource)
"queried" -> decode.success(MapmodelmodeQueried)
"target" -> decode.success(MapmodelmodeTarget)
"produced" -> decode.success(MapmodelmodeProduced)
_ -> decode.failure(MapmodelmodeSource, "Mapmodelmode")}
  }
  
pub type Substancestatus{SubstancestatusActive
SubstancestatusInactive
SubstancestatusEnteredinerror
}
pub fn substancestatus_to_json(substancestatus: Substancestatus) -> Json {
    case substancestatus {SubstancestatusActive -> json.string("active")
SubstancestatusInactive -> json.string("inactive")
SubstancestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn substancestatus_decoder() -> Decoder(Substancestatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(SubstancestatusActive)
"inactive" -> decode.success(SubstancestatusInactive)
"entered-in-error" -> decode.success(SubstancestatusEnteredinerror)
_ -> decode.failure(SubstancestatusActive, "Substancestatus")}
  }
  
pub type Diagnosticreportstatus{DiagnosticreportstatusRegistered
DiagnosticreportstatusPartial
DiagnosticreportstatusFinal
DiagnosticreportstatusAmended
DiagnosticreportstatusCancelled
DiagnosticreportstatusEnteredinerror
DiagnosticreportstatusUnknown
}
pub fn diagnosticreportstatus_to_json(diagnosticreportstatus: Diagnosticreportstatus) -> Json {
    case diagnosticreportstatus {DiagnosticreportstatusRegistered -> json.string("registered")
DiagnosticreportstatusPartial -> json.string("partial")
DiagnosticreportstatusFinal -> json.string("final")
DiagnosticreportstatusAmended -> json.string("amended")
DiagnosticreportstatusCancelled -> json.string("cancelled")
DiagnosticreportstatusEnteredinerror -> json.string("entered-in-error")
DiagnosticreportstatusUnknown -> json.string("unknown")
}
  }
  pub fn diagnosticreportstatus_decoder() -> Decoder(Diagnosticreportstatus) {
    use variant <- decode.then(decode.string)
    case variant {"registered" -> decode.success(DiagnosticreportstatusRegistered)
"partial" -> decode.success(DiagnosticreportstatusPartial)
"final" -> decode.success(DiagnosticreportstatusFinal)
"amended" -> decode.success(DiagnosticreportstatusAmended)
"cancelled" -> decode.success(DiagnosticreportstatusCancelled)
"entered-in-error" -> decode.success(DiagnosticreportstatusEnteredinerror)
"unknown" -> decode.success(DiagnosticreportstatusUnknown)
_ -> decode.failure(DiagnosticreportstatusRegistered, "Diagnosticreportstatus")}
  }
  
pub type Actionrelationshiptype{ActionrelationshiptypeBeforestart
ActionrelationshiptypeBefore
ActionrelationshiptypeBeforeend
ActionrelationshiptypeConcurrentwithstart
ActionrelationshiptypeConcurrent
ActionrelationshiptypeConcurrentwithend
ActionrelationshiptypeAfterstart
ActionrelationshiptypeAfter
ActionrelationshiptypeAfterend
}
pub fn actionrelationshiptype_to_json(actionrelationshiptype: Actionrelationshiptype) -> Json {
    case actionrelationshiptype {ActionrelationshiptypeBeforestart -> json.string("before-start")
ActionrelationshiptypeBefore -> json.string("before")
ActionrelationshiptypeBeforeend -> json.string("before-end")
ActionrelationshiptypeConcurrentwithstart -> json.string("concurrent-with-start")
ActionrelationshiptypeConcurrent -> json.string("concurrent")
ActionrelationshiptypeConcurrentwithend -> json.string("concurrent-with-end")
ActionrelationshiptypeAfterstart -> json.string("after-start")
ActionrelationshiptypeAfter -> json.string("after")
ActionrelationshiptypeAfterend -> json.string("after-end")
}
  }
  pub fn actionrelationshiptype_decoder() -> Decoder(Actionrelationshiptype) {
    use variant <- decode.then(decode.string)
    case variant {"before-start" -> decode.success(ActionrelationshiptypeBeforestart)
"before" -> decode.success(ActionrelationshiptypeBefore)
"before-end" -> decode.success(ActionrelationshiptypeBeforeend)
"concurrent-with-start" -> decode.success(ActionrelationshiptypeConcurrentwithstart)
"concurrent" -> decode.success(ActionrelationshiptypeConcurrent)
"concurrent-with-end" -> decode.success(ActionrelationshiptypeConcurrentwithend)
"after-start" -> decode.success(ActionrelationshiptypeAfterstart)
"after" -> decode.success(ActionrelationshiptypeAfter)
"after-end" -> decode.success(ActionrelationshiptypeAfterend)
_ -> decode.failure(ActionrelationshiptypeBeforestart, "Actionrelationshiptype")}
  }
  
pub type Quantitycomparator{QuantitycomparatorLessthan
QuantitycomparatorLessthanequal
QuantitycomparatorGreaterthanequal
QuantitycomparatorGreaterthan
}
pub fn quantitycomparator_to_json(quantitycomparator: Quantitycomparator) -> Json {
    case quantitycomparator {QuantitycomparatorLessthan -> json.string("<")
QuantitycomparatorLessthanequal -> json.string("<=")
QuantitycomparatorGreaterthanequal -> json.string(">=")
QuantitycomparatorGreaterthan -> json.string(">")
}
  }
  pub fn quantitycomparator_decoder() -> Decoder(Quantitycomparator) {
    use variant <- decode.then(decode.string)
    case variant {"<" -> decode.success(QuantitycomparatorLessthan)
"<=" -> decode.success(QuantitycomparatorLessthanequal)
">=" -> decode.success(QuantitycomparatorGreaterthanequal)
">" -> decode.success(QuantitycomparatorGreaterthan)
_ -> decode.failure(QuantitycomparatorLessthan, "Quantitycomparator")}
  }
  
pub type Contactpointsystem{ContactpointsystemPhone
ContactpointsystemFax
ContactpointsystemEmail
ContactpointsystemPager
ContactpointsystemUrl
ContactpointsystemSms
ContactpointsystemOther
}
pub fn contactpointsystem_to_json(contactpointsystem: Contactpointsystem) -> Json {
    case contactpointsystem {ContactpointsystemPhone -> json.string("phone")
ContactpointsystemFax -> json.string("fax")
ContactpointsystemEmail -> json.string("email")
ContactpointsystemPager -> json.string("pager")
ContactpointsystemUrl -> json.string("url")
ContactpointsystemSms -> json.string("sms")
ContactpointsystemOther -> json.string("other")
}
  }
  pub fn contactpointsystem_decoder() -> Decoder(Contactpointsystem) {
    use variant <- decode.then(decode.string)
    case variant {"phone" -> decode.success(ContactpointsystemPhone)
"fax" -> decode.success(ContactpointsystemFax)
"email" -> decode.success(ContactpointsystemEmail)
"pager" -> decode.success(ContactpointsystemPager)
"url" -> decode.success(ContactpointsystemUrl)
"sms" -> decode.success(ContactpointsystemSms)
"other" -> decode.success(ContactpointsystemOther)
_ -> decode.failure(ContactpointsystemPhone, "Contactpointsystem")}
  }
  
pub type Provenanceentityrole{ProvenanceentityroleDerivation
}
pub fn provenanceentityrole_to_json(provenanceentityrole: Provenanceentityrole) -> Json {
    case provenanceentityrole {ProvenanceentityroleDerivation -> json.string("derivation")
}
  }
  pub fn provenanceentityrole_decoder() -> Decoder(Provenanceentityrole) {
    use variant <- decode.then(decode.string)
    case variant {"derivation" -> decode.success(ProvenanceentityroleDerivation)
_ -> decode.failure(ProvenanceentityroleDerivation, "Provenanceentityrole")}
  }
  
pub type Grouptype{GrouptypePerson
GrouptypeAnimal
GrouptypePractitioner
GrouptypeDevice
GrouptypeMedication
GrouptypeSubstance
}
pub fn grouptype_to_json(grouptype: Grouptype) -> Json {
    case grouptype {GrouptypePerson -> json.string("person")
GrouptypeAnimal -> json.string("animal")
GrouptypePractitioner -> json.string("practitioner")
GrouptypeDevice -> json.string("device")
GrouptypeMedication -> json.string("medication")
GrouptypeSubstance -> json.string("substance")
}
  }
  pub fn grouptype_decoder() -> Decoder(Grouptype) {
    use variant <- decode.then(decode.string)
    case variant {"person" -> decode.success(GrouptypePerson)
"animal" -> decode.success(GrouptypeAnimal)
"practitioner" -> decode.success(GrouptypePractitioner)
"device" -> decode.success(GrouptypeDevice)
"medication" -> decode.success(GrouptypeMedication)
"substance" -> decode.success(GrouptypeSubstance)
_ -> decode.failure(GrouptypePerson, "Grouptype")}
  }
  
pub type Searchentrymode{SearchentrymodeMatch
SearchentrymodeInclude
SearchentrymodeOutcome
}
pub fn searchentrymode_to_json(searchentrymode: Searchentrymode) -> Json {
    case searchentrymode {SearchentrymodeMatch -> json.string("match")
SearchentrymodeInclude -> json.string("include")
SearchentrymodeOutcome -> json.string("outcome")
}
  }
  pub fn searchentrymode_decoder() -> Decoder(Searchentrymode) {
    use variant <- decode.then(decode.string)
    case variant {"match" -> decode.success(SearchentrymodeMatch)
"include" -> decode.success(SearchentrymodeInclude)
"outcome" -> decode.success(SearchentrymodeOutcome)
_ -> decode.failure(SearchentrymodeMatch, "Searchentrymode")}
  }
  
pub type Accountstatus{AccountstatusActive
AccountstatusInactive
AccountstatusEnteredinerror
AccountstatusOnhold
AccountstatusUnknown
}
pub fn accountstatus_to_json(accountstatus: Accountstatus) -> Json {
    case accountstatus {AccountstatusActive -> json.string("active")
AccountstatusInactive -> json.string("inactive")
AccountstatusEnteredinerror -> json.string("entered-in-error")
AccountstatusOnhold -> json.string("on-hold")
AccountstatusUnknown -> json.string("unknown")
}
  }
  pub fn accountstatus_decoder() -> Decoder(Accountstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(AccountstatusActive)
"inactive" -> decode.success(AccountstatusInactive)
"entered-in-error" -> decode.success(AccountstatusEnteredinerror)
"on-hold" -> decode.success(AccountstatusOnhold)
"unknown" -> decode.success(AccountstatusUnknown)
_ -> decode.failure(AccountstatusActive, "Accountstatus")}
  }
  
pub type Documentreferencestatus{DocumentreferencestatusCurrent
DocumentreferencestatusSuperseded
DocumentreferencestatusEnteredinerror
}
pub fn documentreferencestatus_to_json(documentreferencestatus: Documentreferencestatus) -> Json {
    case documentreferencestatus {DocumentreferencestatusCurrent -> json.string("current")
DocumentreferencestatusSuperseded -> json.string("superseded")
DocumentreferencestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn documentreferencestatus_decoder() -> Decoder(Documentreferencestatus) {
    use variant <- decode.then(decode.string)
    case variant {"current" -> decode.success(DocumentreferencestatusCurrent)
"superseded" -> decode.success(DocumentreferencestatusSuperseded)
"entered-in-error" -> decode.success(DocumentreferencestatusEnteredinerror)
_ -> decode.failure(DocumentreferencestatusCurrent, "Documentreferencestatus")}
  }
  
pub type Goalstatus{GoalstatusProposed
GoalstatusPlanned
GoalstatusAccepted
GoalstatusCancelled
GoalstatusEnteredinerror
GoalstatusRejected
}
pub fn goalstatus_to_json(goalstatus: Goalstatus) -> Json {
    case goalstatus {GoalstatusProposed -> json.string("proposed")
GoalstatusPlanned -> json.string("planned")
GoalstatusAccepted -> json.string("accepted")
GoalstatusCancelled -> json.string("cancelled")
GoalstatusEnteredinerror -> json.string("entered-in-error")
GoalstatusRejected -> json.string("rejected")
}
  }
  pub fn goalstatus_decoder() -> Decoder(Goalstatus) {
    use variant <- decode.then(decode.string)
    case variant {"proposed" -> decode.success(GoalstatusProposed)
"planned" -> decode.success(GoalstatusPlanned)
"accepted" -> decode.success(GoalstatusAccepted)
"cancelled" -> decode.success(GoalstatusCancelled)
"entered-in-error" -> decode.success(GoalstatusEnteredinerror)
"rejected" -> decode.success(GoalstatusRejected)
_ -> decode.failure(GoalstatusProposed, "Goalstatus")}
  }
  
pub type Reportparticipanttype{ReportparticipanttypeTestengine
ReportparticipanttypeClient
ReportparticipanttypeServer
}
pub fn reportparticipanttype_to_json(reportparticipanttype: Reportparticipanttype) -> Json {
    case reportparticipanttype {ReportparticipanttypeTestengine -> json.string("test-engine")
ReportparticipanttypeClient -> json.string("client")
ReportparticipanttypeServer -> json.string("server")
}
  }
  pub fn reportparticipanttype_decoder() -> Decoder(Reportparticipanttype) {
    use variant <- decode.then(decode.string)
    case variant {"test-engine" -> decode.success(ReportparticipanttypeTestengine)
"client" -> decode.success(ReportparticipanttypeClient)
"server" -> decode.success(ReportparticipanttypeServer)
_ -> decode.failure(ReportparticipanttypeTestengine, "Reportparticipanttype")}
  }
  
pub type Graphcompartmentrule{GraphcompartmentruleIdentical
GraphcompartmentruleMatching
GraphcompartmentruleDifferent
GraphcompartmentruleCustom
}
pub fn graphcompartmentrule_to_json(graphcompartmentrule: Graphcompartmentrule) -> Json {
    case graphcompartmentrule {GraphcompartmentruleIdentical -> json.string("identical")
GraphcompartmentruleMatching -> json.string("matching")
GraphcompartmentruleDifferent -> json.string("different")
GraphcompartmentruleCustom -> json.string("custom")
}
  }
  pub fn graphcompartmentrule_decoder() -> Decoder(Graphcompartmentrule) {
    use variant <- decode.then(decode.string)
    case variant {"identical" -> decode.success(GraphcompartmentruleIdentical)
"matching" -> decode.success(GraphcompartmentruleMatching)
"different" -> decode.success(GraphcompartmentruleDifferent)
"custom" -> decode.success(GraphcompartmentruleCustom)
_ -> decode.failure(GraphcompartmentruleIdentical, "Graphcompartmentrule")}
  }
  
pub type Immunizationevaluationstatus{ImmunizationevaluationstatusCompleted
ImmunizationevaluationstatusEnteredinerror
}
pub fn immunizationevaluationstatus_to_json(immunizationevaluationstatus: Immunizationevaluationstatus) -> Json {
    case immunizationevaluationstatus {ImmunizationevaluationstatusCompleted -> json.string("completed")
ImmunizationevaluationstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn immunizationevaluationstatus_decoder() -> Decoder(Immunizationevaluationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"completed" -> decode.success(ImmunizationevaluationstatusCompleted)
"entered-in-error" -> decode.success(ImmunizationevaluationstatusEnteredinerror)
_ -> decode.failure(ImmunizationevaluationstatusCompleted, "Immunizationevaluationstatus")}
  }
  
pub type Requestresourcetypes{RequestresourcetypesAppointment
RequestresourcetypesAppointmentresponse
RequestresourcetypesCareplan
RequestresourcetypesClaim
RequestresourcetypesCommunicationrequest
RequestresourcetypesContract
RequestresourcetypesDevicerequest
RequestresourcetypesEnrollmentrequest
RequestresourcetypesImmunizationrecommendation
RequestresourcetypesMedicationrequest
RequestresourcetypesNutritionorder
RequestresourcetypesServicerequest
RequestresourcetypesSupplyrequest
RequestresourcetypesTask
RequestresourcetypesVisionprescription
}
pub fn requestresourcetypes_to_json(requestresourcetypes: Requestresourcetypes) -> Json {
    case requestresourcetypes {RequestresourcetypesAppointment -> json.string("Appointment")
RequestresourcetypesAppointmentresponse -> json.string("AppointmentResponse")
RequestresourcetypesCareplan -> json.string("CarePlan")
RequestresourcetypesClaim -> json.string("Claim")
RequestresourcetypesCommunicationrequest -> json.string("CommunicationRequest")
RequestresourcetypesContract -> json.string("Contract")
RequestresourcetypesDevicerequest -> json.string("DeviceRequest")
RequestresourcetypesEnrollmentrequest -> json.string("EnrollmentRequest")
RequestresourcetypesImmunizationrecommendation -> json.string("ImmunizationRecommendation")
RequestresourcetypesMedicationrequest -> json.string("MedicationRequest")
RequestresourcetypesNutritionorder -> json.string("NutritionOrder")
RequestresourcetypesServicerequest -> json.string("ServiceRequest")
RequestresourcetypesSupplyrequest -> json.string("SupplyRequest")
RequestresourcetypesTask -> json.string("Task")
RequestresourcetypesVisionprescription -> json.string("VisionPrescription")
}
  }
  pub fn requestresourcetypes_decoder() -> Decoder(Requestresourcetypes) {
    use variant <- decode.then(decode.string)
    case variant {"Appointment" -> decode.success(RequestresourcetypesAppointment)
"AppointmentResponse" -> decode.success(RequestresourcetypesAppointmentresponse)
"CarePlan" -> decode.success(RequestresourcetypesCareplan)
"Claim" -> decode.success(RequestresourcetypesClaim)
"CommunicationRequest" -> decode.success(RequestresourcetypesCommunicationrequest)
"Contract" -> decode.success(RequestresourcetypesContract)
"DeviceRequest" -> decode.success(RequestresourcetypesDevicerequest)
"EnrollmentRequest" -> decode.success(RequestresourcetypesEnrollmentrequest)
"ImmunizationRecommendation" -> decode.success(RequestresourcetypesImmunizationrecommendation)
"MedicationRequest" -> decode.success(RequestresourcetypesMedicationrequest)
"NutritionOrder" -> decode.success(RequestresourcetypesNutritionorder)
"ServiceRequest" -> decode.success(RequestresourcetypesServicerequest)
"SupplyRequest" -> decode.success(RequestresourcetypesSupplyrequest)
"Task" -> decode.success(RequestresourcetypesTask)
"VisionPrescription" -> decode.success(RequestresourcetypesVisionprescription)
_ -> decode.failure(RequestresourcetypesAppointment, "Requestresourcetypes")}
  }
  
pub type Resourceslicingrules{ResourceslicingrulesClosed
ResourceslicingrulesOpen
ResourceslicingrulesOpenatend
}
pub fn resourceslicingrules_to_json(resourceslicingrules: Resourceslicingrules) -> Json {
    case resourceslicingrules {ResourceslicingrulesClosed -> json.string("closed")
ResourceslicingrulesOpen -> json.string("open")
ResourceslicingrulesOpenatend -> json.string("openAtEnd")
}
  }
  pub fn resourceslicingrules_decoder() -> Decoder(Resourceslicingrules) {
    use variant <- decode.then(decode.string)
    case variant {"closed" -> decode.success(ResourceslicingrulesClosed)
"open" -> decode.success(ResourceslicingrulesOpen)
"openAtEnd" -> decode.success(ResourceslicingrulesOpenatend)
_ -> decode.failure(ResourceslicingrulesClosed, "Resourceslicingrules")}
  }
  
pub type Referenceversionrules{ReferenceversionrulesEither
ReferenceversionrulesIndependent
ReferenceversionrulesSpecific
}
pub fn referenceversionrules_to_json(referenceversionrules: Referenceversionrules) -> Json {
    case referenceversionrules {ReferenceversionrulesEither -> json.string("either")
ReferenceversionrulesIndependent -> json.string("independent")
ReferenceversionrulesSpecific -> json.string("specific")
}
  }
  pub fn referenceversionrules_decoder() -> Decoder(Referenceversionrules) {
    use variant <- decode.then(decode.string)
    case variant {"either" -> decode.success(ReferenceversionrulesEither)
"independent" -> decode.success(ReferenceversionrulesIndependent)
"specific" -> decode.success(ReferenceversionrulesSpecific)
_ -> decode.failure(ReferenceversionrulesEither, "Referenceversionrules")}
  }
  
pub type Searchxpathusage{SearchxpathusageNormal
SearchxpathusagePhonetic
SearchxpathusageNearby
SearchxpathusageDistance
SearchxpathusageOther
}
pub fn searchxpathusage_to_json(searchxpathusage: Searchxpathusage) -> Json {
    case searchxpathusage {SearchxpathusageNormal -> json.string("normal")
SearchxpathusagePhonetic -> json.string("phonetic")
SearchxpathusageNearby -> json.string("nearby")
SearchxpathusageDistance -> json.string("distance")
SearchxpathusageOther -> json.string("other")
}
  }
  pub fn searchxpathusage_decoder() -> Decoder(Searchxpathusage) {
    use variant <- decode.then(decode.string)
    case variant {"normal" -> decode.success(SearchxpathusageNormal)
"phonetic" -> decode.success(SearchxpathusagePhonetic)
"nearby" -> decode.success(SearchxpathusageNearby)
"distance" -> decode.success(SearchxpathusageDistance)
"other" -> decode.success(SearchxpathusageOther)
_ -> decode.failure(SearchxpathusageNormal, "Searchxpathusage")}
  }
  
pub type Episodeofcarestatus{EpisodeofcarestatusPlanned
EpisodeofcarestatusWaitlist
EpisodeofcarestatusActive
EpisodeofcarestatusOnhold
EpisodeofcarestatusFinished
EpisodeofcarestatusCancelled
EpisodeofcarestatusEnteredinerror
}
pub fn episodeofcarestatus_to_json(episodeofcarestatus: Episodeofcarestatus) -> Json {
    case episodeofcarestatus {EpisodeofcarestatusPlanned -> json.string("planned")
EpisodeofcarestatusWaitlist -> json.string("waitlist")
EpisodeofcarestatusActive -> json.string("active")
EpisodeofcarestatusOnhold -> json.string("onhold")
EpisodeofcarestatusFinished -> json.string("finished")
EpisodeofcarestatusCancelled -> json.string("cancelled")
EpisodeofcarestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn episodeofcarestatus_decoder() -> Decoder(Episodeofcarestatus) {
    use variant <- decode.then(decode.string)
    case variant {"planned" -> decode.success(EpisodeofcarestatusPlanned)
"waitlist" -> decode.success(EpisodeofcarestatusWaitlist)
"active" -> decode.success(EpisodeofcarestatusActive)
"onhold" -> decode.success(EpisodeofcarestatusOnhold)
"finished" -> decode.success(EpisodeofcarestatusFinished)
"cancelled" -> decode.success(EpisodeofcarestatusCancelled)
"entered-in-error" -> decode.success(EpisodeofcarestatusEnteredinerror)
_ -> decode.failure(EpisodeofcarestatusPlanned, "Episodeofcarestatus")}
  }
  
pub type Invoicestatus{InvoicestatusDraft
InvoicestatusIssued
InvoicestatusBalanced
InvoicestatusCancelled
InvoicestatusEnteredinerror
}
pub fn invoicestatus_to_json(invoicestatus: Invoicestatus) -> Json {
    case invoicestatus {InvoicestatusDraft -> json.string("draft")
InvoicestatusIssued -> json.string("issued")
InvoicestatusBalanced -> json.string("balanced")
InvoicestatusCancelled -> json.string("cancelled")
InvoicestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn invoicestatus_decoder() -> Decoder(Invoicestatus) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(InvoicestatusDraft)
"issued" -> decode.success(InvoicestatusIssued)
"balanced" -> decode.success(InvoicestatusBalanced)
"cancelled" -> decode.success(InvoicestatusCancelled)
"entered-in-error" -> decode.success(InvoicestatusEnteredinerror)
_ -> decode.failure(InvoicestatusDraft, "Invoicestatus")}
  }
  
pub type Requeststatus{RequeststatusDraft
RequeststatusActive
RequeststatusOnhold
RequeststatusRevoked
RequeststatusCompleted
RequeststatusEnteredinerror
RequeststatusUnknown
}
pub fn requeststatus_to_json(requeststatus: Requeststatus) -> Json {
    case requeststatus {RequeststatusDraft -> json.string("draft")
RequeststatusActive -> json.string("active")
RequeststatusOnhold -> json.string("on-hold")
RequeststatusRevoked -> json.string("revoked")
RequeststatusCompleted -> json.string("completed")
RequeststatusEnteredinerror -> json.string("entered-in-error")
RequeststatusUnknown -> json.string("unknown")
}
  }
  pub fn requeststatus_decoder() -> Decoder(Requeststatus) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(RequeststatusDraft)
"active" -> decode.success(RequeststatusActive)
"on-hold" -> decode.success(RequeststatusOnhold)
"revoked" -> decode.success(RequeststatusRevoked)
"completed" -> decode.success(RequeststatusCompleted)
"entered-in-error" -> decode.success(RequeststatusEnteredinerror)
"unknown" -> decode.success(RequeststatusUnknown)
_ -> decode.failure(RequeststatusDraft, "Requeststatus")}
  }
  
pub type Maptransform{MaptransformCreate
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
    case maptransform {MaptransformCreate -> json.string("create")
MaptransformCopy -> json.string("copy")
MaptransformTruncate -> json.string("truncate")
MaptransformEscape -> json.string("escape")
MaptransformCast -> json.string("cast")
MaptransformAppend -> json.string("append")
MaptransformTranslate -> json.string("translate")
MaptransformReference -> json.string("reference")
MaptransformDateop -> json.string("dateOp")
MaptransformUuid -> json.string("uuid")
MaptransformPointer -> json.string("pointer")
MaptransformEvaluate -> json.string("evaluate")
MaptransformCc -> json.string("cc")
MaptransformC -> json.string("c")
MaptransformQty -> json.string("qty")
MaptransformId -> json.string("id")
MaptransformCp -> json.string("cp")
}
  }
  pub fn maptransform_decoder() -> Decoder(Maptransform) {
    use variant <- decode.then(decode.string)
    case variant {"create" -> decode.success(MaptransformCreate)
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
_ -> decode.failure(MaptransformCreate, "Maptransform")}
  }
  
pub type Requestintent{RequestintentProposal
RequestintentPlan
RequestintentDirective
RequestintentOrder
RequestintentOption
}
pub fn requestintent_to_json(requestintent: Requestintent) -> Json {
    case requestintent {RequestintentProposal -> json.string("proposal")
RequestintentPlan -> json.string("plan")
RequestintentDirective -> json.string("directive")
RequestintentOrder -> json.string("order")
RequestintentOption -> json.string("option")
}
  }
  pub fn requestintent_decoder() -> Decoder(Requestintent) {
    use variant <- decode.then(decode.string)
    case variant {"proposal" -> decode.success(RequestintentProposal)
"plan" -> decode.success(RequestintentPlan)
"directive" -> decode.success(RequestintentDirective)
"order" -> decode.success(RequestintentOrder)
"option" -> decode.success(RequestintentOption)
_ -> decode.failure(RequestintentProposal, "Requestintent")}
  }
  
pub type Versioningpolicy{VersioningpolicyNoversion
VersioningpolicyVersioned
VersioningpolicyVersionedupdate
}
pub fn versioningpolicy_to_json(versioningpolicy: Versioningpolicy) -> Json {
    case versioningpolicy {VersioningpolicyNoversion -> json.string("no-version")
VersioningpolicyVersioned -> json.string("versioned")
VersioningpolicyVersionedupdate -> json.string("versioned-update")
}
  }
  pub fn versioningpolicy_decoder() -> Decoder(Versioningpolicy) {
    use variant <- decode.then(decode.string)
    case variant {"no-version" -> decode.success(VersioningpolicyNoversion)
"versioned" -> decode.success(VersioningpolicyVersioned)
"versioned-update" -> decode.success(VersioningpolicyVersionedupdate)
_ -> decode.failure(VersioningpolicyNoversion, "Versioningpolicy")}
  }
  
pub type Medicationdispensestatus{MedicationdispensestatusPreparation
MedicationdispensestatusInprogress
MedicationdispensestatusCancelled
MedicationdispensestatusOnhold
MedicationdispensestatusCompleted
MedicationdispensestatusEnteredinerror
MedicationdispensestatusStopped
MedicationdispensestatusDeclined
MedicationdispensestatusUnknown
}
pub fn medicationdispensestatus_to_json(medicationdispensestatus: Medicationdispensestatus) -> Json {
    case medicationdispensestatus {MedicationdispensestatusPreparation -> json.string("preparation")
MedicationdispensestatusInprogress -> json.string("in-progress")
MedicationdispensestatusCancelled -> json.string("cancelled")
MedicationdispensestatusOnhold -> json.string("on-hold")
MedicationdispensestatusCompleted -> json.string("completed")
MedicationdispensestatusEnteredinerror -> json.string("entered-in-error")
MedicationdispensestatusStopped -> json.string("stopped")
MedicationdispensestatusDeclined -> json.string("declined")
MedicationdispensestatusUnknown -> json.string("unknown")
}
  }
  pub fn medicationdispensestatus_decoder() -> Decoder(Medicationdispensestatus) {
    use variant <- decode.then(decode.string)
    case variant {"preparation" -> decode.success(MedicationdispensestatusPreparation)
"in-progress" -> decode.success(MedicationdispensestatusInprogress)
"cancelled" -> decode.success(MedicationdispensestatusCancelled)
"on-hold" -> decode.success(MedicationdispensestatusOnhold)
"completed" -> decode.success(MedicationdispensestatusCompleted)
"entered-in-error" -> decode.success(MedicationdispensestatusEnteredinerror)
"stopped" -> decode.success(MedicationdispensestatusStopped)
"declined" -> decode.success(MedicationdispensestatusDeclined)
"unknown" -> decode.success(MedicationdispensestatusUnknown)
_ -> decode.failure(MedicationdispensestatusPreparation, "Medicationdispensestatus")}
  }
  
pub type Strandtype{StrandtypeWatson
StrandtypeCrick
}
pub fn strandtype_to_json(strandtype: Strandtype) -> Json {
    case strandtype {StrandtypeWatson -> json.string("watson")
StrandtypeCrick -> json.string("crick")
}
  }
  pub fn strandtype_decoder() -> Decoder(Strandtype) {
    use variant <- decode.then(decode.string)
    case variant {"watson" -> decode.success(StrandtypeWatson)
"crick" -> decode.success(StrandtypeCrick)
_ -> decode.failure(StrandtypeWatson, "Strandtype")}
  }
  
pub type Namingsystemtype{NamingsystemtypeCodesystem
NamingsystemtypeIdentifier
NamingsystemtypeRoot
}
pub fn namingsystemtype_to_json(namingsystemtype: Namingsystemtype) -> Json {
    case namingsystemtype {NamingsystemtypeCodesystem -> json.string("codesystem")
NamingsystemtypeIdentifier -> json.string("identifier")
NamingsystemtypeRoot -> json.string("root")
}
  }
  pub fn namingsystemtype_decoder() -> Decoder(Namingsystemtype) {
    use variant <- decode.then(decode.string)
    case variant {"codesystem" -> decode.success(NamingsystemtypeCodesystem)
"identifier" -> decode.success(NamingsystemtypeIdentifier)
"root" -> decode.success(NamingsystemtypeRoot)
_ -> decode.failure(NamingsystemtypeCodesystem, "Namingsystemtype")}
  }
  
pub type Assertresponsecodetypes{AssertresponsecodetypesOkay
AssertresponsecodetypesCreated
AssertresponsecodetypesNocontent
AssertresponsecodetypesNotmodified
AssertresponsecodetypesBad
AssertresponsecodetypesForbidden
AssertresponsecodetypesNotfound
AssertresponsecodetypesMethodnotallowed
AssertresponsecodetypesConflict
AssertresponsecodetypesGone
AssertresponsecodetypesPreconditionfailed
AssertresponsecodetypesUnprocessable
}
pub fn assertresponsecodetypes_to_json(assertresponsecodetypes: Assertresponsecodetypes) -> Json {
    case assertresponsecodetypes {AssertresponsecodetypesOkay -> json.string("okay")
AssertresponsecodetypesCreated -> json.string("created")
AssertresponsecodetypesNocontent -> json.string("noContent")
AssertresponsecodetypesNotmodified -> json.string("notModified")
AssertresponsecodetypesBad -> json.string("bad")
AssertresponsecodetypesForbidden -> json.string("forbidden")
AssertresponsecodetypesNotfound -> json.string("notFound")
AssertresponsecodetypesMethodnotallowed -> json.string("methodNotAllowed")
AssertresponsecodetypesConflict -> json.string("conflict")
AssertresponsecodetypesGone -> json.string("gone")
AssertresponsecodetypesPreconditionfailed -> json.string("preconditionFailed")
AssertresponsecodetypesUnprocessable -> json.string("unprocessable")
}
  }
  pub fn assertresponsecodetypes_decoder() -> Decoder(Assertresponsecodetypes) {
    use variant <- decode.then(decode.string)
    case variant {"okay" -> decode.success(AssertresponsecodetypesOkay)
"created" -> decode.success(AssertresponsecodetypesCreated)
"noContent" -> decode.success(AssertresponsecodetypesNocontent)
"notModified" -> decode.success(AssertresponsecodetypesNotmodified)
"bad" -> decode.success(AssertresponsecodetypesBad)
"forbidden" -> decode.success(AssertresponsecodetypesForbidden)
"notFound" -> decode.success(AssertresponsecodetypesNotfound)
"methodNotAllowed" -> decode.success(AssertresponsecodetypesMethodnotallowed)
"conflict" -> decode.success(AssertresponsecodetypesConflict)
"gone" -> decode.success(AssertresponsecodetypesGone)
"preconditionFailed" -> decode.success(AssertresponsecodetypesPreconditionfailed)
"unprocessable" -> decode.success(AssertresponsecodetypesUnprocessable)
_ -> decode.failure(AssertresponsecodetypesOkay, "Assertresponsecodetypes")}
  }
  
pub type Guidanceresponsestatus{GuidanceresponsestatusSuccess
GuidanceresponsestatusDatarequested
GuidanceresponsestatusDatarequired
GuidanceresponsestatusInprogress
GuidanceresponsestatusFailure
GuidanceresponsestatusEnteredinerror
}
pub fn guidanceresponsestatus_to_json(guidanceresponsestatus: Guidanceresponsestatus) -> Json {
    case guidanceresponsestatus {GuidanceresponsestatusSuccess -> json.string("success")
GuidanceresponsestatusDatarequested -> json.string("data-requested")
GuidanceresponsestatusDatarequired -> json.string("data-required")
GuidanceresponsestatusInprogress -> json.string("in-progress")
GuidanceresponsestatusFailure -> json.string("failure")
GuidanceresponsestatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn guidanceresponsestatus_decoder() -> Decoder(Guidanceresponsestatus) {
    use variant <- decode.then(decode.string)
    case variant {"success" -> decode.success(GuidanceresponsestatusSuccess)
"data-requested" -> decode.success(GuidanceresponsestatusDatarequested)
"data-required" -> decode.success(GuidanceresponsestatusDatarequired)
"in-progress" -> decode.success(GuidanceresponsestatusInprogress)
"failure" -> decode.success(GuidanceresponsestatusFailure)
"entered-in-error" -> decode.success(GuidanceresponsestatusEnteredinerror)
_ -> decode.failure(GuidanceresponsestatusSuccess, "Guidanceresponsestatus")}
  }
  
pub type Medicationrequeststatus{MedicationrequeststatusActive
MedicationrequeststatusOnhold
MedicationrequeststatusCancelled
MedicationrequeststatusCompleted
MedicationrequeststatusEnteredinerror
MedicationrequeststatusStopped
MedicationrequeststatusDraft
MedicationrequeststatusUnknown
}
pub fn medicationrequeststatus_to_json(medicationrequeststatus: Medicationrequeststatus) -> Json {
    case medicationrequeststatus {MedicationrequeststatusActive -> json.string("active")
MedicationrequeststatusOnhold -> json.string("on-hold")
MedicationrequeststatusCancelled -> json.string("cancelled")
MedicationrequeststatusCompleted -> json.string("completed")
MedicationrequeststatusEnteredinerror -> json.string("entered-in-error")
MedicationrequeststatusStopped -> json.string("stopped")
MedicationrequeststatusDraft -> json.string("draft")
MedicationrequeststatusUnknown -> json.string("unknown")
}
  }
  pub fn medicationrequeststatus_decoder() -> Decoder(Medicationrequeststatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(MedicationrequeststatusActive)
"on-hold" -> decode.success(MedicationrequeststatusOnhold)
"cancelled" -> decode.success(MedicationrequeststatusCancelled)
"completed" -> decode.success(MedicationrequeststatusCompleted)
"entered-in-error" -> decode.success(MedicationrequeststatusEnteredinerror)
"stopped" -> decode.success(MedicationrequeststatusStopped)
"draft" -> decode.success(MedicationrequeststatusDraft)
"unknown" -> decode.success(MedicationrequeststatusUnknown)
_ -> decode.failure(MedicationrequeststatusActive, "Medicationrequeststatus")}
  }
  
pub type Resourceaggregationmode{ResourceaggregationmodeContained
ResourceaggregationmodeReferenced
}
pub fn resourceaggregationmode_to_json(resourceaggregationmode: Resourceaggregationmode) -> Json {
    case resourceaggregationmode {ResourceaggregationmodeContained -> json.string("contained")
ResourceaggregationmodeReferenced -> json.string("referenced")
}
  }
  pub fn resourceaggregationmode_decoder() -> Decoder(Resourceaggregationmode) {
    use variant <- decode.then(decode.string)
    case variant {"contained" -> decode.success(ResourceaggregationmodeContained)
"referenced" -> decode.success(ResourceaggregationmodeReferenced)
_ -> decode.failure(ResourceaggregationmodeContained, "Resourceaggregationmode")}
  }
  
pub type Issuetype{IssuetypeInvalid
IssuetypeSecurity
IssuetypeProcessing
IssuetypeTransient
IssuetypeInformational
}
pub fn issuetype_to_json(issuetype: Issuetype) -> Json {
    case issuetype {IssuetypeInvalid -> json.string("invalid")
IssuetypeSecurity -> json.string("security")
IssuetypeProcessing -> json.string("processing")
IssuetypeTransient -> json.string("transient")
IssuetypeInformational -> json.string("informational")
}
  }
  pub fn issuetype_decoder() -> Decoder(Issuetype) {
    use variant <- decode.then(decode.string)
    case variant {"invalid" -> decode.success(IssuetypeInvalid)
"security" -> decode.success(IssuetypeSecurity)
"processing" -> decode.success(IssuetypeProcessing)
"transient" -> decode.success(IssuetypeTransient)
"informational" -> decode.success(IssuetypeInformational)
_ -> decode.failure(IssuetypeInvalid, "Issuetype")}
  }
  
pub type Addresstype{AddresstypePostal
AddresstypePhysical
AddresstypeBoth
}
pub fn addresstype_to_json(addresstype: Addresstype) -> Json {
    case addresstype {AddresstypePostal -> json.string("postal")
AddresstypePhysical -> json.string("physical")
AddresstypeBoth -> json.string("both")
}
  }
  pub fn addresstype_decoder() -> Decoder(Addresstype) {
    use variant <- decode.then(decode.string)
    case variant {"postal" -> decode.success(AddresstypePostal)
"physical" -> decode.success(AddresstypePhysical)
"both" -> decode.success(AddresstypeBoth)
_ -> decode.failure(AddresstypePostal, "Addresstype")}
  }
  
pub type Linktype{LinktypeReplacedby
LinktypeReplaces
LinktypeRefer
LinktypeSeealso
}
pub fn linktype_to_json(linktype: Linktype) -> Json {
    case linktype {LinktypeReplacedby -> json.string("replaced-by")
LinktypeReplaces -> json.string("replaces")
LinktypeRefer -> json.string("refer")
LinktypeSeealso -> json.string("seealso")
}
  }
  pub fn linktype_decoder() -> Decoder(Linktype) {
    use variant <- decode.then(decode.string)
    case variant {"replaced-by" -> decode.success(LinktypeReplacedby)
"replaces" -> decode.success(LinktypeReplaces)
"refer" -> decode.success(LinktypeRefer)
"seealso" -> decode.success(LinktypeSeealso)
_ -> decode.failure(LinktypeReplacedby, "Linktype")}
  }
  
pub type Administrativegender{AdministrativegenderMale
AdministrativegenderFemale
AdministrativegenderOther
AdministrativegenderUnknown
}
pub fn administrativegender_to_json(administrativegender: Administrativegender) -> Json {
    case administrativegender {AdministrativegenderMale -> json.string("male")
AdministrativegenderFemale -> json.string("female")
AdministrativegenderOther -> json.string("other")
AdministrativegenderUnknown -> json.string("unknown")
}
  }
  pub fn administrativegender_decoder() -> Decoder(Administrativegender) {
    use variant <- decode.then(decode.string)
    case variant {"male" -> decode.success(AdministrativegenderMale)
"female" -> decode.success(AdministrativegenderFemale)
"other" -> decode.success(AdministrativegenderOther)
"unknown" -> decode.success(AdministrativegenderUnknown)
_ -> decode.failure(AdministrativegenderMale, "Administrativegender")}
  }
  
pub type Graphcompartmentuse{GraphcompartmentuseCondition
GraphcompartmentuseRequirement
}
pub fn graphcompartmentuse_to_json(graphcompartmentuse: Graphcompartmentuse) -> Json {
    case graphcompartmentuse {GraphcompartmentuseCondition -> json.string("condition")
GraphcompartmentuseRequirement -> json.string("requirement")
}
  }
  pub fn graphcompartmentuse_decoder() -> Decoder(Graphcompartmentuse) {
    use variant <- decode.then(decode.string)
    case variant {"condition" -> decode.success(GraphcompartmentuseCondition)
"requirement" -> decode.success(GraphcompartmentuseRequirement)
_ -> decode.failure(GraphcompartmentuseCondition, "Graphcompartmentuse")}
  }
  
pub type Httpoperations{HttpoperationsDelete
HttpoperationsGet
HttpoperationsOptions
HttpoperationsPatch
HttpoperationsPost
HttpoperationsPut
HttpoperationsHead
}
pub fn httpoperations_to_json(httpoperations: Httpoperations) -> Json {
    case httpoperations {HttpoperationsDelete -> json.string("delete")
HttpoperationsGet -> json.string("get")
HttpoperationsOptions -> json.string("options")
HttpoperationsPatch -> json.string("patch")
HttpoperationsPost -> json.string("post")
HttpoperationsPut -> json.string("put")
HttpoperationsHead -> json.string("head")
}
  }
  pub fn httpoperations_decoder() -> Decoder(Httpoperations) {
    use variant <- decode.then(decode.string)
    case variant {"delete" -> decode.success(HttpoperationsDelete)
"get" -> decode.success(HttpoperationsGet)
"options" -> decode.success(HttpoperationsOptions)
"patch" -> decode.success(HttpoperationsPatch)
"post" -> decode.success(HttpoperationsPost)
"put" -> decode.success(HttpoperationsPut)
"head" -> decode.success(HttpoperationsHead)
_ -> decode.failure(HttpoperationsDelete, "Httpoperations")}
  }
  
pub type Clinicalusedefinitiontype{ClinicalusedefinitiontypeIndication
ClinicalusedefinitiontypeContraindication
ClinicalusedefinitiontypeInteraction
ClinicalusedefinitiontypeUndesirableeffect
ClinicalusedefinitiontypeWarning
}
pub fn clinicalusedefinitiontype_to_json(clinicalusedefinitiontype: Clinicalusedefinitiontype) -> Json {
    case clinicalusedefinitiontype {ClinicalusedefinitiontypeIndication -> json.string("indication")
ClinicalusedefinitiontypeContraindication -> json.string("contraindication")
ClinicalusedefinitiontypeInteraction -> json.string("interaction")
ClinicalusedefinitiontypeUndesirableeffect -> json.string("undesirable-effect")
ClinicalusedefinitiontypeWarning -> json.string("warning")
}
  }
  pub fn clinicalusedefinitiontype_decoder() -> Decoder(Clinicalusedefinitiontype) {
    use variant <- decode.then(decode.string)
    case variant {"indication" -> decode.success(ClinicalusedefinitiontypeIndication)
"contraindication" -> decode.success(ClinicalusedefinitiontypeContraindication)
"interaction" -> decode.success(ClinicalusedefinitiontypeInteraction)
"undesirable-effect" -> decode.success(ClinicalusedefinitiontypeUndesirableeffect)
"warning" -> decode.success(ClinicalusedefinitiontypeWarning)
_ -> decode.failure(ClinicalusedefinitiontypeIndication, "Clinicalusedefinitiontype")}
  }
  
pub type Eligibilityrequestpurpose{EligibilityrequestpurposeAuthrequirements
EligibilityrequestpurposeBenefits
EligibilityrequestpurposeDiscovery
EligibilityrequestpurposeValidation
}
pub fn eligibilityrequestpurpose_to_json(eligibilityrequestpurpose: Eligibilityrequestpurpose) -> Json {
    case eligibilityrequestpurpose {EligibilityrequestpurposeAuthrequirements -> json.string("auth-requirements")
EligibilityrequestpurposeBenefits -> json.string("benefits")
EligibilityrequestpurposeDiscovery -> json.string("discovery")
EligibilityrequestpurposeValidation -> json.string("validation")
}
  }
  pub fn eligibilityrequestpurpose_decoder() -> Decoder(Eligibilityrequestpurpose) {
    use variant <- decode.then(decode.string)
    case variant {"auth-requirements" -> decode.success(EligibilityrequestpurposeAuthrequirements)
"benefits" -> decode.success(EligibilityrequestpurposeBenefits)
"discovery" -> decode.success(EligibilityrequestpurposeDiscovery)
"validation" -> decode.success(EligibilityrequestpurposeValidation)
_ -> decode.failure(EligibilityrequestpurposeAuthrequirements, "Eligibilityrequestpurpose")}
  }
  
pub type Slotstatus{SlotstatusBusy
SlotstatusFree
SlotstatusBusyunavailable
SlotstatusBusytentative
SlotstatusEnteredinerror
}
pub fn slotstatus_to_json(slotstatus: Slotstatus) -> Json {
    case slotstatus {SlotstatusBusy -> json.string("busy")
SlotstatusFree -> json.string("free")
SlotstatusBusyunavailable -> json.string("busy-unavailable")
SlotstatusBusytentative -> json.string("busy-tentative")
SlotstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn slotstatus_decoder() -> Decoder(Slotstatus) {
    use variant <- decode.then(decode.string)
    case variant {"busy" -> decode.success(SlotstatusBusy)
"free" -> decode.success(SlotstatusFree)
"busy-unavailable" -> decode.success(SlotstatusBusyunavailable)
"busy-tentative" -> decode.success(SlotstatusBusytentative)
"entered-in-error" -> decode.success(SlotstatusEnteredinerror)
_ -> decode.failure(SlotstatusBusy, "Slotstatus")}
  }
  
pub type Systemrestfulinteraction{SystemrestfulinteractionTransaction
SystemrestfulinteractionBatch
SystemrestfulinteractionSearchsystem
SystemrestfulinteractionHistorysystem
}
pub fn systemrestfulinteraction_to_json(systemrestfulinteraction: Systemrestfulinteraction) -> Json {
    case systemrestfulinteraction {SystemrestfulinteractionTransaction -> json.string("transaction")
SystemrestfulinteractionBatch -> json.string("batch")
SystemrestfulinteractionSearchsystem -> json.string("search-system")
SystemrestfulinteractionHistorysystem -> json.string("history-system")
}
  }
  pub fn systemrestfulinteraction_decoder() -> Decoder(Systemrestfulinteraction) {
    use variant <- decode.then(decode.string)
    case variant {"transaction" -> decode.success(SystemrestfulinteractionTransaction)
"batch" -> decode.success(SystemrestfulinteractionBatch)
"search-system" -> decode.success(SystemrestfulinteractionSearchsystem)
"history-system" -> decode.success(SystemrestfulinteractionHistorysystem)
_ -> decode.failure(SystemrestfulinteractionTransaction, "Systemrestfulinteraction")}
  }
  
pub type Contributortype{ContributortypeAuthor
ContributortypeEditor
ContributortypeReviewer
ContributortypeEndorser
}
pub fn contributortype_to_json(contributortype: Contributortype) -> Json {
    case contributortype {ContributortypeAuthor -> json.string("author")
ContributortypeEditor -> json.string("editor")
ContributortypeReviewer -> json.string("reviewer")
ContributortypeEndorser -> json.string("endorser")
}
  }
  pub fn contributortype_decoder() -> Decoder(Contributortype) {
    use variant <- decode.then(decode.string)
    case variant {"author" -> decode.success(ContributortypeAuthor)
"editor" -> decode.success(ContributortypeEditor)
"reviewer" -> decode.success(ContributortypeReviewer)
"endorser" -> decode.success(ContributortypeEndorser)
_ -> decode.failure(ContributortypeAuthor, "Contributortype")}
  }
  
pub type Discriminatortype{DiscriminatortypeValue
DiscriminatortypeExists
DiscriminatortypePattern
DiscriminatortypeType
DiscriminatortypeProfile
}
pub fn discriminatortype_to_json(discriminatortype: Discriminatortype) -> Json {
    case discriminatortype {DiscriminatortypeValue -> json.string("value")
DiscriminatortypeExists -> json.string("exists")
DiscriminatortypePattern -> json.string("pattern")
DiscriminatortypeType -> json.string("type")
DiscriminatortypeProfile -> json.string("profile")
}
  }
  pub fn discriminatortype_decoder() -> Decoder(Discriminatortype) {
    use variant <- decode.then(decode.string)
    case variant {"value" -> decode.success(DiscriminatortypeValue)
"exists" -> decode.success(DiscriminatortypeExists)
"pattern" -> decode.success(DiscriminatortypePattern)
"type" -> decode.success(DiscriminatortypeType)
"profile" -> decode.success(DiscriminatortypeProfile)
_ -> decode.failure(DiscriminatortypeValue, "Discriminatortype")}
  }
  
pub type Medicationadminstatus{MedicationadminstatusInprogress
MedicationadminstatusNotdone
MedicationadminstatusOnhold
MedicationadminstatusCompleted
MedicationadminstatusEnteredinerror
MedicationadminstatusStopped
MedicationadminstatusUnknown
}
pub fn medicationadminstatus_to_json(medicationadminstatus: Medicationadminstatus) -> Json {
    case medicationadminstatus {MedicationadminstatusInprogress -> json.string("in-progress")
MedicationadminstatusNotdone -> json.string("not-done")
MedicationadminstatusOnhold -> json.string("on-hold")
MedicationadminstatusCompleted -> json.string("completed")
MedicationadminstatusEnteredinerror -> json.string("entered-in-error")
MedicationadminstatusStopped -> json.string("stopped")
MedicationadminstatusUnknown -> json.string("unknown")
}
  }
  pub fn medicationadminstatus_decoder() -> Decoder(Medicationadminstatus) {
    use variant <- decode.then(decode.string)
    case variant {"in-progress" -> decode.success(MedicationadminstatusInprogress)
"not-done" -> decode.success(MedicationadminstatusNotdone)
"on-hold" -> decode.success(MedicationadminstatusOnhold)
"completed" -> decode.success(MedicationadminstatusCompleted)
"entered-in-error" -> decode.success(MedicationadminstatusEnteredinerror)
"stopped" -> decode.success(MedicationadminstatusStopped)
"unknown" -> decode.success(MedicationadminstatusUnknown)
_ -> decode.failure(MedicationadminstatusInprogress, "Medicationadminstatus")}
  }
  
pub type Notetype{NotetypeDisplay
NotetypePrint
NotetypePrintoper
}
pub fn notetype_to_json(notetype: Notetype) -> Json {
    case notetype {NotetypeDisplay -> json.string("display")
NotetypePrint -> json.string("print")
NotetypePrintoper -> json.string("printoper")
}
  }
  pub fn notetype_decoder() -> Decoder(Notetype) {
    use variant <- decode.then(decode.string)
    case variant {"display" -> decode.success(NotetypeDisplay)
"print" -> decode.success(NotetypePrint)
"printoper" -> decode.success(NotetypePrintoper)
_ -> decode.failure(NotetypeDisplay, "Notetype")}
  }
  
pub type Eventstatus{EventstatusPreparation
EventstatusInprogress
EventstatusNotdone
EventstatusOnhold
EventstatusStopped
EventstatusCompleted
EventstatusEnteredinerror
EventstatusUnknown
}
pub fn eventstatus_to_json(eventstatus: Eventstatus) -> Json {
    case eventstatus {EventstatusPreparation -> json.string("preparation")
EventstatusInprogress -> json.string("in-progress")
EventstatusNotdone -> json.string("not-done")
EventstatusOnhold -> json.string("on-hold")
EventstatusStopped -> json.string("stopped")
EventstatusCompleted -> json.string("completed")
EventstatusEnteredinerror -> json.string("entered-in-error")
EventstatusUnknown -> json.string("unknown")
}
  }
  pub fn eventstatus_decoder() -> Decoder(Eventstatus) {
    use variant <- decode.then(decode.string)
    case variant {"preparation" -> decode.success(EventstatusPreparation)
"in-progress" -> decode.success(EventstatusInprogress)
"not-done" -> decode.success(EventstatusNotdone)
"on-hold" -> decode.success(EventstatusOnhold)
"stopped" -> decode.success(EventstatusStopped)
"completed" -> decode.success(EventstatusCompleted)
"entered-in-error" -> decode.success(EventstatusEnteredinerror)
"unknown" -> decode.success(EventstatusUnknown)
_ -> decode.failure(EventstatusPreparation, "Eventstatus")}
  }
  
pub type Mapsourcelistmode{MapsourcelistmodeFirst
MapsourcelistmodeNotfirst
MapsourcelistmodeLast
MapsourcelistmodeNotlast
MapsourcelistmodeOnlyone
}
pub fn mapsourcelistmode_to_json(mapsourcelistmode: Mapsourcelistmode) -> Json {
    case mapsourcelistmode {MapsourcelistmodeFirst -> json.string("first")
MapsourcelistmodeNotfirst -> json.string("not_first")
MapsourcelistmodeLast -> json.string("last")
MapsourcelistmodeNotlast -> json.string("not_last")
MapsourcelistmodeOnlyone -> json.string("only_one")
}
  }
  pub fn mapsourcelistmode_decoder() -> Decoder(Mapsourcelistmode) {
    use variant <- decode.then(decode.string)
    case variant {"first" -> decode.success(MapsourcelistmodeFirst)
"not_first" -> decode.success(MapsourcelistmodeNotfirst)
"last" -> decode.success(MapsourcelistmodeLast)
"not_last" -> decode.success(MapsourcelistmodeNotlast)
"only_one" -> decode.success(MapsourcelistmodeOnlyone)
_ -> decode.failure(MapsourcelistmodeFirst, "Mapsourcelistmode")}
  }
  
pub type Relationtype{RelationtypeTriggers
RelationtypeIsreplacedby
}
pub fn relationtype_to_json(relationtype: Relationtype) -> Json {
    case relationtype {RelationtypeTriggers -> json.string("triggers")
RelationtypeIsreplacedby -> json.string("is-replaced-by")
}
  }
  pub fn relationtype_decoder() -> Decoder(Relationtype) {
    use variant <- decode.then(decode.string)
    case variant {"triggers" -> decode.success(RelationtypeTriggers)
"is-replaced-by" -> decode.success(RelationtypeIsreplacedby)
_ -> decode.failure(RelationtypeTriggers, "Relationtype")}
  }
  
pub type Devicestatementstatus{DevicestatementstatusActive
DevicestatementstatusCompleted
DevicestatementstatusEnteredinerror
DevicestatementstatusIntended
DevicestatementstatusStopped
DevicestatementstatusOnhold
}
pub fn devicestatementstatus_to_json(devicestatementstatus: Devicestatementstatus) -> Json {
    case devicestatementstatus {DevicestatementstatusActive -> json.string("active")
DevicestatementstatusCompleted -> json.string("completed")
DevicestatementstatusEnteredinerror -> json.string("entered-in-error")
DevicestatementstatusIntended -> json.string("intended")
DevicestatementstatusStopped -> json.string("stopped")
DevicestatementstatusOnhold -> json.string("on-hold")
}
  }
  pub fn devicestatementstatus_decoder() -> Decoder(Devicestatementstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(DevicestatementstatusActive)
"completed" -> decode.success(DevicestatementstatusCompleted)
"entered-in-error" -> decode.success(DevicestatementstatusEnteredinerror)
"intended" -> decode.success(DevicestatementstatusIntended)
"stopped" -> decode.success(DevicestatementstatusStopped)
"on-hold" -> decode.success(DevicestatementstatusOnhold)
_ -> decode.failure(DevicestatementstatusActive, "Devicestatementstatus")}
  }
  
pub type Repositorytype{RepositorytypeDirectlink
RepositorytypeOpenapi
RepositorytypeLogin
RepositorytypeOauth
RepositorytypeOther
}
pub fn repositorytype_to_json(repositorytype: Repositorytype) -> Json {
    case repositorytype {RepositorytypeDirectlink -> json.string("directlink")
RepositorytypeOpenapi -> json.string("openapi")
RepositorytypeLogin -> json.string("login")
RepositorytypeOauth -> json.string("oauth")
RepositorytypeOther -> json.string("other")
}
  }
  pub fn repositorytype_decoder() -> Decoder(Repositorytype) {
    use variant <- decode.then(decode.string)
    case variant {"directlink" -> decode.success(RepositorytypeDirectlink)
"openapi" -> decode.success(RepositorytypeOpenapi)
"login" -> decode.success(RepositorytypeLogin)
"oauth" -> decode.success(RepositorytypeOauth)
"other" -> decode.success(RepositorytypeOther)
_ -> decode.failure(RepositorytypeDirectlink, "Repositorytype")}
  }
  
pub type Subscriptionsearchmodifier{SubscriptionsearchmodifierEqual
SubscriptionsearchmodifierEq
SubscriptionsearchmodifierNe
SubscriptionsearchmodifierGt
SubscriptionsearchmodifierLt
SubscriptionsearchmodifierGe
SubscriptionsearchmodifierLe
SubscriptionsearchmodifierSa
SubscriptionsearchmodifierEb
SubscriptionsearchmodifierAp
SubscriptionsearchmodifierAbove
SubscriptionsearchmodifierBelow
SubscriptionsearchmodifierIn
SubscriptionsearchmodifierNotin
SubscriptionsearchmodifierOftype
}
pub fn subscriptionsearchmodifier_to_json(subscriptionsearchmodifier: Subscriptionsearchmodifier) -> Json {
    case subscriptionsearchmodifier {SubscriptionsearchmodifierEqual -> json.string("=")
SubscriptionsearchmodifierEq -> json.string("eq")
SubscriptionsearchmodifierNe -> json.string("ne")
SubscriptionsearchmodifierGt -> json.string("gt")
SubscriptionsearchmodifierLt -> json.string("lt")
SubscriptionsearchmodifierGe -> json.string("ge")
SubscriptionsearchmodifierLe -> json.string("le")
SubscriptionsearchmodifierSa -> json.string("sa")
SubscriptionsearchmodifierEb -> json.string("eb")
SubscriptionsearchmodifierAp -> json.string("ap")
SubscriptionsearchmodifierAbove -> json.string("above")
SubscriptionsearchmodifierBelow -> json.string("below")
SubscriptionsearchmodifierIn -> json.string("in")
SubscriptionsearchmodifierNotin -> json.string("not-in")
SubscriptionsearchmodifierOftype -> json.string("of-type")
}
  }
  pub fn subscriptionsearchmodifier_decoder() -> Decoder(Subscriptionsearchmodifier) {
    use variant <- decode.then(decode.string)
    case variant {"=" -> decode.success(SubscriptionsearchmodifierEqual)
"eq" -> decode.success(SubscriptionsearchmodifierEq)
"ne" -> decode.success(SubscriptionsearchmodifierNe)
"gt" -> decode.success(SubscriptionsearchmodifierGt)
"lt" -> decode.success(SubscriptionsearchmodifierLt)
"ge" -> decode.success(SubscriptionsearchmodifierGe)
"le" -> decode.success(SubscriptionsearchmodifierLe)
"sa" -> decode.success(SubscriptionsearchmodifierSa)
"eb" -> decode.success(SubscriptionsearchmodifierEb)
"ap" -> decode.success(SubscriptionsearchmodifierAp)
"above" -> decode.success(SubscriptionsearchmodifierAbove)
"below" -> decode.success(SubscriptionsearchmodifierBelow)
"in" -> decode.success(SubscriptionsearchmodifierIn)
"not-in" -> decode.success(SubscriptionsearchmodifierNotin)
"of-type" -> decode.success(SubscriptionsearchmodifierOftype)
_ -> decode.failure(SubscriptionsearchmodifierEqual, "Subscriptionsearchmodifier")}
  }
  
pub type Characteristiccombination{CharacteristiccombinationIntersection
CharacteristiccombinationUnion
}
pub fn characteristiccombination_to_json(characteristiccombination: Characteristiccombination) -> Json {
    case characteristiccombination {CharacteristiccombinationIntersection -> json.string("intersection")
CharacteristiccombinationUnion -> json.string("union")
}
  }
  pub fn characteristiccombination_decoder() -> Decoder(Characteristiccombination) {
    use variant <- decode.then(decode.string)
    case variant {"intersection" -> decode.success(CharacteristiccombinationIntersection)
"union" -> decode.success(CharacteristiccombinationUnion)
_ -> decode.failure(CharacteristiccombinationIntersection, "Characteristiccombination")}
  }
  
pub type Medicationstatus{MedicationstatusActive
MedicationstatusInactive
MedicationstatusEnteredinerror
}
pub fn medicationstatus_to_json(medicationstatus: Medicationstatus) -> Json {
    case medicationstatus {MedicationstatusActive -> json.string("active")
MedicationstatusInactive -> json.string("inactive")
MedicationstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn medicationstatus_decoder() -> Decoder(Medicationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(MedicationstatusActive)
"inactive" -> decode.success(MedicationstatusInactive)
"entered-in-error" -> decode.success(MedicationstatusEnteredinerror)
_ -> decode.failure(MedicationstatusActive, "Medicationstatus")}
  }
  
pub type Constraintseverity{ConstraintseverityError
ConstraintseverityWarning
}
pub fn constraintseverity_to_json(constraintseverity: Constraintseverity) -> Json {
    case constraintseverity {ConstraintseverityError -> json.string("error")
ConstraintseverityWarning -> json.string("warning")
}
  }
  pub fn constraintseverity_decoder() -> Decoder(Constraintseverity) {
    use variant <- decode.then(decode.string)
    case variant {"error" -> decode.success(ConstraintseverityError)
"warning" -> decode.success(ConstraintseverityWarning)
_ -> decode.failure(ConstraintseverityError, "Constraintseverity")}
  }
  
pub type Supplydeliverystatus{SupplydeliverystatusInprogress
SupplydeliverystatusCompleted
SupplydeliverystatusAbandoned
SupplydeliverystatusEnteredinerror
}
pub fn supplydeliverystatus_to_json(supplydeliverystatus: Supplydeliverystatus) -> Json {
    case supplydeliverystatus {SupplydeliverystatusInprogress -> json.string("in-progress")
SupplydeliverystatusCompleted -> json.string("completed")
SupplydeliverystatusAbandoned -> json.string("abandoned")
SupplydeliverystatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn supplydeliverystatus_decoder() -> Decoder(Supplydeliverystatus) {
    use variant <- decode.then(decode.string)
    case variant {"in-progress" -> decode.success(SupplydeliverystatusInprogress)
"completed" -> decode.success(SupplydeliverystatusCompleted)
"abandoned" -> decode.success(SupplydeliverystatusAbandoned)
"entered-in-error" -> decode.success(SupplydeliverystatusEnteredinerror)
_ -> decode.failure(SupplydeliverystatusInprogress, "Supplydeliverystatus")}
  }
  
pub type Actiongroupingbehavior{ActiongroupingbehaviorVisualgroup
ActiongroupingbehaviorLogicalgroup
ActiongroupingbehaviorSentencegroup
}
pub fn actiongroupingbehavior_to_json(actiongroupingbehavior: Actiongroupingbehavior) -> Json {
    case actiongroupingbehavior {ActiongroupingbehaviorVisualgroup -> json.string("visual-group")
ActiongroupingbehaviorLogicalgroup -> json.string("logical-group")
ActiongroupingbehaviorSentencegroup -> json.string("sentence-group")
}
  }
  pub fn actiongroupingbehavior_decoder() -> Decoder(Actiongroupingbehavior) {
    use variant <- decode.then(decode.string)
    case variant {"visual-group" -> decode.success(ActiongroupingbehaviorVisualgroup)
"logical-group" -> decode.success(ActiongroupingbehaviorLogicalgroup)
"sentence-group" -> decode.success(ActiongroupingbehaviorSentencegroup)
_ -> decode.failure(ActiongroupingbehaviorVisualgroup, "Actiongroupingbehavior")}
  }
  
pub type Compositionstatus{CompositionstatusPreliminary
CompositionstatusFinal
CompositionstatusAmended
CompositionstatusEnteredinerror
}
pub fn compositionstatus_to_json(compositionstatus: Compositionstatus) -> Json {
    case compositionstatus {CompositionstatusPreliminary -> json.string("preliminary")
CompositionstatusFinal -> json.string("final")
CompositionstatusAmended -> json.string("amended")
CompositionstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn compositionstatus_decoder() -> Decoder(Compositionstatus) {
    use variant <- decode.then(decode.string)
    case variant {"preliminary" -> decode.success(CompositionstatusPreliminary)
"final" -> decode.success(CompositionstatusFinal)
"amended" -> decode.success(CompositionstatusAmended)
"entered-in-error" -> decode.success(CompositionstatusEnteredinerror)
_ -> decode.failure(CompositionstatusPreliminary, "Compositionstatus")}
  }
  
pub type Consentstatecodes{ConsentstatecodesDraft
ConsentstatecodesProposed
ConsentstatecodesActive
ConsentstatecodesRejected
ConsentstatecodesInactive
ConsentstatecodesEnteredinerror
}
pub fn consentstatecodes_to_json(consentstatecodes: Consentstatecodes) -> Json {
    case consentstatecodes {ConsentstatecodesDraft -> json.string("draft")
ConsentstatecodesProposed -> json.string("proposed")
ConsentstatecodesActive -> json.string("active")
ConsentstatecodesRejected -> json.string("rejected")
ConsentstatecodesInactive -> json.string("inactive")
ConsentstatecodesEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn consentstatecodes_decoder() -> Decoder(Consentstatecodes) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(ConsentstatecodesDraft)
"proposed" -> decode.success(ConsentstatecodesProposed)
"active" -> decode.success(ConsentstatecodesActive)
"rejected" -> decode.success(ConsentstatecodesRejected)
"inactive" -> decode.success(ConsentstatecodesInactive)
"entered-in-error" -> decode.success(ConsentstatecodesEnteredinerror)
_ -> decode.failure(ConsentstatecodesDraft, "Consentstatecodes")}
  }
  
pub type Itemtype{ItemtypeGroup
ItemtypeDisplay
ItemtypeQuestion
}
pub fn itemtype_to_json(itemtype: Itemtype) -> Json {
    case itemtype {ItemtypeGroup -> json.string("group")
ItemtypeDisplay -> json.string("display")
ItemtypeQuestion -> json.string("question")
}
  }
  pub fn itemtype_decoder() -> Decoder(Itemtype) {
    use variant <- decode.then(decode.string)
    case variant {"group" -> decode.success(ItemtypeGroup)
"display" -> decode.success(ItemtypeDisplay)
"question" -> decode.success(ItemtypeQuestion)
_ -> decode.failure(ItemtypeGroup, "Itemtype")}
  }
  
pub type Extensioncontexttype{ExtensioncontexttypeFhirpath
ExtensioncontexttypeElement
ExtensioncontexttypeExtension
}
pub fn extensioncontexttype_to_json(extensioncontexttype: Extensioncontexttype) -> Json {
    case extensioncontexttype {ExtensioncontexttypeFhirpath -> json.string("fhirpath")
ExtensioncontexttypeElement -> json.string("element")
ExtensioncontexttypeExtension -> json.string("extension")
}
  }
  pub fn extensioncontexttype_decoder() -> Decoder(Extensioncontexttype) {
    use variant <- decode.then(decode.string)
    case variant {"fhirpath" -> decode.success(ExtensioncontexttypeFhirpath)
"element" -> decode.success(ExtensioncontexttypeElement)
"extension" -> decode.success(ExtensioncontexttypeExtension)
_ -> decode.failure(ExtensioncontexttypeFhirpath, "Extensioncontexttype")}
  }
  
pub type Actionrequiredbehavior{ActionrequiredbehaviorMust
ActionrequiredbehaviorCould
ActionrequiredbehaviorMustunlessdocumented
}
pub fn actionrequiredbehavior_to_json(actionrequiredbehavior: Actionrequiredbehavior) -> Json {
    case actionrequiredbehavior {ActionrequiredbehaviorMust -> json.string("must")
ActionrequiredbehaviorCould -> json.string("could")
ActionrequiredbehaviorMustunlessdocumented -> json.string("must-unless-documented")
}
  }
  pub fn actionrequiredbehavior_decoder() -> Decoder(Actionrequiredbehavior) {
    use variant <- decode.then(decode.string)
    case variant {"must" -> decode.success(ActionrequiredbehaviorMust)
"could" -> decode.success(ActionrequiredbehaviorCould)
"must-unless-documented" -> decode.success(ActionrequiredbehaviorMustunlessdocumented)
_ -> decode.failure(ActionrequiredbehaviorMust, "Actionrequiredbehavior")}
  }
  
pub type Metriccalibrationtype{MetriccalibrationtypeUnspecified
MetriccalibrationtypeOffset
MetriccalibrationtypeGain
MetriccalibrationtypeTwopoint
}
pub fn metriccalibrationtype_to_json(metriccalibrationtype: Metriccalibrationtype) -> Json {
    case metriccalibrationtype {MetriccalibrationtypeUnspecified -> json.string("unspecified")
MetriccalibrationtypeOffset -> json.string("offset")
MetriccalibrationtypeGain -> json.string("gain")
MetriccalibrationtypeTwopoint -> json.string("two-point")
}
  }
  pub fn metriccalibrationtype_decoder() -> Decoder(Metriccalibrationtype) {
    use variant <- decode.then(decode.string)
    case variant {"unspecified" -> decode.success(MetriccalibrationtypeUnspecified)
"offset" -> decode.success(MetriccalibrationtypeOffset)
"gain" -> decode.success(MetriccalibrationtypeGain)
"two-point" -> decode.success(MetriccalibrationtypeTwopoint)
_ -> decode.failure(MetriccalibrationtypeUnspecified, "Metriccalibrationtype")}
  }
  
pub type Structuredefinitionkind{StructuredefinitionkindPrimitivetype
StructuredefinitionkindComplextype
StructuredefinitionkindResource
StructuredefinitionkindLogical
}
pub fn structuredefinitionkind_to_json(structuredefinitionkind: Structuredefinitionkind) -> Json {
    case structuredefinitionkind {StructuredefinitionkindPrimitivetype -> json.string("primitive-type")
StructuredefinitionkindComplextype -> json.string("complex-type")
StructuredefinitionkindResource -> json.string("resource")
StructuredefinitionkindLogical -> json.string("logical")
}
  }
  pub fn structuredefinitionkind_decoder() -> Decoder(Structuredefinitionkind) {
    use variant <- decode.then(decode.string)
    case variant {"primitive-type" -> decode.success(StructuredefinitionkindPrimitivetype)
"complex-type" -> decode.success(StructuredefinitionkindComplextype)
"resource" -> decode.success(StructuredefinitionkindResource)
"logical" -> decode.success(StructuredefinitionkindLogical)
_ -> decode.failure(StructuredefinitionkindPrimitivetype, "Structuredefinitionkind")}
  }
  
pub type Observationstatus{ObservationstatusRegistered
ObservationstatusPreliminary
ObservationstatusFinal
ObservationstatusAmended
ObservationstatusCancelled
ObservationstatusEnteredinerror
ObservationstatusUnknown
}
pub fn observationstatus_to_json(observationstatus: Observationstatus) -> Json {
    case observationstatus {ObservationstatusRegistered -> json.string("registered")
ObservationstatusPreliminary -> json.string("preliminary")
ObservationstatusFinal -> json.string("final")
ObservationstatusAmended -> json.string("amended")
ObservationstatusCancelled -> json.string("cancelled")
ObservationstatusEnteredinerror -> json.string("entered-in-error")
ObservationstatusUnknown -> json.string("unknown")
}
  }
  pub fn observationstatus_decoder() -> Decoder(Observationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"registered" -> decode.success(ObservationstatusRegistered)
"preliminary" -> decode.success(ObservationstatusPreliminary)
"final" -> decode.success(ObservationstatusFinal)
"amended" -> decode.success(ObservationstatusAmended)
"cancelled" -> decode.success(ObservationstatusCancelled)
"entered-in-error" -> decode.success(ObservationstatusEnteredinerror)
"unknown" -> decode.success(ObservationstatusUnknown)
_ -> decode.failure(ObservationstatusRegistered, "Observationstatus")}
  }
  
pub type Researchelementtype{ResearchelementtypePopulation
ResearchelementtypeExposure
ResearchelementtypeOutcome
}
pub fn researchelementtype_to_json(researchelementtype: Researchelementtype) -> Json {
    case researchelementtype {ResearchelementtypePopulation -> json.string("population")
ResearchelementtypeExposure -> json.string("exposure")
ResearchelementtypeOutcome -> json.string("outcome")
}
  }
  pub fn researchelementtype_decoder() -> Decoder(Researchelementtype) {
    use variant <- decode.then(decode.string)
    case variant {"population" -> decode.success(ResearchelementtypePopulation)
"exposure" -> decode.success(ResearchelementtypeExposure)
"outcome" -> decode.success(ResearchelementtypeOutcome)
_ -> decode.failure(ResearchelementtypePopulation, "Researchelementtype")}
  }
  
pub type Typederivationrule{TypederivationruleSpecialization
TypederivationruleConstraint
}
pub fn typederivationrule_to_json(typederivationrule: Typederivationrule) -> Json {
    case typederivationrule {TypederivationruleSpecialization -> json.string("specialization")
TypederivationruleConstraint -> json.string("constraint")
}
  }
  pub fn typederivationrule_decoder() -> Decoder(Typederivationrule) {
    use variant <- decode.then(decode.string)
    case variant {"specialization" -> decode.success(TypederivationruleSpecialization)
"constraint" -> decode.success(TypederivationruleConstraint)
_ -> decode.failure(TypederivationruleSpecialization, "Typederivationrule")}
  }
  
pub type Nutritionproductstatus{NutritionproductstatusActive
NutritionproductstatusInactive
NutritionproductstatusEnteredinerror
}
pub fn nutritionproductstatus_to_json(nutritionproductstatus: Nutritionproductstatus) -> Json {
    case nutritionproductstatus {NutritionproductstatusActive -> json.string("active")
NutritionproductstatusInactive -> json.string("inactive")
NutritionproductstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn nutritionproductstatus_decoder() -> Decoder(Nutritionproductstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(NutritionproductstatusActive)
"inactive" -> decode.success(NutritionproductstatusInactive)
"entered-in-error" -> decode.success(NutritionproductstatusEnteredinerror)
_ -> decode.failure(NutritionproductstatusActive, "Nutritionproductstatus")}
  }
  
pub type Questionnaireenableoperator{QuestionnaireenableoperatorExists
QuestionnaireenableoperatorEqual
QuestionnaireenableoperatorNotequal
QuestionnaireenableoperatorGreaterthan
QuestionnaireenableoperatorLessthan
QuestionnaireenableoperatorGreaterthanequal
QuestionnaireenableoperatorLessthanequal
}
pub fn questionnaireenableoperator_to_json(questionnaireenableoperator: Questionnaireenableoperator) -> Json {
    case questionnaireenableoperator {QuestionnaireenableoperatorExists -> json.string("exists")
QuestionnaireenableoperatorEqual -> json.string("=")
QuestionnaireenableoperatorNotequal -> json.string("!=")
QuestionnaireenableoperatorGreaterthan -> json.string(">")
QuestionnaireenableoperatorLessthan -> json.string("<")
QuestionnaireenableoperatorGreaterthanequal -> json.string(">=")
QuestionnaireenableoperatorLessthanequal -> json.string("<=")
}
  }
  pub fn questionnaireenableoperator_decoder() -> Decoder(Questionnaireenableoperator) {
    use variant <- decode.then(decode.string)
    case variant {"exists" -> decode.success(QuestionnaireenableoperatorExists)
"=" -> decode.success(QuestionnaireenableoperatorEqual)
"!=" -> decode.success(QuestionnaireenableoperatorNotequal)
">" -> decode.success(QuestionnaireenableoperatorGreaterthan)
"<" -> decode.success(QuestionnaireenableoperatorLessthan)
">=" -> decode.success(QuestionnaireenableoperatorGreaterthanequal)
"<=" -> decode.success(QuestionnaireenableoperatorLessthanequal)
_ -> decode.failure(QuestionnaireenableoperatorExists, "Questionnaireenableoperator")}
  }
  
pub type Taskstatus{TaskstatusDraft
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
    case taskstatus {TaskstatusDraft -> json.string("draft")
TaskstatusRequested -> json.string("requested")
TaskstatusReceived -> json.string("received")
TaskstatusAccepted -> json.string("accepted")
TaskstatusRejected -> json.string("rejected")
TaskstatusReady -> json.string("ready")
TaskstatusCancelled -> json.string("cancelled")
TaskstatusInprogress -> json.string("in-progress")
TaskstatusOnhold -> json.string("on-hold")
TaskstatusFailed -> json.string("failed")
TaskstatusCompleted -> json.string("completed")
TaskstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn taskstatus_decoder() -> Decoder(Taskstatus) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(TaskstatusDraft)
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
_ -> decode.failure(TaskstatusDraft, "Taskstatus")}
  }
  
pub type Qualitytype{QualitytypeIndel
QualitytypeSnp
QualitytypeUnknown
}
pub fn qualitytype_to_json(qualitytype: Qualitytype) -> Json {
    case qualitytype {QualitytypeIndel -> json.string("indel")
QualitytypeSnp -> json.string("snp")
QualitytypeUnknown -> json.string("unknown")
}
  }
  pub fn qualitytype_decoder() -> Decoder(Qualitytype) {
    use variant <- decode.then(decode.string)
    case variant {"indel" -> decode.success(QualitytypeIndel)
"snp" -> decode.success(QualitytypeSnp)
"unknown" -> decode.success(QualitytypeUnknown)
_ -> decode.failure(QualitytypeIndel, "Qualitytype")}
  }
  
pub type Actionprecheckbehavior{ActionprecheckbehaviorYes
ActionprecheckbehaviorNo
}
pub fn actionprecheckbehavior_to_json(actionprecheckbehavior: Actionprecheckbehavior) -> Json {
    case actionprecheckbehavior {ActionprecheckbehaviorYes -> json.string("yes")
ActionprecheckbehaviorNo -> json.string("no")
}
  }
  pub fn actionprecheckbehavior_decoder() -> Decoder(Actionprecheckbehavior) {
    use variant <- decode.then(decode.string)
    case variant {"yes" -> decode.success(ActionprecheckbehaviorYes)
"no" -> decode.success(ActionprecheckbehaviorNo)
_ -> decode.failure(ActionprecheckbehaviorYes, "Actionprecheckbehavior")}
  }
  
pub type Sequencetype{SequencetypeAa
SequencetypeDna
SequencetypeRna
}
pub fn sequencetype_to_json(sequencetype: Sequencetype) -> Json {
    case sequencetype {SequencetypeAa -> json.string("aa")
SequencetypeDna -> json.string("dna")
SequencetypeRna -> json.string("rna")
}
  }
  pub fn sequencetype_decoder() -> Decoder(Sequencetype) {
    use variant <- decode.then(decode.string)
    case variant {"aa" -> decode.success(SequencetypeAa)
"dna" -> decode.success(SequencetypeDna)
"rna" -> decode.success(SequencetypeRna)
_ -> decode.failure(SequencetypeAa, "Sequencetype")}
  }
  
pub type Conditionaldeletestatus{ConditionaldeletestatusNotsupported
ConditionaldeletestatusSingle
ConditionaldeletestatusMultiple
}
pub fn conditionaldeletestatus_to_json(conditionaldeletestatus: Conditionaldeletestatus) -> Json {
    case conditionaldeletestatus {ConditionaldeletestatusNotsupported -> json.string("not-supported")
ConditionaldeletestatusSingle -> json.string("single")
ConditionaldeletestatusMultiple -> json.string("multiple")
}
  }
  pub fn conditionaldeletestatus_decoder() -> Decoder(Conditionaldeletestatus) {
    use variant <- decode.then(decode.string)
    case variant {"not-supported" -> decode.success(ConditionaldeletestatusNotsupported)
"single" -> decode.success(ConditionaldeletestatusSingle)
"multiple" -> decode.success(ConditionaldeletestatusMultiple)
_ -> decode.failure(ConditionaldeletestatusNotsupported, "Conditionaldeletestatus")}
  }
  
pub type Documentrelationshiptype{DocumentrelationshiptypeReplaces
DocumentrelationshiptypeTransforms
DocumentrelationshiptypeSigns
DocumentrelationshiptypeAppends
}
pub fn documentrelationshiptype_to_json(documentrelationshiptype: Documentrelationshiptype) -> Json {
    case documentrelationshiptype {DocumentrelationshiptypeReplaces -> json.string("replaces")
DocumentrelationshiptypeTransforms -> json.string("transforms")
DocumentrelationshiptypeSigns -> json.string("signs")
DocumentrelationshiptypeAppends -> json.string("appends")
}
  }
  pub fn documentrelationshiptype_decoder() -> Decoder(Documentrelationshiptype) {
    use variant <- decode.then(decode.string)
    case variant {"replaces" -> decode.success(DocumentrelationshiptypeReplaces)
"transforms" -> decode.success(DocumentrelationshiptypeTransforms)
"signs" -> decode.success(DocumentrelationshiptypeSigns)
"appends" -> decode.success(DocumentrelationshiptypeAppends)
_ -> decode.failure(DocumentrelationshiptypeReplaces, "Documentrelationshiptype")}
  }
  
pub type Subscriptionchanneltype{SubscriptionchanneltypeResthook
SubscriptionchanneltypeWebsocket
SubscriptionchanneltypeEmail
SubscriptionchanneltypeSms
SubscriptionchanneltypeMessage
}
pub fn subscriptionchanneltype_to_json(subscriptionchanneltype: Subscriptionchanneltype) -> Json {
    case subscriptionchanneltype {SubscriptionchanneltypeResthook -> json.string("rest-hook")
SubscriptionchanneltypeWebsocket -> json.string("websocket")
SubscriptionchanneltypeEmail -> json.string("email")
SubscriptionchanneltypeSms -> json.string("sms")
SubscriptionchanneltypeMessage -> json.string("message")
}
  }
  pub fn subscriptionchanneltype_decoder() -> Decoder(Subscriptionchanneltype) {
    use variant <- decode.then(decode.string)
    case variant {"rest-hook" -> decode.success(SubscriptionchanneltypeResthook)
"websocket" -> decode.success(SubscriptionchanneltypeWebsocket)
"email" -> decode.success(SubscriptionchanneltypeEmail)
"sms" -> decode.success(SubscriptionchanneltypeSms)
"message" -> decode.success(SubscriptionchanneltypeMessage)
_ -> decode.failure(SubscriptionchanneltypeResthook, "Subscriptionchanneltype")}
  }
  
pub type Conceptpropertytype{ConceptpropertytypeCode
ConceptpropertytypeCoding
ConceptpropertytypeString
ConceptpropertytypeInteger
ConceptpropertytypeBoolean
ConceptpropertytypeDatetime
ConceptpropertytypeDecimal
}
pub fn conceptpropertytype_to_json(conceptpropertytype: Conceptpropertytype) -> Json {
    case conceptpropertytype {ConceptpropertytypeCode -> json.string("code")
ConceptpropertytypeCoding -> json.string("Coding")
ConceptpropertytypeString -> json.string("string")
ConceptpropertytypeInteger -> json.string("integer")
ConceptpropertytypeBoolean -> json.string("boolean")
ConceptpropertytypeDatetime -> json.string("dateTime")
ConceptpropertytypeDecimal -> json.string("decimal")
}
  }
  pub fn conceptpropertytype_decoder() -> Decoder(Conceptpropertytype) {
    use variant <- decode.then(decode.string)
    case variant {"code" -> decode.success(ConceptpropertytypeCode)
"Coding" -> decode.success(ConceptpropertytypeCoding)
"string" -> decode.success(ConceptpropertytypeString)
"integer" -> decode.success(ConceptpropertytypeInteger)
"boolean" -> decode.success(ConceptpropertytypeBoolean)
"dateTime" -> decode.success(ConceptpropertytypeDatetime)
"decimal" -> decode.success(ConceptpropertytypeDecimal)
_ -> decode.failure(ConceptpropertytypeCode, "Conceptpropertytype")}
  }
  
pub type Allergyintolerancecriticality{AllergyintolerancecriticalityLow
AllergyintolerancecriticalityHigh
AllergyintolerancecriticalityUnabletoassess
}
pub fn allergyintolerancecriticality_to_json(allergyintolerancecriticality: Allergyintolerancecriticality) -> Json {
    case allergyintolerancecriticality {AllergyintolerancecriticalityLow -> json.string("low")
AllergyintolerancecriticalityHigh -> json.string("high")
AllergyintolerancecriticalityUnabletoassess -> json.string("unable-to-assess")
}
  }
  pub fn allergyintolerancecriticality_decoder() -> Decoder(Allergyintolerancecriticality) {
    use variant <- decode.then(decode.string)
    case variant {"low" -> decode.success(AllergyintolerancecriticalityLow)
"high" -> decode.success(AllergyintolerancecriticalityHigh)
"unable-to-assess" -> decode.success(AllergyintolerancecriticalityUnabletoassess)
_ -> decode.failure(AllergyintolerancecriticalityLow, "Allergyintolerancecriticality")}
  }
  
pub type Typerestfulinteraction{TyperestfulinteractionRead
TyperestfulinteractionVread
TyperestfulinteractionUpdate
TyperestfulinteractionPatch
TyperestfulinteractionDelete
TyperestfulinteractionHistoryinstance
TyperestfulinteractionHistorytype
TyperestfulinteractionCreate
TyperestfulinteractionSearchtype
}
pub fn typerestfulinteraction_to_json(typerestfulinteraction: Typerestfulinteraction) -> Json {
    case typerestfulinteraction {TyperestfulinteractionRead -> json.string("read")
TyperestfulinteractionVread -> json.string("vread")
TyperestfulinteractionUpdate -> json.string("update")
TyperestfulinteractionPatch -> json.string("patch")
TyperestfulinteractionDelete -> json.string("delete")
TyperestfulinteractionHistoryinstance -> json.string("history-instance")
TyperestfulinteractionHistorytype -> json.string("history-type")
TyperestfulinteractionCreate -> json.string("create")
TyperestfulinteractionSearchtype -> json.string("search-type")
}
  }
  pub fn typerestfulinteraction_decoder() -> Decoder(Typerestfulinteraction) {
    use variant <- decode.then(decode.string)
    case variant {"read" -> decode.success(TyperestfulinteractionRead)
"vread" -> decode.success(TyperestfulinteractionVread)
"update" -> decode.success(TyperestfulinteractionUpdate)
"patch" -> decode.success(TyperestfulinteractionPatch)
"delete" -> decode.success(TyperestfulinteractionDelete)
"history-instance" -> decode.success(TyperestfulinteractionHistoryinstance)
"history-type" -> decode.success(TyperestfulinteractionHistorytype)
"create" -> decode.success(TyperestfulinteractionCreate)
"search-type" -> decode.success(TyperestfulinteractionSearchtype)
_ -> decode.failure(TyperestfulinteractionRead, "Typerestfulinteraction")}
  }
  
pub type Definedtypes{DefinedtypesAddress
DefinedtypesAge
DefinedtypesAnnotation
DefinedtypesAttachment
DefinedtypesBackboneelement
DefinedtypesCodeableconcept
DefinedtypesCodeablereference
DefinedtypesCoding
DefinedtypesContactdetail
DefinedtypesContactpoint
DefinedtypesContributor
DefinedtypesCount
DefinedtypesDatarequirement
DefinedtypesDistance
DefinedtypesDosage
DefinedtypesDuration
DefinedtypesElement
DefinedtypesElementdefinition
DefinedtypesExpression
DefinedtypesExtension
DefinedtypesHumanname
DefinedtypesIdentifier
DefinedtypesMarketingstatus
DefinedtypesMeta
DefinedtypesMoney
DefinedtypesMoneyquantity
DefinedtypesNarrative
DefinedtypesParameterdefinition
DefinedtypesPeriod
DefinedtypesPopulation
DefinedtypesProdcharacteristic
DefinedtypesProductshelflife
DefinedtypesQuantity
DefinedtypesRange
DefinedtypesRatio
DefinedtypesRatiorange
DefinedtypesReference
DefinedtypesRelatedartifact
DefinedtypesSampleddata
DefinedtypesSignature
DefinedtypesSimplequantity
DefinedtypesTiming
DefinedtypesTriggerdefinition
DefinedtypesUsagecontext
DefinedtypesBase64binary
DefinedtypesBoolean
DefinedtypesCanonical
DefinedtypesCode
DefinedtypesDate
DefinedtypesDatetime
DefinedtypesDecimal
DefinedtypesId
DefinedtypesInstant
DefinedtypesInteger
DefinedtypesMarkdown
DefinedtypesOid
DefinedtypesPositiveint
DefinedtypesString
DefinedtypesTime
DefinedtypesUnsignedint
DefinedtypesUri
DefinedtypesUrl
DefinedtypesUuid
DefinedtypesXhtml
DefinedtypesResource
}
pub fn definedtypes_to_json(definedtypes: Definedtypes) -> Json {
    case definedtypes {DefinedtypesAddress -> json.string("Address")
DefinedtypesAge -> json.string("Age")
DefinedtypesAnnotation -> json.string("Annotation")
DefinedtypesAttachment -> json.string("Attachment")
DefinedtypesBackboneelement -> json.string("BackboneElement")
DefinedtypesCodeableconcept -> json.string("CodeableConcept")
DefinedtypesCodeablereference -> json.string("CodeableReference")
DefinedtypesCoding -> json.string("Coding")
DefinedtypesContactdetail -> json.string("ContactDetail")
DefinedtypesContactpoint -> json.string("ContactPoint")
DefinedtypesContributor -> json.string("Contributor")
DefinedtypesCount -> json.string("Count")
DefinedtypesDatarequirement -> json.string("DataRequirement")
DefinedtypesDistance -> json.string("Distance")
DefinedtypesDosage -> json.string("Dosage")
DefinedtypesDuration -> json.string("Duration")
DefinedtypesElement -> json.string("Element")
DefinedtypesElementdefinition -> json.string("ElementDefinition")
DefinedtypesExpression -> json.string("Expression")
DefinedtypesExtension -> json.string("Extension")
DefinedtypesHumanname -> json.string("HumanName")
DefinedtypesIdentifier -> json.string("Identifier")
DefinedtypesMarketingstatus -> json.string("MarketingStatus")
DefinedtypesMeta -> json.string("Meta")
DefinedtypesMoney -> json.string("Money")
DefinedtypesMoneyquantity -> json.string("MoneyQuantity")
DefinedtypesNarrative -> json.string("Narrative")
DefinedtypesParameterdefinition -> json.string("ParameterDefinition")
DefinedtypesPeriod -> json.string("Period")
DefinedtypesPopulation -> json.string("Population")
DefinedtypesProdcharacteristic -> json.string("ProdCharacteristic")
DefinedtypesProductshelflife -> json.string("ProductShelfLife")
DefinedtypesQuantity -> json.string("Quantity")
DefinedtypesRange -> json.string("Range")
DefinedtypesRatio -> json.string("Ratio")
DefinedtypesRatiorange -> json.string("RatioRange")
DefinedtypesReference -> json.string("Reference")
DefinedtypesRelatedartifact -> json.string("RelatedArtifact")
DefinedtypesSampleddata -> json.string("SampledData")
DefinedtypesSignature -> json.string("Signature")
DefinedtypesSimplequantity -> json.string("SimpleQuantity")
DefinedtypesTiming -> json.string("Timing")
DefinedtypesTriggerdefinition -> json.string("TriggerDefinition")
DefinedtypesUsagecontext -> json.string("UsageContext")
DefinedtypesBase64binary -> json.string("base64Binary")
DefinedtypesBoolean -> json.string("boolean")
DefinedtypesCanonical -> json.string("canonical")
DefinedtypesCode -> json.string("code")
DefinedtypesDate -> json.string("date")
DefinedtypesDatetime -> json.string("dateTime")
DefinedtypesDecimal -> json.string("decimal")
DefinedtypesId -> json.string("id")
DefinedtypesInstant -> json.string("instant")
DefinedtypesInteger -> json.string("integer")
DefinedtypesMarkdown -> json.string("markdown")
DefinedtypesOid -> json.string("oid")
DefinedtypesPositiveint -> json.string("positiveInt")
DefinedtypesString -> json.string("string")
DefinedtypesTime -> json.string("time")
DefinedtypesUnsignedint -> json.string("unsignedInt")
DefinedtypesUri -> json.string("uri")
DefinedtypesUrl -> json.string("url")
DefinedtypesUuid -> json.string("uuid")
DefinedtypesXhtml -> json.string("xhtml")
DefinedtypesResource -> json.string("Resource")
}
  }
  pub fn definedtypes_decoder() -> Decoder(Definedtypes) {
    use variant <- decode.then(decode.string)
    case variant {"Address" -> decode.success(DefinedtypesAddress)
"Age" -> decode.success(DefinedtypesAge)
"Annotation" -> decode.success(DefinedtypesAnnotation)
"Attachment" -> decode.success(DefinedtypesAttachment)
"BackboneElement" -> decode.success(DefinedtypesBackboneelement)
"CodeableConcept" -> decode.success(DefinedtypesCodeableconcept)
"CodeableReference" -> decode.success(DefinedtypesCodeablereference)
"Coding" -> decode.success(DefinedtypesCoding)
"ContactDetail" -> decode.success(DefinedtypesContactdetail)
"ContactPoint" -> decode.success(DefinedtypesContactpoint)
"Contributor" -> decode.success(DefinedtypesContributor)
"Count" -> decode.success(DefinedtypesCount)
"DataRequirement" -> decode.success(DefinedtypesDatarequirement)
"Distance" -> decode.success(DefinedtypesDistance)
"Dosage" -> decode.success(DefinedtypesDosage)
"Duration" -> decode.success(DefinedtypesDuration)
"Element" -> decode.success(DefinedtypesElement)
"ElementDefinition" -> decode.success(DefinedtypesElementdefinition)
"Expression" -> decode.success(DefinedtypesExpression)
"Extension" -> decode.success(DefinedtypesExtension)
"HumanName" -> decode.success(DefinedtypesHumanname)
"Identifier" -> decode.success(DefinedtypesIdentifier)
"MarketingStatus" -> decode.success(DefinedtypesMarketingstatus)
"Meta" -> decode.success(DefinedtypesMeta)
"Money" -> decode.success(DefinedtypesMoney)
"MoneyQuantity" -> decode.success(DefinedtypesMoneyquantity)
"Narrative" -> decode.success(DefinedtypesNarrative)
"ParameterDefinition" -> decode.success(DefinedtypesParameterdefinition)
"Period" -> decode.success(DefinedtypesPeriod)
"Population" -> decode.success(DefinedtypesPopulation)
"ProdCharacteristic" -> decode.success(DefinedtypesProdcharacteristic)
"ProductShelfLife" -> decode.success(DefinedtypesProductshelflife)
"Quantity" -> decode.success(DefinedtypesQuantity)
"Range" -> decode.success(DefinedtypesRange)
"Ratio" -> decode.success(DefinedtypesRatio)
"RatioRange" -> decode.success(DefinedtypesRatiorange)
"Reference" -> decode.success(DefinedtypesReference)
"RelatedArtifact" -> decode.success(DefinedtypesRelatedartifact)
"SampledData" -> decode.success(DefinedtypesSampleddata)
"Signature" -> decode.success(DefinedtypesSignature)
"SimpleQuantity" -> decode.success(DefinedtypesSimplequantity)
"Timing" -> decode.success(DefinedtypesTiming)
"TriggerDefinition" -> decode.success(DefinedtypesTriggerdefinition)
"UsageContext" -> decode.success(DefinedtypesUsagecontext)
"base64Binary" -> decode.success(DefinedtypesBase64binary)
"boolean" -> decode.success(DefinedtypesBoolean)
"canonical" -> decode.success(DefinedtypesCanonical)
"code" -> decode.success(DefinedtypesCode)
"date" -> decode.success(DefinedtypesDate)
"dateTime" -> decode.success(DefinedtypesDatetime)
"decimal" -> decode.success(DefinedtypesDecimal)
"id" -> decode.success(DefinedtypesId)
"instant" -> decode.success(DefinedtypesInstant)
"integer" -> decode.success(DefinedtypesInteger)
"markdown" -> decode.success(DefinedtypesMarkdown)
"oid" -> decode.success(DefinedtypesOid)
"positiveInt" -> decode.success(DefinedtypesPositiveint)
"string" -> decode.success(DefinedtypesString)
"time" -> decode.success(DefinedtypesTime)
"unsignedInt" -> decode.success(DefinedtypesUnsignedint)
"uri" -> decode.success(DefinedtypesUri)
"url" -> decode.success(DefinedtypesUrl)
"uuid" -> decode.success(DefinedtypesUuid)
"xhtml" -> decode.success(DefinedtypesXhtml)
"Resource" -> decode.success(DefinedtypesResource)
_ -> decode.failure(DefinedtypesAddress, "Definedtypes")}
  }
  
pub type Referencehandlingpolicy{ReferencehandlingpolicyLiteral
ReferencehandlingpolicyLogical
ReferencehandlingpolicyResolves
ReferencehandlingpolicyEnforced
ReferencehandlingpolicyLocal
}
pub fn referencehandlingpolicy_to_json(referencehandlingpolicy: Referencehandlingpolicy) -> Json {
    case referencehandlingpolicy {ReferencehandlingpolicyLiteral -> json.string("literal")
ReferencehandlingpolicyLogical -> json.string("logical")
ReferencehandlingpolicyResolves -> json.string("resolves")
ReferencehandlingpolicyEnforced -> json.string("enforced")
ReferencehandlingpolicyLocal -> json.string("local")
}
  }
  pub fn referencehandlingpolicy_decoder() -> Decoder(Referencehandlingpolicy) {
    use variant <- decode.then(decode.string)
    case variant {"literal" -> decode.success(ReferencehandlingpolicyLiteral)
"logical" -> decode.success(ReferencehandlingpolicyLogical)
"resolves" -> decode.success(ReferencehandlingpolicyResolves)
"enforced" -> decode.success(ReferencehandlingpolicyEnforced)
"local" -> decode.success(ReferencehandlingpolicyLocal)
_ -> decode.failure(ReferencehandlingpolicyLiteral, "Referencehandlingpolicy")}
  }
  
pub type Subscriptionnotificationtype{SubscriptionnotificationtypeHandshake
SubscriptionnotificationtypeHeartbeat
SubscriptionnotificationtypeEventnotification
SubscriptionnotificationtypeQuerystatus
SubscriptionnotificationtypeQueryevent
}
pub fn subscriptionnotificationtype_to_json(subscriptionnotificationtype: Subscriptionnotificationtype) -> Json {
    case subscriptionnotificationtype {SubscriptionnotificationtypeHandshake -> json.string("handshake")
SubscriptionnotificationtypeHeartbeat -> json.string("heartbeat")
SubscriptionnotificationtypeEventnotification -> json.string("event-notification")
SubscriptionnotificationtypeQuerystatus -> json.string("query-status")
SubscriptionnotificationtypeQueryevent -> json.string("query-event")
}
  }
  pub fn subscriptionnotificationtype_decoder() -> Decoder(Subscriptionnotificationtype) {
    use variant <- decode.then(decode.string)
    case variant {"handshake" -> decode.success(SubscriptionnotificationtypeHandshake)
"heartbeat" -> decode.success(SubscriptionnotificationtypeHeartbeat)
"event-notification" -> decode.success(SubscriptionnotificationtypeEventnotification)
"query-status" -> decode.success(SubscriptionnotificationtypeQuerystatus)
"query-event" -> decode.success(SubscriptionnotificationtypeQueryevent)
_ -> decode.failure(SubscriptionnotificationtypeHandshake, "Subscriptionnotificationtype")}
  }
  
pub type Reportactionresultcodes{ReportactionresultcodesPass
ReportactionresultcodesSkip
ReportactionresultcodesFail
ReportactionresultcodesWarning
ReportactionresultcodesError
}
pub fn reportactionresultcodes_to_json(reportactionresultcodes: Reportactionresultcodes) -> Json {
    case reportactionresultcodes {ReportactionresultcodesPass -> json.string("pass")
ReportactionresultcodesSkip -> json.string("skip")
ReportactionresultcodesFail -> json.string("fail")
ReportactionresultcodesWarning -> json.string("warning")
ReportactionresultcodesError -> json.string("error")
}
  }
  pub fn reportactionresultcodes_decoder() -> Decoder(Reportactionresultcodes) {
    use variant <- decode.then(decode.string)
    case variant {"pass" -> decode.success(ReportactionresultcodesPass)
"skip" -> decode.success(ReportactionresultcodesSkip)
"fail" -> decode.success(ReportactionresultcodesFail)
"warning" -> decode.success(ReportactionresultcodesWarning)
"error" -> decode.success(ReportactionresultcodesError)
_ -> decode.failure(ReportactionresultcodesPass, "Reportactionresultcodes")}
  }
  
pub type Specimencontainedpreference{SpecimencontainedpreferencePreferred
SpecimencontainedpreferenceAlternate
}
pub fn specimencontainedpreference_to_json(specimencontainedpreference: Specimencontainedpreference) -> Json {
    case specimencontainedpreference {SpecimencontainedpreferencePreferred -> json.string("preferred")
SpecimencontainedpreferenceAlternate -> json.string("alternate")
}
  }
  pub fn specimencontainedpreference_decoder() -> Decoder(Specimencontainedpreference) {
    use variant <- decode.then(decode.string)
    case variant {"preferred" -> decode.success(SpecimencontainedpreferencePreferred)
"alternate" -> decode.success(SpecimencontainedpreferenceAlternate)
_ -> decode.failure(SpecimencontainedpreferencePreferred, "Specimencontainedpreference")}
  }
  
pub type Metriccategory{MetriccategoryMeasurement
MetriccategorySetting
MetriccategoryCalculation
MetriccategoryUnspecified
}
pub fn metriccategory_to_json(metriccategory: Metriccategory) -> Json {
    case metriccategory {MetriccategoryMeasurement -> json.string("measurement")
MetriccategorySetting -> json.string("setting")
MetriccategoryCalculation -> json.string("calculation")
MetriccategoryUnspecified -> json.string("unspecified")
}
  }
  pub fn metriccategory_decoder() -> Decoder(Metriccategory) {
    use variant <- decode.then(decode.string)
    case variant {"measurement" -> decode.success(MetriccategoryMeasurement)
"setting" -> decode.success(MetriccategorySetting)
"calculation" -> decode.success(MetriccategoryCalculation)
"unspecified" -> decode.success(MetriccategoryUnspecified)
_ -> decode.failure(MetriccategoryMeasurement, "Metriccategory")}
  }
  
pub type Bindingstrength{BindingstrengthRequired
BindingstrengthExtensible
BindingstrengthPreferred
BindingstrengthExample
}
pub fn bindingstrength_to_json(bindingstrength: Bindingstrength) -> Json {
    case bindingstrength {BindingstrengthRequired -> json.string("required")
BindingstrengthExtensible -> json.string("extensible")
BindingstrengthPreferred -> json.string("preferred")
BindingstrengthExample -> json.string("example")
}
  }
  pub fn bindingstrength_decoder() -> Decoder(Bindingstrength) {
    use variant <- decode.then(decode.string)
    case variant {"required" -> decode.success(BindingstrengthRequired)
"extensible" -> decode.success(BindingstrengthExtensible)
"preferred" -> decode.success(BindingstrengthPreferred)
"example" -> decode.success(BindingstrengthExample)
_ -> decode.failure(BindingstrengthRequired, "Bindingstrength")}
  }
  
pub type Guideparametercode{GuideparametercodeApply
GuideparametercodePathresource
GuideparametercodePathpages
GuideparametercodePathtxcache
GuideparametercodeExpansionparameter
GuideparametercodeRulebrokenlinks
GuideparametercodeGeneratexml
GuideparametercodeGeneratejson
GuideparametercodeGenerateturtle
GuideparametercodeHtmltemplate
}
pub fn guideparametercode_to_json(guideparametercode: Guideparametercode) -> Json {
    case guideparametercode {GuideparametercodeApply -> json.string("apply")
GuideparametercodePathresource -> json.string("path-resource")
GuideparametercodePathpages -> json.string("path-pages")
GuideparametercodePathtxcache -> json.string("path-tx-cache")
GuideparametercodeExpansionparameter -> json.string("expansion-parameter")
GuideparametercodeRulebrokenlinks -> json.string("rule-broken-links")
GuideparametercodeGeneratexml -> json.string("generate-xml")
GuideparametercodeGeneratejson -> json.string("generate-json")
GuideparametercodeGenerateturtle -> json.string("generate-turtle")
GuideparametercodeHtmltemplate -> json.string("html-template")
}
  }
  pub fn guideparametercode_decoder() -> Decoder(Guideparametercode) {
    use variant <- decode.then(decode.string)
    case variant {"apply" -> decode.success(GuideparametercodeApply)
"path-resource" -> decode.success(GuideparametercodePathresource)
"path-pages" -> decode.success(GuideparametercodePathpages)
"path-tx-cache" -> decode.success(GuideparametercodePathtxcache)
"expansion-parameter" -> decode.success(GuideparametercodeExpansionparameter)
"rule-broken-links" -> decode.success(GuideparametercodeRulebrokenlinks)
"generate-xml" -> decode.success(GuideparametercodeGeneratexml)
"generate-json" -> decode.success(GuideparametercodeGeneratejson)
"generate-turtle" -> decode.success(GuideparametercodeGenerateturtle)
"html-template" -> decode.success(GuideparametercodeHtmltemplate)
_ -> decode.failure(GuideparametercodeApply, "Guideparametercode")}
  }
  
pub type Searchmodifiercode{SearchmodifiercodeMissing
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
}
pub fn searchmodifiercode_to_json(searchmodifiercode: Searchmodifiercode) -> Json {
    case searchmodifiercode {SearchmodifiercodeMissing -> json.string("missing")
SearchmodifiercodeExact -> json.string("exact")
SearchmodifiercodeContains -> json.string("contains")
SearchmodifiercodeNot -> json.string("not")
SearchmodifiercodeText -> json.string("text")
SearchmodifiercodeIn -> json.string("in")
SearchmodifiercodeNotin -> json.string("not-in")
SearchmodifiercodeBelow -> json.string("below")
SearchmodifiercodeAbove -> json.string("above")
SearchmodifiercodeType -> json.string("type")
SearchmodifiercodeIdentifier -> json.string("identifier")
SearchmodifiercodeOftype -> json.string("ofType")
}
  }
  pub fn searchmodifiercode_decoder() -> Decoder(Searchmodifiercode) {
    use variant <- decode.then(decode.string)
    case variant {"missing" -> decode.success(SearchmodifiercodeMissing)
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
"ofType" -> decode.success(SearchmodifiercodeOftype)
_ -> decode.failure(SearchmodifiercodeMissing, "Searchmodifiercode")}
  }
  
pub type Operationkind{OperationkindOperation
OperationkindQuery
}
pub fn operationkind_to_json(operationkind: Operationkind) -> Json {
    case operationkind {OperationkindOperation -> json.string("operation")
OperationkindQuery -> json.string("query")
}
  }
  pub fn operationkind_decoder() -> Decoder(Operationkind) {
    use variant <- decode.then(decode.string)
    case variant {"operation" -> decode.success(OperationkindOperation)
"query" -> decode.success(OperationkindQuery)
_ -> decode.failure(OperationkindOperation, "Operationkind")}
  }
  
pub type Researchsubjectstatus{ResearchsubjectstatusCandidate
ResearchsubjectstatusEligible
ResearchsubjectstatusFollowup
ResearchsubjectstatusIneligible
ResearchsubjectstatusNotregistered
ResearchsubjectstatusOffstudy
ResearchsubjectstatusOnstudy
ResearchsubjectstatusOnstudyintervention
ResearchsubjectstatusOnstudyobservation
ResearchsubjectstatusPendingonstudy
ResearchsubjectstatusPotentialcandidate
ResearchsubjectstatusScreening
ResearchsubjectstatusWithdrawn
}
pub fn researchsubjectstatus_to_json(researchsubjectstatus: Researchsubjectstatus) -> Json {
    case researchsubjectstatus {ResearchsubjectstatusCandidate -> json.string("candidate")
ResearchsubjectstatusEligible -> json.string("eligible")
ResearchsubjectstatusFollowup -> json.string("follow-up")
ResearchsubjectstatusIneligible -> json.string("ineligible")
ResearchsubjectstatusNotregistered -> json.string("not-registered")
ResearchsubjectstatusOffstudy -> json.string("off-study")
ResearchsubjectstatusOnstudy -> json.string("on-study")
ResearchsubjectstatusOnstudyintervention -> json.string("on-study-intervention")
ResearchsubjectstatusOnstudyobservation -> json.string("on-study-observation")
ResearchsubjectstatusPendingonstudy -> json.string("pending-on-study")
ResearchsubjectstatusPotentialcandidate -> json.string("potential-candidate")
ResearchsubjectstatusScreening -> json.string("screening")
ResearchsubjectstatusWithdrawn -> json.string("withdrawn")
}
  }
  pub fn researchsubjectstatus_decoder() -> Decoder(Researchsubjectstatus) {
    use variant <- decode.then(decode.string)
    case variant {"candidate" -> decode.success(ResearchsubjectstatusCandidate)
"eligible" -> decode.success(ResearchsubjectstatusEligible)
"follow-up" -> decode.success(ResearchsubjectstatusFollowup)
"ineligible" -> decode.success(ResearchsubjectstatusIneligible)
"not-registered" -> decode.success(ResearchsubjectstatusNotregistered)
"off-study" -> decode.success(ResearchsubjectstatusOffstudy)
"on-study" -> decode.success(ResearchsubjectstatusOnstudy)
"on-study-intervention" -> decode.success(ResearchsubjectstatusOnstudyintervention)
"on-study-observation" -> decode.success(ResearchsubjectstatusOnstudyobservation)
"pending-on-study" -> decode.success(ResearchsubjectstatusPendingonstudy)
"potential-candidate" -> decode.success(ResearchsubjectstatusPotentialcandidate)
"screening" -> decode.success(ResearchsubjectstatusScreening)
"withdrawn" -> decode.success(ResearchsubjectstatusWithdrawn)
_ -> decode.failure(ResearchsubjectstatusCandidate, "Researchsubjectstatus")}
  }
  
pub type Explanationofbenefitstatus{ExplanationofbenefitstatusActive
ExplanationofbenefitstatusCancelled
ExplanationofbenefitstatusDraft
ExplanationofbenefitstatusEnteredinerror
}
pub fn explanationofbenefitstatus_to_json(explanationofbenefitstatus: Explanationofbenefitstatus) -> Json {
    case explanationofbenefitstatus {ExplanationofbenefitstatusActive -> json.string("active")
ExplanationofbenefitstatusCancelled -> json.string("cancelled")
ExplanationofbenefitstatusDraft -> json.string("draft")
ExplanationofbenefitstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn explanationofbenefitstatus_decoder() -> Decoder(Explanationofbenefitstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(ExplanationofbenefitstatusActive)
"cancelled" -> decode.success(ExplanationofbenefitstatusCancelled)
"draft" -> decode.success(ExplanationofbenefitstatusDraft)
"entered-in-error" -> decode.success(ExplanationofbenefitstatusEnteredinerror)
_ -> decode.failure(ExplanationofbenefitstatusActive, "Explanationofbenefitstatus")}
  }
  
pub type Namingsystemidentifiertype{NamingsystemidentifiertypeOid
NamingsystemidentifiertypeUuid
NamingsystemidentifiertypeUri
NamingsystemidentifiertypeOther
}
pub fn namingsystemidentifiertype_to_json(namingsystemidentifiertype: Namingsystemidentifiertype) -> Json {
    case namingsystemidentifiertype {NamingsystemidentifiertypeOid -> json.string("oid")
NamingsystemidentifiertypeUuid -> json.string("uuid")
NamingsystemidentifiertypeUri -> json.string("uri")
NamingsystemidentifiertypeOther -> json.string("other")
}
  }
  pub fn namingsystemidentifiertype_decoder() -> Decoder(Namingsystemidentifiertype) {
    use variant <- decode.then(decode.string)
    case variant {"oid" -> decode.success(NamingsystemidentifiertypeOid)
"uuid" -> decode.success(NamingsystemidentifiertypeUuid)
"uri" -> decode.success(NamingsystemidentifiertypeUri)
"other" -> decode.success(NamingsystemidentifiertypeOther)
_ -> decode.failure(NamingsystemidentifiertypeOid, "Namingsystemidentifiertype")}
  }
  
pub type Ingredientmanufacturerrole{IngredientmanufacturerroleAllowed
IngredientmanufacturerrolePossible
IngredientmanufacturerroleActual
}
pub fn ingredientmanufacturerrole_to_json(ingredientmanufacturerrole: Ingredientmanufacturerrole) -> Json {
    case ingredientmanufacturerrole {IngredientmanufacturerroleAllowed -> json.string("allowed")
IngredientmanufacturerrolePossible -> json.string("possible")
IngredientmanufacturerroleActual -> json.string("actual")
}
  }
  pub fn ingredientmanufacturerrole_decoder() -> Decoder(Ingredientmanufacturerrole) {
    use variant <- decode.then(decode.string)
    case variant {"allowed" -> decode.success(IngredientmanufacturerroleAllowed)
"possible" -> decode.success(IngredientmanufacturerrolePossible)
"actual" -> decode.success(IngredientmanufacturerroleActual)
_ -> decode.failure(IngredientmanufacturerroleAllowed, "Ingredientmanufacturerrole")}
  }
  
pub type Questionnaireenablebehavior{QuestionnaireenablebehaviorAll
QuestionnaireenablebehaviorAny
}
pub fn questionnaireenablebehavior_to_json(questionnaireenablebehavior: Questionnaireenablebehavior) -> Json {
    case questionnaireenablebehavior {QuestionnaireenablebehaviorAll -> json.string("all")
QuestionnaireenablebehaviorAny -> json.string("any")
}
  }
  pub fn questionnaireenablebehavior_decoder() -> Decoder(Questionnaireenablebehavior) {
    use variant <- decode.then(decode.string)
    case variant {"all" -> decode.success(QuestionnaireenablebehaviorAll)
"any" -> decode.success(QuestionnaireenablebehaviorAny)
_ -> decode.failure(QuestionnaireenablebehaviorAll, "Questionnaireenablebehavior")}
  }
  
pub type Participationstatus{ParticipationstatusAccepted
ParticipationstatusDeclined
ParticipationstatusTentative
ParticipationstatusNeedsaction
}
pub fn participationstatus_to_json(participationstatus: Participationstatus) -> Json {
    case participationstatus {ParticipationstatusAccepted -> json.string("accepted")
ParticipationstatusDeclined -> json.string("declined")
ParticipationstatusTentative -> json.string("tentative")
ParticipationstatusNeedsaction -> json.string("needs-action")
}
  }
  pub fn participationstatus_decoder() -> Decoder(Participationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"accepted" -> decode.success(ParticipationstatusAccepted)
"declined" -> decode.success(ParticipationstatusDeclined)
"tentative" -> decode.success(ParticipationstatusTentative)
"needs-action" -> decode.success(ParticipationstatusNeedsaction)
_ -> decode.failure(ParticipationstatusAccepted, "Participationstatus")}
  }
  
pub type Languages{LanguagesAr
LanguagesBn
LanguagesCs
LanguagesDa
LanguagesDe
LanguagesDeat
LanguagesDech
LanguagesDede
LanguagesEl
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
LanguagesFi
LanguagesFr
LanguagesFrbe
LanguagesFrch
LanguagesFrfr
LanguagesFy
LanguagesFynl
LanguagesHi
LanguagesHr
LanguagesIt
LanguagesItch
LanguagesItit
LanguagesJa
LanguagesKo
LanguagesNl
LanguagesNlbe
LanguagesNlnl
LanguagesNo
LanguagesNono
LanguagesPa
LanguagesPl
LanguagesPt
LanguagesPtbr
LanguagesRu
LanguagesRuru
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
    case languages {LanguagesAr -> json.string("ar")
LanguagesBn -> json.string("bn")
LanguagesCs -> json.string("cs")
LanguagesDa -> json.string("da")
LanguagesDe -> json.string("de")
LanguagesDeat -> json.string("de-AT")
LanguagesDech -> json.string("de-CH")
LanguagesDede -> json.string("de-DE")
LanguagesEl -> json.string("el")
LanguagesEn -> json.string("en")
LanguagesEnau -> json.string("en-AU")
LanguagesEnca -> json.string("en-CA")
LanguagesEngb -> json.string("en-GB")
LanguagesEnin -> json.string("en-IN")
LanguagesEnnz -> json.string("en-NZ")
LanguagesEnsg -> json.string("en-SG")
LanguagesEnus -> json.string("en-US")
LanguagesEs -> json.string("es")
LanguagesEsar -> json.string("es-AR")
LanguagesEses -> json.string("es-ES")
LanguagesEsuy -> json.string("es-UY")
LanguagesFi -> json.string("fi")
LanguagesFr -> json.string("fr")
LanguagesFrbe -> json.string("fr-BE")
LanguagesFrch -> json.string("fr-CH")
LanguagesFrfr -> json.string("fr-FR")
LanguagesFy -> json.string("fy")
LanguagesFynl -> json.string("fy-NL")
LanguagesHi -> json.string("hi")
LanguagesHr -> json.string("hr")
LanguagesIt -> json.string("it")
LanguagesItch -> json.string("it-CH")
LanguagesItit -> json.string("it-IT")
LanguagesJa -> json.string("ja")
LanguagesKo -> json.string("ko")
LanguagesNl -> json.string("nl")
LanguagesNlbe -> json.string("nl-BE")
LanguagesNlnl -> json.string("nl-NL")
LanguagesNo -> json.string("no")
LanguagesNono -> json.string("no-NO")
LanguagesPa -> json.string("pa")
LanguagesPl -> json.string("pl")
LanguagesPt -> json.string("pt")
LanguagesPtbr -> json.string("pt-BR")
LanguagesRu -> json.string("ru")
LanguagesRuru -> json.string("ru-RU")
LanguagesSr -> json.string("sr")
LanguagesSrrs -> json.string("sr-RS")
LanguagesSv -> json.string("sv")
LanguagesSvse -> json.string("sv-SE")
LanguagesTe -> json.string("te")
LanguagesZh -> json.string("zh")
LanguagesZhcn -> json.string("zh-CN")
LanguagesZhhk -> json.string("zh-HK")
LanguagesZhsg -> json.string("zh-SG")
LanguagesZhtw -> json.string("zh-TW")
}
  }
  pub fn languages_decoder() -> Decoder(Languages) {
    use variant <- decode.then(decode.string)
    case variant {"ar" -> decode.success(LanguagesAr)
"bn" -> decode.success(LanguagesBn)
"cs" -> decode.success(LanguagesCs)
"da" -> decode.success(LanguagesDa)
"de" -> decode.success(LanguagesDe)
"de-AT" -> decode.success(LanguagesDeat)
"de-CH" -> decode.success(LanguagesDech)
"de-DE" -> decode.success(LanguagesDede)
"el" -> decode.success(LanguagesEl)
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
"fi" -> decode.success(LanguagesFi)
"fr" -> decode.success(LanguagesFr)
"fr-BE" -> decode.success(LanguagesFrbe)
"fr-CH" -> decode.success(LanguagesFrch)
"fr-FR" -> decode.success(LanguagesFrfr)
"fy" -> decode.success(LanguagesFy)
"fy-NL" -> decode.success(LanguagesFynl)
"hi" -> decode.success(LanguagesHi)
"hr" -> decode.success(LanguagesHr)
"it" -> decode.success(LanguagesIt)
"it-CH" -> decode.success(LanguagesItch)
"it-IT" -> decode.success(LanguagesItit)
"ja" -> decode.success(LanguagesJa)
"ko" -> decode.success(LanguagesKo)
"nl" -> decode.success(LanguagesNl)
"nl-BE" -> decode.success(LanguagesNlbe)
"nl-NL" -> decode.success(LanguagesNlnl)
"no" -> decode.success(LanguagesNo)
"no-NO" -> decode.success(LanguagesNono)
"pa" -> decode.success(LanguagesPa)
"pl" -> decode.success(LanguagesPl)
"pt" -> decode.success(LanguagesPt)
"pt-BR" -> decode.success(LanguagesPtbr)
"ru" -> decode.success(LanguagesRu)
"ru-RU" -> decode.success(LanguagesRuru)
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
_ -> decode.failure(LanguagesAr, "Languages")}
  }
  
pub type Codesystemcontentmode{CodesystemcontentmodeNotpresent
CodesystemcontentmodeExample
CodesystemcontentmodeFragment
CodesystemcontentmodeComplete
CodesystemcontentmodeSupplement
}
pub fn codesystemcontentmode_to_json(codesystemcontentmode: Codesystemcontentmode) -> Json {
    case codesystemcontentmode {CodesystemcontentmodeNotpresent -> json.string("not-present")
CodesystemcontentmodeExample -> json.string("example")
CodesystemcontentmodeFragment -> json.string("fragment")
CodesystemcontentmodeComplete -> json.string("complete")
CodesystemcontentmodeSupplement -> json.string("supplement")
}
  }
  pub fn codesystemcontentmode_decoder() -> Decoder(Codesystemcontentmode) {
    use variant <- decode.then(decode.string)
    case variant {"not-present" -> decode.success(CodesystemcontentmodeNotpresent)
"example" -> decode.success(CodesystemcontentmodeExample)
"fragment" -> decode.success(CodesystemcontentmodeFragment)
"complete" -> decode.success(CodesystemcontentmodeComplete)
"supplement" -> decode.success(CodesystemcontentmodeSupplement)
_ -> decode.failure(CodesystemcontentmodeNotpresent, "Codesystemcontentmode")}
  }
  
pub type Devicestatus{DevicestatusActive
DevicestatusInactive
DevicestatusEnteredinerror
DevicestatusUnknown
}
pub fn devicestatus_to_json(devicestatus: Devicestatus) -> Json {
    case devicestatus {DevicestatusActive -> json.string("active")
DevicestatusInactive -> json.string("inactive")
DevicestatusEnteredinerror -> json.string("entered-in-error")
DevicestatusUnknown -> json.string("unknown")
}
  }
  pub fn devicestatus_decoder() -> Decoder(Devicestatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(DevicestatusActive)
"inactive" -> decode.success(DevicestatusInactive)
"entered-in-error" -> decode.success(DevicestatusEnteredinerror)
"unknown" -> decode.success(DevicestatusUnknown)
_ -> decode.failure(DevicestatusActive, "Devicestatus")}
  }
  
pub type Eventcapabilitymode{EventcapabilitymodeSender
EventcapabilitymodeReceiver
}
pub fn eventcapabilitymode_to_json(eventcapabilitymode: Eventcapabilitymode) -> Json {
    case eventcapabilitymode {EventcapabilitymodeSender -> json.string("sender")
EventcapabilitymodeReceiver -> json.string("receiver")
}
  }
  pub fn eventcapabilitymode_decoder() -> Decoder(Eventcapabilitymode) {
    use variant <- decode.then(decode.string)
    case variant {"sender" -> decode.success(EventcapabilitymodeSender)
"receiver" -> decode.success(EventcapabilitymodeReceiver)
_ -> decode.failure(EventcapabilitymodeSender, "Eventcapabilitymode")}
  }
  
pub type Remittanceoutcome{RemittanceoutcomeQueued
RemittanceoutcomeComplete
RemittanceoutcomeError
RemittanceoutcomePartial
}
pub fn remittanceoutcome_to_json(remittanceoutcome: Remittanceoutcome) -> Json {
    case remittanceoutcome {RemittanceoutcomeQueued -> json.string("queued")
RemittanceoutcomeComplete -> json.string("complete")
RemittanceoutcomeError -> json.string("error")
RemittanceoutcomePartial -> json.string("partial")
}
  }
  pub fn remittanceoutcome_decoder() -> Decoder(Remittanceoutcome) {
    use variant <- decode.then(decode.string)
    case variant {"queued" -> decode.success(RemittanceoutcomeQueued)
"complete" -> decode.success(RemittanceoutcomeComplete)
"error" -> decode.success(RemittanceoutcomeError)
"partial" -> decode.success(RemittanceoutcomePartial)
_ -> decode.failure(RemittanceoutcomeQueued, "Remittanceoutcome")}
  }
  
pub type Issueseverity{IssueseverityFatal
IssueseverityError
IssueseverityWarning
IssueseverityInformation
}
pub fn issueseverity_to_json(issueseverity: Issueseverity) -> Json {
    case issueseverity {IssueseverityFatal -> json.string("fatal")
IssueseverityError -> json.string("error")
IssueseverityWarning -> json.string("warning")
IssueseverityInformation -> json.string("information")
}
  }
  pub fn issueseverity_decoder() -> Decoder(Issueseverity) {
    use variant <- decode.then(decode.string)
    case variant {"fatal" -> decode.success(IssueseverityFatal)
"error" -> decode.success(IssueseverityError)
"warning" -> decode.success(IssueseverityWarning)
"information" -> decode.success(IssueseverityInformation)
_ -> decode.failure(IssueseverityFatal, "Issueseverity")}
  }
  
pub type Metriccalibrationstate{MetriccalibrationstateNotcalibrated
MetriccalibrationstateCalibrationrequired
MetriccalibrationstateCalibrated
MetriccalibrationstateUnspecified
}
pub fn metriccalibrationstate_to_json(metriccalibrationstate: Metriccalibrationstate) -> Json {
    case metriccalibrationstate {MetriccalibrationstateNotcalibrated -> json.string("not-calibrated")
MetriccalibrationstateCalibrationrequired -> json.string("calibration-required")
MetriccalibrationstateCalibrated -> json.string("calibrated")
MetriccalibrationstateUnspecified -> json.string("unspecified")
}
  }
  pub fn metriccalibrationstate_decoder() -> Decoder(Metriccalibrationstate) {
    use variant <- decode.then(decode.string)
    case variant {"not-calibrated" -> decode.success(MetriccalibrationstateNotcalibrated)
"calibration-required" -> decode.success(MetriccalibrationstateCalibrationrequired)
"calibrated" -> decode.success(MetriccalibrationstateCalibrated)
"unspecified" -> decode.success(MetriccalibrationstateUnspecified)
_ -> decode.failure(MetriccalibrationstateNotcalibrated, "Metriccalibrationstate")}
  }
  
pub type Productstoragescale{ProductstoragescaleFarenheit
ProductstoragescaleCelsius
ProductstoragescaleKelvin
}
pub fn productstoragescale_to_json(productstoragescale: Productstoragescale) -> Json {
    case productstoragescale {ProductstoragescaleFarenheit -> json.string("farenheit")
ProductstoragescaleCelsius -> json.string("celsius")
ProductstoragescaleKelvin -> json.string("kelvin")
}
  }
  pub fn productstoragescale_decoder() -> Decoder(Productstoragescale) {
    use variant <- decode.then(decode.string)
    case variant {"farenheit" -> decode.success(ProductstoragescaleFarenheit)
"celsius" -> decode.success(ProductstoragescaleCelsius)
"kelvin" -> decode.success(ProductstoragescaleKelvin)
_ -> decode.failure(ProductstoragescaleFarenheit, "Productstoragescale")}
  }
  
pub type Relatedartifacttype{RelatedartifacttypeDocumentation
RelatedartifacttypeJustification
RelatedartifacttypeCitation
RelatedartifacttypePredecessor
RelatedartifacttypeSuccessor
RelatedartifacttypeDerivedfrom
RelatedartifacttypeDependson
RelatedartifacttypeComposedof
}
pub fn relatedartifacttype_to_json(relatedartifacttype: Relatedartifacttype) -> Json {
    case relatedartifacttype {RelatedartifacttypeDocumentation -> json.string("documentation")
RelatedartifacttypeJustification -> json.string("justification")
RelatedartifacttypeCitation -> json.string("citation")
RelatedartifacttypePredecessor -> json.string("predecessor")
RelatedartifacttypeSuccessor -> json.string("successor")
RelatedartifacttypeDerivedfrom -> json.string("derived-from")
RelatedartifacttypeDependson -> json.string("depends-on")
RelatedartifacttypeComposedof -> json.string("composed-of")
}
  }
  pub fn relatedartifacttype_decoder() -> Decoder(Relatedartifacttype) {
    use variant <- decode.then(decode.string)
    case variant {"documentation" -> decode.success(RelatedartifacttypeDocumentation)
"justification" -> decode.success(RelatedartifacttypeJustification)
"citation" -> decode.success(RelatedartifacttypeCitation)
"predecessor" -> decode.success(RelatedartifacttypePredecessor)
"successor" -> decode.success(RelatedartifacttypeSuccessor)
"derived-from" -> decode.success(RelatedartifacttypeDerivedfrom)
"depends-on" -> decode.success(RelatedartifacttypeDependson)
"composed-of" -> decode.success(RelatedartifacttypeComposedof)
_ -> decode.failure(RelatedartifacttypeDocumentation, "Relatedartifacttype")}
  }
  
pub type Consentprovisiontype{ConsentprovisiontypeDeny
ConsentprovisiontypePermit
}
pub fn consentprovisiontype_to_json(consentprovisiontype: Consentprovisiontype) -> Json {
    case consentprovisiontype {ConsentprovisiontypeDeny -> json.string("deny")
ConsentprovisiontypePermit -> json.string("permit")
}
  }
  pub fn consentprovisiontype_decoder() -> Decoder(Consentprovisiontype) {
    use variant <- decode.then(decode.string)
    case variant {"deny" -> decode.success(ConsentprovisiontypeDeny)
"permit" -> decode.success(ConsentprovisiontypePermit)
_ -> decode.failure(ConsentprovisiontypeDeny, "Consentprovisiontype")}
  }
  
pub type Messagesignificancecategory{MessagesignificancecategoryConsequence
MessagesignificancecategoryCurrency
MessagesignificancecategoryNotification
}
pub fn messagesignificancecategory_to_json(messagesignificancecategory: Messagesignificancecategory) -> Json {
    case messagesignificancecategory {MessagesignificancecategoryConsequence -> json.string("consequence")
MessagesignificancecategoryCurrency -> json.string("currency")
MessagesignificancecategoryNotification -> json.string("notification")
}
  }
  pub fn messagesignificancecategory_decoder() -> Decoder(Messagesignificancecategory) {
    use variant <- decode.then(decode.string)
    case variant {"consequence" -> decode.success(MessagesignificancecategoryConsequence)
"currency" -> decode.success(MessagesignificancecategoryCurrency)
"notification" -> decode.success(MessagesignificancecategoryNotification)
_ -> decode.failure(MessagesignificancecategoryConsequence, "Messagesignificancecategory")}
  }
  
pub type Sortdirection{SortdirectionAscending
SortdirectionDescending
}
pub fn sortdirection_to_json(sortdirection: Sortdirection) -> Json {
    case sortdirection {SortdirectionAscending -> json.string("ascending")
SortdirectionDescending -> json.string("descending")
}
  }
  pub fn sortdirection_decoder() -> Decoder(Sortdirection) {
    use variant <- decode.then(decode.string)
    case variant {"ascending" -> decode.success(SortdirectionAscending)
"descending" -> decode.success(SortdirectionDescending)
_ -> decode.failure(SortdirectionAscending, "Sortdirection")}
  }
  
pub type Listmode{ListmodeWorking
ListmodeSnapshot
ListmodeChanges
}
pub fn listmode_to_json(listmode: Listmode) -> Json {
    case listmode {ListmodeWorking -> json.string("working")
ListmodeSnapshot -> json.string("snapshot")
ListmodeChanges -> json.string("changes")
}
  }
  pub fn listmode_decoder() -> Decoder(Listmode) {
    use variant <- decode.then(decode.string)
    case variant {"working" -> decode.success(ListmodeWorking)
"snapshot" -> decode.success(ListmodeSnapshot)
"changes" -> decode.success(ListmodeChanges)
_ -> decode.failure(ListmodeWorking, "Listmode")}
  }
  
pub type Alltypes{AlltypesAddress
AlltypesAge
AlltypesAnnotation
AlltypesAttachment
AlltypesBackboneelement
AlltypesCodeableconcept
AlltypesCodeablereference
AlltypesCoding
AlltypesContactdetail
AlltypesContactpoint
AlltypesContributor
AlltypesCount
AlltypesDatarequirement
AlltypesDistance
AlltypesDosage
AlltypesDuration
AlltypesElement
AlltypesElementdefinition
AlltypesExpression
AlltypesExtension
AlltypesHumanname
AlltypesIdentifier
AlltypesMarketingstatus
AlltypesMeta
AlltypesMoney
AlltypesMoneyquantity
AlltypesNarrative
AlltypesParameterdefinition
AlltypesPeriod
AlltypesPopulation
AlltypesProdcharacteristic
AlltypesProductshelflife
AlltypesQuantity
AlltypesRange
AlltypesRatio
AlltypesRatiorange
AlltypesReference
AlltypesRelatedartifact
AlltypesSampleddata
AlltypesSignature
AlltypesSimplequantity
AlltypesTiming
AlltypesTriggerdefinition
AlltypesUsagecontext
AlltypesBase64binary
AlltypesBoolean
AlltypesCanonical
AlltypesCode
AlltypesDate
AlltypesDatetime
AlltypesDecimal
AlltypesId
AlltypesInstant
AlltypesInteger
AlltypesMarkdown
AlltypesOid
AlltypesPositiveint
AlltypesString
AlltypesTime
AlltypesUnsignedint
AlltypesUri
AlltypesUrl
AlltypesUuid
AlltypesXhtml
AlltypesResource
AlltypesType
AlltypesAny
}
pub fn alltypes_to_json(alltypes: Alltypes) -> Json {
    case alltypes {AlltypesAddress -> json.string("Address")
AlltypesAge -> json.string("Age")
AlltypesAnnotation -> json.string("Annotation")
AlltypesAttachment -> json.string("Attachment")
AlltypesBackboneelement -> json.string("BackboneElement")
AlltypesCodeableconcept -> json.string("CodeableConcept")
AlltypesCodeablereference -> json.string("CodeableReference")
AlltypesCoding -> json.string("Coding")
AlltypesContactdetail -> json.string("ContactDetail")
AlltypesContactpoint -> json.string("ContactPoint")
AlltypesContributor -> json.string("Contributor")
AlltypesCount -> json.string("Count")
AlltypesDatarequirement -> json.string("DataRequirement")
AlltypesDistance -> json.string("Distance")
AlltypesDosage -> json.string("Dosage")
AlltypesDuration -> json.string("Duration")
AlltypesElement -> json.string("Element")
AlltypesElementdefinition -> json.string("ElementDefinition")
AlltypesExpression -> json.string("Expression")
AlltypesExtension -> json.string("Extension")
AlltypesHumanname -> json.string("HumanName")
AlltypesIdentifier -> json.string("Identifier")
AlltypesMarketingstatus -> json.string("MarketingStatus")
AlltypesMeta -> json.string("Meta")
AlltypesMoney -> json.string("Money")
AlltypesMoneyquantity -> json.string("MoneyQuantity")
AlltypesNarrative -> json.string("Narrative")
AlltypesParameterdefinition -> json.string("ParameterDefinition")
AlltypesPeriod -> json.string("Period")
AlltypesPopulation -> json.string("Population")
AlltypesProdcharacteristic -> json.string("ProdCharacteristic")
AlltypesProductshelflife -> json.string("ProductShelfLife")
AlltypesQuantity -> json.string("Quantity")
AlltypesRange -> json.string("Range")
AlltypesRatio -> json.string("Ratio")
AlltypesRatiorange -> json.string("RatioRange")
AlltypesReference -> json.string("Reference")
AlltypesRelatedartifact -> json.string("RelatedArtifact")
AlltypesSampleddata -> json.string("SampledData")
AlltypesSignature -> json.string("Signature")
AlltypesSimplequantity -> json.string("SimpleQuantity")
AlltypesTiming -> json.string("Timing")
AlltypesTriggerdefinition -> json.string("TriggerDefinition")
AlltypesUsagecontext -> json.string("UsageContext")
AlltypesBase64binary -> json.string("base64Binary")
AlltypesBoolean -> json.string("boolean")
AlltypesCanonical -> json.string("canonical")
AlltypesCode -> json.string("code")
AlltypesDate -> json.string("date")
AlltypesDatetime -> json.string("dateTime")
AlltypesDecimal -> json.string("decimal")
AlltypesId -> json.string("id")
AlltypesInstant -> json.string("instant")
AlltypesInteger -> json.string("integer")
AlltypesMarkdown -> json.string("markdown")
AlltypesOid -> json.string("oid")
AlltypesPositiveint -> json.string("positiveInt")
AlltypesString -> json.string("string")
AlltypesTime -> json.string("time")
AlltypesUnsignedint -> json.string("unsignedInt")
AlltypesUri -> json.string("uri")
AlltypesUrl -> json.string("url")
AlltypesUuid -> json.string("uuid")
AlltypesXhtml -> json.string("xhtml")
AlltypesResource -> json.string("Resource")
AlltypesType -> json.string("Type")
AlltypesAny -> json.string("Any")
}
  }
  pub fn alltypes_decoder() -> Decoder(Alltypes) {
    use variant <- decode.then(decode.string)
    case variant {"Address" -> decode.success(AlltypesAddress)
"Age" -> decode.success(AlltypesAge)
"Annotation" -> decode.success(AlltypesAnnotation)
"Attachment" -> decode.success(AlltypesAttachment)
"BackboneElement" -> decode.success(AlltypesBackboneelement)
"CodeableConcept" -> decode.success(AlltypesCodeableconcept)
"CodeableReference" -> decode.success(AlltypesCodeablereference)
"Coding" -> decode.success(AlltypesCoding)
"ContactDetail" -> decode.success(AlltypesContactdetail)
"ContactPoint" -> decode.success(AlltypesContactpoint)
"Contributor" -> decode.success(AlltypesContributor)
"Count" -> decode.success(AlltypesCount)
"DataRequirement" -> decode.success(AlltypesDatarequirement)
"Distance" -> decode.success(AlltypesDistance)
"Dosage" -> decode.success(AlltypesDosage)
"Duration" -> decode.success(AlltypesDuration)
"Element" -> decode.success(AlltypesElement)
"ElementDefinition" -> decode.success(AlltypesElementdefinition)
"Expression" -> decode.success(AlltypesExpression)
"Extension" -> decode.success(AlltypesExtension)
"HumanName" -> decode.success(AlltypesHumanname)
"Identifier" -> decode.success(AlltypesIdentifier)
"MarketingStatus" -> decode.success(AlltypesMarketingstatus)
"Meta" -> decode.success(AlltypesMeta)
"Money" -> decode.success(AlltypesMoney)
"MoneyQuantity" -> decode.success(AlltypesMoneyquantity)
"Narrative" -> decode.success(AlltypesNarrative)
"ParameterDefinition" -> decode.success(AlltypesParameterdefinition)
"Period" -> decode.success(AlltypesPeriod)
"Population" -> decode.success(AlltypesPopulation)
"ProdCharacteristic" -> decode.success(AlltypesProdcharacteristic)
"ProductShelfLife" -> decode.success(AlltypesProductshelflife)
"Quantity" -> decode.success(AlltypesQuantity)
"Range" -> decode.success(AlltypesRange)
"Ratio" -> decode.success(AlltypesRatio)
"RatioRange" -> decode.success(AlltypesRatiorange)
"Reference" -> decode.success(AlltypesReference)
"RelatedArtifact" -> decode.success(AlltypesRelatedartifact)
"SampledData" -> decode.success(AlltypesSampleddata)
"Signature" -> decode.success(AlltypesSignature)
"SimpleQuantity" -> decode.success(AlltypesSimplequantity)
"Timing" -> decode.success(AlltypesTiming)
"TriggerDefinition" -> decode.success(AlltypesTriggerdefinition)
"UsageContext" -> decode.success(AlltypesUsagecontext)
"base64Binary" -> decode.success(AlltypesBase64binary)
"boolean" -> decode.success(AlltypesBoolean)
"canonical" -> decode.success(AlltypesCanonical)
"code" -> decode.success(AlltypesCode)
"date" -> decode.success(AlltypesDate)
"dateTime" -> decode.success(AlltypesDatetime)
"decimal" -> decode.success(AlltypesDecimal)
"id" -> decode.success(AlltypesId)
"instant" -> decode.success(AlltypesInstant)
"integer" -> decode.success(AlltypesInteger)
"markdown" -> decode.success(AlltypesMarkdown)
"oid" -> decode.success(AlltypesOid)
"positiveInt" -> decode.success(AlltypesPositiveint)
"string" -> decode.success(AlltypesString)
"time" -> decode.success(AlltypesTime)
"unsignedInt" -> decode.success(AlltypesUnsignedint)
"uri" -> decode.success(AlltypesUri)
"url" -> decode.success(AlltypesUrl)
"uuid" -> decode.success(AlltypesUuid)
"xhtml" -> decode.success(AlltypesXhtml)
"Resource" -> decode.success(AlltypesResource)
"Type" -> decode.success(AlltypesType)
"Any" -> decode.success(AlltypesAny)
_ -> decode.failure(AlltypesAddress, "Alltypes")}
  }
  
pub type Clinicalimpressionstatus{ClinicalimpressionstatusInprogress
ClinicalimpressionstatusCompleted
ClinicalimpressionstatusEnteredinerror
}
pub fn clinicalimpressionstatus_to_json(clinicalimpressionstatus: Clinicalimpressionstatus) -> Json {
    case clinicalimpressionstatus {ClinicalimpressionstatusInprogress -> json.string("in-progress")
ClinicalimpressionstatusCompleted -> json.string("completed")
ClinicalimpressionstatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn clinicalimpressionstatus_decoder() -> Decoder(Clinicalimpressionstatus) {
    use variant <- decode.then(decode.string)
    case variant {"in-progress" -> decode.success(ClinicalimpressionstatusInprogress)
"completed" -> decode.success(ClinicalimpressionstatusCompleted)
"entered-in-error" -> decode.success(ClinicalimpressionstatusEnteredinerror)
_ -> decode.failure(ClinicalimpressionstatusInprogress, "Clinicalimpressionstatus")}
  }
  
pub type Reactioneventseverity{ReactioneventseverityMild
ReactioneventseverityModerate
ReactioneventseveritySevere
}
pub fn reactioneventseverity_to_json(reactioneventseverity: Reactioneventseverity) -> Json {
    case reactioneventseverity {ReactioneventseverityMild -> json.string("mild")
ReactioneventseverityModerate -> json.string("moderate")
ReactioneventseveritySevere -> json.string("severe")
}
  }
  pub fn reactioneventseverity_decoder() -> Decoder(Reactioneventseverity) {
    use variant <- decode.then(decode.string)
    case variant {"mild" -> decode.success(ReactioneventseverityMild)
"moderate" -> decode.success(ReactioneventseverityModerate)
"severe" -> decode.success(ReactioneventseveritySevere)
_ -> decode.failure(ReactioneventseverityMild, "Reactioneventseverity")}
  }
  
pub type Eligibilityresponsepurpose{EligibilityresponsepurposeAuthrequirements
EligibilityresponsepurposeBenefits
EligibilityresponsepurposeDiscovery
EligibilityresponsepurposeValidation
}
pub fn eligibilityresponsepurpose_to_json(eligibilityresponsepurpose: Eligibilityresponsepurpose) -> Json {
    case eligibilityresponsepurpose {EligibilityresponsepurposeAuthrequirements -> json.string("auth-requirements")
EligibilityresponsepurposeBenefits -> json.string("benefits")
EligibilityresponsepurposeDiscovery -> json.string("discovery")
EligibilityresponsepurposeValidation -> json.string("validation")
}
  }
  pub fn eligibilityresponsepurpose_decoder() -> Decoder(Eligibilityresponsepurpose) {
    use variant <- decode.then(decode.string)
    case variant {"auth-requirements" -> decode.success(EligibilityresponsepurposeAuthrequirements)
"benefits" -> decode.success(EligibilityresponsepurposeBenefits)
"discovery" -> decode.success(EligibilityresponsepurposeDiscovery)
"validation" -> decode.success(EligibilityresponsepurposeValidation)
_ -> decode.failure(EligibilityresponsepurposeAuthrequirements, "Eligibilityresponsepurpose")}
  }
  
pub type Consentdatameaning{ConsentdatameaningInstance
ConsentdatameaningRelated
ConsentdatameaningDependents
ConsentdatameaningAuthoredby
}
pub fn consentdatameaning_to_json(consentdatameaning: Consentdatameaning) -> Json {
    case consentdatameaning {ConsentdatameaningInstance -> json.string("instance")
ConsentdatameaningRelated -> json.string("related")
ConsentdatameaningDependents -> json.string("dependents")
ConsentdatameaningAuthoredby -> json.string("authoredby")
}
  }
  pub fn consentdatameaning_decoder() -> Decoder(Consentdatameaning) {
    use variant <- decode.then(decode.string)
    case variant {"instance" -> decode.success(ConsentdatameaningInstance)
"related" -> decode.success(ConsentdatameaningRelated)
"dependents" -> decode.success(ConsentdatameaningDependents)
"authoredby" -> decode.success(ConsentdatameaningAuthoredby)
_ -> decode.failure(ConsentdatameaningInstance, "Consentdatameaning")}
  }
  
pub type Visioneyecodes{VisioneyecodesRight
VisioneyecodesLeft
}
pub fn visioneyecodes_to_json(visioneyecodes: Visioneyecodes) -> Json {
    case visioneyecodes {VisioneyecodesRight -> json.string("right")
VisioneyecodesLeft -> json.string("left")
}
  }
  pub fn visioneyecodes_decoder() -> Decoder(Visioneyecodes) {
    use variant <- decode.then(decode.string)
    case variant {"right" -> decode.success(VisioneyecodesRight)
"left" -> decode.success(VisioneyecodesLeft)
_ -> decode.failure(VisioneyecodesRight, "Visioneyecodes")}
  }
  
pub type Careplanactivitystatus{CareplanactivitystatusNotstarted
CareplanactivitystatusScheduled
CareplanactivitystatusInprogress
CareplanactivitystatusOnhold
CareplanactivitystatusCompleted
CareplanactivitystatusCancelled
CareplanactivitystatusUnknown
CareplanactivitystatusEnteredinerror
}
pub fn careplanactivitystatus_to_json(careplanactivitystatus: Careplanactivitystatus) -> Json {
    case careplanactivitystatus {CareplanactivitystatusNotstarted -> json.string("not-started")
CareplanactivitystatusScheduled -> json.string("scheduled")
CareplanactivitystatusInprogress -> json.string("in-progress")
CareplanactivitystatusOnhold -> json.string("on-hold")
CareplanactivitystatusCompleted -> json.string("completed")
CareplanactivitystatusCancelled -> json.string("cancelled")
CareplanactivitystatusUnknown -> json.string("unknown")
CareplanactivitystatusEnteredinerror -> json.string("entered-in-error")
}
  }
  pub fn careplanactivitystatus_decoder() -> Decoder(Careplanactivitystatus) {
    use variant <- decode.then(decode.string)
    case variant {"not-started" -> decode.success(CareplanactivitystatusNotstarted)
"scheduled" -> decode.success(CareplanactivitystatusScheduled)
"in-progress" -> decode.success(CareplanactivitystatusInprogress)
"on-hold" -> decode.success(CareplanactivitystatusOnhold)
"completed" -> decode.success(CareplanactivitystatusCompleted)
"cancelled" -> decode.success(CareplanactivitystatusCancelled)
"unknown" -> decode.success(CareplanactivitystatusUnknown)
"entered-in-error" -> decode.success(CareplanactivitystatusEnteredinerror)
_ -> decode.failure(CareplanactivitystatusNotstarted, "Careplanactivitystatus")}
  }
  
pub type Linkagetype{LinkagetypeSource
LinkagetypeAlternate
LinkagetypeHistorical
}
pub fn linkagetype_to_json(linkagetype: Linkagetype) -> Json {
    case linkagetype {LinkagetypeSource -> json.string("source")
LinkagetypeAlternate -> json.string("alternate")
LinkagetypeHistorical -> json.string("historical")
}
  }
  pub fn linkagetype_decoder() -> Decoder(Linkagetype) {
    use variant <- decode.then(decode.string)
    case variant {"source" -> decode.success(LinkagetypeSource)
"alternate" -> decode.success(LinkagetypeAlternate)
"historical" -> decode.success(LinkagetypeHistorical)
_ -> decode.failure(LinkagetypeSource, "Linkagetype")}
  }
  
pub type Searchparamtype{SearchparamtypeNumber
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
    case searchparamtype {SearchparamtypeNumber -> json.string("number")
SearchparamtypeDate -> json.string("date")
SearchparamtypeString -> json.string("string")
SearchparamtypeToken -> json.string("token")
SearchparamtypeReference -> json.string("reference")
SearchparamtypeComposite -> json.string("composite")
SearchparamtypeQuantity -> json.string("quantity")
SearchparamtypeUri -> json.string("uri")
SearchparamtypeSpecial -> json.string("special")
}
  }
  pub fn searchparamtype_decoder() -> Decoder(Searchparamtype) {
    use variant <- decode.then(decode.string)
    case variant {"number" -> decode.success(SearchparamtypeNumber)
"date" -> decode.success(SearchparamtypeDate)
"string" -> decode.success(SearchparamtypeString)
"token" -> decode.success(SearchparamtypeToken)
"reference" -> decode.success(SearchparamtypeReference)
"composite" -> decode.success(SearchparamtypeComposite)
"quantity" -> decode.success(SearchparamtypeQuantity)
"uri" -> decode.success(SearchparamtypeUri)
"special" -> decode.success(SearchparamtypeSpecial)
_ -> decode.failure(SearchparamtypeNumber, "Searchparamtype")}
  }
  
pub type Productcategory{ProductcategoryOrgan
ProductcategoryTissue
ProductcategoryFluid
ProductcategoryCells
ProductcategoryBiologicalagent
}
pub fn productcategory_to_json(productcategory: Productcategory) -> Json {
    case productcategory {ProductcategoryOrgan -> json.string("organ")
ProductcategoryTissue -> json.string("tissue")
ProductcategoryFluid -> json.string("fluid")
ProductcategoryCells -> json.string("cells")
ProductcategoryBiologicalagent -> json.string("biologicalAgent")
}
  }
  pub fn productcategory_decoder() -> Decoder(Productcategory) {
    use variant <- decode.then(decode.string)
    case variant {"organ" -> decode.success(ProductcategoryOrgan)
"tissue" -> decode.success(ProductcategoryTissue)
"fluid" -> decode.success(ProductcategoryFluid)
"cells" -> decode.success(ProductcategoryCells)
"biologicalAgent" -> decode.success(ProductcategoryBiologicalagent)
_ -> decode.failure(ProductcategoryOrgan, "Productcategory")}
  }
  
pub type Variablehandling{VariablehandlingContinuous
VariablehandlingDichotomous
VariablehandlingOrdinal
VariablehandlingPolychotomous
}
pub fn variablehandling_to_json(variablehandling: Variablehandling) -> Json {
    case variablehandling {VariablehandlingContinuous -> json.string("continuous")
VariablehandlingDichotomous -> json.string("dichotomous")
VariablehandlingOrdinal -> json.string("ordinal")
VariablehandlingPolychotomous -> json.string("polychotomous")
}
  }
  pub fn variablehandling_decoder() -> Decoder(Variablehandling) {
    use variant <- decode.then(decode.string)
    case variant {"continuous" -> decode.success(VariablehandlingContinuous)
"dichotomous" -> decode.success(VariablehandlingDichotomous)
"ordinal" -> decode.success(VariablehandlingOrdinal)
"polychotomous" -> decode.success(VariablehandlingPolychotomous)
_ -> decode.failure(VariablehandlingContinuous, "Variablehandling")}
  }
  
pub type Contactpointuse{ContactpointuseHome
ContactpointuseWork
ContactpointuseTemp
ContactpointuseOld
ContactpointuseMobile
}
pub fn contactpointuse_to_json(contactpointuse: Contactpointuse) -> Json {
    case contactpointuse {ContactpointuseHome -> json.string("home")
ContactpointuseWork -> json.string("work")
ContactpointuseTemp -> json.string("temp")
ContactpointuseOld -> json.string("old")
ContactpointuseMobile -> json.string("mobile")
}
  }
  pub fn contactpointuse_decoder() -> Decoder(Contactpointuse) {
    use variant <- decode.then(decode.string)
    case variant {"home" -> decode.success(ContactpointuseHome)
"work" -> decode.success(ContactpointuseWork)
"temp" -> decode.success(ContactpointuseTemp)
"old" -> decode.success(ContactpointuseOld)
"mobile" -> decode.success(ContactpointuseMobile)
_ -> decode.failure(ContactpointuseHome, "Contactpointuse")}
  }
  
pub type Historystatus{HistorystatusPartial
HistorystatusCompleted
HistorystatusEnteredinerror
HistorystatusHealthunknown
}
pub fn historystatus_to_json(historystatus: Historystatus) -> Json {
    case historystatus {HistorystatusPartial -> json.string("partial")
HistorystatusCompleted -> json.string("completed")
HistorystatusEnteredinerror -> json.string("entered-in-error")
HistorystatusHealthunknown -> json.string("health-unknown")
}
  }
  pub fn historystatus_decoder() -> Decoder(Historystatus) {
    use variant <- decode.then(decode.string)
    case variant {"partial" -> decode.success(HistorystatusPartial)
"completed" -> decode.success(HistorystatusCompleted)
"entered-in-error" -> decode.success(HistorystatusEnteredinerror)
"health-unknown" -> decode.success(HistorystatusHealthunknown)
_ -> decode.failure(HistorystatusPartial, "Historystatus")}
  }
  
pub type Chargeitemstatus{ChargeitemstatusPlanned
ChargeitemstatusBillable
ChargeitemstatusNotbillable
ChargeitemstatusAborted
ChargeitemstatusBilled
ChargeitemstatusEnteredinerror
ChargeitemstatusUnknown
}
pub fn chargeitemstatus_to_json(chargeitemstatus: Chargeitemstatus) -> Json {
    case chargeitemstatus {ChargeitemstatusPlanned -> json.string("planned")
ChargeitemstatusBillable -> json.string("billable")
ChargeitemstatusNotbillable -> json.string("not-billable")
ChargeitemstatusAborted -> json.string("aborted")
ChargeitemstatusBilled -> json.string("billed")
ChargeitemstatusEnteredinerror -> json.string("entered-in-error")
ChargeitemstatusUnknown -> json.string("unknown")
}
  }
  pub fn chargeitemstatus_decoder() -> Decoder(Chargeitemstatus) {
    use variant <- decode.then(decode.string)
    case variant {"planned" -> decode.success(ChargeitemstatusPlanned)
"billable" -> decode.success(ChargeitemstatusBillable)
"not-billable" -> decode.success(ChargeitemstatusNotbillable)
"aborted" -> decode.success(ChargeitemstatusAborted)
"billed" -> decode.success(ChargeitemstatusBilled)
"entered-in-error" -> decode.success(ChargeitemstatusEnteredinerror)
"unknown" -> decode.success(ChargeitemstatusUnknown)
_ -> decode.failure(ChargeitemstatusPlanned, "Chargeitemstatus")}
  }
  
pub type Assertoperatorcodes{AssertoperatorcodesEquals
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
}
pub fn assertoperatorcodes_to_json(assertoperatorcodes: Assertoperatorcodes) -> Json {
    case assertoperatorcodes {AssertoperatorcodesEquals -> json.string("equals")
AssertoperatorcodesNotequals -> json.string("notEquals")
AssertoperatorcodesIn -> json.string("in")
AssertoperatorcodesNotin -> json.string("notIn")
AssertoperatorcodesGreaterthan -> json.string("greaterThan")
AssertoperatorcodesLessthan -> json.string("lessThan")
AssertoperatorcodesEmpty -> json.string("empty")
AssertoperatorcodesNotempty -> json.string("notEmpty")
AssertoperatorcodesContains -> json.string("contains")
AssertoperatorcodesNotcontains -> json.string("notContains")
AssertoperatorcodesEval -> json.string("eval")
}
  }
  pub fn assertoperatorcodes_decoder() -> Decoder(Assertoperatorcodes) {
    use variant <- decode.then(decode.string)
    case variant {"equals" -> decode.success(AssertoperatorcodesEquals)
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
_ -> decode.failure(AssertoperatorcodesEquals, "Assertoperatorcodes")}
  }
  
pub type Medicationrequestintent{MedicationrequestintentProposal
MedicationrequestintentPlan
MedicationrequestintentOrder
MedicationrequestintentOriginalorder
MedicationrequestintentReflexorder
MedicationrequestintentFillerorder
MedicationrequestintentInstanceorder
MedicationrequestintentOption
}
pub fn medicationrequestintent_to_json(medicationrequestintent: Medicationrequestintent) -> Json {
    case medicationrequestintent {MedicationrequestintentProposal -> json.string("proposal")
MedicationrequestintentPlan -> json.string("plan")
MedicationrequestintentOrder -> json.string("order")
MedicationrequestintentOriginalorder -> json.string("original-order")
MedicationrequestintentReflexorder -> json.string("reflex-order")
MedicationrequestintentFillerorder -> json.string("filler-order")
MedicationrequestintentInstanceorder -> json.string("instance-order")
MedicationrequestintentOption -> json.string("option")
}
  }
  pub fn medicationrequestintent_decoder() -> Decoder(Medicationrequestintent) {
    use variant <- decode.then(decode.string)
    case variant {"proposal" -> decode.success(MedicationrequestintentProposal)
"plan" -> decode.success(MedicationrequestintentPlan)
"order" -> decode.success(MedicationrequestintentOrder)
"original-order" -> decode.success(MedicationrequestintentOriginalorder)
"reflex-order" -> decode.success(MedicationrequestintentReflexorder)
"filler-order" -> decode.success(MedicationrequestintentFillerorder)
"instance-order" -> decode.success(MedicationrequestintentInstanceorder)
"option" -> decode.success(MedicationrequestintentOption)
_ -> decode.failure(MedicationrequestintentProposal, "Medicationrequestintent")}
  }
  
pub type Triggertype{TriggertypeNamedevent
TriggertypePeriodic
TriggertypeDatachanged
TriggertypeDataaccessed
TriggertypeDataaccessended
}
pub fn triggertype_to_json(triggertype: Triggertype) -> Json {
    case triggertype {TriggertypeNamedevent -> json.string("named-event")
TriggertypePeriodic -> json.string("periodic")
TriggertypeDatachanged -> json.string("data-changed")
TriggertypeDataaccessed -> json.string("data-accessed")
TriggertypeDataaccessended -> json.string("data-access-ended")
}
  }
  pub fn triggertype_decoder() -> Decoder(Triggertype) {
    use variant <- decode.then(decode.string)
    case variant {"named-event" -> decode.success(TriggertypeNamedevent)
"periodic" -> decode.success(TriggertypePeriodic)
"data-changed" -> decode.success(TriggertypeDatachanged)
"data-accessed" -> decode.success(TriggertypeDataaccessed)
"data-access-ended" -> decode.success(TriggertypeDataaccessended)
_ -> decode.failure(TriggertypeNamedevent, "Triggertype")}
  }
  
pub type Eventtiming{EventtimingMorn
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
    case eventtiming {EventtimingMorn -> json.string("MORN")
EventtimingMornearly -> json.string("MORN.early")
EventtimingMornlate -> json.string("MORN.late")
EventtimingNoon -> json.string("NOON")
EventtimingAft -> json.string("AFT")
EventtimingAftearly -> json.string("AFT.early")
EventtimingAftlate -> json.string("AFT.late")
EventtimingEve -> json.string("EVE")
EventtimingEveearly -> json.string("EVE.early")
EventtimingEvelate -> json.string("EVE.late")
EventtimingNight -> json.string("NIGHT")
EventtimingPhs -> json.string("PHS")
EventtimingHs -> json.string("HS")
EventtimingWake -> json.string("WAKE")
EventtimingC -> json.string("C")
EventtimingCm -> json.string("CM")
EventtimingCd -> json.string("CD")
EventtimingCv -> json.string("CV")
EventtimingAc -> json.string("AC")
EventtimingAcm -> json.string("ACM")
EventtimingAcd -> json.string("ACD")
EventtimingAcv -> json.string("ACV")
EventtimingPc -> json.string("PC")
EventtimingPcm -> json.string("PCM")
EventtimingPcd -> json.string("PCD")
EventtimingPcv -> json.string("PCV")
}
  }
  pub fn eventtiming_decoder() -> Decoder(Eventtiming) {
    use variant <- decode.then(decode.string)
    case variant {"MORN" -> decode.success(EventtimingMorn)
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
_ -> decode.failure(EventtimingMorn, "Eventtiming")}
  }
  
pub type Orientationtype{OrientationtypeSense
OrientationtypeAntisense
}
pub fn orientationtype_to_json(orientationtype: Orientationtype) -> Json {
    case orientationtype {OrientationtypeSense -> json.string("sense")
OrientationtypeAntisense -> json.string("antisense")
}
  }
  pub fn orientationtype_decoder() -> Decoder(Orientationtype) {
    use variant <- decode.then(decode.string)
    case variant {"sense" -> decode.success(OrientationtypeSense)
"antisense" -> decode.success(OrientationtypeAntisense)
_ -> decode.failure(OrientationtypeSense, "Orientationtype")}
  }
  
pub type Publicationstatus{PublicationstatusDraft
PublicationstatusActive
PublicationstatusRetired
PublicationstatusUnknown
}
pub fn publicationstatus_to_json(publicationstatus: Publicationstatus) -> Json {
    case publicationstatus {PublicationstatusDraft -> json.string("draft")
PublicationstatusActive -> json.string("active")
PublicationstatusRetired -> json.string("retired")
PublicationstatusUnknown -> json.string("unknown")
}
  }
  pub fn publicationstatus_decoder() -> Decoder(Publicationstatus) {
    use variant <- decode.then(decode.string)
    case variant {"draft" -> decode.success(PublicationstatusDraft)
"active" -> decode.success(PublicationstatusActive)
"retired" -> decode.success(PublicationstatusRetired)
"unknown" -> decode.success(PublicationstatusUnknown)
_ -> decode.failure(PublicationstatusDraft, "Publicationstatus")}
  }
  
pub type Careplanintent{CareplanintentProposal
CareplanintentPlan
CareplanintentOrder
CareplanintentOption
}
pub fn careplanintent_to_json(careplanintent: Careplanintent) -> Json {
    case careplanintent {CareplanintentProposal -> json.string("proposal")
CareplanintentPlan -> json.string("plan")
CareplanintentOrder -> json.string("order")
CareplanintentOption -> json.string("option")
}
  }
  pub fn careplanintent_decoder() -> Decoder(Careplanintent) {
    use variant <- decode.then(decode.string)
    case variant {"proposal" -> decode.success(CareplanintentProposal)
"plan" -> decode.success(CareplanintentPlan)
"order" -> decode.success(CareplanintentOrder)
"option" -> decode.success(CareplanintentOption)
_ -> decode.failure(CareplanintentProposal, "Careplanintent")}
  }
  
pub type Measurereportstatus{MeasurereportstatusComplete
MeasurereportstatusPending
MeasurereportstatusError
}
pub fn measurereportstatus_to_json(measurereportstatus: Measurereportstatus) -> Json {
    case measurereportstatus {MeasurereportstatusComplete -> json.string("complete")
MeasurereportstatusPending -> json.string("pending")
MeasurereportstatusError -> json.string("error")
}
  }
  pub fn measurereportstatus_decoder() -> Decoder(Measurereportstatus) {
    use variant <- decode.then(decode.string)
    case variant {"complete" -> decode.success(MeasurereportstatusComplete)
"pending" -> decode.success(MeasurereportstatusPending)
"error" -> decode.success(MeasurereportstatusError)
_ -> decode.failure(MeasurereportstatusComplete, "Measurereportstatus")}
  }
  
pub type Endpointstatus{EndpointstatusActive
EndpointstatusSuspended
EndpointstatusError
EndpointstatusOff
EndpointstatusEnteredinerror
EndpointstatusTest
}
pub fn endpointstatus_to_json(endpointstatus: Endpointstatus) -> Json {
    case endpointstatus {EndpointstatusActive -> json.string("active")
EndpointstatusSuspended -> json.string("suspended")
EndpointstatusError -> json.string("error")
EndpointstatusOff -> json.string("off")
EndpointstatusEnteredinerror -> json.string("entered-in-error")
EndpointstatusTest -> json.string("test")
}
  }
  pub fn endpointstatus_decoder() -> Decoder(Endpointstatus) {
    use variant <- decode.then(decode.string)
    case variant {"active" -> decode.success(EndpointstatusActive)
"suspended" -> decode.success(EndpointstatusSuspended)
"error" -> decode.success(EndpointstatusError)
"off" -> decode.success(EndpointstatusOff)
"entered-in-error" -> decode.success(EndpointstatusEnteredinerror)
"test" -> decode.success(EndpointstatusTest)
_ -> decode.failure(EndpointstatusActive, "Endpointstatus")}
  }
  
pub type Addressuse{AddressuseHome
AddressuseWork
AddressuseTemp
AddressuseOld
AddressuseBilling
}
pub fn addressuse_to_json(addressuse: Addressuse) -> Json {
    case addressuse {AddressuseHome -> json.string("home")
AddressuseWork -> json.string("work")
AddressuseTemp -> json.string("temp")
AddressuseOld -> json.string("old")
AddressuseBilling -> json.string("billing")
}
  }
  pub fn addressuse_decoder() -> Decoder(Addressuse) {
    use variant <- decode.then(decode.string)
    case variant {"home" -> decode.success(AddressuseHome)
"work" -> decode.success(AddressuseWork)
"temp" -> decode.success(AddressuseTemp)
"old" -> decode.success(AddressuseOld)
"billing" -> decode.success(AddressuseBilling)
_ -> decode.failure(AddressuseHome, "Addressuse")}
  }
  
pub type Maptargetlistmode{MaptargetlistmodeFirst
MaptargetlistmodeShare
MaptargetlistmodeLast
MaptargetlistmodeCollate
}
pub fn maptargetlistmode_to_json(maptargetlistmode: Maptargetlistmode) -> Json {
    case maptargetlistmode {MaptargetlistmodeFirst -> json.string("first")
MaptargetlistmodeShare -> json.string("share")
MaptargetlistmodeLast -> json.string("last")
MaptargetlistmodeCollate -> json.string("collate")
}
  }
  pub fn maptargetlistmode_decoder() -> Decoder(Maptargetlistmode) {
    use variant <- decode.then(decode.string)
    case variant {"first" -> decode.success(MaptargetlistmodeFirst)
"share" -> decode.success(MaptargetlistmodeShare)
"last" -> decode.success(MaptargetlistmodeLast)
"collate" -> decode.success(MaptargetlistmodeCollate)
_ -> decode.failure(MaptargetlistmodeFirst, "Maptargetlistmode")}
  }
  
pub type Reportresultcodes{ReportresultcodesPass
ReportresultcodesFail
ReportresultcodesPending
}
pub fn reportresultcodes_to_json(reportresultcodes: Reportresultcodes) -> Json {
    case reportresultcodes {ReportresultcodesPass -> json.string("pass")
ReportresultcodesFail -> json.string("fail")
ReportresultcodesPending -> json.string("pending")
}
  }
  pub fn reportresultcodes_decoder() -> Decoder(Reportresultcodes) {
    use variant <- decode.then(decode.string)
    case variant {"pass" -> decode.success(ReportresultcodesPass)
"fail" -> decode.success(ReportresultcodesFail)
"pending" -> decode.success(ReportresultcodesPending)
_ -> decode.failure(ReportresultcodesPass, "Reportresultcodes")}
  }
  