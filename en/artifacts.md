# Artifacts Summary - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Artifacts Summary**

## Artifacts Summary

This page provides a list of the FHIR artifacts defined as part of this implementation guide.

### Structures: Resource Profiles 

These define constraints on FHIR resources for systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [ Fall Risk Factor Observation  ](StructureDefinition-fall-risk-factor-observation.md) | A standardized FHIR Observation representing a single contributing factor to fall risk (e.g., fear of falling, walking ability, medication use). This profile supports both automated EHR data extraction and manual questionnaire responses, providing a consistent structure for clinical risk scoring algorithms. |
| [ Fall Risk Observation  ](StructureDefinition-fall-risk-observation.md) | The outcome of a fall risk screening episode, capturing the overall risk classification (Low / Moderate / High) and referencing the aggregated score Observation. |
| [ Fall Risk Performance Test Observation  ](StructureDefinition-fall-risk-performance-observation.md) | Objective physical performance measurements used in fall risk assessment, including the Sit to stand frequency in 30 seconds, 4-Stage Balance Test, and the Timed Up & Go (TUG) test. |
| [ Fall Risk Score Observation  ](StructureDefinition-fall-risk-score-observation.md) | An aggregated fall risk score (0–34) derived from individual Fall Risk Factor Observations and Fall Risk Performance Observations. The 'hasMember' element links to the contributing factors, ensuring full traceability of the clinical evidence. |

### Terminology: Value Sets 

These define sets of codes used by systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [ Fall Risk Category ValueSet  ](ValueSet-fall-risk-category-vs.md) | Risk classification outcomes for fall risk assessment using SNOMED qualifier values. |
| [ Fall Risk Factors ValueSet  ](ValueSet-fall-risk-factors-vs.md) | Standardized LOINC and SNOMED codes for fall risk assessment inputs (factors 1–10). |
| [ Fall Risk Performance Tests ValueSet  ](ValueSet-fall-risk-performance-tests-vs.md) | Codes for objective physical performance tests used in fall risk assessment (tests a–c). |
| [ Fall Risk Score Threshold ValueSet  ](ValueSet-fall-risk-threshold-vs.md) | Local codes that identify which score band (Low / Moderate / High) a computed FallRiskScore falls into. Used in FallRiskObservation.note or as an interpretation code alongside valueQuantity in FallRiskScoreObservation. |

### Terminology: Code Systems 

These define new code systems used by systems conforming to this implementation guide.

| | |
| :--- | :--- |
| [ Fall Risk Local Code System  ](CodeSystem-fall-risk-codes.md) | Local codes for physical performance tests, aggregate scores, and fall risk factors not available in LOINC or SNOMED CT. |

### Terminology: Concept Maps 

These define transformations to convert between codes by systems conforming with this implementation guide.

| | |
| :--- | :--- |
| [ Fall Risk Score Threshold ConceptMap  ](ConceptMap-fall-risk-score-threshold-map.md) | Maps local score-band codes (score-low / score-moderate / score-high) to the corresponding SNOMED risk category codes in FallRiskCategoryVS. The numeric cutoffs encoded in the comments and group.element.display fields are the authoritative thresholds for this IG: score-low = total score 0–11 score-moderate = total score 12–22 score-high = total score 23–34 |

### Example: Example Instances 

These are example instances that show what data produced and consumed by systems conforming with this implementation guide might look like.

| | |
| :--- | :--- |
| [ Example Patient – Maria Müller  ](Patient-example-patient.md) | A 78-year-old female patient undergoing fall risk assessment. |
| [ Example Practitioner  ](Practitioner-example-practitioner.md) | The physiotherapist conducting the fall risk assessment. |
| [ Example – ADL Independence  ](Observation-obs-adl.md) | Observation capturing the patient's functional independence level (slight assistance needed) — scores 1 pt. |
| [ Example – Complete Fall Risk Assessment Bundle  ](Bundle-fall-risk-bundle-example.md) | A Bundle containing all FHIR resources for a single fall risk assessment session. This Bundle can be sent to any FHIR R4 server in one request. |
| [ Example – Condition: At Risk of Falls  ](Condition-condition-fall-risk.md) | Problem list entry created after moderate fall risk assessment. |
| [ Example – Fall Risk Score 20/34)  ](Observation-obs-fall-risk-score.md) | Aggregated fall risk score of 20 out of 34 — Moderate risk (score band 12–22). |
| [ Example – Fall Risk Screening Result  ](Observation-obs-fall-risk-result.md) | Overall fall risk classification: Moderate. |
| [ Example – Falls History  ](Observation-obs-falls-history.md) | Observation capturing the patient's history of 2 falls within the last 12 months — scores 2 pts. |
| [ Example – Falls History QuestionnaireResponse  ](QuestionnaireResponse-qr-falls-history.md) | A completed QuestionnaireResponse containing all 13 manual answers and clinical history entries recorded during the assessment. |
| [ Example – Fear of Falling  ](Observation-obs-fear-of-falling.md) | Observation capturing the patient's worry about falling (ABC scale) — scores 2 pts. |
| [ Example – Sit to Stand (30 s)  ](Observation-obs-chair-stand.md) | Patient completed 8 repetitions in 30 seconds — scores 1 pt (8–11 band). |
| [ Example – TUG Test  ](Observation-obs-tug-test.md) | Patient completed TUG in 14.2 seconds — scores 2 pts (12–20 s band). |
| [ Example – Walking Ability  ](Observation-obs-walking.md) | Observation capturing the patient's walking ability and use of walking aids — scores 1 pt. |
| [ Falls Risk Assessment Questionnaire  ](Questionnaire-falls-history.md) | Complete questionnaire model for active assessment including terminology mapping to LOINC and SNOMED CT. |

