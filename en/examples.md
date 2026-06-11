# Examples - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Examples**

## Examples

# Examples

This page walks through complete FHIR JSON examples for a real assessment scenario: Maria Müller, 78 years old, assessed on 15 November 2024.

All example resources are also available in the Artifacts section.

-------

## Patient

The patient resource uses core FHIR Patient. No special profile is needed.

```
{
  "resourceType": "Patient",
  "id": "example-patient",
  "name": [{ "family": "Mueller", "given": ["Maria"] }],
  "gender": "female",
  "birthDate": "1946-03-12",
  "address": [{
    "line": ["Hauptstrasse 15"],
    "city": "Vienna",
    "country": "AT"
  }]
}

```

-------

## Practitioner

The physiotherapist conducting the assessment.

```
{
  "resourceType": "Practitioner",
  "id": "example-practitioner",
  "name": [{ "family": "Huber", "given": ["Anna"] }]
}

```

-------

## QuestionnaireResponse

The practitioner records all 13 patient answers in a single QuestionnaireResponse. Items 0–8 are top-level. Items 9–12 are nested inside the `ehr-fallback-group`.

```
{
  "resourceType": "QuestionnaireResponse",
  "id": "qr-falls-history",
  "questionnaire": "https://example.org/fhir/fall-risk/Questionnaire/falls-history",
  "status": "completed",
  "subject": { "reference": "Patient/example-patient" },
  "authored": "2024-11-15T10:00:00+01:00",
  "item": [
    {
      "linkId": "falls-count",
      "text": "How many times have you fallen in the last 12 months?",
      "answer": [{ "valueInteger": 2 }]
    },
    {
      "linkId": "fear-of-falling",
      "text": "Are you worried about falling? (ABC scale)",
      "answer": [{ "valueCoding": { "system": "http://snomed.info/sct", "code": "373066001", "display": "Yes" } }]
    },
    {
      "linkId": "adl-independence",
      "text": "Activities of Daily Living (ADL): functional independence",
      "answer": [{ "valueString": "Slight assistance needed" }]
    },
    {
      "linkId": "walking-ability",
      "text": "Walking ability and use of walking aids",
      "answer": [{ "valueString": "With aids" }]
    },
    {
      "linkId": "alcohol-use",
      "text": "Alcohol use (units per week)",
      "answer": [{ "valueQuantity": { "value": 2, "unit": "units/week", "system": "http://unitsofmeasure.org", "code": "/wk" } }]
    },
    {
      "linkId": "physical-activity",
      "text": "Current physical activity level",
      "answer": [{ "valueString": "Low activity" }]
    },
    {
      "linkId": "tug-score",
      "text": "Timed Up and Go test result (seconds)",
      "answer": [{ "valueDecimal": 14.2 }]
    },
    {
      "linkId": "chair-stand-score",
      "text": "Sit to stand frequency in 30 seconds (repetitions)",
      "answer": [{ "valueInteger": 8 }]
    },
    {
      "linkId": "balance-4stage",
      "text": "4-Stage Balance Test result (highest stage reached)",
      "answer": [{ "valueInteger": 3 }]
    },
    {
      "linkId": "ehr-fallback-group",
      "text": "Clinical History Data",
      "item": [
        {
          "linkId": "medications",
          "text": "Total medication count (including FRIDs flag)",
          "answer": [{ "valueString": "3:FRID" }]
        },
        {
          "linkId": "comorbidities",
          "text": "Number of active diagnoses (comorbidities)",
          "answer": [{ "valueInteger": 3 }]
        },
        {
          "linkId": "cognitive-status",
          "text": "MMSE score",
          "answer": [{ "valueInteger": 24 }]
        },
        {
          "linkId": "vision-impairment",
          "text": "Vision or hearing impairment present?",
          "answer": [{ "valueBoolean": true }]
        }
      ]
    }
  ]
}

```

-------

## Factor Observations (Manual)

Each QuestionnaireResponse answer is transformed into a standardized Observation. The `derivedFrom` link preserves the audit trail back to the original patient answer.

### Factor 1: Falls History

```
{
  "resourceType": "Observation",
  "id": "obs-falls-history",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "428942009", "display": "History of fall (situation)" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:00:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueInteger": 2,
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 2 points (2 falls in 12 months).

### Factor 2: Fear of Falling

```
{
  "resourceType": "Observation",
  "id": "obs-fear-of-falling",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "97878-3", "display": "Worried about falling" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueCodeableConcept": { "coding": [{ "system": "http://snomed.info/sct", "code": "373066001", "display": "Yes (qualifier value)" }] },
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 2 points (moderate fear).

### Factor 3: ADL Independence

```
{
  "resourceType": "Observation",
  "id": "obs-adl",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "284545001", "display": "Ability to perform activities of everyday life (observable entity)" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueCodeableConcept": { "text": "Slight assistance needed" },
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 1 point (slight assistance needed).

### Factor 4: Walking Ability

```
{
  "resourceType": "Observation",
  "id": "obs-walking",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "282097004", "display": "Ability to walk (observable entity)" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueCodeableConcept": { "text": "With aids" },
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 1 point (uses walking aid).

### Factor 5: Medications (incl. FRID)

```
{
  "resourceType": "Observation",
  "id": "obs-medications",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "10160-0", "display": "History of Medication use Narrative" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueString": "3:FRID",
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 3 points (3 medications including FRID — Fall Risk Increasing Drugs bonus applied, capped at 3).

### Factor 6: Comorbidities

```
{
  "resourceType": "Observation",
  "id": "obs-comorbidities",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "446363004", "display": "Adult comorbidity evaluation-27 score" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueInteger": 3,
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 2 points (3–4 active diagnoses range).

### Factor 7: Alcohol Use

```
{
  "resourceType": "Observation",
  "id": "obs-alcohol",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "74013-4", "display": "Alcoholic drinks per day" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueQuantity": { "value": 2, "unit": "/wk", "system": "http://unitsofmeasure.org", "code": "/wk" },
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 1 point (1–3 units per week).

### Factor 8: Physical Activity

```
{
  "resourceType": "Observation",
  "id": "obs-physical-activity",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "99285-9", "display": "Current activity level" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueCodeableConcept": { "text": "Low activity" },
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 2 points (low activity level).

### Factor 9: Cognitive Status (MMSE)

```
{
  "resourceType": "Observation",
  "id": "obs-cognitive",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "72107-6", "display": "Mini-Mental State Examination [MMSE]" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueInteger": 24,
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 1 point (MMSE 21–26, mild impairment range).

### Factor 10: Vision Impairment

```
{
  "resourceType": "Observation",
  "id": "obs-vision",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "397540003", "display": "Visual impairment" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueBoolean": true,
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}

```

Score: 1 point (impairment present).

-------

## Performance Test Observations

Physical performance tests are measured directly by the practitioner and use category `exam`.

### Test A: Timed Up and Go (TUG)

```
{
  "resourceType": "Observation",
  "id": "obs-tug-test",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "exam" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "89423-8", "display": "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:45:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueQuantity": { "value": 14.2, "unit": "s", "system": "http://unitsofmeasure.org", "code": "s" }
}

```

Score: 2 points (12–20 seconds range). Note the TUG scale is non-linear: 0 / 2 / 3 — there is no 1-point value.

### Test B: 30-Second Chair Stand

```
{
  "resourceType": "Observation",
  "id": "obs-chair-stand",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "exam" }] }],
  "code": { "coding": [{ "system": "http://loinc.org", "code": "66247-8", "display": "Sit to stand frequency in 30 seconds" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:50:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueQuantity": { "value": 8, "unit": "{count}", "system": "http://unitsofmeasure.org", "code": "{count}" }
}

```

Score: 1 point (8–11 repetitions range).

### Test C: 4-Stage Balance Test

```
{
  "resourceType": "Observation",
  "id": "obs-balance",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "exam" }] }],
  "code": { "coding": [{ "system": "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes", "code": "balance-4stage", "display": "4-Stage Balance Test" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:55:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueInteger": 3
}

```

Score: 1 point (stage 3 achieved, stage 4 not reached).

-------

## Fall Risk Score (20 / 34)

The score Observation aggregates all 13 factor and performance Observations via `hasMember`.

| | | | |
| :--- | :--- | :--- | :--- |
| Falls history | SNOMED 428942009 | 2 falls | 2 |
| Fear of falling | LOINC 97878-3 | Yes | 2 |
| ADL independence | SNOMED 284545001 | Slight | 1 |
| Walking ability | SNOMED 282097004 | With aids | 1 |
| Medications | LOINC 10160-0 | 3:FRID | 3 |
| Comorbidities | SNOMED 446363004 | 3 | 2 |
| Alcohol use | LOINC 74013-4 | 2/wk | 1 |
| Physical activity | LOINC 99285-9 | Low | 2 |
| Cognitive status | LOINC 72107-6 | MMSE 24 | 1 |
| Vision impairment | SNOMED 397540003 | true | 1 |
| TUG test | LOINC 89423-8 | 14.2 s | 2 |
| Chair stand | LOINC 66247-8 | 8 reps | 1 |
| Balance 4-stage | LOCAL balance-4stage | Stage 3 | 1 |
| **Total** |   |   | **20** |

```
{
  "resourceType": "Observation",
  "id": "obs-fall-risk-score",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"] },
  "status": "final",
  "category": [{ "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }] }],
  "code": { "coding": [{ "system": "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes", "code": "fall-risk-score", "display": "Fall Risk Score" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T11:00:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueQuantity": { "value": 20, "unit": "{score}", "system": "http://unitsofmeasure.org", "code": "{score}" },
  "interpretation": [{ "coding": [{ "system": "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes", "code": "score-moderate", "display": "Moderate fall risk threshold met" }] }],
  "hasMember": [
    { "reference": "Observation/obs-falls-history" },
    { "reference": "Observation/obs-fear-of-falling" },
    { "reference": "Observation/obs-adl" },
    { "reference": "Observation/obs-walking" },
    { "reference": "Observation/obs-medications" },
    { "reference": "Observation/obs-comorbidities" },
    { "reference": "Observation/obs-alcohol" },
    { "reference": "Observation/obs-physical-activity" },
    { "reference": "Observation/obs-cognitive" },
    { "reference": "Observation/obs-vision" },
    { "reference": "Observation/obs-tug-test" },
    { "reference": "Observation/obs-chair-stand" },
    { "reference": "Observation/obs-balance" }
  ]
}

```

Thresholds defined by the ConceptMap in this IG:

* **0–11** → LOW risk
* **12–22** → MODERATE risk
* **23–34** → HIGH risk

Score 20 falls in the 12–22 range → **Moderate Risk**.

-------

## Fall Risk Classification

```
{
  "resourceType": "Observation",
  "id": "obs-fall-risk-result",
  "meta": { "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"] },
  "status": "final",
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At risk for falls" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T11:00:00+01:00",
  "performer": [{ "reference": "Practitioner/example-practitioner" }],
  "valueCodeableConcept": { "coding": [{ "system": "http://snomed.info/sct", "code": "332721351000132106", "display": "Moderate risk (qualifier value)" }] },
  "derivedFrom": [{ "reference": "Observation/obs-fall-risk-score" }]
}

```

-------

## Condition: At Risk of Falls

This resource enters the patient's problem list and is visible in any FHIR-capable system.

```
{
  "resourceType": "Condition",
  "id": "condition-fall-risk",
  "clinicalStatus": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-clinical", "code": "active" }] },
  "verificationStatus": { "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status", "code": "confirmed" }] },
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At risk for falls" }] },
  "subject": { "reference": "Patient/example-patient" },
  "onsetDateTime": "2024-11-15",
  "evidence": [{ "detail": [{ "reference": "Observation/obs-fall-risk-result" }] }]
}

```

If Maria is admitted to any FHIR-capable hospital, the clinical team immediately sees she is at moderate fall risk — without repeating the assessment.

-------

## Complete Resource Chain

```
Patient/example-patient
    │
    ├─ QuestionnaireResponse/qr-falls-history
    │       (all 13 answers, including nested EHR group)
    │
    ├── Factor Observations (derivedFrom: qr-falls-history)
    │   ├─ obs-falls-history        SNOMED 428942009   2 falls      → 2 pts
    │   ├─ obs-fear-of-falling      LOINC  97878-3     Yes          → 2 pts
    │   ├─ obs-adl                  SNOMED 284545001   Slight       → 1 pt
    │   ├─ obs-walking              SNOMED 282097004   With aids    → 1 pt
    │   ├─ obs-medications          LOINC  10160-0     3:FRID       → 3 pts
    │   ├─ obs-comorbidities        SNOMED 446363004   3            → 2 pts
    │   ├─ obs-alcohol              LOINC  74013-4     2/wk         → 1 pt
    │   ├─ obs-physical-activity    LOINC  99285-9     Low          → 2 pts
    │   ├─ obs-cognitive            LOINC  72107-6     MMSE 24      → 1 pt
    │   └─ obs-vision               SNOMED 397540003   true         → 1 pt
    │
    ├── Performance Observations (measured directly)
    │   ├─ obs-tug-test             LOINC  89423-8     14.2 s       → 2 pts
    │   ├─ obs-chair-stand          LOINC  66247-8     8 reps       → 1 pt
    │   └─ obs-balance              LOCAL  balance-4stage  Stage 3  → 1 pt
    │
    ├─ obs-fall-risk-score
    │   LOCAL fall-risk-score   value: 20/34
    │   interpretation: score-moderate (12–22 range)
    │   hasMember: all 13 observations above
    │
    ├─ obs-fall-risk-result
    │   SNOMED 129839007 "At risk for falls"
    │   valueCodeableConcept: SNOMED 332721351000132106 "Moderate risk"
    │   derivedFrom: obs-fall-risk-score
    │
    └─ condition-fall-risk
        SNOMED 129839007 "At risk for falls"
        clinicalStatus: active
        evidence.detail: obs-fall-risk-result

```

## Complete Assessment Bundle

For convenience, all 12 resources detailed above are packaged into a single FHIR Bundle instance. You can view, download, or use this package for testing integration endpoints.

* [Example – Complete Fall Risk Assessment Bundle](Bundle-fall-risk-bundle-example.md)

