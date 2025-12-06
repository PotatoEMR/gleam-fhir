pub type Fhirtypes {
  FhirtypesBase
}

pub type Administrativegender {
  AdministrativegenderMale
  AdministrativegenderFemale
  AdministrativegenderOther
  AdministrativegenderUnknown
}

pub type Bindingstrength {
  BindingstrengthRequired
  BindingstrengthExtensible
  BindingstrengthPreferred
  BindingstrengthExample
}

pub type Conceptmaprelationship {
  ConceptmaprelationshipRelatedto
  ConceptmaprelationshipNotrelatedto
}

pub type Documentreferencestatus {
  DocumentreferencestatusCurrent
  DocumentreferencestatusSuperseded
  DocumentreferencestatusEnteredinerror
}

pub type Fhirversion {
  Fhirversion001
  Fhirversion005
  Fhirversion006
  Fhirversion011
  Fhirversion00
  Fhirversion04
  Fhirversion05
  Fhirversion10
  Fhirversion11
  Fhirversion14
  Fhirversion16
  Fhirversion18
  Fhirversion30
  Fhirversion33
  Fhirversion35
  Fhirversion40
  Fhirversion41
  Fhirversion42
  Fhirversion43
  Fhirversion44
  Fhirversion45
  Fhirversion46
  Fhirversion50
}

pub type Notetype {
  NotetypeDisplay
  NotetypePrint
  NotetypePrintoper
}

pub type Publicationstatus {
  PublicationstatusDraft
  PublicationstatusActive
  PublicationstatusRetired
  PublicationstatusUnknown
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

pub type Conformanceexpectation {
  ConformanceexpectationShall
  ConformanceexpectationShould
  ConformanceexpectationMay
  ConformanceexpectationShouldnot
}

pub type Operationparameteruse {
  OperationparameteruseIn
  OperationparameteruseOut
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

pub type Requeststatus {
  RequeststatusDraft
  RequeststatusActive
  RequeststatusOnhold
  RequeststatusRevoked
  RequeststatusCompleted
  RequeststatusEnteredinerror
  RequeststatusUnknown
}

pub type Requestintent {
  RequestintentProposal
  RequestintentPlan
  RequestintentDirective
  RequestintentOrder
  RequestintentOption
}

pub type Requestpriority {
  RequestpriorityRoutine
  RequestpriorityUrgent
  RequestpriorityAsap
  RequestpriorityStat
}

pub type Flagstatus {
  FlagstatusActive
  FlagstatusInactive
  FlagstatusEnteredinerror
}

pub type Allergyintolerancecategory {
  AllergyintolerancecategoryFood
  AllergyintolerancecategoryMedication
  AllergyintolerancecategoryEnvironment
  AllergyintolerancecategoryBiologic
}

pub type Allergyintolerancecriticality {
  AllergyintolerancecriticalityLow
  AllergyintolerancecriticalityHigh
  AllergyintolerancecriticalityUnabletoassess
}

pub type Reactioneventseverity {
  ReactioneventseverityMild
  ReactioneventseverityModerate
  ReactioneventseveritySevere
}

pub type Careteamstatus {
  CareteamstatusProposed
  CareteamstatusActive
  CareteamstatusSuspended
  CareteamstatusInactive
  CareteamstatusEnteredinerror
}

pub type Capabilitystatementkind {
  CapabilitystatementkindInstance
  CapabilitystatementkindCapability
  CapabilitystatementkindRequirements
}

pub type Restfulcapabilitymode {
  RestfulcapabilitymodeClient
  RestfulcapabilitymodeServer
}

pub type Versioningpolicy {
  VersioningpolicyNoversion
  VersioningpolicyVersioned
  VersioningpolicyVersionedupdate
}

pub type Conditionalreadstatus {
  ConditionalreadstatusNotsupported
  ConditionalreadstatusModifiedsince
  ConditionalreadstatusNotmatch
  ConditionalreadstatusFullsupport
}

pub type Conditionaldeletestatus {
  ConditionaldeletestatusNotsupported
  ConditionaldeletestatusSingle
  ConditionaldeletestatusMultiple
}

pub type Referencehandlingpolicy {
  ReferencehandlingpolicyLiteral
  ReferencehandlingpolicyLogical
  ReferencehandlingpolicyResolves
  ReferencehandlingpolicyEnforced
  ReferencehandlingpolicyLocal
}

pub type Eventcapabilitymode {
  EventcapabilitymodeSender
  EventcapabilitymodeReceiver
}

pub type Documentmode {
  DocumentmodeProducer
  DocumentmodeConsumer
}

pub type Detectedissueseverity {
  DetectedissueseverityHigh
  DetectedissueseverityModerate
  DetectedissueseverityLow
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

pub type Devicestatus {
  DevicestatusActive
  DevicestatusInactive
  DevicestatusEnteredinerror
}

pub type Devicenametype {
  DevicenametypeRegisteredname
  DevicenametypeUserfriendlyname
  DevicenametypePatientreportedname
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

pub type Sequencetype {
  SequencetypeAa
  SequencetypeDna
  SequencetypeRna
}

pub type Orientationtype {
  OrientationtypeSense
  OrientationtypeAntisense
}

pub type Strandtype {
  StrandtypeWatson
  StrandtypeCrick
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

pub type Compositionstatus {
  CompositionstatusRegistered
  CompositionstatusPartial
  CompositionstatusFinal
  CompositionstatusAmended
  CompositionstatusCancelled
  CompositionstatusEnteredinerror
  CompositionstatusDeprecated
  CompositionstatusUnknown
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

pub type Encounterlocationstatus {
  EncounterlocationstatusPlanned
  EncounterlocationstatusActive
  EncounterlocationstatusReserved
  EncounterlocationstatusCompleted
}

pub type Historystatus {
  HistorystatusPartial
  HistorystatusCompleted
  HistorystatusEnteredinerror
  HistorystatusHealthunknown
}

pub type Goalstatus {
  GoalstatusProposed
  GoalstatusPlanned
  GoalstatusAccepted
  GoalstatusCancelled
  GoalstatusEnteredinerror
  GoalstatusRejected
}

pub type Graphcompartmentuse {
  GraphcompartmentuseWhere
  GraphcompartmentuseRequires
}

pub type Graphcompartmentrule {
  GraphcompartmentruleIdentical
  GraphcompartmentruleMatching
  GraphcompartmentruleDifferent
  GraphcompartmentruleCustom
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

pub type Groupmembershipbasis {
  GroupmembershipbasisDefinitional
  GroupmembershipbasisEnumerated
}

pub type Imagingselectionstatus {
  ImagingselectionstatusAvailable
  ImagingselectionstatusEnteredinerror
  ImagingselectionstatusUnknown
}

pub type Imagingselection2dgraphictype {
  Imagingselection2dgraphictypePoint
  Imagingselection2dgraphictypePolyline
  Imagingselection2dgraphictypeInterpolated
  Imagingselection2dgraphictypeCircle
  Imagingselection2dgraphictypeEllipse
}

pub type Imagingselection3dgraphictype {
  Imagingselection3dgraphictypePoint
  Imagingselection3dgraphictypeMultipoint
  Imagingselection3dgraphictypePolyline
  Imagingselection3dgraphictypePolygon
  Imagingselection3dgraphictypeEllipse
  Imagingselection3dgraphictypeEllipsoid
}

pub type Imagingstudystatus {
  ImagingstudystatusRegistered
  ImagingstudystatusAvailable
  ImagingstudystatusCancelled
  ImagingstudystatusEnteredinerror
  ImagingstudystatusUnknown
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

pub type Guidepagegeneration {
  GuidepagegenerationHtml
  GuidepagegenerationMarkdown
  GuidepagegenerationXml
  GuidepagegenerationGenerated
}

pub type Linkagetype {
  LinkagetypeSource
  LinkagetypeAlternate
  LinkagetypeHistorical
}

pub type Liststatus {
  ListstatusCurrent
  ListstatusRetired
  ListstatusEnteredinerror
}

pub type Listmode {
  ListmodeWorking
  ListmodeSnapshot
  ListmodeChanges
}

pub type Locationstatus {
  LocationstatusActive
  LocationstatusSuspended
  LocationstatusInactive
}

pub type Locationmode {
  LocationmodeInstance
  LocationmodeKind
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

pub type Medicationrequeststatus {
  MedicationrequeststatusActive
  MedicationrequeststatusOnhold
  MedicationrequeststatusEnded
  MedicationrequeststatusEnteredinerror
  MedicationrequeststatusDraft
  MedicationrequeststatusUnknown
}

pub type Medicationrequestintent {
  MedicationrequestintentProposal
  MedicationrequestintentPlan
  MedicationrequestintentOrder
  MedicationrequestintentOption
}

pub type Medicationstatementstatus {
  MedicationstatementstatusRecorded
  MedicationstatementstatusEnteredinerror
  MedicationstatementstatusDraft
}

pub type Medicationstatus {
  MedicationstatusActive
  MedicationstatusInactive
  MedicationstatusEnteredinerror
}

pub type Responsecode {
  ResponsecodeOk
  ResponsecodeTransienterror
  ResponsecodeFatalerror
}

pub type Observationtriggeredbytype {
  ObservationtriggeredbytypeReflex
  ObservationtriggeredbytypeRepeat
  ObservationtriggeredbytypeRerun
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

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
  IssueseveritySuccess
}

pub type Issuetype {
  IssuetypeInvalid
  IssuetypeSecurity
  IssuetypeProcessing
  IssuetypeTransient
  IssuetypeInformational
  IssuetypeSuccess
}

pub type Linktype {
  LinktypeReplacedby
  LinktypeReplaces
  LinktypeRefer
  LinktypeSeealso
}

pub type Provenanceentityrole {
  ProvenanceentityroleRevision
  ProvenanceentityroleQuotation
  ProvenanceentityroleSource
  ProvenanceentityroleInstantiates
  ProvenanceentityroleRemoval
}

pub type Itemtype {
  ItemtypeGroup
  ItemtypeDisplay
  ItemtypeQuestion
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

pub type Questionnaireenablebehavior {
  QuestionnaireenablebehaviorAll
  QuestionnaireenablebehaviorAny
}

pub type Questionnaireanswersstatus {
  QuestionnaireanswersstatusInprogress
  QuestionnaireanswersstatusCompleted
  QuestionnaireanswersstatusAmended
  QuestionnaireanswersstatusEnteredinerror
  QuestionnaireanswersstatusStopped
}

pub type Auditeventaction {
  AuditeventactionC
  AuditeventactionR
  AuditeventactionU
  AuditeventactionD
  AuditeventactionE
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

pub type Specimenstatus {
  SpecimenstatusAvailable
  SpecimenstatusUnavailable
  SpecimenstatusUnsatisfactory
  SpecimenstatusEnteredinerror
}

pub type Specimencombined {
  SpecimencombinedGrouped
  SpecimencombinedPooled
}

pub type Substancestatus {
  SubstancestatusActive
  SubstancestatusInactive
  SubstancestatusEnteredinerror
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

pub type Conceptmappropertytype {
  ConceptmappropertytypeCoding
  ConceptmappropertytypeString
  ConceptmappropertytypeInteger
  ConceptmappropertytypeBoolean
  ConceptmappropertytypeDatetime
  ConceptmappropertytypeDecimal
  ConceptmappropertytypeCode
}

pub type Conceptmapattributetype {
  ConceptmapattributetypeCode
  ConceptmapattributetypeCoding
  ConceptmapattributetypeString
  ConceptmapattributetypeBoolean
  ConceptmapattributetypeQuantity
}

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeUsesourcecode
  ConceptmapunmappedmodeFixed
  ConceptmapunmappedmodeOthermap
}

pub type Slotstatus {
  SlotstatusBusy
  SlotstatusFree
  SlotstatusBusyunavailable
  SlotstatusBusytentative
  SlotstatusEnteredinerror
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

pub type Participationstatus {
  ParticipationstatusAccepted
  ParticipationstatusDeclined
  ParticipationstatusTentative
  ParticipationstatusNeedsaction
}

pub type Namingsystemtype {
  NamingsystemtypeCodesystem
  NamingsystemtypeIdentifier
  NamingsystemtypeRoot
}

pub type Namingsystemidentifiertype {
  NamingsystemidentifiertypeOid
  NamingsystemidentifiertypeUuid
  NamingsystemidentifiertypeUri
  NamingsystemidentifiertypeIristem
  NamingsystemidentifiertypeV2csmnemonic
  NamingsystemidentifiertypeOther
}

pub type Endpointstatus {
  EndpointstatusActive
  EndpointstatusSuspended
  EndpointstatusError
  EndpointstatusOff
  EndpointstatusEnteredinerror
}

pub type Subscriptionpayloadcontent {
  SubscriptionpayloadcontentEmpty
  SubscriptionpayloadcontentIdonly
  SubscriptionpayloadcontentFullresource
}

pub type Subscriptionnotificationtype {
  SubscriptionnotificationtypeHandshake
  SubscriptionnotificationtypeHeartbeat
  SubscriptionnotificationtypeEventnotification
  SubscriptionnotificationtypeQuerystatus
  SubscriptionnotificationtypeQueryevent
}

pub type Subscriptiontopiccrbehavior {
  SubscriptiontopiccrbehaviorTestpasses
  SubscriptiontopiccrbehaviorTestfails
}

pub type Operationkind {
  OperationkindOperation
  OperationkindQuery
}

pub type Operationparameterscope {
  OperationparameterscopeInstance
  OperationparameterscopeType
  OperationparameterscopeSystem
}

pub type Coveragekind {
  CoveragekindInsurance
  CoveragekindSelfpay
  CoveragekindOther
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

pub type Eligibilityrequestpurpose {
  EligibilityrequestpurposeAuthrequirements
  EligibilityrequestpurposeBenefits
  EligibilityrequestpurposeDiscovery
  EligibilityrequestpurposeValidation
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

pub type Searchentrymode {
  SearchentrymodeMatch
  SearchentrymodeInclude
  SearchentrymodeOutcome
}

pub type Httpverb {
  HttpverbGet
  HttpverbHead
  HttpverbPost
  HttpverbPut
  HttpverbDelete
  HttpverbPatch
}

pub type Searchprocessingmode {
  SearchprocessingmodeNormal
  SearchprocessingmodePhonetic
  SearchprocessingmodeOther
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

pub type Eligibilityresponsepurpose {
  EligibilityresponsepurposeAuthrequirements
  EligibilityresponsepurposeBenefits
  EligibilityresponsepurposeDiscovery
  EligibilityresponsepurposeValidation
}

pub type Eligibilityoutcome {
  EligibilityoutcomeQueued
  EligibilityoutcomeComplete
  EligibilityoutcomeError
  EligibilityoutcomePartial
}

pub type Enrollmentoutcome {
  EnrollmentoutcomeQueued
  EnrollmentoutcomeComplete
  EnrollmentoutcomeError
  EnrollmentoutcomePartial
}

pub type Paymentoutcome {
  PaymentoutcomeQueued
  PaymentoutcomeComplete
  PaymentoutcomeError
  PaymentoutcomePartial
}

pub type Metricoperationalstatus {
  MetricoperationalstatusOn
  MetricoperationalstatusOff
  MetricoperationalstatusStandby
  MetricoperationalstatusEnteredinerror
}

pub type Metriccategory {
  MetriccategoryMeasurement
  MetriccategorySetting
  MetriccategoryCalculation
  MetriccategoryUnspecified
}

pub type Metriccalibrationtype {
  MetriccalibrationtypeUnspecified
  MetriccalibrationtypeOffset
  MetriccalibrationtypeGain
  MetriccalibrationtypeTwopoint
}

pub type Metriccalibrationstate {
  MetriccalibrationstateNotcalibrated
  MetriccalibrationstateCalibrationrequired
  MetriccalibrationstateCalibrated
  MetriccalibrationstateUnspecified
}

pub type Identityassurancelevel {
  IdentityassurancelevelLevel1
  IdentityassurancelevelLevel2
  IdentityassurancelevelLevel3
  IdentityassurancelevelLevel4
}

pub type Visioneyecodes {
  VisioneyecodesRight
  VisioneyecodesLeft
}

pub type Visionbasecodes {
  VisionbasecodesUp
  VisionbasecodesDown
  VisionbasecodesIn
  VisionbasecodesOut
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

pub type Structuredefinitionkind {
  StructuredefinitionkindPrimitivetype
  StructuredefinitionkindComplextype
  StructuredefinitionkindResource
  StructuredefinitionkindLogical
}

pub type Extensioncontexttype {
  ExtensioncontexttypeFhirpath
  ExtensioncontexttypeElement
  ExtensioncontexttypeExtension
}

pub type Typederivationrule {
  TypederivationruleSpecialization
  TypederivationruleConstraint
}

pub type Mapmodelmode {
  MapmodelmodeSource
  MapmodelmodeQueried
  MapmodelmodeTarget
  MapmodelmodeProduced
}

pub type Mapgrouptypemode {
  MapgrouptypemodeTypes
  MapgrouptypemodeTypeandtypes
}

pub type Mapinputmode {
  MapinputmodeSource
  MapinputmodeTarget
}

pub type Mapsourcelistmode {
  MapsourcelistmodeFirst
  MapsourcelistmodeNotfirst
  MapsourcelistmodeLast
  MapsourcelistmodeNotlast
  MapsourcelistmodeOnlyone
}

pub type Maptargetlistmode {
  MaptargetlistmodeFirst
  MaptargetlistmodeShare
  MaptargetlistmodeLast
  MaptargetlistmodeSingle
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

pub type Supplyrequeststatus {
  SupplyrequeststatusDraft
  SupplyrequeststatusActive
  SupplyrequeststatusSuspended
  SupplyrequeststatusCancelled
  SupplyrequeststatusCompleted
  SupplyrequeststatusEnteredinerror
  SupplyrequeststatusUnknown
}

pub type Supplydeliverystatus {
  SupplydeliverystatusInprogress
  SupplydeliverystatusCompleted
  SupplydeliverystatusAbandoned
  SupplydeliverystatusEnteredinerror
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

pub type Assertdirectioncodes {
  AssertdirectioncodesResponse
  AssertdirectioncodesRequest
}

pub type Assertmanualcompletioncodes {
  AssertmanualcompletioncodesFail
  AssertmanualcompletioncodesPass
  AssertmanualcompletioncodesSkip
  AssertmanualcompletioncodesStop
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

pub type Reportstatuscodes {
  ReportstatuscodesCompleted
  ReportstatuscodesInprogress
  ReportstatuscodesWaiting
  ReportstatuscodesStopped
  ReportstatuscodesEnteredinerror
}

pub type Reportresultcodes {
  ReportresultcodesPass
  ReportresultcodesFail
  ReportresultcodesPending
}

pub type Reportparticipanttype {
  ReportparticipanttypeTestengine
  ReportparticipanttypeClient
  ReportparticipanttypeServer
}

pub type Reportactionresultcodes {
  ReportactionresultcodesPass
  ReportactionresultcodesSkip
  ReportactionresultcodesFail
  ReportactionresultcodesWarning
  ReportactionresultcodesError
}

pub type Accountstatus {
  AccountstatusActive
  AccountstatusInactive
  AccountstatusEnteredinerror
  AccountstatusOnhold
  AccountstatusUnknown
}

pub type Conditionpreconditiontype {
  ConditionpreconditiontypeSensitive
  ConditionpreconditiontypeSpecific
}

pub type Conditionquestionnairepurpose {
  ConditionquestionnairepurposePreadmit
  ConditionquestionnairepurposeDiffdiagnosis
  ConditionquestionnairepurposeOutcome
}

pub type Consentstatecodes {
  ConsentstatecodesDraft
  ConsentstatecodesActive
  ConsentstatecodesInactive
  ConsentstatecodesNotdone
  ConsentstatecodesEnteredinerror
  ConsentstatecodesUnknown
}

pub type Consentprovisiontype {
  ConsentprovisiontypeDeny
  ConsentprovisiontypePermit
}

pub type Consentdatameaning {
  ConsentdatameaningInstance
  ConsentdatameaningRelated
  ConsentdatameaningDependents
  ConsentdatameaningAuthoredby
}

pub type Measurereportstatus {
  MeasurereportstatusComplete
  MeasurereportstatusPending
  MeasurereportstatusError
}

pub type Measurereporttype {
  MeasurereporttypeIndividual
  MeasurereporttypeSubjectlist
  MeasurereporttypeSummary
  MeasurereporttypeDataexchange
}

pub type Submitdataupdatetype {
  SubmitdataupdatetypeIncremental
  SubmitdataupdatetypeSnapshot
}

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningGroupedby
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningClassifiedwith
}

pub type Codesystemcontentmode {
  CodesystemcontentmodeNotpresent
  CodesystemcontentmodeExample
  CodesystemcontentmodeFragment
  CodesystemcontentmodeComplete
  CodesystemcontentmodeSupplement
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

pub type Compartmenttype {
  CompartmenttypePatient
  CompartmenttypeEncounter
  CompartmenttypeRelatedperson
  CompartmenttypePractitioner
  CompartmenttypeDevice
  CompartmenttypeEpisodeofcare
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

pub type Actionconditionkind {
  ActionconditionkindApplicability
  ActionconditionkindStart
  ActionconditionkindStop
}

pub type Actionrelationshiptype {
  ActionrelationshiptypeBefore
  ActionrelationshiptypeConcurrent
  ActionrelationshiptypeAfter
}

pub type Actiongroupingbehavior {
  ActiongroupingbehaviorVisualgroup
  ActiongroupingbehaviorLogicalgroup
  ActiongroupingbehaviorSentencegroup
}

pub type Actionselectionbehavior {
  ActionselectionbehaviorAny
  ActionselectionbehaviorAll
  ActionselectionbehaviorAllornone
  ActionselectionbehaviorExactlyone
  ActionselectionbehaviorAtmostone
  ActionselectionbehaviorOneormore
}

pub type Actionrequiredbehavior {
  ActionrequiredbehaviorMust
  ActionrequiredbehaviorCould
  ActionrequiredbehaviorMustunlessdocumented
}

pub type Actionprecheckbehavior {
  ActionprecheckbehaviorYes
  ActionprecheckbehaviorNo
}

pub type Actioncardinalitybehavior {
  ActioncardinalitybehaviorSingle
  ActioncardinalitybehaviorMultiple
}

pub type Guidanceresponsestatus {
  GuidanceresponsestatusSuccess
  GuidanceresponsestatusDatarequested
  GuidanceresponsestatusDatarequired
  GuidanceresponsestatusInprogress
  GuidanceresponsestatusFailure
  GuidanceresponsestatusEnteredinerror
}

pub type Messagesignificancecategory {
  MessagesignificancecategoryConsequence
  MessagesignificancecategoryCurrency
  MessagesignificancecategoryNotification
}

pub type Messageheaderresponserequest {
  MessageheaderresponserequestAlways
  MessageheaderresponserequestOnerror
  MessageheaderresponserequestNever
  MessageheaderresponserequestOnsuccess
}

pub type Adverseeventactuality {
  AdverseeventactualityActual
  AdverseeventactualityPotential
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

pub type Specimencontainedpreference {
  SpecimencontainedpreferencePreferred
  SpecimencontainedpreferenceAlternate
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

pub type Observationrangecategory {
  ObservationrangecategoryReference
  ObservationrangecategoryCritical
  ObservationrangecategoryAbsolute
}

pub type Examplescenarioactortype {
  ExamplescenarioactortypePerson
  ExamplescenarioactortypeSystem
}

pub type Codesearchsupport {
  CodesearchsupportIncompose
  CodesearchsupportInexpansion
  CodesearchsupportIncomposeorexpansion
}

pub type Invoicestatus {
  InvoicestatusDraft
  InvoicestatusIssued
  InvoicestatusBalanced
  InvoicestatusCancelled
  InvoicestatusEnteredinerror
}

pub type Ingredientmanufacturerrole {
  IngredientmanufacturerroleAllowed
  IngredientmanufacturerrolePossible
  IngredientmanufacturerroleActual
}

pub type Medicationknowledgestatus {
  MedicationknowledgestatusActive
  MedicationknowledgestatusEnteredinerror
  MedicationknowledgestatusInactive
}

pub type Devicecorrectiveactionscope {
  DevicecorrectiveactionscopeModel
  DevicecorrectiveactionscopeLotnumbers
  DevicecorrectiveactionscopeSerialnumbers
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

pub type Variablehandling {
  VariablehandlingContinuous
  VariablehandlingDichotomous
  VariablehandlingOrdinal
  VariablehandlingPolychotomous
}

pub type Clinicalusedefinitiontype {
  ClinicalusedefinitiontypeIndication
  ClinicalusedefinitiontypeContraindication
  ClinicalusedefinitiontypeInteraction
  ClinicalusedefinitiontypeUndesirableeffect
  ClinicalusedefinitiontypeWarning
}

pub type Nutritionproductstatus {
  NutritionproductstatusActive
  NutritionproductstatusInactive
  NutritionproductstatusEnteredinerror
}

pub type Permissionstatus {
  PermissionstatusActive
  PermissionstatusEnteredinerror
  PermissionstatusDraft
  PermissionstatusRejected
}

pub type Inventoryreportstatus {
  InventoryreportstatusDraft
  InventoryreportstatusRequested
  InventoryreportstatusActive
  InventoryreportstatusEnteredinerror
}

pub type Inventoryreportcounttype {
  InventoryreportcounttypeSnapshot
  InventoryreportcounttypeDifference
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

pub type Artifactassessmentinformationtype {
  ArtifactassessmentinformationtypeComment
  ArtifactassessmentinformationtypeClassifier
  ArtifactassessmentinformationtypeRating
  ArtifactassessmentinformationtypeContainer
  ArtifactassessmentinformationtypeResponse
  ArtifactassessmentinformationtypeChangerequest
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

pub type Artifactassessmentdisposition {
  ArtifactassessmentdispositionUnresolved
  ArtifactassessmentdispositionNotpersuasive
  ArtifactassessmentdispositionPersuasive
  ArtifactassessmentdispositionPersuasivewithmodification
  ArtifactassessmentdispositionNotpersuasivewithmodification
}

pub type Transportstatus {
  TransportstatusInprogress
  TransportstatusCompleted
  TransportstatusAbandoned
  TransportstatusCancelled
  TransportstatusPlanned
  TransportstatusEnteredinerror
}

pub type Genomicstudystatus {
  GenomicstudystatusRegistered
  GenomicstudystatusAvailable
  GenomicstudystatusCancelled
  GenomicstudystatusEnteredinerror
  GenomicstudystatusUnknown
}

pub type Formularyitemstatus {
  FormularyitemstatusActive
  FormularyitemstatusEnteredinerror
  FormularyitemstatusInactive
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

pub type Inventoryitemstatus {
  InventoryitemstatusActive
  InventoryitemstatusInactive
  InventoryitemstatusEnteredinerror
  InventoryitemstatusUnknown
}
