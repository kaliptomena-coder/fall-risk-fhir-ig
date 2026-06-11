# Fall Risk Score Threshold ValueSet - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Score Threshold ValueSet**

## ValueSet: Fall Risk Score Threshold ValueSet (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ValueSet/fall-risk-threshold-vs | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskThresholdVS |

 
Local codes that identify which score band (Low / Moderate / High) a computed FallRiskScore falls into. Used in FallRiskObservation.note or as an interpretation code alongside valueQuantity in FallRiskScoreObservation. 

 **References** 

* [Fall Risk Score Observation](StructureDefinition-fall-risk-score-observation.md)

### Logical Definition (CLD)

 

### Expansion

-------

 [Description of the above table(s)](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#terminology). 



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "fall-risk-threshold-vs",
  "url" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-threshold-vs",
  "version" : "0.1.0",
  "name" : "FallRiskThresholdVS",
  "title" : "Fall Risk Score Threshold ValueSet",
  "status" : "draft",
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
  "description" : "Local codes that identify which score band (Low / Moderate / High) a computed\nFallRiskScore falls into. Used in FallRiskObservation.note or as an\ninterpretation code alongside valueQuantity in FallRiskScoreObservation.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "compose" : {
    "include" : [{
      "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "concept" : [{
        "code" : "score-low",
        "display" : "Low fall risk threshold met"
      },
      {
        "code" : "score-moderate",
        "display" : "Moderate fall risk threshold met"
      },
      {
        "code" : "score-high",
        "display" : "High fall risk threshold met"
      }]
    }]
  }
}

```
