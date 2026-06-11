# Fall Risk Factors ValueSet - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Factors ValueSet**

## ValueSet: Fall Risk Factors ValueSet (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ValueSet/fall-risk-factors-vs | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskFactorsVS |

 
Standardized LOINC and SNOMED codes for fall risk assessment inputs (factors 1–10). 

 **References** 

* [Fall Risk Factor Observation](StructureDefinition-fall-risk-factor-observation.md)

### Logical Definition (CLD)

 

### Expansion

-------

 [Description of the above table(s)](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#terminology). 



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "fall-risk-factors-vs",
  "url" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-factors-vs",
  "version" : "0.1.0",
  "name" : "FallRiskFactorsVS",
  "title" : "Fall Risk Factors ValueSet",
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
  "description" : "Standardized LOINC and SNOMED codes for fall risk assessment inputs (factors 1–10).",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "compose" : {
    "include" : [{
      "system" : "http://loinc.org",
      "concept" : [{
        "code" : "97878-3",
        "display" : "Worried about falling"
      },
      {
        "code" : "72107-6",
        "display" : "Mini-Mental State Examination [MMSE]"
      },
      {
        "code" : "74013-4",
        "display" : "Alcoholic drinks per day"
      },
      {
        "code" : "10160-0",
        "display" : "History of Medication use Narrative"
      },
      {
        "code" : "99285-9",
        "display" : "Current activity level"
      }]
    },
    {
      "system" : "http://snomed.info/sct",
      "concept" : [{
        "code" : "428942009",
        "display" : "History of fall (situation)"
      },
      {
        "code" : "397540003",
        "display" : "Visual impairment"
      },
      {
        "code" : "284545001",
        "display" : "Ability to perform activities of everyday life (observable entity)"
      },
      {
        "code" : "446363004",
        "display" : "Adult comorbidity evaluation-27 score"
      },
      {
        "code" : "282097004",
        "display" : "Ability to walk (observable entity)"
      }]
    }]
  }
}

```
