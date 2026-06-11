# Fall Risk Score Threshold ConceptMap - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Score Threshold ConceptMap**

## ConceptMap: Fall Risk Score Threshold ConceptMap (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ConceptMap/fall-risk-score-threshold-map | *Version*:0.1.0 |
| Active as of 2026-06-11 | *Computable Name*: |

 
Maps local score-band codes (score-low / score-moderate / score-high) to the corresponding SNOMED risk category codes in FallRiskCategoryVS. The numeric cutoffs encoded in the comments and group.element.display fields are the authoritative thresholds for this IG: score-low = total score 0–11 score-moderate = total score 12–22 score-high = total score 23–34 



## Resource Content

```json
{
  "resourceType" : "ConceptMap",
  "id" : "fall-risk-score-threshold-map",
  "url" : "https://example.org/fhir/fall-risk/ConceptMap/fall-risk-score-threshold-map",
  "version" : "0.1.0",
  "title" : "Fall Risk Score Threshold ConceptMap",
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
  "description" : "Maps local score-band codes (score-low / score-moderate / score-high) to the\ncorresponding SNOMED risk category codes in FallRiskCategoryVS.\nThe numeric cutoffs encoded in the comments and group.element.display fields\nare the authoritative thresholds for this IG:\n  score-low      = total score 0–11\n  score-moderate = total score 12–22\n  score-high     = total score 23–34",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "sourceCanonical" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-threshold-vs",
  "targetCanonical" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-category-vs",
  "group" : [{
    "source" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
    "target" : "http://snomed.info/sct",
    "element" : [{
      "code" : "score-low",
      "display" : "Total score 0–11",
      "target" : [{
        "code" : "439430008",
        "display" : "Low risk (qualifier value)",
        "equivalence" : "equivalent"
      }]
    },
    {
      "code" : "score-moderate",
      "display" : "Total score 12–22",
      "target" : [{
        "code" : "332721351000132106",
        "display" : "Moderate risk (qualifier value)",
        "equivalence" : "equivalent"
      }]
    },
    {
      "code" : "score-high",
      "display" : "Total score 23–34",
      "target" : [{
        "code" : "455201601000132100",
        "display" : "High risk (qualifier value)",
        "equivalence" : "equivalent"
      }]
    }]
  }]
}

```
