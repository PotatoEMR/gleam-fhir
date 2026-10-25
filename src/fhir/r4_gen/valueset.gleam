////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) valuesets

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/list
import gleam/string

pub type Addresstype {
  AddresstypePostal
  AddresstypePhysical
  AddresstypeBoth
}

pub const addresstype: List(Addresstype) = [
  AddresstypePostal,
  AddresstypePhysical,
  AddresstypeBoth,
]

pub fn addresstype_to_json(addresstype: Addresstype) -> Json {
  json.string(addresstype_to_code(addresstype))
}

pub fn addresstype_to_code(addresstype: Addresstype) -> String {
  case addresstype {
    AddresstypePostal -> "postal"
    AddresstypePhysical -> "physical"
    AddresstypeBoth -> "both"
  }
}

pub fn addresstype_parse_code(code: String) -> Result(Addresstype, Nil) {
  case code {
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
    _ ->
      decode.failure(
        AddresstypePostal,
        "code from valueset Addresstype ["
          <> {
          addresstype |> list.map(addresstype_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Addressuse {
  AddressuseHome
  AddressuseWork
  AddressuseTemp
  AddressuseOld
  AddressuseBilling
}

pub const addressuse: List(Addressuse) = [
  AddressuseHome,
  AddressuseWork,
  AddressuseTemp,
  AddressuseOld,
  AddressuseBilling,
]

pub fn addressuse_to_json(addressuse: Addressuse) -> Json {
  json.string(addressuse_to_code(addressuse))
}

pub fn addressuse_to_code(addressuse: Addressuse) -> String {
  case addressuse {
    AddressuseHome -> "home"
    AddressuseWork -> "work"
    AddressuseTemp -> "temp"
    AddressuseOld -> "old"
    AddressuseBilling -> "billing"
  }
}

pub fn addressuse_parse_code(code: String) -> Result(Addressuse, Nil) {
  case code {
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
    _ ->
      decode.failure(
        AddressuseHome,
        "code from valueset Addressuse ["
          <> { addressuse |> list.map(addressuse_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Alltypes {
  AlltypesAddress
  AlltypesAge
  AlltypesAnnotation
  AlltypesAttachment
  AlltypesBackboneelement
  AlltypesCodeableconcept
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
  AlltypesReference
  AlltypesRelatedartifact
  AlltypesSampleddata
  AlltypesSignature
  AlltypesSimplequantity
  AlltypesSubstanceamount
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
  AlltypesAccount
  AlltypesActivitydefinition
  AlltypesAdverseevent
  AlltypesAllergyintolerance
  AlltypesAppointment
  AlltypesAppointmentresponse
  AlltypesAuditevent
  AlltypesBasic
  AlltypesBinary
  AlltypesBiologicallyderivedproduct
  AlltypesBodystructure
  AlltypesBundle
  AlltypesCapabilitystatement
  AlltypesCareplan
  AlltypesCareteam
  AlltypesCatalogentry
  AlltypesChargeitem
  AlltypesChargeitemdefinition
  AlltypesClaim
  AlltypesClaimresponse
  AlltypesClinicalimpression
  AlltypesCodesystem
  AlltypesCommunication
  AlltypesCommunicationrequest
  AlltypesCompartmentdefinition
  AlltypesComposition
  AlltypesConceptmap
  AlltypesCondition
  AlltypesConsent
  AlltypesContract
  AlltypesCoverage
  AlltypesCoverageeligibilityrequest
  AlltypesCoverageeligibilityresponse
  AlltypesDetectedissue
  AlltypesDevice
  AlltypesDevicedefinition
  AlltypesDevicemetric
  AlltypesDevicerequest
  AlltypesDeviceusestatement
  AlltypesDiagnosticreport
  AlltypesDocumentmanifest
  AlltypesDocumentreference
  AlltypesDomainresource
  AlltypesEffectevidencesynthesis
  AlltypesEncounter
  AlltypesEndpoint
  AlltypesEnrollmentrequest
  AlltypesEnrollmentresponse
  AlltypesEpisodeofcare
  AlltypesEventdefinition
  AlltypesEvidence
  AlltypesEvidencevariable
  AlltypesExamplescenario
  AlltypesExplanationofbenefit
  AlltypesFamilymemberhistory
  AlltypesFlag
  AlltypesGoal
  AlltypesGraphdefinition
  AlltypesGroup
  AlltypesGuidanceresponse
  AlltypesHealthcareservice
  AlltypesImagingstudy
  AlltypesImmunization
  AlltypesImmunizationevaluation
  AlltypesImmunizationrecommendation
  AlltypesImplementationguide
  AlltypesInsuranceplan
  AlltypesInvoice
  AlltypesLibrary
  AlltypesLinkage
  AlltypesList
  AlltypesLocation
  AlltypesMeasure
  AlltypesMeasurereport
  AlltypesMedia
  AlltypesMedication
  AlltypesMedicationadministration
  AlltypesMedicationdispense
  AlltypesMedicationknowledge
  AlltypesMedicationrequest
  AlltypesMedicationstatement
  AlltypesMedicinalproduct
  AlltypesMedicinalproductauthorization
  AlltypesMedicinalproductcontraindication
  AlltypesMedicinalproductindication
  AlltypesMedicinalproductingredient
  AlltypesMedicinalproductinteraction
  AlltypesMedicinalproductmanufactured
  AlltypesMedicinalproductpackaged
  AlltypesMedicinalproductpharmaceutical
  AlltypesMedicinalproductundesirableeffect
  AlltypesMessagedefinition
  AlltypesMessageheader
  AlltypesMolecularsequence
  AlltypesNamingsystem
  AlltypesNutritionorder
  AlltypesObservation
  AlltypesObservationdefinition
  AlltypesOperationdefinition
  AlltypesOperationoutcome
  AlltypesOrganization
  AlltypesOrganizationaffiliation
  AlltypesParameters
  AlltypesPatient
  AlltypesPaymentnotice
  AlltypesPaymentreconciliation
  AlltypesPerson
  AlltypesPlandefinition
  AlltypesPractitioner
  AlltypesPractitionerrole
  AlltypesProcedure
  AlltypesProvenance
  AlltypesQuestionnaire
  AlltypesQuestionnaireresponse
  AlltypesRelatedperson
  AlltypesRequestgroup
  AlltypesResearchdefinition
  AlltypesResearchelementdefinition
  AlltypesResearchstudy
  AlltypesResearchsubject
  AlltypesResource
  AlltypesRiskassessment
  AlltypesRiskevidencesynthesis
  AlltypesSchedule
  AlltypesSearchparameter
  AlltypesServicerequest
  AlltypesSlot
  AlltypesSpecimen
  AlltypesSpecimendefinition
  AlltypesStructuredefinition
  AlltypesStructuremap
  AlltypesSubscription
  AlltypesSubstance
  AlltypesSubstancenucleicacid
  AlltypesSubstancepolymer
  AlltypesSubstanceprotein
  AlltypesSubstancereferenceinformation
  AlltypesSubstancesourcematerial
  AlltypesSubstancespecification
  AlltypesSupplydelivery
  AlltypesSupplyrequest
  AlltypesTask
  AlltypesTerminologycapabilities
  AlltypesTestreport
  AlltypesTestscript
  AlltypesValueset
  AlltypesVerificationresult
  AlltypesVisionprescription
  AlltypesType
  AlltypesAny
}

pub const alltypes: List(Alltypes) = [
  AlltypesAddress,
  AlltypesAge,
  AlltypesAnnotation,
  AlltypesAttachment,
  AlltypesBackboneelement,
  AlltypesCodeableconcept,
  AlltypesCoding,
  AlltypesContactdetail,
  AlltypesContactpoint,
  AlltypesContributor,
  AlltypesCount,
  AlltypesDatarequirement,
  AlltypesDistance,
  AlltypesDosage,
  AlltypesDuration,
  AlltypesElement,
  AlltypesElementdefinition,
  AlltypesExpression,
  AlltypesExtension,
  AlltypesHumanname,
  AlltypesIdentifier,
  AlltypesMarketingstatus,
  AlltypesMeta,
  AlltypesMoney,
  AlltypesMoneyquantity,
  AlltypesNarrative,
  AlltypesParameterdefinition,
  AlltypesPeriod,
  AlltypesPopulation,
  AlltypesProdcharacteristic,
  AlltypesProductshelflife,
  AlltypesQuantity,
  AlltypesRange,
  AlltypesRatio,
  AlltypesReference,
  AlltypesRelatedartifact,
  AlltypesSampleddata,
  AlltypesSignature,
  AlltypesSimplequantity,
  AlltypesSubstanceamount,
  AlltypesTiming,
  AlltypesTriggerdefinition,
  AlltypesUsagecontext,
  AlltypesBase64binary,
  AlltypesBoolean,
  AlltypesCanonical,
  AlltypesCode,
  AlltypesDate,
  AlltypesDatetime,
  AlltypesDecimal,
  AlltypesId,
  AlltypesInstant,
  AlltypesInteger,
  AlltypesMarkdown,
  AlltypesOid,
  AlltypesPositiveint,
  AlltypesString,
  AlltypesTime,
  AlltypesUnsignedint,
  AlltypesUri,
  AlltypesUrl,
  AlltypesUuid,
  AlltypesXhtml,
  AlltypesAccount,
  AlltypesActivitydefinition,
  AlltypesAdverseevent,
  AlltypesAllergyintolerance,
  AlltypesAppointment,
  AlltypesAppointmentresponse,
  AlltypesAuditevent,
  AlltypesBasic,
  AlltypesBinary,
  AlltypesBiologicallyderivedproduct,
  AlltypesBodystructure,
  AlltypesBundle,
  AlltypesCapabilitystatement,
  AlltypesCareplan,
  AlltypesCareteam,
  AlltypesCatalogentry,
  AlltypesChargeitem,
  AlltypesChargeitemdefinition,
  AlltypesClaim,
  AlltypesClaimresponse,
  AlltypesClinicalimpression,
  AlltypesCodesystem,
  AlltypesCommunication,
  AlltypesCommunicationrequest,
  AlltypesCompartmentdefinition,
  AlltypesComposition,
  AlltypesConceptmap,
  AlltypesCondition,
  AlltypesConsent,
  AlltypesContract,
  AlltypesCoverage,
  AlltypesCoverageeligibilityrequest,
  AlltypesCoverageeligibilityresponse,
  AlltypesDetectedissue,
  AlltypesDevice,
  AlltypesDevicedefinition,
  AlltypesDevicemetric,
  AlltypesDevicerequest,
  AlltypesDeviceusestatement,
  AlltypesDiagnosticreport,
  AlltypesDocumentmanifest,
  AlltypesDocumentreference,
  AlltypesDomainresource,
  AlltypesEffectevidencesynthesis,
  AlltypesEncounter,
  AlltypesEndpoint,
  AlltypesEnrollmentrequest,
  AlltypesEnrollmentresponse,
  AlltypesEpisodeofcare,
  AlltypesEventdefinition,
  AlltypesEvidence,
  AlltypesEvidencevariable,
  AlltypesExamplescenario,
  AlltypesExplanationofbenefit,
  AlltypesFamilymemberhistory,
  AlltypesFlag,
  AlltypesGoal,
  AlltypesGraphdefinition,
  AlltypesGroup,
  AlltypesGuidanceresponse,
  AlltypesHealthcareservice,
  AlltypesImagingstudy,
  AlltypesImmunization,
  AlltypesImmunizationevaluation,
  AlltypesImmunizationrecommendation,
  AlltypesImplementationguide,
  AlltypesInsuranceplan,
  AlltypesInvoice,
  AlltypesLibrary,
  AlltypesLinkage,
  AlltypesList,
  AlltypesLocation,
  AlltypesMeasure,
  AlltypesMeasurereport,
  AlltypesMedia,
  AlltypesMedication,
  AlltypesMedicationadministration,
  AlltypesMedicationdispense,
  AlltypesMedicationknowledge,
  AlltypesMedicationrequest,
  AlltypesMedicationstatement,
  AlltypesMedicinalproduct,
  AlltypesMedicinalproductauthorization,
  AlltypesMedicinalproductcontraindication,
  AlltypesMedicinalproductindication,
  AlltypesMedicinalproductingredient,
  AlltypesMedicinalproductinteraction,
  AlltypesMedicinalproductmanufactured,
  AlltypesMedicinalproductpackaged,
  AlltypesMedicinalproductpharmaceutical,
  AlltypesMedicinalproductundesirableeffect,
  AlltypesMessagedefinition,
  AlltypesMessageheader,
  AlltypesMolecularsequence,
  AlltypesNamingsystem,
  AlltypesNutritionorder,
  AlltypesObservation,
  AlltypesObservationdefinition,
  AlltypesOperationdefinition,
  AlltypesOperationoutcome,
  AlltypesOrganization,
  AlltypesOrganizationaffiliation,
  AlltypesParameters,
  AlltypesPatient,
  AlltypesPaymentnotice,
  AlltypesPaymentreconciliation,
  AlltypesPerson,
  AlltypesPlandefinition,
  AlltypesPractitioner,
  AlltypesPractitionerrole,
  AlltypesProcedure,
  AlltypesProvenance,
  AlltypesQuestionnaire,
  AlltypesQuestionnaireresponse,
  AlltypesRelatedperson,
  AlltypesRequestgroup,
  AlltypesResearchdefinition,
  AlltypesResearchelementdefinition,
  AlltypesResearchstudy,
  AlltypesResearchsubject,
  AlltypesResource,
  AlltypesRiskassessment,
  AlltypesRiskevidencesynthesis,
  AlltypesSchedule,
  AlltypesSearchparameter,
  AlltypesServicerequest,
  AlltypesSlot,
  AlltypesSpecimen,
  AlltypesSpecimendefinition,
  AlltypesStructuredefinition,
  AlltypesStructuremap,
  AlltypesSubscription,
  AlltypesSubstance,
  AlltypesSubstancenucleicacid,
  AlltypesSubstancepolymer,
  AlltypesSubstanceprotein,
  AlltypesSubstancereferenceinformation,
  AlltypesSubstancesourcematerial,
  AlltypesSubstancespecification,
  AlltypesSupplydelivery,
  AlltypesSupplyrequest,
  AlltypesTask,
  AlltypesTerminologycapabilities,
  AlltypesTestreport,
  AlltypesTestscript,
  AlltypesValueset,
  AlltypesVerificationresult,
  AlltypesVisionprescription,
  AlltypesType,
  AlltypesAny,
]

pub fn alltypes_to_json(alltypes: Alltypes) -> Json {
  json.string(alltypes_to_code(alltypes))
}

pub fn alltypes_to_code(alltypes: Alltypes) -> String {
  case alltypes {
    AlltypesAddress -> "Address"
    AlltypesAge -> "Age"
    AlltypesAnnotation -> "Annotation"
    AlltypesAttachment -> "Attachment"
    AlltypesBackboneelement -> "BackboneElement"
    AlltypesCodeableconcept -> "CodeableConcept"
    AlltypesCoding -> "Coding"
    AlltypesContactdetail -> "ContactDetail"
    AlltypesContactpoint -> "ContactPoint"
    AlltypesContributor -> "Contributor"
    AlltypesCount -> "Count"
    AlltypesDatarequirement -> "DataRequirement"
    AlltypesDistance -> "Distance"
    AlltypesDosage -> "Dosage"
    AlltypesDuration -> "Duration"
    AlltypesElement -> "Element"
    AlltypesElementdefinition -> "ElementDefinition"
    AlltypesExpression -> "Expression"
    AlltypesExtension -> "Extension"
    AlltypesHumanname -> "HumanName"
    AlltypesIdentifier -> "Identifier"
    AlltypesMarketingstatus -> "MarketingStatus"
    AlltypesMeta -> "Meta"
    AlltypesMoney -> "Money"
    AlltypesMoneyquantity -> "MoneyQuantity"
    AlltypesNarrative -> "Narrative"
    AlltypesParameterdefinition -> "ParameterDefinition"
    AlltypesPeriod -> "Period"
    AlltypesPopulation -> "Population"
    AlltypesProdcharacteristic -> "ProdCharacteristic"
    AlltypesProductshelflife -> "ProductShelfLife"
    AlltypesQuantity -> "Quantity"
    AlltypesRange -> "Range"
    AlltypesRatio -> "Ratio"
    AlltypesReference -> "Reference"
    AlltypesRelatedartifact -> "RelatedArtifact"
    AlltypesSampleddata -> "SampledData"
    AlltypesSignature -> "Signature"
    AlltypesSimplequantity -> "SimpleQuantity"
    AlltypesSubstanceamount -> "SubstanceAmount"
    AlltypesTiming -> "Timing"
    AlltypesTriggerdefinition -> "TriggerDefinition"
    AlltypesUsagecontext -> "UsageContext"
    AlltypesBase64binary -> "base64Binary"
    AlltypesBoolean -> "boolean"
    AlltypesCanonical -> "canonical"
    AlltypesCode -> "code"
    AlltypesDate -> "date"
    AlltypesDatetime -> "dateTime"
    AlltypesDecimal -> "decimal"
    AlltypesId -> "id"
    AlltypesInstant -> "instant"
    AlltypesInteger -> "integer"
    AlltypesMarkdown -> "markdown"
    AlltypesOid -> "oid"
    AlltypesPositiveint -> "positiveInt"
    AlltypesString -> "string"
    AlltypesTime -> "time"
    AlltypesUnsignedint -> "unsignedInt"
    AlltypesUri -> "uri"
    AlltypesUrl -> "url"
    AlltypesUuid -> "uuid"
    AlltypesXhtml -> "xhtml"
    AlltypesAccount -> "Account"
    AlltypesActivitydefinition -> "ActivityDefinition"
    AlltypesAdverseevent -> "AdverseEvent"
    AlltypesAllergyintolerance -> "AllergyIntolerance"
    AlltypesAppointment -> "Appointment"
    AlltypesAppointmentresponse -> "AppointmentResponse"
    AlltypesAuditevent -> "AuditEvent"
    AlltypesBasic -> "Basic"
    AlltypesBinary -> "Binary"
    AlltypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    AlltypesBodystructure -> "BodyStructure"
    AlltypesBundle -> "Bundle"
    AlltypesCapabilitystatement -> "CapabilityStatement"
    AlltypesCareplan -> "CarePlan"
    AlltypesCareteam -> "CareTeam"
    AlltypesCatalogentry -> "CatalogEntry"
    AlltypesChargeitem -> "ChargeItem"
    AlltypesChargeitemdefinition -> "ChargeItemDefinition"
    AlltypesClaim -> "Claim"
    AlltypesClaimresponse -> "ClaimResponse"
    AlltypesClinicalimpression -> "ClinicalImpression"
    AlltypesCodesystem -> "CodeSystem"
    AlltypesCommunication -> "Communication"
    AlltypesCommunicationrequest -> "CommunicationRequest"
    AlltypesCompartmentdefinition -> "CompartmentDefinition"
    AlltypesComposition -> "Composition"
    AlltypesConceptmap -> "ConceptMap"
    AlltypesCondition -> "Condition"
    AlltypesConsent -> "Consent"
    AlltypesContract -> "Contract"
    AlltypesCoverage -> "Coverage"
    AlltypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    AlltypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    AlltypesDetectedissue -> "DetectedIssue"
    AlltypesDevice -> "Device"
    AlltypesDevicedefinition -> "DeviceDefinition"
    AlltypesDevicemetric -> "DeviceMetric"
    AlltypesDevicerequest -> "DeviceRequest"
    AlltypesDeviceusestatement -> "DeviceUseStatement"
    AlltypesDiagnosticreport -> "DiagnosticReport"
    AlltypesDocumentmanifest -> "DocumentManifest"
    AlltypesDocumentreference -> "DocumentReference"
    AlltypesDomainresource -> "DomainResource"
    AlltypesEffectevidencesynthesis -> "EffectEvidenceSynthesis"
    AlltypesEncounter -> "Encounter"
    AlltypesEndpoint -> "Endpoint"
    AlltypesEnrollmentrequest -> "EnrollmentRequest"
    AlltypesEnrollmentresponse -> "EnrollmentResponse"
    AlltypesEpisodeofcare -> "EpisodeOfCare"
    AlltypesEventdefinition -> "EventDefinition"
    AlltypesEvidence -> "Evidence"
    AlltypesEvidencevariable -> "EvidenceVariable"
    AlltypesExamplescenario -> "ExampleScenario"
    AlltypesExplanationofbenefit -> "ExplanationOfBenefit"
    AlltypesFamilymemberhistory -> "FamilyMemberHistory"
    AlltypesFlag -> "Flag"
    AlltypesGoal -> "Goal"
    AlltypesGraphdefinition -> "GraphDefinition"
    AlltypesGroup -> "Group"
    AlltypesGuidanceresponse -> "GuidanceResponse"
    AlltypesHealthcareservice -> "HealthcareService"
    AlltypesImagingstudy -> "ImagingStudy"
    AlltypesImmunization -> "Immunization"
    AlltypesImmunizationevaluation -> "ImmunizationEvaluation"
    AlltypesImmunizationrecommendation -> "ImmunizationRecommendation"
    AlltypesImplementationguide -> "ImplementationGuide"
    AlltypesInsuranceplan -> "InsurancePlan"
    AlltypesInvoice -> "Invoice"
    AlltypesLibrary -> "Library"
    AlltypesLinkage -> "Linkage"
    AlltypesList -> "List"
    AlltypesLocation -> "Location"
    AlltypesMeasure -> "Measure"
    AlltypesMeasurereport -> "MeasureReport"
    AlltypesMedia -> "Media"
    AlltypesMedication -> "Medication"
    AlltypesMedicationadministration -> "MedicationAdministration"
    AlltypesMedicationdispense -> "MedicationDispense"
    AlltypesMedicationknowledge -> "MedicationKnowledge"
    AlltypesMedicationrequest -> "MedicationRequest"
    AlltypesMedicationstatement -> "MedicationStatement"
    AlltypesMedicinalproduct -> "MedicinalProduct"
    AlltypesMedicinalproductauthorization -> "MedicinalProductAuthorization"
    AlltypesMedicinalproductcontraindication ->
      "MedicinalProductContraindication"
    AlltypesMedicinalproductindication -> "MedicinalProductIndication"
    AlltypesMedicinalproductingredient -> "MedicinalProductIngredient"
    AlltypesMedicinalproductinteraction -> "MedicinalProductInteraction"
    AlltypesMedicinalproductmanufactured -> "MedicinalProductManufactured"
    AlltypesMedicinalproductpackaged -> "MedicinalProductPackaged"
    AlltypesMedicinalproductpharmaceutical -> "MedicinalProductPharmaceutical"
    AlltypesMedicinalproductundesirableeffect ->
      "MedicinalProductUndesirableEffect"
    AlltypesMessagedefinition -> "MessageDefinition"
    AlltypesMessageheader -> "MessageHeader"
    AlltypesMolecularsequence -> "MolecularSequence"
    AlltypesNamingsystem -> "NamingSystem"
    AlltypesNutritionorder -> "NutritionOrder"
    AlltypesObservation -> "Observation"
    AlltypesObservationdefinition -> "ObservationDefinition"
    AlltypesOperationdefinition -> "OperationDefinition"
    AlltypesOperationoutcome -> "OperationOutcome"
    AlltypesOrganization -> "Organization"
    AlltypesOrganizationaffiliation -> "OrganizationAffiliation"
    AlltypesParameters -> "Parameters"
    AlltypesPatient -> "Patient"
    AlltypesPaymentnotice -> "PaymentNotice"
    AlltypesPaymentreconciliation -> "PaymentReconciliation"
    AlltypesPerson -> "Person"
    AlltypesPlandefinition -> "PlanDefinition"
    AlltypesPractitioner -> "Practitioner"
    AlltypesPractitionerrole -> "PractitionerRole"
    AlltypesProcedure -> "Procedure"
    AlltypesProvenance -> "Provenance"
    AlltypesQuestionnaire -> "Questionnaire"
    AlltypesQuestionnaireresponse -> "QuestionnaireResponse"
    AlltypesRelatedperson -> "RelatedPerson"
    AlltypesRequestgroup -> "RequestGroup"
    AlltypesResearchdefinition -> "ResearchDefinition"
    AlltypesResearchelementdefinition -> "ResearchElementDefinition"
    AlltypesResearchstudy -> "ResearchStudy"
    AlltypesResearchsubject -> "ResearchSubject"
    AlltypesResource -> "Resource"
    AlltypesRiskassessment -> "RiskAssessment"
    AlltypesRiskevidencesynthesis -> "RiskEvidenceSynthesis"
    AlltypesSchedule -> "Schedule"
    AlltypesSearchparameter -> "SearchParameter"
    AlltypesServicerequest -> "ServiceRequest"
    AlltypesSlot -> "Slot"
    AlltypesSpecimen -> "Specimen"
    AlltypesSpecimendefinition -> "SpecimenDefinition"
    AlltypesStructuredefinition -> "StructureDefinition"
    AlltypesStructuremap -> "StructureMap"
    AlltypesSubscription -> "Subscription"
    AlltypesSubstance -> "Substance"
    AlltypesSubstancenucleicacid -> "SubstanceNucleicAcid"
    AlltypesSubstancepolymer -> "SubstancePolymer"
    AlltypesSubstanceprotein -> "SubstanceProtein"
    AlltypesSubstancereferenceinformation -> "SubstanceReferenceInformation"
    AlltypesSubstancesourcematerial -> "SubstanceSourceMaterial"
    AlltypesSubstancespecification -> "SubstanceSpecification"
    AlltypesSupplydelivery -> "SupplyDelivery"
    AlltypesSupplyrequest -> "SupplyRequest"
    AlltypesTask -> "Task"
    AlltypesTerminologycapabilities -> "TerminologyCapabilities"
    AlltypesTestreport -> "TestReport"
    AlltypesTestscript -> "TestScript"
    AlltypesValueset -> "ValueSet"
    AlltypesVerificationresult -> "VerificationResult"
    AlltypesVisionprescription -> "VisionPrescription"
    AlltypesType -> "Type"
    AlltypesAny -> "Any"
  }
}

pub fn alltypes_parse_code(code: String) -> Result(Alltypes, Nil) {
  case code {
    "Address" -> Ok(AlltypesAddress)
    "Age" -> Ok(AlltypesAge)
    "Annotation" -> Ok(AlltypesAnnotation)
    "Attachment" -> Ok(AlltypesAttachment)
    "BackboneElement" -> Ok(AlltypesBackboneelement)
    "CodeableConcept" -> Ok(AlltypesCodeableconcept)
    "Coding" -> Ok(AlltypesCoding)
    "ContactDetail" -> Ok(AlltypesContactdetail)
    "ContactPoint" -> Ok(AlltypesContactpoint)
    "Contributor" -> Ok(AlltypesContributor)
    "Count" -> Ok(AlltypesCount)
    "DataRequirement" -> Ok(AlltypesDatarequirement)
    "Distance" -> Ok(AlltypesDistance)
    "Dosage" -> Ok(AlltypesDosage)
    "Duration" -> Ok(AlltypesDuration)
    "Element" -> Ok(AlltypesElement)
    "ElementDefinition" -> Ok(AlltypesElementdefinition)
    "Expression" -> Ok(AlltypesExpression)
    "Extension" -> Ok(AlltypesExtension)
    "HumanName" -> Ok(AlltypesHumanname)
    "Identifier" -> Ok(AlltypesIdentifier)
    "MarketingStatus" -> Ok(AlltypesMarketingstatus)
    "Meta" -> Ok(AlltypesMeta)
    "Money" -> Ok(AlltypesMoney)
    "MoneyQuantity" -> Ok(AlltypesMoneyquantity)
    "Narrative" -> Ok(AlltypesNarrative)
    "ParameterDefinition" -> Ok(AlltypesParameterdefinition)
    "Period" -> Ok(AlltypesPeriod)
    "Population" -> Ok(AlltypesPopulation)
    "ProdCharacteristic" -> Ok(AlltypesProdcharacteristic)
    "ProductShelfLife" -> Ok(AlltypesProductshelflife)
    "Quantity" -> Ok(AlltypesQuantity)
    "Range" -> Ok(AlltypesRange)
    "Ratio" -> Ok(AlltypesRatio)
    "Reference" -> Ok(AlltypesReference)
    "RelatedArtifact" -> Ok(AlltypesRelatedartifact)
    "SampledData" -> Ok(AlltypesSampleddata)
    "Signature" -> Ok(AlltypesSignature)
    "SimpleQuantity" -> Ok(AlltypesSimplequantity)
    "SubstanceAmount" -> Ok(AlltypesSubstanceamount)
    "Timing" -> Ok(AlltypesTiming)
    "TriggerDefinition" -> Ok(AlltypesTriggerdefinition)
    "UsageContext" -> Ok(AlltypesUsagecontext)
    "base64Binary" -> Ok(AlltypesBase64binary)
    "boolean" -> Ok(AlltypesBoolean)
    "canonical" -> Ok(AlltypesCanonical)
    "code" -> Ok(AlltypesCode)
    "date" -> Ok(AlltypesDate)
    "dateTime" -> Ok(AlltypesDatetime)
    "decimal" -> Ok(AlltypesDecimal)
    "id" -> Ok(AlltypesId)
    "instant" -> Ok(AlltypesInstant)
    "integer" -> Ok(AlltypesInteger)
    "markdown" -> Ok(AlltypesMarkdown)
    "oid" -> Ok(AlltypesOid)
    "positiveInt" -> Ok(AlltypesPositiveint)
    "string" -> Ok(AlltypesString)
    "time" -> Ok(AlltypesTime)
    "unsignedInt" -> Ok(AlltypesUnsignedint)
    "uri" -> Ok(AlltypesUri)
    "url" -> Ok(AlltypesUrl)
    "uuid" -> Ok(AlltypesUuid)
    "xhtml" -> Ok(AlltypesXhtml)
    "Account" -> Ok(AlltypesAccount)
    "ActivityDefinition" -> Ok(AlltypesActivitydefinition)
    "AdverseEvent" -> Ok(AlltypesAdverseevent)
    "AllergyIntolerance" -> Ok(AlltypesAllergyintolerance)
    "Appointment" -> Ok(AlltypesAppointment)
    "AppointmentResponse" -> Ok(AlltypesAppointmentresponse)
    "AuditEvent" -> Ok(AlltypesAuditevent)
    "Basic" -> Ok(AlltypesBasic)
    "Binary" -> Ok(AlltypesBinary)
    "BiologicallyDerivedProduct" -> Ok(AlltypesBiologicallyderivedproduct)
    "BodyStructure" -> Ok(AlltypesBodystructure)
    "Bundle" -> Ok(AlltypesBundle)
    "CapabilityStatement" -> Ok(AlltypesCapabilitystatement)
    "CarePlan" -> Ok(AlltypesCareplan)
    "CareTeam" -> Ok(AlltypesCareteam)
    "CatalogEntry" -> Ok(AlltypesCatalogentry)
    "ChargeItem" -> Ok(AlltypesChargeitem)
    "ChargeItemDefinition" -> Ok(AlltypesChargeitemdefinition)
    "Claim" -> Ok(AlltypesClaim)
    "ClaimResponse" -> Ok(AlltypesClaimresponse)
    "ClinicalImpression" -> Ok(AlltypesClinicalimpression)
    "CodeSystem" -> Ok(AlltypesCodesystem)
    "Communication" -> Ok(AlltypesCommunication)
    "CommunicationRequest" -> Ok(AlltypesCommunicationrequest)
    "CompartmentDefinition" -> Ok(AlltypesCompartmentdefinition)
    "Composition" -> Ok(AlltypesComposition)
    "ConceptMap" -> Ok(AlltypesConceptmap)
    "Condition" -> Ok(AlltypesCondition)
    "Consent" -> Ok(AlltypesConsent)
    "Contract" -> Ok(AlltypesContract)
    "Coverage" -> Ok(AlltypesCoverage)
    "CoverageEligibilityRequest" -> Ok(AlltypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" -> Ok(AlltypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(AlltypesDetectedissue)
    "Device" -> Ok(AlltypesDevice)
    "DeviceDefinition" -> Ok(AlltypesDevicedefinition)
    "DeviceMetric" -> Ok(AlltypesDevicemetric)
    "DeviceRequest" -> Ok(AlltypesDevicerequest)
    "DeviceUseStatement" -> Ok(AlltypesDeviceusestatement)
    "DiagnosticReport" -> Ok(AlltypesDiagnosticreport)
    "DocumentManifest" -> Ok(AlltypesDocumentmanifest)
    "DocumentReference" -> Ok(AlltypesDocumentreference)
    "DomainResource" -> Ok(AlltypesDomainresource)
    "EffectEvidenceSynthesis" -> Ok(AlltypesEffectevidencesynthesis)
    "Encounter" -> Ok(AlltypesEncounter)
    "Endpoint" -> Ok(AlltypesEndpoint)
    "EnrollmentRequest" -> Ok(AlltypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(AlltypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(AlltypesEpisodeofcare)
    "EventDefinition" -> Ok(AlltypesEventdefinition)
    "Evidence" -> Ok(AlltypesEvidence)
    "EvidenceVariable" -> Ok(AlltypesEvidencevariable)
    "ExampleScenario" -> Ok(AlltypesExamplescenario)
    "ExplanationOfBenefit" -> Ok(AlltypesExplanationofbenefit)
    "FamilyMemberHistory" -> Ok(AlltypesFamilymemberhistory)
    "Flag" -> Ok(AlltypesFlag)
    "Goal" -> Ok(AlltypesGoal)
    "GraphDefinition" -> Ok(AlltypesGraphdefinition)
    "Group" -> Ok(AlltypesGroup)
    "GuidanceResponse" -> Ok(AlltypesGuidanceresponse)
    "HealthcareService" -> Ok(AlltypesHealthcareservice)
    "ImagingStudy" -> Ok(AlltypesImagingstudy)
    "Immunization" -> Ok(AlltypesImmunization)
    "ImmunizationEvaluation" -> Ok(AlltypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(AlltypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(AlltypesImplementationguide)
    "InsurancePlan" -> Ok(AlltypesInsuranceplan)
    "Invoice" -> Ok(AlltypesInvoice)
    "Library" -> Ok(AlltypesLibrary)
    "Linkage" -> Ok(AlltypesLinkage)
    "List" -> Ok(AlltypesList)
    "Location" -> Ok(AlltypesLocation)
    "Measure" -> Ok(AlltypesMeasure)
    "MeasureReport" -> Ok(AlltypesMeasurereport)
    "Media" -> Ok(AlltypesMedia)
    "Medication" -> Ok(AlltypesMedication)
    "MedicationAdministration" -> Ok(AlltypesMedicationadministration)
    "MedicationDispense" -> Ok(AlltypesMedicationdispense)
    "MedicationKnowledge" -> Ok(AlltypesMedicationknowledge)
    "MedicationRequest" -> Ok(AlltypesMedicationrequest)
    "MedicationStatement" -> Ok(AlltypesMedicationstatement)
    "MedicinalProduct" -> Ok(AlltypesMedicinalproduct)
    "MedicinalProductAuthorization" -> Ok(AlltypesMedicinalproductauthorization)
    "MedicinalProductContraindication" ->
      Ok(AlltypesMedicinalproductcontraindication)
    "MedicinalProductIndication" -> Ok(AlltypesMedicinalproductindication)
    "MedicinalProductIngredient" -> Ok(AlltypesMedicinalproductingredient)
    "MedicinalProductInteraction" -> Ok(AlltypesMedicinalproductinteraction)
    "MedicinalProductManufactured" -> Ok(AlltypesMedicinalproductmanufactured)
    "MedicinalProductPackaged" -> Ok(AlltypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      Ok(AlltypesMedicinalproductpharmaceutical)
    "MedicinalProductUndesirableEffect" ->
      Ok(AlltypesMedicinalproductundesirableeffect)
    "MessageDefinition" -> Ok(AlltypesMessagedefinition)
    "MessageHeader" -> Ok(AlltypesMessageheader)
    "MolecularSequence" -> Ok(AlltypesMolecularsequence)
    "NamingSystem" -> Ok(AlltypesNamingsystem)
    "NutritionOrder" -> Ok(AlltypesNutritionorder)
    "Observation" -> Ok(AlltypesObservation)
    "ObservationDefinition" -> Ok(AlltypesObservationdefinition)
    "OperationDefinition" -> Ok(AlltypesOperationdefinition)
    "OperationOutcome" -> Ok(AlltypesOperationoutcome)
    "Organization" -> Ok(AlltypesOrganization)
    "OrganizationAffiliation" -> Ok(AlltypesOrganizationaffiliation)
    "Parameters" -> Ok(AlltypesParameters)
    "Patient" -> Ok(AlltypesPatient)
    "PaymentNotice" -> Ok(AlltypesPaymentnotice)
    "PaymentReconciliation" -> Ok(AlltypesPaymentreconciliation)
    "Person" -> Ok(AlltypesPerson)
    "PlanDefinition" -> Ok(AlltypesPlandefinition)
    "Practitioner" -> Ok(AlltypesPractitioner)
    "PractitionerRole" -> Ok(AlltypesPractitionerrole)
    "Procedure" -> Ok(AlltypesProcedure)
    "Provenance" -> Ok(AlltypesProvenance)
    "Questionnaire" -> Ok(AlltypesQuestionnaire)
    "QuestionnaireResponse" -> Ok(AlltypesQuestionnaireresponse)
    "RelatedPerson" -> Ok(AlltypesRelatedperson)
    "RequestGroup" -> Ok(AlltypesRequestgroup)
    "ResearchDefinition" -> Ok(AlltypesResearchdefinition)
    "ResearchElementDefinition" -> Ok(AlltypesResearchelementdefinition)
    "ResearchStudy" -> Ok(AlltypesResearchstudy)
    "ResearchSubject" -> Ok(AlltypesResearchsubject)
    "Resource" -> Ok(AlltypesResource)
    "RiskAssessment" -> Ok(AlltypesRiskassessment)
    "RiskEvidenceSynthesis" -> Ok(AlltypesRiskevidencesynthesis)
    "Schedule" -> Ok(AlltypesSchedule)
    "SearchParameter" -> Ok(AlltypesSearchparameter)
    "ServiceRequest" -> Ok(AlltypesServicerequest)
    "Slot" -> Ok(AlltypesSlot)
    "Specimen" -> Ok(AlltypesSpecimen)
    "SpecimenDefinition" -> Ok(AlltypesSpecimendefinition)
    "StructureDefinition" -> Ok(AlltypesStructuredefinition)
    "StructureMap" -> Ok(AlltypesStructuremap)
    "Subscription" -> Ok(AlltypesSubscription)
    "Substance" -> Ok(AlltypesSubstance)
    "SubstanceNucleicAcid" -> Ok(AlltypesSubstancenucleicacid)
    "SubstancePolymer" -> Ok(AlltypesSubstancepolymer)
    "SubstanceProtein" -> Ok(AlltypesSubstanceprotein)
    "SubstanceReferenceInformation" -> Ok(AlltypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> Ok(AlltypesSubstancesourcematerial)
    "SubstanceSpecification" -> Ok(AlltypesSubstancespecification)
    "SupplyDelivery" -> Ok(AlltypesSupplydelivery)
    "SupplyRequest" -> Ok(AlltypesSupplyrequest)
    "Task" -> Ok(AlltypesTask)
    "TerminologyCapabilities" -> Ok(AlltypesTerminologycapabilities)
    "TestReport" -> Ok(AlltypesTestreport)
    "TestScript" -> Ok(AlltypesTestscript)
    "ValueSet" -> Ok(AlltypesValueset)
    "VerificationResult" -> Ok(AlltypesVerificationresult)
    "VisionPrescription" -> Ok(AlltypesVisionprescription)
    "Type" -> Ok(AlltypesType)
    "Any" -> Ok(AlltypesAny)
    _ -> Error(Nil)
  }
}

pub fn alltypes_decoder() -> Decoder(Alltypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Address" -> decode.success(AlltypesAddress)
    "Age" -> decode.success(AlltypesAge)
    "Annotation" -> decode.success(AlltypesAnnotation)
    "Attachment" -> decode.success(AlltypesAttachment)
    "BackboneElement" -> decode.success(AlltypesBackboneelement)
    "CodeableConcept" -> decode.success(AlltypesCodeableconcept)
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
    "Reference" -> decode.success(AlltypesReference)
    "RelatedArtifact" -> decode.success(AlltypesRelatedartifact)
    "SampledData" -> decode.success(AlltypesSampleddata)
    "Signature" -> decode.success(AlltypesSignature)
    "SimpleQuantity" -> decode.success(AlltypesSimplequantity)
    "SubstanceAmount" -> decode.success(AlltypesSubstanceamount)
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
    "Account" -> decode.success(AlltypesAccount)
    "ActivityDefinition" -> decode.success(AlltypesActivitydefinition)
    "AdverseEvent" -> decode.success(AlltypesAdverseevent)
    "AllergyIntolerance" -> decode.success(AlltypesAllergyintolerance)
    "Appointment" -> decode.success(AlltypesAppointment)
    "AppointmentResponse" -> decode.success(AlltypesAppointmentresponse)
    "AuditEvent" -> decode.success(AlltypesAuditevent)
    "Basic" -> decode.success(AlltypesBasic)
    "Binary" -> decode.success(AlltypesBinary)
    "BiologicallyDerivedProduct" ->
      decode.success(AlltypesBiologicallyderivedproduct)
    "BodyStructure" -> decode.success(AlltypesBodystructure)
    "Bundle" -> decode.success(AlltypesBundle)
    "CapabilityStatement" -> decode.success(AlltypesCapabilitystatement)
    "CarePlan" -> decode.success(AlltypesCareplan)
    "CareTeam" -> decode.success(AlltypesCareteam)
    "CatalogEntry" -> decode.success(AlltypesCatalogentry)
    "ChargeItem" -> decode.success(AlltypesChargeitem)
    "ChargeItemDefinition" -> decode.success(AlltypesChargeitemdefinition)
    "Claim" -> decode.success(AlltypesClaim)
    "ClaimResponse" -> decode.success(AlltypesClaimresponse)
    "ClinicalImpression" -> decode.success(AlltypesClinicalimpression)
    "CodeSystem" -> decode.success(AlltypesCodesystem)
    "Communication" -> decode.success(AlltypesCommunication)
    "CommunicationRequest" -> decode.success(AlltypesCommunicationrequest)
    "CompartmentDefinition" -> decode.success(AlltypesCompartmentdefinition)
    "Composition" -> decode.success(AlltypesComposition)
    "ConceptMap" -> decode.success(AlltypesConceptmap)
    "Condition" -> decode.success(AlltypesCondition)
    "Consent" -> decode.success(AlltypesConsent)
    "Contract" -> decode.success(AlltypesContract)
    "Coverage" -> decode.success(AlltypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(AlltypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(AlltypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(AlltypesDetectedissue)
    "Device" -> decode.success(AlltypesDevice)
    "DeviceDefinition" -> decode.success(AlltypesDevicedefinition)
    "DeviceMetric" -> decode.success(AlltypesDevicemetric)
    "DeviceRequest" -> decode.success(AlltypesDevicerequest)
    "DeviceUseStatement" -> decode.success(AlltypesDeviceusestatement)
    "DiagnosticReport" -> decode.success(AlltypesDiagnosticreport)
    "DocumentManifest" -> decode.success(AlltypesDocumentmanifest)
    "DocumentReference" -> decode.success(AlltypesDocumentreference)
    "DomainResource" -> decode.success(AlltypesDomainresource)
    "EffectEvidenceSynthesis" -> decode.success(AlltypesEffectevidencesynthesis)
    "Encounter" -> decode.success(AlltypesEncounter)
    "Endpoint" -> decode.success(AlltypesEndpoint)
    "EnrollmentRequest" -> decode.success(AlltypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(AlltypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(AlltypesEpisodeofcare)
    "EventDefinition" -> decode.success(AlltypesEventdefinition)
    "Evidence" -> decode.success(AlltypesEvidence)
    "EvidenceVariable" -> decode.success(AlltypesEvidencevariable)
    "ExampleScenario" -> decode.success(AlltypesExamplescenario)
    "ExplanationOfBenefit" -> decode.success(AlltypesExplanationofbenefit)
    "FamilyMemberHistory" -> decode.success(AlltypesFamilymemberhistory)
    "Flag" -> decode.success(AlltypesFlag)
    "Goal" -> decode.success(AlltypesGoal)
    "GraphDefinition" -> decode.success(AlltypesGraphdefinition)
    "Group" -> decode.success(AlltypesGroup)
    "GuidanceResponse" -> decode.success(AlltypesGuidanceresponse)
    "HealthcareService" -> decode.success(AlltypesHealthcareservice)
    "ImagingStudy" -> decode.success(AlltypesImagingstudy)
    "Immunization" -> decode.success(AlltypesImmunization)
    "ImmunizationEvaluation" -> decode.success(AlltypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(AlltypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(AlltypesImplementationguide)
    "InsurancePlan" -> decode.success(AlltypesInsuranceplan)
    "Invoice" -> decode.success(AlltypesInvoice)
    "Library" -> decode.success(AlltypesLibrary)
    "Linkage" -> decode.success(AlltypesLinkage)
    "List" -> decode.success(AlltypesList)
    "Location" -> decode.success(AlltypesLocation)
    "Measure" -> decode.success(AlltypesMeasure)
    "MeasureReport" -> decode.success(AlltypesMeasurereport)
    "Media" -> decode.success(AlltypesMedia)
    "Medication" -> decode.success(AlltypesMedication)
    "MedicationAdministration" ->
      decode.success(AlltypesMedicationadministration)
    "MedicationDispense" -> decode.success(AlltypesMedicationdispense)
    "MedicationKnowledge" -> decode.success(AlltypesMedicationknowledge)
    "MedicationRequest" -> decode.success(AlltypesMedicationrequest)
    "MedicationStatement" -> decode.success(AlltypesMedicationstatement)
    "MedicinalProduct" -> decode.success(AlltypesMedicinalproduct)
    "MedicinalProductAuthorization" ->
      decode.success(AlltypesMedicinalproductauthorization)
    "MedicinalProductContraindication" ->
      decode.success(AlltypesMedicinalproductcontraindication)
    "MedicinalProductIndication" ->
      decode.success(AlltypesMedicinalproductindication)
    "MedicinalProductIngredient" ->
      decode.success(AlltypesMedicinalproductingredient)
    "MedicinalProductInteraction" ->
      decode.success(AlltypesMedicinalproductinteraction)
    "MedicinalProductManufactured" ->
      decode.success(AlltypesMedicinalproductmanufactured)
    "MedicinalProductPackaged" ->
      decode.success(AlltypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      decode.success(AlltypesMedicinalproductpharmaceutical)
    "MedicinalProductUndesirableEffect" ->
      decode.success(AlltypesMedicinalproductundesirableeffect)
    "MessageDefinition" -> decode.success(AlltypesMessagedefinition)
    "MessageHeader" -> decode.success(AlltypesMessageheader)
    "MolecularSequence" -> decode.success(AlltypesMolecularsequence)
    "NamingSystem" -> decode.success(AlltypesNamingsystem)
    "NutritionOrder" -> decode.success(AlltypesNutritionorder)
    "Observation" -> decode.success(AlltypesObservation)
    "ObservationDefinition" -> decode.success(AlltypesObservationdefinition)
    "OperationDefinition" -> decode.success(AlltypesOperationdefinition)
    "OperationOutcome" -> decode.success(AlltypesOperationoutcome)
    "Organization" -> decode.success(AlltypesOrganization)
    "OrganizationAffiliation" -> decode.success(AlltypesOrganizationaffiliation)
    "Parameters" -> decode.success(AlltypesParameters)
    "Patient" -> decode.success(AlltypesPatient)
    "PaymentNotice" -> decode.success(AlltypesPaymentnotice)
    "PaymentReconciliation" -> decode.success(AlltypesPaymentreconciliation)
    "Person" -> decode.success(AlltypesPerson)
    "PlanDefinition" -> decode.success(AlltypesPlandefinition)
    "Practitioner" -> decode.success(AlltypesPractitioner)
    "PractitionerRole" -> decode.success(AlltypesPractitionerrole)
    "Procedure" -> decode.success(AlltypesProcedure)
    "Provenance" -> decode.success(AlltypesProvenance)
    "Questionnaire" -> decode.success(AlltypesQuestionnaire)
    "QuestionnaireResponse" -> decode.success(AlltypesQuestionnaireresponse)
    "RelatedPerson" -> decode.success(AlltypesRelatedperson)
    "RequestGroup" -> decode.success(AlltypesRequestgroup)
    "ResearchDefinition" -> decode.success(AlltypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(AlltypesResearchelementdefinition)
    "ResearchStudy" -> decode.success(AlltypesResearchstudy)
    "ResearchSubject" -> decode.success(AlltypesResearchsubject)
    "Resource" -> decode.success(AlltypesResource)
    "RiskAssessment" -> decode.success(AlltypesRiskassessment)
    "RiskEvidenceSynthesis" -> decode.success(AlltypesRiskevidencesynthesis)
    "Schedule" -> decode.success(AlltypesSchedule)
    "SearchParameter" -> decode.success(AlltypesSearchparameter)
    "ServiceRequest" -> decode.success(AlltypesServicerequest)
    "Slot" -> decode.success(AlltypesSlot)
    "Specimen" -> decode.success(AlltypesSpecimen)
    "SpecimenDefinition" -> decode.success(AlltypesSpecimendefinition)
    "StructureDefinition" -> decode.success(AlltypesStructuredefinition)
    "StructureMap" -> decode.success(AlltypesStructuremap)
    "Subscription" -> decode.success(AlltypesSubscription)
    "Substance" -> decode.success(AlltypesSubstance)
    "SubstanceNucleicAcid" -> decode.success(AlltypesSubstancenucleicacid)
    "SubstancePolymer" -> decode.success(AlltypesSubstancepolymer)
    "SubstanceProtein" -> decode.success(AlltypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      decode.success(AlltypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> decode.success(AlltypesSubstancesourcematerial)
    "SubstanceSpecification" -> decode.success(AlltypesSubstancespecification)
    "SupplyDelivery" -> decode.success(AlltypesSupplydelivery)
    "SupplyRequest" -> decode.success(AlltypesSupplyrequest)
    "Task" -> decode.success(AlltypesTask)
    "TerminologyCapabilities" -> decode.success(AlltypesTerminologycapabilities)
    "TestReport" -> decode.success(AlltypesTestreport)
    "TestScript" -> decode.success(AlltypesTestscript)
    "ValueSet" -> decode.success(AlltypesValueset)
    "VerificationResult" -> decode.success(AlltypesVerificationresult)
    "VisionPrescription" -> decode.success(AlltypesVisionprescription)
    "Type" -> decode.success(AlltypesType)
    "Any" -> decode.success(AlltypesAny)
    _ ->
      decode.failure(
        AlltypesAddress,
        "code from valueset Alltypes ["
          <> { alltypes |> list.map(alltypes_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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
}

pub const bundletype: List(Bundletype) = [
  BundletypeDocument,
  BundletypeMessage,
  BundletypeTransaction,
  BundletypeTransactionresponse,
  BundletypeBatch,
  BundletypeBatchresponse,
  BundletypeHistory,
  BundletypeSearchset,
  BundletypeCollection,
]

pub fn bundletype_to_json(bundletype: Bundletype) -> Json {
  json.string(bundletype_to_code(bundletype))
}

pub fn bundletype_to_code(bundletype: Bundletype) -> String {
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
  }
}

pub fn bundletype_parse_code(code: String) -> Result(Bundletype, Nil) {
  case code {
    "document" -> Ok(BundletypeDocument)
    "message" -> Ok(BundletypeMessage)
    "transaction" -> Ok(BundletypeTransaction)
    "transaction-response" -> Ok(BundletypeTransactionresponse)
    "batch" -> Ok(BundletypeBatch)
    "batch-response" -> Ok(BundletypeBatchresponse)
    "history" -> Ok(BundletypeHistory)
    "searchset" -> Ok(BundletypeSearchset)
    "collection" -> Ok(BundletypeCollection)
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
    _ ->
      decode.failure(
        BundletypeDocument,
        "code from valueset Bundletype ["
          <> { bundletype |> list.map(bundletype_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Codesystemcontentmode {
  CodesystemcontentmodeNotpresent
  CodesystemcontentmodeExample
  CodesystemcontentmodeFragment
  CodesystemcontentmodeComplete
  CodesystemcontentmodeSupplement
}

pub const codesystemcontentmode: List(Codesystemcontentmode) = [
  CodesystemcontentmodeNotpresent,
  CodesystemcontentmodeExample,
  CodesystemcontentmodeFragment,
  CodesystemcontentmodeComplete,
  CodesystemcontentmodeSupplement,
]

pub fn codesystemcontentmode_to_json(
  codesystemcontentmode: Codesystemcontentmode,
) -> Json {
  json.string(codesystemcontentmode_to_code(codesystemcontentmode))
}

pub fn codesystemcontentmode_to_code(
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

pub fn codesystemcontentmode_parse_code(
  code: String,
) -> Result(Codesystemcontentmode, Nil) {
  case code {
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
      decode.failure(
        CodesystemcontentmodeNotpresent,
        "code from valueset Codesystemcontentmode ["
          <> {
          codesystemcontentmode
          |> list.map(codesystemcontentmode_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Codesystemhierarchymeaning {
  CodesystemhierarchymeaningGroupedby
  CodesystemhierarchymeaningIsa
  CodesystemhierarchymeaningPartof
  CodesystemhierarchymeaningClassifiedwith
}

pub const codesystemhierarchymeaning: List(Codesystemhierarchymeaning) = [
  CodesystemhierarchymeaningGroupedby,
  CodesystemhierarchymeaningIsa,
  CodesystemhierarchymeaningPartof,
  CodesystemhierarchymeaningClassifiedwith,
]

pub fn codesystemhierarchymeaning_to_json(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> Json {
  json.string(codesystemhierarchymeaning_to_code(codesystemhierarchymeaning))
}

pub fn codesystemhierarchymeaning_to_code(
  codesystemhierarchymeaning: Codesystemhierarchymeaning,
) -> String {
  case codesystemhierarchymeaning {
    CodesystemhierarchymeaningGroupedby -> "grouped-by"
    CodesystemhierarchymeaningIsa -> "is-a"
    CodesystemhierarchymeaningPartof -> "part-of"
    CodesystemhierarchymeaningClassifiedwith -> "classified-with"
  }
}

pub fn codesystemhierarchymeaning_parse_code(
  code: String,
) -> Result(Codesystemhierarchymeaning, Nil) {
  case code {
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
        "code from valueset Codesystemhierarchymeaning ["
          <> {
          codesystemhierarchymeaning
          |> list.map(codesystemhierarchymeaning_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const conceptpropertytype: List(Conceptpropertytype) = [
  ConceptpropertytypeCode,
  ConceptpropertytypeCoding,
  ConceptpropertytypeString,
  ConceptpropertytypeInteger,
  ConceptpropertytypeBoolean,
  ConceptpropertytypeDatetime,
  ConceptpropertytypeDecimal,
]

pub fn conceptpropertytype_to_json(
  conceptpropertytype: Conceptpropertytype,
) -> Json {
  json.string(conceptpropertytype_to_code(conceptpropertytype))
}

pub fn conceptpropertytype_to_code(
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

pub fn conceptpropertytype_parse_code(
  code: String,
) -> Result(Conceptpropertytype, Nil) {
  case code {
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
    _ ->
      decode.failure(
        ConceptpropertytypeCode,
        "code from valueset Conceptpropertytype ["
          <> {
          conceptpropertytype
          |> list.map(conceptpropertytype_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const contactpointsystem: List(Contactpointsystem) = [
  ContactpointsystemPhone,
  ContactpointsystemFax,
  ContactpointsystemEmail,
  ContactpointsystemPager,
  ContactpointsystemUrl,
  ContactpointsystemSms,
  ContactpointsystemOther,
]

pub fn contactpointsystem_to_json(
  contactpointsystem: Contactpointsystem,
) -> Json {
  json.string(contactpointsystem_to_code(contactpointsystem))
}

pub fn contactpointsystem_to_code(
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

pub fn contactpointsystem_parse_code(
  code: String,
) -> Result(Contactpointsystem, Nil) {
  case code {
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
    _ ->
      decode.failure(
        ContactpointsystemPhone,
        "code from valueset Contactpointsystem ["
          <> {
          contactpointsystem
          |> list.map(contactpointsystem_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Contactpointuse {
  ContactpointuseHome
  ContactpointuseWork
  ContactpointuseTemp
  ContactpointuseOld
  ContactpointuseMobile
}

pub const contactpointuse: List(Contactpointuse) = [
  ContactpointuseHome,
  ContactpointuseWork,
  ContactpointuseTemp,
  ContactpointuseOld,
  ContactpointuseMobile,
]

pub fn contactpointuse_to_json(contactpointuse: Contactpointuse) -> Json {
  json.string(contactpointuse_to_code(contactpointuse))
}

pub fn contactpointuse_to_code(contactpointuse: Contactpointuse) -> String {
  case contactpointuse {
    ContactpointuseHome -> "home"
    ContactpointuseWork -> "work"
    ContactpointuseTemp -> "temp"
    ContactpointuseOld -> "old"
    ContactpointuseMobile -> "mobile"
  }
}

pub fn contactpointuse_parse_code(
  code: String,
) -> Result(Contactpointuse, Nil) {
  case code {
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
    _ ->
      decode.failure(
        ContactpointuseHome,
        "code from valueset Contactpointuse ["
          <> {
          contactpointuse
          |> list.map(contactpointuse_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Contributortype {
  ContributortypeAuthor
  ContributortypeEditor
  ContributortypeReviewer
  ContributortypeEndorser
}

pub const contributortype: List(Contributortype) = [
  ContributortypeAuthor,
  ContributortypeEditor,
  ContributortypeReviewer,
  ContributortypeEndorser,
]

pub fn contributortype_to_json(contributortype: Contributortype) -> Json {
  json.string(contributortype_to_code(contributortype))
}

pub fn contributortype_to_code(contributortype: Contributortype) -> String {
  case contributortype {
    ContributortypeAuthor -> "author"
    ContributortypeEditor -> "editor"
    ContributortypeReviewer -> "reviewer"
    ContributortypeEndorser -> "endorser"
  }
}

pub fn contributortype_parse_code(
  code: String,
) -> Result(Contributortype, Nil) {
  case code {
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
    _ ->
      decode.failure(
        ContributortypeAuthor,
        "code from valueset Contributortype ["
          <> {
          contributortype
          |> list.map(contributortype_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Currencies {
  CurrenciesAed
  CurrenciesAfn
  CurrenciesAll
  CurrenciesAmd
  CurrenciesAng
  CurrenciesAoa
  CurrenciesArs
  CurrenciesAud
  CurrenciesAwg
  CurrenciesAzn
  CurrenciesBam
  CurrenciesBbd
  CurrenciesBdt
  CurrenciesBgn
  CurrenciesBhd
  CurrenciesBif
  CurrenciesBmd
  CurrenciesBnd
  CurrenciesBob
  CurrenciesBov
  CurrenciesBrl
  CurrenciesBsd
  CurrenciesBtn
  CurrenciesBwp
  CurrenciesByn
  CurrenciesBzd
  CurrenciesCad
  CurrenciesCdf
  CurrenciesChe
  CurrenciesChf
  CurrenciesChw
  CurrenciesClf
  CurrenciesClp
  CurrenciesCny
  CurrenciesCop
  CurrenciesCou
  CurrenciesCrc
  CurrenciesCuc
  CurrenciesCup
  CurrenciesCve
  CurrenciesCzk
  CurrenciesDjf
  CurrenciesDkk
  CurrenciesDop
  CurrenciesDzd
  CurrenciesEgp
  CurrenciesErn
  CurrenciesEtb
  CurrenciesEur
  CurrenciesFjd
  CurrenciesFkp
  CurrenciesGbp
  CurrenciesGel
  CurrenciesGgp
  CurrenciesGhs
  CurrenciesGip
  CurrenciesGmd
  CurrenciesGnf
  CurrenciesGtq
  CurrenciesGyd
  CurrenciesHkd
  CurrenciesHnl
  CurrenciesHrk
  CurrenciesHtg
  CurrenciesHuf
  CurrenciesIdr
  CurrenciesIls
  CurrenciesImp
  CurrenciesInr
  CurrenciesIqd
  CurrenciesIrr
  CurrenciesIsk
  CurrenciesJep
  CurrenciesJmd
  CurrenciesJod
  CurrenciesJpy
  CurrenciesKes
  CurrenciesKgs
  CurrenciesKhr
  CurrenciesKmf
  CurrenciesKpw
  CurrenciesKrw
  CurrenciesKwd
  CurrenciesKyd
  CurrenciesKzt
  CurrenciesLak
  CurrenciesLbp
  CurrenciesLkr
  CurrenciesLrd
  CurrenciesLsl
  CurrenciesLyd
  CurrenciesMad
  CurrenciesMdl
  CurrenciesMga
  CurrenciesMkd
  CurrenciesMmk
  CurrenciesMnt
  CurrenciesMop
  CurrenciesMru
  CurrenciesMur
  CurrenciesMvr
  CurrenciesMwk
  CurrenciesMxn
  CurrenciesMxv
  CurrenciesMyr
  CurrenciesMzn
  CurrenciesNad
  CurrenciesNgn
  CurrenciesNio
  CurrenciesNok
  CurrenciesNpr
  CurrenciesNzd
  CurrenciesOmr
  CurrenciesPab
  CurrenciesPen
  CurrenciesPgk
  CurrenciesPhp
  CurrenciesPkr
  CurrenciesPln
  CurrenciesPyg
  CurrenciesQar
  CurrenciesRon
  CurrenciesRsd
  CurrenciesRub
  CurrenciesRwf
  CurrenciesSar
  CurrenciesSbd
  CurrenciesScr
  CurrenciesSdg
  CurrenciesSek
  CurrenciesSgd
  CurrenciesShp
  CurrenciesSll
  CurrenciesSos
  CurrenciesSrd
  CurrenciesSsp
  CurrenciesStn
  CurrenciesSvc
  CurrenciesSyp
  CurrenciesSzl
  CurrenciesThb
  CurrenciesTjs
  CurrenciesTmt
  CurrenciesTnd
  CurrenciesTop
  CurrenciesTry
  CurrenciesTtd
  CurrenciesTvd
  CurrenciesTwd
  CurrenciesTzs
  CurrenciesUah
  CurrenciesUgx
  CurrenciesUsd
  CurrenciesUsn
  CurrenciesUyi
  CurrenciesUyu
  CurrenciesUzs
  CurrenciesVef
  CurrenciesVnd
  CurrenciesVuv
  CurrenciesWst
  CurrenciesXaf
  CurrenciesXag
  CurrenciesXau
  CurrenciesXba
  CurrenciesXbb
  CurrenciesXbc
  CurrenciesXbd
  CurrenciesXcd
  CurrenciesXdr
  CurrenciesXof
  CurrenciesXpd
  CurrenciesXpf
  CurrenciesXpt
  CurrenciesXsu
  CurrenciesXts
  CurrenciesXua
  CurrenciesXxx
  CurrenciesYer
  CurrenciesZar
  CurrenciesZmw
  CurrenciesZwl
}

pub const currencies: List(Currencies) = [
  CurrenciesAed,
  CurrenciesAfn,
  CurrenciesAll,
  CurrenciesAmd,
  CurrenciesAng,
  CurrenciesAoa,
  CurrenciesArs,
  CurrenciesAud,
  CurrenciesAwg,
  CurrenciesAzn,
  CurrenciesBam,
  CurrenciesBbd,
  CurrenciesBdt,
  CurrenciesBgn,
  CurrenciesBhd,
  CurrenciesBif,
  CurrenciesBmd,
  CurrenciesBnd,
  CurrenciesBob,
  CurrenciesBov,
  CurrenciesBrl,
  CurrenciesBsd,
  CurrenciesBtn,
  CurrenciesBwp,
  CurrenciesByn,
  CurrenciesBzd,
  CurrenciesCad,
  CurrenciesCdf,
  CurrenciesChe,
  CurrenciesChf,
  CurrenciesChw,
  CurrenciesClf,
  CurrenciesClp,
  CurrenciesCny,
  CurrenciesCop,
  CurrenciesCou,
  CurrenciesCrc,
  CurrenciesCuc,
  CurrenciesCup,
  CurrenciesCve,
  CurrenciesCzk,
  CurrenciesDjf,
  CurrenciesDkk,
  CurrenciesDop,
  CurrenciesDzd,
  CurrenciesEgp,
  CurrenciesErn,
  CurrenciesEtb,
  CurrenciesEur,
  CurrenciesFjd,
  CurrenciesFkp,
  CurrenciesGbp,
  CurrenciesGel,
  CurrenciesGgp,
  CurrenciesGhs,
  CurrenciesGip,
  CurrenciesGmd,
  CurrenciesGnf,
  CurrenciesGtq,
  CurrenciesGyd,
  CurrenciesHkd,
  CurrenciesHnl,
  CurrenciesHrk,
  CurrenciesHtg,
  CurrenciesHuf,
  CurrenciesIdr,
  CurrenciesIls,
  CurrenciesImp,
  CurrenciesInr,
  CurrenciesIqd,
  CurrenciesIrr,
  CurrenciesIsk,
  CurrenciesJep,
  CurrenciesJmd,
  CurrenciesJod,
  CurrenciesJpy,
  CurrenciesKes,
  CurrenciesKgs,
  CurrenciesKhr,
  CurrenciesKmf,
  CurrenciesKpw,
  CurrenciesKrw,
  CurrenciesKwd,
  CurrenciesKyd,
  CurrenciesKzt,
  CurrenciesLak,
  CurrenciesLbp,
  CurrenciesLkr,
  CurrenciesLrd,
  CurrenciesLsl,
  CurrenciesLyd,
  CurrenciesMad,
  CurrenciesMdl,
  CurrenciesMga,
  CurrenciesMkd,
  CurrenciesMmk,
  CurrenciesMnt,
  CurrenciesMop,
  CurrenciesMru,
  CurrenciesMur,
  CurrenciesMvr,
  CurrenciesMwk,
  CurrenciesMxn,
  CurrenciesMxv,
  CurrenciesMyr,
  CurrenciesMzn,
  CurrenciesNad,
  CurrenciesNgn,
  CurrenciesNio,
  CurrenciesNok,
  CurrenciesNpr,
  CurrenciesNzd,
  CurrenciesOmr,
  CurrenciesPab,
  CurrenciesPen,
  CurrenciesPgk,
  CurrenciesPhp,
  CurrenciesPkr,
  CurrenciesPln,
  CurrenciesPyg,
  CurrenciesQar,
  CurrenciesRon,
  CurrenciesRsd,
  CurrenciesRub,
  CurrenciesRwf,
  CurrenciesSar,
  CurrenciesSbd,
  CurrenciesScr,
  CurrenciesSdg,
  CurrenciesSek,
  CurrenciesSgd,
  CurrenciesShp,
  CurrenciesSll,
  CurrenciesSos,
  CurrenciesSrd,
  CurrenciesSsp,
  CurrenciesStn,
  CurrenciesSvc,
  CurrenciesSyp,
  CurrenciesSzl,
  CurrenciesThb,
  CurrenciesTjs,
  CurrenciesTmt,
  CurrenciesTnd,
  CurrenciesTop,
  CurrenciesTry,
  CurrenciesTtd,
  CurrenciesTvd,
  CurrenciesTwd,
  CurrenciesTzs,
  CurrenciesUah,
  CurrenciesUgx,
  CurrenciesUsd,
  CurrenciesUsn,
  CurrenciesUyi,
  CurrenciesUyu,
  CurrenciesUzs,
  CurrenciesVef,
  CurrenciesVnd,
  CurrenciesVuv,
  CurrenciesWst,
  CurrenciesXaf,
  CurrenciesXag,
  CurrenciesXau,
  CurrenciesXba,
  CurrenciesXbb,
  CurrenciesXbc,
  CurrenciesXbd,
  CurrenciesXcd,
  CurrenciesXdr,
  CurrenciesXof,
  CurrenciesXpd,
  CurrenciesXpf,
  CurrenciesXpt,
  CurrenciesXsu,
  CurrenciesXts,
  CurrenciesXua,
  CurrenciesXxx,
  CurrenciesYer,
  CurrenciesZar,
  CurrenciesZmw,
  CurrenciesZwl,
]

pub fn currencies_to_json(currencies: Currencies) -> Json {
  json.string(currencies_to_code(currencies))
}

pub fn currencies_to_code(currencies: Currencies) -> String {
  case currencies {
    CurrenciesAed -> "AED"
    CurrenciesAfn -> "AFN"
    CurrenciesAll -> "ALL"
    CurrenciesAmd -> "AMD"
    CurrenciesAng -> "ANG"
    CurrenciesAoa -> "AOA"
    CurrenciesArs -> "ARS"
    CurrenciesAud -> "AUD"
    CurrenciesAwg -> "AWG"
    CurrenciesAzn -> "AZN"
    CurrenciesBam -> "BAM"
    CurrenciesBbd -> "BBD"
    CurrenciesBdt -> "BDT"
    CurrenciesBgn -> "BGN"
    CurrenciesBhd -> "BHD"
    CurrenciesBif -> "BIF"
    CurrenciesBmd -> "BMD"
    CurrenciesBnd -> "BND"
    CurrenciesBob -> "BOB"
    CurrenciesBov -> "BOV"
    CurrenciesBrl -> "BRL"
    CurrenciesBsd -> "BSD"
    CurrenciesBtn -> "BTN"
    CurrenciesBwp -> "BWP"
    CurrenciesByn -> "BYN"
    CurrenciesBzd -> "BZD"
    CurrenciesCad -> "CAD"
    CurrenciesCdf -> "CDF"
    CurrenciesChe -> "CHE"
    CurrenciesChf -> "CHF"
    CurrenciesChw -> "CHW"
    CurrenciesClf -> "CLF"
    CurrenciesClp -> "CLP"
    CurrenciesCny -> "CNY"
    CurrenciesCop -> "COP"
    CurrenciesCou -> "COU"
    CurrenciesCrc -> "CRC"
    CurrenciesCuc -> "CUC"
    CurrenciesCup -> "CUP"
    CurrenciesCve -> "CVE"
    CurrenciesCzk -> "CZK"
    CurrenciesDjf -> "DJF"
    CurrenciesDkk -> "DKK"
    CurrenciesDop -> "DOP"
    CurrenciesDzd -> "DZD"
    CurrenciesEgp -> "EGP"
    CurrenciesErn -> "ERN"
    CurrenciesEtb -> "ETB"
    CurrenciesEur -> "EUR"
    CurrenciesFjd -> "FJD"
    CurrenciesFkp -> "FKP"
    CurrenciesGbp -> "GBP"
    CurrenciesGel -> "GEL"
    CurrenciesGgp -> "GGP"
    CurrenciesGhs -> "GHS"
    CurrenciesGip -> "GIP"
    CurrenciesGmd -> "GMD"
    CurrenciesGnf -> "GNF"
    CurrenciesGtq -> "GTQ"
    CurrenciesGyd -> "GYD"
    CurrenciesHkd -> "HKD"
    CurrenciesHnl -> "HNL"
    CurrenciesHrk -> "HRK"
    CurrenciesHtg -> "HTG"
    CurrenciesHuf -> "HUF"
    CurrenciesIdr -> "IDR"
    CurrenciesIls -> "ILS"
    CurrenciesImp -> "IMP"
    CurrenciesInr -> "INR"
    CurrenciesIqd -> "IQD"
    CurrenciesIrr -> "IRR"
    CurrenciesIsk -> "ISK"
    CurrenciesJep -> "JEP"
    CurrenciesJmd -> "JMD"
    CurrenciesJod -> "JOD"
    CurrenciesJpy -> "JPY"
    CurrenciesKes -> "KES"
    CurrenciesKgs -> "KGS"
    CurrenciesKhr -> "KHR"
    CurrenciesKmf -> "KMF"
    CurrenciesKpw -> "KPW"
    CurrenciesKrw -> "KRW"
    CurrenciesKwd -> "KWD"
    CurrenciesKyd -> "KYD"
    CurrenciesKzt -> "KZT"
    CurrenciesLak -> "LAK"
    CurrenciesLbp -> "LBP"
    CurrenciesLkr -> "LKR"
    CurrenciesLrd -> "LRD"
    CurrenciesLsl -> "LSL"
    CurrenciesLyd -> "LYD"
    CurrenciesMad -> "MAD"
    CurrenciesMdl -> "MDL"
    CurrenciesMga -> "MGA"
    CurrenciesMkd -> "MKD"
    CurrenciesMmk -> "MMK"
    CurrenciesMnt -> "MNT"
    CurrenciesMop -> "MOP"
    CurrenciesMru -> "MRU"
    CurrenciesMur -> "MUR"
    CurrenciesMvr -> "MVR"
    CurrenciesMwk -> "MWK"
    CurrenciesMxn -> "MXN"
    CurrenciesMxv -> "MXV"
    CurrenciesMyr -> "MYR"
    CurrenciesMzn -> "MZN"
    CurrenciesNad -> "NAD"
    CurrenciesNgn -> "NGN"
    CurrenciesNio -> "NIO"
    CurrenciesNok -> "NOK"
    CurrenciesNpr -> "NPR"
    CurrenciesNzd -> "NZD"
    CurrenciesOmr -> "OMR"
    CurrenciesPab -> "PAB"
    CurrenciesPen -> "PEN"
    CurrenciesPgk -> "PGK"
    CurrenciesPhp -> "PHP"
    CurrenciesPkr -> "PKR"
    CurrenciesPln -> "PLN"
    CurrenciesPyg -> "PYG"
    CurrenciesQar -> "QAR"
    CurrenciesRon -> "RON"
    CurrenciesRsd -> "RSD"
    CurrenciesRub -> "RUB"
    CurrenciesRwf -> "RWF"
    CurrenciesSar -> "SAR"
    CurrenciesSbd -> "SBD"
    CurrenciesScr -> "SCR"
    CurrenciesSdg -> "SDG"
    CurrenciesSek -> "SEK"
    CurrenciesSgd -> "SGD"
    CurrenciesShp -> "SHP"
    CurrenciesSll -> "SLL"
    CurrenciesSos -> "SOS"
    CurrenciesSrd -> "SRD"
    CurrenciesSsp -> "SSP"
    CurrenciesStn -> "STN"
    CurrenciesSvc -> "SVC"
    CurrenciesSyp -> "SYP"
    CurrenciesSzl -> "SZL"
    CurrenciesThb -> "THB"
    CurrenciesTjs -> "TJS"
    CurrenciesTmt -> "TMT"
    CurrenciesTnd -> "TND"
    CurrenciesTop -> "TOP"
    CurrenciesTry -> "TRY"
    CurrenciesTtd -> "TTD"
    CurrenciesTvd -> "TVD"
    CurrenciesTwd -> "TWD"
    CurrenciesTzs -> "TZS"
    CurrenciesUah -> "UAH"
    CurrenciesUgx -> "UGX"
    CurrenciesUsd -> "USD"
    CurrenciesUsn -> "USN"
    CurrenciesUyi -> "UYI"
    CurrenciesUyu -> "UYU"
    CurrenciesUzs -> "UZS"
    CurrenciesVef -> "VEF"
    CurrenciesVnd -> "VND"
    CurrenciesVuv -> "VUV"
    CurrenciesWst -> "WST"
    CurrenciesXaf -> "XAF"
    CurrenciesXag -> "XAG"
    CurrenciesXau -> "XAU"
    CurrenciesXba -> "XBA"
    CurrenciesXbb -> "XBB"
    CurrenciesXbc -> "XBC"
    CurrenciesXbd -> "XBD"
    CurrenciesXcd -> "XCD"
    CurrenciesXdr -> "XDR"
    CurrenciesXof -> "XOF"
    CurrenciesXpd -> "XPD"
    CurrenciesXpf -> "XPF"
    CurrenciesXpt -> "XPT"
    CurrenciesXsu -> "XSU"
    CurrenciesXts -> "XTS"
    CurrenciesXua -> "XUA"
    CurrenciesXxx -> "XXX"
    CurrenciesYer -> "YER"
    CurrenciesZar -> "ZAR"
    CurrenciesZmw -> "ZMW"
    CurrenciesZwl -> "ZWL"
  }
}

pub fn currencies_parse_code(code: String) -> Result(Currencies, Nil) {
  case code {
    "AED" -> Ok(CurrenciesAed)
    "AFN" -> Ok(CurrenciesAfn)
    "ALL" -> Ok(CurrenciesAll)
    "AMD" -> Ok(CurrenciesAmd)
    "ANG" -> Ok(CurrenciesAng)
    "AOA" -> Ok(CurrenciesAoa)
    "ARS" -> Ok(CurrenciesArs)
    "AUD" -> Ok(CurrenciesAud)
    "AWG" -> Ok(CurrenciesAwg)
    "AZN" -> Ok(CurrenciesAzn)
    "BAM" -> Ok(CurrenciesBam)
    "BBD" -> Ok(CurrenciesBbd)
    "BDT" -> Ok(CurrenciesBdt)
    "BGN" -> Ok(CurrenciesBgn)
    "BHD" -> Ok(CurrenciesBhd)
    "BIF" -> Ok(CurrenciesBif)
    "BMD" -> Ok(CurrenciesBmd)
    "BND" -> Ok(CurrenciesBnd)
    "BOB" -> Ok(CurrenciesBob)
    "BOV" -> Ok(CurrenciesBov)
    "BRL" -> Ok(CurrenciesBrl)
    "BSD" -> Ok(CurrenciesBsd)
    "BTN" -> Ok(CurrenciesBtn)
    "BWP" -> Ok(CurrenciesBwp)
    "BYN" -> Ok(CurrenciesByn)
    "BZD" -> Ok(CurrenciesBzd)
    "CAD" -> Ok(CurrenciesCad)
    "CDF" -> Ok(CurrenciesCdf)
    "CHE" -> Ok(CurrenciesChe)
    "CHF" -> Ok(CurrenciesChf)
    "CHW" -> Ok(CurrenciesChw)
    "CLF" -> Ok(CurrenciesClf)
    "CLP" -> Ok(CurrenciesClp)
    "CNY" -> Ok(CurrenciesCny)
    "COP" -> Ok(CurrenciesCop)
    "COU" -> Ok(CurrenciesCou)
    "CRC" -> Ok(CurrenciesCrc)
    "CUC" -> Ok(CurrenciesCuc)
    "CUP" -> Ok(CurrenciesCup)
    "CVE" -> Ok(CurrenciesCve)
    "CZK" -> Ok(CurrenciesCzk)
    "DJF" -> Ok(CurrenciesDjf)
    "DKK" -> Ok(CurrenciesDkk)
    "DOP" -> Ok(CurrenciesDop)
    "DZD" -> Ok(CurrenciesDzd)
    "EGP" -> Ok(CurrenciesEgp)
    "ERN" -> Ok(CurrenciesErn)
    "ETB" -> Ok(CurrenciesEtb)
    "EUR" -> Ok(CurrenciesEur)
    "FJD" -> Ok(CurrenciesFjd)
    "FKP" -> Ok(CurrenciesFkp)
    "GBP" -> Ok(CurrenciesGbp)
    "GEL" -> Ok(CurrenciesGel)
    "GGP" -> Ok(CurrenciesGgp)
    "GHS" -> Ok(CurrenciesGhs)
    "GIP" -> Ok(CurrenciesGip)
    "GMD" -> Ok(CurrenciesGmd)
    "GNF" -> Ok(CurrenciesGnf)
    "GTQ" -> Ok(CurrenciesGtq)
    "GYD" -> Ok(CurrenciesGyd)
    "HKD" -> Ok(CurrenciesHkd)
    "HNL" -> Ok(CurrenciesHnl)
    "HRK" -> Ok(CurrenciesHrk)
    "HTG" -> Ok(CurrenciesHtg)
    "HUF" -> Ok(CurrenciesHuf)
    "IDR" -> Ok(CurrenciesIdr)
    "ILS" -> Ok(CurrenciesIls)
    "IMP" -> Ok(CurrenciesImp)
    "INR" -> Ok(CurrenciesInr)
    "IQD" -> Ok(CurrenciesIqd)
    "IRR" -> Ok(CurrenciesIrr)
    "ISK" -> Ok(CurrenciesIsk)
    "JEP" -> Ok(CurrenciesJep)
    "JMD" -> Ok(CurrenciesJmd)
    "JOD" -> Ok(CurrenciesJod)
    "JPY" -> Ok(CurrenciesJpy)
    "KES" -> Ok(CurrenciesKes)
    "KGS" -> Ok(CurrenciesKgs)
    "KHR" -> Ok(CurrenciesKhr)
    "KMF" -> Ok(CurrenciesKmf)
    "KPW" -> Ok(CurrenciesKpw)
    "KRW" -> Ok(CurrenciesKrw)
    "KWD" -> Ok(CurrenciesKwd)
    "KYD" -> Ok(CurrenciesKyd)
    "KZT" -> Ok(CurrenciesKzt)
    "LAK" -> Ok(CurrenciesLak)
    "LBP" -> Ok(CurrenciesLbp)
    "LKR" -> Ok(CurrenciesLkr)
    "LRD" -> Ok(CurrenciesLrd)
    "LSL" -> Ok(CurrenciesLsl)
    "LYD" -> Ok(CurrenciesLyd)
    "MAD" -> Ok(CurrenciesMad)
    "MDL" -> Ok(CurrenciesMdl)
    "MGA" -> Ok(CurrenciesMga)
    "MKD" -> Ok(CurrenciesMkd)
    "MMK" -> Ok(CurrenciesMmk)
    "MNT" -> Ok(CurrenciesMnt)
    "MOP" -> Ok(CurrenciesMop)
    "MRU" -> Ok(CurrenciesMru)
    "MUR" -> Ok(CurrenciesMur)
    "MVR" -> Ok(CurrenciesMvr)
    "MWK" -> Ok(CurrenciesMwk)
    "MXN" -> Ok(CurrenciesMxn)
    "MXV" -> Ok(CurrenciesMxv)
    "MYR" -> Ok(CurrenciesMyr)
    "MZN" -> Ok(CurrenciesMzn)
    "NAD" -> Ok(CurrenciesNad)
    "NGN" -> Ok(CurrenciesNgn)
    "NIO" -> Ok(CurrenciesNio)
    "NOK" -> Ok(CurrenciesNok)
    "NPR" -> Ok(CurrenciesNpr)
    "NZD" -> Ok(CurrenciesNzd)
    "OMR" -> Ok(CurrenciesOmr)
    "PAB" -> Ok(CurrenciesPab)
    "PEN" -> Ok(CurrenciesPen)
    "PGK" -> Ok(CurrenciesPgk)
    "PHP" -> Ok(CurrenciesPhp)
    "PKR" -> Ok(CurrenciesPkr)
    "PLN" -> Ok(CurrenciesPln)
    "PYG" -> Ok(CurrenciesPyg)
    "QAR" -> Ok(CurrenciesQar)
    "RON" -> Ok(CurrenciesRon)
    "RSD" -> Ok(CurrenciesRsd)
    "RUB" -> Ok(CurrenciesRub)
    "RWF" -> Ok(CurrenciesRwf)
    "SAR" -> Ok(CurrenciesSar)
    "SBD" -> Ok(CurrenciesSbd)
    "SCR" -> Ok(CurrenciesScr)
    "SDG" -> Ok(CurrenciesSdg)
    "SEK" -> Ok(CurrenciesSek)
    "SGD" -> Ok(CurrenciesSgd)
    "SHP" -> Ok(CurrenciesShp)
    "SLL" -> Ok(CurrenciesSll)
    "SOS" -> Ok(CurrenciesSos)
    "SRD" -> Ok(CurrenciesSrd)
    "SSP" -> Ok(CurrenciesSsp)
    "STN" -> Ok(CurrenciesStn)
    "SVC" -> Ok(CurrenciesSvc)
    "SYP" -> Ok(CurrenciesSyp)
    "SZL" -> Ok(CurrenciesSzl)
    "THB" -> Ok(CurrenciesThb)
    "TJS" -> Ok(CurrenciesTjs)
    "TMT" -> Ok(CurrenciesTmt)
    "TND" -> Ok(CurrenciesTnd)
    "TOP" -> Ok(CurrenciesTop)
    "TRY" -> Ok(CurrenciesTry)
    "TTD" -> Ok(CurrenciesTtd)
    "TVD" -> Ok(CurrenciesTvd)
    "TWD" -> Ok(CurrenciesTwd)
    "TZS" -> Ok(CurrenciesTzs)
    "UAH" -> Ok(CurrenciesUah)
    "UGX" -> Ok(CurrenciesUgx)
    "USD" -> Ok(CurrenciesUsd)
    "USN" -> Ok(CurrenciesUsn)
    "UYI" -> Ok(CurrenciesUyi)
    "UYU" -> Ok(CurrenciesUyu)
    "UZS" -> Ok(CurrenciesUzs)
    "VEF" -> Ok(CurrenciesVef)
    "VND" -> Ok(CurrenciesVnd)
    "VUV" -> Ok(CurrenciesVuv)
    "WST" -> Ok(CurrenciesWst)
    "XAF" -> Ok(CurrenciesXaf)
    "XAG" -> Ok(CurrenciesXag)
    "XAU" -> Ok(CurrenciesXau)
    "XBA" -> Ok(CurrenciesXba)
    "XBB" -> Ok(CurrenciesXbb)
    "XBC" -> Ok(CurrenciesXbc)
    "XBD" -> Ok(CurrenciesXbd)
    "XCD" -> Ok(CurrenciesXcd)
    "XDR" -> Ok(CurrenciesXdr)
    "XOF" -> Ok(CurrenciesXof)
    "XPD" -> Ok(CurrenciesXpd)
    "XPF" -> Ok(CurrenciesXpf)
    "XPT" -> Ok(CurrenciesXpt)
    "XSU" -> Ok(CurrenciesXsu)
    "XTS" -> Ok(CurrenciesXts)
    "XUA" -> Ok(CurrenciesXua)
    "XXX" -> Ok(CurrenciesXxx)
    "YER" -> Ok(CurrenciesYer)
    "ZAR" -> Ok(CurrenciesZar)
    "ZMW" -> Ok(CurrenciesZmw)
    "ZWL" -> Ok(CurrenciesZwl)
    _ -> Error(Nil)
  }
}

pub fn currencies_decoder() -> Decoder(Currencies) {
  use variant <- decode.then(decode.string)
  case variant {
    "AED" -> decode.success(CurrenciesAed)
    "AFN" -> decode.success(CurrenciesAfn)
    "ALL" -> decode.success(CurrenciesAll)
    "AMD" -> decode.success(CurrenciesAmd)
    "ANG" -> decode.success(CurrenciesAng)
    "AOA" -> decode.success(CurrenciesAoa)
    "ARS" -> decode.success(CurrenciesArs)
    "AUD" -> decode.success(CurrenciesAud)
    "AWG" -> decode.success(CurrenciesAwg)
    "AZN" -> decode.success(CurrenciesAzn)
    "BAM" -> decode.success(CurrenciesBam)
    "BBD" -> decode.success(CurrenciesBbd)
    "BDT" -> decode.success(CurrenciesBdt)
    "BGN" -> decode.success(CurrenciesBgn)
    "BHD" -> decode.success(CurrenciesBhd)
    "BIF" -> decode.success(CurrenciesBif)
    "BMD" -> decode.success(CurrenciesBmd)
    "BND" -> decode.success(CurrenciesBnd)
    "BOB" -> decode.success(CurrenciesBob)
    "BOV" -> decode.success(CurrenciesBov)
    "BRL" -> decode.success(CurrenciesBrl)
    "BSD" -> decode.success(CurrenciesBsd)
    "BTN" -> decode.success(CurrenciesBtn)
    "BWP" -> decode.success(CurrenciesBwp)
    "BYN" -> decode.success(CurrenciesByn)
    "BZD" -> decode.success(CurrenciesBzd)
    "CAD" -> decode.success(CurrenciesCad)
    "CDF" -> decode.success(CurrenciesCdf)
    "CHE" -> decode.success(CurrenciesChe)
    "CHF" -> decode.success(CurrenciesChf)
    "CHW" -> decode.success(CurrenciesChw)
    "CLF" -> decode.success(CurrenciesClf)
    "CLP" -> decode.success(CurrenciesClp)
    "CNY" -> decode.success(CurrenciesCny)
    "COP" -> decode.success(CurrenciesCop)
    "COU" -> decode.success(CurrenciesCou)
    "CRC" -> decode.success(CurrenciesCrc)
    "CUC" -> decode.success(CurrenciesCuc)
    "CUP" -> decode.success(CurrenciesCup)
    "CVE" -> decode.success(CurrenciesCve)
    "CZK" -> decode.success(CurrenciesCzk)
    "DJF" -> decode.success(CurrenciesDjf)
    "DKK" -> decode.success(CurrenciesDkk)
    "DOP" -> decode.success(CurrenciesDop)
    "DZD" -> decode.success(CurrenciesDzd)
    "EGP" -> decode.success(CurrenciesEgp)
    "ERN" -> decode.success(CurrenciesErn)
    "ETB" -> decode.success(CurrenciesEtb)
    "EUR" -> decode.success(CurrenciesEur)
    "FJD" -> decode.success(CurrenciesFjd)
    "FKP" -> decode.success(CurrenciesFkp)
    "GBP" -> decode.success(CurrenciesGbp)
    "GEL" -> decode.success(CurrenciesGel)
    "GGP" -> decode.success(CurrenciesGgp)
    "GHS" -> decode.success(CurrenciesGhs)
    "GIP" -> decode.success(CurrenciesGip)
    "GMD" -> decode.success(CurrenciesGmd)
    "GNF" -> decode.success(CurrenciesGnf)
    "GTQ" -> decode.success(CurrenciesGtq)
    "GYD" -> decode.success(CurrenciesGyd)
    "HKD" -> decode.success(CurrenciesHkd)
    "HNL" -> decode.success(CurrenciesHnl)
    "HRK" -> decode.success(CurrenciesHrk)
    "HTG" -> decode.success(CurrenciesHtg)
    "HUF" -> decode.success(CurrenciesHuf)
    "IDR" -> decode.success(CurrenciesIdr)
    "ILS" -> decode.success(CurrenciesIls)
    "IMP" -> decode.success(CurrenciesImp)
    "INR" -> decode.success(CurrenciesInr)
    "IQD" -> decode.success(CurrenciesIqd)
    "IRR" -> decode.success(CurrenciesIrr)
    "ISK" -> decode.success(CurrenciesIsk)
    "JEP" -> decode.success(CurrenciesJep)
    "JMD" -> decode.success(CurrenciesJmd)
    "JOD" -> decode.success(CurrenciesJod)
    "JPY" -> decode.success(CurrenciesJpy)
    "KES" -> decode.success(CurrenciesKes)
    "KGS" -> decode.success(CurrenciesKgs)
    "KHR" -> decode.success(CurrenciesKhr)
    "KMF" -> decode.success(CurrenciesKmf)
    "KPW" -> decode.success(CurrenciesKpw)
    "KRW" -> decode.success(CurrenciesKrw)
    "KWD" -> decode.success(CurrenciesKwd)
    "KYD" -> decode.success(CurrenciesKyd)
    "KZT" -> decode.success(CurrenciesKzt)
    "LAK" -> decode.success(CurrenciesLak)
    "LBP" -> decode.success(CurrenciesLbp)
    "LKR" -> decode.success(CurrenciesLkr)
    "LRD" -> decode.success(CurrenciesLrd)
    "LSL" -> decode.success(CurrenciesLsl)
    "LYD" -> decode.success(CurrenciesLyd)
    "MAD" -> decode.success(CurrenciesMad)
    "MDL" -> decode.success(CurrenciesMdl)
    "MGA" -> decode.success(CurrenciesMga)
    "MKD" -> decode.success(CurrenciesMkd)
    "MMK" -> decode.success(CurrenciesMmk)
    "MNT" -> decode.success(CurrenciesMnt)
    "MOP" -> decode.success(CurrenciesMop)
    "MRU" -> decode.success(CurrenciesMru)
    "MUR" -> decode.success(CurrenciesMur)
    "MVR" -> decode.success(CurrenciesMvr)
    "MWK" -> decode.success(CurrenciesMwk)
    "MXN" -> decode.success(CurrenciesMxn)
    "MXV" -> decode.success(CurrenciesMxv)
    "MYR" -> decode.success(CurrenciesMyr)
    "MZN" -> decode.success(CurrenciesMzn)
    "NAD" -> decode.success(CurrenciesNad)
    "NGN" -> decode.success(CurrenciesNgn)
    "NIO" -> decode.success(CurrenciesNio)
    "NOK" -> decode.success(CurrenciesNok)
    "NPR" -> decode.success(CurrenciesNpr)
    "NZD" -> decode.success(CurrenciesNzd)
    "OMR" -> decode.success(CurrenciesOmr)
    "PAB" -> decode.success(CurrenciesPab)
    "PEN" -> decode.success(CurrenciesPen)
    "PGK" -> decode.success(CurrenciesPgk)
    "PHP" -> decode.success(CurrenciesPhp)
    "PKR" -> decode.success(CurrenciesPkr)
    "PLN" -> decode.success(CurrenciesPln)
    "PYG" -> decode.success(CurrenciesPyg)
    "QAR" -> decode.success(CurrenciesQar)
    "RON" -> decode.success(CurrenciesRon)
    "RSD" -> decode.success(CurrenciesRsd)
    "RUB" -> decode.success(CurrenciesRub)
    "RWF" -> decode.success(CurrenciesRwf)
    "SAR" -> decode.success(CurrenciesSar)
    "SBD" -> decode.success(CurrenciesSbd)
    "SCR" -> decode.success(CurrenciesScr)
    "SDG" -> decode.success(CurrenciesSdg)
    "SEK" -> decode.success(CurrenciesSek)
    "SGD" -> decode.success(CurrenciesSgd)
    "SHP" -> decode.success(CurrenciesShp)
    "SLL" -> decode.success(CurrenciesSll)
    "SOS" -> decode.success(CurrenciesSos)
    "SRD" -> decode.success(CurrenciesSrd)
    "SSP" -> decode.success(CurrenciesSsp)
    "STN" -> decode.success(CurrenciesStn)
    "SVC" -> decode.success(CurrenciesSvc)
    "SYP" -> decode.success(CurrenciesSyp)
    "SZL" -> decode.success(CurrenciesSzl)
    "THB" -> decode.success(CurrenciesThb)
    "TJS" -> decode.success(CurrenciesTjs)
    "TMT" -> decode.success(CurrenciesTmt)
    "TND" -> decode.success(CurrenciesTnd)
    "TOP" -> decode.success(CurrenciesTop)
    "TRY" -> decode.success(CurrenciesTry)
    "TTD" -> decode.success(CurrenciesTtd)
    "TVD" -> decode.success(CurrenciesTvd)
    "TWD" -> decode.success(CurrenciesTwd)
    "TZS" -> decode.success(CurrenciesTzs)
    "UAH" -> decode.success(CurrenciesUah)
    "UGX" -> decode.success(CurrenciesUgx)
    "USD" -> decode.success(CurrenciesUsd)
    "USN" -> decode.success(CurrenciesUsn)
    "UYI" -> decode.success(CurrenciesUyi)
    "UYU" -> decode.success(CurrenciesUyu)
    "UZS" -> decode.success(CurrenciesUzs)
    "VEF" -> decode.success(CurrenciesVef)
    "VND" -> decode.success(CurrenciesVnd)
    "VUV" -> decode.success(CurrenciesVuv)
    "WST" -> decode.success(CurrenciesWst)
    "XAF" -> decode.success(CurrenciesXaf)
    "XAG" -> decode.success(CurrenciesXag)
    "XAU" -> decode.success(CurrenciesXau)
    "XBA" -> decode.success(CurrenciesXba)
    "XBB" -> decode.success(CurrenciesXbb)
    "XBC" -> decode.success(CurrenciesXbc)
    "XBD" -> decode.success(CurrenciesXbd)
    "XCD" -> decode.success(CurrenciesXcd)
    "XDR" -> decode.success(CurrenciesXdr)
    "XOF" -> decode.success(CurrenciesXof)
    "XPD" -> decode.success(CurrenciesXpd)
    "XPF" -> decode.success(CurrenciesXpf)
    "XPT" -> decode.success(CurrenciesXpt)
    "XSU" -> decode.success(CurrenciesXsu)
    "XTS" -> decode.success(CurrenciesXts)
    "XUA" -> decode.success(CurrenciesXua)
    "XXX" -> decode.success(CurrenciesXxx)
    "YER" -> decode.success(CurrenciesYer)
    "ZAR" -> decode.success(CurrenciesZar)
    "ZMW" -> decode.success(CurrenciesZmw)
    "ZWL" -> decode.success(CurrenciesZwl)
    _ ->
      decode.failure(
        CurrenciesAed,
        "code from valueset Currencies ["
          <> { currencies |> list.map(currencies_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const daysofweek: List(Daysofweek) = [
  DaysofweekMon,
  DaysofweekTue,
  DaysofweekWed,
  DaysofweekThu,
  DaysofweekFri,
  DaysofweekSat,
  DaysofweekSun,
]

pub fn daysofweek_to_json(daysofweek: Daysofweek) -> Json {
  json.string(daysofweek_to_code(daysofweek))
}

pub fn daysofweek_to_code(daysofweek: Daysofweek) -> String {
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

pub fn daysofweek_parse_code(code: String) -> Result(Daysofweek, Nil) {
  case code {
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
    _ ->
      decode.failure(
        DaysofweekMon,
        "code from valueset Daysofweek ["
          <> { daysofweek |> list.map(daysofweek_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const eventtiming: List(Eventtiming) = [
  EventtimingMorn,
  EventtimingMornearly,
  EventtimingMornlate,
  EventtimingNoon,
  EventtimingAft,
  EventtimingAftearly,
  EventtimingAftlate,
  EventtimingEve,
  EventtimingEveearly,
  EventtimingEvelate,
  EventtimingNight,
  EventtimingPhs,
  EventtimingHs,
  EventtimingWake,
  EventtimingC,
  EventtimingCm,
  EventtimingCd,
  EventtimingCv,
  EventtimingAc,
  EventtimingAcm,
  EventtimingAcd,
  EventtimingAcv,
  EventtimingPc,
  EventtimingPcm,
  EventtimingPcd,
  EventtimingPcv,
]

pub fn eventtiming_to_json(eventtiming: Eventtiming) -> Json {
  json.string(eventtiming_to_code(eventtiming))
}

pub fn eventtiming_to_code(eventtiming: Eventtiming) -> String {
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

pub fn eventtiming_parse_code(code: String) -> Result(Eventtiming, Nil) {
  case code {
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
    _ ->
      decode.failure(
        EventtimingMorn,
        "code from valueset Eventtiming ["
          <> {
          eventtiming |> list.map(eventtiming_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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
  FilteroperatorExists
}

pub const filteroperator: List(Filteroperator) = [
  FilteroperatorEqual,
  FilteroperatorIsa,
  FilteroperatorDescendentof,
  FilteroperatorIsnota,
  FilteroperatorRegex,
  FilteroperatorIn,
  FilteroperatorNotin,
  FilteroperatorGeneralizes,
  FilteroperatorExists,
]

pub fn filteroperator_to_json(filteroperator: Filteroperator) -> Json {
  json.string(filteroperator_to_code(filteroperator))
}

pub fn filteroperator_to_code(filteroperator: Filteroperator) -> String {
  case filteroperator {
    FilteroperatorEqual -> "="
    FilteroperatorIsa -> "is-a"
    FilteroperatorDescendentof -> "descendent-of"
    FilteroperatorIsnota -> "is-not-a"
    FilteroperatorRegex -> "regex"
    FilteroperatorIn -> "in"
    FilteroperatorNotin -> "not-in"
    FilteroperatorGeneralizes -> "generalizes"
    FilteroperatorExists -> "exists"
  }
}

pub fn filteroperator_parse_code(code: String) -> Result(Filteroperator, Nil) {
  case code {
    "=" -> Ok(FilteroperatorEqual)
    "is-a" -> Ok(FilteroperatorIsa)
    "descendent-of" -> Ok(FilteroperatorDescendentof)
    "is-not-a" -> Ok(FilteroperatorIsnota)
    "regex" -> Ok(FilteroperatorRegex)
    "in" -> Ok(FilteroperatorIn)
    "not-in" -> Ok(FilteroperatorNotin)
    "generalizes" -> Ok(FilteroperatorGeneralizes)
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
    "exists" -> decode.success(FilteroperatorExists)
    _ ->
      decode.failure(
        FilteroperatorEqual,
        "code from valueset Filteroperator ["
          <> {
          filteroperator
          |> list.map(filteroperator_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const httpverb: List(Httpverb) = [
  HttpverbGet,
  HttpverbHead,
  HttpverbPost,
  HttpverbPut,
  HttpverbDelete,
  HttpverbPatch,
]

pub fn httpverb_to_json(httpverb: Httpverb) -> Json {
  json.string(httpverb_to_code(httpverb))
}

pub fn httpverb_to_code(httpverb: Httpverb) -> String {
  case httpverb {
    HttpverbGet -> "GET"
    HttpverbHead -> "HEAD"
    HttpverbPost -> "POST"
    HttpverbPut -> "PUT"
    HttpverbDelete -> "DELETE"
    HttpverbPatch -> "PATCH"
  }
}

pub fn httpverb_parse_code(code: String) -> Result(Httpverb, Nil) {
  case code {
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
    _ ->
      decode.failure(
        HttpverbGet,
        "code from valueset Httpverb ["
          <> { httpverb |> list.map(httpverb_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Identifieruse {
  IdentifieruseUsual
  IdentifieruseOfficial
  IdentifieruseTemp
  IdentifieruseSecondary
  IdentifieruseOld
}

pub const identifieruse: List(Identifieruse) = [
  IdentifieruseUsual,
  IdentifieruseOfficial,
  IdentifieruseTemp,
  IdentifieruseSecondary,
  IdentifieruseOld,
]

pub fn identifieruse_to_json(identifieruse: Identifieruse) -> Json {
  json.string(identifieruse_to_code(identifieruse))
}

pub fn identifieruse_to_code(identifieruse: Identifieruse) -> String {
  case identifieruse {
    IdentifieruseUsual -> "usual"
    IdentifieruseOfficial -> "official"
    IdentifieruseTemp -> "temp"
    IdentifieruseSecondary -> "secondary"
    IdentifieruseOld -> "old"
  }
}

pub fn identifieruse_parse_code(code: String) -> Result(Identifieruse, Nil) {
  case code {
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
    _ ->
      decode.failure(
        IdentifieruseUsual,
        "code from valueset Identifieruse ["
          <> {
          identifieruse |> list.map(identifieruse_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
}

pub const issueseverity: List(Issueseverity) = [
  IssueseverityFatal,
  IssueseverityError,
  IssueseverityWarning,
  IssueseverityInformation,
]

pub fn issueseverity_to_json(issueseverity: Issueseverity) -> Json {
  json.string(issueseverity_to_code(issueseverity))
}

pub fn issueseverity_to_code(issueseverity: Issueseverity) -> String {
  case issueseverity {
    IssueseverityFatal -> "fatal"
    IssueseverityError -> "error"
    IssueseverityWarning -> "warning"
    IssueseverityInformation -> "information"
  }
}

pub fn issueseverity_parse_code(code: String) -> Result(Issueseverity, Nil) {
  case code {
    "fatal" -> Ok(IssueseverityFatal)
    "error" -> Ok(IssueseverityError)
    "warning" -> Ok(IssueseverityWarning)
    "information" -> Ok(IssueseverityInformation)
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
    _ ->
      decode.failure(
        IssueseverityFatal,
        "code from valueset Issueseverity ["
          <> {
          issueseverity |> list.map(issueseverity_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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
  IssuetypeTransient
  IssuetypeLockerror
  IssuetypeNostore
  IssuetypeException
  IssuetypeTimeout
  IssuetypeIncomplete
  IssuetypeThrottled
  IssuetypeInformational
}

pub const issuetype: List(Issuetype) = [
  IssuetypeInvalid,
  IssuetypeStructure,
  IssuetypeRequired,
  IssuetypeValue,
  IssuetypeInvariant,
  IssuetypeSecurity,
  IssuetypeLogin,
  IssuetypeUnknown,
  IssuetypeExpired,
  IssuetypeForbidden,
  IssuetypeSuppressed,
  IssuetypeProcessing,
  IssuetypeNotsupported,
  IssuetypeDuplicate,
  IssuetypeMultiplematches,
  IssuetypeNotfound,
  IssuetypeDeleted,
  IssuetypeToolong,
  IssuetypeCodeinvalid,
  IssuetypeExtension,
  IssuetypeToocostly,
  IssuetypeBusinessrule,
  IssuetypeConflict,
  IssuetypeTransient,
  IssuetypeLockerror,
  IssuetypeNostore,
  IssuetypeException,
  IssuetypeTimeout,
  IssuetypeIncomplete,
  IssuetypeThrottled,
  IssuetypeInformational,
]

pub fn issuetype_to_json(issuetype: Issuetype) -> Json {
  json.string(issuetype_to_code(issuetype))
}

pub fn issuetype_to_code(issuetype: Issuetype) -> String {
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
    IssuetypeTransient -> "transient"
    IssuetypeLockerror -> "lock-error"
    IssuetypeNostore -> "no-store"
    IssuetypeException -> "exception"
    IssuetypeTimeout -> "timeout"
    IssuetypeIncomplete -> "incomplete"
    IssuetypeThrottled -> "throttled"
    IssuetypeInformational -> "informational"
  }
}

pub fn issuetype_parse_code(code: String) -> Result(Issuetype, Nil) {
  case code {
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
    "transient" -> Ok(IssuetypeTransient)
    "lock-error" -> Ok(IssuetypeLockerror)
    "no-store" -> Ok(IssuetypeNostore)
    "exception" -> Ok(IssuetypeException)
    "timeout" -> Ok(IssuetypeTimeout)
    "incomplete" -> Ok(IssuetypeIncomplete)
    "throttled" -> Ok(IssuetypeThrottled)
    "informational" -> Ok(IssuetypeInformational)
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
    "transient" -> decode.success(IssuetypeTransient)
    "lock-error" -> decode.success(IssuetypeLockerror)
    "no-store" -> decode.success(IssuetypeNostore)
    "exception" -> decode.success(IssuetypeException)
    "timeout" -> decode.success(IssuetypeTimeout)
    "incomplete" -> decode.success(IssuetypeIncomplete)
    "throttled" -> decode.success(IssuetypeThrottled)
    "informational" -> decode.success(IssuetypeInformational)
    _ ->
      decode.failure(
        IssuetypeInvalid,
        "code from valueset Issuetype ["
          <> { issuetype |> list.map(issuetype_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const nameuse: List(Nameuse) = [
  NameuseUsual,
  NameuseOfficial,
  NameuseTemp,
  NameuseNickname,
  NameuseAnonymous,
  NameuseOld,
  NameuseMaiden,
]

pub fn nameuse_to_json(nameuse: Nameuse) -> Json {
  json.string(nameuse_to_code(nameuse))
}

pub fn nameuse_to_code(nameuse: Nameuse) -> String {
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

pub fn nameuse_parse_code(code: String) -> Result(Nameuse, Nil) {
  case code {
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
    _ ->
      decode.failure(
        NameuseUsual,
        "code from valueset Nameuse ["
          <> { nameuse |> list.map(nameuse_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Narrativestatus {
  NarrativestatusGenerated
  NarrativestatusExtensions
  NarrativestatusAdditional
  NarrativestatusEmpty
}

pub const narrativestatus: List(Narrativestatus) = [
  NarrativestatusGenerated,
  NarrativestatusExtensions,
  NarrativestatusAdditional,
  NarrativestatusEmpty,
]

pub fn narrativestatus_to_json(narrativestatus: Narrativestatus) -> Json {
  json.string(narrativestatus_to_code(narrativestatus))
}

pub fn narrativestatus_to_code(narrativestatus: Narrativestatus) -> String {
  case narrativestatus {
    NarrativestatusGenerated -> "generated"
    NarrativestatusExtensions -> "extensions"
    NarrativestatusAdditional -> "additional"
    NarrativestatusEmpty -> "empty"
  }
}

pub fn narrativestatus_parse_code(
  code: String,
) -> Result(Narrativestatus, Nil) {
  case code {
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
    _ ->
      decode.failure(
        NarrativestatusGenerated,
        "code from valueset Narrativestatus ["
          <> {
          narrativestatus
          |> list.map(narrativestatus_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Operationparameteruse {
  OperationparameteruseIn
  OperationparameteruseOut
}

pub const operationparameteruse: List(Operationparameteruse) = [
  OperationparameteruseIn,
  OperationparameteruseOut,
]

pub fn operationparameteruse_to_json(
  operationparameteruse: Operationparameteruse,
) -> Json {
  json.string(operationparameteruse_to_code(operationparameteruse))
}

pub fn operationparameteruse_to_code(
  operationparameteruse: Operationparameteruse,
) -> String {
  case operationparameteruse {
    OperationparameteruseIn -> "in"
    OperationparameteruseOut -> "out"
  }
}

pub fn operationparameteruse_parse_code(
  code: String,
) -> Result(Operationparameteruse, Nil) {
  case code {
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
    _ ->
      decode.failure(
        OperationparameteruseIn,
        "code from valueset Operationparameteruse ["
          <> {
          operationparameteruse
          |> list.map(operationparameteruse_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Publicationstatus {
  PublicationstatusDraft
  PublicationstatusActive
  PublicationstatusRetired
  PublicationstatusUnknown
}

pub const publicationstatus: List(Publicationstatus) = [
  PublicationstatusDraft,
  PublicationstatusActive,
  PublicationstatusRetired,
  PublicationstatusUnknown,
]

pub fn publicationstatus_to_json(publicationstatus: Publicationstatus) -> Json {
  json.string(publicationstatus_to_code(publicationstatus))
}

pub fn publicationstatus_to_code(
  publicationstatus: Publicationstatus,
) -> String {
  case publicationstatus {
    PublicationstatusDraft -> "draft"
    PublicationstatusActive -> "active"
    PublicationstatusRetired -> "retired"
    PublicationstatusUnknown -> "unknown"
  }
}

pub fn publicationstatus_parse_code(
  code: String,
) -> Result(Publicationstatus, Nil) {
  case code {
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
    _ ->
      decode.failure(
        PublicationstatusDraft,
        "code from valueset Publicationstatus ["
          <> {
          publicationstatus
          |> list.map(publicationstatus_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Quantitycomparator {
  QuantitycomparatorLessthan
  QuantitycomparatorLessthanequal
  QuantitycomparatorGreaterthanequal
  QuantitycomparatorGreaterthan
}

pub const quantitycomparator: List(Quantitycomparator) = [
  QuantitycomparatorLessthan,
  QuantitycomparatorLessthanequal,
  QuantitycomparatorGreaterthanequal,
  QuantitycomparatorGreaterthan,
]

pub fn quantitycomparator_to_json(
  quantitycomparator: Quantitycomparator,
) -> Json {
  json.string(quantitycomparator_to_code(quantitycomparator))
}

pub fn quantitycomparator_to_code(
  quantitycomparator: Quantitycomparator,
) -> String {
  case quantitycomparator {
    QuantitycomparatorLessthan -> "<"
    QuantitycomparatorLessthanequal -> "<="
    QuantitycomparatorGreaterthanequal -> ">="
    QuantitycomparatorGreaterthan -> ">"
  }
}

pub fn quantitycomparator_parse_code(
  code: String,
) -> Result(Quantitycomparator, Nil) {
  case code {
    "<" -> Ok(QuantitycomparatorLessthan)
    "<=" -> Ok(QuantitycomparatorLessthanequal)
    ">=" -> Ok(QuantitycomparatorGreaterthanequal)
    ">" -> Ok(QuantitycomparatorGreaterthan)
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
    _ ->
      decode.failure(
        QuantitycomparatorLessthan,
        "code from valueset Quantitycomparator ["
          <> {
          quantitycomparator
          |> list.map(quantitycomparator_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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
}

pub const relatedartifacttype: List(Relatedartifacttype) = [
  RelatedartifacttypeDocumentation,
  RelatedartifacttypeJustification,
  RelatedartifacttypeCitation,
  RelatedartifacttypePredecessor,
  RelatedartifacttypeSuccessor,
  RelatedartifacttypeDerivedfrom,
  RelatedartifacttypeDependson,
  RelatedartifacttypeComposedof,
]

pub fn relatedartifacttype_to_json(
  relatedartifacttype: Relatedartifacttype,
) -> Json {
  json.string(relatedartifacttype_to_code(relatedartifacttype))
}

pub fn relatedartifacttype_to_code(
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
  }
}

pub fn relatedartifacttype_parse_code(
  code: String,
) -> Result(Relatedartifacttype, Nil) {
  case code {
    "documentation" -> Ok(RelatedartifacttypeDocumentation)
    "justification" -> Ok(RelatedartifacttypeJustification)
    "citation" -> Ok(RelatedartifacttypeCitation)
    "predecessor" -> Ok(RelatedartifacttypePredecessor)
    "successor" -> Ok(RelatedartifacttypeSuccessor)
    "derived-from" -> Ok(RelatedartifacttypeDerivedfrom)
    "depends-on" -> Ok(RelatedartifacttypeDependson)
    "composed-of" -> Ok(RelatedartifacttypeComposedof)
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
    _ ->
      decode.failure(
        RelatedartifacttypeDocumentation,
        "code from valueset Relatedartifacttype ["
          <> {
          relatedartifacttype
          |> list.map(relatedartifacttype_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Searchentrymode {
  SearchentrymodeMatch
  SearchentrymodeInclude
  SearchentrymodeOutcome
}

pub const searchentrymode: List(Searchentrymode) = [
  SearchentrymodeMatch,
  SearchentrymodeInclude,
  SearchentrymodeOutcome,
]

pub fn searchentrymode_to_json(searchentrymode: Searchentrymode) -> Json {
  json.string(searchentrymode_to_code(searchentrymode))
}

pub fn searchentrymode_to_code(searchentrymode: Searchentrymode) -> String {
  case searchentrymode {
    SearchentrymodeMatch -> "match"
    SearchentrymodeInclude -> "include"
    SearchentrymodeOutcome -> "outcome"
  }
}

pub fn searchentrymode_parse_code(
  code: String,
) -> Result(Searchentrymode, Nil) {
  case code {
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
    _ ->
      decode.failure(
        SearchentrymodeMatch,
        "code from valueset Searchentrymode ["
          <> {
          searchentrymode
          |> list.map(searchentrymode_to_code)
          |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type Sortdirection {
  SortdirectionAscending
  SortdirectionDescending
}

pub const sortdirection: List(Sortdirection) = [
  SortdirectionAscending,
  SortdirectionDescending,
]

pub fn sortdirection_to_json(sortdirection: Sortdirection) -> Json {
  json.string(sortdirection_to_code(sortdirection))
}

pub fn sortdirection_to_code(sortdirection: Sortdirection) -> String {
  case sortdirection {
    SortdirectionAscending -> "ascending"
    SortdirectionDescending -> "descending"
  }
}

pub fn sortdirection_parse_code(code: String) -> Result(Sortdirection, Nil) {
  case code {
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
    _ ->
      decode.failure(
        SortdirectionAscending,
        "code from valueset Sortdirection ["
          <> {
          sortdirection |> list.map(sortdirection_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const triggertype: List(Triggertype) = [
  TriggertypeNamedevent,
  TriggertypePeriodic,
  TriggertypeDatachanged,
  TriggertypeDataadded,
  TriggertypeDatamodified,
  TriggertypeDataremoved,
  TriggertypeDataaccessed,
  TriggertypeDataaccessended,
]

pub fn triggertype_to_json(triggertype: Triggertype) -> Json {
  json.string(triggertype_to_code(triggertype))
}

pub fn triggertype_to_code(triggertype: Triggertype) -> String {
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

pub fn triggertype_parse_code(code: String) -> Result(Triggertype, Nil) {
  case code {
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
    _ ->
      decode.failure(
        TriggertypeNamedevent,
        "code from valueset Triggertype ["
          <> {
          triggertype |> list.map(triggertype_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
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

pub const unitsoftime: List(Unitsoftime) = [
  UnitsoftimeS,
  UnitsoftimeMin,
  UnitsoftimeH,
  UnitsoftimeD,
  UnitsoftimeWk,
  UnitsoftimeMo,
  UnitsoftimeA,
]

pub fn unitsoftime_to_json(unitsoftime: Unitsoftime) -> Json {
  json.string(unitsoftime_to_code(unitsoftime))
}

pub fn unitsoftime_to_code(unitsoftime: Unitsoftime) -> String {
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

pub fn unitsoftime_parse_code(code: String) -> Result(Unitsoftime, Nil) {
  case code {
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
    _ ->
      decode.failure(
        UnitsoftimeS,
        "code from valueset Unitsoftime ["
          <> {
          unitsoftime |> list.map(unitsoftime_to_code) |> string.join(", ")
        }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}
