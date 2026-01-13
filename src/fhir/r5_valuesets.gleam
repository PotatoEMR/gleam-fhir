pub type Conditionaldeletestatus {
  ConditionaldeletestatusNotsupported
  ConditionaldeletestatusSingle
  ConditionaldeletestatusMultiple
}

pub fn conditionaldeletestatus_to_json(
  conditionaldeletestatus: Conditionaldeletestatus,
) -> Json {
  case conditionaldeletestatus {
    ConditionaldeletestatusNotsupported -> json.string("not-supported")
    ConditionaldeletestatusSingle -> json.string("single")
    ConditionaldeletestatusMultiple -> json.string("multiple")
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

pub type Namingsystemtype {
  NamingsystemtypeCodesystem
  NamingsystemtypeIdentifier
  NamingsystemtypeRoot
}

pub fn namingsystemtype_to_json(namingsystemtype: Namingsystemtype) -> Json {
  case namingsystemtype {
    NamingsystemtypeCodesystem -> json.string("codesystem")
    NamingsystemtypeIdentifier -> json.string("identifier")
    NamingsystemtypeRoot -> json.string("root")
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

pub type Encounterlocationstatus {
  EncounterlocationstatusPlanned
  EncounterlocationstatusActive
  EncounterlocationstatusReserved
  EncounterlocationstatusCompleted
}

pub fn encounterlocationstatus_to_json(
  encounterlocationstatus: Encounterlocationstatus,
) -> Json {
  case encounterlocationstatus {
    EncounterlocationstatusPlanned -> json.string("planned")
    EncounterlocationstatusActive -> json.string("active")
    EncounterlocationstatusReserved -> json.string("reserved")
    EncounterlocationstatusCompleted -> json.string("completed")
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

pub type Adverseeventstatus {
  AdverseeventstatusInprogress
  AdverseeventstatusCompleted
  AdverseeventstatusEnteredinerror
  AdverseeventstatusUnknown
}

pub fn adverseeventstatus_to_json(
  adverseeventstatus: Adverseeventstatus,
) -> Json {
  case adverseeventstatus {
    AdverseeventstatusInprogress -> json.string("in-progress")
    AdverseeventstatusCompleted -> json.string("completed")
    AdverseeventstatusEnteredinerror -> json.string("entered-in-error")
    AdverseeventstatusUnknown -> json.string("unknown")
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

pub type Resourceaggregationmode {
  ResourceaggregationmodeContained
  ResourceaggregationmodeReferenced
  ResourceaggregationmodeBundled
}

pub fn resourceaggregationmode_to_json(
  resourceaggregationmode: Resourceaggregationmode,
) -> Json {
  case resourceaggregationmode {
    ResourceaggregationmodeContained -> json.string("contained")
    ResourceaggregationmodeReferenced -> json.string("referenced")
    ResourceaggregationmodeBundled -> json.string("bundled")
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

pub type Transportstatus {
  TransportstatusInprogress
  TransportstatusCompleted
  TransportstatusAbandoned
  TransportstatusCancelled
  TransportstatusPlanned
  TransportstatusEnteredinerror
}

pub fn transportstatus_to_json(transportstatus: Transportstatus) -> Json {
  case transportstatus {
    TransportstatusInprogress -> json.string("in-progress")
    TransportstatusCompleted -> json.string("completed")
    TransportstatusAbandoned -> json.string("abandoned")
    TransportstatusCancelled -> json.string("cancelled")
    TransportstatusPlanned -> json.string("planned")
    TransportstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Structuredefinitionkind {
  StructuredefinitionkindPrimitivetype
  StructuredefinitionkindComplextype
  StructuredefinitionkindResource
  StructuredefinitionkindLogical
}

pub fn structuredefinitionkind_to_json(
  structuredefinitionkind: Structuredefinitionkind,
) -> Json {
  case structuredefinitionkind {
    StructuredefinitionkindPrimitivetype -> json.string("primitive-type")
    StructuredefinitionkindComplextype -> json.string("complex-type")
    StructuredefinitionkindResource -> json.string("resource")
    StructuredefinitionkindLogical -> json.string("logical")
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

pub type Locationstatus {
  LocationstatusActive
  LocationstatusSuspended
  LocationstatusInactive
}

pub fn locationstatus_to_json(locationstatus: Locationstatus) -> Json {
  case locationstatus {
    LocationstatusActive -> json.string("active")
    LocationstatusSuspended -> json.string("suspended")
    LocationstatusInactive -> json.string("inactive")
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

pub type Invoicestatus {
  InvoicestatusDraft
  InvoicestatusIssued
  InvoicestatusBalanced
  InvoicestatusCancelled
  InvoicestatusEnteredinerror
}

pub fn invoicestatus_to_json(invoicestatus: Invoicestatus) -> Json {
  case invoicestatus {
    InvoicestatusDraft -> json.string("draft")
    InvoicestatusIssued -> json.string("issued")
    InvoicestatusBalanced -> json.string("balanced")
    InvoicestatusCancelled -> json.string("cancelled")
    InvoicestatusEnteredinerror -> json.string("entered-in-error")
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
  case quantitycomparator {
    QuantitycomparatorLessthan -> json.string("<")
    QuantitycomparatorLessthanequal -> json.string("<=")
    QuantitycomparatorGreaterthanequal -> json.string(">=")
    QuantitycomparatorGreaterthan -> json.string(">")
    QuantitycomparatorAd -> json.string("ad")
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

pub type Reportresultcodes {
  ReportresultcodesPass
  ReportresultcodesFail
  ReportresultcodesPending
}

pub fn reportresultcodes_to_json(reportresultcodes: Reportresultcodes) -> Json {
  case reportresultcodes {
    ReportresultcodesPass -> json.string("pass")
    ReportresultcodesFail -> json.string("fail")
    ReportresultcodesPending -> json.string("pending")
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
  case characteristiccombination {
    CharacteristiccombinationAllof -> json.string("all-of")
    CharacteristiccombinationAnyof -> json.string("any-of")
    CharacteristiccombinationAtleast -> json.string("at-least")
    CharacteristiccombinationAtmost -> json.string("at-most")
    CharacteristiccombinationStatistical -> json.string("statistical")
    CharacteristiccombinationNeteffect -> json.string("net-effect")
    CharacteristiccombinationDataset -> json.string("dataset")
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

pub type Operationparameteruse {
  OperationparameteruseIn
  OperationparameteruseOut
}

pub fn operationparameteruse_to_json(
  operationparameteruse: Operationparameteruse,
) -> Json {
  case operationparameteruse {
    OperationparameteruseIn -> json.string("in")
    OperationparameteruseOut -> json.string("out")
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

pub type Substancestatus {
  SubstancestatusActive
  SubstancestatusInactive
  SubstancestatusEnteredinerror
}

pub fn substancestatus_to_json(substancestatus: Substancestatus) -> Json {
  case substancestatus {
    SubstancestatusActive -> json.string("active")
    SubstancestatusInactive -> json.string("inactive")
    SubstancestatusEnteredinerror -> json.string("entered-in-error")
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
  case permissionrulecombining {
    PermissionrulecombiningDenyoverrides -> json.string("deny-overrides")
    PermissionrulecombiningPermitoverrides -> json.string("permit-overrides")
    PermissionrulecombiningOrdereddenyoverrides ->
      json.string("ordered-deny-overrides")
    PermissionrulecombiningOrderedpermitoverrides ->
      json.string("ordered-permit-overrides")
    PermissionrulecombiningDenyunlesspermit -> json.string("deny-unless-permit")
    PermissionrulecombiningPermitunlessdeny -> json.string("permit-unless-deny")
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
  case unitsoftime {
    UnitsoftimeS -> json.string("s")
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

pub type Careteamstatus {
  CareteamstatusProposed
  CareteamstatusActive
  CareteamstatusSuspended
  CareteamstatusInactive
  CareteamstatusEnteredinerror
}

pub fn careteamstatus_to_json(careteamstatus: Careteamstatus) -> Json {
  case careteamstatus {
    CareteamstatusProposed -> json.string("proposed")
    CareteamstatusActive -> json.string("active")
    CareteamstatusSuspended -> json.string("suspended")
    CareteamstatusInactive -> json.string("inactive")
    CareteamstatusEnteredinerror -> json.string("entered-in-error")
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
  case compositionstatus {
    CompositionstatusRegistered -> json.string("registered")
    CompositionstatusPartial -> json.string("partial")
    CompositionstatusPreliminary -> json.string("preliminary")
    CompositionstatusFinal -> json.string("final")
    CompositionstatusAmended -> json.string("amended")
    CompositionstatusCorrected -> json.string("corrected")
    CompositionstatusAppended -> json.string("appended")
    CompositionstatusCancelled -> json.string("cancelled")
    CompositionstatusEnteredinerror -> json.string("entered-in-error")
    CompositionstatusDeprecated -> json.string("deprecated")
    CompositionstatusUnknown -> json.string("unknown")
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
  case chargeitemstatus {
    ChargeitemstatusPlanned -> json.string("planned")
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
  case resourcetypes {
    ResourcetypesAccount -> json.string("Account")
    ResourcetypesActivitydefinition -> json.string("ActivityDefinition")
    ResourcetypesActordefinition -> json.string("ActorDefinition")
    ResourcetypesAdministrableproductdefinition ->
      json.string("AdministrableProductDefinition")
    ResourcetypesAdverseevent -> json.string("AdverseEvent")
    ResourcetypesAllergyintolerance -> json.string("AllergyIntolerance")
    ResourcetypesAppointment -> json.string("Appointment")
    ResourcetypesAppointmentresponse -> json.string("AppointmentResponse")
    ResourcetypesArtifactassessment -> json.string("ArtifactAssessment")
    ResourcetypesAuditevent -> json.string("AuditEvent")
    ResourcetypesBasic -> json.string("Basic")
    ResourcetypesBinary -> json.string("Binary")
    ResourcetypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    ResourcetypesBiologicallyderivedproductdispense ->
      json.string("BiologicallyDerivedProductDispense")
    ResourcetypesBodystructure -> json.string("BodyStructure")
    ResourcetypesBundle -> json.string("Bundle")
    ResourcetypesCapabilitystatement -> json.string("CapabilityStatement")
    ResourcetypesCareplan -> json.string("CarePlan")
    ResourcetypesCareteam -> json.string("CareTeam")
    ResourcetypesChargeitem -> json.string("ChargeItem")
    ResourcetypesChargeitemdefinition -> json.string("ChargeItemDefinition")
    ResourcetypesCitation -> json.string("Citation")
    ResourcetypesClaim -> json.string("Claim")
    ResourcetypesClaimresponse -> json.string("ClaimResponse")
    ResourcetypesClinicalimpression -> json.string("ClinicalImpression")
    ResourcetypesClinicalusedefinition -> json.string("ClinicalUseDefinition")
    ResourcetypesCodesystem -> json.string("CodeSystem")
    ResourcetypesCommunication -> json.string("Communication")
    ResourcetypesCommunicationrequest -> json.string("CommunicationRequest")
    ResourcetypesCompartmentdefinition -> json.string("CompartmentDefinition")
    ResourcetypesComposition -> json.string("Composition")
    ResourcetypesConceptmap -> json.string("ConceptMap")
    ResourcetypesCondition -> json.string("Condition")
    ResourcetypesConditiondefinition -> json.string("ConditionDefinition")
    ResourcetypesConsent -> json.string("Consent")
    ResourcetypesContract -> json.string("Contract")
    ResourcetypesCoverage -> json.string("Coverage")
    ResourcetypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    ResourcetypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    ResourcetypesDetectedissue -> json.string("DetectedIssue")
    ResourcetypesDevice -> json.string("Device")
    ResourcetypesDeviceassociation -> json.string("DeviceAssociation")
    ResourcetypesDevicedefinition -> json.string("DeviceDefinition")
    ResourcetypesDevicedispense -> json.string("DeviceDispense")
    ResourcetypesDevicemetric -> json.string("DeviceMetric")
    ResourcetypesDevicerequest -> json.string("DeviceRequest")
    ResourcetypesDeviceusage -> json.string("DeviceUsage")
    ResourcetypesDiagnosticreport -> json.string("DiagnosticReport")
    ResourcetypesDocumentreference -> json.string("DocumentReference")
    ResourcetypesEncounter -> json.string("Encounter")
    ResourcetypesEncounterhistory -> json.string("EncounterHistory")
    ResourcetypesEndpoint -> json.string("Endpoint")
    ResourcetypesEnrollmentrequest -> json.string("EnrollmentRequest")
    ResourcetypesEnrollmentresponse -> json.string("EnrollmentResponse")
    ResourcetypesEpisodeofcare -> json.string("EpisodeOfCare")
    ResourcetypesEventdefinition -> json.string("EventDefinition")
    ResourcetypesEvidence -> json.string("Evidence")
    ResourcetypesEvidencereport -> json.string("EvidenceReport")
    ResourcetypesEvidencevariable -> json.string("EvidenceVariable")
    ResourcetypesExamplescenario -> json.string("ExampleScenario")
    ResourcetypesExplanationofbenefit -> json.string("ExplanationOfBenefit")
    ResourcetypesFamilymemberhistory -> json.string("FamilyMemberHistory")
    ResourcetypesFlag -> json.string("Flag")
    ResourcetypesFormularyitem -> json.string("FormularyItem")
    ResourcetypesGenomicstudy -> json.string("GenomicStudy")
    ResourcetypesGoal -> json.string("Goal")
    ResourcetypesGraphdefinition -> json.string("GraphDefinition")
    ResourcetypesGroup -> json.string("Group")
    ResourcetypesGuidanceresponse -> json.string("GuidanceResponse")
    ResourcetypesHealthcareservice -> json.string("HealthcareService")
    ResourcetypesImagingselection -> json.string("ImagingSelection")
    ResourcetypesImagingstudy -> json.string("ImagingStudy")
    ResourcetypesImmunization -> json.string("Immunization")
    ResourcetypesImmunizationevaluation -> json.string("ImmunizationEvaluation")
    ResourcetypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    ResourcetypesImplementationguide -> json.string("ImplementationGuide")
    ResourcetypesIngredient -> json.string("Ingredient")
    ResourcetypesInsuranceplan -> json.string("InsurancePlan")
    ResourcetypesInventoryitem -> json.string("InventoryItem")
    ResourcetypesInventoryreport -> json.string("InventoryReport")
    ResourcetypesInvoice -> json.string("Invoice")
    ResourcetypesLibrary -> json.string("Library")
    ResourcetypesLinkage -> json.string("Linkage")
    ResourcetypesList -> json.string("List")
    ResourcetypesLocation -> json.string("Location")
    ResourcetypesManufactureditemdefinition ->
      json.string("ManufacturedItemDefinition")
    ResourcetypesMeasure -> json.string("Measure")
    ResourcetypesMeasurereport -> json.string("MeasureReport")
    ResourcetypesMedication -> json.string("Medication")
    ResourcetypesMedicationadministration ->
      json.string("MedicationAdministration")
    ResourcetypesMedicationdispense -> json.string("MedicationDispense")
    ResourcetypesMedicationknowledge -> json.string("MedicationKnowledge")
    ResourcetypesMedicationrequest -> json.string("MedicationRequest")
    ResourcetypesMedicationstatement -> json.string("MedicationStatement")
    ResourcetypesMedicinalproductdefinition ->
      json.string("MedicinalProductDefinition")
    ResourcetypesMessagedefinition -> json.string("MessageDefinition")
    ResourcetypesMessageheader -> json.string("MessageHeader")
    ResourcetypesMolecularsequence -> json.string("MolecularSequence")
    ResourcetypesNamingsystem -> json.string("NamingSystem")
    ResourcetypesNutritionintake -> json.string("NutritionIntake")
    ResourcetypesNutritionorder -> json.string("NutritionOrder")
    ResourcetypesNutritionproduct -> json.string("NutritionProduct")
    ResourcetypesObservation -> json.string("Observation")
    ResourcetypesObservationdefinition -> json.string("ObservationDefinition")
    ResourcetypesOperationdefinition -> json.string("OperationDefinition")
    ResourcetypesOperationoutcome -> json.string("OperationOutcome")
    ResourcetypesOrganization -> json.string("Organization")
    ResourcetypesOrganizationaffiliation ->
      json.string("OrganizationAffiliation")
    ResourcetypesPackagedproductdefinition ->
      json.string("PackagedProductDefinition")
    ResourcetypesParameters -> json.string("Parameters")
    ResourcetypesPatient -> json.string("Patient")
    ResourcetypesPaymentnotice -> json.string("PaymentNotice")
    ResourcetypesPaymentreconciliation -> json.string("PaymentReconciliation")
    ResourcetypesPermission -> json.string("Permission")
    ResourcetypesPerson -> json.string("Person")
    ResourcetypesPlandefinition -> json.string("PlanDefinition")
    ResourcetypesPractitioner -> json.string("Practitioner")
    ResourcetypesPractitionerrole -> json.string("PractitionerRole")
    ResourcetypesProcedure -> json.string("Procedure")
    ResourcetypesProvenance -> json.string("Provenance")
    ResourcetypesQuestionnaire -> json.string("Questionnaire")
    ResourcetypesQuestionnaireresponse -> json.string("QuestionnaireResponse")
    ResourcetypesRegulatedauthorization -> json.string("RegulatedAuthorization")
    ResourcetypesRelatedperson -> json.string("RelatedPerson")
    ResourcetypesRequestorchestration -> json.string("RequestOrchestration")
    ResourcetypesRequirements -> json.string("Requirements")
    ResourcetypesResearchstudy -> json.string("ResearchStudy")
    ResourcetypesResearchsubject -> json.string("ResearchSubject")
    ResourcetypesRiskassessment -> json.string("RiskAssessment")
    ResourcetypesSchedule -> json.string("Schedule")
    ResourcetypesSearchparameter -> json.string("SearchParameter")
    ResourcetypesServicerequest -> json.string("ServiceRequest")
    ResourcetypesSlot -> json.string("Slot")
    ResourcetypesSpecimen -> json.string("Specimen")
    ResourcetypesSpecimendefinition -> json.string("SpecimenDefinition")
    ResourcetypesStructuredefinition -> json.string("StructureDefinition")
    ResourcetypesStructuremap -> json.string("StructureMap")
    ResourcetypesSubscription -> json.string("Subscription")
    ResourcetypesSubscriptionstatus -> json.string("SubscriptionStatus")
    ResourcetypesSubscriptiontopic -> json.string("SubscriptionTopic")
    ResourcetypesSubstance -> json.string("Substance")
    ResourcetypesSubstancedefinition -> json.string("SubstanceDefinition")
    ResourcetypesSubstancenucleicacid -> json.string("SubstanceNucleicAcid")
    ResourcetypesSubstancepolymer -> json.string("SubstancePolymer")
    ResourcetypesSubstanceprotein -> json.string("SubstanceProtein")
    ResourcetypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    ResourcetypesSubstancesourcematerial ->
      json.string("SubstanceSourceMaterial")
    ResourcetypesSupplydelivery -> json.string("SupplyDelivery")
    ResourcetypesSupplyrequest -> json.string("SupplyRequest")
    ResourcetypesTask -> json.string("Task")
    ResourcetypesTerminologycapabilities ->
      json.string("TerminologyCapabilities")
    ResourcetypesTestplan -> json.string("TestPlan")
    ResourcetypesTestreport -> json.string("TestReport")
    ResourcetypesTestscript -> json.string("TestScript")
    ResourcetypesTransport -> json.string("Transport")
    ResourcetypesValueset -> json.string("ValueSet")
    ResourcetypesVerificationresult -> json.string("VerificationResult")
    ResourcetypesVisionprescription -> json.string("VisionPrescription")
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

pub type Claimoutcome {
  ClaimoutcomeQueued
  ClaimoutcomeComplete
  ClaimoutcomeError
  ClaimoutcomePartial
}

pub fn claimoutcome_to_json(claimoutcome: Claimoutcome) -> Json {
  case claimoutcome {
    ClaimoutcomeQueued -> json.string("queued")
    ClaimoutcomeComplete -> json.string("complete")
    ClaimoutcomeError -> json.string("error")
    ClaimoutcomePartial -> json.string("partial")
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

pub type Reactioneventseverity {
  ReactioneventseverityMild
  ReactioneventseverityModerate
  ReactioneventseveritySevere
}

pub fn reactioneventseverity_to_json(
  reactioneventseverity: Reactioneventseverity,
) -> Json {
  case reactioneventseverity {
    ReactioneventseverityMild -> json.string("mild")
    ReactioneventseverityModerate -> json.string("moderate")
    ReactioneventseveritySevere -> json.string("severe")
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

pub type Notetype {
  NotetypeDisplay
  NotetypePrint
  NotetypePrintoper
}

pub fn notetype_to_json(notetype: Notetype) -> Json {
  case notetype {
    NotetypeDisplay -> json.string("display")
    NotetypePrint -> json.string("print")
    NotetypePrintoper -> json.string("printoper")
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

pub type Conditionquestionnairepurpose {
  ConditionquestionnairepurposePreadmit
  ConditionquestionnairepurposeDiffdiagnosis
  ConditionquestionnairepurposeOutcome
}

pub fn conditionquestionnairepurpose_to_json(
  conditionquestionnairepurpose: Conditionquestionnairepurpose,
) -> Json {
  case conditionquestionnairepurpose {
    ConditionquestionnairepurposePreadmit -> json.string("preadmit")
    ConditionquestionnairepurposeDiffdiagnosis -> json.string("diff-diagnosis")
    ConditionquestionnairepurposeOutcome -> json.string("outcome")
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

pub type Actionprecheckbehavior {
  ActionprecheckbehaviorYes
  ActionprecheckbehaviorNo
}

pub fn actionprecheckbehavior_to_json(
  actionprecheckbehavior: Actionprecheckbehavior,
) -> Json {
  case actionprecheckbehavior {
    ActionprecheckbehaviorYes -> json.string("yes")
    ActionprecheckbehaviorNo -> json.string("no")
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

pub type Compartmenttype {
  CompartmenttypePatient
  CompartmenttypeEncounter
  CompartmenttypeRelatedperson
  CompartmenttypePractitioner
  CompartmenttypeDevice
  CompartmenttypeEpisodeofcare
}

pub fn compartmenttype_to_json(compartmenttype: Compartmenttype) -> Json {
  case compartmenttype {
    CompartmenttypePatient -> json.string("Patient")
    CompartmenttypeEncounter -> json.string("Encounter")
    CompartmenttypeRelatedperson -> json.string("RelatedPerson")
    CompartmenttypePractitioner -> json.string("Practitioner")
    CompartmenttypeDevice -> json.string("Device")
    CompartmenttypeEpisodeofcare -> json.string("EpisodeOfCare")
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
  case imagingselection2dgraphictype {
    Imagingselection2dgraphictypePoint -> json.string("point")
    Imagingselection2dgraphictypePolyline -> json.string("polyline")
    Imagingselection2dgraphictypeInterpolated -> json.string("interpolated")
    Imagingselection2dgraphictypeCircle -> json.string("circle")
    Imagingselection2dgraphictypeEllipse -> json.string("ellipse")
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
  case ianalinkrelations {
    IanalinkrelationsAbout -> json.string("about")
    IanalinkrelationsAcl -> json.string("acl")
    IanalinkrelationsAlternate -> json.string("alternate")
    IanalinkrelationsAmphtml -> json.string("amphtml")
    IanalinkrelationsAppendix -> json.string("appendix")
    IanalinkrelationsAppletouchicon -> json.string("apple-touch-icon")
    IanalinkrelationsAppletouchstartupimage ->
      json.string("apple-touch-startup-image")
    IanalinkrelationsArchives -> json.string("archives")
    IanalinkrelationsAuthor -> json.string("author")
    IanalinkrelationsBlockedby -> json.string("blocked-by")
    IanalinkrelationsBookmark -> json.string("bookmark")
    IanalinkrelationsCanonical -> json.string("canonical")
    IanalinkrelationsChapter -> json.string("chapter")
    IanalinkrelationsCiteas -> json.string("cite-as")
    IanalinkrelationsCollection -> json.string("collection")
    IanalinkrelationsContents -> json.string("contents")
    IanalinkrelationsConvertedfrom -> json.string("convertedFrom")
    IanalinkrelationsCopyright -> json.string("copyright")
    IanalinkrelationsCreateform -> json.string("create-form")
    IanalinkrelationsCurrent -> json.string("current")
    IanalinkrelationsDescribedby -> json.string("describedby")
    IanalinkrelationsDescribes -> json.string("describes")
    IanalinkrelationsDisclosure -> json.string("disclosure")
    IanalinkrelationsDnsprefetch -> json.string("dns-prefetch")
    IanalinkrelationsDuplicate -> json.string("duplicate")
    IanalinkrelationsEdit -> json.string("edit")
    IanalinkrelationsEditform -> json.string("edit-form")
    IanalinkrelationsEditmedia -> json.string("edit-media")
    IanalinkrelationsEnclosure -> json.string("enclosure")
    IanalinkrelationsExternal -> json.string("external")
    IanalinkrelationsFirst -> json.string("first")
    IanalinkrelationsGlossary -> json.string("glossary")
    IanalinkrelationsHelp -> json.string("help")
    IanalinkrelationsHosts -> json.string("hosts")
    IanalinkrelationsHub -> json.string("hub")
    IanalinkrelationsIcon -> json.string("icon")
    IanalinkrelationsIndex -> json.string("index")
    IanalinkrelationsIntervalafter -> json.string("intervalAfter")
    IanalinkrelationsIntervalbefore -> json.string("intervalBefore")
    IanalinkrelationsIntervalcontains -> json.string("intervalContains")
    IanalinkrelationsIntervaldisjoint -> json.string("intervalDisjoint")
    IanalinkrelationsIntervalduring -> json.string("intervalDuring")
    IanalinkrelationsIntervalequals -> json.string("intervalEquals")
    IanalinkrelationsIntervalfinishedby -> json.string("intervalFinishedBy")
    IanalinkrelationsIntervalfinishes -> json.string("intervalFinishes")
    IanalinkrelationsIntervalin -> json.string("intervalIn")
    IanalinkrelationsIntervalmeets -> json.string("intervalMeets")
    IanalinkrelationsIntervalmetby -> json.string("intervalMetBy")
    IanalinkrelationsIntervaloverlappedby -> json.string("intervalOverlappedBy")
    IanalinkrelationsIntervaloverlaps -> json.string("intervalOverlaps")
    IanalinkrelationsIntervalstartedby -> json.string("intervalStartedBy")
    IanalinkrelationsIntervalstarts -> json.string("intervalStarts")
    IanalinkrelationsItem -> json.string("item")
    IanalinkrelationsLast -> json.string("last")
    IanalinkrelationsLatestversion -> json.string("latest-version")
    IanalinkrelationsLicense -> json.string("license")
    IanalinkrelationsLinkset -> json.string("linkset")
    IanalinkrelationsLrdd -> json.string("lrdd")
    IanalinkrelationsManifest -> json.string("manifest")
    IanalinkrelationsMaskicon -> json.string("mask-icon")
    IanalinkrelationsMediafeed -> json.string("media-feed")
    IanalinkrelationsMemento -> json.string("memento")
    IanalinkrelationsMicropub -> json.string("micropub")
    IanalinkrelationsModulepreload -> json.string("modulepreload")
    IanalinkrelationsMonitor -> json.string("monitor")
    IanalinkrelationsMonitorgroup -> json.string("monitor-group")
    IanalinkrelationsNext -> json.string("next")
    IanalinkrelationsNextarchive -> json.string("next-archive")
    IanalinkrelationsNofollow -> json.string("nofollow")
    IanalinkrelationsNoopener -> json.string("noopener")
    IanalinkrelationsNoreferrer -> json.string("noreferrer")
    IanalinkrelationsOpener -> json.string("opener")
    IanalinkrelationsOpenid2localid -> json.string("openid2.local_id")
    IanalinkrelationsOpenid2provider -> json.string("openid2.provider")
    IanalinkrelationsOriginal -> json.string("original")
    IanalinkrelationsP3pv1 -> json.string("P3Pv1")
    IanalinkrelationsPayment -> json.string("payment")
    IanalinkrelationsPingback -> json.string("pingback")
    IanalinkrelationsPreconnect -> json.string("preconnect")
    IanalinkrelationsPredecessorversion -> json.string("predecessor-version")
    IanalinkrelationsPrefetch -> json.string("prefetch")
    IanalinkrelationsPreload -> json.string("preload")
    IanalinkrelationsPrerender -> json.string("prerender")
    IanalinkrelationsPrev -> json.string("prev")
    IanalinkrelationsPreview -> json.string("preview")
    IanalinkrelationsPrevious -> json.string("previous")
    IanalinkrelationsPrevarchive -> json.string("prev-archive")
    IanalinkrelationsPrivacypolicy -> json.string("privacy-policy")
    IanalinkrelationsProfile -> json.string("profile")
    IanalinkrelationsPublication -> json.string("publication")
    IanalinkrelationsRelated -> json.string("related")
    IanalinkrelationsRestconf -> json.string("restconf")
    IanalinkrelationsReplies -> json.string("replies")
    IanalinkrelationsRuleinput -> json.string("ruleinput")
    IanalinkrelationsSearch -> json.string("search")
    IanalinkrelationsSection -> json.string("section")
    IanalinkrelationsSelf -> json.string("self")
    IanalinkrelationsService -> json.string("service")
    IanalinkrelationsServicedesc -> json.string("service-desc")
    IanalinkrelationsServicedoc -> json.string("service-doc")
    IanalinkrelationsServicemeta -> json.string("service-meta")
    IanalinkrelationsSponsored -> json.string("sponsored")
    IanalinkrelationsStart -> json.string("start")
    IanalinkrelationsStatus -> json.string("status")
    IanalinkrelationsStylesheet -> json.string("stylesheet")
    IanalinkrelationsSubsection -> json.string("subsection")
    IanalinkrelationsSuccessorversion -> json.string("successor-version")
    IanalinkrelationsSunset -> json.string("sunset")
    IanalinkrelationsTag -> json.string("tag")
    IanalinkrelationsTermsofservice -> json.string("terms-of-service")
    IanalinkrelationsTimegate -> json.string("timegate")
    IanalinkrelationsTimemap -> json.string("timemap")
    IanalinkrelationsType -> json.string("type")
    IanalinkrelationsUgc -> json.string("ugc")
    IanalinkrelationsUp -> json.string("up")
    IanalinkrelationsVersionhistory -> json.string("version-history")
    IanalinkrelationsVia -> json.string("via")
    IanalinkrelationsWebmention -> json.string("webmention")
    IanalinkrelationsWorkingcopy -> json.string("working-copy")
    IanalinkrelationsWorkingcopyof -> json.string("working-copy-of")
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
  case observationstatus {
    ObservationstatusRegistered -> json.string("registered")
    ObservationstatusPreliminary -> json.string("preliminary")
    ObservationstatusFinal -> json.string("final")
    ObservationstatusAmended -> json.string("amended")
    ObservationstatusCorrected -> json.string("corrected")
    ObservationstatusCancelled -> json.string("cancelled")
    ObservationstatusEnteredinerror -> json.string("entered-in-error")
    ObservationstatusUnknown -> json.string("unknown")
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

pub type Bindingstrength {
  BindingstrengthRequired
  BindingstrengthExtensible
  BindingstrengthPreferred
  BindingstrengthExample
}

pub fn bindingstrength_to_json(bindingstrength: Bindingstrength) -> Json {
  case bindingstrength {
    BindingstrengthRequired -> json.string("required")
    BindingstrengthExtensible -> json.string("extensible")
    BindingstrengthPreferred -> json.string("preferred")
    BindingstrengthExample -> json.string("example")
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
  case additionalbindingpurpose {
    AdditionalbindingpurposeMaximum -> json.string("maximum")
    AdditionalbindingpurposeMinimum -> json.string("minimum")
    AdditionalbindingpurposeRequired -> json.string("required")
    AdditionalbindingpurposeExtensible -> json.string("extensible")
    AdditionalbindingpurposeCandidate -> json.string("candidate")
    AdditionalbindingpurposeCurrent -> json.string("current")
    AdditionalbindingpurposePreferred -> json.string("preferred")
    AdditionalbindingpurposeUi -> json.string("ui")
    AdditionalbindingpurposeStarter -> json.string("starter")
    AdditionalbindingpurposeComponent -> json.string("component")
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

pub type Requestpriority {
  RequestpriorityRoutine
  RequestpriorityUrgent
  RequestpriorityAsap
  RequestpriorityStat
}

pub fn requestpriority_to_json(requestpriority: Requestpriority) -> Json {
  case requestpriority {
    RequestpriorityRoutine -> json.string("routine")
    RequestpriorityUrgent -> json.string("urgent")
    RequestpriorityAsap -> json.string("asap")
    RequestpriorityStat -> json.string("stat")
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

pub type Conditionpreconditiontype {
  ConditionpreconditiontypeSensitive
  ConditionpreconditiontypeSpecific
}

pub fn conditionpreconditiontype_to_json(
  conditionpreconditiontype: Conditionpreconditiontype,
) -> Json {
  case conditionpreconditiontype {
    ConditionpreconditiontypeSensitive -> json.string("sensitive")
    ConditionpreconditiontypeSpecific -> json.string("specific")
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

pub type Supplydeliverystatus {
  SupplydeliverystatusInprogress
  SupplydeliverystatusCompleted
  SupplydeliverystatusAbandoned
  SupplydeliverystatusEnteredinerror
}

pub fn supplydeliverystatus_to_json(
  supplydeliverystatus: Supplydeliverystatus,
) -> Json {
  case supplydeliverystatus {
    SupplydeliverystatusInprogress -> json.string("in-progress")
    SupplydeliverystatusCompleted -> json.string("completed")
    SupplydeliverystatusAbandoned -> json.string("abandoned")
    SupplydeliverystatusEnteredinerror -> json.string("entered-in-error")
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
  case issuetype {
    IssuetypeInvalid -> json.string("invalid")
    IssuetypeStructure -> json.string("structure")
    IssuetypeRequired -> json.string("required")
    IssuetypeValue -> json.string("value")
    IssuetypeInvariant -> json.string("invariant")
    IssuetypeSecurity -> json.string("security")
    IssuetypeLogin -> json.string("login")
    IssuetypeUnknown -> json.string("unknown")
    IssuetypeExpired -> json.string("expired")
    IssuetypeForbidden -> json.string("forbidden")
    IssuetypeSuppressed -> json.string("suppressed")
    IssuetypeProcessing -> json.string("processing")
    IssuetypeNotsupported -> json.string("not-supported")
    IssuetypeDuplicate -> json.string("duplicate")
    IssuetypeMultiplematches -> json.string("multiple-matches")
    IssuetypeNotfound -> json.string("not-found")
    IssuetypeDeleted -> json.string("deleted")
    IssuetypeToolong -> json.string("too-long")
    IssuetypeCodeinvalid -> json.string("code-invalid")
    IssuetypeExtension -> json.string("extension")
    IssuetypeToocostly -> json.string("too-costly")
    IssuetypeBusinessrule -> json.string("business-rule")
    IssuetypeConflict -> json.string("conflict")
    IssuetypeLimitedfilter -> json.string("limited-filter")
    IssuetypeTransient -> json.string("transient")
    IssuetypeLockerror -> json.string("lock-error")
    IssuetypeNostore -> json.string("no-store")
    IssuetypeException -> json.string("exception")
    IssuetypeTimeout -> json.string("timeout")
    IssuetypeIncomplete -> json.string("incomplete")
    IssuetypeThrottled -> json.string("throttled")
    IssuetypeInformational -> json.string("informational")
    IssuetypeSuccess -> json.string("success")
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
  case assertresponsecodetypes {
    AssertresponsecodetypesContinue -> json.string("continue")
    AssertresponsecodetypesSwitchingprotocols ->
      json.string("switchingProtocols")
    AssertresponsecodetypesOkay -> json.string("okay")
    AssertresponsecodetypesCreated -> json.string("created")
    AssertresponsecodetypesAccepted -> json.string("accepted")
    AssertresponsecodetypesNonauthoritativeinformation ->
      json.string("nonAuthoritativeInformation")
    AssertresponsecodetypesNocontent -> json.string("noContent")
    AssertresponsecodetypesResetcontent -> json.string("resetContent")
    AssertresponsecodetypesPartialcontent -> json.string("partialContent")
    AssertresponsecodetypesMultiplechoices -> json.string("multipleChoices")
    AssertresponsecodetypesMovedpermanently -> json.string("movedPermanently")
    AssertresponsecodetypesFound -> json.string("found")
    AssertresponsecodetypesSeeother -> json.string("seeOther")
    AssertresponsecodetypesNotmodified -> json.string("notModified")
    AssertresponsecodetypesUseproxy -> json.string("useProxy")
    AssertresponsecodetypesTemporaryredirect -> json.string("temporaryRedirect")
    AssertresponsecodetypesPermanentredirect -> json.string("permanentRedirect")
    AssertresponsecodetypesBadrequest -> json.string("badRequest")
    AssertresponsecodetypesUnauthorized -> json.string("unauthorized")
    AssertresponsecodetypesPaymentrequired -> json.string("paymentRequired")
    AssertresponsecodetypesForbidden -> json.string("forbidden")
    AssertresponsecodetypesNotfound -> json.string("notFound")
    AssertresponsecodetypesMethodnotallowed -> json.string("methodNotAllowed")
    AssertresponsecodetypesNotacceptable -> json.string("notAcceptable")
    AssertresponsecodetypesProxyauthenticationrequired ->
      json.string("proxyAuthenticationRequired")
    AssertresponsecodetypesRequesttimeout -> json.string("requestTimeout")
    AssertresponsecodetypesConflict -> json.string("conflict")
    AssertresponsecodetypesGone -> json.string("gone")
    AssertresponsecodetypesLengthrequired -> json.string("lengthRequired")
    AssertresponsecodetypesPreconditionfailed ->
      json.string("preconditionFailed")
    AssertresponsecodetypesContenttoolarge -> json.string("contentTooLarge")
    AssertresponsecodetypesUritoolong -> json.string("uriTooLong")
    AssertresponsecodetypesUnsupportedmediatype ->
      json.string("unsupportedMediaType")
    AssertresponsecodetypesRangenotsatisfiable ->
      json.string("rangeNotSatisfiable")
    AssertresponsecodetypesExpectationfailed -> json.string("expectationFailed")
    AssertresponsecodetypesMisdirectedrequest ->
      json.string("misdirectedRequest")
    AssertresponsecodetypesUnprocessablecontent ->
      json.string("unprocessableContent")
    AssertresponsecodetypesUpgraderequired -> json.string("upgradeRequired")
    AssertresponsecodetypesInternalservererror ->
      json.string("internalServerError")
    AssertresponsecodetypesNotimplemented -> json.string("notImplemented")
    AssertresponsecodetypesBadgateway -> json.string("badGateway")
    AssertresponsecodetypesServiceunavailable ->
      json.string("serviceUnavailable")
    AssertresponsecodetypesGatewaytimeout -> json.string("gatewayTimeout")
    AssertresponsecodetypesHttpversionnotsupported ->
      json.string("httpVersionNotSupported")
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

pub type Variablehandling {
  VariablehandlingContinuous
  VariablehandlingDichotomous
  VariablehandlingOrdinal
  VariablehandlingPolychotomous
}

pub fn variablehandling_to_json(variablehandling: Variablehandling) -> Json {
  case variablehandling {
    VariablehandlingContinuous -> json.string("continuous")
    VariablehandlingDichotomous -> json.string("dichotomous")
    VariablehandlingOrdinal -> json.string("ordinal")
    VariablehandlingPolychotomous -> json.string("polychotomous")
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

pub type Specimencombined {
  SpecimencombinedGrouped
  SpecimencombinedPooled
}

pub fn specimencombined_to_json(specimencombined: Specimencombined) -> Json {
  case specimencombined {
    SpecimencombinedGrouped -> json.string("grouped")
    SpecimencombinedPooled -> json.string("pooled")
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

pub type Identityassurancelevel {
  IdentityassurancelevelLevel1
  IdentityassurancelevelLevel2
  IdentityassurancelevelLevel3
  IdentityassurancelevelLevel4
}

pub fn identityassurancelevel_to_json(
  identityassurancelevel: Identityassurancelevel,
) -> Json {
  case identityassurancelevel {
    IdentityassurancelevelLevel1 -> json.string("level1")
    IdentityassurancelevelLevel2 -> json.string("level2")
    IdentityassurancelevelLevel3 -> json.string("level3")
    IdentityassurancelevelLevel4 -> json.string("level4")
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

pub type Httpverb {
  HttpverbGet
  HttpverbHead
  HttpverbPost
  HttpverbPut
  HttpverbDelete
  HttpverbPatch
}

pub fn httpverb_to_json(httpverb: Httpverb) -> Json {
  case httpverb {
    HttpverbGet -> json.string("GET")
    HttpverbHead -> json.string("HEAD")
    HttpverbPost -> json.string("POST")
    HttpverbPut -> json.string("PUT")
    HttpverbDelete -> json.string("DELETE")
    HttpverbPatch -> json.string("PATCH")
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

pub type Subscriptiontopiccrbehavior {
  SubscriptiontopiccrbehaviorTestpasses
  SubscriptiontopiccrbehaviorTestfails
}

pub fn subscriptiontopiccrbehavior_to_json(
  subscriptiontopiccrbehavior: Subscriptiontopiccrbehavior,
) -> Json {
  case subscriptiontopiccrbehavior {
    SubscriptiontopiccrbehaviorTestpasses -> json.string("test-passes")
    SubscriptiontopiccrbehaviorTestfails -> json.string("test-fails")
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

pub type Messagesignificancecategory {
  MessagesignificancecategoryConsequence
  MessagesignificancecategoryCurrency
  MessagesignificancecategoryNotification
}

pub fn messagesignificancecategory_to_json(
  messagesignificancecategory: Messagesignificancecategory,
) -> Json {
  case messagesignificancecategory {
    MessagesignificancecategoryConsequence -> json.string("consequence")
    MessagesignificancecategoryCurrency -> json.string("currency")
    MessagesignificancecategoryNotification -> json.string("notification")
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

pub type Capabilitystatementkind {
  CapabilitystatementkindInstance
  CapabilitystatementkindCapability
  CapabilitystatementkindRequirements
}

pub fn capabilitystatementkind_to_json(
  capabilitystatementkind: Capabilitystatementkind,
) -> Json {
  case capabilitystatementkind {
    CapabilitystatementkindInstance -> json.string("instance")
    CapabilitystatementkindCapability -> json.string("capability")
    CapabilitystatementkindRequirements -> json.string("requirements")
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

pub type Interactiontrigger {
  InteractiontriggerCreate
  InteractiontriggerUpdate
  InteractiontriggerDelete
}

pub fn interactiontrigger_to_json(
  interactiontrigger: Interactiontrigger,
) -> Json {
  case interactiontrigger {
    InteractiontriggerCreate -> json.string("create")
    InteractiontriggerUpdate -> json.string("update")
    InteractiontriggerDelete -> json.string("delete")
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

pub type Documentmode {
  DocumentmodeProducer
  DocumentmodeConsumer
}

pub fn documentmode_to_json(documentmode: Documentmode) -> Json {
  case documentmode {
    DocumentmodeProducer -> json.string("producer")
    DocumentmodeConsumer -> json.string("consumer")
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
  case versionindependentallresourcetypes {
    VersionindependentallresourcetypesAccount -> json.string("Account")
    VersionindependentallresourcetypesActivitydefinition ->
      json.string("ActivityDefinition")
    VersionindependentallresourcetypesActordefinition ->
      json.string("ActorDefinition")
    VersionindependentallresourcetypesAdministrableproductdefinition ->
      json.string("AdministrableProductDefinition")
    VersionindependentallresourcetypesAdverseevent ->
      json.string("AdverseEvent")
    VersionindependentallresourcetypesAllergyintolerance ->
      json.string("AllergyIntolerance")
    VersionindependentallresourcetypesAppointment -> json.string("Appointment")
    VersionindependentallresourcetypesAppointmentresponse ->
      json.string("AppointmentResponse")
    VersionindependentallresourcetypesArtifactassessment ->
      json.string("ArtifactAssessment")
    VersionindependentallresourcetypesAuditevent -> json.string("AuditEvent")
    VersionindependentallresourcetypesBasic -> json.string("Basic")
    VersionindependentallresourcetypesBinary -> json.string("Binary")
    VersionindependentallresourcetypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    VersionindependentallresourcetypesBiologicallyderivedproductdispense ->
      json.string("BiologicallyDerivedProductDispense")
    VersionindependentallresourcetypesBodystructure ->
      json.string("BodyStructure")
    VersionindependentallresourcetypesBundle -> json.string("Bundle")
    VersionindependentallresourcetypesCanonicalresource ->
      json.string("CanonicalResource")
    VersionindependentallresourcetypesCapabilitystatement ->
      json.string("CapabilityStatement")
    VersionindependentallresourcetypesCareplan -> json.string("CarePlan")
    VersionindependentallresourcetypesCareteam -> json.string("CareTeam")
    VersionindependentallresourcetypesChargeitem -> json.string("ChargeItem")
    VersionindependentallresourcetypesChargeitemdefinition ->
      json.string("ChargeItemDefinition")
    VersionindependentallresourcetypesCitation -> json.string("Citation")
    VersionindependentallresourcetypesClaim -> json.string("Claim")
    VersionindependentallresourcetypesClaimresponse ->
      json.string("ClaimResponse")
    VersionindependentallresourcetypesClinicalimpression ->
      json.string("ClinicalImpression")
    VersionindependentallresourcetypesClinicalusedefinition ->
      json.string("ClinicalUseDefinition")
    VersionindependentallresourcetypesCodesystem -> json.string("CodeSystem")
    VersionindependentallresourcetypesCommunication ->
      json.string("Communication")
    VersionindependentallresourcetypesCommunicationrequest ->
      json.string("CommunicationRequest")
    VersionindependentallresourcetypesCompartmentdefinition ->
      json.string("CompartmentDefinition")
    VersionindependentallresourcetypesComposition -> json.string("Composition")
    VersionindependentallresourcetypesConceptmap -> json.string("ConceptMap")
    VersionindependentallresourcetypesCondition -> json.string("Condition")
    VersionindependentallresourcetypesConditiondefinition ->
      json.string("ConditionDefinition")
    VersionindependentallresourcetypesConsent -> json.string("Consent")
    VersionindependentallresourcetypesContract -> json.string("Contract")
    VersionindependentallresourcetypesCoverage -> json.string("Coverage")
    VersionindependentallresourcetypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    VersionindependentallresourcetypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    VersionindependentallresourcetypesDetectedissue ->
      json.string("DetectedIssue")
    VersionindependentallresourcetypesDevice -> json.string("Device")
    VersionindependentallresourcetypesDeviceassociation ->
      json.string("DeviceAssociation")
    VersionindependentallresourcetypesDevicedefinition ->
      json.string("DeviceDefinition")
    VersionindependentallresourcetypesDevicedispense ->
      json.string("DeviceDispense")
    VersionindependentallresourcetypesDevicemetric ->
      json.string("DeviceMetric")
    VersionindependentallresourcetypesDevicerequest ->
      json.string("DeviceRequest")
    VersionindependentallresourcetypesDeviceusage -> json.string("DeviceUsage")
    VersionindependentallresourcetypesDiagnosticreport ->
      json.string("DiagnosticReport")
    VersionindependentallresourcetypesDocumentreference ->
      json.string("DocumentReference")
    VersionindependentallresourcetypesDomainresource ->
      json.string("DomainResource")
    VersionindependentallresourcetypesEncounter -> json.string("Encounter")
    VersionindependentallresourcetypesEncounterhistory ->
      json.string("EncounterHistory")
    VersionindependentallresourcetypesEndpoint -> json.string("Endpoint")
    VersionindependentallresourcetypesEnrollmentrequest ->
      json.string("EnrollmentRequest")
    VersionindependentallresourcetypesEnrollmentresponse ->
      json.string("EnrollmentResponse")
    VersionindependentallresourcetypesEpisodeofcare ->
      json.string("EpisodeOfCare")
    VersionindependentallresourcetypesEventdefinition ->
      json.string("EventDefinition")
    VersionindependentallresourcetypesEvidence -> json.string("Evidence")
    VersionindependentallresourcetypesEvidencereport ->
      json.string("EvidenceReport")
    VersionindependentallresourcetypesEvidencevariable ->
      json.string("EvidenceVariable")
    VersionindependentallresourcetypesExamplescenario ->
      json.string("ExampleScenario")
    VersionindependentallresourcetypesExplanationofbenefit ->
      json.string("ExplanationOfBenefit")
    VersionindependentallresourcetypesFamilymemberhistory ->
      json.string("FamilyMemberHistory")
    VersionindependentallresourcetypesFlag -> json.string("Flag")
    VersionindependentallresourcetypesFormularyitem ->
      json.string("FormularyItem")
    VersionindependentallresourcetypesGenomicstudy ->
      json.string("GenomicStudy")
    VersionindependentallresourcetypesGoal -> json.string("Goal")
    VersionindependentallresourcetypesGraphdefinition ->
      json.string("GraphDefinition")
    VersionindependentallresourcetypesGroup -> json.string("Group")
    VersionindependentallresourcetypesGuidanceresponse ->
      json.string("GuidanceResponse")
    VersionindependentallresourcetypesHealthcareservice ->
      json.string("HealthcareService")
    VersionindependentallresourcetypesImagingselection ->
      json.string("ImagingSelection")
    VersionindependentallresourcetypesImagingstudy ->
      json.string("ImagingStudy")
    VersionindependentallresourcetypesImmunization ->
      json.string("Immunization")
    VersionindependentallresourcetypesImmunizationevaluation ->
      json.string("ImmunizationEvaluation")
    VersionindependentallresourcetypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    VersionindependentallresourcetypesImplementationguide ->
      json.string("ImplementationGuide")
    VersionindependentallresourcetypesIngredient -> json.string("Ingredient")
    VersionindependentallresourcetypesInsuranceplan ->
      json.string("InsurancePlan")
    VersionindependentallresourcetypesInventoryitem ->
      json.string("InventoryItem")
    VersionindependentallresourcetypesInventoryreport ->
      json.string("InventoryReport")
    VersionindependentallresourcetypesInvoice -> json.string("Invoice")
    VersionindependentallresourcetypesLibrary -> json.string("Library")
    VersionindependentallresourcetypesLinkage -> json.string("Linkage")
    VersionindependentallresourcetypesList -> json.string("List")
    VersionindependentallresourcetypesLocation -> json.string("Location")
    VersionindependentallresourcetypesManufactureditemdefinition ->
      json.string("ManufacturedItemDefinition")
    VersionindependentallresourcetypesMeasure -> json.string("Measure")
    VersionindependentallresourcetypesMeasurereport ->
      json.string("MeasureReport")
    VersionindependentallresourcetypesMedication -> json.string("Medication")
    VersionindependentallresourcetypesMedicationadministration ->
      json.string("MedicationAdministration")
    VersionindependentallresourcetypesMedicationdispense ->
      json.string("MedicationDispense")
    VersionindependentallresourcetypesMedicationknowledge ->
      json.string("MedicationKnowledge")
    VersionindependentallresourcetypesMedicationrequest ->
      json.string("MedicationRequest")
    VersionindependentallresourcetypesMedicationstatement ->
      json.string("MedicationStatement")
    VersionindependentallresourcetypesMedicinalproductdefinition ->
      json.string("MedicinalProductDefinition")
    VersionindependentallresourcetypesMessagedefinition ->
      json.string("MessageDefinition")
    VersionindependentallresourcetypesMessageheader ->
      json.string("MessageHeader")
    VersionindependentallresourcetypesMetadataresource ->
      json.string("MetadataResource")
    VersionindependentallresourcetypesMolecularsequence ->
      json.string("MolecularSequence")
    VersionindependentallresourcetypesNamingsystem ->
      json.string("NamingSystem")
    VersionindependentallresourcetypesNutritionintake ->
      json.string("NutritionIntake")
    VersionindependentallresourcetypesNutritionorder ->
      json.string("NutritionOrder")
    VersionindependentallresourcetypesNutritionproduct ->
      json.string("NutritionProduct")
    VersionindependentallresourcetypesObservation -> json.string("Observation")
    VersionindependentallresourcetypesObservationdefinition ->
      json.string("ObservationDefinition")
    VersionindependentallresourcetypesOperationdefinition ->
      json.string("OperationDefinition")
    VersionindependentallresourcetypesOperationoutcome ->
      json.string("OperationOutcome")
    VersionindependentallresourcetypesOrganization ->
      json.string("Organization")
    VersionindependentallresourcetypesOrganizationaffiliation ->
      json.string("OrganizationAffiliation")
    VersionindependentallresourcetypesPackagedproductdefinition ->
      json.string("PackagedProductDefinition")
    VersionindependentallresourcetypesParameters -> json.string("Parameters")
    VersionindependentallresourcetypesPatient -> json.string("Patient")
    VersionindependentallresourcetypesPaymentnotice ->
      json.string("PaymentNotice")
    VersionindependentallresourcetypesPaymentreconciliation ->
      json.string("PaymentReconciliation")
    VersionindependentallresourcetypesPermission -> json.string("Permission")
    VersionindependentallresourcetypesPerson -> json.string("Person")
    VersionindependentallresourcetypesPlandefinition ->
      json.string("PlanDefinition")
    VersionindependentallresourcetypesPractitioner ->
      json.string("Practitioner")
    VersionindependentallresourcetypesPractitionerrole ->
      json.string("PractitionerRole")
    VersionindependentallresourcetypesProcedure -> json.string("Procedure")
    VersionindependentallresourcetypesProvenance -> json.string("Provenance")
    VersionindependentallresourcetypesQuestionnaire ->
      json.string("Questionnaire")
    VersionindependentallresourcetypesQuestionnaireresponse ->
      json.string("QuestionnaireResponse")
    VersionindependentallresourcetypesRegulatedauthorization ->
      json.string("RegulatedAuthorization")
    VersionindependentallresourcetypesRelatedperson ->
      json.string("RelatedPerson")
    VersionindependentallresourcetypesRequestorchestration ->
      json.string("RequestOrchestration")
    VersionindependentallresourcetypesRequirements ->
      json.string("Requirements")
    VersionindependentallresourcetypesResearchstudy ->
      json.string("ResearchStudy")
    VersionindependentallresourcetypesResearchsubject ->
      json.string("ResearchSubject")
    VersionindependentallresourcetypesResource -> json.string("Resource")
    VersionindependentallresourcetypesRiskassessment ->
      json.string("RiskAssessment")
    VersionindependentallresourcetypesSchedule -> json.string("Schedule")
    VersionindependentallresourcetypesSearchparameter ->
      json.string("SearchParameter")
    VersionindependentallresourcetypesServicerequest ->
      json.string("ServiceRequest")
    VersionindependentallresourcetypesSlot -> json.string("Slot")
    VersionindependentallresourcetypesSpecimen -> json.string("Specimen")
    VersionindependentallresourcetypesSpecimendefinition ->
      json.string("SpecimenDefinition")
    VersionindependentallresourcetypesStructuredefinition ->
      json.string("StructureDefinition")
    VersionindependentallresourcetypesStructuremap ->
      json.string("StructureMap")
    VersionindependentallresourcetypesSubscription ->
      json.string("Subscription")
    VersionindependentallresourcetypesSubscriptionstatus ->
      json.string("SubscriptionStatus")
    VersionindependentallresourcetypesSubscriptiontopic ->
      json.string("SubscriptionTopic")
    VersionindependentallresourcetypesSubstance -> json.string("Substance")
    VersionindependentallresourcetypesSubstancedefinition ->
      json.string("SubstanceDefinition")
    VersionindependentallresourcetypesSubstancenucleicacid ->
      json.string("SubstanceNucleicAcid")
    VersionindependentallresourcetypesSubstancepolymer ->
      json.string("SubstancePolymer")
    VersionindependentallresourcetypesSubstanceprotein ->
      json.string("SubstanceProtein")
    VersionindependentallresourcetypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    VersionindependentallresourcetypesSubstancesourcematerial ->
      json.string("SubstanceSourceMaterial")
    VersionindependentallresourcetypesSupplydelivery ->
      json.string("SupplyDelivery")
    VersionindependentallresourcetypesSupplyrequest ->
      json.string("SupplyRequest")
    VersionindependentallresourcetypesTask -> json.string("Task")
    VersionindependentallresourcetypesTerminologycapabilities ->
      json.string("TerminologyCapabilities")
    VersionindependentallresourcetypesTestplan -> json.string("TestPlan")
    VersionindependentallresourcetypesTestreport -> json.string("TestReport")
    VersionindependentallresourcetypesTestscript -> json.string("TestScript")
    VersionindependentallresourcetypesTransport -> json.string("Transport")
    VersionindependentallresourcetypesValueset -> json.string("ValueSet")
    VersionindependentallresourcetypesVerificationresult ->
      json.string("VerificationResult")
    VersionindependentallresourcetypesVisionprescription ->
      json.string("VisionPrescription")
    VersionindependentallresourcetypesBodysite -> json.string("BodySite")
    VersionindependentallresourcetypesCatalogentry ->
      json.string("CatalogEntry")
    VersionindependentallresourcetypesConformance -> json.string("Conformance")
    VersionindependentallresourcetypesDataelement -> json.string("DataElement")
    VersionindependentallresourcetypesDevicecomponent ->
      json.string("DeviceComponent")
    VersionindependentallresourcetypesDeviceuserequest ->
      json.string("DeviceUseRequest")
    VersionindependentallresourcetypesDeviceusestatement ->
      json.string("DeviceUseStatement")
    VersionindependentallresourcetypesDiagnosticorder ->
      json.string("DiagnosticOrder")
    VersionindependentallresourcetypesDocumentmanifest ->
      json.string("DocumentManifest")
    VersionindependentallresourcetypesEffectevidencesynthesis ->
      json.string("EffectEvidenceSynthesis")
    VersionindependentallresourcetypesEligibilityrequest ->
      json.string("EligibilityRequest")
    VersionindependentallresourcetypesEligibilityresponse ->
      json.string("EligibilityResponse")
    VersionindependentallresourcetypesExpansionprofile ->
      json.string("ExpansionProfile")
    VersionindependentallresourcetypesImagingmanifest ->
      json.string("ImagingManifest")
    VersionindependentallresourcetypesImagingobjectselection ->
      json.string("ImagingObjectSelection")
    VersionindependentallresourcetypesMedia -> json.string("Media")
    VersionindependentallresourcetypesMedicationorder ->
      json.string("MedicationOrder")
    VersionindependentallresourcetypesMedicationusage ->
      json.string("MedicationUsage")
    VersionindependentallresourcetypesMedicinalproduct ->
      json.string("MedicinalProduct")
    VersionindependentallresourcetypesMedicinalproductauthorization ->
      json.string("MedicinalProductAuthorization")
    VersionindependentallresourcetypesMedicinalproductcontraindication ->
      json.string("MedicinalProductContraindication")
    VersionindependentallresourcetypesMedicinalproductindication ->
      json.string("MedicinalProductIndication")
    VersionindependentallresourcetypesMedicinalproductingredient ->
      json.string("MedicinalProductIngredient")
    VersionindependentallresourcetypesMedicinalproductinteraction ->
      json.string("MedicinalProductInteraction")
    VersionindependentallresourcetypesMedicinalproductmanufactured ->
      json.string("MedicinalProductManufactured")
    VersionindependentallresourcetypesMedicinalproductpackaged ->
      json.string("MedicinalProductPackaged")
    VersionindependentallresourcetypesMedicinalproductpharmaceutical ->
      json.string("MedicinalProductPharmaceutical")
    VersionindependentallresourcetypesMedicinalproductundesirableeffect ->
      json.string("MedicinalProductUndesirableEffect")
    VersionindependentallresourcetypesOrder -> json.string("Order")
    VersionindependentallresourcetypesOrderresponse ->
      json.string("OrderResponse")
    VersionindependentallresourcetypesProcedurerequest ->
      json.string("ProcedureRequest")
    VersionindependentallresourcetypesProcessrequest ->
      json.string("ProcessRequest")
    VersionindependentallresourcetypesProcessresponse ->
      json.string("ProcessResponse")
    VersionindependentallresourcetypesReferralrequest ->
      json.string("ReferralRequest")
    VersionindependentallresourcetypesRequestgroup ->
      json.string("RequestGroup")
    VersionindependentallresourcetypesResearchdefinition ->
      json.string("ResearchDefinition")
    VersionindependentallresourcetypesResearchelementdefinition ->
      json.string("ResearchElementDefinition")
    VersionindependentallresourcetypesRiskevidencesynthesis ->
      json.string("RiskEvidenceSynthesis")
    VersionindependentallresourcetypesSequence -> json.string("Sequence")
    VersionindependentallresourcetypesServicedefinition ->
      json.string("ServiceDefinition")
    VersionindependentallresourcetypesSubstancespecification ->
      json.string("SubstanceSpecification")
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

pub type Maptargetlistmode {
  MaptargetlistmodeFirst
  MaptargetlistmodeShare
  MaptargetlistmodeLast
  MaptargetlistmodeSingle
}

pub fn maptargetlistmode_to_json(maptargetlistmode: Maptargetlistmode) -> Json {
  case maptargetlistmode {
    MaptargetlistmodeFirst -> json.string("first")
    MaptargetlistmodeShare -> json.string("share")
    MaptargetlistmodeLast -> json.string("last")
    MaptargetlistmodeSingle -> json.string("single")
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
  case relatedartifacttypeall {
    RelatedartifacttypeallDocumentation -> json.string("documentation")
    RelatedartifacttypeallJustification -> json.string("justification")
    RelatedartifacttypeallCitation -> json.string("citation")
    RelatedartifacttypeallPredecessor -> json.string("predecessor")
    RelatedartifacttypeallSuccessor -> json.string("successor")
    RelatedartifacttypeallDerivedfrom -> json.string("derived-from")
    RelatedartifacttypeallDependson -> json.string("depends-on")
    RelatedartifacttypeallComposedof -> json.string("composed-of")
    RelatedartifacttypeallPartof -> json.string("part-of")
    RelatedartifacttypeallAmends -> json.string("amends")
    RelatedartifacttypeallAmendedwith -> json.string("amended-with")
    RelatedartifacttypeallAppends -> json.string("appends")
    RelatedartifacttypeallAppendedwith -> json.string("appended-with")
    RelatedartifacttypeallCites -> json.string("cites")
    RelatedartifacttypeallCitedby -> json.string("cited-by")
    RelatedartifacttypeallCommentson -> json.string("comments-on")
    RelatedartifacttypeallCommentin -> json.string("comment-in")
    RelatedartifacttypeallContains -> json.string("contains")
    RelatedartifacttypeallContainedin -> json.string("contained-in")
    RelatedartifacttypeallCorrects -> json.string("corrects")
    RelatedartifacttypeallCorrectionin -> json.string("correction-in")
    RelatedartifacttypeallReplaces -> json.string("replaces")
    RelatedartifacttypeallReplacedwith -> json.string("replaced-with")
    RelatedartifacttypeallRetracts -> json.string("retracts")
    RelatedartifacttypeallRetractedby -> json.string("retracted-by")
    RelatedartifacttypeallSigns -> json.string("signs")
    RelatedartifacttypeallSimilarto -> json.string("similar-to")
    RelatedartifacttypeallSupports -> json.string("supports")
    RelatedartifacttypeallSupportedwith -> json.string("supported-with")
    RelatedartifacttypeallTransforms -> json.string("transforms")
    RelatedartifacttypeallTransformedinto -> json.string("transformed-into")
    RelatedartifacttypeallTransformedwith -> json.string("transformed-with")
    RelatedartifacttypeallDocuments -> json.string("documents")
    RelatedartifacttypeallSpecificationof -> json.string("specification-of")
    RelatedartifacttypeallCreatedwith -> json.string("created-with")
    RelatedartifacttypeallCiteas -> json.string("cite-as")
    RelatedartifacttypeallReprint -> json.string("reprint")
    RelatedartifacttypeallReprintof -> json.string("reprint-of")
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
  case filteroperator {
    FilteroperatorEqual -> json.string("=")
    FilteroperatorIsa -> json.string("is-a")
    FilteroperatorDescendentof -> json.string("descendent-of")
    FilteroperatorIsnota -> json.string("is-not-a")
    FilteroperatorRegex -> json.string("regex")
    FilteroperatorIn -> json.string("in")
    FilteroperatorNotin -> json.string("not-in")
    FilteroperatorGeneralizes -> json.string("generalizes")
    FilteroperatorChildof -> json.string("child-of")
    FilteroperatorDescendentleaf -> json.string("descendent-leaf")
    FilteroperatorExists -> json.string("exists")
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
  case fhirversion {
    Fhirversion001 -> json.string("0.01")
    Fhirversion005 -> json.string("0.05")
    Fhirversion006 -> json.string("0.06")
    Fhirversion011 -> json.string("0.11")
    Fhirversion00 -> json.string("0.0")
    Fhirversion0080 -> json.string("0.0.80")
    Fhirversion0081 -> json.string("0.0.81")
    Fhirversion0082 -> json.string("0.0.82")
    Fhirversion04 -> json.string("0.4")
    Fhirversion040 -> json.string("0.4.0")
    Fhirversion05 -> json.string("0.5")
    Fhirversion050 -> json.string("0.5.0")
    Fhirversion10 -> json.string("1.0")
    Fhirversion100 -> json.string("1.0.0")
    Fhirversion101 -> json.string("1.0.1")
    Fhirversion102 -> json.string("1.0.2")
    Fhirversion11 -> json.string("1.1")
    Fhirversion110 -> json.string("1.1.0")
    Fhirversion14 -> json.string("1.4")
    Fhirversion140 -> json.string("1.4.0")
    Fhirversion16 -> json.string("1.6")
    Fhirversion160 -> json.string("1.6.0")
    Fhirversion18 -> json.string("1.8")
    Fhirversion180 -> json.string("1.8.0")
    Fhirversion30 -> json.string("3.0")
    Fhirversion300 -> json.string("3.0.0")
    Fhirversion301 -> json.string("3.0.1")
    Fhirversion302 -> json.string("3.0.2")
    Fhirversion33 -> json.string("3.3")
    Fhirversion330 -> json.string("3.3.0")
    Fhirversion35 -> json.string("3.5")
    Fhirversion350 -> json.string("3.5.0")
    Fhirversion40 -> json.string("4.0")
    Fhirversion400 -> json.string("4.0.0")
    Fhirversion401 -> json.string("4.0.1")
    Fhirversion41 -> json.string("4.1")
    Fhirversion410 -> json.string("4.1.0")
    Fhirversion42 -> json.string("4.2")
    Fhirversion420 -> json.string("4.2.0")
    Fhirversion43 -> json.string("4.3")
    Fhirversion430 -> json.string("4.3.0")
    Fhirversion430cibuild -> json.string("4.3.0-cibuild")
    Fhirversion430snapshot1 -> json.string("4.3.0-snapshot1")
    Fhirversion44 -> json.string("4.4")
    Fhirversion440 -> json.string("4.4.0")
    Fhirversion45 -> json.string("4.5")
    Fhirversion450 -> json.string("4.5.0")
    Fhirversion46 -> json.string("4.6")
    Fhirversion460 -> json.string("4.6.0")
    Fhirversion50 -> json.string("5.0")
    Fhirversion500 -> json.string("5.0.0")
    Fhirversion500cibuild -> json.string("5.0.0-cibuild")
    Fhirversion500snapshot1 -> json.string("5.0.0-snapshot1")
    Fhirversion500snapshot2 -> json.string("5.0.0-snapshot2")
    Fhirversion500ballot -> json.string("5.0.0-ballot")
    Fhirversion500snapshot3 -> json.string("5.0.0-snapshot3")
    Fhirversion500draftfinal -> json.string("5.0.0-draft-final")
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

pub type Medicationknowledgestatus {
  MedicationknowledgestatusActive
  MedicationknowledgestatusEnteredinerror
  MedicationknowledgestatusInactive
}

pub fn medicationknowledgestatus_to_json(
  medicationknowledgestatus: Medicationknowledgestatus,
) -> Json {
  case medicationknowledgestatus {
    MedicationknowledgestatusActive -> json.string("active")
    MedicationknowledgestatusEnteredinerror -> json.string("entered-in-error")
    MedicationknowledgestatusInactive -> json.string("inactive")
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

pub type Inventoryreportstatus {
  InventoryreportstatusDraft
  InventoryreportstatusRequested
  InventoryreportstatusActive
  InventoryreportstatusEnteredinerror
}

pub fn inventoryreportstatus_to_json(
  inventoryreportstatus: Inventoryreportstatus,
) -> Json {
  case inventoryreportstatus {
    InventoryreportstatusDraft -> json.string("draft")
    InventoryreportstatusRequested -> json.string("requested")
    InventoryreportstatusActive -> json.string("active")
    InventoryreportstatusEnteredinerror -> json.string("entered-in-error")
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
  case grouptype {
    GrouptypePerson -> json.string("person")
    GrouptypeAnimal -> json.string("animal")
    GrouptypePractitioner -> json.string("practitioner")
    GrouptypeDevice -> json.string("device")
    GrouptypeCareteam -> json.string("careteam")
    GrouptypeHealthcareservice -> json.string("healthcareservice")
    GrouptypeLocation -> json.string("location")
    GrouptypeOrganization -> json.string("organization")
    GrouptypeRelatedperson -> json.string("relatedperson")
    GrouptypeSpecimen -> json.string("specimen")
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

pub type Adverseeventactuality {
  AdverseeventactualityActual
  AdverseeventactualityPotential
}

pub fn adverseeventactuality_to_json(
  adverseeventactuality: Adverseeventactuality,
) -> Json {
  case adverseeventactuality {
    AdverseeventactualityActual -> json.string("actual")
    AdverseeventactualityPotential -> json.string("potential")
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

pub type Mapmodelmode {
  MapmodelmodeSource
  MapmodelmodeQueried
  MapmodelmodeTarget
  MapmodelmodeProduced
}

pub fn mapmodelmode_to_json(mapmodelmode: Mapmodelmode) -> Json {
  case mapmodelmode {
    MapmodelmodeSource -> json.string("source")
    MapmodelmodeQueried -> json.string("queried")
    MapmodelmodeTarget -> json.string("target")
    MapmodelmodeProduced -> json.string("produced")
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

pub type Linktype {
  LinktypeReplacedby
  LinktypeReplaces
  LinktypeRefer
  LinktypeSeealso
}

pub fn linktype_to_json(linktype: Linktype) -> Json {
  case linktype {
    LinktypeReplacedby -> json.string("replaced-by")
    LinktypeReplaces -> json.string("replaces")
    LinktypeRefer -> json.string("refer")
    LinktypeSeealso -> json.string("seealso")
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
  case taskstatus {
    TaskstatusDraft -> json.string("draft")
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
  case languages {
    LanguagesAr -> json.string("ar")
    LanguagesBg -> json.string("bg")
    LanguagesBgbg -> json.string("bg-BG")
    LanguagesBn -> json.string("bn")
    LanguagesCs -> json.string("cs")
    LanguagesCscz -> json.string("cs-CZ")
    LanguagesBs -> json.string("bs")
    LanguagesBsba -> json.string("bs-BA")
    LanguagesDa -> json.string("da")
    LanguagesDadk -> json.string("da-DK")
    LanguagesDe -> json.string("de")
    LanguagesDeat -> json.string("de-AT")
    LanguagesDech -> json.string("de-CH")
    LanguagesDede -> json.string("de-DE")
    LanguagesEl -> json.string("el")
    LanguagesElgr -> json.string("el-GR")
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
    LanguagesEt -> json.string("et")
    LanguagesEtee -> json.string("et-EE")
    LanguagesFi -> json.string("fi")
    LanguagesFr -> json.string("fr")
    LanguagesFrbe -> json.string("fr-BE")
    LanguagesFrch -> json.string("fr-CH")
    LanguagesFrfr -> json.string("fr-FR")
    LanguagesFifi -> json.string("fi-FI")
    LanguagesFrca -> json.string("fr-CA")
    LanguagesFy -> json.string("fy")
    LanguagesFynl -> json.string("fy-NL")
    LanguagesHi -> json.string("hi")
    LanguagesHr -> json.string("hr")
    LanguagesHrhr -> json.string("hr-HR")
    LanguagesIs -> json.string("is")
    LanguagesIsis -> json.string("is-IS")
    LanguagesIt -> json.string("it")
    LanguagesItch -> json.string("it-CH")
    LanguagesItit -> json.string("it-IT")
    LanguagesJa -> json.string("ja")
    LanguagesKo -> json.string("ko")
    LanguagesLt -> json.string("lt")
    LanguagesLtlt -> json.string("lt-LT")
    LanguagesLv -> json.string("lv")
    LanguagesLvlv -> json.string("lv-LV")
    LanguagesNl -> json.string("nl")
    LanguagesNlbe -> json.string("nl-BE")
    LanguagesNlnl -> json.string("nl-NL")
    LanguagesNo -> json.string("no")
    LanguagesNono -> json.string("no-NO")
    LanguagesPa -> json.string("pa")
    LanguagesPl -> json.string("pl")
    LanguagesPlpl -> json.string("pl-PL")
    LanguagesPt -> json.string("pt")
    LanguagesPtpt -> json.string("pt-PT")
    LanguagesPtbr -> json.string("pt-BR")
    LanguagesRo -> json.string("ro")
    LanguagesRoro -> json.string("ro-RO")
    LanguagesRu -> json.string("ru")
    LanguagesRuru -> json.string("ru-RU")
    LanguagesSk -> json.string("sk")
    LanguagesSksk -> json.string("sk-SK")
    LanguagesSl -> json.string("sl")
    LanguagesSlsi -> json.string("sl-SI")
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
  case propertyrepresentation {
    PropertyrepresentationXmlattr -> json.string("xmlAttr")
    PropertyrepresentationXmltext -> json.string("xmlText")
    PropertyrepresentationTypeattr -> json.string("typeAttr")
    PropertyrepresentationCdatext -> json.string("cdaText")
    PropertyrepresentationXhtml -> json.string("xhtml")
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

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeUsesourcecode
  ConceptmapunmappedmodeFixed
  ConceptmapunmappedmodeOthermap
}

pub fn conceptmapunmappedmode_to_json(
  conceptmapunmappedmode: Conceptmapunmappedmode,
) -> Json {
  case conceptmapunmappedmode {
    ConceptmapunmappedmodeUsesourcecode -> json.string("use-source-code")
    ConceptmapunmappedmodeFixed -> json.string("fixed")
    ConceptmapunmappedmodeOthermap -> json.string("other-map")
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
  case verificationresultstatus {
    VerificationresultstatusAttested -> json.string("attested")
    VerificationresultstatusValidated -> json.string("validated")
    VerificationresultstatusInprocess -> json.string("in-process")
    VerificationresultstatusReqrevalid -> json.string("req-revalid")
    VerificationresultstatusValfail -> json.string("val-fail")
    VerificationresultstatusRevalfail -> json.string("reval-fail")
    VerificationresultstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Accountstatus {
  AccountstatusActive
  AccountstatusInactive
  AccountstatusEnteredinerror
  AccountstatusOnhold
  AccountstatusUnknown
}

pub fn accountstatus_to_json(accountstatus: Accountstatus) -> Json {
  case accountstatus {
    AccountstatusActive -> json.string("active")
    AccountstatusInactive -> json.string("inactive")
    AccountstatusEnteredinerror -> json.string("entered-in-error")
    AccountstatusOnhold -> json.string("on-hold")
    AccountstatusUnknown -> json.string("unknown")
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

pub type Careplanintent {
  CareplanintentProposal
  CareplanintentPlan
  CareplanintentOrder
  CareplanintentOption
  CareplanintentDirective
}

pub fn careplanintent_to_json(careplanintent: Careplanintent) -> Json {
  case careplanintent {
    CareplanintentProposal -> json.string("proposal")
    CareplanintentPlan -> json.string("plan")
    CareplanintentOrder -> json.string("order")
    CareplanintentOption -> json.string("option")
    CareplanintentDirective -> json.string("directive")
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
  case taskintent {
    TaskintentUnknown -> json.string("unknown")
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
  case searchmodifiercode {
    SearchmodifiercodeMissing -> json.string("missing")
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
    SearchmodifiercodeOftype -> json.string("of-type")
    SearchmodifiercodeCodetext -> json.string("code-text")
    SearchmodifiercodeTextadvanced -> json.string("text-advanced")
    SearchmodifiercodeIterate -> json.string("iterate")
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
  case artifactassessmentinformationtype {
    ArtifactassessmentinformationtypeComment -> json.string("comment")
    ArtifactassessmentinformationtypeClassifier -> json.string("classifier")
    ArtifactassessmentinformationtypeRating -> json.string("rating")
    ArtifactassessmentinformationtypeContainer -> json.string("container")
    ArtifactassessmentinformationtypeResponse -> json.string("response")
    ArtifactassessmentinformationtypeChangerequest ->
      json.string("change-request")
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

pub type Consentdatameaning {
  ConsentdatameaningInstance
  ConsentdatameaningRelated
  ConsentdatameaningDependents
  ConsentdatameaningAuthoredby
}

pub fn consentdatameaning_to_json(
  consentdatameaning: Consentdatameaning,
) -> Json {
  case consentdatameaning {
    ConsentdatameaningInstance -> json.string("instance")
    ConsentdatameaningRelated -> json.string("related")
    ConsentdatameaningDependents -> json.string("dependents")
    ConsentdatameaningAuthoredby -> json.string("authoredby")
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
  case conceptmapattributetype {
    ConceptmapattributetypeCode -> json.string("code")
    ConceptmapattributetypeCoding -> json.string("Coding")
    ConceptmapattributetypeString -> json.string("string")
    ConceptmapattributetypeBoolean -> json.string("boolean")
    ConceptmapattributetypeQuantity -> json.string("Quantity")
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

pub type Fmstatus {
  FmstatusActive
  FmstatusCancelled
  FmstatusDraft
  FmstatusEnteredinerror
}

pub fn fmstatus_to_json(fmstatus: Fmstatus) -> Json {
  case fmstatus {
    FmstatusActive -> json.string("active")
    FmstatusCancelled -> json.string("cancelled")
    FmstatusDraft -> json.string("draft")
    FmstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Medicationstatus {
  MedicationstatusActive
  MedicationstatusInactive
  MedicationstatusEnteredinerror
}

pub fn medicationstatus_to_json(medicationstatus: Medicationstatus) -> Json {
  case medicationstatus {
    MedicationstatusActive -> json.string("active")
    MedicationstatusInactive -> json.string("inactive")
    MedicationstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Sequencetype {
  SequencetypeAa
  SequencetypeDna
  SequencetypeRna
}

pub fn sequencetype_to_json(sequencetype: Sequencetype) -> Json {
  case sequencetype {
    SequencetypeAa -> json.string("aa")
    SequencetypeDna -> json.string("dna")
    SequencetypeRna -> json.string("rna")
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

pub type Graphcompartmentrule {
  GraphcompartmentruleIdentical
  GraphcompartmentruleMatching
  GraphcompartmentruleDifferent
  GraphcompartmentruleCustom
}

pub fn graphcompartmentrule_to_json(
  graphcompartmentrule: Graphcompartmentrule,
) -> Json {
  case graphcompartmentrule {
    GraphcompartmentruleIdentical -> json.string("identical")
    GraphcompartmentruleMatching -> json.string("matching")
    GraphcompartmentruleDifferent -> json.string("different")
    GraphcompartmentruleCustom -> json.string("custom")
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

pub type Operationkind {
  OperationkindOperation
  OperationkindQuery
}

pub fn operationkind_to_json(operationkind: Operationkind) -> Json {
  case operationkind {
    OperationkindOperation -> json.string("operation")
    OperationkindQuery -> json.string("query")
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

pub type Detectedissueseverity {
  DetectedissueseverityHigh
  DetectedissueseverityModerate
  DetectedissueseverityLow
}

pub fn detectedissueseverity_to_json(
  detectedissueseverity: Detectedissueseverity,
) -> Json {
  case detectedissueseverity {
    DetectedissueseverityHigh -> json.string("high")
    DetectedissueseverityModerate -> json.string("moderate")
    DetectedissueseverityLow -> json.string("low")
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

pub type Metriccalibrationstate {
  MetriccalibrationstateNotcalibrated
  MetriccalibrationstateCalibrationrequired
  MetriccalibrationstateCalibrated
  MetriccalibrationstateUnspecified
}

pub fn metriccalibrationstate_to_json(
  metriccalibrationstate: Metriccalibrationstate,
) -> Json {
  case metriccalibrationstate {
    MetriccalibrationstateNotcalibrated -> json.string("not-calibrated")
    MetriccalibrationstateCalibrationrequired ->
      json.string("calibration-required")
    MetriccalibrationstateCalibrated -> json.string("calibrated")
    MetriccalibrationstateUnspecified -> json.string("unspecified")
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
  case searchparamtype {
    SearchparamtypeNumber -> json.string("number")
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
  case genomicstudystatus {
    GenomicstudystatusRegistered -> json.string("registered")
    GenomicstudystatusAvailable -> json.string("available")
    GenomicstudystatusCancelled -> json.string("cancelled")
    GenomicstudystatusEnteredinerror -> json.string("entered-in-error")
    GenomicstudystatusUnknown -> json.string("unknown")
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

pub type Linkagetype {
  LinkagetypeSource
  LinkagetypeAlternate
  LinkagetypeHistorical
}

pub fn linkagetype_to_json(linkagetype: Linkagetype) -> Json {
  case linkagetype {
    LinkagetypeSource -> json.string("source")
    LinkagetypeAlternate -> json.string("alternate")
    LinkagetypeHistorical -> json.string("historical")
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

pub type Inventoryreportcounttype {
  InventoryreportcounttypeSnapshot
  InventoryreportcounttypeDifference
}

pub fn inventoryreportcounttype_to_json(
  inventoryreportcounttype: Inventoryreportcounttype,
) -> Json {
  case inventoryreportcounttype {
    InventoryreportcounttypeSnapshot -> json.string("snapshot")
    InventoryreportcounttypeDifference -> json.string("difference")
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

pub type Immunizationevaluationstatus {
  ImmunizationevaluationstatusCompleted
  ImmunizationevaluationstatusEnteredinerror
}

pub fn immunizationevaluationstatus_to_json(
  immunizationevaluationstatus: Immunizationevaluationstatus,
) -> Json {
  case immunizationevaluationstatus {
    ImmunizationevaluationstatusCompleted -> json.string("completed")
    ImmunizationevaluationstatusEnteredinerror ->
      json.string("entered-in-error")
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
  case imagingstudystatus {
    ImagingstudystatusRegistered -> json.string("registered")
    ImagingstudystatusAvailable -> json.string("available")
    ImagingstudystatusCancelled -> json.string("cancelled")
    ImagingstudystatusEnteredinerror -> json.string("entered-in-error")
    ImagingstudystatusUnknown -> json.string("unknown")
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

pub type Subscriptionpayloadcontent {
  SubscriptionpayloadcontentEmpty
  SubscriptionpayloadcontentIdonly
  SubscriptionpayloadcontentFullresource
}

pub fn subscriptionpayloadcontent_to_json(
  subscriptionpayloadcontent: Subscriptionpayloadcontent,
) -> Json {
  case subscriptionpayloadcontent {
    SubscriptionpayloadcontentEmpty -> json.string("empty")
    SubscriptionpayloadcontentIdonly -> json.string("id-only")
    SubscriptionpayloadcontentFullresource -> json.string("full-resource")
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
  case subscriptionstatus {
    SubscriptionstatusRequested -> json.string("requested")
    SubscriptionstatusActive -> json.string("active")
    SubscriptionstatusError -> json.string("error")
    SubscriptionstatusOff -> json.string("off")
    SubscriptionstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Auditeventaction {
  AuditeventactionC
  AuditeventactionR
  AuditeventactionU
  AuditeventactionD
  AuditeventactionE
}

pub fn auditeventaction_to_json(auditeventaction: Auditeventaction) -> Json {
  case auditeventaction {
    AuditeventactionC -> json.string("C")
    AuditeventactionR -> json.string("R")
    AuditeventactionU -> json.string("U")
    AuditeventactionD -> json.string("D")
    AuditeventactionE -> json.string("E")
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

pub type Reportparticipanttype {
  ReportparticipanttypeTestengine
  ReportparticipanttypeClient
  ReportparticipanttypeServer
}

pub fn reportparticipanttype_to_json(
  reportparticipanttype: Reportparticipanttype,
) -> Json {
  case reportparticipanttype {
    ReportparticipanttypeTestengine -> json.string("test-engine")
    ReportparticipanttypeClient -> json.string("client")
    ReportparticipanttypeServer -> json.string("server")
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

pub type Specimencontainedpreference {
  SpecimencontainedpreferencePreferred
  SpecimencontainedpreferenceAlternate
}

pub fn specimencontainedpreference_to_json(
  specimencontainedpreference: Specimencontainedpreference,
) -> Json {
  case specimencontainedpreference {
    SpecimencontainedpreferencePreferred -> json.string("preferred")
    SpecimencontainedpreferenceAlternate -> json.string("alternate")
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
  case artifactassessmentworkflowstatus {
    ArtifactassessmentworkflowstatusSubmitted -> json.string("submitted")
    ArtifactassessmentworkflowstatusTriaged -> json.string("triaged")
    ArtifactassessmentworkflowstatusWaitingforinput ->
      json.string("waiting-for-input")
    ArtifactassessmentworkflowstatusResolvednochange ->
      json.string("resolved-no-change")
    ArtifactassessmentworkflowstatusResolvedchangerequired ->
      json.string("resolved-change-required")
    ArtifactassessmentworkflowstatusDeferred -> json.string("deferred")
    ArtifactassessmentworkflowstatusDuplicate -> json.string("duplicate")
    ArtifactassessmentworkflowstatusApplied -> json.string("applied")
    ArtifactassessmentworkflowstatusPublished -> json.string("published")
    ArtifactassessmentworkflowstatusEnteredinerror ->
      json.string("entered-in-error")
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

pub type Devicenametype {
  DevicenametypeRegisteredname
  DevicenametypeUserfriendlyname
  DevicenametypePatientreportedname
}

pub fn devicenametype_to_json(devicenametype: Devicenametype) -> Json {
  case devicenametype {
    DevicenametypeRegisteredname -> json.string("registered-name")
    DevicenametypeUserfriendlyname -> json.string("user-friendly-name")
    DevicenametypePatientreportedname -> json.string("patient-reported-name")
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

pub type Mapsourcelistmode {
  MapsourcelistmodeFirst
  MapsourcelistmodeNotfirst
  MapsourcelistmodeLast
  MapsourcelistmodeNotlast
  MapsourcelistmodeOnlyone
}

pub fn mapsourcelistmode_to_json(mapsourcelistmode: Mapsourcelistmode) -> Json {
  case mapsourcelistmode {
    MapsourcelistmodeFirst -> json.string("first")
    MapsourcelistmodeNotfirst -> json.string("not_first")
    MapsourcelistmodeLast -> json.string("last")
    MapsourcelistmodeNotlast -> json.string("not_last")
    MapsourcelistmodeOnlyone -> json.string("only_one")
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
  case questionnaireanswersstatus {
    QuestionnaireanswersstatusInprogress -> json.string("in-progress")
    QuestionnaireanswersstatusCompleted -> json.string("completed")
    QuestionnaireanswersstatusAmended -> json.string("amended")
    QuestionnaireanswersstatusEnteredinerror -> json.string("entered-in-error")
    QuestionnaireanswersstatusStopped -> json.string("stopped")
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

pub type Flagstatus {
  FlagstatusActive
  FlagstatusInactive
  FlagstatusEnteredinerror
}

pub fn flagstatus_to_json(flagstatus: Flagstatus) -> Json {
  case flagstatus {
    FlagstatusActive -> json.string("active")
    FlagstatusInactive -> json.string("inactive")
    FlagstatusEnteredinerror -> json.string("entered-in-error")
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
  case requestresourcetypes {
    RequestresourcetypesAppointment -> json.string("Appointment")
    RequestresourcetypesAppointmentresponse ->
      json.string("AppointmentResponse")
    RequestresourcetypesCareplan -> json.string("CarePlan")
    RequestresourcetypesClaim -> json.string("Claim")
    RequestresourcetypesCommunicationrequest ->
      json.string("CommunicationRequest")
    RequestresourcetypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    RequestresourcetypesDevicerequest -> json.string("DeviceRequest")
    RequestresourcetypesEnrollmentrequest -> json.string("EnrollmentRequest")
    RequestresourcetypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    RequestresourcetypesMedicationrequest -> json.string("MedicationRequest")
    RequestresourcetypesNutritionorder -> json.string("NutritionOrder")
    RequestresourcetypesRequestorchestration ->
      json.string("RequestOrchestration")
    RequestresourcetypesServicerequest -> json.string("ServiceRequest")
    RequestresourcetypesSupplyrequest -> json.string("SupplyRequest")
    RequestresourcetypesTask -> json.string("Task")
    RequestresourcetypesTransport -> json.string("Transport")
    RequestresourcetypesVisionprescription -> json.string("VisionPrescription")
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

pub type Imagingselectionstatus {
  ImagingselectionstatusAvailable
  ImagingselectionstatusEnteredinerror
  ImagingselectionstatusUnknown
}

pub fn imagingselectionstatus_to_json(
  imagingselectionstatus: Imagingselectionstatus,
) -> Json {
  case imagingselectionstatus {
    ImagingselectionstatusAvailable -> json.string("available")
    ImagingselectionstatusEnteredinerror -> json.string("entered-in-error")
    ImagingselectionstatusUnknown -> json.string("unknown")
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

pub type Metricoperationalstatus {
  MetricoperationalstatusOn
  MetricoperationalstatusOff
  MetricoperationalstatusStandby
  MetricoperationalstatusEnteredinerror
}

pub fn metricoperationalstatus_to_json(
  metricoperationalstatus: Metricoperationalstatus,
) -> Json {
  case metricoperationalstatus {
    MetricoperationalstatusOn -> json.string("on")
    MetricoperationalstatusOff -> json.string("off")
    MetricoperationalstatusStandby -> json.string("standby")
    MetricoperationalstatusEnteredinerror -> json.string("entered-in-error")
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
  case requestintent {
    RequestintentProposal -> json.string("proposal")
    RequestintentPlan -> json.string("plan")
    RequestintentDirective -> json.string("directive")
    RequestintentOrder -> json.string("order")
    RequestintentOriginalorder -> json.string("original-order")
    RequestintentReflexorder -> json.string("reflex-order")
    RequestintentFillerorder -> json.string("filler-order")
    RequestintentInstanceorder -> json.string("instance-order")
    RequestintentOption -> json.string("option")
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
  case pricecomponenttype {
    PricecomponenttypeBase -> json.string("base")
    PricecomponenttypeSurcharge -> json.string("surcharge")
    PricecomponenttypeDeduction -> json.string("deduction")
    PricecomponenttypeDiscount -> json.string("discount")
    PricecomponenttypeTax -> json.string("tax")
    PricecomponenttypeInformational -> json.string("informational")
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

pub type Assertdirectioncodes {
  AssertdirectioncodesResponse
  AssertdirectioncodesRequest
}

pub fn assertdirectioncodes_to_json(
  assertdirectioncodes: Assertdirectioncodes,
) -> Json {
  case assertdirectioncodes {
    AssertdirectioncodesResponse -> json.string("response")
    AssertdirectioncodesRequest -> json.string("request")
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

pub type Actionrequiredbehavior {
  ActionrequiredbehaviorMust
  ActionrequiredbehaviorCould
  ActionrequiredbehaviorMustunlessdocumented
}

pub fn actionrequiredbehavior_to_json(
  actionrequiredbehavior: Actionrequiredbehavior,
) -> Json {
  case actionrequiredbehavior {
    ActionrequiredbehaviorMust -> json.string("must")
    ActionrequiredbehaviorCould -> json.string("could")
    ActionrequiredbehaviorMustunlessdocumented ->
      json.string("must-unless-documented")
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

pub type Questionnaireanswerconstraint {
  QuestionnaireanswerconstraintOptionsonly
  QuestionnaireanswerconstraintOptionsortype
  QuestionnaireanswerconstraintOptionsorstring
}

pub fn questionnaireanswerconstraint_to_json(
  questionnaireanswerconstraint: Questionnaireanswerconstraint,
) -> Json {
  case questionnaireanswerconstraint {
    QuestionnaireanswerconstraintOptionsonly -> json.string("optionsOnly")
    QuestionnaireanswerconstraintOptionsortype -> json.string("optionsOrType")
    QuestionnaireanswerconstraintOptionsorstring ->
      json.string("optionsOrString")
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

pub type Identifieruse {
  IdentifieruseUsual
  IdentifieruseOfficial
  IdentifieruseTemp
  IdentifieruseSecondary
  IdentifieruseOld
}

pub fn identifieruse_to_json(identifieruse: Identifieruse) -> Json {
  case identifieruse {
    IdentifieruseUsual -> json.string("usual")
    IdentifieruseOfficial -> json.string("official")
    IdentifieruseTemp -> json.string("temp")
    IdentifieruseSecondary -> json.string("secondary")
    IdentifieruseOld -> json.string("old")
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

pub type Coveragekind {
  CoveragekindInsurance
  CoveragekindSelfpay
  CoveragekindOther
}

pub fn coveragekind_to_json(coveragekind: Coveragekind) -> Json {
  case coveragekind {
    CoveragekindInsurance -> json.string("insurance")
    CoveragekindSelfpay -> json.string("self-pay")
    CoveragekindOther -> json.string("other")
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

pub type Strandtype {
  StrandtypeWatson
  StrandtypeCrick
}

pub fn strandtype_to_json(strandtype: Strandtype) -> Json {
  case strandtype {
    StrandtypeWatson -> json.string("watson")
    StrandtypeCrick -> json.string("crick")
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

pub type Measurereportstatus {
  MeasurereportstatusComplete
  MeasurereportstatusPending
  MeasurereportstatusError
}

pub fn measurereportstatus_to_json(
  measurereportstatus: Measurereportstatus,
) -> Json {
  case measurereportstatus {
    MeasurereportstatusComplete -> json.string("complete")
    MeasurereportstatusPending -> json.string("pending")
    MeasurereportstatusError -> json.string("error")
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

pub type Extensioncontexttype {
  ExtensioncontexttypeFhirpath
  ExtensioncontexttypeElement
  ExtensioncontexttypeExtension
}

pub fn extensioncontexttype_to_json(
  extensioncontexttype: Extensioncontexttype,
) -> Json {
  case extensioncontexttype {
    ExtensioncontexttypeFhirpath -> json.string("fhirpath")
    ExtensioncontexttypeElement -> json.string("element")
    ExtensioncontexttypeExtension -> json.string("extension")
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
  case fhirtypes {
    FhirtypesBase -> json.string("Base")
    FhirtypesElement -> json.string("Element")
    FhirtypesBackboneelement -> json.string("BackboneElement")
    FhirtypesDatatype -> json.string("DataType")
    FhirtypesAddress -> json.string("Address")
    FhirtypesAnnotation -> json.string("Annotation")
    FhirtypesAttachment -> json.string("Attachment")
    FhirtypesAvailability -> json.string("Availability")
    FhirtypesBackbonetype -> json.string("BackboneType")
    FhirtypesDosage -> json.string("Dosage")
    FhirtypesElementdefinition -> json.string("ElementDefinition")
    FhirtypesMarketingstatus -> json.string("MarketingStatus")
    FhirtypesProductshelflife -> json.string("ProductShelfLife")
    FhirtypesTiming -> json.string("Timing")
    FhirtypesCodeableconcept -> json.string("CodeableConcept")
    FhirtypesCodeablereference -> json.string("CodeableReference")
    FhirtypesCoding -> json.string("Coding")
    FhirtypesContactdetail -> json.string("ContactDetail")
    FhirtypesContactpoint -> json.string("ContactPoint")
    FhirtypesContributor -> json.string("Contributor")
    FhirtypesDatarequirement -> json.string("DataRequirement")
    FhirtypesExpression -> json.string("Expression")
    FhirtypesExtendedcontactdetail -> json.string("ExtendedContactDetail")
    FhirtypesExtension -> json.string("Extension")
    FhirtypesHumanname -> json.string("HumanName")
    FhirtypesIdentifier -> json.string("Identifier")
    FhirtypesMeta -> json.string("Meta")
    FhirtypesMonetarycomponent -> json.string("MonetaryComponent")
    FhirtypesMoney -> json.string("Money")
    FhirtypesNarrative -> json.string("Narrative")
    FhirtypesParameterdefinition -> json.string("ParameterDefinition")
    FhirtypesPeriod -> json.string("Period")
    FhirtypesPrimitivetype -> json.string("PrimitiveType")
    FhirtypesBase64binary -> json.string("base64Binary")
    FhirtypesBoolean -> json.string("boolean")
    FhirtypesDate -> json.string("date")
    FhirtypesDatetime -> json.string("dateTime")
    FhirtypesDecimal -> json.string("decimal")
    FhirtypesInstant -> json.string("instant")
    FhirtypesInteger -> json.string("integer")
    FhirtypesPositiveint -> json.string("positiveInt")
    FhirtypesUnsignedint -> json.string("unsignedInt")
    FhirtypesInteger64 -> json.string("integer64")
    FhirtypesString -> json.string("string")
    FhirtypesCode -> json.string("code")
    FhirtypesId -> json.string("id")
    FhirtypesMarkdown -> json.string("markdown")
    FhirtypesTime -> json.string("time")
    FhirtypesUri -> json.string("uri")
    FhirtypesCanonical -> json.string("canonical")
    FhirtypesOid -> json.string("oid")
    FhirtypesUrl -> json.string("url")
    FhirtypesUuid -> json.string("uuid")
    FhirtypesQuantity -> json.string("Quantity")
    FhirtypesAge -> json.string("Age")
    FhirtypesCount -> json.string("Count")
    FhirtypesDistance -> json.string("Distance")
    FhirtypesDuration -> json.string("Duration")
    FhirtypesRange -> json.string("Range")
    FhirtypesRatio -> json.string("Ratio")
    FhirtypesRatiorange -> json.string("RatioRange")
    FhirtypesReference -> json.string("Reference")
    FhirtypesRelatedartifact -> json.string("RelatedArtifact")
    FhirtypesSampleddata -> json.string("SampledData")
    FhirtypesSignature -> json.string("Signature")
    FhirtypesTriggerdefinition -> json.string("TriggerDefinition")
    FhirtypesUsagecontext -> json.string("UsageContext")
    FhirtypesVirtualservicedetail -> json.string("VirtualServiceDetail")
    FhirtypesXhtml -> json.string("xhtml")
    FhirtypesResource -> json.string("Resource")
    FhirtypesBinary -> json.string("Binary")
    FhirtypesBundle -> json.string("Bundle")
    FhirtypesDomainresource -> json.string("DomainResource")
    FhirtypesAccount -> json.string("Account")
    FhirtypesActivitydefinition -> json.string("ActivityDefinition")
    FhirtypesActordefinition -> json.string("ActorDefinition")
    FhirtypesAdministrableproductdefinition ->
      json.string("AdministrableProductDefinition")
    FhirtypesAdverseevent -> json.string("AdverseEvent")
    FhirtypesAllergyintolerance -> json.string("AllergyIntolerance")
    FhirtypesAppointment -> json.string("Appointment")
    FhirtypesAppointmentresponse -> json.string("AppointmentResponse")
    FhirtypesArtifactassessment -> json.string("ArtifactAssessment")
    FhirtypesAuditevent -> json.string("AuditEvent")
    FhirtypesBasic -> json.string("Basic")
    FhirtypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    FhirtypesBiologicallyderivedproductdispense ->
      json.string("BiologicallyDerivedProductDispense")
    FhirtypesBodystructure -> json.string("BodyStructure")
    FhirtypesCanonicalresource -> json.string("CanonicalResource")
    FhirtypesCapabilitystatement -> json.string("CapabilityStatement")
    FhirtypesCareplan -> json.string("CarePlan")
    FhirtypesCareteam -> json.string("CareTeam")
    FhirtypesChargeitem -> json.string("ChargeItem")
    FhirtypesChargeitemdefinition -> json.string("ChargeItemDefinition")
    FhirtypesCitation -> json.string("Citation")
    FhirtypesClaim -> json.string("Claim")
    FhirtypesClaimresponse -> json.string("ClaimResponse")
    FhirtypesClinicalimpression -> json.string("ClinicalImpression")
    FhirtypesClinicalusedefinition -> json.string("ClinicalUseDefinition")
    FhirtypesCodesystem -> json.string("CodeSystem")
    FhirtypesCommunication -> json.string("Communication")
    FhirtypesCommunicationrequest -> json.string("CommunicationRequest")
    FhirtypesCompartmentdefinition -> json.string("CompartmentDefinition")
    FhirtypesComposition -> json.string("Composition")
    FhirtypesConceptmap -> json.string("ConceptMap")
    FhirtypesCondition -> json.string("Condition")
    FhirtypesConditiondefinition -> json.string("ConditionDefinition")
    FhirtypesConsent -> json.string("Consent")
    FhirtypesContract -> json.string("Contract")
    FhirtypesCoverage -> json.string("Coverage")
    FhirtypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    FhirtypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    FhirtypesDetectedissue -> json.string("DetectedIssue")
    FhirtypesDevice -> json.string("Device")
    FhirtypesDeviceassociation -> json.string("DeviceAssociation")
    FhirtypesDevicedefinition -> json.string("DeviceDefinition")
    FhirtypesDevicedispense -> json.string("DeviceDispense")
    FhirtypesDevicemetric -> json.string("DeviceMetric")
    FhirtypesDevicerequest -> json.string("DeviceRequest")
    FhirtypesDeviceusage -> json.string("DeviceUsage")
    FhirtypesDiagnosticreport -> json.string("DiagnosticReport")
    FhirtypesDocumentreference -> json.string("DocumentReference")
    FhirtypesEncounter -> json.string("Encounter")
    FhirtypesEncounterhistory -> json.string("EncounterHistory")
    FhirtypesEndpoint -> json.string("Endpoint")
    FhirtypesEnrollmentrequest -> json.string("EnrollmentRequest")
    FhirtypesEnrollmentresponse -> json.string("EnrollmentResponse")
    FhirtypesEpisodeofcare -> json.string("EpisodeOfCare")
    FhirtypesEventdefinition -> json.string("EventDefinition")
    FhirtypesEvidence -> json.string("Evidence")
    FhirtypesEvidencereport -> json.string("EvidenceReport")
    FhirtypesEvidencevariable -> json.string("EvidenceVariable")
    FhirtypesExamplescenario -> json.string("ExampleScenario")
    FhirtypesExplanationofbenefit -> json.string("ExplanationOfBenefit")
    FhirtypesFamilymemberhistory -> json.string("FamilyMemberHistory")
    FhirtypesFlag -> json.string("Flag")
    FhirtypesFormularyitem -> json.string("FormularyItem")
    FhirtypesGenomicstudy -> json.string("GenomicStudy")
    FhirtypesGoal -> json.string("Goal")
    FhirtypesGraphdefinition -> json.string("GraphDefinition")
    FhirtypesGroup -> json.string("Group")
    FhirtypesGuidanceresponse -> json.string("GuidanceResponse")
    FhirtypesHealthcareservice -> json.string("HealthcareService")
    FhirtypesImagingselection -> json.string("ImagingSelection")
    FhirtypesImagingstudy -> json.string("ImagingStudy")
    FhirtypesImmunization -> json.string("Immunization")
    FhirtypesImmunizationevaluation -> json.string("ImmunizationEvaluation")
    FhirtypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    FhirtypesImplementationguide -> json.string("ImplementationGuide")
    FhirtypesIngredient -> json.string("Ingredient")
    FhirtypesInsuranceplan -> json.string("InsurancePlan")
    FhirtypesInventoryitem -> json.string("InventoryItem")
    FhirtypesInventoryreport -> json.string("InventoryReport")
    FhirtypesInvoice -> json.string("Invoice")
    FhirtypesLibrary -> json.string("Library")
    FhirtypesLinkage -> json.string("Linkage")
    FhirtypesList -> json.string("List")
    FhirtypesLocation -> json.string("Location")
    FhirtypesManufactureditemdefinition ->
      json.string("ManufacturedItemDefinition")
    FhirtypesMeasure -> json.string("Measure")
    FhirtypesMeasurereport -> json.string("MeasureReport")
    FhirtypesMedication -> json.string("Medication")
    FhirtypesMedicationadministration -> json.string("MedicationAdministration")
    FhirtypesMedicationdispense -> json.string("MedicationDispense")
    FhirtypesMedicationknowledge -> json.string("MedicationKnowledge")
    FhirtypesMedicationrequest -> json.string("MedicationRequest")
    FhirtypesMedicationstatement -> json.string("MedicationStatement")
    FhirtypesMedicinalproductdefinition ->
      json.string("MedicinalProductDefinition")
    FhirtypesMessagedefinition -> json.string("MessageDefinition")
    FhirtypesMessageheader -> json.string("MessageHeader")
    FhirtypesMetadataresource -> json.string("MetadataResource")
    FhirtypesMolecularsequence -> json.string("MolecularSequence")
    FhirtypesNamingsystem -> json.string("NamingSystem")
    FhirtypesNutritionintake -> json.string("NutritionIntake")
    FhirtypesNutritionorder -> json.string("NutritionOrder")
    FhirtypesNutritionproduct -> json.string("NutritionProduct")
    FhirtypesObservation -> json.string("Observation")
    FhirtypesObservationdefinition -> json.string("ObservationDefinition")
    FhirtypesOperationdefinition -> json.string("OperationDefinition")
    FhirtypesOperationoutcome -> json.string("OperationOutcome")
    FhirtypesOrganization -> json.string("Organization")
    FhirtypesOrganizationaffiliation -> json.string("OrganizationAffiliation")
    FhirtypesPackagedproductdefinition ->
      json.string("PackagedProductDefinition")
    FhirtypesPatient -> json.string("Patient")
    FhirtypesPaymentnotice -> json.string("PaymentNotice")
    FhirtypesPaymentreconciliation -> json.string("PaymentReconciliation")
    FhirtypesPermission -> json.string("Permission")
    FhirtypesPerson -> json.string("Person")
    FhirtypesPlandefinition -> json.string("PlanDefinition")
    FhirtypesPractitioner -> json.string("Practitioner")
    FhirtypesPractitionerrole -> json.string("PractitionerRole")
    FhirtypesProcedure -> json.string("Procedure")
    FhirtypesProvenance -> json.string("Provenance")
    FhirtypesQuestionnaire -> json.string("Questionnaire")
    FhirtypesQuestionnaireresponse -> json.string("QuestionnaireResponse")
    FhirtypesRegulatedauthorization -> json.string("RegulatedAuthorization")
    FhirtypesRelatedperson -> json.string("RelatedPerson")
    FhirtypesRequestorchestration -> json.string("RequestOrchestration")
    FhirtypesRequirements -> json.string("Requirements")
    FhirtypesResearchstudy -> json.string("ResearchStudy")
    FhirtypesResearchsubject -> json.string("ResearchSubject")
    FhirtypesRiskassessment -> json.string("RiskAssessment")
    FhirtypesSchedule -> json.string("Schedule")
    FhirtypesSearchparameter -> json.string("SearchParameter")
    FhirtypesServicerequest -> json.string("ServiceRequest")
    FhirtypesSlot -> json.string("Slot")
    FhirtypesSpecimen -> json.string("Specimen")
    FhirtypesSpecimendefinition -> json.string("SpecimenDefinition")
    FhirtypesStructuredefinition -> json.string("StructureDefinition")
    FhirtypesStructuremap -> json.string("StructureMap")
    FhirtypesSubscription -> json.string("Subscription")
    FhirtypesSubscriptionstatus -> json.string("SubscriptionStatus")
    FhirtypesSubscriptiontopic -> json.string("SubscriptionTopic")
    FhirtypesSubstance -> json.string("Substance")
    FhirtypesSubstancedefinition -> json.string("SubstanceDefinition")
    FhirtypesSubstancenucleicacid -> json.string("SubstanceNucleicAcid")
    FhirtypesSubstancepolymer -> json.string("SubstancePolymer")
    FhirtypesSubstanceprotein -> json.string("SubstanceProtein")
    FhirtypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    FhirtypesSubstancesourcematerial -> json.string("SubstanceSourceMaterial")
    FhirtypesSupplydelivery -> json.string("SupplyDelivery")
    FhirtypesSupplyrequest -> json.string("SupplyRequest")
    FhirtypesTask -> json.string("Task")
    FhirtypesTerminologycapabilities -> json.string("TerminologyCapabilities")
    FhirtypesTestplan -> json.string("TestPlan")
    FhirtypesTestreport -> json.string("TestReport")
    FhirtypesTestscript -> json.string("TestScript")
    FhirtypesTransport -> json.string("Transport")
    FhirtypesValueset -> json.string("ValueSet")
    FhirtypesVerificationresult -> json.string("VerificationResult")
    FhirtypesVisionprescription -> json.string("VisionPrescription")
    FhirtypesParameters -> json.string("Parameters")
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
  case provenanceentityrole {
    ProvenanceentityroleRevision -> json.string("revision")
    ProvenanceentityroleQuotation -> json.string("quotation")
    ProvenanceentityroleSource -> json.string("source")
    ProvenanceentityroleInstantiates -> json.string("instantiates")
    ProvenanceentityroleRemoval -> json.string("removal")
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

pub type Questionnaireenablebehavior {
  QuestionnaireenablebehaviorAll
  QuestionnaireenablebehaviorAny
}

pub fn questionnaireenablebehavior_to_json(
  questionnaireenablebehavior: Questionnaireenablebehavior,
) -> Json {
  case questionnaireenablebehavior {
    QuestionnaireenablebehaviorAll -> json.string("all")
    QuestionnaireenablebehaviorAny -> json.string("any")
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
  case questionnaireenableoperator {
    QuestionnaireenableoperatorExists -> json.string("exists")
    QuestionnaireenableoperatorEqual -> json.string("=")
    QuestionnaireenableoperatorNotequal -> json.string("!=")
    QuestionnaireenableoperatorGreaterthan -> json.string(">")
    QuestionnaireenableoperatorLessthan -> json.string("<")
    QuestionnaireenableoperatorGreaterthanequal -> json.string(">=")
    QuestionnaireenableoperatorLessthanequal -> json.string("<=")
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

pub type Searchprocessingmode {
  SearchprocessingmodeNormal
  SearchprocessingmodePhonetic
  SearchprocessingmodeOther
}

pub fn searchprocessingmode_to_json(
  searchprocessingmode: Searchprocessingmode,
) -> Json {
  case searchprocessingmode {
    SearchprocessingmodeNormal -> json.string("normal")
    SearchprocessingmodePhonetic -> json.string("phonetic")
    SearchprocessingmodeOther -> json.string("other")
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

pub type Typederivationrule {
  TypederivationruleSpecialization
  TypederivationruleConstraint
}

pub fn typederivationrule_to_json(
  typederivationrule: Typederivationrule,
) -> Json {
  case typederivationrule {
    TypederivationruleSpecialization -> json.string("specialization")
    TypederivationruleConstraint -> json.string("constraint")
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

pub type Claimuse {
  ClaimuseClaim
  ClaimusePreauthorization
  ClaimusePredetermination
}

pub fn claimuse_to_json(claimuse: Claimuse) -> Json {
  case claimuse {
    ClaimuseClaim -> json.string("claim")
    ClaimusePreauthorization -> json.string("preauthorization")
    ClaimusePredetermination -> json.string("predetermination")
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
  case assertoperatorcodes {
    AssertoperatorcodesEquals -> json.string("equals")
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
    AssertoperatorcodesManualeval -> json.string("manualEval")
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

pub type Devicestatus {
  DevicestatusActive
  DevicestatusInactive
  DevicestatusEnteredinerror
}

pub fn devicestatus_to_json(devicestatus: Devicestatus) -> Json {
  case devicestatus {
    DevicestatusActive -> json.string("active")
    DevicestatusInactive -> json.string("inactive")
    DevicestatusEnteredinerror -> json.string("entered-in-error")
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
  case searchcomparator {
    SearchcomparatorEq -> json.string("eq")
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

pub type Groupmembershipbasis {
  GroupmembershipbasisDefinitional
  GroupmembershipbasisEnumerated
}

pub fn groupmembershipbasis_to_json(
  groupmembershipbasis: Groupmembershipbasis,
) -> Json {
  case groupmembershipbasis {
    GroupmembershipbasisDefinitional -> json.string("definitional")
    GroupmembershipbasisEnumerated -> json.string("enumerated")
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

pub type Visionbasecodes {
  VisionbasecodesUp
  VisionbasecodesDown
  VisionbasecodesIn
  VisionbasecodesOut
}

pub fn visionbasecodes_to_json(visionbasecodes: Visionbasecodes) -> Json {
  case visionbasecodes {
    VisionbasecodesUp -> json.string("up")
    VisionbasecodesDown -> json.string("down")
    VisionbasecodesIn -> json.string("in")
    VisionbasecodesOut -> json.string("out")
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
  case imagingselection3dgraphictype {
    Imagingselection3dgraphictypePoint -> json.string("point")
    Imagingselection3dgraphictypeMultipoint -> json.string("multipoint")
    Imagingselection3dgraphictypePolyline -> json.string("polyline")
    Imagingselection3dgraphictypePolygon -> json.string("polygon")
    Imagingselection3dgraphictypeEllipse -> json.string("ellipse")
    Imagingselection3dgraphictypeEllipsoid -> json.string("ellipsoid")
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

pub type Eligibilityresponsepurpose {
  EligibilityresponsepurposeAuthrequirements
  EligibilityresponsepurposeBenefits
  EligibilityresponsepurposeDiscovery
  EligibilityresponsepurposeValidation
}

pub fn eligibilityresponsepurpose_to_json(
  eligibilityresponsepurpose: Eligibilityresponsepurpose,
) -> Json {
  case eligibilityresponsepurpose {
    EligibilityresponsepurposeAuthrequirements ->
      json.string("auth-requirements")
    EligibilityresponsepurposeBenefits -> json.string("benefits")
    EligibilityresponsepurposeDiscovery -> json.string("discovery")
    EligibilityresponsepurposeValidation -> json.string("validation")
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

pub type Discriminatortype {
  DiscriminatortypeValue
  DiscriminatortypeExists
  DiscriminatortypePattern
  DiscriminatortypeType
  DiscriminatortypeProfile
  DiscriminatortypePosition
}

pub fn discriminatortype_to_json(discriminatortype: Discriminatortype) -> Json {
  case discriminatortype {
    DiscriminatortypeValue -> json.string("value")
    DiscriminatortypeExists -> json.string("exists")
    DiscriminatortypePattern -> json.string("pattern")
    DiscriminatortypeType -> json.string("type")
    DiscriminatortypeProfile -> json.string("profile")
    DiscriminatortypePosition -> json.string("position")
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

pub type Narrativestatus {
  NarrativestatusGenerated
  NarrativestatusExtensions
  NarrativestatusAdditional
  NarrativestatusEmpty
}

pub fn narrativestatus_to_json(narrativestatus: Narrativestatus) -> Json {
  case narrativestatus {
    NarrativestatusGenerated -> json.string("generated")
    NarrativestatusExtensions -> json.string("extensions")
    NarrativestatusAdditional -> json.string("additional")
    NarrativestatusEmpty -> json.string("empty")
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

pub type Versioningpolicy {
  VersioningpolicyNoversion
  VersioningpolicyVersioned
  VersioningpolicyVersionedupdate
}

pub fn versioningpolicy_to_json(versioningpolicy: Versioningpolicy) -> Json {
  case versioningpolicy {
    VersioningpolicyNoversion -> json.string("no-version")
    VersioningpolicyVersioned -> json.string("versioned")
    VersioningpolicyVersionedupdate -> json.string("versioned-update")
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

pub type Consentprovisiontype {
  ConsentprovisiontypeDeny
  ConsentprovisiontypePermit
}

pub fn consentprovisiontype_to_json(
  consentprovisiontype: Consentprovisiontype,
) -> Json {
  case consentprovisiontype {
    ConsentprovisiontypeDeny -> json.string("deny")
    ConsentprovisiontypePermit -> json.string("permit")
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

pub type Actionconditionkind {
  ActionconditionkindApplicability
  ActionconditionkindStart
  ActionconditionkindStop
}

pub fn actionconditionkind_to_json(
  actionconditionkind: Actionconditionkind,
) -> Json {
  case actionconditionkind {
    ActionconditionkindApplicability -> json.string("applicability")
    ActionconditionkindStart -> json.string("start")
    ActionconditionkindStop -> json.string("stop")
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
  case bundletype {
    BundletypeDocument -> json.string("document")
    BundletypeMessage -> json.string("message")
    BundletypeTransaction -> json.string("transaction")
    BundletypeTransactionresponse -> json.string("transaction-response")
    BundletypeBatch -> json.string("batch")
    BundletypeBatchresponse -> json.string("batch-response")
    BundletypeHistory -> json.string("history")
    BundletypeSearchset -> json.string("searchset")
    BundletypeCollection -> json.string("collection")
    BundletypeSubscriptionnotification ->
      json.string("subscription-notification")
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
  case actionselectionbehavior {
    ActionselectionbehaviorAny -> json.string("any")
    ActionselectionbehaviorAll -> json.string("all")
    ActionselectionbehaviorAllornone -> json.string("all-or-none")
    ActionselectionbehaviorExactlyone -> json.string("exactly-one")
    ActionselectionbehaviorAtmostone -> json.string("at-most-one")
    ActionselectionbehaviorOneormore -> json.string("one-or-more")
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
  case maptransform {
    MaptransformCreate -> json.string("create")
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
  case contactpointsystem {
    ContactpointsystemPhone -> json.string("phone")
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
  case appointmentstatus {
    AppointmentstatusProposed -> json.string("proposed")
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

pub type Formularyitemstatus {
  FormularyitemstatusActive
  FormularyitemstatusEnteredinerror
  FormularyitemstatusInactive
}

pub fn formularyitemstatus_to_json(
  formularyitemstatus: Formularyitemstatus,
) -> Json {
  case formularyitemstatus {
    FormularyitemstatusActive -> json.string("active")
    FormularyitemstatusEnteredinerror -> json.string("entered-in-error")
    FormularyitemstatusInactive -> json.string("inactive")
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

pub type Examplescenarioactortype {
  ExamplescenarioactortypePerson
  ExamplescenarioactortypeSystem
}

pub fn examplescenarioactortype_to_json(
  examplescenarioactortype: Examplescenarioactortype,
) -> Json {
  case examplescenarioactortype {
    ExamplescenarioactortypePerson -> json.string("person")
    ExamplescenarioactortypeSystem -> json.string("system")
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
  case triggertype {
    TriggertypeNamedevent -> json.string("named-event")
    TriggertypePeriodic -> json.string("periodic")
    TriggertypeDatachanged -> json.string("data-changed")
    TriggertypeDataadded -> json.string("data-added")
    TriggertypeDatamodified -> json.string("data-modified")
    TriggertypeDataremoved -> json.string("data-removed")
    TriggertypeDataaccessed -> json.string("data-accessed")
    TriggertypeDataaccessended -> json.string("data-access-ended")
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
  case artifactassessmentdisposition {
    ArtifactassessmentdispositionUnresolved -> json.string("unresolved")
    ArtifactassessmentdispositionNotpersuasive -> json.string("not-persuasive")
    ArtifactassessmentdispositionPersuasive -> json.string("persuasive")
    ArtifactassessmentdispositionPersuasivewithmodification ->
      json.string("persuasive-with-modification")
    ArtifactassessmentdispositionNotpersuasivewithmodification ->
      json.string("not-persuasive-with-modification")
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
  case auditeventseverity {
    AuditeventseverityEmergency -> json.string("emergency")
    AuditeventseverityAlert -> json.string("alert")
    AuditeventseverityCritical -> json.string("critical")
    AuditeventseverityError -> json.string("error")
    AuditeventseverityWarning -> json.string("warning")
    AuditeventseverityNotice -> json.string("notice")
    AuditeventseverityInformational -> json.string("informational")
    AuditeventseverityDebug -> json.string("debug")
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
  case relatedartifacttype {
    RelatedartifacttypeDocumentation -> json.string("documentation")
    RelatedartifacttypeJustification -> json.string("justification")
    RelatedartifacttypeCitation -> json.string("citation")
    RelatedartifacttypePredecessor -> json.string("predecessor")
    RelatedartifacttypeSuccessor -> json.string("successor")
    RelatedartifacttypeDerivedfrom -> json.string("derived-from")
    RelatedartifacttypeDependson -> json.string("depends-on")
    RelatedartifacttypeComposedof -> json.string("composed-of")
    RelatedartifacttypePartof -> json.string("part-of")
    RelatedartifacttypeAmends -> json.string("amends")
    RelatedartifacttypeAmendedwith -> json.string("amended-with")
    RelatedartifacttypeAppends -> json.string("appends")
    RelatedartifacttypeAppendedwith -> json.string("appended-with")
    RelatedartifacttypeCites -> json.string("cites")
    RelatedartifacttypeCitedby -> json.string("cited-by")
    RelatedartifacttypeCommentson -> json.string("comments-on")
    RelatedartifacttypeCommentin -> json.string("comment-in")
    RelatedartifacttypeContains -> json.string("contains")
    RelatedartifacttypeContainedin -> json.string("contained-in")
    RelatedartifacttypeCorrects -> json.string("corrects")
    RelatedartifacttypeCorrectionin -> json.string("correction-in")
    RelatedartifacttypeReplaces -> json.string("replaces")
    RelatedartifacttypeReplacedwith -> json.string("replaced-with")
    RelatedartifacttypeRetracts -> json.string("retracts")
    RelatedartifacttypeRetractedby -> json.string("retracted-by")
    RelatedartifacttypeSigns -> json.string("signs")
    RelatedartifacttypeSimilarto -> json.string("similar-to")
    RelatedartifacttypeSupports -> json.string("supports")
    RelatedartifacttypeSupportedwith -> json.string("supported-with")
    RelatedartifacttypeTransforms -> json.string("transforms")
    RelatedartifacttypeTransformedinto -> json.string("transformed-into")
    RelatedartifacttypeTransformedwith -> json.string("transformed-with")
    RelatedartifacttypeDocuments -> json.string("documents")
    RelatedartifacttypeSpecificationof -> json.string("specification-of")
    RelatedartifacttypeCreatedwith -> json.string("created-with")
    RelatedartifacttypeCiteas -> json.string("cite-as")
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

pub type Documentreferencestatus {
  DocumentreferencestatusCurrent
  DocumentreferencestatusSuperseded
  DocumentreferencestatusEnteredinerror
}

pub fn documentreferencestatus_to_json(
  documentreferencestatus: Documentreferencestatus,
) -> Json {
  case documentreferencestatus {
    DocumentreferencestatusCurrent -> json.string("current")
    DocumentreferencestatusSuperseded -> json.string("superseded")
    DocumentreferencestatusEnteredinerror -> json.string("entered-in-error")
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

pub type Submitdataupdatetype {
  SubmitdataupdatetypeIncremental
  SubmitdataupdatetypeSnapshot
}

pub fn submitdataupdatetype_to_json(
  submitdataupdatetype: Submitdataupdatetype,
) -> Json {
  case submitdataupdatetype {
    SubmitdataupdatetypeIncremental -> json.string("incremental")
    SubmitdataupdatetypeSnapshot -> json.string("snapshot")
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

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningGroupedby
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningClassifiedwith
}

pub fn codesystemhierarchymeaning_to_json(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> Json {
  case codesystemhierarchymeaning {
    CodesystemhierarchymeaningGroupedby -> json.string("grouped-by")
    CodesystemhierarchymeaningIsa -> json.string("is-a")
    CodesystemhierarchymeaningPartof -> json.string("part-of")
    CodesystemhierarchymeaningClassifiedwith -> json.string("classified-with")
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
  case eventstatus {
    EventstatusPreparation -> json.string("preparation")
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

pub type Conformanceexpectation {
  ConformanceexpectationShall
  ConformanceexpectationShould
  ConformanceexpectationMay
  ConformanceexpectationShouldnot
}

pub fn conformanceexpectation_to_json(
  conformanceexpectation: Conformanceexpectation,
) -> Json {
  case conformanceexpectation {
    ConformanceexpectationShall -> json.string("SHALL")
    ConformanceexpectationShould -> json.string("SHOULD")
    ConformanceexpectationMay -> json.string("MAY")
    ConformanceexpectationShouldnot -> json.string("SHOULD-NOT")
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
  case encounterstatus {
    EncounterstatusPlanned -> json.string("planned")
    EncounterstatusInprogress -> json.string("in-progress")
    EncounterstatusOnhold -> json.string("on-hold")
    EncounterstatusDischarged -> json.string("discharged")
    EncounterstatusCompleted -> json.string("completed")
    EncounterstatusCancelled -> json.string("cancelled")
    EncounterstatusDiscontinued -> json.string("discontinued")
    EncounterstatusEnteredinerror -> json.string("entered-in-error")
    EncounterstatusUnknown -> json.string("unknown")
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

pub type Orientationtype {
  OrientationtypeSense
  OrientationtypeAntisense
}

pub fn orientationtype_to_json(orientationtype: Orientationtype) -> Json {
  case orientationtype {
    OrientationtypeSense -> json.string("sense")
    OrientationtypeAntisense -> json.string("antisense")
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
  case valuefiltercomparator {
    ValuefiltercomparatorEq -> json.string("eq")
    ValuefiltercomparatorGt -> json.string("gt")
    ValuefiltercomparatorLt -> json.string("lt")
    ValuefiltercomparatorGe -> json.string("ge")
    ValuefiltercomparatorLe -> json.string("le")
    ValuefiltercomparatorSa -> json.string("sa")
    ValuefiltercomparatorEb -> json.string("eb")
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

pub type Allergyintolerancecriticality {
  AllergyintolerancecriticalityLow
  AllergyintolerancecriticalityHigh
  AllergyintolerancecriticalityUnabletoassess
}

pub fn allergyintolerancecriticality_to_json(
  allergyintolerancecriticality: Allergyintolerancecriticality,
) -> Json {
  case allergyintolerancecriticality {
    AllergyintolerancecriticalityLow -> json.string("low")
    AllergyintolerancecriticalityHigh -> json.string("high")
    AllergyintolerancecriticalityUnabletoassess ->
      json.string("unable-to-assess")
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
  case actionrelationshiptype {
    ActionrelationshiptypeBefore -> json.string("before")
    ActionrelationshiptypeBeforestart -> json.string("before-start")
    ActionrelationshiptypeBeforeend -> json.string("before-end")
    ActionrelationshiptypeConcurrent -> json.string("concurrent")
    ActionrelationshiptypeConcurrentwithstart ->
      json.string("concurrent-with-start")
    ActionrelationshiptypeConcurrentwithend ->
      json.string("concurrent-with-end")
    ActionrelationshiptypeAfter -> json.string("after")
    ActionrelationshiptypeAfterstart -> json.string("after-start")
    ActionrelationshiptypeAfterend -> json.string("after-end")
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

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
  IssueseveritySuccess
}

pub fn issueseverity_to_json(issueseverity: Issueseverity) -> Json {
  case issueseverity {
    IssueseverityFatal -> json.string("fatal")
    IssueseverityError -> json.string("error")
    IssueseverityWarning -> json.string("warning")
    IssueseverityInformation -> json.string("information")
    IssueseveritySuccess -> json.string("success")
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

pub type Enrollmentoutcome {
  EnrollmentoutcomeQueued
  EnrollmentoutcomeComplete
  EnrollmentoutcomeError
  EnrollmentoutcomePartial
}

pub fn enrollmentoutcome_to_json(enrollmentoutcome: Enrollmentoutcome) -> Json {
  case enrollmentoutcome {
    EnrollmentoutcomeQueued -> json.string("queued")
    EnrollmentoutcomeComplete -> json.string("complete")
    EnrollmentoutcomeError -> json.string("error")
    EnrollmentoutcomePartial -> json.string("partial")
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

pub type Eligibilityoutcome {
  EligibilityoutcomeQueued
  EligibilityoutcomeComplete
  EligibilityoutcomeError
  EligibilityoutcomePartial
}

pub fn eligibilityoutcome_to_json(
  eligibilityoutcome: Eligibilityoutcome,
) -> Json {
  case eligibilityoutcome {
    EligibilityoutcomeQueued -> json.string("queued")
    EligibilityoutcomeComplete -> json.string("complete")
    EligibilityoutcomeError -> json.string("error")
    EligibilityoutcomePartial -> json.string("partial")
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
  case subscriptionnotificationtype {
    SubscriptionnotificationtypeHandshake -> json.string("handshake")
    SubscriptionnotificationtypeHeartbeat -> json.string("heartbeat")
    SubscriptionnotificationtypeEventnotification ->
      json.string("event-notification")
    SubscriptionnotificationtypeQuerystatus -> json.string("query-status")
    SubscriptionnotificationtypeQueryevent -> json.string("query-event")
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

pub type Slotstatus {
  SlotstatusBusy
  SlotstatusFree
  SlotstatusBusyunavailable
  SlotstatusBusytentative
  SlotstatusEnteredinerror
}

pub fn slotstatus_to_json(slotstatus: Slotstatus) -> Json {
  case slotstatus {
    SlotstatusBusy -> json.string("busy")
    SlotstatusFree -> json.string("free")
    SlotstatusBusyunavailable -> json.string("busy-unavailable")
    SlotstatusBusytentative -> json.string("busy-tentative")
    SlotstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Ingredientmanufacturerrole {
  IngredientmanufacturerroleAllowed
  IngredientmanufacturerrolePossible
  IngredientmanufacturerroleActual
}

pub fn ingredientmanufacturerrole_to_json(
  ingredientmanufacturerrole: Ingredientmanufacturerrole,
) -> Json {
  case ingredientmanufacturerrole {
    IngredientmanufacturerroleAllowed -> json.string("allowed")
    IngredientmanufacturerrolePossible -> json.string("possible")
    IngredientmanufacturerroleActual -> json.string("actual")
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

pub type Assertmanualcompletioncodes {
  AssertmanualcompletioncodesFail
  AssertmanualcompletioncodesPass
  AssertmanualcompletioncodesSkip
  AssertmanualcompletioncodesStop
}

pub fn assertmanualcompletioncodes_to_json(
  assertmanualcompletioncodes: Assertmanualcompletioncodes,
) -> Json {
  case assertmanualcompletioncodes {
    AssertmanualcompletioncodesFail -> json.string("fail")
    AssertmanualcompletioncodesPass -> json.string("pass")
    AssertmanualcompletioncodesSkip -> json.string("skip")
    AssertmanualcompletioncodesStop -> json.string("stop")
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
  case conceptmaprelationship {
    ConceptmaprelationshipRelatedto -> json.string("related-to")
    ConceptmaprelationshipEquivalent -> json.string("equivalent")
    ConceptmaprelationshipSourceisnarrowerthantarget ->
      json.string("source-is-narrower-than-target")
    ConceptmaprelationshipSourceisbroaderthantarget ->
      json.string("source-is-broader-than-target")
    ConceptmaprelationshipNotrelatedto -> json.string("not-related-to")
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
  case codesystemcontentmode {
    CodesystemcontentmodeNotpresent -> json.string("not-present")
    CodesystemcontentmodeExample -> json.string("example")
    CodesystemcontentmodeFragment -> json.string("fragment")
    CodesystemcontentmodeComplete -> json.string("complete")
    CodesystemcontentmodeSupplement -> json.string("supplement")
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

pub type Observationtriggeredbytype {
  ObservationtriggeredbytypeReflex
  ObservationtriggeredbytypeRepeat
  ObservationtriggeredbytypeRerun
}

pub fn observationtriggeredbytype_to_json(
  observationtriggeredbytype: Observationtriggeredbytype,
) -> Json {
  case observationtriggeredbytype {
    ObservationtriggeredbytypeReflex -> json.string("reflex")
    ObservationtriggeredbytypeRepeat -> json.string("repeat")
    ObservationtriggeredbytypeRerun -> json.string("re-run")
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
  case referencehandlingpolicy {
    ReferencehandlingpolicyLiteral -> json.string("literal")
    ReferencehandlingpolicyLogical -> json.string("logical")
    ReferencehandlingpolicyResolves -> json.string("resolves")
    ReferencehandlingpolicyEnforced -> json.string("enforced")
    ReferencehandlingpolicyLocal -> json.string("local")
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
  case supplyrequeststatus {
    SupplyrequeststatusDraft -> json.string("draft")
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

pub type Measurereporttype {
  MeasurereporttypeIndividual
  MeasurereporttypeSubjectlist
  MeasurereporttypeSummary
  MeasurereporttypeDataexchange
}

pub fn measurereporttype_to_json(measurereporttype: Measurereporttype) -> Json {
  case measurereporttype {
    MeasurereporttypeIndividual -> json.string("individual")
    MeasurereporttypeSubjectlist -> json.string("subject-list")
    MeasurereporttypeSummary -> json.string("summary")
    MeasurereporttypeDataexchange -> json.string("data-exchange")
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

pub type Publicationstatus {
  PublicationstatusDraft
  PublicationstatusActive
  PublicationstatusRetired
  PublicationstatusUnknown
}

pub fn publicationstatus_to_json(publicationstatus: Publicationstatus) -> Json {
  case publicationstatus {
    PublicationstatusDraft -> json.string("draft")
    PublicationstatusActive -> json.string("active")
    PublicationstatusRetired -> json.string("retired")
    PublicationstatusUnknown -> json.string("unknown")
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
  case medicationdispensestatus {
    MedicationdispensestatusPreparation -> json.string("preparation")
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

pub type Searchentrymode {
  SearchentrymodeMatch
  SearchentrymodeInclude
  SearchentrymodeOutcome
}

pub fn searchentrymode_to_json(searchentrymode: Searchentrymode) -> Json {
  case searchentrymode {
    SearchentrymodeMatch -> json.string("match")
    SearchentrymodeInclude -> json.string("include")
    SearchentrymodeOutcome -> json.string("outcome")
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
  case requeststatus {
    RequeststatusDraft -> json.string("draft")
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

pub type Detectedissuestatus {
  DetectedissuestatusPreliminary
  DetectedissuestatusFinal
  DetectedissuestatusEnteredinerror
  DetectedissuestatusMitigated
}

pub fn detectedissuestatus_to_json(
  detectedissuestatus: Detectedissuestatus,
) -> Json {
  case detectedissuestatus {
    DetectedissuestatusPreliminary -> json.string("preliminary")
    DetectedissuestatusFinal -> json.string("final")
    DetectedissuestatusEnteredinerror -> json.string("entered-in-error")
    DetectedissuestatusMitigated -> json.string("mitigated")
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

pub type Observationrangecategory {
  ObservationrangecategoryReference
  ObservationrangecategoryCritical
  ObservationrangecategoryAbsolute
}

pub fn observationrangecategory_to_json(
  observationrangecategory: Observationrangecategory,
) -> Json {
  case observationrangecategory {
    ObservationrangecategoryReference -> json.string("reference")
    ObservationrangecategoryCritical -> json.string("critical")
    ObservationrangecategoryAbsolute -> json.string("absolute")
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
  case deviceproductidentifierinudi {
    DeviceproductidentifierinudiLotnumber -> json.string("lot-number")
    DeviceproductidentifierinudiManufactureddate ->
      json.string("manufactured-date")
    DeviceproductidentifierinudiSerialnumber -> json.string("serial-number")
    DeviceproductidentifierinudiExpirationdate -> json.string("expiration-date")
    DeviceproductidentifierinudiBiologicalsource ->
      json.string("biological-source")
    DeviceproductidentifierinudiSoftwareversion ->
      json.string("software-version")
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

pub type Metriccategory {
  MetriccategoryMeasurement
  MetriccategorySetting
  MetriccategoryCalculation
  MetriccategoryUnspecified
}

pub fn metriccategory_to_json(metriccategory: Metriccategory) -> Json {
  case metriccategory {
    MetriccategoryMeasurement -> json.string("measurement")
    MetriccategorySetting -> json.string("setting")
    MetriccategoryCalculation -> json.string("calculation")
    MetriccategoryUnspecified -> json.string("unspecified")
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

pub type Codesearchsupport {
  CodesearchsupportIncompose
  CodesearchsupportInexpansion
  CodesearchsupportIncomposeorexpansion
}

pub fn codesearchsupport_to_json(codesearchsupport: Codesearchsupport) -> Json {
  case codesearchsupport {
    CodesearchsupportIncompose -> json.string("in-compose")
    CodesearchsupportInexpansion -> json.string("in-expansion")
    CodesearchsupportIncomposeorexpansion ->
      json.string("in-compose-or-expansion")
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

pub type Addressuse {
  AddressuseHome
  AddressuseWork
  AddressuseTemp
  AddressuseOld
  AddressuseBilling
}

pub fn addressuse_to_json(addressuse: Addressuse) -> Json {
  case addressuse {
    AddressuseHome -> json.string("home")
    AddressuseWork -> json.string("work")
    AddressuseTemp -> json.string("temp")
    AddressuseOld -> json.string("old")
    AddressuseBilling -> json.string("billing")
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
  case deviceusagestatus {
    DeviceusagestatusActive -> json.string("active")
    DeviceusagestatusCompleted -> json.string("completed")
    DeviceusagestatusNotdone -> json.string("not-done")
    DeviceusagestatusEnteredinerror -> json.string("entered-in-error")
    DeviceusagestatusIntended -> json.string("intended")
    DeviceusagestatusStopped -> json.string("stopped")
    DeviceusagestatusOnhold -> json.string("on-hold")
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

pub type Listmode {
  ListmodeWorking
  ListmodeSnapshot
  ListmodeChanges
}

pub fn listmode_to_json(listmode: Listmode) -> Json {
  case listmode {
    ListmodeWorking -> json.string("working")
    ListmodeSnapshot -> json.string("snapshot")
    ListmodeChanges -> json.string("changes")
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

pub type Eligibilityrequestpurpose {
  EligibilityrequestpurposeAuthrequirements
  EligibilityrequestpurposeBenefits
  EligibilityrequestpurposeDiscovery
  EligibilityrequestpurposeValidation
}

pub fn eligibilityrequestpurpose_to_json(
  eligibilityrequestpurpose: Eligibilityrequestpurpose,
) -> Json {
  case eligibilityrequestpurpose {
    EligibilityrequestpurposeAuthrequirements ->
      json.string("auth-requirements")
    EligibilityrequestpurposeBenefits -> json.string("benefits")
    EligibilityrequestpurposeDiscovery -> json.string("discovery")
    EligibilityrequestpurposeValidation -> json.string("validation")
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
  case transportintent {
    TransportintentUnknown -> json.string("unknown")
    TransportintentProposal -> json.string("proposal")
    TransportintentPlan -> json.string("plan")
    TransportintentOrder -> json.string("order")
    TransportintentOriginalorder -> json.string("original-order")
    TransportintentReflexorder -> json.string("reflex-order")
    TransportintentFillerorder -> json.string("filler-order")
    TransportintentInstanceorder -> json.string("instance-order")
    TransportintentOption -> json.string("option")
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

pub type Endpointstatus {
  EndpointstatusActive
  EndpointstatusSuspended
  EndpointstatusError
  EndpointstatusOff
  EndpointstatusEnteredinerror
}

pub fn endpointstatus_to_json(endpointstatus: Endpointstatus) -> Json {
  case endpointstatus {
    EndpointstatusActive -> json.string("active")
    EndpointstatusSuspended -> json.string("suspended")
    EndpointstatusError -> json.string("error")
    EndpointstatusOff -> json.string("off")
    EndpointstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Explanationofbenefitstatus {
  ExplanationofbenefitstatusActive
  ExplanationofbenefitstatusCancelled
  ExplanationofbenefitstatusDraft
  ExplanationofbenefitstatusEnteredinerror
}

pub fn explanationofbenefitstatus_to_json(
  explanationofbenefitstatus: Explanationofbenefitstatus,
) -> Json {
  case explanationofbenefitstatus {
    ExplanationofbenefitstatusActive -> json.string("active")
    ExplanationofbenefitstatusCancelled -> json.string("cancelled")
    ExplanationofbenefitstatusDraft -> json.string("draft")
    ExplanationofbenefitstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Devicecorrectiveactionscope {
  DevicecorrectiveactionscopeModel
  DevicecorrectiveactionscopeLotnumbers
  DevicecorrectiveactionscopeSerialnumbers
}

pub fn devicecorrectiveactionscope_to_json(
  devicecorrectiveactionscope: Devicecorrectiveactionscope,
) -> Json {
  case devicecorrectiveactionscope {
    DevicecorrectiveactionscopeModel -> json.string("model")
    DevicecorrectiveactionscopeLotnumbers -> json.string("lot-numbers")
    DevicecorrectiveactionscopeSerialnumbers -> json.string("serial-numbers")
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
  case medicationrequestintent {
    MedicationrequestintentProposal -> json.string("proposal")
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

pub type Actiongroupingbehavior {
  ActiongroupingbehaviorVisualgroup
  ActiongroupingbehaviorLogicalgroup
  ActiongroupingbehaviorSentencegroup
}

pub fn actiongroupingbehavior_to_json(
  actiongroupingbehavior: Actiongroupingbehavior,
) -> Json {
  case actiongroupingbehavior {
    ActiongroupingbehaviorVisualgroup -> json.string("visual-group")
    ActiongroupingbehaviorLogicalgroup -> json.string("logical-group")
    ActiongroupingbehaviorSentencegroup -> json.string("sentence-group")
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

pub type Graphcompartmentuse {
  GraphcompartmentuseWhere
  GraphcompartmentuseRequires
}

pub fn graphcompartmentuse_to_json(
  graphcompartmentuse: Graphcompartmentuse,
) -> Json {
  case graphcompartmentuse {
    GraphcompartmentuseWhere -> json.string("where")
    GraphcompartmentuseRequires -> json.string("requires")
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

pub type Mapinputmode {
  MapinputmodeSource
  MapinputmodeTarget
}

pub fn mapinputmode_to_json(mapinputmode: Mapinputmode) -> Json {
  case mapinputmode {
    MapinputmodeSource -> json.string("source")
    MapinputmodeTarget -> json.string("target")
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
  case contractstatus {
    ContractstatusAmended -> json.string("amended")
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

pub type Actioncardinalitybehavior {
  ActioncardinalitybehaviorSingle
  ActioncardinalitybehaviorMultiple
}

pub fn actioncardinalitybehavior_to_json(
  actioncardinalitybehavior: Actioncardinalitybehavior,
) -> Json {
  case actioncardinalitybehavior {
    ActioncardinalitybehaviorSingle -> json.string("single")
    ActioncardinalitybehaviorMultiple -> json.string("multiple")
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

pub type Conditionalreadstatus {
  ConditionalreadstatusNotsupported
  ConditionalreadstatusModifiedsince
  ConditionalreadstatusNotmatch
  ConditionalreadstatusFullsupport
}

pub fn conditionalreadstatus_to_json(
  conditionalreadstatus: Conditionalreadstatus,
) -> Json {
  case conditionalreadstatus {
    ConditionalreadstatusNotsupported -> json.string("not-supported")
    ConditionalreadstatusModifiedsince -> json.string("modified-since")
    ConditionalreadstatusNotmatch -> json.string("not-match")
    ConditionalreadstatusFullsupport -> json.string("full-support")
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

pub type Questionnairedisableddisplay {
  QuestionnairedisableddisplayHidden
  QuestionnairedisableddisplayProtected
}

pub fn questionnairedisableddisplay_to_json(
  questionnairedisableddisplay: Questionnairedisableddisplay,
) -> Json {
  case questionnairedisableddisplay {
    QuestionnairedisableddisplayHidden -> json.string("hidden")
    QuestionnairedisableddisplayProtected -> json.string("protected")
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
  case reportrelationtype {
    ReportrelationtypeReplaces -> json.string("replaces")
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
  case medicationrequeststatus {
    MedicationrequeststatusActive -> json.string("active")
    MedicationrequeststatusOnhold -> json.string("on-hold")
    MedicationrequeststatusEnded -> json.string("ended")
    MedicationrequeststatusStopped -> json.string("stopped")
    MedicationrequeststatusCompleted -> json.string("completed")
    MedicationrequeststatusCancelled -> json.string("cancelled")
    MedicationrequeststatusEnteredinerror -> json.string("entered-in-error")
    MedicationrequeststatusDraft -> json.string("draft")
    MedicationrequeststatusUnknown -> json.string("unknown")
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
  case diagnosticreportstatus {
    DiagnosticreportstatusRegistered -> json.string("registered")
    DiagnosticreportstatusPartial -> json.string("partial")
    DiagnosticreportstatusPreliminary -> json.string("preliminary")
    DiagnosticreportstatusModified -> json.string("modified")
    DiagnosticreportstatusFinal -> json.string("final")
    DiagnosticreportstatusAmended -> json.string("amended")
    DiagnosticreportstatusCorrected -> json.string("corrected")
    DiagnosticreportstatusAppended -> json.string("appended")
    DiagnosticreportstatusCancelled -> json.string("cancelled")
    DiagnosticreportstatusEnteredinerror -> json.string("entered-in-error")
    DiagnosticreportstatusUnknown -> json.string("unknown")
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

pub type Consentstatecodes {
  ConsentstatecodesDraft
  ConsentstatecodesActive
  ConsentstatecodesInactive
  ConsentstatecodesNotdone
  ConsentstatecodesEnteredinerror
  ConsentstatecodesUnknown
}

pub fn consentstatecodes_to_json(consentstatecodes: Consentstatecodes) -> Json {
  case consentstatecodes {
    ConsentstatecodesDraft -> json.string("draft")
    ConsentstatecodesActive -> json.string("active")
    ConsentstatecodesInactive -> json.string("inactive")
    ConsentstatecodesNotdone -> json.string("not-done")
    ConsentstatecodesEnteredinerror -> json.string("entered-in-error")
    ConsentstatecodesUnknown -> json.string("unknown")
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

pub type Liststatus {
  ListstatusCurrent
  ListstatusRetired
  ListstatusEnteredinerror
}

pub fn liststatus_to_json(liststatus: Liststatus) -> Json {
  case liststatus {
    ListstatusCurrent -> json.string("current")
    ListstatusRetired -> json.string("retired")
    ListstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Operationparameterscope {
  OperationparameterscopeInstance
  OperationparameterscopeType
  OperationparameterscopeSystem
}

pub fn operationparameterscope_to_json(
  operationparameterscope: Operationparameterscope,
) -> Json {
  case operationparameterscope {
    OperationparameterscopeInstance -> json.string("instance")
    OperationparameterscopeType -> json.string("type")
    OperationparameterscopeSystem -> json.string("system")
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

pub type Contributortype {
  ContributortypeAuthor
  ContributortypeEditor
  ContributortypeReviewer
  ContributortypeEndorser
}

pub fn contributortype_to_json(contributortype: Contributortype) -> Json {
  case contributortype {
    ContributortypeAuthor -> json.string("author")
    ContributortypeEditor -> json.string("editor")
    ContributortypeReviewer -> json.string("reviewer")
    ContributortypeEndorser -> json.string("endorser")
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

pub type Restfulcapabilitymode {
  RestfulcapabilitymodeClient
  RestfulcapabilitymodeServer
}

pub fn restfulcapabilitymode_to_json(
  restfulcapabilitymode: Restfulcapabilitymode,
) -> Json {
  case restfulcapabilitymode {
    RestfulcapabilitymodeClient -> json.string("client")
    RestfulcapabilitymodeServer -> json.string("server")
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

pub type Medicationstatementstatus {
  MedicationstatementstatusRecorded
  MedicationstatementstatusEnteredinerror
  MedicationstatementstatusDraft
}

pub fn medicationstatementstatus_to_json(
  medicationstatementstatus: Medicationstatementstatus,
) -> Json {
  case medicationstatementstatus {
    MedicationstatementstatusRecorded -> json.string("recorded")
    MedicationstatementstatusEnteredinerror -> json.string("entered-in-error")
    MedicationstatementstatusDraft -> json.string("draft")
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

pub type Inventoryitemstatus {
  InventoryitemstatusActive
  InventoryitemstatusInactive
  InventoryitemstatusEnteredinerror
  InventoryitemstatusUnknown
}

pub fn inventoryitemstatus_to_json(
  inventoryitemstatus: Inventoryitemstatus,
) -> Json {
  case inventoryitemstatus {
    InventoryitemstatusActive -> json.string("active")
    InventoryitemstatusInactive -> json.string("inactive")
    InventoryitemstatusEnteredinerror -> json.string("entered-in-error")
    InventoryitemstatusUnknown -> json.string("unknown")
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
  case guidanceresponsestatus {
    GuidanceresponsestatusSuccess -> json.string("success")
    GuidanceresponsestatusDatarequested -> json.string("data-requested")
    GuidanceresponsestatusDatarequired -> json.string("data-required")
    GuidanceresponsestatusInprogress -> json.string("in-progress")
    GuidanceresponsestatusFailure -> json.string("failure")
    GuidanceresponsestatusEnteredinerror -> json.string("entered-in-error")
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

pub type Constraintseverity {
  ConstraintseverityError
  ConstraintseverityWarning
}

pub fn constraintseverity_to_json(
  constraintseverity: Constraintseverity,
) -> Json {
  case constraintseverity {
    ConstraintseverityError -> json.string("error")
    ConstraintseverityWarning -> json.string("warning")
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

pub type Messageheaderresponserequest {
  MessageheaderresponserequestAlways
  MessageheaderresponserequestOnerror
  MessageheaderresponserequestNever
  MessageheaderresponserequestOnsuccess
}

pub fn messageheaderresponserequest_to_json(
  messageheaderresponserequest: Messageheaderresponserequest,
) -> Json {
  case messageheaderresponserequest {
    MessageheaderresponserequestAlways -> json.string("always")
    MessageheaderresponserequestOnerror -> json.string("on-error")
    MessageheaderresponserequestNever -> json.string("never")
    MessageheaderresponserequestOnsuccess -> json.string("on-success")
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
  case contractpublicationstatus {
    ContractpublicationstatusAmended -> json.string("amended")
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

pub type Immunizationstatus {
  ImmunizationstatusCompleted
  ImmunizationstatusEnteredinerror
  ImmunizationstatusNotdone
}

pub fn immunizationstatus_to_json(
  immunizationstatus: Immunizationstatus,
) -> Json {
  case immunizationstatus {
    ImmunizationstatusCompleted -> json.string("completed")
    ImmunizationstatusEnteredinerror -> json.string("entered-in-error")
    ImmunizationstatusNotdone -> json.string("not-done")
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
  case httpoperations {
    HttpoperationsDelete -> json.string("delete")
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
  case biologicallyderivedproductdispensestatus {
    BiologicallyderivedproductdispensestatusPreparation ->
      json.string("preparation")
    BiologicallyderivedproductdispensestatusInprogress ->
      json.string("in-progress")
    BiologicallyderivedproductdispensestatusAllocated ->
      json.string("allocated")
    BiologicallyderivedproductdispensestatusIssued -> json.string("issued")
    BiologicallyderivedproductdispensestatusUnfulfilled ->
      json.string("unfulfilled")
    BiologicallyderivedproductdispensestatusReturned -> json.string("returned")
    BiologicallyderivedproductdispensestatusEnteredinerror ->
      json.string("entered-in-error")
    BiologicallyderivedproductdispensestatusUnknown -> json.string("unknown")
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

pub type Guidepagegeneration {
  GuidepagegenerationHtml
  GuidepagegenerationMarkdown
  GuidepagegenerationXml
  GuidepagegenerationGenerated
}

pub fn guidepagegeneration_to_json(
  guidepagegeneration: Guidepagegeneration,
) -> Json {
  case guidepagegeneration {
    GuidepagegenerationHtml -> json.string("html")
    GuidepagegenerationMarkdown -> json.string("markdown")
    GuidepagegenerationXml -> json.string("xml")
    GuidepagegenerationGenerated -> json.string("generated")
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

pub type Locationmode {
  LocationmodeInstance
  LocationmodeKind
}

pub fn locationmode_to_json(locationmode: Locationmode) -> Json {
  case locationmode {
    LocationmodeInstance -> json.string("instance")
    LocationmodeKind -> json.string("kind")
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
  case actionparticipanttype {
    ActionparticipanttypeCareteam -> json.string("careteam")
    ActionparticipanttypeDevice -> json.string("device")
    ActionparticipanttypeGroup -> json.string("group")
    ActionparticipanttypeHealthcareservice -> json.string("healthcareservice")
    ActionparticipanttypeLocation -> json.string("location")
    ActionparticipanttypeOrganization -> json.string("organization")
    ActionparticipanttypePatient -> json.string("patient")
    ActionparticipanttypePractitioner -> json.string("practitioner")
    ActionparticipanttypePractitionerrole -> json.string("practitionerrole")
    ActionparticipanttypeRelatedperson -> json.string("relatedperson")
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

pub type Specimenstatus {
  SpecimenstatusAvailable
  SpecimenstatusUnavailable
  SpecimenstatusUnsatisfactory
  SpecimenstatusEnteredinerror
}

pub fn specimenstatus_to_json(specimenstatus: Specimenstatus) -> Json {
  case specimenstatus {
    SpecimenstatusAvailable -> json.string("available")
    SpecimenstatusUnavailable -> json.string("unavailable")
    SpecimenstatusUnsatisfactory -> json.string("unsatisfactory")
    SpecimenstatusEnteredinerror -> json.string("entered-in-error")
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
  case namingsystemidentifiertype {
    NamingsystemidentifiertypeOid -> json.string("oid")
    NamingsystemidentifiertypeUuid -> json.string("uuid")
    NamingsystemidentifiertypeUri -> json.string("uri")
    NamingsystemidentifiertypeIristem -> json.string("iri-stem")
    NamingsystemidentifiertypeV2csmnemonic -> json.string("v2csmnemonic")
    NamingsystemidentifiertypeOther -> json.string("other")
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
  case goalstatus {
    GoalstatusProposed -> json.string("proposed")
    GoalstatusPlanned -> json.string("planned")
    GoalstatusAccepted -> json.string("accepted")
    GoalstatusActive -> json.string("active")
    GoalstatusOnhold -> json.string("on-hold")
    GoalstatusCompleted -> json.string("completed")
    GoalstatusCancelled -> json.string("cancelled")
    GoalstatusEnteredinerror -> json.string("entered-in-error")
    GoalstatusRejected -> json.string("rejected")
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

pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}

pub fn administrativegender_to_json(
  administrativegender: Administrativegender,
) -> Json {
  case administrativegender {
    AdministrativegenderMale -> json.string("male")
    AdministrativegenderFemale -> json.string("female")
    AdministrativegenderOther -> json.string("other")
    AdministrativegenderUnknown -> json.string("unknown")
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
  case conceptmappropertytype {
    ConceptmappropertytypeCoding -> json.string("Coding")
    ConceptmappropertytypeString -> json.string("string")
    ConceptmappropertytypeInteger -> json.string("integer")
    ConceptmappropertytypeBoolean -> json.string("boolean")
    ConceptmappropertytypeDatetime -> json.string("dateTime")
    ConceptmappropertytypeDecimal -> json.string("decimal")
    ConceptmappropertytypeCode -> json.string("code")
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

pub type Historystatus {
  HistorystatusPartial
  HistorystatusCompleted
  HistorystatusEnteredinerror
  HistorystatusHealthunknown
}

pub fn historystatus_to_json(historystatus: Historystatus) -> Json {
  case historystatus {
    HistorystatusPartial -> json.string("partial")
    HistorystatusCompleted -> json.string("completed")
    HistorystatusEnteredinerror -> json.string("entered-in-error")
    HistorystatusHealthunknown -> json.string("health-unknown")
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

pub type Visioneyecodes {
  VisioneyecodesRight
  VisioneyecodesLeft
}

pub fn visioneyecodes_to_json(visioneyecodes: Visioneyecodes) -> Json {
  case visioneyecodes {
    VisioneyecodesRight -> json.string("right")
    VisioneyecodesLeft -> json.string("left")
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
  case daysofweek {
    DaysofweekMon -> json.string("mon")
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
  case itemtype {
    ItemtypeGroup -> json.string("group")
    ItemtypeDisplay -> json.string("display")
    ItemtypeQuestion -> json.string("question")
    ItemtypeBoolean -> json.string("boolean")
    ItemtypeDecimal -> json.string("decimal")
    ItemtypeInteger -> json.string("integer")
    ItemtypeDate -> json.string("date")
    ItemtypeDatetime -> json.string("dateTime")
    ItemtypeTime -> json.string("time")
    ItemtypeString -> json.string("string")
    ItemtypeText -> json.string("text")
    ItemtypeUrl -> json.string("url")
    ItemtypeCoding -> json.string("coding")
    ItemtypeAttachment -> json.string("attachment")
    ItemtypeReference -> json.string("reference")
    ItemtypeQuantity -> json.string("quantity")
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

pub type Responsecode {
  ResponsecodeOk
  ResponsecodeTransienterror
  ResponsecodeFatalerror
}

pub fn responsecode_to_json(responsecode: Responsecode) -> Json {
  case responsecode {
    ResponsecodeOk -> json.string("ok")
    ResponsecodeTransienterror -> json.string("transient-error")
    ResponsecodeFatalerror -> json.string("fatal-error")
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

pub type Devicedefinitionregulatoryidentifiertype {
  DevicedefinitionregulatoryidentifiertypeBasic
  DevicedefinitionregulatoryidentifiertypeMaster
  DevicedefinitionregulatoryidentifiertypeLicense
}

pub fn devicedefinitionregulatoryidentifiertype_to_json(
  devicedefinitionregulatoryidentifiertype: Devicedefinitionregulatoryidentifiertype,
) -> Json {
  case devicedefinitionregulatoryidentifiertype {
    DevicedefinitionregulatoryidentifiertypeBasic -> json.string("basic")
    DevicedefinitionregulatoryidentifiertypeMaster -> json.string("master")
    DevicedefinitionregulatoryidentifiertypeLicense -> json.string("license")
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

pub type Paymentoutcome {
  PaymentoutcomeQueued
  PaymentoutcomeComplete
  PaymentoutcomeError
  PaymentoutcomePartial
}

pub fn paymentoutcome_to_json(paymentoutcome: Paymentoutcome) -> Json {
  case paymentoutcome {
    PaymentoutcomeQueued -> json.string("queued")
    PaymentoutcomeComplete -> json.string("complete")
    PaymentoutcomeError -> json.string("error")
    PaymentoutcomePartial -> json.string("partial")
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
  case devicedispensestatus {
    DevicedispensestatusPreparation -> json.string("preparation")
    DevicedispensestatusInprogress -> json.string("in-progress")
    DevicedispensestatusCancelled -> json.string("cancelled")
    DevicedispensestatusOnhold -> json.string("on-hold")
    DevicedispensestatusCompleted -> json.string("completed")
    DevicedispensestatusEnteredinerror -> json.string("entered-in-error")
    DevicedispensestatusStopped -> json.string("stopped")
    DevicedispensestatusDeclined -> json.string("declined")
    DevicedispensestatusUnknown -> json.string("unknown")
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
  case eventtiming {
    EventtimingMorn -> json.string("MORN")
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
    EventtimingImd -> json.string("IMD")
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

pub type Referenceversionrules {
  ReferenceversionrulesEither
  ReferenceversionrulesIndependent
  ReferenceversionrulesSpecific
}

pub fn referenceversionrules_to_json(
  referenceversionrules: Referenceversionrules,
) -> Json {
  case referenceversionrules {
    ReferenceversionrulesEither -> json.string("either")
    ReferenceversionrulesIndependent -> json.string("independent")
    ReferenceversionrulesSpecific -> json.string("specific")
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
  case clinicalusedefinitiontype {
    ClinicalusedefinitiontypeIndication -> json.string("indication")
    ClinicalusedefinitiontypeContraindication -> json.string("contraindication")
    ClinicalusedefinitiontypeInteraction -> json.string("interaction")
    ClinicalusedefinitiontypeUndesirableeffect ->
      json.string("undesirable-effect")
    ClinicalusedefinitiontypeWarning -> json.string("warning")
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
  case reportactionresultcodes {
    ReportactionresultcodesPass -> json.string("pass")
    ReportactionresultcodesSkip -> json.string("skip")
    ReportactionresultcodesFail -> json.string("fail")
    ReportactionresultcodesWarning -> json.string("warning")
    ReportactionresultcodesError -> json.string("error")
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

pub type Mapgrouptypemode {
  MapgrouptypemodeTypes
  MapgrouptypemodeTypeandtypes
}

pub fn mapgrouptypemode_to_json(mapgrouptypemode: Mapgrouptypemode) -> Json {
  case mapgrouptypemode {
    MapgrouptypemodeTypes -> json.string("types")
    MapgrouptypemodeTypeandtypes -> json.string("type-and-types")
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
  case appointmentresponsestatus {
    AppointmentresponsestatusAccepted -> json.string("accepted")
    AppointmentresponsestatusDeclined -> json.string("declined")
    AppointmentresponsestatusTentative -> json.string("tentative")
    AppointmentresponsestatusNeedsaction -> json.string("needs-action")
    AppointmentresponsestatusEnteredinerror -> json.string("entered-in-error")
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
  case permitteddatatype {
    PermitteddatatypeQuantity -> json.string("Quantity")
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

pub type Participationstatus {
  ParticipationstatusAccepted
  ParticipationstatusDeclined
  ParticipationstatusTentative
  ParticipationstatusNeedsaction
}

pub fn participationstatus_to_json(
  participationstatus: Participationstatus,
) -> Json {
  case participationstatus {
    ParticipationstatusAccepted -> json.string("accepted")
    ParticipationstatusDeclined -> json.string("declined")
    ParticipationstatusTentative -> json.string("tentative")
    ParticipationstatusNeedsaction -> json.string("needs-action")
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

pub type Permissionstatus {
  PermissionstatusActive
  PermissionstatusEnteredinerror
  PermissionstatusDraft
  PermissionstatusRejected
}

pub fn permissionstatus_to_json(permissionstatus: Permissionstatus) -> Json {
  case permissionstatus {
    PermissionstatusActive -> json.string("active")
    PermissionstatusEnteredinerror -> json.string("entered-in-error")
    PermissionstatusDraft -> json.string("draft")
    PermissionstatusRejected -> json.string("rejected")
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
  case spdxlicense {
    SpdxlicenseNotopensource -> json.string("not-open-source")
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
    SpdxlicenseBsd3clausenonuclearlicense2014 ->
      json.string("BSD-3-Clause-No-Nuclear-License-2014")
    SpdxlicenseBsd3clausenonuclearlicense ->
      json.string("BSD-3-Clause-No-Nuclear-License")
    SpdxlicenseBsd3clausenonuclearwarranty ->
      json.string("BSD-3-Clause-No-Nuclear-Warranty")
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
    SpdxlicenseCnripythongplcompatible ->
      json.string("CNRI-Python-GPL-Compatible")
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
    SpdxlicenseMpl20nocopyleftexception ->
      json.string("MPL-2.0-no-copyleft-exception")
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

pub type Metriccalibrationtype {
  MetriccalibrationtypeUnspecified
  MetriccalibrationtypeOffset
  MetriccalibrationtypeGain
  MetriccalibrationtypeTwopoint
}

pub fn metriccalibrationtype_to_json(
  metriccalibrationtype: Metriccalibrationtype,
) -> Json {
  case metriccalibrationtype {
    MetriccalibrationtypeUnspecified -> json.string("unspecified")
    MetriccalibrationtypeOffset -> json.string("offset")
    MetriccalibrationtypeGain -> json.string("gain")
    MetriccalibrationtypeTwopoint -> json.string("two-point")
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
  case medicationadminstatus {
    MedicationadminstatusInprogress -> json.string("in-progress")
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
  case episodeofcarestatus {
    EpisodeofcarestatusPlanned -> json.string("planned")
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

pub type Addresstype {
  AddresstypePostal
  AddresstypePhysical
  AddresstypeBoth
}

pub fn addresstype_to_json(addresstype: Addresstype) -> Json {
  case addresstype {
    AddresstypePostal -> json.string("postal")
    AddresstypePhysical -> json.string("physical")
    AddresstypeBoth -> json.string("both")
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

pub type Allergyintolerancecategory {
  AllergyintolerancecategoryFood
  AllergyintolerancecategoryMedication
  AllergyintolerancecategoryEnvironment
  AllergyintolerancecategoryBiologic
}

pub fn allergyintolerancecategory_to_json(
  allergyintolerancecategory: Allergyintolerancecategory,
) -> Json {
  case allergyintolerancecategory {
    AllergyintolerancecategoryFood -> json.string("food")
    AllergyintolerancecategoryMedication -> json.string("medication")
    AllergyintolerancecategoryEnvironment -> json.string("environment")
    AllergyintolerancecategoryBiologic -> json.string("biologic")
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

pub type Nutritionproductstatus {
  NutritionproductstatusActive
  NutritionproductstatusInactive
  NutritionproductstatusEnteredinerror
}

pub fn nutritionproductstatus_to_json(
  nutritionproductstatus: Nutritionproductstatus,
) -> Json {
  case nutritionproductstatus {
    NutritionproductstatusActive -> json.string("active")
    NutritionproductstatusInactive -> json.string("inactive")
    NutritionproductstatusEnteredinerror -> json.string("entered-in-error")
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

pub type Reportstatuscodes {
  ReportstatuscodesCompleted
  ReportstatuscodesInprogress
  ReportstatuscodesWaiting
  ReportstatuscodesStopped
  ReportstatuscodesEnteredinerror
}

pub fn reportstatuscodes_to_json(reportstatuscodes: Reportstatuscodes) -> Json {
  case reportstatuscodes {
    ReportstatuscodesCompleted -> json.string("completed")
    ReportstatuscodesInprogress -> json.string("in-progress")
    ReportstatuscodesWaiting -> json.string("waiting")
    ReportstatuscodesStopped -> json.string("stopped")
    ReportstatuscodesEnteredinerror -> json.string("entered-in-error")
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

pub type Resourceslicingrules {
  ResourceslicingrulesClosed
  ResourceslicingrulesOpen
  ResourceslicingrulesOpenatend
}

pub fn resourceslicingrules_to_json(
  resourceslicingrules: Resourceslicingrules,
) -> Json {
  case resourceslicingrules {
    ResourceslicingrulesClosed -> json.string("closed")
    ResourceslicingrulesOpen -> json.string("open")
    ResourceslicingrulesOpenatend -> json.string("openAtEnd")
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

pub type Contactpointuse {
  ContactpointuseHome
  ContactpointuseWork
  ContactpointuseTemp
  ContactpointuseOld
  ContactpointuseMobile
}

pub fn contactpointuse_to_json(contactpointuse: Contactpointuse) -> Json {
  case contactpointuse {
    ContactpointuseHome -> json.string("home")
    ContactpointuseWork -> json.string("work")
    ContactpointuseTemp -> json.string("temp")
    ContactpointuseOld -> json.string("old")
    ContactpointuseMobile -> json.string("mobile")
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
  case conceptpropertytype {
    ConceptpropertytypeCode -> json.string("code")
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
  case typerestfulinteraction {
    TyperestfulinteractionRead -> json.string("read")
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
  case nameuse {
    NameuseUsual -> json.string("usual")
    NameuseOfficial -> json.string("official")
    NameuseTemp -> json.string("temp")
    NameuseNickname -> json.string("nickname")
    NameuseAnonymous -> json.string("anonymous")
    NameuseOld -> json.string("old")
    NameuseMaiden -> json.string("maiden")
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

pub type Eventcapabilitymode {
  EventcapabilitymodeSender
  EventcapabilitymodeReceiver
}

pub fn eventcapabilitymode_to_json(
  eventcapabilitymode: Eventcapabilitymode,
) -> Json {
  case eventcapabilitymode {
    EventcapabilitymodeSender -> json.string("sender")
    EventcapabilitymodeReceiver -> json.string("receiver")
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

pub type Sortdirection {
  SortdirectionAscending
  SortdirectionDescending
}

pub fn sortdirection_to_json(sortdirection: Sortdirection) -> Json {
  case sortdirection {
    SortdirectionAscending -> json.string("ascending")
    SortdirectionDescending -> json.string("descending")
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

pub type Systemrestfulinteraction {
  SystemrestfulinteractionTransaction
  SystemrestfulinteractionBatch
  SystemrestfulinteractionSearchsystem
  SystemrestfulinteractionHistorysystem
}

pub fn systemrestfulinteraction_to_json(
  systemrestfulinteraction: Systemrestfulinteraction,
) -> Json {
  case systemrestfulinteraction {
    SystemrestfulinteractionTransaction -> json.string("transaction")
    SystemrestfulinteractionBatch -> json.string("batch")
    SystemrestfulinteractionSearchsystem -> json.string("search-system")
    SystemrestfulinteractionHistorysystem -> json.string("history-system")
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
  case udientrytype {
    UdientrytypeBarcode -> json.string("barcode")
    UdientrytypeRfid -> json.string("rfid")
    UdientrytypeManual -> json.string("manual")
    UdientrytypeCard -> json.string("card")
    UdientrytypeSelfreported -> json.string("self-reported")
    UdientrytypeElectronictransmission -> json.string("electronic-transmission")
    UdientrytypeUnknown -> json.string("unknown")
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

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
