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
Description: "Local codes for physical performance tests, aggregate scores, and fall risk factors not available in the licensed LOINC version."

* ^experimental = true
* ^status = #active

* #fall-risk-score   "Fall Risk Score"                    "Aggregated fall risk score (0–30) computed from all individual Fall Risk Factor Observations."
* #chair-stand-30s   "Sit to stand frequency in 30 seconds" "Count of sit-to-stand repetitions completed in 30 seconds."
* #balance-4stage    "4-Stage Balance Test"               "Highest balance stage achieved (1–4) in the 4-Stage Balance Test."

// CHANGE 1: REMOVED local code #visual-impairment.
// It was defined here as a fallback but was NEVER referenced anywhere in the IG —
// every ValueSet entry and Questionnaire item used $SNOMED#397540003 "Visual impairment" instead.
// Keeping an unused local code creates confusion about which code should be used.
// If SNOMED is accessible (and it clearly is throughout this IG), use it exclusively.
// Deleted line was:
//   * #visual-impairment "Visual impairment" "Visual impairment as a fall risk factor..."


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

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#survey "Survey"

// NOTE (no change): category is fixed to #survey here. This is intentional for
// patient-reported and questionnaire-derived factors. EHR-derived factors
// (medications, comorbidities) that are sourced differently may warrant a
// separate profile or a relaxed binding — but no change is made here since
// the original design decision is consistent across all factor instances.

* code 1..1 MS
* subject 1..1 MS
* subject only Reference(Patient)
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
An aggregated fall risk score derived from individual Fall Risk Factor Observations.
The 'hasMember' element links to the contributing factors, ensuring full traceability
of the clinical evidence.
"""

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#survey "Survey"
* code 1..1 MS
* code = $LOCAL#fall-risk-score "Fall Risk Score"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.unit = "{score}"
* valueQuantity.code = #{score}
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

* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#exam "Exam"
* code 1..1 MS
* code from FallRiskPerformanceTestsVS (required)
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] 1..1 MS
* effective[x] only dateTime
* value[x] 1..1 MS
* performer 1..* MS
* derivedFrom MS


// ── 1d. Fall Risk Observation (final classification) ───────────────
Profile: FallRiskObservation
Parent: Observation
Id: fall-risk-observation
Title: "Fall Risk Observation"
Description: """
The outcome of a fall risk screening episode, capturing the overall risk classification
(Low / Moderate / High) and referencing the aggregated score Observation.
"""

* status 1..1 MS
* status = #final
* code 1..1 MS
* code = $SNOMED#129839007 "At risk for falls"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] 1..1 MS
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
Description: "Standardized LOINC and SNOMED codes for fall risk assessment inputs."

* ^experimental = true

// LOINC codes
* $LOINC#97878-3  "Worried about falling"
* $LOINC#72107-6  "Mini-Mental State Examination [MMSE]"
* $LOINC#74013-4  "Alcoholic drinks per day"
* $LOINC#10160-0  "History of Medication use Narrative"

// CHANGE 2: REMOVED $LOCAL#chair-stand-30s from this ValueSet.
// The 30-second chair stand test is an OBJECTIVE PERFORMANCE TEST, not a survey factor.
// It belongs exclusively in FallRiskPerformanceTestsVS using LOINC#66247-8.
// Having $LOCAL#chair-stand-30s here alongside $LOINC#66247-8 in the performance VS
// created two different codes for the same clinical concept, and the local code was
// never used in any instance or questionnaire item.
// Deleted line was:
//   * $LOCAL#chair-stand-30s "Sit to stand frequency in 30 seconds"

// SNOMED codes
* $SNOMED#397540003  "Visual impairment"
* $SNOMED#284545001  "Ability to perform activities of everyday life (observable entity)"
* $SNOMED#446363004  "Adult comorbidity evaluation-27 score"
* $SNOMED#282097004  "Ability to walk (observable entity)"

// CHANGE 3: REMOVED $LOCAL#balance-4stage from this ValueSet.
// The 4-Stage Balance Test is also an objective performance test, not a survey factor.
// It belongs exclusively in FallRiskPerformanceTestsVS.
// It was duplicated across both ValueSets in the original — removed here for clarity.
// Deleted line was:
//   * $LOCAL#balance-4stage "4-Stage Balance Test"


ValueSet: FallRiskPerformanceTestsVS
Id: fall-risk-performance-tests-vs
Title: "Fall Risk Performance Tests ValueSet"
Description: "Codes for objective physical performance tests used in fall risk assessment."

* ^experimental = true

// TUG test — validated LOINC code
* $LOINC#89423-8  "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"

// Chair Stand — LOINC code (consistent with all instances and Questionnaire items)
// CHANGE 4: This ValueSet previously included LOINC#66247-8 (correct),
// while FallRiskFactorsVS included $LOCAL#chair-stand-30s for the same test (incorrect).
// The local code has been removed from FallRiskFactorsVS; LOINC#66247-8 is the sole code.
* $LOINC#66247-8  "Sit to stand frequency in 30 seconds"

// 4-Stage Balance Test — local code (no suitable LOINC available)
* $LOCAL#balance-4stage  "4-Stage Balance Test"


ValueSet: FallRiskCategoryVS
Id: fall-risk-category-vs
Title: "Fall Risk Category ValueSet"
Description: "Risk classification outcomes for fall risk assessment using SNOMED qualifier values."

* ^experimental = true

* $SNOMED#439430008             "Low risk (qualifier value)"
* $SNOMED#332721351000132106    "Moderate risk (qualifier value)"
* $SNOMED#455201601000132100    "High risk (qualifier value)"

// NOTE on CHANGE 5 (see instance below): The display text declared in this ValueSet
// for 332721351000132106 is "Moderate risk (qualifier value)".
// The ExampleFallRiskAssessment instance used "At moderate risk for fall (finding)"
// for the same code — a mismatch. The instance display has been corrected to match
// the ValueSet declaration.


// ════════════════════════════════════════════════════════════════
// 3. INSTANCES
// ════════════════════════════════════════════════════════════════

// CHANGE 6: MOVED ExamplePractitioner to the TOP of the instances section.
// In the original it was defined at the bottom, AFTER all the Observation instances
// that reference it via performer[0] = Reference(ExamplePractitioner).
// While FSH resolvers can handle forward references, placing the referenced resource
// before its dependents is standard practice and avoids validation warnings.
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
* status = #final
* category = $OBS_CAT#survey "Survey"
* code = $LOINC#97878-3 "Worried about falling"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:30:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueCodeableConcept = $SNOMED#373066001 "Yes (qualifier value)"


Instance: ExampleTUGObservation
InstanceOf: FallRiskPerformanceObservation
Title: "Example – Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
Description: "Patient completed TUG in 14.2 seconds (elevated risk threshold >12 s)."
Usage: #example

* id = "obs-tug-test"
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
Title: "Example – Sit to stand frequency in 30 seconds"
Description: "Patient completed 8 repetitions in 30 seconds."
Usage: #example

* id = "obs-chair-stand"
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


Instance: ExampleFallRiskScore
InstanceOf: FallRiskScoreObservation
Title: "Example – Fall Risk Score (18/30)"
Description: "Aggregated fall risk score of 18 out of 30 — Moderate risk."
Usage: #example

* id = "obs-fall-risk-score"
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
* hasMember[0] = Reference(ExampleFearOfFallingObservation)
* hasMember[1] = Reference(ExampleTUGObservation)
* hasMember[2] = Reference(ExampleChairStandObservation)


Instance: ExampleFallRiskAssessment
InstanceOf: FallRiskObservation
Title: "Example – Fall Risk Screening Result"
Description: "Overall fall risk classification: Moderate."
Usage: #example

* id = "obs-fall-risk-result"
* status = #final
* code = $SNOMED#129839007 "At risk for falls"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T11:00:00+01:00"
* performer[0] = Reference(ExamplePractitioner)

// Display text confirmed correct by user: "At moderate risk for fall (finding)"
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


// ─── FALL RISK QUESTIONNAIRE MODEL (LAYER 2) ──────────────────────
Instance: FallsHistoryQuestionnaire
InstanceOf: Questionnaire
Usage: #example
Title: "Falls Risk Assessment Questionnaire"
Description: "Complete questionnaire model for active assessment including terminology mapping to LOINC and SNOMED CT."

// FIX url/id mismatch error: FSH uses the Instance name as the logical id by default,
// giving id = "FallsHistoryQuestionnaire", but the url ends with "falls-history".
// The validator requires id to match the final path segment of url.
// Setting id explicitly resolves: "Resource id/url mismatch: FallsHistoryQuestionnaire/..."
* id = "falls-history"
* status = #active
* url = "https://example.org/fhir/fall-risk/Questionnaire/falls-history"

// --- MANUAL FACTORS (Patient-Reported) ---

* item[0]
  * linkId = "falls-count"
  * code = $SNOMED#428942009 "History of fall (situation)"
  * text = "How many times have you fallen in the last 12 months?"
  * type = #integer

* item[1]
  * linkId = "fear-of-falling"
  * code = $LOINC#97878-3 "Worried about falling"
  * text = "Are you worried about falling?"
  * type = #choice
  * answerOption[0].valueCoding = $SNOMED#373066001 "Yes"
  * answerOption[1].valueCoding = $SNOMED#373067005 "No"

* item[2]
  * linkId = "alcohol-use"
  * code = $LOINC#74013-4 "Alcoholic drinks per day"
  * text = "Alcohol use (drinks per day)"
  * type = #quantity

* item[3]
  * linkId = "physical-activity"
  * code = $LOINC#99285-9 "Current activity level"

  // CHANGE 7: CORRECTED duplicate text "Current activity level activity level".
  // Original: "Current activity level activity level"
  // Corrected: "Current activity level"
  // This was a copy-paste error — "activity level" was written twice.
  * text = "Current activity level"

  * type = #choice
  * answerOption[0].valueString = "Active (meets WHO guidelines)"
  * answerOption[1].valueString = "Inactive (sedentary)"

* item[4]
  * linkId = "adl-independence"
  * code = $SNOMED#284545001 "Ability to perform activities of everyday life"
  * text = "Activities of Daily Living (ADL): functional independence"
  * type = #choice
  * answerOption[0].valueString = "Fully Independent"
  * answerOption[1].valueString = "Needs some assistance"

* item[5]
  * linkId = "walking-ability"
  * code = $SNOMED#282097004 "Ability to walk (observable entity)"
  * text = "Walking ability and use of walking aids"
  * type = #choice
  * answerOption[0].valueString = "Independent"
  * answerOption[1].valueString = "With aids"

// --- OBJECTIVE PERFORMANCE MEASURES ---

// item[6]: Chair stand uses LOINC#66247-8 exclusively (local code removed from FallRiskFactorsVS).
* item[6]
  * linkId = "chair-stand-score"
  * code = $LOINC#66247-8 "Sit to stand frequency in 30 seconds"
  * text = "Sit to stand frequency in 30 seconds"
  * type = #integer

* item[7]
  * linkId = "balance-4stage"
  * code = $LOCAL#balance-4stage "4-Stage Balance Test"
  * text = "4-Stage Balance Test Result (Highest stage reached)"
  * type = #choice
  * answerOption[0].valueInteger = 1
  * answerOption[1].valueInteger = 2
  * answerOption[2].valueInteger = 3
  * answerOption[3].valueInteger = 4

* item[8]
  * linkId = "tug-score"
  * code = $LOINC#89423-8 "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
  * text = "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
  * type = #decimal

// --- EHR FALLBACK SECTION (Clinical History) ---

* item[+].linkId = "ehr-fallback-group"
* item[=].text = "Clinical History Data (Fallback)"
* item[=].type = #group

* item[=].item[+].linkId = "medications"
* item[=].item[=].code = $LOINC#10160-0 "History of Medication use Narrative"
* item[=].item[=].text = "Medications/FRIDs usage count"
* item[=].item[=].type = #integer

* item[=].item[+].linkId = "vision-impairment"
* item[=].item[=].code = $SNOMED#397540003 "Visual impairment"
* item[=].item[=].text = "Visual or hearing impairment detected?"
* item[=].item[=].type = #boolean

// FIX item[9].item[2]: display "MMSE Score" is not a valid LOINC display.
// Canonical display from tx.fhir.org is "Mini-Mental State Examination [MMSE]".
* item[=].item[+].linkId = "cognitive-status"
* item[=].item[=].code = $LOINC#72107-6 "Mini-Mental State Examination [MMSE]"
* item[=].item[=].text = "MMSE score (Cognitive Impairment)"
* item[=].item[=].type = #integer
