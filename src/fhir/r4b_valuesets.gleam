////[https://hl7.org/fhir/r4b](https://hl7.org/fhir/r4b) valuesets

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

pub type Variabletype {
  VariabletypeDichotomous
  VariabletypeContinuous
  VariabletypeDescriptive
}

pub fn variabletype_to_json(variabletype: Variabletype) -> Json {
  json.string(variabletype_to_string(variabletype))
}

pub fn variabletype_to_string(variabletype: Variabletype) -> String {
  case variabletype {
    VariabletypeDichotomous -> "dichotomous"
    VariabletypeContinuous -> "continuous"
    VariabletypeDescriptive -> "descriptive"
  }
}

pub fn variabletype_from_string(s: String) -> Result(Variabletype, Nil) {
  case s {
    "dichotomous" -> Ok(VariabletypeDichotomous)
    "continuous" -> Ok(VariabletypeContinuous)
    "descriptive" -> Ok(VariabletypeDescriptive)
    _ -> Error(Nil)
  }
}

pub fn variabletype_decoder() -> Decoder(Variabletype) {
  use variant <- decode.then(decode.string)
  case variant {
    "dichotomous" -> decode.success(VariabletypeDichotomous)
    "continuous" -> decode.success(VariabletypeContinuous)
    "descriptive" -> decode.success(VariabletypeDescriptive)
    _ -> decode.failure(VariabletypeDichotomous, "Variabletype")
  }
}

pub type Relationtype {
  RelationtypeTriggers
  RelationtypeIsreplacedby
}

pub fn relationtype_to_json(relationtype: Relationtype) -> Json {
  json.string(relationtype_to_string(relationtype))
}

pub fn relationtype_to_string(relationtype: Relationtype) -> String {
  case relationtype {
    RelationtypeTriggers -> "triggers"
    RelationtypeIsreplacedby -> "is-replaced-by"
  }
}

pub fn relationtype_from_string(s: String) -> Result(Relationtype, Nil) {
  case s {
    "triggers" -> Ok(RelationtypeTriggers)
    "is-replaced-by" -> Ok(RelationtypeIsreplacedby)
    _ -> Error(Nil)
  }
}

pub fn relationtype_decoder() -> Decoder(Relationtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "triggers" -> decode.success(RelationtypeTriggers)
    "is-replaced-by" -> decode.success(RelationtypeIsreplacedby)
    _ -> decode.failure(RelationtypeTriggers, "Relationtype")
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

pub type Quantitycomparator {
  QuantitycomparatorLessthan
  QuantitycomparatorLessthanequal
  QuantitycomparatorGreaterthanequal
  QuantitycomparatorGreaterthan
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
    _ -> decode.failure(QuantitycomparatorLessthan, "Quantitycomparator")
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

pub type Characteristiccombination {
  CharacteristiccombinationIntersection
  CharacteristiccombinationUnion
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
    CharacteristiccombinationIntersection -> "intersection"
    CharacteristiccombinationUnion -> "union"
  }
}

pub fn characteristiccombination_from_string(
  s: String,
) -> Result(Characteristiccombination, Nil) {
  case s {
    "intersection" -> Ok(CharacteristiccombinationIntersection)
    "union" -> Ok(CharacteristiccombinationUnion)
    _ -> Error(Nil)
  }
}

pub fn characteristiccombination_decoder() -> Decoder(Characteristiccombination) {
  use variant <- decode.then(decode.string)
  case variant {
    "intersection" -> decode.success(CharacteristiccombinationIntersection)
    "union" -> decode.success(CharacteristiccombinationUnion)
    _ ->
      decode.failure(
        CharacteristiccombinationIntersection,
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

pub fn researchstudystatus_to_json(
  researchstudystatus: Researchstudystatus,
) -> Json {
  json.string(researchstudystatus_to_string(researchstudystatus))
}

pub fn researchstudystatus_to_string(
  researchstudystatus: Researchstudystatus,
) -> String {
  case researchstudystatus {
    ResearchstudystatusActive -> "active"
    ResearchstudystatusAdministrativelycompleted -> "administratively-completed"
    ResearchstudystatusApproved -> "approved"
    ResearchstudystatusClosedtoaccrual -> "closed-to-accrual"
    ResearchstudystatusClosedtoaccrualandintervention ->
      "closed-to-accrual-and-intervention"
    ResearchstudystatusCompleted -> "completed"
    ResearchstudystatusDisapproved -> "disapproved"
    ResearchstudystatusInreview -> "in-review"
    ResearchstudystatusTemporarilyclosedtoaccrual ->
      "temporarily-closed-to-accrual"
    ResearchstudystatusTemporarilyclosedtoaccrualandintervention ->
      "temporarily-closed-to-accrual-and-intervention"
    ResearchstudystatusWithdrawn -> "withdrawn"
  }
}

pub fn researchstudystatus_from_string(
  s: String,
) -> Result(Researchstudystatus, Nil) {
  case s {
    "active" -> Ok(ResearchstudystatusActive)
    "administratively-completed" ->
      Ok(ResearchstudystatusAdministrativelycompleted)
    "approved" -> Ok(ResearchstudystatusApproved)
    "closed-to-accrual" -> Ok(ResearchstudystatusClosedtoaccrual)
    "closed-to-accrual-and-intervention" ->
      Ok(ResearchstudystatusClosedtoaccrualandintervention)
    "completed" -> Ok(ResearchstudystatusCompleted)
    "disapproved" -> Ok(ResearchstudystatusDisapproved)
    "in-review" -> Ok(ResearchstudystatusInreview)
    "temporarily-closed-to-accrual" ->
      Ok(ResearchstudystatusTemporarilyclosedtoaccrual)
    "temporarily-closed-to-accrual-and-intervention" ->
      Ok(ResearchstudystatusTemporarilyclosedtoaccrualandintervention)
    "withdrawn" -> Ok(ResearchstudystatusWithdrawn)
    _ -> Error(Nil)
  }
}

pub fn researchstudystatus_decoder() -> Decoder(Researchstudystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(ResearchstudystatusActive)
    "administratively-completed" ->
      decode.success(ResearchstudystatusAdministrativelycompleted)
    "approved" -> decode.success(ResearchstudystatusApproved)
    "closed-to-accrual" -> decode.success(ResearchstudystatusClosedtoaccrual)
    "closed-to-accrual-and-intervention" ->
      decode.success(ResearchstudystatusClosedtoaccrualandintervention)
    "completed" -> decode.success(ResearchstudystatusCompleted)
    "disapproved" -> decode.success(ResearchstudystatusDisapproved)
    "in-review" -> decode.success(ResearchstudystatusInreview)
    "temporarily-closed-to-accrual" ->
      decode.success(ResearchstudystatusTemporarilyclosedtoaccrual)
    "temporarily-closed-to-accrual-and-intervention" ->
      decode.success(
        ResearchstudystatusTemporarilyclosedtoaccrualandintervention,
      )
    "withdrawn" -> decode.success(ResearchstudystatusWithdrawn)
    _ -> decode.failure(ResearchstudystatusActive, "Researchstudystatus")
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

pub type Searchxpathusage {
  SearchxpathusageNormal
  SearchxpathusagePhonetic
  SearchxpathusageNearby
  SearchxpathusageDistance
  SearchxpathusageOther
}

pub fn searchxpathusage_to_json(searchxpathusage: Searchxpathusage) -> Json {
  json.string(searchxpathusage_to_string(searchxpathusage))
}

pub fn searchxpathusage_to_string(searchxpathusage: Searchxpathusage) -> String {
  case searchxpathusage {
    SearchxpathusageNormal -> "normal"
    SearchxpathusagePhonetic -> "phonetic"
    SearchxpathusageNearby -> "nearby"
    SearchxpathusageDistance -> "distance"
    SearchxpathusageOther -> "other"
  }
}

pub fn searchxpathusage_from_string(s: String) -> Result(Searchxpathusage, Nil) {
  case s {
    "normal" -> Ok(SearchxpathusageNormal)
    "phonetic" -> Ok(SearchxpathusagePhonetic)
    "nearby" -> Ok(SearchxpathusageNearby)
    "distance" -> Ok(SearchxpathusageDistance)
    "other" -> Ok(SearchxpathusageOther)
    _ -> Error(Nil)
  }
}

pub fn searchxpathusage_decoder() -> Decoder(Searchxpathusage) {
  use variant <- decode.then(decode.string)
  case variant {
    "normal" -> decode.success(SearchxpathusageNormal)
    "phonetic" -> decode.success(SearchxpathusagePhonetic)
    "nearby" -> decode.success(SearchxpathusageNearby)
    "distance" -> decode.success(SearchxpathusageDistance)
    "other" -> decode.success(SearchxpathusageOther)
    _ -> decode.failure(SearchxpathusageNormal, "Searchxpathusage")
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

pub type Clinicalimpressionstatus {
  ClinicalimpressionstatusInprogress
  ClinicalimpressionstatusCompleted
  ClinicalimpressionstatusEnteredinerror
}

pub fn clinicalimpressionstatus_to_json(
  clinicalimpressionstatus: Clinicalimpressionstatus,
) -> Json {
  json.string(clinicalimpressionstatus_to_string(clinicalimpressionstatus))
}

pub fn clinicalimpressionstatus_to_string(
  clinicalimpressionstatus: Clinicalimpressionstatus,
) -> String {
  case clinicalimpressionstatus {
    ClinicalimpressionstatusInprogress -> "in-progress"
    ClinicalimpressionstatusCompleted -> "completed"
    ClinicalimpressionstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn clinicalimpressionstatus_from_string(
  s: String,
) -> Result(Clinicalimpressionstatus, Nil) {
  case s {
    "in-progress" -> Ok(ClinicalimpressionstatusInprogress)
    "completed" -> Ok(ClinicalimpressionstatusCompleted)
    "entered-in-error" -> Ok(ClinicalimpressionstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn clinicalimpressionstatus_decoder() -> Decoder(Clinicalimpressionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "in-progress" -> decode.success(ClinicalimpressionstatusInprogress)
    "completed" -> decode.success(ClinicalimpressionstatusCompleted)
    "entered-in-error" -> decode.success(ClinicalimpressionstatusEnteredinerror)
    _ ->
      decode.failure(
        ClinicalimpressionstatusInprogress,
        "Clinicalimpressionstatus",
      )
  }
}

pub type Compositionstatus {
  CompositionstatusPreliminary
  CompositionstatusFinal
  CompositionstatusAmended
  CompositionstatusEnteredinerror
}

pub fn compositionstatus_to_json(compositionstatus: Compositionstatus) -> Json {
  json.string(compositionstatus_to_string(compositionstatus))
}

pub fn compositionstatus_to_string(
  compositionstatus: Compositionstatus,
) -> String {
  case compositionstatus {
    CompositionstatusPreliminary -> "preliminary"
    CompositionstatusFinal -> "final"
    CompositionstatusAmended -> "amended"
    CompositionstatusEnteredinerror -> "entered-in-error"
  }
}

pub fn compositionstatus_from_string(
  s: String,
) -> Result(Compositionstatus, Nil) {
  case s {
    "preliminary" -> Ok(CompositionstatusPreliminary)
    "final" -> Ok(CompositionstatusFinal)
    "amended" -> Ok(CompositionstatusAmended)
    "entered-in-error" -> Ok(CompositionstatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn compositionstatus_decoder() -> Decoder(Compositionstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "preliminary" -> decode.success(CompositionstatusPreliminary)
    "final" -> decode.success(CompositionstatusFinal)
    "amended" -> decode.success(CompositionstatusAmended)
    "entered-in-error" -> decode.success(CompositionstatusEnteredinerror)
    _ -> decode.failure(CompositionstatusPreliminary, "Compositionstatus")
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

pub type Resourcetypes {
  ResourcetypesResource
  ResourcetypesBinary
  ResourcetypesBundle
  ResourcetypesDomainresource
  ResourcetypesAccount
  ResourcetypesActivitydefinition
  ResourcetypesAdministrableproductdefinition
  ResourcetypesAdverseevent
  ResourcetypesAllergyintolerance
  ResourcetypesAppointment
  ResourcetypesAppointmentresponse
  ResourcetypesAuditevent
  ResourcetypesBasic
  ResourcetypesBiologicallyderivedproduct
  ResourcetypesBodystructure
  ResourcetypesCapabilitystatement
  ResourcetypesCareplan
  ResourcetypesCareteam
  ResourcetypesCatalogentry
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
  ResourcetypesConsent
  ResourcetypesContract
  ResourcetypesCoverage
  ResourcetypesCoverageeligibilityrequest
  ResourcetypesCoverageeligibilityresponse
  ResourcetypesDetectedissue
  ResourcetypesDevice
  ResourcetypesDevicedefinition
  ResourcetypesDevicemetric
  ResourcetypesDevicerequest
  ResourcetypesDeviceusestatement
  ResourcetypesDiagnosticreport
  ResourcetypesDocumentmanifest
  ResourcetypesDocumentreference
  ResourcetypesEncounter
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
  ResourcetypesGoal
  ResourcetypesGraphdefinition
  ResourcetypesGroup
  ResourcetypesGuidanceresponse
  ResourcetypesHealthcareservice
  ResourcetypesImagingstudy
  ResourcetypesImmunization
  ResourcetypesImmunizationevaluation
  ResourcetypesImmunizationrecommendation
  ResourcetypesImplementationguide
  ResourcetypesIngredient
  ResourcetypesInsuranceplan
  ResourcetypesInvoice
  ResourcetypesLibrary
  ResourcetypesLinkage
  ResourcetypesList
  ResourcetypesLocation
  ResourcetypesManufactureditemdefinition
  ResourcetypesMeasure
  ResourcetypesMeasurereport
  ResourcetypesMedia
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
  ResourcetypesNutritionorder
  ResourcetypesNutritionproduct
  ResourcetypesObservation
  ResourcetypesObservationdefinition
  ResourcetypesOperationdefinition
  ResourcetypesOperationoutcome
  ResourcetypesOrganization
  ResourcetypesOrganizationaffiliation
  ResourcetypesPackagedproductdefinition
  ResourcetypesPatient
  ResourcetypesPaymentnotice
  ResourcetypesPaymentreconciliation
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
  ResourcetypesRequestgroup
  ResourcetypesResearchdefinition
  ResourcetypesResearchelementdefinition
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
  ResourcetypesSupplydelivery
  ResourcetypesSupplyrequest
  ResourcetypesTask
  ResourcetypesTerminologycapabilities
  ResourcetypesTestreport
  ResourcetypesTestscript
  ResourcetypesValueset
  ResourcetypesVerificationresult
  ResourcetypesVisionprescription
  ResourcetypesParameters
}

pub fn resourcetypes_to_json(resourcetypes: Resourcetypes) -> Json {
  json.string(resourcetypes_to_string(resourcetypes))
}

pub fn resourcetypes_to_string(resourcetypes: Resourcetypes) -> String {
  case resourcetypes {
    ResourcetypesResource -> "Resource"
    ResourcetypesBinary -> "Binary"
    ResourcetypesBundle -> "Bundle"
    ResourcetypesDomainresource -> "DomainResource"
    ResourcetypesAccount -> "Account"
    ResourcetypesActivitydefinition -> "ActivityDefinition"
    ResourcetypesAdministrableproductdefinition ->
      "AdministrableProductDefinition"
    ResourcetypesAdverseevent -> "AdverseEvent"
    ResourcetypesAllergyintolerance -> "AllergyIntolerance"
    ResourcetypesAppointment -> "Appointment"
    ResourcetypesAppointmentresponse -> "AppointmentResponse"
    ResourcetypesAuditevent -> "AuditEvent"
    ResourcetypesBasic -> "Basic"
    ResourcetypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    ResourcetypesBodystructure -> "BodyStructure"
    ResourcetypesCapabilitystatement -> "CapabilityStatement"
    ResourcetypesCareplan -> "CarePlan"
    ResourcetypesCareteam -> "CareTeam"
    ResourcetypesCatalogentry -> "CatalogEntry"
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
    ResourcetypesConsent -> "Consent"
    ResourcetypesContract -> "Contract"
    ResourcetypesCoverage -> "Coverage"
    ResourcetypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    ResourcetypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    ResourcetypesDetectedissue -> "DetectedIssue"
    ResourcetypesDevice -> "Device"
    ResourcetypesDevicedefinition -> "DeviceDefinition"
    ResourcetypesDevicemetric -> "DeviceMetric"
    ResourcetypesDevicerequest -> "DeviceRequest"
    ResourcetypesDeviceusestatement -> "DeviceUseStatement"
    ResourcetypesDiagnosticreport -> "DiagnosticReport"
    ResourcetypesDocumentmanifest -> "DocumentManifest"
    ResourcetypesDocumentreference -> "DocumentReference"
    ResourcetypesEncounter -> "Encounter"
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
    ResourcetypesGoal -> "Goal"
    ResourcetypesGraphdefinition -> "GraphDefinition"
    ResourcetypesGroup -> "Group"
    ResourcetypesGuidanceresponse -> "GuidanceResponse"
    ResourcetypesHealthcareservice -> "HealthcareService"
    ResourcetypesImagingstudy -> "ImagingStudy"
    ResourcetypesImmunization -> "Immunization"
    ResourcetypesImmunizationevaluation -> "ImmunizationEvaluation"
    ResourcetypesImmunizationrecommendation -> "ImmunizationRecommendation"
    ResourcetypesImplementationguide -> "ImplementationGuide"
    ResourcetypesIngredient -> "Ingredient"
    ResourcetypesInsuranceplan -> "InsurancePlan"
    ResourcetypesInvoice -> "Invoice"
    ResourcetypesLibrary -> "Library"
    ResourcetypesLinkage -> "Linkage"
    ResourcetypesList -> "List"
    ResourcetypesLocation -> "Location"
    ResourcetypesManufactureditemdefinition -> "ManufacturedItemDefinition"
    ResourcetypesMeasure -> "Measure"
    ResourcetypesMeasurereport -> "MeasureReport"
    ResourcetypesMedia -> "Media"
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
    ResourcetypesNutritionorder -> "NutritionOrder"
    ResourcetypesNutritionproduct -> "NutritionProduct"
    ResourcetypesObservation -> "Observation"
    ResourcetypesObservationdefinition -> "ObservationDefinition"
    ResourcetypesOperationdefinition -> "OperationDefinition"
    ResourcetypesOperationoutcome -> "OperationOutcome"
    ResourcetypesOrganization -> "Organization"
    ResourcetypesOrganizationaffiliation -> "OrganizationAffiliation"
    ResourcetypesPackagedproductdefinition -> "PackagedProductDefinition"
    ResourcetypesPatient -> "Patient"
    ResourcetypesPaymentnotice -> "PaymentNotice"
    ResourcetypesPaymentreconciliation -> "PaymentReconciliation"
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
    ResourcetypesRequestgroup -> "RequestGroup"
    ResourcetypesResearchdefinition -> "ResearchDefinition"
    ResourcetypesResearchelementdefinition -> "ResearchElementDefinition"
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
    ResourcetypesSupplydelivery -> "SupplyDelivery"
    ResourcetypesSupplyrequest -> "SupplyRequest"
    ResourcetypesTask -> "Task"
    ResourcetypesTerminologycapabilities -> "TerminologyCapabilities"
    ResourcetypesTestreport -> "TestReport"
    ResourcetypesTestscript -> "TestScript"
    ResourcetypesValueset -> "ValueSet"
    ResourcetypesVerificationresult -> "VerificationResult"
    ResourcetypesVisionprescription -> "VisionPrescription"
    ResourcetypesParameters -> "Parameters"
  }
}

pub fn resourcetypes_from_string(s: String) -> Result(Resourcetypes, Nil) {
  case s {
    "Resource" -> Ok(ResourcetypesResource)
    "Binary" -> Ok(ResourcetypesBinary)
    "Bundle" -> Ok(ResourcetypesBundle)
    "DomainResource" -> Ok(ResourcetypesDomainresource)
    "Account" -> Ok(ResourcetypesAccount)
    "ActivityDefinition" -> Ok(ResourcetypesActivitydefinition)
    "AdministrableProductDefinition" ->
      Ok(ResourcetypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(ResourcetypesAdverseevent)
    "AllergyIntolerance" -> Ok(ResourcetypesAllergyintolerance)
    "Appointment" -> Ok(ResourcetypesAppointment)
    "AppointmentResponse" -> Ok(ResourcetypesAppointmentresponse)
    "AuditEvent" -> Ok(ResourcetypesAuditevent)
    "Basic" -> Ok(ResourcetypesBasic)
    "BiologicallyDerivedProduct" -> Ok(ResourcetypesBiologicallyderivedproduct)
    "BodyStructure" -> Ok(ResourcetypesBodystructure)
    "CapabilityStatement" -> Ok(ResourcetypesCapabilitystatement)
    "CarePlan" -> Ok(ResourcetypesCareplan)
    "CareTeam" -> Ok(ResourcetypesCareteam)
    "CatalogEntry" -> Ok(ResourcetypesCatalogentry)
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
    "Consent" -> Ok(ResourcetypesConsent)
    "Contract" -> Ok(ResourcetypesContract)
    "Coverage" -> Ok(ResourcetypesCoverage)
    "CoverageEligibilityRequest" -> Ok(ResourcetypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      Ok(ResourcetypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(ResourcetypesDetectedissue)
    "Device" -> Ok(ResourcetypesDevice)
    "DeviceDefinition" -> Ok(ResourcetypesDevicedefinition)
    "DeviceMetric" -> Ok(ResourcetypesDevicemetric)
    "DeviceRequest" -> Ok(ResourcetypesDevicerequest)
    "DeviceUseStatement" -> Ok(ResourcetypesDeviceusestatement)
    "DiagnosticReport" -> Ok(ResourcetypesDiagnosticreport)
    "DocumentManifest" -> Ok(ResourcetypesDocumentmanifest)
    "DocumentReference" -> Ok(ResourcetypesDocumentreference)
    "Encounter" -> Ok(ResourcetypesEncounter)
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
    "Goal" -> Ok(ResourcetypesGoal)
    "GraphDefinition" -> Ok(ResourcetypesGraphdefinition)
    "Group" -> Ok(ResourcetypesGroup)
    "GuidanceResponse" -> Ok(ResourcetypesGuidanceresponse)
    "HealthcareService" -> Ok(ResourcetypesHealthcareservice)
    "ImagingStudy" -> Ok(ResourcetypesImagingstudy)
    "Immunization" -> Ok(ResourcetypesImmunization)
    "ImmunizationEvaluation" -> Ok(ResourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(ResourcetypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(ResourcetypesImplementationguide)
    "Ingredient" -> Ok(ResourcetypesIngredient)
    "InsurancePlan" -> Ok(ResourcetypesInsuranceplan)
    "Invoice" -> Ok(ResourcetypesInvoice)
    "Library" -> Ok(ResourcetypesLibrary)
    "Linkage" -> Ok(ResourcetypesLinkage)
    "List" -> Ok(ResourcetypesList)
    "Location" -> Ok(ResourcetypesLocation)
    "ManufacturedItemDefinition" -> Ok(ResourcetypesManufactureditemdefinition)
    "Measure" -> Ok(ResourcetypesMeasure)
    "MeasureReport" -> Ok(ResourcetypesMeasurereport)
    "Media" -> Ok(ResourcetypesMedia)
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
    "NutritionOrder" -> Ok(ResourcetypesNutritionorder)
    "NutritionProduct" -> Ok(ResourcetypesNutritionproduct)
    "Observation" -> Ok(ResourcetypesObservation)
    "ObservationDefinition" -> Ok(ResourcetypesObservationdefinition)
    "OperationDefinition" -> Ok(ResourcetypesOperationdefinition)
    "OperationOutcome" -> Ok(ResourcetypesOperationoutcome)
    "Organization" -> Ok(ResourcetypesOrganization)
    "OrganizationAffiliation" -> Ok(ResourcetypesOrganizationaffiliation)
    "PackagedProductDefinition" -> Ok(ResourcetypesPackagedproductdefinition)
    "Patient" -> Ok(ResourcetypesPatient)
    "PaymentNotice" -> Ok(ResourcetypesPaymentnotice)
    "PaymentReconciliation" -> Ok(ResourcetypesPaymentreconciliation)
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
    "RequestGroup" -> Ok(ResourcetypesRequestgroup)
    "ResearchDefinition" -> Ok(ResourcetypesResearchdefinition)
    "ResearchElementDefinition" -> Ok(ResourcetypesResearchelementdefinition)
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
    "SupplyDelivery" -> Ok(ResourcetypesSupplydelivery)
    "SupplyRequest" -> Ok(ResourcetypesSupplyrequest)
    "Task" -> Ok(ResourcetypesTask)
    "TerminologyCapabilities" -> Ok(ResourcetypesTerminologycapabilities)
    "TestReport" -> Ok(ResourcetypesTestreport)
    "TestScript" -> Ok(ResourcetypesTestscript)
    "ValueSet" -> Ok(ResourcetypesValueset)
    "VerificationResult" -> Ok(ResourcetypesVerificationresult)
    "VisionPrescription" -> Ok(ResourcetypesVisionprescription)
    "Parameters" -> Ok(ResourcetypesParameters)
    _ -> Error(Nil)
  }
}

pub fn resourcetypes_decoder() -> Decoder(Resourcetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Resource" -> decode.success(ResourcetypesResource)
    "Binary" -> decode.success(ResourcetypesBinary)
    "Bundle" -> decode.success(ResourcetypesBundle)
    "DomainResource" -> decode.success(ResourcetypesDomainresource)
    "Account" -> decode.success(ResourcetypesAccount)
    "ActivityDefinition" -> decode.success(ResourcetypesActivitydefinition)
    "AdministrableProductDefinition" ->
      decode.success(ResourcetypesAdministrableproductdefinition)
    "AdverseEvent" -> decode.success(ResourcetypesAdverseevent)
    "AllergyIntolerance" -> decode.success(ResourcetypesAllergyintolerance)
    "Appointment" -> decode.success(ResourcetypesAppointment)
    "AppointmentResponse" -> decode.success(ResourcetypesAppointmentresponse)
    "AuditEvent" -> decode.success(ResourcetypesAuditevent)
    "Basic" -> decode.success(ResourcetypesBasic)
    "BiologicallyDerivedProduct" ->
      decode.success(ResourcetypesBiologicallyderivedproduct)
    "BodyStructure" -> decode.success(ResourcetypesBodystructure)
    "CapabilityStatement" -> decode.success(ResourcetypesCapabilitystatement)
    "CarePlan" -> decode.success(ResourcetypesCareplan)
    "CareTeam" -> decode.success(ResourcetypesCareteam)
    "CatalogEntry" -> decode.success(ResourcetypesCatalogentry)
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
    "Consent" -> decode.success(ResourcetypesConsent)
    "Contract" -> decode.success(ResourcetypesContract)
    "Coverage" -> decode.success(ResourcetypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(ResourcetypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(ResourcetypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(ResourcetypesDetectedissue)
    "Device" -> decode.success(ResourcetypesDevice)
    "DeviceDefinition" -> decode.success(ResourcetypesDevicedefinition)
    "DeviceMetric" -> decode.success(ResourcetypesDevicemetric)
    "DeviceRequest" -> decode.success(ResourcetypesDevicerequest)
    "DeviceUseStatement" -> decode.success(ResourcetypesDeviceusestatement)
    "DiagnosticReport" -> decode.success(ResourcetypesDiagnosticreport)
    "DocumentManifest" -> decode.success(ResourcetypesDocumentmanifest)
    "DocumentReference" -> decode.success(ResourcetypesDocumentreference)
    "Encounter" -> decode.success(ResourcetypesEncounter)
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
    "Goal" -> decode.success(ResourcetypesGoal)
    "GraphDefinition" -> decode.success(ResourcetypesGraphdefinition)
    "Group" -> decode.success(ResourcetypesGroup)
    "GuidanceResponse" -> decode.success(ResourcetypesGuidanceresponse)
    "HealthcareService" -> decode.success(ResourcetypesHealthcareservice)
    "ImagingStudy" -> decode.success(ResourcetypesImagingstudy)
    "Immunization" -> decode.success(ResourcetypesImmunization)
    "ImmunizationEvaluation" ->
      decode.success(ResourcetypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(ResourcetypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(ResourcetypesImplementationguide)
    "Ingredient" -> decode.success(ResourcetypesIngredient)
    "InsurancePlan" -> decode.success(ResourcetypesInsuranceplan)
    "Invoice" -> decode.success(ResourcetypesInvoice)
    "Library" -> decode.success(ResourcetypesLibrary)
    "Linkage" -> decode.success(ResourcetypesLinkage)
    "List" -> decode.success(ResourcetypesList)
    "Location" -> decode.success(ResourcetypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(ResourcetypesManufactureditemdefinition)
    "Measure" -> decode.success(ResourcetypesMeasure)
    "MeasureReport" -> decode.success(ResourcetypesMeasurereport)
    "Media" -> decode.success(ResourcetypesMedia)
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
    "Patient" -> decode.success(ResourcetypesPatient)
    "PaymentNotice" -> decode.success(ResourcetypesPaymentnotice)
    "PaymentReconciliation" ->
      decode.success(ResourcetypesPaymentreconciliation)
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
    "RequestGroup" -> decode.success(ResourcetypesRequestgroup)
    "ResearchDefinition" -> decode.success(ResourcetypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(ResourcetypesResearchelementdefinition)
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
    "SupplyDelivery" -> decode.success(ResourcetypesSupplydelivery)
    "SupplyRequest" -> decode.success(ResourcetypesSupplyrequest)
    "Task" -> decode.success(ResourcetypesTask)
    "TerminologyCapabilities" ->
      decode.success(ResourcetypesTerminologycapabilities)
    "TestReport" -> decode.success(ResourcetypesTestreport)
    "TestScript" -> decode.success(ResourcetypesTestscript)
    "ValueSet" -> decode.success(ResourcetypesValueset)
    "VerificationResult" -> decode.success(ResourcetypesVerificationresult)
    "VisionPrescription" -> decode.success(ResourcetypesVisionprescription)
    "Parameters" -> decode.success(ResourcetypesParameters)
    _ -> decode.failure(ResourcetypesResource, "Resourcetypes")
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

pub type Compartmenttype {
  CompartmenttypePatient
  CompartmenttypeEncounter
  CompartmenttypeRelatedperson
  CompartmenttypePractitioner
  CompartmenttypeDevice
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
  }
}

pub fn compartmenttype_from_string(s: String) -> Result(Compartmenttype, Nil) {
  case s {
    "Patient" -> Ok(CompartmenttypePatient)
    "Encounter" -> Ok(CompartmenttypeEncounter)
    "RelatedPerson" -> Ok(CompartmenttypeRelatedperson)
    "Practitioner" -> Ok(CompartmenttypePractitioner)
    "Device" -> Ok(CompartmenttypeDevice)
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
    _ -> decode.failure(CompartmenttypePatient, "Compartmenttype")
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
    _ -> decode.failure(IssuetypeInvalid, "Issuetype")
  }
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

pub fn assertresponsecodetypes_to_json(
  assertresponsecodetypes: Assertresponsecodetypes,
) -> Json {
  json.string(assertresponsecodetypes_to_string(assertresponsecodetypes))
}

pub fn assertresponsecodetypes_to_string(
  assertresponsecodetypes: Assertresponsecodetypes,
) -> String {
  case assertresponsecodetypes {
    AssertresponsecodetypesOkay -> "okay"
    AssertresponsecodetypesCreated -> "created"
    AssertresponsecodetypesNocontent -> "noContent"
    AssertresponsecodetypesNotmodified -> "notModified"
    AssertresponsecodetypesBad -> "bad"
    AssertresponsecodetypesForbidden -> "forbidden"
    AssertresponsecodetypesNotfound -> "notFound"
    AssertresponsecodetypesMethodnotallowed -> "methodNotAllowed"
    AssertresponsecodetypesConflict -> "conflict"
    AssertresponsecodetypesGone -> "gone"
    AssertresponsecodetypesPreconditionfailed -> "preconditionFailed"
    AssertresponsecodetypesUnprocessable -> "unprocessable"
  }
}

pub fn assertresponsecodetypes_from_string(
  s: String,
) -> Result(Assertresponsecodetypes, Nil) {
  case s {
    "okay" -> Ok(AssertresponsecodetypesOkay)
    "created" -> Ok(AssertresponsecodetypesCreated)
    "noContent" -> Ok(AssertresponsecodetypesNocontent)
    "notModified" -> Ok(AssertresponsecodetypesNotmodified)
    "bad" -> Ok(AssertresponsecodetypesBad)
    "forbidden" -> Ok(AssertresponsecodetypesForbidden)
    "notFound" -> Ok(AssertresponsecodetypesNotfound)
    "methodNotAllowed" -> Ok(AssertresponsecodetypesMethodnotallowed)
    "conflict" -> Ok(AssertresponsecodetypesConflict)
    "gone" -> Ok(AssertresponsecodetypesGone)
    "preconditionFailed" -> Ok(AssertresponsecodetypesPreconditionfailed)
    "unprocessable" -> Ok(AssertresponsecodetypesUnprocessable)
    _ -> Error(Nil)
  }
}

pub fn assertresponsecodetypes_decoder() -> Decoder(Assertresponsecodetypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "okay" -> decode.success(AssertresponsecodetypesOkay)
    "created" -> decode.success(AssertresponsecodetypesCreated)
    "noContent" -> decode.success(AssertresponsecodetypesNocontent)
    "notModified" -> decode.success(AssertresponsecodetypesNotmodified)
    "bad" -> decode.success(AssertresponsecodetypesBad)
    "forbidden" -> decode.success(AssertresponsecodetypesForbidden)
    "notFound" -> decode.success(AssertresponsecodetypesNotfound)
    "methodNotAllowed" ->
      decode.success(AssertresponsecodetypesMethodnotallowed)
    "conflict" -> decode.success(AssertresponsecodetypesConflict)
    "gone" -> decode.success(AssertresponsecodetypesGone)
    "preconditionFailed" ->
      decode.success(AssertresponsecodetypesPreconditionfailed)
    "unprocessable" -> decode.success(AssertresponsecodetypesUnprocessable)
    _ -> decode.failure(AssertresponsecodetypesOkay, "Assertresponsecodetypes")
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

pub type Allergyintolerancetype {
  AllergyintolerancetypeAllergy
  AllergyintolerancetypeIntolerance
}

pub fn allergyintolerancetype_to_json(
  allergyintolerancetype: Allergyintolerancetype,
) -> Json {
  json.string(allergyintolerancetype_to_string(allergyintolerancetype))
}

pub fn allergyintolerancetype_to_string(
  allergyintolerancetype: Allergyintolerancetype,
) -> String {
  case allergyintolerancetype {
    AllergyintolerancetypeAllergy -> "allergy"
    AllergyintolerancetypeIntolerance -> "intolerance"
  }
}

pub fn allergyintolerancetype_from_string(
  s: String,
) -> Result(Allergyintolerancetype, Nil) {
  case s {
    "allergy" -> Ok(AllergyintolerancetypeAllergy)
    "intolerance" -> Ok(AllergyintolerancetypeIntolerance)
    _ -> Error(Nil)
  }
}

pub fn allergyintolerancetype_decoder() -> Decoder(Allergyintolerancetype) {
  use variant <- decode.then(decode.string)
  case variant {
    "allergy" -> decode.success(AllergyintolerancetypeAllergy)
    "intolerance" -> decode.success(AllergyintolerancetypeIntolerance)
    _ -> decode.failure(AllergyintolerancetypeAllergy, "Allergyintolerancetype")
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

pub type Maptargetlistmode {
  MaptargetlistmodeFirst
  MaptargetlistmodeShare
  MaptargetlistmodeLast
  MaptargetlistmodeCollate
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
    MaptargetlistmodeCollate -> "collate"
  }
}

pub fn maptargetlistmode_from_string(
  s: String,
) -> Result(Maptargetlistmode, Nil) {
  case s {
    "first" -> Ok(MaptargetlistmodeFirst)
    "share" -> Ok(MaptargetlistmodeShare)
    "last" -> Ok(MaptargetlistmodeLast)
    "collate" -> Ok(MaptargetlistmodeCollate)
    _ -> Error(Nil)
  }
}

pub fn maptargetlistmode_decoder() -> Decoder(Maptargetlistmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "first" -> decode.success(MaptargetlistmodeFirst)
    "share" -> decode.success(MaptargetlistmodeShare)
    "last" -> decode.success(MaptargetlistmodeLast)
    "collate" -> decode.success(MaptargetlistmodeCollate)
    _ -> decode.failure(MaptargetlistmodeFirst, "Maptargetlistmode")
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
    _ -> decode.failure(FilteroperatorEqual, "Filteroperator")
  }
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
  json.string(fhirversion_to_string(fhirversion))
}

pub fn fhirversion_to_string(fhirversion: Fhirversion) -> String {
  case fhirversion {
    Fhirversion001 -> "0.01"
    Fhirversion005 -> "0.05"
    Fhirversion006 -> "0.06"
    Fhirversion011 -> "0.11"
    Fhirversion0080 -> "0.0.80"
    Fhirversion0081 -> "0.0.81"
    Fhirversion0082 -> "0.0.82"
    Fhirversion040 -> "0.4.0"
    Fhirversion050 -> "0.5.0"
    Fhirversion100 -> "1.0.0"
    Fhirversion101 -> "1.0.1"
    Fhirversion102 -> "1.0.2"
    Fhirversion110 -> "1.1.0"
    Fhirversion140 -> "1.4.0"
    Fhirversion160 -> "1.6.0"
    Fhirversion180 -> "1.8.0"
    Fhirversion300 -> "3.0.0"
    Fhirversion301 -> "3.0.1"
    Fhirversion302 -> "3.0.2"
    Fhirversion330 -> "3.3.0"
    Fhirversion350 -> "3.5.0"
    Fhirversion400 -> "4.0.0"
    Fhirversion401 -> "4.0.1"
    Fhirversion410 -> "4.1.0"
    Fhirversion430cibuild -> "4.3.0-cibuild"
    Fhirversion430snapshot1 -> "4.3.0-snapshot1"
    Fhirversion430 -> "4.3.0"
  }
}

pub fn fhirversion_from_string(s: String) -> Result(Fhirversion, Nil) {
  case s {
    "0.01" -> Ok(Fhirversion001)
    "0.05" -> Ok(Fhirversion005)
    "0.06" -> Ok(Fhirversion006)
    "0.11" -> Ok(Fhirversion011)
    "0.0.80" -> Ok(Fhirversion0080)
    "0.0.81" -> Ok(Fhirversion0081)
    "0.0.82" -> Ok(Fhirversion0082)
    "0.4.0" -> Ok(Fhirversion040)
    "0.5.0" -> Ok(Fhirversion050)
    "1.0.0" -> Ok(Fhirversion100)
    "1.0.1" -> Ok(Fhirversion101)
    "1.0.2" -> Ok(Fhirversion102)
    "1.1.0" -> Ok(Fhirversion110)
    "1.4.0" -> Ok(Fhirversion140)
    "1.6.0" -> Ok(Fhirversion160)
    "1.8.0" -> Ok(Fhirversion180)
    "3.0.0" -> Ok(Fhirversion300)
    "3.0.1" -> Ok(Fhirversion301)
    "3.0.2" -> Ok(Fhirversion302)
    "3.3.0" -> Ok(Fhirversion330)
    "3.5.0" -> Ok(Fhirversion350)
    "4.0.0" -> Ok(Fhirversion400)
    "4.0.1" -> Ok(Fhirversion401)
    "4.1.0" -> Ok(Fhirversion410)
    "4.3.0-cibuild" -> Ok(Fhirversion430cibuild)
    "4.3.0-snapshot1" -> Ok(Fhirversion430snapshot1)
    "4.3.0" -> Ok(Fhirversion430)
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
    _ -> decode.failure(Fhirversion001, "Fhirversion")
  }
}

pub type Medicationknowledgestatus {
  MedicationknowledgestatusActive
  MedicationknowledgestatusInactive
  MedicationknowledgestatusEnteredinerror
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
    MedicationknowledgestatusInactive -> "inactive"
    MedicationknowledgestatusEnteredinerror -> "entered-in-error"
  }
}

pub fn medicationknowledgestatus_from_string(
  s: String,
) -> Result(Medicationknowledgestatus, Nil) {
  case s {
    "active" -> Ok(MedicationknowledgestatusActive)
    "inactive" -> Ok(MedicationknowledgestatusInactive)
    "entered-in-error" -> Ok(MedicationknowledgestatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn medicationknowledgestatus_decoder() -> Decoder(Medicationknowledgestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(MedicationknowledgestatusActive)
    "inactive" -> decode.success(MedicationknowledgestatusInactive)
    "entered-in-error" ->
      decode.success(MedicationknowledgestatusEnteredinerror)
    _ ->
      decode.failure(
        MedicationknowledgestatusActive,
        "Medicationknowledgestatus",
      )
  }
}

pub type Grouptype {
  GrouptypePerson
  GrouptypeAnimal
  GrouptypePractitioner
  GrouptypeDevice
  GrouptypeMedication
  GrouptypeSubstance
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
    GrouptypeMedication -> "medication"
    GrouptypeSubstance -> "substance"
  }
}

pub fn grouptype_from_string(s: String) -> Result(Grouptype, Nil) {
  case s {
    "person" -> Ok(GrouptypePerson)
    "animal" -> Ok(GrouptypeAnimal)
    "practitioner" -> Ok(GrouptypePractitioner)
    "device" -> Ok(GrouptypeDevice)
    "medication" -> Ok(GrouptypeMedication)
    "substance" -> Ok(GrouptypeSubstance)
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
    "medication" -> decode.success(GrouptypeMedication)
    "substance" -> decode.success(GrouptypeSubstance)
    _ -> decode.failure(GrouptypePerson, "Grouptype")
  }
}

pub type Definedtypes {
  DefinedtypesAddress
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
  DefinedtypesBinary
  DefinedtypesBundle
  DefinedtypesDomainresource
  DefinedtypesAccount
  DefinedtypesActivitydefinition
  DefinedtypesAdministrableproductdefinition
  DefinedtypesAdverseevent
  DefinedtypesAllergyintolerance
  DefinedtypesAppointment
  DefinedtypesAppointmentresponse
  DefinedtypesAuditevent
  DefinedtypesBasic
  DefinedtypesBiologicallyderivedproduct
  DefinedtypesBodystructure
  DefinedtypesCapabilitystatement
  DefinedtypesCareplan
  DefinedtypesCareteam
  DefinedtypesCatalogentry
  DefinedtypesChargeitem
  DefinedtypesChargeitemdefinition
  DefinedtypesCitation
  DefinedtypesClaim
  DefinedtypesClaimresponse
  DefinedtypesClinicalimpression
  DefinedtypesClinicalusedefinition
  DefinedtypesCodesystem
  DefinedtypesCommunication
  DefinedtypesCommunicationrequest
  DefinedtypesCompartmentdefinition
  DefinedtypesComposition
  DefinedtypesConceptmap
  DefinedtypesCondition
  DefinedtypesConsent
  DefinedtypesContract
  DefinedtypesCoverage
  DefinedtypesCoverageeligibilityrequest
  DefinedtypesCoverageeligibilityresponse
  DefinedtypesDetectedissue
  DefinedtypesDevice
  DefinedtypesDevicedefinition
  DefinedtypesDevicemetric
  DefinedtypesDevicerequest
  DefinedtypesDeviceusestatement
  DefinedtypesDiagnosticreport
  DefinedtypesDocumentmanifest
  DefinedtypesDocumentreference
  DefinedtypesEncounter
  DefinedtypesEndpoint
  DefinedtypesEnrollmentrequest
  DefinedtypesEnrollmentresponse
  DefinedtypesEpisodeofcare
  DefinedtypesEventdefinition
  DefinedtypesEvidence
  DefinedtypesEvidencereport
  DefinedtypesEvidencevariable
  DefinedtypesExamplescenario
  DefinedtypesExplanationofbenefit
  DefinedtypesFamilymemberhistory
  DefinedtypesFlag
  DefinedtypesGoal
  DefinedtypesGraphdefinition
  DefinedtypesGroup
  DefinedtypesGuidanceresponse
  DefinedtypesHealthcareservice
  DefinedtypesImagingstudy
  DefinedtypesImmunization
  DefinedtypesImmunizationevaluation
  DefinedtypesImmunizationrecommendation
  DefinedtypesImplementationguide
  DefinedtypesIngredient
  DefinedtypesInsuranceplan
  DefinedtypesInvoice
  DefinedtypesLibrary
  DefinedtypesLinkage
  DefinedtypesList
  DefinedtypesLocation
  DefinedtypesManufactureditemdefinition
  DefinedtypesMeasure
  DefinedtypesMeasurereport
  DefinedtypesMedia
  DefinedtypesMedication
  DefinedtypesMedicationadministration
  DefinedtypesMedicationdispense
  DefinedtypesMedicationknowledge
  DefinedtypesMedicationrequest
  DefinedtypesMedicationstatement
  DefinedtypesMedicinalproductdefinition
  DefinedtypesMessagedefinition
  DefinedtypesMessageheader
  DefinedtypesMolecularsequence
  DefinedtypesNamingsystem
  DefinedtypesNutritionorder
  DefinedtypesNutritionproduct
  DefinedtypesObservation
  DefinedtypesObservationdefinition
  DefinedtypesOperationdefinition
  DefinedtypesOperationoutcome
  DefinedtypesOrganization
  DefinedtypesOrganizationaffiliation
  DefinedtypesPackagedproductdefinition
  DefinedtypesPatient
  DefinedtypesPaymentnotice
  DefinedtypesPaymentreconciliation
  DefinedtypesPerson
  DefinedtypesPlandefinition
  DefinedtypesPractitioner
  DefinedtypesPractitionerrole
  DefinedtypesProcedure
  DefinedtypesProvenance
  DefinedtypesQuestionnaire
  DefinedtypesQuestionnaireresponse
  DefinedtypesRegulatedauthorization
  DefinedtypesRelatedperson
  DefinedtypesRequestgroup
  DefinedtypesResearchdefinition
  DefinedtypesResearchelementdefinition
  DefinedtypesResearchstudy
  DefinedtypesResearchsubject
  DefinedtypesRiskassessment
  DefinedtypesSchedule
  DefinedtypesSearchparameter
  DefinedtypesServicerequest
  DefinedtypesSlot
  DefinedtypesSpecimen
  DefinedtypesSpecimendefinition
  DefinedtypesStructuredefinition
  DefinedtypesStructuremap
  DefinedtypesSubscription
  DefinedtypesSubscriptionstatus
  DefinedtypesSubscriptiontopic
  DefinedtypesSubstance
  DefinedtypesSubstancedefinition
  DefinedtypesSupplydelivery
  DefinedtypesSupplyrequest
  DefinedtypesTask
  DefinedtypesTerminologycapabilities
  DefinedtypesTestreport
  DefinedtypesTestscript
  DefinedtypesValueset
  DefinedtypesVerificationresult
  DefinedtypesVisionprescription
  DefinedtypesParameters
}

pub fn definedtypes_to_json(definedtypes: Definedtypes) -> Json {
  json.string(definedtypes_to_string(definedtypes))
}

pub fn definedtypes_to_string(definedtypes: Definedtypes) -> String {
  case definedtypes {
    DefinedtypesAddress -> "Address"
    DefinedtypesAge -> "Age"
    DefinedtypesAnnotation -> "Annotation"
    DefinedtypesAttachment -> "Attachment"
    DefinedtypesBackboneelement -> "BackboneElement"
    DefinedtypesCodeableconcept -> "CodeableConcept"
    DefinedtypesCodeablereference -> "CodeableReference"
    DefinedtypesCoding -> "Coding"
    DefinedtypesContactdetail -> "ContactDetail"
    DefinedtypesContactpoint -> "ContactPoint"
    DefinedtypesContributor -> "Contributor"
    DefinedtypesCount -> "Count"
    DefinedtypesDatarequirement -> "DataRequirement"
    DefinedtypesDistance -> "Distance"
    DefinedtypesDosage -> "Dosage"
    DefinedtypesDuration -> "Duration"
    DefinedtypesElement -> "Element"
    DefinedtypesElementdefinition -> "ElementDefinition"
    DefinedtypesExpression -> "Expression"
    DefinedtypesExtension -> "Extension"
    DefinedtypesHumanname -> "HumanName"
    DefinedtypesIdentifier -> "Identifier"
    DefinedtypesMarketingstatus -> "MarketingStatus"
    DefinedtypesMeta -> "Meta"
    DefinedtypesMoney -> "Money"
    DefinedtypesMoneyquantity -> "MoneyQuantity"
    DefinedtypesNarrative -> "Narrative"
    DefinedtypesParameterdefinition -> "ParameterDefinition"
    DefinedtypesPeriod -> "Period"
    DefinedtypesPopulation -> "Population"
    DefinedtypesProdcharacteristic -> "ProdCharacteristic"
    DefinedtypesProductshelflife -> "ProductShelfLife"
    DefinedtypesQuantity -> "Quantity"
    DefinedtypesRange -> "Range"
    DefinedtypesRatio -> "Ratio"
    DefinedtypesRatiorange -> "RatioRange"
    DefinedtypesReference -> "Reference"
    DefinedtypesRelatedartifact -> "RelatedArtifact"
    DefinedtypesSampleddata -> "SampledData"
    DefinedtypesSignature -> "Signature"
    DefinedtypesSimplequantity -> "SimpleQuantity"
    DefinedtypesTiming -> "Timing"
    DefinedtypesTriggerdefinition -> "TriggerDefinition"
    DefinedtypesUsagecontext -> "UsageContext"
    DefinedtypesBase64binary -> "base64Binary"
    DefinedtypesBoolean -> "boolean"
    DefinedtypesCanonical -> "canonical"
    DefinedtypesCode -> "code"
    DefinedtypesDate -> "date"
    DefinedtypesDatetime -> "dateTime"
    DefinedtypesDecimal -> "decimal"
    DefinedtypesId -> "id"
    DefinedtypesInstant -> "instant"
    DefinedtypesInteger -> "integer"
    DefinedtypesMarkdown -> "markdown"
    DefinedtypesOid -> "oid"
    DefinedtypesPositiveint -> "positiveInt"
    DefinedtypesString -> "string"
    DefinedtypesTime -> "time"
    DefinedtypesUnsignedint -> "unsignedInt"
    DefinedtypesUri -> "uri"
    DefinedtypesUrl -> "url"
    DefinedtypesUuid -> "uuid"
    DefinedtypesXhtml -> "xhtml"
    DefinedtypesResource -> "Resource"
    DefinedtypesBinary -> "Binary"
    DefinedtypesBundle -> "Bundle"
    DefinedtypesDomainresource -> "DomainResource"
    DefinedtypesAccount -> "Account"
    DefinedtypesActivitydefinition -> "ActivityDefinition"
    DefinedtypesAdministrableproductdefinition ->
      "AdministrableProductDefinition"
    DefinedtypesAdverseevent -> "AdverseEvent"
    DefinedtypesAllergyintolerance -> "AllergyIntolerance"
    DefinedtypesAppointment -> "Appointment"
    DefinedtypesAppointmentresponse -> "AppointmentResponse"
    DefinedtypesAuditevent -> "AuditEvent"
    DefinedtypesBasic -> "Basic"
    DefinedtypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    DefinedtypesBodystructure -> "BodyStructure"
    DefinedtypesCapabilitystatement -> "CapabilityStatement"
    DefinedtypesCareplan -> "CarePlan"
    DefinedtypesCareteam -> "CareTeam"
    DefinedtypesCatalogentry -> "CatalogEntry"
    DefinedtypesChargeitem -> "ChargeItem"
    DefinedtypesChargeitemdefinition -> "ChargeItemDefinition"
    DefinedtypesCitation -> "Citation"
    DefinedtypesClaim -> "Claim"
    DefinedtypesClaimresponse -> "ClaimResponse"
    DefinedtypesClinicalimpression -> "ClinicalImpression"
    DefinedtypesClinicalusedefinition -> "ClinicalUseDefinition"
    DefinedtypesCodesystem -> "CodeSystem"
    DefinedtypesCommunication -> "Communication"
    DefinedtypesCommunicationrequest -> "CommunicationRequest"
    DefinedtypesCompartmentdefinition -> "CompartmentDefinition"
    DefinedtypesComposition -> "Composition"
    DefinedtypesConceptmap -> "ConceptMap"
    DefinedtypesCondition -> "Condition"
    DefinedtypesConsent -> "Consent"
    DefinedtypesContract -> "Contract"
    DefinedtypesCoverage -> "Coverage"
    DefinedtypesCoverageeligibilityrequest -> "CoverageEligibilityRequest"
    DefinedtypesCoverageeligibilityresponse -> "CoverageEligibilityResponse"
    DefinedtypesDetectedissue -> "DetectedIssue"
    DefinedtypesDevice -> "Device"
    DefinedtypesDevicedefinition -> "DeviceDefinition"
    DefinedtypesDevicemetric -> "DeviceMetric"
    DefinedtypesDevicerequest -> "DeviceRequest"
    DefinedtypesDeviceusestatement -> "DeviceUseStatement"
    DefinedtypesDiagnosticreport -> "DiagnosticReport"
    DefinedtypesDocumentmanifest -> "DocumentManifest"
    DefinedtypesDocumentreference -> "DocumentReference"
    DefinedtypesEncounter -> "Encounter"
    DefinedtypesEndpoint -> "Endpoint"
    DefinedtypesEnrollmentrequest -> "EnrollmentRequest"
    DefinedtypesEnrollmentresponse -> "EnrollmentResponse"
    DefinedtypesEpisodeofcare -> "EpisodeOfCare"
    DefinedtypesEventdefinition -> "EventDefinition"
    DefinedtypesEvidence -> "Evidence"
    DefinedtypesEvidencereport -> "EvidenceReport"
    DefinedtypesEvidencevariable -> "EvidenceVariable"
    DefinedtypesExamplescenario -> "ExampleScenario"
    DefinedtypesExplanationofbenefit -> "ExplanationOfBenefit"
    DefinedtypesFamilymemberhistory -> "FamilyMemberHistory"
    DefinedtypesFlag -> "Flag"
    DefinedtypesGoal -> "Goal"
    DefinedtypesGraphdefinition -> "GraphDefinition"
    DefinedtypesGroup -> "Group"
    DefinedtypesGuidanceresponse -> "GuidanceResponse"
    DefinedtypesHealthcareservice -> "HealthcareService"
    DefinedtypesImagingstudy -> "ImagingStudy"
    DefinedtypesImmunization -> "Immunization"
    DefinedtypesImmunizationevaluation -> "ImmunizationEvaluation"
    DefinedtypesImmunizationrecommendation -> "ImmunizationRecommendation"
    DefinedtypesImplementationguide -> "ImplementationGuide"
    DefinedtypesIngredient -> "Ingredient"
    DefinedtypesInsuranceplan -> "InsurancePlan"
    DefinedtypesInvoice -> "Invoice"
    DefinedtypesLibrary -> "Library"
    DefinedtypesLinkage -> "Linkage"
    DefinedtypesList -> "List"
    DefinedtypesLocation -> "Location"
    DefinedtypesManufactureditemdefinition -> "ManufacturedItemDefinition"
    DefinedtypesMeasure -> "Measure"
    DefinedtypesMeasurereport -> "MeasureReport"
    DefinedtypesMedia -> "Media"
    DefinedtypesMedication -> "Medication"
    DefinedtypesMedicationadministration -> "MedicationAdministration"
    DefinedtypesMedicationdispense -> "MedicationDispense"
    DefinedtypesMedicationknowledge -> "MedicationKnowledge"
    DefinedtypesMedicationrequest -> "MedicationRequest"
    DefinedtypesMedicationstatement -> "MedicationStatement"
    DefinedtypesMedicinalproductdefinition -> "MedicinalProductDefinition"
    DefinedtypesMessagedefinition -> "MessageDefinition"
    DefinedtypesMessageheader -> "MessageHeader"
    DefinedtypesMolecularsequence -> "MolecularSequence"
    DefinedtypesNamingsystem -> "NamingSystem"
    DefinedtypesNutritionorder -> "NutritionOrder"
    DefinedtypesNutritionproduct -> "NutritionProduct"
    DefinedtypesObservation -> "Observation"
    DefinedtypesObservationdefinition -> "ObservationDefinition"
    DefinedtypesOperationdefinition -> "OperationDefinition"
    DefinedtypesOperationoutcome -> "OperationOutcome"
    DefinedtypesOrganization -> "Organization"
    DefinedtypesOrganizationaffiliation -> "OrganizationAffiliation"
    DefinedtypesPackagedproductdefinition -> "PackagedProductDefinition"
    DefinedtypesPatient -> "Patient"
    DefinedtypesPaymentnotice -> "PaymentNotice"
    DefinedtypesPaymentreconciliation -> "PaymentReconciliation"
    DefinedtypesPerson -> "Person"
    DefinedtypesPlandefinition -> "PlanDefinition"
    DefinedtypesPractitioner -> "Practitioner"
    DefinedtypesPractitionerrole -> "PractitionerRole"
    DefinedtypesProcedure -> "Procedure"
    DefinedtypesProvenance -> "Provenance"
    DefinedtypesQuestionnaire -> "Questionnaire"
    DefinedtypesQuestionnaireresponse -> "QuestionnaireResponse"
    DefinedtypesRegulatedauthorization -> "RegulatedAuthorization"
    DefinedtypesRelatedperson -> "RelatedPerson"
    DefinedtypesRequestgroup -> "RequestGroup"
    DefinedtypesResearchdefinition -> "ResearchDefinition"
    DefinedtypesResearchelementdefinition -> "ResearchElementDefinition"
    DefinedtypesResearchstudy -> "ResearchStudy"
    DefinedtypesResearchsubject -> "ResearchSubject"
    DefinedtypesRiskassessment -> "RiskAssessment"
    DefinedtypesSchedule -> "Schedule"
    DefinedtypesSearchparameter -> "SearchParameter"
    DefinedtypesServicerequest -> "ServiceRequest"
    DefinedtypesSlot -> "Slot"
    DefinedtypesSpecimen -> "Specimen"
    DefinedtypesSpecimendefinition -> "SpecimenDefinition"
    DefinedtypesStructuredefinition -> "StructureDefinition"
    DefinedtypesStructuremap -> "StructureMap"
    DefinedtypesSubscription -> "Subscription"
    DefinedtypesSubscriptionstatus -> "SubscriptionStatus"
    DefinedtypesSubscriptiontopic -> "SubscriptionTopic"
    DefinedtypesSubstance -> "Substance"
    DefinedtypesSubstancedefinition -> "SubstanceDefinition"
    DefinedtypesSupplydelivery -> "SupplyDelivery"
    DefinedtypesSupplyrequest -> "SupplyRequest"
    DefinedtypesTask -> "Task"
    DefinedtypesTerminologycapabilities -> "TerminologyCapabilities"
    DefinedtypesTestreport -> "TestReport"
    DefinedtypesTestscript -> "TestScript"
    DefinedtypesValueset -> "ValueSet"
    DefinedtypesVerificationresult -> "VerificationResult"
    DefinedtypesVisionprescription -> "VisionPrescription"
    DefinedtypesParameters -> "Parameters"
  }
}

pub fn definedtypes_from_string(s: String) -> Result(Definedtypes, Nil) {
  case s {
    "Address" -> Ok(DefinedtypesAddress)
    "Age" -> Ok(DefinedtypesAge)
    "Annotation" -> Ok(DefinedtypesAnnotation)
    "Attachment" -> Ok(DefinedtypesAttachment)
    "BackboneElement" -> Ok(DefinedtypesBackboneelement)
    "CodeableConcept" -> Ok(DefinedtypesCodeableconcept)
    "CodeableReference" -> Ok(DefinedtypesCodeablereference)
    "Coding" -> Ok(DefinedtypesCoding)
    "ContactDetail" -> Ok(DefinedtypesContactdetail)
    "ContactPoint" -> Ok(DefinedtypesContactpoint)
    "Contributor" -> Ok(DefinedtypesContributor)
    "Count" -> Ok(DefinedtypesCount)
    "DataRequirement" -> Ok(DefinedtypesDatarequirement)
    "Distance" -> Ok(DefinedtypesDistance)
    "Dosage" -> Ok(DefinedtypesDosage)
    "Duration" -> Ok(DefinedtypesDuration)
    "Element" -> Ok(DefinedtypesElement)
    "ElementDefinition" -> Ok(DefinedtypesElementdefinition)
    "Expression" -> Ok(DefinedtypesExpression)
    "Extension" -> Ok(DefinedtypesExtension)
    "HumanName" -> Ok(DefinedtypesHumanname)
    "Identifier" -> Ok(DefinedtypesIdentifier)
    "MarketingStatus" -> Ok(DefinedtypesMarketingstatus)
    "Meta" -> Ok(DefinedtypesMeta)
    "Money" -> Ok(DefinedtypesMoney)
    "MoneyQuantity" -> Ok(DefinedtypesMoneyquantity)
    "Narrative" -> Ok(DefinedtypesNarrative)
    "ParameterDefinition" -> Ok(DefinedtypesParameterdefinition)
    "Period" -> Ok(DefinedtypesPeriod)
    "Population" -> Ok(DefinedtypesPopulation)
    "ProdCharacteristic" -> Ok(DefinedtypesProdcharacteristic)
    "ProductShelfLife" -> Ok(DefinedtypesProductshelflife)
    "Quantity" -> Ok(DefinedtypesQuantity)
    "Range" -> Ok(DefinedtypesRange)
    "Ratio" -> Ok(DefinedtypesRatio)
    "RatioRange" -> Ok(DefinedtypesRatiorange)
    "Reference" -> Ok(DefinedtypesReference)
    "RelatedArtifact" -> Ok(DefinedtypesRelatedartifact)
    "SampledData" -> Ok(DefinedtypesSampleddata)
    "Signature" -> Ok(DefinedtypesSignature)
    "SimpleQuantity" -> Ok(DefinedtypesSimplequantity)
    "Timing" -> Ok(DefinedtypesTiming)
    "TriggerDefinition" -> Ok(DefinedtypesTriggerdefinition)
    "UsageContext" -> Ok(DefinedtypesUsagecontext)
    "base64Binary" -> Ok(DefinedtypesBase64binary)
    "boolean" -> Ok(DefinedtypesBoolean)
    "canonical" -> Ok(DefinedtypesCanonical)
    "code" -> Ok(DefinedtypesCode)
    "date" -> Ok(DefinedtypesDate)
    "dateTime" -> Ok(DefinedtypesDatetime)
    "decimal" -> Ok(DefinedtypesDecimal)
    "id" -> Ok(DefinedtypesId)
    "instant" -> Ok(DefinedtypesInstant)
    "integer" -> Ok(DefinedtypesInteger)
    "markdown" -> Ok(DefinedtypesMarkdown)
    "oid" -> Ok(DefinedtypesOid)
    "positiveInt" -> Ok(DefinedtypesPositiveint)
    "string" -> Ok(DefinedtypesString)
    "time" -> Ok(DefinedtypesTime)
    "unsignedInt" -> Ok(DefinedtypesUnsignedint)
    "uri" -> Ok(DefinedtypesUri)
    "url" -> Ok(DefinedtypesUrl)
    "uuid" -> Ok(DefinedtypesUuid)
    "xhtml" -> Ok(DefinedtypesXhtml)
    "Resource" -> Ok(DefinedtypesResource)
    "Binary" -> Ok(DefinedtypesBinary)
    "Bundle" -> Ok(DefinedtypesBundle)
    "DomainResource" -> Ok(DefinedtypesDomainresource)
    "Account" -> Ok(DefinedtypesAccount)
    "ActivityDefinition" -> Ok(DefinedtypesActivitydefinition)
    "AdministrableProductDefinition" ->
      Ok(DefinedtypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(DefinedtypesAdverseevent)
    "AllergyIntolerance" -> Ok(DefinedtypesAllergyintolerance)
    "Appointment" -> Ok(DefinedtypesAppointment)
    "AppointmentResponse" -> Ok(DefinedtypesAppointmentresponse)
    "AuditEvent" -> Ok(DefinedtypesAuditevent)
    "Basic" -> Ok(DefinedtypesBasic)
    "BiologicallyDerivedProduct" -> Ok(DefinedtypesBiologicallyderivedproduct)
    "BodyStructure" -> Ok(DefinedtypesBodystructure)
    "CapabilityStatement" -> Ok(DefinedtypesCapabilitystatement)
    "CarePlan" -> Ok(DefinedtypesCareplan)
    "CareTeam" -> Ok(DefinedtypesCareteam)
    "CatalogEntry" -> Ok(DefinedtypesCatalogentry)
    "ChargeItem" -> Ok(DefinedtypesChargeitem)
    "ChargeItemDefinition" -> Ok(DefinedtypesChargeitemdefinition)
    "Citation" -> Ok(DefinedtypesCitation)
    "Claim" -> Ok(DefinedtypesClaim)
    "ClaimResponse" -> Ok(DefinedtypesClaimresponse)
    "ClinicalImpression" -> Ok(DefinedtypesClinicalimpression)
    "ClinicalUseDefinition" -> Ok(DefinedtypesClinicalusedefinition)
    "CodeSystem" -> Ok(DefinedtypesCodesystem)
    "Communication" -> Ok(DefinedtypesCommunication)
    "CommunicationRequest" -> Ok(DefinedtypesCommunicationrequest)
    "CompartmentDefinition" -> Ok(DefinedtypesCompartmentdefinition)
    "Composition" -> Ok(DefinedtypesComposition)
    "ConceptMap" -> Ok(DefinedtypesConceptmap)
    "Condition" -> Ok(DefinedtypesCondition)
    "Consent" -> Ok(DefinedtypesConsent)
    "Contract" -> Ok(DefinedtypesContract)
    "Coverage" -> Ok(DefinedtypesCoverage)
    "CoverageEligibilityRequest" -> Ok(DefinedtypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" -> Ok(DefinedtypesCoverageeligibilityresponse)
    "DetectedIssue" -> Ok(DefinedtypesDetectedissue)
    "Device" -> Ok(DefinedtypesDevice)
    "DeviceDefinition" -> Ok(DefinedtypesDevicedefinition)
    "DeviceMetric" -> Ok(DefinedtypesDevicemetric)
    "DeviceRequest" -> Ok(DefinedtypesDevicerequest)
    "DeviceUseStatement" -> Ok(DefinedtypesDeviceusestatement)
    "DiagnosticReport" -> Ok(DefinedtypesDiagnosticreport)
    "DocumentManifest" -> Ok(DefinedtypesDocumentmanifest)
    "DocumentReference" -> Ok(DefinedtypesDocumentreference)
    "Encounter" -> Ok(DefinedtypesEncounter)
    "Endpoint" -> Ok(DefinedtypesEndpoint)
    "EnrollmentRequest" -> Ok(DefinedtypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(DefinedtypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(DefinedtypesEpisodeofcare)
    "EventDefinition" -> Ok(DefinedtypesEventdefinition)
    "Evidence" -> Ok(DefinedtypesEvidence)
    "EvidenceReport" -> Ok(DefinedtypesEvidencereport)
    "EvidenceVariable" -> Ok(DefinedtypesEvidencevariable)
    "ExampleScenario" -> Ok(DefinedtypesExamplescenario)
    "ExplanationOfBenefit" -> Ok(DefinedtypesExplanationofbenefit)
    "FamilyMemberHistory" -> Ok(DefinedtypesFamilymemberhistory)
    "Flag" -> Ok(DefinedtypesFlag)
    "Goal" -> Ok(DefinedtypesGoal)
    "GraphDefinition" -> Ok(DefinedtypesGraphdefinition)
    "Group" -> Ok(DefinedtypesGroup)
    "GuidanceResponse" -> Ok(DefinedtypesGuidanceresponse)
    "HealthcareService" -> Ok(DefinedtypesHealthcareservice)
    "ImagingStudy" -> Ok(DefinedtypesImagingstudy)
    "Immunization" -> Ok(DefinedtypesImmunization)
    "ImmunizationEvaluation" -> Ok(DefinedtypesImmunizationevaluation)
    "ImmunizationRecommendation" -> Ok(DefinedtypesImmunizationrecommendation)
    "ImplementationGuide" -> Ok(DefinedtypesImplementationguide)
    "Ingredient" -> Ok(DefinedtypesIngredient)
    "InsurancePlan" -> Ok(DefinedtypesInsuranceplan)
    "Invoice" -> Ok(DefinedtypesInvoice)
    "Library" -> Ok(DefinedtypesLibrary)
    "Linkage" -> Ok(DefinedtypesLinkage)
    "List" -> Ok(DefinedtypesList)
    "Location" -> Ok(DefinedtypesLocation)
    "ManufacturedItemDefinition" -> Ok(DefinedtypesManufactureditemdefinition)
    "Measure" -> Ok(DefinedtypesMeasure)
    "MeasureReport" -> Ok(DefinedtypesMeasurereport)
    "Media" -> Ok(DefinedtypesMedia)
    "Medication" -> Ok(DefinedtypesMedication)
    "MedicationAdministration" -> Ok(DefinedtypesMedicationadministration)
    "MedicationDispense" -> Ok(DefinedtypesMedicationdispense)
    "MedicationKnowledge" -> Ok(DefinedtypesMedicationknowledge)
    "MedicationRequest" -> Ok(DefinedtypesMedicationrequest)
    "MedicationStatement" -> Ok(DefinedtypesMedicationstatement)
    "MedicinalProductDefinition" -> Ok(DefinedtypesMedicinalproductdefinition)
    "MessageDefinition" -> Ok(DefinedtypesMessagedefinition)
    "MessageHeader" -> Ok(DefinedtypesMessageheader)
    "MolecularSequence" -> Ok(DefinedtypesMolecularsequence)
    "NamingSystem" -> Ok(DefinedtypesNamingsystem)
    "NutritionOrder" -> Ok(DefinedtypesNutritionorder)
    "NutritionProduct" -> Ok(DefinedtypesNutritionproduct)
    "Observation" -> Ok(DefinedtypesObservation)
    "ObservationDefinition" -> Ok(DefinedtypesObservationdefinition)
    "OperationDefinition" -> Ok(DefinedtypesOperationdefinition)
    "OperationOutcome" -> Ok(DefinedtypesOperationoutcome)
    "Organization" -> Ok(DefinedtypesOrganization)
    "OrganizationAffiliation" -> Ok(DefinedtypesOrganizationaffiliation)
    "PackagedProductDefinition" -> Ok(DefinedtypesPackagedproductdefinition)
    "Patient" -> Ok(DefinedtypesPatient)
    "PaymentNotice" -> Ok(DefinedtypesPaymentnotice)
    "PaymentReconciliation" -> Ok(DefinedtypesPaymentreconciliation)
    "Person" -> Ok(DefinedtypesPerson)
    "PlanDefinition" -> Ok(DefinedtypesPlandefinition)
    "Practitioner" -> Ok(DefinedtypesPractitioner)
    "PractitionerRole" -> Ok(DefinedtypesPractitionerrole)
    "Procedure" -> Ok(DefinedtypesProcedure)
    "Provenance" -> Ok(DefinedtypesProvenance)
    "Questionnaire" -> Ok(DefinedtypesQuestionnaire)
    "QuestionnaireResponse" -> Ok(DefinedtypesQuestionnaireresponse)
    "RegulatedAuthorization" -> Ok(DefinedtypesRegulatedauthorization)
    "RelatedPerson" -> Ok(DefinedtypesRelatedperson)
    "RequestGroup" -> Ok(DefinedtypesRequestgroup)
    "ResearchDefinition" -> Ok(DefinedtypesResearchdefinition)
    "ResearchElementDefinition" -> Ok(DefinedtypesResearchelementdefinition)
    "ResearchStudy" -> Ok(DefinedtypesResearchstudy)
    "ResearchSubject" -> Ok(DefinedtypesResearchsubject)
    "RiskAssessment" -> Ok(DefinedtypesRiskassessment)
    "Schedule" -> Ok(DefinedtypesSchedule)
    "SearchParameter" -> Ok(DefinedtypesSearchparameter)
    "ServiceRequest" -> Ok(DefinedtypesServicerequest)
    "Slot" -> Ok(DefinedtypesSlot)
    "Specimen" -> Ok(DefinedtypesSpecimen)
    "SpecimenDefinition" -> Ok(DefinedtypesSpecimendefinition)
    "StructureDefinition" -> Ok(DefinedtypesStructuredefinition)
    "StructureMap" -> Ok(DefinedtypesStructuremap)
    "Subscription" -> Ok(DefinedtypesSubscription)
    "SubscriptionStatus" -> Ok(DefinedtypesSubscriptionstatus)
    "SubscriptionTopic" -> Ok(DefinedtypesSubscriptiontopic)
    "Substance" -> Ok(DefinedtypesSubstance)
    "SubstanceDefinition" -> Ok(DefinedtypesSubstancedefinition)
    "SupplyDelivery" -> Ok(DefinedtypesSupplydelivery)
    "SupplyRequest" -> Ok(DefinedtypesSupplyrequest)
    "Task" -> Ok(DefinedtypesTask)
    "TerminologyCapabilities" -> Ok(DefinedtypesTerminologycapabilities)
    "TestReport" -> Ok(DefinedtypesTestreport)
    "TestScript" -> Ok(DefinedtypesTestscript)
    "ValueSet" -> Ok(DefinedtypesValueset)
    "VerificationResult" -> Ok(DefinedtypesVerificationresult)
    "VisionPrescription" -> Ok(DefinedtypesVisionprescription)
    "Parameters" -> Ok(DefinedtypesParameters)
    _ -> Error(Nil)
  }
}

pub fn definedtypes_decoder() -> Decoder(Definedtypes) {
  use variant <- decode.then(decode.string)
  case variant {
    "Address" -> decode.success(DefinedtypesAddress)
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
    "Binary" -> decode.success(DefinedtypesBinary)
    "Bundle" -> decode.success(DefinedtypesBundle)
    "DomainResource" -> decode.success(DefinedtypesDomainresource)
    "Account" -> decode.success(DefinedtypesAccount)
    "ActivityDefinition" -> decode.success(DefinedtypesActivitydefinition)
    "AdministrableProductDefinition" ->
      decode.success(DefinedtypesAdministrableproductdefinition)
    "AdverseEvent" -> decode.success(DefinedtypesAdverseevent)
    "AllergyIntolerance" -> decode.success(DefinedtypesAllergyintolerance)
    "Appointment" -> decode.success(DefinedtypesAppointment)
    "AppointmentResponse" -> decode.success(DefinedtypesAppointmentresponse)
    "AuditEvent" -> decode.success(DefinedtypesAuditevent)
    "Basic" -> decode.success(DefinedtypesBasic)
    "BiologicallyDerivedProduct" ->
      decode.success(DefinedtypesBiologicallyderivedproduct)
    "BodyStructure" -> decode.success(DefinedtypesBodystructure)
    "CapabilityStatement" -> decode.success(DefinedtypesCapabilitystatement)
    "CarePlan" -> decode.success(DefinedtypesCareplan)
    "CareTeam" -> decode.success(DefinedtypesCareteam)
    "CatalogEntry" -> decode.success(DefinedtypesCatalogentry)
    "ChargeItem" -> decode.success(DefinedtypesChargeitem)
    "ChargeItemDefinition" -> decode.success(DefinedtypesChargeitemdefinition)
    "Citation" -> decode.success(DefinedtypesCitation)
    "Claim" -> decode.success(DefinedtypesClaim)
    "ClaimResponse" -> decode.success(DefinedtypesClaimresponse)
    "ClinicalImpression" -> decode.success(DefinedtypesClinicalimpression)
    "ClinicalUseDefinition" -> decode.success(DefinedtypesClinicalusedefinition)
    "CodeSystem" -> decode.success(DefinedtypesCodesystem)
    "Communication" -> decode.success(DefinedtypesCommunication)
    "CommunicationRequest" -> decode.success(DefinedtypesCommunicationrequest)
    "CompartmentDefinition" -> decode.success(DefinedtypesCompartmentdefinition)
    "Composition" -> decode.success(DefinedtypesComposition)
    "ConceptMap" -> decode.success(DefinedtypesConceptmap)
    "Condition" -> decode.success(DefinedtypesCondition)
    "Consent" -> decode.success(DefinedtypesConsent)
    "Contract" -> decode.success(DefinedtypesContract)
    "Coverage" -> decode.success(DefinedtypesCoverage)
    "CoverageEligibilityRequest" ->
      decode.success(DefinedtypesCoverageeligibilityrequest)
    "CoverageEligibilityResponse" ->
      decode.success(DefinedtypesCoverageeligibilityresponse)
    "DetectedIssue" -> decode.success(DefinedtypesDetectedissue)
    "Device" -> decode.success(DefinedtypesDevice)
    "DeviceDefinition" -> decode.success(DefinedtypesDevicedefinition)
    "DeviceMetric" -> decode.success(DefinedtypesDevicemetric)
    "DeviceRequest" -> decode.success(DefinedtypesDevicerequest)
    "DeviceUseStatement" -> decode.success(DefinedtypesDeviceusestatement)
    "DiagnosticReport" -> decode.success(DefinedtypesDiagnosticreport)
    "DocumentManifest" -> decode.success(DefinedtypesDocumentmanifest)
    "DocumentReference" -> decode.success(DefinedtypesDocumentreference)
    "Encounter" -> decode.success(DefinedtypesEncounter)
    "Endpoint" -> decode.success(DefinedtypesEndpoint)
    "EnrollmentRequest" -> decode.success(DefinedtypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(DefinedtypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(DefinedtypesEpisodeofcare)
    "EventDefinition" -> decode.success(DefinedtypesEventdefinition)
    "Evidence" -> decode.success(DefinedtypesEvidence)
    "EvidenceReport" -> decode.success(DefinedtypesEvidencereport)
    "EvidenceVariable" -> decode.success(DefinedtypesEvidencevariable)
    "ExampleScenario" -> decode.success(DefinedtypesExamplescenario)
    "ExplanationOfBenefit" -> decode.success(DefinedtypesExplanationofbenefit)
    "FamilyMemberHistory" -> decode.success(DefinedtypesFamilymemberhistory)
    "Flag" -> decode.success(DefinedtypesFlag)
    "Goal" -> decode.success(DefinedtypesGoal)
    "GraphDefinition" -> decode.success(DefinedtypesGraphdefinition)
    "Group" -> decode.success(DefinedtypesGroup)
    "GuidanceResponse" -> decode.success(DefinedtypesGuidanceresponse)
    "HealthcareService" -> decode.success(DefinedtypesHealthcareservice)
    "ImagingStudy" -> decode.success(DefinedtypesImagingstudy)
    "Immunization" -> decode.success(DefinedtypesImmunization)
    "ImmunizationEvaluation" ->
      decode.success(DefinedtypesImmunizationevaluation)
    "ImmunizationRecommendation" ->
      decode.success(DefinedtypesImmunizationrecommendation)
    "ImplementationGuide" -> decode.success(DefinedtypesImplementationguide)
    "Ingredient" -> decode.success(DefinedtypesIngredient)
    "InsurancePlan" -> decode.success(DefinedtypesInsuranceplan)
    "Invoice" -> decode.success(DefinedtypesInvoice)
    "Library" -> decode.success(DefinedtypesLibrary)
    "Linkage" -> decode.success(DefinedtypesLinkage)
    "List" -> decode.success(DefinedtypesList)
    "Location" -> decode.success(DefinedtypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(DefinedtypesManufactureditemdefinition)
    "Measure" -> decode.success(DefinedtypesMeasure)
    "MeasureReport" -> decode.success(DefinedtypesMeasurereport)
    "Media" -> decode.success(DefinedtypesMedia)
    "Medication" -> decode.success(DefinedtypesMedication)
    "MedicationAdministration" ->
      decode.success(DefinedtypesMedicationadministration)
    "MedicationDispense" -> decode.success(DefinedtypesMedicationdispense)
    "MedicationKnowledge" -> decode.success(DefinedtypesMedicationknowledge)
    "MedicationRequest" -> decode.success(DefinedtypesMedicationrequest)
    "MedicationStatement" -> decode.success(DefinedtypesMedicationstatement)
    "MedicinalProductDefinition" ->
      decode.success(DefinedtypesMedicinalproductdefinition)
    "MessageDefinition" -> decode.success(DefinedtypesMessagedefinition)
    "MessageHeader" -> decode.success(DefinedtypesMessageheader)
    "MolecularSequence" -> decode.success(DefinedtypesMolecularsequence)
    "NamingSystem" -> decode.success(DefinedtypesNamingsystem)
    "NutritionOrder" -> decode.success(DefinedtypesNutritionorder)
    "NutritionProduct" -> decode.success(DefinedtypesNutritionproduct)
    "Observation" -> decode.success(DefinedtypesObservation)
    "ObservationDefinition" -> decode.success(DefinedtypesObservationdefinition)
    "OperationDefinition" -> decode.success(DefinedtypesOperationdefinition)
    "OperationOutcome" -> decode.success(DefinedtypesOperationoutcome)
    "Organization" -> decode.success(DefinedtypesOrganization)
    "OrganizationAffiliation" ->
      decode.success(DefinedtypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      decode.success(DefinedtypesPackagedproductdefinition)
    "Patient" -> decode.success(DefinedtypesPatient)
    "PaymentNotice" -> decode.success(DefinedtypesPaymentnotice)
    "PaymentReconciliation" -> decode.success(DefinedtypesPaymentreconciliation)
    "Person" -> decode.success(DefinedtypesPerson)
    "PlanDefinition" -> decode.success(DefinedtypesPlandefinition)
    "Practitioner" -> decode.success(DefinedtypesPractitioner)
    "PractitionerRole" -> decode.success(DefinedtypesPractitionerrole)
    "Procedure" -> decode.success(DefinedtypesProcedure)
    "Provenance" -> decode.success(DefinedtypesProvenance)
    "Questionnaire" -> decode.success(DefinedtypesQuestionnaire)
    "QuestionnaireResponse" -> decode.success(DefinedtypesQuestionnaireresponse)
    "RegulatedAuthorization" ->
      decode.success(DefinedtypesRegulatedauthorization)
    "RelatedPerson" -> decode.success(DefinedtypesRelatedperson)
    "RequestGroup" -> decode.success(DefinedtypesRequestgroup)
    "ResearchDefinition" -> decode.success(DefinedtypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(DefinedtypesResearchelementdefinition)
    "ResearchStudy" -> decode.success(DefinedtypesResearchstudy)
    "ResearchSubject" -> decode.success(DefinedtypesResearchsubject)
    "RiskAssessment" -> decode.success(DefinedtypesRiskassessment)
    "Schedule" -> decode.success(DefinedtypesSchedule)
    "SearchParameter" -> decode.success(DefinedtypesSearchparameter)
    "ServiceRequest" -> decode.success(DefinedtypesServicerequest)
    "Slot" -> decode.success(DefinedtypesSlot)
    "Specimen" -> decode.success(DefinedtypesSpecimen)
    "SpecimenDefinition" -> decode.success(DefinedtypesSpecimendefinition)
    "StructureDefinition" -> decode.success(DefinedtypesStructuredefinition)
    "StructureMap" -> decode.success(DefinedtypesStructuremap)
    "Subscription" -> decode.success(DefinedtypesSubscription)
    "SubscriptionStatus" -> decode.success(DefinedtypesSubscriptionstatus)
    "SubscriptionTopic" -> decode.success(DefinedtypesSubscriptiontopic)
    "Substance" -> decode.success(DefinedtypesSubstance)
    "SubstanceDefinition" -> decode.success(DefinedtypesSubstancedefinition)
    "SupplyDelivery" -> decode.success(DefinedtypesSupplydelivery)
    "SupplyRequest" -> decode.success(DefinedtypesSupplyrequest)
    "Task" -> decode.success(DefinedtypesTask)
    "TerminologyCapabilities" ->
      decode.success(DefinedtypesTerminologycapabilities)
    "TestReport" -> decode.success(DefinedtypesTestreport)
    "TestScript" -> decode.success(DefinedtypesTestscript)
    "ValueSet" -> decode.success(DefinedtypesValueset)
    "VerificationResult" -> decode.success(DefinedtypesVerificationresult)
    "VisionPrescription" -> decode.success(DefinedtypesVisionprescription)
    "Parameters" -> decode.success(DefinedtypesParameters)
    _ -> decode.failure(DefinedtypesAddress, "Definedtypes")
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

pub type Invoicepricecomponenttype {
  InvoicepricecomponenttypeBase
  InvoicepricecomponenttypeSurcharge
  InvoicepricecomponenttypeDeduction
  InvoicepricecomponenttypeDiscount
  InvoicepricecomponenttypeTax
  InvoicepricecomponenttypeInformational
}

pub fn invoicepricecomponenttype_to_json(
  invoicepricecomponenttype: Invoicepricecomponenttype,
) -> Json {
  json.string(invoicepricecomponenttype_to_string(invoicepricecomponenttype))
}

pub fn invoicepricecomponenttype_to_string(
  invoicepricecomponenttype: Invoicepricecomponenttype,
) -> String {
  case invoicepricecomponenttype {
    InvoicepricecomponenttypeBase -> "base"
    InvoicepricecomponenttypeSurcharge -> "surcharge"
    InvoicepricecomponenttypeDeduction -> "deduction"
    InvoicepricecomponenttypeDiscount -> "discount"
    InvoicepricecomponenttypeTax -> "tax"
    InvoicepricecomponenttypeInformational -> "informational"
  }
}

pub fn invoicepricecomponenttype_from_string(
  s: String,
) -> Result(Invoicepricecomponenttype, Nil) {
  case s {
    "base" -> Ok(InvoicepricecomponenttypeBase)
    "surcharge" -> Ok(InvoicepricecomponenttypeSurcharge)
    "deduction" -> Ok(InvoicepricecomponenttypeDeduction)
    "discount" -> Ok(InvoicepricecomponenttypeDiscount)
    "tax" -> Ok(InvoicepricecomponenttypeTax)
    "informational" -> Ok(InvoicepricecomponenttypeInformational)
    _ -> Error(Nil)
  }
}

pub fn invoicepricecomponenttype_decoder() -> Decoder(Invoicepricecomponenttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "base" -> decode.success(InvoicepricecomponenttypeBase)
    "surcharge" -> decode.success(InvoicepricecomponenttypeSurcharge)
    "deduction" -> decode.success(InvoicepricecomponenttypeDeduction)
    "discount" -> decode.success(InvoicepricecomponenttypeDiscount)
    "tax" -> decode.success(InvoicepricecomponenttypeTax)
    "informational" -> decode.success(InvoicepricecomponenttypeInformational)
    _ ->
      decode.failure(InvoicepricecomponenttypeBase, "Invoicepricecomponenttype")
  }
}

pub type Careplanactivitykind {
  CareplanactivitykindAppointment
  CareplanactivitykindCommunicationrequest
  CareplanactivitykindDevicerequest
  CareplanactivitykindMedicationrequest
  CareplanactivitykindNutritionorder
  CareplanactivitykindTask
  CareplanactivitykindServicerequest
  CareplanactivitykindVisionprescription
}

pub fn careplanactivitykind_to_json(
  careplanactivitykind: Careplanactivitykind,
) -> Json {
  json.string(careplanactivitykind_to_string(careplanactivitykind))
}

pub fn careplanactivitykind_to_string(
  careplanactivitykind: Careplanactivitykind,
) -> String {
  case careplanactivitykind {
    CareplanactivitykindAppointment -> "Appointment"
    CareplanactivitykindCommunicationrequest -> "CommunicationRequest"
    CareplanactivitykindDevicerequest -> "DeviceRequest"
    CareplanactivitykindMedicationrequest -> "MedicationRequest"
    CareplanactivitykindNutritionorder -> "NutritionOrder"
    CareplanactivitykindTask -> "Task"
    CareplanactivitykindServicerequest -> "ServiceRequest"
    CareplanactivitykindVisionprescription -> "VisionPrescription"
  }
}

pub fn careplanactivitykind_from_string(
  s: String,
) -> Result(Careplanactivitykind, Nil) {
  case s {
    "Appointment" -> Ok(CareplanactivitykindAppointment)
    "CommunicationRequest" -> Ok(CareplanactivitykindCommunicationrequest)
    "DeviceRequest" -> Ok(CareplanactivitykindDevicerequest)
    "MedicationRequest" -> Ok(CareplanactivitykindMedicationrequest)
    "NutritionOrder" -> Ok(CareplanactivitykindNutritionorder)
    "Task" -> Ok(CareplanactivitykindTask)
    "ServiceRequest" -> Ok(CareplanactivitykindServicerequest)
    "VisionPrescription" -> Ok(CareplanactivitykindVisionprescription)
    _ -> Error(Nil)
  }
}

pub fn careplanactivitykind_decoder() -> Decoder(Careplanactivitykind) {
  use variant <- decode.then(decode.string)
  case variant {
    "Appointment" -> decode.success(CareplanactivitykindAppointment)
    "CommunicationRequest" ->
      decode.success(CareplanactivitykindCommunicationrequest)
    "DeviceRequest" -> decode.success(CareplanactivitykindDevicerequest)
    "MedicationRequest" -> decode.success(CareplanactivitykindMedicationrequest)
    "NutritionOrder" -> decode.success(CareplanactivitykindNutritionorder)
    "Task" -> decode.success(CareplanactivitykindTask)
    "ServiceRequest" -> decode.success(CareplanactivitykindServicerequest)
    "VisionPrescription" ->
      decode.success(CareplanactivitykindVisionprescription)
    _ -> decode.failure(CareplanactivitykindAppointment, "Careplanactivitykind")
  }
}

pub type Conceptmapunmappedmode {
  ConceptmapunmappedmodeProvided
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
    ConceptmapunmappedmodeProvided -> "provided"
    ConceptmapunmappedmodeFixed -> "fixed"
    ConceptmapunmappedmodeOthermap -> "other-map"
  }
}

pub fn conceptmapunmappedmode_from_string(
  s: String,
) -> Result(Conceptmapunmappedmode, Nil) {
  case s {
    "provided" -> Ok(ConceptmapunmappedmodeProvided)
    "fixed" -> Ok(ConceptmapunmappedmodeFixed)
    "other-map" -> Ok(ConceptmapunmappedmodeOthermap)
    _ -> Error(Nil)
  }
}

pub fn conceptmapunmappedmode_decoder() -> Decoder(Conceptmapunmappedmode) {
  use variant <- decode.then(decode.string)
  case variant {
    "provided" -> decode.success(ConceptmapunmappedmodeProvided)
    "fixed" -> decode.success(ConceptmapunmappedmodeFixed)
    "other-map" -> decode.success(ConceptmapunmappedmodeOthermap)
    _ ->
      decode.failure(ConceptmapunmappedmodeProvided, "Conceptmapunmappedmode")
  }
}

pub type Verificationresultstatus {
  VerificationresultstatusAttested
  VerificationresultstatusValidated
  VerificationresultstatusInprocess
  VerificationresultstatusReqrevalid
  VerificationresultstatusValfail
  VerificationresultstatusRevalfail
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

pub type Careplanintent {
  CareplanintentProposal
  CareplanintentPlan
  CareplanintentOrder
  CareplanintentOption
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
  }
}

pub fn careplanintent_from_string(s: String) -> Result(Careplanintent, Nil) {
  case s {
    "proposal" -> Ok(CareplanintentProposal)
    "plan" -> Ok(CareplanintentPlan)
    "order" -> Ok(CareplanintentOrder)
    "option" -> Ok(CareplanintentOption)
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
    SearchmodifiercodeOftype -> "ofType"
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
    "ofType" -> Ok(SearchmodifiercodeOftype)
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
    "ofType" -> decode.success(SearchmodifiercodeOftype)
    _ -> decode.failure(SearchmodifiercodeMissing, "Searchmodifiercode")
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

pub type Repositorytype {
  RepositorytypeDirectlink
  RepositorytypeOpenapi
  RepositorytypeLogin
  RepositorytypeOauth
  RepositorytypeOther
}

pub fn repositorytype_to_json(repositorytype: Repositorytype) -> Json {
  json.string(repositorytype_to_string(repositorytype))
}

pub fn repositorytype_to_string(repositorytype: Repositorytype) -> String {
  case repositorytype {
    RepositorytypeDirectlink -> "directlink"
    RepositorytypeOpenapi -> "openapi"
    RepositorytypeLogin -> "login"
    RepositorytypeOauth -> "oauth"
    RepositorytypeOther -> "other"
  }
}

pub fn repositorytype_from_string(s: String) -> Result(Repositorytype, Nil) {
  case s {
    "directlink" -> Ok(RepositorytypeDirectlink)
    "openapi" -> Ok(RepositorytypeOpenapi)
    "login" -> Ok(RepositorytypeLogin)
    "oauth" -> Ok(RepositorytypeOauth)
    "other" -> Ok(RepositorytypeOther)
    _ -> Error(Nil)
  }
}

pub fn repositorytype_decoder() -> Decoder(Repositorytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "directlink" -> decode.success(RepositorytypeDirectlink)
    "openapi" -> decode.success(RepositorytypeOpenapi)
    "login" -> decode.success(RepositorytypeLogin)
    "oauth" -> decode.success(RepositorytypeOauth)
    "other" -> decode.success(RepositorytypeOther)
    _ -> decode.failure(RepositorytypeDirectlink, "Repositorytype")
  }
}

pub type Subscriptionstatus {
  SubscriptionstatusRequested
  SubscriptionstatusActive
  SubscriptionstatusError
  SubscriptionstatusOff
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

pub type Careplanactivitystatus {
  CareplanactivitystatusNotstarted
  CareplanactivitystatusScheduled
  CareplanactivitystatusInprogress
  CareplanactivitystatusOnhold
  CareplanactivitystatusCompleted
  CareplanactivitystatusCancelled
  CareplanactivitystatusStopped
  CareplanactivitystatusUnknown
  CareplanactivitystatusEnteredinerror
}

pub fn careplanactivitystatus_to_json(
  careplanactivitystatus: Careplanactivitystatus,
) -> Json {
  json.string(careplanactivitystatus_to_string(careplanactivitystatus))
}

pub fn careplanactivitystatus_to_string(
  careplanactivitystatus: Careplanactivitystatus,
) -> String {
  case careplanactivitystatus {
    CareplanactivitystatusNotstarted -> "not-started"
    CareplanactivitystatusScheduled -> "scheduled"
    CareplanactivitystatusInprogress -> "in-progress"
    CareplanactivitystatusOnhold -> "on-hold"
    CareplanactivitystatusCompleted -> "completed"
    CareplanactivitystatusCancelled -> "cancelled"
    CareplanactivitystatusStopped -> "stopped"
    CareplanactivitystatusUnknown -> "unknown"
    CareplanactivitystatusEnteredinerror -> "entered-in-error"
  }
}

pub fn careplanactivitystatus_from_string(
  s: String,
) -> Result(Careplanactivitystatus, Nil) {
  case s {
    "not-started" -> Ok(CareplanactivitystatusNotstarted)
    "scheduled" -> Ok(CareplanactivitystatusScheduled)
    "in-progress" -> Ok(CareplanactivitystatusInprogress)
    "on-hold" -> Ok(CareplanactivitystatusOnhold)
    "completed" -> Ok(CareplanactivitystatusCompleted)
    "cancelled" -> Ok(CareplanactivitystatusCancelled)
    "stopped" -> Ok(CareplanactivitystatusStopped)
    "unknown" -> Ok(CareplanactivitystatusUnknown)
    "entered-in-error" -> Ok(CareplanactivitystatusEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn careplanactivitystatus_decoder() -> Decoder(Careplanactivitystatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "not-started" -> decode.success(CareplanactivitystatusNotstarted)
    "scheduled" -> decode.success(CareplanactivitystatusScheduled)
    "in-progress" -> decode.success(CareplanactivitystatusInprogress)
    "on-hold" -> decode.success(CareplanactivitystatusOnhold)
    "completed" -> decode.success(CareplanactivitystatusCompleted)
    "cancelled" -> decode.success(CareplanactivitystatusCancelled)
    "stopped" -> decode.success(CareplanactivitystatusStopped)
    "unknown" -> decode.success(CareplanactivitystatusUnknown)
    "entered-in-error" -> decode.success(CareplanactivitystatusEnteredinerror)
    _ ->
      decode.failure(CareplanactivitystatusNotstarted, "Careplanactivitystatus")
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

pub type Devicenametype {
  DevicenametypeUdilabelname
  DevicenametypeUserfriendlyname
  DevicenametypePatientreportedname
  DevicenametypeManufacturername
  DevicenametypeModelname
  DevicenametypeOther
}

pub fn devicenametype_to_json(devicenametype: Devicenametype) -> Json {
  json.string(devicenametype_to_string(devicenametype))
}

pub fn devicenametype_to_string(devicenametype: Devicenametype) -> String {
  case devicenametype {
    DevicenametypeUdilabelname -> "udi-label-name"
    DevicenametypeUserfriendlyname -> "user-friendly-name"
    DevicenametypePatientreportedname -> "patient-reported-name"
    DevicenametypeManufacturername -> "manufacturer-name"
    DevicenametypeModelname -> "model-name"
    DevicenametypeOther -> "other"
  }
}

pub fn devicenametype_from_string(s: String) -> Result(Devicenametype, Nil) {
  case s {
    "udi-label-name" -> Ok(DevicenametypeUdilabelname)
    "user-friendly-name" -> Ok(DevicenametypeUserfriendlyname)
    "patient-reported-name" -> Ok(DevicenametypePatientreportedname)
    "manufacturer-name" -> Ok(DevicenametypeManufacturername)
    "model-name" -> Ok(DevicenametypeModelname)
    "other" -> Ok(DevicenametypeOther)
    _ -> Error(Nil)
  }
}

pub fn devicenametype_decoder() -> Decoder(Devicenametype) {
  use variant <- decode.then(decode.string)
  case variant {
    "udi-label-name" -> decode.success(DevicenametypeUdilabelname)
    "user-friendly-name" -> decode.success(DevicenametypeUserfriendlyname)
    "patient-reported-name" -> decode.success(DevicenametypePatientreportedname)
    "manufacturer-name" -> decode.success(DevicenametypeManufacturername)
    "model-name" -> decode.success(DevicenametypeModelname)
    "other" -> decode.success(DevicenametypeOther)
    _ -> decode.failure(DevicenametypeUdilabelname, "Devicenametype")
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

pub fn guideparametercode_to_json(
  guideparametercode: Guideparametercode,
) -> Json {
  json.string(guideparametercode_to_string(guideparametercode))
}

pub fn guideparametercode_to_string(
  guideparametercode: Guideparametercode,
) -> String {
  case guideparametercode {
    GuideparametercodeApply -> "apply"
    GuideparametercodePathresource -> "path-resource"
    GuideparametercodePathpages -> "path-pages"
    GuideparametercodePathtxcache -> "path-tx-cache"
    GuideparametercodeExpansionparameter -> "expansion-parameter"
    GuideparametercodeRulebrokenlinks -> "rule-broken-links"
    GuideparametercodeGeneratexml -> "generate-xml"
    GuideparametercodeGeneratejson -> "generate-json"
    GuideparametercodeGenerateturtle -> "generate-turtle"
    GuideparametercodeHtmltemplate -> "html-template"
  }
}

pub fn guideparametercode_from_string(
  s: String,
) -> Result(Guideparametercode, Nil) {
  case s {
    "apply" -> Ok(GuideparametercodeApply)
    "path-resource" -> Ok(GuideparametercodePathresource)
    "path-pages" -> Ok(GuideparametercodePathpages)
    "path-tx-cache" -> Ok(GuideparametercodePathtxcache)
    "expansion-parameter" -> Ok(GuideparametercodeExpansionparameter)
    "rule-broken-links" -> Ok(GuideparametercodeRulebrokenlinks)
    "generate-xml" -> Ok(GuideparametercodeGeneratexml)
    "generate-json" -> Ok(GuideparametercodeGeneratejson)
    "generate-turtle" -> Ok(GuideparametercodeGenerateturtle)
    "html-template" -> Ok(GuideparametercodeHtmltemplate)
    _ -> Error(Nil)
  }
}

pub fn guideparametercode_decoder() -> Decoder(Guideparametercode) {
  use variant <- decode.then(decode.string)
  case variant {
    "apply" -> decode.success(GuideparametercodeApply)
    "path-resource" -> decode.success(GuideparametercodePathresource)
    "path-pages" -> decode.success(GuideparametercodePathpages)
    "path-tx-cache" -> decode.success(GuideparametercodePathtxcache)
    "expansion-parameter" ->
      decode.success(GuideparametercodeExpansionparameter)
    "rule-broken-links" -> decode.success(GuideparametercodeRulebrokenlinks)
    "generate-xml" -> decode.success(GuideparametercodeGeneratexml)
    "generate-json" -> decode.success(GuideparametercodeGeneratejson)
    "generate-turtle" -> decode.success(GuideparametercodeGenerateturtle)
    "html-template" -> decode.success(GuideparametercodeHtmltemplate)
    _ -> decode.failure(GuideparametercodeApply, "Guideparametercode")
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

pub type Subscriptionchanneltype {
  SubscriptionchanneltypeResthook
  SubscriptionchanneltypeWebsocket
  SubscriptionchanneltypeEmail
  SubscriptionchanneltypeSms
  SubscriptionchanneltypeMessage
}

pub fn subscriptionchanneltype_to_json(
  subscriptionchanneltype: Subscriptionchanneltype,
) -> Json {
  json.string(subscriptionchanneltype_to_string(subscriptionchanneltype))
}

pub fn subscriptionchanneltype_to_string(
  subscriptionchanneltype: Subscriptionchanneltype,
) -> String {
  case subscriptionchanneltype {
    SubscriptionchanneltypeResthook -> "rest-hook"
    SubscriptionchanneltypeWebsocket -> "websocket"
    SubscriptionchanneltypeEmail -> "email"
    SubscriptionchanneltypeSms -> "sms"
    SubscriptionchanneltypeMessage -> "message"
  }
}

pub fn subscriptionchanneltype_from_string(
  s: String,
) -> Result(Subscriptionchanneltype, Nil) {
  case s {
    "rest-hook" -> Ok(SubscriptionchanneltypeResthook)
    "websocket" -> Ok(SubscriptionchanneltypeWebsocket)
    "email" -> Ok(SubscriptionchanneltypeEmail)
    "sms" -> Ok(SubscriptionchanneltypeSms)
    "message" -> Ok(SubscriptionchanneltypeMessage)
    _ -> Error(Nil)
  }
}

pub fn subscriptionchanneltype_decoder() -> Decoder(Subscriptionchanneltype) {
  use variant <- decode.then(decode.string)
  case variant {
    "rest-hook" -> decode.success(SubscriptionchanneltypeResthook)
    "websocket" -> decode.success(SubscriptionchanneltypeWebsocket)
    "email" -> decode.success(SubscriptionchanneltypeEmail)
    "sms" -> decode.success(SubscriptionchanneltypeSms)
    "message" -> decode.success(SubscriptionchanneltypeMessage)
    _ ->
      decode.failure(SubscriptionchanneltypeResthook, "Subscriptionchanneltype")
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
    RequestresourcetypesContract -> "Contract"
    RequestresourcetypesDevicerequest -> "DeviceRequest"
    RequestresourcetypesEnrollmentrequest -> "EnrollmentRequest"
    RequestresourcetypesImmunizationrecommendation ->
      "ImmunizationRecommendation"
    RequestresourcetypesMedicationrequest -> "MedicationRequest"
    RequestresourcetypesNutritionorder -> "NutritionOrder"
    RequestresourcetypesServicerequest -> "ServiceRequest"
    RequestresourcetypesSupplyrequest -> "SupplyRequest"
    RequestresourcetypesTask -> "Task"
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
    "Contract" -> Ok(RequestresourcetypesContract)
    "DeviceRequest" -> Ok(RequestresourcetypesDevicerequest)
    "EnrollmentRequest" -> Ok(RequestresourcetypesEnrollmentrequest)
    "ImmunizationRecommendation" ->
      Ok(RequestresourcetypesImmunizationrecommendation)
    "MedicationRequest" -> Ok(RequestresourcetypesMedicationrequest)
    "NutritionOrder" -> Ok(RequestresourcetypesNutritionorder)
    "ServiceRequest" -> Ok(RequestresourcetypesServicerequest)
    "SupplyRequest" -> Ok(RequestresourcetypesSupplyrequest)
    "Task" -> Ok(RequestresourcetypesTask)
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
    "Contract" -> decode.success(RequestresourcetypesContract)
    "DeviceRequest" -> decode.success(RequestresourcetypesDevicerequest)
    "EnrollmentRequest" -> decode.success(RequestresourcetypesEnrollmentrequest)
    "ImmunizationRecommendation" ->
      decode.success(RequestresourcetypesImmunizationrecommendation)
    "MedicationRequest" -> decode.success(RequestresourcetypesMedicationrequest)
    "NutritionOrder" -> decode.success(RequestresourcetypesNutritionorder)
    "ServiceRequest" -> decode.success(RequestresourcetypesServicerequest)
    "SupplyRequest" -> decode.success(RequestresourcetypesSupplyrequest)
    "Task" -> decode.success(RequestresourcetypesTask)
    "VisionPrescription" ->
      decode.success(RequestresourcetypesVisionprescription)
    _ -> decode.failure(RequestresourcetypesAppointment, "Requestresourcetypes")
  }
}

pub type Documentrelationshiptype {
  DocumentrelationshiptypeReplaces
  DocumentrelationshiptypeTransforms
  DocumentrelationshiptypeSigns
  DocumentrelationshiptypeAppends
}

pub fn documentrelationshiptype_to_json(
  documentrelationshiptype: Documentrelationshiptype,
) -> Json {
  json.string(documentrelationshiptype_to_string(documentrelationshiptype))
}

pub fn documentrelationshiptype_to_string(
  documentrelationshiptype: Documentrelationshiptype,
) -> String {
  case documentrelationshiptype {
    DocumentrelationshiptypeReplaces -> "replaces"
    DocumentrelationshiptypeTransforms -> "transforms"
    DocumentrelationshiptypeSigns -> "signs"
    DocumentrelationshiptypeAppends -> "appends"
  }
}

pub fn documentrelationshiptype_from_string(
  s: String,
) -> Result(Documentrelationshiptype, Nil) {
  case s {
    "replaces" -> Ok(DocumentrelationshiptypeReplaces)
    "transforms" -> Ok(DocumentrelationshiptypeTransforms)
    "signs" -> Ok(DocumentrelationshiptypeSigns)
    "appends" -> Ok(DocumentrelationshiptypeAppends)
    _ -> Error(Nil)
  }
}

pub fn documentrelationshiptype_decoder() -> Decoder(Documentrelationshiptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "replaces" -> decode.success(DocumentrelationshiptypeReplaces)
    "transforms" -> decode.success(DocumentrelationshiptypeTransforms)
    "signs" -> decode.success(DocumentrelationshiptypeSigns)
    "appends" -> decode.success(DocumentrelationshiptypeAppends)
    _ ->
      decode.failure(
        DocumentrelationshiptypeReplaces,
        "Documentrelationshiptype",
      )
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

pub type Productstatus {
  ProductstatusAvailable
  ProductstatusUnavailable
}

pub fn productstatus_to_json(productstatus: Productstatus) -> Json {
  json.string(productstatus_to_string(productstatus))
}

pub fn productstatus_to_string(productstatus: Productstatus) -> String {
  case productstatus {
    ProductstatusAvailable -> "available"
    ProductstatusUnavailable -> "unavailable"
  }
}

pub fn productstatus_from_string(s: String) -> Result(Productstatus, Nil) {
  case s {
    "available" -> Ok(ProductstatusAvailable)
    "unavailable" -> Ok(ProductstatusUnavailable)
    _ -> Error(Nil)
  }
}

pub fn productstatus_decoder() -> Decoder(Productstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "available" -> decode.success(ProductstatusAvailable)
    "unavailable" -> decode.success(ProductstatusUnavailable)
    _ -> decode.failure(ProductstatusAvailable, "Productstatus")
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

pub type Provenanceentityrole {
  ProvenanceentityroleDerivation
  ProvenanceentityroleRevision
  ProvenanceentityroleQuotation
  ProvenanceentityroleSource
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
    ProvenanceentityroleDerivation -> "derivation"
    ProvenanceentityroleRevision -> "revision"
    ProvenanceentityroleQuotation -> "quotation"
    ProvenanceentityroleSource -> "source"
    ProvenanceentityroleRemoval -> "removal"
  }
}

pub fn provenanceentityrole_from_string(
  s: String,
) -> Result(Provenanceentityrole, Nil) {
  case s {
    "derivation" -> Ok(ProvenanceentityroleDerivation)
    "revision" -> Ok(ProvenanceentityroleRevision)
    "quotation" -> Ok(ProvenanceentityroleQuotation)
    "source" -> Ok(ProvenanceentityroleSource)
    "removal" -> Ok(ProvenanceentityroleRemoval)
    _ -> Error(Nil)
  }
}

pub fn provenanceentityrole_decoder() -> Decoder(Provenanceentityrole) {
  use variant <- decode.then(decode.string)
  case variant {
    "derivation" -> decode.success(ProvenanceentityroleDerivation)
    "revision" -> decode.success(ProvenanceentityroleRevision)
    "quotation" -> decode.success(ProvenanceentityroleQuotation)
    "source" -> decode.success(ProvenanceentityroleSource)
    "removal" -> decode.success(ProvenanceentityroleRemoval)
    _ -> decode.failure(ProvenanceentityroleDerivation, "Provenanceentityrole")
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
    _ -> decode.failure(AssertoperatorcodesEquals, "Assertoperatorcodes")
  }
}

pub type Devicestatus {
  DevicestatusActive
  DevicestatusInactive
  DevicestatusEnteredinerror
  DevicestatusUnknown
}

pub fn devicestatus_to_json(devicestatus: Devicestatus) -> Json {
  json.string(devicestatus_to_string(devicestatus))
}

pub fn devicestatus_to_string(devicestatus: Devicestatus) -> String {
  case devicestatus {
    DevicestatusActive -> "active"
    DevicestatusInactive -> "inactive"
    DevicestatusEnteredinerror -> "entered-in-error"
    DevicestatusUnknown -> "unknown"
  }
}

pub fn devicestatus_from_string(s: String) -> Result(Devicestatus, Nil) {
  case s {
    "active" -> Ok(DevicestatusActive)
    "inactive" -> Ok(DevicestatusInactive)
    "entered-in-error" -> Ok(DevicestatusEnteredinerror)
    "unknown" -> Ok(DevicestatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn devicestatus_decoder() -> Decoder(Devicestatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(DevicestatusActive)
    "inactive" -> decode.success(DevicestatusInactive)
    "entered-in-error" -> decode.success(DevicestatusEnteredinerror)
    "unknown" -> decode.success(DevicestatusUnknown)
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

pub type Discriminatortype {
  DiscriminatortypeValue
  DiscriminatortypeExists
  DiscriminatortypePattern
  DiscriminatortypeType
  DiscriminatortypeProfile
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

pub type Remittanceoutcome {
  RemittanceoutcomeQueued
  RemittanceoutcomeComplete
  RemittanceoutcomeError
  RemittanceoutcomePartial
}

pub fn remittanceoutcome_to_json(remittanceoutcome: Remittanceoutcome) -> Json {
  json.string(remittanceoutcome_to_string(remittanceoutcome))
}

pub fn remittanceoutcome_to_string(
  remittanceoutcome: Remittanceoutcome,
) -> String {
  case remittanceoutcome {
    RemittanceoutcomeQueued -> "queued"
    RemittanceoutcomeComplete -> "complete"
    RemittanceoutcomeError -> "error"
    RemittanceoutcomePartial -> "partial"
  }
}

pub fn remittanceoutcome_from_string(
  s: String,
) -> Result(Remittanceoutcome, Nil) {
  case s {
    "queued" -> Ok(RemittanceoutcomeQueued)
    "complete" -> Ok(RemittanceoutcomeComplete)
    "error" -> Ok(RemittanceoutcomeError)
    "partial" -> Ok(RemittanceoutcomePartial)
    _ -> Error(Nil)
  }
}

pub fn remittanceoutcome_decoder() -> Decoder(Remittanceoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "queued" -> decode.success(RemittanceoutcomeQueued)
    "complete" -> decode.success(RemittanceoutcomeComplete)
    "error" -> decode.success(RemittanceoutcomeError)
    "partial" -> decode.success(RemittanceoutcomePartial)
    _ -> decode.failure(RemittanceoutcomeQueued, "Remittanceoutcome")
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

pub type Examplescenarioactortype {
  ExamplescenarioactortypePerson
  ExamplescenarioactortypeEntity
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
    ExamplescenarioactortypeEntity -> "entity"
  }
}

pub fn examplescenarioactortype_from_string(
  s: String,
) -> Result(Examplescenarioactortype, Nil) {
  case s {
    "person" -> Ok(ExamplescenarioactortypePerson)
    "entity" -> Ok(ExamplescenarioactortypeEntity)
    _ -> Error(Nil)
  }
}

pub fn examplescenarioactortype_decoder() -> Decoder(Examplescenarioactortype) {
  use variant <- decode.then(decode.string)
  case variant {
    "person" -> decode.success(ExamplescenarioactortypePerson)
    "entity" -> decode.success(ExamplescenarioactortypeEntity)
    _ ->
      decode.failure(ExamplescenarioactortypePerson, "Examplescenarioactortype")
  }
}

pub type Networktype {
  Networktype1
  Networktype2
  Networktype3
  Networktype4
  Networktype5
}

pub fn networktype_to_json(networktype: Networktype) -> Json {
  json.string(networktype_to_string(networktype))
}

pub fn networktype_to_string(networktype: Networktype) -> String {
  case networktype {
    Networktype1 -> "1"
    Networktype2 -> "2"
    Networktype3 -> "3"
    Networktype4 -> "4"
    Networktype5 -> "5"
  }
}

pub fn networktype_from_string(s: String) -> Result(Networktype, Nil) {
  case s {
    "1" -> Ok(Networktype1)
    "2" -> Ok(Networktype2)
    "3" -> Ok(Networktype3)
    "4" -> Ok(Networktype4)
    "5" -> Ok(Networktype5)
    _ -> Error(Nil)
  }
}

pub fn networktype_decoder() -> Decoder(Networktype) {
  use variant <- decode.then(decode.string)
  case variant {
    "1" -> decode.success(Networktype1)
    "2" -> decode.success(Networktype2)
    "3" -> decode.success(Networktype3)
    "4" -> decode.success(Networktype4)
    "5" -> decode.success(Networktype5)
    _ -> decode.failure(Networktype1, "Networktype")
  }
}

pub type Conceptmapequivalence {
  ConceptmapequivalenceRelatedto
  ConceptmapequivalenceEquivalent
  ConceptmapequivalenceEqual
  ConceptmapequivalenceWider
  ConceptmapequivalenceSubsumes
  ConceptmapequivalenceNarrower
  ConceptmapequivalenceSpecializes
  ConceptmapequivalenceInexact
  ConceptmapequivalenceUnmatched
  ConceptmapequivalenceDisjoint
}

pub fn conceptmapequivalence_to_json(
  conceptmapequivalence: Conceptmapequivalence,
) -> Json {
  json.string(conceptmapequivalence_to_string(conceptmapequivalence))
}

pub fn conceptmapequivalence_to_string(
  conceptmapequivalence: Conceptmapequivalence,
) -> String {
  case conceptmapequivalence {
    ConceptmapequivalenceRelatedto -> "relatedto"
    ConceptmapequivalenceEquivalent -> "equivalent"
    ConceptmapequivalenceEqual -> "equal"
    ConceptmapequivalenceWider -> "wider"
    ConceptmapequivalenceSubsumes -> "subsumes"
    ConceptmapequivalenceNarrower -> "narrower"
    ConceptmapequivalenceSpecializes -> "specializes"
    ConceptmapequivalenceInexact -> "inexact"
    ConceptmapequivalenceUnmatched -> "unmatched"
    ConceptmapequivalenceDisjoint -> "disjoint"
  }
}

pub fn conceptmapequivalence_from_string(
  s: String,
) -> Result(Conceptmapequivalence, Nil) {
  case s {
    "relatedto" -> Ok(ConceptmapequivalenceRelatedto)
    "equivalent" -> Ok(ConceptmapequivalenceEquivalent)
    "equal" -> Ok(ConceptmapequivalenceEqual)
    "wider" -> Ok(ConceptmapequivalenceWider)
    "subsumes" -> Ok(ConceptmapequivalenceSubsumes)
    "narrower" -> Ok(ConceptmapequivalenceNarrower)
    "specializes" -> Ok(ConceptmapequivalenceSpecializes)
    "inexact" -> Ok(ConceptmapequivalenceInexact)
    "unmatched" -> Ok(ConceptmapequivalenceUnmatched)
    "disjoint" -> Ok(ConceptmapequivalenceDisjoint)
    _ -> Error(Nil)
  }
}

pub fn conceptmapequivalence_decoder() -> Decoder(Conceptmapequivalence) {
  use variant <- decode.then(decode.string)
  case variant {
    "relatedto" -> decode.success(ConceptmapequivalenceRelatedto)
    "equivalent" -> decode.success(ConceptmapequivalenceEquivalent)
    "equal" -> decode.success(ConceptmapequivalenceEqual)
    "wider" -> decode.success(ConceptmapequivalenceWider)
    "subsumes" -> decode.success(ConceptmapequivalenceSubsumes)
    "narrower" -> decode.success(ConceptmapequivalenceNarrower)
    "specializes" -> decode.success(ConceptmapequivalenceSpecializes)
    "inexact" -> decode.success(ConceptmapequivalenceInexact)
    "unmatched" -> decode.success(ConceptmapequivalenceUnmatched)
    "disjoint" -> decode.success(ConceptmapequivalenceDisjoint)
    _ -> decode.failure(ConceptmapequivalenceRelatedto, "Conceptmapequivalence")
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

pub type Devicestatementstatus {
  DevicestatementstatusActive
  DevicestatementstatusCompleted
  DevicestatementstatusEnteredinerror
  DevicestatementstatusIntended
  DevicestatementstatusStopped
  DevicestatementstatusOnhold
}

pub fn devicestatementstatus_to_json(
  devicestatementstatus: Devicestatementstatus,
) -> Json {
  json.string(devicestatementstatus_to_string(devicestatementstatus))
}

pub fn devicestatementstatus_to_string(
  devicestatementstatus: Devicestatementstatus,
) -> String {
  case devicestatementstatus {
    DevicestatementstatusActive -> "active"
    DevicestatementstatusCompleted -> "completed"
    DevicestatementstatusEnteredinerror -> "entered-in-error"
    DevicestatementstatusIntended -> "intended"
    DevicestatementstatusStopped -> "stopped"
    DevicestatementstatusOnhold -> "on-hold"
  }
}

pub fn devicestatementstatus_from_string(
  s: String,
) -> Result(Devicestatementstatus, Nil) {
  case s {
    "active" -> Ok(DevicestatementstatusActive)
    "completed" -> Ok(DevicestatementstatusCompleted)
    "entered-in-error" -> Ok(DevicestatementstatusEnteredinerror)
    "intended" -> Ok(DevicestatementstatusIntended)
    "stopped" -> Ok(DevicestatementstatusStopped)
    "on-hold" -> Ok(DevicestatementstatusOnhold)
    _ -> Error(Nil)
  }
}

pub fn devicestatementstatus_decoder() -> Decoder(Devicestatementstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(DevicestatementstatusActive)
    "completed" -> decode.success(DevicestatementstatusCompleted)
    "entered-in-error" -> decode.success(DevicestatementstatusEnteredinerror)
    "intended" -> decode.success(DevicestatementstatusIntended)
    "stopped" -> decode.success(DevicestatementstatusStopped)
    "on-hold" -> decode.success(DevicestatementstatusOnhold)
    _ -> decode.failure(DevicestatementstatusActive, "Devicestatementstatus")
  }
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

pub fn encounterstatus_to_json(encounterstatus: Encounterstatus) -> Json {
  json.string(encounterstatus_to_string(encounterstatus))
}

pub fn encounterstatus_to_string(encounterstatus: Encounterstatus) -> String {
  case encounterstatus {
    EncounterstatusPlanned -> "planned"
    EncounterstatusArrived -> "arrived"
    EncounterstatusTriaged -> "triaged"
    EncounterstatusInprogress -> "in-progress"
    EncounterstatusOnleave -> "onleave"
    EncounterstatusFinished -> "finished"
    EncounterstatusCancelled -> "cancelled"
    EncounterstatusEnteredinerror -> "entered-in-error"
    EncounterstatusUnknown -> "unknown"
  }
}

pub fn encounterstatus_from_string(s: String) -> Result(Encounterstatus, Nil) {
  case s {
    "planned" -> Ok(EncounterstatusPlanned)
    "arrived" -> Ok(EncounterstatusArrived)
    "triaged" -> Ok(EncounterstatusTriaged)
    "in-progress" -> Ok(EncounterstatusInprogress)
    "onleave" -> Ok(EncounterstatusOnleave)
    "finished" -> Ok(EncounterstatusFinished)
    "cancelled" -> Ok(EncounterstatusCancelled)
    "entered-in-error" -> Ok(EncounterstatusEnteredinerror)
    "unknown" -> Ok(EncounterstatusUnknown)
    _ -> Error(Nil)
  }
}

pub fn encounterstatus_decoder() -> Decoder(Encounterstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "planned" -> decode.success(EncounterstatusPlanned)
    "arrived" -> decode.success(EncounterstatusArrived)
    "triaged" -> decode.success(EncounterstatusTriaged)
    "in-progress" -> decode.success(EncounterstatusInprogress)
    "onleave" -> decode.success(EncounterstatusOnleave)
    "finished" -> decode.success(EncounterstatusFinished)
    "cancelled" -> decode.success(EncounterstatusCancelled)
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

pub fn actionrelationshiptype_to_json(
  actionrelationshiptype: Actionrelationshiptype,
) -> Json {
  json.string(actionrelationshiptype_to_string(actionrelationshiptype))
}

pub fn actionrelationshiptype_to_string(
  actionrelationshiptype: Actionrelationshiptype,
) -> String {
  case actionrelationshiptype {
    ActionrelationshiptypeBeforestart -> "before-start"
    ActionrelationshiptypeBefore -> "before"
    ActionrelationshiptypeBeforeend -> "before-end"
    ActionrelationshiptypeConcurrentwithstart -> "concurrent-with-start"
    ActionrelationshiptypeConcurrent -> "concurrent"
    ActionrelationshiptypeConcurrentwithend -> "concurrent-with-end"
    ActionrelationshiptypeAfterstart -> "after-start"
    ActionrelationshiptypeAfter -> "after"
    ActionrelationshiptypeAfterend -> "after-end"
  }
}

pub fn actionrelationshiptype_from_string(
  s: String,
) -> Result(Actionrelationshiptype, Nil) {
  case s {
    "before-start" -> Ok(ActionrelationshiptypeBeforestart)
    "before" -> Ok(ActionrelationshiptypeBefore)
    "before-end" -> Ok(ActionrelationshiptypeBeforeend)
    "concurrent-with-start" -> Ok(ActionrelationshiptypeConcurrentwithstart)
    "concurrent" -> Ok(ActionrelationshiptypeConcurrent)
    "concurrent-with-end" -> Ok(ActionrelationshiptypeConcurrentwithend)
    "after-start" -> Ok(ActionrelationshiptypeAfterstart)
    "after" -> Ok(ActionrelationshiptypeAfter)
    "after-end" -> Ok(ActionrelationshiptypeAfterend)
    _ -> Error(Nil)
  }
}

pub fn actionrelationshiptype_decoder() -> Decoder(Actionrelationshiptype) {
  use variant <- decode.then(decode.string)
  case variant {
    "before-start" -> decode.success(ActionrelationshiptypeBeforestart)
    "before" -> decode.success(ActionrelationshiptypeBefore)
    "before-end" -> decode.success(ActionrelationshiptypeBeforeend)
    "concurrent-with-start" ->
      decode.success(ActionrelationshiptypeConcurrentwithstart)
    "concurrent" -> decode.success(ActionrelationshiptypeConcurrent)
    "concurrent-with-end" ->
      decode.success(ActionrelationshiptypeConcurrentwithend)
    "after-start" -> decode.success(ActionrelationshiptypeAfterstart)
    "after" -> decode.success(ActionrelationshiptypeAfter)
    "after-end" -> decode.success(ActionrelationshiptypeAfterend)
    _ ->
      decode.failure(
        ActionrelationshiptypeBeforestart,
        "Actionrelationshiptype",
      )
  }
}

pub type Issueseverity {
  IssueseverityFatal
  IssueseverityError
  IssueseverityWarning
  IssueseverityInformation
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
  }
}

pub fn issueseverity_from_string(s: String) -> Result(Issueseverity, Nil) {
  case s {
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
    _ -> decode.failure(IssueseverityFatal, "Issueseverity")
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

pub fn metriccolor_to_json(metriccolor: Metriccolor) -> Json {
  json.string(metriccolor_to_string(metriccolor))
}

pub fn metriccolor_to_string(metriccolor: Metriccolor) -> String {
  case metriccolor {
    MetriccolorBlack -> "black"
    MetriccolorRed -> "red"
    MetriccolorGreen -> "green"
    MetriccolorYellow -> "yellow"
    MetriccolorBlue -> "blue"
    MetriccolorMagenta -> "magenta"
    MetriccolorCyan -> "cyan"
    MetriccolorWhite -> "white"
  }
}

pub fn metriccolor_from_string(s: String) -> Result(Metriccolor, Nil) {
  case s {
    "black" -> Ok(MetriccolorBlack)
    "red" -> Ok(MetriccolorRed)
    "green" -> Ok(MetriccolorGreen)
    "yellow" -> Ok(MetriccolorYellow)
    "blue" -> Ok(MetriccolorBlue)
    "magenta" -> Ok(MetriccolorMagenta)
    "cyan" -> Ok(MetriccolorCyan)
    "white" -> Ok(MetriccolorWhite)
    _ -> Error(Nil)
  }
}

pub fn metriccolor_decoder() -> Decoder(Metriccolor) {
  use variant <- decode.then(decode.string)
  case variant {
    "black" -> decode.success(MetriccolorBlack)
    "red" -> decode.success(MetriccolorRed)
    "green" -> decode.success(MetriccolorGreen)
    "yellow" -> decode.success(MetriccolorYellow)
    "blue" -> decode.success(MetriccolorBlue)
    "magenta" -> decode.success(MetriccolorMagenta)
    "cyan" -> decode.success(MetriccolorCyan)
    "white" -> decode.success(MetriccolorWhite)
    _ -> decode.failure(MetriccolorBlack, "Metriccolor")
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

pub type Subscriptionsearchmodifier {
  SubscriptionsearchmodifierEqual
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

pub fn subscriptionsearchmodifier_to_json(
  subscriptionsearchmodifier: Subscriptionsearchmodifier,
) -> Json {
  json.string(subscriptionsearchmodifier_to_string(subscriptionsearchmodifier))
}

pub fn subscriptionsearchmodifier_to_string(
  subscriptionsearchmodifier: Subscriptionsearchmodifier,
) -> String {
  case subscriptionsearchmodifier {
    SubscriptionsearchmodifierEqual -> "="
    SubscriptionsearchmodifierEq -> "eq"
    SubscriptionsearchmodifierNe -> "ne"
    SubscriptionsearchmodifierGt -> "gt"
    SubscriptionsearchmodifierLt -> "lt"
    SubscriptionsearchmodifierGe -> "ge"
    SubscriptionsearchmodifierLe -> "le"
    SubscriptionsearchmodifierSa -> "sa"
    SubscriptionsearchmodifierEb -> "eb"
    SubscriptionsearchmodifierAp -> "ap"
    SubscriptionsearchmodifierAbove -> "above"
    SubscriptionsearchmodifierBelow -> "below"
    SubscriptionsearchmodifierIn -> "in"
    SubscriptionsearchmodifierNotin -> "not-in"
    SubscriptionsearchmodifierOftype -> "of-type"
  }
}

pub fn subscriptionsearchmodifier_from_string(
  s: String,
) -> Result(Subscriptionsearchmodifier, Nil) {
  case s {
    "=" -> Ok(SubscriptionsearchmodifierEqual)
    "eq" -> Ok(SubscriptionsearchmodifierEq)
    "ne" -> Ok(SubscriptionsearchmodifierNe)
    "gt" -> Ok(SubscriptionsearchmodifierGt)
    "lt" -> Ok(SubscriptionsearchmodifierLt)
    "ge" -> Ok(SubscriptionsearchmodifierGe)
    "le" -> Ok(SubscriptionsearchmodifierLe)
    "sa" -> Ok(SubscriptionsearchmodifierSa)
    "eb" -> Ok(SubscriptionsearchmodifierEb)
    "ap" -> Ok(SubscriptionsearchmodifierAp)
    "above" -> Ok(SubscriptionsearchmodifierAbove)
    "below" -> Ok(SubscriptionsearchmodifierBelow)
    "in" -> Ok(SubscriptionsearchmodifierIn)
    "not-in" -> Ok(SubscriptionsearchmodifierNotin)
    "of-type" -> Ok(SubscriptionsearchmodifierOftype)
    _ -> Error(Nil)
  }
}

pub fn subscriptionsearchmodifier_decoder() -> Decoder(
  Subscriptionsearchmodifier,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "=" -> decode.success(SubscriptionsearchmodifierEqual)
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
    _ ->
      decode.failure(
        SubscriptionsearchmodifierEqual,
        "Subscriptionsearchmodifier",
      )
  }
}

pub type Qualitytype {
  QualitytypeIndel
  QualitytypeSnp
  QualitytypeUnknown
}

pub fn qualitytype_to_json(qualitytype: Qualitytype) -> Json {
  json.string(qualitytype_to_string(qualitytype))
}

pub fn qualitytype_to_string(qualitytype: Qualitytype) -> String {
  case qualitytype {
    QualitytypeIndel -> "indel"
    QualitytypeSnp -> "snp"
    QualitytypeUnknown -> "unknown"
  }
}

pub fn qualitytype_from_string(s: String) -> Result(Qualitytype, Nil) {
  case s {
    "indel" -> Ok(QualitytypeIndel)
    "snp" -> Ok(QualitytypeSnp)
    "unknown" -> Ok(QualitytypeUnknown)
    _ -> Error(Nil)
  }
}

pub fn qualitytype_decoder() -> Decoder(Qualitytype) {
  use variant <- decode.then(decode.string)
  case variant {
    "indel" -> decode.success(QualitytypeIndel)
    "snp" -> decode.success(QualitytypeSnp)
    "unknown" -> decode.success(QualitytypeUnknown)
    _ -> decode.failure(QualitytypeIndel, "Qualitytype")
  }
}

pub type Measurereporttype {
  MeasurereporttypeIndividual
  MeasurereporttypeSubjectlist
  MeasurereporttypeSummary
  MeasurereporttypeDatacollection
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
    MeasurereporttypeDatacollection -> "data-collection"
  }
}

pub fn measurereporttype_from_string(
  s: String,
) -> Result(Measurereporttype, Nil) {
  case s {
    "individual" -> Ok(MeasurereporttypeIndividual)
    "subject-list" -> Ok(MeasurereporttypeSubjectlist)
    "summary" -> Ok(MeasurereporttypeSummary)
    "data-collection" -> Ok(MeasurereporttypeDatacollection)
    _ -> Error(Nil)
  }
}

pub fn measurereporttype_decoder() -> Decoder(Measurereporttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "individual" -> decode.success(MeasurereporttypeIndividual)
    "subject-list" -> decode.success(MeasurereporttypeSubjectlist)
    "summary" -> decode.success(MeasurereporttypeSummary)
    "data-collection" -> decode.success(MeasurereporttypeDatacollection)
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

pub type Productstoragescale {
  ProductstoragescaleFarenheit
  ProductstoragescaleCelsius
  ProductstoragescaleKelvin
}

pub fn productstoragescale_to_json(
  productstoragescale: Productstoragescale,
) -> Json {
  json.string(productstoragescale_to_string(productstoragescale))
}

pub fn productstoragescale_to_string(
  productstoragescale: Productstoragescale,
) -> String {
  case productstoragescale {
    ProductstoragescaleFarenheit -> "farenheit"
    ProductstoragescaleCelsius -> "celsius"
    ProductstoragescaleKelvin -> "kelvin"
  }
}

pub fn productstoragescale_from_string(
  s: String,
) -> Result(Productstoragescale, Nil) {
  case s {
    "farenheit" -> Ok(ProductstoragescaleFarenheit)
    "celsius" -> Ok(ProductstoragescaleCelsius)
    "kelvin" -> Ok(ProductstoragescaleKelvin)
    _ -> Error(Nil)
  }
}

pub fn productstoragescale_decoder() -> Decoder(Productstoragescale) {
  use variant <- decode.then(decode.string)
  case variant {
    "farenheit" -> decode.success(ProductstoragescaleFarenheit)
    "celsius" -> decode.success(ProductstoragescaleCelsius)
    "kelvin" -> decode.success(ProductstoragescaleKelvin)
    _ -> decode.failure(ProductstoragescaleFarenheit, "Productstoragescale")
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

pub type Codesearchsupport {
  CodesearchsupportExplicit
  CodesearchsupportAll
}

pub fn codesearchsupport_to_json(codesearchsupport: Codesearchsupport) -> Json {
  json.string(codesearchsupport_to_string(codesearchsupport))
}

pub fn codesearchsupport_to_string(
  codesearchsupport: Codesearchsupport,
) -> String {
  case codesearchsupport {
    CodesearchsupportExplicit -> "explicit"
    CodesearchsupportAll -> "all"
  }
}

pub fn codesearchsupport_from_string(
  s: String,
) -> Result(Codesearchsupport, Nil) {
  case s {
    "explicit" -> Ok(CodesearchsupportExplicit)
    "all" -> Ok(CodesearchsupportAll)
    _ -> Error(Nil)
  }
}

pub fn codesearchsupport_decoder() -> Decoder(Codesearchsupport) {
  use variant <- decode.then(decode.string)
  case variant {
    "explicit" -> decode.success(CodesearchsupportExplicit)
    "all" -> decode.success(CodesearchsupportAll)
    _ -> decode.failure(CodesearchsupportExplicit, "Codesearchsupport")
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

pub type Endpointstatus {
  EndpointstatusActive
  EndpointstatusSuspended
  EndpointstatusError
  EndpointstatusOff
  EndpointstatusEnteredinerror
  EndpointstatusTest
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
    EndpointstatusTest -> "test"
  }
}

pub fn endpointstatus_from_string(s: String) -> Result(Endpointstatus, Nil) {
  case s {
    "active" -> Ok(EndpointstatusActive)
    "suspended" -> Ok(EndpointstatusSuspended)
    "error" -> Ok(EndpointstatusError)
    "off" -> Ok(EndpointstatusOff)
    "entered-in-error" -> Ok(EndpointstatusEnteredinerror)
    "test" -> Ok(EndpointstatusTest)
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
    "test" -> decode.success(EndpointstatusTest)
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

pub type Graphcompartmentuse {
  GraphcompartmentuseCondition
  GraphcompartmentuseRequirement
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
    GraphcompartmentuseCondition -> "condition"
    GraphcompartmentuseRequirement -> "requirement"
  }
}

pub fn graphcompartmentuse_from_string(
  s: String,
) -> Result(Graphcompartmentuse, Nil) {
  case s {
    "condition" -> Ok(GraphcompartmentuseCondition)
    "requirement" -> Ok(GraphcompartmentuseRequirement)
    _ -> Error(Nil)
  }
}

pub fn graphcompartmentuse_decoder() -> Decoder(Graphcompartmentuse) {
  use variant <- decode.then(decode.string)
  case variant {
    "condition" -> decode.success(GraphcompartmentuseCondition)
    "requirement" -> decode.success(GraphcompartmentuseRequirement)
    _ -> decode.failure(GraphcompartmentuseCondition, "Graphcompartmentuse")
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

pub type Researchelementtype {
  ResearchelementtypePopulation
  ResearchelementtypeExposure
  ResearchelementtypeOutcome
}

pub fn researchelementtype_to_json(
  researchelementtype: Researchelementtype,
) -> Json {
  json.string(researchelementtype_to_string(researchelementtype))
}

pub fn researchelementtype_to_string(
  researchelementtype: Researchelementtype,
) -> String {
  case researchelementtype {
    ResearchelementtypePopulation -> "population"
    ResearchelementtypeExposure -> "exposure"
    ResearchelementtypeOutcome -> "outcome"
  }
}

pub fn researchelementtype_from_string(
  s: String,
) -> Result(Researchelementtype, Nil) {
  case s {
    "population" -> Ok(ResearchelementtypePopulation)
    "exposure" -> Ok(ResearchelementtypeExposure)
    "outcome" -> Ok(ResearchelementtypeOutcome)
    _ -> Error(Nil)
  }
}

pub fn researchelementtype_decoder() -> Decoder(Researchelementtype) {
  use variant <- decode.then(decode.string)
  case variant {
    "population" -> decode.success(ResearchelementtypePopulation)
    "exposure" -> decode.success(ResearchelementtypeExposure)
    "outcome" -> decode.success(ResearchelementtypeOutcome)
    _ -> decode.failure(ResearchelementtypePopulation, "Researchelementtype")
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

pub fn researchsubjectstatus_to_json(
  researchsubjectstatus: Researchsubjectstatus,
) -> Json {
  json.string(researchsubjectstatus_to_string(researchsubjectstatus))
}

pub fn researchsubjectstatus_to_string(
  researchsubjectstatus: Researchsubjectstatus,
) -> String {
  case researchsubjectstatus {
    ResearchsubjectstatusCandidate -> "candidate"
    ResearchsubjectstatusEligible -> "eligible"
    ResearchsubjectstatusFollowup -> "follow-up"
    ResearchsubjectstatusIneligible -> "ineligible"
    ResearchsubjectstatusNotregistered -> "not-registered"
    ResearchsubjectstatusOffstudy -> "off-study"
    ResearchsubjectstatusOnstudy -> "on-study"
    ResearchsubjectstatusOnstudyintervention -> "on-study-intervention"
    ResearchsubjectstatusOnstudyobservation -> "on-study-observation"
    ResearchsubjectstatusPendingonstudy -> "pending-on-study"
    ResearchsubjectstatusPotentialcandidate -> "potential-candidate"
    ResearchsubjectstatusScreening -> "screening"
    ResearchsubjectstatusWithdrawn -> "withdrawn"
  }
}

pub fn researchsubjectstatus_from_string(
  s: String,
) -> Result(Researchsubjectstatus, Nil) {
  case s {
    "candidate" -> Ok(ResearchsubjectstatusCandidate)
    "eligible" -> Ok(ResearchsubjectstatusEligible)
    "follow-up" -> Ok(ResearchsubjectstatusFollowup)
    "ineligible" -> Ok(ResearchsubjectstatusIneligible)
    "not-registered" -> Ok(ResearchsubjectstatusNotregistered)
    "off-study" -> Ok(ResearchsubjectstatusOffstudy)
    "on-study" -> Ok(ResearchsubjectstatusOnstudy)
    "on-study-intervention" -> Ok(ResearchsubjectstatusOnstudyintervention)
    "on-study-observation" -> Ok(ResearchsubjectstatusOnstudyobservation)
    "pending-on-study" -> Ok(ResearchsubjectstatusPendingonstudy)
    "potential-candidate" -> Ok(ResearchsubjectstatusPotentialcandidate)
    "screening" -> Ok(ResearchsubjectstatusScreening)
    "withdrawn" -> Ok(ResearchsubjectstatusWithdrawn)
    _ -> Error(Nil)
  }
}

pub fn researchsubjectstatus_decoder() -> Decoder(Researchsubjectstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "candidate" -> decode.success(ResearchsubjectstatusCandidate)
    "eligible" -> decode.success(ResearchsubjectstatusEligible)
    "follow-up" -> decode.success(ResearchsubjectstatusFollowup)
    "ineligible" -> decode.success(ResearchsubjectstatusIneligible)
    "not-registered" -> decode.success(ResearchsubjectstatusNotregistered)
    "off-study" -> decode.success(ResearchsubjectstatusOffstudy)
    "on-study" -> decode.success(ResearchsubjectstatusOnstudy)
    "on-study-intervention" ->
      decode.success(ResearchsubjectstatusOnstudyintervention)
    "on-study-observation" ->
      decode.success(ResearchsubjectstatusOnstudyobservation)
    "pending-on-study" -> decode.success(ResearchsubjectstatusPendingonstudy)
    "potential-candidate" ->
      decode.success(ResearchsubjectstatusPotentialcandidate)
    "screening" -> decode.success(ResearchsubjectstatusScreening)
    "withdrawn" -> decode.success(ResearchsubjectstatusWithdrawn)
    _ -> decode.failure(ResearchsubjectstatusCandidate, "Researchsubjectstatus")
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
    MedicationrequeststatusCancelled -> "cancelled"
    MedicationrequeststatusCompleted -> "completed"
    MedicationrequeststatusEnteredinerror -> "entered-in-error"
    MedicationrequeststatusStopped -> "stopped"
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
    "cancelled" -> Ok(MedicationrequeststatusCancelled)
    "completed" -> Ok(MedicationrequeststatusCompleted)
    "entered-in-error" -> Ok(MedicationrequeststatusEnteredinerror)
    "stopped" -> Ok(MedicationrequeststatusStopped)
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
    "cancelled" -> decode.success(MedicationrequeststatusCancelled)
    "completed" -> decode.success(MedicationrequeststatusCompleted)
    "entered-in-error" -> decode.success(MedicationrequeststatusEnteredinerror)
    "stopped" -> decode.success(MedicationrequeststatusStopped)
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

pub type Alltypes {
  AlltypesAddress
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
  AlltypesBinary
  AlltypesBundle
  AlltypesDomainresource
  AlltypesAccount
  AlltypesActivitydefinition
  AlltypesAdministrableproductdefinition
  AlltypesAdverseevent
  AlltypesAllergyintolerance
  AlltypesAppointment
  AlltypesAppointmentresponse
  AlltypesAuditevent
  AlltypesBasic
  AlltypesBiologicallyderivedproduct
  AlltypesBodystructure
  AlltypesCapabilitystatement
  AlltypesCareplan
  AlltypesCareteam
  AlltypesCatalogentry
  AlltypesChargeitem
  AlltypesChargeitemdefinition
  AlltypesCitation
  AlltypesClaim
  AlltypesClaimresponse
  AlltypesClinicalimpression
  AlltypesClinicalusedefinition
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
  AlltypesEncounter
  AlltypesEndpoint
  AlltypesEnrollmentrequest
  AlltypesEnrollmentresponse
  AlltypesEpisodeofcare
  AlltypesEventdefinition
  AlltypesEvidence
  AlltypesEvidencereport
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
  AlltypesIngredient
  AlltypesInsuranceplan
  AlltypesInvoice
  AlltypesLibrary
  AlltypesLinkage
  AlltypesList
  AlltypesLocation
  AlltypesManufactureditemdefinition
  AlltypesMeasure
  AlltypesMeasurereport
  AlltypesMedia
  AlltypesMedication
  AlltypesMedicationadministration
  AlltypesMedicationdispense
  AlltypesMedicationknowledge
  AlltypesMedicationrequest
  AlltypesMedicationstatement
  AlltypesMedicinalproductdefinition
  AlltypesMessagedefinition
  AlltypesMessageheader
  AlltypesMolecularsequence
  AlltypesNamingsystem
  AlltypesNutritionorder
  AlltypesNutritionproduct
  AlltypesObservation
  AlltypesObservationdefinition
  AlltypesOperationdefinition
  AlltypesOperationoutcome
  AlltypesOrganization
  AlltypesOrganizationaffiliation
  AlltypesPackagedproductdefinition
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
  AlltypesRegulatedauthorization
  AlltypesRelatedperson
  AlltypesRequestgroup
  AlltypesResearchdefinition
  AlltypesResearchelementdefinition
  AlltypesResearchstudy
  AlltypesResearchsubject
  AlltypesRiskassessment
  AlltypesSchedule
  AlltypesSearchparameter
  AlltypesServicerequest
  AlltypesSlot
  AlltypesSpecimen
  AlltypesSpecimendefinition
  AlltypesStructuredefinition
  AlltypesStructuremap
  AlltypesSubscription
  AlltypesSubscriptionstatus
  AlltypesSubscriptiontopic
  AlltypesSubstance
  AlltypesSubstancedefinition
  AlltypesSupplydelivery
  AlltypesSupplyrequest
  AlltypesTask
  AlltypesTerminologycapabilities
  AlltypesTestreport
  AlltypesTestscript
  AlltypesValueset
  AlltypesVerificationresult
  AlltypesVisionprescription
  AlltypesParameters
  AlltypesType
  AlltypesAny
}

pub fn alltypes_to_json(alltypes: Alltypes) -> Json {
  json.string(alltypes_to_string(alltypes))
}

pub fn alltypes_to_string(alltypes: Alltypes) -> String {
  case alltypes {
    AlltypesAddress -> "Address"
    AlltypesAge -> "Age"
    AlltypesAnnotation -> "Annotation"
    AlltypesAttachment -> "Attachment"
    AlltypesBackboneelement -> "BackboneElement"
    AlltypesCodeableconcept -> "CodeableConcept"
    AlltypesCodeablereference -> "CodeableReference"
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
    AlltypesRatiorange -> "RatioRange"
    AlltypesReference -> "Reference"
    AlltypesRelatedartifact -> "RelatedArtifact"
    AlltypesSampleddata -> "SampledData"
    AlltypesSignature -> "Signature"
    AlltypesSimplequantity -> "SimpleQuantity"
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
    AlltypesResource -> "Resource"
    AlltypesBinary -> "Binary"
    AlltypesBundle -> "Bundle"
    AlltypesDomainresource -> "DomainResource"
    AlltypesAccount -> "Account"
    AlltypesActivitydefinition -> "ActivityDefinition"
    AlltypesAdministrableproductdefinition -> "AdministrableProductDefinition"
    AlltypesAdverseevent -> "AdverseEvent"
    AlltypesAllergyintolerance -> "AllergyIntolerance"
    AlltypesAppointment -> "Appointment"
    AlltypesAppointmentresponse -> "AppointmentResponse"
    AlltypesAuditevent -> "AuditEvent"
    AlltypesBasic -> "Basic"
    AlltypesBiologicallyderivedproduct -> "BiologicallyDerivedProduct"
    AlltypesBodystructure -> "BodyStructure"
    AlltypesCapabilitystatement -> "CapabilityStatement"
    AlltypesCareplan -> "CarePlan"
    AlltypesCareteam -> "CareTeam"
    AlltypesCatalogentry -> "CatalogEntry"
    AlltypesChargeitem -> "ChargeItem"
    AlltypesChargeitemdefinition -> "ChargeItemDefinition"
    AlltypesCitation -> "Citation"
    AlltypesClaim -> "Claim"
    AlltypesClaimresponse -> "ClaimResponse"
    AlltypesClinicalimpression -> "ClinicalImpression"
    AlltypesClinicalusedefinition -> "ClinicalUseDefinition"
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
    AlltypesEncounter -> "Encounter"
    AlltypesEndpoint -> "Endpoint"
    AlltypesEnrollmentrequest -> "EnrollmentRequest"
    AlltypesEnrollmentresponse -> "EnrollmentResponse"
    AlltypesEpisodeofcare -> "EpisodeOfCare"
    AlltypesEventdefinition -> "EventDefinition"
    AlltypesEvidence -> "Evidence"
    AlltypesEvidencereport -> "EvidenceReport"
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
    AlltypesIngredient -> "Ingredient"
    AlltypesInsuranceplan -> "InsurancePlan"
    AlltypesInvoice -> "Invoice"
    AlltypesLibrary -> "Library"
    AlltypesLinkage -> "Linkage"
    AlltypesList -> "List"
    AlltypesLocation -> "Location"
    AlltypesManufactureditemdefinition -> "ManufacturedItemDefinition"
    AlltypesMeasure -> "Measure"
    AlltypesMeasurereport -> "MeasureReport"
    AlltypesMedia -> "Media"
    AlltypesMedication -> "Medication"
    AlltypesMedicationadministration -> "MedicationAdministration"
    AlltypesMedicationdispense -> "MedicationDispense"
    AlltypesMedicationknowledge -> "MedicationKnowledge"
    AlltypesMedicationrequest -> "MedicationRequest"
    AlltypesMedicationstatement -> "MedicationStatement"
    AlltypesMedicinalproductdefinition -> "MedicinalProductDefinition"
    AlltypesMessagedefinition -> "MessageDefinition"
    AlltypesMessageheader -> "MessageHeader"
    AlltypesMolecularsequence -> "MolecularSequence"
    AlltypesNamingsystem -> "NamingSystem"
    AlltypesNutritionorder -> "NutritionOrder"
    AlltypesNutritionproduct -> "NutritionProduct"
    AlltypesObservation -> "Observation"
    AlltypesObservationdefinition -> "ObservationDefinition"
    AlltypesOperationdefinition -> "OperationDefinition"
    AlltypesOperationoutcome -> "OperationOutcome"
    AlltypesOrganization -> "Organization"
    AlltypesOrganizationaffiliation -> "OrganizationAffiliation"
    AlltypesPackagedproductdefinition -> "PackagedProductDefinition"
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
    AlltypesRegulatedauthorization -> "RegulatedAuthorization"
    AlltypesRelatedperson -> "RelatedPerson"
    AlltypesRequestgroup -> "RequestGroup"
    AlltypesResearchdefinition -> "ResearchDefinition"
    AlltypesResearchelementdefinition -> "ResearchElementDefinition"
    AlltypesResearchstudy -> "ResearchStudy"
    AlltypesResearchsubject -> "ResearchSubject"
    AlltypesRiskassessment -> "RiskAssessment"
    AlltypesSchedule -> "Schedule"
    AlltypesSearchparameter -> "SearchParameter"
    AlltypesServicerequest -> "ServiceRequest"
    AlltypesSlot -> "Slot"
    AlltypesSpecimen -> "Specimen"
    AlltypesSpecimendefinition -> "SpecimenDefinition"
    AlltypesStructuredefinition -> "StructureDefinition"
    AlltypesStructuremap -> "StructureMap"
    AlltypesSubscription -> "Subscription"
    AlltypesSubscriptionstatus -> "SubscriptionStatus"
    AlltypesSubscriptiontopic -> "SubscriptionTopic"
    AlltypesSubstance -> "Substance"
    AlltypesSubstancedefinition -> "SubstanceDefinition"
    AlltypesSupplydelivery -> "SupplyDelivery"
    AlltypesSupplyrequest -> "SupplyRequest"
    AlltypesTask -> "Task"
    AlltypesTerminologycapabilities -> "TerminologyCapabilities"
    AlltypesTestreport -> "TestReport"
    AlltypesTestscript -> "TestScript"
    AlltypesValueset -> "ValueSet"
    AlltypesVerificationresult -> "VerificationResult"
    AlltypesVisionprescription -> "VisionPrescription"
    AlltypesParameters -> "Parameters"
    AlltypesType -> "Type"
    AlltypesAny -> "Any"
  }
}

pub fn alltypes_from_string(s: String) -> Result(Alltypes, Nil) {
  case s {
    "Address" -> Ok(AlltypesAddress)
    "Age" -> Ok(AlltypesAge)
    "Annotation" -> Ok(AlltypesAnnotation)
    "Attachment" -> Ok(AlltypesAttachment)
    "BackboneElement" -> Ok(AlltypesBackboneelement)
    "CodeableConcept" -> Ok(AlltypesCodeableconcept)
    "CodeableReference" -> Ok(AlltypesCodeablereference)
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
    "RatioRange" -> Ok(AlltypesRatiorange)
    "Reference" -> Ok(AlltypesReference)
    "RelatedArtifact" -> Ok(AlltypesRelatedartifact)
    "SampledData" -> Ok(AlltypesSampleddata)
    "Signature" -> Ok(AlltypesSignature)
    "SimpleQuantity" -> Ok(AlltypesSimplequantity)
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
    "Resource" -> Ok(AlltypesResource)
    "Binary" -> Ok(AlltypesBinary)
    "Bundle" -> Ok(AlltypesBundle)
    "DomainResource" -> Ok(AlltypesDomainresource)
    "Account" -> Ok(AlltypesAccount)
    "ActivityDefinition" -> Ok(AlltypesActivitydefinition)
    "AdministrableProductDefinition" ->
      Ok(AlltypesAdministrableproductdefinition)
    "AdverseEvent" -> Ok(AlltypesAdverseevent)
    "AllergyIntolerance" -> Ok(AlltypesAllergyintolerance)
    "Appointment" -> Ok(AlltypesAppointment)
    "AppointmentResponse" -> Ok(AlltypesAppointmentresponse)
    "AuditEvent" -> Ok(AlltypesAuditevent)
    "Basic" -> Ok(AlltypesBasic)
    "BiologicallyDerivedProduct" -> Ok(AlltypesBiologicallyderivedproduct)
    "BodyStructure" -> Ok(AlltypesBodystructure)
    "CapabilityStatement" -> Ok(AlltypesCapabilitystatement)
    "CarePlan" -> Ok(AlltypesCareplan)
    "CareTeam" -> Ok(AlltypesCareteam)
    "CatalogEntry" -> Ok(AlltypesCatalogentry)
    "ChargeItem" -> Ok(AlltypesChargeitem)
    "ChargeItemDefinition" -> Ok(AlltypesChargeitemdefinition)
    "Citation" -> Ok(AlltypesCitation)
    "Claim" -> Ok(AlltypesClaim)
    "ClaimResponse" -> Ok(AlltypesClaimresponse)
    "ClinicalImpression" -> Ok(AlltypesClinicalimpression)
    "ClinicalUseDefinition" -> Ok(AlltypesClinicalusedefinition)
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
    "Encounter" -> Ok(AlltypesEncounter)
    "Endpoint" -> Ok(AlltypesEndpoint)
    "EnrollmentRequest" -> Ok(AlltypesEnrollmentrequest)
    "EnrollmentResponse" -> Ok(AlltypesEnrollmentresponse)
    "EpisodeOfCare" -> Ok(AlltypesEpisodeofcare)
    "EventDefinition" -> Ok(AlltypesEventdefinition)
    "Evidence" -> Ok(AlltypesEvidence)
    "EvidenceReport" -> Ok(AlltypesEvidencereport)
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
    "Ingredient" -> Ok(AlltypesIngredient)
    "InsurancePlan" -> Ok(AlltypesInsuranceplan)
    "Invoice" -> Ok(AlltypesInvoice)
    "Library" -> Ok(AlltypesLibrary)
    "Linkage" -> Ok(AlltypesLinkage)
    "List" -> Ok(AlltypesList)
    "Location" -> Ok(AlltypesLocation)
    "ManufacturedItemDefinition" -> Ok(AlltypesManufactureditemdefinition)
    "Measure" -> Ok(AlltypesMeasure)
    "MeasureReport" -> Ok(AlltypesMeasurereport)
    "Media" -> Ok(AlltypesMedia)
    "Medication" -> Ok(AlltypesMedication)
    "MedicationAdministration" -> Ok(AlltypesMedicationadministration)
    "MedicationDispense" -> Ok(AlltypesMedicationdispense)
    "MedicationKnowledge" -> Ok(AlltypesMedicationknowledge)
    "MedicationRequest" -> Ok(AlltypesMedicationrequest)
    "MedicationStatement" -> Ok(AlltypesMedicationstatement)
    "MedicinalProductDefinition" -> Ok(AlltypesMedicinalproductdefinition)
    "MessageDefinition" -> Ok(AlltypesMessagedefinition)
    "MessageHeader" -> Ok(AlltypesMessageheader)
    "MolecularSequence" -> Ok(AlltypesMolecularsequence)
    "NamingSystem" -> Ok(AlltypesNamingsystem)
    "NutritionOrder" -> Ok(AlltypesNutritionorder)
    "NutritionProduct" -> Ok(AlltypesNutritionproduct)
    "Observation" -> Ok(AlltypesObservation)
    "ObservationDefinition" -> Ok(AlltypesObservationdefinition)
    "OperationDefinition" -> Ok(AlltypesOperationdefinition)
    "OperationOutcome" -> Ok(AlltypesOperationoutcome)
    "Organization" -> Ok(AlltypesOrganization)
    "OrganizationAffiliation" -> Ok(AlltypesOrganizationaffiliation)
    "PackagedProductDefinition" -> Ok(AlltypesPackagedproductdefinition)
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
    "RegulatedAuthorization" -> Ok(AlltypesRegulatedauthorization)
    "RelatedPerson" -> Ok(AlltypesRelatedperson)
    "RequestGroup" -> Ok(AlltypesRequestgroup)
    "ResearchDefinition" -> Ok(AlltypesResearchdefinition)
    "ResearchElementDefinition" -> Ok(AlltypesResearchelementdefinition)
    "ResearchStudy" -> Ok(AlltypesResearchstudy)
    "ResearchSubject" -> Ok(AlltypesResearchsubject)
    "RiskAssessment" -> Ok(AlltypesRiskassessment)
    "Schedule" -> Ok(AlltypesSchedule)
    "SearchParameter" -> Ok(AlltypesSearchparameter)
    "ServiceRequest" -> Ok(AlltypesServicerequest)
    "Slot" -> Ok(AlltypesSlot)
    "Specimen" -> Ok(AlltypesSpecimen)
    "SpecimenDefinition" -> Ok(AlltypesSpecimendefinition)
    "StructureDefinition" -> Ok(AlltypesStructuredefinition)
    "StructureMap" -> Ok(AlltypesStructuremap)
    "Subscription" -> Ok(AlltypesSubscription)
    "SubscriptionStatus" -> Ok(AlltypesSubscriptionstatus)
    "SubscriptionTopic" -> Ok(AlltypesSubscriptiontopic)
    "Substance" -> Ok(AlltypesSubstance)
    "SubstanceDefinition" -> Ok(AlltypesSubstancedefinition)
    "SupplyDelivery" -> Ok(AlltypesSupplydelivery)
    "SupplyRequest" -> Ok(AlltypesSupplyrequest)
    "Task" -> Ok(AlltypesTask)
    "TerminologyCapabilities" -> Ok(AlltypesTerminologycapabilities)
    "TestReport" -> Ok(AlltypesTestreport)
    "TestScript" -> Ok(AlltypesTestscript)
    "ValueSet" -> Ok(AlltypesValueset)
    "VerificationResult" -> Ok(AlltypesVerificationresult)
    "VisionPrescription" -> Ok(AlltypesVisionprescription)
    "Parameters" -> Ok(AlltypesParameters)
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
    "Binary" -> decode.success(AlltypesBinary)
    "Bundle" -> decode.success(AlltypesBundle)
    "DomainResource" -> decode.success(AlltypesDomainresource)
    "Account" -> decode.success(AlltypesAccount)
    "ActivityDefinition" -> decode.success(AlltypesActivitydefinition)
    "AdministrableProductDefinition" ->
      decode.success(AlltypesAdministrableproductdefinition)
    "AdverseEvent" -> decode.success(AlltypesAdverseevent)
    "AllergyIntolerance" -> decode.success(AlltypesAllergyintolerance)
    "Appointment" -> decode.success(AlltypesAppointment)
    "AppointmentResponse" -> decode.success(AlltypesAppointmentresponse)
    "AuditEvent" -> decode.success(AlltypesAuditevent)
    "Basic" -> decode.success(AlltypesBasic)
    "BiologicallyDerivedProduct" ->
      decode.success(AlltypesBiologicallyderivedproduct)
    "BodyStructure" -> decode.success(AlltypesBodystructure)
    "CapabilityStatement" -> decode.success(AlltypesCapabilitystatement)
    "CarePlan" -> decode.success(AlltypesCareplan)
    "CareTeam" -> decode.success(AlltypesCareteam)
    "CatalogEntry" -> decode.success(AlltypesCatalogentry)
    "ChargeItem" -> decode.success(AlltypesChargeitem)
    "ChargeItemDefinition" -> decode.success(AlltypesChargeitemdefinition)
    "Citation" -> decode.success(AlltypesCitation)
    "Claim" -> decode.success(AlltypesClaim)
    "ClaimResponse" -> decode.success(AlltypesClaimresponse)
    "ClinicalImpression" -> decode.success(AlltypesClinicalimpression)
    "ClinicalUseDefinition" -> decode.success(AlltypesClinicalusedefinition)
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
    "Encounter" -> decode.success(AlltypesEncounter)
    "Endpoint" -> decode.success(AlltypesEndpoint)
    "EnrollmentRequest" -> decode.success(AlltypesEnrollmentrequest)
    "EnrollmentResponse" -> decode.success(AlltypesEnrollmentresponse)
    "EpisodeOfCare" -> decode.success(AlltypesEpisodeofcare)
    "EventDefinition" -> decode.success(AlltypesEventdefinition)
    "Evidence" -> decode.success(AlltypesEvidence)
    "EvidenceReport" -> decode.success(AlltypesEvidencereport)
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
    "Ingredient" -> decode.success(AlltypesIngredient)
    "InsurancePlan" -> decode.success(AlltypesInsuranceplan)
    "Invoice" -> decode.success(AlltypesInvoice)
    "Library" -> decode.success(AlltypesLibrary)
    "Linkage" -> decode.success(AlltypesLinkage)
    "List" -> decode.success(AlltypesList)
    "Location" -> decode.success(AlltypesLocation)
    "ManufacturedItemDefinition" ->
      decode.success(AlltypesManufactureditemdefinition)
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
    "MedicinalProductDefinition" ->
      decode.success(AlltypesMedicinalproductdefinition)
    "MessageDefinition" -> decode.success(AlltypesMessagedefinition)
    "MessageHeader" -> decode.success(AlltypesMessageheader)
    "MolecularSequence" -> decode.success(AlltypesMolecularsequence)
    "NamingSystem" -> decode.success(AlltypesNamingsystem)
    "NutritionOrder" -> decode.success(AlltypesNutritionorder)
    "NutritionProduct" -> decode.success(AlltypesNutritionproduct)
    "Observation" -> decode.success(AlltypesObservation)
    "ObservationDefinition" -> decode.success(AlltypesObservationdefinition)
    "OperationDefinition" -> decode.success(AlltypesOperationdefinition)
    "OperationOutcome" -> decode.success(AlltypesOperationoutcome)
    "Organization" -> decode.success(AlltypesOrganization)
    "OrganizationAffiliation" -> decode.success(AlltypesOrganizationaffiliation)
    "PackagedProductDefinition" ->
      decode.success(AlltypesPackagedproductdefinition)
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
    "RegulatedAuthorization" -> decode.success(AlltypesRegulatedauthorization)
    "RelatedPerson" -> decode.success(AlltypesRelatedperson)
    "RequestGroup" -> decode.success(AlltypesRequestgroup)
    "ResearchDefinition" -> decode.success(AlltypesResearchdefinition)
    "ResearchElementDefinition" ->
      decode.success(AlltypesResearchelementdefinition)
    "ResearchStudy" -> decode.success(AlltypesResearchstudy)
    "ResearchSubject" -> decode.success(AlltypesResearchsubject)
    "RiskAssessment" -> decode.success(AlltypesRiskassessment)
    "Schedule" -> decode.success(AlltypesSchedule)
    "SearchParameter" -> decode.success(AlltypesSearchparameter)
    "ServiceRequest" -> decode.success(AlltypesServicerequest)
    "Slot" -> decode.success(AlltypesSlot)
    "Specimen" -> decode.success(AlltypesSpecimen)
    "SpecimenDefinition" -> decode.success(AlltypesSpecimendefinition)
    "StructureDefinition" -> decode.success(AlltypesStructuredefinition)
    "StructureMap" -> decode.success(AlltypesStructuremap)
    "Subscription" -> decode.success(AlltypesSubscription)
    "SubscriptionStatus" -> decode.success(AlltypesSubscriptionstatus)
    "SubscriptionTopic" -> decode.success(AlltypesSubscriptiontopic)
    "Substance" -> decode.success(AlltypesSubstance)
    "SubstanceDefinition" -> decode.success(AlltypesSubstancedefinition)
    "SupplyDelivery" -> decode.success(AlltypesSupplydelivery)
    "SupplyRequest" -> decode.success(AlltypesSupplyrequest)
    "Task" -> decode.success(AlltypesTask)
    "TerminologyCapabilities" -> decode.success(AlltypesTerminologycapabilities)
    "TestReport" -> decode.success(AlltypesTestreport)
    "TestScript" -> decode.success(AlltypesTestscript)
    "ValueSet" -> decode.success(AlltypesValueset)
    "VerificationResult" -> decode.success(AlltypesVerificationresult)
    "VisionPrescription" -> decode.success(AlltypesVisionprescription)
    "Parameters" -> decode.success(AlltypesParameters)
    "Type" -> decode.success(AlltypesType)
    "Any" -> decode.success(AlltypesAny)
    _ -> decode.failure(AlltypesAddress, "Alltypes")
  }
}

pub type Consentstatecodes {
  ConsentstatecodesDraft
  ConsentstatecodesProposed
  ConsentstatecodesActive
  ConsentstatecodesRejected
  ConsentstatecodesInactive
  ConsentstatecodesEnteredinerror
}

pub fn consentstatecodes_to_json(consentstatecodes: Consentstatecodes) -> Json {
  json.string(consentstatecodes_to_string(consentstatecodes))
}

pub fn consentstatecodes_to_string(
  consentstatecodes: Consentstatecodes,
) -> String {
  case consentstatecodes {
    ConsentstatecodesDraft -> "draft"
    ConsentstatecodesProposed -> "proposed"
    ConsentstatecodesActive -> "active"
    ConsentstatecodesRejected -> "rejected"
    ConsentstatecodesInactive -> "inactive"
    ConsentstatecodesEnteredinerror -> "entered-in-error"
  }
}

pub fn consentstatecodes_from_string(
  s: String,
) -> Result(Consentstatecodes, Nil) {
  case s {
    "draft" -> Ok(ConsentstatecodesDraft)
    "proposed" -> Ok(ConsentstatecodesProposed)
    "active" -> Ok(ConsentstatecodesActive)
    "rejected" -> Ok(ConsentstatecodesRejected)
    "inactive" -> Ok(ConsentstatecodesInactive)
    "entered-in-error" -> Ok(ConsentstatecodesEnteredinerror)
    _ -> Error(Nil)
  }
}

pub fn consentstatecodes_decoder() -> Decoder(Consentstatecodes) {
  use variant <- decode.then(decode.string)
  case variant {
    "draft" -> decode.success(ConsentstatecodesDraft)
    "proposed" -> decode.success(ConsentstatecodesProposed)
    "active" -> decode.success(ConsentstatecodesActive)
    "rejected" -> decode.success(ConsentstatecodesRejected)
    "inactive" -> decode.success(ConsentstatecodesInactive)
    "entered-in-error" -> decode.success(ConsentstatecodesEnteredinerror)
    _ -> decode.failure(ConsentstatecodesDraft, "Consentstatecodes")
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

pub fn medicationstatementstatus_to_json(
  medicationstatementstatus: Medicationstatementstatus,
) -> Json {
  json.string(medicationstatementstatus_to_string(medicationstatementstatus))
}

pub fn medicationstatementstatus_to_string(
  medicationstatementstatus: Medicationstatementstatus,
) -> String {
  case medicationstatementstatus {
    MedicationstatementstatusActive -> "active"
    MedicationstatementstatusCompleted -> "completed"
    MedicationstatementstatusEnteredinerror -> "entered-in-error"
    MedicationstatementstatusIntended -> "intended"
    MedicationstatementstatusStopped -> "stopped"
    MedicationstatementstatusOnhold -> "on-hold"
    MedicationstatementstatusUnknown -> "unknown"
    MedicationstatementstatusNottaken -> "not-taken"
  }
}

pub fn medicationstatementstatus_from_string(
  s: String,
) -> Result(Medicationstatementstatus, Nil) {
  case s {
    "active" -> Ok(MedicationstatementstatusActive)
    "completed" -> Ok(MedicationstatementstatusCompleted)
    "entered-in-error" -> Ok(MedicationstatementstatusEnteredinerror)
    "intended" -> Ok(MedicationstatementstatusIntended)
    "stopped" -> Ok(MedicationstatementstatusStopped)
    "on-hold" -> Ok(MedicationstatementstatusOnhold)
    "unknown" -> Ok(MedicationstatementstatusUnknown)
    "not-taken" -> Ok(MedicationstatementstatusNottaken)
    _ -> Error(Nil)
  }
}

pub fn medicationstatementstatus_decoder() -> Decoder(Medicationstatementstatus) {
  use variant <- decode.then(decode.string)
  case variant {
    "active" -> decode.success(MedicationstatementstatusActive)
    "completed" -> decode.success(MedicationstatementstatusCompleted)
    "entered-in-error" ->
      decode.success(MedicationstatementstatusEnteredinerror)
    "intended" -> decode.success(MedicationstatementstatusIntended)
    "stopped" -> decode.success(MedicationstatementstatusStopped)
    "on-hold" -> decode.success(MedicationstatementstatusOnhold)
    "unknown" -> decode.success(MedicationstatementstatusUnknown)
    "not-taken" -> decode.success(MedicationstatementstatusNottaken)
    _ ->
      decode.failure(
        MedicationstatementstatusActive,
        "Medicationstatementstatus",
      )
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

pub type Productcategory {
  ProductcategoryOrgan
  ProductcategoryTissue
  ProductcategoryFluid
  ProductcategoryCells
  ProductcategoryBiologicalagent
}

pub fn productcategory_to_json(productcategory: Productcategory) -> Json {
  json.string(productcategory_to_string(productcategory))
}

pub fn productcategory_to_string(productcategory: Productcategory) -> String {
  case productcategory {
    ProductcategoryOrgan -> "organ"
    ProductcategoryTissue -> "tissue"
    ProductcategoryFluid -> "fluid"
    ProductcategoryCells -> "cells"
    ProductcategoryBiologicalagent -> "biologicalAgent"
  }
}

pub fn productcategory_from_string(s: String) -> Result(Productcategory, Nil) {
  case s {
    "organ" -> Ok(ProductcategoryOrgan)
    "tissue" -> Ok(ProductcategoryTissue)
    "fluid" -> Ok(ProductcategoryFluid)
    "cells" -> Ok(ProductcategoryCells)
    "biologicalAgent" -> Ok(ProductcategoryBiologicalagent)
    _ -> Error(Nil)
  }
}

pub fn productcategory_decoder() -> Decoder(Productcategory) {
  use variant <- decode.then(decode.string)
  case variant {
    "organ" -> decode.success(ProductcategoryOrgan)
    "tissue" -> decode.success(ProductcategoryTissue)
    "fluid" -> decode.success(ProductcategoryFluid)
    "cells" -> decode.success(ProductcategoryCells)
    "biologicalAgent" -> decode.success(ProductcategoryBiologicalagent)
    _ -> decode.failure(ProductcategoryOrgan, "Productcategory")
  }
}

pub type Actionparticipanttype {
  ActionparticipanttypePatient
  ActionparticipanttypePractitioner
  ActionparticipanttypeRelatedperson
  ActionparticipanttypeDevice
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
    ActionparticipanttypePatient -> "patient"
    ActionparticipanttypePractitioner -> "practitioner"
    ActionparticipanttypeRelatedperson -> "related-person"
    ActionparticipanttypeDevice -> "device"
  }
}

pub fn actionparticipanttype_from_string(
  s: String,
) -> Result(Actionparticipanttype, Nil) {
  case s {
    "patient" -> Ok(ActionparticipanttypePatient)
    "practitioner" -> Ok(ActionparticipanttypePractitioner)
    "related-person" -> Ok(ActionparticipanttypeRelatedperson)
    "device" -> Ok(ActionparticipanttypeDevice)
    _ -> Error(Nil)
  }
}

pub fn actionparticipanttype_decoder() -> Decoder(Actionparticipanttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "patient" -> decode.success(ActionparticipanttypePatient)
    "practitioner" -> decode.success(ActionparticipanttypePractitioner)
    "related-person" -> decode.success(ActionparticipanttypeRelatedperson)
    "device" -> decode.success(ActionparticipanttypeDevice)
    _ -> decode.failure(ActionparticipanttypePatient, "Actionparticipanttype")
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

pub type Namingsystemidentifiertype {
  NamingsystemidentifiertypeOid
  NamingsystemidentifiertypeUuid
  NamingsystemidentifiertypeUri
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

pub type Participantrequired {
  ParticipantrequiredRequired
  ParticipantrequiredOptional
  ParticipantrequiredInformationonly
}

pub fn participantrequired_to_json(
  participantrequired: Participantrequired,
) -> Json {
  json.string(participantrequired_to_string(participantrequired))
}

pub fn participantrequired_to_string(
  participantrequired: Participantrequired,
) -> String {
  case participantrequired {
    ParticipantrequiredRequired -> "required"
    ParticipantrequiredOptional -> "optional"
    ParticipantrequiredInformationonly -> "information-only"
  }
}

pub fn participantrequired_from_string(
  s: String,
) -> Result(Participantrequired, Nil) {
  case s {
    "required" -> Ok(ParticipantrequiredRequired)
    "optional" -> Ok(ParticipantrequiredOptional)
    "information-only" -> Ok(ParticipantrequiredInformationonly)
    _ -> Error(Nil)
  }
}

pub fn participantrequired_decoder() -> Decoder(Participantrequired) {
  use variant <- decode.then(decode.string)
  case variant {
    "required" -> decode.success(ParticipantrequiredRequired)
    "optional" -> decode.success(ParticipantrequiredOptional)
    "information-only" -> decode.success(ParticipantrequiredInformationonly)
    _ -> decode.failure(ParticipantrequiredRequired, "Participantrequired")
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
  ItemtypeChoice
  ItemtypeOpenchoice
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
    ItemtypeChoice -> "choice"
    ItemtypeOpenchoice -> "open-choice"
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
    "choice" -> Ok(ItemtypeChoice)
    "open-choice" -> Ok(ItemtypeOpenchoice)
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
    "choice" -> decode.success(ItemtypeChoice)
    "open-choice" -> decode.success(ItemtypeOpenchoice)
    "attachment" -> decode.success(ItemtypeAttachment)
    "reference" -> decode.success(ItemtypeReference)
    "quantity" -> decode.success(ItemtypeQuantity)
    _ -> decode.failure(ItemtypeGroup, "Itemtype")
  }
}

pub type Mapcontexttype {
  MapcontexttypeType
  MapcontexttypeVariable
}

pub fn mapcontexttype_to_json(mapcontexttype: Mapcontexttype) -> Json {
  json.string(mapcontexttype_to_string(mapcontexttype))
}

pub fn mapcontexttype_to_string(mapcontexttype: Mapcontexttype) -> String {
  case mapcontexttype {
    MapcontexttypeType -> "type"
    MapcontexttypeVariable -> "variable"
  }
}

pub fn mapcontexttype_from_string(s: String) -> Result(Mapcontexttype, Nil) {
  case s {
    "type" -> Ok(MapcontexttypeType)
    "variable" -> Ok(MapcontexttypeVariable)
    _ -> Error(Nil)
  }
}

pub fn mapcontexttype_decoder() -> Decoder(Mapcontexttype) {
  use variant <- decode.then(decode.string)
  case variant {
    "type" -> decode.success(MapcontexttypeType)
    "variable" -> decode.success(MapcontexttypeVariable)
    _ -> decode.failure(MapcontexttypeType, "Mapcontexttype")
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
    _ -> decode.failure(EventtimingMorn, "Eventtiming")
  }
}

pub type Groupmeasure {
  GroupmeasureMean
  GroupmeasureMedian
  GroupmeasureMeanofmean
  GroupmeasureMeanofmedian
  GroupmeasureMedianofmean
  GroupmeasureMedianofmedian
}

pub fn groupmeasure_to_json(groupmeasure: Groupmeasure) -> Json {
  json.string(groupmeasure_to_string(groupmeasure))
}

pub fn groupmeasure_to_string(groupmeasure: Groupmeasure) -> String {
  case groupmeasure {
    GroupmeasureMean -> "mean"
    GroupmeasureMedian -> "median"
    GroupmeasureMeanofmean -> "mean-of-mean"
    GroupmeasureMeanofmedian -> "mean-of-median"
    GroupmeasureMedianofmean -> "median-of-mean"
    GroupmeasureMedianofmedian -> "median-of-median"
  }
}

pub fn groupmeasure_from_string(s: String) -> Result(Groupmeasure, Nil) {
  case s {
    "mean" -> Ok(GroupmeasureMean)
    "median" -> Ok(GroupmeasureMedian)
    "mean-of-mean" -> Ok(GroupmeasureMeanofmean)
    "mean-of-median" -> Ok(GroupmeasureMeanofmedian)
    "median-of-mean" -> Ok(GroupmeasureMedianofmean)
    "median-of-median" -> Ok(GroupmeasureMedianofmedian)
    _ -> Error(Nil)
  }
}

pub fn groupmeasure_decoder() -> Decoder(Groupmeasure) {
  use variant <- decode.then(decode.string)
  case variant {
    "mean" -> decode.success(GroupmeasureMean)
    "median" -> decode.success(GroupmeasureMedian)
    "mean-of-mean" -> decode.success(GroupmeasureMeanofmean)
    "mean-of-median" -> decode.success(GroupmeasureMeanofmedian)
    "median-of-mean" -> decode.success(GroupmeasureMedianofmean)
    "median-of-median" -> decode.success(GroupmeasureMedianofmedian)
    _ -> decode.failure(GroupmeasureMean, "Groupmeasure")
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

pub type Mapgrouptypemode {
  MapgrouptypemodeNone
  MapgrouptypemodeTypes
  MapgrouptypemodeTypeandtypes
}

pub fn mapgrouptypemode_to_json(mapgrouptypemode: Mapgrouptypemode) -> Json {
  json.string(mapgrouptypemode_to_string(mapgrouptypemode))
}

pub fn mapgrouptypemode_to_string(mapgrouptypemode: Mapgrouptypemode) -> String {
  case mapgrouptypemode {
    MapgrouptypemodeNone -> "none"
    MapgrouptypemodeTypes -> "types"
    MapgrouptypemodeTypeandtypes -> "type-and-types"
  }
}

pub fn mapgrouptypemode_from_string(s: String) -> Result(Mapgrouptypemode, Nil) {
  case s {
    "none" -> Ok(MapgrouptypemodeNone)
    "types" -> Ok(MapgrouptypemodeTypes)
    "type-and-types" -> Ok(MapgrouptypemodeTypeandtypes)
    _ -> Error(Nil)
  }
}

pub fn mapgrouptypemode_decoder() -> Decoder(Mapgrouptypemode) {
  use variant <- decode.then(decode.string)
  case variant {
    "none" -> decode.success(MapgrouptypemodeNone)
    "types" -> decode.success(MapgrouptypemodeTypes)
    "type-and-types" -> decode.success(MapgrouptypemodeTypeandtypes)
    _ -> decode.failure(MapgrouptypemodeNone, "Mapgrouptypemode")
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

pub type Compositionattestationmode {
  CompositionattestationmodePersonal
  CompositionattestationmodeProfessional
  CompositionattestationmodeLegal
  CompositionattestationmodeOfficial
}

pub fn compositionattestationmode_to_json(
  compositionattestationmode: Compositionattestationmode,
) -> Json {
  json.string(compositionattestationmode_to_string(compositionattestationmode))
}

pub fn compositionattestationmode_to_string(
  compositionattestationmode: Compositionattestationmode,
) -> String {
  case compositionattestationmode {
    CompositionattestationmodePersonal -> "personal"
    CompositionattestationmodeProfessional -> "professional"
    CompositionattestationmodeLegal -> "legal"
    CompositionattestationmodeOfficial -> "official"
  }
}

pub fn compositionattestationmode_from_string(
  s: String,
) -> Result(Compositionattestationmode, Nil) {
  case s {
    "personal" -> Ok(CompositionattestationmodePersonal)
    "professional" -> Ok(CompositionattestationmodeProfessional)
    "legal" -> Ok(CompositionattestationmodeLegal)
    "official" -> Ok(CompositionattestationmodeOfficial)
    _ -> Error(Nil)
  }
}

pub fn compositionattestationmode_decoder() -> Decoder(
  Compositionattestationmode,
) {
  use variant <- decode.then(decode.string)
  case variant {
    "personal" -> decode.success(CompositionattestationmodePersonal)
    "professional" -> decode.success(CompositionattestationmodeProfessional)
    "legal" -> decode.success(CompositionattestationmodeLegal)
    "official" -> decode.success(CompositionattestationmodeOfficial)
    _ ->
      decode.failure(
        CompositionattestationmodePersonal,
        "Compositionattestationmode",
      )
  }
}

pub type Auditeventoutcome {
  Auditeventoutcome0
  Auditeventoutcome4
  Auditeventoutcome8
  Auditeventoutcome12
}

pub fn auditeventoutcome_to_json(auditeventoutcome: Auditeventoutcome) -> Json {
  json.string(auditeventoutcome_to_string(auditeventoutcome))
}

pub fn auditeventoutcome_to_string(
  auditeventoutcome: Auditeventoutcome,
) -> String {
  case auditeventoutcome {
    Auditeventoutcome0 -> "0"
    Auditeventoutcome4 -> "4"
    Auditeventoutcome8 -> "8"
    Auditeventoutcome12 -> "12"
  }
}

pub fn auditeventoutcome_from_string(
  s: String,
) -> Result(Auditeventoutcome, Nil) {
  case s {
    "0" -> Ok(Auditeventoutcome0)
    "4" -> Ok(Auditeventoutcome4)
    "8" -> Ok(Auditeventoutcome8)
    "12" -> Ok(Auditeventoutcome12)
    _ -> Error(Nil)
  }
}

pub fn auditeventoutcome_decoder() -> Decoder(Auditeventoutcome) {
  use variant <- decode.then(decode.string)
  case variant {
    "0" -> decode.success(Auditeventoutcome0)
    "4" -> decode.success(Auditeventoutcome4)
    "8" -> decode.success(Auditeventoutcome8)
    "12" -> decode.success(Auditeventoutcome12)
    _ -> decode.failure(Auditeventoutcome0, "Auditeventoutcome")
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

pub type Udientrytype {
  UdientrytypeBarcode
  UdientrytypeRfid
  UdientrytypeManual
  UdientrytypeCard
  UdientrytypeSelfreported
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
    "unknown" -> decode.success(UdientrytypeUnknown)
    _ -> decode.failure(UdientrytypeBarcode, "Udientrytype")
  }
}

import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
