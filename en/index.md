# Home - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* **Home**

## Home

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ImplementationGuide/hl7.fhir.uv.fall-risk | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskAssessmentIG |

# Fall Risk Assessment Implementation Guide

## Overview & Clinical Intent

Falls are a leading cause of injury and loss of independence among older adults. This Implementation Guide (IG) establishes a standardized digital framework for capturing, tracking, and scoring clinical fall risks.

By unifying subjective patient history, automated Electronic Health Record (EHR) data elements, and objective physical performance tests into a structured FHIR model, this specification enables predictable and deterministic clinical risk stratification.

-------

## Data Flow Architecture

This IG is designed around a clear, hierarchical data lifecycle that transforms raw patient inputs into actionable clinical diagnoses:

1. **Data Capture (`QuestionnaireResponse`)**: The clinician or patient completes a 13-factor assessment tracking falls history, medication use, and active comorbidities.
1. **Granular Extraction (`Observation`)**: Data points are broken out into individual`FallRiskFactorObservation`(for historical data) and`FallRiskPerformanceObservation`instances (for timed physical tests like TUG).
1. **Evidence Aggregation (`FallRiskScoreObservation`)**: A computation engine aggregates the scores from the individual observations into a single total numeric score ranging from**0 to 34**.
1. **Clinical Stratification (`ConceptMap` & `Condition`)**: A standardized`ConceptMap`translates the numeric score into a risk category (Low, Moderate, High) output via a final`FallRiskObservation`, which links directly to an active`Condition`on the patient's problem list.

-------

## Key Artifacts

Implementers should focus on the following primary profiles and terminologies defined in this guide:

### Core Profiles

* **[FallRiskFactorObservation](StructureDefinition-fall-risk-factor-observation.md)**: Tracks single clinical factors (e.g., fear of falling, visual impairment).
* **[FallRiskPerformanceObservation](StructureDefinition-fall-risk-performance-observation.md)**: Captures objective physical tests (e.g., Timed Up & Go, 30-Second Chair Stand).
* **[FallRiskScoreObservation](StructureDefinition-fall-risk-score-observation.md)**: Holds the accumulated score and references all contributing observations using `hasMember`.
* **[FallRiskObservation](StructureDefinition-fall-risk-observation.md)**: The definitive screening assertion detailing final clinical risk categorization.

### Deterministic Mapping

* **[FallRiskScoreThresholdMap](ConceptMap-fall-risk-score-threshold-map.md)**: Maps numeric ranges directly to SNOMED CT qualifier values.

| | | |
| :--- | :--- | :--- |
| **0–11** | Low Risk | `439430008` |
| **12–22** | Moderate Risk | `332721351000132106` |
| **23–34** | High Risk | `455201601000132100` |

-------

This publication includes IP covered under the following statements.

* This material contains content from [LOINC](http://loinc.org). LOINC is copyright © 1995-2020, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the [license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc.

* [LOINC](http://tx.fhir.org/r4/ValueSet/x-loinc2.82): [Bundle/fall-risk-bundle-example](Bundle-fall-risk-bundle-example.md), [FallRiskFactorObservation](StructureDefinition-fall-risk-factor-observation.md)... Show 7 more, [FallRiskFactorsVS](ValueSet-fall-risk-factors-vs.md), [FallRiskPerformanceObservation](StructureDefinition-fall-risk-performance-observation.md), [FallRiskPerformanceTestsVS](ValueSet-fall-risk-performance-tests-vs.md), [Observation/obs-chair-stand](Observation-obs-chair-stand.md), [Observation/obs-fear-of-falling](Observation-obs-fear-of-falling.md), [Observation/obs-tug-test](Observation-obs-tug-test.md) and [Questionnaire/falls-history](Questionnaire-falls-history.md)


* This material contains content that is copyright of SNOMED International. Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact [https://www.snomed.org/get-snomed](https://www.snomed.org/get-snomed) or [info@snomed.org](mailto:info@snomed.org).

* [SNOMED Clinical Terms&reg; (SNOMED CT&reg;)](http://hl7.org/fhir/R4/codesystem-snomedct.html): [Bundle/fall-risk-bundle-example](Bundle-fall-risk-bundle-example.md), [Condition/condition-fall-risk](Condition-condition-fall-risk.md)... Show 12 more, [FallRiskCategoryVS](ValueSet-fall-risk-category-vs.md), [FallRiskFactorObservation](StructureDefinition-fall-risk-factor-observation.md), [FallRiskFactorsVS](ValueSet-fall-risk-factors-vs.md), [FallRiskObservation](StructureDefinition-fall-risk-observation.md), [Observation/obs-adl](Observation-obs-adl.md), [Observation/obs-fall-risk-result](Observation-obs-fall-risk-result.md), [Observation/obs-falls-history](Observation-obs-falls-history.md), [Observation/obs-fear-of-falling](Observation-obs-fear-of-falling.md), [Observation/obs-walking](Observation-obs-walking.md), [Practitioner/example-practitioner](Practitioner-example-practitioner.md), [Questionnaire/falls-history](Questionnaire-falls-history.md) and [QuestionnaireResponse/qr-falls-history](QuestionnaireResponse-qr-falls-history.md)


This is an R4 IG. None of the features it uses are changed in R4B, so it can be used as is with R4B systems. Packages for both [R4 (hl7.fhir.uv.fall-risk.r4)](../package.r4.tgz) and [R4B (hl7.fhir.uv.fall-risk.r4b)](../package.r4b.tgz) are available.



*There are no Global profiles defined*

