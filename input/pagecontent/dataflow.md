# Data Flow & Scoring

This page explains step-by-step how raw clinical data becomes a fall risk classification, and how each step maps to a specific FHIR resource.

---

## Overview of the Flow

```
Step 1: Data Collection
    EHR pull (automated) + Questionnaire (manual) + Physical tests
         │
Step 2: Normalization
    Everything → FallRiskFactorObservation or FallRiskPerformanceObservation
         │
Step 3: Score Calculation
    All Observations → FallRiskScoreObservation (0–30 points)
         │
Step 4: Classification
    Score → FallRiskObservation (Low / Moderate / High)
         │
Step 5: Problem List
    Classification → Condition ("At risk of fall") on problem list
```

---

## Step 1: Data Collection

Three sources feed the assessment:

### 1a. EHR-Derived Data (Automated)

The clinical system queries existing FHIR resources and creates derived Observations:

| Source Resource | Query | Result Observation |
|---|---|---|
| `MedicationStatement` | Count all active medications | `valueQuantity` (integer count) |
| `MedicationStatement` | Filter high-risk meds (ATC codes) | `valueQuantity` (0/1/2+) |
| `Condition` | Count active diagnoses | `valueQuantity` (integer count) |
| `Observation` (LOINC 72107-6) | Retrieve latest MMSE | `valueInteger` |
| `Observation` (SNOMED 397540003) | Retrieve vision/hearing status | `valueCodeableConcept` |

The derived Observation uses `derivedFrom` to reference its source:

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": { "coding": [{ "system": "http://loinc.org", "code": "72107-6" }] },
  "valueInteger": 24,
  "derivedFrom": [{ "reference": "Observation/mmse-2023-06-01" }]
}
```

### 1b. Questionnaire Data (Manual)

The clinician or patient fills in a `QuestionnaireResponse`. A transformation step extracts each answer into a separate `FallRiskFactorObservation`:

```
QuestionnaireResponse.item["falls-count"].answer.valueInteger = 2
    ──→ FallRiskFactorObservation (SNOMED 428807008, valueInteger = 2)
         derivedFrom: QuestionnaireResponse/qr-falls-history
```

### 1c. Physical Performance Tests

These are entered directly as `FallRiskPerformanceObservation` resources with LOINC codes and UCUM units:

| Test | LOINC | Value type | Risk threshold |
|---|---|---|---|
| 30-sec Chair Stand | 82755-5 | `valueQuantity {repetitions}` | < 10 reps |
| 4-Stage Balance | 92631-9 | `valueCodeableConcept` | Stage < 3 |
| TUG Test | 80456-7 | `valueQuantity s` | > 12 seconds |

---

## Step 2: Normalization

After collection, every factor is represented as a `FallRiskFactorObservation` or `FallRiskPerformanceObservation`. This uniform format is what the scoring algorithm consumes.

**Rule:** No scoring happens on raw `QuestionnaireResponse` or `MedicationStatement` directly. These are always transformed first.

---

## Step 3: Score Calculation

### Scoring Table

Each factor contributes points to the total score (0–30):

| Factor | Condition | Points |
|---|---|---|
| **1. Falls history** | 0 falls | 0 |
| | 1 fall | 1 |
| | 2+ falls | 2 |
| **2. Fear of falling** | ABC score ≥ 80% | 0 |
| | ABC 50–79% | 1 |
| | ABC < 50% | 2 |
| **3. Medications** | 0–3 meds | 0 |
| | 4–6 meds | 1 |
| | 7+ meds OR 2+ high-risk | 2 |
| **4. Comorbidities** | 0–1 | 0 |
| | 2–3 | 1 |
| | 4+ | 2 |
| **5. Cognition (MMSE)** | ≥ 25 | 0 |
| | 18–24 | 1 |
| | < 18 | 2 |
| **6. Vision/Hearing** | Both normal | 0 |
| | One impaired | 1 |
| | Both impaired | 2 |
| **7. Alcohol** | 0–7 units/wk | 0 |
| | 8–14 units/wk | 1 |
| | 15+ units/wk | 2 |
| **8. Physical activity** | Active (≥3/wk) | 0 |
| | Some (1–2/wk) | 1 |
| | Inactive | 2 |
| **9. ADL Independence** | Fully independent | 0 |
| | Partially dependent | 1 |
| | Dependent | 2 |
| **10. Walking** | Normal | 0 |
| | Difficulty | 1 |
| | Cannot walk unaided | 2 |
| **a. Chair Stand** | ≥ 12 reps | 0 |
| | 8–11 reps | 1 |
| | < 8 reps | 2 |
| **b. Balance Test** | Stage 4 | 0 |
| | Stage 3 | 1 |
| | Stage 1–2 | 2 |
| **c. TUG Test** | ≤ 10 s | 0 |
| | 10–12 s | 1 |
| | > 12 s | 2 |

**Total: 0–30 points** (13 factors × max 2 points each, adjusted to 30)

### Score stored as:

```json
{
  "resourceType": "Observation",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"] },
  "code": { "coding": [{ "system": "http://loinc.org", "code": "75218-8", "display": "Fall risk total score" }] },
  "valueQuantity": { "value": 18, "unit": "score", "system": "http://unitsofmeasure.org" },
  "hasMember": [
    { "reference": "Observation/obs-fear-of-falling" },
    { "reference": "Observation/obs-tug-test" }
  ]
}
```

---

## Step 4: Classification

The score is mapped to a risk category:

| Total Score | Classification | SNOMED Code |
|---|---|---|
| 0 – 9 | Low Risk | 723510000 |
| 10 – 19 | Moderate Risk | 723511001 |
| 20 – 30 | High Risk | 723505004 |

**Maria's score: 18 → Moderate Risk (SNOMED 723511001)**

This becomes a `FallRiskObservation`:

```json
{
  "resourceType": "Observation",
  "code": { "coding": [{ "system": "http://loinc.org", "code": "71802-3" }] },
  "valueCodeableConcept": {
    "coding": [{ "system": "http://snomed.info/sct", "code": "723511001", "display": "Moderate risk" }]
  },
  "derivedFrom": [{ "reference": "Observation/obs-fall-risk-score" }]
}
```

---

## Step 5: Problem List Entry

When the score is Moderate or High, a `Condition` resource is created and added to the patient's problem list:

```json
{
  "resourceType": "Condition",
  "clinicalStatus": { "coding": [{ "code": "active" }] },
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At increased risk for falls (finding)" }] },
  "evidence": [{ "detail": [{ "reference": "Observation/obs-fall-risk-result" }] }]
}
```

This entry is visible in any FHIR-capable EHR that supports the standard problem list view, ensuring continuity of care.

---

## Implementation Notes

### For developers

- All Observation resources must reference the patient via `Observation.subject`
- All Observations must carry `effectiveDateTime` (assessment date)
- The `hasMember` links in `FallRiskScoreObservation` are the authoritative list of inputs used for a given score
- A new assessment episode = a new set of Observations with a new `effectiveDateTime`

### Tracking history

Because each assessment creates new Observation resources with timestamps, the complete history of a patient's fall risk is preserved. Trend analysis is possible by querying `FallRiskScoreObservation` resources for a patient ordered by `effectiveDateTime`.

### Error handling

If a factor cannot be assessed (patient unable to complete TUG, for example), the Observation should be created with `status = #cancelled` and a `dataAbsentReason` code. The scoring algorithm should apply a predefined fallback score for missing factors and document this assumption.
