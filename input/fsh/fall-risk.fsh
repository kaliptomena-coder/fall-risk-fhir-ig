// ╔══════════════════════════════════════════════════════════════╗
// ║ FALL RISK ASSESSMENT - FHIR SHORTHAND (FSH)                 ║
// ║ Profiles, ValueSet, and FHIR instances for fall risk IG     ║
// ╚══════════════════════════════════════════════════════════════╝

// ─── ALIASES ──────────────────────────────────────────────────────
Alias: $LOINC    = http://loinc.org
Alias: $SNOMED   = http://snomed.info/sct
Alias: $UCUM     = http://unitsofmeasure.org
Alias: $OBS_CAT  = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $LOCAL    = https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes

// ════════════════════════════════════════════════════════════════
// 0. LOCAL CODE SYSTEM
// ════════════════════════════════════════════════════════════════
CodeSystem: FallRiskLocalCS
Id: fall-risk-codes
Title: "Fall Risk Local Code System"
Description: "Local codes for physical performance tests, aggregate scores, and fall risk factors not available in LOINC or SNOMED CT."

* ^experimental = true
* ^status = #active

// CORRECTED: description updated from "0–30" to "0–34" to match the actual scoring model
// (13 factors, max 34 points: 6 core factors × 3 pts + 2 extended × 1 pt + 2 extended × 3 pts +
//  TUG 3 pts + chair stand 2 pts + balance 2 pts = 34).
* #fall-risk-score   "Fall Risk Score"                      "Aggregated fall risk score (0–34) computed from all individual Fall Risk Factor Observations."
* #balance-4stage    "4-Stage Balance Test"                 "Highest balance stage achieved (1–4) in the 4-Stage Balance Test."

// Scoring threshold codes — used by FallRiskScoreInterpretation to record which
// classification band a given score falls into.
* #score-low        "Low fall risk threshold met"           "Total score falls within the Low risk band (0–11)."
* #score-moderate   "Moderate fall risk threshold met"      "Total score falls within the Moderate risk band (12–22)."
* #score-high       "High fall risk threshold met"          "Total score falls within the High risk band (23–34)."


// ════════════════════════════════════════════════════════════════
// 1. PROFILES
// ════════════════════════════════════════════════════════════════

// ── 1a. Generic Fall Risk Factor Observation ──────────────────────
Profile: FallRiskFactorObservation
Parent: Observation
Id: fall-risk-factor-observation
Title: "Fall Risk Factor Observation"
Description: """
A standardized FHIR Observation representing a single contributing factor to fall risk
(e.g., fear of falling, walking ability, medication use).
This profile supports both automated EHR data extraction and manual questionnaire responses,
providing a consistent structure for clinical risk scoring algorithms.
"""
* ^url = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#survey "Survey"
* code 1..1 MS
* code from FallRiskFactorsVS (required) 
* subject 1..1 MS
* subject only Reference(Patient)

* identifier 0..* MS
* identifier.system 1..1
* identifier.value 1..1
* issued 0..1 MS
* encounter 0..1 MS
* encounter only Reference(Encounter)
* device 0..1 MS
* device only Reference(Device)

* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* performer 1..* MS
* method MS
* derivedFrom MS
* derivedFrom only Reference(QuestionnaireResponse or Observation)


// ── 1b. Fall Risk Score (aggregate) ───────────────────────────────
Profile: FallRiskScoreObservation
Parent: Observation
Id: fall-risk-score-observation
Title: "Fall Risk Score Observation"
Description: """
An aggregated fall risk score (0–34) derived from individual Fall Risk Factor Observations
and Fall Risk Performance Observations.
The 'hasMember' element links to the contributing factors, ensuring full traceability
of the clinical evidence.
"""

* ^url = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#survey "Survey"
* code 1..1 MS

* code = $LOCAL#fall-risk-score "Fall Risk Score"
* subject 1..1 MS
* subject only Reference(Patient)

* identifier 0..* MS
* identifier.system 1..1
* identifier.value 1..1

* issued 0..1 MS
* encounter 0..1 MS
* encounter only Reference(Encounter)
* device 0..1 MS
* device only Reference(Device)

* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.unit = "{score}"
* valueQuantity.code = #{score}

* interpretation 0..1 MS
* interpretation from FallRiskThresholdVS (required)

* performer 1..* MS
* hasMember MS
* hasMember only Reference(FallRiskFactorObservation or FallRiskPerformanceObservation)


// ── 1c. Objective Performance Test Observation ────────────────────
Profile: FallRiskPerformanceObservation
Parent: Observation
Id: fall-risk-performance-observation
Title: "Fall Risk Performance Test Observation"
Description: """
Objective physical performance measurements used in fall risk assessment,
including the Sit to stand frequency in 30 seconds, 4-Stage Balance Test,
and the Timed Up & Go (TUG) test.
"""

* ^url = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#exam "Exam"
* code 1..1 MS
* code from FallRiskPerformanceTestsVS (required)
* subject 1..1 MS
* subject only Reference(Patient)

* identifier 0..* MS
* identifier.system 1..1
* identifier.value 1..1

* issued 0..1 MS
* encounter 0..1 MS
* encounter only Reference(Encounter)
* device 0..1 MS
* device only Reference(Device)

* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* performer 1..* MS
* derivedFrom MS
* derivedFrom only Reference(QuestionnaireResponse or Observation)

// ── 1d. Fall Risk Observation (final classification) ───────────────
Profile: FallRiskObservation
Parent: Observation
Id: fall-risk-observation
Title: "Fall Risk Observation"
Description: """
The outcome of a fall risk screening episode, capturing the overall risk classification
(Low / Moderate / High) and referencing the aggregated score Observation.
"""
* ^url = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"

* status 1..1 MS
* status = #final
* code 1..1 MS
* code = $SNOMED#129839007 "At risk for falls"
* subject 1..1 MS
* subject only Reference(Patient)

* identifier 0..* MS
* identifier.system 1..1
* identifier.value 1..1

* issued 0..1 MS
* encounter 0..1 MS
* encounter only Reference(Encounter)

* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from FallRiskCategoryVS (required)
* performer 1..* MS
* derivedFrom 1..* MS
* derivedFrom only Reference(FallRiskScoreObservation)


// ════════════════════════════════════════════════════════════════
// 2. VALUE SETS
// ════════════════════════════════════════════════════════════════

ValueSet: FallRiskFactorsVS
Id: fall-risk-factors-vs
Title: "Fall Risk Factors ValueSet"
Description: "Standardized LOINC and SNOMED codes for fall risk assessment inputs (factors 1–10)."

* ^experimental = true

// LOINC codes
* $LOINC#97878-3  "Worried about falling"
* $LOINC#72107-6  "Mini-Mental State Examination [MMSE]"
* $LOINC#74013-4  "Alcoholic drinks per day"
* $LOINC#10160-0  "History of Medication use Narrative"
* $LOINC#99285-9  "Current activity level"

// SNOMED codes
* $SNOMED#428942009  "History of fall (situation)"
* $SNOMED#397540003  "Visual impairment"
* $SNOMED#284545001  "Ability to perform activities of everyday life (observable entity)"
* $SNOMED#446363004  "Adult comorbidity evaluation-27 score"
* $SNOMED#282097004  "Ability to walk (observable entity)"


ValueSet: FallRiskPerformanceTestsVS
Id: fall-risk-performance-tests-vs
Title: "Fall Risk Performance Tests ValueSet"
Description: "Codes for objective physical performance tests used in fall risk assessment (tests a–c)."

* ^experimental = true

// TUG test
* $LOINC#89423-8   "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
// 30-second chair stand
* $LOINC#66247-8   "Sit to stand frequency in 30 seconds"
// 4-Stage Balance Test — no suitable LOINC available
* $LOCAL#balance-4stage  "4-Stage Balance Test"


ValueSet: FallRiskCategoryVS
Id: fall-risk-category-vs
Title: "Fall Risk Category ValueSet"
Description: "Risk classification outcomes for fall risk assessment using SNOMED qualifier values."

* ^experimental = true

* $SNOMED#439430008             "Low risk (qualifier value)"
* $SNOMED#332721351000132106    "Moderate risk (qualifier value)"
* $SNOMED#455201601000132100    "High risk (qualifier value)"


// ADDED: ValueSet for score threshold interpretation codes.
// Used by the scoring algorithm to record which band a computed score falls into.
ValueSet: FallRiskThresholdVS
Id: fall-risk-threshold-vs
Title: "Fall Risk Score Threshold ValueSet"
Description: """
Local codes that identify which score band (Low / Moderate / High) a computed
FallRiskScore falls into. Used in FallRiskObservation.note or as an
interpretation code alongside valueQuantity in FallRiskScoreObservation.
"""

* ^experimental = true

* $LOCAL#score-low       "Low fall risk threshold met"
* $LOCAL#score-moderate  "Moderate fall risk threshold met"
* $LOCAL#score-high      "High fall risk threshold met"


// ════════════════════════════════════════════════════════════════
// 3. SCORE THRESHOLD RULES
// ════════════════════════════════════════════════════════════════
// These rules define the numeric score bands that map a FallRiskScoreObservation
// valueQuantity to a FallRiskCategoryVS code.  They are expressed as a FHIR
// ConceptMap so that any conformant system can apply them deterministically.
//
// Score range: 0–34 (sum of all 13 factors; see scoring table in dataflow.md).
//
//   0–11  → SNOMED 439430008  "Low risk (qualifier value)"
//  12–22  → SNOMED 332721351000132106  "Moderate risk (qualifier value)"
//  23–34  → SNOMED 455201601000132100  "High risk (qualifier value)"
//
// The ConceptMap source is FallRiskThresholdVS (local threshold codes);
// the target is FallRiskCategoryVS (SNOMED qualifier values).

Instance: FallRiskScoreThresholdMap
InstanceOf: ConceptMap
Title: "Fall Risk Score Threshold ConceptMap"
Description: """
Maps local score-band codes (score-low / score-moderate / score-high) to the
corresponding SNOMED risk category codes in FallRiskCategoryVS.
The numeric cutoffs encoded in the comments and group.element.display fields
are the authoritative thresholds for this IG:
  score-low      = total score 0–11
  score-moderate = total score 12–22
  score-high     = total score 23–34
"""
Usage: #definition

* id = "fall-risk-score-threshold-map"
* url = "https://example.org/fhir/fall-risk/ConceptMap/fall-risk-score-threshold-map"
* status = #active
* experimental = true
* sourceCanonical = "https://example.org/fhir/fall-risk/ValueSet/fall-risk-threshold-vs"
* targetCanonical = "https://example.org/fhir/fall-risk/ValueSet/fall-risk-category-vs"

* group[0].source = "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes"
* group[0].target = "http://snomed.info/sct"

* group[0].element[0].code = #score-low
* group[0].element[0].display = "Total score 0–11"
* group[0].element[0].target[0].code = #439430008
* group[0].element[0].target[0].display = "Low risk (qualifier value)"
* group[0].element[0].target[0].equivalence = #equivalent

* group[0].element[1].code = #score-moderate
* group[0].element[1].display = "Total score 12–22"
* group[0].element[1].target[0].code = #332721351000132106
* group[0].element[1].target[0].display = "Moderate risk (qualifier value)"
* group[0].element[1].target[0].equivalence = #equivalent

* group[0].element[2].code = #score-high
* group[0].element[2].display = "Total score 23–34"
* group[0].element[2].target[0].code = #455201601000132100
* group[0].element[2].target[0].display = "High risk (qualifier value)"
* group[0].element[2].target[0].equivalence = #equivalent


// ════════════════════════════════════════════════════════════════
// 4. INSTANCES
// ════════════════════════════════════════════════════════════════

Instance: ExamplePractitioner
InstanceOf: Practitioner
Title: "Example Practitioner"
Description: "The physiotherapist conducting the fall risk assessment."
Usage: #example

* id = "example-practitioner"
* name
  * family = "Huber"
  * given[0] = "Anna"
* qualification[0].code = $SNOMED#36682004 "Physiotherapist (occupation)"


Instance: ExamplePatient
InstanceOf: Patient
Title: "Example Patient – Maria Müller"
Description: "A 78-year-old female patient undergoing fall risk assessment."
Usage: #example

* id = "example-patient"
* name
  * family = "Mueller"
  * given[0] = "Maria"
* gender = #female
* birthDate = "1946-03-12"
* address
  * line[0] = "Hauptstrasse 15"
  * city = "Vienna"
  * country = "AT"


Instance: ExampleFearOfFallingObservation
InstanceOf: FallRiskFactorObservation
Title: "Example – Fear of Falling (Factor 2)"
Description: "Patient reports whether they are worried about falling."
Usage: #example

* id = "obs-fear-of-falling"
* meta.profile[0] = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation" 

* status = #final
* category = $OBS_CAT#survey "Survey"
* code = $LOINC#97878-3 "Worried about falling"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:30:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueCodeableConcept = $SNOMED#373066001 "Yes (qualifier value)"


Instance: ExampleTUGObservation
InstanceOf: FallRiskPerformanceObservation
Title: "Example – TUG Test"
Description: "Patient completed TUG in 14.2 seconds — scores 2 pts (12–20 s band)."
Usage: #example

* id = "obs-tug-test"
* meta.profile[0] = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"

* status = #final
* category = $OBS_CAT#exam "Exam"
* code = $LOINC#89423-8 "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:45:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueQuantity
  * value = 14.2
  * unit = "s"
  * system = $UCUM
  * code = #s


Instance: ExampleChairStandObservation
InstanceOf: FallRiskPerformanceObservation
Title: "Example – Sit to Stand (30 s)"
Description: "Patient completed 8 repetitions in 30 seconds — scores 1 pt (8–11 band)."
Usage: #example

* id = "obs-chair-stand"
* meta.profile[0] = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"


* status = #final
* category = $OBS_CAT#exam "Exam"
* code = $LOINC#66247-8 "Sit to stand frequency in 30 seconds"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:50:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueQuantity
  * value = 8
  * unit = "{count}"
  * system = $UCUM
  * code = #{count}


// CORRECTED: Title and Description updated from "18/30" to "18/34"
// to match the corrected maximum score of 34.
Instance: ExampleFallRiskScore
InstanceOf: FallRiskScoreObservation
Title: "Example – Fall Risk Score (18/34)"
Description: "Aggregated fall risk score of 18 out of 34 — Moderate risk (score band 12–22)."
Usage: #example

* id = "obs-fall-risk-score"
* meta.profile[0] = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"

* status = #final
* category = $OBS_CAT#survey "Survey"
* code = $LOCAL#fall-risk-score "Fall Risk Score"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T11:00:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueQuantity
  * value = 18
  * unit = "{score}"
  * system = $UCUM
  * code = #{score}
// ADDED: interpretation records which threshold band this score falls into.
* interpretation = $LOCAL#score-moderate "Moderate fall risk threshold met"
* hasMember[0] = Reference(ExampleFearOfFallingObservation)
* hasMember[1] = Reference(ExampleTUGObservation)
* hasMember[2] = Reference(ExampleChairStandObservation)


Instance: ExampleFallRiskAssessment
InstanceOf: FallRiskObservation
Title: "Example – Fall Risk Screening Result"
Description: "Overall fall risk classification: Moderate."
Usage: #example

* id = "obs-fall-risk-result"
* meta.profile[0] = "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"

* status = #final
* code = $SNOMED#129839007 "At risk for falls"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T11:00:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueCodeableConcept = $SNOMED#332721351000132106 "At moderate risk for fall (finding)"
* derivedFrom = Reference(ExampleFallRiskScore)


Instance: ExampleFallRiskCondition
InstanceOf: Condition
Title: "Example – Condition: At Risk of Falls"
Description: "Problem list entry created after moderate fall risk assessment."
Usage: #example

* id = "condition-fall-risk"
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* category[0] = http://terminology.hl7.org/CodeSystem/condition-category#problem-list-item
* code = $SNOMED#129839007 "At risk for falls"
* subject = Reference(ExamplePatient)
* onsetDateTime = "2024-11-15"
* evidence[0].detail = Reference(ExampleFallRiskAssessment)


Instance: ExampleFallsHistoryQR
InstanceOf: QuestionnaireResponse
Title: "Example – Falls History QuestionnaireResponse"
Description: "Patient reports 2 falls in the past 12 months."
Usage: #example

* id = "qr-falls-history"
* status = #completed
* questionnaire = "https://example.org/fhir/fall-risk/Questionnaire/falls-history"
* subject = Reference(ExamplePatient)
* authored = "2024-11-15T10:00:00+01:00"
* item[0]
  * linkId = "falls-count"
  * text = "How many times have you fallen in the last 12 months?"
  * answer[0].valueInteger = 2


// ─── FALL RISK QUESTIONNAIRE ───────────────────────────────────────
Instance: FallsHistoryQuestionnaire
InstanceOf: Questionnaire
Usage: #example
Title: "Falls Risk Assessment Questionnaire"
Description: "Complete questionnaire model for active assessment including terminology mapping to LOINC and SNOMED CT."

* id = "falls-history"
* status = #active
* url = "https://example.org/fhir/fall-risk/Questionnaire/falls-history"

// ── Core factors (1–6) — required ─────────────────────────────────

* item[0]
  * linkId = "falls-count"
  * code = $SNOMED#428942009 "History of fall (situation)"
  * text = "How many times have you fallen in the last 12 months?"
  * type = #integer
  // Scoring: 0=0 · 1=1 · 2=2 · ≥3=3

* item[1]
  * linkId = "fear-of-falling"
  * code = $LOINC#97878-3 "Worried about falling"
  * text = "Are you worried about falling? (ABC scale)"
  * type = #choice
  * answerOption[0].valueCoding = $SNOMED#373066001 "Yes"
  * answerOption[1].valueCoding = $SNOMED#373067005 "No"
  // Scoring: None (ABC 80–100%)=0 · Slight (51–79%)=1 · Often (30–50%)=2 · Severe (<30%)=3

* item[2]
  * linkId = "adl-independence"
  * code = $SNOMED#284545001 "Ability to perform activities of everyday life"
  * text = "Activities of Daily Living (ADL): functional independence"
  * type = #choice
  * answerOption[0].valueString = "Fully independent"
  * answerOption[1].valueString = "Slight assistance needed"
  * answerOption[2].valueString = "Moderate assistance needed"
  * answerOption[3].valueString = "Fully dependent"
  // Scoring: Independent=0 · Slight=1 · Moderate=2 · Fully dependent=3

* item[3]
  * linkId = "walking-ability"
  * code = $SNOMED#282097004 "Ability to walk (observable entity)"
  * text = "Walking ability and use of walking aids"
  * type = #choice
  * answerOption[0].valueString = "Independent"
  * answerOption[1].valueString = "With aids"
  // Scoring: Independent=0 · With aid=1

// ── Extended factors (7–10) — if time allows ──────────────────────

* item[4]
  * linkId = "alcohol-use"
  * code = $LOINC#74013-4 "Alcoholic drinks per day"
  * text = "Alcohol use (units per week)"
  * type = #quantity
  // Scoring: 0=0 · 1–3=1 · 4–10=2 · ≥11=3

* item[5]
  * linkId = "physical-activity"
  * code = $LOINC#99285-9 "Current activity level"
  * text = "Current physical activity level"
  * type = #choice
  * answerOption[0].valueString = "Very active"
  * answerOption[1].valueString = "Moderately active"
  * answerOption[2].valueString = "Low activity"
  * answerOption[3].valueString = "Very low / sedentary"
  // Scoring: Very active=0 · Moderate=1 · Low=2 · Very low=3

// ── Objective performance tests (a–c) ─────────────────────────────

* item[6]
  * linkId = "tug-score"
  * code = $LOINC#89423-8 "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
  * text = "Timed Up & Go test result (seconds)"
  * type = #decimal
  // Scoring: <12 s=0 · 12–20 s=2 · >20 s=3

* item[7]
  * linkId = "chair-stand-score"
  * code = $LOINC#66247-8 "Sit to stand frequency in 30 seconds"
  * text = "Sit to stand frequency in 30 seconds (repetitions)"
  * type = #integer
  // Scoring: ≥12=0 · 8–11=1 · <8=2

* item[8]
  * linkId = "balance-4stage"
  * code = $LOCAL#balance-4stage "4-Stage Balance Test"
  * text = "4-Stage Balance Test result (highest stage reached)"
  * type = #choice
  * answerOption[0].valueInteger = 1
  * answerOption[1].valueInteger = 2
  * answerOption[2].valueInteger = 3
  * answerOption[3].valueInteger = 4
  // Scoring: Stage 4=0 · Stage 3=1 · ≤Stage 2=2

// ── EHR fallback section (clinical history — auto-populated) ───────

* item[+].linkId = "ehr-fallback-group"
* item[=].text = "Clinical History Data (EHR-derived)"
* item[=].type = #group

* item[=].item[+].linkId = "medications"
* item[=].item[=].code = $LOINC#10160-0 "History of Medication use Narrative"
* item[=].item[=].text = "Total medication count (including FRIDs flag)"
* item[=].item[=].type = #integer
// Scoring: 0=0 · 1–2=1 · 3=2 · ≥4=3  (+bonus if FRIDs present)

* item[=].item[+].linkId = "comorbidities"
* item[=].item[=].code = $SNOMED#446363004 "Adult comorbidity evaluation-27 score"
* item[=].item[=].text = "Number of active diagnoses (comorbidities)"
* item[=].item[=].type = #integer
// Scoring: 0=0 · 1–2=1 · 3–4=2 · ≥5=3

* item[=].item[+].linkId = "cognitive-status"
* item[=].item[=].code = $LOINC#72107-6 "Mini-Mental State Examination [MMSE]"
* item[=].item[=].text = "MMSE score"
* item[=].item[=].type = #integer
// Scoring derived from MMSE integer: None (≥27)=0 · Mild (21–26)=1 · Moderate (11–20)=2 · Severe (≤10)=3

* item[=].item[+].linkId = "vision-impairment"
* item[=].item[=].code = $SNOMED#397540003 "Visual impairment"
* item[=].item[=].text = "Vision or hearing impairment present?"
* item[=].item[=].type = #boolean
// Scoring: No=0 · Yes=1
