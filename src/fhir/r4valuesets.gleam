pub type Conditionaldeletestatus {
  ConditionaldeletestatusMultiple
  ConditionaldeletestatusSingle
  ConditionaldeletestatusNotsupported
}

pub fn conditionaldeletestatus_to_json(
  conditionaldeletestatus: Conditionaldeletestatus,
) -> Json {
  case conditionaldeletestatus {
    ConditionaldeletestatusMultiple -> json.string("multiple")
    ConditionaldeletestatusSingle -> json.string("single")
    ConditionaldeletestatusNotsupported -> json.string("not-supported")
  }
}

pub fn conditionaldeletestatus_decoder() -> Decoder(Conditionaldeletestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "multiple" -> decode.success(ConditionaldeletestatusMultiple)
    "single" -> decode.success(ConditionaldeletestatusSingle)
    "not-supported" -> decode.success(ConditionaldeletestatusNotsupported)
    _ ->
      decode.failure(ConditionaldeletestatusMultiple, "Conditionaldeletestatus")
  }
}

pub type Namingsystemtype {
  NamingsystemtypeRoot
  NamingsystemtypeIdentifier
  NamingsystemtypeCodesystem
}

pub fn namingsystemtype_to_json(namingsystemtype: Namingsystemtype) -> Json {
  case namingsystemtype {
    NamingsystemtypeRoot -> json.string("root")
    NamingsystemtypeIdentifier -> json.string("identifier")
    NamingsystemtypeCodesystem -> json.string("codesystem")
  }
}

pub fn namingsystemtype_decoder() -> Decoder(Namingsystemtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "root" -> decode.success(NamingsystemtypeRoot)
    "identifier" -> decode.success(NamingsystemtypeIdentifier)
    "codesystem" -> decode.success(NamingsystemtypeCodesystem)
    _ -> decode.failure(NamingsystemtypeRoot, "Namingsystemtype")
  }
}

pub type Encounterlocationstatus {
  EncounterlocationstatusCompleted
  EncounterlocationstatusReserved
  EncounterlocationstatusActive
  EncounterlocationstatusPlanned
}

pub fn encounterlocationstatus_to_json(
  encounterlocationstatus: Encounterlocationstatus,
) -> Json {
  case encounterlocationstatus {
    EncounterlocationstatusCompleted -> json.string("completed")
    EncounterlocationstatusReserved -> json.string("reserved")
    EncounterlocationstatusActive -> json.string("active")
    EncounterlocationstatusPlanned -> json.string("planned")
  }
}

pub fn encounterlocationstatus_decoder() -> Decoder(Encounterlocationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "completed" -> decode.success(EncounterlocationstatusCompleted)
    "reserved" -> decode.success(EncounterlocationstatusReserved)
    "active" -> decode.success(EncounterlocationstatusActive)
    "planned" -> decode.success(EncounterlocationstatusPlanned)
    _ ->
      decode.failure(
        EncounterlocationstatusCompleted,
        "Encounterlocationstatus",
      )
  }
}

pub type Resourceaggregationmode {
  ResourceaggregationmodeReferenced
  ResourceaggregationmodeContained
  ResourceaggregationmodeBundled
}

pub fn resourceaggregationmode_to_json(
  resourceaggregationmode: Resourceaggregationmode,
) -> Json {
  case resourceaggregationmode {
    ResourceaggregationmodeReferenced -> json.string("referenced")
    ResourceaggregationmodeContained -> json.string("contained")
    ResourceaggregationmodeBundled -> json.string("bundled")
  }
}

pub fn resourceaggregationmode_decoder() -> Decoder(Resourceaggregationmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "referenced" -> decode.success(ResourceaggregationmodeReferenced)
    "contained" -> decode.success(ResourceaggregationmodeContained)
    "bundled" -> decode.success(ResourceaggregationmodeBundled)
    _ ->
      decode.failure(
        ResourceaggregationmodeReferenced,
        "Resourceaggregationmode",
      )
  }
}

pub type Variabletype {
  VariabletypeDescriptive
  VariabletypeContinuous
  VariabletypeDichotomous
}

pub fn variabletype_to_json(variabletype: Variabletype) -> Json {
  case variabletype {
    VariabletypeDescriptive -> json.string("descriptive")
    VariabletypeContinuous -> json.string("continuous")
    VariabletypeDichotomous -> json.string("dichotomous")
  }
}

pub fn variabletype_decoder() -> Decoder(Variabletype) {
  use variant <- decode.then(decode.string)
  case variant {
    "descriptive" -> decode.success(VariabletypeDescriptive)
    "continuous" -> decode.success(VariabletypeContinuous)
    "dichotomous" -> decode.success(VariabletypeDichotomous)
    _ -> decode.failure(VariabletypeDescriptive, "Variabletype")
  }
}

pub type Relationtype {
  RelationtypeIsreplacedby
  RelationtypeTriggers
}

pub fn relationtype_to_json(relationtype: Relationtype) -> Json {
  case relationtype {
    RelationtypeIsreplacedby -> json.string("is-replaced-by")
    RelationtypeTriggers -> json.string("triggers")
  }
}

pub fn relationtype_decoder() -> Decoder(Relationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "is-replaced-by" -> decode.success(RelationtypeIsreplacedby)
    "triggers" -> decode.success(RelationtypeTriggers)
    _ -> decode.failure(RelationtypeIsreplacedby, "Relationtype")
  }
}

pub type Structuredefinitionkind {
  StructuredefinitionkindLogical
  StructuredefinitionkindResource
  StructuredefinitionkindComplextype
  StructuredefinitionkindPrimitivetype
}

pub fn structuredefinitionkind_to_json(
  structuredefinitionkind: Structuredefinitionkind,
) -> Json {
  case structuredefinitionkind {
    StructuredefinitionkindLogical -> json.string("logical")
    StructuredefinitionkindResource -> json.string("resource")
    StructuredefinitionkindComplextype -> json.string("complex-type")
    StructuredefinitionkindPrimitivetype -> json.string("primitive-type")
  }
}

pub fn structuredefinitionkind_decoder() -> Decoder(Structuredefinitionkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "logical" -> decode.success(StructuredefinitionkindLogical)
    "resource" -> decode.success(StructuredefinitionkindResource)
    "complex-type" -> decode.success(StructuredefinitionkindComplextype)
    "primitive-type" -> decode.success(StructuredefinitionkindPrimitivetype)
    _ ->
      decode.failure(StructuredefinitionkindLogical, "Structuredefinitionkind")
  }
}

pub type Locationstatus {
  LocationstatusInactive
  LocationstatusSuspended
  LocationstatusActive
}

pub fn locationstatus_to_json(locationstatus: Locationstatus) -> Json {
  case locationstatus {
    LocationstatusInactive -> json.string("inactive")
    LocationstatusSuspended -> json.string("suspended")
    LocationstatusActive -> json.string("active")
  }
}

pub fn locationstatus_decoder() -> Decoder(Locationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "inactive" -> decode.success(LocationstatusInactive)
    "suspended" -> decode.success(LocationstatusSuspended)
    "active" -> decode.success(LocationstatusActive)
    _ -> decode.failure(LocationstatusInactive, "Locationstatus")
  }
}

pub type Invoicestatus {
  InvoicestatusEnteredinerror
  InvoicestatusCancelled
  InvoicestatusBalanced
  InvoicestatusIssued
  InvoicestatusDraft
}

pub fn invoicestatus_to_json(invoicestatus: Invoicestatus) -> Json {
  case invoicestatus {
    InvoicestatusEnteredinerror -> json.string("entered-in-error")
    InvoicestatusCancelled -> json.string("cancelled")
    InvoicestatusBalanced -> json.string("balanced")
    InvoicestatusIssued -> json.string("issued")
    InvoicestatusDraft -> json.string("draft")
  }
}

pub fn invoicestatus_decoder() -> Decoder(Invoicestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(InvoicestatusEnteredinerror)
    "cancelled" -> decode.success(InvoicestatusCancelled)
    "balanced" -> decode.success(InvoicestatusBalanced)
    "issued" -> decode.success(InvoicestatusIssued)
    "draft" -> decode.success(InvoicestatusDraft)
    _ -> decode.failure(InvoicestatusEnteredinerror, "Invoicestatus")
  }
}

pub type Quantitycomparator {
  QuantitycomparatorGreaterthan
  QuantitycomparatorGreaterthanequal
  QuantitycomparatorLessthanequal
  QuantitycomparatorLessthan
}

pub fn quantitycomparator_to_json(
  quantitycomparator: Quantitycomparator,
) -> Json {
  case quantitycomparator {
    QuantitycomparatorGreaterthan -> json.string(">")
    QuantitycomparatorGreaterthanequal -> json.string(">=")
    QuantitycomparatorLessthanequal -> json.string("<=")
    QuantitycomparatorLessthan -> json.string("<")
  }
}

pub fn quantitycomparator_decoder() -> Decoder(Quantitycomparator) {
  use variant <- decode.then(decode.string)
  case variant {
    ">" -> decode.success(QuantitycomparatorGreaterthan)
    ">=" -> decode.success(QuantitycomparatorGreaterthanequal)
    "<=" -> decode.success(QuantitycomparatorLessthanequal)
    "<" -> decode.success(QuantitycomparatorLessthan)
    _ -> decode.failure(QuantitycomparatorGreaterthan, "Quantitycomparator")
  }
}

pub type Reportresultcodes {
  ReportresultcodesPending
  ReportresultcodesFail
  ReportresultcodesPass
}

pub fn reportresultcodes_to_json(reportresultcodes: Reportresultcodes) -> Json {
  case reportresultcodes {
    ReportresultcodesPending -> json.string("pending")
    ReportresultcodesFail -> json.string("fail")
    ReportresultcodesPass -> json.string("pass")
  }
}

pub fn reportresultcodes_decoder() -> Decoder(Reportresultcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "pending" -> decode.success(ReportresultcodesPending)
    "fail" -> decode.success(ReportresultcodesFail)
    "pass" -> decode.success(ReportresultcodesPass)
    _ -> decode.failure(ReportresultcodesPending, "Reportresultcodes")
  }
}

pub type Operationparameteruse {
  OperationparameteruseOut
  OperationparameteruseIn
}

pub fn operationparameteruse_to_json(
  operationparameteruse: Operationparameteruse,
) -> Json {
  case operationparameteruse {
    OperationparameteruseOut -> json.string("out")
    OperationparameteruseIn -> json.string("in")
  }
}

pub fn operationparameteruse_decoder() -> Decoder(Operationparameteruse) {
  use variant <- decode.then(decode.string)
  case variant {
    "out" -> decode.success(OperationparameteruseOut)
    "in" -> decode.success(OperationparameteruseIn)
    _ -> decode.failure(OperationparameteruseOut, "Operationparameteruse")
  }
}

pub type Substancestatus {
  SubstancestatusEnteredinerror
  SubstancestatusInactive
  SubstancestatusActive
}

pub fn substancestatus_to_json(substancestatus: Substancestatus) -> Json {
  case substancestatus {
    SubstancestatusEnteredinerror -> json.string("entered-in-error")
    SubstancestatusInactive -> json.string("inactive")
    SubstancestatusActive -> json.string("active")
  }
}

pub fn substancestatus_decoder() -> Decoder(Substancestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(SubstancestatusEnteredinerror)
    "inactive" -> decode.success(SubstancestatusInactive)
    "active" -> decode.success(SubstancestatusActive)
    _ -> decode.failure(SubstancestatusEnteredinerror, "Substancestatus")
  }
}

pub type Researchstudystatus {
  ResearchstudystatusWithdrawn
  ResearchstudystatusTemporarilyclosedtoaccrualandintervention
  ResearchstudystatusTemporarilyclosedtoaccrual
  ResearchstudystatusInreview
  ResearchstudystatusDisapproved
  ResearchstudystatusCompleted
  ResearchstudystatusClosedtoaccrualandintervention
  ResearchstudystatusClosedtoaccrual
  ResearchstudystatusApproved
  ResearchstudystatusAdministrativelycompleted
  ResearchstudystatusActive
}

pub fn researchstudystatus_to_json(
  researchstudystatus: Researchstudystatus,
) -> Json {
  case researchstudystatus {
    ResearchstudystatusWithdrawn -> json.string("withdrawn")
    ResearchstudystatusTemporarilyclosedtoaccrualandintervention ->
      json.string("temporarily-closed-to-accrual-and-intervention")
    ResearchstudystatusTemporarilyclosedtoaccrual ->
      json.string("temporarily-closed-to-accrual")
    ResearchstudystatusInreview -> json.string("in-review")
    ResearchstudystatusDisapproved -> json.string("disapproved")
    ResearchstudystatusCompleted -> json.string("completed")
    ResearchstudystatusClosedtoaccrualandintervention ->
      json.string("closed-to-accrual-and-intervention")
    ResearchstudystatusClosedtoaccrual -> json.string("closed-to-accrual")
    ResearchstudystatusApproved -> json.string("approved")
    ResearchstudystatusAdministrativelycompleted ->
      json.string("administratively-completed")
    ResearchstudystatusActive -> json.string("active")
  }
}

pub fn researchstudystatus_decoder() -> Decoder(Researchstudystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "withdrawn" -> decode.success(ResearchstudystatusWithdrawn)
    "temporarily-closed-to-accrual-and-intervention" ->
      decode.success(
        ResearchstudystatusTemporarilyclosedtoaccrualandintervention,
      )
    "temporarily-closed-to-accrual" ->
      decode.success(ResearchstudystatusTemporarilyclosedtoaccrual)
    "in-review" -> decode.success(ResearchstudystatusInreview)
    "disapproved" -> decode.success(ResearchstudystatusDisapproved)
    "completed" -> decode.success(ResearchstudystatusCompleted)
    "closed-to-accrual-and-intervention" ->
      decode.success(ResearchstudystatusClosedtoaccrualandintervention)
    "closed-to-accrual" -> decode.success(ResearchstudystatusClosedtoaccrual)
    "approved" -> decode.success(ResearchstudystatusApproved)
    "administratively-completed" ->
      decode.success(ResearchstudystatusAdministrativelycompleted)
    "active" -> decode.success(ResearchstudystatusActive)
    _ -> decode.failure(ResearchstudystatusWithdrawn, "Researchstudystatus")
  }
}

pub type Unitsoftime {
  UnitsoftimeA
  UnitsoftimeMo
  UnitsoftimeWk
  UnitsoftimeD
  UnitsoftimeH
  UnitsoftimeMin
  UnitsoftimeS
}

pub fn unitsoftime_to_json(unitsoftime: Unitsoftime) -> Json {
  case unitsoftime {
    UnitsoftimeA -> json.string("a")
    UnitsoftimeMo -> json.string("mo")
    UnitsoftimeWk -> json.string("wk")
    UnitsoftimeD -> json.string("d")
    UnitsoftimeH -> json.string("h")
    UnitsoftimeMin -> json.string("min")
    UnitsoftimeS -> json.string("s")
  }
}

pub fn unitsoftime_decoder() -> Decoder(Unitsoftime) {
  use variant <- decode.then(decode.string)
  case variant {
    "a" -> decode.success(UnitsoftimeA)
    "mo" -> decode.success(UnitsoftimeMo)
    "wk" -> decode.success(UnitsoftimeWk)
    "d" -> decode.success(UnitsoftimeD)
    "h" -> decode.success(UnitsoftimeH)
    "min" -> decode.success(UnitsoftimeMin)
    "s" -> decode.success(UnitsoftimeS)
    _ -> decode.failure(UnitsoftimeA, "Unitsoftime")
  }
}

pub type Searchxpathusage {
  SearchxpathusageOther
  SearchxpathusageDistance
  SearchxpathusageNearby
  SearchxpathusagePhonetic
  SearchxpathusageNormal
}

pub fn searchxpathusage_to_json(searchxpathusage: Searchxpathusage) -> Json {
  case searchxpathusage {
    SearchxpathusageOther -> json.string("other")
    SearchxpathusageDistance -> json.string("distance")
    SearchxpathusageNearby -> json.string("nearby")
    SearchxpathusagePhonetic -> json.string("phonetic")
    SearchxpathusageNormal -> json.string("normal")
  }
}

pub fn searchxpathusage_decoder() -> Decoder(Searchxpathusage) {
  use variant <- decode.then(decode.string)
  case variant {
    "other" -> decode.success(SearchxpathusageOther)
    "distance" -> decode.success(SearchxpathusageDistance)
    "nearby" -> decode.success(SearchxpathusageNearby)
    "phonetic" -> decode.success(SearchxpathusagePhonetic)
    "normal" -> decode.success(SearchxpathusageNormal)
    _ -> decode.failure(SearchxpathusageOther, "Searchxpathusage")
  }
}

pub type Careteamstatus {
  CareteamstatusEnteredinerror
  CareteamstatusInactive
  CareteamstatusSuspended
  CareteamstatusActive
  CareteamstatusProposed
}

pub fn careteamstatus_to_json(careteamstatus: Careteamstatus) -> Json {
  case careteamstatus {
    CareteamstatusEnteredinerror -> json.string("entered-in-error")
    CareteamstatusInactive -> json.string("inactive")
    CareteamstatusSuspended -> json.string("suspended")
    CareteamstatusActive -> json.string("active")
    CareteamstatusProposed -> json.string("proposed")
  }
}

pub fn careteamstatus_decoder() -> Decoder(Careteamstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(CareteamstatusEnteredinerror)
    "inactive" -> decode.success(CareteamstatusInactive)
    "suspended" -> decode.success(CareteamstatusSuspended)
    "active" -> decode.success(CareteamstatusActive)
    "proposed" -> decode.success(CareteamstatusProposed)
    _ -> decode.failure(CareteamstatusEnteredinerror, "Careteamstatus")
  }
}

pub type Clinicalimpressionstatus {
  ClinicalimpressionstatusUnknown
  ClinicalimpressionstatusEnteredinerror
  ClinicalimpressionstatusCompleted
  ClinicalimpressionstatusStopped
  ClinicalimpressionstatusOnhold
  ClinicalimpressionstatusNotdone
  ClinicalimpressionstatusInprogress
  ClinicalimpressionstatusPreparation
}

pub fn clinicalimpressionstatus_to_json(
  clinicalimpressionstatus: Clinicalimpressionstatus,
) -> Json {
  case clinicalimpressionstatus {
    ClinicalimpressionstatusUnknown -> json.string("unknown")
    ClinicalimpressionstatusEnteredinerror -> json.string("entered-in-error")
    ClinicalimpressionstatusCompleted -> json.string("completed")
    ClinicalimpressionstatusStopped -> json.string("stopped")
    ClinicalimpressionstatusOnhold -> json.string("on-hold")
    ClinicalimpressionstatusNotdone -> json.string("not-done")
    ClinicalimpressionstatusInprogress -> json.string("in-progress")
    ClinicalimpressionstatusPreparation -> json.string("preparation")
  }
}

pub fn clinicalimpressionstatus_decoder() -> Decoder(Clinicalimpressionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ClinicalimpressionstatusUnknown)
    "entered-in-error" -> decode.success(ClinicalimpressionstatusEnteredinerror)
    "completed" -> decode.success(ClinicalimpressionstatusCompleted)
    "stopped" -> decode.success(ClinicalimpressionstatusStopped)
    "on-hold" -> decode.success(ClinicalimpressionstatusOnhold)
    "not-done" -> decode.success(ClinicalimpressionstatusNotdone)
    "in-progress" -> decode.success(ClinicalimpressionstatusInprogress)
    "preparation" -> decode.success(ClinicalimpressionstatusPreparation)
    _ ->
      decode.failure(
        ClinicalimpressionstatusUnknown,
        "Clinicalimpressionstatus",
      )
  }
}

pub type Compositionstatus {
  CompositionstatusEnteredinerror
  CompositionstatusAmended
  CompositionstatusFinal
  CompositionstatusPreliminary
}

pub fn compositionstatus_to_json(compositionstatus: Compositionstatus) -> Json {
  case compositionstatus {
    CompositionstatusEnteredinerror -> json.string("entered-in-error")
    CompositionstatusAmended -> json.string("amended")
    CompositionstatusFinal -> json.string("final")
    CompositionstatusPreliminary -> json.string("preliminary")
  }
}

pub fn compositionstatus_decoder() -> Decoder(Compositionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(CompositionstatusEnteredinerror)
    "amended" -> decode.success(CompositionstatusAmended)
    "final" -> decode.success(CompositionstatusFinal)
    "preliminary" -> decode.success(CompositionstatusPreliminary)
    _ -> decode.failure(CompositionstatusEnteredinerror, "Compositionstatus")
  }
}

pub type Chargeitemstatus {
  ChargeitemstatusUnknown
  ChargeitemstatusEnteredinerror
  ChargeitemstatusBilled
  ChargeitemstatusAborted
  ChargeitemstatusNotbillable
  ChargeitemstatusBillable
  ChargeitemstatusPlanned
}

pub fn chargeitemstatus_to_json(chargeitemstatus: Chargeitemstatus) -> Json {
  case chargeitemstatus {
    ChargeitemstatusUnknown -> json.string("unknown")
    ChargeitemstatusEnteredinerror -> json.string("entered-in-error")
    ChargeitemstatusBilled -> json.string("billed")
    ChargeitemstatusAborted -> json.string("aborted")
    ChargeitemstatusNotbillable -> json.string("not-billable")
    ChargeitemstatusBillable -> json.string("billable")
    ChargeitemstatusPlanned -> json.string("planned")
  }
}

pub fn chargeitemstatus_decoder() -> Decoder(Chargeitemstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ChargeitemstatusUnknown)
    "entered-in-error" -> decode.success(ChargeitemstatusEnteredinerror)
    "billed" -> decode.success(ChargeitemstatusBilled)
    "aborted" -> decode.success(ChargeitemstatusAborted)
    "not-billable" -> decode.success(ChargeitemstatusNotbillable)
    "billable" -> decode.success(ChargeitemstatusBillable)
    "planned" -> decode.success(ChargeitemstatusPlanned)
    _ -> decode.failure(ChargeitemstatusUnknown, "Chargeitemstatus")
  }
}

pub type Resourcetypes {
  ResourcetypesVisionprescription
  ResourcetypesVerificationresult
  ResourcetypesValueset
  ResourcetypesTestscript
  ResourcetypesTestreport
  ResourcetypesTerminologycapabilities
  ResourcetypesTask
  ResourcetypesSupplyrequest
  ResourcetypesSupplydelivery
  ResourcetypesSubstancespecification
  ResourcetypesSubstancesourcematerial
  ResourcetypesSubstancereferenceinformation
  ResourcetypesSubstanceprotein
  ResourcetypesSubstancepolymer
  ResourcetypesSubstancenucleicacid
  ResourcetypesSubstance
  ResourcetypesSubscription
  ResourcetypesStructuremap
  ResourcetypesStructuredefinition
  ResourcetypesSpecimendefinition
  ResourcetypesSpecimen
  ResourcetypesSlot
  ResourcetypesServicerequest
  ResourcetypesSearchparameter
  ResourcetypesSchedule
  ResourcetypesRiskevidencesynthesis
  ResourcetypesRiskassessment
  ResourcetypesResource
  ResourcetypesResearchsubject
  ResourcetypesResearchstudy
  ResourcetypesResearchelementdefinition
  ResourcetypesResearchdefinition
  ResourcetypesRequestgroup
  ResourcetypesRelatedperson
  ResourcetypesQuestionnaireresponse
  ResourcetypesQuestionnaire
  ResourcetypesProvenance
  ResourcetypesProcedure
  ResourcetypesPractitionerrole
  ResourcetypesPractitioner
  ResourcetypesPlandefinition
  ResourcetypesPerson
  ResourcetypesPaymentreconciliation
  ResourcetypesPaymentnotice
  ResourcetypesPatient
  ResourcetypesParameters
  ResourcetypesOrganizationaffiliation
  ResourcetypesOrganization
  ResourcetypesOperationoutcome
  ResourcetypesOperationdefinition
  ResourcetypesObservationdefinition
  ResourcetypesObservation
  ResourcetypesNutritionorder
  ResourcetypesNamingsystem
  ResourcetypesMolecularsequence
  ResourcetypesMessageheader
  ResourcetypesMessagedefinition
  ResourcetypesMedicinalproductundesirableeffect
  ResourcetypesMedicinalproductpharmaceutical
  ResourcetypesMedicinalproductpackaged
  ResourcetypesMedicinalproductmanufactured
  ResourcetypesMedicinalproductinteraction
  ResourcetypesMedicinalproductingredient
  ResourcetypesMedicinalproductindication
  ResourcetypesMedicinalproductcontraindication
  ResourcetypesMedicinalproductauthorization
  ResourcetypesMedicinalproduct
  ResourcetypesMedicationstatement
  ResourcetypesMedicationrequest
  ResourcetypesMedicationknowledge
  ResourcetypesMedicationdispense
  ResourcetypesMedicationadministration
  ResourcetypesMedication
  ResourcetypesMedia
  ResourcetypesMeasurereport
  ResourcetypesMeasure
  ResourcetypesLocation
  ResourcetypesList
  ResourcetypesLinkage
  ResourcetypesLibrary
  ResourcetypesInvoice
  ResourcetypesInsuranceplan
  ResourcetypesImplementationguide
  ResourcetypesImmunizationrecommendation
  ResourcetypesImmunizationevaluation
  ResourcetypesImmunization
  ResourcetypesImagingstudy
  ResourcetypesHealthcareservice
  ResourcetypesGuidanceresponse
  ResourcetypesGroup
  ResourcetypesGraphdefinition
  ResourcetypesGoal
  ResourcetypesFlag
  ResourcetypesFamilymemberhistory
  ResourcetypesExplanationofbenefit
  ResourcetypesExamplescenario
  ResourcetypesEvidencevariable
  ResourcetypesEvidence
  ResourcetypesEventdefinition
  ResourcetypesEpisodeofcare
  ResourcetypesEnrollmentresponse
  ResourcetypesEnrollmentrequest
  ResourcetypesEndpoint
  ResourcetypesEncounter
  ResourcetypesEffectevidencesynthesis
  ResourcetypesDomainresource
  ResourcetypesDocumentreference
  ResourcetypesDocumentmanifest
  ResourcetypesDiagnosticreport
  ResourcetypesDeviceusestatement
  ResourcetypesDevicerequest
  ResourcetypesDevicemetric
  ResourcetypesDevicedefinition
  ResourcetypesDevice
  ResourcetypesDetectedissue
  ResourcetypesCoverageeligibilityresponse
  ResourcetypesCoverageeligibilityrequest
  ResourcetypesCoverage
  ResourcetypesContract
  ResourcetypesConsent
  ResourcetypesCondition
  ResourcetypesConceptmap
  ResourcetypesComposition
  ResourcetypesCompartmentdefinition
  ResourcetypesCommunicationrequest
  ResourcetypesCommunication
  ResourcetypesCodesystem
  ResourcetypesClinicalimpression
  ResourcetypesClaimresponse
  ResourcetypesClaim
  ResourcetypesChargeitemdefinition
  ResourcetypesChargeitem
  ResourcetypesCatalogentry
  ResourcetypesCareteam
  ResourcetypesCareplan
  ResourcetypesCapabilitystatement
  ResourcetypesBundle
  ResourcetypesBodystructure
  ResourcetypesBiologicallyderivedproduct
  ResourcetypesBinary
  ResourcetypesBasic
  ResourcetypesAuditevent
  ResourcetypesAppointmentresponse
  ResourcetypesAppointment
  ResourcetypesAllergyintolerance
  ResourcetypesAdverseevent
  ResourcetypesActivitydefinition
  ResourcetypesAccount
}

pub fn resourcetypes_to_json(resourcetypes: Resourcetypes) -> Json {
  case resourcetypes {
    ResourcetypesVisionprescription -> json.string("VisionPrescription")
    ResourcetypesVerificationresult -> json.string("VerificationResult")
    ResourcetypesValueset -> json.string("ValueSet")
    ResourcetypesTestscript -> json.string("TestScript")
    ResourcetypesTestreport -> json.string("TestReport")
    ResourcetypesTerminologycapabilities ->
      json.string("TerminologyCapabilities")
    ResourcetypesTask -> json.string("Task")
    ResourcetypesSupplyrequest -> json.string("SupplyRequest")
    ResourcetypesSupplydelivery -> json.string("SupplyDelivery")
    ResourcetypesSubstancespecification -> json.string("SubstanceSpecification")
    ResourcetypesSubstancesourcematerial ->
      json.string("SubstanceSourceMaterial")
    ResourcetypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    ResourcetypesSubstanceprotein -> json.string("SubstanceProtein")
    ResourcetypesSubstancepolymer -> json.string("SubstancePolymer")
    ResourcetypesSubstancenucleicacid -> json.string("SubstanceNucleicAcid")
    ResourcetypesSubstance -> json.string("Substance")
    ResourcetypesSubscription -> json.string("Subscription")
    ResourcetypesStructuremap -> json.string("StructureMap")
    ResourcetypesStructuredefinition -> json.string("StructureDefinition")
    ResourcetypesSpecimendefinition -> json.string("SpecimenDefinition")
    ResourcetypesSpecimen -> json.string("Specimen")
    ResourcetypesSlot -> json.string("Slot")
    ResourcetypesServicerequest -> json.string("ServiceRequest")
    ResourcetypesSearchparameter -> json.string("SearchParameter")
    ResourcetypesSchedule -> json.string("Schedule")
    ResourcetypesRiskevidencesynthesis -> json.string("RiskEvidenceSynthesis")
    ResourcetypesRiskassessment -> json.string("RiskAssessment")
    ResourcetypesResource -> json.string("Resource")
    ResourcetypesResearchsubject -> json.string("ResearchSubject")
    ResourcetypesResearchstudy -> json.string("ResearchStudy")
    ResourcetypesResearchelementdefinition ->
      json.string("ResearchElementDefinition")
    ResourcetypesResearchdefinition -> json.string("ResearchDefinition")
    ResourcetypesRequestgroup -> json.string("RequestGroup")
    ResourcetypesRelatedperson -> json.string("RelatedPerson")
    ResourcetypesQuestionnaireresponse -> json.string("QuestionnaireResponse")
    ResourcetypesQuestionnaire -> json.string("Questionnaire")
    ResourcetypesProvenance -> json.string("Provenance")
    ResourcetypesProcedure -> json.string("Procedure")
    ResourcetypesPractitionerrole -> json.string("PractitionerRole")
    ResourcetypesPractitioner -> json.string("Practitioner")
    ResourcetypesPlandefinition -> json.string("PlanDefinition")
    ResourcetypesPerson -> json.string("Person")
    ResourcetypesPaymentreconciliation -> json.string("PaymentReconciliation")
    ResourcetypesPaymentnotice -> json.string("PaymentNotice")
    ResourcetypesPatient -> json.string("Patient")
    ResourcetypesParameters -> json.string("Parameters")
    ResourcetypesOrganizationaffiliation ->
      json.string("OrganizationAffiliation")
    ResourcetypesOrganization -> json.string("Organization")
    ResourcetypesOperationoutcome -> json.string("OperationOutcome")
    ResourcetypesOperationdefinition -> json.string("OperationDefinition")
    ResourcetypesObservationdefinition -> json.string("ObservationDefinition")
    ResourcetypesObservation -> json.string("Observation")
    ResourcetypesNutritionorder -> json.string("NutritionOrder")
    ResourcetypesNamingsystem -> json.string("NamingSystem")
    ResourcetypesMolecularsequence -> json.string("MolecularSequence")
    ResourcetypesMessageheader -> json.string("MessageHeader")
    ResourcetypesMessagedefinition -> json.string("MessageDefinition")
    ResourcetypesMedicinalproductundesirableeffect ->
      json.string("MedicinalProductUndesirableEffect")
    ResourcetypesMedicinalproductpharmaceutical ->
      json.string("MedicinalProductPharmaceutical")
    ResourcetypesMedicinalproductpackaged ->
      json.string("MedicinalProductPackaged")
    ResourcetypesMedicinalproductmanufactured ->
      json.string("MedicinalProductManufactured")
    ResourcetypesMedicinalproductinteraction ->
      json.string("MedicinalProductInteraction")
    ResourcetypesMedicinalproductingredient ->
      json.string("MedicinalProductIngredient")
    ResourcetypesMedicinalproductindication ->
      json.string("MedicinalProductIndication")
    ResourcetypesMedicinalproductcontraindication ->
      json.string("MedicinalProductContraindication")
    ResourcetypesMedicinalproductauthorization ->
      json.string("MedicinalProductAuthorization")
    ResourcetypesMedicinalproduct -> json.string("MedicinalProduct")
    ResourcetypesMedicationstatement -> json.string("MedicationStatement")
    ResourcetypesMedicationrequest -> json.string("MedicationRequest")
    ResourcetypesMedicationknowledge -> json.string("MedicationKnowledge")
    ResourcetypesMedicationdispense -> json.string("MedicationDispense")
    ResourcetypesMedicationadministration ->
      json.string("MedicationAdministration")
    ResourcetypesMedication -> json.string("Medication")
    ResourcetypesMedia -> json.string("Media")
    ResourcetypesMeasurereport -> json.string("MeasureReport")
    ResourcetypesMeasure -> json.string("Measure")
    ResourcetypesLocation -> json.string("Location")
    ResourcetypesList -> json.string("List")
    ResourcetypesLinkage -> json.string("Linkage")
    ResourcetypesLibrary -> json.string("Library")
    ResourcetypesInvoice -> json.string("Invoice")
    ResourcetypesInsuranceplan -> json.string("InsurancePlan")
    ResourcetypesImplementationguide -> json.string("ImplementationGuide")
    ResourcetypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    ResourcetypesImmunizationevaluation -> json.string("ImmunizationEvaluation")
    ResourcetypesImmunization -> json.string("Immunization")
    ResourcetypesImagingstudy -> json.string("ImagingStudy")
    ResourcetypesHealthcareservice -> json.string("HealthcareService")
    ResourcetypesGuidanceresponse -> json.string("GuidanceResponse")
    ResourcetypesGroup -> json.string("Group")
    ResourcetypesGraphdefinition -> json.string("GraphDefinition")
    ResourcetypesGoal -> json.string("Goal")
    ResourcetypesFlag -> json.string("Flag")
    ResourcetypesFamilymemberhistory -> json.string("FamilyMemberHistory")
    ResourcetypesExplanationofbenefit -> json.string("ExplanationOfBenefit")
    ResourcetypesExamplescenario -> json.string("ExampleScenario")
    ResourcetypesEvidencevariable -> json.string("EvidenceVariable")
    ResourcetypesEvidence -> json.string("Evidence")
    ResourcetypesEventdefinition -> json.string("EventDefinition")
    ResourcetypesEpisodeofcare -> json.string("EpisodeOfCare")
    ResourcetypesEnrollmentresponse -> json.string("EnrollmentResponse")
    ResourcetypesEnrollmentrequest -> json.string("EnrollmentRequest")
    ResourcetypesEndpoint -> json.string("Endpoint")
    ResourcetypesEncounter -> json.string("Encounter")
    ResourcetypesEffectevidencesynthesis ->
      json.string("EffectEvidenceSynthesis")
    ResourcetypesDomainresource -> json.string("DomainResource")
    ResourcetypesDocumentreference -> json.string("DocumentReference")
    ResourcetypesDocumentmanifest -> json.string("DocumentManifest")
    ResourcetypesDiagnosticreport -> json.string("DiagnosticReport")
    ResourcetypesDeviceusestatement -> json.string("DeviceUseStatement")
    ResourcetypesDevicerequest -> json.string("DeviceRequest")
    ResourcetypesDevicemetric -> json.string("DeviceMetric")
    ResourcetypesDevicedefinition -> json.string("DeviceDefinition")
    ResourcetypesDevice -> json.string("Device")
    ResourcetypesDetectedissue -> json.string("DetectedIssue")
    ResourcetypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    ResourcetypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    ResourcetypesCoverage -> json.string("Coverage")
    ResourcetypesContract -> json.string("Contract")
    ResourcetypesConsent -> json.string("Consent")
    ResourcetypesCondition -> json.string("Condition")
    ResourcetypesConceptmap -> json.string("ConceptMap")
    ResourcetypesComposition -> json.string("Composition")
    ResourcetypesCompartmentdefinition -> json.string("CompartmentDefinition")
    ResourcetypesCommunicationrequest -> json.string("CommunicationRequest")
    ResourcetypesCommunication -> json.string("Communication")
    ResourcetypesCodesystem -> json.string("CodeSystem")
    ResourcetypesClinicalimpression -> json.string("ClinicalImpression")
    ResourcetypesClaimresponse -> json.string("ClaimResponse")
    ResourcetypesClaim -> json.string("Claim")
    ResourcetypesChargeitemdefinition -> json.string("ChargeItemDefinition")
    ResourcetypesChargeitem -> json.string("ChargeItem")
    ResourcetypesCatalogentry -> json.string("CatalogEntry")
    ResourcetypesCareteam -> json.string("CareTeam")
    ResourcetypesCareplan -> json.string("CarePlan")
    ResourcetypesCapabilitystatement -> json.string("CapabilityStatement")
    ResourcetypesBundle -> json.string("Bundle")
    ResourcetypesBodystructure -> json.string("BodyStructure")
    ResourcetypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    ResourcetypesBinary -> json.string("Binary")
    ResourcetypesBasic -> json.string("Basic")
    ResourcetypesAuditevent -> json.string("AuditEvent")
    ResourcetypesAppointmentresponse -> json.string("AppointmentResponse")
    ResourcetypesAppointment -> json.string("Appointment")
    ResourcetypesAllergyintolerance -> json.string("AllergyIntolerance")
    ResourcetypesAdverseevent -> json.string("AdverseEvent")
    ResourcetypesActivitydefinition -> json.string("ActivityDefinition")
    ResourcetypesAccount -> json.string("Account")
  }
}

pub fn resourcetypes_decoder() -> Decoder(Resourcetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "VisionPrescription" -> decode.success(ResourcetypesVisionprescription)
    "VerificationResult" -> decode.success(ResourcetypesVerificationresult)
    "ValueSet" -> decode.success(ResourcetypesValueset)
    "TestScript" -> decode.success(ResourcetypesTestscript)
    "TestReport" -> decode.success(ResourcetypesTestreport)
    "TerminologyCapabilities" ->
      decode.success(ResourcetypesTerminologycapabilities)
    "Task" -> decode.success(ResourcetypesTask)
    "SupplyRequest" -> decode.success(ResourcetypesSupplyrequest)
    "SupplyDelivery" -> decode.success(ResourcetypesSupplydelivery)
    "SubstanceSpecification" ->
      decode.success(ResourcetypesSubstancespecification)
    "SubstanceSourceMaterial" ->
      decode.success(ResourcetypesSubstancesourcematerial)
    "SubstanceReferenceInformation" ->
      decode.success(ResourcetypesSubstancereferenceinformation)
    "SubstanceProtein" -> decode.success(ResourcetypesSubstanceprotein)
    "SubstancePolymer" -> decode.success(ResourcetypesSubstancepolymer)
    "SubstanceNucleicAcid" -> decode.success(ResourcetypesSubstancenucleicacid)
    "Substance" -> decode.success(ResourcetypesSubstance)
    "Subscription" -> decode.success(ResourcetypesSubscription)
    "StructureMap" -> decode.success(ResourcetypesStructuremap)
    "StructureDefinition" -> decode.success(ResourcetypesStructuredefinition)
    "SpecimenDefinition" -> decode.success(ResourcetypesSpecimendefinition)
    "Specimen" -> decode.success(ResourcetypesSpecimen)
    "Slot" -> decode.success(ResourcetypesSlot)
    "ServiceRequest" -> decode.success(ResourcetypesServicerequest)
    "SearchParameter" -> decode.success(ResourcetypesSearchparameter)
    "Schedule" -> decode.success(ResourcetypesSchedule)
    "RiskEvidenceSynthesis" ->
      decode.success(ResourcetypesRiskevidencesynthesis)
    "RiskAssessment" -> decode.success(ResourcetypesRiskassessment)
    "Resource" -> decode.success(ResourcetypesResource)
    "ResearchSubject" -> decode.success(ResourcetypesResearchsubject)
    "ResearchStudy" -> decode.success(ResourcetypesResearchstudy)
    "ResearchElementDefinition" ->
      decode.success(ResourcetypesResearchelementdefinition)
    "ResearchDefinition" -> decode.success(ResourcetypesResearchdefinition)
    "RequestGroup" -> decode.success(ResourcetypesRequestgroup)
    "RelatedPerson" -> decode.success(ResourcetypesRelatedperson)
    "QuestionnaireResponse" ->
      decode.success(ResourcetypesQuestionnaireresponse)
    "Questionnaire" -> decode.success(ResourcetypesQuestionnaire)
    "Provenance" -> decode.success(ResourcetypesProvenance)
    "Procedure" -> decode.success(ResourcetypesProcedure)
    "PractitionerRole" -> decode.success(ResourcetypesPractitionerrole)
    "Practitioner" -> decode.success(ResourcetypesPractitioner)
    "PlanDefinition" -> decode.success(ResourcetypesPlandefinition)
    "Person" -> decode.success(ResourcetypesPerson)
    "PaymentReconciliation" ->
      decode.success(ResourcetypesPaymentreconciliation)
    "PaymentNotice" -> decode.success(ResourcetypesPaymentnotice)
    "Patient" -> decode.success(ResourcetypesPatient)
    "Parameters" -> decode.success(ResourcetypesParameters)
    "OrganizationAffiliation" ->
      decode.success(ResourcetypesOrganizationaffiliation)
    "Organization" -> decode.success(ResourcetypesOrganization)
    "OperationOutcome" -> decode.success(ResourcetypesOperationoutcome)
    "OperationDefinition" -> decode.success(ResourcetypesOperationdefinition)
    "ObservationDefinition" ->
      decode.success(ResourcetypesObservationdefinition)
    "Observation" -> decode.success(ResourcetypesObservation)
    "NutritionOrder" -> decode.success(ResourcetypesNutritionorder)
    "NamingSystem" -> decode.success(ResourcetypesNamingsystem)
    "MolecularSequence" -> decode.success(ResourcetypesMolecularsequence)
    "MessageHeader" -> decode.success(ResourcetypesMessageheader)
    "MessageDefinition" -> decode.success(ResourcetypesMessagedefinition)
    "MedicinalProductUndesirableEffect" ->
      decode.success(ResourcetypesMedicinalproductundesirableeffect)
    "MedicinalProductPharmaceutical" ->
      decode.success(ResourcetypesMedicinalproductpharmaceutical)
    "MedicinalProductPackaged" ->
      decode.success(ResourcetypesMedicinalproductpackaged)
    "MedicinalProductManufactured" ->
      decode.success(ResourcetypesMedicinalproductmanufactured)
    "MedicinalProductInteraction" ->
      decode.success(ResourcetypesMedicinalproductinteraction)
    "MedicinalProductIngredient" ->
      decode.success(ResourcetypesMedicinalproductingredient)
    "MedicinalProductIndication" ->
      decode.success(ResourcetypesMedicinalproductindication)
    "MedicinalProductContraindication" ->
      decode.success(ResourcetypesMedicinalproductcontraindication)
    "MedicinalProductAuthorization" ->
      decode.success(ResourcetypesMedicinalproductauthorization)
    "MedicinalProduct" -> decode.success(ResourcetypesMedicinalproduct)
    "MedicationStatement" -> decode.success(ResourcetypesMedicationstatement)
    "MedicationRequest" -> decode.success(ResourcetypesMedicationrequest)
    "MedicationKnowledge" -> decode.success(ResourcetypesMedicationknowledge)
    "MedicationDispense" -> decode.success(ResourcetypesMedicationdispense)
    "MedicationAdministration" ->
      decode.success(ResourcetypesMedicationadministration)
    "Medication" -> decode.success(ResourcetypesMedication)
    "Media" -> decode.success(ResourcetypesMedia)
    "MeasureReport" -> decode.success(ResourcetypesMeasurereport)
    "Measure" -> decode.success(ResourcetypesMeasure)
    "Location" -> decode.success(ResourcetypesLocation)
    "List" -> decode.success(ResourcetypesList)
    "Linkage" -> decode.success(ResourcetypesLinkage)
    "Library" -> decode.success(ResourcetypesLibrary)
    "Invoice" -> decode.success(ResourcetypesInvoice)
    "InsurancePlan" -> decode.success(ResourcetypesInsuranceplan)
    "ImplementationGuide" -> decode.success(ResourcetypesImplementationguide)
    "ImmunizationRecommendation" ->
      decode.success(ResourcetypesImmunizationrecommendation)
    "ImmunizationEvaluation" ->
      decode.success(ResourcetypesImmunizationevaluation)
    "Immunization" -> decode.success(ResourcetypesImmunization)
    "ImagingStudy" -> decode.success(ResourcetypesImagingstudy)
    "HealthcareService" -> decode.success(ResourcetypesHealthcareservice)
    "GuidanceResponse" -> decode.success(ResourcetypesGuidanceresponse)
    "Group" -> decode.success(ResourcetypesGroup)
    "GraphDefinition" -> decode.success(ResourcetypesGraphdefinition)
    "Goal" -> decode.success(ResourcetypesGoal)
    "Flag" -> decode.success(ResourcetypesFlag)
    "FamilyMemberHistory" -> decode.success(ResourcetypesFamilymemberhistory)
    "ExplanationOfBenefit" -> decode.success(ResourcetypesExplanationofbenefit)
    "ExampleScenario" -> decode.success(ResourcetypesExamplescenario)
    "EvidenceVariable" -> decode.success(ResourcetypesEvidencevariable)
    "Evidence" -> decode.success(ResourcetypesEvidence)
    "EventDefinition" -> decode.success(ResourcetypesEventdefinition)
    "EpisodeOfCare" -> decode.success(ResourcetypesEpisodeofcare)
    "EnrollmentResponse" -> decode.success(ResourcetypesEnrollmentresponse)
    "EnrollmentRequest" -> decode.success(ResourcetypesEnrollmentrequest)
    "Endpoint" -> decode.success(ResourcetypesEndpoint)
    "Encounter" -> decode.success(ResourcetypesEncounter)
    "EffectEvidenceSynthesis" ->
      decode.success(ResourcetypesEffectevidencesynthesis)
    "DomainResource" -> decode.success(ResourcetypesDomainresource)
    "DocumentReference" -> decode.success(ResourcetypesDocumentreference)
    "DocumentManifest" -> decode.success(ResourcetypesDocumentmanifest)
    "DiagnosticReport" -> decode.success(ResourcetypesDiagnosticreport)
    "DeviceUseStatement" -> decode.success(ResourcetypesDeviceusestatement)
    "DeviceRequest" -> decode.success(ResourcetypesDevicerequest)
    "DeviceMetric" -> decode.success(ResourcetypesDevicemetric)
    "DeviceDefinition" -> decode.success(ResourcetypesDevicedefinition)
    "Device" -> decode.success(ResourcetypesDevice)
    "DetectedIssue" -> decode.success(ResourcetypesDetectedissue)
    "CoverageEligibilityResponse" ->
      decode.success(ResourcetypesCoverageeligibilityresponse)
    "CoverageEligibilityRequest" ->
      decode.success(ResourcetypesCoverageeligibilityrequest)
    "Coverage" -> decode.success(ResourcetypesCoverage)
    "Contract" -> decode.success(ResourcetypesContract)
    "Consent" -> decode.success(ResourcetypesConsent)
    "Condition" -> decode.success(ResourcetypesCondition)
    "ConceptMap" -> decode.success(ResourcetypesConceptmap)
    "Composition" -> decode.success(ResourcetypesComposition)
    "CompartmentDefinition" ->
      decode.success(ResourcetypesCompartmentdefinition)
    "CommunicationRequest" -> decode.success(ResourcetypesCommunicationrequest)
    "Communication" -> decode.success(ResourcetypesCommunication)
    "CodeSystem" -> decode.success(ResourcetypesCodesystem)
    "ClinicalImpression" -> decode.success(ResourcetypesClinicalimpression)
    "ClaimResponse" -> decode.success(ResourcetypesClaimresponse)
    "Claim" -> decode.success(ResourcetypesClaim)
    "ChargeItemDefinition" -> decode.success(ResourcetypesChargeitemdefinition)
    "ChargeItem" -> decode.success(ResourcetypesChargeitem)
    "CatalogEntry" -> decode.success(ResourcetypesCatalogentry)
    "CareTeam" -> decode.success(ResourcetypesCareteam)
    "CarePlan" -> decode.success(ResourcetypesCareplan)
    "CapabilityStatement" -> decode.success(ResourcetypesCapabilitystatement)
    "Bundle" -> decode.success(ResourcetypesBundle)
    "BodyStructure" -> decode.success(ResourcetypesBodystructure)
    "BiologicallyDerivedProduct" ->
      decode.success(ResourcetypesBiologicallyderivedproduct)
    "Binary" -> decode.success(ResourcetypesBinary)
    "Basic" -> decode.success(ResourcetypesBasic)
    "AuditEvent" -> decode.success(ResourcetypesAuditevent)
    "AppointmentResponse" -> decode.success(ResourcetypesAppointmentresponse)
    "Appointment" -> decode.success(ResourcetypesAppointment)
    "AllergyIntolerance" -> decode.success(ResourcetypesAllergyintolerance)
    "AdverseEvent" -> decode.success(ResourcetypesAdverseevent)
    "ActivityDefinition" -> decode.success(ResourcetypesActivitydefinition)
    "Account" -> decode.success(ResourcetypesAccount)
    _ -> decode.failure(ResourcetypesVisionprescription, "Resourcetypes")
  }
}

pub type Reactioneventseverity {
  ReactioneventseveritySevere
  ReactioneventseverityModerate
  ReactioneventseverityMild
}

pub fn reactioneventseverity_to_json(
  reactioneventseverity: Reactioneventseverity,
) -> Json {
  case reactioneventseverity {
    ReactioneventseveritySevere -> json.string("severe")
    ReactioneventseverityModerate -> json.string("moderate")
    ReactioneventseverityMild -> json.string("mild")
  }
}

pub fn reactioneventseverity_decoder() -> Decoder(Reactioneventseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "severe" -> decode.success(ReactioneventseveritySevere)
    "moderate" -> decode.success(ReactioneventseverityModerate)
    "mild" -> decode.success(ReactioneventseverityMild)
    _ -> decode.failure(ReactioneventseveritySevere, "Reactioneventseverity")
  }
}

pub type Notetype {
  NotetypePrintoper
  NotetypePrint
  NotetypeDisplay
}

pub fn notetype_to_json(notetype: Notetype) -> Json {
  case notetype {
    NotetypePrintoper -> json.string("printoper")
    NotetypePrint -> json.string("print")
    NotetypeDisplay -> json.string("display")
  }
}

pub fn notetype_decoder() -> Decoder(Notetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "printoper" -> decode.success(NotetypePrintoper)
    "print" -> decode.success(NotetypePrint)
    "display" -> decode.success(NotetypeDisplay)
    _ -> decode.failure(NotetypePrintoper, "Notetype")
  }
}

pub type Actionprecheckbehavior {
  ActionprecheckbehaviorNo
  ActionprecheckbehaviorYes
}

pub fn actionprecheckbehavior_to_json(
  actionprecheckbehavior: Actionprecheckbehavior,
) -> Json {
  case actionprecheckbehavior {
    ActionprecheckbehaviorNo -> json.string("no")
    ActionprecheckbehaviorYes -> json.string("yes")
  }
}

pub fn actionprecheckbehavior_decoder() -> Decoder(Actionprecheckbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "no" -> decode.success(ActionprecheckbehaviorNo)
    "yes" -> decode.success(ActionprecheckbehaviorYes)
    _ -> decode.failure(ActionprecheckbehaviorNo, "Actionprecheckbehavior")
  }
}

pub type Compartmenttype {
  CompartmenttypeDevice
  CompartmenttypePractitioner
  CompartmenttypeRelatedperson
  CompartmenttypeEncounter
  CompartmenttypePatient
}

pub fn compartmenttype_to_json(compartmenttype: Compartmenttype) -> Json {
  case compartmenttype {
    CompartmenttypeDevice -> json.string("Device")
    CompartmenttypePractitioner -> json.string("Practitioner")
    CompartmenttypeRelatedperson -> json.string("RelatedPerson")
    CompartmenttypeEncounter -> json.string("Encounter")
    CompartmenttypePatient -> json.string("Patient")
  }
}

pub fn compartmenttype_decoder() -> Decoder(Compartmenttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "Device" -> decode.success(CompartmenttypeDevice)
    "Practitioner" -> decode.success(CompartmenttypePractitioner)
    "RelatedPerson" -> decode.success(CompartmenttypeRelatedperson)
    "Encounter" -> decode.success(CompartmenttypeEncounter)
    "Patient" -> decode.success(CompartmenttypePatient)
    _ -> decode.failure(CompartmenttypeDevice, "Compartmenttype")
  }
}

pub type Observationstatus {
  ObservationstatusUnknown
  ObservationstatusEnteredinerror
  ObservationstatusCancelled
  ObservationstatusAmended
  ObservationstatusFinal
  ObservationstatusPreliminary
  ObservationstatusRegistered
  ObservationstatusCorrected
}

pub fn observationstatus_to_json(observationstatus: Observationstatus) -> Json {
  case observationstatus {
    ObservationstatusUnknown -> json.string("unknown")
    ObservationstatusEnteredinerror -> json.string("entered-in-error")
    ObservationstatusCancelled -> json.string("cancelled")
    ObservationstatusAmended -> json.string("amended")
    ObservationstatusFinal -> json.string("final")
    ObservationstatusPreliminary -> json.string("preliminary")
    ObservationstatusRegistered -> json.string("registered")
    ObservationstatusCorrected -> json.string("corrected")
  }
}

pub fn observationstatus_decoder() -> Decoder(Observationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ObservationstatusUnknown)
    "entered-in-error" -> decode.success(ObservationstatusEnteredinerror)
    "cancelled" -> decode.success(ObservationstatusCancelled)
    "amended" -> decode.success(ObservationstatusAmended)
    "final" -> decode.success(ObservationstatusFinal)
    "preliminary" -> decode.success(ObservationstatusPreliminary)
    "registered" -> decode.success(ObservationstatusRegistered)
    "corrected" -> decode.success(ObservationstatusCorrected)
    _ -> decode.failure(ObservationstatusUnknown, "Observationstatus")
  }
}

pub type Bindingstrength {
  BindingstrengthExample
  BindingstrengthPreferred
  BindingstrengthExtensible
  BindingstrengthRequired
}

pub fn bindingstrength_to_json(bindingstrength: Bindingstrength) -> Json {
  case bindingstrength {
    BindingstrengthExample -> json.string("example")
    BindingstrengthPreferred -> json.string("preferred")
    BindingstrengthExtensible -> json.string("extensible")
    BindingstrengthRequired -> json.string("required")
  }
}

pub fn bindingstrength_decoder() -> Decoder(Bindingstrength) {
  use variant <- decode.then(decode.string)
  case variant {
    "example" -> decode.success(BindingstrengthExample)
    "preferred" -> decode.success(BindingstrengthPreferred)
    "extensible" -> decode.success(BindingstrengthExtensible)
    "required" -> decode.success(BindingstrengthRequired)
    _ -> decode.failure(BindingstrengthExample, "Bindingstrength")
  }
}

pub type Requestpriority {
  RequestpriorityStat
  RequestpriorityAsap
  RequestpriorityUrgent
  RequestpriorityRoutine
}

pub fn requestpriority_to_json(requestpriority: Requestpriority) -> Json {
  case requestpriority {
    RequestpriorityStat -> json.string("stat")
    RequestpriorityAsap -> json.string("asap")
    RequestpriorityUrgent -> json.string("urgent")
    RequestpriorityRoutine -> json.string("routine")
  }
}

pub fn requestpriority_decoder() -> Decoder(Requestpriority) {
  use variant <- decode.then(decode.string)
  case variant {
    "stat" -> decode.success(RequestpriorityStat)
    "asap" -> decode.success(RequestpriorityAsap)
    "urgent" -> decode.success(RequestpriorityUrgent)
    "routine" -> decode.success(RequestpriorityRoutine)
    _ -> decode.failure(RequestpriorityStat, "Requestpriority")
  }
}

pub type Supplydeliverystatus {
  SupplydeliverystatusEnteredinerror
  SupplydeliverystatusAbandoned
  SupplydeliverystatusCompleted
  SupplydeliverystatusInprogress
}

pub fn supplydeliverystatus_to_json(
  supplydeliverystatus: Supplydeliverystatus,
) -> Json {
  case supplydeliverystatus {
    SupplydeliverystatusEnteredinerror -> json.string("entered-in-error")
    SupplydeliverystatusAbandoned -> json.string("abandoned")
    SupplydeliverystatusCompleted -> json.string("completed")
    SupplydeliverystatusInprogress -> json.string("in-progress")
  }
}

pub fn supplydeliverystatus_decoder() -> Decoder(Supplydeliverystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(SupplydeliverystatusEnteredinerror)
    "abandoned" -> decode.success(SupplydeliverystatusAbandoned)
    "completed" -> decode.success(SupplydeliverystatusCompleted)
    "in-progress" -> decode.success(SupplydeliverystatusInprogress)
    _ ->
      decode.failure(SupplydeliverystatusEnteredinerror, "Supplydeliverystatus")
  }
}

pub type Issuetype {
  IssuetypeInformational
  IssuetypeTransient
  IssuetypeProcessing
  IssuetypeSecurity
  IssuetypeInvalid
  IssuetypeInvariant
  IssuetypeValue
  IssuetypeRequired
  IssuetypeStructure
  IssuetypeSuppressed
  IssuetypeForbidden
  IssuetypeExpired
  IssuetypeUnknown
  IssuetypeLogin
  IssuetypeConflict
  IssuetypeBusinessrule
  IssuetypeToocostly
  IssuetypeExtension
  IssuetypeCodeinvalid
  IssuetypeToolong
  IssuetypeNotfound
  IssuetypeMultiplematches
  IssuetypeDuplicate
  IssuetypeNotsupported
  IssuetypeDeleted
  IssuetypeThrottled
  IssuetypeIncomplete
  IssuetypeTimeout
  IssuetypeException
  IssuetypeNostore
  IssuetypeLockerror
}

pub fn issuetype_to_json(issuetype: Issuetype) -> Json {
  case issuetype {
    IssuetypeInformational -> json.string("informational")
    IssuetypeTransient -> json.string("transient")
    IssuetypeProcessing -> json.string("processing")
    IssuetypeSecurity -> json.string("security")
    IssuetypeInvalid -> json.string("invalid")
    IssuetypeInvariant -> json.string("invariant")
    IssuetypeValue -> json.string("value")
    IssuetypeRequired -> json.string("required")
    IssuetypeStructure -> json.string("structure")
    IssuetypeSuppressed -> json.string("suppressed")
    IssuetypeForbidden -> json.string("forbidden")
    IssuetypeExpired -> json.string("expired")
    IssuetypeUnknown -> json.string("unknown")
    IssuetypeLogin -> json.string("login")
    IssuetypeConflict -> json.string("conflict")
    IssuetypeBusinessrule -> json.string("business-rule")
    IssuetypeToocostly -> json.string("too-costly")
    IssuetypeExtension -> json.string("extension")
    IssuetypeCodeinvalid -> json.string("code-invalid")
    IssuetypeToolong -> json.string("too-long")
    IssuetypeNotfound -> json.string("not-found")
    IssuetypeMultiplematches -> json.string("multiple-matches")
    IssuetypeDuplicate -> json.string("duplicate")
    IssuetypeNotsupported -> json.string("not-supported")
    IssuetypeDeleted -> json.string("deleted")
    IssuetypeThrottled -> json.string("throttled")
    IssuetypeIncomplete -> json.string("incomplete")
    IssuetypeTimeout -> json.string("timeout")
    IssuetypeException -> json.string("exception")
    IssuetypeNostore -> json.string("no-store")
    IssuetypeLockerror -> json.string("lock-error")
  }
}

pub fn issuetype_decoder() -> Decoder(Issuetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "informational" -> decode.success(IssuetypeInformational)
    "transient" -> decode.success(IssuetypeTransient)
    "processing" -> decode.success(IssuetypeProcessing)
    "security" -> decode.success(IssuetypeSecurity)
    "invalid" -> decode.success(IssuetypeInvalid)
    "invariant" -> decode.success(IssuetypeInvariant)
    "value" -> decode.success(IssuetypeValue)
    "required" -> decode.success(IssuetypeRequired)
    "structure" -> decode.success(IssuetypeStructure)
    "suppressed" -> decode.success(IssuetypeSuppressed)
    "forbidden" -> decode.success(IssuetypeForbidden)
    "expired" -> decode.success(IssuetypeExpired)
    "unknown" -> decode.success(IssuetypeUnknown)
    "login" -> decode.success(IssuetypeLogin)
    "conflict" -> decode.success(IssuetypeConflict)
    "business-rule" -> decode.success(IssuetypeBusinessrule)
    "too-costly" -> decode.success(IssuetypeToocostly)
    "extension" -> decode.success(IssuetypeExtension)
    "code-invalid" -> decode.success(IssuetypeCodeinvalid)
    "too-long" -> decode.success(IssuetypeToolong)
    "not-found" -> decode.success(IssuetypeNotfound)
    "multiple-matches" -> decode.success(IssuetypeMultiplematches)
    "duplicate" -> decode.success(IssuetypeDuplicate)
    "not-supported" -> decode.success(IssuetypeNotsupported)
    "deleted" -> decode.success(IssuetypeDeleted)
    "throttled" -> decode.success(IssuetypeThrottled)
    "incomplete" -> decode.success(IssuetypeIncomplete)
    "timeout" -> decode.success(IssuetypeTimeout)
    "exception" -> decode.success(IssuetypeException)
    "no-store" -> decode.success(IssuetypeNostore)
    "lock-error" -> decode.success(IssuetypeLockerror)
    _ -> decode.failure(IssuetypeInformational, "Issuetype")
  }
}

pub type Assertresponsecodetypes {
  AssertresponsecodetypesUnprocessable
  AssertresponsecodetypesPreconditionfailed
  AssertresponsecodetypesGone
  AssertresponsecodetypesConflict
  AssertresponsecodetypesMethodnotallowed
  AssertresponsecodetypesNotfound
  AssertresponsecodetypesForbidden
  AssertresponsecodetypesBad
  AssertresponsecodetypesNotmodified
  AssertresponsecodetypesNocontent
  AssertresponsecodetypesCreated
  AssertresponsecodetypesOkay
}

pub fn assertresponsecodetypes_to_json(
  assertresponsecodetypes: Assertresponsecodetypes,
) -> Json {
  case assertresponsecodetypes {
    AssertresponsecodetypesUnprocessable -> json.string("unprocessable")
    AssertresponsecodetypesPreconditionfailed ->
      json.string("preconditionFailed")
    AssertresponsecodetypesGone -> json.string("gone")
    AssertresponsecodetypesConflict -> json.string("conflict")
    AssertresponsecodetypesMethodnotallowed -> json.string("methodNotAllowed")
    AssertresponsecodetypesNotfound -> json.string("notFound")
    AssertresponsecodetypesForbidden -> json.string("forbidden")
    AssertresponsecodetypesBad -> json.string("bad")
    AssertresponsecodetypesNotmodified -> json.string("notModified")
    AssertresponsecodetypesNocontent -> json.string("noContent")
    AssertresponsecodetypesCreated -> json.string("created")
    AssertresponsecodetypesOkay -> json.string("okay")
  }
}

pub fn assertresponsecodetypes_decoder() -> Decoder(Assertresponsecodetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "unprocessable" -> decode.success(AssertresponsecodetypesUnprocessable)
    "preconditionFailed" ->
      decode.success(AssertresponsecodetypesPreconditionfailed)
    "gone" -> decode.success(AssertresponsecodetypesGone)
    "conflict" -> decode.success(AssertresponsecodetypesConflict)
    "methodNotAllowed" ->
      decode.success(AssertresponsecodetypesMethodnotallowed)
    "notFound" -> decode.success(AssertresponsecodetypesNotfound)
    "forbidden" -> decode.success(AssertresponsecodetypesForbidden)
    "bad" -> decode.success(AssertresponsecodetypesBad)
    "notModified" -> decode.success(AssertresponsecodetypesNotmodified)
    "noContent" -> decode.success(AssertresponsecodetypesNocontent)
    "created" -> decode.success(AssertresponsecodetypesCreated)
    "okay" -> decode.success(AssertresponsecodetypesOkay)
    _ ->
      decode.failure(
        AssertresponsecodetypesUnprocessable,
        "Assertresponsecodetypes",
      )
  }
}

pub type Identityassurancelevel {
  IdentityassurancelevelLevel4
  IdentityassurancelevelLevel3
  IdentityassurancelevelLevel2
  IdentityassurancelevelLevel1
}

pub fn identityassurancelevel_to_json(
  identityassurancelevel: Identityassurancelevel,
) -> Json {
  case identityassurancelevel {
    IdentityassurancelevelLevel4 -> json.string("level4")
    IdentityassurancelevelLevel3 -> json.string("level3")
    IdentityassurancelevelLevel2 -> json.string("level2")
    IdentityassurancelevelLevel1 -> json.string("level1")
  }
}

pub fn identityassurancelevel_decoder() -> Decoder(Identityassurancelevel) {
  use variant <- decode.then(decode.string)
  case variant {
    "level4" -> decode.success(IdentityassurancelevelLevel4)
    "level3" -> decode.success(IdentityassurancelevelLevel3)
    "level2" -> decode.success(IdentityassurancelevelLevel2)
    "level1" -> decode.success(IdentityassurancelevelLevel1)
    _ -> decode.failure(IdentityassurancelevelLevel4, "Identityassurancelevel")
  }
}

pub type Httpverb {
  HttpverbPatch
  HttpverbDelete
  HttpverbPut
  HttpverbPost
  HttpverbHead
  HttpverbGet
}

pub fn httpverb_to_json(httpverb: Httpverb) -> Json {
  case httpverb {
    HttpverbPatch -> json.string("PATCH")
    HttpverbDelete -> json.string("DELETE")
    HttpverbPut -> json.string("PUT")
    HttpverbPost -> json.string("POST")
    HttpverbHead -> json.string("HEAD")
    HttpverbGet -> json.string("GET")
  }
}

pub fn httpverb_decoder() -> Decoder(Httpverb) {
  use variant <- decode.then(decode.string)
  case variant {
    "PATCH" -> decode.success(HttpverbPatch)
    "DELETE" -> decode.success(HttpverbDelete)
    "PUT" -> decode.success(HttpverbPut)
    "POST" -> decode.success(HttpverbPost)
    "HEAD" -> decode.success(HttpverbHead)
    "GET" -> decode.success(HttpverbGet)
    _ -> decode.failure(HttpverbPatch, "Httpverb")
  }
}

pub type Messagesignificancecategory {
  MessagesignificancecategoryNotification
  MessagesignificancecategoryCurrency
  MessagesignificancecategoryConsequence
}

pub fn messagesignificancecategory_to_json(
  messagesignificancecategory: Messagesignificancecategory,
) -> Json {
  case messagesignificancecategory {
    MessagesignificancecategoryNotification -> json.string("notification")
    MessagesignificancecategoryCurrency -> json.string("currency")
    MessagesignificancecategoryConsequence -> json.string("consequence")
  }
}

pub fn messagesignificancecategory_decoder() -> Decoder(
  Messagesignificancecategory,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "notification" -> decode.success(MessagesignificancecategoryNotification)
    "currency" -> decode.success(MessagesignificancecategoryCurrency)
    "consequence" -> decode.success(MessagesignificancecategoryConsequence)
    _ ->
      decode.failure(
        MessagesignificancecategoryNotification,
        "Messagesignificancecategory",
      )
  }
}

pub type Capabilitystatementkind {
  CapabilitystatementkindRequirements
  CapabilitystatementkindCapability
  CapabilitystatementkindInstance
}

pub fn capabilitystatementkind_to_json(
  capabilitystatementkind: Capabilitystatementkind,
) -> Json {
  case capabilitystatementkind {
    CapabilitystatementkindRequirements -> json.string("requirements")
    CapabilitystatementkindCapability -> json.string("capability")
    CapabilitystatementkindInstance -> json.string("instance")
  }
}

pub fn capabilitystatementkind_decoder() -> Decoder(Capabilitystatementkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "requirements" -> decode.success(CapabilitystatementkindRequirements)
    "capability" -> decode.success(CapabilitystatementkindCapability)
    "instance" -> decode.success(CapabilitystatementkindInstance)
    _ ->
      decode.failure(
        CapabilitystatementkindRequirements,
        "Capabilitystatementkind",
      )
  }
}

pub type Allergyintolerancetype {
  AllergyintolerancetypeIntolerance
  AllergyintolerancetypeAllergy
}

pub fn allergyintolerancetype_to_json(
  allergyintolerancetype: Allergyintolerancetype,
) -> Json {
  case allergyintolerancetype {
    AllergyintolerancetypeIntolerance -> json.string("intolerance")
    AllergyintolerancetypeAllergy -> json.string("allergy")
  }
}

pub fn allergyintolerancetype_decoder() -> Decoder(Allergyintolerancetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "intolerance" -> decode.success(AllergyintolerancetypeIntolerance)
    "allergy" -> decode.success(AllergyintolerancetypeAllergy)
    _ ->
      decode.failure(
        AllergyintolerancetypeIntolerance,
        "Allergyintolerancetype",
      )
  }
}

pub type Documentmode {
  DocumentmodeConsumer
  DocumentmodeProducer
}

pub fn documentmode_to_json(documentmode: Documentmode) -> Json {
  case documentmode {
    DocumentmodeConsumer -> json.string("consumer")
    DocumentmodeProducer -> json.string("producer")
  }
}

pub fn documentmode_decoder() -> Decoder(Documentmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "consumer" -> decode.success(DocumentmodeConsumer)
    "producer" -> decode.success(DocumentmodeProducer)
    _ -> decode.failure(DocumentmodeConsumer, "Documentmode")
  }
}

pub type Maptargetlistmode {
  MaptargetlistmodeCollate
  MaptargetlistmodeLast
  MaptargetlistmodeShare
  MaptargetlistmodeFirst
}

pub fn maptargetlistmode_to_json(maptargetlistmode: Maptargetlistmode) -> Json {
  case maptargetlistmode {
    MaptargetlistmodeCollate -> json.string("collate")
    MaptargetlistmodeLast -> json.string("last")
    MaptargetlistmodeShare -> json.string("share")
    MaptargetlistmodeFirst -> json.string("first")
  }
}

pub fn maptargetlistmode_decoder() -> Decoder(Maptargetlistmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "collate" -> decode.success(MaptargetlistmodeCollate)
    "last" -> decode.success(MaptargetlistmodeLast)
    "share" -> decode.success(MaptargetlistmodeShare)
    "first" -> decode.success(MaptargetlistmodeFirst)
    _ -> decode.failure(MaptargetlistmodeCollate, "Maptargetlistmode")
  }
}

pub type Filteroperator {
  FilteroperatorExists
  FilteroperatorGeneralizes
  FilteroperatorNotin
  FilteroperatorIn
  FilteroperatorRegex
  FilteroperatorIsnota
  FilteroperatorDescendentof
  FilteroperatorIsa
  FilteroperatorEqual
}

pub fn filteroperator_to_json(filteroperator: Filteroperator) -> Json {
  case filteroperator {
    FilteroperatorExists -> json.string("exists")
    FilteroperatorGeneralizes -> json.string("generalizes")
    FilteroperatorNotin -> json.string("not-in")
    FilteroperatorIn -> json.string("in")
    FilteroperatorRegex -> json.string("regex")
    FilteroperatorIsnota -> json.string("is-not-a")
    FilteroperatorDescendentof -> json.string("descendent-of")
    FilteroperatorIsa -> json.string("is-a")
    FilteroperatorEqual -> json.string("=")
  }
}

pub fn filteroperator_decoder() -> Decoder(Filteroperator) {
  use variant <- decode.then(decode.string)
  case variant {
    "exists" -> decode.success(FilteroperatorExists)
    "generalizes" -> decode.success(FilteroperatorGeneralizes)
    "not-in" -> decode.success(FilteroperatorNotin)
    "in" -> decode.success(FilteroperatorIn)
    "regex" -> decode.success(FilteroperatorRegex)
    "is-not-a" -> decode.success(FilteroperatorIsnota)
    "descendent-of" -> decode.success(FilteroperatorDescendentof)
    "is-a" -> decode.success(FilteroperatorIsa)
    "=" -> decode.success(FilteroperatorEqual)
    _ -> decode.failure(FilteroperatorExists, "Filteroperator")
  }
}

pub type Fhirversion {
  Fhirversion401
  Fhirversion400
  Fhirversion350
  Fhirversion330
  Fhirversion301
  Fhirversion300
  Fhirversion180
  Fhirversion160
  Fhirversion140
  Fhirversion110
  Fhirversion102
  Fhirversion101
  Fhirversion100
  Fhirversion050
  Fhirversion040
  Fhirversion0082
  Fhirversion0081
  Fhirversion0080
  Fhirversion011
  Fhirversion006
  Fhirversion005
  Fhirversion001
}

pub fn fhirversion_to_json(fhirversion: Fhirversion) -> Json {
  case fhirversion {
    Fhirversion401 -> json.string("4.0.1")
    Fhirversion400 -> json.string("4.0.0")
    Fhirversion350 -> json.string("3.5.0")
    Fhirversion330 -> json.string("3.3.0")
    Fhirversion301 -> json.string("3.0.1")
    Fhirversion300 -> json.string("3.0.0")
    Fhirversion180 -> json.string("1.8.0")
    Fhirversion160 -> json.string("1.6.0")
    Fhirversion140 -> json.string("1.4.0")
    Fhirversion110 -> json.string("1.1.0")
    Fhirversion102 -> json.string("1.0.2")
    Fhirversion101 -> json.string("1.0.1")
    Fhirversion100 -> json.string("1.0.0")
    Fhirversion050 -> json.string("0.5.0")
    Fhirversion040 -> json.string("0.4.0")
    Fhirversion0082 -> json.string("0.0.82")
    Fhirversion0081 -> json.string("0.0.81")
    Fhirversion0080 -> json.string("0.0.80")
    Fhirversion011 -> json.string("0.11")
    Fhirversion006 -> json.string("0.06")
    Fhirversion005 -> json.string("0.05")
    Fhirversion001 -> json.string("0.01")
  }
}

pub fn fhirversion_decoder() -> Decoder(Fhirversion) {
  use variant <- decode.then(decode.string)
  case variant {
    "4.0.1" -> decode.success(Fhirversion401)
    "4.0.0" -> decode.success(Fhirversion400)
    "3.5.0" -> decode.success(Fhirversion350)
    "3.3.0" -> decode.success(Fhirversion330)
    "3.0.1" -> decode.success(Fhirversion301)
    "3.0.0" -> decode.success(Fhirversion300)
    "1.8.0" -> decode.success(Fhirversion180)
    "1.6.0" -> decode.success(Fhirversion160)
    "1.4.0" -> decode.success(Fhirversion140)
    "1.1.0" -> decode.success(Fhirversion110)
    "1.0.2" -> decode.success(Fhirversion102)
    "1.0.1" -> decode.success(Fhirversion101)
    "1.0.0" -> decode.success(Fhirversion100)
    "0.5.0" -> decode.success(Fhirversion050)
    "0.4.0" -> decode.success(Fhirversion040)
    "0.0.82" -> decode.success(Fhirversion0082)
    "0.0.81" -> decode.success(Fhirversion0081)
    "0.0.80" -> decode.success(Fhirversion0080)
    "0.11" -> decode.success(Fhirversion011)
    "0.06" -> decode.success(Fhirversion006)
    "0.05" -> decode.success(Fhirversion005)
    "0.01" -> decode.success(Fhirversion001)
    _ -> decode.failure(Fhirversion401, "Fhirversion")
  }
}

pub type Medicationknowledgestatus {
  MedicationknowledgestatusEnteredinerror
  MedicationknowledgestatusInactive
  MedicationknowledgestatusActive
}

pub fn medicationknowledgestatus_to_json(
  medicationknowledgestatus: Medicationknowledgestatus,
) -> Json {
  case medicationknowledgestatus {
    MedicationknowledgestatusEnteredinerror -> json.string("entered-in-error")
    MedicationknowledgestatusInactive -> json.string("inactive")
    MedicationknowledgestatusActive -> json.string("active")
  }
}

pub fn medicationknowledgestatus_decoder() -> Decoder(Medicationknowledgestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" ->
      decode.success(MedicationknowledgestatusEnteredinerror)
    "inactive" -> decode.success(MedicationknowledgestatusInactive)
    "active" -> decode.success(MedicationknowledgestatusActive)
    _ ->
      decode.failure(
        MedicationknowledgestatusEnteredinerror,
        "Medicationknowledgestatus",
      )
  }
}

pub type Grouptype {
  GrouptypeSubstance
  GrouptypeMedication
  GrouptypeDevice
  GrouptypePractitioner
  GrouptypeAnimal
  GrouptypePerson
}

pub fn grouptype_to_json(grouptype: Grouptype) -> Json {
  case grouptype {
    GrouptypeSubstance -> json.string("substance")
    GrouptypeMedication -> json.string("medication")
    GrouptypeDevice -> json.string("device")
    GrouptypePractitioner -> json.string("practitioner")
    GrouptypeAnimal -> json.string("animal")
    GrouptypePerson -> json.string("person")
  }
}

pub fn grouptype_decoder() -> Decoder(Grouptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "substance" -> decode.success(GrouptypeSubstance)
    "medication" -> decode.success(GrouptypeMedication)
    "device" -> decode.success(GrouptypeDevice)
    "practitioner" -> decode.success(GrouptypePractitioner)
    "animal" -> decode.success(GrouptypeAnimal)
    "person" -> decode.success(GrouptypePerson)
    _ -> decode.failure(GrouptypeSubstance, "Grouptype")
  }
}

pub type Definedtypes {
  DefinedtypesVisionprescription
  DefinedtypesVerificationresult
  DefinedtypesValueset
  DefinedtypesTestscript
  DefinedtypesTestreport
  DefinedtypesTerminologycapabilities
  DefinedtypesTask
  DefinedtypesSupplyrequest
  DefinedtypesSupplydelivery
  DefinedtypesSubstancespecification
  DefinedtypesSubstancesourcematerial
  DefinedtypesSubstancereferenceinformation
  DefinedtypesSubstanceprotein
  DefinedtypesSubstancepolymer
  DefinedtypesSubstancenucleicacid
  DefinedtypesSubstance
  DefinedtypesSubscription
  DefinedtypesStructuremap
  DefinedtypesStructuredefinition
  DefinedtypesSpecimendefinition
  DefinedtypesSpecimen
  DefinedtypesSlot
  DefinedtypesServicerequest
  DefinedtypesSearchparameter
  DefinedtypesSchedule
  DefinedtypesRiskevidencesynthesis
  DefinedtypesRiskassessment
  DefinedtypesResource
  DefinedtypesResearchsubject
  DefinedtypesResearchstudy
  DefinedtypesResearchelementdefinition
  DefinedtypesResearchdefinition
  DefinedtypesRequestgroup
  DefinedtypesRelatedperson
  DefinedtypesQuestionnaireresponse
  DefinedtypesQuestionnaire
  DefinedtypesProvenance
  DefinedtypesProcedure
  DefinedtypesPractitionerrole
  DefinedtypesPractitioner
  DefinedtypesPlandefinition
  DefinedtypesPerson
  DefinedtypesPaymentreconciliation
  DefinedtypesPaymentnotice
  DefinedtypesPatient
  DefinedtypesParameters
  DefinedtypesOrganizationaffiliation
  DefinedtypesOrganization
  DefinedtypesOperationoutcome
  DefinedtypesOperationdefinition
  DefinedtypesObservationdefinition
  DefinedtypesObservation
  DefinedtypesNutritionorder
  DefinedtypesNamingsystem
  DefinedtypesMolecularsequence
  DefinedtypesMessageheader
  DefinedtypesMessagedefinition
  DefinedtypesMedicinalproductundesirableeffect
  DefinedtypesMedicinalproductpharmaceutical
  DefinedtypesMedicinalproductpackaged
  DefinedtypesMedicinalproductmanufactured
  DefinedtypesMedicinalproductinteraction
  DefinedtypesMedicinalproductingredient
  DefinedtypesMedicinalproductindication
  DefinedtypesMedicinalproductcontraindication
  DefinedtypesMedicinalproductauthorization
  DefinedtypesMedicinalproduct
  DefinedtypesMedicationstatement
  DefinedtypesMedicationrequest
  DefinedtypesMedicationknowledge
  DefinedtypesMedicationdispense
  DefinedtypesMedicationadministration
  DefinedtypesMedication
  DefinedtypesMedia
  DefinedtypesMeasurereport
  DefinedtypesMeasure
  DefinedtypesLocation
  DefinedtypesList
  DefinedtypesLinkage
  DefinedtypesLibrary
  DefinedtypesInvoice
  DefinedtypesInsuranceplan
  DefinedtypesImplementationguide
  DefinedtypesImmunizationrecommendation
  DefinedtypesImmunizationevaluation
  DefinedtypesImmunization
  DefinedtypesImagingstudy
  DefinedtypesHealthcareservice
  DefinedtypesGuidanceresponse
  DefinedtypesGroup
  DefinedtypesGraphdefinition
  DefinedtypesGoal
  DefinedtypesFlag
  DefinedtypesFamilymemberhistory
  DefinedtypesExplanationofbenefit
  DefinedtypesExamplescenario
  DefinedtypesEvidencevariable
  DefinedtypesEvidence
  DefinedtypesEventdefinition
  DefinedtypesEpisodeofcare
  DefinedtypesEnrollmentresponse
  DefinedtypesEnrollmentrequest
  DefinedtypesEndpoint
  DefinedtypesEncounter
  DefinedtypesEffectevidencesynthesis
  DefinedtypesDomainresource
  DefinedtypesDocumentreference
  DefinedtypesDocumentmanifest
  DefinedtypesDiagnosticreport
  DefinedtypesDeviceusestatement
  DefinedtypesDevicerequest
  DefinedtypesDevicemetric
  DefinedtypesDevicedefinition
  DefinedtypesDevice
  DefinedtypesDetectedissue
  DefinedtypesCoverageeligibilityresponse
  DefinedtypesCoverageeligibilityrequest
  DefinedtypesCoverage
  DefinedtypesContract
  DefinedtypesConsent
  DefinedtypesCondition
  DefinedtypesConceptmap
  DefinedtypesComposition
  DefinedtypesCompartmentdefinition
  DefinedtypesCommunicationrequest
  DefinedtypesCommunication
  DefinedtypesCodesystem
  DefinedtypesClinicalimpression
  DefinedtypesClaimresponse
  DefinedtypesClaim
  DefinedtypesChargeitemdefinition
  DefinedtypesChargeitem
  DefinedtypesCatalogentry
  DefinedtypesCareteam
  DefinedtypesCareplan
  DefinedtypesCapabilitystatement
  DefinedtypesBundle
  DefinedtypesBodystructure
  DefinedtypesBiologicallyderivedproduct
  DefinedtypesBinary
  DefinedtypesBasic
  DefinedtypesAuditevent
  DefinedtypesAppointmentresponse
  DefinedtypesAppointment
  DefinedtypesAllergyintolerance
  DefinedtypesAdverseevent
  DefinedtypesActivitydefinition
  DefinedtypesAccount
  DefinedtypesXhtml
  DefinedtypesUuid
  DefinedtypesUrl
  DefinedtypesUri
  DefinedtypesUnsignedint
  DefinedtypesTime
  DefinedtypesString
  DefinedtypesPositiveint
  DefinedtypesOid
  DefinedtypesMarkdown
  DefinedtypesInteger
  DefinedtypesInstant
  DefinedtypesId
  DefinedtypesDecimal
  DefinedtypesDatetime
  DefinedtypesDate
  DefinedtypesCode
  DefinedtypesCanonical
  DefinedtypesBoolean
  DefinedtypesBase64binary
  DefinedtypesUsagecontext
  DefinedtypesTriggerdefinition
  DefinedtypesTiming
  DefinedtypesSubstanceamount
  DefinedtypesSimplequantity
  DefinedtypesSignature
  DefinedtypesSampleddata
  DefinedtypesRelatedartifact
  DefinedtypesReference
  DefinedtypesRatio
  DefinedtypesRange
  DefinedtypesQuantity
  DefinedtypesProductshelflife
  DefinedtypesProdcharacteristic
  DefinedtypesPopulation
  DefinedtypesPeriod
  DefinedtypesParameterdefinition
  DefinedtypesNarrative
  DefinedtypesMoneyquantity
  DefinedtypesMoney
  DefinedtypesMeta
  DefinedtypesMarketingstatus
  DefinedtypesIdentifier
  DefinedtypesHumanname
  DefinedtypesExtension
  DefinedtypesExpression
  DefinedtypesElementdefinition
  DefinedtypesElement
  DefinedtypesDuration
  DefinedtypesDosage
  DefinedtypesDistance
  DefinedtypesDatarequirement
  DefinedtypesCount
  DefinedtypesContributor
  DefinedtypesContactpoint
  DefinedtypesContactdetail
  DefinedtypesCoding
  DefinedtypesCodeableconcept
  DefinedtypesBackboneelement
  DefinedtypesAttachment
  DefinedtypesAnnotation
  DefinedtypesAge
  DefinedtypesAddress
}

pub fn definedtypes_to_json(definedtypes: Definedtypes) -> Json {
  case definedtypes {
    DefinedtypesVisionprescription -> json.string("VisionPrescription")
    DefinedtypesVerificationresult -> json.string("VerificationResult")
    DefinedtypesValueset -> json.string("ValueSet")
    DefinedtypesTestscript -> json.string("TestScript")
    DefinedtypesTestreport -> json.string("TestReport")
    DefinedtypesTerminologycapabilities ->
      json.string("TerminologyCapabilities")
    DefinedtypesTask -> json.string("Task")
    DefinedtypesSupplyrequest -> json.string("SupplyRequest")
    DefinedtypesSupplydelivery -> json.string("SupplyDelivery")
    DefinedtypesSubstancespecification -> json.string("SubstanceSpecification")
    DefinedtypesSubstancesourcematerial ->
      json.string("SubstanceSourceMaterial")
    DefinedtypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    DefinedtypesSubstanceprotein -> json.string("SubstanceProtein")
    DefinedtypesSubstancepolymer -> json.string("SubstancePolymer")
    DefinedtypesSubstancenucleicacid -> json.string("SubstanceNucleicAcid")
    DefinedtypesSubstance -> json.string("Substance")
    DefinedtypesSubscription -> json.string("Subscription")
    DefinedtypesStructuremap -> json.string("StructureMap")
    DefinedtypesStructuredefinition -> json.string("StructureDefinition")
    DefinedtypesSpecimendefinition -> json.string("SpecimenDefinition")
    DefinedtypesSpecimen -> json.string("Specimen")
    DefinedtypesSlot -> json.string("Slot")
    DefinedtypesServicerequest -> json.string("ServiceRequest")
    DefinedtypesSearchparameter -> json.string("SearchParameter")
    DefinedtypesSchedule -> json.string("Schedule")
    DefinedtypesRiskevidencesynthesis -> json.string("RiskEvidenceSynthesis")
    DefinedtypesRiskassessment -> json.string("RiskAssessment")
    DefinedtypesResource -> json.string("Resource")
    DefinedtypesResearchsubject -> json.string("ResearchSubject")
    DefinedtypesResearchstudy -> json.string("ResearchStudy")
    DefinedtypesResearchelementdefinition ->
      json.string("ResearchElementDefinition")
    DefinedtypesResearchdefinition -> json.string("ResearchDefinition")
    DefinedtypesRequestgroup -> json.string("RequestGroup")
    DefinedtypesRelatedperson -> json.string("RelatedPerson")
    DefinedtypesQuestionnaireresponse -> json.string("QuestionnaireResponse")
    DefinedtypesQuestionnaire -> json.string("Questionnaire")
    DefinedtypesProvenance -> json.string("Provenance")
    DefinedtypesProcedure -> json.string("Procedure")
    DefinedtypesPractitionerrole -> json.string("PractitionerRole")
    DefinedtypesPractitioner -> json.string("Practitioner")
    DefinedtypesPlandefinition -> json.string("PlanDefinition")
    DefinedtypesPerson -> json.string("Person")
    DefinedtypesPaymentreconciliation -> json.string("PaymentReconciliation")
    DefinedtypesPaymentnotice -> json.string("PaymentNotice")
    DefinedtypesPatient -> json.string("Patient")
    DefinedtypesParameters -> json.string("Parameters")
    DefinedtypesOrganizationaffiliation ->
      json.string("OrganizationAffiliation")
    DefinedtypesOrganization -> json.string("Organization")
    DefinedtypesOperationoutcome -> json.string("OperationOutcome")
    DefinedtypesOperationdefinition -> json.string("OperationDefinition")
    DefinedtypesObservationdefinition -> json.string("ObservationDefinition")
    DefinedtypesObservation -> json.string("Observation")
    DefinedtypesNutritionorder -> json.string("NutritionOrder")
    DefinedtypesNamingsystem -> json.string("NamingSystem")
    DefinedtypesMolecularsequence -> json.string("MolecularSequence")
    DefinedtypesMessageheader -> json.string("MessageHeader")
    DefinedtypesMessagedefinition -> json.string("MessageDefinition")
    DefinedtypesMedicinalproductundesirableeffect ->
      json.string("MedicinalProductUndesirableEffect")
    DefinedtypesMedicinalproductpharmaceutical ->
      json.string("MedicinalProductPharmaceutical")
    DefinedtypesMedicinalproductpackaged ->
      json.string("MedicinalProductPackaged")
    DefinedtypesMedicinalproductmanufactured ->
      json.string("MedicinalProductManufactured")
    DefinedtypesMedicinalproductinteraction ->
      json.string("MedicinalProductInteraction")
    DefinedtypesMedicinalproductingredient ->
      json.string("MedicinalProductIngredient")
    DefinedtypesMedicinalproductindication ->
      json.string("MedicinalProductIndication")
    DefinedtypesMedicinalproductcontraindication ->
      json.string("MedicinalProductContraindication")
    DefinedtypesMedicinalproductauthorization ->
      json.string("MedicinalProductAuthorization")
    DefinedtypesMedicinalproduct -> json.string("MedicinalProduct")
    DefinedtypesMedicationstatement -> json.string("MedicationStatement")
    DefinedtypesMedicationrequest -> json.string("MedicationRequest")
    DefinedtypesMedicationknowledge -> json.string("MedicationKnowledge")
    DefinedtypesMedicationdispense -> json.string("MedicationDispense")
    DefinedtypesMedicationadministration ->
      json.string("MedicationAdministration")
    DefinedtypesMedication -> json.string("Medication")
    DefinedtypesMedia -> json.string("Media")
    DefinedtypesMeasurereport -> json.string("MeasureReport")
    DefinedtypesMeasure -> json.string("Measure")
    DefinedtypesLocation -> json.string("Location")
    DefinedtypesList -> json.string("List")
    DefinedtypesLinkage -> json.string("Linkage")
    DefinedtypesLibrary -> json.string("Library")
    DefinedtypesInvoice -> json.string("Invoice")
    DefinedtypesInsuranceplan -> json.string("InsurancePlan")
    DefinedtypesImplementationguide -> json.string("ImplementationGuide")
    DefinedtypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    DefinedtypesImmunizationevaluation -> json.string("ImmunizationEvaluation")
    DefinedtypesImmunization -> json.string("Immunization")
    DefinedtypesImagingstudy -> json.string("ImagingStudy")
    DefinedtypesHealthcareservice -> json.string("HealthcareService")
    DefinedtypesGuidanceresponse -> json.string("GuidanceResponse")
    DefinedtypesGroup -> json.string("Group")
    DefinedtypesGraphdefinition -> json.string("GraphDefinition")
    DefinedtypesGoal -> json.string("Goal")
    DefinedtypesFlag -> json.string("Flag")
    DefinedtypesFamilymemberhistory -> json.string("FamilyMemberHistory")
    DefinedtypesExplanationofbenefit -> json.string("ExplanationOfBenefit")
    DefinedtypesExamplescenario -> json.string("ExampleScenario")
    DefinedtypesEvidencevariable -> json.string("EvidenceVariable")
    DefinedtypesEvidence -> json.string("Evidence")
    DefinedtypesEventdefinition -> json.string("EventDefinition")
    DefinedtypesEpisodeofcare -> json.string("EpisodeOfCare")
    DefinedtypesEnrollmentresponse -> json.string("EnrollmentResponse")
    DefinedtypesEnrollmentrequest -> json.string("EnrollmentRequest")
    DefinedtypesEndpoint -> json.string("Endpoint")
    DefinedtypesEncounter -> json.string("Encounter")
    DefinedtypesEffectevidencesynthesis ->
      json.string("EffectEvidenceSynthesis")
    DefinedtypesDomainresource -> json.string("DomainResource")
    DefinedtypesDocumentreference -> json.string("DocumentReference")
    DefinedtypesDocumentmanifest -> json.string("DocumentManifest")
    DefinedtypesDiagnosticreport -> json.string("DiagnosticReport")
    DefinedtypesDeviceusestatement -> json.string("DeviceUseStatement")
    DefinedtypesDevicerequest -> json.string("DeviceRequest")
    DefinedtypesDevicemetric -> json.string("DeviceMetric")
    DefinedtypesDevicedefinition -> json.string("DeviceDefinition")
    DefinedtypesDevice -> json.string("Device")
    DefinedtypesDetectedissue -> json.string("DetectedIssue")
    DefinedtypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    DefinedtypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    DefinedtypesCoverage -> json.string("Coverage")
    DefinedtypesContract -> json.string("Contract")
    DefinedtypesConsent -> json.string("Consent")
    DefinedtypesCondition -> json.string("Condition")
    DefinedtypesConceptmap -> json.string("ConceptMap")
    DefinedtypesComposition -> json.string("Composition")
    DefinedtypesCompartmentdefinition -> json.string("CompartmentDefinition")
    DefinedtypesCommunicationrequest -> json.string("CommunicationRequest")
    DefinedtypesCommunication -> json.string("Communication")
    DefinedtypesCodesystem -> json.string("CodeSystem")
    DefinedtypesClinicalimpression -> json.string("ClinicalImpression")
    DefinedtypesClaimresponse -> json.string("ClaimResponse")
    DefinedtypesClaim -> json.string("Claim")
    DefinedtypesChargeitemdefinition -> json.string("ChargeItemDefinition")
    DefinedtypesChargeitem -> json.string("ChargeItem")
    DefinedtypesCatalogentry -> json.string("CatalogEntry")
    DefinedtypesCareteam -> json.string("CareTeam")
    DefinedtypesCareplan -> json.string("CarePlan")
    DefinedtypesCapabilitystatement -> json.string("CapabilityStatement")
    DefinedtypesBundle -> json.string("Bundle")
    DefinedtypesBodystructure -> json.string("BodyStructure")
    DefinedtypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    DefinedtypesBinary -> json.string("Binary")
    DefinedtypesBasic -> json.string("Basic")
    DefinedtypesAuditevent -> json.string("AuditEvent")
    DefinedtypesAppointmentresponse -> json.string("AppointmentResponse")
    DefinedtypesAppointment -> json.string("Appointment")
    DefinedtypesAllergyintolerance -> json.string("AllergyIntolerance")
    DefinedtypesAdverseevent -> json.string("AdverseEvent")
    DefinedtypesActivitydefinition -> json.string("ActivityDefinition")
    DefinedtypesAccount -> json.string("Account")
    DefinedtypesXhtml -> json.string("xhtml")
    DefinedtypesUuid -> json.string("uuid")
    DefinedtypesUrl -> json.string("url")
    DefinedtypesUri -> json.string("uri")
    DefinedtypesUnsignedint -> json.string("unsignedInt")
    DefinedtypesTime -> json.string("time")
    DefinedtypesString -> json.string("string")
    DefinedtypesPositiveint -> json.string("positiveInt")
    DefinedtypesOid -> json.string("oid")
    DefinedtypesMarkdown -> json.string("markdown")
    DefinedtypesInteger -> json.string("integer")
    DefinedtypesInstant -> json.string("instant")
    DefinedtypesId -> json.string("id")
    DefinedtypesDecimal -> json.string("decimal")
    DefinedtypesDatetime -> json.string("dateTime")
    DefinedtypesDate -> json.string("date")
    DefinedtypesCode -> json.string("code")
    DefinedtypesCanonical -> json.string("canonical")
    DefinedtypesBoolean -> json.string("boolean")
    DefinedtypesBase64binary -> json.string("base64Binary")
    DefinedtypesUsagecontext -> json.string("UsageContext")
    DefinedtypesTriggerdefinition -> json.string("TriggerDefinition")
    DefinedtypesTiming -> json.string("Timing")
    DefinedtypesSubstanceamount -> json.string("SubstanceAmount")
    DefinedtypesSimplequantity -> json.string("SimpleQuantity")
    DefinedtypesSignature -> json.string("Signature")
    DefinedtypesSampleddata -> json.string("SampledData")
    DefinedtypesRelatedartifact -> json.string("RelatedArtifact")
    DefinedtypesReference -> json.string("Reference")
    DefinedtypesRatio -> json.string("Ratio")
    DefinedtypesRange -> json.string("Range")
    DefinedtypesQuantity -> json.string("Quantity")
    DefinedtypesProductshelflife -> json.string("ProductShelfLife")
    DefinedtypesProdcharacteristic -> json.string("ProdCharacteristic")
    DefinedtypesPopulation -> json.string("Population")
    DefinedtypesPeriod -> json.string("Period")
    DefinedtypesParameterdefinition -> json.string("ParameterDefinition")
    DefinedtypesNarrative -> json.string("Narrative")
    DefinedtypesMoneyquantity -> json.string("MoneyQuantity")
    DefinedtypesMoney -> json.string("Money")
    DefinedtypesMeta -> json.string("Meta")
    DefinedtypesMarketingstatus -> json.string("MarketingStatus")
    DefinedtypesIdentifier -> json.string("Identifier")
    DefinedtypesHumanname -> json.string("HumanName")
    DefinedtypesExtension -> json.string("Extension")
    DefinedtypesExpression -> json.string("Expression")
    DefinedtypesElementdefinition -> json.string("ElementDefinition")
    DefinedtypesElement -> json.string("Element")
    DefinedtypesDuration -> json.string("Duration")
    DefinedtypesDosage -> json.string("Dosage")
    DefinedtypesDistance -> json.string("Distance")
    DefinedtypesDatarequirement -> json.string("DataRequirement")
    DefinedtypesCount -> json.string("Count")
    DefinedtypesContributor -> json.string("Contributor")
    DefinedtypesContactpoint -> json.string("ContactPoint")
    DefinedtypesContactdetail -> json.string("ContactDetail")
    DefinedtypesCoding -> json.string("Coding")
    DefinedtypesCodeableconcept -> json.string("CodeableConcept")
    DefinedtypesBackboneelement -> json.string("BackboneElement")
    DefinedtypesAttachment -> json.string("Attachment")
    DefinedtypesAnnotation -> json.string("Annotation")
    DefinedtypesAge -> json.string("Age")
    DefinedtypesAddress -> json.string("Address")
  }
}

pub fn definedtypes_decoder() -> Decoder(Definedtypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "VisionPrescription" -> decode.success(DefinedtypesVisionprescription)
    "VerificationResult" -> decode.success(DefinedtypesVerificationresult)
    "ValueSet" -> decode.success(DefinedtypesValueset)
    "TestScript" -> decode.success(DefinedtypesTestscript)
    "TestReport" -> decode.success(DefinedtypesTestreport)
    "TerminologyCapabilities" ->
      decode.success(DefinedtypesTerminologycapabilities)
    "Task" -> decode.success(DefinedtypesTask)
    "SupplyRequest" -> decode.success(DefinedtypesSupplyrequest)
    "SupplyDelivery" -> decode.success(DefinedtypesSupplydelivery)
    "SubstanceSpecification" ->
      decode.success(DefinedtypesSubstancespecification)
    "SubstanceSourceMaterial" ->
      decode.success(DefinedtypesSubstancesourcematerial)
    "SubstanceReferenceInformation" ->
      decode.success(DefinedtypesSubstancereferenceinformation)
    "SubstanceProtein" -> decode.success(DefinedtypesSubstanceprotein)
    "SubstancePolymer" -> decode.success(DefinedtypesSubstancepolymer)
    "SubstanceNucleicAcid" -> decode.success(DefinedtypesSubstancenucleicacid)
    "Substance" -> decode.success(DefinedtypesSubstance)
    "Subscription" -> decode.success(DefinedtypesSubscription)
    "StructureMap" -> decode.success(DefinedtypesStructuremap)
    "StructureDefinition" -> decode.success(DefinedtypesStructuredefinition)
    "SpecimenDefinition" -> decode.success(DefinedtypesSpecimendefinition)
    "Specimen" -> decode.success(DefinedtypesSpecimen)
    "Slot" -> decode.success(DefinedtypesSlot)
    "ServiceRequest" -> decode.success(DefinedtypesServicerequest)
    "SearchParameter" -> decode.success(DefinedtypesSearchparameter)
    "Schedule" -> decode.success(DefinedtypesSchedule)
    "RiskEvidenceSynthesis" -> decode.success(DefinedtypesRiskevidencesynthesis)
    "RiskAssessment" -> decode.success(DefinedtypesRiskassessment)
    "Resource" -> decode.success(DefinedtypesResource)
    "ResearchSubject" -> decode.success(DefinedtypesResearchsubject)
    "ResearchStudy" -> decode.success(DefinedtypesResearchstudy)
    "ResearchElementDefinition" ->
      decode.success(DefinedtypesResearchelementdefinition)
    "ResearchDefinition" -> decode.success(DefinedtypesResearchdefinition)
    "RequestGroup" -> decode.success(DefinedtypesRequestgroup)
    "RelatedPerson" -> decode.success(DefinedtypesRelatedperson)
    "QuestionnaireResponse" -> decode.success(DefinedtypesQuestionnaireresponse)
    "Questionnaire" -> decode.success(DefinedtypesQuestionnaire)
    "Provenance" -> decode.success(DefinedtypesProvenance)
    "Procedure" -> decode.success(DefinedtypesProcedure)
    "PractitionerRole" -> decode.success(DefinedtypesPractitionerrole)
    "Practitioner" -> decode.success(DefinedtypesPractitioner)
    "PlanDefinition" -> decode.success(DefinedtypesPlandefinition)
    "Person" -> decode.success(DefinedtypesPerson)
    "PaymentReconciliation" -> decode.success(DefinedtypesPaymentreconciliation)
    "PaymentNotice" -> decode.success(DefinedtypesPaymentnotice)
    "Patient" -> decode.success(DefinedtypesPatient)
    "Parameters" -> decode.success(DefinedtypesParameters)
    "OrganizationAffiliation" ->
      decode.success(DefinedtypesOrganizationaffiliation)
    "Organization" -> decode.success(DefinedtypesOrganization)
    "OperationOutcome" -> decode.success(DefinedtypesOperationoutcome)
    "OperationDefinition" -> decode.success(DefinedtypesOperationdefinition)
    "ObservationDefinition" -> decode.success(DefinedtypesObservationdefinition)
    "Observation" -> decode.success(DefinedtypesObservation)
    "NutritionOrder" -> decode.success(DefinedtypesNutritionorder)
    "NamingSystem" -> decode.success(DefinedtypesNamingsystem)
    "MolecularSequence" -> decode.success(DefinedtypesMolecularsequence)
    "MessageHeader" -> decode.success(DefinedtypesMessageheader)
    "MessageDefinition" -> decode.success(DefinedtypesMessagedefinition)
    "MedicinalProductUndesirableEffect" ->
      decode.success(DefinedtypesMedicinalproductundesirableeffect)
    "MedicinalProductPharmaceutical" ->
      decode.success(DefinedtypesMedicinalproductpharmaceutical)
    "MedicinalProductPackaged" ->
      decode.success(DefinedtypesMedicinalproductpackaged)
    "MedicinalProductManufactured" ->
      decode.success(DefinedtypesMedicinalproductmanufactured)
    "MedicinalProductInteraction" ->
      decode.success(DefinedtypesMedicinalproductinteraction)
    "MedicinalProductIngredient" ->
      decode.success(DefinedtypesMedicinalproductingredient)
    "MedicinalProductIndication" ->
      decode.success(DefinedtypesMedicinalproductindication)
    "MedicinalProductContraindication" ->
      decode.success(DefinedtypesMedicinalproductcontraindication)
    "MedicinalProductAuthorization" ->
      decode.success(DefinedtypesMedicinalproductauthorization)
    "MedicinalProduct" -> decode.success(DefinedtypesMedicinalproduct)
    "MedicationStatement" -> decode.success(DefinedtypesMedicationstatement)
    "MedicationRequest" -> decode.success(DefinedtypesMedicationrequest)
    "MedicationKnowledge" -> decode.success(DefinedtypesMedicationknowledge)
    "MedicationDispense" -> decode.success(DefinedtypesMedicationdispense)
    "MedicationAdministration" ->
      decode.success(DefinedtypesMedicationadministration)
    "Medication" -> decode.success(DefinedtypesMedication)
    "Media" -> decode.success(DefinedtypesMedia)
    "MeasureReport" -> decode.success(DefinedtypesMeasurereport)
    "Measure" -> decode.success(DefinedtypesMeasure)
    "Location" -> decode.success(DefinedtypesLocation)
    "List" -> decode.success(DefinedtypesList)
    "Linkage" -> decode.success(DefinedtypesLinkage)
    "Library" -> decode.success(DefinedtypesLibrary)
    "Invoice" -> decode.success(DefinedtypesInvoice)
    "InsurancePlan" -> decode.success(DefinedtypesInsuranceplan)
    "ImplementationGuide" -> decode.success(DefinedtypesImplementationguide)
    "ImmunizationRecommendation" ->
      decode.success(DefinedtypesImmunizationrecommendation)
    "ImmunizationEvaluation" ->
      decode.success(DefinedtypesImmunizationevaluation)
    "Immunization" -> decode.success(DefinedtypesImmunization)
    "ImagingStudy" -> decode.success(DefinedtypesImagingstudy)
    "HealthcareService" -> decode.success(DefinedtypesHealthcareservice)
    "GuidanceResponse" -> decode.success(DefinedtypesGuidanceresponse)
    "Group" -> decode.success(DefinedtypesGroup)
    "GraphDefinition" -> decode.success(DefinedtypesGraphdefinition)
    "Goal" -> decode.success(DefinedtypesGoal)
    "Flag" -> decode.success(DefinedtypesFlag)
    "FamilyMemberHistory" -> decode.success(DefinedtypesFamilymemberhistory)
    "ExplanationOfBenefit" -> decode.success(DefinedtypesExplanationofbenefit)
    "ExampleScenario" -> decode.success(DefinedtypesExamplescenario)
    "EvidenceVariable" -> decode.success(DefinedtypesEvidencevariable)
    "Evidence" -> decode.success(DefinedtypesEvidence)
    "EventDefinition" -> decode.success(DefinedtypesEventdefinition)
    "EpisodeOfCare" -> decode.success(DefinedtypesEpisodeofcare)
    "EnrollmentResponse" -> decode.success(DefinedtypesEnrollmentresponse)
    "EnrollmentRequest" -> decode.success(DefinedtypesEnrollmentrequest)
    "Endpoint" -> decode.success(DefinedtypesEndpoint)
    "Encounter" -> decode.success(DefinedtypesEncounter)
    "EffectEvidenceSynthesis" ->
      decode.success(DefinedtypesEffectevidencesynthesis)
    "DomainResource" -> decode.success(DefinedtypesDomainresource)
    "DocumentReference" -> decode.success(DefinedtypesDocumentreference)
    "DocumentManifest" -> decode.success(DefinedtypesDocumentmanifest)
    "DiagnosticReport" -> decode.success(DefinedtypesDiagnosticreport)
    "DeviceUseStatement" -> decode.success(DefinedtypesDeviceusestatement)
    "DeviceRequest" -> decode.success(DefinedtypesDevicerequest)
    "DeviceMetric" -> decode.success(DefinedtypesDevicemetric)
    "DeviceDefinition" -> decode.success(DefinedtypesDevicedefinition)
    "Device" -> decode.success(DefinedtypesDevice)
    "DetectedIssue" -> decode.success(DefinedtypesDetectedissue)
    "CoverageEligibilityResponse" ->
      decode.success(DefinedtypesCoverageeligibilityresponse)
    "CoverageEligibilityRequest" ->
      decode.success(DefinedtypesCoverageeligibilityrequest)
    "Coverage" -> decode.success(DefinedtypesCoverage)
    "Contract" -> decode.success(DefinedtypesContract)
    "Consent" -> decode.success(DefinedtypesConsent)
    "Condition" -> decode.success(DefinedtypesCondition)
    "ConceptMap" -> decode.success(DefinedtypesConceptmap)
    "Composition" -> decode.success(DefinedtypesComposition)
    "CompartmentDefinition" -> decode.success(DefinedtypesCompartmentdefinition)
    "CommunicationRequest" -> decode.success(DefinedtypesCommunicationrequest)
    "Communication" -> decode.success(DefinedtypesCommunication)
    "CodeSystem" -> decode.success(DefinedtypesCodesystem)
    "ClinicalImpression" -> decode.success(DefinedtypesClinicalimpression)
    "ClaimResponse" -> decode.success(DefinedtypesClaimresponse)
    "Claim" -> decode.success(DefinedtypesClaim)
    "ChargeItemDefinition" -> decode.success(DefinedtypesChargeitemdefinition)
    "ChargeItem" -> decode.success(DefinedtypesChargeitem)
    "CatalogEntry" -> decode.success(DefinedtypesCatalogentry)
    "CareTeam" -> decode.success(DefinedtypesCareteam)
    "CarePlan" -> decode.success(DefinedtypesCareplan)
    "CapabilityStatement" -> decode.success(DefinedtypesCapabilitystatement)
    "Bundle" -> decode.success(DefinedtypesBundle)
    "BodyStructure" -> decode.success(DefinedtypesBodystructure)
    "BiologicallyDerivedProduct" ->
      decode.success(DefinedtypesBiologicallyderivedproduct)
    "Binary" -> decode.success(DefinedtypesBinary)
    "Basic" -> decode.success(DefinedtypesBasic)
    "AuditEvent" -> decode.success(DefinedtypesAuditevent)
    "AppointmentResponse" -> decode.success(DefinedtypesAppointmentresponse)
    "Appointment" -> decode.success(DefinedtypesAppointment)
    "AllergyIntolerance" -> decode.success(DefinedtypesAllergyintolerance)
    "AdverseEvent" -> decode.success(DefinedtypesAdverseevent)
    "ActivityDefinition" -> decode.success(DefinedtypesActivitydefinition)
    "Account" -> decode.success(DefinedtypesAccount)
    "xhtml" -> decode.success(DefinedtypesXhtml)
    "uuid" -> decode.success(DefinedtypesUuid)
    "url" -> decode.success(DefinedtypesUrl)
    "uri" -> decode.success(DefinedtypesUri)
    "unsignedInt" -> decode.success(DefinedtypesUnsignedint)
    "time" -> decode.success(DefinedtypesTime)
    "string" -> decode.success(DefinedtypesString)
    "positiveInt" -> decode.success(DefinedtypesPositiveint)
    "oid" -> decode.success(DefinedtypesOid)
    "markdown" -> decode.success(DefinedtypesMarkdown)
    "integer" -> decode.success(DefinedtypesInteger)
    "instant" -> decode.success(DefinedtypesInstant)
    "id" -> decode.success(DefinedtypesId)
    "decimal" -> decode.success(DefinedtypesDecimal)
    "dateTime" -> decode.success(DefinedtypesDatetime)
    "date" -> decode.success(DefinedtypesDate)
    "code" -> decode.success(DefinedtypesCode)
    "canonical" -> decode.success(DefinedtypesCanonical)
    "boolean" -> decode.success(DefinedtypesBoolean)
    "base64Binary" -> decode.success(DefinedtypesBase64binary)
    "UsageContext" -> decode.success(DefinedtypesUsagecontext)
    "TriggerDefinition" -> decode.success(DefinedtypesTriggerdefinition)
    "Timing" -> decode.success(DefinedtypesTiming)
    "SubstanceAmount" -> decode.success(DefinedtypesSubstanceamount)
    "SimpleQuantity" -> decode.success(DefinedtypesSimplequantity)
    "Signature" -> decode.success(DefinedtypesSignature)
    "SampledData" -> decode.success(DefinedtypesSampleddata)
    "RelatedArtifact" -> decode.success(DefinedtypesRelatedartifact)
    "Reference" -> decode.success(DefinedtypesReference)
    "Ratio" -> decode.success(DefinedtypesRatio)
    "Range" -> decode.success(DefinedtypesRange)
    "Quantity" -> decode.success(DefinedtypesQuantity)
    "ProductShelfLife" -> decode.success(DefinedtypesProductshelflife)
    "ProdCharacteristic" -> decode.success(DefinedtypesProdcharacteristic)
    "Population" -> decode.success(DefinedtypesPopulation)
    "Period" -> decode.success(DefinedtypesPeriod)
    "ParameterDefinition" -> decode.success(DefinedtypesParameterdefinition)
    "Narrative" -> decode.success(DefinedtypesNarrative)
    "MoneyQuantity" -> decode.success(DefinedtypesMoneyquantity)
    "Money" -> decode.success(DefinedtypesMoney)
    "Meta" -> decode.success(DefinedtypesMeta)
    "MarketingStatus" -> decode.success(DefinedtypesMarketingstatus)
    "Identifier" -> decode.success(DefinedtypesIdentifier)
    "HumanName" -> decode.success(DefinedtypesHumanname)
    "Extension" -> decode.success(DefinedtypesExtension)
    "Expression" -> decode.success(DefinedtypesExpression)
    "ElementDefinition" -> decode.success(DefinedtypesElementdefinition)
    "Element" -> decode.success(DefinedtypesElement)
    "Duration" -> decode.success(DefinedtypesDuration)
    "Dosage" -> decode.success(DefinedtypesDosage)
    "Distance" -> decode.success(DefinedtypesDistance)
    "DataRequirement" -> decode.success(DefinedtypesDatarequirement)
    "Count" -> decode.success(DefinedtypesCount)
    "Contributor" -> decode.success(DefinedtypesContributor)
    "ContactPoint" -> decode.success(DefinedtypesContactpoint)
    "ContactDetail" -> decode.success(DefinedtypesContactdetail)
    "Coding" -> decode.success(DefinedtypesCoding)
    "CodeableConcept" -> decode.success(DefinedtypesCodeableconcept)
    "BackboneElement" -> decode.success(DefinedtypesBackboneelement)
    "Attachment" -> decode.success(DefinedtypesAttachment)
    "Annotation" -> decode.success(DefinedtypesAnnotation)
    "Age" -> decode.success(DefinedtypesAge)
    "Address" -> decode.success(DefinedtypesAddress)
    _ -> decode.failure(DefinedtypesVisionprescription, "Definedtypes")
  }
}

pub type Adverseeventactuality {
  AdverseeventactualityPotential
  AdverseeventactualityActual
}

pub fn adverseeventactuality_to_json(
  adverseeventactuality: Adverseeventactuality,
) -> Json {
  case adverseeventactuality {
    AdverseeventactualityPotential -> json.string("potential")
    AdverseeventactualityActual -> json.string("actual")
  }
}

pub fn adverseeventactuality_decoder() -> Decoder(Adverseeventactuality) {
  use variant <- decode.then(decode.string)
  case variant {
    "potential" -> decode.success(AdverseeventactualityPotential)
    "actual" -> decode.success(AdverseeventactualityActual)
    _ -> decode.failure(AdverseeventactualityPotential, "Adverseeventactuality")
  }
}

pub type Mapmodelmode {
  MapmodelmodeProduced
  MapmodelmodeTarget
  MapmodelmodeQueried
  MapmodelmodeSource
}

pub fn mapmodelmode_to_json(mapmodelmode: Mapmodelmode) -> Json {
  case mapmodelmode {
    MapmodelmodeProduced -> json.string("produced")
    MapmodelmodeTarget -> json.string("target")
    MapmodelmodeQueried -> json.string("queried")
    MapmodelmodeSource -> json.string("source")
  }
}

pub fn mapmodelmode_decoder() -> Decoder(Mapmodelmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "produced" -> decode.success(MapmodelmodeProduced)
    "target" -> decode.success(MapmodelmodeTarget)
    "queried" -> decode.success(MapmodelmodeQueried)
    "source" -> decode.success(MapmodelmodeSource)
    _ -> decode.failure(MapmodelmodeProduced, "Mapmodelmode")
  }
}

pub type Linktype {
  LinktypeSeealso
  LinktypeRefer
  LinktypeReplaces
  LinktypeReplacedby
}

pub fn linktype_to_json(linktype: Linktype) -> Json {
  case linktype {
    LinktypeSeealso -> json.string("seealso")
    LinktypeRefer -> json.string("refer")
    LinktypeReplaces -> json.string("replaces")
    LinktypeReplacedby -> json.string("replaced-by")
  }
}

pub fn linktype_decoder() -> Decoder(Linktype) {
  use variant <- decode.then(decode.string)
  case variant {
    "seealso" -> decode.success(LinktypeSeealso)
    "refer" -> decode.success(LinktypeRefer)
    "replaces" -> decode.success(LinktypeReplaces)
    "replaced-by" -> decode.success(LinktypeReplacedby)
    _ -> decode.failure(LinktypeSeealso, "Linktype")
  }
}

pub type Taskstatus {
  TaskstatusEnteredinerror
  TaskstatusCompleted
  TaskstatusFailed
  TaskstatusOnhold
  TaskstatusInprogress
  TaskstatusCancelled
  TaskstatusReady
  TaskstatusRejected
  TaskstatusAccepted
  TaskstatusReceived
  TaskstatusRequested
  TaskstatusDraft
}

pub fn taskstatus_to_json(taskstatus: Taskstatus) -> Json {
  case taskstatus {
    TaskstatusEnteredinerror -> json.string("entered-in-error")
    TaskstatusCompleted -> json.string("completed")
    TaskstatusFailed -> json.string("failed")
    TaskstatusOnhold -> json.string("on-hold")
    TaskstatusInprogress -> json.string("in-progress")
    TaskstatusCancelled -> json.string("cancelled")
    TaskstatusReady -> json.string("ready")
    TaskstatusRejected -> json.string("rejected")
    TaskstatusAccepted -> json.string("accepted")
    TaskstatusReceived -> json.string("received")
    TaskstatusRequested -> json.string("requested")
    TaskstatusDraft -> json.string("draft")
  }
}

pub fn taskstatus_decoder() -> Decoder(Taskstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(TaskstatusEnteredinerror)
    "completed" -> decode.success(TaskstatusCompleted)
    "failed" -> decode.success(TaskstatusFailed)
    "on-hold" -> decode.success(TaskstatusOnhold)
    "in-progress" -> decode.success(TaskstatusInprogress)
    "cancelled" -> decode.success(TaskstatusCancelled)
    "ready" -> decode.success(TaskstatusReady)
    "rejected" -> decode.success(TaskstatusRejected)
    "accepted" -> decode.success(TaskstatusAccepted)
    "received" -> decode.success(TaskstatusReceived)
    "requested" -> decode.success(TaskstatusRequested)
    "draft" -> decode.success(TaskstatusDraft)
    _ -> decode.failure(TaskstatusEnteredinerror, "Taskstatus")
  }
}

pub type Propertyrepresentation {
  PropertyrepresentationXhtml
  PropertyrepresentationCdatext
  PropertyrepresentationTypeattr
  PropertyrepresentationXmltext
  PropertyrepresentationXmlattr
}

pub fn propertyrepresentation_to_json(
  propertyrepresentation: Propertyrepresentation,
) -> Json {
  case propertyrepresentation {
    PropertyrepresentationXhtml -> json.string("xhtml")
    PropertyrepresentationCdatext -> json.string("cdaText")
    PropertyrepresentationTypeattr -> json.string("typeAttr")
    PropertyrepresentationXmltext -> json.string("xmlText")
    PropertyrepresentationXmlattr -> json.string("xmlAttr")
  }
}

pub fn propertyrepresentation_decoder() -> Decoder(Propertyrepresentation) {
  use variant <- decode.then(decode.string)
  case variant {
    "xhtml" -> decode.success(PropertyrepresentationXhtml)
    "cdaText" -> decode.success(PropertyrepresentationCdatext)
    "typeAttr" -> decode.success(PropertyrepresentationTypeattr)
    "xmlText" -> decode.success(PropertyrepresentationXmltext)
    "xmlAttr" -> decode.success(PropertyrepresentationXmlattr)
    _ -> decode.failure(PropertyrepresentationXhtml, "Propertyrepresentation")
  }
}

pub type Invoicepricecomponenttype {
  InvoicepricecomponenttypeInformational
  InvoicepricecomponenttypeTax
  InvoicepricecomponenttypeDiscount
  InvoicepricecomponenttypeDeduction
  InvoicepricecomponenttypeSurcharge
  InvoicepricecomponenttypeBase
}

pub fn invoicepricecomponenttype_to_json(
  invoicepricecomponenttype: Invoicepricecomponenttype,
) -> Json {
  case invoicepricecomponenttype {
    InvoicepricecomponenttypeInformational -> json.string("informational")
    InvoicepricecomponenttypeTax -> json.string("tax")
    InvoicepricecomponenttypeDiscount -> json.string("discount")
    InvoicepricecomponenttypeDeduction -> json.string("deduction")
    InvoicepricecomponenttypeSurcharge -> json.string("surcharge")
    InvoicepricecomponenttypeBase -> json.string("base")
  }
}

pub fn invoicepricecomponenttype_decoder() -> Decoder(Invoicepricecomponenttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "informational" -> decode.success(InvoicepricecomponenttypeInformational)
    "tax" -> decode.success(InvoicepricecomponenttypeTax)
    "discount" -> decode.success(InvoicepricecomponenttypeDiscount)
    "deduction" -> decode.success(InvoicepricecomponenttypeDeduction)
    "surcharge" -> decode.success(InvoicepricecomponenttypeSurcharge)
    "base" -> decode.success(InvoicepricecomponenttypeBase)
    _ ->
      decode.failure(
        InvoicepricecomponenttypeInformational,
        "Invoicepricecomponenttype",
      )
  }
}

pub type Careplanactivitykind {
  CareplanactivitykindVisionprescription
  CareplanactivitykindVerificationresult
  CareplanactivitykindValueset
  CareplanactivitykindTestscript
  CareplanactivitykindTestreport
  CareplanactivitykindTerminologycapabilities
  CareplanactivitykindTask
  CareplanactivitykindSupplyrequest
  CareplanactivitykindSupplydelivery
  CareplanactivitykindSubstancespecification
  CareplanactivitykindSubstancesourcematerial
  CareplanactivitykindSubstancereferenceinformation
  CareplanactivitykindSubstanceprotein
  CareplanactivitykindSubstancepolymer
  CareplanactivitykindSubstancenucleicacid
  CareplanactivitykindSubstance
  CareplanactivitykindSubscription
  CareplanactivitykindStructuremap
  CareplanactivitykindStructuredefinition
  CareplanactivitykindSpecimendefinition
  CareplanactivitykindSpecimen
  CareplanactivitykindSlot
  CareplanactivitykindServicerequest
  CareplanactivitykindSearchparameter
  CareplanactivitykindSchedule
  CareplanactivitykindRiskevidencesynthesis
  CareplanactivitykindRiskassessment
  CareplanactivitykindResource
  CareplanactivitykindResearchsubject
  CareplanactivitykindResearchstudy
  CareplanactivitykindResearchelementdefinition
  CareplanactivitykindResearchdefinition
  CareplanactivitykindRequestgroup
  CareplanactivitykindRelatedperson
  CareplanactivitykindQuestionnaireresponse
  CareplanactivitykindQuestionnaire
  CareplanactivitykindProvenance
  CareplanactivitykindProcedure
  CareplanactivitykindPractitionerrole
  CareplanactivitykindPractitioner
  CareplanactivitykindPlandefinition
  CareplanactivitykindPerson
  CareplanactivitykindPaymentreconciliation
  CareplanactivitykindPaymentnotice
  CareplanactivitykindPatient
  CareplanactivitykindParameters
  CareplanactivitykindOrganizationaffiliation
  CareplanactivitykindOrganization
  CareplanactivitykindOperationoutcome
  CareplanactivitykindOperationdefinition
  CareplanactivitykindObservationdefinition
  CareplanactivitykindObservation
  CareplanactivitykindNutritionorder
  CareplanactivitykindNamingsystem
  CareplanactivitykindMolecularsequence
  CareplanactivitykindMessageheader
  CareplanactivitykindMessagedefinition
  CareplanactivitykindMedicinalproductundesirableeffect
  CareplanactivitykindMedicinalproductpharmaceutical
  CareplanactivitykindMedicinalproductpackaged
  CareplanactivitykindMedicinalproductmanufactured
  CareplanactivitykindMedicinalproductinteraction
  CareplanactivitykindMedicinalproductingredient
  CareplanactivitykindMedicinalproductindication
  CareplanactivitykindMedicinalproductcontraindication
  CareplanactivitykindMedicinalproductauthorization
  CareplanactivitykindMedicinalproduct
  CareplanactivitykindMedicationstatement
  CareplanactivitykindMedicationrequest
  CareplanactivitykindMedicationknowledge
  CareplanactivitykindMedicationdispense
  CareplanactivitykindMedicationadministration
  CareplanactivitykindMedication
  CareplanactivitykindMedia
  CareplanactivitykindMeasurereport
  CareplanactivitykindMeasure
  CareplanactivitykindLocation
  CareplanactivitykindList
  CareplanactivitykindLinkage
  CareplanactivitykindLibrary
  CareplanactivitykindInvoice
  CareplanactivitykindInsuranceplan
  CareplanactivitykindImplementationguide
  CareplanactivitykindImmunizationrecommendation
  CareplanactivitykindImmunizationevaluation
  CareplanactivitykindImmunization
  CareplanactivitykindImagingstudy
  CareplanactivitykindHealthcareservice
  CareplanactivitykindGuidanceresponse
  CareplanactivitykindGroup
  CareplanactivitykindGraphdefinition
  CareplanactivitykindGoal
  CareplanactivitykindFlag
  CareplanactivitykindFamilymemberhistory
  CareplanactivitykindExplanationofbenefit
  CareplanactivitykindExamplescenario
  CareplanactivitykindEvidencevariable
  CareplanactivitykindEvidence
  CareplanactivitykindEventdefinition
  CareplanactivitykindEpisodeofcare
  CareplanactivitykindEnrollmentresponse
  CareplanactivitykindEnrollmentrequest
  CareplanactivitykindEndpoint
  CareplanactivitykindEncounter
  CareplanactivitykindEffectevidencesynthesis
  CareplanactivitykindDomainresource
  CareplanactivitykindDocumentreference
  CareplanactivitykindDocumentmanifest
  CareplanactivitykindDiagnosticreport
  CareplanactivitykindDeviceusestatement
  CareplanactivitykindDevicerequest
  CareplanactivitykindDevicemetric
  CareplanactivitykindDevicedefinition
  CareplanactivitykindDevice
  CareplanactivitykindDetectedissue
  CareplanactivitykindCoverageeligibilityresponse
  CareplanactivitykindCoverageeligibilityrequest
  CareplanactivitykindCoverage
  CareplanactivitykindContract
  CareplanactivitykindConsent
  CareplanactivitykindCondition
  CareplanactivitykindConceptmap
  CareplanactivitykindComposition
  CareplanactivitykindCompartmentdefinition
  CareplanactivitykindCommunicationrequest
  CareplanactivitykindCommunication
  CareplanactivitykindCodesystem
  CareplanactivitykindClinicalimpression
  CareplanactivitykindClaimresponse
  CareplanactivitykindClaim
  CareplanactivitykindChargeitemdefinition
  CareplanactivitykindChargeitem
  CareplanactivitykindCatalogentry
  CareplanactivitykindCareteam
  CareplanactivitykindCareplan
  CareplanactivitykindCapabilitystatement
  CareplanactivitykindBundle
  CareplanactivitykindBodystructure
  CareplanactivitykindBiologicallyderivedproduct
  CareplanactivitykindBinary
  CareplanactivitykindBasic
  CareplanactivitykindAuditevent
  CareplanactivitykindAppointmentresponse
  CareplanactivitykindAppointment
  CareplanactivitykindAllergyintolerance
  CareplanactivitykindAdverseevent
  CareplanactivitykindActivitydefinition
  CareplanactivitykindAccount
}

pub fn careplanactivitykind_to_json(
  careplanactivitykind: Careplanactivitykind,
) -> Json {
  case careplanactivitykind {
    CareplanactivitykindVisionprescription -> json.string("VisionPrescription")
    CareplanactivitykindVerificationresult -> json.string("VerificationResult")
    CareplanactivitykindValueset -> json.string("ValueSet")
    CareplanactivitykindTestscript -> json.string("TestScript")
    CareplanactivitykindTestreport -> json.string("TestReport")
    CareplanactivitykindTerminologycapabilities ->
      json.string("TerminologyCapabilities")
    CareplanactivitykindTask -> json.string("Task")
    CareplanactivitykindSupplyrequest -> json.string("SupplyRequest")
    CareplanactivitykindSupplydelivery -> json.string("SupplyDelivery")
    CareplanactivitykindSubstancespecification ->
      json.string("SubstanceSpecification")
    CareplanactivitykindSubstancesourcematerial ->
      json.string("SubstanceSourceMaterial")
    CareplanactivitykindSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    CareplanactivitykindSubstanceprotein -> json.string("SubstanceProtein")
    CareplanactivitykindSubstancepolymer -> json.string("SubstancePolymer")
    CareplanactivitykindSubstancenucleicacid ->
      json.string("SubstanceNucleicAcid")
    CareplanactivitykindSubstance -> json.string("Substance")
    CareplanactivitykindSubscription -> json.string("Subscription")
    CareplanactivitykindStructuremap -> json.string("StructureMap")
    CareplanactivitykindStructuredefinition ->
      json.string("StructureDefinition")
    CareplanactivitykindSpecimendefinition -> json.string("SpecimenDefinition")
    CareplanactivitykindSpecimen -> json.string("Specimen")
    CareplanactivitykindSlot -> json.string("Slot")
    CareplanactivitykindServicerequest -> json.string("ServiceRequest")
    CareplanactivitykindSearchparameter -> json.string("SearchParameter")
    CareplanactivitykindSchedule -> json.string("Schedule")
    CareplanactivitykindRiskevidencesynthesis ->
      json.string("RiskEvidenceSynthesis")
    CareplanactivitykindRiskassessment -> json.string("RiskAssessment")
    CareplanactivitykindResource -> json.string("Resource")
    CareplanactivitykindResearchsubject -> json.string("ResearchSubject")
    CareplanactivitykindResearchstudy -> json.string("ResearchStudy")
    CareplanactivitykindResearchelementdefinition ->
      json.string("ResearchElementDefinition")
    CareplanactivitykindResearchdefinition -> json.string("ResearchDefinition")
    CareplanactivitykindRequestgroup -> json.string("RequestGroup")
    CareplanactivitykindRelatedperson -> json.string("RelatedPerson")
    CareplanactivitykindQuestionnaireresponse ->
      json.string("QuestionnaireResponse")
    CareplanactivitykindQuestionnaire -> json.string("Questionnaire")
    CareplanactivitykindProvenance -> json.string("Provenance")
    CareplanactivitykindProcedure -> json.string("Procedure")
    CareplanactivitykindPractitionerrole -> json.string("PractitionerRole")
    CareplanactivitykindPractitioner -> json.string("Practitioner")
    CareplanactivitykindPlandefinition -> json.string("PlanDefinition")
    CareplanactivitykindPerson -> json.string("Person")
    CareplanactivitykindPaymentreconciliation ->
      json.string("PaymentReconciliation")
    CareplanactivitykindPaymentnotice -> json.string("PaymentNotice")
    CareplanactivitykindPatient -> json.string("Patient")
    CareplanactivitykindParameters -> json.string("Parameters")
    CareplanactivitykindOrganizationaffiliation ->
      json.string("OrganizationAffiliation")
    CareplanactivitykindOrganization -> json.string("Organization")
    CareplanactivitykindOperationoutcome -> json.string("OperationOutcome")
    CareplanactivitykindOperationdefinition ->
      json.string("OperationDefinition")
    CareplanactivitykindObservationdefinition ->
      json.string("ObservationDefinition")
    CareplanactivitykindObservation -> json.string("Observation")
    CareplanactivitykindNutritionorder -> json.string("NutritionOrder")
    CareplanactivitykindNamingsystem -> json.string("NamingSystem")
    CareplanactivitykindMolecularsequence -> json.string("MolecularSequence")
    CareplanactivitykindMessageheader -> json.string("MessageHeader")
    CareplanactivitykindMessagedefinition -> json.string("MessageDefinition")
    CareplanactivitykindMedicinalproductundesirableeffect ->
      json.string("MedicinalProductUndesirableEffect")
    CareplanactivitykindMedicinalproductpharmaceutical ->
      json.string("MedicinalProductPharmaceutical")
    CareplanactivitykindMedicinalproductpackaged ->
      json.string("MedicinalProductPackaged")
    CareplanactivitykindMedicinalproductmanufactured ->
      json.string("MedicinalProductManufactured")
    CareplanactivitykindMedicinalproductinteraction ->
      json.string("MedicinalProductInteraction")
    CareplanactivitykindMedicinalproductingredient ->
      json.string("MedicinalProductIngredient")
    CareplanactivitykindMedicinalproductindication ->
      json.string("MedicinalProductIndication")
    CareplanactivitykindMedicinalproductcontraindication ->
      json.string("MedicinalProductContraindication")
    CareplanactivitykindMedicinalproductauthorization ->
      json.string("MedicinalProductAuthorization")
    CareplanactivitykindMedicinalproduct -> json.string("MedicinalProduct")
    CareplanactivitykindMedicationstatement ->
      json.string("MedicationStatement")
    CareplanactivitykindMedicationrequest -> json.string("MedicationRequest")
    CareplanactivitykindMedicationknowledge ->
      json.string("MedicationKnowledge")
    CareplanactivitykindMedicationdispense -> json.string("MedicationDispense")
    CareplanactivitykindMedicationadministration ->
      json.string("MedicationAdministration")
    CareplanactivitykindMedication -> json.string("Medication")
    CareplanactivitykindMedia -> json.string("Media")
    CareplanactivitykindMeasurereport -> json.string("MeasureReport")
    CareplanactivitykindMeasure -> json.string("Measure")
    CareplanactivitykindLocation -> json.string("Location")
    CareplanactivitykindList -> json.string("List")
    CareplanactivitykindLinkage -> json.string("Linkage")
    CareplanactivitykindLibrary -> json.string("Library")
    CareplanactivitykindInvoice -> json.string("Invoice")
    CareplanactivitykindInsuranceplan -> json.string("InsurancePlan")
    CareplanactivitykindImplementationguide ->
      json.string("ImplementationGuide")
    CareplanactivitykindImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    CareplanactivitykindImmunizationevaluation ->
      json.string("ImmunizationEvaluation")
    CareplanactivitykindImmunization -> json.string("Immunization")
    CareplanactivitykindImagingstudy -> json.string("ImagingStudy")
    CareplanactivitykindHealthcareservice -> json.string("HealthcareService")
    CareplanactivitykindGuidanceresponse -> json.string("GuidanceResponse")
    CareplanactivitykindGroup -> json.string("Group")
    CareplanactivitykindGraphdefinition -> json.string("GraphDefinition")
    CareplanactivitykindGoal -> json.string("Goal")
    CareplanactivitykindFlag -> json.string("Flag")
    CareplanactivitykindFamilymemberhistory ->
      json.string("FamilyMemberHistory")
    CareplanactivitykindExplanationofbenefit ->
      json.string("ExplanationOfBenefit")
    CareplanactivitykindExamplescenario -> json.string("ExampleScenario")
    CareplanactivitykindEvidencevariable -> json.string("EvidenceVariable")
    CareplanactivitykindEvidence -> json.string("Evidence")
    CareplanactivitykindEventdefinition -> json.string("EventDefinition")
    CareplanactivitykindEpisodeofcare -> json.string("EpisodeOfCare")
    CareplanactivitykindEnrollmentresponse -> json.string("EnrollmentResponse")
    CareplanactivitykindEnrollmentrequest -> json.string("EnrollmentRequest")
    CareplanactivitykindEndpoint -> json.string("Endpoint")
    CareplanactivitykindEncounter -> json.string("Encounter")
    CareplanactivitykindEffectevidencesynthesis ->
      json.string("EffectEvidenceSynthesis")
    CareplanactivitykindDomainresource -> json.string("DomainResource")
    CareplanactivitykindDocumentreference -> json.string("DocumentReference")
    CareplanactivitykindDocumentmanifest -> json.string("DocumentManifest")
    CareplanactivitykindDiagnosticreport -> json.string("DiagnosticReport")
    CareplanactivitykindDeviceusestatement -> json.string("DeviceUseStatement")
    CareplanactivitykindDevicerequest -> json.string("DeviceRequest")
    CareplanactivitykindDevicemetric -> json.string("DeviceMetric")
    CareplanactivitykindDevicedefinition -> json.string("DeviceDefinition")
    CareplanactivitykindDevice -> json.string("Device")
    CareplanactivitykindDetectedissue -> json.string("DetectedIssue")
    CareplanactivitykindCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    CareplanactivitykindCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    CareplanactivitykindCoverage -> json.string("Coverage")
    CareplanactivitykindContract -> json.string("Contract")
    CareplanactivitykindConsent -> json.string("Consent")
    CareplanactivitykindCondition -> json.string("Condition")
    CareplanactivitykindConceptmap -> json.string("ConceptMap")
    CareplanactivitykindComposition -> json.string("Composition")
    CareplanactivitykindCompartmentdefinition ->
      json.string("CompartmentDefinition")
    CareplanactivitykindCommunicationrequest ->
      json.string("CommunicationRequest")
    CareplanactivitykindCommunication -> json.string("Communication")
    CareplanactivitykindCodesystem -> json.string("CodeSystem")
    CareplanactivitykindClinicalimpression -> json.string("ClinicalImpression")
    CareplanactivitykindClaimresponse -> json.string("ClaimResponse")
    CareplanactivitykindClaim -> json.string("Claim")
    CareplanactivitykindChargeitemdefinition ->
      json.string("ChargeItemDefinition")
    CareplanactivitykindChargeitem -> json.string("ChargeItem")
    CareplanactivitykindCatalogentry -> json.string("CatalogEntry")
    CareplanactivitykindCareteam -> json.string("CareTeam")
    CareplanactivitykindCareplan -> json.string("CarePlan")
    CareplanactivitykindCapabilitystatement ->
      json.string("CapabilityStatement")
    CareplanactivitykindBundle -> json.string("Bundle")
    CareplanactivitykindBodystructure -> json.string("BodyStructure")
    CareplanactivitykindBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    CareplanactivitykindBinary -> json.string("Binary")
    CareplanactivitykindBasic -> json.string("Basic")
    CareplanactivitykindAuditevent -> json.string("AuditEvent")
    CareplanactivitykindAppointmentresponse ->
      json.string("AppointmentResponse")
    CareplanactivitykindAppointment -> json.string("Appointment")
    CareplanactivitykindAllergyintolerance -> json.string("AllergyIntolerance")
    CareplanactivitykindAdverseevent -> json.string("AdverseEvent")
    CareplanactivitykindActivitydefinition -> json.string("ActivityDefinition")
    CareplanactivitykindAccount -> json.string("Account")
  }
}

pub fn careplanactivitykind_decoder() -> Decoder(Careplanactivitykind) {
  use variant <- decode.then(decode.string)
  case variant {
    "VisionPrescription" ->
      decode.success(CareplanactivitykindVisionprescription)
    "VerificationResult" ->
      decode.success(CareplanactivitykindVerificationresult)
    "ValueSet" -> decode.success(CareplanactivitykindValueset)
    "TestScript" -> decode.success(CareplanactivitykindTestscript)
    "TestReport" -> decode.success(CareplanactivitykindTestreport)
    "TerminologyCapabilities" ->
      decode.success(CareplanactivitykindTerminologycapabilities)
    "Task" -> decode.success(CareplanactivitykindTask)
    "SupplyRequest" -> decode.success(CareplanactivitykindSupplyrequest)
    "SupplyDelivery" -> decode.success(CareplanactivitykindSupplydelivery)
    "SubstanceSpecification" ->
      decode.success(CareplanactivitykindSubstancespecification)
    "SubstanceSourceMaterial" ->
      decode.success(CareplanactivitykindSubstancesourcematerial)
    "SubstanceReferenceInformation" ->
      decode.success(CareplanactivitykindSubstancereferenceinformation)
    "SubstanceProtein" -> decode.success(CareplanactivitykindSubstanceprotein)
    "SubstancePolymer" -> decode.success(CareplanactivitykindSubstancepolymer)
    "SubstanceNucleicAcid" ->
      decode.success(CareplanactivitykindSubstancenucleicacid)
    "Substance" -> decode.success(CareplanactivitykindSubstance)
    "Subscription" -> decode.success(CareplanactivitykindSubscription)
    "StructureMap" -> decode.success(CareplanactivitykindStructuremap)
    "StructureDefinition" ->
      decode.success(CareplanactivitykindStructuredefinition)
    "SpecimenDefinition" ->
      decode.success(CareplanactivitykindSpecimendefinition)
    "Specimen" -> decode.success(CareplanactivitykindSpecimen)
    "Slot" -> decode.success(CareplanactivitykindSlot)
    "ServiceRequest" -> decode.success(CareplanactivitykindServicerequest)
    "SearchParameter" -> decode.success(CareplanactivitykindSearchparameter)
    "Schedule" -> decode.success(CareplanactivitykindSchedule)
    "RiskEvidenceSynthesis" ->
      decode.success(CareplanactivitykindRiskevidencesynthesis)
    "RiskAssessment" -> decode.success(CareplanactivitykindRiskassessment)
    "Resource" -> decode.success(CareplanactivitykindResource)
    "ResearchSubject" -> decode.success(CareplanactivitykindResearchsubject)
    "ResearchStudy" -> decode.success(CareplanactivitykindResearchstudy)
    "ResearchElementDefinition" ->
      decode.success(CareplanactivitykindResearchelementdefinition)
    "ResearchDefinition" ->
      decode.success(CareplanactivitykindResearchdefinition)
    "RequestGroup" -> decode.success(CareplanactivitykindRequestgroup)
    "RelatedPerson" -> decode.success(CareplanactivitykindRelatedperson)
    "QuestionnaireResponse" ->
      decode.success(CareplanactivitykindQuestionnaireresponse)
    "Questionnaire" -> decode.success(CareplanactivitykindQuestionnaire)
    "Provenance" -> decode.success(CareplanactivitykindProvenance)
    "Procedure" -> decode.success(CareplanactivitykindProcedure)
    "PractitionerRole" -> decode.success(CareplanactivitykindPractitionerrole)
    "Practitioner" -> decode.success(CareplanactivitykindPractitioner)
    "PlanDefinition" -> decode.success(CareplanactivitykindPlandefinition)
    "Person" -> decode.success(CareplanactivitykindPerson)
    "PaymentReconciliation" ->
      decode.success(CareplanactivitykindPaymentreconciliation)
    "PaymentNotice" -> decode.success(CareplanactivitykindPaymentnotice)
    "Patient" -> decode.success(CareplanactivitykindPatient)
    "Parameters" -> decode.success(CareplanactivitykindParameters)
    "OrganizationAffiliation" ->
      decode.success(CareplanactivitykindOrganizationaffiliation)
    "Organization" -> decode.success(CareplanactivitykindOrganization)
    "OperationOutcome" -> decode.success(CareplanactivitykindOperationoutcome)
    "OperationDefinition" ->
      decode.success(CareplanactivitykindOperationdefinition)
    "ObservationDefinition" ->
      decode.success(CareplanactivitykindObservationdefinition)
    "Observation" -> decode.success(CareplanactivitykindObservation)
    "NutritionOrder" -> decode.success(CareplanactivitykindNutritionorder)
    "NamingSystem" -> decode.success(CareplanactivitykindNamingsystem)
    "MolecularSequence" -> decode.success(CareplanactivitykindMolecularsequence)
    "MessageHeader" -> decode.success(CareplanactivitykindMessageheader)
    "MessageDefinition" -> decode.success(CareplanactivitykindMessagedefinition)
    "MedicinalProductUndesirableEffect" ->
      decode.success(CareplanactivitykindMedicinalproductundesirableeffect)
    "MedicinalProductPharmaceutical" ->
      decode.success(CareplanactivitykindMedicinalproductpharmaceutical)
    "MedicinalProductPackaged" ->
      decode.success(CareplanactivitykindMedicinalproductpackaged)
    "MedicinalProductManufactured" ->
      decode.success(CareplanactivitykindMedicinalproductmanufactured)
    "MedicinalProductInteraction" ->
      decode.success(CareplanactivitykindMedicinalproductinteraction)
    "MedicinalProductIngredient" ->
      decode.success(CareplanactivitykindMedicinalproductingredient)
    "MedicinalProductIndication" ->
      decode.success(CareplanactivitykindMedicinalproductindication)
    "MedicinalProductContraindication" ->
      decode.success(CareplanactivitykindMedicinalproductcontraindication)
    "MedicinalProductAuthorization" ->
      decode.success(CareplanactivitykindMedicinalproductauthorization)
    "MedicinalProduct" -> decode.success(CareplanactivitykindMedicinalproduct)
    "MedicationStatement" ->
      decode.success(CareplanactivitykindMedicationstatement)
    "MedicationRequest" -> decode.success(CareplanactivitykindMedicationrequest)
    "MedicationKnowledge" ->
      decode.success(CareplanactivitykindMedicationknowledge)
    "MedicationDispense" ->
      decode.success(CareplanactivitykindMedicationdispense)
    "MedicationAdministration" ->
      decode.success(CareplanactivitykindMedicationadministration)
    "Medication" -> decode.success(CareplanactivitykindMedication)
    "Media" -> decode.success(CareplanactivitykindMedia)
    "MeasureReport" -> decode.success(CareplanactivitykindMeasurereport)
    "Measure" -> decode.success(CareplanactivitykindMeasure)
    "Location" -> decode.success(CareplanactivitykindLocation)
    "List" -> decode.success(CareplanactivitykindList)
    "Linkage" -> decode.success(CareplanactivitykindLinkage)
    "Library" -> decode.success(CareplanactivitykindLibrary)
    "Invoice" -> decode.success(CareplanactivitykindInvoice)
    "InsurancePlan" -> decode.success(CareplanactivitykindInsuranceplan)
    "ImplementationGuide" ->
      decode.success(CareplanactivitykindImplementationguide)
    "ImmunizationRecommendation" ->
      decode.success(CareplanactivitykindImmunizationrecommendation)
    "ImmunizationEvaluation" ->
      decode.success(CareplanactivitykindImmunizationevaluation)
    "Immunization" -> decode.success(CareplanactivitykindImmunization)
    "ImagingStudy" -> decode.success(CareplanactivitykindImagingstudy)
    "HealthcareService" -> decode.success(CareplanactivitykindHealthcareservice)
    "GuidanceResponse" -> decode.success(CareplanactivitykindGuidanceresponse)
    "Group" -> decode.success(CareplanactivitykindGroup)
    "GraphDefinition" -> decode.success(CareplanactivitykindGraphdefinition)
    "Goal" -> decode.success(CareplanactivitykindGoal)
    "Flag" -> decode.success(CareplanactivitykindFlag)
    "FamilyMemberHistory" ->
      decode.success(CareplanactivitykindFamilymemberhistory)
    "ExplanationOfBenefit" ->
      decode.success(CareplanactivitykindExplanationofbenefit)
    "ExampleScenario" -> decode.success(CareplanactivitykindExamplescenario)
    "EvidenceVariable" -> decode.success(CareplanactivitykindEvidencevariable)
    "Evidence" -> decode.success(CareplanactivitykindEvidence)
    "EventDefinition" -> decode.success(CareplanactivitykindEventdefinition)
    "EpisodeOfCare" -> decode.success(CareplanactivitykindEpisodeofcare)
    "EnrollmentResponse" ->
      decode.success(CareplanactivitykindEnrollmentresponse)
    "EnrollmentRequest" -> decode.success(CareplanactivitykindEnrollmentrequest)
    "Endpoint" -> decode.success(CareplanactivitykindEndpoint)
    "Encounter" -> decode.success(CareplanactivitykindEncounter)
    "EffectEvidenceSynthesis" ->
      decode.success(CareplanactivitykindEffectevidencesynthesis)
    "DomainResource" -> decode.success(CareplanactivitykindDomainresource)
    "DocumentReference" -> decode.success(CareplanactivitykindDocumentreference)
    "DocumentManifest" -> decode.success(CareplanactivitykindDocumentmanifest)
    "DiagnosticReport" -> decode.success(CareplanactivitykindDiagnosticreport)
    "DeviceUseStatement" ->
      decode.success(CareplanactivitykindDeviceusestatement)
    "DeviceRequest" -> decode.success(CareplanactivitykindDevicerequest)
    "DeviceMetric" -> decode.success(CareplanactivitykindDevicemetric)
    "DeviceDefinition" -> decode.success(CareplanactivitykindDevicedefinition)
    "Device" -> decode.success(CareplanactivitykindDevice)
    "DetectedIssue" -> decode.success(CareplanactivitykindDetectedissue)
    "CoverageEligibilityResponse" ->
      decode.success(CareplanactivitykindCoverageeligibilityresponse)
    "CoverageEligibilityRequest" ->
      decode.success(CareplanactivitykindCoverageeligibilityrequest)
    "Coverage" -> decode.success(CareplanactivitykindCoverage)
    "Contract" -> decode.success(CareplanactivitykindContract)
    "Consent" -> decode.success(CareplanactivitykindConsent)
    "Condition" -> decode.success(CareplanactivitykindCondition)
    "ConceptMap" -> decode.success(CareplanactivitykindConceptmap)
    "Composition" -> decode.success(CareplanactivitykindComposition)
    "CompartmentDefinition" ->
      decode.success(CareplanactivitykindCompartmentdefinition)
    "CommunicationRequest" ->
      decode.success(CareplanactivitykindCommunicationrequest)
    "Communication" -> decode.success(CareplanactivitykindCommunication)
    "CodeSystem" -> decode.success(CareplanactivitykindCodesystem)
    "ClinicalImpression" ->
      decode.success(CareplanactivitykindClinicalimpression)
    "ClaimResponse" -> decode.success(CareplanactivitykindClaimresponse)
    "Claim" -> decode.success(CareplanactivitykindClaim)
    "ChargeItemDefinition" ->
      decode.success(CareplanactivitykindChargeitemdefinition)
    "ChargeItem" -> decode.success(CareplanactivitykindChargeitem)
    "CatalogEntry" -> decode.success(CareplanactivitykindCatalogentry)
    "CareTeam" -> decode.success(CareplanactivitykindCareteam)
    "CarePlan" -> decode.success(CareplanactivitykindCareplan)
    "CapabilityStatement" ->
      decode.success(CareplanactivitykindCapabilitystatement)
    "Bundle" -> decode.success(CareplanactivitykindBundle)
    "BodyStructure" -> decode.success(CareplanactivitykindBodystructure)
    "BiologicallyDerivedProduct" ->
      decode.success(CareplanactivitykindBiologicallyderivedproduct)
    "Binary" -> decode.success(CareplanactivitykindBinary)
    "Basic" -> decode.success(CareplanactivitykindBasic)
    "AuditEvent" -> decode.success(CareplanactivitykindAuditevent)
    "AppointmentResponse" ->
      decode.success(CareplanactivitykindAppointmentresponse)
    "Appointment" -> decode.success(CareplanactivitykindAppointment)
    "AllergyIntolerance" ->
      decode.success(CareplanactivitykindAllergyintolerance)
    "AdverseEvent" -> decode.success(CareplanactivitykindAdverseevent)
    "ActivityDefinition" ->
      decode.success(CareplanactivitykindActivitydefinition)
    "Account" -> decode.success(CareplanactivitykindAccount)
    _ ->
      decode.failure(
        CareplanactivitykindVisionprescription,
        "Careplanactivitykind",
      )
  }
}

pub type Exposurestate {
  ExposurestateExposurealternative
  ExposurestateExposure
}

pub fn exposurestate_to_json(exposurestate: Exposurestate) -> Json {
  case exposurestate {
    ExposurestateExposurealternative -> json.string("exposure-alternative")
    ExposurestateExposure -> json.string("exposure")
  }
}

pub fn exposurestate_decoder() -> Decoder(Exposurestate) {
  use variant <- decode.then(decode.string)
  case variant {
    "exposure-alternative" -> decode.success(ExposurestateExposurealternative)
    "exposure" -> decode.success(ExposurestateExposure)
    _ -> decode.failure(ExposurestateExposurealternative, "Exposurestate")
  }
}

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeOthermap
  ConceptmapunmappedmodeFixed
  ConceptmapunmappedmodeProvided
}

pub fn conceptmapunmappedmode_to_json(
  conceptmapunmappedmode: Conceptmapunmappedmode,
) -> Json {
  case conceptmapunmappedmode {
    ConceptmapunmappedmodeOthermap -> json.string("other-map")
    ConceptmapunmappedmodeFixed -> json.string("fixed")
    ConceptmapunmappedmodeProvided -> json.string("provided")
  }
}

pub fn conceptmapunmappedmode_decoder() -> Decoder(Conceptmapunmappedmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "other-map" -> decode.success(ConceptmapunmappedmodeOthermap)
    "fixed" -> decode.success(ConceptmapunmappedmodeFixed)
    "provided" -> decode.success(ConceptmapunmappedmodeProvided)
    _ ->
      decode.failure(ConceptmapunmappedmodeOthermap, "Conceptmapunmappedmode")
  }
}

pub type Verificationresultstatus {
  VerificationresultstatusRevalfail
  VerificationresultstatusValfail
  VerificationresultstatusReqrevalid
  VerificationresultstatusInprocess
  VerificationresultstatusValidated
  VerificationresultstatusAttested
}

pub fn verificationresultstatus_to_json(
  verificationresultstatus: Verificationresultstatus,
) -> Json {
  case verificationresultstatus {
    VerificationresultstatusRevalfail -> json.string("reval-fail")
    VerificationresultstatusValfail -> json.string("val-fail")
    VerificationresultstatusReqrevalid -> json.string("req-revalid")
    VerificationresultstatusInprocess -> json.string("in-process")
    VerificationresultstatusValidated -> json.string("validated")
    VerificationresultstatusAttested -> json.string("attested")
  }
}

pub fn verificationresultstatus_decoder() -> Decoder(Verificationresultstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "reval-fail" -> decode.success(VerificationresultstatusRevalfail)
    "val-fail" -> decode.success(VerificationresultstatusValfail)
    "req-revalid" -> decode.success(VerificationresultstatusReqrevalid)
    "in-process" -> decode.success(VerificationresultstatusInprocess)
    "validated" -> decode.success(VerificationresultstatusValidated)
    "attested" -> decode.success(VerificationresultstatusAttested)
    _ ->
      decode.failure(
        VerificationresultstatusRevalfail,
        "Verificationresultstatus",
      )
  }
}

pub type Accountstatus {
  AccountstatusUnknown
  AccountstatusOnhold
  AccountstatusEnteredinerror
  AccountstatusInactive
  AccountstatusActive
}

pub fn accountstatus_to_json(accountstatus: Accountstatus) -> Json {
  case accountstatus {
    AccountstatusUnknown -> json.string("unknown")
    AccountstatusOnhold -> json.string("on-hold")
    AccountstatusEnteredinerror -> json.string("entered-in-error")
    AccountstatusInactive -> json.string("inactive")
    AccountstatusActive -> json.string("active")
  }
}

pub fn accountstatus_decoder() -> Decoder(Accountstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(AccountstatusUnknown)
    "on-hold" -> decode.success(AccountstatusOnhold)
    "entered-in-error" -> decode.success(AccountstatusEnteredinerror)
    "inactive" -> decode.success(AccountstatusInactive)
    "active" -> decode.success(AccountstatusActive)
    _ -> decode.failure(AccountstatusUnknown, "Accountstatus")
  }
}

pub type Careplanintent {
  CareplanintentOption
  CareplanintentOrder
  CareplanintentDirective
  CareplanintentPlan
  CareplanintentProposal
  CareplanintentFillerorder
  CareplanintentReflexorder
  CareplanintentOriginalorder
  CareplanintentInstanceorder
}

pub fn careplanintent_to_json(careplanintent: Careplanintent) -> Json {
  case careplanintent {
    CareplanintentOption -> json.string("option")
    CareplanintentOrder -> json.string("order")
    CareplanintentDirective -> json.string("directive")
    CareplanintentPlan -> json.string("plan")
    CareplanintentProposal -> json.string("proposal")
    CareplanintentFillerorder -> json.string("filler-order")
    CareplanintentReflexorder -> json.string("reflex-order")
    CareplanintentOriginalorder -> json.string("original-order")
    CareplanintentInstanceorder -> json.string("instance-order")
  }
}

pub fn careplanintent_decoder() -> Decoder(Careplanintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "option" -> decode.success(CareplanintentOption)
    "order" -> decode.success(CareplanintentOrder)
    "directive" -> decode.success(CareplanintentDirective)
    "plan" -> decode.success(CareplanintentPlan)
    "proposal" -> decode.success(CareplanintentProposal)
    "filler-order" -> decode.success(CareplanintentFillerorder)
    "reflex-order" -> decode.success(CareplanintentReflexorder)
    "original-order" -> decode.success(CareplanintentOriginalorder)
    "instance-order" -> decode.success(CareplanintentInstanceorder)
    _ -> decode.failure(CareplanintentOption, "Careplanintent")
  }
}

pub type Taskintent {
  TaskintentOption
  TaskintentOrder
  TaskintentDirective
  TaskintentPlan
  TaskintentProposal
  TaskintentFillerorder
  TaskintentReflexorder
  TaskintentOriginalorder
  TaskintentInstanceorder
  TaskintentUnknown
}

pub fn taskintent_to_json(taskintent: Taskintent) -> Json {
  case taskintent {
    TaskintentOption -> json.string("option")
    TaskintentOrder -> json.string("order")
    TaskintentDirective -> json.string("directive")
    TaskintentPlan -> json.string("plan")
    TaskintentProposal -> json.string("proposal")
    TaskintentFillerorder -> json.string("filler-order")
    TaskintentReflexorder -> json.string("reflex-order")
    TaskintentOriginalorder -> json.string("original-order")
    TaskintentInstanceorder -> json.string("instance-order")
    TaskintentUnknown -> json.string("unknown")
  }
}

pub fn taskintent_decoder() -> Decoder(Taskintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "option" -> decode.success(TaskintentOption)
    "order" -> decode.success(TaskintentOrder)
    "directive" -> decode.success(TaskintentDirective)
    "plan" -> decode.success(TaskintentPlan)
    "proposal" -> decode.success(TaskintentProposal)
    "filler-order" -> decode.success(TaskintentFillerorder)
    "reflex-order" -> decode.success(TaskintentReflexorder)
    "original-order" -> decode.success(TaskintentOriginalorder)
    "instance-order" -> decode.success(TaskintentInstanceorder)
    "unknown" -> decode.success(TaskintentUnknown)
    _ -> decode.failure(TaskintentOption, "Taskintent")
  }
}

pub type Searchmodifiercode {
  SearchmodifiercodeOftype
  SearchmodifiercodeIdentifier
  SearchmodifiercodeType
  SearchmodifiercodeAbove
  SearchmodifiercodeBelow
  SearchmodifiercodeNotin
  SearchmodifiercodeIn
  SearchmodifiercodeText
  SearchmodifiercodeNot
  SearchmodifiercodeContains
  SearchmodifiercodeExact
  SearchmodifiercodeMissing
}

pub fn searchmodifiercode_to_json(
  searchmodifiercode: Searchmodifiercode,
) -> Json {
  case searchmodifiercode {
    SearchmodifiercodeOftype -> json.string("ofType")
    SearchmodifiercodeIdentifier -> json.string("identifier")
    SearchmodifiercodeType -> json.string("type")
    SearchmodifiercodeAbove -> json.string("above")
    SearchmodifiercodeBelow -> json.string("below")
    SearchmodifiercodeNotin -> json.string("not-in")
    SearchmodifiercodeIn -> json.string("in")
    SearchmodifiercodeText -> json.string("text")
    SearchmodifiercodeNot -> json.string("not")
    SearchmodifiercodeContains -> json.string("contains")
    SearchmodifiercodeExact -> json.string("exact")
    SearchmodifiercodeMissing -> json.string("missing")
  }
}

pub fn searchmodifiercode_decoder() -> Decoder(Searchmodifiercode) {
  use variant <- decode.then(decode.string)
  case variant {
    "ofType" -> decode.success(SearchmodifiercodeOftype)
    "identifier" -> decode.success(SearchmodifiercodeIdentifier)
    "type" -> decode.success(SearchmodifiercodeType)
    "above" -> decode.success(SearchmodifiercodeAbove)
    "below" -> decode.success(SearchmodifiercodeBelow)
    "not-in" -> decode.success(SearchmodifiercodeNotin)
    "in" -> decode.success(SearchmodifiercodeIn)
    "text" -> decode.success(SearchmodifiercodeText)
    "not" -> decode.success(SearchmodifiercodeNot)
    "contains" -> decode.success(SearchmodifiercodeContains)
    "exact" -> decode.success(SearchmodifiercodeExact)
    "missing" -> decode.success(SearchmodifiercodeMissing)
    _ -> decode.failure(SearchmodifiercodeOftype, "Searchmodifiercode")
  }
}

pub type Consentdatameaning {
  ConsentdatameaningAuthoredby
  ConsentdatameaningDependents
  ConsentdatameaningRelated
  ConsentdatameaningInstance
}

pub fn consentdatameaning_to_json(
  consentdatameaning: Consentdatameaning,
) -> Json {
  case consentdatameaning {
    ConsentdatameaningAuthoredby -> json.string("authoredby")
    ConsentdatameaningDependents -> json.string("dependents")
    ConsentdatameaningRelated -> json.string("related")
    ConsentdatameaningInstance -> json.string("instance")
  }
}

pub fn consentdatameaning_decoder() -> Decoder(Consentdatameaning) {
  use variant <- decode.then(decode.string)
  case variant {
    "authoredby" -> decode.success(ConsentdatameaningAuthoredby)
    "dependents" -> decode.success(ConsentdatameaningDependents)
    "related" -> decode.success(ConsentdatameaningRelated)
    "instance" -> decode.success(ConsentdatameaningInstance)
    _ -> decode.failure(ConsentdatameaningAuthoredby, "Consentdatameaning")
  }
}

pub type Fmstatus {
  FmstatusEnteredinerror
  FmstatusDraft
  FmstatusCancelled
  FmstatusActive
}

pub fn fmstatus_to_json(fmstatus: Fmstatus) -> Json {
  case fmstatus {
    FmstatusEnteredinerror -> json.string("entered-in-error")
    FmstatusDraft -> json.string("draft")
    FmstatusCancelled -> json.string("cancelled")
    FmstatusActive -> json.string("active")
  }
}

pub fn fmstatus_decoder() -> Decoder(Fmstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(FmstatusEnteredinerror)
    "draft" -> decode.success(FmstatusDraft)
    "cancelled" -> decode.success(FmstatusCancelled)
    "active" -> decode.success(FmstatusActive)
    _ -> decode.failure(FmstatusEnteredinerror, "Fmstatus")
  }
}

pub type Medicationstatus {
  MedicationstatusEnteredinerror
  MedicationstatusInactive
  MedicationstatusActive
}

pub fn medicationstatus_to_json(medicationstatus: Medicationstatus) -> Json {
  case medicationstatus {
    MedicationstatusEnteredinerror -> json.string("entered-in-error")
    MedicationstatusInactive -> json.string("inactive")
    MedicationstatusActive -> json.string("active")
  }
}

pub fn medicationstatus_decoder() -> Decoder(Medicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(MedicationstatusEnteredinerror)
    "inactive" -> decode.success(MedicationstatusInactive)
    "active" -> decode.success(MedicationstatusActive)
    _ -> decode.failure(MedicationstatusEnteredinerror, "Medicationstatus")
  }
}

pub type Sequencetype {
  SequencetypeRna
  SequencetypeDna
  SequencetypeAa
}

pub fn sequencetype_to_json(sequencetype: Sequencetype) -> Json {
  case sequencetype {
    SequencetypeRna -> json.string("rna")
    SequencetypeDna -> json.string("dna")
    SequencetypeAa -> json.string("aa")
  }
}

pub fn sequencetype_decoder() -> Decoder(Sequencetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "rna" -> decode.success(SequencetypeRna)
    "dna" -> decode.success(SequencetypeDna)
    "aa" -> decode.success(SequencetypeAa)
    _ -> decode.failure(SequencetypeRna, "Sequencetype")
  }
}

pub type Graphcompartmentrule {
  GraphcompartmentruleCustom
  GraphcompartmentruleDifferent
  GraphcompartmentruleMatching
  GraphcompartmentruleIdentical
}

pub fn graphcompartmentrule_to_json(
  graphcompartmentrule: Graphcompartmentrule,
) -> Json {
  case graphcompartmentrule {
    GraphcompartmentruleCustom -> json.string("custom")
    GraphcompartmentruleDifferent -> json.string("different")
    GraphcompartmentruleMatching -> json.string("matching")
    GraphcompartmentruleIdentical -> json.string("identical")
  }
}

pub fn graphcompartmentrule_decoder() -> Decoder(Graphcompartmentrule) {
  use variant <- decode.then(decode.string)
  case variant {
    "custom" -> decode.success(GraphcompartmentruleCustom)
    "different" -> decode.success(GraphcompartmentruleDifferent)
    "matching" -> decode.success(GraphcompartmentruleMatching)
    "identical" -> decode.success(GraphcompartmentruleIdentical)
    _ -> decode.failure(GraphcompartmentruleCustom, "Graphcompartmentrule")
  }
}

pub type Operationkind {
  OperationkindQuery
  OperationkindOperation
}

pub fn operationkind_to_json(operationkind: Operationkind) -> Json {
  case operationkind {
    OperationkindQuery -> json.string("query")
    OperationkindOperation -> json.string("operation")
  }
}

pub fn operationkind_decoder() -> Decoder(Operationkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "query" -> decode.success(OperationkindQuery)
    "operation" -> decode.success(OperationkindOperation)
    _ -> decode.failure(OperationkindQuery, "Operationkind")
  }
}

pub type Detectedissueseverity {
  DetectedissueseverityLow
  DetectedissueseverityModerate
  DetectedissueseverityHigh
}

pub fn detectedissueseverity_to_json(
  detectedissueseverity: Detectedissueseverity,
) -> Json {
  case detectedissueseverity {
    DetectedissueseverityLow -> json.string("low")
    DetectedissueseverityModerate -> json.string("moderate")
    DetectedissueseverityHigh -> json.string("high")
  }
}

pub fn detectedissueseverity_decoder() -> Decoder(Detectedissueseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "low" -> decode.success(DetectedissueseverityLow)
    "moderate" -> decode.success(DetectedissueseverityModerate)
    "high" -> decode.success(DetectedissueseverityHigh)
    _ -> decode.failure(DetectedissueseverityLow, "Detectedissueseverity")
  }
}

pub type Metriccalibrationstate {
  MetriccalibrationstateUnspecified
  MetriccalibrationstateCalibrated
  MetriccalibrationstateCalibrationrequired
  MetriccalibrationstateNotcalibrated
}

pub fn metriccalibrationstate_to_json(
  metriccalibrationstate: Metriccalibrationstate,
) -> Json {
  case metriccalibrationstate {
    MetriccalibrationstateUnspecified -> json.string("unspecified")
    MetriccalibrationstateCalibrated -> json.string("calibrated")
    MetriccalibrationstateCalibrationrequired ->
      json.string("calibration-required")
    MetriccalibrationstateNotcalibrated -> json.string("not-calibrated")
  }
}

pub fn metriccalibrationstate_decoder() -> Decoder(Metriccalibrationstate) {
  use variant <- decode.then(decode.string)
  case variant {
    "unspecified" -> decode.success(MetriccalibrationstateUnspecified)
    "calibrated" -> decode.success(MetriccalibrationstateCalibrated)
    "calibration-required" ->
      decode.success(MetriccalibrationstateCalibrationrequired)
    "not-calibrated" -> decode.success(MetriccalibrationstateNotcalibrated)
    _ ->
      decode.failure(
        MetriccalibrationstateUnspecified,
        "Metriccalibrationstate",
      )
  }
}

pub type Searchparamtype {
  SearchparamtypeSpecial
  SearchparamtypeUri
  SearchparamtypeQuantity
  SearchparamtypeComposite
  SearchparamtypeReference
  SearchparamtypeToken
  SearchparamtypeString
  SearchparamtypeDate
  SearchparamtypeNumber
}

pub fn searchparamtype_to_json(searchparamtype: Searchparamtype) -> Json {
  case searchparamtype {
    SearchparamtypeSpecial -> json.string("special")
    SearchparamtypeUri -> json.string("uri")
    SearchparamtypeQuantity -> json.string("quantity")
    SearchparamtypeComposite -> json.string("composite")
    SearchparamtypeReference -> json.string("reference")
    SearchparamtypeToken -> json.string("token")
    SearchparamtypeString -> json.string("string")
    SearchparamtypeDate -> json.string("date")
    SearchparamtypeNumber -> json.string("number")
  }
}

pub fn searchparamtype_decoder() -> Decoder(Searchparamtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "special" -> decode.success(SearchparamtypeSpecial)
    "uri" -> decode.success(SearchparamtypeUri)
    "quantity" -> decode.success(SearchparamtypeQuantity)
    "composite" -> decode.success(SearchparamtypeComposite)
    "reference" -> decode.success(SearchparamtypeReference)
    "token" -> decode.success(SearchparamtypeToken)
    "string" -> decode.success(SearchparamtypeString)
    "date" -> decode.success(SearchparamtypeDate)
    "number" -> decode.success(SearchparamtypeNumber)
    _ -> decode.failure(SearchparamtypeSpecial, "Searchparamtype")
  }
}

pub type Linkagetype {
  LinkagetypeHistorical
  LinkagetypeAlternate
  LinkagetypeSource
}

pub fn linkagetype_to_json(linkagetype: Linkagetype) -> Json {
  case linkagetype {
    LinkagetypeHistorical -> json.string("historical")
    LinkagetypeAlternate -> json.string("alternate")
    LinkagetypeSource -> json.string("source")
  }
}

pub fn linkagetype_decoder() -> Decoder(Linkagetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "historical" -> decode.success(LinkagetypeHistorical)
    "alternate" -> decode.success(LinkagetypeAlternate)
    "source" -> decode.success(LinkagetypeSource)
    _ -> decode.failure(LinkagetypeHistorical, "Linkagetype")
  }
}

pub type Immunizationevaluationstatus {
  ImmunizationevaluationstatusUnknown
  ImmunizationevaluationstatusStopped
  ImmunizationevaluationstatusEnteredinerror
  ImmunizationevaluationstatusCompleted
  ImmunizationevaluationstatusOnhold
  ImmunizationevaluationstatusNotdone
  ImmunizationevaluationstatusInprogress
}

pub fn immunizationevaluationstatus_to_json(
  immunizationevaluationstatus: Immunizationevaluationstatus,
) -> Json {
  case immunizationevaluationstatus {
    ImmunizationevaluationstatusUnknown -> json.string("unknown")
    ImmunizationevaluationstatusStopped -> json.string("stopped")
    ImmunizationevaluationstatusEnteredinerror ->
      json.string("entered-in-error")
    ImmunizationevaluationstatusCompleted -> json.string("completed")
    ImmunizationevaluationstatusOnhold -> json.string("on-hold")
    ImmunizationevaluationstatusNotdone -> json.string("not-done")
    ImmunizationevaluationstatusInprogress -> json.string("in-progress")
  }
}

pub fn immunizationevaluationstatus_decoder() -> Decoder(
  Immunizationevaluationstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ImmunizationevaluationstatusUnknown)
    "stopped" -> decode.success(ImmunizationevaluationstatusStopped)
    "entered-in-error" ->
      decode.success(ImmunizationevaluationstatusEnteredinerror)
    "completed" -> decode.success(ImmunizationevaluationstatusCompleted)
    "on-hold" -> decode.success(ImmunizationevaluationstatusOnhold)
    "not-done" -> decode.success(ImmunizationevaluationstatusNotdone)
    "in-progress" -> decode.success(ImmunizationevaluationstatusInprogress)
    _ ->
      decode.failure(
        ImmunizationevaluationstatusUnknown,
        "Immunizationevaluationstatus",
      )
  }
}

pub type Imagingstudystatus {
  ImagingstudystatusUnknown
  ImagingstudystatusEnteredinerror
  ImagingstudystatusCancelled
  ImagingstudystatusAvailable
  ImagingstudystatusRegistered
}

pub fn imagingstudystatus_to_json(
  imagingstudystatus: Imagingstudystatus,
) -> Json {
  case imagingstudystatus {
    ImagingstudystatusUnknown -> json.string("unknown")
    ImagingstudystatusEnteredinerror -> json.string("entered-in-error")
    ImagingstudystatusCancelled -> json.string("cancelled")
    ImagingstudystatusAvailable -> json.string("available")
    ImagingstudystatusRegistered -> json.string("registered")
  }
}

pub fn imagingstudystatus_decoder() -> Decoder(Imagingstudystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ImagingstudystatusUnknown)
    "entered-in-error" -> decode.success(ImagingstudystatusEnteredinerror)
    "cancelled" -> decode.success(ImagingstudystatusCancelled)
    "available" -> decode.success(ImagingstudystatusAvailable)
    "registered" -> decode.success(ImagingstudystatusRegistered)
    _ -> decode.failure(ImagingstudystatusUnknown, "Imagingstudystatus")
  }
}

pub type Repositorytype {
  RepositorytypeOther
  RepositorytypeOauth
  RepositorytypeLogin
  RepositorytypeOpenapi
  RepositorytypeDirectlink
}

pub fn repositorytype_to_json(repositorytype: Repositorytype) -> Json {
  case repositorytype {
    RepositorytypeOther -> json.string("other")
    RepositorytypeOauth -> json.string("oauth")
    RepositorytypeLogin -> json.string("login")
    RepositorytypeOpenapi -> json.string("openapi")
    RepositorytypeDirectlink -> json.string("directlink")
  }
}

pub fn repositorytype_decoder() -> Decoder(Repositorytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "other" -> decode.success(RepositorytypeOther)
    "oauth" -> decode.success(RepositorytypeOauth)
    "login" -> decode.success(RepositorytypeLogin)
    "openapi" -> decode.success(RepositorytypeOpenapi)
    "directlink" -> decode.success(RepositorytypeDirectlink)
    _ -> decode.failure(RepositorytypeOther, "Repositorytype")
  }
}

pub type Subscriptionstatus {
  SubscriptionstatusOff
  SubscriptionstatusError
  SubscriptionstatusActive
  SubscriptionstatusRequested
}

pub fn subscriptionstatus_to_json(
  subscriptionstatus: Subscriptionstatus,
) -> Json {
  case subscriptionstatus {
    SubscriptionstatusOff -> json.string("off")
    SubscriptionstatusError -> json.string("error")
    SubscriptionstatusActive -> json.string("active")
    SubscriptionstatusRequested -> json.string("requested")
  }
}

pub fn subscriptionstatus_decoder() -> Decoder(Subscriptionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "off" -> decode.success(SubscriptionstatusOff)
    "error" -> decode.success(SubscriptionstatusError)
    "active" -> decode.success(SubscriptionstatusActive)
    "requested" -> decode.success(SubscriptionstatusRequested)
    _ -> decode.failure(SubscriptionstatusOff, "Subscriptionstatus")
  }
}

pub type Auditeventaction {
  AuditeventactionE
  AuditeventactionD
  AuditeventactionU
  AuditeventactionR
  AuditeventactionC
}

pub fn auditeventaction_to_json(auditeventaction: Auditeventaction) -> Json {
  case auditeventaction {
    AuditeventactionE -> json.string("E")
    AuditeventactionD -> json.string("D")
    AuditeventactionU -> json.string("U")
    AuditeventactionR -> json.string("R")
    AuditeventactionC -> json.string("C")
  }
}

pub fn auditeventaction_decoder() -> Decoder(Auditeventaction) {
  use variant <- decode.then(decode.string)
  case variant {
    "E" -> decode.success(AuditeventactionE)
    "D" -> decode.success(AuditeventactionD)
    "U" -> decode.success(AuditeventactionU)
    "R" -> decode.success(AuditeventactionR)
    "C" -> decode.success(AuditeventactionC)
    _ -> decode.failure(AuditeventactionE, "Auditeventaction")
  }
}

pub type Careplanactivitystatus {
  CareplanactivitystatusEnteredinerror
  CareplanactivitystatusUnknown
  CareplanactivitystatusCancelled
  CareplanactivitystatusCompleted
  CareplanactivitystatusOnhold
  CareplanactivitystatusInprogress
  CareplanactivitystatusScheduled
  CareplanactivitystatusNotstarted
  CareplanactivitystatusStopped
}

pub fn careplanactivitystatus_to_json(
  careplanactivitystatus: Careplanactivitystatus,
) -> Json {
  case careplanactivitystatus {
    CareplanactivitystatusEnteredinerror -> json.string("entered-in-error")
    CareplanactivitystatusUnknown -> json.string("unknown")
    CareplanactivitystatusCancelled -> json.string("cancelled")
    CareplanactivitystatusCompleted -> json.string("completed")
    CareplanactivitystatusOnhold -> json.string("on-hold")
    CareplanactivitystatusInprogress -> json.string("in-progress")
    CareplanactivitystatusScheduled -> json.string("scheduled")
    CareplanactivitystatusNotstarted -> json.string("not-started")
    CareplanactivitystatusStopped -> json.string("stopped")
  }
}

pub fn careplanactivitystatus_decoder() -> Decoder(Careplanactivitystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(CareplanactivitystatusEnteredinerror)
    "unknown" -> decode.success(CareplanactivitystatusUnknown)
    "cancelled" -> decode.success(CareplanactivitystatusCancelled)
    "completed" -> decode.success(CareplanactivitystatusCompleted)
    "on-hold" -> decode.success(CareplanactivitystatusOnhold)
    "in-progress" -> decode.success(CareplanactivitystatusInprogress)
    "scheduled" -> decode.success(CareplanactivitystatusScheduled)
    "not-started" -> decode.success(CareplanactivitystatusNotstarted)
    "stopped" -> decode.success(CareplanactivitystatusStopped)
    _ ->
      decode.failure(
        CareplanactivitystatusEnteredinerror,
        "Careplanactivitystatus",
      )
  }
}

pub type Reportparticipanttype {
  ReportparticipanttypeServer
  ReportparticipanttypeClient
  ReportparticipanttypeTestengine
}

pub fn reportparticipanttype_to_json(
  reportparticipanttype: Reportparticipanttype,
) -> Json {
  case reportparticipanttype {
    ReportparticipanttypeServer -> json.string("server")
    ReportparticipanttypeClient -> json.string("client")
    ReportparticipanttypeTestengine -> json.string("test-engine")
  }
}

pub fn reportparticipanttype_decoder() -> Decoder(Reportparticipanttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "server" -> decode.success(ReportparticipanttypeServer)
    "client" -> decode.success(ReportparticipanttypeClient)
    "test-engine" -> decode.success(ReportparticipanttypeTestengine)
    _ -> decode.failure(ReportparticipanttypeServer, "Reportparticipanttype")
  }
}

pub type Specimencontainedpreference {
  SpecimencontainedpreferenceAlternate
  SpecimencontainedpreferencePreferred
}

pub fn specimencontainedpreference_to_json(
  specimencontainedpreference: Specimencontainedpreference,
) -> Json {
  case specimencontainedpreference {
    SpecimencontainedpreferenceAlternate -> json.string("alternate")
    SpecimencontainedpreferencePreferred -> json.string("preferred")
  }
}

pub fn specimencontainedpreference_decoder() -> Decoder(
  Specimencontainedpreference,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "alternate" -> decode.success(SpecimencontainedpreferenceAlternate)
    "preferred" -> decode.success(SpecimencontainedpreferencePreferred)
    _ ->
      decode.failure(
        SpecimencontainedpreferenceAlternate,
        "Specimencontainedpreference",
      )
  }
}

pub type Devicenametype {
  DevicenametypeOther
  DevicenametypeModelname
  DevicenametypeManufacturername
  DevicenametypePatientreportedname
  DevicenametypeUserfriendlyname
  DevicenametypeUdilabelname
}

pub fn devicenametype_to_json(devicenametype: Devicenametype) -> Json {
  case devicenametype {
    DevicenametypeOther -> json.string("other")
    DevicenametypeModelname -> json.string("model-name")
    DevicenametypeManufacturername -> json.string("manufacturer-name")
    DevicenametypePatientreportedname -> json.string("patient-reported-name")
    DevicenametypeUserfriendlyname -> json.string("user-friendly-name")
    DevicenametypeUdilabelname -> json.string("udi-label-name")
  }
}

pub fn devicenametype_decoder() -> Decoder(Devicenametype) {
  use variant <- decode.then(decode.string)
  case variant {
    "other" -> decode.success(DevicenametypeOther)
    "model-name" -> decode.success(DevicenametypeModelname)
    "manufacturer-name" -> decode.success(DevicenametypeManufacturername)
    "patient-reported-name" -> decode.success(DevicenametypePatientreportedname)
    "user-friendly-name" -> decode.success(DevicenametypeUserfriendlyname)
    "udi-label-name" -> decode.success(DevicenametypeUdilabelname)
    _ -> decode.failure(DevicenametypeOther, "Devicenametype")
  }
}

pub type Mapsourcelistmode {
  MapsourcelistmodeOnlyone
  MapsourcelistmodeNotlast
  MapsourcelistmodeLast
  MapsourcelistmodeNotfirst
  MapsourcelistmodeFirst
}

pub fn mapsourcelistmode_to_json(mapsourcelistmode: Mapsourcelistmode) -> Json {
  case mapsourcelistmode {
    MapsourcelistmodeOnlyone -> json.string("only_one")
    MapsourcelistmodeNotlast -> json.string("not_last")
    MapsourcelistmodeLast -> json.string("last")
    MapsourcelistmodeNotfirst -> json.string("not_first")
    MapsourcelistmodeFirst -> json.string("first")
  }
}

pub fn mapsourcelistmode_decoder() -> Decoder(Mapsourcelistmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "only_one" -> decode.success(MapsourcelistmodeOnlyone)
    "not_last" -> decode.success(MapsourcelistmodeNotlast)
    "last" -> decode.success(MapsourcelistmodeLast)
    "not_first" -> decode.success(MapsourcelistmodeNotfirst)
    "first" -> decode.success(MapsourcelistmodeFirst)
    _ -> decode.failure(MapsourcelistmodeOnlyone, "Mapsourcelistmode")
  }
}

pub type Guideparametercode {
  GuideparametercodeHtmltemplate
  GuideparametercodeGenerateturtle
  GuideparametercodeGeneratejson
  GuideparametercodeGeneratexml
  GuideparametercodeRulebrokenlinks
  GuideparametercodeExpansionparameter
  GuideparametercodePathtxcache
  GuideparametercodePathpages
  GuideparametercodePathresource
  GuideparametercodeApply
}

pub fn guideparametercode_to_json(
  guideparametercode: Guideparametercode,
) -> Json {
  case guideparametercode {
    GuideparametercodeHtmltemplate -> json.string("html-template")
    GuideparametercodeGenerateturtle -> json.string("generate-turtle")
    GuideparametercodeGeneratejson -> json.string("generate-json")
    GuideparametercodeGeneratexml -> json.string("generate-xml")
    GuideparametercodeRulebrokenlinks -> json.string("rule-broken-links")
    GuideparametercodeExpansionparameter -> json.string("expansion-parameter")
    GuideparametercodePathtxcache -> json.string("path-tx-cache")
    GuideparametercodePathpages -> json.string("path-pages")
    GuideparametercodePathresource -> json.string("path-resource")
    GuideparametercodeApply -> json.string("apply")
  }
}

pub fn guideparametercode_decoder() -> Decoder(Guideparametercode) {
  use variant <- decode.then(decode.string)
  case variant {
    "html-template" -> decode.success(GuideparametercodeHtmltemplate)
    "generate-turtle" -> decode.success(GuideparametercodeGenerateturtle)
    "generate-json" -> decode.success(GuideparametercodeGeneratejson)
    "generate-xml" -> decode.success(GuideparametercodeGeneratexml)
    "rule-broken-links" -> decode.success(GuideparametercodeRulebrokenlinks)
    "expansion-parameter" ->
      decode.success(GuideparametercodeExpansionparameter)
    "path-tx-cache" -> decode.success(GuideparametercodePathtxcache)
    "path-pages" -> decode.success(GuideparametercodePathpages)
    "path-resource" -> decode.success(GuideparametercodePathresource)
    "apply" -> decode.success(GuideparametercodeApply)
    _ -> decode.failure(GuideparametercodeHtmltemplate, "Guideparametercode")
  }
}

pub type Questionnaireanswersstatus {
  QuestionnaireanswersstatusStopped
  QuestionnaireanswersstatusEnteredinerror
  QuestionnaireanswersstatusAmended
  QuestionnaireanswersstatusCompleted
  QuestionnaireanswersstatusInprogress
}

pub fn questionnaireanswersstatus_to_json(
  questionnaireanswersstatus: Questionnaireanswersstatus,
) -> Json {
  case questionnaireanswersstatus {
    QuestionnaireanswersstatusStopped -> json.string("stopped")
    QuestionnaireanswersstatusEnteredinerror -> json.string("entered-in-error")
    QuestionnaireanswersstatusAmended -> json.string("amended")
    QuestionnaireanswersstatusCompleted -> json.string("completed")
    QuestionnaireanswersstatusInprogress -> json.string("in-progress")
  }
}

pub fn questionnaireanswersstatus_decoder() -> Decoder(
  Questionnaireanswersstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "stopped" -> decode.success(QuestionnaireanswersstatusStopped)
    "entered-in-error" ->
      decode.success(QuestionnaireanswersstatusEnteredinerror)
    "amended" -> decode.success(QuestionnaireanswersstatusAmended)
    "completed" -> decode.success(QuestionnaireanswersstatusCompleted)
    "in-progress" -> decode.success(QuestionnaireanswersstatusInprogress)
    _ ->
      decode.failure(
        QuestionnaireanswersstatusStopped,
        "Questionnaireanswersstatus",
      )
  }
}

pub type Subscriptionchanneltype {
  SubscriptionchanneltypeMessage
  SubscriptionchanneltypeSms
  SubscriptionchanneltypeEmail
  SubscriptionchanneltypeWebsocket
  SubscriptionchanneltypeResthook
}

pub fn subscriptionchanneltype_to_json(
  subscriptionchanneltype: Subscriptionchanneltype,
) -> Json {
  case subscriptionchanneltype {
    SubscriptionchanneltypeMessage -> json.string("message")
    SubscriptionchanneltypeSms -> json.string("sms")
    SubscriptionchanneltypeEmail -> json.string("email")
    SubscriptionchanneltypeWebsocket -> json.string("websocket")
    SubscriptionchanneltypeResthook -> json.string("rest-hook")
  }
}

pub fn subscriptionchanneltype_decoder() -> Decoder(Subscriptionchanneltype) {
  use variant <- decode.then(decode.string)
  case variant {
    "message" -> decode.success(SubscriptionchanneltypeMessage)
    "sms" -> decode.success(SubscriptionchanneltypeSms)
    "email" -> decode.success(SubscriptionchanneltypeEmail)
    "websocket" -> decode.success(SubscriptionchanneltypeWebsocket)
    "rest-hook" -> decode.success(SubscriptionchanneltypeResthook)
    _ ->
      decode.failure(SubscriptionchanneltypeMessage, "Subscriptionchanneltype")
  }
}

pub type Flagstatus {
  FlagstatusEnteredinerror
  FlagstatusInactive
  FlagstatusActive
}

pub fn flagstatus_to_json(flagstatus: Flagstatus) -> Json {
  case flagstatus {
    FlagstatusEnteredinerror -> json.string("entered-in-error")
    FlagstatusInactive -> json.string("inactive")
    FlagstatusActive -> json.string("active")
  }
}

pub fn flagstatus_decoder() -> Decoder(Flagstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(FlagstatusEnteredinerror)
    "inactive" -> decode.success(FlagstatusInactive)
    "active" -> decode.success(FlagstatusActive)
    _ -> decode.failure(FlagstatusEnteredinerror, "Flagstatus")
  }
}

pub type Requestresourcetypes {
  RequestresourcetypesVisionprescription
  RequestresourcetypesTask
  RequestresourcetypesSupplyrequest
  RequestresourcetypesServicerequest
  RequestresourcetypesNutritionorder
  RequestresourcetypesMedicationrequest
  RequestresourcetypesImmunizationrecommendation
  RequestresourcetypesEnrollmentrequest
  RequestresourcetypesDevicerequest
  RequestresourcetypesContract
  RequestresourcetypesCommunicationrequest
  RequestresourcetypesClaim
  RequestresourcetypesCareplan
  RequestresourcetypesAppointmentresponse
  RequestresourcetypesAppointment
}

pub fn requestresourcetypes_to_json(
  requestresourcetypes: Requestresourcetypes,
) -> Json {
  case requestresourcetypes {
    RequestresourcetypesVisionprescription -> json.string("VisionPrescription")
    RequestresourcetypesTask -> json.string("Task")
    RequestresourcetypesSupplyrequest -> json.string("SupplyRequest")
    RequestresourcetypesServicerequest -> json.string("ServiceRequest")
    RequestresourcetypesNutritionorder -> json.string("NutritionOrder")
    RequestresourcetypesMedicationrequest -> json.string("MedicationRequest")
    RequestresourcetypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    RequestresourcetypesEnrollmentrequest -> json.string("EnrollmentRequest")
    RequestresourcetypesDevicerequest -> json.string("DeviceRequest")
    RequestresourcetypesContract -> json.string("Contract")
    RequestresourcetypesCommunicationrequest ->
      json.string("CommunicationRequest")
    RequestresourcetypesClaim -> json.string("Claim")
    RequestresourcetypesCareplan -> json.string("CarePlan")
    RequestresourcetypesAppointmentresponse ->
      json.string("AppointmentResponse")
    RequestresourcetypesAppointment -> json.string("Appointment")
  }
}

pub fn requestresourcetypes_decoder() -> Decoder(Requestresourcetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "VisionPrescription" ->
      decode.success(RequestresourcetypesVisionprescription)
    "Task" -> decode.success(RequestresourcetypesTask)
    "SupplyRequest" -> decode.success(RequestresourcetypesSupplyrequest)
    "ServiceRequest" -> decode.success(RequestresourcetypesServicerequest)
    "NutritionOrder" -> decode.success(RequestresourcetypesNutritionorder)
    "MedicationRequest" -> decode.success(RequestresourcetypesMedicationrequest)
    "ImmunizationRecommendation" ->
      decode.success(RequestresourcetypesImmunizationrecommendation)
    "EnrollmentRequest" -> decode.success(RequestresourcetypesEnrollmentrequest)
    "DeviceRequest" -> decode.success(RequestresourcetypesDevicerequest)
    "Contract" -> decode.success(RequestresourcetypesContract)
    "CommunicationRequest" ->
      decode.success(RequestresourcetypesCommunicationrequest)
    "Claim" -> decode.success(RequestresourcetypesClaim)
    "CarePlan" -> decode.success(RequestresourcetypesCareplan)
    "AppointmentResponse" ->
      decode.success(RequestresourcetypesAppointmentresponse)
    "Appointment" -> decode.success(RequestresourcetypesAppointment)
    _ ->
      decode.failure(
        RequestresourcetypesVisionprescription,
        "Requestresourcetypes",
      )
  }
}

pub type Documentrelationshiptype {
  DocumentrelationshiptypeAppends
  DocumentrelationshiptypeSigns
  DocumentrelationshiptypeTransforms
  DocumentrelationshiptypeReplaces
}

pub fn documentrelationshiptype_to_json(
  documentrelationshiptype: Documentrelationshiptype,
) -> Json {
  case documentrelationshiptype {
    DocumentrelationshiptypeAppends -> json.string("appends")
    DocumentrelationshiptypeSigns -> json.string("signs")
    DocumentrelationshiptypeTransforms -> json.string("transforms")
    DocumentrelationshiptypeReplaces -> json.string("replaces")
  }
}

pub fn documentrelationshiptype_decoder() -> Decoder(Documentrelationshiptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "appends" -> decode.success(DocumentrelationshiptypeAppends)
    "signs" -> decode.success(DocumentrelationshiptypeSigns)
    "transforms" -> decode.success(DocumentrelationshiptypeTransforms)
    "replaces" -> decode.success(DocumentrelationshiptypeReplaces)
    _ ->
      decode.failure(
        DocumentrelationshiptypeAppends,
        "Documentrelationshiptype",
      )
  }
}

pub type Metricoperationalstatus {
  MetricoperationalstatusEnteredinerror
  MetricoperationalstatusStandby
  MetricoperationalstatusOff
  MetricoperationalstatusOn
}

pub fn metricoperationalstatus_to_json(
  metricoperationalstatus: Metricoperationalstatus,
) -> Json {
  case metricoperationalstatus {
    MetricoperationalstatusEnteredinerror -> json.string("entered-in-error")
    MetricoperationalstatusStandby -> json.string("standby")
    MetricoperationalstatusOff -> json.string("off")
    MetricoperationalstatusOn -> json.string("on")
  }
}

pub fn metricoperationalstatus_decoder() -> Decoder(Metricoperationalstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(MetricoperationalstatusEnteredinerror)
    "standby" -> decode.success(MetricoperationalstatusStandby)
    "off" -> decode.success(MetricoperationalstatusOff)
    "on" -> decode.success(MetricoperationalstatusOn)
    _ ->
      decode.failure(
        MetricoperationalstatusEnteredinerror,
        "Metricoperationalstatus",
      )
  }
}

pub type Requestintent {
  RequestintentOption
  RequestintentOrder
  RequestintentDirective
  RequestintentPlan
  RequestintentProposal
  RequestintentFillerorder
  RequestintentReflexorder
  RequestintentOriginalorder
  RequestintentInstanceorder
}

pub fn requestintent_to_json(requestintent: Requestintent) -> Json {
  case requestintent {
    RequestintentOption -> json.string("option")
    RequestintentOrder -> json.string("order")
    RequestintentDirective -> json.string("directive")
    RequestintentPlan -> json.string("plan")
    RequestintentProposal -> json.string("proposal")
    RequestintentFillerorder -> json.string("filler-order")
    RequestintentReflexorder -> json.string("reflex-order")
    RequestintentOriginalorder -> json.string("original-order")
    RequestintentInstanceorder -> json.string("instance-order")
  }
}

pub fn requestintent_decoder() -> Decoder(Requestintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "option" -> decode.success(RequestintentOption)
    "order" -> decode.success(RequestintentOrder)
    "directive" -> decode.success(RequestintentDirective)
    "plan" -> decode.success(RequestintentPlan)
    "proposal" -> decode.success(RequestintentProposal)
    "filler-order" -> decode.success(RequestintentFillerorder)
    "reflex-order" -> decode.success(RequestintentReflexorder)
    "original-order" -> decode.success(RequestintentOriginalorder)
    "instance-order" -> decode.success(RequestintentInstanceorder)
    _ -> decode.failure(RequestintentOption, "Requestintent")
  }
}

pub type Assertdirectioncodes {
  AssertdirectioncodesRequest
  AssertdirectioncodesResponse
}

pub fn assertdirectioncodes_to_json(
  assertdirectioncodes: Assertdirectioncodes,
) -> Json {
  case assertdirectioncodes {
    AssertdirectioncodesRequest -> json.string("request")
    AssertdirectioncodesResponse -> json.string("response")
  }
}

pub fn assertdirectioncodes_decoder() -> Decoder(Assertdirectioncodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "request" -> decode.success(AssertdirectioncodesRequest)
    "response" -> decode.success(AssertdirectioncodesResponse)
    _ -> decode.failure(AssertdirectioncodesRequest, "Assertdirectioncodes")
  }
}

pub type Actionrequiredbehavior {
  ActionrequiredbehaviorMustunlessdocumented
  ActionrequiredbehaviorCould
  ActionrequiredbehaviorMust
}

pub fn actionrequiredbehavior_to_json(
  actionrequiredbehavior: Actionrequiredbehavior,
) -> Json {
  case actionrequiredbehavior {
    ActionrequiredbehaviorMustunlessdocumented ->
      json.string("must-unless-documented")
    ActionrequiredbehaviorCould -> json.string("could")
    ActionrequiredbehaviorMust -> json.string("must")
  }
}

pub fn actionrequiredbehavior_decoder() -> Decoder(Actionrequiredbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "must-unless-documented" ->
      decode.success(ActionrequiredbehaviorMustunlessdocumented)
    "could" -> decode.success(ActionrequiredbehaviorCould)
    "must" -> decode.success(ActionrequiredbehaviorMust)
    _ ->
      decode.failure(
        ActionrequiredbehaviorMustunlessdocumented,
        "Actionrequiredbehavior",
      )
  }
}

pub type Identifieruse {
  IdentifieruseOld
  IdentifieruseSecondary
  IdentifieruseTemp
  IdentifieruseOfficial
  IdentifieruseUsual
}

pub fn identifieruse_to_json(identifieruse: Identifieruse) -> Json {
  case identifieruse {
    IdentifieruseOld -> json.string("old")
    IdentifieruseSecondary -> json.string("secondary")
    IdentifieruseTemp -> json.string("temp")
    IdentifieruseOfficial -> json.string("official")
    IdentifieruseUsual -> json.string("usual")
  }
}

pub fn identifieruse_decoder() -> Decoder(Identifieruse) {
  use variant <- decode.then(decode.string)
  case variant {
    "old" -> decode.success(IdentifieruseOld)
    "secondary" -> decode.success(IdentifieruseSecondary)
    "temp" -> decode.success(IdentifieruseTemp)
    "official" -> decode.success(IdentifieruseOfficial)
    "usual" -> decode.success(IdentifieruseUsual)
    _ -> decode.failure(IdentifieruseOld, "Identifieruse")
  }
}

pub type Strandtype {
  StrandtypeCrick
  StrandtypeWatson
}

pub fn strandtype_to_json(strandtype: Strandtype) -> Json {
  case strandtype {
    StrandtypeCrick -> json.string("crick")
    StrandtypeWatson -> json.string("watson")
  }
}

pub fn strandtype_decoder() -> Decoder(Strandtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "crick" -> decode.success(StrandtypeCrick)
    "watson" -> decode.success(StrandtypeWatson)
    _ -> decode.failure(StrandtypeCrick, "Strandtype")
  }
}

pub type Measurereportstatus {
  MeasurereportstatusError
  MeasurereportstatusPending
  MeasurereportstatusComplete
}

pub fn measurereportstatus_to_json(
  measurereportstatus: Measurereportstatus,
) -> Json {
  case measurereportstatus {
    MeasurereportstatusError -> json.string("error")
    MeasurereportstatusPending -> json.string("pending")
    MeasurereportstatusComplete -> json.string("complete")
  }
}

pub fn measurereportstatus_decoder() -> Decoder(Measurereportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "error" -> decode.success(MeasurereportstatusError)
    "pending" -> decode.success(MeasurereportstatusPending)
    "complete" -> decode.success(MeasurereportstatusComplete)
    _ -> decode.failure(MeasurereportstatusError, "Measurereportstatus")
  }
}

pub type Productstatus {
  ProductstatusUnavailable
  ProductstatusAvailable
}

pub fn productstatus_to_json(productstatus: Productstatus) -> Json {
  case productstatus {
    ProductstatusUnavailable -> json.string("unavailable")
    ProductstatusAvailable -> json.string("available")
  }
}

pub fn productstatus_decoder() -> Decoder(Productstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unavailable" -> decode.success(ProductstatusUnavailable)
    "available" -> decode.success(ProductstatusAvailable)
    _ -> decode.failure(ProductstatusUnavailable, "Productstatus")
  }
}

pub type Extensioncontexttype {
  ExtensioncontexttypeExtension
  ExtensioncontexttypeElement
  ExtensioncontexttypeFhirpath
}

pub fn extensioncontexttype_to_json(
  extensioncontexttype: Extensioncontexttype,
) -> Json {
  case extensioncontexttype {
    ExtensioncontexttypeExtension -> json.string("extension")
    ExtensioncontexttypeElement -> json.string("element")
    ExtensioncontexttypeFhirpath -> json.string("fhirpath")
  }
}

pub fn extensioncontexttype_decoder() -> Decoder(Extensioncontexttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "extension" -> decode.success(ExtensioncontexttypeExtension)
    "element" -> decode.success(ExtensioncontexttypeElement)
    "fhirpath" -> decode.success(ExtensioncontexttypeFhirpath)
    _ -> decode.failure(ExtensioncontexttypeExtension, "Extensioncontexttype")
  }
}

pub type Provenanceentityrole {
  ProvenanceentityroleDerivation
  ProvenanceentityroleRemoval
  ProvenanceentityroleSource
  ProvenanceentityroleQuotation
  ProvenanceentityroleRevision
}

pub fn provenanceentityrole_to_json(
  provenanceentityrole: Provenanceentityrole,
) -> Json {
  case provenanceentityrole {
    ProvenanceentityroleDerivation -> json.string("derivation")
    ProvenanceentityroleRemoval -> json.string("removal")
    ProvenanceentityroleSource -> json.string("source")
    ProvenanceentityroleQuotation -> json.string("quotation")
    ProvenanceentityroleRevision -> json.string("revision")
  }
}

pub fn provenanceentityrole_decoder() -> Decoder(Provenanceentityrole) {
  use variant <- decode.then(decode.string)
  case variant {
    "derivation" -> decode.success(ProvenanceentityroleDerivation)
    "removal" -> decode.success(ProvenanceentityroleRemoval)
    "source" -> decode.success(ProvenanceentityroleSource)
    "quotation" -> decode.success(ProvenanceentityroleQuotation)
    "revision" -> decode.success(ProvenanceentityroleRevision)
    _ -> decode.failure(ProvenanceentityroleDerivation, "Provenanceentityrole")
  }
}

pub type Questionnaireenablebehavior {
  QuestionnaireenablebehaviorAny
  QuestionnaireenablebehaviorAll
}

pub fn questionnaireenablebehavior_to_json(
  questionnaireenablebehavior: Questionnaireenablebehavior,
) -> Json {
  case questionnaireenablebehavior {
    QuestionnaireenablebehaviorAny -> json.string("any")
    QuestionnaireenablebehaviorAll -> json.string("all")
  }
}

pub fn questionnaireenablebehavior_decoder() -> Decoder(
  Questionnaireenablebehavior,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "any" -> decode.success(QuestionnaireenablebehaviorAny)
    "all" -> decode.success(QuestionnaireenablebehaviorAll)
    _ ->
      decode.failure(
        QuestionnaireenablebehaviorAny,
        "Questionnaireenablebehavior",
      )
  }
}

pub type Questionnaireenableoperator {
  QuestionnaireenableoperatorLessthanequal
  QuestionnaireenableoperatorGreaterthanequal
  QuestionnaireenableoperatorLessthan
  QuestionnaireenableoperatorGreaterthan
  QuestionnaireenableoperatorNotequal
  QuestionnaireenableoperatorEqual
  QuestionnaireenableoperatorExists
}

pub fn questionnaireenableoperator_to_json(
  questionnaireenableoperator: Questionnaireenableoperator,
) -> Json {
  case questionnaireenableoperator {
    QuestionnaireenableoperatorLessthanequal -> json.string("<=")
    QuestionnaireenableoperatorGreaterthanequal -> json.string(">=")
    QuestionnaireenableoperatorLessthan -> json.string("<")
    QuestionnaireenableoperatorGreaterthan -> json.string(">")
    QuestionnaireenableoperatorNotequal -> json.string("!=")
    QuestionnaireenableoperatorEqual -> json.string("=")
    QuestionnaireenableoperatorExists -> json.string("exists")
  }
}

pub fn questionnaireenableoperator_decoder() -> Decoder(
  Questionnaireenableoperator,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "<=" -> decode.success(QuestionnaireenableoperatorLessthanequal)
    ">=" -> decode.success(QuestionnaireenableoperatorGreaterthanequal)
    "<" -> decode.success(QuestionnaireenableoperatorLessthan)
    ">" -> decode.success(QuestionnaireenableoperatorGreaterthan)
    "!=" -> decode.success(QuestionnaireenableoperatorNotequal)
    "=" -> decode.success(QuestionnaireenableoperatorEqual)
    "exists" -> decode.success(QuestionnaireenableoperatorExists)
    _ ->
      decode.failure(
        QuestionnaireenableoperatorLessthanequal,
        "Questionnaireenableoperator",
      )
  }
}

pub type Typederivationrule {
  TypederivationruleConstraint
  TypederivationruleSpecialization
}

pub fn typederivationrule_to_json(
  typederivationrule: Typederivationrule,
) -> Json {
  case typederivationrule {
    TypederivationruleConstraint -> json.string("constraint")
    TypederivationruleSpecialization -> json.string("specialization")
  }
}

pub fn typederivationrule_decoder() -> Decoder(Typederivationrule) {
  use variant <- decode.then(decode.string)
  case variant {
    "constraint" -> decode.success(TypederivationruleConstraint)
    "specialization" -> decode.success(TypederivationruleSpecialization)
    _ -> decode.failure(TypederivationruleConstraint, "Typederivationrule")
  }
}

pub type Claimuse {
  ClaimusePredetermination
  ClaimusePreauthorization
  ClaimuseClaim
}

pub fn claimuse_to_json(claimuse: Claimuse) -> Json {
  case claimuse {
    ClaimusePredetermination -> json.string("predetermination")
    ClaimusePreauthorization -> json.string("preauthorization")
    ClaimuseClaim -> json.string("claim")
  }
}

pub fn claimuse_decoder() -> Decoder(Claimuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "predetermination" -> decode.success(ClaimusePredetermination)
    "preauthorization" -> decode.success(ClaimusePreauthorization)
    "claim" -> decode.success(ClaimuseClaim)
    _ -> decode.failure(ClaimusePredetermination, "Claimuse")
  }
}

pub type Assertoperatorcodes {
  AssertoperatorcodesEval
  AssertoperatorcodesNotcontains
  AssertoperatorcodesContains
  AssertoperatorcodesNotempty
  AssertoperatorcodesEmpty
  AssertoperatorcodesLessthan
  AssertoperatorcodesGreaterthan
  AssertoperatorcodesNotin
  AssertoperatorcodesIn
  AssertoperatorcodesNotequals
  AssertoperatorcodesEquals
}

pub fn assertoperatorcodes_to_json(
  assertoperatorcodes: Assertoperatorcodes,
) -> Json {
  case assertoperatorcodes {
    AssertoperatorcodesEval -> json.string("eval")
    AssertoperatorcodesNotcontains -> json.string("notContains")
    AssertoperatorcodesContains -> json.string("contains")
    AssertoperatorcodesNotempty -> json.string("notEmpty")
    AssertoperatorcodesEmpty -> json.string("empty")
    AssertoperatorcodesLessthan -> json.string("lessThan")
    AssertoperatorcodesGreaterthan -> json.string("greaterThan")
    AssertoperatorcodesNotin -> json.string("notIn")
    AssertoperatorcodesIn -> json.string("in")
    AssertoperatorcodesNotequals -> json.string("notEquals")
    AssertoperatorcodesEquals -> json.string("equals")
  }
}

pub fn assertoperatorcodes_decoder() -> Decoder(Assertoperatorcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "eval" -> decode.success(AssertoperatorcodesEval)
    "notContains" -> decode.success(AssertoperatorcodesNotcontains)
    "contains" -> decode.success(AssertoperatorcodesContains)
    "notEmpty" -> decode.success(AssertoperatorcodesNotempty)
    "empty" -> decode.success(AssertoperatorcodesEmpty)
    "lessThan" -> decode.success(AssertoperatorcodesLessthan)
    "greaterThan" -> decode.success(AssertoperatorcodesGreaterthan)
    "notIn" -> decode.success(AssertoperatorcodesNotin)
    "in" -> decode.success(AssertoperatorcodesIn)
    "notEquals" -> decode.success(AssertoperatorcodesNotequals)
    "equals" -> decode.success(AssertoperatorcodesEquals)
    _ -> decode.failure(AssertoperatorcodesEval, "Assertoperatorcodes")
  }
}

pub type Devicestatus {
  DevicestatusUnknown
  DevicestatusEnteredinerror
  DevicestatusInactive
  DevicestatusActive
}

pub fn devicestatus_to_json(devicestatus: Devicestatus) -> Json {
  case devicestatus {
    DevicestatusUnknown -> json.string("unknown")
    DevicestatusEnteredinerror -> json.string("entered-in-error")
    DevicestatusInactive -> json.string("inactive")
    DevicestatusActive -> json.string("active")
  }
}

pub fn devicestatus_decoder() -> Decoder(Devicestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(DevicestatusUnknown)
    "entered-in-error" -> decode.success(DevicestatusEnteredinerror)
    "inactive" -> decode.success(DevicestatusInactive)
    "active" -> decode.success(DevicestatusActive)
    _ -> decode.failure(DevicestatusUnknown, "Devicestatus")
  }
}

pub type Searchcomparator {
  SearchcomparatorAp
  SearchcomparatorEb
  SearchcomparatorSa
  SearchcomparatorLe
  SearchcomparatorGe
  SearchcomparatorLt
  SearchcomparatorGt
  SearchcomparatorNe
  SearchcomparatorEq
}

pub fn searchcomparator_to_json(searchcomparator: Searchcomparator) -> Json {
  case searchcomparator {
    SearchcomparatorAp -> json.string("ap")
    SearchcomparatorEb -> json.string("eb")
    SearchcomparatorSa -> json.string("sa")
    SearchcomparatorLe -> json.string("le")
    SearchcomparatorGe -> json.string("ge")
    SearchcomparatorLt -> json.string("lt")
    SearchcomparatorGt -> json.string("gt")
    SearchcomparatorNe -> json.string("ne")
    SearchcomparatorEq -> json.string("eq")
  }
}

pub fn searchcomparator_decoder() -> Decoder(Searchcomparator) {
  use variant <- decode.then(decode.string)
  case variant {
    "ap" -> decode.success(SearchcomparatorAp)
    "eb" -> decode.success(SearchcomparatorEb)
    "sa" -> decode.success(SearchcomparatorSa)
    "le" -> decode.success(SearchcomparatorLe)
    "ge" -> decode.success(SearchcomparatorGe)
    "lt" -> decode.success(SearchcomparatorLt)
    "gt" -> decode.success(SearchcomparatorGt)
    "ne" -> decode.success(SearchcomparatorNe)
    "eq" -> decode.success(SearchcomparatorEq)
    _ -> decode.failure(SearchcomparatorAp, "Searchcomparator")
  }
}

pub type Visionbasecodes {
  VisionbasecodesOut
  VisionbasecodesIn
  VisionbasecodesDown
  VisionbasecodesUp
}

pub fn visionbasecodes_to_json(visionbasecodes: Visionbasecodes) -> Json {
  case visionbasecodes {
    VisionbasecodesOut -> json.string("out")
    VisionbasecodesIn -> json.string("in")
    VisionbasecodesDown -> json.string("down")
    VisionbasecodesUp -> json.string("up")
  }
}

pub fn visionbasecodes_decoder() -> Decoder(Visionbasecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "out" -> decode.success(VisionbasecodesOut)
    "in" -> decode.success(VisionbasecodesIn)
    "down" -> decode.success(VisionbasecodesDown)
    "up" -> decode.success(VisionbasecodesUp)
    _ -> decode.failure(VisionbasecodesOut, "Visionbasecodes")
  }
}

pub type Eligibilityresponsepurpose {
  EligibilityresponsepurposeValidation
  EligibilityresponsepurposeDiscovery
  EligibilityresponsepurposeBenefits
  EligibilityresponsepurposeAuthrequirements
}

pub fn eligibilityresponsepurpose_to_json(
  eligibilityresponsepurpose: Eligibilityresponsepurpose,
) -> Json {
  case eligibilityresponsepurpose {
    EligibilityresponsepurposeValidation -> json.string("validation")
    EligibilityresponsepurposeDiscovery -> json.string("discovery")
    EligibilityresponsepurposeBenefits -> json.string("benefits")
    EligibilityresponsepurposeAuthrequirements ->
      json.string("auth-requirements")
  }
}

pub fn eligibilityresponsepurpose_decoder() -> Decoder(
  Eligibilityresponsepurpose,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "validation" -> decode.success(EligibilityresponsepurposeValidation)
    "discovery" -> decode.success(EligibilityresponsepurposeDiscovery)
    "benefits" -> decode.success(EligibilityresponsepurposeBenefits)
    "auth-requirements" ->
      decode.success(EligibilityresponsepurposeAuthrequirements)
    _ ->
      decode.failure(
        EligibilityresponsepurposeValidation,
        "Eligibilityresponsepurpose",
      )
  }
}

pub type Discriminatortype {
  DiscriminatortypeProfile
  DiscriminatortypeType
  DiscriminatortypePattern
  DiscriminatortypeExists
  DiscriminatortypeValue
}

pub fn discriminatortype_to_json(discriminatortype: Discriminatortype) -> Json {
  case discriminatortype {
    DiscriminatortypeProfile -> json.string("profile")
    DiscriminatortypeType -> json.string("type")
    DiscriminatortypePattern -> json.string("pattern")
    DiscriminatortypeExists -> json.string("exists")
    DiscriminatortypeValue -> json.string("value")
  }
}

pub fn discriminatortype_decoder() -> Decoder(Discriminatortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "profile" -> decode.success(DiscriminatortypeProfile)
    "type" -> decode.success(DiscriminatortypeType)
    "pattern" -> decode.success(DiscriminatortypePattern)
    "exists" -> decode.success(DiscriminatortypeExists)
    "value" -> decode.success(DiscriminatortypeValue)
    _ -> decode.failure(DiscriminatortypeProfile, "Discriminatortype")
  }
}

pub type Narrativestatus {
  NarrativestatusEmpty
  NarrativestatusAdditional
  NarrativestatusExtensions
  NarrativestatusGenerated
}

pub fn narrativestatus_to_json(narrativestatus: Narrativestatus) -> Json {
  case narrativestatus {
    NarrativestatusEmpty -> json.string("empty")
    NarrativestatusAdditional -> json.string("additional")
    NarrativestatusExtensions -> json.string("extensions")
    NarrativestatusGenerated -> json.string("generated")
  }
}

pub fn narrativestatus_decoder() -> Decoder(Narrativestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "empty" -> decode.success(NarrativestatusEmpty)
    "additional" -> decode.success(NarrativestatusAdditional)
    "extensions" -> decode.success(NarrativestatusExtensions)
    "generated" -> decode.success(NarrativestatusGenerated)
    _ -> decode.failure(NarrativestatusEmpty, "Narrativestatus")
  }
}

pub type Versioningpolicy {
  VersioningpolicyVersionedupdate
  VersioningpolicyVersioned
  VersioningpolicyNoversion
}

pub fn versioningpolicy_to_json(versioningpolicy: Versioningpolicy) -> Json {
  case versioningpolicy {
    VersioningpolicyVersionedupdate -> json.string("versioned-update")
    VersioningpolicyVersioned -> json.string("versioned")
    VersioningpolicyNoversion -> json.string("no-version")
  }
}

pub fn versioningpolicy_decoder() -> Decoder(Versioningpolicy) {
  use variant <- decode.then(decode.string)
  case variant {
    "versioned-update" -> decode.success(VersioningpolicyVersionedupdate)
    "versioned" -> decode.success(VersioningpolicyVersioned)
    "no-version" -> decode.success(VersioningpolicyNoversion)
    _ -> decode.failure(VersioningpolicyVersionedupdate, "Versioningpolicy")
  }
}

pub type Consentprovisiontype {
  ConsentprovisiontypePermit
  ConsentprovisiontypeDeny
}

pub fn consentprovisiontype_to_json(
  consentprovisiontype: Consentprovisiontype,
) -> Json {
  case consentprovisiontype {
    ConsentprovisiontypePermit -> json.string("permit")
    ConsentprovisiontypeDeny -> json.string("deny")
  }
}

pub fn consentprovisiontype_decoder() -> Decoder(Consentprovisiontype) {
  use variant <- decode.then(decode.string)
  case variant {
    "permit" -> decode.success(ConsentprovisiontypePermit)
    "deny" -> decode.success(ConsentprovisiontypeDeny)
    _ -> decode.failure(ConsentprovisiontypePermit, "Consentprovisiontype")
  }
}

pub type Actionconditionkind {
  ActionconditionkindStop
  ActionconditionkindStart
  ActionconditionkindApplicability
}

pub fn actionconditionkind_to_json(
  actionconditionkind: Actionconditionkind,
) -> Json {
  case actionconditionkind {
    ActionconditionkindStop -> json.string("stop")
    ActionconditionkindStart -> json.string("start")
    ActionconditionkindApplicability -> json.string("applicability")
  }
}

pub fn actionconditionkind_decoder() -> Decoder(Actionconditionkind) {
  use variant <- decode.then(decode.string)
  case variant {
    "stop" -> decode.success(ActionconditionkindStop)
    "start" -> decode.success(ActionconditionkindStart)
    "applicability" -> decode.success(ActionconditionkindApplicability)
    _ -> decode.failure(ActionconditionkindStop, "Actionconditionkind")
  }
}

pub type Bundletype {
  BundletypeCollection
  BundletypeSearchset
  BundletypeHistory
  BundletypeBatchresponse
  BundletypeBatch
  BundletypeTransactionresponse
  BundletypeTransaction
  BundletypeMessage
  BundletypeDocument
}

pub fn bundletype_to_json(bundletype: Bundletype) -> Json {
  case bundletype {
    BundletypeCollection -> json.string("collection")
    BundletypeSearchset -> json.string("searchset")
    BundletypeHistory -> json.string("history")
    BundletypeBatchresponse -> json.string("batch-response")
    BundletypeBatch -> json.string("batch")
    BundletypeTransactionresponse -> json.string("transaction-response")
    BundletypeTransaction -> json.string("transaction")
    BundletypeMessage -> json.string("message")
    BundletypeDocument -> json.string("document")
  }
}

pub fn bundletype_decoder() -> Decoder(Bundletype) {
  use variant <- decode.then(decode.string)
  case variant {
    "collection" -> decode.success(BundletypeCollection)
    "searchset" -> decode.success(BundletypeSearchset)
    "history" -> decode.success(BundletypeHistory)
    "batch-response" -> decode.success(BundletypeBatchresponse)
    "batch" -> decode.success(BundletypeBatch)
    "transaction-response" -> decode.success(BundletypeTransactionresponse)
    "transaction" -> decode.success(BundletypeTransaction)
    "message" -> decode.success(BundletypeMessage)
    "document" -> decode.success(BundletypeDocument)
    _ -> decode.failure(BundletypeCollection, "Bundletype")
  }
}

pub type Actionselectionbehavior {
  ActionselectionbehaviorOneormore
  ActionselectionbehaviorAtmostone
  ActionselectionbehaviorExactlyone
  ActionselectionbehaviorAllornone
  ActionselectionbehaviorAll
  ActionselectionbehaviorAny
}

pub fn actionselectionbehavior_to_json(
  actionselectionbehavior: Actionselectionbehavior,
) -> Json {
  case actionselectionbehavior {
    ActionselectionbehaviorOneormore -> json.string("one-or-more")
    ActionselectionbehaviorAtmostone -> json.string("at-most-one")
    ActionselectionbehaviorExactlyone -> json.string("exactly-one")
    ActionselectionbehaviorAllornone -> json.string("all-or-none")
    ActionselectionbehaviorAll -> json.string("all")
    ActionselectionbehaviorAny -> json.string("any")
  }
}

pub fn actionselectionbehavior_decoder() -> Decoder(Actionselectionbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "one-or-more" -> decode.success(ActionselectionbehaviorOneormore)
    "at-most-one" -> decode.success(ActionselectionbehaviorAtmostone)
    "exactly-one" -> decode.success(ActionselectionbehaviorExactlyone)
    "all-or-none" -> decode.success(ActionselectionbehaviorAllornone)
    "all" -> decode.success(ActionselectionbehaviorAll)
    "any" -> decode.success(ActionselectionbehaviorAny)
    _ ->
      decode.failure(
        ActionselectionbehaviorOneormore,
        "Actionselectionbehavior",
      )
  }
}

pub type Maptransform {
  MaptransformCp
  MaptransformId
  MaptransformQty
  MaptransformC
  MaptransformCc
  MaptransformEvaluate
  MaptransformPointer
  MaptransformUuid
  MaptransformDateop
  MaptransformReference
  MaptransformTranslate
  MaptransformAppend
  MaptransformCast
  MaptransformEscape
  MaptransformTruncate
  MaptransformCopy
  MaptransformCreate
}

pub fn maptransform_to_json(maptransform: Maptransform) -> Json {
  case maptransform {
    MaptransformCp -> json.string("cp")
    MaptransformId -> json.string("id")
    MaptransformQty -> json.string("qty")
    MaptransformC -> json.string("c")
    MaptransformCc -> json.string("cc")
    MaptransformEvaluate -> json.string("evaluate")
    MaptransformPointer -> json.string("pointer")
    MaptransformUuid -> json.string("uuid")
    MaptransformDateop -> json.string("dateOp")
    MaptransformReference -> json.string("reference")
    MaptransformTranslate -> json.string("translate")
    MaptransformAppend -> json.string("append")
    MaptransformCast -> json.string("cast")
    MaptransformEscape -> json.string("escape")
    MaptransformTruncate -> json.string("truncate")
    MaptransformCopy -> json.string("copy")
    MaptransformCreate -> json.string("create")
  }
}

pub fn maptransform_decoder() -> Decoder(Maptransform) {
  use variant <- decode.then(decode.string)
  case variant {
    "cp" -> decode.success(MaptransformCp)
    "id" -> decode.success(MaptransformId)
    "qty" -> decode.success(MaptransformQty)
    "c" -> decode.success(MaptransformC)
    "cc" -> decode.success(MaptransformCc)
    "evaluate" -> decode.success(MaptransformEvaluate)
    "pointer" -> decode.success(MaptransformPointer)
    "uuid" -> decode.success(MaptransformUuid)
    "dateOp" -> decode.success(MaptransformDateop)
    "reference" -> decode.success(MaptransformReference)
    "translate" -> decode.success(MaptransformTranslate)
    "append" -> decode.success(MaptransformAppend)
    "cast" -> decode.success(MaptransformCast)
    "escape" -> decode.success(MaptransformEscape)
    "truncate" -> decode.success(MaptransformTruncate)
    "copy" -> decode.success(MaptransformCopy)
    "create" -> decode.success(MaptransformCreate)
    _ -> decode.failure(MaptransformCp, "Maptransform")
  }
}

pub type Contactpointsystem {
  ContactpointsystemOther
  ContactpointsystemSms
  ContactpointsystemUrl
  ContactpointsystemPager
  ContactpointsystemEmail
  ContactpointsystemFax
  ContactpointsystemPhone
}

pub fn contactpointsystem_to_json(
  contactpointsystem: Contactpointsystem,
) -> Json {
  case contactpointsystem {
    ContactpointsystemOther -> json.string("other")
    ContactpointsystemSms -> json.string("sms")
    ContactpointsystemUrl -> json.string("url")
    ContactpointsystemPager -> json.string("pager")
    ContactpointsystemEmail -> json.string("email")
    ContactpointsystemFax -> json.string("fax")
    ContactpointsystemPhone -> json.string("phone")
  }
}

pub fn contactpointsystem_decoder() -> Decoder(Contactpointsystem) {
  use variant <- decode.then(decode.string)
  case variant {
    "other" -> decode.success(ContactpointsystemOther)
    "sms" -> decode.success(ContactpointsystemSms)
    "url" -> decode.success(ContactpointsystemUrl)
    "pager" -> decode.success(ContactpointsystemPager)
    "email" -> decode.success(ContactpointsystemEmail)
    "fax" -> decode.success(ContactpointsystemFax)
    "phone" -> decode.success(ContactpointsystemPhone)
    _ -> decode.failure(ContactpointsystemOther, "Contactpointsystem")
  }
}

pub type Remittanceoutcome {
  RemittanceoutcomePartial
  RemittanceoutcomeError
  RemittanceoutcomeComplete
  RemittanceoutcomeQueued
}

pub fn remittanceoutcome_to_json(remittanceoutcome: Remittanceoutcome) -> Json {
  case remittanceoutcome {
    RemittanceoutcomePartial -> json.string("partial")
    RemittanceoutcomeError -> json.string("error")
    RemittanceoutcomeComplete -> json.string("complete")
    RemittanceoutcomeQueued -> json.string("queued")
  }
}

pub fn remittanceoutcome_decoder() -> Decoder(Remittanceoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "partial" -> decode.success(RemittanceoutcomePartial)
    "error" -> decode.success(RemittanceoutcomeError)
    "complete" -> decode.success(RemittanceoutcomeComplete)
    "queued" -> decode.success(RemittanceoutcomeQueued)
    _ -> decode.failure(RemittanceoutcomePartial, "Remittanceoutcome")
  }
}

pub type Appointmentstatus {
  AppointmentstatusWaitlist
  AppointmentstatusCheckedin
  AppointmentstatusEnteredinerror
  AppointmentstatusNoshow
  AppointmentstatusCancelled
  AppointmentstatusFulfilled
  AppointmentstatusArrived
  AppointmentstatusBooked
  AppointmentstatusPending
  AppointmentstatusProposed
}

pub fn appointmentstatus_to_json(appointmentstatus: Appointmentstatus) -> Json {
  case appointmentstatus {
    AppointmentstatusWaitlist -> json.string("waitlist")
    AppointmentstatusCheckedin -> json.string("checked-in")
    AppointmentstatusEnteredinerror -> json.string("entered-in-error")
    AppointmentstatusNoshow -> json.string("noshow")
    AppointmentstatusCancelled -> json.string("cancelled")
    AppointmentstatusFulfilled -> json.string("fulfilled")
    AppointmentstatusArrived -> json.string("arrived")
    AppointmentstatusBooked -> json.string("booked")
    AppointmentstatusPending -> json.string("pending")
    AppointmentstatusProposed -> json.string("proposed")
  }
}

pub fn appointmentstatus_decoder() -> Decoder(Appointmentstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "waitlist" -> decode.success(AppointmentstatusWaitlist)
    "checked-in" -> decode.success(AppointmentstatusCheckedin)
    "entered-in-error" -> decode.success(AppointmentstatusEnteredinerror)
    "noshow" -> decode.success(AppointmentstatusNoshow)
    "cancelled" -> decode.success(AppointmentstatusCancelled)
    "fulfilled" -> decode.success(AppointmentstatusFulfilled)
    "arrived" -> decode.success(AppointmentstatusArrived)
    "booked" -> decode.success(AppointmentstatusBooked)
    "pending" -> decode.success(AppointmentstatusPending)
    "proposed" -> decode.success(AppointmentstatusProposed)
    _ -> decode.failure(AppointmentstatusWaitlist, "Appointmentstatus")
  }
}

pub type Examplescenarioactortype {
  ExamplescenarioactortypeEntity
  ExamplescenarioactortypePerson
}

pub fn examplescenarioactortype_to_json(
  examplescenarioactortype: Examplescenarioactortype,
) -> Json {
  case examplescenarioactortype {
    ExamplescenarioactortypeEntity -> json.string("entity")
    ExamplescenarioactortypePerson -> json.string("person")
  }
}

pub fn examplescenarioactortype_decoder() -> Decoder(Examplescenarioactortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "entity" -> decode.success(ExamplescenarioactortypeEntity)
    "person" -> decode.success(ExamplescenarioactortypePerson)
    _ ->
      decode.failure(ExamplescenarioactortypeEntity, "Examplescenarioactortype")
  }
}

pub type Networktype {
  Networktype5
  Networktype4
  Networktype3
  Networktype2
  Networktype1
}

pub fn networktype_to_json(networktype: Networktype) -> Json {
  case networktype {
    Networktype5 -> json.string("5")
    Networktype4 -> json.string("4")
    Networktype3 -> json.string("3")
    Networktype2 -> json.string("2")
    Networktype1 -> json.string("1")
  }
}

pub fn networktype_decoder() -> Decoder(Networktype) {
  use variant <- decode.then(decode.string)
  case variant {
    "5" -> decode.success(Networktype5)
    "4" -> decode.success(Networktype4)
    "3" -> decode.success(Networktype3)
    "2" -> decode.success(Networktype2)
    "1" -> decode.success(Networktype1)
    _ -> decode.failure(Networktype5, "Networktype")
  }
}

pub type Conceptmapequivalence {
  ConceptmapequivalenceUnmatched
  ConceptmapequivalenceRelatedto
  ConceptmapequivalenceInexact
  ConceptmapequivalenceSpecializes
  ConceptmapequivalenceNarrower
  ConceptmapequivalenceSubsumes
  ConceptmapequivalenceWider
  ConceptmapequivalenceEquivalent
  ConceptmapequivalenceEqual
  ConceptmapequivalenceDisjoint
}

pub fn conceptmapequivalence_to_json(
  conceptmapequivalence: Conceptmapequivalence,
) -> Json {
  case conceptmapequivalence {
    ConceptmapequivalenceUnmatched -> json.string("unmatched")
    ConceptmapequivalenceRelatedto -> json.string("relatedto")
    ConceptmapequivalenceInexact -> json.string("inexact")
    ConceptmapequivalenceSpecializes -> json.string("specializes")
    ConceptmapequivalenceNarrower -> json.string("narrower")
    ConceptmapequivalenceSubsumes -> json.string("subsumes")
    ConceptmapequivalenceWider -> json.string("wider")
    ConceptmapequivalenceEquivalent -> json.string("equivalent")
    ConceptmapequivalenceEqual -> json.string("equal")
    ConceptmapequivalenceDisjoint -> json.string("disjoint")
  }
}

pub fn conceptmapequivalence_decoder() -> Decoder(Conceptmapequivalence) {
  use variant <- decode.then(decode.string)
  case variant {
    "unmatched" -> decode.success(ConceptmapequivalenceUnmatched)
    "relatedto" -> decode.success(ConceptmapequivalenceRelatedto)
    "inexact" -> decode.success(ConceptmapequivalenceInexact)
    "specializes" -> decode.success(ConceptmapequivalenceSpecializes)
    "narrower" -> decode.success(ConceptmapequivalenceNarrower)
    "subsumes" -> decode.success(ConceptmapequivalenceSubsumes)
    "wider" -> decode.success(ConceptmapequivalenceWider)
    "equivalent" -> decode.success(ConceptmapequivalenceEquivalent)
    "equal" -> decode.success(ConceptmapequivalenceEqual)
    "disjoint" -> decode.success(ConceptmapequivalenceDisjoint)
    _ -> decode.failure(ConceptmapequivalenceUnmatched, "Conceptmapequivalence")
  }
}

pub type Triggertype {
  TriggertypeDataaccessended
  TriggertypeDataaccessed
  TriggertypeDatachanged
  TriggertypePeriodic
  TriggertypeNamedevent
  TriggertypeDataremoved
  TriggertypeDatamodified
  TriggertypeDataadded
}

pub fn triggertype_to_json(triggertype: Triggertype) -> Json {
  case triggertype {
    TriggertypeDataaccessended -> json.string("data-access-ended")
    TriggertypeDataaccessed -> json.string("data-accessed")
    TriggertypeDatachanged -> json.string("data-changed")
    TriggertypePeriodic -> json.string("periodic")
    TriggertypeNamedevent -> json.string("named-event")
    TriggertypeDataremoved -> json.string("data-removed")
    TriggertypeDatamodified -> json.string("data-modified")
    TriggertypeDataadded -> json.string("data-added")
  }
}

pub fn triggertype_decoder() -> Decoder(Triggertype) {
  use variant <- decode.then(decode.string)
  case variant {
    "data-access-ended" -> decode.success(TriggertypeDataaccessended)
    "data-accessed" -> decode.success(TriggertypeDataaccessed)
    "data-changed" -> decode.success(TriggertypeDatachanged)
    "periodic" -> decode.success(TriggertypePeriodic)
    "named-event" -> decode.success(TriggertypeNamedevent)
    "data-removed" -> decode.success(TriggertypeDataremoved)
    "data-modified" -> decode.success(TriggertypeDatamodified)
    "data-added" -> decode.success(TriggertypeDataadded)
    _ -> decode.failure(TriggertypeDataaccessended, "Triggertype")
  }
}

pub type Relatedartifacttype {
  RelatedartifacttypeComposedof
  RelatedartifacttypeDependson
  RelatedartifacttypeDerivedfrom
  RelatedartifacttypeSuccessor
  RelatedartifacttypePredecessor
  RelatedartifacttypeCitation
  RelatedartifacttypeJustification
  RelatedartifacttypeDocumentation
}

pub fn relatedartifacttype_to_json(
  relatedartifacttype: Relatedartifacttype,
) -> Json {
  case relatedartifacttype {
    RelatedartifacttypeComposedof -> json.string("composed-of")
    RelatedartifacttypeDependson -> json.string("depends-on")
    RelatedartifacttypeDerivedfrom -> json.string("derived-from")
    RelatedartifacttypeSuccessor -> json.string("successor")
    RelatedartifacttypePredecessor -> json.string("predecessor")
    RelatedartifacttypeCitation -> json.string("citation")
    RelatedartifacttypeJustification -> json.string("justification")
    RelatedartifacttypeDocumentation -> json.string("documentation")
  }
}

pub fn relatedartifacttype_decoder() -> Decoder(Relatedartifacttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "composed-of" -> decode.success(RelatedartifacttypeComposedof)
    "depends-on" -> decode.success(RelatedartifacttypeDependson)
    "derived-from" -> decode.success(RelatedartifacttypeDerivedfrom)
    "successor" -> decode.success(RelatedartifacttypeSuccessor)
    "predecessor" -> decode.success(RelatedartifacttypePredecessor)
    "citation" -> decode.success(RelatedartifacttypeCitation)
    "justification" -> decode.success(RelatedartifacttypeJustification)
    "documentation" -> decode.success(RelatedartifacttypeDocumentation)
    _ -> decode.failure(RelatedartifacttypeComposedof, "Relatedartifacttype")
  }
}

pub type Documentreferencestatus {
  DocumentreferencestatusEnteredinerror
  DocumentreferencestatusSuperseded
  DocumentreferencestatusCurrent
}

pub fn documentreferencestatus_to_json(
  documentreferencestatus: Documentreferencestatus,
) -> Json {
  case documentreferencestatus {
    DocumentreferencestatusEnteredinerror -> json.string("entered-in-error")
    DocumentreferencestatusSuperseded -> json.string("superseded")
    DocumentreferencestatusCurrent -> json.string("current")
  }
}

pub fn documentreferencestatus_decoder() -> Decoder(Documentreferencestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(DocumentreferencestatusEnteredinerror)
    "superseded" -> decode.success(DocumentreferencestatusSuperseded)
    "current" -> decode.success(DocumentreferencestatusCurrent)
    _ ->
      decode.failure(
        DocumentreferencestatusEnteredinerror,
        "Documentreferencestatus",
      )
  }
}

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningClassifiedwith
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningGroupedby
}

pub fn codesystemhierarchymeaning_to_json(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> Json {
  case codesystemhierarchymeaning {
    CodesystemhierarchymeaningClassifiedwith -> json.string("classified-with")
    CodesystemhierarchymeaningPartof -> json.string("part-of")
    CodesystemhierarchymeaningIsa -> json.string("is-a")
    CodesystemhierarchymeaningGroupedby -> json.string("grouped-by")
  }
}

pub fn codesystemhierarchymeaning_decoder() -> Decoder(
  Codesystemhierarchymeaning,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "classified-with" ->
      decode.success(CodesystemhierarchymeaningClassifiedwith)
    "part-of" -> decode.success(CodesystemhierarchymeaningPartof)
    "is-a" -> decode.success(CodesystemhierarchymeaningIsa)
    "grouped-by" -> decode.success(CodesystemhierarchymeaningGroupedby)
    _ ->
      decode.failure(
        CodesystemhierarchymeaningClassifiedwith,
        "Codesystemhierarchymeaning",
      )
  }
}

pub type Eventstatus {
  EventstatusUnknown
  EventstatusEnteredinerror
  EventstatusCompleted
  EventstatusStopped
  EventstatusOnhold
  EventstatusNotdone
  EventstatusInprogress
  EventstatusPreparation
}

pub fn eventstatus_to_json(eventstatus: Eventstatus) -> Json {
  case eventstatus {
    EventstatusUnknown -> json.string("unknown")
    EventstatusEnteredinerror -> json.string("entered-in-error")
    EventstatusCompleted -> json.string("completed")
    EventstatusStopped -> json.string("stopped")
    EventstatusOnhold -> json.string("on-hold")
    EventstatusNotdone -> json.string("not-done")
    EventstatusInprogress -> json.string("in-progress")
    EventstatusPreparation -> json.string("preparation")
  }
}

pub fn eventstatus_decoder() -> Decoder(Eventstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(EventstatusUnknown)
    "entered-in-error" -> decode.success(EventstatusEnteredinerror)
    "completed" -> decode.success(EventstatusCompleted)
    "stopped" -> decode.success(EventstatusStopped)
    "on-hold" -> decode.success(EventstatusOnhold)
    "not-done" -> decode.success(EventstatusNotdone)
    "in-progress" -> decode.success(EventstatusInprogress)
    "preparation" -> decode.success(EventstatusPreparation)
    _ -> decode.failure(EventstatusUnknown, "Eventstatus")
  }
}

pub type Devicestatementstatus {
  DevicestatementstatusOnhold
  DevicestatementstatusStopped
  DevicestatementstatusIntended
  DevicestatementstatusEnteredinerror
  DevicestatementstatusCompleted
  DevicestatementstatusActive
}

pub fn devicestatementstatus_to_json(
  devicestatementstatus: Devicestatementstatus,
) -> Json {
  case devicestatementstatus {
    DevicestatementstatusOnhold -> json.string("on-hold")
    DevicestatementstatusStopped -> json.string("stopped")
    DevicestatementstatusIntended -> json.string("intended")
    DevicestatementstatusEnteredinerror -> json.string("entered-in-error")
    DevicestatementstatusCompleted -> json.string("completed")
    DevicestatementstatusActive -> json.string("active")
  }
}

pub fn devicestatementstatus_decoder() -> Decoder(Devicestatementstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "on-hold" -> decode.success(DevicestatementstatusOnhold)
    "stopped" -> decode.success(DevicestatementstatusStopped)
    "intended" -> decode.success(DevicestatementstatusIntended)
    "entered-in-error" -> decode.success(DevicestatementstatusEnteredinerror)
    "completed" -> decode.success(DevicestatementstatusCompleted)
    "active" -> decode.success(DevicestatementstatusActive)
    _ -> decode.failure(DevicestatementstatusOnhold, "Devicestatementstatus")
  }
}

pub type Encounterstatus {
  EncounterstatusUnknown
  EncounterstatusEnteredinerror
  EncounterstatusCancelled
  EncounterstatusFinished
  EncounterstatusOnleave
  EncounterstatusInprogress
  EncounterstatusTriaged
  EncounterstatusArrived
  EncounterstatusPlanned
}

pub fn encounterstatus_to_json(encounterstatus: Encounterstatus) -> Json {
  case encounterstatus {
    EncounterstatusUnknown -> json.string("unknown")
    EncounterstatusEnteredinerror -> json.string("entered-in-error")
    EncounterstatusCancelled -> json.string("cancelled")
    EncounterstatusFinished -> json.string("finished")
    EncounterstatusOnleave -> json.string("onleave")
    EncounterstatusInprogress -> json.string("in-progress")
    EncounterstatusTriaged -> json.string("triaged")
    EncounterstatusArrived -> json.string("arrived")
    EncounterstatusPlanned -> json.string("planned")
  }
}

pub fn encounterstatus_decoder() -> Decoder(Encounterstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(EncounterstatusUnknown)
    "entered-in-error" -> decode.success(EncounterstatusEnteredinerror)
    "cancelled" -> decode.success(EncounterstatusCancelled)
    "finished" -> decode.success(EncounterstatusFinished)
    "onleave" -> decode.success(EncounterstatusOnleave)
    "in-progress" -> decode.success(EncounterstatusInprogress)
    "triaged" -> decode.success(EncounterstatusTriaged)
    "arrived" -> decode.success(EncounterstatusArrived)
    "planned" -> decode.success(EncounterstatusPlanned)
    _ -> decode.failure(EncounterstatusUnknown, "Encounterstatus")
  }
}

pub type Orientationtype {
  OrientationtypeAntisense
  OrientationtypeSense
}

pub fn orientationtype_to_json(orientationtype: Orientationtype) -> Json {
  case orientationtype {
    OrientationtypeAntisense -> json.string("antisense")
    OrientationtypeSense -> json.string("sense")
  }
}

pub fn orientationtype_decoder() -> Decoder(Orientationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "antisense" -> decode.success(OrientationtypeAntisense)
    "sense" -> decode.success(OrientationtypeSense)
    _ -> decode.failure(OrientationtypeAntisense, "Orientationtype")
  }
}

pub type Allergyintolerancecriticality {
  AllergyintolerancecriticalityUnabletoassess
  AllergyintolerancecriticalityHigh
  AllergyintolerancecriticalityLow
}

pub fn allergyintolerancecriticality_to_json(
  allergyintolerancecriticality: Allergyintolerancecriticality,
) -> Json {
  case allergyintolerancecriticality {
    AllergyintolerancecriticalityUnabletoassess ->
      json.string("unable-to-assess")
    AllergyintolerancecriticalityHigh -> json.string("high")
    AllergyintolerancecriticalityLow -> json.string("low")
  }
}

pub fn allergyintolerancecriticality_decoder() -> Decoder(
  Allergyintolerancecriticality,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "unable-to-assess" ->
      decode.success(AllergyintolerancecriticalityUnabletoassess)
    "high" -> decode.success(AllergyintolerancecriticalityHigh)
    "low" -> decode.success(AllergyintolerancecriticalityLow)
    _ ->
      decode.failure(
        AllergyintolerancecriticalityUnabletoassess,
        "Allergyintolerancecriticality",
      )
  }
}

pub type Actionrelationshiptype {
  ActionrelationshiptypeAfterend
  ActionrelationshiptypeAfter
  ActionrelationshiptypeAfterstart
  ActionrelationshiptypeConcurrentwithend
  ActionrelationshiptypeConcurrent
  ActionrelationshiptypeConcurrentwithstart
  ActionrelationshiptypeBeforeend
  ActionrelationshiptypeBefore
  ActionrelationshiptypeBeforestart
}

pub fn actionrelationshiptype_to_json(
  actionrelationshiptype: Actionrelationshiptype,
) -> Json {
  case actionrelationshiptype {
    ActionrelationshiptypeAfterend -> json.string("after-end")
    ActionrelationshiptypeAfter -> json.string("after")
    ActionrelationshiptypeAfterstart -> json.string("after-start")
    ActionrelationshiptypeConcurrentwithend ->
      json.string("concurrent-with-end")
    ActionrelationshiptypeConcurrent -> json.string("concurrent")
    ActionrelationshiptypeConcurrentwithstart ->
      json.string("concurrent-with-start")
    ActionrelationshiptypeBeforeend -> json.string("before-end")
    ActionrelationshiptypeBefore -> json.string("before")
    ActionrelationshiptypeBeforestart -> json.string("before-start")
  }
}

pub fn actionrelationshiptype_decoder() -> Decoder(Actionrelationshiptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "after-end" -> decode.success(ActionrelationshiptypeAfterend)
    "after" -> decode.success(ActionrelationshiptypeAfter)
    "after-start" -> decode.success(ActionrelationshiptypeAfterstart)
    "concurrent-with-end" ->
      decode.success(ActionrelationshiptypeConcurrentwithend)
    "concurrent" -> decode.success(ActionrelationshiptypeConcurrent)
    "concurrent-with-start" ->
      decode.success(ActionrelationshiptypeConcurrentwithstart)
    "before-end" -> decode.success(ActionrelationshiptypeBeforeend)
    "before" -> decode.success(ActionrelationshiptypeBefore)
    "before-start" -> decode.success(ActionrelationshiptypeBeforestart)
    _ ->
      decode.failure(ActionrelationshiptypeAfterend, "Actionrelationshiptype")
  }
}

pub type Issueseverity {
  IssueseverityInformation
  IssueseverityWarning
  IssueseverityError
  IssueseverityFatal
}

pub fn issueseverity_to_json(issueseverity: Issueseverity) -> Json {
  case issueseverity {
    IssueseverityInformation -> json.string("information")
    IssueseverityWarning -> json.string("warning")
    IssueseverityError -> json.string("error")
    IssueseverityFatal -> json.string("fatal")
  }
}

pub fn issueseverity_decoder() -> Decoder(Issueseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "information" -> decode.success(IssueseverityInformation)
    "warning" -> decode.success(IssueseverityWarning)
    "error" -> decode.success(IssueseverityError)
    "fatal" -> decode.success(IssueseverityFatal)
    _ -> decode.failure(IssueseverityInformation, "Issueseverity")
  }
}

pub type Slotstatus {
  SlotstatusEnteredinerror
  SlotstatusBusytentative
  SlotstatusBusyunavailable
  SlotstatusFree
  SlotstatusBusy
}

pub fn slotstatus_to_json(slotstatus: Slotstatus) -> Json {
  case slotstatus {
    SlotstatusEnteredinerror -> json.string("entered-in-error")
    SlotstatusBusytentative -> json.string("busy-tentative")
    SlotstatusBusyunavailable -> json.string("busy-unavailable")
    SlotstatusFree -> json.string("free")
    SlotstatusBusy -> json.string("busy")
  }
}

pub fn slotstatus_decoder() -> Decoder(Slotstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(SlotstatusEnteredinerror)
    "busy-tentative" -> decode.success(SlotstatusBusytentative)
    "busy-unavailable" -> decode.success(SlotstatusBusyunavailable)
    "free" -> decode.success(SlotstatusFree)
    "busy" -> decode.success(SlotstatusBusy)
    _ -> decode.failure(SlotstatusEnteredinerror, "Slotstatus")
  }
}

pub type Codesystemcontentmode {
  CodesystemcontentmodeSupplement
  CodesystemcontentmodeComplete
  CodesystemcontentmodeFragment
  CodesystemcontentmodeExample
  CodesystemcontentmodeNotpresent
}

pub fn codesystemcontentmode_to_json(
  codesystemcontentmode: Codesystemcontentmode,
) -> Json {
  case codesystemcontentmode {
    CodesystemcontentmodeSupplement -> json.string("supplement")
    CodesystemcontentmodeComplete -> json.string("complete")
    CodesystemcontentmodeFragment -> json.string("fragment")
    CodesystemcontentmodeExample -> json.string("example")
    CodesystemcontentmodeNotpresent -> json.string("not-present")
  }
}

pub fn codesystemcontentmode_decoder() -> Decoder(Codesystemcontentmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "supplement" -> decode.success(CodesystemcontentmodeSupplement)
    "complete" -> decode.success(CodesystemcontentmodeComplete)
    "fragment" -> decode.success(CodesystemcontentmodeFragment)
    "example" -> decode.success(CodesystemcontentmodeExample)
    "not-present" -> decode.success(CodesystemcontentmodeNotpresent)
    _ ->
      decode.failure(CodesystemcontentmodeSupplement, "Codesystemcontentmode")
  }
}

pub type Metriccolor {
  MetriccolorWhite
  MetriccolorCyan
  MetriccolorMagenta
  MetriccolorBlue
  MetriccolorYellow
  MetriccolorGreen
  MetriccolorRed
  MetriccolorBlack
}

pub fn metriccolor_to_json(metriccolor: Metriccolor) -> Json {
  case metriccolor {
    MetriccolorWhite -> json.string("white")
    MetriccolorCyan -> json.string("cyan")
    MetriccolorMagenta -> json.string("magenta")
    MetriccolorBlue -> json.string("blue")
    MetriccolorYellow -> json.string("yellow")
    MetriccolorGreen -> json.string("green")
    MetriccolorRed -> json.string("red")
    MetriccolorBlack -> json.string("black")
  }
}

pub fn metriccolor_decoder() -> Decoder(Metriccolor) {
  use variant <- decode.then(decode.string)
  case variant {
    "white" -> decode.success(MetriccolorWhite)
    "cyan" -> decode.success(MetriccolorCyan)
    "magenta" -> decode.success(MetriccolorMagenta)
    "blue" -> decode.success(MetriccolorBlue)
    "yellow" -> decode.success(MetriccolorYellow)
    "green" -> decode.success(MetriccolorGreen)
    "red" -> decode.success(MetriccolorRed)
    "black" -> decode.success(MetriccolorBlack)
    _ -> decode.failure(MetriccolorWhite, "Metriccolor")
  }
}

pub type Referencehandlingpolicy {
  ReferencehandlingpolicyLocal
  ReferencehandlingpolicyEnforced
  ReferencehandlingpolicyResolves
  ReferencehandlingpolicyLogical
  ReferencehandlingpolicyLiteral
}

pub fn referencehandlingpolicy_to_json(
  referencehandlingpolicy: Referencehandlingpolicy,
) -> Json {
  case referencehandlingpolicy {
    ReferencehandlingpolicyLocal -> json.string("local")
    ReferencehandlingpolicyEnforced -> json.string("enforced")
    ReferencehandlingpolicyResolves -> json.string("resolves")
    ReferencehandlingpolicyLogical -> json.string("logical")
    ReferencehandlingpolicyLiteral -> json.string("literal")
  }
}

pub fn referencehandlingpolicy_decoder() -> Decoder(Referencehandlingpolicy) {
  use variant <- decode.then(decode.string)
  case variant {
    "local" -> decode.success(ReferencehandlingpolicyLocal)
    "enforced" -> decode.success(ReferencehandlingpolicyEnforced)
    "resolves" -> decode.success(ReferencehandlingpolicyResolves)
    "logical" -> decode.success(ReferencehandlingpolicyLogical)
    "literal" -> decode.success(ReferencehandlingpolicyLiteral)
    _ -> decode.failure(ReferencehandlingpolicyLocal, "Referencehandlingpolicy")
  }
}

pub type Supplyrequeststatus {
  SupplyrequeststatusUnknown
  SupplyrequeststatusEnteredinerror
  SupplyrequeststatusCompleted
  SupplyrequeststatusCancelled
  SupplyrequeststatusSuspended
  SupplyrequeststatusActive
  SupplyrequeststatusDraft
}

pub fn supplyrequeststatus_to_json(
  supplyrequeststatus: Supplyrequeststatus,
) -> Json {
  case supplyrequeststatus {
    SupplyrequeststatusUnknown -> json.string("unknown")
    SupplyrequeststatusEnteredinerror -> json.string("entered-in-error")
    SupplyrequeststatusCompleted -> json.string("completed")
    SupplyrequeststatusCancelled -> json.string("cancelled")
    SupplyrequeststatusSuspended -> json.string("suspended")
    SupplyrequeststatusActive -> json.string("active")
    SupplyrequeststatusDraft -> json.string("draft")
  }
}

pub fn supplyrequeststatus_decoder() -> Decoder(Supplyrequeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(SupplyrequeststatusUnknown)
    "entered-in-error" -> decode.success(SupplyrequeststatusEnteredinerror)
    "completed" -> decode.success(SupplyrequeststatusCompleted)
    "cancelled" -> decode.success(SupplyrequeststatusCancelled)
    "suspended" -> decode.success(SupplyrequeststatusSuspended)
    "active" -> decode.success(SupplyrequeststatusActive)
    "draft" -> decode.success(SupplyrequeststatusDraft)
    _ -> decode.failure(SupplyrequeststatusUnknown, "Supplyrequeststatus")
  }
}

pub type Qualitytype {
  QualitytypeUnknown
  QualitytypeSnp
  QualitytypeIndel
}

pub fn qualitytype_to_json(qualitytype: Qualitytype) -> Json {
  case qualitytype {
    QualitytypeUnknown -> json.string("unknown")
    QualitytypeSnp -> json.string("snp")
    QualitytypeIndel -> json.string("indel")
  }
}

pub fn qualitytype_decoder() -> Decoder(Qualitytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(QualitytypeUnknown)
    "snp" -> decode.success(QualitytypeSnp)
    "indel" -> decode.success(QualitytypeIndel)
    _ -> decode.failure(QualitytypeUnknown, "Qualitytype")
  }
}

pub type Measurereporttype {
  MeasurereporttypeDatacollection
  MeasurereporttypeSummary
  MeasurereporttypeSubjectlist
  MeasurereporttypeIndividual
}

pub fn measurereporttype_to_json(measurereporttype: Measurereporttype) -> Json {
  case measurereporttype {
    MeasurereporttypeDatacollection -> json.string("data-collection")
    MeasurereporttypeSummary -> json.string("summary")
    MeasurereporttypeSubjectlist -> json.string("subject-list")
    MeasurereporttypeIndividual -> json.string("individual")
  }
}

pub fn measurereporttype_decoder() -> Decoder(Measurereporttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "data-collection" -> decode.success(MeasurereporttypeDatacollection)
    "summary" -> decode.success(MeasurereporttypeSummary)
    "subject-list" -> decode.success(MeasurereporttypeSubjectlist)
    "individual" -> decode.success(MeasurereporttypeIndividual)
    _ -> decode.failure(MeasurereporttypeDatacollection, "Measurereporttype")
  }
}

pub type Publicationstatus {
  PublicationstatusUnknown
  PublicationstatusRetired
  PublicationstatusActive
  PublicationstatusDraft
}

pub fn publicationstatus_to_json(publicationstatus: Publicationstatus) -> Json {
  case publicationstatus {
    PublicationstatusUnknown -> json.string("unknown")
    PublicationstatusRetired -> json.string("retired")
    PublicationstatusActive -> json.string("active")
    PublicationstatusDraft -> json.string("draft")
  }
}

pub fn publicationstatus_decoder() -> Decoder(Publicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(PublicationstatusUnknown)
    "retired" -> decode.success(PublicationstatusRetired)
    "active" -> decode.success(PublicationstatusActive)
    "draft" -> decode.success(PublicationstatusDraft)
    _ -> decode.failure(PublicationstatusUnknown, "Publicationstatus")
  }
}

pub type Medicationdispensestatus {
  MedicationdispensestatusUnknown
  MedicationdispensestatusDeclined
  MedicationdispensestatusStopped
  MedicationdispensestatusEnteredinerror
  MedicationdispensestatusCompleted
  MedicationdispensestatusOnhold
  MedicationdispensestatusCancelled
  MedicationdispensestatusInprogress
  MedicationdispensestatusPreparation
}

pub fn medicationdispensestatus_to_json(
  medicationdispensestatus: Medicationdispensestatus,
) -> Json {
  case medicationdispensestatus {
    MedicationdispensestatusUnknown -> json.string("unknown")
    MedicationdispensestatusDeclined -> json.string("declined")
    MedicationdispensestatusStopped -> json.string("stopped")
    MedicationdispensestatusEnteredinerror -> json.string("entered-in-error")
    MedicationdispensestatusCompleted -> json.string("completed")
    MedicationdispensestatusOnhold -> json.string("on-hold")
    MedicationdispensestatusCancelled -> json.string("cancelled")
    MedicationdispensestatusInprogress -> json.string("in-progress")
    MedicationdispensestatusPreparation -> json.string("preparation")
  }
}

pub fn medicationdispensestatus_decoder() -> Decoder(Medicationdispensestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(MedicationdispensestatusUnknown)
    "declined" -> decode.success(MedicationdispensestatusDeclined)
    "stopped" -> decode.success(MedicationdispensestatusStopped)
    "entered-in-error" -> decode.success(MedicationdispensestatusEnteredinerror)
    "completed" -> decode.success(MedicationdispensestatusCompleted)
    "on-hold" -> decode.success(MedicationdispensestatusOnhold)
    "cancelled" -> decode.success(MedicationdispensestatusCancelled)
    "in-progress" -> decode.success(MedicationdispensestatusInprogress)
    "preparation" -> decode.success(MedicationdispensestatusPreparation)
    _ ->
      decode.failure(
        MedicationdispensestatusUnknown,
        "Medicationdispensestatus",
      )
  }
}

pub type Searchentrymode {
  SearchentrymodeOutcome
  SearchentrymodeInclude
  SearchentrymodeMatch
}

pub fn searchentrymode_to_json(searchentrymode: Searchentrymode) -> Json {
  case searchentrymode {
    SearchentrymodeOutcome -> json.string("outcome")
    SearchentrymodeInclude -> json.string("include")
    SearchentrymodeMatch -> json.string("match")
  }
}

pub fn searchentrymode_decoder() -> Decoder(Searchentrymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "outcome" -> decode.success(SearchentrymodeOutcome)
    "include" -> decode.success(SearchentrymodeInclude)
    "match" -> decode.success(SearchentrymodeMatch)
    _ -> decode.failure(SearchentrymodeOutcome, "Searchentrymode")
  }
}

pub type Requeststatus {
  RequeststatusUnknown
  RequeststatusEnteredinerror
  RequeststatusCompleted
  RequeststatusRevoked
  RequeststatusOnhold
  RequeststatusActive
  RequeststatusDraft
}

pub fn requeststatus_to_json(requeststatus: Requeststatus) -> Json {
  case requeststatus {
    RequeststatusUnknown -> json.string("unknown")
    RequeststatusEnteredinerror -> json.string("entered-in-error")
    RequeststatusCompleted -> json.string("completed")
    RequeststatusRevoked -> json.string("revoked")
    RequeststatusOnhold -> json.string("on-hold")
    RequeststatusActive -> json.string("active")
    RequeststatusDraft -> json.string("draft")
  }
}

pub fn requeststatus_decoder() -> Decoder(Requeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(RequeststatusUnknown)
    "entered-in-error" -> decode.success(RequeststatusEnteredinerror)
    "completed" -> decode.success(RequeststatusCompleted)
    "revoked" -> decode.success(RequeststatusRevoked)
    "on-hold" -> decode.success(RequeststatusOnhold)
    "active" -> decode.success(RequeststatusActive)
    "draft" -> decode.success(RequeststatusDraft)
    _ -> decode.failure(RequeststatusUnknown, "Requeststatus")
  }
}

pub type Observationrangecategory {
  ObservationrangecategoryAbsolute
  ObservationrangecategoryCritical
  ObservationrangecategoryReference
}

pub fn observationrangecategory_to_json(
  observationrangecategory: Observationrangecategory,
) -> Json {
  case observationrangecategory {
    ObservationrangecategoryAbsolute -> json.string("absolute")
    ObservationrangecategoryCritical -> json.string("critical")
    ObservationrangecategoryReference -> json.string("reference")
  }
}

pub fn observationrangecategory_decoder() -> Decoder(Observationrangecategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "absolute" -> decode.success(ObservationrangecategoryAbsolute)
    "critical" -> decode.success(ObservationrangecategoryCritical)
    "reference" -> decode.success(ObservationrangecategoryReference)
    _ ->
      decode.failure(
        ObservationrangecategoryAbsolute,
        "Observationrangecategory",
      )
  }
}

pub type Productstoragescale {
  ProductstoragescaleKelvin
  ProductstoragescaleCelsius
  ProductstoragescaleFarenheit
}

pub fn productstoragescale_to_json(
  productstoragescale: Productstoragescale,
) -> Json {
  case productstoragescale {
    ProductstoragescaleKelvin -> json.string("kelvin")
    ProductstoragescaleCelsius -> json.string("celsius")
    ProductstoragescaleFarenheit -> json.string("farenheit")
  }
}

pub fn productstoragescale_decoder() -> Decoder(Productstoragescale) {
  use variant <- decode.then(decode.string)
  case variant {
    "kelvin" -> decode.success(ProductstoragescaleKelvin)
    "celsius" -> decode.success(ProductstoragescaleCelsius)
    "farenheit" -> decode.success(ProductstoragescaleFarenheit)
    _ -> decode.failure(ProductstoragescaleKelvin, "Productstoragescale")
  }
}

pub type Metriccategory {
  MetriccategoryUnspecified
  MetriccategoryCalculation
  MetriccategorySetting
  MetriccategoryMeasurement
}

pub fn metriccategory_to_json(metriccategory: Metriccategory) -> Json {
  case metriccategory {
    MetriccategoryUnspecified -> json.string("unspecified")
    MetriccategoryCalculation -> json.string("calculation")
    MetriccategorySetting -> json.string("setting")
    MetriccategoryMeasurement -> json.string("measurement")
  }
}

pub fn metriccategory_decoder() -> Decoder(Metriccategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "unspecified" -> decode.success(MetriccategoryUnspecified)
    "calculation" -> decode.success(MetriccategoryCalculation)
    "setting" -> decode.success(MetriccategorySetting)
    "measurement" -> decode.success(MetriccategoryMeasurement)
    _ -> decode.failure(MetriccategoryUnspecified, "Metriccategory")
  }
}

pub type Codesearchsupport {
  CodesearchsupportAll
  CodesearchsupportExplicit
}

pub fn codesearchsupport_to_json(codesearchsupport: Codesearchsupport) -> Json {
  case codesearchsupport {
    CodesearchsupportAll -> json.string("all")
    CodesearchsupportExplicit -> json.string("explicit")
  }
}

pub fn codesearchsupport_decoder() -> Decoder(Codesearchsupport) {
  use variant <- decode.then(decode.string)
  case variant {
    "all" -> decode.success(CodesearchsupportAll)
    "explicit" -> decode.success(CodesearchsupportExplicit)
    _ -> decode.failure(CodesearchsupportAll, "Codesearchsupport")
  }
}

pub type Addressuse {
  AddressuseBilling
  AddressuseOld
  AddressuseTemp
  AddressuseWork
  AddressuseHome
}

pub fn addressuse_to_json(addressuse: Addressuse) -> Json {
  case addressuse {
    AddressuseBilling -> json.string("billing")
    AddressuseOld -> json.string("old")
    AddressuseTemp -> json.string("temp")
    AddressuseWork -> json.string("work")
    AddressuseHome -> json.string("home")
  }
}

pub fn addressuse_decoder() -> Decoder(Addressuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "billing" -> decode.success(AddressuseBilling)
    "old" -> decode.success(AddressuseOld)
    "temp" -> decode.success(AddressuseTemp)
    "work" -> decode.success(AddressuseWork)
    "home" -> decode.success(AddressuseHome)
    _ -> decode.failure(AddressuseBilling, "Addressuse")
  }
}

pub type Listmode {
  ListmodeChanges
  ListmodeSnapshot
  ListmodeWorking
}

pub fn listmode_to_json(listmode: Listmode) -> Json {
  case listmode {
    ListmodeChanges -> json.string("changes")
    ListmodeSnapshot -> json.string("snapshot")
    ListmodeWorking -> json.string("working")
  }
}

pub fn listmode_decoder() -> Decoder(Listmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "changes" -> decode.success(ListmodeChanges)
    "snapshot" -> decode.success(ListmodeSnapshot)
    "working" -> decode.success(ListmodeWorking)
    _ -> decode.failure(ListmodeChanges, "Listmode")
  }
}

pub type Eligibilityrequestpurpose {
  EligibilityrequestpurposeValidation
  EligibilityrequestpurposeDiscovery
  EligibilityrequestpurposeBenefits
  EligibilityrequestpurposeAuthrequirements
}

pub fn eligibilityrequestpurpose_to_json(
  eligibilityrequestpurpose: Eligibilityrequestpurpose,
) -> Json {
  case eligibilityrequestpurpose {
    EligibilityrequestpurposeValidation -> json.string("validation")
    EligibilityrequestpurposeDiscovery -> json.string("discovery")
    EligibilityrequestpurposeBenefits -> json.string("benefits")
    EligibilityrequestpurposeAuthrequirements ->
      json.string("auth-requirements")
  }
}

pub fn eligibilityrequestpurpose_decoder() -> Decoder(Eligibilityrequestpurpose) {
  use variant <- decode.then(decode.string)
  case variant {
    "validation" -> decode.success(EligibilityrequestpurposeValidation)
    "discovery" -> decode.success(EligibilityrequestpurposeDiscovery)
    "benefits" -> decode.success(EligibilityrequestpurposeBenefits)
    "auth-requirements" ->
      decode.success(EligibilityrequestpurposeAuthrequirements)
    _ ->
      decode.failure(
        EligibilityrequestpurposeValidation,
        "Eligibilityrequestpurpose",
      )
  }
}

pub type Endpointstatus {
  EndpointstatusTest
  EndpointstatusEnteredinerror
  EndpointstatusOff
  EndpointstatusError
  EndpointstatusSuspended
  EndpointstatusActive
}

pub fn endpointstatus_to_json(endpointstatus: Endpointstatus) -> Json {
  case endpointstatus {
    EndpointstatusTest -> json.string("test")
    EndpointstatusEnteredinerror -> json.string("entered-in-error")
    EndpointstatusOff -> json.string("off")
    EndpointstatusError -> json.string("error")
    EndpointstatusSuspended -> json.string("suspended")
    EndpointstatusActive -> json.string("active")
  }
}

pub fn endpointstatus_decoder() -> Decoder(Endpointstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "test" -> decode.success(EndpointstatusTest)
    "entered-in-error" -> decode.success(EndpointstatusEnteredinerror)
    "off" -> decode.success(EndpointstatusOff)
    "error" -> decode.success(EndpointstatusError)
    "suspended" -> decode.success(EndpointstatusSuspended)
    "active" -> decode.success(EndpointstatusActive)
    _ -> decode.failure(EndpointstatusTest, "Endpointstatus")
  }
}

pub type Explanationofbenefitstatus {
  ExplanationofbenefitstatusEnteredinerror
  ExplanationofbenefitstatusDraft
  ExplanationofbenefitstatusCancelled
  ExplanationofbenefitstatusActive
}

pub fn explanationofbenefitstatus_to_json(
  explanationofbenefitstatus: Explanationofbenefitstatus,
) -> Json {
  case explanationofbenefitstatus {
    ExplanationofbenefitstatusEnteredinerror -> json.string("entered-in-error")
    ExplanationofbenefitstatusDraft -> json.string("draft")
    ExplanationofbenefitstatusCancelled -> json.string("cancelled")
    ExplanationofbenefitstatusActive -> json.string("active")
  }
}

pub fn explanationofbenefitstatus_decoder() -> Decoder(
  Explanationofbenefitstatus,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" ->
      decode.success(ExplanationofbenefitstatusEnteredinerror)
    "draft" -> decode.success(ExplanationofbenefitstatusDraft)
    "cancelled" -> decode.success(ExplanationofbenefitstatusCancelled)
    "active" -> decode.success(ExplanationofbenefitstatusActive)
    _ ->
      decode.failure(
        ExplanationofbenefitstatusEnteredinerror,
        "Explanationofbenefitstatus",
      )
  }
}

pub type Medicationrequestintent {
  MedicationrequestintentOption
  MedicationrequestintentInstanceorder
  MedicationrequestintentFillerorder
  MedicationrequestintentReflexorder
  MedicationrequestintentOriginalorder
  MedicationrequestintentOrder
  MedicationrequestintentPlan
  MedicationrequestintentProposal
}

pub fn medicationrequestintent_to_json(
  medicationrequestintent: Medicationrequestintent,
) -> Json {
  case medicationrequestintent {
    MedicationrequestintentOption -> json.string("option")
    MedicationrequestintentInstanceorder -> json.string("instance-order")
    MedicationrequestintentFillerorder -> json.string("filler-order")
    MedicationrequestintentReflexorder -> json.string("reflex-order")
    MedicationrequestintentOriginalorder -> json.string("original-order")
    MedicationrequestintentOrder -> json.string("order")
    MedicationrequestintentPlan -> json.string("plan")
    MedicationrequestintentProposal -> json.string("proposal")
  }
}

pub fn medicationrequestintent_decoder() -> Decoder(Medicationrequestintent) {
  use variant <- decode.then(decode.string)
  case variant {
    "option" -> decode.success(MedicationrequestintentOption)
    "instance-order" -> decode.success(MedicationrequestintentInstanceorder)
    "filler-order" -> decode.success(MedicationrequestintentFillerorder)
    "reflex-order" -> decode.success(MedicationrequestintentReflexorder)
    "original-order" -> decode.success(MedicationrequestintentOriginalorder)
    "order" -> decode.success(MedicationrequestintentOrder)
    "plan" -> decode.success(MedicationrequestintentPlan)
    "proposal" -> decode.success(MedicationrequestintentProposal)
    _ ->
      decode.failure(MedicationrequestintentOption, "Medicationrequestintent")
  }
}

pub type Actiongroupingbehavior {
  ActiongroupingbehaviorSentencegroup
  ActiongroupingbehaviorLogicalgroup
  ActiongroupingbehaviorVisualgroup
}

pub fn actiongroupingbehavior_to_json(
  actiongroupingbehavior: Actiongroupingbehavior,
) -> Json {
  case actiongroupingbehavior {
    ActiongroupingbehaviorSentencegroup -> json.string("sentence-group")
    ActiongroupingbehaviorLogicalgroup -> json.string("logical-group")
    ActiongroupingbehaviorVisualgroup -> json.string("visual-group")
  }
}

pub fn actiongroupingbehavior_decoder() -> Decoder(Actiongroupingbehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "sentence-group" -> decode.success(ActiongroupingbehaviorSentencegroup)
    "logical-group" -> decode.success(ActiongroupingbehaviorLogicalgroup)
    "visual-group" -> decode.success(ActiongroupingbehaviorVisualgroup)
    _ ->
      decode.failure(
        ActiongroupingbehaviorSentencegroup,
        "Actiongroupingbehavior",
      )
  }
}

pub type Graphcompartmentuse {
  GraphcompartmentuseRequirement
  GraphcompartmentuseCondition
}

pub fn graphcompartmentuse_to_json(
  graphcompartmentuse: Graphcompartmentuse,
) -> Json {
  case graphcompartmentuse {
    GraphcompartmentuseRequirement -> json.string("requirement")
    GraphcompartmentuseCondition -> json.string("condition")
  }
}

pub fn graphcompartmentuse_decoder() -> Decoder(Graphcompartmentuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "requirement" -> decode.success(GraphcompartmentuseRequirement)
    "condition" -> decode.success(GraphcompartmentuseCondition)
    _ -> decode.failure(GraphcompartmentuseRequirement, "Graphcompartmentuse")
  }
}

pub type Mapinputmode {
  MapinputmodeTarget
  MapinputmodeSource
}

pub fn mapinputmode_to_json(mapinputmode: Mapinputmode) -> Json {
  case mapinputmode {
    MapinputmodeTarget -> json.string("target")
    MapinputmodeSource -> json.string("source")
  }
}

pub fn mapinputmode_decoder() -> Decoder(Mapinputmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "target" -> decode.success(MapinputmodeTarget)
    "source" -> decode.success(MapinputmodeSource)
    _ -> decode.failure(MapinputmodeTarget, "Mapinputmode")
  }
}

pub type Contractstatus {
  ContractstatusTerminated
  ContractstatusResolved
  ContractstatusRevoked
  ContractstatusRenewed
  ContractstatusRejected
  ContractstatusPolicy
  ContractstatusOffered
  ContractstatusNegotiable
  ContractstatusExecuted
  ContractstatusExecutable
  ContractstatusEnteredinerror
  ContractstatusDisputed
  ContractstatusCancelled
  ContractstatusAppended
  ContractstatusAmended
}

pub fn contractstatus_to_json(contractstatus: Contractstatus) -> Json {
  case contractstatus {
    ContractstatusTerminated -> json.string("terminated")
    ContractstatusResolved -> json.string("resolved")
    ContractstatusRevoked -> json.string("revoked")
    ContractstatusRenewed -> json.string("renewed")
    ContractstatusRejected -> json.string("rejected")
    ContractstatusPolicy -> json.string("policy")
    ContractstatusOffered -> json.string("offered")
    ContractstatusNegotiable -> json.string("negotiable")
    ContractstatusExecuted -> json.string("executed")
    ContractstatusExecutable -> json.string("executable")
    ContractstatusEnteredinerror -> json.string("entered-in-error")
    ContractstatusDisputed -> json.string("disputed")
    ContractstatusCancelled -> json.string("cancelled")
    ContractstatusAppended -> json.string("appended")
    ContractstatusAmended -> json.string("amended")
  }
}

pub fn contractstatus_decoder() -> Decoder(Contractstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "terminated" -> decode.success(ContractstatusTerminated)
    "resolved" -> decode.success(ContractstatusResolved)
    "revoked" -> decode.success(ContractstatusRevoked)
    "renewed" -> decode.success(ContractstatusRenewed)
    "rejected" -> decode.success(ContractstatusRejected)
    "policy" -> decode.success(ContractstatusPolicy)
    "offered" -> decode.success(ContractstatusOffered)
    "negotiable" -> decode.success(ContractstatusNegotiable)
    "executed" -> decode.success(ContractstatusExecuted)
    "executable" -> decode.success(ContractstatusExecutable)
    "entered-in-error" -> decode.success(ContractstatusEnteredinerror)
    "disputed" -> decode.success(ContractstatusDisputed)
    "cancelled" -> decode.success(ContractstatusCancelled)
    "appended" -> decode.success(ContractstatusAppended)
    "amended" -> decode.success(ContractstatusAmended)
    _ -> decode.failure(ContractstatusTerminated, "Contractstatus")
  }
}

pub type Researchelementtype {
  ResearchelementtypeOutcome
  ResearchelementtypeExposure
  ResearchelementtypePopulation
}

pub fn researchelementtype_to_json(
  researchelementtype: Researchelementtype,
) -> Json {
  case researchelementtype {
    ResearchelementtypeOutcome -> json.string("outcome")
    ResearchelementtypeExposure -> json.string("exposure")
    ResearchelementtypePopulation -> json.string("population")
  }
}

pub fn researchelementtype_decoder() -> Decoder(Researchelementtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "outcome" -> decode.success(ResearchelementtypeOutcome)
    "exposure" -> decode.success(ResearchelementtypeExposure)
    "population" -> decode.success(ResearchelementtypePopulation)
    _ -> decode.failure(ResearchelementtypeOutcome, "Researchelementtype")
  }
}

pub type Actioncardinalitybehavior {
  ActioncardinalitybehaviorMultiple
  ActioncardinalitybehaviorSingle
}

pub fn actioncardinalitybehavior_to_json(
  actioncardinalitybehavior: Actioncardinalitybehavior,
) -> Json {
  case actioncardinalitybehavior {
    ActioncardinalitybehaviorMultiple -> json.string("multiple")
    ActioncardinalitybehaviorSingle -> json.string("single")
  }
}

pub fn actioncardinalitybehavior_decoder() -> Decoder(Actioncardinalitybehavior) {
  use variant <- decode.then(decode.string)
  case variant {
    "multiple" -> decode.success(ActioncardinalitybehaviorMultiple)
    "single" -> decode.success(ActioncardinalitybehaviorSingle)
    _ ->
      decode.failure(
        ActioncardinalitybehaviorMultiple,
        "Actioncardinalitybehavior",
      )
  }
}

pub type Researchsubjectstatus {
  ResearchsubjectstatusWithdrawn
  ResearchsubjectstatusScreening
  ResearchsubjectstatusPotentialcandidate
  ResearchsubjectstatusPendingonstudy
  ResearchsubjectstatusOnstudyobservation
  ResearchsubjectstatusOnstudyintervention
  ResearchsubjectstatusOnstudy
  ResearchsubjectstatusOffstudy
  ResearchsubjectstatusNotregistered
  ResearchsubjectstatusIneligible
  ResearchsubjectstatusFollowup
  ResearchsubjectstatusEligible
  ResearchsubjectstatusCandidate
}

pub fn researchsubjectstatus_to_json(
  researchsubjectstatus: Researchsubjectstatus,
) -> Json {
  case researchsubjectstatus {
    ResearchsubjectstatusWithdrawn -> json.string("withdrawn")
    ResearchsubjectstatusScreening -> json.string("screening")
    ResearchsubjectstatusPotentialcandidate ->
      json.string("potential-candidate")
    ResearchsubjectstatusPendingonstudy -> json.string("pending-on-study")
    ResearchsubjectstatusOnstudyobservation ->
      json.string("on-study-observation")
    ResearchsubjectstatusOnstudyintervention ->
      json.string("on-study-intervention")
    ResearchsubjectstatusOnstudy -> json.string("on-study")
    ResearchsubjectstatusOffstudy -> json.string("off-study")
    ResearchsubjectstatusNotregistered -> json.string("not-registered")
    ResearchsubjectstatusIneligible -> json.string("ineligible")
    ResearchsubjectstatusFollowup -> json.string("follow-up")
    ResearchsubjectstatusEligible -> json.string("eligible")
    ResearchsubjectstatusCandidate -> json.string("candidate")
  }
}

pub fn researchsubjectstatus_decoder() -> Decoder(Researchsubjectstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "withdrawn" -> decode.success(ResearchsubjectstatusWithdrawn)
    "screening" -> decode.success(ResearchsubjectstatusScreening)
    "potential-candidate" ->
      decode.success(ResearchsubjectstatusPotentialcandidate)
    "pending-on-study" -> decode.success(ResearchsubjectstatusPendingonstudy)
    "on-study-observation" ->
      decode.success(ResearchsubjectstatusOnstudyobservation)
    "on-study-intervention" ->
      decode.success(ResearchsubjectstatusOnstudyintervention)
    "on-study" -> decode.success(ResearchsubjectstatusOnstudy)
    "off-study" -> decode.success(ResearchsubjectstatusOffstudy)
    "not-registered" -> decode.success(ResearchsubjectstatusNotregistered)
    "ineligible" -> decode.success(ResearchsubjectstatusIneligible)
    "follow-up" -> decode.success(ResearchsubjectstatusFollowup)
    "eligible" -> decode.success(ResearchsubjectstatusEligible)
    "candidate" -> decode.success(ResearchsubjectstatusCandidate)
    _ -> decode.failure(ResearchsubjectstatusWithdrawn, "Researchsubjectstatus")
  }
}

pub type Conditionalreadstatus {
  ConditionalreadstatusFullsupport
  ConditionalreadstatusNotmatch
  ConditionalreadstatusModifiedsince
  ConditionalreadstatusNotsupported
}

pub fn conditionalreadstatus_to_json(
  conditionalreadstatus: Conditionalreadstatus,
) -> Json {
  case conditionalreadstatus {
    ConditionalreadstatusFullsupport -> json.string("full-support")
    ConditionalreadstatusNotmatch -> json.string("not-match")
    ConditionalreadstatusModifiedsince -> json.string("modified-since")
    ConditionalreadstatusNotsupported -> json.string("not-supported")
  }
}

pub fn conditionalreadstatus_decoder() -> Decoder(Conditionalreadstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "full-support" -> decode.success(ConditionalreadstatusFullsupport)
    "not-match" -> decode.success(ConditionalreadstatusNotmatch)
    "modified-since" -> decode.success(ConditionalreadstatusModifiedsince)
    "not-supported" -> decode.success(ConditionalreadstatusNotsupported)
    _ ->
      decode.failure(ConditionalreadstatusFullsupport, "Conditionalreadstatus")
  }
}

pub type Medicationrequeststatus {
  MedicationrequeststatusUnknown
  MedicationrequeststatusDraft
  MedicationrequeststatusStopped
  MedicationrequeststatusEnteredinerror
  MedicationrequeststatusCompleted
  MedicationrequeststatusCancelled
  MedicationrequeststatusOnhold
  MedicationrequeststatusActive
}

pub fn medicationrequeststatus_to_json(
  medicationrequeststatus: Medicationrequeststatus,
) -> Json {
  case medicationrequeststatus {
    MedicationrequeststatusUnknown -> json.string("unknown")
    MedicationrequeststatusDraft -> json.string("draft")
    MedicationrequeststatusStopped -> json.string("stopped")
    MedicationrequeststatusEnteredinerror -> json.string("entered-in-error")
    MedicationrequeststatusCompleted -> json.string("completed")
    MedicationrequeststatusCancelled -> json.string("cancelled")
    MedicationrequeststatusOnhold -> json.string("on-hold")
    MedicationrequeststatusActive -> json.string("active")
  }
}

pub fn medicationrequeststatus_decoder() -> Decoder(Medicationrequeststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(MedicationrequeststatusUnknown)
    "draft" -> decode.success(MedicationrequeststatusDraft)
    "stopped" -> decode.success(MedicationrequeststatusStopped)
    "entered-in-error" -> decode.success(MedicationrequeststatusEnteredinerror)
    "completed" -> decode.success(MedicationrequeststatusCompleted)
    "cancelled" -> decode.success(MedicationrequeststatusCancelled)
    "on-hold" -> decode.success(MedicationrequeststatusOnhold)
    "active" -> decode.success(MedicationrequeststatusActive)
    _ ->
      decode.failure(MedicationrequeststatusUnknown, "Medicationrequeststatus")
  }
}

pub type Diagnosticreportstatus {
  DiagnosticreportstatusUnknown
  DiagnosticreportstatusEnteredinerror
  DiagnosticreportstatusCancelled
  DiagnosticreportstatusAmended
  DiagnosticreportstatusFinal
  DiagnosticreportstatusPartial
  DiagnosticreportstatusRegistered
  DiagnosticreportstatusPreliminary
  DiagnosticreportstatusAppended
  DiagnosticreportstatusCorrected
}

pub fn diagnosticreportstatus_to_json(
  diagnosticreportstatus: Diagnosticreportstatus,
) -> Json {
  case diagnosticreportstatus {
    DiagnosticreportstatusUnknown -> json.string("unknown")
    DiagnosticreportstatusEnteredinerror -> json.string("entered-in-error")
    DiagnosticreportstatusCancelled -> json.string("cancelled")
    DiagnosticreportstatusAmended -> json.string("amended")
    DiagnosticreportstatusFinal -> json.string("final")
    DiagnosticreportstatusPartial -> json.string("partial")
    DiagnosticreportstatusRegistered -> json.string("registered")
    DiagnosticreportstatusPreliminary -> json.string("preliminary")
    DiagnosticreportstatusAppended -> json.string("appended")
    DiagnosticreportstatusCorrected -> json.string("corrected")
  }
}

pub fn diagnosticreportstatus_decoder() -> Decoder(Diagnosticreportstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(DiagnosticreportstatusUnknown)
    "entered-in-error" -> decode.success(DiagnosticreportstatusEnteredinerror)
    "cancelled" -> decode.success(DiagnosticreportstatusCancelled)
    "amended" -> decode.success(DiagnosticreportstatusAmended)
    "final" -> decode.success(DiagnosticreportstatusFinal)
    "partial" -> decode.success(DiagnosticreportstatusPartial)
    "registered" -> decode.success(DiagnosticreportstatusRegistered)
    "preliminary" -> decode.success(DiagnosticreportstatusPreliminary)
    "appended" -> decode.success(DiagnosticreportstatusAppended)
    "corrected" -> decode.success(DiagnosticreportstatusCorrected)
    _ -> decode.failure(DiagnosticreportstatusUnknown, "Diagnosticreportstatus")
  }
}

pub type Alltypes {
  AlltypesAny
  AlltypesType
  AlltypesVisionprescription
  AlltypesVerificationresult
  AlltypesValueset
  AlltypesTestscript
  AlltypesTestreport
  AlltypesTerminologycapabilities
  AlltypesTask
  AlltypesSupplyrequest
  AlltypesSupplydelivery
  AlltypesSubstancespecification
  AlltypesSubstancesourcematerial
  AlltypesSubstancereferenceinformation
  AlltypesSubstanceprotein
  AlltypesSubstancepolymer
  AlltypesSubstancenucleicacid
  AlltypesSubstance
  AlltypesSubscription
  AlltypesStructuremap
  AlltypesStructuredefinition
  AlltypesSpecimendefinition
  AlltypesSpecimen
  AlltypesSlot
  AlltypesServicerequest
  AlltypesSearchparameter
  AlltypesSchedule
  AlltypesRiskevidencesynthesis
  AlltypesRiskassessment
  AlltypesResource
  AlltypesResearchsubject
  AlltypesResearchstudy
  AlltypesResearchelementdefinition
  AlltypesResearchdefinition
  AlltypesRequestgroup
  AlltypesRelatedperson
  AlltypesQuestionnaireresponse
  AlltypesQuestionnaire
  AlltypesProvenance
  AlltypesProcedure
  AlltypesPractitionerrole
  AlltypesPractitioner
  AlltypesPlandefinition
  AlltypesPerson
  AlltypesPaymentreconciliation
  AlltypesPaymentnotice
  AlltypesPatient
  AlltypesParameters
  AlltypesOrganizationaffiliation
  AlltypesOrganization
  AlltypesOperationoutcome
  AlltypesOperationdefinition
  AlltypesObservationdefinition
  AlltypesObservation
  AlltypesNutritionorder
  AlltypesNamingsystem
  AlltypesMolecularsequence
  AlltypesMessageheader
  AlltypesMessagedefinition
  AlltypesMedicinalproductundesirableeffect
  AlltypesMedicinalproductpharmaceutical
  AlltypesMedicinalproductpackaged
  AlltypesMedicinalproductmanufactured
  AlltypesMedicinalproductinteraction
  AlltypesMedicinalproductingredient
  AlltypesMedicinalproductindication
  AlltypesMedicinalproductcontraindication
  AlltypesMedicinalproductauthorization
  AlltypesMedicinalproduct
  AlltypesMedicationstatement
  AlltypesMedicationrequest
  AlltypesMedicationknowledge
  AlltypesMedicationdispense
  AlltypesMedicationadministration
  AlltypesMedication
  AlltypesMedia
  AlltypesMeasurereport
  AlltypesMeasure
  AlltypesLocation
  AlltypesList
  AlltypesLinkage
  AlltypesLibrary
  AlltypesInvoice
  AlltypesInsuranceplan
  AlltypesImplementationguide
  AlltypesImmunizationrecommendation
  AlltypesImmunizationevaluation
  AlltypesImmunization
  AlltypesImagingstudy
  AlltypesHealthcareservice
  AlltypesGuidanceresponse
  AlltypesGroup
  AlltypesGraphdefinition
  AlltypesGoal
  AlltypesFlag
  AlltypesFamilymemberhistory
  AlltypesExplanationofbenefit
  AlltypesExamplescenario
  AlltypesEvidencevariable
  AlltypesEvidence
  AlltypesEventdefinition
  AlltypesEpisodeofcare
  AlltypesEnrollmentresponse
  AlltypesEnrollmentrequest
  AlltypesEndpoint
  AlltypesEncounter
  AlltypesEffectevidencesynthesis
  AlltypesDomainresource
  AlltypesDocumentreference
  AlltypesDocumentmanifest
  AlltypesDiagnosticreport
  AlltypesDeviceusestatement
  AlltypesDevicerequest
  AlltypesDevicemetric
  AlltypesDevicedefinition
  AlltypesDevice
  AlltypesDetectedissue
  AlltypesCoverageeligibilityresponse
  AlltypesCoverageeligibilityrequest
  AlltypesCoverage
  AlltypesContract
  AlltypesConsent
  AlltypesCondition
  AlltypesConceptmap
  AlltypesComposition
  AlltypesCompartmentdefinition
  AlltypesCommunicationrequest
  AlltypesCommunication
  AlltypesCodesystem
  AlltypesClinicalimpression
  AlltypesClaimresponse
  AlltypesClaim
  AlltypesChargeitemdefinition
  AlltypesChargeitem
  AlltypesCatalogentry
  AlltypesCareteam
  AlltypesCareplan
  AlltypesCapabilitystatement
  AlltypesBundle
  AlltypesBodystructure
  AlltypesBiologicallyderivedproduct
  AlltypesBinary
  AlltypesBasic
  AlltypesAuditevent
  AlltypesAppointmentresponse
  AlltypesAppointment
  AlltypesAllergyintolerance
  AlltypesAdverseevent
  AlltypesActivitydefinition
  AlltypesAccount
  AlltypesXhtml
  AlltypesUuid
  AlltypesUrl
  AlltypesUri
  AlltypesUnsignedint
  AlltypesTime
  AlltypesString
  AlltypesPositiveint
  AlltypesOid
  AlltypesMarkdown
  AlltypesInteger
  AlltypesInstant
  AlltypesId
  AlltypesDecimal
  AlltypesDatetime
  AlltypesDate
  AlltypesCode
  AlltypesCanonical
  AlltypesBoolean
  AlltypesBase64binary
  AlltypesUsagecontext
  AlltypesTriggerdefinition
  AlltypesTiming
  AlltypesSubstanceamount
  AlltypesSimplequantity
  AlltypesSignature
  AlltypesSampleddata
  AlltypesRelatedartifact
  AlltypesReference
  AlltypesRatio
  AlltypesRange
  AlltypesQuantity
  AlltypesProductshelflife
  AlltypesProdcharacteristic
  AlltypesPopulation
  AlltypesPeriod
  AlltypesParameterdefinition
  AlltypesNarrative
  AlltypesMoneyquantity
  AlltypesMoney
  AlltypesMeta
  AlltypesMarketingstatus
  AlltypesIdentifier
  AlltypesHumanname
  AlltypesExtension
  AlltypesExpression
  AlltypesElementdefinition
  AlltypesElement
  AlltypesDuration
  AlltypesDosage
  AlltypesDistance
  AlltypesDatarequirement
  AlltypesCount
  AlltypesContributor
  AlltypesContactpoint
  AlltypesContactdetail
  AlltypesCoding
  AlltypesCodeableconcept
  AlltypesBackboneelement
  AlltypesAttachment
  AlltypesAnnotation
  AlltypesAge
  AlltypesAddress
}

pub fn alltypes_to_json(alltypes: Alltypes) -> Json {
  case alltypes {
    AlltypesAny -> json.string("Any")
    AlltypesType -> json.string("Type")
    AlltypesVisionprescription -> json.string("VisionPrescription")
    AlltypesVerificationresult -> json.string("VerificationResult")
    AlltypesValueset -> json.string("ValueSet")
    AlltypesTestscript -> json.string("TestScript")
    AlltypesTestreport -> json.string("TestReport")
    AlltypesTerminologycapabilities -> json.string("TerminologyCapabilities")
    AlltypesTask -> json.string("Task")
    AlltypesSupplyrequest -> json.string("SupplyRequest")
    AlltypesSupplydelivery -> json.string("SupplyDelivery")
    AlltypesSubstancespecification -> json.string("SubstanceSpecification")
    AlltypesSubstancesourcematerial -> json.string("SubstanceSourceMaterial")
    AlltypesSubstancereferenceinformation ->
      json.string("SubstanceReferenceInformation")
    AlltypesSubstanceprotein -> json.string("SubstanceProtein")
    AlltypesSubstancepolymer -> json.string("SubstancePolymer")
    AlltypesSubstancenucleicacid -> json.string("SubstanceNucleicAcid")
    AlltypesSubstance -> json.string("Substance")
    AlltypesSubscription -> json.string("Subscription")
    AlltypesStructuremap -> json.string("StructureMap")
    AlltypesStructuredefinition -> json.string("StructureDefinition")
    AlltypesSpecimendefinition -> json.string("SpecimenDefinition")
    AlltypesSpecimen -> json.string("Specimen")
    AlltypesSlot -> json.string("Slot")
    AlltypesServicerequest -> json.string("ServiceRequest")
    AlltypesSearchparameter -> json.string("SearchParameter")
    AlltypesSchedule -> json.string("Schedule")
    AlltypesRiskevidencesynthesis -> json.string("RiskEvidenceSynthesis")
    AlltypesRiskassessment -> json.string("RiskAssessment")
    AlltypesResource -> json.string("Resource")
    AlltypesResearchsubject -> json.string("ResearchSubject")
    AlltypesResearchstudy -> json.string("ResearchStudy")
    AlltypesResearchelementdefinition ->
      json.string("ResearchElementDefinition")
    AlltypesResearchdefinition -> json.string("ResearchDefinition")
    AlltypesRequestgroup -> json.string("RequestGroup")
    AlltypesRelatedperson -> json.string("RelatedPerson")
    AlltypesQuestionnaireresponse -> json.string("QuestionnaireResponse")
    AlltypesQuestionnaire -> json.string("Questionnaire")
    AlltypesProvenance -> json.string("Provenance")
    AlltypesProcedure -> json.string("Procedure")
    AlltypesPractitionerrole -> json.string("PractitionerRole")
    AlltypesPractitioner -> json.string("Practitioner")
    AlltypesPlandefinition -> json.string("PlanDefinition")
    AlltypesPerson -> json.string("Person")
    AlltypesPaymentreconciliation -> json.string("PaymentReconciliation")
    AlltypesPaymentnotice -> json.string("PaymentNotice")
    AlltypesPatient -> json.string("Patient")
    AlltypesParameters -> json.string("Parameters")
    AlltypesOrganizationaffiliation -> json.string("OrganizationAffiliation")
    AlltypesOrganization -> json.string("Organization")
    AlltypesOperationoutcome -> json.string("OperationOutcome")
    AlltypesOperationdefinition -> json.string("OperationDefinition")
    AlltypesObservationdefinition -> json.string("ObservationDefinition")
    AlltypesObservation -> json.string("Observation")
    AlltypesNutritionorder -> json.string("NutritionOrder")
    AlltypesNamingsystem -> json.string("NamingSystem")
    AlltypesMolecularsequence -> json.string("MolecularSequence")
    AlltypesMessageheader -> json.string("MessageHeader")
    AlltypesMessagedefinition -> json.string("MessageDefinition")
    AlltypesMedicinalproductundesirableeffect ->
      json.string("MedicinalProductUndesirableEffect")
    AlltypesMedicinalproductpharmaceutical ->
      json.string("MedicinalProductPharmaceutical")
    AlltypesMedicinalproductpackaged -> json.string("MedicinalProductPackaged")
    AlltypesMedicinalproductmanufactured ->
      json.string("MedicinalProductManufactured")
    AlltypesMedicinalproductinteraction ->
      json.string("MedicinalProductInteraction")
    AlltypesMedicinalproductingredient ->
      json.string("MedicinalProductIngredient")
    AlltypesMedicinalproductindication ->
      json.string("MedicinalProductIndication")
    AlltypesMedicinalproductcontraindication ->
      json.string("MedicinalProductContraindication")
    AlltypesMedicinalproductauthorization ->
      json.string("MedicinalProductAuthorization")
    AlltypesMedicinalproduct -> json.string("MedicinalProduct")
    AlltypesMedicationstatement -> json.string("MedicationStatement")
    AlltypesMedicationrequest -> json.string("MedicationRequest")
    AlltypesMedicationknowledge -> json.string("MedicationKnowledge")
    AlltypesMedicationdispense -> json.string("MedicationDispense")
    AlltypesMedicationadministration -> json.string("MedicationAdministration")
    AlltypesMedication -> json.string("Medication")
    AlltypesMedia -> json.string("Media")
    AlltypesMeasurereport -> json.string("MeasureReport")
    AlltypesMeasure -> json.string("Measure")
    AlltypesLocation -> json.string("Location")
    AlltypesList -> json.string("List")
    AlltypesLinkage -> json.string("Linkage")
    AlltypesLibrary -> json.string("Library")
    AlltypesInvoice -> json.string("Invoice")
    AlltypesInsuranceplan -> json.string("InsurancePlan")
    AlltypesImplementationguide -> json.string("ImplementationGuide")
    AlltypesImmunizationrecommendation ->
      json.string("ImmunizationRecommendation")
    AlltypesImmunizationevaluation -> json.string("ImmunizationEvaluation")
    AlltypesImmunization -> json.string("Immunization")
    AlltypesImagingstudy -> json.string("ImagingStudy")
    AlltypesHealthcareservice -> json.string("HealthcareService")
    AlltypesGuidanceresponse -> json.string("GuidanceResponse")
    AlltypesGroup -> json.string("Group")
    AlltypesGraphdefinition -> json.string("GraphDefinition")
    AlltypesGoal -> json.string("Goal")
    AlltypesFlag -> json.string("Flag")
    AlltypesFamilymemberhistory -> json.string("FamilyMemberHistory")
    AlltypesExplanationofbenefit -> json.string("ExplanationOfBenefit")
    AlltypesExamplescenario -> json.string("ExampleScenario")
    AlltypesEvidencevariable -> json.string("EvidenceVariable")
    AlltypesEvidence -> json.string("Evidence")
    AlltypesEventdefinition -> json.string("EventDefinition")
    AlltypesEpisodeofcare -> json.string("EpisodeOfCare")
    AlltypesEnrollmentresponse -> json.string("EnrollmentResponse")
    AlltypesEnrollmentrequest -> json.string("EnrollmentRequest")
    AlltypesEndpoint -> json.string("Endpoint")
    AlltypesEncounter -> json.string("Encounter")
    AlltypesEffectevidencesynthesis -> json.string("EffectEvidenceSynthesis")
    AlltypesDomainresource -> json.string("DomainResource")
    AlltypesDocumentreference -> json.string("DocumentReference")
    AlltypesDocumentmanifest -> json.string("DocumentManifest")
    AlltypesDiagnosticreport -> json.string("DiagnosticReport")
    AlltypesDeviceusestatement -> json.string("DeviceUseStatement")
    AlltypesDevicerequest -> json.string("DeviceRequest")
    AlltypesDevicemetric -> json.string("DeviceMetric")
    AlltypesDevicedefinition -> json.string("DeviceDefinition")
    AlltypesDevice -> json.string("Device")
    AlltypesDetectedissue -> json.string("DetectedIssue")
    AlltypesCoverageeligibilityresponse ->
      json.string("CoverageEligibilityResponse")
    AlltypesCoverageeligibilityrequest ->
      json.string("CoverageEligibilityRequest")
    AlltypesCoverage -> json.string("Coverage")
    AlltypesContract -> json.string("Contract")
    AlltypesConsent -> json.string("Consent")
    AlltypesCondition -> json.string("Condition")
    AlltypesConceptmap -> json.string("ConceptMap")
    AlltypesComposition -> json.string("Composition")
    AlltypesCompartmentdefinition -> json.string("CompartmentDefinition")
    AlltypesCommunicationrequest -> json.string("CommunicationRequest")
    AlltypesCommunication -> json.string("Communication")
    AlltypesCodesystem -> json.string("CodeSystem")
    AlltypesClinicalimpression -> json.string("ClinicalImpression")
    AlltypesClaimresponse -> json.string("ClaimResponse")
    AlltypesClaim -> json.string("Claim")
    AlltypesChargeitemdefinition -> json.string("ChargeItemDefinition")
    AlltypesChargeitem -> json.string("ChargeItem")
    AlltypesCatalogentry -> json.string("CatalogEntry")
    AlltypesCareteam -> json.string("CareTeam")
    AlltypesCareplan -> json.string("CarePlan")
    AlltypesCapabilitystatement -> json.string("CapabilityStatement")
    AlltypesBundle -> json.string("Bundle")
    AlltypesBodystructure -> json.string("BodyStructure")
    AlltypesBiologicallyderivedproduct ->
      json.string("BiologicallyDerivedProduct")
    AlltypesBinary -> json.string("Binary")
    AlltypesBasic -> json.string("Basic")
    AlltypesAuditevent -> json.string("AuditEvent")
    AlltypesAppointmentresponse -> json.string("AppointmentResponse")
    AlltypesAppointment -> json.string("Appointment")
    AlltypesAllergyintolerance -> json.string("AllergyIntolerance")
    AlltypesAdverseevent -> json.string("AdverseEvent")
    AlltypesActivitydefinition -> json.string("ActivityDefinition")
    AlltypesAccount -> json.string("Account")
    AlltypesXhtml -> json.string("xhtml")
    AlltypesUuid -> json.string("uuid")
    AlltypesUrl -> json.string("url")
    AlltypesUri -> json.string("uri")
    AlltypesUnsignedint -> json.string("unsignedInt")
    AlltypesTime -> json.string("time")
    AlltypesString -> json.string("string")
    AlltypesPositiveint -> json.string("positiveInt")
    AlltypesOid -> json.string("oid")
    AlltypesMarkdown -> json.string("markdown")
    AlltypesInteger -> json.string("integer")
    AlltypesInstant -> json.string("instant")
    AlltypesId -> json.string("id")
    AlltypesDecimal -> json.string("decimal")
    AlltypesDatetime -> json.string("dateTime")
    AlltypesDate -> json.string("date")
    AlltypesCode -> json.string("code")
    AlltypesCanonical -> json.string("canonical")
    AlltypesBoolean -> json.string("boolean")
    AlltypesBase64binary -> json.string("base64Binary")
    AlltypesUsagecontext -> json.string("UsageContext")
    AlltypesTriggerdefinition -> json.string("TriggerDefinition")
    AlltypesTiming -> json.string("Timing")
    AlltypesSubstanceamount -> json.string("SubstanceAmount")
    AlltypesSimplequantity -> json.string("SimpleQuantity")
    AlltypesSignature -> json.string("Signature")
    AlltypesSampleddata -> json.string("SampledData")
    AlltypesRelatedartifact -> json.string("RelatedArtifact")
    AlltypesReference -> json.string("Reference")
    AlltypesRatio -> json.string("Ratio")
    AlltypesRange -> json.string("Range")
    AlltypesQuantity -> json.string("Quantity")
    AlltypesProductshelflife -> json.string("ProductShelfLife")
    AlltypesProdcharacteristic -> json.string("ProdCharacteristic")
    AlltypesPopulation -> json.string("Population")
    AlltypesPeriod -> json.string("Period")
    AlltypesParameterdefinition -> json.string("ParameterDefinition")
    AlltypesNarrative -> json.string("Narrative")
    AlltypesMoneyquantity -> json.string("MoneyQuantity")
    AlltypesMoney -> json.string("Money")
    AlltypesMeta -> json.string("Meta")
    AlltypesMarketingstatus -> json.string("MarketingStatus")
    AlltypesIdentifier -> json.string("Identifier")
    AlltypesHumanname -> json.string("HumanName")
    AlltypesExtension -> json.string("Extension")
    AlltypesExpression -> json.string("Expression")
    AlltypesElementdefinition -> json.string("ElementDefinition")
    AlltypesElement -> json.string("Element")
    AlltypesDuration -> json.string("Duration")
    AlltypesDosage -> json.string("Dosage")
    AlltypesDistance -> json.string("Distance")
    AlltypesDatarequirement -> json.string("DataRequirement")
    AlltypesCount -> json.string("Count")
    AlltypesContributor -> json.string("Contributor")
    AlltypesContactpoint -> json.string("ContactPoint")
    AlltypesContactdetail -> json.string("ContactDetail")
    AlltypesCoding -> json.string("Coding")
    AlltypesCodeableconcept -> json.string("CodeableConcept")
    AlltypesBackboneelement -> json.string("BackboneElement")
    AlltypesAttachment -> json.string("Attachment")
    AlltypesAnnotation -> json.string("Annotation")
    AlltypesAge -> json.string("Age")
    AlltypesAddress -> json.string("Address")
  }
}

pub fn alltypes_decoder() -> Decoder(Alltypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Any" -> decode.success(AlltypesAny)
    "Type" -> decode.success(AlltypesType)
    "VisionPrescription" -> decode.success(AlltypesVisionprescription)
    "VerificationResult" -> decode.success(AlltypesVerificationresult)
    "ValueSet" -> decode.success(AlltypesValueset)
    "TestScript" -> decode.success(AlltypesTestscript)
    "TestReport" -> decode.success(AlltypesTestreport)
    "TerminologyCapabilities" -> decode.success(AlltypesTerminologycapabilities)
    "Task" -> decode.success(AlltypesTask)
    "SupplyRequest" -> decode.success(AlltypesSupplyrequest)
    "SupplyDelivery" -> decode.success(AlltypesSupplydelivery)
    "SubstanceSpecification" -> decode.success(AlltypesSubstancespecification)
    "SubstanceSourceMaterial" -> decode.success(AlltypesSubstancesourcematerial)
    "SubstanceReferenceInformation" ->
      decode.success(AlltypesSubstancereferenceinformation)
    "SubstanceProtein" -> decode.success(AlltypesSubstanceprotein)
    "SubstancePolymer" -> decode.success(AlltypesSubstancepolymer)
    "SubstanceNucleicAcid" -> decode.success(AlltypesSubstancenucleicacid)
    "Substance" -> decode.success(AlltypesSubstance)
    "Subscription" -> decode.success(AlltypesSubscription)
    "StructureMap" -> decode.success(AlltypesStructuremap)
    "StructureDefinition" -> decode.success(AlltypesStructuredefinition)
    "SpecimenDefinition" -> decode.success(AlltypesSpecimendefinition)
    "Specimen" -> decode.success(AlltypesSpecimen)
    "Slot" -> decode.success(AlltypesSlot)
    "ServiceRequest" -> decode.success(AlltypesServicerequest)
    "SearchParameter" -> decode.success(AlltypesSearchparameter)
    "Schedule" -> decode.success(AlltypesSchedule)
    "RiskEvidenceSynthesis" -> decode.success(AlltypesRiskevidencesynthesis)
    "RiskAssessment" -> decode.success(AlltypesRiskassessment)
    "Resource" -> decode.success(AlltypesResource)
    "ResearchSubject" -> decode.success(AlltypesResearchsubject)
    "ResearchStudy" -> decode.success(AlltypesResearchstudy)
    "ResearchElementDefinition" ->
      decode.success(AlltypesResearchelementdefinition)
    "ResearchDefinition" -> decode.success(AlltypesResearchdefinition)
    "RequestGroup" -> decode.success(AlltypesRequestgroup)
    "RelatedPerson" -> decode.success(AlltypesRelatedperson)
    "QuestionnaireResponse" -> decode.success(AlltypesQuestionnaireresponse)
    "Questionnaire" -> decode.success(AlltypesQuestionnaire)
    "Provenance" -> decode.success(AlltypesProvenance)
    "Procedure" -> decode.success(AlltypesProcedure)
    "PractitionerRole" -> decode.success(AlltypesPractitionerrole)
    "Practitioner" -> decode.success(AlltypesPractitioner)
    "PlanDefinition" -> decode.success(AlltypesPlandefinition)
    "Person" -> decode.success(AlltypesPerson)
    "PaymentReconciliation" -> decode.success(AlltypesPaymentreconciliation)
    "PaymentNotice" -> decode.success(AlltypesPaymentnotice)
    "Patient" -> decode.success(AlltypesPatient)
    "Parameters" -> decode.success(AlltypesParameters)
    "OrganizationAffiliation" -> decode.success(AlltypesOrganizationaffiliation)
    "Organization" -> decode.success(AlltypesOrganization)
    "OperationOutcome" -> decode.success(AlltypesOperationoutcome)
    "OperationDefinition" -> decode.success(AlltypesOperationdefinition)
    "ObservationDefinition" -> decode.success(AlltypesObservationdefinition)
    "Observation" -> decode.success(AlltypesObservation)
    "NutritionOrder" -> decode.success(AlltypesNutritionorder)
    "NamingSystem" -> decode.success(AlltypesNamingsystem)
    "MolecularSequence" -> decode.success(AlltypesMolecularsequence)
    "MessageHeader" -> decode.success(AlltypesMessageheader)
    "MessageDefinition" -> decode.success(AlltypesMessagedefinition)
    "MedicinalProductUndesirableEffect" ->
      decode.success(AlltypesMedicinalproductundesirableeffect)
    "MedicinalProductPharmaceutical" ->
      decode.success(AlltypesMedicinalproductpharmaceutical)
    "MedicinalProductPackaged" ->
      decode.success(AlltypesMedicinalproductpackaged)
    "MedicinalProductManufactured" ->
      decode.success(AlltypesMedicinalproductmanufactured)
    "MedicinalProductInteraction" ->
      decode.success(AlltypesMedicinalproductinteraction)
    "MedicinalProductIngredient" ->
      decode.success(AlltypesMedicinalproductingredient)
    "MedicinalProductIndication" ->
      decode.success(AlltypesMedicinalproductindication)
    "MedicinalProductContraindication" ->
      decode.success(AlltypesMedicinalproductcontraindication)
    "MedicinalProductAuthorization" ->
      decode.success(AlltypesMedicinalproductauthorization)
    "MedicinalProduct" -> decode.success(AlltypesMedicinalproduct)
    "MedicationStatement" -> decode.success(AlltypesMedicationstatement)
    "MedicationRequest" -> decode.success(AlltypesMedicationrequest)
    "MedicationKnowledge" -> decode.success(AlltypesMedicationknowledge)
    "MedicationDispense" -> decode.success(AlltypesMedicationdispense)
    "MedicationAdministration" ->
      decode.success(AlltypesMedicationadministration)
    "Medication" -> decode.success(AlltypesMedication)
    "Media" -> decode.success(AlltypesMedia)
    "MeasureReport" -> decode.success(AlltypesMeasurereport)
    "Measure" -> decode.success(AlltypesMeasure)
    "Location" -> decode.success(AlltypesLocation)
    "List" -> decode.success(AlltypesList)
    "Linkage" -> decode.success(AlltypesLinkage)
    "Library" -> decode.success(AlltypesLibrary)
    "Invoice" -> decode.success(AlltypesInvoice)
    "InsurancePlan" -> decode.success(AlltypesInsuranceplan)
    "ImplementationGuide" -> decode.success(AlltypesImplementationguide)
    "ImmunizationRecommendation" ->
      decode.success(AlltypesImmunizationrecommendation)
    "ImmunizationEvaluation" -> decode.success(AlltypesImmunizationevaluation)
    "Immunization" -> decode.success(AlltypesImmunization)
    "ImagingStudy" -> decode.success(AlltypesImagingstudy)
    "HealthcareService" -> decode.success(AlltypesHealthcareservice)
    "GuidanceResponse" -> decode.success(AlltypesGuidanceresponse)
    "Group" -> decode.success(AlltypesGroup)
    "GraphDefinition" -> decode.success(AlltypesGraphdefinition)
    "Goal" -> decode.success(AlltypesGoal)
    "Flag" -> decode.success(AlltypesFlag)
    "FamilyMemberHistory" -> decode.success(AlltypesFamilymemberhistory)
    "ExplanationOfBenefit" -> decode.success(AlltypesExplanationofbenefit)
    "ExampleScenario" -> decode.success(AlltypesExamplescenario)
    "EvidenceVariable" -> decode.success(AlltypesEvidencevariable)
    "Evidence" -> decode.success(AlltypesEvidence)
    "EventDefinition" -> decode.success(AlltypesEventdefinition)
    "EpisodeOfCare" -> decode.success(AlltypesEpisodeofcare)
    "EnrollmentResponse" -> decode.success(AlltypesEnrollmentresponse)
    "EnrollmentRequest" -> decode.success(AlltypesEnrollmentrequest)
    "Endpoint" -> decode.success(AlltypesEndpoint)
    "Encounter" -> decode.success(AlltypesEncounter)
    "EffectEvidenceSynthesis" -> decode.success(AlltypesEffectevidencesynthesis)
    "DomainResource" -> decode.success(AlltypesDomainresource)
    "DocumentReference" -> decode.success(AlltypesDocumentreference)
    "DocumentManifest" -> decode.success(AlltypesDocumentmanifest)
    "DiagnosticReport" -> decode.success(AlltypesDiagnosticreport)
    "DeviceUseStatement" -> decode.success(AlltypesDeviceusestatement)
    "DeviceRequest" -> decode.success(AlltypesDevicerequest)
    "DeviceMetric" -> decode.success(AlltypesDevicemetric)
    "DeviceDefinition" -> decode.success(AlltypesDevicedefinition)
    "Device" -> decode.success(AlltypesDevice)
    "DetectedIssue" -> decode.success(AlltypesDetectedissue)
    "CoverageEligibilityResponse" ->
      decode.success(AlltypesCoverageeligibilityresponse)
    "CoverageEligibilityRequest" ->
      decode.success(AlltypesCoverageeligibilityrequest)
    "Coverage" -> decode.success(AlltypesCoverage)
    "Contract" -> decode.success(AlltypesContract)
    "Consent" -> decode.success(AlltypesConsent)
    "Condition" -> decode.success(AlltypesCondition)
    "ConceptMap" -> decode.success(AlltypesConceptmap)
    "Composition" -> decode.success(AlltypesComposition)
    "CompartmentDefinition" -> decode.success(AlltypesCompartmentdefinition)
    "CommunicationRequest" -> decode.success(AlltypesCommunicationrequest)
    "Communication" -> decode.success(AlltypesCommunication)
    "CodeSystem" -> decode.success(AlltypesCodesystem)
    "ClinicalImpression" -> decode.success(AlltypesClinicalimpression)
    "ClaimResponse" -> decode.success(AlltypesClaimresponse)
    "Claim" -> decode.success(AlltypesClaim)
    "ChargeItemDefinition" -> decode.success(AlltypesChargeitemdefinition)
    "ChargeItem" -> decode.success(AlltypesChargeitem)
    "CatalogEntry" -> decode.success(AlltypesCatalogentry)
    "CareTeam" -> decode.success(AlltypesCareteam)
    "CarePlan" -> decode.success(AlltypesCareplan)
    "CapabilityStatement" -> decode.success(AlltypesCapabilitystatement)
    "Bundle" -> decode.success(AlltypesBundle)
    "BodyStructure" -> decode.success(AlltypesBodystructure)
    "BiologicallyDerivedProduct" ->
      decode.success(AlltypesBiologicallyderivedproduct)
    "Binary" -> decode.success(AlltypesBinary)
    "Basic" -> decode.success(AlltypesBasic)
    "AuditEvent" -> decode.success(AlltypesAuditevent)
    "AppointmentResponse" -> decode.success(AlltypesAppointmentresponse)
    "Appointment" -> decode.success(AlltypesAppointment)
    "AllergyIntolerance" -> decode.success(AlltypesAllergyintolerance)
    "AdverseEvent" -> decode.success(AlltypesAdverseevent)
    "ActivityDefinition" -> decode.success(AlltypesActivitydefinition)
    "Account" -> decode.success(AlltypesAccount)
    "xhtml" -> decode.success(AlltypesXhtml)
    "uuid" -> decode.success(AlltypesUuid)
    "url" -> decode.success(AlltypesUrl)
    "uri" -> decode.success(AlltypesUri)
    "unsignedInt" -> decode.success(AlltypesUnsignedint)
    "time" -> decode.success(AlltypesTime)
    "string" -> decode.success(AlltypesString)
    "positiveInt" -> decode.success(AlltypesPositiveint)
    "oid" -> decode.success(AlltypesOid)
    "markdown" -> decode.success(AlltypesMarkdown)
    "integer" -> decode.success(AlltypesInteger)
    "instant" -> decode.success(AlltypesInstant)
    "id" -> decode.success(AlltypesId)
    "decimal" -> decode.success(AlltypesDecimal)
    "dateTime" -> decode.success(AlltypesDatetime)
    "date" -> decode.success(AlltypesDate)
    "code" -> decode.success(AlltypesCode)
    "canonical" -> decode.success(AlltypesCanonical)
    "boolean" -> decode.success(AlltypesBoolean)
    "base64Binary" -> decode.success(AlltypesBase64binary)
    "UsageContext" -> decode.success(AlltypesUsagecontext)
    "TriggerDefinition" -> decode.success(AlltypesTriggerdefinition)
    "Timing" -> decode.success(AlltypesTiming)
    "SubstanceAmount" -> decode.success(AlltypesSubstanceamount)
    "SimpleQuantity" -> decode.success(AlltypesSimplequantity)
    "Signature" -> decode.success(AlltypesSignature)
    "SampledData" -> decode.success(AlltypesSampleddata)
    "RelatedArtifact" -> decode.success(AlltypesRelatedartifact)
    "Reference" -> decode.success(AlltypesReference)
    "Ratio" -> decode.success(AlltypesRatio)
    "Range" -> decode.success(AlltypesRange)
    "Quantity" -> decode.success(AlltypesQuantity)
    "ProductShelfLife" -> decode.success(AlltypesProductshelflife)
    "ProdCharacteristic" -> decode.success(AlltypesProdcharacteristic)
    "Population" -> decode.success(AlltypesPopulation)
    "Period" -> decode.success(AlltypesPeriod)
    "ParameterDefinition" -> decode.success(AlltypesParameterdefinition)
    "Narrative" -> decode.success(AlltypesNarrative)
    "MoneyQuantity" -> decode.success(AlltypesMoneyquantity)
    "Money" -> decode.success(AlltypesMoney)
    "Meta" -> decode.success(AlltypesMeta)
    "MarketingStatus" -> decode.success(AlltypesMarketingstatus)
    "Identifier" -> decode.success(AlltypesIdentifier)
    "HumanName" -> decode.success(AlltypesHumanname)
    "Extension" -> decode.success(AlltypesExtension)
    "Expression" -> decode.success(AlltypesExpression)
    "ElementDefinition" -> decode.success(AlltypesElementdefinition)
    "Element" -> decode.success(AlltypesElement)
    "Duration" -> decode.success(AlltypesDuration)
    "Dosage" -> decode.success(AlltypesDosage)
    "Distance" -> decode.success(AlltypesDistance)
    "DataRequirement" -> decode.success(AlltypesDatarequirement)
    "Count" -> decode.success(AlltypesCount)
    "Contributor" -> decode.success(AlltypesContributor)
    "ContactPoint" -> decode.success(AlltypesContactpoint)
    "ContactDetail" -> decode.success(AlltypesContactdetail)
    "Coding" -> decode.success(AlltypesCoding)
    "CodeableConcept" -> decode.success(AlltypesCodeableconcept)
    "BackboneElement" -> decode.success(AlltypesBackboneelement)
    "Attachment" -> decode.success(AlltypesAttachment)
    "Annotation" -> decode.success(AlltypesAnnotation)
    "Age" -> decode.success(AlltypesAge)
    "Address" -> decode.success(AlltypesAddress)
    _ -> decode.failure(AlltypesAny, "Alltypes")
  }
}

pub type Consentstatecodes {
  ConsentstatecodesEnteredinerror
  ConsentstatecodesInactive
  ConsentstatecodesRejected
  ConsentstatecodesActive
  ConsentstatecodesProposed
  ConsentstatecodesDraft
}

pub fn consentstatecodes_to_json(consentstatecodes: Consentstatecodes) -> Json {
  case consentstatecodes {
    ConsentstatecodesEnteredinerror -> json.string("entered-in-error")
    ConsentstatecodesInactive -> json.string("inactive")
    ConsentstatecodesRejected -> json.string("rejected")
    ConsentstatecodesActive -> json.string("active")
    ConsentstatecodesProposed -> json.string("proposed")
    ConsentstatecodesDraft -> json.string("draft")
  }
}

pub fn consentstatecodes_decoder() -> Decoder(Consentstatecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(ConsentstatecodesEnteredinerror)
    "inactive" -> decode.success(ConsentstatecodesInactive)
    "rejected" -> decode.success(ConsentstatecodesRejected)
    "active" -> decode.success(ConsentstatecodesActive)
    "proposed" -> decode.success(ConsentstatecodesProposed)
    "draft" -> decode.success(ConsentstatecodesDraft)
    _ -> decode.failure(ConsentstatecodesEnteredinerror, "Consentstatecodes")
  }
}

pub type Liststatus {
  ListstatusEnteredinerror
  ListstatusRetired
  ListstatusCurrent
}

pub fn liststatus_to_json(liststatus: Liststatus) -> Json {
  case liststatus {
    ListstatusEnteredinerror -> json.string("entered-in-error")
    ListstatusRetired -> json.string("retired")
    ListstatusCurrent -> json.string("current")
  }
}

pub fn liststatus_decoder() -> Decoder(Liststatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(ListstatusEnteredinerror)
    "retired" -> decode.success(ListstatusRetired)
    "current" -> decode.success(ListstatusCurrent)
    _ -> decode.failure(ListstatusEnteredinerror, "Liststatus")
  }
}

pub type Contributortype {
  ContributortypeEndorser
  ContributortypeReviewer
  ContributortypeEditor
  ContributortypeAuthor
}

pub fn contributortype_to_json(contributortype: Contributortype) -> Json {
  case contributortype {
    ContributortypeEndorser -> json.string("endorser")
    ContributortypeReviewer -> json.string("reviewer")
    ContributortypeEditor -> json.string("editor")
    ContributortypeAuthor -> json.string("author")
  }
}

pub fn contributortype_decoder() -> Decoder(Contributortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "endorser" -> decode.success(ContributortypeEndorser)
    "reviewer" -> decode.success(ContributortypeReviewer)
    "editor" -> decode.success(ContributortypeEditor)
    "author" -> decode.success(ContributortypeAuthor)
    _ -> decode.failure(ContributortypeEndorser, "Contributortype")
  }
}

pub type Restfulcapabilitymode {
  RestfulcapabilitymodeServer
  RestfulcapabilitymodeClient
}

pub fn restfulcapabilitymode_to_json(
  restfulcapabilitymode: Restfulcapabilitymode,
) -> Json {
  case restfulcapabilitymode {
    RestfulcapabilitymodeServer -> json.string("server")
    RestfulcapabilitymodeClient -> json.string("client")
  }
}

pub fn restfulcapabilitymode_decoder() -> Decoder(Restfulcapabilitymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "server" -> decode.success(RestfulcapabilitymodeServer)
    "client" -> decode.success(RestfulcapabilitymodeClient)
    _ -> decode.failure(RestfulcapabilitymodeServer, "Restfulcapabilitymode")
  }
}

pub type Medicationstatementstatus {
  MedicationstatementstatusNottaken
  MedicationstatementstatusUnknown
  MedicationstatementstatusOnhold
  MedicationstatementstatusStopped
  MedicationstatementstatusIntended
  MedicationstatementstatusEnteredinerror
  MedicationstatementstatusCompleted
  MedicationstatementstatusActive
}

pub fn medicationstatementstatus_to_json(
  medicationstatementstatus: Medicationstatementstatus,
) -> Json {
  case medicationstatementstatus {
    MedicationstatementstatusNottaken -> json.string("not-taken")
    MedicationstatementstatusUnknown -> json.string("unknown")
    MedicationstatementstatusOnhold -> json.string("on-hold")
    MedicationstatementstatusStopped -> json.string("stopped")
    MedicationstatementstatusIntended -> json.string("intended")
    MedicationstatementstatusEnteredinerror -> json.string("entered-in-error")
    MedicationstatementstatusCompleted -> json.string("completed")
    MedicationstatementstatusActive -> json.string("active")
  }
}

pub fn medicationstatementstatus_decoder() -> Decoder(Medicationstatementstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-taken" -> decode.success(MedicationstatementstatusNottaken)
    "unknown" -> decode.success(MedicationstatementstatusUnknown)
    "on-hold" -> decode.success(MedicationstatementstatusOnhold)
    "stopped" -> decode.success(MedicationstatementstatusStopped)
    "intended" -> decode.success(MedicationstatementstatusIntended)
    "entered-in-error" ->
      decode.success(MedicationstatementstatusEnteredinerror)
    "completed" -> decode.success(MedicationstatementstatusCompleted)
    "active" -> decode.success(MedicationstatementstatusActive)
    _ ->
      decode.failure(
        MedicationstatementstatusNottaken,
        "Medicationstatementstatus",
      )
  }
}

pub type Guidanceresponsestatus {
  GuidanceresponsestatusEnteredinerror
  GuidanceresponsestatusFailure
  GuidanceresponsestatusInprogress
  GuidanceresponsestatusDatarequired
  GuidanceresponsestatusDatarequested
  GuidanceresponsestatusSuccess
}

pub fn guidanceresponsestatus_to_json(
  guidanceresponsestatus: Guidanceresponsestatus,
) -> Json {
  case guidanceresponsestatus {
    GuidanceresponsestatusEnteredinerror -> json.string("entered-in-error")
    GuidanceresponsestatusFailure -> json.string("failure")
    GuidanceresponsestatusInprogress -> json.string("in-progress")
    GuidanceresponsestatusDatarequired -> json.string("data-required")
    GuidanceresponsestatusDatarequested -> json.string("data-requested")
    GuidanceresponsestatusSuccess -> json.string("success")
  }
}

pub fn guidanceresponsestatus_decoder() -> Decoder(Guidanceresponsestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(GuidanceresponsestatusEnteredinerror)
    "failure" -> decode.success(GuidanceresponsestatusFailure)
    "in-progress" -> decode.success(GuidanceresponsestatusInprogress)
    "data-required" -> decode.success(GuidanceresponsestatusDatarequired)
    "data-requested" -> decode.success(GuidanceresponsestatusDatarequested)
    "success" -> decode.success(GuidanceresponsestatusSuccess)
    _ ->
      decode.failure(
        GuidanceresponsestatusEnteredinerror,
        "Guidanceresponsestatus",
      )
  }
}

pub type Constraintseverity {
  ConstraintseverityWarning
  ConstraintseverityError
}

pub fn constraintseverity_to_json(
  constraintseverity: Constraintseverity,
) -> Json {
  case constraintseverity {
    ConstraintseverityWarning -> json.string("warning")
    ConstraintseverityError -> json.string("error")
  }
}

pub fn constraintseverity_decoder() -> Decoder(Constraintseverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "warning" -> decode.success(ConstraintseverityWarning)
    "error" -> decode.success(ConstraintseverityError)
    _ -> decode.failure(ConstraintseverityWarning, "Constraintseverity")
  }
}

pub type Messageheaderresponserequest {
  MessageheaderresponserequestOnsuccess
  MessageheaderresponserequestNever
  MessageheaderresponserequestOnerror
  MessageheaderresponserequestAlways
}

pub fn messageheaderresponserequest_to_json(
  messageheaderresponserequest: Messageheaderresponserequest,
) -> Json {
  case messageheaderresponserequest {
    MessageheaderresponserequestOnsuccess -> json.string("on-success")
    MessageheaderresponserequestNever -> json.string("never")
    MessageheaderresponserequestOnerror -> json.string("on-error")
    MessageheaderresponserequestAlways -> json.string("always")
  }
}

pub fn messageheaderresponserequest_decoder() -> Decoder(
  Messageheaderresponserequest,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "on-success" -> decode.success(MessageheaderresponserequestOnsuccess)
    "never" -> decode.success(MessageheaderresponserequestNever)
    "on-error" -> decode.success(MessageheaderresponserequestOnerror)
    "always" -> decode.success(MessageheaderresponserequestAlways)
    _ ->
      decode.failure(
        MessageheaderresponserequestOnsuccess,
        "Messageheaderresponserequest",
      )
  }
}

pub type Contractpublicationstatus {
  ContractpublicationstatusTerminated
  ContractpublicationstatusResolved
  ContractpublicationstatusRevoked
  ContractpublicationstatusRenewed
  ContractpublicationstatusRejected
  ContractpublicationstatusPolicy
  ContractpublicationstatusOffered
  ContractpublicationstatusNegotiable
  ContractpublicationstatusExecuted
  ContractpublicationstatusExecutable
  ContractpublicationstatusEnteredinerror
  ContractpublicationstatusDisputed
  ContractpublicationstatusCancelled
  ContractpublicationstatusAppended
  ContractpublicationstatusAmended
}

pub fn contractpublicationstatus_to_json(
  contractpublicationstatus: Contractpublicationstatus,
) -> Json {
  case contractpublicationstatus {
    ContractpublicationstatusTerminated -> json.string("terminated")
    ContractpublicationstatusResolved -> json.string("resolved")
    ContractpublicationstatusRevoked -> json.string("revoked")
    ContractpublicationstatusRenewed -> json.string("renewed")
    ContractpublicationstatusRejected -> json.string("rejected")
    ContractpublicationstatusPolicy -> json.string("policy")
    ContractpublicationstatusOffered -> json.string("offered")
    ContractpublicationstatusNegotiable -> json.string("negotiable")
    ContractpublicationstatusExecuted -> json.string("executed")
    ContractpublicationstatusExecutable -> json.string("executable")
    ContractpublicationstatusEnteredinerror -> json.string("entered-in-error")
    ContractpublicationstatusDisputed -> json.string("disputed")
    ContractpublicationstatusCancelled -> json.string("cancelled")
    ContractpublicationstatusAppended -> json.string("appended")
    ContractpublicationstatusAmended -> json.string("amended")
  }
}

pub fn contractpublicationstatus_decoder() -> Decoder(Contractpublicationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "terminated" -> decode.success(ContractpublicationstatusTerminated)
    "resolved" -> decode.success(ContractpublicationstatusResolved)
    "revoked" -> decode.success(ContractpublicationstatusRevoked)
    "renewed" -> decode.success(ContractpublicationstatusRenewed)
    "rejected" -> decode.success(ContractpublicationstatusRejected)
    "policy" -> decode.success(ContractpublicationstatusPolicy)
    "offered" -> decode.success(ContractpublicationstatusOffered)
    "negotiable" -> decode.success(ContractpublicationstatusNegotiable)
    "executed" -> decode.success(ContractpublicationstatusExecuted)
    "executable" -> decode.success(ContractpublicationstatusExecutable)
    "entered-in-error" ->
      decode.success(ContractpublicationstatusEnteredinerror)
    "disputed" -> decode.success(ContractpublicationstatusDisputed)
    "cancelled" -> decode.success(ContractpublicationstatusCancelled)
    "appended" -> decode.success(ContractpublicationstatusAppended)
    "amended" -> decode.success(ContractpublicationstatusAmended)
    _ ->
      decode.failure(
        ContractpublicationstatusTerminated,
        "Contractpublicationstatus",
      )
  }
}

pub type Immunizationstatus {
  ImmunizationstatusUnknown
  ImmunizationstatusEnteredinerror
  ImmunizationstatusCompleted
  ImmunizationstatusStopped
  ImmunizationstatusOnhold
  ImmunizationstatusNotdone
  ImmunizationstatusInprogress
  ImmunizationstatusPreparation
}

pub fn immunizationstatus_to_json(
  immunizationstatus: Immunizationstatus,
) -> Json {
  case immunizationstatus {
    ImmunizationstatusUnknown -> json.string("unknown")
    ImmunizationstatusEnteredinerror -> json.string("entered-in-error")
    ImmunizationstatusCompleted -> json.string("completed")
    ImmunizationstatusStopped -> json.string("stopped")
    ImmunizationstatusOnhold -> json.string("on-hold")
    ImmunizationstatusNotdone -> json.string("not-done")
    ImmunizationstatusInprogress -> json.string("in-progress")
    ImmunizationstatusPreparation -> json.string("preparation")
  }
}

pub fn immunizationstatus_decoder() -> Decoder(Immunizationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(ImmunizationstatusUnknown)
    "entered-in-error" -> decode.success(ImmunizationstatusEnteredinerror)
    "completed" -> decode.success(ImmunizationstatusCompleted)
    "stopped" -> decode.success(ImmunizationstatusStopped)
    "on-hold" -> decode.success(ImmunizationstatusOnhold)
    "not-done" -> decode.success(ImmunizationstatusNotdone)
    "in-progress" -> decode.success(ImmunizationstatusInprogress)
    "preparation" -> decode.success(ImmunizationstatusPreparation)
    _ -> decode.failure(ImmunizationstatusUnknown, "Immunizationstatus")
  }
}

pub type Httpoperations {
  HttpoperationsHead
  HttpoperationsPut
  HttpoperationsPost
  HttpoperationsPatch
  HttpoperationsOptions
  HttpoperationsGet
  HttpoperationsDelete
}

pub fn httpoperations_to_json(httpoperations: Httpoperations) -> Json {
  case httpoperations {
    HttpoperationsHead -> json.string("head")
    HttpoperationsPut -> json.string("put")
    HttpoperationsPost -> json.string("post")
    HttpoperationsPatch -> json.string("patch")
    HttpoperationsOptions -> json.string("options")
    HttpoperationsGet -> json.string("get")
    HttpoperationsDelete -> json.string("delete")
  }
}

pub fn httpoperations_decoder() -> Decoder(Httpoperations) {
  use variant <- decode.then(decode.string)
  case variant {
    "head" -> decode.success(HttpoperationsHead)
    "put" -> decode.success(HttpoperationsPut)
    "post" -> decode.success(HttpoperationsPost)
    "patch" -> decode.success(HttpoperationsPatch)
    "options" -> decode.success(HttpoperationsOptions)
    "get" -> decode.success(HttpoperationsGet)
    "delete" -> decode.success(HttpoperationsDelete)
    _ -> decode.failure(HttpoperationsHead, "Httpoperations")
  }
}

pub type Guidepagegeneration {
  GuidepagegenerationGenerated
  GuidepagegenerationXml
  GuidepagegenerationMarkdown
  GuidepagegenerationHtml
}

pub fn guidepagegeneration_to_json(
  guidepagegeneration: Guidepagegeneration,
) -> Json {
  case guidepagegeneration {
    GuidepagegenerationGenerated -> json.string("generated")
    GuidepagegenerationXml -> json.string("xml")
    GuidepagegenerationMarkdown -> json.string("markdown")
    GuidepagegenerationHtml -> json.string("html")
  }
}

pub fn guidepagegeneration_decoder() -> Decoder(Guidepagegeneration) {
  use variant <- decode.then(decode.string)
  case variant {
    "generated" -> decode.success(GuidepagegenerationGenerated)
    "xml" -> decode.success(GuidepagegenerationXml)
    "markdown" -> decode.success(GuidepagegenerationMarkdown)
    "html" -> decode.success(GuidepagegenerationHtml)
    _ -> decode.failure(GuidepagegenerationGenerated, "Guidepagegeneration")
  }
}

pub type Locationmode {
  LocationmodeKind
  LocationmodeInstance
}

pub fn locationmode_to_json(locationmode: Locationmode) -> Json {
  case locationmode {
    LocationmodeKind -> json.string("kind")
    LocationmodeInstance -> json.string("instance")
  }
}

pub fn locationmode_decoder() -> Decoder(Locationmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "kind" -> decode.success(LocationmodeKind)
    "instance" -> decode.success(LocationmodeInstance)
    _ -> decode.failure(LocationmodeKind, "Locationmode")
  }
}

pub type Productcategory {
  ProductcategoryBiologicalagent
  ProductcategoryCells
  ProductcategoryFluid
  ProductcategoryTissue
  ProductcategoryOrgan
}

pub fn productcategory_to_json(productcategory: Productcategory) -> Json {
  case productcategory {
    ProductcategoryBiologicalagent -> json.string("biologicalAgent")
    ProductcategoryCells -> json.string("cells")
    ProductcategoryFluid -> json.string("fluid")
    ProductcategoryTissue -> json.string("tissue")
    ProductcategoryOrgan -> json.string("organ")
  }
}

pub fn productcategory_decoder() -> Decoder(Productcategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "biologicalAgent" -> decode.success(ProductcategoryBiologicalagent)
    "cells" -> decode.success(ProductcategoryCells)
    "fluid" -> decode.success(ProductcategoryFluid)
    "tissue" -> decode.success(ProductcategoryTissue)
    "organ" -> decode.success(ProductcategoryOrgan)
    _ -> decode.failure(ProductcategoryBiologicalagent, "Productcategory")
  }
}

pub type Actionparticipanttype {
  ActionparticipanttypeDevice
  ActionparticipanttypeRelatedperson
  ActionparticipanttypePractitioner
  ActionparticipanttypePatient
}

pub fn actionparticipanttype_to_json(
  actionparticipanttype: Actionparticipanttype,
) -> Json {
  case actionparticipanttype {
    ActionparticipanttypeDevice -> json.string("device")
    ActionparticipanttypeRelatedperson -> json.string("related-person")
    ActionparticipanttypePractitioner -> json.string("practitioner")
    ActionparticipanttypePatient -> json.string("patient")
  }
}

pub fn actionparticipanttype_decoder() -> Decoder(Actionparticipanttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "device" -> decode.success(ActionparticipanttypeDevice)
    "related-person" -> decode.success(ActionparticipanttypeRelatedperson)
    "practitioner" -> decode.success(ActionparticipanttypePractitioner)
    "patient" -> decode.success(ActionparticipanttypePatient)
    _ -> decode.failure(ActionparticipanttypeDevice, "Actionparticipanttype")
  }
}

pub type Specimenstatus {
  SpecimenstatusEnteredinerror
  SpecimenstatusUnsatisfactory
  SpecimenstatusUnavailable
  SpecimenstatusAvailable
}

pub fn specimenstatus_to_json(specimenstatus: Specimenstatus) -> Json {
  case specimenstatus {
    SpecimenstatusEnteredinerror -> json.string("entered-in-error")
    SpecimenstatusUnsatisfactory -> json.string("unsatisfactory")
    SpecimenstatusUnavailable -> json.string("unavailable")
    SpecimenstatusAvailable -> json.string("available")
  }
}

pub fn specimenstatus_decoder() -> Decoder(Specimenstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(SpecimenstatusEnteredinerror)
    "unsatisfactory" -> decode.success(SpecimenstatusUnsatisfactory)
    "unavailable" -> decode.success(SpecimenstatusUnavailable)
    "available" -> decode.success(SpecimenstatusAvailable)
    _ -> decode.failure(SpecimenstatusEnteredinerror, "Specimenstatus")
  }
}

pub type Namingsystemidentifiertype {
  NamingsystemidentifiertypeOther
  NamingsystemidentifiertypeUri
  NamingsystemidentifiertypeUuid
  NamingsystemidentifiertypeOid
}

pub fn namingsystemidentifiertype_to_json(
  namingsystemidentifiertype: Namingsystemidentifiertype,
) -> Json {
  case namingsystemidentifiertype {
    NamingsystemidentifiertypeOther -> json.string("other")
    NamingsystemidentifiertypeUri -> json.string("uri")
    NamingsystemidentifiertypeUuid -> json.string("uuid")
    NamingsystemidentifiertypeOid -> json.string("oid")
  }
}

pub fn namingsystemidentifiertype_decoder() -> Decoder(
  Namingsystemidentifiertype,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "other" -> decode.success(NamingsystemidentifiertypeOther)
    "uri" -> decode.success(NamingsystemidentifiertypeUri)
    "uuid" -> decode.success(NamingsystemidentifiertypeUuid)
    "oid" -> decode.success(NamingsystemidentifiertypeOid)
    _ ->
      decode.failure(
        NamingsystemidentifiertypeOther,
        "Namingsystemidentifiertype",
      )
  }
}

pub type Goalstatus {
  GoalstatusRejected
  GoalstatusEnteredinerror
  GoalstatusCancelled
  GoalstatusAccepted
  GoalstatusPlanned
  GoalstatusProposed
  GoalstatusCompleted
  GoalstatusOnhold
  GoalstatusActive
}

pub fn goalstatus_to_json(goalstatus: Goalstatus) -> Json {
  case goalstatus {
    GoalstatusRejected -> json.string("rejected")
    GoalstatusEnteredinerror -> json.string("entered-in-error")
    GoalstatusCancelled -> json.string("cancelled")
    GoalstatusAccepted -> json.string("accepted")
    GoalstatusPlanned -> json.string("planned")
    GoalstatusProposed -> json.string("proposed")
    GoalstatusCompleted -> json.string("completed")
    GoalstatusOnhold -> json.string("on-hold")
    GoalstatusActive -> json.string("active")
  }
}

pub fn goalstatus_decoder() -> Decoder(Goalstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "rejected" -> decode.success(GoalstatusRejected)
    "entered-in-error" -> decode.success(GoalstatusEnteredinerror)
    "cancelled" -> decode.success(GoalstatusCancelled)
    "accepted" -> decode.success(GoalstatusAccepted)
    "planned" -> decode.success(GoalstatusPlanned)
    "proposed" -> decode.success(GoalstatusProposed)
    "completed" -> decode.success(GoalstatusCompleted)
    "on-hold" -> decode.success(GoalstatusOnhold)
    "active" -> decode.success(GoalstatusActive)
    _ -> decode.failure(GoalstatusRejected, "Goalstatus")
  }
}

pub type Administrativegender {
  AdministrativegenderUnknown
  AdministrativegenderOther
  AdministrativegenderFemale
  AdministrativegenderMale
}

pub fn administrativegender_to_json(
  administrativegender: Administrativegender,
) -> Json {
  case administrativegender {
    AdministrativegenderUnknown -> json.string("unknown")
    AdministrativegenderOther -> json.string("other")
    AdministrativegenderFemale -> json.string("female")
    AdministrativegenderMale -> json.string("male")
  }
}

pub fn administrativegender_decoder() -> Decoder(Administrativegender) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(AdministrativegenderUnknown)
    "other" -> decode.success(AdministrativegenderOther)
    "female" -> decode.success(AdministrativegenderFemale)
    "male" -> decode.success(AdministrativegenderMale)
    _ -> decode.failure(AdministrativegenderUnknown, "Administrativegender")
  }
}

pub type Historystatus {
  HistorystatusHealthunknown
  HistorystatusEnteredinerror
  HistorystatusCompleted
  HistorystatusPartial
}

pub fn historystatus_to_json(historystatus: Historystatus) -> Json {
  case historystatus {
    HistorystatusHealthunknown -> json.string("health-unknown")
    HistorystatusEnteredinerror -> json.string("entered-in-error")
    HistorystatusCompleted -> json.string("completed")
    HistorystatusPartial -> json.string("partial")
  }
}

pub fn historystatus_decoder() -> Decoder(Historystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "health-unknown" -> decode.success(HistorystatusHealthunknown)
    "entered-in-error" -> decode.success(HistorystatusEnteredinerror)
    "completed" -> decode.success(HistorystatusCompleted)
    "partial" -> decode.success(HistorystatusPartial)
    _ -> decode.failure(HistorystatusHealthunknown, "Historystatus")
  }
}

pub type Participantrequired {
  ParticipantrequiredInformationonly
  ParticipantrequiredOptional
  ParticipantrequiredRequired
}

pub fn participantrequired_to_json(
  participantrequired: Participantrequired,
) -> Json {
  case participantrequired {
    ParticipantrequiredInformationonly -> json.string("information-only")
    ParticipantrequiredOptional -> json.string("optional")
    ParticipantrequiredRequired -> json.string("required")
  }
}

pub fn participantrequired_decoder() -> Decoder(Participantrequired) {
  use variant <- decode.then(decode.string)
  case variant {
    "information-only" -> decode.success(ParticipantrequiredInformationonly)
    "optional" -> decode.success(ParticipantrequiredOptional)
    "required" -> decode.success(ParticipantrequiredRequired)
    _ ->
      decode.failure(ParticipantrequiredInformationonly, "Participantrequired")
  }
}

pub type Visioneyecodes {
  VisioneyecodesLeft
  VisioneyecodesRight
}

pub fn visioneyecodes_to_json(visioneyecodes: Visioneyecodes) -> Json {
  case visioneyecodes {
    VisioneyecodesLeft -> json.string("left")
    VisioneyecodesRight -> json.string("right")
  }
}

pub fn visioneyecodes_decoder() -> Decoder(Visioneyecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "left" -> decode.success(VisioneyecodesLeft)
    "right" -> decode.success(VisioneyecodesRight)
    _ -> decode.failure(VisioneyecodesLeft, "Visioneyecodes")
  }
}

pub type Daysofweek {
  DaysofweekSun
  DaysofweekSat
  DaysofweekFri
  DaysofweekThu
  DaysofweekWed
  DaysofweekTue
  DaysofweekMon
}

pub fn daysofweek_to_json(daysofweek: Daysofweek) -> Json {
  case daysofweek {
    DaysofweekSun -> json.string("sun")
    DaysofweekSat -> json.string("sat")
    DaysofweekFri -> json.string("fri")
    DaysofweekThu -> json.string("thu")
    DaysofweekWed -> json.string("wed")
    DaysofweekTue -> json.string("tue")
    DaysofweekMon -> json.string("mon")
  }
}

pub fn daysofweek_decoder() -> Decoder(Daysofweek) {
  use variant <- decode.then(decode.string)
  case variant {
    "sun" -> decode.success(DaysofweekSun)
    "sat" -> decode.success(DaysofweekSat)
    "fri" -> decode.success(DaysofweekFri)
    "thu" -> decode.success(DaysofweekThu)
    "wed" -> decode.success(DaysofweekWed)
    "tue" -> decode.success(DaysofweekTue)
    "mon" -> decode.success(DaysofweekMon)
    _ -> decode.failure(DaysofweekSun, "Daysofweek")
  }
}

pub type Itemtype {
  ItemtypeQuestion
  ItemtypeDisplay
  ItemtypeGroup
  ItemtypeQuantity
  ItemtypeReference
  ItemtypeAttachment
  ItemtypeOpenchoice
  ItemtypeChoice
  ItemtypeUrl
  ItemtypeText
  ItemtypeString
  ItemtypeTime
  ItemtypeDatetime
  ItemtypeDate
  ItemtypeInteger
  ItemtypeDecimal
  ItemtypeBoolean
}

pub fn itemtype_to_json(itemtype: Itemtype) -> Json {
  case itemtype {
    ItemtypeQuestion -> json.string("question")
    ItemtypeDisplay -> json.string("display")
    ItemtypeGroup -> json.string("group")
    ItemtypeQuantity -> json.string("quantity")
    ItemtypeReference -> json.string("reference")
    ItemtypeAttachment -> json.string("attachment")
    ItemtypeOpenchoice -> json.string("open-choice")
    ItemtypeChoice -> json.string("choice")
    ItemtypeUrl -> json.string("url")
    ItemtypeText -> json.string("text")
    ItemtypeString -> json.string("string")
    ItemtypeTime -> json.string("time")
    ItemtypeDatetime -> json.string("dateTime")
    ItemtypeDate -> json.string("date")
    ItemtypeInteger -> json.string("integer")
    ItemtypeDecimal -> json.string("decimal")
    ItemtypeBoolean -> json.string("boolean")
  }
}

pub fn itemtype_decoder() -> Decoder(Itemtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "question" -> decode.success(ItemtypeQuestion)
    "display" -> decode.success(ItemtypeDisplay)
    "group" -> decode.success(ItemtypeGroup)
    "quantity" -> decode.success(ItemtypeQuantity)
    "reference" -> decode.success(ItemtypeReference)
    "attachment" -> decode.success(ItemtypeAttachment)
    "open-choice" -> decode.success(ItemtypeOpenchoice)
    "choice" -> decode.success(ItemtypeChoice)
    "url" -> decode.success(ItemtypeUrl)
    "text" -> decode.success(ItemtypeText)
    "string" -> decode.success(ItemtypeString)
    "time" -> decode.success(ItemtypeTime)
    "dateTime" -> decode.success(ItemtypeDatetime)
    "date" -> decode.success(ItemtypeDate)
    "integer" -> decode.success(ItemtypeInteger)
    "decimal" -> decode.success(ItemtypeDecimal)
    "boolean" -> decode.success(ItemtypeBoolean)
    _ -> decode.failure(ItemtypeQuestion, "Itemtype")
  }
}

pub type Mapcontexttype {
  MapcontexttypeVariable
  MapcontexttypeType
}

pub fn mapcontexttype_to_json(mapcontexttype: Mapcontexttype) -> Json {
  case mapcontexttype {
    MapcontexttypeVariable -> json.string("variable")
    MapcontexttypeType -> json.string("type")
  }
}

pub fn mapcontexttype_decoder() -> Decoder(Mapcontexttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "variable" -> decode.success(MapcontexttypeVariable)
    "type" -> decode.success(MapcontexttypeType)
    _ -> decode.failure(MapcontexttypeVariable, "Mapcontexttype")
  }
}

pub type Responsecode {
  ResponsecodeFatalerror
  ResponsecodeTransienterror
  ResponsecodeOk
}

pub fn responsecode_to_json(responsecode: Responsecode) -> Json {
  case responsecode {
    ResponsecodeFatalerror -> json.string("fatal-error")
    ResponsecodeTransienterror -> json.string("transient-error")
    ResponsecodeOk -> json.string("ok")
  }
}

pub fn responsecode_decoder() -> Decoder(Responsecode) {
  use variant <- decode.then(decode.string)
  case variant {
    "fatal-error" -> decode.success(ResponsecodeFatalerror)
    "transient-error" -> decode.success(ResponsecodeTransienterror)
    "ok" -> decode.success(ResponsecodeOk)
    _ -> decode.failure(ResponsecodeFatalerror, "Responsecode")
  }
}

pub type Eventtiming {
  EventtimingWake
  EventtimingPcv
  EventtimingPcm
  EventtimingPcd
  EventtimingPc
  EventtimingIcv
  EventtimingIcm
  EventtimingIcd
  EventtimingIc
  EventtimingHs
  EventtimingC
  EventtimingAcv
  EventtimingAcm
  EventtimingAcd
  EventtimingAc
  EventtimingCv
  EventtimingCm
  EventtimingCd
  EventtimingPhs
  EventtimingNight
  EventtimingEvelate
  EventtimingEveearly
  EventtimingEve
  EventtimingAftlate
  EventtimingAftearly
  EventtimingAft
  EventtimingNoon
  EventtimingMornlate
  EventtimingMornearly
  EventtimingMorn
}

pub fn eventtiming_to_json(eventtiming: Eventtiming) -> Json {
  case eventtiming {
    EventtimingWake -> json.string("WAKE")
    EventtimingPcv -> json.string("PCV")
    EventtimingPcm -> json.string("PCM")
    EventtimingPcd -> json.string("PCD")
    EventtimingPc -> json.string("PC")
    EventtimingIcv -> json.string("ICV")
    EventtimingIcm -> json.string("ICM")
    EventtimingIcd -> json.string("ICD")
    EventtimingIc -> json.string("IC")
    EventtimingHs -> json.string("HS")
    EventtimingC -> json.string("C")
    EventtimingAcv -> json.string("ACV")
    EventtimingAcm -> json.string("ACM")
    EventtimingAcd -> json.string("ACD")
    EventtimingAc -> json.string("AC")
    EventtimingCv -> json.string("CV")
    EventtimingCm -> json.string("CM")
    EventtimingCd -> json.string("CD")
    EventtimingPhs -> json.string("PHS")
    EventtimingNight -> json.string("NIGHT")
    EventtimingEvelate -> json.string("EVE.late")
    EventtimingEveearly -> json.string("EVE.early")
    EventtimingEve -> json.string("EVE")
    EventtimingAftlate -> json.string("AFT.late")
    EventtimingAftearly -> json.string("AFT.early")
    EventtimingAft -> json.string("AFT")
    EventtimingNoon -> json.string("NOON")
    EventtimingMornlate -> json.string("MORN.late")
    EventtimingMornearly -> json.string("MORN.early")
    EventtimingMorn -> json.string("MORN")
  }
}

pub fn eventtiming_decoder() -> Decoder(Eventtiming) {
  use variant <- decode.then(decode.string)
  case variant {
    "WAKE" -> decode.success(EventtimingWake)
    "PCV" -> decode.success(EventtimingPcv)
    "PCM" -> decode.success(EventtimingPcm)
    "PCD" -> decode.success(EventtimingPcd)
    "PC" -> decode.success(EventtimingPc)
    "ICV" -> decode.success(EventtimingIcv)
    "ICM" -> decode.success(EventtimingIcm)
    "ICD" -> decode.success(EventtimingIcd)
    "IC" -> decode.success(EventtimingIc)
    "HS" -> decode.success(EventtimingHs)
    "C" -> decode.success(EventtimingC)
    "ACV" -> decode.success(EventtimingAcv)
    "ACM" -> decode.success(EventtimingAcm)
    "ACD" -> decode.success(EventtimingAcd)
    "AC" -> decode.success(EventtimingAc)
    "CV" -> decode.success(EventtimingCv)
    "CM" -> decode.success(EventtimingCm)
    "CD" -> decode.success(EventtimingCd)
    "PHS" -> decode.success(EventtimingPhs)
    "NIGHT" -> decode.success(EventtimingNight)
    "EVE.late" -> decode.success(EventtimingEvelate)
    "EVE.early" -> decode.success(EventtimingEveearly)
    "EVE" -> decode.success(EventtimingEve)
    "AFT.late" -> decode.success(EventtimingAftlate)
    "AFT.early" -> decode.success(EventtimingAftearly)
    "AFT" -> decode.success(EventtimingAft)
    "NOON" -> decode.success(EventtimingNoon)
    "MORN.late" -> decode.success(EventtimingMornlate)
    "MORN.early" -> decode.success(EventtimingMornearly)
    "MORN" -> decode.success(EventtimingMorn)
    _ -> decode.failure(EventtimingWake, "Eventtiming")
  }
}

pub type Groupmeasure {
  GroupmeasureMedianofmedian
  GroupmeasureMedianofmean
  GroupmeasureMeanofmedian
  GroupmeasureMeanofmean
  GroupmeasureMedian
  GroupmeasureMean
}

pub fn groupmeasure_to_json(groupmeasure: Groupmeasure) -> Json {
  case groupmeasure {
    GroupmeasureMedianofmedian -> json.string("median-of-median")
    GroupmeasureMedianofmean -> json.string("median-of-mean")
    GroupmeasureMeanofmedian -> json.string("mean-of-median")
    GroupmeasureMeanofmean -> json.string("mean-of-mean")
    GroupmeasureMedian -> json.string("median")
    GroupmeasureMean -> json.string("mean")
  }
}

pub fn groupmeasure_decoder() -> Decoder(Groupmeasure) {
  use variant <- decode.then(decode.string)
  case variant {
    "median-of-median" -> decode.success(GroupmeasureMedianofmedian)
    "median-of-mean" -> decode.success(GroupmeasureMedianofmean)
    "mean-of-median" -> decode.success(GroupmeasureMeanofmedian)
    "mean-of-mean" -> decode.success(GroupmeasureMeanofmean)
    "median" -> decode.success(GroupmeasureMedian)
    "mean" -> decode.success(GroupmeasureMean)
    _ -> decode.failure(GroupmeasureMedianofmedian, "Groupmeasure")
  }
}

pub type Referenceversionrules {
  ReferenceversionrulesSpecific
  ReferenceversionrulesIndependent
  ReferenceversionrulesEither
}

pub fn referenceversionrules_to_json(
  referenceversionrules: Referenceversionrules,
) -> Json {
  case referenceversionrules {
    ReferenceversionrulesSpecific -> json.string("specific")
    ReferenceversionrulesIndependent -> json.string("independent")
    ReferenceversionrulesEither -> json.string("either")
  }
}

pub fn referenceversionrules_decoder() -> Decoder(Referenceversionrules) {
  use variant <- decode.then(decode.string)
  case variant {
    "specific" -> decode.success(ReferenceversionrulesSpecific)
    "independent" -> decode.success(ReferenceversionrulesIndependent)
    "either" -> decode.success(ReferenceversionrulesEither)
    _ -> decode.failure(ReferenceversionrulesSpecific, "Referenceversionrules")
  }
}

pub type Reportactionresultcodes {
  ReportactionresultcodesError
  ReportactionresultcodesWarning
  ReportactionresultcodesFail
  ReportactionresultcodesSkip
  ReportactionresultcodesPass
}

pub fn reportactionresultcodes_to_json(
  reportactionresultcodes: Reportactionresultcodes,
) -> Json {
  case reportactionresultcodes {
    ReportactionresultcodesError -> json.string("error")
    ReportactionresultcodesWarning -> json.string("warning")
    ReportactionresultcodesFail -> json.string("fail")
    ReportactionresultcodesSkip -> json.string("skip")
    ReportactionresultcodesPass -> json.string("pass")
  }
}

pub fn reportactionresultcodes_decoder() -> Decoder(Reportactionresultcodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "error" -> decode.success(ReportactionresultcodesError)
    "warning" -> decode.success(ReportactionresultcodesWarning)
    "fail" -> decode.success(ReportactionresultcodesFail)
    "skip" -> decode.success(ReportactionresultcodesSkip)
    "pass" -> decode.success(ReportactionresultcodesPass)
    _ -> decode.failure(ReportactionresultcodesError, "Reportactionresultcodes")
  }
}

pub type Mapgrouptypemode {
  MapgrouptypemodeTypeandtypes
  MapgrouptypemodeTypes
  MapgrouptypemodeNone
}

pub fn mapgrouptypemode_to_json(mapgrouptypemode: Mapgrouptypemode) -> Json {
  case mapgrouptypemode {
    MapgrouptypemodeTypeandtypes -> json.string("type-and-types")
    MapgrouptypemodeTypes -> json.string("types")
    MapgrouptypemodeNone -> json.string("none")
  }
}

pub fn mapgrouptypemode_decoder() -> Decoder(Mapgrouptypemode) {
  use variant <- decode.then(decode.string)
  case variant {
    "type-and-types" -> decode.success(MapgrouptypemodeTypeandtypes)
    "types" -> decode.success(MapgrouptypemodeTypes)
    "none" -> decode.success(MapgrouptypemodeNone)
    _ -> decode.failure(MapgrouptypemodeTypeandtypes, "Mapgrouptypemode")
  }
}

pub type Permitteddatatype {
  PermitteddatatypePeriod
  PermitteddatatypeDatetime
  PermitteddatatypeTime
  PermitteddatatypeSampleddata
  PermitteddatatypeRatio
  PermitteddatatypeRange
  PermitteddatatypeInteger
  PermitteddatatypeBoolean
  PermitteddatatypeString
  PermitteddatatypeCodeableconcept
  PermitteddatatypeQuantity
}

pub fn permitteddatatype_to_json(permitteddatatype: Permitteddatatype) -> Json {
  case permitteddatatype {
    PermitteddatatypePeriod -> json.string("Period")
    PermitteddatatypeDatetime -> json.string("dateTime")
    PermitteddatatypeTime -> json.string("time")
    PermitteddatatypeSampleddata -> json.string("SampledData")
    PermitteddatatypeRatio -> json.string("Ratio")
    PermitteddatatypeRange -> json.string("Range")
    PermitteddatatypeInteger -> json.string("integer")
    PermitteddatatypeBoolean -> json.string("boolean")
    PermitteddatatypeString -> json.string("string")
    PermitteddatatypeCodeableconcept -> json.string("CodeableConcept")
    PermitteddatatypeQuantity -> json.string("Quantity")
  }
}

pub fn permitteddatatype_decoder() -> Decoder(Permitteddatatype) {
  use variant <- decode.then(decode.string)
  case variant {
    "Period" -> decode.success(PermitteddatatypePeriod)
    "dateTime" -> decode.success(PermitteddatatypeDatetime)
    "time" -> decode.success(PermitteddatatypeTime)
    "SampledData" -> decode.success(PermitteddatatypeSampleddata)
    "Ratio" -> decode.success(PermitteddatatypeRatio)
    "Range" -> decode.success(PermitteddatatypeRange)
    "integer" -> decode.success(PermitteddatatypeInteger)
    "boolean" -> decode.success(PermitteddatatypeBoolean)
    "string" -> decode.success(PermitteddatatypeString)
    "CodeableConcept" -> decode.success(PermitteddatatypeCodeableconcept)
    "Quantity" -> decode.success(PermitteddatatypeQuantity)
    _ -> decode.failure(PermitteddatatypePeriod, "Permitteddatatype")
  }
}

pub type Participationstatus {
  ParticipationstatusNeedsaction
  ParticipationstatusTentative
  ParticipationstatusDeclined
  ParticipationstatusAccepted
}

pub fn participationstatus_to_json(
  participationstatus: Participationstatus,
) -> Json {
  case participationstatus {
    ParticipationstatusNeedsaction -> json.string("needs-action")
    ParticipationstatusTentative -> json.string("tentative")
    ParticipationstatusDeclined -> json.string("declined")
    ParticipationstatusAccepted -> json.string("accepted")
  }
}

pub fn participationstatus_decoder() -> Decoder(Participationstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "needs-action" -> decode.success(ParticipationstatusNeedsaction)
    "tentative" -> decode.success(ParticipationstatusTentative)
    "declined" -> decode.success(ParticipationstatusDeclined)
    "accepted" -> decode.success(ParticipationstatusAccepted)
    _ -> decode.failure(ParticipationstatusNeedsaction, "Participationstatus")
  }
}

pub type Compositionattestationmode {
  CompositionattestationmodeOfficial
  CompositionattestationmodeLegal
  CompositionattestationmodeProfessional
  CompositionattestationmodePersonal
}

pub fn compositionattestationmode_to_json(
  compositionattestationmode: Compositionattestationmode,
) -> Json {
  case compositionattestationmode {
    CompositionattestationmodeOfficial -> json.string("official")
    CompositionattestationmodeLegal -> json.string("legal")
    CompositionattestationmodeProfessional -> json.string("professional")
    CompositionattestationmodePersonal -> json.string("personal")
  }
}

pub fn compositionattestationmode_decoder() -> Decoder(
  Compositionattestationmode,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "official" -> decode.success(CompositionattestationmodeOfficial)
    "legal" -> decode.success(CompositionattestationmodeLegal)
    "professional" -> decode.success(CompositionattestationmodeProfessional)
    "personal" -> decode.success(CompositionattestationmodePersonal)
    _ ->
      decode.failure(
        CompositionattestationmodeOfficial,
        "Compositionattestationmode",
      )
  }
}

pub type Auditeventoutcome {
  Auditeventoutcome12
  Auditeventoutcome8
  Auditeventoutcome4
  Auditeventoutcome0
}

pub fn auditeventoutcome_to_json(auditeventoutcome: Auditeventoutcome) -> Json {
  case auditeventoutcome {
    Auditeventoutcome12 -> json.string("12")
    Auditeventoutcome8 -> json.string("8")
    Auditeventoutcome4 -> json.string("4")
    Auditeventoutcome0 -> json.string("0")
  }
}

pub fn auditeventoutcome_decoder() -> Decoder(Auditeventoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "12" -> decode.success(Auditeventoutcome12)
    "8" -> decode.success(Auditeventoutcome8)
    "4" -> decode.success(Auditeventoutcome4)
    "0" -> decode.success(Auditeventoutcome0)
    _ -> decode.failure(Auditeventoutcome12, "Auditeventoutcome")
  }
}

pub type Spdxlicense {
  SpdxlicenseZpl21
  SpdxlicenseZpl20
  SpdxlicenseZpl11
  SpdxlicenseZlib
  SpdxlicenseZlibacknowledgement
  SpdxlicenseZimbra14
  SpdxlicenseZimbra13
  SpdxlicenseZend20
  SpdxlicenseZed
  SpdxlicenseYpl11
  SpdxlicenseYpl10
  SpdxlicenseXskat
  SpdxlicenseXpp
  SpdxlicenseXnet
  SpdxlicenseXinetd
  SpdxlicenseXfree8611
  SpdxlicenseXerox
  SpdxlicenseX11
  SpdxlicenseWtfpl
  SpdxlicenseWsuipa
  SpdxlicenseWatcom10
  SpdxlicenseW3c
  SpdxlicenseW3c20150513
  SpdxlicenseW3c19980720
  SpdxlicenseVsl10
  SpdxlicenseVostrom
  SpdxlicenseVim
  SpdxlicenseUpl10
  SpdxlicenseUnlicense
  SpdxlicenseUnicodetou
  SpdxlicenseUnicodedfs2016
  SpdxlicenseUnicodedfs2015
  SpdxlicenseTosl
  SpdxlicenseTorque11
  SpdxlicenseTmate
  SpdxlicenseTcpwrappers
  SpdxlicenseTcl
  SpdxlicenseSwl
  SpdxlicenseSugarcrm113
  SpdxlicenseSpl10
  SpdxlicenseSpencer99
  SpdxlicenseSpencer94
  SpdxlicenseSpencer86
  SpdxlicenseSnia
  SpdxlicenseSmppl
  SpdxlicenseSmlnj
  SpdxlicenseSleepycat
  SpdxlicenseSissl
  SpdxlicenseSissl12
  SpdxlicenseSimpl20
  SpdxlicenseSgib20
  SpdxlicenseSgib11
  SpdxlicenseSgib10
  SpdxlicenseSendmail
  SpdxlicenseScea
  SpdxlicenseSaxpath
  SpdxlicenseSaxpd
  SpdxlicenseRuby
  SpdxlicenseRscpl
  SpdxlicenseRsamd
  SpdxlicenseRpsl10
  SpdxlicenseRpl15
  SpdxlicenseRpl11
  SpdxlicenseRhecos11
  SpdxlicenseRdisc
  SpdxlicenseQpl10
  SpdxlicenseQhull
  SpdxlicensePython20
  SpdxlicensePsutils
  SpdxlicensePsfrag
  SpdxlicensePostgresql
  SpdxlicensePlexus
  SpdxlicensePhp301
  SpdxlicensePhp30
  SpdxlicensePddl10
  SpdxlicenseOsl30
  SpdxlicenseOsl21
  SpdxlicenseOsl20
  SpdxlicenseOsl11
  SpdxlicenseOsl10
  SpdxlicenseOsetpl21
  SpdxlicenseOpl10
  SpdxlicenseOpenssl
  SpdxlicenseOml
  SpdxlicenseOldap28
  SpdxlicenseOldap27
  SpdxlicenseOldap26
  SpdxlicenseOldap25
  SpdxlicenseOldap24
  SpdxlicenseOldap23
  SpdxlicenseOldap22
  SpdxlicenseOldap222
  SpdxlicenseOldap221
  SpdxlicenseOldap21
  SpdxlicenseOldap20
  SpdxlicenseOldap201
  SpdxlicenseOldap14
  SpdxlicenseOldap13
  SpdxlicenseOldap12
  SpdxlicenseOldap11
  SpdxlicenseOgtsl
  SpdxlicenseOfl11
  SpdxlicenseOfl10
  SpdxlicenseOdbl10
  SpdxlicenseOclc20
  SpdxlicenseOcctpl
  SpdxlicenseNtp
  SpdxlicenseNrl
  SpdxlicenseNposl30
  SpdxlicenseNpl11
  SpdxlicenseNpl10
  SpdxlicenseNoweb
  SpdxlicenseNosl
  SpdxlicenseNokia
  SpdxlicenseNlpl
  SpdxlicenseNlod10
  SpdxlicenseNgpl
  SpdxlicenseNewsletr
  SpdxlicenseNetcdf
  SpdxlicenseNetsnmp
  SpdxlicenseNcsa
  SpdxlicenseNbpl10
  SpdxlicenseNaumen
  SpdxlicenseNasa13
  SpdxlicenseMup
  SpdxlicenseMultics
  SpdxlicenseMtll
  SpdxlicenseMsrl
  SpdxlicenseMspl
  SpdxlicenseMpl20
  SpdxlicenseMpl20nocopyleftexception
  SpdxlicenseMpl11
  SpdxlicenseMpl10
  SpdxlicenseMpich2
  SpdxlicenseMotosoto
  SpdxlicenseMitnfa
  SpdxlicenseMit
  SpdxlicenseMitfeh
  SpdxlicenseMitenna
  SpdxlicenseMitcmu
  SpdxlicenseMitadvertising
  SpdxlicenseMit0
  SpdxlicenseMiros
  SpdxlicenseMakeindex
  SpdxlicenseLppl13c
  SpdxlicenseLppl13a
  SpdxlicenseLppl12
  SpdxlicenseLppl11
  SpdxlicenseLppl10
  SpdxlicenseLpl102
  SpdxlicenseLpl10
  SpdxlicenseLinuxopenib
  SpdxlicenseLiliqrplus11
  SpdxlicenseLiliqr11
  SpdxlicenseLiliqp11
  SpdxlicenseLibtiff
  SpdxlicenseLibpng
  SpdxlicenseLgpllr
  SpdxlicenseLgpl30orlater
  SpdxlicenseLgpl30only
  SpdxlicenseLgpl21orlater
  SpdxlicenseLgpl21only
  SpdxlicenseLgpl20orlater
  SpdxlicenseLgpl20only
  SpdxlicenseLeptonica
  SpdxlicenseLatex2e
  SpdxlicenseLal13
  SpdxlicenseLal12
  SpdxlicenseJson
  SpdxlicenseJasper20
  SpdxlicenseIsc
  SpdxlicenseIpl10
  SpdxlicenseIpa
  SpdxlicenseInterbase10
  SpdxlicenseIntel
  SpdxlicenseIntelacpi
  SpdxlicenseInfozip
  SpdxlicenseImlib2
  SpdxlicenseImatix
  SpdxlicenseImagemagick
  SpdxlicenseIjg
  SpdxlicenseIcu
  SpdxlicenseIbmpibs
  SpdxlicenseHpnd
  SpdxlicenseHaskellreport
  SpdxlicenseGsoap13b
  SpdxlicenseGpl30orlater
  SpdxlicenseGpl30only
  SpdxlicenseGpl20orlater
  SpdxlicenseGpl20only
  SpdxlicenseGpl10orlater
  SpdxlicenseGpl10only
  SpdxlicenseGnuplot
  SpdxlicenseGlulxe
  SpdxlicenseGlide
  SpdxlicenseGl2ps
  SpdxlicenseGiftware
  SpdxlicenseGfdl13orlater
  SpdxlicenseGfdl13only
  SpdxlicenseGfdl12orlater
  SpdxlicenseGfdl12only
  SpdxlicenseGfdl11orlater
  SpdxlicenseGfdl11only
  SpdxlicenseFtl
  SpdxlicenseFsfullr
  SpdxlicenseFsful
  SpdxlicenseFsfap
  SpdxlicenseFreeimage
  SpdxlicenseFrameworx10
  SpdxlicenseFair
  SpdxlicenseEurosym
  SpdxlicenseEupl12
  SpdxlicenseEupl11
  SpdxlicenseEupl10
  SpdxlicenseEudatagrid
  SpdxlicenseErlpl11
  SpdxlicenseEpl20
  SpdxlicenseEpl10
  SpdxlicenseEntessa
  SpdxlicenseEgenix
  SpdxlicenseEfl20
  SpdxlicenseEfl10
  SpdxlicenseEcl20
  SpdxlicenseEcl10
  SpdxlicenseDvipdfm
  SpdxlicenseDsdp
  SpdxlicenseDotseqn
  SpdxlicenseDoc
  SpdxlicenseDiffmark
  SpdxlicenseDfsl10
  SpdxlicenseCurl
  SpdxlicenseCube
  SpdxlicenseCuaopl10
  SpdxlicenseCrystalstacker
  SpdxlicenseCrossword
  SpdxlicenseCpol102
  SpdxlicenseCpl10
  SpdxlicenseCpal10
  SpdxlicenseCondor11
  SpdxlicenseCnripython
  SpdxlicenseCnripythongplcompatible
  SpdxlicenseCnrijython
  SpdxlicenseClartistic
  SpdxlicenseCecillc
  SpdxlicenseCecillb
  SpdxlicenseCecill21
  SpdxlicenseCecill20
  SpdxlicenseCecill11
  SpdxlicenseCecill10
  SpdxlicenseCdlasharing10
  SpdxlicenseCdlapermissive10
  SpdxlicenseCddl11
  SpdxlicenseCddl10
  SpdxlicenseCc010
  SpdxlicenseCcbysa40
  SpdxlicenseCcbysa30
  SpdxlicenseCcbysa25
  SpdxlicenseCcbysa20
  SpdxlicenseCcbysa10
  SpdxlicenseCcbynd40
  SpdxlicenseCcbynd30
  SpdxlicenseCcbynd25
  SpdxlicenseCcbynd20
  SpdxlicenseCcbynd10
  SpdxlicenseCcbyncsa40
  SpdxlicenseCcbyncsa30
  SpdxlicenseCcbyncsa25
  SpdxlicenseCcbyncsa20
  SpdxlicenseCcbyncsa10
  SpdxlicenseCcbyncnd40
  SpdxlicenseCcbyncnd30
  SpdxlicenseCcbyncnd25
  SpdxlicenseCcbyncnd20
  SpdxlicenseCcbyncnd10
  SpdxlicenseCcbync40
  SpdxlicenseCcbync30
  SpdxlicenseCcbync25
  SpdxlicenseCcbync20
  SpdxlicenseCcbync10
  SpdxlicenseCcby40
  SpdxlicenseCcby30
  SpdxlicenseCcby25
  SpdxlicenseCcby20
  SpdxlicenseCcby10
  SpdxlicenseCatosl11
  SpdxlicenseCaldera
  SpdxlicenseBzip2106
  SpdxlicenseBzip2105
  SpdxlicenseBsl10
  SpdxlicenseBsdsourcecode
  SpdxlicenseBsdprotection
  SpdxlicenseBsd4clause
  SpdxlicenseBsd4clauseuc
  SpdxlicenseBsd3clause
  SpdxlicenseBsd3clausenonuclearwarranty
  SpdxlicenseBsd3clausenonuclearlicense
  SpdxlicenseBsd3clausenonuclearlicense2014
  SpdxlicenseBsd3clauselbnl
  SpdxlicenseBsd3clauseclear
  SpdxlicenseBsd3clauseattribution
  SpdxlicenseBsd2clause
  SpdxlicenseBsd2clausepatent
  SpdxlicenseBsd2clausenetbsd
  SpdxlicenseBsd2clausefreebsd
  SpdxlicenseBsd1clause
  SpdxlicenseBorceux
  SpdxlicenseBittorrent11
  SpdxlicenseBittorrent10
  SpdxlicenseBeerware
  SpdxlicenseBarr
  SpdxlicenseBahyph
  SpdxlicenseArtistic20
  SpdxlicenseArtistic10
  SpdxlicenseArtistic10perl
  SpdxlicenseArtistic10cl8
  SpdxlicenseApsl20
  SpdxlicenseApsl12
  SpdxlicenseApsl11
  SpdxlicenseApsl10
  SpdxlicenseApl10
  SpdxlicenseApafml
  SpdxlicenseApache20
  SpdxlicenseApache11
  SpdxlicenseApache10
  SpdxlicenseAntlrpd
  SpdxlicenseAmpas
  SpdxlicenseAml
  SpdxlicenseAmdplpa
  SpdxlicenseAladdin
  SpdxlicenseAgpl30orlater
  SpdxlicenseAgpl30only
  SpdxlicenseAgpl10orlater
  SpdxlicenseAgpl10only
  SpdxlicenseAfmparse
  SpdxlicenseAfl30
  SpdxlicenseAfl21
  SpdxlicenseAfl20
  SpdxlicenseAfl12
  SpdxlicenseAfl11
  SpdxlicenseAdsl
  SpdxlicenseAdobeglyph
  SpdxlicenseAdobe2006
  SpdxlicenseAbstyles
  SpdxlicenseAal
  Spdxlicense0bsd
  SpdxlicenseNotopensource
}

pub fn spdxlicense_to_json(spdxlicense: Spdxlicense) -> Json {
  case spdxlicense {
    SpdxlicenseZpl21 -> json.string("ZPL-2.1")
    SpdxlicenseZpl20 -> json.string("ZPL-2.0")
    SpdxlicenseZpl11 -> json.string("ZPL-1.1")
    SpdxlicenseZlib -> json.string("Zlib")
    SpdxlicenseZlibacknowledgement -> json.string("zlib-acknowledgement")
    SpdxlicenseZimbra14 -> json.string("Zimbra-1.4")
    SpdxlicenseZimbra13 -> json.string("Zimbra-1.3")
    SpdxlicenseZend20 -> json.string("Zend-2.0")
    SpdxlicenseZed -> json.string("Zed")
    SpdxlicenseYpl11 -> json.string("YPL-1.1")
    SpdxlicenseYpl10 -> json.string("YPL-1.0")
    SpdxlicenseXskat -> json.string("XSkat")
    SpdxlicenseXpp -> json.string("xpp")
    SpdxlicenseXnet -> json.string("Xnet")
    SpdxlicenseXinetd -> json.string("xinetd")
    SpdxlicenseXfree8611 -> json.string("XFree86-1.1")
    SpdxlicenseXerox -> json.string("Xerox")
    SpdxlicenseX11 -> json.string("X11")
    SpdxlicenseWtfpl -> json.string("WTFPL")
    SpdxlicenseWsuipa -> json.string("Wsuipa")
    SpdxlicenseWatcom10 -> json.string("Watcom-1.0")
    SpdxlicenseW3c -> json.string("W3C")
    SpdxlicenseW3c20150513 -> json.string("W3C-20150513")
    SpdxlicenseW3c19980720 -> json.string("W3C-19980720")
    SpdxlicenseVsl10 -> json.string("VSL-1.0")
    SpdxlicenseVostrom -> json.string("VOSTROM")
    SpdxlicenseVim -> json.string("Vim")
    SpdxlicenseUpl10 -> json.string("UPL-1.0")
    SpdxlicenseUnlicense -> json.string("Unlicense")
    SpdxlicenseUnicodetou -> json.string("Unicode-TOU")
    SpdxlicenseUnicodedfs2016 -> json.string("Unicode-DFS-2016")
    SpdxlicenseUnicodedfs2015 -> json.string("Unicode-DFS-2015")
    SpdxlicenseTosl -> json.string("TOSL")
    SpdxlicenseTorque11 -> json.string("TORQUE-1.1")
    SpdxlicenseTmate -> json.string("TMate")
    SpdxlicenseTcpwrappers -> json.string("TCP-wrappers")
    SpdxlicenseTcl -> json.string("TCL")
    SpdxlicenseSwl -> json.string("SWL")
    SpdxlicenseSugarcrm113 -> json.string("SugarCRM-1.1.3")
    SpdxlicenseSpl10 -> json.string("SPL-1.0")
    SpdxlicenseSpencer99 -> json.string("Spencer-99")
    SpdxlicenseSpencer94 -> json.string("Spencer-94")
    SpdxlicenseSpencer86 -> json.string("Spencer-86")
    SpdxlicenseSnia -> json.string("SNIA")
    SpdxlicenseSmppl -> json.string("SMPPL")
    SpdxlicenseSmlnj -> json.string("SMLNJ")
    SpdxlicenseSleepycat -> json.string("Sleepycat")
    SpdxlicenseSissl -> json.string("SISSL")
    SpdxlicenseSissl12 -> json.string("SISSL-1.2")
    SpdxlicenseSimpl20 -> json.string("SimPL-2.0")
    SpdxlicenseSgib20 -> json.string("SGI-B-2.0")
    SpdxlicenseSgib11 -> json.string("SGI-B-1.1")
    SpdxlicenseSgib10 -> json.string("SGI-B-1.0")
    SpdxlicenseSendmail -> json.string("Sendmail")
    SpdxlicenseScea -> json.string("SCEA")
    SpdxlicenseSaxpath -> json.string("Saxpath")
    SpdxlicenseSaxpd -> json.string("SAX-PD")
    SpdxlicenseRuby -> json.string("Ruby")
    SpdxlicenseRscpl -> json.string("RSCPL")
    SpdxlicenseRsamd -> json.string("RSA-MD")
    SpdxlicenseRpsl10 -> json.string("RPSL-1.0")
    SpdxlicenseRpl15 -> json.string("RPL-1.5")
    SpdxlicenseRpl11 -> json.string("RPL-1.1")
    SpdxlicenseRhecos11 -> json.string("RHeCos-1.1")
    SpdxlicenseRdisc -> json.string("Rdisc")
    SpdxlicenseQpl10 -> json.string("QPL-1.0")
    SpdxlicenseQhull -> json.string("Qhull")
    SpdxlicensePython20 -> json.string("Python-2.0")
    SpdxlicensePsutils -> json.string("psutils")
    SpdxlicensePsfrag -> json.string("psfrag")
    SpdxlicensePostgresql -> json.string("PostgreSQL")
    SpdxlicensePlexus -> json.string("Plexus")
    SpdxlicensePhp301 -> json.string("PHP-3.01")
    SpdxlicensePhp30 -> json.string("PHP-3.0")
    SpdxlicensePddl10 -> json.string("PDDL-1.0")
    SpdxlicenseOsl30 -> json.string("OSL-3.0")
    SpdxlicenseOsl21 -> json.string("OSL-2.1")
    SpdxlicenseOsl20 -> json.string("OSL-2.0")
    SpdxlicenseOsl11 -> json.string("OSL-1.1")
    SpdxlicenseOsl10 -> json.string("OSL-1.0")
    SpdxlicenseOsetpl21 -> json.string("OSET-PL-2.1")
    SpdxlicenseOpl10 -> json.string("OPL-1.0")
    SpdxlicenseOpenssl -> json.string("OpenSSL")
    SpdxlicenseOml -> json.string("OML")
    SpdxlicenseOldap28 -> json.string("OLDAP-2.8")
    SpdxlicenseOldap27 -> json.string("OLDAP-2.7")
    SpdxlicenseOldap26 -> json.string("OLDAP-2.6")
    SpdxlicenseOldap25 -> json.string("OLDAP-2.5")
    SpdxlicenseOldap24 -> json.string("OLDAP-2.4")
    SpdxlicenseOldap23 -> json.string("OLDAP-2.3")
    SpdxlicenseOldap22 -> json.string("OLDAP-2.2")
    SpdxlicenseOldap222 -> json.string("OLDAP-2.2.2")
    SpdxlicenseOldap221 -> json.string("OLDAP-2.2.1")
    SpdxlicenseOldap21 -> json.string("OLDAP-2.1")
    SpdxlicenseOldap20 -> json.string("OLDAP-2.0")
    SpdxlicenseOldap201 -> json.string("OLDAP-2.0.1")
    SpdxlicenseOldap14 -> json.string("OLDAP-1.4")
    SpdxlicenseOldap13 -> json.string("OLDAP-1.3")
    SpdxlicenseOldap12 -> json.string("OLDAP-1.2")
    SpdxlicenseOldap11 -> json.string("OLDAP-1.1")
    SpdxlicenseOgtsl -> json.string("OGTSL")
    SpdxlicenseOfl11 -> json.string("OFL-1.1")
    SpdxlicenseOfl10 -> json.string("OFL-1.0")
    SpdxlicenseOdbl10 -> json.string("ODbL-1.0")
    SpdxlicenseOclc20 -> json.string("OCLC-2.0")
    SpdxlicenseOcctpl -> json.string("OCCT-PL")
    SpdxlicenseNtp -> json.string("NTP")
    SpdxlicenseNrl -> json.string("NRL")
    SpdxlicenseNposl30 -> json.string("NPOSL-3.0")
    SpdxlicenseNpl11 -> json.string("NPL-1.1")
    SpdxlicenseNpl10 -> json.string("NPL-1.0")
    SpdxlicenseNoweb -> json.string("Noweb")
    SpdxlicenseNosl -> json.string("NOSL")
    SpdxlicenseNokia -> json.string("Nokia")
    SpdxlicenseNlpl -> json.string("NLPL")
    SpdxlicenseNlod10 -> json.string("NLOD-1.0")
    SpdxlicenseNgpl -> json.string("NGPL")
    SpdxlicenseNewsletr -> json.string("Newsletr")
    SpdxlicenseNetcdf -> json.string("NetCDF")
    SpdxlicenseNetsnmp -> json.string("Net-SNMP")
    SpdxlicenseNcsa -> json.string("NCSA")
    SpdxlicenseNbpl10 -> json.string("NBPL-1.0")
    SpdxlicenseNaumen -> json.string("Naumen")
    SpdxlicenseNasa13 -> json.string("NASA-1.3")
    SpdxlicenseMup -> json.string("Mup")
    SpdxlicenseMultics -> json.string("Multics")
    SpdxlicenseMtll -> json.string("MTLL")
    SpdxlicenseMsrl -> json.string("MS-RL")
    SpdxlicenseMspl -> json.string("MS-PL")
    SpdxlicenseMpl20 -> json.string("MPL-2.0")
    SpdxlicenseMpl20nocopyleftexception ->
      json.string("MPL-2.0-no-copyleft-exception")
    SpdxlicenseMpl11 -> json.string("MPL-1.1")
    SpdxlicenseMpl10 -> json.string("MPL-1.0")
    SpdxlicenseMpich2 -> json.string("mpich2")
    SpdxlicenseMotosoto -> json.string("Motosoto")
    SpdxlicenseMitnfa -> json.string("MITNFA")
    SpdxlicenseMit -> json.string("MIT")
    SpdxlicenseMitfeh -> json.string("MIT-feh")
    SpdxlicenseMitenna -> json.string("MIT-enna")
    SpdxlicenseMitcmu -> json.string("MIT-CMU")
    SpdxlicenseMitadvertising -> json.string("MIT-advertising")
    SpdxlicenseMit0 -> json.string("MIT-0")
    SpdxlicenseMiros -> json.string("MirOS")
    SpdxlicenseMakeindex -> json.string("MakeIndex")
    SpdxlicenseLppl13c -> json.string("LPPL-1.3c")
    SpdxlicenseLppl13a -> json.string("LPPL-1.3a")
    SpdxlicenseLppl12 -> json.string("LPPL-1.2")
    SpdxlicenseLppl11 -> json.string("LPPL-1.1")
    SpdxlicenseLppl10 -> json.string("LPPL-1.0")
    SpdxlicenseLpl102 -> json.string("LPL-1.02")
    SpdxlicenseLpl10 -> json.string("LPL-1.0")
    SpdxlicenseLinuxopenib -> json.string("Linux-OpenIB")
    SpdxlicenseLiliqrplus11 -> json.string("LiLiQ-Rplus-1.1")
    SpdxlicenseLiliqr11 -> json.string("LiLiQ-R-1.1")
    SpdxlicenseLiliqp11 -> json.string("LiLiQ-P-1.1")
    SpdxlicenseLibtiff -> json.string("libtiff")
    SpdxlicenseLibpng -> json.string("Libpng")
    SpdxlicenseLgpllr -> json.string("LGPLLR")
    SpdxlicenseLgpl30orlater -> json.string("LGPL-3.0-or-later")
    SpdxlicenseLgpl30only -> json.string("LGPL-3.0-only")
    SpdxlicenseLgpl21orlater -> json.string("LGPL-2.1-or-later")
    SpdxlicenseLgpl21only -> json.string("LGPL-2.1-only")
    SpdxlicenseLgpl20orlater -> json.string("LGPL-2.0-or-later")
    SpdxlicenseLgpl20only -> json.string("LGPL-2.0-only")
    SpdxlicenseLeptonica -> json.string("Leptonica")
    SpdxlicenseLatex2e -> json.string("Latex2e")
    SpdxlicenseLal13 -> json.string("LAL-1.3")
    SpdxlicenseLal12 -> json.string("LAL-1.2")
    SpdxlicenseJson -> json.string("JSON")
    SpdxlicenseJasper20 -> json.string("JasPer-2.0")
    SpdxlicenseIsc -> json.string("ISC")
    SpdxlicenseIpl10 -> json.string("IPL-1.0")
    SpdxlicenseIpa -> json.string("IPA")
    SpdxlicenseInterbase10 -> json.string("Interbase-1.0")
    SpdxlicenseIntel -> json.string("Intel")
    SpdxlicenseIntelacpi -> json.string("Intel-ACPI")
    SpdxlicenseInfozip -> json.string("Info-ZIP")
    SpdxlicenseImlib2 -> json.string("Imlib2")
    SpdxlicenseImatix -> json.string("iMatix")
    SpdxlicenseImagemagick -> json.string("ImageMagick")
    SpdxlicenseIjg -> json.string("IJG")
    SpdxlicenseIcu -> json.string("ICU")
    SpdxlicenseIbmpibs -> json.string("IBM-pibs")
    SpdxlicenseHpnd -> json.string("HPND")
    SpdxlicenseHaskellreport -> json.string("HaskellReport")
    SpdxlicenseGsoap13b -> json.string("gSOAP-1.3b")
    SpdxlicenseGpl30orlater -> json.string("GPL-3.0-or-later")
    SpdxlicenseGpl30only -> json.string("GPL-3.0-only")
    SpdxlicenseGpl20orlater -> json.string("GPL-2.0-or-later")
    SpdxlicenseGpl20only -> json.string("GPL-2.0-only")
    SpdxlicenseGpl10orlater -> json.string("GPL-1.0-or-later")
    SpdxlicenseGpl10only -> json.string("GPL-1.0-only")
    SpdxlicenseGnuplot -> json.string("gnuplot")
    SpdxlicenseGlulxe -> json.string("Glulxe")
    SpdxlicenseGlide -> json.string("Glide")
    SpdxlicenseGl2ps -> json.string("GL2PS")
    SpdxlicenseGiftware -> json.string("Giftware")
    SpdxlicenseGfdl13orlater -> json.string("GFDL-1.3-or-later")
    SpdxlicenseGfdl13only -> json.string("GFDL-1.3-only")
    SpdxlicenseGfdl12orlater -> json.string("GFDL-1.2-or-later")
    SpdxlicenseGfdl12only -> json.string("GFDL-1.2-only")
    SpdxlicenseGfdl11orlater -> json.string("GFDL-1.1-or-later")
    SpdxlicenseGfdl11only -> json.string("GFDL-1.1-only")
    SpdxlicenseFtl -> json.string("FTL")
    SpdxlicenseFsfullr -> json.string("FSFULLR")
    SpdxlicenseFsful -> json.string("FSFUL")
    SpdxlicenseFsfap -> json.string("FSFAP")
    SpdxlicenseFreeimage -> json.string("FreeImage")
    SpdxlicenseFrameworx10 -> json.string("Frameworx-1.0")
    SpdxlicenseFair -> json.string("Fair")
    SpdxlicenseEurosym -> json.string("Eurosym")
    SpdxlicenseEupl12 -> json.string("EUPL-1.2")
    SpdxlicenseEupl11 -> json.string("EUPL-1.1")
    SpdxlicenseEupl10 -> json.string("EUPL-1.0")
    SpdxlicenseEudatagrid -> json.string("EUDatagrid")
    SpdxlicenseErlpl11 -> json.string("ErlPL-1.1")
    SpdxlicenseEpl20 -> json.string("EPL-2.0")
    SpdxlicenseEpl10 -> json.string("EPL-1.0")
    SpdxlicenseEntessa -> json.string("Entessa")
    SpdxlicenseEgenix -> json.string("eGenix")
    SpdxlicenseEfl20 -> json.string("EFL-2.0")
    SpdxlicenseEfl10 -> json.string("EFL-1.0")
    SpdxlicenseEcl20 -> json.string("ECL-2.0")
    SpdxlicenseEcl10 -> json.string("ECL-1.0")
    SpdxlicenseDvipdfm -> json.string("dvipdfm")
    SpdxlicenseDsdp -> json.string("DSDP")
    SpdxlicenseDotseqn -> json.string("Dotseqn")
    SpdxlicenseDoc -> json.string("DOC")
    SpdxlicenseDiffmark -> json.string("diffmark")
    SpdxlicenseDfsl10 -> json.string("D-FSL-1.0")
    SpdxlicenseCurl -> json.string("curl")
    SpdxlicenseCube -> json.string("Cube")
    SpdxlicenseCuaopl10 -> json.string("CUA-OPL-1.0")
    SpdxlicenseCrystalstacker -> json.string("CrystalStacker")
    SpdxlicenseCrossword -> json.string("Crossword")
    SpdxlicenseCpol102 -> json.string("CPOL-1.02")
    SpdxlicenseCpl10 -> json.string("CPL-1.0")
    SpdxlicenseCpal10 -> json.string("CPAL-1.0")
    SpdxlicenseCondor11 -> json.string("Condor-1.1")
    SpdxlicenseCnripython -> json.string("CNRI-Python")
    SpdxlicenseCnripythongplcompatible ->
      json.string("CNRI-Python-GPL-Compatible")
    SpdxlicenseCnrijython -> json.string("CNRI-Jython")
    SpdxlicenseClartistic -> json.string("ClArtistic")
    SpdxlicenseCecillc -> json.string("CECILL-C")
    SpdxlicenseCecillb -> json.string("CECILL-B")
    SpdxlicenseCecill21 -> json.string("CECILL-2.1")
    SpdxlicenseCecill20 -> json.string("CECILL-2.0")
    SpdxlicenseCecill11 -> json.string("CECILL-1.1")
    SpdxlicenseCecill10 -> json.string("CECILL-1.0")
    SpdxlicenseCdlasharing10 -> json.string("CDLA-Sharing-1.0")
    SpdxlicenseCdlapermissive10 -> json.string("CDLA-Permissive-1.0")
    SpdxlicenseCddl11 -> json.string("CDDL-1.1")
    SpdxlicenseCddl10 -> json.string("CDDL-1.0")
    SpdxlicenseCc010 -> json.string("CC0-1.0")
    SpdxlicenseCcbysa40 -> json.string("CC-BY-SA-4.0")
    SpdxlicenseCcbysa30 -> json.string("CC-BY-SA-3.0")
    SpdxlicenseCcbysa25 -> json.string("CC-BY-SA-2.5")
    SpdxlicenseCcbysa20 -> json.string("CC-BY-SA-2.0")
    SpdxlicenseCcbysa10 -> json.string("CC-BY-SA-1.0")
    SpdxlicenseCcbynd40 -> json.string("CC-BY-ND-4.0")
    SpdxlicenseCcbynd30 -> json.string("CC-BY-ND-3.0")
    SpdxlicenseCcbynd25 -> json.string("CC-BY-ND-2.5")
    SpdxlicenseCcbynd20 -> json.string("CC-BY-ND-2.0")
    SpdxlicenseCcbynd10 -> json.string("CC-BY-ND-1.0")
    SpdxlicenseCcbyncsa40 -> json.string("CC-BY-NC-SA-4.0")
    SpdxlicenseCcbyncsa30 -> json.string("CC-BY-NC-SA-3.0")
    SpdxlicenseCcbyncsa25 -> json.string("CC-BY-NC-SA-2.5")
    SpdxlicenseCcbyncsa20 -> json.string("CC-BY-NC-SA-2.0")
    SpdxlicenseCcbyncsa10 -> json.string("CC-BY-NC-SA-1.0")
    SpdxlicenseCcbyncnd40 -> json.string("CC-BY-NC-ND-4.0")
    SpdxlicenseCcbyncnd30 -> json.string("CC-BY-NC-ND-3.0")
    SpdxlicenseCcbyncnd25 -> json.string("CC-BY-NC-ND-2.5")
    SpdxlicenseCcbyncnd20 -> json.string("CC-BY-NC-ND-2.0")
    SpdxlicenseCcbyncnd10 -> json.string("CC-BY-NC-ND-1.0")
    SpdxlicenseCcbync40 -> json.string("CC-BY-NC-4.0")
    SpdxlicenseCcbync30 -> json.string("CC-BY-NC-3.0")
    SpdxlicenseCcbync25 -> json.string("CC-BY-NC-2.5")
    SpdxlicenseCcbync20 -> json.string("CC-BY-NC-2.0")
    SpdxlicenseCcbync10 -> json.string("CC-BY-NC-1.0")
    SpdxlicenseCcby40 -> json.string("CC-BY-4.0")
    SpdxlicenseCcby30 -> json.string("CC-BY-3.0")
    SpdxlicenseCcby25 -> json.string("CC-BY-2.5")
    SpdxlicenseCcby20 -> json.string("CC-BY-2.0")
    SpdxlicenseCcby10 -> json.string("CC-BY-1.0")
    SpdxlicenseCatosl11 -> json.string("CATOSL-1.1")
    SpdxlicenseCaldera -> json.string("Caldera")
    SpdxlicenseBzip2106 -> json.string("bzip2-1.0.6")
    SpdxlicenseBzip2105 -> json.string("bzip2-1.0.5")
    SpdxlicenseBsl10 -> json.string("BSL-1.0")
    SpdxlicenseBsdsourcecode -> json.string("BSD-Source-Code")
    SpdxlicenseBsdprotection -> json.string("BSD-Protection")
    SpdxlicenseBsd4clause -> json.string("BSD-4-Clause")
    SpdxlicenseBsd4clauseuc -> json.string("BSD-4-Clause-UC")
    SpdxlicenseBsd3clause -> json.string("BSD-3-Clause")
    SpdxlicenseBsd3clausenonuclearwarranty ->
      json.string("BSD-3-Clause-No-Nuclear-Warranty")
    SpdxlicenseBsd3clausenonuclearlicense ->
      json.string("BSD-3-Clause-No-Nuclear-License")
    SpdxlicenseBsd3clausenonuclearlicense2014 ->
      json.string("BSD-3-Clause-No-Nuclear-License-2014")
    SpdxlicenseBsd3clauselbnl -> json.string("BSD-3-Clause-LBNL")
    SpdxlicenseBsd3clauseclear -> json.string("BSD-3-Clause-Clear")
    SpdxlicenseBsd3clauseattribution -> json.string("BSD-3-Clause-Attribution")
    SpdxlicenseBsd2clause -> json.string("BSD-2-Clause")
    SpdxlicenseBsd2clausepatent -> json.string("BSD-2-Clause-Patent")
    SpdxlicenseBsd2clausenetbsd -> json.string("BSD-2-Clause-NetBSD")
    SpdxlicenseBsd2clausefreebsd -> json.string("BSD-2-Clause-FreeBSD")
    SpdxlicenseBsd1clause -> json.string("BSD-1-Clause")
    SpdxlicenseBorceux -> json.string("Borceux")
    SpdxlicenseBittorrent11 -> json.string("BitTorrent-1.1")
    SpdxlicenseBittorrent10 -> json.string("BitTorrent-1.0")
    SpdxlicenseBeerware -> json.string("Beerware")
    SpdxlicenseBarr -> json.string("Barr")
    SpdxlicenseBahyph -> json.string("Bahyph")
    SpdxlicenseArtistic20 -> json.string("Artistic-2.0")
    SpdxlicenseArtistic10 -> json.string("Artistic-1.0")
    SpdxlicenseArtistic10perl -> json.string("Artistic-1.0-Perl")
    SpdxlicenseArtistic10cl8 -> json.string("Artistic-1.0-cl8")
    SpdxlicenseApsl20 -> json.string("APSL-2.0")
    SpdxlicenseApsl12 -> json.string("APSL-1.2")
    SpdxlicenseApsl11 -> json.string("APSL-1.1")
    SpdxlicenseApsl10 -> json.string("APSL-1.0")
    SpdxlicenseApl10 -> json.string("APL-1.0")
    SpdxlicenseApafml -> json.string("APAFML")
    SpdxlicenseApache20 -> json.string("Apache-2.0")
    SpdxlicenseApache11 -> json.string("Apache-1.1")
    SpdxlicenseApache10 -> json.string("Apache-1.0")
    SpdxlicenseAntlrpd -> json.string("ANTLR-PD")
    SpdxlicenseAmpas -> json.string("AMPAS")
    SpdxlicenseAml -> json.string("AML")
    SpdxlicenseAmdplpa -> json.string("AMDPLPA")
    SpdxlicenseAladdin -> json.string("Aladdin")
    SpdxlicenseAgpl30orlater -> json.string("AGPL-3.0-or-later")
    SpdxlicenseAgpl30only -> json.string("AGPL-3.0-only")
    SpdxlicenseAgpl10orlater -> json.string("AGPL-1.0-or-later")
    SpdxlicenseAgpl10only -> json.string("AGPL-1.0-only")
    SpdxlicenseAfmparse -> json.string("Afmparse")
    SpdxlicenseAfl30 -> json.string("AFL-3.0")
    SpdxlicenseAfl21 -> json.string("AFL-2.1")
    SpdxlicenseAfl20 -> json.string("AFL-2.0")
    SpdxlicenseAfl12 -> json.string("AFL-1.2")
    SpdxlicenseAfl11 -> json.string("AFL-1.1")
    SpdxlicenseAdsl -> json.string("ADSL")
    SpdxlicenseAdobeglyph -> json.string("Adobe-Glyph")
    SpdxlicenseAdobe2006 -> json.string("Adobe-2006")
    SpdxlicenseAbstyles -> json.string("Abstyles")
    SpdxlicenseAal -> json.string("AAL")
    Spdxlicense0bsd -> json.string("0BSD")
    SpdxlicenseNotopensource -> json.string("not-open-source")
  }
}

pub fn spdxlicense_decoder() -> Decoder(Spdxlicense) {
  use variant <- decode.then(decode.string)
  case variant {
    "ZPL-2.1" -> decode.success(SpdxlicenseZpl21)
    "ZPL-2.0" -> decode.success(SpdxlicenseZpl20)
    "ZPL-1.1" -> decode.success(SpdxlicenseZpl11)
    "Zlib" -> decode.success(SpdxlicenseZlib)
    "zlib-acknowledgement" -> decode.success(SpdxlicenseZlibacknowledgement)
    "Zimbra-1.4" -> decode.success(SpdxlicenseZimbra14)
    "Zimbra-1.3" -> decode.success(SpdxlicenseZimbra13)
    "Zend-2.0" -> decode.success(SpdxlicenseZend20)
    "Zed" -> decode.success(SpdxlicenseZed)
    "YPL-1.1" -> decode.success(SpdxlicenseYpl11)
    "YPL-1.0" -> decode.success(SpdxlicenseYpl10)
    "XSkat" -> decode.success(SpdxlicenseXskat)
    "xpp" -> decode.success(SpdxlicenseXpp)
    "Xnet" -> decode.success(SpdxlicenseXnet)
    "xinetd" -> decode.success(SpdxlicenseXinetd)
    "XFree86-1.1" -> decode.success(SpdxlicenseXfree8611)
    "Xerox" -> decode.success(SpdxlicenseXerox)
    "X11" -> decode.success(SpdxlicenseX11)
    "WTFPL" -> decode.success(SpdxlicenseWtfpl)
    "Wsuipa" -> decode.success(SpdxlicenseWsuipa)
    "Watcom-1.0" -> decode.success(SpdxlicenseWatcom10)
    "W3C" -> decode.success(SpdxlicenseW3c)
    "W3C-20150513" -> decode.success(SpdxlicenseW3c20150513)
    "W3C-19980720" -> decode.success(SpdxlicenseW3c19980720)
    "VSL-1.0" -> decode.success(SpdxlicenseVsl10)
    "VOSTROM" -> decode.success(SpdxlicenseVostrom)
    "Vim" -> decode.success(SpdxlicenseVim)
    "UPL-1.0" -> decode.success(SpdxlicenseUpl10)
    "Unlicense" -> decode.success(SpdxlicenseUnlicense)
    "Unicode-TOU" -> decode.success(SpdxlicenseUnicodetou)
    "Unicode-DFS-2016" -> decode.success(SpdxlicenseUnicodedfs2016)
    "Unicode-DFS-2015" -> decode.success(SpdxlicenseUnicodedfs2015)
    "TOSL" -> decode.success(SpdxlicenseTosl)
    "TORQUE-1.1" -> decode.success(SpdxlicenseTorque11)
    "TMate" -> decode.success(SpdxlicenseTmate)
    "TCP-wrappers" -> decode.success(SpdxlicenseTcpwrappers)
    "TCL" -> decode.success(SpdxlicenseTcl)
    "SWL" -> decode.success(SpdxlicenseSwl)
    "SugarCRM-1.1.3" -> decode.success(SpdxlicenseSugarcrm113)
    "SPL-1.0" -> decode.success(SpdxlicenseSpl10)
    "Spencer-99" -> decode.success(SpdxlicenseSpencer99)
    "Spencer-94" -> decode.success(SpdxlicenseSpencer94)
    "Spencer-86" -> decode.success(SpdxlicenseSpencer86)
    "SNIA" -> decode.success(SpdxlicenseSnia)
    "SMPPL" -> decode.success(SpdxlicenseSmppl)
    "SMLNJ" -> decode.success(SpdxlicenseSmlnj)
    "Sleepycat" -> decode.success(SpdxlicenseSleepycat)
    "SISSL" -> decode.success(SpdxlicenseSissl)
    "SISSL-1.2" -> decode.success(SpdxlicenseSissl12)
    "SimPL-2.0" -> decode.success(SpdxlicenseSimpl20)
    "SGI-B-2.0" -> decode.success(SpdxlicenseSgib20)
    "SGI-B-1.1" -> decode.success(SpdxlicenseSgib11)
    "SGI-B-1.0" -> decode.success(SpdxlicenseSgib10)
    "Sendmail" -> decode.success(SpdxlicenseSendmail)
    "SCEA" -> decode.success(SpdxlicenseScea)
    "Saxpath" -> decode.success(SpdxlicenseSaxpath)
    "SAX-PD" -> decode.success(SpdxlicenseSaxpd)
    "Ruby" -> decode.success(SpdxlicenseRuby)
    "RSCPL" -> decode.success(SpdxlicenseRscpl)
    "RSA-MD" -> decode.success(SpdxlicenseRsamd)
    "RPSL-1.0" -> decode.success(SpdxlicenseRpsl10)
    "RPL-1.5" -> decode.success(SpdxlicenseRpl15)
    "RPL-1.1" -> decode.success(SpdxlicenseRpl11)
    "RHeCos-1.1" -> decode.success(SpdxlicenseRhecos11)
    "Rdisc" -> decode.success(SpdxlicenseRdisc)
    "QPL-1.0" -> decode.success(SpdxlicenseQpl10)
    "Qhull" -> decode.success(SpdxlicenseQhull)
    "Python-2.0" -> decode.success(SpdxlicensePython20)
    "psutils" -> decode.success(SpdxlicensePsutils)
    "psfrag" -> decode.success(SpdxlicensePsfrag)
    "PostgreSQL" -> decode.success(SpdxlicensePostgresql)
    "Plexus" -> decode.success(SpdxlicensePlexus)
    "PHP-3.01" -> decode.success(SpdxlicensePhp301)
    "PHP-3.0" -> decode.success(SpdxlicensePhp30)
    "PDDL-1.0" -> decode.success(SpdxlicensePddl10)
    "OSL-3.0" -> decode.success(SpdxlicenseOsl30)
    "OSL-2.1" -> decode.success(SpdxlicenseOsl21)
    "OSL-2.0" -> decode.success(SpdxlicenseOsl20)
    "OSL-1.1" -> decode.success(SpdxlicenseOsl11)
    "OSL-1.0" -> decode.success(SpdxlicenseOsl10)
    "OSET-PL-2.1" -> decode.success(SpdxlicenseOsetpl21)
    "OPL-1.0" -> decode.success(SpdxlicenseOpl10)
    "OpenSSL" -> decode.success(SpdxlicenseOpenssl)
    "OML" -> decode.success(SpdxlicenseOml)
    "OLDAP-2.8" -> decode.success(SpdxlicenseOldap28)
    "OLDAP-2.7" -> decode.success(SpdxlicenseOldap27)
    "OLDAP-2.6" -> decode.success(SpdxlicenseOldap26)
    "OLDAP-2.5" -> decode.success(SpdxlicenseOldap25)
    "OLDAP-2.4" -> decode.success(SpdxlicenseOldap24)
    "OLDAP-2.3" -> decode.success(SpdxlicenseOldap23)
    "OLDAP-2.2" -> decode.success(SpdxlicenseOldap22)
    "OLDAP-2.2.2" -> decode.success(SpdxlicenseOldap222)
    "OLDAP-2.2.1" -> decode.success(SpdxlicenseOldap221)
    "OLDAP-2.1" -> decode.success(SpdxlicenseOldap21)
    "OLDAP-2.0" -> decode.success(SpdxlicenseOldap20)
    "OLDAP-2.0.1" -> decode.success(SpdxlicenseOldap201)
    "OLDAP-1.4" -> decode.success(SpdxlicenseOldap14)
    "OLDAP-1.3" -> decode.success(SpdxlicenseOldap13)
    "OLDAP-1.2" -> decode.success(SpdxlicenseOldap12)
    "OLDAP-1.1" -> decode.success(SpdxlicenseOldap11)
    "OGTSL" -> decode.success(SpdxlicenseOgtsl)
    "OFL-1.1" -> decode.success(SpdxlicenseOfl11)
    "OFL-1.0" -> decode.success(SpdxlicenseOfl10)
    "ODbL-1.0" -> decode.success(SpdxlicenseOdbl10)
    "OCLC-2.0" -> decode.success(SpdxlicenseOclc20)
    "OCCT-PL" -> decode.success(SpdxlicenseOcctpl)
    "NTP" -> decode.success(SpdxlicenseNtp)
    "NRL" -> decode.success(SpdxlicenseNrl)
    "NPOSL-3.0" -> decode.success(SpdxlicenseNposl30)
    "NPL-1.1" -> decode.success(SpdxlicenseNpl11)
    "NPL-1.0" -> decode.success(SpdxlicenseNpl10)
    "Noweb" -> decode.success(SpdxlicenseNoweb)
    "NOSL" -> decode.success(SpdxlicenseNosl)
    "Nokia" -> decode.success(SpdxlicenseNokia)
    "NLPL" -> decode.success(SpdxlicenseNlpl)
    "NLOD-1.0" -> decode.success(SpdxlicenseNlod10)
    "NGPL" -> decode.success(SpdxlicenseNgpl)
    "Newsletr" -> decode.success(SpdxlicenseNewsletr)
    "NetCDF" -> decode.success(SpdxlicenseNetcdf)
    "Net-SNMP" -> decode.success(SpdxlicenseNetsnmp)
    "NCSA" -> decode.success(SpdxlicenseNcsa)
    "NBPL-1.0" -> decode.success(SpdxlicenseNbpl10)
    "Naumen" -> decode.success(SpdxlicenseNaumen)
    "NASA-1.3" -> decode.success(SpdxlicenseNasa13)
    "Mup" -> decode.success(SpdxlicenseMup)
    "Multics" -> decode.success(SpdxlicenseMultics)
    "MTLL" -> decode.success(SpdxlicenseMtll)
    "MS-RL" -> decode.success(SpdxlicenseMsrl)
    "MS-PL" -> decode.success(SpdxlicenseMspl)
    "MPL-2.0" -> decode.success(SpdxlicenseMpl20)
    "MPL-2.0-no-copyleft-exception" ->
      decode.success(SpdxlicenseMpl20nocopyleftexception)
    "MPL-1.1" -> decode.success(SpdxlicenseMpl11)
    "MPL-1.0" -> decode.success(SpdxlicenseMpl10)
    "mpich2" -> decode.success(SpdxlicenseMpich2)
    "Motosoto" -> decode.success(SpdxlicenseMotosoto)
    "MITNFA" -> decode.success(SpdxlicenseMitnfa)
    "MIT" -> decode.success(SpdxlicenseMit)
    "MIT-feh" -> decode.success(SpdxlicenseMitfeh)
    "MIT-enna" -> decode.success(SpdxlicenseMitenna)
    "MIT-CMU" -> decode.success(SpdxlicenseMitcmu)
    "MIT-advertising" -> decode.success(SpdxlicenseMitadvertising)
    "MIT-0" -> decode.success(SpdxlicenseMit0)
    "MirOS" -> decode.success(SpdxlicenseMiros)
    "MakeIndex" -> decode.success(SpdxlicenseMakeindex)
    "LPPL-1.3c" -> decode.success(SpdxlicenseLppl13c)
    "LPPL-1.3a" -> decode.success(SpdxlicenseLppl13a)
    "LPPL-1.2" -> decode.success(SpdxlicenseLppl12)
    "LPPL-1.1" -> decode.success(SpdxlicenseLppl11)
    "LPPL-1.0" -> decode.success(SpdxlicenseLppl10)
    "LPL-1.02" -> decode.success(SpdxlicenseLpl102)
    "LPL-1.0" -> decode.success(SpdxlicenseLpl10)
    "Linux-OpenIB" -> decode.success(SpdxlicenseLinuxopenib)
    "LiLiQ-Rplus-1.1" -> decode.success(SpdxlicenseLiliqrplus11)
    "LiLiQ-R-1.1" -> decode.success(SpdxlicenseLiliqr11)
    "LiLiQ-P-1.1" -> decode.success(SpdxlicenseLiliqp11)
    "libtiff" -> decode.success(SpdxlicenseLibtiff)
    "Libpng" -> decode.success(SpdxlicenseLibpng)
    "LGPLLR" -> decode.success(SpdxlicenseLgpllr)
    "LGPL-3.0-or-later" -> decode.success(SpdxlicenseLgpl30orlater)
    "LGPL-3.0-only" -> decode.success(SpdxlicenseLgpl30only)
    "LGPL-2.1-or-later" -> decode.success(SpdxlicenseLgpl21orlater)
    "LGPL-2.1-only" -> decode.success(SpdxlicenseLgpl21only)
    "LGPL-2.0-or-later" -> decode.success(SpdxlicenseLgpl20orlater)
    "LGPL-2.0-only" -> decode.success(SpdxlicenseLgpl20only)
    "Leptonica" -> decode.success(SpdxlicenseLeptonica)
    "Latex2e" -> decode.success(SpdxlicenseLatex2e)
    "LAL-1.3" -> decode.success(SpdxlicenseLal13)
    "LAL-1.2" -> decode.success(SpdxlicenseLal12)
    "JSON" -> decode.success(SpdxlicenseJson)
    "JasPer-2.0" -> decode.success(SpdxlicenseJasper20)
    "ISC" -> decode.success(SpdxlicenseIsc)
    "IPL-1.0" -> decode.success(SpdxlicenseIpl10)
    "IPA" -> decode.success(SpdxlicenseIpa)
    "Interbase-1.0" -> decode.success(SpdxlicenseInterbase10)
    "Intel" -> decode.success(SpdxlicenseIntel)
    "Intel-ACPI" -> decode.success(SpdxlicenseIntelacpi)
    "Info-ZIP" -> decode.success(SpdxlicenseInfozip)
    "Imlib2" -> decode.success(SpdxlicenseImlib2)
    "iMatix" -> decode.success(SpdxlicenseImatix)
    "ImageMagick" -> decode.success(SpdxlicenseImagemagick)
    "IJG" -> decode.success(SpdxlicenseIjg)
    "ICU" -> decode.success(SpdxlicenseIcu)
    "IBM-pibs" -> decode.success(SpdxlicenseIbmpibs)
    "HPND" -> decode.success(SpdxlicenseHpnd)
    "HaskellReport" -> decode.success(SpdxlicenseHaskellreport)
    "gSOAP-1.3b" -> decode.success(SpdxlicenseGsoap13b)
    "GPL-3.0-or-later" -> decode.success(SpdxlicenseGpl30orlater)
    "GPL-3.0-only" -> decode.success(SpdxlicenseGpl30only)
    "GPL-2.0-or-later" -> decode.success(SpdxlicenseGpl20orlater)
    "GPL-2.0-only" -> decode.success(SpdxlicenseGpl20only)
    "GPL-1.0-or-later" -> decode.success(SpdxlicenseGpl10orlater)
    "GPL-1.0-only" -> decode.success(SpdxlicenseGpl10only)
    "gnuplot" -> decode.success(SpdxlicenseGnuplot)
    "Glulxe" -> decode.success(SpdxlicenseGlulxe)
    "Glide" -> decode.success(SpdxlicenseGlide)
    "GL2PS" -> decode.success(SpdxlicenseGl2ps)
    "Giftware" -> decode.success(SpdxlicenseGiftware)
    "GFDL-1.3-or-later" -> decode.success(SpdxlicenseGfdl13orlater)
    "GFDL-1.3-only" -> decode.success(SpdxlicenseGfdl13only)
    "GFDL-1.2-or-later" -> decode.success(SpdxlicenseGfdl12orlater)
    "GFDL-1.2-only" -> decode.success(SpdxlicenseGfdl12only)
    "GFDL-1.1-or-later" -> decode.success(SpdxlicenseGfdl11orlater)
    "GFDL-1.1-only" -> decode.success(SpdxlicenseGfdl11only)
    "FTL" -> decode.success(SpdxlicenseFtl)
    "FSFULLR" -> decode.success(SpdxlicenseFsfullr)
    "FSFUL" -> decode.success(SpdxlicenseFsful)
    "FSFAP" -> decode.success(SpdxlicenseFsfap)
    "FreeImage" -> decode.success(SpdxlicenseFreeimage)
    "Frameworx-1.0" -> decode.success(SpdxlicenseFrameworx10)
    "Fair" -> decode.success(SpdxlicenseFair)
    "Eurosym" -> decode.success(SpdxlicenseEurosym)
    "EUPL-1.2" -> decode.success(SpdxlicenseEupl12)
    "EUPL-1.1" -> decode.success(SpdxlicenseEupl11)
    "EUPL-1.0" -> decode.success(SpdxlicenseEupl10)
    "EUDatagrid" -> decode.success(SpdxlicenseEudatagrid)
    "ErlPL-1.1" -> decode.success(SpdxlicenseErlpl11)
    "EPL-2.0" -> decode.success(SpdxlicenseEpl20)
    "EPL-1.0" -> decode.success(SpdxlicenseEpl10)
    "Entessa" -> decode.success(SpdxlicenseEntessa)
    "eGenix" -> decode.success(SpdxlicenseEgenix)
    "EFL-2.0" -> decode.success(SpdxlicenseEfl20)
    "EFL-1.0" -> decode.success(SpdxlicenseEfl10)
    "ECL-2.0" -> decode.success(SpdxlicenseEcl20)
    "ECL-1.0" -> decode.success(SpdxlicenseEcl10)
    "dvipdfm" -> decode.success(SpdxlicenseDvipdfm)
    "DSDP" -> decode.success(SpdxlicenseDsdp)
    "Dotseqn" -> decode.success(SpdxlicenseDotseqn)
    "DOC" -> decode.success(SpdxlicenseDoc)
    "diffmark" -> decode.success(SpdxlicenseDiffmark)
    "D-FSL-1.0" -> decode.success(SpdxlicenseDfsl10)
    "curl" -> decode.success(SpdxlicenseCurl)
    "Cube" -> decode.success(SpdxlicenseCube)
    "CUA-OPL-1.0" -> decode.success(SpdxlicenseCuaopl10)
    "CrystalStacker" -> decode.success(SpdxlicenseCrystalstacker)
    "Crossword" -> decode.success(SpdxlicenseCrossword)
    "CPOL-1.02" -> decode.success(SpdxlicenseCpol102)
    "CPL-1.0" -> decode.success(SpdxlicenseCpl10)
    "CPAL-1.0" -> decode.success(SpdxlicenseCpal10)
    "Condor-1.1" -> decode.success(SpdxlicenseCondor11)
    "CNRI-Python" -> decode.success(SpdxlicenseCnripython)
    "CNRI-Python-GPL-Compatible" ->
      decode.success(SpdxlicenseCnripythongplcompatible)
    "CNRI-Jython" -> decode.success(SpdxlicenseCnrijython)
    "ClArtistic" -> decode.success(SpdxlicenseClartistic)
    "CECILL-C" -> decode.success(SpdxlicenseCecillc)
    "CECILL-B" -> decode.success(SpdxlicenseCecillb)
    "CECILL-2.1" -> decode.success(SpdxlicenseCecill21)
    "CECILL-2.0" -> decode.success(SpdxlicenseCecill20)
    "CECILL-1.1" -> decode.success(SpdxlicenseCecill11)
    "CECILL-1.0" -> decode.success(SpdxlicenseCecill10)
    "CDLA-Sharing-1.0" -> decode.success(SpdxlicenseCdlasharing10)
    "CDLA-Permissive-1.0" -> decode.success(SpdxlicenseCdlapermissive10)
    "CDDL-1.1" -> decode.success(SpdxlicenseCddl11)
    "CDDL-1.0" -> decode.success(SpdxlicenseCddl10)
    "CC0-1.0" -> decode.success(SpdxlicenseCc010)
    "CC-BY-SA-4.0" -> decode.success(SpdxlicenseCcbysa40)
    "CC-BY-SA-3.0" -> decode.success(SpdxlicenseCcbysa30)
    "CC-BY-SA-2.5" -> decode.success(SpdxlicenseCcbysa25)
    "CC-BY-SA-2.0" -> decode.success(SpdxlicenseCcbysa20)
    "CC-BY-SA-1.0" -> decode.success(SpdxlicenseCcbysa10)
    "CC-BY-ND-4.0" -> decode.success(SpdxlicenseCcbynd40)
    "CC-BY-ND-3.0" -> decode.success(SpdxlicenseCcbynd30)
    "CC-BY-ND-2.5" -> decode.success(SpdxlicenseCcbynd25)
    "CC-BY-ND-2.0" -> decode.success(SpdxlicenseCcbynd20)
    "CC-BY-ND-1.0" -> decode.success(SpdxlicenseCcbynd10)
    "CC-BY-NC-SA-4.0" -> decode.success(SpdxlicenseCcbyncsa40)
    "CC-BY-NC-SA-3.0" -> decode.success(SpdxlicenseCcbyncsa30)
    "CC-BY-NC-SA-2.5" -> decode.success(SpdxlicenseCcbyncsa25)
    "CC-BY-NC-SA-2.0" -> decode.success(SpdxlicenseCcbyncsa20)
    "CC-BY-NC-SA-1.0" -> decode.success(SpdxlicenseCcbyncsa10)
    "CC-BY-NC-ND-4.0" -> decode.success(SpdxlicenseCcbyncnd40)
    "CC-BY-NC-ND-3.0" -> decode.success(SpdxlicenseCcbyncnd30)
    "CC-BY-NC-ND-2.5" -> decode.success(SpdxlicenseCcbyncnd25)
    "CC-BY-NC-ND-2.0" -> decode.success(SpdxlicenseCcbyncnd20)
    "CC-BY-NC-ND-1.0" -> decode.success(SpdxlicenseCcbyncnd10)
    "CC-BY-NC-4.0" -> decode.success(SpdxlicenseCcbync40)
    "CC-BY-NC-3.0" -> decode.success(SpdxlicenseCcbync30)
    "CC-BY-NC-2.5" -> decode.success(SpdxlicenseCcbync25)
    "CC-BY-NC-2.0" -> decode.success(SpdxlicenseCcbync20)
    "CC-BY-NC-1.0" -> decode.success(SpdxlicenseCcbync10)
    "CC-BY-4.0" -> decode.success(SpdxlicenseCcby40)
    "CC-BY-3.0" -> decode.success(SpdxlicenseCcby30)
    "CC-BY-2.5" -> decode.success(SpdxlicenseCcby25)
    "CC-BY-2.0" -> decode.success(SpdxlicenseCcby20)
    "CC-BY-1.0" -> decode.success(SpdxlicenseCcby10)
    "CATOSL-1.1" -> decode.success(SpdxlicenseCatosl11)
    "Caldera" -> decode.success(SpdxlicenseCaldera)
    "bzip2-1.0.6" -> decode.success(SpdxlicenseBzip2106)
    "bzip2-1.0.5" -> decode.success(SpdxlicenseBzip2105)
    "BSL-1.0" -> decode.success(SpdxlicenseBsl10)
    "BSD-Source-Code" -> decode.success(SpdxlicenseBsdsourcecode)
    "BSD-Protection" -> decode.success(SpdxlicenseBsdprotection)
    "BSD-4-Clause" -> decode.success(SpdxlicenseBsd4clause)
    "BSD-4-Clause-UC" -> decode.success(SpdxlicenseBsd4clauseuc)
    "BSD-3-Clause" -> decode.success(SpdxlicenseBsd3clause)
    "BSD-3-Clause-No-Nuclear-Warranty" ->
      decode.success(SpdxlicenseBsd3clausenonuclearwarranty)
    "BSD-3-Clause-No-Nuclear-License" ->
      decode.success(SpdxlicenseBsd3clausenonuclearlicense)
    "BSD-3-Clause-No-Nuclear-License-2014" ->
      decode.success(SpdxlicenseBsd3clausenonuclearlicense2014)
    "BSD-3-Clause-LBNL" -> decode.success(SpdxlicenseBsd3clauselbnl)
    "BSD-3-Clause-Clear" -> decode.success(SpdxlicenseBsd3clauseclear)
    "BSD-3-Clause-Attribution" ->
      decode.success(SpdxlicenseBsd3clauseattribution)
    "BSD-2-Clause" -> decode.success(SpdxlicenseBsd2clause)
    "BSD-2-Clause-Patent" -> decode.success(SpdxlicenseBsd2clausepatent)
    "BSD-2-Clause-NetBSD" -> decode.success(SpdxlicenseBsd2clausenetbsd)
    "BSD-2-Clause-FreeBSD" -> decode.success(SpdxlicenseBsd2clausefreebsd)
    "BSD-1-Clause" -> decode.success(SpdxlicenseBsd1clause)
    "Borceux" -> decode.success(SpdxlicenseBorceux)
    "BitTorrent-1.1" -> decode.success(SpdxlicenseBittorrent11)
    "BitTorrent-1.0" -> decode.success(SpdxlicenseBittorrent10)
    "Beerware" -> decode.success(SpdxlicenseBeerware)
    "Barr" -> decode.success(SpdxlicenseBarr)
    "Bahyph" -> decode.success(SpdxlicenseBahyph)
    "Artistic-2.0" -> decode.success(SpdxlicenseArtistic20)
    "Artistic-1.0" -> decode.success(SpdxlicenseArtistic10)
    "Artistic-1.0-Perl" -> decode.success(SpdxlicenseArtistic10perl)
    "Artistic-1.0-cl8" -> decode.success(SpdxlicenseArtistic10cl8)
    "APSL-2.0" -> decode.success(SpdxlicenseApsl20)
    "APSL-1.2" -> decode.success(SpdxlicenseApsl12)
    "APSL-1.1" -> decode.success(SpdxlicenseApsl11)
    "APSL-1.0" -> decode.success(SpdxlicenseApsl10)
    "APL-1.0" -> decode.success(SpdxlicenseApl10)
    "APAFML" -> decode.success(SpdxlicenseApafml)
    "Apache-2.0" -> decode.success(SpdxlicenseApache20)
    "Apache-1.1" -> decode.success(SpdxlicenseApache11)
    "Apache-1.0" -> decode.success(SpdxlicenseApache10)
    "ANTLR-PD" -> decode.success(SpdxlicenseAntlrpd)
    "AMPAS" -> decode.success(SpdxlicenseAmpas)
    "AML" -> decode.success(SpdxlicenseAml)
    "AMDPLPA" -> decode.success(SpdxlicenseAmdplpa)
    "Aladdin" -> decode.success(SpdxlicenseAladdin)
    "AGPL-3.0-or-later" -> decode.success(SpdxlicenseAgpl30orlater)
    "AGPL-3.0-only" -> decode.success(SpdxlicenseAgpl30only)
    "AGPL-1.0-or-later" -> decode.success(SpdxlicenseAgpl10orlater)
    "AGPL-1.0-only" -> decode.success(SpdxlicenseAgpl10only)
    "Afmparse" -> decode.success(SpdxlicenseAfmparse)
    "AFL-3.0" -> decode.success(SpdxlicenseAfl30)
    "AFL-2.1" -> decode.success(SpdxlicenseAfl21)
    "AFL-2.0" -> decode.success(SpdxlicenseAfl20)
    "AFL-1.2" -> decode.success(SpdxlicenseAfl12)
    "AFL-1.1" -> decode.success(SpdxlicenseAfl11)
    "ADSL" -> decode.success(SpdxlicenseAdsl)
    "Adobe-Glyph" -> decode.success(SpdxlicenseAdobeglyph)
    "Adobe-2006" -> decode.success(SpdxlicenseAdobe2006)
    "Abstyles" -> decode.success(SpdxlicenseAbstyles)
    "AAL" -> decode.success(SpdxlicenseAal)
    "0BSD" -> decode.success(Spdxlicense0bsd)
    "not-open-source" -> decode.success(SpdxlicenseNotopensource)
    _ -> decode.failure(SpdxlicenseZpl21, "Spdxlicense")
  }
}

pub type Metriccalibrationtype {
  MetriccalibrationtypeTwopoint
  MetriccalibrationtypeGain
  MetriccalibrationtypeOffset
  MetriccalibrationtypeUnspecified
}

pub fn metriccalibrationtype_to_json(
  metriccalibrationtype: Metriccalibrationtype,
) -> Json {
  case metriccalibrationtype {
    MetriccalibrationtypeTwopoint -> json.string("two-point")
    MetriccalibrationtypeGain -> json.string("gain")
    MetriccalibrationtypeOffset -> json.string("offset")
    MetriccalibrationtypeUnspecified -> json.string("unspecified")
  }
}

pub fn metriccalibrationtype_decoder() -> Decoder(Metriccalibrationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "two-point" -> decode.success(MetriccalibrationtypeTwopoint)
    "gain" -> decode.success(MetriccalibrationtypeGain)
    "offset" -> decode.success(MetriccalibrationtypeOffset)
    "unspecified" -> decode.success(MetriccalibrationtypeUnspecified)
    _ -> decode.failure(MetriccalibrationtypeTwopoint, "Metriccalibrationtype")
  }
}

pub type Medicationadminstatus {
  MedicationadminstatusUnknown
  MedicationadminstatusStopped
  MedicationadminstatusEnteredinerror
  MedicationadminstatusCompleted
  MedicationadminstatusOnhold
  MedicationadminstatusNotdone
  MedicationadminstatusInprogress
}

pub fn medicationadminstatus_to_json(
  medicationadminstatus: Medicationadminstatus,
) -> Json {
  case medicationadminstatus {
    MedicationadminstatusUnknown -> json.string("unknown")
    MedicationadminstatusStopped -> json.string("stopped")
    MedicationadminstatusEnteredinerror -> json.string("entered-in-error")
    MedicationadminstatusCompleted -> json.string("completed")
    MedicationadminstatusOnhold -> json.string("on-hold")
    MedicationadminstatusNotdone -> json.string("not-done")
    MedicationadminstatusInprogress -> json.string("in-progress")
  }
}

pub fn medicationadminstatus_decoder() -> Decoder(Medicationadminstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(MedicationadminstatusUnknown)
    "stopped" -> decode.success(MedicationadminstatusStopped)
    "entered-in-error" -> decode.success(MedicationadminstatusEnteredinerror)
    "completed" -> decode.success(MedicationadminstatusCompleted)
    "on-hold" -> decode.success(MedicationadminstatusOnhold)
    "not-done" -> decode.success(MedicationadminstatusNotdone)
    "in-progress" -> decode.success(MedicationadminstatusInprogress)
    _ -> decode.failure(MedicationadminstatusUnknown, "Medicationadminstatus")
  }
}

pub type Episodeofcarestatus {
  EpisodeofcarestatusEnteredinerror
  EpisodeofcarestatusCancelled
  EpisodeofcarestatusFinished
  EpisodeofcarestatusOnhold
  EpisodeofcarestatusActive
  EpisodeofcarestatusWaitlist
  EpisodeofcarestatusPlanned
}

pub fn episodeofcarestatus_to_json(
  episodeofcarestatus: Episodeofcarestatus,
) -> Json {
  case episodeofcarestatus {
    EpisodeofcarestatusEnteredinerror -> json.string("entered-in-error")
    EpisodeofcarestatusCancelled -> json.string("cancelled")
    EpisodeofcarestatusFinished -> json.string("finished")
    EpisodeofcarestatusOnhold -> json.string("onhold")
    EpisodeofcarestatusActive -> json.string("active")
    EpisodeofcarestatusWaitlist -> json.string("waitlist")
    EpisodeofcarestatusPlanned -> json.string("planned")
  }
}

pub fn episodeofcarestatus_decoder() -> Decoder(Episodeofcarestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(EpisodeofcarestatusEnteredinerror)
    "cancelled" -> decode.success(EpisodeofcarestatusCancelled)
    "finished" -> decode.success(EpisodeofcarestatusFinished)
    "onhold" -> decode.success(EpisodeofcarestatusOnhold)
    "active" -> decode.success(EpisodeofcarestatusActive)
    "waitlist" -> decode.success(EpisodeofcarestatusWaitlist)
    "planned" -> decode.success(EpisodeofcarestatusPlanned)
    _ ->
      decode.failure(EpisodeofcarestatusEnteredinerror, "Episodeofcarestatus")
  }
}

pub type Addresstype {
  AddresstypeBoth
  AddresstypePhysical
  AddresstypePostal
}

pub fn addresstype_to_json(addresstype: Addresstype) -> Json {
  case addresstype {
    AddresstypeBoth -> json.string("both")
    AddresstypePhysical -> json.string("physical")
    AddresstypePostal -> json.string("postal")
  }
}

pub fn addresstype_decoder() -> Decoder(Addresstype) {
  use variant <- decode.then(decode.string)
  case variant {
    "both" -> decode.success(AddresstypeBoth)
    "physical" -> decode.success(AddresstypePhysical)
    "postal" -> decode.success(AddresstypePostal)
    _ -> decode.failure(AddresstypeBoth, "Addresstype")
  }
}

pub type Allergyintolerancecategory {
  AllergyintolerancecategoryBiologic
  AllergyintolerancecategoryEnvironment
  AllergyintolerancecategoryMedication
  AllergyintolerancecategoryFood
}

pub fn allergyintolerancecategory_to_json(
  allergyintolerancecategory: Allergyintolerancecategory,
) -> Json {
  case allergyintolerancecategory {
    AllergyintolerancecategoryBiologic -> json.string("biologic")
    AllergyintolerancecategoryEnvironment -> json.string("environment")
    AllergyintolerancecategoryMedication -> json.string("medication")
    AllergyintolerancecategoryFood -> json.string("food")
  }
}

pub fn allergyintolerancecategory_decoder() -> Decoder(
  Allergyintolerancecategory,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "biologic" -> decode.success(AllergyintolerancecategoryBiologic)
    "environment" -> decode.success(AllergyintolerancecategoryEnvironment)
    "medication" -> decode.success(AllergyintolerancecategoryMedication)
    "food" -> decode.success(AllergyintolerancecategoryFood)
    _ ->
      decode.failure(
        AllergyintolerancecategoryBiologic,
        "Allergyintolerancecategory",
      )
  }
}

pub type Reportstatuscodes {
  ReportstatuscodesEnteredinerror
  ReportstatuscodesStopped
  ReportstatuscodesWaiting
  ReportstatuscodesInprogress
  ReportstatuscodesCompleted
}

pub fn reportstatuscodes_to_json(reportstatuscodes: Reportstatuscodes) -> Json {
  case reportstatuscodes {
    ReportstatuscodesEnteredinerror -> json.string("entered-in-error")
    ReportstatuscodesStopped -> json.string("stopped")
    ReportstatuscodesWaiting -> json.string("waiting")
    ReportstatuscodesInprogress -> json.string("in-progress")
    ReportstatuscodesCompleted -> json.string("completed")
  }
}

pub fn reportstatuscodes_decoder() -> Decoder(Reportstatuscodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "entered-in-error" -> decode.success(ReportstatuscodesEnteredinerror)
    "stopped" -> decode.success(ReportstatuscodesStopped)
    "waiting" -> decode.success(ReportstatuscodesWaiting)
    "in-progress" -> decode.success(ReportstatuscodesInprogress)
    "completed" -> decode.success(ReportstatuscodesCompleted)
    _ -> decode.failure(ReportstatuscodesEnteredinerror, "Reportstatuscodes")
  }
}

pub type Resourceslicingrules {
  ResourceslicingrulesOpenatend
  ResourceslicingrulesOpen
  ResourceslicingrulesClosed
}

pub fn resourceslicingrules_to_json(
  resourceslicingrules: Resourceslicingrules,
) -> Json {
  case resourceslicingrules {
    ResourceslicingrulesOpenatend -> json.string("openAtEnd")
    ResourceslicingrulesOpen -> json.string("open")
    ResourceslicingrulesClosed -> json.string("closed")
  }
}

pub fn resourceslicingrules_decoder() -> Decoder(Resourceslicingrules) {
  use variant <- decode.then(decode.string)
  case variant {
    "openAtEnd" -> decode.success(ResourceslicingrulesOpenatend)
    "open" -> decode.success(ResourceslicingrulesOpen)
    "closed" -> decode.success(ResourceslicingrulesClosed)
    _ -> decode.failure(ResourceslicingrulesOpenatend, "Resourceslicingrules")
  }
}

pub type Contactpointuse {
  ContactpointuseMobile
  ContactpointuseOld
  ContactpointuseTemp
  ContactpointuseWork
  ContactpointuseHome
}

pub fn contactpointuse_to_json(contactpointuse: Contactpointuse) -> Json {
  case contactpointuse {
    ContactpointuseMobile -> json.string("mobile")
    ContactpointuseOld -> json.string("old")
    ContactpointuseTemp -> json.string("temp")
    ContactpointuseWork -> json.string("work")
    ContactpointuseHome -> json.string("home")
  }
}

pub fn contactpointuse_decoder() -> Decoder(Contactpointuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "mobile" -> decode.success(ContactpointuseMobile)
    "old" -> decode.success(ContactpointuseOld)
    "temp" -> decode.success(ContactpointuseTemp)
    "work" -> decode.success(ContactpointuseWork)
    "home" -> decode.success(ContactpointuseHome)
    _ -> decode.failure(ContactpointuseMobile, "Contactpointuse")
  }
}

pub type Conceptpropertytype {
  ConceptpropertytypeDecimal
  ConceptpropertytypeDatetime
  ConceptpropertytypeBoolean
  ConceptpropertytypeInteger
  ConceptpropertytypeString
  ConceptpropertytypeCoding
  ConceptpropertytypeCode
}

pub fn conceptpropertytype_to_json(
  conceptpropertytype: Conceptpropertytype,
) -> Json {
  case conceptpropertytype {
    ConceptpropertytypeDecimal -> json.string("decimal")
    ConceptpropertytypeDatetime -> json.string("dateTime")
    ConceptpropertytypeBoolean -> json.string("boolean")
    ConceptpropertytypeInteger -> json.string("integer")
    ConceptpropertytypeString -> json.string("string")
    ConceptpropertytypeCoding -> json.string("Coding")
    ConceptpropertytypeCode -> json.string("code")
  }
}

pub fn conceptpropertytype_decoder() -> Decoder(Conceptpropertytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "decimal" -> decode.success(ConceptpropertytypeDecimal)
    "dateTime" -> decode.success(ConceptpropertytypeDatetime)
    "boolean" -> decode.success(ConceptpropertytypeBoolean)
    "integer" -> decode.success(ConceptpropertytypeInteger)
    "string" -> decode.success(ConceptpropertytypeString)
    "Coding" -> decode.success(ConceptpropertytypeCoding)
    "code" -> decode.success(ConceptpropertytypeCode)
    _ -> decode.failure(ConceptpropertytypeDecimal, "Conceptpropertytype")
  }
}

pub type Typerestfulinteraction {
  TyperestfulinteractionOperation
  TyperestfulinteractionBatch
  TyperestfulinteractionTransaction
  TyperestfulinteractionCapabilities
  TyperestfulinteractionSearch
  TyperestfulinteractionCreate
  TyperestfulinteractionHistory
  TyperestfulinteractionDelete
  TyperestfulinteractionPatch
  TyperestfulinteractionUpdate
  TyperestfulinteractionVread
  TyperestfulinteractionRead
  TyperestfulinteractionHistorysystem
  TyperestfulinteractionHistorytype
  TyperestfulinteractionHistoryinstance
  TyperestfulinteractionSearchsystem
  TyperestfulinteractionSearchtype
}

pub fn typerestfulinteraction_to_json(
  typerestfulinteraction: Typerestfulinteraction,
) -> Json {
  case typerestfulinteraction {
    TyperestfulinteractionOperation -> json.string("operation")
    TyperestfulinteractionBatch -> json.string("batch")
    TyperestfulinteractionTransaction -> json.string("transaction")
    TyperestfulinteractionCapabilities -> json.string("capabilities")
    TyperestfulinteractionSearch -> json.string("search")
    TyperestfulinteractionCreate -> json.string("create")
    TyperestfulinteractionHistory -> json.string("history")
    TyperestfulinteractionDelete -> json.string("delete")
    TyperestfulinteractionPatch -> json.string("patch")
    TyperestfulinteractionUpdate -> json.string("update")
    TyperestfulinteractionVread -> json.string("vread")
    TyperestfulinteractionRead -> json.string("read")
    TyperestfulinteractionHistorysystem -> json.string("history-system")
    TyperestfulinteractionHistorytype -> json.string("history-type")
    TyperestfulinteractionHistoryinstance -> json.string("history-instance")
    TyperestfulinteractionSearchsystem -> json.string("search-system")
    TyperestfulinteractionSearchtype -> json.string("search-type")
  }
}

pub fn typerestfulinteraction_decoder() -> Decoder(Typerestfulinteraction) {
  use variant <- decode.then(decode.string)
  case variant {
    "operation" -> decode.success(TyperestfulinteractionOperation)
    "batch" -> decode.success(TyperestfulinteractionBatch)
    "transaction" -> decode.success(TyperestfulinteractionTransaction)
    "capabilities" -> decode.success(TyperestfulinteractionCapabilities)
    "search" -> decode.success(TyperestfulinteractionSearch)
    "create" -> decode.success(TyperestfulinteractionCreate)
    "history" -> decode.success(TyperestfulinteractionHistory)
    "delete" -> decode.success(TyperestfulinteractionDelete)
    "patch" -> decode.success(TyperestfulinteractionPatch)
    "update" -> decode.success(TyperestfulinteractionUpdate)
    "vread" -> decode.success(TyperestfulinteractionVread)
    "read" -> decode.success(TyperestfulinteractionRead)
    "history-system" -> decode.success(TyperestfulinteractionHistorysystem)
    "history-type" -> decode.success(TyperestfulinteractionHistorytype)
    "history-instance" -> decode.success(TyperestfulinteractionHistoryinstance)
    "search-system" -> decode.success(TyperestfulinteractionSearchsystem)
    "search-type" -> decode.success(TyperestfulinteractionSearchtype)
    _ ->
      decode.failure(TyperestfulinteractionOperation, "Typerestfulinteraction")
  }
}

pub type Nameuse {
  NameuseOld
  NameuseAnonymous
  NameuseNickname
  NameuseTemp
  NameuseOfficial
  NameuseUsual
  NameuseMaiden
}

pub fn nameuse_to_json(nameuse: Nameuse) -> Json {
  case nameuse {
    NameuseOld -> json.string("old")
    NameuseAnonymous -> json.string("anonymous")
    NameuseNickname -> json.string("nickname")
    NameuseTemp -> json.string("temp")
    NameuseOfficial -> json.string("official")
    NameuseUsual -> json.string("usual")
    NameuseMaiden -> json.string("maiden")
  }
}

pub fn nameuse_decoder() -> Decoder(Nameuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "old" -> decode.success(NameuseOld)
    "anonymous" -> decode.success(NameuseAnonymous)
    "nickname" -> decode.success(NameuseNickname)
    "temp" -> decode.success(NameuseTemp)
    "official" -> decode.success(NameuseOfficial)
    "usual" -> decode.success(NameuseUsual)
    "maiden" -> decode.success(NameuseMaiden)
    _ -> decode.failure(NameuseOld, "Nameuse")
  }
}

pub type Eventcapabilitymode {
  EventcapabilitymodeReceiver
  EventcapabilitymodeSender
}

pub fn eventcapabilitymode_to_json(
  eventcapabilitymode: Eventcapabilitymode,
) -> Json {
  case eventcapabilitymode {
    EventcapabilitymodeReceiver -> json.string("receiver")
    EventcapabilitymodeSender -> json.string("sender")
  }
}

pub fn eventcapabilitymode_decoder() -> Decoder(Eventcapabilitymode) {
  use variant <- decode.then(decode.string)
  case variant {
    "receiver" -> decode.success(EventcapabilitymodeReceiver)
    "sender" -> decode.success(EventcapabilitymodeSender)
    _ -> decode.failure(EventcapabilitymodeReceiver, "Eventcapabilitymode")
  }
}

pub type Sortdirection {
  SortdirectionDescending
  SortdirectionAscending
}

pub fn sortdirection_to_json(sortdirection: Sortdirection) -> Json {
  case sortdirection {
    SortdirectionDescending -> json.string("descending")
    SortdirectionAscending -> json.string("ascending")
  }
}

pub fn sortdirection_decoder() -> Decoder(Sortdirection) {
  use variant <- decode.then(decode.string)
  case variant {
    "descending" -> decode.success(SortdirectionDescending)
    "ascending" -> decode.success(SortdirectionAscending)
    _ -> decode.failure(SortdirectionDescending, "Sortdirection")
  }
}

pub type Systemrestfulinteraction {
  SystemrestfulinteractionOperation
  SystemrestfulinteractionBatch
  SystemrestfulinteractionTransaction
  SystemrestfulinteractionCapabilities
  SystemrestfulinteractionSearch
  SystemrestfulinteractionCreate
  SystemrestfulinteractionHistory
  SystemrestfulinteractionDelete
  SystemrestfulinteractionPatch
  SystemrestfulinteractionUpdate
  SystemrestfulinteractionVread
  SystemrestfulinteractionRead
  SystemrestfulinteractionHistorysystem
  SystemrestfulinteractionHistorytype
  SystemrestfulinteractionHistoryinstance
  SystemrestfulinteractionSearchsystem
  SystemrestfulinteractionSearchtype
}

pub fn systemrestfulinteraction_to_json(
  systemrestfulinteraction: Systemrestfulinteraction,
) -> Json {
  case systemrestfulinteraction {
    SystemrestfulinteractionOperation -> json.string("operation")
    SystemrestfulinteractionBatch -> json.string("batch")
    SystemrestfulinteractionTransaction -> json.string("transaction")
    SystemrestfulinteractionCapabilities -> json.string("capabilities")
    SystemrestfulinteractionSearch -> json.string("search")
    SystemrestfulinteractionCreate -> json.string("create")
    SystemrestfulinteractionHistory -> json.string("history")
    SystemrestfulinteractionDelete -> json.string("delete")
    SystemrestfulinteractionPatch -> json.string("patch")
    SystemrestfulinteractionUpdate -> json.string("update")
    SystemrestfulinteractionVread -> json.string("vread")
    SystemrestfulinteractionRead -> json.string("read")
    SystemrestfulinteractionHistorysystem -> json.string("history-system")
    SystemrestfulinteractionHistorytype -> json.string("history-type")
    SystemrestfulinteractionHistoryinstance -> json.string("history-instance")
    SystemrestfulinteractionSearchsystem -> json.string("search-system")
    SystemrestfulinteractionSearchtype -> json.string("search-type")
  }
}

pub fn systemrestfulinteraction_decoder() -> Decoder(Systemrestfulinteraction) {
  use variant <- decode.then(decode.string)
  case variant {
    "operation" -> decode.success(SystemrestfulinteractionOperation)
    "batch" -> decode.success(SystemrestfulinteractionBatch)
    "transaction" -> decode.success(SystemrestfulinteractionTransaction)
    "capabilities" -> decode.success(SystemrestfulinteractionCapabilities)
    "search" -> decode.success(SystemrestfulinteractionSearch)
    "create" -> decode.success(SystemrestfulinteractionCreate)
    "history" -> decode.success(SystemrestfulinteractionHistory)
    "delete" -> decode.success(SystemrestfulinteractionDelete)
    "patch" -> decode.success(SystemrestfulinteractionPatch)
    "update" -> decode.success(SystemrestfulinteractionUpdate)
    "vread" -> decode.success(SystemrestfulinteractionVread)
    "read" -> decode.success(SystemrestfulinteractionRead)
    "history-system" -> decode.success(SystemrestfulinteractionHistorysystem)
    "history-type" -> decode.success(SystemrestfulinteractionHistorytype)
    "history-instance" ->
      decode.success(SystemrestfulinteractionHistoryinstance)
    "search-system" -> decode.success(SystemrestfulinteractionSearchsystem)
    "search-type" -> decode.success(SystemrestfulinteractionSearchtype)
    _ ->
      decode.failure(
        SystemrestfulinteractionOperation,
        "Systemrestfulinteraction",
      )
  }
}

pub type Udientrytype {
  UdientrytypeUnknown
  UdientrytypeSelfreported
  UdientrytypeCard
  UdientrytypeManual
  UdientrytypeRfid
  UdientrytypeBarcode
}

pub fn udientrytype_to_json(udientrytype: Udientrytype) -> Json {
  case udientrytype {
    UdientrytypeUnknown -> json.string("unknown")
    UdientrytypeSelfreported -> json.string("self-reported")
    UdientrytypeCard -> json.string("card")
    UdientrytypeManual -> json.string("manual")
    UdientrytypeRfid -> json.string("rfid")
    UdientrytypeBarcode -> json.string("barcode")
  }
}

pub fn udientrytype_decoder() -> Decoder(Udientrytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "unknown" -> decode.success(UdientrytypeUnknown)
    "self-reported" -> decode.success(UdientrytypeSelfreported)
    "card" -> decode.success(UdientrytypeCard)
    "manual" -> decode.success(UdientrytypeManual)
    "rfid" -> decode.success(UdientrytypeRfid)
    "barcode" -> decode.success(UdientrytypeBarcode)
    _ -> decode.failure(UdientrytypeUnknown, "Udientrytype")
  }
}

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
