// ╔══════════════════════════════════════════════════════════════╗
// ║        FALL RISK ASSESSMENT - FHIR SHORTHAND (FSH)          ║
// ║   Profiles, ValueSet, and FHIR instances for fall risk IG   ║
// ╚══════════════════════════════════════════════════════════════╝

// ─── ALIASES ────────────────────────────────────────────────────
Alias: $LOINC      = http://loinc.org
Alias: $SNOMED     = http://snomed.info/sct
Alias: $UCUM       = http://unitsofmeasure.org
Alias: $OBS_CAT    = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $LOCAL      = https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes

// ════════════════════════════════════════════════════════════════
// 0.  LOCAL CODE SYSTEM
//     Local codes for fall risk factors, performance tests, and aggregate scores
//     not available in the licensed LOINC version.
// ════════════════════════════════════════════════════════════════

CodeSystem: FallRiskLocalCS
Id: fall-risk-codes
Title: "Fall Risk Local Code System"
Description: "Local codes for physical performance tests, aggregate scores, and fall risk factors not available in the licensed LOINC version."
* ^experimental = true
* ^status = #active
* #fall-risk-score "Fall Risk Score" "Aggregated fall risk score (0–30) computed from all individual Fall Risk Factor Observations."
* #chair-stand-30s "30-Second Chair Stand Test" "Count of sit-to-stand repetitions completed in 30 seconds."
* #balance-4stage  "4-Stage Balance Test"        "Highest balance stage achieved (1–4) in the 4-Stage Balance Test."
* #visual-impairment "Visual impairment" "Visual impairment as a fall risk factor, represented by a local code when no suitable standard observation code is licensed."

// ════════════════════════════════════════════════════════
// 1.  PROFILES
// ════════════════════════════════════════════════════════════════

// ── 1a. Generic Fall Risk Factor Observation ────────────────────
Profile: FallRiskFactorObservation
Parent: Observation
Id: fall-risk-factor-observation
Title: "Fall Risk Factor Observation"
Description: """
A standardized FHIR Observation representing a single contributing factor
to fall risk (e.g., fear of falling, walking ability, medication use).

This profile supports both automated EHR data extraction and manual 
questionnaire responses, providing a consistent structure for 
clinical risk scoring algorithms.
"""
* status 1..1 MS
* status = #final
* category 1..* MS
* category = $OBS_CAT#survey "Survey"
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

// ── 1b. Fall Risk Score (aggregate) ─────────────────────────────
Profile: FallRiskScoreObservation
Parent: Observation
Id: fall-risk-score-observation
Title: "Fall Risk Score Observation"
Description: """
An aggregated fall risk score derived from individual Fall Risk Factor 
Observations. The 'hasMember' element links to the contributing factors, 
ensuring full traceability of the clinical evidence.
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
// UCUM does not have "score" — use the annotation unit {score}
* valueQuantity.unit = "{score}"
* valueQuantity.code = #{score}
* performer 1..* MS
* hasMember MS
* hasMember only Reference(FallRiskFactorObservation or FallRiskPerformanceObservation)

// ── 1c. Objective Performance Test Observation ──────────────────
Profile: FallRiskPerformanceObservation
Parent: Observation
Id: fall-risk-performance-observation
Title: "Fall Risk Performance Test Observation"
Description: """
Objective physical performance measurements used in fall risk assessment, 
including the 30-Second Chair Stand Test, 4-Stage Balance Test, and the 
Timed Up & Go (TUG) test.
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

// ── 1d. Fall Risk Observation (final classification) ─────────────
Profile: FallRiskObservation
Parent: Observation
Id: fall-risk-observation
Title: "Fall Risk Observation"
Description: """
The outcome of a fall risk screening episode, capturing the overall
risk classification (Low / Moderate / High) and referencing the
aggregated score Observation.
"""
* status 1..1 MS
* status = #final
* code 1..1 MS
// FIX: LOINC 71802-3 official display is "Housing status" — wrong code.
//      Using SNOMED 129839007 is the correct concept for fall risk assessment.
//      We bind code directly to SNOMED.
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
// 2.  VALUE SETS
// ════════════════════════════════════════════════════════════════

ValueSet: FallRiskFactorsVS
Id: fall-risk-factors-vs
Title: "Fall Risk Factors ValueSet"
Description: "Standardized LOINC and SNOMED codes for fall risk assessment inputs. Display names use the official terminology display text."
* ^experimental = true
// LOINC codes — using official LOINC display names exactly as returned by tx.fhir.org
* $LOINC#97878-3  "Worried about falling"
* $LOINC#72107-6  "Mini-Mental State Examination [MMSE]"
* $LOINC#74013-4  "Alcoholic drinks per day"
// SNOMED codes — official display names
* $LOCAL#visual-impairment "Visual impairment"
* $SNOMED#284545001 "Ability to perform activities of everyday life (observable entity)"
// Local codes for tests not in LOINC 2.82
* $LOCAL#chair-stand-30s "30-Second Chair Stand Test"
* $LOCAL#balance-4stage  "4-Stage Balance Test"

ValueSet: FallRiskPerformanceTestsVS
Id: fall-risk-performance-tests-vs
Title: "Fall Risk Performance Tests ValueSet"
Description: "Codes for objective physical performance tests. TUG uses validated LOINC; Chair Stand and Balance Test use local codes."
* ^experimental = true
// FIX: Using correct LOINC code 89423-8 from CDC STEADI panel for TUG timing
* $LOINC#89423-8       "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
* $LOCAL#chair-stand-30s "30-Second Chair Stand Test"
* $LOCAL#balance-4stage  "4-Stage Balance Test"

ValueSet: FallRiskCategoryVS
Id: fall-risk-category-vs
Title: "Fall Risk Category ValueSet"
Description: "Risk classification outcomes for fall risk assessment using SNOMED qualifier values."
* ^experimental = true
// FIX: SNOMED codes 723510000/723511001/723505004 map to wrong concepts.
//      Using the correct SNOMED risk qualifier codes:
* $SNOMED#723509005 "Low risk (qualifier value)"
* $SNOMED#723508002 "Moderate risk (qualifier value)"
* $SNOMED#723505004 "High risk (qualifier value)"

// ════════════════════════════════════════════════════════════════
// 3.  INSTANCES
// ════════════════════════════════════════════════════════════════

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

// Reusable performer reference (the assessing practitioner)
// Used in all Observation instances below

Instance: ExampleFearOfFallingObservation
InstanceOf: FallRiskFactorObservation
Title: "Example – Fear of Falling (Factor 2)"
Description: "Patient reports whether they are worried about falling."
Usage: #example
* id = "obs-fear-of-falling"
* status = #final
* category = $OBS_CAT#survey "Survey"
// LOINC code for worried-about-falling
* code = $LOINC#97878-3 "Worried about falling"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:30:00+01:00"
// add performer 
* performer[0] = Reference(ExamplePractitioner)
* valueCodeableConcept = $SNOMED#373066001 "Yes (qualifier value)"

Instance: ExampleTUGObservation
InstanceOf: FallRiskPerformanceObservation
Title: "Example – Timed Up and Go Test"
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
Title: "Example – 30-Second Chair Stand Test"
Description: "Patient completed 8 repetitions in 30 seconds."
Usage: #example
* id = "obs-chair-stand"
* status = #final
* category = $OBS_CAT#exam "Exam"
// FIX: use local code #chair-stand-30s — no suitable LOINC code available
* code = $LOCAL#chair-stand-30s "30-Second Chair Stand Test"
* subject = Reference(ExamplePatient)
* effectiveDateTime = "2024-11-15T10:50:00+01:00"
* performer[0] = Reference(ExamplePractitioner)
* valueQuantity
  * value = 8
  // FIX: UCUM does not have "repetition" — use annotation unit {count}
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
// FIX: use corrected SNOMED qualifier value for Moderate risk
* valueCodeableConcept = $SNOMED#723508002 "Moderate risk (qualifier value)"
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

//      Using 129839007 "At risk for falls" which is the correct concept.
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
// FIX: QuestionnaireResponse needs a questionnaire reference to avoid validation hint
* questionnaire = "https://example.org/fhir/fall-risk/Questionnaire/falls-history"
* subject = Reference(ExamplePatient)
* authored = "2024-11-15T10:00:00+01:00"
* item[0]
  * linkId = "falls-count"
  * text = "How many times have you fallen in the last 12 months?"
  * answer[0].valueInteger = 2

// ── Supporting instance: Practitioner ───────────────────────────
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
