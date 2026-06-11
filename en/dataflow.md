# Data Flow & Scoring

This page explains step-by-step how raw clinical data becomes a fall risk classification, and how each step maps to a specific FHIR resource.

---

## Overview of the flow

```
Step 1: Data collection
    EHR pull (automated) + Questionnaire (manual) + Physical performance tests
         │
Step 2: Normalization
    Everything → FallRiskFactorObservation or FallRiskPerformanceObservation
         │
Step 3: Score calculation
    All Observations → FallRiskScoreObservation (0–34 points)
         │
Step 4: Classification
    Score → FallRiskObservation (Low / Moderate / High)
    Thresholds defined in FallRiskScoreThresholdMap (ConceptMap)
         │
Step 5: Problem list
    Moderate or High → Condition ("At risk for falls") on problem list
```

---

## Step 1: Data collection

Three sources feed the assessment.

### 1a. EHR-derived data (automated)

The clinical system queries existing FHIR resources and creates derived Observations:

| Source resource | Query | FHIR code | Result type |
|---|---|---|---|
| `MedicationStatement` | Count all active medications; flag FRIDs | `LOINC 10160-0` | `valueQuantity` (integer) |
| `Condition` | Count active diagnoses | `SNOMED 446363004` | `valueQuantity` (integer) |
| `Observation` (LOINC 72107-6) | Retrieve latest MMSE score | `LOINC 72107-6` | `valueInteger` |
| `Observation` (SNOMED 397540003) | Retrieve vision/hearing impairment status | `SNOMED 397540003` | `valueCodeableConcept` |

The derived Observation uses `derivedFrom` to reference its source:

```json
{
  "resourceType": "Observation",
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "72107-6", "display": "Mini-Mental State Examination [MMSE]" }] },
  "valueInteger": 24,
  "derivedFrom": [{ "reference": "Observation/mmse-2023-06-01" }]
}
```

### 1b. Questionnaire data (manual)

The clinician or patient fills in a `QuestionnaireResponse`. A transformation step extracts each answer into a separate `FallRiskFactorObservation`:

```
QuestionnaireResponse.item["falls-count"].answer.valueInteger = 2
    ──→ FallRiskFactorObservation (SNOMED 428942009, valueInteger = 2)
         derivedFrom: QuestionnaireResponse/qr-falls-history
```

### 1c. Physical performance tests

These are entered directly as `FallRiskPerformanceObservation` resources:

| Test | FHIR code | Value type | Scoring levels |
|---|---|---|---|
| TUG test | `LOINC 89423-8` | `valueQuantity` (s) | <12 s = 0 · 12–20 s = 2 · >20 s = 3 |
| 30-sec chair stand | `LOINC 66247-8` | `valueQuantity` ({count}) | ≥12 = 0 · 8–11 = 1 · <8 = 2 |
| 4-Stage balance test | `LOCAL balance-4stage` | `valueInteger` (stage 1–4) | Stage 4 = 0 · Stage 3 = 1 · ≤Stage 2 = 2 |

---

## Step 2: Normalization

After collection, every factor is represented as either a `FallRiskFactorObservation` (factors 1–10) or a `FallRiskPerformanceObservation` (tests a–c). This uniform format is what the scoring algorithm consumes.

**Rule:** No scoring happens on raw `QuestionnaireResponse` or `MedicationStatement` directly. These are always transformed first.

---

## Step 3: Score calculation

### Scoring table

Each factor contributes points to the total score (0–34 points across 13 factors).

**Core factors — required (1–6)**

| # | Factor | Source | FHIR code | Levels | Max pts |
|---|---|---|---|---|---|
| 1 | Falls history (12 mo) | Patient-reported | SNOMED 428942009 | 0 falls=0 · 1=1 · 2=2 · ≥3=3 | 3 |
| 2 | Fear of falling (ABC scale) | Patient-reported | LOINC 97878-3 | None (80–100%)=0 · Slight (51–79%)=1 · Often (30–50%)=2 · Severe (<30%)=3 | 3 |
| 3 | Medications / FRIDs | EHR-derived | LOINC 10160-0 | 0=0 · 1–2=1 · 3=2 · ≥4=3 (+bonus: FRIDs yes/no) | 3 |
| 4 | Comorbidities (count) | EHR-derived | SNOMED 446363004 | 0=0 · 1–2=1 · 3–4=2 · ≥5=3 | 3 |
| 5 | Cognitive impairment (MMSE) | EHR / clinical | LOINC 72107-6 | None (≥27)=0 · Mild (21–26)=1 · Moderate (11–20)=2 · Severe (≤10)=3 | 3 |
| 6 | ADL independence | Patient-reported | SNOMED 284545001 | Independent=0 · Slight=1 · Moderate=2 · Fully dependent=3 | 3 |

**Extended factors — if time allows (7–10)**

| # | Factor | Source | FHIR code | Levels | Max pts |
|---|---|---|---|---|---|
| 7 | Vision & hearing impairment | EHR / clinical | SNOMED 397540003 | No=0 · Yes=1 | 1 |
| 8 | Alcohol use (units/week) | Patient-reported | LOINC 74013-4 | 0=0 · 1–3=1 · 4–10=2 · ≥11=3 | 3 |
| 9 | Physical activity level | Patient-reported | LOINC 99285-9 | Very active=0 · Moderate=1 · Low=2 · Very low=3 | 3 |
| 10 | Walking ability | Patient-reported | SNOMED 282097004 | Independent=0 · With aid=1 | 1 |

**Objective performance tests**

| # | Test | Source | FHIR code | Levels | Max pts |
|---|---|---|---|---|---|
| a | TUG test | Performance | LOINC 89423-8 | <12 s=0 · 12–20 s=2 · >20 s=3 | 3 |
| b | 30-sec chair stand | Performance | LOINC 66247-8 | ≥12=0 · 8–11=1 · <8=2 | 2 |
| c | 4-Stage balance test | Performance | LOCAL balance-4stage | Stage 4=0 · Stage 3=1 · ≤Stage 2=2 | 2 |

**Maximum total: 34 points**

> **Note on missing data:** If a factor cannot be assessed (e.g. patient unable to complete TUG), create the Observation with `status = #cancelled` and a `dataAbsentReason` code. The scoring algorithm applies a predefined fallback score for missing factors and records this in the score Observation's `note` element.

### Score stored as

```json
{
  "resourceType": "Observation",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"]
  },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": {
    "coding": [{
      "system": "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "code": "fall-risk-score",
      "display": "Fall Risk Score"
    }]
  },
  "valueQuantity": {
    "value": 18,
    "unit": "{score}",
    "system": "http://unitsofmeasure.org",
    "code": "#{score}"
  },
  "interpretation": [{
    "coding": [{
      "system": "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "code": "score-moderate",
      "display": "Moderate fall risk threshold met"
    }]
  }],
  "hasMember": [
    { "reference": "Observation/obs-fear-of-falling" },
    { "reference": "Observation/obs-tug-test" },
    { "reference": "Observation/obs-chair-stand" }
  ]
}
```

---

## Step 4: Classification

The score is mapped to a risk category using the thresholds defined in `FallRiskScoreThresholdMap` (ConceptMap). The SNOMED codes are fixed by `FallRiskCategoryVS`.

| Total score | Local threshold code | SNOMED code | Display |
|---|---|---|---|
| 0–11 | `score-low` | `439430008` | Low risk (qualifier value) |
| 12–22 | `score-moderate` | `332721351000132106` | Moderate risk (qualifier value) |
| 23–34 | `score-high` | `455201601000132100` | High risk (qualifier value) |

**Maria's score: 18 → Moderate risk (SNOMED `332721351000132106`)**

This becomes a `FallRiskObservation`:

```json
{
  "resourceType": "Observation",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"]
  },
  "status": "final",
  "code": {
    "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At risk for falls" }]
  },
  "valueCodeableConcept": {
    "coding": [{
      "system": "http://snomed.info/sct",
      "code": "332721351000132106",
      "display": "At moderate risk for fall (finding)"
    }]
  },
  "derivedFrom": [{ "reference": "Observation/obs-fall-risk-score" }]
}
```

---

## Step 5: Problem list entry

When the score is **Moderate or High**, a `Condition` resource is created and added to the patient's problem list:

```json
{
  "resourceType": "Condition",
  "clinicalStatus": {
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-clinical", "code": "active" }]
  },
  "verificationStatus": {
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status", "code": "confirmed" }]
  },
  "category": [{
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-category", "code": "problem-list-item" }]
  }],
  "code": {
    "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At risk for falls" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "onsetDateTime": "2024-11-15",
  "evidence": [{ "detail": [{ "reference": "Observation/obs-fall-risk-result" }] }]
}
```

This entry is visible in any FHIR-capable EHR that supports the standard problem list view, ensuring continuity of care.

---

## Implementation notes

### For developers

- All Observation resources must reference the patient via `Observation.subject`.
- All Observations must carry `effectiveDateTime` (assessment date).
- The `hasMember` links in `FallRiskScoreObservation` are the authoritative list of inputs used for a given score.
- A new assessment episode = a new set of Observations with a new `effectiveDateTime`.
- `FallRiskScoreObservation.code` uses `LOCAL#fall-risk-score` — no standard code exists for this composite score.
- `FallRiskScoreObservation.interpretation` carries the local threshold band code (`score-low`, `score-moderate`, or `score-high`) so consumers do not need to reapply the ConceptMap.
- The authoritative threshold cutoffs (0–11 / 12–22 / 23–34) are defined in the `FallRiskScoreThresholdMap` ConceptMap. Do not hardcode them in application logic — resolve them from the ConceptMap.

### Tracking history

Because each assessment creates new Observation resources with timestamps, the complete history of a patient's fall risk is preserved. Trend analysis is possible by querying `FallRiskScoreObservation` resources for a patient ordered by `effectiveDateTime`.

### Error handling

If a factor cannot be assessed (patient unable to complete TUG, for example), the Observation should be created with `status = #cancelled` and a `dataAbsentReason` code. The scoring algorithm should apply a predefined fallback score for missing factors and document this assumption in the score Observation's `note` element.
