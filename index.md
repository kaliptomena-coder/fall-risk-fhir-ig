# Fall Risk Assessment Implementation Guide

## Overview & Clinical Intent
Falls are a leading cause of injury and loss of independence among older adults. This Implementation Guide (IG) establishes a standardized digital framework for capturing, tracking, and scoring clinical fall risks. 

By unifying subjective patient history, automated Electronic Health Record (EHR) data elements, and objective physical performance tests into a structured FHIR model, this specification enables predictable and deterministic clinical risk stratification.

---

## Data Flow Architecture
This IG is designed around a clear, hierarchical data lifecycle that transforms raw patient inputs into actionable clinical diagnoses:

1. **Data Capture (`QuestionnaireResponse`)**: The clinician or patient completes a 13-factor assessment tracking falls history, medication use, and active comorbidities.
2. **Granular Extraction (`Observation`)**: Data points are broken out into individual `FallRiskFactorObservation` (for historical data) and `FallRiskPerformanceObservation` instances (for timed physical tests like TUG).
3. **Evidence Aggregation (`FallRiskScoreObservation`)**: A computation engine aggregates the scores from the individual observations into a single total numeric score ranging from **0 to 34**.
4. **Clinical Stratification (`ConceptMap` & `Condition`)**: A standardized `ConceptMap` translates the numeric score into a risk category (Low, Moderate, High) output via a final `FallRiskObservation`, which links directly to an active `Condition` on the patient's problem list.

---

## Key Artifacts
Implementers should focus on the following primary profiles and terminologies defined in this guide:

### Core Profiles
* **[FallRiskFactorObservation](StructureDefinition-fall-risk-factor-observation.html)**: Tracks single clinical factors (e.g., fear of falling, visual impairment).
* **[FallRiskPerformanceObservation](StructureDefinition-fall-risk-performance-observation.html)**: Captures objective physical tests (e.g., Timed Up & Go, 30-Second Chair Stand).
* **[FallRiskScoreObservation](StructureDefinition-fall-risk-score-observation.html)**: Holds the accumulated score and references all contributing observations using `hasMember`.
* **[FallRiskObservation](StructureDefinition-fall-risk-observation.html)**: The definitive screening assertion detailing final clinical risk categorization.

### Deterministic Mapping
* **[FallRiskScoreThresholdMap](ConceptMap-fall-risk-score-threshold-map.html)**: Maps numeric ranges directly to SNOMED CT qualifier values.

| Total Numeric Score | Risk Classification | SNOMED CT Code |
| :--- | :--- | :--- |
| **0–11** | Low Risk | `439430008` |
| **12–22** | Moderate Risk | `332721351000132106` |
| **23–34** | High Risk | `455201601000132100` |

---

{% include ip-statements.xhtml %}
{% include cross-version-analysis.xhtml %}
{% include dependency-table.xhtml %}
{% include globals-table.xhtml %}