# Fall Risk Local Code System - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Local Code System**

## CodeSystem: Fall Risk Local Code System (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes | *Version*:0.1.0 |
| Active as of 2026-06-11 | *Computable Name*:FallRiskLocalCS |

 
Local codes for physical performance tests, aggregate scores, and fall risk factors not available in LOINC or SNOMED CT. 

This Code system is referenced in the definition of the following value sets:

* [FallRiskPerformanceTestsVS](ValueSet-fall-risk-performance-tests-vs.md)
* [FallRiskThresholdVS](ValueSet-fall-risk-threshold-vs.md)

-------

 [Description of the above table(s)](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#terminology). 



## Resource Content

```json
{
  "resourceType" : "CodeSystem",
  "id" : "fall-risk-codes",
  "url" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
  "version" : "0.1.0",
  "name" : "FallRiskLocalCS",
  "title" : "Fall Risk Local Code System",
  "status" : "active",
  "experimental" : true,
  "date" : "2026-06-11T13:45:29+00:00",
  "publisher" : "Fall Risk IG Authors",
  "contact" : [{
    "name" : "Fall Risk IG Authors",
    "telecom" : [{
      "system" : "url",
      "value" : "https://example.org/fall-risk"
    },
    {
      "system" : "email",
      "value" : "info@example.org"
    }]
  }],
  "description" : "Local codes for physical performance tests, aggregate scores, and fall risk factors not available in LOINC or SNOMED CT.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "content" : "complete",
  "count" : 5,
  "concept" : [{
    "code" : "fall-risk-score",
    "display" : "Fall Risk Score",
    "definition" : "Aggregated fall risk score (0–34) computed from all individual Fall Risk Factor Observations."
  },
  {
    "code" : "balance-4stage",
    "display" : "4-Stage Balance Test",
    "definition" : "Highest balance stage achieved (1–4) in the 4-Stage Balance Test."
  },
  {
    "code" : "score-low",
    "display" : "Low fall risk threshold met",
    "definition" : "Total score falls within the Low risk band (0–11)."
  },
  {
    "code" : "score-moderate",
    "display" : "Moderate fall risk threshold met",
    "definition" : "Total score falls within the Moderate risk band (12–22)."
  },
  {
    "code" : "score-high",
    "display" : "High fall risk threshold met",
    "definition" : "Total score falls within the High risk band (23–34)."
  }]
}

```
