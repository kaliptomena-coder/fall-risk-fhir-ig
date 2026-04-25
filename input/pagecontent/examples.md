# Examples

This page walks through complete FHIR JSON examples for a real assessment scenario: **Maria Müller**, 78 years old, assessed on 15 November 2024.

All example resources are also available in the [Artifacts](artifacts.html) section.

---

## Patient

The patient resource uses core FHIR `Patient`. No special profile is needed.

```json
{
  "resourceType": "Patient",
  "id": "example-patient",
  "name": [{ "family": "Müller", "given": ["Maria"] }],
  "gender": "female",
  "birthDate": "1946-03-12",
  "address": [{
    "line": ["Hauptstraße 15"],
    "city": "Vienna",
    "country": "AT"
  }]
}
```

---

## Factor Observation: Fear of Falling

Maria scores 55% on the Activities-specific Balance Confidence (ABC) Scale.
55% maps to **1 point** in the scoring table (50–79% range).

```json
{
  "resourceType": "Observation",
  "id": "obs-fear-of-falling",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"]
  },
  "status": "final",
  "category": [{
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "survey" }]
  }],
  "code": {
    "coding": [{ "system": "http://loinc.org", "code": "95418-0", "display": "ABC Scale – fear of falling" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:30:00+01:00",
  "valueQuantity": {
    "value": 55,
    "unit": "%",
    "system": "http://unitsofmeasure.org",
    "code": "%"
  }
}
```

**Key points:**
- `code` uses LOINC 95418-0 (ABC Scale)
- `valueQuantity` in percent — lower means more fear of falling
- `effectiveDateTime` captures exactly when the assessment happened

---

## Performance Test: Timed Up and Go (TUG)

Maria took 14.2 seconds. The risk threshold is > 12 seconds, so this scores **2 points**.

```json
{
  "resourceType": "Observation",
  "id": "obs-tug-test",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"]
  },
  "status": "final",
  "category": [{
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "exam" }]
  }],
  "code": {
    "coding": [{ "system": "http://loinc.org", "code": "80456-7", "display": "Timed Up and Go Test" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:45:00+01:00",
  "valueQuantity": {
    "value": 14.2,
    "unit": "s",
    "system": "http://unitsofmeasure.org",
    "code": "s"
  }
}
```

**Key points:**
- Performance tests use category `exam` (not `survey`)
- UCUM unit `s` for seconds is mandatory for interoperability
- Any system that understands LOINC 80456-7 knows this is a TUG test

---

## Performance Test: 30-Second Chair Stand

Maria completed 8 repetitions — below the expected 10–11 for her age group. Scores **1 point**.

```json
{
  "resourceType": "Observation",
  "id": "obs-chair-stand",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"]
  },
  "status": "final",
  "category": [{
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "exam" }]
  }],
  "code": {
    "coding": [{ "system": "http://loinc.org", "code": "82755-5", "display": "30-Second Chair Stand Test" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:50:00+01:00",
  "valueQuantity": {
    "value": 8,
    "unit": "repetitions",
    "system": "http://unitsofmeasure.org",
    "code": "{repetition}"
  }
}
```

---

## QuestionnaireResponse: Falls History

The nurse asks Maria about past falls. Maria reports 2 falls in the past 12 months.

```json
{
  "resourceType": "QuestionnaireResponse",
  "id": "qr-falls-history",
  "status": "completed",
  "subject": { "reference": "Patient/example-patient" },
  "authored": "2024-11-15T10:00:00+01:00",
  "item": [{
    "linkId": "falls-count",
    "text": "How many times have you fallen in the last 12 months?",
    "answer": [{ "valueInteger": 2 }]
  }]
}
```

This `QuestionnaireResponse` would then be transformed into a `FallRiskFactorObservation`:

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "428807008", "display": "History of fall" }] },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T10:00:00+01:00",
  "valueInteger": 2,
  "derivedFrom": [{ "reference": "QuestionnaireResponse/qr-falls-history" }]
}
```

Note the `derivedFrom` link — this is the **audit trail**.

---

## Fall Risk Score (18/30)

The score Observation aggregates all factor Observations. `hasMember` lists every contributing input.

```json
{
  "resourceType": "Observation",
  "id": "obs-fall-risk-score",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"]
  },
  "status": "final",
  "code": {
    "coding": [{ "system": "http://loinc.org", "code": "75218-8", "display": "Fall risk total score" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T11:00:00+01:00",
  "valueQuantity": {
    "value": 18,
    "unit": "score",
    "system": "http://unitsofmeasure.org"
  },
  "hasMember": [
    { "reference": "Observation/obs-fear-of-falling" },
    { "reference": "Observation/obs-tug-test" },
    { "reference": "Observation/obs-chair-stand" }
  ]
}
```

---

## Fall Risk Classification (Moderate)

Score 18 falls in the 10–19 range → **Moderate Risk**.

```json
{
  "resourceType": "Observation",
  "id": "obs-fall-risk-result",
  "meta": {
    "profile": ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"]
  },
  "status": "final",
  "code": {
    "coding": [{ "system": "http://loinc.org", "code": "71802-3", "display": "Fall risk screening" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "effectiveDateTime": "2024-11-15T11:00:00+01:00",
  "valueCodeableConcept": {
    "coding": [{ "system": "http://snomed.info/sct", "code": "723511001", "display": "Moderate risk" }]
  },
  "derivedFrom": [{ "reference": "Observation/obs-fall-risk-score" }]
}
```

---

## Condition: At Risk of Fall

This enters the patient's problem list and is visible in any FHIR EHR.

```json
{
  "resourceType": "Condition",
  "id": "condition-fall-risk",
  "clinicalStatus": {
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-clinical", "code": "active" }]
  },
  "verificationStatus": {
    "coding": [{ "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status", "code": "confirmed" }]
  },
  "code": {
    "coding": [{ "system": "http://snomed.info/sct", "code": "129839007", "display": "At increased risk for falls (finding)" }]
  },
  "subject": { "reference": "Patient/example-patient" },
  "onsetDateTime": "2024-11-15",
  "evidence": [{
    "detail": [{ "reference": "Observation/obs-fall-risk-result" }]
  }]
}
```

**Why this matters:** This `Condition` will appear in Maria's problem list in any hospital or GP system that is FHIR-capable. If she is admitted to emergency, the team sees immediately that she is at moderate fall risk — without anyone needing to re-do the assessment.

---

## Complete Resource Chain (Summary)

```
Patient/example-patient
    │
    ├─ QuestionnaireResponse/qr-falls-history
    │       └── derivedFrom ──→ Observation (falls count)
    │
    ├─ Observation/obs-fear-of-falling    (LOINC 95418-0, 55%)
    ├─ Observation/obs-tug-test           (LOINC 80456-7, 14.2s)
    ├─ Observation/obs-chair-stand        (LOINC 82755-5, 8 reps)
    │
    ├─ Observation/obs-fall-risk-score    (LOINC 75218-8, 18/30)
    │       hasMember: fear-of-falling, tug-test, chair-stand, ...
    │
    ├─ Observation/obs-fall-risk-result   (LOINC 71802-3, Moderate)
    │       derivedFrom: obs-fall-risk-score
    │
    └─ Condition/condition-fall-risk      (SNOMED 129839007)
            evidence: obs-fall-risk-result
```
