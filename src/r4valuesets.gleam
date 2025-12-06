pub type Participantrequired {
  ParticipantrequiredRequired
  ParticipantrequiredOptional
  ParticipantrequiredInformationonly
}

pub type Repositorytype {
  RepositorytypeDirectlink
  RepositorytypeOpenapi
  RepositorytypeLogin
  RepositorytypeOauth
  RepositorytypeOther
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

pub type Fhirversion {
  Fhirversion001
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
  Fhirversion330
  Fhirversion350
  Fhirversion400
  Fhirversion401
}

pub type Actionselectionbehavior {
  ActionselectionbehaviorAny
  ActionselectionbehaviorAll
  ActionselectionbehaviorAllornone
  ActionselectionbehaviorExactlyone
  ActionselectionbehaviorAtmostone
  ActionselectionbehaviorOneormore
}

pub type Historystatus {
  HistorystatusPartial
  HistorystatusCompleted
  HistorystatusEnteredinerror
  HistorystatusHealthunknown
}

pub type Visioneyecodes {
  VisioneyecodesRight
  VisioneyecodesLeft
}

pub type Careteamstatus {
  CareteamstatusProposed
  CareteamstatusActive
  CareteamstatusSuspended
  CareteamstatusInactive
  CareteamstatusEnteredinerror
}

pub type Invoicepricecomponenttype {
  InvoicepricecomponenttypeBase
  InvoicepricecomponenttypeSurcharge
  InvoicepricecomponenttypeDeduction
  InvoicepricecomponenttypeDiscount
  InvoicepricecomponenttypeTax
  InvoicepricecomponenttypeInformational
}

pub type Medicationstatementstatus {
  MedicationstatementstatusActive
  MedicationstatementstatusCompleted
  MedicationstatementstatusEnteredinerror
  MedicationstatementstatusIntended
  MedicationstatementstatusStopped
  MedicationstatementstatusOnhold
  MedicationstatementstatusUnknown
  MedicationstatementstatusNottaken
}

pub type Specimenstatus {
  SpecimenstatusAvailable
  SpecimenstatusUnavailable
  SpecimenstatusUnsatisfactory
  SpecimenstatusEnteredinerror
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

pub type Mapcontexttype {
  MapcontexttypeType
  MapcontexttypeVariable
}

pub type Listmode {
  ListmodeWorking
  ListmodeSnapshot
  ListmodeChanges
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

pub type Measurereporttype {
  MeasurereporttypeIndividual
  MeasurereporttypeSubjectlist
  MeasurereporttypeSummary
  MeasurereporttypeDatacollection
}

pub type Actionrequiredbehavior {
  ActionrequiredbehaviorMust
  ActionrequiredbehaviorCould
  ActionrequiredbehaviorMustunlessdocumented
}

pub type Metriccolor {
  MetriccolorBlack
  MetriccolorRed
  MetriccolorGreen
  MetriccolorYellow
  MetriccolorBlue
  MetriccolorMagenta
  MetriccolorCyan
  MetriccolorWhite
}

pub type Restfulcapabilitymode {
  RestfulcapabilitymodeClient
  RestfulcapabilitymodeServer
}

pub type Graphcompartmentuse {
  GraphcompartmentuseCondition
  GraphcompartmentuseRequirement
}

pub type Eligibilityresponsepurpose {
  EligibilityresponsepurposeAuthrequirements
  EligibilityresponsepurposeBenefits
  EligibilityresponsepurposeDiscovery
  EligibilityresponsepurposeValidation
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

pub type Reportstatuscodes {
  ReportstatuscodesCompleted
  ReportstatuscodesInprogress
  ReportstatuscodesWaiting
  ReportstatuscodesStopped
  ReportstatuscodesEnteredinerror
}

pub type Versioningpolicy {
  VersioningpolicyNoversion
  VersioningpolicyVersioned
  VersioningpolicyVersionedupdate
}

pub type Spdxlicense {
  SpdxlicenseNotopensource
  SpdxlicenseBsd0
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

pub type Assertdirectioncodes {
  AssertdirectioncodesResponse
  AssertdirectioncodesRequest
}

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeProvided
  ConceptmapunmappedmodeFixed
  ConceptmapunmappedmodeOthermap
}

pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}

pub type Maptargetlistmode {
  MaptargetlistmodeFirst
  MaptargetlistmodeShare
  MaptargetlistmodeLast
  MaptargetlistmodeCollate
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

pub type Invoicestatus {
  InvoicestatusDraft
  InvoicestatusIssued
  InvoicestatusBalanced
  InvoicestatusCancelled
  InvoicestatusEnteredinerror
}

pub type Flagstatus {
  FlagstatusActive
  FlagstatusInactive
  FlagstatusEnteredinerror
}

pub type Linktype {
  LinktypeReplacedby
  LinktypeReplaces
  LinktypeRefer
  LinktypeSeealso
}

pub type Operationparameteruse {
  OperationparameteruseIn
  OperationparameteruseOut
}

pub type Searchentrymode {
  SearchentrymodeMatch
  SearchentrymodeInclude
  SearchentrymodeOutcome
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

pub type Devicestatementstatus {
  DevicestatementstatusActive
  DevicestatementstatusCompleted
  DevicestatementstatusEnteredinerror
  DevicestatementstatusIntended
  DevicestatementstatusStopped
  DevicestatementstatusOnhold
}

pub type Consentdatameaning {
  ConsentdatameaningInstance
  ConsentdatameaningRelated
  ConsentdatameaningDependents
  ConsentdatameaningAuthoredby
}

pub type Bindingstrength {
  BindingstrengthRequired
  BindingstrengthExtensible
  BindingstrengthPreferred
  BindingstrengthExample
}

pub type Namingsystemidentifiertype {
  NamingsystemidentifiertypeOid
  NamingsystemidentifiertypeUuid
  NamingsystemidentifiertypeUri
  NamingsystemidentifiertypeOther
}

pub type Compositionattestationmode {
  CompositionattestationmodePersonal
  CompositionattestationmodeProfessional
  CompositionattestationmodeLegal
  CompositionattestationmodeOfficial
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

pub type Fmstatus {
  FmstatusActive
  FmstatusCancelled
  FmstatusDraft
  FmstatusEnteredinerror
}

pub type Requestpriority {
  RequestpriorityRoutine
  RequestpriorityUrgent
  RequestpriorityAsap
  RequestpriorityStat
}

pub type Actionrelationshiptype {
  ActionrelationshiptypeBeforestart
  ActionrelationshiptypeBefore
  ActionrelationshiptypeBeforeend
  ActionrelationshiptypeConcurrentwithstart
  ActionrelationshiptypeConcurrent
  ActionrelationshiptypeConcurrentwithend
  ActionrelationshiptypeAfterstart
  ActionrelationshiptypeAfter
  ActionrelationshiptypeAfterend
}

pub type Actionparticipanttype {
  ActionparticipanttypePatient
  ActionparticipanttypePractitioner
  ActionparticipanttypeRelatedperson
  ActionparticipanttypeDevice
}

pub type Actionconditionkind {
  ActionconditionkindApplicability
  ActionconditionkindStart
  ActionconditionkindStop
}

pub type Structuredefinitionkind {
  StructuredefinitionkindPrimitivetype
  StructuredefinitionkindComplextype
  StructuredefinitionkindResource
  StructuredefinitionkindLogical
}

pub type Observationrangecategory {
  ObservationrangecategoryReference
  ObservationrangecategoryCritical
  ObservationrangecategoryAbsolute
}

pub type Subscriptionstatus {
  SubscriptionstatusRequested
  SubscriptionstatusActive
  SubscriptionstatusError
  SubscriptionstatusOff
}

pub type Codesearchsupport {
  CodesearchsupportExplicit
  CodesearchsupportAll
}

pub type Remittanceoutcome {
  RemittanceoutcomeQueued
  RemittanceoutcomeComplete
  RemittanceoutcomeError
  RemittanceoutcomePartial
}

pub type Responsecode {
  ResponsecodeOk
  ResponsecodeTransienterror
  ResponsecodeFatalerror
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

pub type Conditionalreadstatus {
  ConditionalreadstatusNotsupported
  ConditionalreadstatusModifiedsince
  ConditionalreadstatusNotmatch
  ConditionalreadstatusFullsupport
}

pub type Productstoragescale {
  ProductstoragescaleFarenheit
  ProductstoragescaleCelsius
  ProductstoragescaleKelvin
}

pub type Accountstatus {
  AccountstatusActive
  AccountstatusInactive
  AccountstatusEnteredinerror
  AccountstatusOnhold
  AccountstatusUnknown
}

pub type Questionnaireanswersstatus {
  QuestionnaireanswersstatusInprogress
  QuestionnaireanswersstatusCompleted
  QuestionnaireanswersstatusAmended
  QuestionnaireanswersstatusEnteredinerror
  QuestionnaireanswersstatusStopped
}

pub type Researchstudystatus {
  ResearchstudystatusActive
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

pub type Medicationrequeststatus {
  MedicationrequeststatusActive
  MedicationrequeststatusOnhold
  MedicationrequeststatusCancelled
  MedicationrequeststatusCompleted
  MedicationrequeststatusEnteredinerror
  MedicationrequeststatusStopped
  MedicationrequeststatusDraft
  MedicationrequeststatusUnknown
}

pub type Careplanactivitystatus {
  CareplanactivitystatusNotstarted
  CareplanactivitystatusScheduled
  CareplanactivitystatusInprogress
  CareplanactivitystatusOnhold
  CareplanactivitystatusCompleted
  CareplanactivitystatusCancelled
  CareplanactivitystatusUnknown
  CareplanactivitystatusEnteredinerror
}

pub type Productcategory {
  ProductcategoryOrgan
  ProductcategoryTissue
  ProductcategoryFluid
  ProductcategoryCells
  ProductcategoryBiologicalagent
}

pub type Measurereportstatus {
  MeasurereportstatusComplete
  MeasurereportstatusPending
  MeasurereportstatusError
}

pub type Namingsystemtype {
  NamingsystemtypeCodesystem
  NamingsystemtypeIdentifier
  NamingsystemtypeRoot
}

pub type Relationtype {
  RelationtypeTriggers
  RelationtypeIsreplacedby
}

pub type Orientationtype {
  OrientationtypeSense
  OrientationtypeAntisense
}

pub type Metriccalibrationtype {
  MetriccalibrationtypeUnspecified
  MetriccalibrationtypeOffset
  MetriccalibrationtypeGain
  MetriccalibrationtypeTwopoint
}

pub type Locationstatus {
  LocationstatusActive
  LocationstatusSuspended
  LocationstatusInactive
}

pub type Allergyintolerancetype {
  AllergyintolerancetypeAllergy
  AllergyintolerancetypeIntolerance
}

pub type Notetype {
  NotetypeDisplay
  NotetypePrint
  NotetypePrintoper
}

pub type Consentprovisiontype {
  ConsentprovisiontypeDeny
  ConsentprovisiontypePermit
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

pub type Qualitytype {
  QualitytypeIndel
  QualitytypeSnp
  QualitytypeUnknown
}

pub type Reactioneventseverity {
  ReactioneventseverityMild
  ReactioneventseverityModerate
  ReactioneventseveritySevere
}

pub type Capabilitystatementkind {
  CapabilitystatementkindInstance
  CapabilitystatementkindCapability
  CapabilitystatementkindRequirements
}

pub type Reportactionresultcodes {
  ReportactionresultcodesPass
  ReportactionresultcodesSkip
  ReportactionresultcodesFail
  ReportactionresultcodesWarning
  ReportactionresultcodesError
}

pub type Questionnaireenablebehavior {
  QuestionnaireenablebehaviorAll
  QuestionnaireenablebehaviorAny
}

pub type Compartmenttype {
  CompartmenttypePatient
  CompartmenttypeEncounter
  CompartmenttypeRelatedperson
  CompartmenttypePractitioner
  CompartmenttypeDevice
}

pub type Allergyintolerancecategory {
  AllergyintolerancecategoryFood
  AllergyintolerancecategoryMedication
  AllergyintolerancecategoryEnvironment
  AllergyintolerancecategoryBiologic
}

pub type Adverseeventactuality {
  AdverseeventactualityActual
  AdverseeventactualityPotential
}

pub type Observationstatus {
  ObservationstatusRegistered
  ObservationstatusPreliminary
  ObservationstatusFinal
  ObservationstatusAmended
  ObservationstatusCancelled
  ObservationstatusEnteredinerror
  ObservationstatusUnknown
}

pub type Itemtype {
  ItemtypeGroup
  ItemtypeDisplay
  ItemtypeQuestion
}

pub type Sequencetype {
  SequencetypeAa
  SequencetypeDna
  SequencetypeRna
}

pub type Status {
  StatusAttested
  StatusValidated
  StatusInprocess
  StatusReqrevalid
  StatusValfail
  StatusRevalfail
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

pub type Liststatus {
  ListstatusCurrent
  ListstatusRetired
  ListstatusEnteredinerror
}

pub type Codesystemcontentmode {
  CodesystemcontentmodeNotpresent
  CodesystemcontentmodeExample
  CodesystemcontentmodeFragment
  CodesystemcontentmodeComplete
  CodesystemcontentmodeSupplement
}

pub type Requestintent {
  RequestintentProposal
  RequestintentPlan
  RequestintentDirective
  RequestintentOrder
  RequestintentOption
}

pub type Encounterlocationstatus {
  EncounterlocationstatusPlanned
  EncounterlocationstatusActive
  EncounterlocationstatusReserved
  EncounterlocationstatusCompleted
}

pub type Mapinputmode {
  MapinputmodeSource
  MapinputmodeTarget
}

pub type Auditeventaction {
  AuditeventactionC
  AuditeventactionR
  AuditeventactionU
  AuditeventactionD
  AuditeventactionE
}

pub type Medicationknowledgestatus {
  MedicationknowledgestatusActive
  MedicationknowledgestatusInactive
  MedicationknowledgestatusEnteredinerror
}

pub type Actionprecheckbehavior {
  ActionprecheckbehaviorYes
  ActionprecheckbehaviorNo
}

pub type Researchsubjectstatus {
  ResearchsubjectstatusCandidate
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

pub type Participationstatus {
  ParticipationstatusAccepted
  ParticipationstatusDeclined
  ParticipationstatusTentative
  ParticipationstatusNeedsaction
}

pub type Goalstatus {
  GoalstatusProposed
  GoalstatusPlanned
  GoalstatusAccepted
  GoalstatusCancelled
  GoalstatusEnteredinerror
  GoalstatusRejected
}

pub type Graphcompartmentrule {
  GraphcompartmentruleIdentical
  GraphcompartmentruleMatching
  GraphcompartmentruleDifferent
  GraphcompartmentruleCustom
}

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
}

pub type Diagnosticreportstatus {
  DiagnosticreportstatusRegistered
  DiagnosticreportstatusPartial
  DiagnosticreportstatusFinal
  DiagnosticreportstatusAmended
  DiagnosticreportstatusCancelled
  DiagnosticreportstatusEnteredinerror
  DiagnosticreportstatusUnknown
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

pub type Productstatus {
  ProductstatusAvailable
  ProductstatusUnavailable
}

pub type Mapsourcelistmode {
  MapsourcelistmodeFirst
  MapsourcelistmodeNotfirst
  MapsourcelistmodeLast
  MapsourcelistmodeNotlast
  MapsourcelistmodeOnlyone
}

pub type Udientrytype {
  UdientrytypeBarcode
  UdientrytypeRfid
  UdientrytypeManual
  UdientrytypeCard
  UdientrytypeSelfreported
  UdientrytypeUnknown
}

pub type Consentstatecodes {
  ConsentstatecodesDraft
  ConsentstatecodesProposed
  ConsentstatecodesActive
  ConsentstatecodesRejected
  ConsentstatecodesInactive
  ConsentstatecodesEnteredinerror
}

pub type Documentreferencestatus {
  DocumentreferencestatusCurrent
  DocumentreferencestatusSuperseded
  DocumentreferencestatusEnteredinerror
}

pub type Eligibilityrequestpurpose {
  EligibilityrequestpurposeAuthrequirements
  EligibilityrequestpurposeBenefits
  EligibilityrequestpurposeDiscovery
  EligibilityrequestpurposeValidation
}

pub type Typederivationrule {
  TypederivationruleSpecialization
  TypederivationruleConstraint
}

pub type Assertresponsecodetypes {
  AssertresponsecodetypesOkay
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

pub type Reportparticipanttype {
  ReportparticipanttypeTestengine
  ReportparticipanttypeClient
  ReportparticipanttypeServer
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

pub type Strandtype {
  StrandtypeWatson
  StrandtypeCrick
}

pub type Detectedissueseverity {
  DetectedissueseverityHigh
  DetectedissueseverityModerate
  DetectedissueseverityLow
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

pub type Devicestatus {
  DevicestatusActive
  DevicestatusInactive
  DevicestatusEnteredinerror
  DevicestatusUnknown
}

pub type Linkagetype {
  LinkagetypeSource
  LinkagetypeAlternate
  LinkagetypeHistorical
}

pub type Guideparametercode {
  GuideparametercodeApply
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

pub type Searchxpathusage {
  SearchxpathusageNormal
  SearchxpathusagePhonetic
  SearchxpathusageNearby
  SearchxpathusageDistance
  SearchxpathusageOther
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
}

pub type Actiongroupingbehavior {
  ActiongroupingbehaviorVisualgroup
  ActiongroupingbehaviorLogicalgroup
  ActiongroupingbehaviorSentencegroup
}

pub type Mapmodelmode {
  MapmodelmodeSource
  MapmodelmodeQueried
  MapmodelmodeTarget
  MapmodelmodeProduced
}

pub type Imagingstudystatus {
  ImagingstudystatusRegistered
  ImagingstudystatusAvailable
  ImagingstudystatusCancelled
  ImagingstudystatusEnteredinerror
  ImagingstudystatusUnknown
}

pub type Compositionstatus {
  CompositionstatusPreliminary
  CompositionstatusFinal
  CompositionstatusAmended
  CompositionstatusEnteredinerror
}

pub type Conceptmapequivalence {
  ConceptmapequivalenceRelatedto
  ConceptmapequivalenceUnmatched
}

pub type Identityassurancelevel {
  IdentityassurancelevelLevel1
  IdentityassurancelevelLevel2
  IdentityassurancelevelLevel3
  IdentityassurancelevelLevel4
}

pub type Requestresourcetypes {
  RequestresourcetypesAppointment
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

pub type Allergyintolerancecriticality {
  AllergyintolerancecriticalityLow
  AllergyintolerancecriticalityHigh
  AllergyintolerancecriticalityUnabletoassess
}

pub type Provenanceentityrole {
  ProvenanceentityroleDerivation
}

pub type Groupmeasure {
  GroupmeasureMean
  GroupmeasureMedian
  GroupmeasureMeanofmean
  GroupmeasureMeanofmedian
  GroupmeasureMedianofmean
  GroupmeasureMedianofmedian
}

pub type Conditionaldeletestatus {
  ConditionaldeletestatusNotsupported
  ConditionaldeletestatusSingle
  ConditionaldeletestatusMultiple
}

pub type Medicationstatus {
  MedicationstatusActive
  MedicationstatusInactive
  MedicationstatusEnteredinerror
}

pub type Metriccategory {
  MetriccategoryMeasurement
  MetriccategorySetting
  MetriccategoryCalculation
  MetriccategoryUnspecified
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
}

pub type Guidepagegeneration {
  GuidepagegenerationHtml
  GuidepagegenerationMarkdown
  GuidepagegenerationXml
  GuidepagegenerationGenerated
}

pub type Messageheaderresponserequest {
  MessageheaderresponserequestAlways
  MessageheaderresponserequestOnerror
  MessageheaderresponserequestNever
  MessageheaderresponserequestOnsuccess
}

pub type Devicenametype {
  DevicenametypeUdilabelname
  DevicenametypeUserfriendlyname
  DevicenametypePatientreportedname
  DevicenametypeManufacturername
  DevicenametypeModelname
  DevicenametypeOther
}

pub type Subscriptionchanneltype {
  SubscriptionchanneltypeResthook
  SubscriptionchanneltypeWebsocket
  SubscriptionchanneltypeEmail
  SubscriptionchanneltypeSms
  SubscriptionchanneltypeMessage
}

pub type Referencehandlingpolicy {
  ReferencehandlingpolicyLiteral
  ReferencehandlingpolicyLogical
  ReferencehandlingpolicyResolves
  ReferencehandlingpolicyEnforced
  ReferencehandlingpolicyLocal
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
}

pub type Locationmode {
  LocationmodeInstance
  LocationmodeKind
}

pub type Extensioncontexttype {
  ExtensioncontexttypeFhirpath
  ExtensioncontexttypeElement
  ExtensioncontexttypeExtension
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

pub type Metricoperationalstatus {
  MetricoperationalstatusOn
  MetricoperationalstatusOff
  MetricoperationalstatusStandby
  MetricoperationalstatusEnteredinerror
}

pub type Messagesignificancecategory {
  MessagesignificancecategoryConsequence
  MessagesignificancecategoryCurrency
  MessagesignificancecategoryNotification
}

pub type Documentmode {
  DocumentmodeProducer
  DocumentmodeConsumer
}

pub type Variabletype {
  VariabletypeDichotomous
  VariabletypeContinuous
  VariabletypeDescriptive
}

pub type Auditeventoutcome {
  Auditeventoutcome0
  Auditeventoutcome4
  Auditeventoutcome8
  Auditeventoutcome12
}

pub type Visionbasecodes {
  VisionbasecodesUp
  VisionbasecodesDown
  VisionbasecodesIn
  VisionbasecodesOut
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

pub type Actioncardinalitybehavior {
  ActioncardinalitybehaviorSingle
  ActioncardinalitybehaviorMultiple
}

pub type Substancestatus {
  SubstancestatusActive
  SubstancestatusInactive
  SubstancestatusEnteredinerror
}

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningGroupedby
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningClassifiedwith
}

pub type Encounterstatus {
  EncounterstatusPlanned
  EncounterstatusArrived
  EncounterstatusTriaged
  EncounterstatusInprogress
  EncounterstatusOnleave
  EncounterstatusFinished
  EncounterstatusCancelled
  EncounterstatusEnteredinerror
  EncounterstatusUnknown
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
  FilteroperatorExists
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

pub type Claimuse {
  ClaimuseClaim
  ClaimusePreauthorization
  ClaimusePredetermination
}

pub type Explanationofbenefitstatus {
  ExplanationofbenefitstatusActive
  ExplanationofbenefitstatusCancelled
  ExplanationofbenefitstatusDraft
  ExplanationofbenefitstatusEnteredinerror
}

pub type Slotstatus {
  SlotstatusBusy
  SlotstatusFree
  SlotstatusBusyunavailable
  SlotstatusBusytentative
  SlotstatusEnteredinerror
}

pub type Examplescenarioactortype {
  ExamplescenarioactortypePerson
  ExamplescenarioactortypeEntity
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

pub type Mapgrouptypemode {
  MapgrouptypemodeNone
  MapgrouptypemodeTypes
  MapgrouptypemodeTypeandtypes
}

pub type Documentrelationshiptype {
  DocumentrelationshiptypeReplaces
  DocumentrelationshiptypeTransforms
  DocumentrelationshiptypeSigns
  DocumentrelationshiptypeAppends
}

pub type Publicationstatus {
  PublicationstatusDraft
  PublicationstatusActive
  PublicationstatusRetired
  PublicationstatusUnknown
}

pub type Reportresultcodes {
  ReportresultcodesPass
  ReportresultcodesFail
  ReportresultcodesPending
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

pub type Supplydeliverystatus {
  SupplydeliverystatusInprogress
  SupplydeliverystatusCompleted
  SupplydeliverystatusAbandoned
  SupplydeliverystatusEnteredinerror
}

pub type Eventcapabilitymode {
  EventcapabilitymodeSender
  EventcapabilitymodeReceiver
}

pub type Issuetype {
  IssuetypeInvalid
  IssuetypeSecurity
  IssuetypeProcessing
  IssuetypeTransient
  IssuetypeInformational
}

pub type Metriccalibrationstate {
  MetriccalibrationstateNotcalibrated
  MetriccalibrationstateCalibrationrequired
  MetriccalibrationstateCalibrated
  MetriccalibrationstateUnspecified
}

pub type Networktype {
  Networktype1
  Networktype2
  Networktype3
  Networktype4
  Networktype5
}

pub type Exposurestate {
  ExposurestateExposure
  ExposurestateExposurealternative
}

pub type Guidanceresponsestatus {
  GuidanceresponsestatusSuccess
  GuidanceresponsestatusDatarequested
  GuidanceresponsestatusDatarequired
  GuidanceresponsestatusInprogress
  GuidanceresponsestatusFailure
  GuidanceresponsestatusEnteredinerror
}

pub type Grouptype {
  GrouptypePerson
  GrouptypeAnimal
  GrouptypePractitioner
  GrouptypeDevice
  GrouptypeMedication
  GrouptypeSubstance
}

pub type Operationkind {
  OperationkindOperation
  OperationkindQuery
}

pub type Specimencontainedpreference {
  SpecimencontainedpreferencePreferred
  SpecimencontainedpreferenceAlternate
}

pub type Httpverb {
  HttpverbGet
  HttpverbHead
  HttpverbPost
  HttpverbPut
  HttpverbDelete
  HttpverbPatch
}

pub type Researchelementtype {
  ResearchelementtypePopulation
  ResearchelementtypeExposure
  ResearchelementtypeOutcome
}

pub type Endpointstatus {
  EndpointstatusActive
  EndpointstatusSuspended
  EndpointstatusError
  EndpointstatusOff
  EndpointstatusEnteredinerror
  EndpointstatusTest
}
