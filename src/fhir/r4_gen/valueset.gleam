////[https://hl7.org/fhir/r4](https://hl7.org/fhir/r4) valuesets

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/list
import gleam/string

pub type AddressType {
  AddressTypePostal
  AddressTypePhysical
  AddressTypeBoth
}

pub const address_type: List(AddressType) = [
  AddressTypePostal,
  AddressTypePhysical,
  AddressTypeBoth,
]

pub fn address_type_to_json(address_type: AddressType) -> Json {
  json.string(address_type_to_code(address_type))
}

pub fn address_type_to_code(address_type: AddressType) -> String {
  case address_type {
    AddressTypePostal -> "postal"
    AddressTypePhysical -> "physical"
    AddressTypeBoth -> "both"
  }
}

pub fn address_type_parse_code(code: String) -> Result(AddressType, Nil) {
  case code {
    "postal" -> Ok(AddressTypePostal)
    "physical" -> Ok(AddressTypePhysical)
    "both" -> Ok(AddressTypeBoth)
    _ -> Error(Nil)
  }
}

pub fn address_type_decoder() -> Decoder(AddressType) {
  use variant <- decode.then(decode.string)
  case variant {
    "postal" -> decode.success(AddressTypePostal)
    "physical" -> decode.success(AddressTypePhysical)
    "both" -> decode.success(AddressTypeBoth)
    _ ->
      decode.failure(
        AddressTypePostal,
        "code from valueset AddressType ["
          <> {
          address_type |> list.map(address_type_to_code) |> string.join(", ")
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

pub type AddressUse {
  AddressUseHome
  AddressUseWork
  AddressUseTemp
  AddressUseOld
  AddressUseBilling
}

pub const address_use: List(AddressUse) = [
  AddressUseHome,
  AddressUseWork,
  AddressUseTemp,
  AddressUseOld,
  AddressUseBilling,
]

pub fn address_use_to_json(address_use: AddressUse) -> Json {
  json.string(address_use_to_code(address_use))
}

pub fn address_use_to_code(address_use: AddressUse) -> String {
  case address_use {
    AddressUseHome -> "home"
    AddressUseWork -> "work"
    AddressUseTemp -> "temp"
    AddressUseOld -> "old"
    AddressUseBilling -> "billing"
  }
}

pub fn address_use_parse_code(code: String) -> Result(AddressUse, Nil) {
  case code {
    "home" -> Ok(AddressUseHome)
    "work" -> Ok(AddressUseWork)
    "temp" -> Ok(AddressUseTemp)
    "old" -> Ok(AddressUseOld)
    "billing" -> Ok(AddressUseBilling)
    _ -> Error(Nil)
  }
}

pub fn address_use_decoder() -> Decoder(AddressUse) {
  use variant <- decode.then(decode.string)
  case variant {
    "home" -> decode.success(AddressUseHome)
    "work" -> decode.success(AddressUseWork)
    "temp" -> decode.success(AddressUseTemp)
    "old" -> decode.success(AddressUseOld)
    "billing" -> decode.success(AddressUseBilling)
    _ ->
      decode.failure(
        AddressUseHome,
        "code from valueset AddressUse ["
          <> {
          address_use |> list.map(address_use_to_code) |> string.join(", ")
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

pub type AllTypes {
  AllTypesAddress
  AllTypesAge
  AllTypesAnnotation
  AllTypesAttachment
  AllTypesBackboneelement
  AllTypesCodeableconcept
  AllTypesCoding
  AllTypesContactdetail
  AllTypesContactpoint
  AllTypesContributor
  AllTypesCount
  AllTypesDatarequirement
  AllTypesDistance
  AllTypesDosage
  AllTypesDuration
  AllTypesElement
  AllTypesElementdefinition
  AllTypesExpression
  AllTypesExtension
  AllTypesHumanname
  AllTypesIdentifier
  AllTypesMarketingstatus
  AllTypesMeta
  AllTypesMoney
  AllTypesMoneyquantity
  AllTypesNarrative
  AllTypesParameterdefinition
  AllTypesPeriod
  AllTypesPopulation
  AllTypesProdcharacteristic
  AllTypesProductshelflife
  AllTypesQuantity
  AllTypesRange
  AllTypesRatio
  AllTypesReference
  AllTypesRelatedartifact
  AllTypesSampleddata
  AllTypesSignature
  AllTypesSimplequantity
  AllTypesSubstanceamount
  AllTypesTiming
  AllTypesTriggerdefinition
  AllTypesUsagecontext
  AllTypesBase64binary
  AllTypesBoolean
  AllTypesCanonical
  AllTypesCode
  AllTypesDate
  AllTypesDatetime
  AllTypesDecimal
  AllTypesId
  AllTypesInstant
  AllTypesInteger
  AllTypesMarkdown
  AllTypesOid
  AllTypesPositiveint
  AllTypesString
  AllTypesTime
  AllTypesUnsignedint
  AllTypesUri
  AllTypesUrl
  AllTypesUuid
  AllTypesXhtml
  AllTypesAccount
  AllTypesActivitydefinition
  AllTypesAdverseevent
  AllTypesAllergyintolerance
  AllTypesAppointment
  AllTypesAppointmentresponse
  AllTypesAuditevent
  AllTypesBasic
  AllTypesBinary
  AllTypesBiologicallyderivedproduct
  AllTypesBodystructure
  AllTypesBundle
  AllTypesCapabilitystatement
  AllTypesCareplan
  AllTypesCareteam
  AllTypesCatalogentry
  AllTypesChargeitem
  AllTypesChargeitemdefinition
  AllTypesClaim
  AllTypesClaimresponse
  AllTypesClinicalimpression
  AllTypesCodesystem
  AllTypesCommunication
  AllTypesCommunicationrequest
  AllTypesCompartmentdefinition
  AllTypesComposition
  AllTypesConceptmap
  AllTypesCondition
  AllTypesConsent
  AllTypesContract
  AllTypesCoverage
  AllTypesCoverageeligibilityrequest
  AllTypesCoverageeligibilityresponse
  AllTypesDetectedissue
  AllTypesDevice
  AllTypesDevicedefinition
  AllTypesDevicemetric
  AllTypesDevicerequest
  AllTypesDeviceusestatement
  AllTypesDiagnosticreport
  AllTypesDocumentmanifest
  AllTypesDocumentreference
  AllTypesDomainresource
  AllTypesEffectevidencesynthesis
  AllTypesEncounter
  AllTypesEndpoint
  AllTypesEnrollmentrequest
  AllTypesEnrollmentresponse
  AllTypesEpisodeofcare
  AllTypesEventdefinition
  AllTypesEvidence
  AllTypesEvidencevariable
  AllTypesExamplescenario
  AllTypesExplanationofbenefit
  AllTypesFamilymemberhistory
  AllTypesFlag
  AllTypesGoal
  AllTypesGraphdefinition
  AllTypesGroup
  AllTypesGuidanceresponse
  AllTypesHealthcareservice
  AllTypesImagingstudy
  AllTypesImmunization
  AllTypesImmunizationevaluation
  AllTypesImmunizationrecommendation
  AllTypesImplementationguide
  AllTypesInsuranceplan
  AllTypesInvoice
  AllTypesLibrary
  AllTypesLinkage
  AllTypesList
  AllTypesLocation
  AllTypesMeasure
  AllTypesMeasurereport
  AllTypesMedia
  AllTypesMedication
  AllTypesMedicationadministration
  AllTypesMedicationdispense
  AllTypesMedicationknowledge
  AllTypesMedicationrequest
  AllTypesMedicationstatement
  AllTypesMedicinalproduct
  AllTypesMedicinalproductauthorization
  AllTypesMedicinalproductcontraindication
  AllTypesMedicinalproductindication
  AllTypesMedicinalproductingredient
  AllTypesMedicinalproductinteraction
  AllTypesMedicinalproductmanufactured
  AllTypesMedicinalproductpackaged
  AllTypesMedicinalproductpharmaceutical
  AllTypesMedicinalproductundesirableeffect
  AllTypesMessagedefinition
  AllTypesMessageheader
  AllTypesMolecularsequence
  AllTypesNamingsystem
  AllTypesNutritionorder
  AllTypesObservation
  AllTypesObservationdefinition
  AllTypesOperationdefinition
  AllTypesOperationoutcome
  AllTypesOrganization
  AllTypesOrganizationaffiliation
  AllTypesParameters
  AllTypesPatient
  AllTypesPaymentnotice
  AllTypesPaymentreconciliation
  AllTypesPerson
  AllTypesPlandefinition
  AllTypesPractitioner
  AllTypesPractitionerrole
  AllTypesProcedure
  AllTypesProvenance
  AllTypesQuestionnaire
  AllTypesQuestionnaireresponse
  AllTypesRelatedperson
  AllTypesRequestgroup
  AllTypesResearchdefinition
  AllTypesResearchelementdefinition
  AllTypesResearchstudy
  AllTypesResearchsubject
  AllTypesResource
  AllTypesRiskassessment
  AllTypesRiskevidencesynthesis
  AllTypesSchedule
  AllTypesSearchparameter
  AllTypesServicerequest
  AllTypesSlot
  AllTypesSpecimen
  AllTypesSpecimendefinition
  AllTypesStructuredefinition
  AllTypesStructuremap
  AllTypesSubscription
  AllTypesSubstance
  AllTypesSubstancenucleicacid
  AllTypesSubstancepolymer
  AllTypesSubstanceprotein
  AllTypesSubstancereferenceinformation
  AllTypesSubstancesourcematerial
  AllTypesSubstancespecification
  AllTypesSupplydelivery
  AllTypesSupplyrequest
  AllTypesTask
  AllTypesTerminologycapabilities
  AllTypesTestreport
  AllTypesTestscript
  AllTypesValueset
  AllTypesVerificationresult
  AllTypesVisionprescription
  AllTypesType
  AllTypesAny
}

pub const all_types: List(AllTypes) = [
  AllTypesAddress,
  AllTypesAge,
  AllTypesAnnotation,
  AllTypesAttachment,
  AllTypesBackboneelement,
  AllTypesCodeableconcept,
  AllTypesCoding,
  AllTypesContactdetail,
  AllTypesContactpoint,
  AllTypesContributor,
  AllTypesCount,
  AllTypesDatarequirement,
  AllTypesDistance,
  AllTypesDosage,
  AllTypesDuration,
  AllTypesElement,
  AllTypesElementdefinition,
  AllTypesExpression,
  AllTypesExtension,
  AllTypesHumanname,
  AllTypesIdentifier,
  AllTypesMarketingstatus,
  AllTypesMeta,
  AllTypesMoney,
  AllTypesMoneyquantity,
  AllTypesNarrative,
  AllTypesParameterdefinition,
  AllTypesPeriod,
  AllTypesPopulation,
  AllTypesProdcharacteristic,
  AllTypesProductshelflife,
  AllTypesQuantity,
  AllTypesRange,
  AllTypesRatio,
  AllTypesReference,
  AllTypesRelatedartifact,
  AllTypesSampleddata,
  AllTypesSignature,
  AllTypesSimplequantity,
  AllTypesSubstanceamount,
  AllTypesTiming,
  AllTypesTriggerdefinition,
  AllTypesUsagecontext,
  AllTypesBase64binary,
  AllTypesBoolean,
  AllTypesCanonical,
  AllTypesCode,
  AllTypesDate,
  AllTypesDatetime,
  AllTypesDecimal,
  AllTypesId,
  AllTypesInstant,
  AllTypesInteger,
  AllTypesMarkdown,
  AllTypesOid,
  AllTypesPositiveint,
  AllTypesString,
  AllTypesTime,
  AllTypesUnsignedint,
  AllTypesUri,
  AllTypesUrl,
  AllTypesUuid,
  AllTypesXhtml,
  AllTypesAccount,
  AllTypesActivitydefinition,
  AllTypesAdverseevent,
  AllTypesAllergyintolerance,
  AllTypesAppointment,
  AllTypesAppointmentresponse,
  AllTypesAuditevent,
  AllTypesBasic,
  AllTypesBinary,
  AllTypesBiologicallyderivedproduct,
  AllTypesBodystructure,
  AllTypesBundle,
  AllTypesCapabilitystatement,
  AllTypesCareplan,
  AllTypesCareteam,
  AllTypesCatalogentry,
  AllTypesChargeitem,
  AllTypesChargeitemdefinition,
  AllTypesClaim,
  AllTypesClaimresponse,
  AllTypesClinicalimpression,
  AllTypesCodesystem,
  AllTypesCommunication,
  AllTypesCommunicationrequest,
  AllTypesCompartmentdefinition,
  AllTypesComposition,
  AllTypesConceptmap,
  AllTypesCondition,
  AllTypesConsent,
  AllTypesContract,
  AllTypesCoverage,
  AllTypesCoverageeligibilityrequest,
  AllTypesCoverageeligibilityresponse,
  AllTypesDetectedissue,
  AllTypesDevice,
  AllTypesDevicedefinition,
  AllTypesDevicemetric,
  AllTypesDevicerequest,
  AllTypesDeviceusestatement,
  AllTypesDiagnosticreport,
  AllTypesDocumentmanifest,
  AllTypesDocumentreference,
  AllTypesDomainresource,
  AllTypesEffectevidencesynthesis,
  AllTypesEncounter,
  AllTypesEndpoint,
  AllTypesEnrollmentrequest,
  AllTypesEnrollmentresponse,
  AllTypesEpisodeofcare,
  AllTypesEventdefinition,
  AllTypesEvidence,
  AllTypesEvidencevariable,
  AllTypesExamplescenario,
  AllTypesExplanationofbenefit,
  AllTypesFamilymemberhistory,
  AllTypesFlag,
  AllTypesGoal,
  AllTypesGraphdefinition,
  AllTypesGroup,
  AllTypesGuidanceresponse,
  AllTypesHealthcareservice,
  AllTypesImagingstudy,
  AllTypesImmunization,
  AllTypesImmunizationevaluation,
  AllTypesImmunizationrecommendation,
  AllTypesImplementationguide,
  AllTypesInsuranceplan,
  AllTypesInvoice,
  AllTypesLibrary,
  AllTypesLinkage,
  AllTypesList,
  AllTypesLocation,
  AllTypesMeasure,
  AllTypesMeasurereport,
  AllTypesMedia,
  AllTypesMedication,
  AllTypesMedicationadministration,
  AllTypesMedicationdispense,
  AllTypesMedicationknowledge,
  AllTypesMedicationrequest,
  AllTypesMedicationstatement,
  AllTypesMedicinalproduct,
  AllTypesMedicinalproductauthorization,
  AllTypesMedicinalproductcontraindication,
  AllTypesMedicinalproductindication,
  AllTypesMedicinalproductingredient,
  AllTypesMedicinalproductinteraction,
  AllTypesMedicinalproductmanufactured,
  AllTypesMedicinalproductpackaged,
  AllTypesMedicinalproductpharmaceutical,
  AllTypesMedicinalproductundesirableeffect,
  AllTypesMessagedefinition,
  AllTypesMessageheader,
  AllTypesMolecularsequence,
  AllTypesNamingsystem,
  AllTypesNutritionorder,
  AllTypesObservation,
  AllTypesObservationdefinition,
  AllTypesOperationdefinition,
  AllTypesOperationoutcome,
  AllTypesOrganization,
  AllTypesOrganizationaffiliation,
  AllTypesParameters,
  AllTypesPatient,
  AllTypesPaymentnotice,
  AllTypesPaymentreconciliation,
  AllTypesPerson,
  AllTypesPlandefinition,
  AllTypesPractitioner,
  AllTypesPractitionerrole,
  AllTypesProcedure,
  AllTypesProvenance,
  AllTypesQuestionnaire,
  AllTypesQuestionnaireresponse,
  AllTypesRelatedperson,
  AllTypesRequestgroup,
  AllTypesResearchdefinition,
  AllTypesResearchelementdefinition,
  AllTypesResearchstudy,
  AllTypesResearchsubject,
  AllTypesResource,
  AllTypesRiskassessment,
  AllTypesRiskevidencesynthesis,
  AllTypesSchedule,
  AllTypesSearchparameter,
  AllTypesServicerequest,
  AllTypesSlot,
  AllTypesSpecimen,
  AllTypesSpecimendefinition,
  AllTypesStructuredefinition,
  AllTypesStructuremap,
  AllTypesSubscription,
  AllTypesSubstance,
  AllTypesSubstancenucleicacid,
  AllTypesSubstancepolymer,
  AllTypesSubstanceprotein,
  AllTypesSubstancereferenceinformation,
  AllTypesSubstancesourcematerial,
  AllTypesSubstancespecification,
  AllTypesSupplydelivery,
  AllTypesSupplyrequest,
  AllTypesTask,
  AllTypesTerminologycapabilities,
  AllTypesTestreport,
  AllTypesTestscript,
  AllTypesValueset,
  AllTypesVerificationresult,
  AllTypesVisionprescription,
  AllTypesType,
  AllTypesAny,
]

pub fn all_types_to_json(all_types: AllTypes) -> Json {
  json.string(all_types_to_code(all_types))
}

pub fn all_types_to_code(all_types: AllTypes) -> String {
  case all_types {
    AllTypesAddress -> "Address"
    AllTypesAge -> "Age"
    AllTypesAnnotation -> "Annotation"
    AllTypesAttachment -> "Attachment"
    AllTypesBackboneelement -> "BackboneElement"
    AllTypesCodeableconcept -> "CodeableConcept"
    AllTypesCoding -> "Coding"
    AllTypesContactdetail -> "ContactDetail"
    AllTypesContactpoint -> "ContactPoint"
    AllTypesContributor -> "Contributor"
    AllTypesCount -> "Count"
    AllTypesDatarequirement -> "DataRequirement"
    AllTypesDistance -> "Distance"
    AllTypesDosage -> "Dosage"
    AllTypesDuration -> "Duration"
    AllTypesElement -> "Element"
    AllTypesElementdefinition -> "ElementDefinition"
    AllTypesExpression -> "Expression"
    AllTypesExtension -> "Extension"
    AllTypesHumanname -> "HumanName"
    AllTypesIdentifier -> "Identifier"
    AllTypesMarketingstatus -> "MarketingStatus"
    AllTypesMeta -> "Meta"
    AllTypesMoney -> "Money"
    AllTypesMoneyquantity -> "MoneyQuantity"
    AllTypesNarrative -> "Narrative"
    AllTypesParameterdefinition -> "ParameterDefinition"
    AllTypesPeriod -> "Period"
    AllTypesPopulation -> "Population"
    AllTypesProdcharacteristic -> "ProdCharacteristic"
    AllTypesProductshelflife -> "ProductShelfLife"
    AllTypesQuantity -> "Quantity"
    AllTypesRange -> "Range"
    AllTypesRatio -> "Ratio"
    AllTypesReference -> "Reference"
    AllTypesRelatedartifact -> "RelatedArtifact"
    AllTypesSampleddata -> "SampledData"
    AllTypesSignature -> "Signature"
    AllTypesSimplequantity -> "SimpleQuantity"
    AllTypesSubstanceamount -> "SubstanceAmount"
    AllTypesTiming -> "Timing"
    AllTypesTriggerdefinition -> "TriggerDefinition"
    AllTypesUsagecontext -> "UsageContext"
    AllTypesBase64binary -> "base64Binary"
    AllTypesBoolean -> "boolean"
    AllTypesCanonical -> "canonical"
    AllTypesCode -> "code"
    AllTypesDate -> "date"
    AllTypesDatetime -> "dateTime"
    AllTypesDecimal -> "decimal"
    AllTypesId -> "id"
    AllTypesInstant -> "instant"
    AllTypesInteger -> "integer"
    AllTypesMarkdown -> "markdown"
    AllTypesOid -> "oid"
    AllTypesPositiveint -> "positiveInt"
    AllTypesString -> "string"
    AllTypesTime -> "time"
    AllTypesUnsignedint -> "unsignedInt"
    AllTypesUri -> "uri"
    AllTypesUrl -> "url"
    AllTypesUuid -> "uuid"
    AllTypesXhtml -> "xhtml"
    AllTypesAccount -> "Account"
    AllTypesActivitydefinition -> "ActivityDefinition"
    AllTypesAdverseevent -> "AdverseEvent"
    AllTypesAllergyintolerance -> "AllergyIntolerance"
    AllTypesAppointment -> "Appointment"
    AllTypesAppointmentresponse -> "AppointmentResponse"
    AllTypesAuditevent -> "AuditEvent"
    AllTypesBasic -> "Basic"
    AllTypesBinary -> "Binary"
    AllTypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    AllTypesBodystructure -> "BodyStructure"
    AllTypesBundle -> "Bundle"
    AllTypesCapabilitystatement -> "CapabilityStatement"
    AllTypesCareplan -> "CarePlan"
    AllTypesCareteam -> "CareTeam"
    AllTypesCatalogentry -> "CatalogEntry"
    AllTypesChargeitem -> "ChargeItem"
    AllTypesChargeitemdefinition -> "ChargeItemDefinition"
    AllTypesClaim -> "Claim"
    AllTypesClaimresponse -> "ClaimResponse"
    AllTypesClinicalimpression -> "ClinicalImpression"
    AllTypesCodesystem -> "CodeSystem"
    AllTypesCommunication -> "Communication"
    AllTypesCommunicationrequest -> "CommunicationRequest"
    AllTypesCompartmentdefinition -> "CompartmentDefinition"
    AllTypesComposition -> "Composition"
    AllTypesConceptmap -> "ConceptMap"
    AllTypesCondition -> "Condition"
    AllTypesConsent -> "Consent"
    AllTypesContract -> "Contract"
    AllTypesCoverage -> "Coverage"
    AllTypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    AllTypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    AllTypesDetectedissue -> "DetectedIssue"
    AllTypesDevice -> "Device"
    AllTypesDevicedefinition -> "DeviceDefinition"
    AllTypesDevicemetric -> "DeviceMetric"
    AllTypesDevicerequest -> "DeviceRequest"
    AllTypesDeviceusestatement -> "DeviceUseStatement"
    AllTypesDiagnosticreport -> "DiagnosticReport"
    AllTypesDocumentmanifest -> "DocumentManifest"
    AllTypesDocumentreference -> "DocumentReference"
    AllTypesDomainresource -> "DomainResource"
    AllTypesEffectevidencesynthesis -> "EffectEvidenceSynthesis"
    AllTypesEncounter -> "Encounter"
    AllTypesEndpoint -> "Endpoint"
    AllTypesEnrollmentrequest -> "EnrollmentRequest"
    AllTypesEnrollmentresponse -> "EnrollmentResponse"
    AllTypesEpisodeofcare -> "EpisodeOfCare"
    AllTypesEventdefinition -> "EventDefinition"
    AllTypesEvidence -> "Evidence"
    AllTypesEvidencevariable -> "EvidenceVariable"
    AllTypesExamplescenario -> "ExampleScenario"
    AllTypesExplanationofbenefit -> "ExplanationOfBenefit"
    AllTypesFamilymemberhistory -> "FamilyMemberHistory"
    AllTypesFlag -> "Flag"
    AllTypesGoal -> "Goal"
    AllTypesGraphdefinition -> "GraphDefinition"
    AllTypesGroup -> "Group"
    AllTypesGuidanceresponse -> "GuidanceResponse"
    AllTypesHealthcareservice -> "HealthcareService"
    AllTypesImagingstudy -> "ImagingStudy"
    AllTypesImmunization -> "Immunization"
    AllTypesImmunizationevaluation -> "ImmunizationEvaluation"
    AllTypesImmunizationrecommendation -> "ImmunizationRecommendation"
    AllTypesImplementationguide -> "ImplementationGuide"
    AllTypesInsuranceplan -> "InsurancePlan"
    AllTypesInvoice -> "Invoice"
    AllTypesLibrary -> "Library"
    AllTypesLinkage -> "Linkage"
    AllTypesList -> "List"
    AllTypesLocation -> "Location"
    AllTypesMeasure -> "Measure"
    AllTypesMeasurereport -> "MeasureReport"
    AllTypesMedia -> "Media"
    AllTypesMedication -> "Medication"
    AllTypesMedicationadministration -> "MedicationAdministration"
    AllTypesMedicationdispense -> "MedicationDispense"
    AllTypesMedicationknowledge -> "MedicationKnowledge"
    AllTypesMedicationrequest -> "MedicationRequest"
    AllTypesMedicationstatement -> "MedicationStatement"
    AllTypesMedicinalproduct -> "MedicinalProduct"
    AllTypesMedicinalproductauthorization -> "MedicinalProductAuthorization"
    AllTypesMedicinalproductcontraindication ->
      "MedicinalProductContraindication"
    AllTypesMedicinalproductindication -> "MedicinalProductIndication"
    AllTypesMedicinalproductingredient -> "MedicinalProductIngredient"
    AllTypesMedicinalproductinteraction -> "MedicinalProductInteraction"
    AllTypesMedicinalproductmanufactured -> "MedicinalProductManufactured"
    AllTypesMedicinalproductpackaged -> "MedicinalProductPackaged"
    AllTypesMedicinalproductpharmaceutical -> "MedicinalProductPharmaceutical"
    AllTypesMedicinalproductundesirableeffect ->
      "MedicinalProductUndesirableEffect"
    AllTypesMessagedefinition -> "MessageDefinition"
    AllTypesMessageheader -> "MessageHeader"
    AllTypesMolecularsequence -> "MolecularSequence"
    AllTypesNamingsystem -> "NamingSystem"
    AllTypesNutritionorder -> "NutritionOrder"
    AllTypesObservation -> "Observation"
    AllTypesObservationdefinition -> "ObservationDefinition"
    AllTypesOperationdefinition -> "OperationDefinition"
    AllTypesOperationoutcome -> "OperationOutcome"
    AllTypesOrganization -> "Organization"
    AllTypesOrganizationaffiliation -> "OrganizationAffiliation"
    AllTypesParameters -> "Parameters"
    AllTypesPatient -> "Patient"
    AllTypesPaymentnotice -> "PaymentNotice"
    AllTypesPaymentreconciliation -> "PaymentReconciliation"
    AllTypesPerson -> "Person"
    AllTypesPlandefinition -> "PlanDefinition"
    AllTypesPractitioner -> "Practitioner"
    AllTypesPractitionerrole -> "PractitionerRole"
    AllTypesProcedure -> "Procedure"
    AllTypesProvenance -> "Provenance"
    AllTypesQuestionnaire -> "Questionnaire"
    AllTypesQuestionnaireresponse -> "QuestionnaireResponse"
    AllTypesRelatedperson -> "RelatedPerson"
    AllTypesRequestgroup -> "RequestGroup"
    AllTypesResearchdefinition -> "ResearchDefinition"
    AllTypesResearchelementdefinition -> "ResearchElementDefinition"
    AllTypesResearchstudy -> "ResearchStudy"
    AllTypesResearchsubject -> "ResearchSubject"
    AllTypesResource -> "Resource"
    AllTypesRiskassessment -> "RiskAssessment"
    AllTypesRiskevidencesynthesis -> "RiskEvidenceSynthesis"
    AllTypesSchedule -> "Schedule"
    AllTypesSearchparameter -> "SearchParameter"
    AllTypesServicerequest -> "ServiceRequest"
    AllTypesSlot -> "Slot"
    AllTypesSpecimen -> "Specimen"
    AllTypesSpecimendefinition -> "SpecimenDefinition"
    AllTypesStructuredefinition -> "StructureDefinition"
    AllTypesStructuremap -> "StructureMap"
    AllTypesSubscription -> "Subscription"
    AllTypesSubstance -> "Substance"
    AllTypesSubstancenucleicacid -> "SubstanceNucleicAcid"
    AllTypesSubstancepolymer -> "SubstancePolymer"
    AllTypesSubstanceprotein -> "SubstanceProtein"
    AllTypesSubstancereferenceinformation -> "SubstanceReferenceInformation"
    AllTypesSubstancesourcematerial -> "SubstanceSourceMaterial"
    AllTypesSubstancespecification -> "SubstanceSpecification"
    AllTypesSupplydelivery -> "SupplyDelivery"
    AllTypesSupplyrequest -> "SupplyRequest"
    AllTypesTask -> "Task"
    AllTypesTerminologycapabilities -> "TerminologyCapabilities"
    AllTypesTestreport -> "TestReport"
    AllTypesTestscript -> "TestScript"
    AllTypesValueset -> "ValueSet"
    AllTypesVerificationresult -> "VerificationResult"
    AllTypesVisionprescription -> "VisionPrescription"
    AllTypesType -> "Type"
    AllTypesAny -> "Any"
  }
}

pub fn all_types_parse_code(code: String) -> Result(AllTypes, Nil) {
  case code {
    "Address" -> Ok(AllTypesAddress)
    "Age" -> Ok(AllTypesAge)
    "Annotation" -> Ok(AllTypesAnnotation)
    "Attachment" -> Ok(AllTypesAttachment)
    "BackboneElement" -> Ok(AllTypesBackboneelement)
    "CodeableConcept" -> Ok(AllTypesCodeableconcept)
    "Coding" -> Ok(AllTypesCoding)
    "ContactDetail" -> Ok(AllTypesContactdetail)
    "ContactPoint" -> Ok(AllTypesContactpoint)
    "Contributor" -> Ok(AllTypesContributor)
    "Count" -> Ok(AllTypesCount)
    "DataRequirement" -> Ok(AllTypesDatarequirement)
    "Distance" -> Ok(AllTypesDistance)
    "Dosage" -> Ok(AllTypesDosage)
    "Duration" -> Ok(AllTypesDuration)
    "Element" -> Ok(AllTypesElement)
    "ElementDefinition" -> Ok(AllTypesElementdefinition)
    "Expression" -> Ok(AllTypesExpression)
    "Extension" -> Ok(AllTypesExtension)
    "HumanName" -> Ok(AllTypesHumanname)
    "Identifier" -> Ok(AllTypesIdentifier)
    "MarketingStatus" -> Ok(AllTypesMarketingstatus)
    "Meta" -> Ok(AllTypesMeta)
    "Money" -> Ok(AllTypesMoney)
    "MoneyQuantity" -> Ok(AllTypesMoneyquantity)
    "Narrative" -> Ok(AllTypesNarrative)
    "ParameterDefinition" -> Ok(AllTypesParameterdefinition)
    "Period" -> Ok(AllTypesPeriod)
    "Population" -> Ok(AllTypesPopulation)
    "ProdCharacteristic" -> Ok(AllTypesProdcharacteristic)
    "ProductShelfLife" -> Ok(AllTypesProductshelflife)
    "Quantity" -> Ok(AllTypesQuantity)
    "Range" -> Ok(AllTypesRange)
    "Ratio" -> Ok(AllTypesRatio)
    "Reference" -> Ok(AllTypesReference)
    "RelatedArtifact" -> Ok(AllTypesRelatedartifact)
    "SampledData" -> Ok(AllTypesSampleddata)
    "Signature" -> Ok(AllTypesSignature)
    "SimpleQuantity" -> Ok(AllTypesSimplequantity)
    "SubstanceAmount" -> Ok(AllTypesSubstanceamount)
    "Timing" -> Ok(AllTypesTiming)
    "TriggerDefinition" -> Ok(AllTypesTriggerdefinition)
    "UsageContext" -> Ok(AllTypesUsagecontext)
    "base64Binary" -> Ok(AllTypesBase64binary)
    "boolean" -> Ok(AllTypesBoolean)
    "canonical" -> Ok(AllTypesCanonical)
    "code" -> Ok(AllTypesCode)
    "date" -> Ok(AllTypesDate)
    "dateTime" -> Ok(AllTypesDatetime)
    "decimal" -> Ok(AllTypesDecimal)
    "id" -> Ok(AllTypesId)
    "instant" -> Ok(AllTypesInstant)
    "integer" -> Ok(AllTypesInteger)
    "markdown" -> Ok(AllTypesMarkdown)
    "oid" -> Ok(AllTypesOid)
    "positiveInt" -> Ok(AllTypesPositiveint)
    "string" -> Ok(AllTypesString)
    "time" -> Ok(AllTypesTime)
    "unsignedInt" -> Ok(AllTypesUnsignedint)
    "uri" -> Ok(AllTypesUri)
    "url" -> Ok(AllTypesUrl)
    "uuid" -> Ok(AllTypesUuid)
    "xhtml" -> Ok(AllTypesXhtml)
    "Account" -> Ok(AllTypesAccount)
    "ActivityDefinition" -> Ok(AllTypesActivitydefinition)
    "AdverseEvent" -> Ok(AllTypesAdverseevent)
    "AllergyIntolerance" -> Ok(AllTypesAllergyintolerance)
    "Appointment" -> Ok(AllTypesAppointment)
    "AppointmentResponse" -> Ok(AllTypesAppointmentresponse)
    "AuditEvent" -> Ok(AllTypesAuditevent)
    "Basic" -> Ok(AllTypesBasic)
    "Binary" -> Ok(AllTypesBinary)
    "BiologicallyDerivedProduct" -> Ok(AllTypesBiologicallyderivedproduct)
    "BodyStructure" -> Ok(AllTypesBodystructure)
    "Bundle" -> Ok(AllTypesBundle)
    "CapabilityStatement" -> Ok(AllTypesCapabilitystatement)
    "CarePlan" -> Ok(AllTypesCareplan)
    "CareTeam" -> Ok(AllTypesCareteam)
    "CatalogEntry" -> Ok(AllTypesCatalogentry)
    "ChargeItem" -> Ok(AllTypesChargeitem)
    "ChargeItemDefinition" -> Ok(AllTypesChargeitemdefinition)
    "Claim" -> Ok(AllTypesClaim)
    "ClaimResponse" -> Ok(AllTypesClaimresponse)
    "ClinicalImpression" -> Ok(AllTypesClinicalimpression)
    "CodeSystem" -> Ok(AllTypesCodesystem)
    "Communication" -> Ok(AllTypesCommunication)
    "CommunicationRequest" -> Ok(AllTypesCommunicationrequest)
    "CompartmentDefinition" -> Ok(AllTypesCompartmentdefinition)
    "Composition" -> Ok(AllTypesComposition)
    "ConceptMap" -> Ok(AllTypesConceptmap)
    "Condition" -> Ok(AllTypesCondition)
    "Consent" -> Ok(AllTypesConsent)
    "Contract" -> Ok(AllTypesContract)
    "Coverage" -> Ok(AllTypesCoverage)
    "CoverageEligibilityRequest" -> Ok(AllTypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" -> Ok(AllTypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(AllTypesDetectedissue)
    "Device" -> Ok(AllTypesDevice)
    "DeviceDefinition" -> Ok(AllTypesDevicedefinition)
    "DeviceMetric" -> Ok(AllTypesDevicemetric)
    "DeviceRequest" -> Ok(AllTypesDevicerequest)
    "DeviceUseStatement" -> Ok(AllTypesDeviceusestatement)
    "DiagnosticReport" -> Ok(AllTypesDiagnosticreport)
    "DocumentManifest" -> Ok(AllTypesDocumentmanifest)
    "DocumentReference" -> Ok(AllTypesDocumentreference)
    "DomainResource" -> Ok(AllTypesDomainresource)
    "EffectEvidenceSynthesis" -> Ok(AllTypesEffectevidencesynthesis)
    "Encounter" -> Ok(AllTypesEncounter)
    "Endpoint" -> Ok(AllTypesEndpoint)
    "EnrollmentRequest" -> Ok(AllTypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(AllTypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(AllTypesEpisodeofcare)
    "EventDefinition" -> Ok(AllTypesEventdefinition)
    "Evidence" -> Ok(AllTypesEvidence)
    "EvidenceVariable" -> Ok(AllTypesEvidencevariable)
    "ExampleScenario" -> Ok(AllTypesExamplescenario)
    "ExplanationOfBenefit" -> Ok(AllTypesExplanationofbenefit)
    "FamilyMemberHistory" -> Ok(AllTypesFamilymemberhistory)
    "Flag" -> Ok(AllTypesFlag)
    "Goal" -> Ok(AllTypesGoal)
    "GraphDefinition" -> Ok(AllTypesGraphdefinition)
    "Group" -> Ok(AllTypesGroup)
    "GuidanceResponse" -> Ok(AllTypesGuidanceresponse)
    "HealthcareService" -> Ok(AllTypesHealthcareservice)
    "ImagingStudy" -> Ok(AllTypesImagingstudy)
    "Immunization" -> Ok(AllTypesImmunization)
    "ImmunizationEvaluation" -> Ok(AllTypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(AllTypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(AllTypesImplementationguide)
    "InsurancePlan" -> Ok(AllTypesInsuranceplan)
    "Invoice" -> Ok(AllTypesInvoice)
    "Library" -> Ok(AllTypesLibrary)
    "Linkage" -> Ok(AllTypesLinkage)
    "List" -> Ok(AllTypesList)
    "Location" -> Ok(AllTypesLocation)
    "Measure" -> Ok(AllTypesMeasure)
    "MeasureReport" -> Ok(AllTypesMeasurereport)
    "Media" -> Ok(AllTypesMedia)
    "Medication" -> Ok(AllTypesMedication)
    "MedicationAdministration" -> Ok(AllTypesMedicationadministration)
    "MedicationDispense" -> Ok(AllTypesMedicationdispense)
    "MedicationKnowledge" -> Ok(AllTypesMedicationknowledge)
    "MedicationRequest" -> Ok(AllTypesMedicationrequest)
    "MedicationStatement" -> Ok(AllTypesMedicationstatement)
    "MedicinalProduct" -> Ok(AllTypesMedicinalproduct)
    "MedicinalProductAuthorization" -> Ok(AllTypesMedicinalproductauthorization)
    "MedicinalProductContraindication" ->
      Ok(AllTypesMedicinalproductcontraindication)
    "MedicinalProductIndication" -> Ok(AllTypesMedicinalproductindication)
    "MedicinalProductIngredient" -> Ok(AllTypesMedicinalproductingredient)
    "MedicinalProductInteraction" -> Ok(AllTypesMedicinalproductinteraction)
    "MedicinalProductManufactured" -> Ok(AllTypesMedicinalproductmanufactured)
    "MedicinalProductPackaged" -> Ok(AllTypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      Ok(AllTypesMedicinalproductpharmaceutical)
    "MedicinalProductUndesirableEffect" ->
      Ok(AllTypesMedicinalproductundesirableeffect)
    "MessageDefinition" -> Ok(AllTypesMessagedefinition)
    "MessageHeader" -> Ok(AllTypesMessageheader)
    "MolecularSequence" -> Ok(AllTypesMolecularsequence)
    "NamingSystem" -> Ok(AllTypesNamingsystem)
    "NutritionOrder" -> Ok(AllTypesNutritionorder)
    "Observation" -> Ok(AllTypesObservation)
    "ObservationDefinition" -> Ok(AllTypesObservationdefinition)
    "OperationDefinition" -> Ok(AllTypesOperationdefinition)
    "OperationOutcome" -> Ok(AllTypesOperationoutcome)
    "Organization" -> Ok(AllTypesOrganization)
    "OrganizationAffiliation" -> Ok(AllTypesOrganizationaffiliation)
    "Parameters" -> Ok(AllTypesParameters)
    "Patient" -> Ok(AllTypesPatient)
    "PaymentNotice" -> Ok(AllTypesPaymentnotice)
    "PaymentReconciliation" -> Ok(AllTypesPaymentreconciliation)
    "Person" -> Ok(AllTypesPerson)
    "PlanDefinition" -> Ok(AllTypesPlandefinition)
    "Practitioner" -> Ok(AllTypesPractitioner)
    "PractitionerRole" -> Ok(AllTypesPractitionerrole)
    "Procedure" -> Ok(AllTypesProcedure)
    "Provenance" -> Ok(AllTypesProvenance)
    "Questionnaire" -> Ok(AllTypesQuestionnaire)
    "QuestionnaireResponse" -> Ok(AllTypesQuestionnaireresponse)
    "RelatedPerson" -> Ok(AllTypesRelatedperson)
    "RequestGroup" -> Ok(AllTypesRequestgroup)
    "ResearchDefinition" -> Ok(AllTypesResearchdefinition)
    "ResearchElementDefinition" -> Ok(AllTypesResearchelementdefinition)
    "ResearchStudy" -> Ok(AllTypesResearchstudy)
    "ResearchSubject" -> Ok(AllTypesResearchsubject)
    "Resource" -> Ok(AllTypesResource)
    "RiskAssessment" -> Ok(AllTypesRiskassessment)
    "RiskEvidenceSynthesis" -> Ok(AllTypesRiskevidencesynthesis)
    "Schedule" -> Ok(AllTypesSchedule)
    "SearchParameter" -> Ok(AllTypesSearchparameter)
    "ServiceRequest" -> Ok(AllTypesServicerequest)
    "Slot" -> Ok(AllTypesSlot)
    "Specimen" -> Ok(AllTypesSpecimen)
    "SpecimenDefinition" -> Ok(AllTypesSpecimendefinition)
    "StructureDefinition" -> Ok(AllTypesStructuredefinition)
    "StructureMap" -> Ok(AllTypesStructuremap)
    "Subscription" -> Ok(AllTypesSubscription)
    "Substance" -> Ok(AllTypesSubstance)
    "SubstanceNucleicAcid" -> Ok(AllTypesSubstancenucleicacid)
    "SubstancePolymer" -> Ok(AllTypesSubstancepolymer)
    "SubstanceProtein" -> Ok(AllTypesSubstanceprotein)
    "SubstanceReferenceInformation" -> Ok(AllTypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> Ok(AllTypesSubstancesourcematerial)
    "SubstanceSpecification" -> Ok(AllTypesSubstancespecification)
    "SupplyDelivery" -> Ok(AllTypesSupplydelivery)
    "SupplyRequest" -> Ok(AllTypesSupplyrequest)
    "Task" -> Ok(AllTypesTask)
    "TerminologyCapabilities" -> Ok(AllTypesTerminologycapabilities)
    "TestReport" -> Ok(AllTypesTestreport)
    "TestScript" -> Ok(AllTypesTestscript)
    "ValueSet" -> Ok(AllTypesValueset)
    "VerificationResult" -> Ok(AllTypesVerificationresult)
    "VisionPrescription" -> Ok(AllTypesVisionprescription)
    "Type" -> Ok(AllTypesType)
    "Any" -> Ok(AllTypesAny)
    _ -> Error(Nil)
  }
}

pub fn all_types_decoder() -> Decoder(AllTypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Address" -> decode.success(AllTypesAddress)
    "Age" -> decode.success(AllTypesAge)
    "Annotation" -> decode.success(AllTypesAnnotation)
    "Attachment" -> decode.success(AllTypesAttachment)
    "BackboneElement" -> decode.success(AllTypesBackboneelement)
    "CodeableConcept" -> decode.success(AllTypesCodeableconcept)
    "Coding" -> decode.success(AllTypesCoding)
    "ContactDetail" -> decode.success(AllTypesContactdetail)
    "ContactPoint" -> decode.success(AllTypesContactpoint)
    "Contributor" -> decode.success(AllTypesContributor)
    "Count" -> decode.success(AllTypesCount)
    "DataRequirement" -> decode.success(AllTypesDatarequirement)
    "Distance" -> decode.success(AllTypesDistance)
    "Dosage" -> decode.success(AllTypesDosage)
    "Duration" -> decode.success(AllTypesDuration)
    "Element" -> decode.success(AllTypesElement)
    "ElementDefinition" -> decode.success(AllTypesElementdefinition)
    "Expression" -> decode.success(AllTypesExpression)
    "Extension" -> decode.success(AllTypesExtension)
    "HumanName" -> decode.success(AllTypesHumanname)
    "Identifier" -> decode.success(AllTypesIdentifier)
    "MarketingStatus" -> decode.success(AllTypesMarketingstatus)
    "Meta" -> decode.success(AllTypesMeta)
    "Money" -> decode.success(AllTypesMoney)
    "MoneyQuantity" -> decode.success(AllTypesMoneyquantity)
    "Narrative" -> decode.success(AllTypesNarrative)
    "ParameterDefinition" -> decode.success(AllTypesParameterdefinition)
    "Period" -> decode.success(AllTypesPeriod)
    "Population" -> decode.success(AllTypesPopulation)
    "ProdCharacteristic" -> decode.success(AllTypesProdcharacteristic)
    "ProductShelfLife" -> decode.success(AllTypesProductshelflife)
    "Quantity" -> decode.success(AllTypesQuantity)
    "Range" -> decode.success(AllTypesRange)
    "Ratio" -> decode.success(AllTypesRatio)
    "Reference" -> decode.success(AllTypesReference)
    "RelatedArtifact" -> decode.success(AllTypesRelatedartifact)
    "SampledData" -> decode.success(AllTypesSampleddata)
    "Signature" -> decode.success(AllTypesSignature)
    "SimpleQuantity" -> decode.success(AllTypesSimplequantity)
    "SubstanceAmount" -> decode.success(AllTypesSubstanceamount)
    "Timing" -> decode.success(AllTypesTiming)
    "TriggerDefinition" -> decode.success(AllTypesTriggerdefinition)
    "UsageContext" -> decode.success(AllTypesUsagecontext)
    "base64Binary" -> decode.success(AllTypesBase64binary)
    "boolean" -> decode.success(AllTypesBoolean)
    "canonical" -> decode.success(AllTypesCanonical)
    "code" -> decode.success(AllTypesCode)
    "date" -> decode.success(AllTypesDate)
    "dateTime" -> decode.success(AllTypesDatetime)
    "decimal" -> decode.success(AllTypesDecimal)
    "id" -> decode.success(AllTypesId)
    "instant" -> decode.success(AllTypesInstant)
    "integer" -> decode.success(AllTypesInteger)
    "markdown" -> decode.success(AllTypesMarkdown)
    "oid" -> decode.success(AllTypesOid)
    "positiveInt" -> decode.success(AllTypesPositiveint)
    "string" -> decode.success(AllTypesString)
    "time" -> decode.success(AllTypesTime)
    "unsignedInt" -> decode.success(AllTypesUnsignedint)
    "uri" -> decode.success(AllTypesUri)
    "url" -> decode.success(AllTypesUrl)
    "uuid" -> decode.success(AllTypesUuid)
    "xhtml" -> decode.success(AllTypesXhtml)
    "Account" -> decode.success(AllTypesAccount)
    "ActivityDefinition" -> decode.success(AllTypesActivitydefinition)
    "AdverseEvent" -> decode.success(AllTypesAdverseevent)
    "AllergyIntolerance" -> decode.success(AllTypesAllergyintolerance)
    "Appointment" -> decode.success(AllTypesAppointment)
    "AppointmentResponse" -> decode.success(AllTypesAppointmentresponse)
    "AuditEvent" -> decode.success(AllTypesAuditevent)
    "Basic" -> decode.success(AllTypesBasic)
    "Binary" -> decode.success(AllTypesBinary)
    "BiologicallyDerivedProduct" ->
      decode.success(AllTypesBiologicallyderivedproduct)
    "BodyStructure" -> decode.success(AllTypesBodystructure)
    "Bundle" -> decode.success(AllTypesBundle)
    "CapabilityStatement" -> decode.success(AllTypesCapabilitystatement)
    "CarePlan" -> decode.success(AllTypesCareplan)
    "CareTeam" -> decode.success(AllTypesCareteam)
    "CatalogEntry" -> decode.success(AllTypesCatalogentry)
    "ChargeItem" -> decode.success(AllTypesChargeitem)
    "ChargeItemDefinition" -> decode.success(AllTypesChargeitemdefinition)
    "Claim" -> decode.success(AllTypesClaim)
    "ClaimResponse" -> decode.success(AllTypesClaimresponse)
    "ClinicalImpression" -> decode.success(AllTypesClinicalimpression)
    "CodeSystem" -> decode.success(AllTypesCodesystem)
    "Communication" -> decode.success(AllTypesCommunication)
    "CommunicationRequest" -> decode.success(AllTypesCommunicationrequest)
    "CompartmentDefinition" -> decode.success(AllTypesCompartmentdefinition)
    "Composition" -> decode.success(AllTypesComposition)
    "ConceptMap" -> decode.success(AllTypesConceptmap)
    "Condition" -> decode.success(AllTypesCondition)
    "Consent" -> decode.success(AllTypesConsent)
    "Contract" -> decode.success(AllTypesContract)
    "Coverage" -> decode.success(AllTypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(AllTypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(AllTypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(AllTypesDetectedissue)
    "Device" -> decode.success(AllTypesDevice)
    "DeviceDefinition" -> decode.success(AllTypesDevicedefinition)
    "DeviceMetric" -> decode.success(AllTypesDevicemetric)
    "DeviceRequest" -> decode.success(AllTypesDevicerequest)
    "DeviceUseStatement" -> decode.success(AllTypesDeviceusestatement)
    "DiagnosticReport" -> decode.success(AllTypesDiagnosticreport)
    "DocumentManifest" -> decode.success(AllTypesDocumentmanifest)
    "DocumentReference" -> decode.success(AllTypesDocumentreference)
    "DomainResource" -> decode.success(AllTypesDomainresource)
    "EffectEvidenceSynthesis" -> decode.success(AllTypesEffectevidencesynthesis)
    "Encounter" -> decode.success(AllTypesEncounter)
    "Endpoint" -> decode.success(AllTypesEndpoint)
    "EnrollmentRequest" -> decode.success(AllTypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(AllTypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(AllTypesEpisodeofcare)
    "EventDefinition" -> decode.success(AllTypesEventdefinition)
    "Evidence" -> decode.success(AllTypesEvidence)
    "EvidenceVariable" -> decode.success(AllTypesEvidencevariable)
    "ExampleScenario" -> decode.success(AllTypesExamplescenario)
    "ExplanationOfBenefit" -> decode.success(AllTypesExplanationofbenefit)
    "FamilyMemberHistory" -> decode.success(AllTypesFamilymemberhistory)
    "Flag" -> decode.success(AllTypesFlag)
    "Goal" -> decode.success(AllTypesGoal)
    "GraphDefinition" -> decode.success(AllTypesGraphdefinition)
    "Group" -> decode.success(AllTypesGroup)
    "GuidanceResponse" -> decode.success(AllTypesGuidanceresponse)
    "HealthcareService" -> decode.success(AllTypesHealthcareservice)
    "ImagingStudy" -> decode.success(AllTypesImagingstudy)
    "Immunization" -> decode.success(AllTypesImmunization)
    "ImmunizationEvaluation" -> decode.success(AllTypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(AllTypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(AllTypesImplementationguide)
    "InsurancePlan" -> decode.success(AllTypesInsuranceplan)
    "Invoice" -> decode.success(AllTypesInvoice)
    "Library" -> decode.success(AllTypesLibrary)
    "Linkage" -> decode.success(AllTypesLinkage)
    "List" -> decode.success(AllTypesList)
    "Location" -> decode.success(AllTypesLocation)
    "Measure" -> decode.success(AllTypesMeasure)
    "MeasureReport" -> decode.success(AllTypesMeasurereport)
    "Media" -> decode.success(AllTypesMedia)
    "Medication" -> decode.success(AllTypesMedication)
    "MedicationAdministration" ->
      decode.success(AllTypesMedicationadministration)
    "MedicationDispense" -> decode.success(AllTypesMedicationdispense)
    "MedicationKnowledge" -> decode.success(AllTypesMedicationknowledge)
    "MedicationRequest" -> decode.success(AllTypesMedicationrequest)
    "MedicationStatement" -> decode.success(AllTypesMedicationstatement)
    "MedicinalProduct" -> decode.success(AllTypesMedicinalproduct)
    "MedicinalProductAuthorization" ->
      decode.success(AllTypesMedicinalproductauthorization)
    "MedicinalProductContraindication" ->
      decode.success(AllTypesMedicinalproductcontraindication)
    "MedicinalProductIndication" ->
      decode.success(AllTypesMedicinalproductindication)
    "MedicinalProductIngredient" ->
      decode.success(AllTypesMedicinalproductingredient)
    "MedicinalProductInteraction" ->
      decode.success(AllTypesMedicinalproductinteraction)
    "MedicinalProductManufactured" ->
      decode.success(AllTypesMedicinalproductmanufactured)
    "MedicinalProductPackaged" ->
      decode.success(AllTypesMedicinalproductpackaged)
    "MedicinalProductPharmaceutical" ->
      decode.success(AllTypesMedicinalproductpharmaceutical)
    "MedicinalProductUndesirableEffect" ->
      decode.success(AllTypesMedicinalproductundesirableeffect)
    "MessageDefinition" -> decode.success(AllTypesMessagedefinition)
    "MessageHeader" -> decode.success(AllTypesMessageheader)
    "MolecularSequence" -> decode.success(AllTypesMolecularsequence)
    "NamingSystem" -> decode.success(AllTypesNamingsystem)
    "NutritionOrder" -> decode.success(AllTypesNutritionorder)
    "Observation" -> decode.success(AllTypesObservation)
    "ObservationDefinition" -> decode.success(AllTypesObservationdefinition)
    "OperationDefinition" -> decode.success(AllTypesOperationdefinition)
    "OperationOutcome" -> decode.success(AllTypesOperationoutcome)
    "Organization" -> decode.success(AllTypesOrganization)
    "OrganizationAffiliation" -> decode.success(AllTypesOrganizationaffiliation)
    "Parameters" -> decode.success(AllTypesParameters)
    "Patient" -> decode.success(AllTypesPatient)
    "PaymentNotice" -> decode.success(AllTypesPaymentnotice)
    "PaymentReconciliation" -> decode.success(AllTypesPaymentreconciliation)
    "Person" -> decode.success(AllTypesPerson)
    "PlanDefinition" -> decode.success(AllTypesPlandefinition)
    "Practitioner" -> decode.success(AllTypesPractitioner)
    "PractitionerRole" -> decode.success(AllTypesPractitionerrole)
    "Procedure" -> decode.success(AllTypesProcedure)
    "Provenance" -> decode.success(AllTypesProvenance)
    "Questionnaire" -> decode.success(AllTypesQuestionnaire)
    "QuestionnaireResponse" -> decode.success(AllTypesQuestionnaireresponse)
    "RelatedPerson" -> decode.success(AllTypesRelatedperson)
    "RequestGroup" -> decode.success(AllTypesRequestgroup)
    "ResearchDefinition" -> decode.success(AllTypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(AllTypesResearchelementdefinition)
    "ResearchStudy" -> decode.success(AllTypesResearchstudy)
    "ResearchSubject" -> decode.success(AllTypesResearchsubject)
    "Resource" -> decode.success(AllTypesResource)
    "RiskAssessment" -> decode.success(AllTypesRiskassessment)
    "RiskEvidenceSynthesis" -> decode.success(AllTypesRiskevidencesynthesis)
    "Schedule" -> decode.success(AllTypesSchedule)
    "SearchParameter" -> decode.success(AllTypesSearchparameter)
    "ServiceRequest" -> decode.success(AllTypesServicerequest)
    "Slot" -> decode.success(AllTypesSlot)
    "Specimen" -> decode.success(AllTypesSpecimen)
    "SpecimenDefinition" -> decode.success(AllTypesSpecimendefinition)
    "StructureDefinition" -> decode.success(AllTypesStructuredefinition)
    "StructureMap" -> decode.success(AllTypesStructuremap)
    "Subscription" -> decode.success(AllTypesSubscription)
    "Substance" -> decode.success(AllTypesSubstance)
    "SubstanceNucleicAcid" -> decode.success(AllTypesSubstancenucleicacid)
    "SubstancePolymer" -> decode.success(AllTypesSubstancepolymer)
    "SubstanceProtein" -> decode.success(AllTypesSubstanceprotein)
    "SubstanceReferenceInformation" ->
      decode.success(AllTypesSubstancereferenceinformation)
    "SubstanceSourceMaterial" -> decode.success(AllTypesSubstancesourcematerial)
    "SubstanceSpecification" -> decode.success(AllTypesSubstancespecification)
    "SupplyDelivery" -> decode.success(AllTypesSupplydelivery)
    "SupplyRequest" -> decode.success(AllTypesSupplyrequest)
    "Task" -> decode.success(AllTypesTask)
    "TerminologyCapabilities" -> decode.success(AllTypesTerminologycapabilities)
    "TestReport" -> decode.success(AllTypesTestreport)
    "TestScript" -> decode.success(AllTypesTestscript)
    "ValueSet" -> decode.success(AllTypesValueset)
    "VerificationResult" -> decode.success(AllTypesVerificationresult)
    "VisionPrescription" -> decode.success(AllTypesVisionprescription)
    "Type" -> decode.success(AllTypesType)
    "Any" -> decode.success(AllTypesAny)
    _ ->
      decode.failure(
        AllTypesAddress,
        "code from valueset AllTypes ["
          <> { all_types |> list.map(all_types_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type BundleType {
  BundleTypeDocument
  BundleTypeMessage
  BundleTypeTransaction
  BundleTypeTransactionresponse
  BundleTypeBatch
  BundleTypeBatchresponse
  BundleTypeHistory
  BundleTypeSearchset
  BundleTypeCollection
}

pub const bundle_type: List(BundleType) = [
  BundleTypeDocument,
  BundleTypeMessage,
  BundleTypeTransaction,
  BundleTypeTransactionresponse,
  BundleTypeBatch,
  BundleTypeBatchresponse,
  BundleTypeHistory,
  BundleTypeSearchset,
  BundleTypeCollection,
]

pub fn bundle_type_to_json(bundle_type: BundleType) -> Json {
  json.string(bundle_type_to_code(bundle_type))
}

pub fn bundle_type_to_code(bundle_type: BundleType) -> String {
  case bundle_type {
    BundleTypeDocument -> "document"
    BundleTypeMessage -> "message"
    BundleTypeTransaction -> "transaction"
    BundleTypeTransactionresponse -> "transaction-response"
    BundleTypeBatch -> "batch"
    BundleTypeBatchresponse -> "batch-response"
    BundleTypeHistory -> "history"
    BundleTypeSearchset -> "searchset"
    BundleTypeCollection -> "collection"
  }
}

pub fn bundle_type_parse_code(code: String) -> Result(BundleType, Nil) {
  case code {
    "document" -> Ok(BundleTypeDocument)
    "message" -> Ok(BundleTypeMessage)
    "transaction" -> Ok(BundleTypeTransaction)
    "transaction-response" -> Ok(BundleTypeTransactionresponse)
    "batch" -> Ok(BundleTypeBatch)
    "batch-response" -> Ok(BundleTypeBatchresponse)
    "history" -> Ok(BundleTypeHistory)
    "searchset" -> Ok(BundleTypeSearchset)
    "collection" -> Ok(BundleTypeCollection)
    _ -> Error(Nil)
  }
}

pub fn bundle_type_decoder() -> Decoder(BundleType) {
  use variant <- decode.then(decode.string)
  case variant {
    "document" -> decode.success(BundleTypeDocument)
    "message" -> decode.success(BundleTypeMessage)
    "transaction" -> decode.success(BundleTypeTransaction)
    "transaction-response" -> decode.success(BundleTypeTransactionresponse)
    "batch" -> decode.success(BundleTypeBatch)
    "batch-response" -> decode.success(BundleTypeBatchresponse)
    "history" -> decode.success(BundleTypeHistory)
    "searchset" -> decode.success(BundleTypeSearchset)
    "collection" -> decode.success(BundleTypeCollection)
    _ ->
      decode.failure(
        BundleTypeDocument,
        "code from valueset BundleType ["
          <> {
          bundle_type |> list.map(bundle_type_to_code) |> string.join(", ")
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

pub type CodesystemContentMode {
  CodesystemContentModeNotpresent
  CodesystemContentModeExample
  CodesystemContentModeFragment
  CodesystemContentModeComplete
  CodesystemContentModeSupplement
}

pub const codesystem_content_mode: List(CodesystemContentMode) = [
  CodesystemContentModeNotpresent,
  CodesystemContentModeExample,
  CodesystemContentModeFragment,
  CodesystemContentModeComplete,
  CodesystemContentModeSupplement,
]

pub fn codesystem_content_mode_to_json(
  codesystem_content_mode: CodesystemContentMode,
) -> Json {
  json.string(codesystem_content_mode_to_code(codesystem_content_mode))
}

pub fn codesystem_content_mode_to_code(
  codesystem_content_mode: CodesystemContentMode,
) -> String {
  case codesystem_content_mode {
    CodesystemContentModeNotpresent -> "not-present"
    CodesystemContentModeExample -> "example"
    CodesystemContentModeFragment -> "fragment"
    CodesystemContentModeComplete -> "complete"
    CodesystemContentModeSupplement -> "supplement"
  }
}

pub fn codesystem_content_mode_parse_code(
  code: String,
) -> Result(CodesystemContentMode, Nil) {
  case code {
    "not-present" -> Ok(CodesystemContentModeNotpresent)
    "example" -> Ok(CodesystemContentModeExample)
    "fragment" -> Ok(CodesystemContentModeFragment)
    "complete" -> Ok(CodesystemContentModeComplete)
    "supplement" -> Ok(CodesystemContentModeSupplement)
    _ -> Error(Nil)
  }
}

pub fn codesystem_content_mode_decoder() -> Decoder(CodesystemContentMode) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-present" -> decode.success(CodesystemContentModeNotpresent)
    "example" -> decode.success(CodesystemContentModeExample)
    "fragment" -> decode.success(CodesystemContentModeFragment)
    "complete" -> decode.success(CodesystemContentModeComplete)
    "supplement" -> decode.success(CodesystemContentModeSupplement)
    _ ->
      decode.failure(
        CodesystemContentModeNotpresent,
        "code from valueset CodesystemContentMode ["
          <> {
          codesystem_content_mode
          |> list.map(codesystem_content_mode_to_code)
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

pub type CodesystemHierarchyMeaning {
  CodesystemHierarchyMeaningGroupedby
  CodesystemHierarchyMeaningIsa
  CodesystemHierarchyMeaningPartof
  CodesystemHierarchyMeaningClassifiedwith
}

pub const codesystem_hierarchy_meaning: List(CodesystemHierarchyMeaning) = [
  CodesystemHierarchyMeaningGroupedby,
  CodesystemHierarchyMeaningIsa,
  CodesystemHierarchyMeaningPartof,
  CodesystemHierarchyMeaningClassifiedwith,
]

pub fn codesystem_hierarchy_meaning_to_json(
  codesystem_hierarchy_meaning: CodesystemHierarchyMeaning,
) -> Json {
  json.string(codesystem_hierarchy_meaning_to_code(codesystem_hierarchy_meaning))
}

pub fn codesystem_hierarchy_meaning_to_code(
  codesystem_hierarchy_meaning: CodesystemHierarchyMeaning,
) -> String {
  case codesystem_hierarchy_meaning {
    CodesystemHierarchyMeaningGroupedby -> "grouped-by"
    CodesystemHierarchyMeaningIsa -> "is-a"
    CodesystemHierarchyMeaningPartof -> "part-of"
    CodesystemHierarchyMeaningClassifiedwith -> "classified-with"
  }
}

pub fn codesystem_hierarchy_meaning_parse_code(
  code: String,
) -> Result(CodesystemHierarchyMeaning, Nil) {
  case code {
    "grouped-by" -> Ok(CodesystemHierarchyMeaningGroupedby)
    "is-a" -> Ok(CodesystemHierarchyMeaningIsa)
    "part-of" -> Ok(CodesystemHierarchyMeaningPartof)
    "classified-with" -> Ok(CodesystemHierarchyMeaningClassifiedwith)
    _ -> Error(Nil)
  }
}

pub fn codesystem_hierarchy_meaning_decoder() -> Decoder(
  CodesystemHierarchyMeaning,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "grouped-by" -> decode.success(CodesystemHierarchyMeaningGroupedby)
    "is-a" -> decode.success(CodesystemHierarchyMeaningIsa)
    "part-of" -> decode.success(CodesystemHierarchyMeaningPartof)
    "classified-with" ->
      decode.success(CodesystemHierarchyMeaningClassifiedwith)
    _ ->
      decode.failure(
        CodesystemHierarchyMeaningGroupedby,
        "code from valueset CodesystemHierarchyMeaning ["
          <> {
          codesystem_hierarchy_meaning
          |> list.map(codesystem_hierarchy_meaning_to_code)
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

pub type ConceptPropertyType {
  ConceptPropertyTypeCode
  ConceptPropertyTypeCoding
  ConceptPropertyTypeString
  ConceptPropertyTypeInteger
  ConceptPropertyTypeBoolean
  ConceptPropertyTypeDatetime
  ConceptPropertyTypeDecimal
}

pub const concept_property_type: List(ConceptPropertyType) = [
  ConceptPropertyTypeCode,
  ConceptPropertyTypeCoding,
  ConceptPropertyTypeString,
  ConceptPropertyTypeInteger,
  ConceptPropertyTypeBoolean,
  ConceptPropertyTypeDatetime,
  ConceptPropertyTypeDecimal,
]

pub fn concept_property_type_to_json(
  concept_property_type: ConceptPropertyType,
) -> Json {
  json.string(concept_property_type_to_code(concept_property_type))
}

pub fn concept_property_type_to_code(
  concept_property_type: ConceptPropertyType,
) -> String {
  case concept_property_type {
    ConceptPropertyTypeCode -> "code"
    ConceptPropertyTypeCoding -> "Coding"
    ConceptPropertyTypeString -> "string"
    ConceptPropertyTypeInteger -> "integer"
    ConceptPropertyTypeBoolean -> "boolean"
    ConceptPropertyTypeDatetime -> "dateTime"
    ConceptPropertyTypeDecimal -> "decimal"
  }
}

pub fn concept_property_type_parse_code(
  code: String,
) -> Result(ConceptPropertyType, Nil) {
  case code {
    "code" -> Ok(ConceptPropertyTypeCode)
    "Coding" -> Ok(ConceptPropertyTypeCoding)
    "string" -> Ok(ConceptPropertyTypeString)
    "integer" -> Ok(ConceptPropertyTypeInteger)
    "boolean" -> Ok(ConceptPropertyTypeBoolean)
    "dateTime" -> Ok(ConceptPropertyTypeDatetime)
    "decimal" -> Ok(ConceptPropertyTypeDecimal)
    _ -> Error(Nil)
  }
}

pub fn concept_property_type_decoder() -> Decoder(ConceptPropertyType) {
  use variant <- decode.then(decode.string)
  case variant {
    "code" -> decode.success(ConceptPropertyTypeCode)
    "Coding" -> decode.success(ConceptPropertyTypeCoding)
    "string" -> decode.success(ConceptPropertyTypeString)
    "integer" -> decode.success(ConceptPropertyTypeInteger)
    "boolean" -> decode.success(ConceptPropertyTypeBoolean)
    "dateTime" -> decode.success(ConceptPropertyTypeDatetime)
    "decimal" -> decode.success(ConceptPropertyTypeDecimal)
    _ ->
      decode.failure(
        ConceptPropertyTypeCode,
        "code from valueset ConceptPropertyType ["
          <> {
          concept_property_type
          |> list.map(concept_property_type_to_code)
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

pub type ContactpointSystem {
  ContactpointSystemPhone
  ContactpointSystemFax
  ContactpointSystemEmail
  ContactpointSystemPager
  ContactpointSystemUrl
  ContactpointSystemSms
  ContactpointSystemOther
}

pub const contactpoint_system: List(ContactpointSystem) = [
  ContactpointSystemPhone,
  ContactpointSystemFax,
  ContactpointSystemEmail,
  ContactpointSystemPager,
  ContactpointSystemUrl,
  ContactpointSystemSms,
  ContactpointSystemOther,
]

pub fn contactpoint_system_to_json(
  contactpoint_system: ContactpointSystem,
) -> Json {
  json.string(contactpoint_system_to_code(contactpoint_system))
}

pub fn contactpoint_system_to_code(
  contactpoint_system: ContactpointSystem,
) -> String {
  case contactpoint_system {
    ContactpointSystemPhone -> "phone"
    ContactpointSystemFax -> "fax"
    ContactpointSystemEmail -> "email"
    ContactpointSystemPager -> "pager"
    ContactpointSystemUrl -> "url"
    ContactpointSystemSms -> "sms"
    ContactpointSystemOther -> "other"
  }
}

pub fn contactpoint_system_parse_code(
  code: String,
) -> Result(ContactpointSystem, Nil) {
  case code {
    "phone" -> Ok(ContactpointSystemPhone)
    "fax" -> Ok(ContactpointSystemFax)
    "email" -> Ok(ContactpointSystemEmail)
    "pager" -> Ok(ContactpointSystemPager)
    "url" -> Ok(ContactpointSystemUrl)
    "sms" -> Ok(ContactpointSystemSms)
    "other" -> Ok(ContactpointSystemOther)
    _ -> Error(Nil)
  }
}

pub fn contactpoint_system_decoder() -> Decoder(ContactpointSystem) {
  use variant <- decode.then(decode.string)
  case variant {
    "phone" -> decode.success(ContactpointSystemPhone)
    "fax" -> decode.success(ContactpointSystemFax)
    "email" -> decode.success(ContactpointSystemEmail)
    "pager" -> decode.success(ContactpointSystemPager)
    "url" -> decode.success(ContactpointSystemUrl)
    "sms" -> decode.success(ContactpointSystemSms)
    "other" -> decode.success(ContactpointSystemOther)
    _ ->
      decode.failure(
        ContactpointSystemPhone,
        "code from valueset ContactpointSystem ["
          <> {
          contactpoint_system
          |> list.map(contactpoint_system_to_code)
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

pub type ContactpointUse {
  ContactpointUseHome
  ContactpointUseWork
  ContactpointUseTemp
  ContactpointUseOld
  ContactpointUseMobile
}

pub const contactpoint_use: List(ContactpointUse) = [
  ContactpointUseHome,
  ContactpointUseWork,
  ContactpointUseTemp,
  ContactpointUseOld,
  ContactpointUseMobile,
]

pub fn contactpoint_use_to_json(contactpoint_use: ContactpointUse) -> Json {
  json.string(contactpoint_use_to_code(contactpoint_use))
}

pub fn contactpoint_use_to_code(contactpoint_use: ContactpointUse) -> String {
  case contactpoint_use {
    ContactpointUseHome -> "home"
    ContactpointUseWork -> "work"
    ContactpointUseTemp -> "temp"
    ContactpointUseOld -> "old"
    ContactpointUseMobile -> "mobile"
  }
}

pub fn contactpoint_use_parse_code(
  code: String,
) -> Result(ContactpointUse, Nil) {
  case code {
    "home" -> Ok(ContactpointUseHome)
    "work" -> Ok(ContactpointUseWork)
    "temp" -> Ok(ContactpointUseTemp)
    "old" -> Ok(ContactpointUseOld)
    "mobile" -> Ok(ContactpointUseMobile)
    _ -> Error(Nil)
  }
}

pub fn contactpoint_use_decoder() -> Decoder(ContactpointUse) {
  use variant <- decode.then(decode.string)
  case variant {
    "home" -> decode.success(ContactpointUseHome)
    "work" -> decode.success(ContactpointUseWork)
    "temp" -> decode.success(ContactpointUseTemp)
    "old" -> decode.success(ContactpointUseOld)
    "mobile" -> decode.success(ContactpointUseMobile)
    _ ->
      decode.failure(
        ContactpointUseHome,
        "code from valueset ContactpointUse ["
          <> {
          contactpoint_use
          |> list.map(contactpoint_use_to_code)
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

pub type ContributorType {
  ContributorTypeAuthor
  ContributorTypeEditor
  ContributorTypeReviewer
  ContributorTypeEndorser
}

pub const contributor_type: List(ContributorType) = [
  ContributorTypeAuthor,
  ContributorTypeEditor,
  ContributorTypeReviewer,
  ContributorTypeEndorser,
]

pub fn contributor_type_to_json(contributor_type: ContributorType) -> Json {
  json.string(contributor_type_to_code(contributor_type))
}

pub fn contributor_type_to_code(contributor_type: ContributorType) -> String {
  case contributor_type {
    ContributorTypeAuthor -> "author"
    ContributorTypeEditor -> "editor"
    ContributorTypeReviewer -> "reviewer"
    ContributorTypeEndorser -> "endorser"
  }
}

pub fn contributor_type_parse_code(
  code: String,
) -> Result(ContributorType, Nil) {
  case code {
    "author" -> Ok(ContributorTypeAuthor)
    "editor" -> Ok(ContributorTypeEditor)
    "reviewer" -> Ok(ContributorTypeReviewer)
    "endorser" -> Ok(ContributorTypeEndorser)
    _ -> Error(Nil)
  }
}

pub fn contributor_type_decoder() -> Decoder(ContributorType) {
  use variant <- decode.then(decode.string)
  case variant {
    "author" -> decode.success(ContributorTypeAuthor)
    "editor" -> decode.success(ContributorTypeEditor)
    "reviewer" -> decode.success(ContributorTypeReviewer)
    "endorser" -> decode.success(ContributorTypeEndorser)
    _ ->
      decode.failure(
        ContributorTypeAuthor,
        "code from valueset ContributorType ["
          <> {
          contributor_type
          |> list.map(contributor_type_to_code)
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

pub type DaysOfWeek {
  DaysOfWeekMon
  DaysOfWeekTue
  DaysOfWeekWed
  DaysOfWeekThu
  DaysOfWeekFri
  DaysOfWeekSat
  DaysOfWeekSun
}

pub const days_of_week: List(DaysOfWeek) = [
  DaysOfWeekMon,
  DaysOfWeekTue,
  DaysOfWeekWed,
  DaysOfWeekThu,
  DaysOfWeekFri,
  DaysOfWeekSat,
  DaysOfWeekSun,
]

pub fn days_of_week_to_json(days_of_week: DaysOfWeek) -> Json {
  json.string(days_of_week_to_code(days_of_week))
}

pub fn days_of_week_to_code(days_of_week: DaysOfWeek) -> String {
  case days_of_week {
    DaysOfWeekMon -> "mon"
    DaysOfWeekTue -> "tue"
    DaysOfWeekWed -> "wed"
    DaysOfWeekThu -> "thu"
    DaysOfWeekFri -> "fri"
    DaysOfWeekSat -> "sat"
    DaysOfWeekSun -> "sun"
  }
}

pub fn days_of_week_parse_code(code: String) -> Result(DaysOfWeek, Nil) {
  case code {
    "mon" -> Ok(DaysOfWeekMon)
    "tue" -> Ok(DaysOfWeekTue)
    "wed" -> Ok(DaysOfWeekWed)
    "thu" -> Ok(DaysOfWeekThu)
    "fri" -> Ok(DaysOfWeekFri)
    "sat" -> Ok(DaysOfWeekSat)
    "sun" -> Ok(DaysOfWeekSun)
    _ -> Error(Nil)
  }
}

pub fn days_of_week_decoder() -> Decoder(DaysOfWeek) {
  use variant <- decode.then(decode.string)
  case variant {
    "mon" -> decode.success(DaysOfWeekMon)
    "tue" -> decode.success(DaysOfWeekTue)
    "wed" -> decode.success(DaysOfWeekWed)
    "thu" -> decode.success(DaysOfWeekThu)
    "fri" -> decode.success(DaysOfWeekFri)
    "sat" -> decode.success(DaysOfWeekSat)
    "sun" -> decode.success(DaysOfWeekSun)
    _ ->
      decode.failure(
        DaysOfWeekMon,
        "code from valueset DaysOfWeek ["
          <> {
          days_of_week |> list.map(days_of_week_to_code) |> string.join(", ")
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

pub type EventTiming {
  EventTimingMorn
  EventTimingMornearly
  EventTimingMornlate
  EventTimingNoon
  EventTimingAft
  EventTimingAftearly
  EventTimingAftlate
  EventTimingEve
  EventTimingEveearly
  EventTimingEvelate
  EventTimingNight
  EventTimingPhs
  EventTimingHs
  EventTimingWake
  EventTimingC
  EventTimingCm
  EventTimingCd
  EventTimingCv
  EventTimingAc
  EventTimingAcm
  EventTimingAcd
  EventTimingAcv
  EventTimingPc
  EventTimingPcm
  EventTimingPcd
  EventTimingPcv
}

pub const event_timing: List(EventTiming) = [
  EventTimingMorn,
  EventTimingMornearly,
  EventTimingMornlate,
  EventTimingNoon,
  EventTimingAft,
  EventTimingAftearly,
  EventTimingAftlate,
  EventTimingEve,
  EventTimingEveearly,
  EventTimingEvelate,
  EventTimingNight,
  EventTimingPhs,
  EventTimingHs,
  EventTimingWake,
  EventTimingC,
  EventTimingCm,
  EventTimingCd,
  EventTimingCv,
  EventTimingAc,
  EventTimingAcm,
  EventTimingAcd,
  EventTimingAcv,
  EventTimingPc,
  EventTimingPcm,
  EventTimingPcd,
  EventTimingPcv,
]

pub fn event_timing_to_json(event_timing: EventTiming) -> Json {
  json.string(event_timing_to_code(event_timing))
}

pub fn event_timing_to_code(event_timing: EventTiming) -> String {
  case event_timing {
    EventTimingMorn -> "MORN"
    EventTimingMornearly -> "MORN.early"
    EventTimingMornlate -> "MORN.late"
    EventTimingNoon -> "NOON"
    EventTimingAft -> "AFT"
    EventTimingAftearly -> "AFT.early"
    EventTimingAftlate -> "AFT.late"
    EventTimingEve -> "EVE"
    EventTimingEveearly -> "EVE.early"
    EventTimingEvelate -> "EVE.late"
    EventTimingNight -> "NIGHT"
    EventTimingPhs -> "PHS"
    EventTimingHs -> "HS"
    EventTimingWake -> "WAKE"
    EventTimingC -> "C"
    EventTimingCm -> "CM"
    EventTimingCd -> "CD"
    EventTimingCv -> "CV"
    EventTimingAc -> "AC"
    EventTimingAcm -> "ACM"
    EventTimingAcd -> "ACD"
    EventTimingAcv -> "ACV"
    EventTimingPc -> "PC"
    EventTimingPcm -> "PCM"
    EventTimingPcd -> "PCD"
    EventTimingPcv -> "PCV"
  }
}

pub fn event_timing_parse_code(code: String) -> Result(EventTiming, Nil) {
  case code {
    "MORN" -> Ok(EventTimingMorn)
    "MORN.early" -> Ok(EventTimingMornearly)
    "MORN.late" -> Ok(EventTimingMornlate)
    "NOON" -> Ok(EventTimingNoon)
    "AFT" -> Ok(EventTimingAft)
    "AFT.early" -> Ok(EventTimingAftearly)
    "AFT.late" -> Ok(EventTimingAftlate)
    "EVE" -> Ok(EventTimingEve)
    "EVE.early" -> Ok(EventTimingEveearly)
    "EVE.late" -> Ok(EventTimingEvelate)
    "NIGHT" -> Ok(EventTimingNight)
    "PHS" -> Ok(EventTimingPhs)
    "HS" -> Ok(EventTimingHs)
    "WAKE" -> Ok(EventTimingWake)
    "C" -> Ok(EventTimingC)
    "CM" -> Ok(EventTimingCm)
    "CD" -> Ok(EventTimingCd)
    "CV" -> Ok(EventTimingCv)
    "AC" -> Ok(EventTimingAc)
    "ACM" -> Ok(EventTimingAcm)
    "ACD" -> Ok(EventTimingAcd)
    "ACV" -> Ok(EventTimingAcv)
    "PC" -> Ok(EventTimingPc)
    "PCM" -> Ok(EventTimingPcm)
    "PCD" -> Ok(EventTimingPcd)
    "PCV" -> Ok(EventTimingPcv)
    _ -> Error(Nil)
  }
}

pub fn event_timing_decoder() -> Decoder(EventTiming) {
  use variant <- decode.then(decode.string)
  case variant {
    "MORN" -> decode.success(EventTimingMorn)
    "MORN.early" -> decode.success(EventTimingMornearly)
    "MORN.late" -> decode.success(EventTimingMornlate)
    "NOON" -> decode.success(EventTimingNoon)
    "AFT" -> decode.success(EventTimingAft)
    "AFT.early" -> decode.success(EventTimingAftearly)
    "AFT.late" -> decode.success(EventTimingAftlate)
    "EVE" -> decode.success(EventTimingEve)
    "EVE.early" -> decode.success(EventTimingEveearly)
    "EVE.late" -> decode.success(EventTimingEvelate)
    "NIGHT" -> decode.success(EventTimingNight)
    "PHS" -> decode.success(EventTimingPhs)
    "HS" -> decode.success(EventTimingHs)
    "WAKE" -> decode.success(EventTimingWake)
    "C" -> decode.success(EventTimingC)
    "CM" -> decode.success(EventTimingCm)
    "CD" -> decode.success(EventTimingCd)
    "CV" -> decode.success(EventTimingCv)
    "AC" -> decode.success(EventTimingAc)
    "ACM" -> decode.success(EventTimingAcm)
    "ACD" -> decode.success(EventTimingAcd)
    "ACV" -> decode.success(EventTimingAcv)
    "PC" -> decode.success(EventTimingPc)
    "PCM" -> decode.success(EventTimingPcm)
    "PCD" -> decode.success(EventTimingPcd)
    "PCV" -> decode.success(EventTimingPcv)
    _ ->
      decode.failure(
        EventTimingMorn,
        "code from valueset EventTiming ["
          <> {
          event_timing |> list.map(event_timing_to_code) |> string.join(", ")
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

pub type FilterOperator {
  FilterOperatorEqual
  FilterOperatorIsa
  FilterOperatorDescendentof
  FilterOperatorIsnota
  FilterOperatorRegex
  FilterOperatorIn
  FilterOperatorNotin
  FilterOperatorGeneralizes
  FilterOperatorExists
}

pub const filter_operator: List(FilterOperator) = [
  FilterOperatorEqual,
  FilterOperatorIsa,
  FilterOperatorDescendentof,
  FilterOperatorIsnota,
  FilterOperatorRegex,
  FilterOperatorIn,
  FilterOperatorNotin,
  FilterOperatorGeneralizes,
  FilterOperatorExists,
]

pub fn filter_operator_to_json(filter_operator: FilterOperator) -> Json {
  json.string(filter_operator_to_code(filter_operator))
}

pub fn filter_operator_to_code(filter_operator: FilterOperator) -> String {
  case filter_operator {
    FilterOperatorEqual -> "="
    FilterOperatorIsa -> "is-a"
    FilterOperatorDescendentof -> "descendent-of"
    FilterOperatorIsnota -> "is-not-a"
    FilterOperatorRegex -> "regex"
    FilterOperatorIn -> "in"
    FilterOperatorNotin -> "not-in"
    FilterOperatorGeneralizes -> "generalizes"
    FilterOperatorExists -> "exists"
  }
}

pub fn filter_operator_parse_code(code: String) -> Result(FilterOperator, Nil) {
  case code {
    "=" -> Ok(FilterOperatorEqual)
    "is-a" -> Ok(FilterOperatorIsa)
    "descendent-of" -> Ok(FilterOperatorDescendentof)
    "is-not-a" -> Ok(FilterOperatorIsnota)
    "regex" -> Ok(FilterOperatorRegex)
    "in" -> Ok(FilterOperatorIn)
    "not-in" -> Ok(FilterOperatorNotin)
    "generalizes" -> Ok(FilterOperatorGeneralizes)
    "exists" -> Ok(FilterOperatorExists)
    _ -> Error(Nil)
  }
}

pub fn filter_operator_decoder() -> Decoder(FilterOperator) {
  use variant <- decode.then(decode.string)
  case variant {
    "=" -> decode.success(FilterOperatorEqual)
    "is-a" -> decode.success(FilterOperatorIsa)
    "descendent-of" -> decode.success(FilterOperatorDescendentof)
    "is-not-a" -> decode.success(FilterOperatorIsnota)
    "regex" -> decode.success(FilterOperatorRegex)
    "in" -> decode.success(FilterOperatorIn)
    "not-in" -> decode.success(FilterOperatorNotin)
    "generalizes" -> decode.success(FilterOperatorGeneralizes)
    "exists" -> decode.success(FilterOperatorExists)
    _ ->
      decode.failure(
        FilterOperatorEqual,
        "code from valueset FilterOperator ["
          <> {
          filter_operator
          |> list.map(filter_operator_to_code)
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

pub type HttpVerb {
  HttpVerbGet
  HttpVerbHead
  HttpVerbPost
  HttpVerbPut
  HttpVerbDelete
  HttpVerbPatch
}

pub const http_verb: List(HttpVerb) = [
  HttpVerbGet,
  HttpVerbHead,
  HttpVerbPost,
  HttpVerbPut,
  HttpVerbDelete,
  HttpVerbPatch,
]

pub fn http_verb_to_json(http_verb: HttpVerb) -> Json {
  json.string(http_verb_to_code(http_verb))
}

pub fn http_verb_to_code(http_verb: HttpVerb) -> String {
  case http_verb {
    HttpVerbGet -> "GET"
    HttpVerbHead -> "HEAD"
    HttpVerbPost -> "POST"
    HttpVerbPut -> "PUT"
    HttpVerbDelete -> "DELETE"
    HttpVerbPatch -> "PATCH"
  }
}

pub fn http_verb_parse_code(code: String) -> Result(HttpVerb, Nil) {
  case code {
    "GET" -> Ok(HttpVerbGet)
    "HEAD" -> Ok(HttpVerbHead)
    "POST" -> Ok(HttpVerbPost)
    "PUT" -> Ok(HttpVerbPut)
    "DELETE" -> Ok(HttpVerbDelete)
    "PATCH" -> Ok(HttpVerbPatch)
    _ -> Error(Nil)
  }
}

pub fn http_verb_decoder() -> Decoder(HttpVerb) {
  use variant <- decode.then(decode.string)
  case variant {
    "GET" -> decode.success(HttpVerbGet)
    "HEAD" -> decode.success(HttpVerbHead)
    "POST" -> decode.success(HttpVerbPost)
    "PUT" -> decode.success(HttpVerbPut)
    "DELETE" -> decode.success(HttpVerbDelete)
    "PATCH" -> decode.success(HttpVerbPatch)
    _ ->
      decode.failure(
        HttpVerbGet,
        "code from valueset HttpVerb ["
          <> { http_verb |> list.map(http_verb_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type IdentifierUse {
  IdentifierUseUsual
  IdentifierUseOfficial
  IdentifierUseTemp
  IdentifierUseSecondary
  IdentifierUseOld
}

pub const identifier_use: List(IdentifierUse) = [
  IdentifierUseUsual,
  IdentifierUseOfficial,
  IdentifierUseTemp,
  IdentifierUseSecondary,
  IdentifierUseOld,
]

pub fn identifier_use_to_json(identifier_use: IdentifierUse) -> Json {
  json.string(identifier_use_to_code(identifier_use))
}

pub fn identifier_use_to_code(identifier_use: IdentifierUse) -> String {
  case identifier_use {
    IdentifierUseUsual -> "usual"
    IdentifierUseOfficial -> "official"
    IdentifierUseTemp -> "temp"
    IdentifierUseSecondary -> "secondary"
    IdentifierUseOld -> "old"
  }
}

pub fn identifier_use_parse_code(code: String) -> Result(IdentifierUse, Nil) {
  case code {
    "usual" -> Ok(IdentifierUseUsual)
    "official" -> Ok(IdentifierUseOfficial)
    "temp" -> Ok(IdentifierUseTemp)
    "secondary" -> Ok(IdentifierUseSecondary)
    "old" -> Ok(IdentifierUseOld)
    _ -> Error(Nil)
  }
}

pub fn identifier_use_decoder() -> Decoder(IdentifierUse) {
  use variant <- decode.then(decode.string)
  case variant {
    "usual" -> decode.success(IdentifierUseUsual)
    "official" -> decode.success(IdentifierUseOfficial)
    "temp" -> decode.success(IdentifierUseTemp)
    "secondary" -> decode.success(IdentifierUseSecondary)
    "old" -> decode.success(IdentifierUseOld)
    _ ->
      decode.failure(
        IdentifierUseUsual,
        "code from valueset IdentifierUse ["
          <> {
          identifier_use
          |> list.map(identifier_use_to_code)
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

pub type IssueSeverity {
  IssueSeverityFatal
  IssueSeverityError
  IssueSeverityWarning
  IssueSeverityInformation
}

pub const issue_severity: List(IssueSeverity) = [
  IssueSeverityFatal,
  IssueSeverityError,
  IssueSeverityWarning,
  IssueSeverityInformation,
]

pub fn issue_severity_to_json(issue_severity: IssueSeverity) -> Json {
  json.string(issue_severity_to_code(issue_severity))
}

pub fn issue_severity_to_code(issue_severity: IssueSeverity) -> String {
  case issue_severity {
    IssueSeverityFatal -> "fatal"
    IssueSeverityError -> "error"
    IssueSeverityWarning -> "warning"
    IssueSeverityInformation -> "information"
  }
}

pub fn issue_severity_parse_code(code: String) -> Result(IssueSeverity, Nil) {
  case code {
    "fatal" -> Ok(IssueSeverityFatal)
    "error" -> Ok(IssueSeverityError)
    "warning" -> Ok(IssueSeverityWarning)
    "information" -> Ok(IssueSeverityInformation)
    _ -> Error(Nil)
  }
}

pub fn issue_severity_decoder() -> Decoder(IssueSeverity) {
  use variant <- decode.then(decode.string)
  case variant {
    "fatal" -> decode.success(IssueSeverityFatal)
    "error" -> decode.success(IssueSeverityError)
    "warning" -> decode.success(IssueSeverityWarning)
    "information" -> decode.success(IssueSeverityInformation)
    _ ->
      decode.failure(
        IssueSeverityFatal,
        "code from valueset IssueSeverity ["
          <> {
          issue_severity
          |> list.map(issue_severity_to_code)
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

pub type IssueType {
  IssueTypeInvalid
  IssueTypeStructure
  IssueTypeRequired
  IssueTypeValue
  IssueTypeInvariant
  IssueTypeSecurity
  IssueTypeLogin
  IssueTypeUnknown
  IssueTypeExpired
  IssueTypeForbidden
  IssueTypeSuppressed
  IssueTypeProcessing
  IssueTypeNotsupported
  IssueTypeDuplicate
  IssueTypeMultiplematches
  IssueTypeNotfound
  IssueTypeDeleted
  IssueTypeToolong
  IssueTypeCodeinvalid
  IssueTypeExtension
  IssueTypeToocostly
  IssueTypeBusinessrule
  IssueTypeConflict
  IssueTypeTransient
  IssueTypeLockerror
  IssueTypeNostore
  IssueTypeException
  IssueTypeTimeout
  IssueTypeIncomplete
  IssueTypeThrottled
  IssueTypeInformational
}

pub const issue_type: List(IssueType) = [
  IssueTypeInvalid,
  IssueTypeStructure,
  IssueTypeRequired,
  IssueTypeValue,
  IssueTypeInvariant,
  IssueTypeSecurity,
  IssueTypeLogin,
  IssueTypeUnknown,
  IssueTypeExpired,
  IssueTypeForbidden,
  IssueTypeSuppressed,
  IssueTypeProcessing,
  IssueTypeNotsupported,
  IssueTypeDuplicate,
  IssueTypeMultiplematches,
  IssueTypeNotfound,
  IssueTypeDeleted,
  IssueTypeToolong,
  IssueTypeCodeinvalid,
  IssueTypeExtension,
  IssueTypeToocostly,
  IssueTypeBusinessrule,
  IssueTypeConflict,
  IssueTypeTransient,
  IssueTypeLockerror,
  IssueTypeNostore,
  IssueTypeException,
  IssueTypeTimeout,
  IssueTypeIncomplete,
  IssueTypeThrottled,
  IssueTypeInformational,
]

pub fn issue_type_to_json(issue_type: IssueType) -> Json {
  json.string(issue_type_to_code(issue_type))
}

pub fn issue_type_to_code(issue_type: IssueType) -> String {
  case issue_type {
    IssueTypeInvalid -> "invalid"
    IssueTypeStructure -> "structure"
    IssueTypeRequired -> "required"
    IssueTypeValue -> "value"
    IssueTypeInvariant -> "invariant"
    IssueTypeSecurity -> "security"
    IssueTypeLogin -> "login"
    IssueTypeUnknown -> "unknown"
    IssueTypeExpired -> "expired"
    IssueTypeForbidden -> "forbidden"
    IssueTypeSuppressed -> "suppressed"
    IssueTypeProcessing -> "processing"
    IssueTypeNotsupported -> "not-supported"
    IssueTypeDuplicate -> "duplicate"
    IssueTypeMultiplematches -> "multiple-matches"
    IssueTypeNotfound -> "not-found"
    IssueTypeDeleted -> "deleted"
    IssueTypeToolong -> "too-long"
    IssueTypeCodeinvalid -> "code-invalid"
    IssueTypeExtension -> "extension"
    IssueTypeToocostly -> "too-costly"
    IssueTypeBusinessrule -> "business-rule"
    IssueTypeConflict -> "conflict"
    IssueTypeTransient -> "transient"
    IssueTypeLockerror -> "lock-error"
    IssueTypeNostore -> "no-store"
    IssueTypeException -> "exception"
    IssueTypeTimeout -> "timeout"
    IssueTypeIncomplete -> "incomplete"
    IssueTypeThrottled -> "throttled"
    IssueTypeInformational -> "informational"
  }
}

pub fn issue_type_parse_code(code: String) -> Result(IssueType, Nil) {
  case code {
    "invalid" -> Ok(IssueTypeInvalid)
    "structure" -> Ok(IssueTypeStructure)
    "required" -> Ok(IssueTypeRequired)
    "value" -> Ok(IssueTypeValue)
    "invariant" -> Ok(IssueTypeInvariant)
    "security" -> Ok(IssueTypeSecurity)
    "login" -> Ok(IssueTypeLogin)
    "unknown" -> Ok(IssueTypeUnknown)
    "expired" -> Ok(IssueTypeExpired)
    "forbidden" -> Ok(IssueTypeForbidden)
    "suppressed" -> Ok(IssueTypeSuppressed)
    "processing" -> Ok(IssueTypeProcessing)
    "not-supported" -> Ok(IssueTypeNotsupported)
    "duplicate" -> Ok(IssueTypeDuplicate)
    "multiple-matches" -> Ok(IssueTypeMultiplematches)
    "not-found" -> Ok(IssueTypeNotfound)
    "deleted" -> Ok(IssueTypeDeleted)
    "too-long" -> Ok(IssueTypeToolong)
    "code-invalid" -> Ok(IssueTypeCodeinvalid)
    "extension" -> Ok(IssueTypeExtension)
    "too-costly" -> Ok(IssueTypeToocostly)
    "business-rule" -> Ok(IssueTypeBusinessrule)
    "conflict" -> Ok(IssueTypeConflict)
    "transient" -> Ok(IssueTypeTransient)
    "lock-error" -> Ok(IssueTypeLockerror)
    "no-store" -> Ok(IssueTypeNostore)
    "exception" -> Ok(IssueTypeException)
    "timeout" -> Ok(IssueTypeTimeout)
    "incomplete" -> Ok(IssueTypeIncomplete)
    "throttled" -> Ok(IssueTypeThrottled)
    "informational" -> Ok(IssueTypeInformational)
    _ -> Error(Nil)
  }
}

pub fn issue_type_decoder() -> Decoder(IssueType) {
  use variant <- decode.then(decode.string)
  case variant {
    "invalid" -> decode.success(IssueTypeInvalid)
    "structure" -> decode.success(IssueTypeStructure)
    "required" -> decode.success(IssueTypeRequired)
    "value" -> decode.success(IssueTypeValue)
    "invariant" -> decode.success(IssueTypeInvariant)
    "security" -> decode.success(IssueTypeSecurity)
    "login" -> decode.success(IssueTypeLogin)
    "unknown" -> decode.success(IssueTypeUnknown)
    "expired" -> decode.success(IssueTypeExpired)
    "forbidden" -> decode.success(IssueTypeForbidden)
    "suppressed" -> decode.success(IssueTypeSuppressed)
    "processing" -> decode.success(IssueTypeProcessing)
    "not-supported" -> decode.success(IssueTypeNotsupported)
    "duplicate" -> decode.success(IssueTypeDuplicate)
    "multiple-matches" -> decode.success(IssueTypeMultiplematches)
    "not-found" -> decode.success(IssueTypeNotfound)
    "deleted" -> decode.success(IssueTypeDeleted)
    "too-long" -> decode.success(IssueTypeToolong)
    "code-invalid" -> decode.success(IssueTypeCodeinvalid)
    "extension" -> decode.success(IssueTypeExtension)
    "too-costly" -> decode.success(IssueTypeToocostly)
    "business-rule" -> decode.success(IssueTypeBusinessrule)
    "conflict" -> decode.success(IssueTypeConflict)
    "transient" -> decode.success(IssueTypeTransient)
    "lock-error" -> decode.success(IssueTypeLockerror)
    "no-store" -> decode.success(IssueTypeNostore)
    "exception" -> decode.success(IssueTypeException)
    "timeout" -> decode.success(IssueTypeTimeout)
    "incomplete" -> decode.success(IssueTypeIncomplete)
    "throttled" -> decode.success(IssueTypeThrottled)
    "informational" -> decode.success(IssueTypeInformational)
    _ ->
      decode.failure(
        IssueTypeInvalid,
        "code from valueset IssueType ["
          <> { issue_type |> list.map(issue_type_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type NameUse {
  NameUseUsual
  NameUseOfficial
  NameUseTemp
  NameUseNickname
  NameUseAnonymous
  NameUseOld
  NameUseMaiden
}

pub const name_use: List(NameUse) = [
  NameUseUsual,
  NameUseOfficial,
  NameUseTemp,
  NameUseNickname,
  NameUseAnonymous,
  NameUseOld,
  NameUseMaiden,
]

pub fn name_use_to_json(name_use: NameUse) -> Json {
  json.string(name_use_to_code(name_use))
}

pub fn name_use_to_code(name_use: NameUse) -> String {
  case name_use {
    NameUseUsual -> "usual"
    NameUseOfficial -> "official"
    NameUseTemp -> "temp"
    NameUseNickname -> "nickname"
    NameUseAnonymous -> "anonymous"
    NameUseOld -> "old"
    NameUseMaiden -> "maiden"
  }
}

pub fn name_use_parse_code(code: String) -> Result(NameUse, Nil) {
  case code {
    "usual" -> Ok(NameUseUsual)
    "official" -> Ok(NameUseOfficial)
    "temp" -> Ok(NameUseTemp)
    "nickname" -> Ok(NameUseNickname)
    "anonymous" -> Ok(NameUseAnonymous)
    "old" -> Ok(NameUseOld)
    "maiden" -> Ok(NameUseMaiden)
    _ -> Error(Nil)
  }
}

pub fn name_use_decoder() -> Decoder(NameUse) {
  use variant <- decode.then(decode.string)
  case variant {
    "usual" -> decode.success(NameUseUsual)
    "official" -> decode.success(NameUseOfficial)
    "temp" -> decode.success(NameUseTemp)
    "nickname" -> decode.success(NameUseNickname)
    "anonymous" -> decode.success(NameUseAnonymous)
    "old" -> decode.success(NameUseOld)
    "maiden" -> decode.success(NameUseMaiden)
    _ ->
      decode.failure(
        NameUseUsual,
        "code from valueset NameUse ["
          <> { name_use |> list.map(name_use_to_code) |> string.join(", ") }
          <> "]",
      )
      |> decode.map_errors(fn(errors) {
        list.map(errors, fn(error) {
          decode.DecodeError(..error, found: variant)
        })
      })
  }
}

pub type NarrativeStatus {
  NarrativeStatusGenerated
  NarrativeStatusExtensions
  NarrativeStatusAdditional
  NarrativeStatusEmpty
}

pub const narrative_status: List(NarrativeStatus) = [
  NarrativeStatusGenerated,
  NarrativeStatusExtensions,
  NarrativeStatusAdditional,
  NarrativeStatusEmpty,
]

pub fn narrative_status_to_json(narrative_status: NarrativeStatus) -> Json {
  json.string(narrative_status_to_code(narrative_status))
}

pub fn narrative_status_to_code(narrative_status: NarrativeStatus) -> String {
  case narrative_status {
    NarrativeStatusGenerated -> "generated"
    NarrativeStatusExtensions -> "extensions"
    NarrativeStatusAdditional -> "additional"
    NarrativeStatusEmpty -> "empty"
  }
}

pub fn narrative_status_parse_code(
  code: String,
) -> Result(NarrativeStatus, Nil) {
  case code {
    "generated" -> Ok(NarrativeStatusGenerated)
    "extensions" -> Ok(NarrativeStatusExtensions)
    "additional" -> Ok(NarrativeStatusAdditional)
    "empty" -> Ok(NarrativeStatusEmpty)
    _ -> Error(Nil)
  }
}

pub fn narrative_status_decoder() -> Decoder(NarrativeStatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "generated" -> decode.success(NarrativeStatusGenerated)
    "extensions" -> decode.success(NarrativeStatusExtensions)
    "additional" -> decode.success(NarrativeStatusAdditional)
    "empty" -> decode.success(NarrativeStatusEmpty)
    _ ->
      decode.failure(
        NarrativeStatusGenerated,
        "code from valueset NarrativeStatus ["
          <> {
          narrative_status
          |> list.map(narrative_status_to_code)
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

pub type OperationParameterUse {
  OperationParameterUseIn
  OperationParameterUseOut
}

pub const operation_parameter_use: List(OperationParameterUse) = [
  OperationParameterUseIn,
  OperationParameterUseOut,
]

pub fn operation_parameter_use_to_json(
  operation_parameter_use: OperationParameterUse,
) -> Json {
  json.string(operation_parameter_use_to_code(operation_parameter_use))
}

pub fn operation_parameter_use_to_code(
  operation_parameter_use: OperationParameterUse,
) -> String {
  case operation_parameter_use {
    OperationParameterUseIn -> "in"
    OperationParameterUseOut -> "out"
  }
}

pub fn operation_parameter_use_parse_code(
  code: String,
) -> Result(OperationParameterUse, Nil) {
  case code {
    "in" -> Ok(OperationParameterUseIn)
    "out" -> Ok(OperationParameterUseOut)
    _ -> Error(Nil)
  }
}

pub fn operation_parameter_use_decoder() -> Decoder(OperationParameterUse) {
  use variant <- decode.then(decode.string)
  case variant {
    "in" -> decode.success(OperationParameterUseIn)
    "out" -> decode.success(OperationParameterUseOut)
    _ ->
      decode.failure(
        OperationParameterUseIn,
        "code from valueset OperationParameterUse ["
          <> {
          operation_parameter_use
          |> list.map(operation_parameter_use_to_code)
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

pub type PublicationStatus {
  PublicationStatusDraft
  PublicationStatusActive
  PublicationStatusRetired
  PublicationStatusUnknown
}

pub const publication_status: List(PublicationStatus) = [
  PublicationStatusDraft,
  PublicationStatusActive,
  PublicationStatusRetired,
  PublicationStatusUnknown,
]

pub fn publication_status_to_json(
  publication_status: PublicationStatus,
) -> Json {
  json.string(publication_status_to_code(publication_status))
}

pub fn publication_status_to_code(
  publication_status: PublicationStatus,
) -> String {
  case publication_status {
    PublicationStatusDraft -> "draft"
    PublicationStatusActive -> "active"
    PublicationStatusRetired -> "retired"
    PublicationStatusUnknown -> "unknown"
  }
}

pub fn publication_status_parse_code(
  code: String,
) -> Result(PublicationStatus, Nil) {
  case code {
    "draft" -> Ok(PublicationStatusDraft)
    "active" -> Ok(PublicationStatusActive)
    "retired" -> Ok(PublicationStatusRetired)
    "unknown" -> Ok(PublicationStatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn publication_status_decoder() -> Decoder(PublicationStatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(PublicationStatusDraft)
    "active" -> decode.success(PublicationStatusActive)
    "retired" -> decode.success(PublicationStatusRetired)
    "unknown" -> decode.success(PublicationStatusUnknown)
    _ ->
      decode.failure(
        PublicationStatusDraft,
        "code from valueset PublicationStatus ["
          <> {
          publication_status
          |> list.map(publication_status_to_code)
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

pub type QuantityComparator {
  QuantityComparatorLessthan
  QuantityComparatorLessthanequal
  QuantityComparatorGreaterthanequal
  QuantityComparatorGreaterthan
}

pub const quantity_comparator: List(QuantityComparator) = [
  QuantityComparatorLessthan,
  QuantityComparatorLessthanequal,
  QuantityComparatorGreaterthanequal,
  QuantityComparatorGreaterthan,
]

pub fn quantity_comparator_to_json(
  quantity_comparator: QuantityComparator,
) -> Json {
  json.string(quantity_comparator_to_code(quantity_comparator))
}

pub fn quantity_comparator_to_code(
  quantity_comparator: QuantityComparator,
) -> String {
  case quantity_comparator {
    QuantityComparatorLessthan -> "<"
    QuantityComparatorLessthanequal -> "<="
    QuantityComparatorGreaterthanequal -> ">="
    QuantityComparatorGreaterthan -> ">"
  }
}

pub fn quantity_comparator_parse_code(
  code: String,
) -> Result(QuantityComparator, Nil) {
  case code {
    "<" -> Ok(QuantityComparatorLessthan)
    "<=" -> Ok(QuantityComparatorLessthanequal)
    ">=" -> Ok(QuantityComparatorGreaterthanequal)
    ">" -> Ok(QuantityComparatorGreaterthan)
    _ -> Error(Nil)
  }
}

pub fn quantity_comparator_decoder() -> Decoder(QuantityComparator) {
  use variant <- decode.then(decode.string)
  case variant {
    "<" -> decode.success(QuantityComparatorLessthan)
    "<=" -> decode.success(QuantityComparatorLessthanequal)
    ">=" -> decode.success(QuantityComparatorGreaterthanequal)
    ">" -> decode.success(QuantityComparatorGreaterthan)
    _ ->
      decode.failure(
        QuantityComparatorLessthan,
        "code from valueset QuantityComparator ["
          <> {
          quantity_comparator
          |> list.map(quantity_comparator_to_code)
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

pub type RelatedartifactType {
  RelatedartifactTypeDocumentation
  RelatedartifactTypeJustification
  RelatedartifactTypeCitation
  RelatedartifactTypePredecessor
  RelatedartifactTypeSuccessor
  RelatedartifactTypeDerivedfrom
  RelatedartifactTypeDependson
  RelatedartifactTypeComposedof
}

pub const relatedartifact_type: List(RelatedartifactType) = [
  RelatedartifactTypeDocumentation,
  RelatedartifactTypeJustification,
  RelatedartifactTypeCitation,
  RelatedartifactTypePredecessor,
  RelatedartifactTypeSuccessor,
  RelatedartifactTypeDerivedfrom,
  RelatedartifactTypeDependson,
  RelatedartifactTypeComposedof,
]

pub fn relatedartifact_type_to_json(
  relatedartifact_type: RelatedartifactType,
) -> Json {
  json.string(relatedartifact_type_to_code(relatedartifact_type))
}

pub fn relatedartifact_type_to_code(
  relatedartifact_type: RelatedartifactType,
) -> String {
  case relatedartifact_type {
    RelatedartifactTypeDocumentation -> "documentation"
    RelatedartifactTypeJustification -> "justification"
    RelatedartifactTypeCitation -> "citation"
    RelatedartifactTypePredecessor -> "predecessor"
    RelatedartifactTypeSuccessor -> "successor"
    RelatedartifactTypeDerivedfrom -> "derived-from"
    RelatedartifactTypeDependson -> "depends-on"
    RelatedartifactTypeComposedof -> "composed-of"
  }
}

pub fn relatedartifact_type_parse_code(
  code: String,
) -> Result(RelatedartifactType, Nil) {
  case code {
    "documentation" -> Ok(RelatedartifactTypeDocumentation)
    "justification" -> Ok(RelatedartifactTypeJustification)
    "citation" -> Ok(RelatedartifactTypeCitation)
    "predecessor" -> Ok(RelatedartifactTypePredecessor)
    "successor" -> Ok(RelatedartifactTypeSuccessor)
    "derived-from" -> Ok(RelatedartifactTypeDerivedfrom)
    "depends-on" -> Ok(RelatedartifactTypeDependson)
    "composed-of" -> Ok(RelatedartifactTypeComposedof)
    _ -> Error(Nil)
  }
}

pub fn relatedartifact_type_decoder() -> Decoder(RelatedartifactType) {
  use variant <- decode.then(decode.string)
  case variant {
    "documentation" -> decode.success(RelatedartifactTypeDocumentation)
    "justification" -> decode.success(RelatedartifactTypeJustification)
    "citation" -> decode.success(RelatedartifactTypeCitation)
    "predecessor" -> decode.success(RelatedartifactTypePredecessor)
    "successor" -> decode.success(RelatedartifactTypeSuccessor)
    "derived-from" -> decode.success(RelatedartifactTypeDerivedfrom)
    "depends-on" -> decode.success(RelatedartifactTypeDependson)
    "composed-of" -> decode.success(RelatedartifactTypeComposedof)
    _ ->
      decode.failure(
        RelatedartifactTypeDocumentation,
        "code from valueset RelatedartifactType ["
          <> {
          relatedartifact_type
          |> list.map(relatedartifact_type_to_code)
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

pub type SearchEntryMode {
  SearchEntryModeMatch
  SearchEntryModeInclude
  SearchEntryModeOutcome
}

pub const search_entry_mode: List(SearchEntryMode) = [
  SearchEntryModeMatch,
  SearchEntryModeInclude,
  SearchEntryModeOutcome,
]

pub fn search_entry_mode_to_json(search_entry_mode: SearchEntryMode) -> Json {
  json.string(search_entry_mode_to_code(search_entry_mode))
}

pub fn search_entry_mode_to_code(search_entry_mode: SearchEntryMode) -> String {
  case search_entry_mode {
    SearchEntryModeMatch -> "match"
    SearchEntryModeInclude -> "include"
    SearchEntryModeOutcome -> "outcome"
  }
}

pub fn search_entry_mode_parse_code(
  code: String,
) -> Result(SearchEntryMode, Nil) {
  case code {
    "match" -> Ok(SearchEntryModeMatch)
    "include" -> Ok(SearchEntryModeInclude)
    "outcome" -> Ok(SearchEntryModeOutcome)
    _ -> Error(Nil)
  }
}

pub fn search_entry_mode_decoder() -> Decoder(SearchEntryMode) {
  use variant <- decode.then(decode.string)
  case variant {
    "match" -> decode.success(SearchEntryModeMatch)
    "include" -> decode.success(SearchEntryModeInclude)
    "outcome" -> decode.success(SearchEntryModeOutcome)
    _ ->
      decode.failure(
        SearchEntryModeMatch,
        "code from valueset SearchEntryMode ["
          <> {
          search_entry_mode
          |> list.map(search_entry_mode_to_code)
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

pub type SortDirection {
  SortDirectionAscending
  SortDirectionDescending
}

pub const sort_direction: List(SortDirection) = [
  SortDirectionAscending,
  SortDirectionDescending,
]

pub fn sort_direction_to_json(sort_direction: SortDirection) -> Json {
  json.string(sort_direction_to_code(sort_direction))
}

pub fn sort_direction_to_code(sort_direction: SortDirection) -> String {
  case sort_direction {
    SortDirectionAscending -> "ascending"
    SortDirectionDescending -> "descending"
  }
}

pub fn sort_direction_parse_code(code: String) -> Result(SortDirection, Nil) {
  case code {
    "ascending" -> Ok(SortDirectionAscending)
    "descending" -> Ok(SortDirectionDescending)
    _ -> Error(Nil)
  }
}

pub fn sort_direction_decoder() -> Decoder(SortDirection) {
  use variant <- decode.then(decode.string)
  case variant {
    "ascending" -> decode.success(SortDirectionAscending)
    "descending" -> decode.success(SortDirectionDescending)
    _ ->
      decode.failure(
        SortDirectionAscending,
        "code from valueset SortDirection ["
          <> {
          sort_direction
          |> list.map(sort_direction_to_code)
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

pub type TriggerType {
  TriggerTypeNamedevent
  TriggerTypePeriodic
  TriggerTypeDatachanged
  TriggerTypeDataadded
  TriggerTypeDatamodified
  TriggerTypeDataremoved
  TriggerTypeDataaccessed
  TriggerTypeDataaccessended
}

pub const trigger_type: List(TriggerType) = [
  TriggerTypeNamedevent,
  TriggerTypePeriodic,
  TriggerTypeDatachanged,
  TriggerTypeDataadded,
  TriggerTypeDatamodified,
  TriggerTypeDataremoved,
  TriggerTypeDataaccessed,
  TriggerTypeDataaccessended,
]

pub fn trigger_type_to_json(trigger_type: TriggerType) -> Json {
  json.string(trigger_type_to_code(trigger_type))
}

pub fn trigger_type_to_code(trigger_type: TriggerType) -> String {
  case trigger_type {
    TriggerTypeNamedevent -> "named-event"
    TriggerTypePeriodic -> "periodic"
    TriggerTypeDatachanged -> "data-changed"
    TriggerTypeDataadded -> "data-added"
    TriggerTypeDatamodified -> "data-modified"
    TriggerTypeDataremoved -> "data-removed"
    TriggerTypeDataaccessed -> "data-accessed"
    TriggerTypeDataaccessended -> "data-access-ended"
  }
}

pub fn trigger_type_parse_code(code: String) -> Result(TriggerType, Nil) {
  case code {
    "named-event" -> Ok(TriggerTypeNamedevent)
    "periodic" -> Ok(TriggerTypePeriodic)
    "data-changed" -> Ok(TriggerTypeDatachanged)
    "data-added" -> Ok(TriggerTypeDataadded)
    "data-modified" -> Ok(TriggerTypeDatamodified)
    "data-removed" -> Ok(TriggerTypeDataremoved)
    "data-accessed" -> Ok(TriggerTypeDataaccessed)
    "data-access-ended" -> Ok(TriggerTypeDataaccessended)
    _ -> Error(Nil)
  }
}

pub fn trigger_type_decoder() -> Decoder(TriggerType) {
  use variant <- decode.then(decode.string)
  case variant {
    "named-event" -> decode.success(TriggerTypeNamedevent)
    "periodic" -> decode.success(TriggerTypePeriodic)
    "data-changed" -> decode.success(TriggerTypeDatachanged)
    "data-added" -> decode.success(TriggerTypeDataadded)
    "data-modified" -> decode.success(TriggerTypeDatamodified)
    "data-removed" -> decode.success(TriggerTypeDataremoved)
    "data-accessed" -> decode.success(TriggerTypeDataaccessed)
    "data-access-ended" -> decode.success(TriggerTypeDataaccessended)
    _ ->
      decode.failure(
        TriggerTypeNamedevent,
        "code from valueset TriggerType ["
          <> {
          trigger_type |> list.map(trigger_type_to_code) |> string.join(", ")
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

pub type UnitsOfTime {
  UnitsOfTimeS
  UnitsOfTimeMin
  UnitsOfTimeH
  UnitsOfTimeD
  UnitsOfTimeWk
  UnitsOfTimeMo
  UnitsOfTimeA
}

pub const units_of_time: List(UnitsOfTime) = [
  UnitsOfTimeS,
  UnitsOfTimeMin,
  UnitsOfTimeH,
  UnitsOfTimeD,
  UnitsOfTimeWk,
  UnitsOfTimeMo,
  UnitsOfTimeA,
]

pub fn units_of_time_to_json(units_of_time: UnitsOfTime) -> Json {
  json.string(units_of_time_to_code(units_of_time))
}

pub fn units_of_time_to_code(units_of_time: UnitsOfTime) -> String {
  case units_of_time {
    UnitsOfTimeS -> "s"
    UnitsOfTimeMin -> "min"
    UnitsOfTimeH -> "h"
    UnitsOfTimeD -> "d"
    UnitsOfTimeWk -> "wk"
    UnitsOfTimeMo -> "mo"
    UnitsOfTimeA -> "a"
  }
}

pub fn units_of_time_parse_code(code: String) -> Result(UnitsOfTime, Nil) {
  case code {
    "s" -> Ok(UnitsOfTimeS)
    "min" -> Ok(UnitsOfTimeMin)
    "h" -> Ok(UnitsOfTimeH)
    "d" -> Ok(UnitsOfTimeD)
    "wk" -> Ok(UnitsOfTimeWk)
    "mo" -> Ok(UnitsOfTimeMo)
    "a" -> Ok(UnitsOfTimeA)
    _ -> Error(Nil)
  }
}

pub fn units_of_time_decoder() -> Decoder(UnitsOfTime) {
  use variant <- decode.then(decode.string)
  case variant {
    "s" -> decode.success(UnitsOfTimeS)
    "min" -> decode.success(UnitsOfTimeMin)
    "h" -> decode.success(UnitsOfTimeH)
    "d" -> decode.success(UnitsOfTimeD)
    "wk" -> decode.success(UnitsOfTimeWk)
    "mo" -> decode.success(UnitsOfTimeMo)
    "a" -> decode.success(UnitsOfTimeA)
    _ ->
      decode.failure(
        UnitsOfTimeS,
        "code from valueset UnitsOfTime ["
          <> {
          units_of_time |> list.map(units_of_time_to_code) |> string.join(", ")
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
