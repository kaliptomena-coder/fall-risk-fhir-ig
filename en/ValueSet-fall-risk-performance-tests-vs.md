# Fall Risk Performance Tests ValueSet - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Performance Tests ValueSet**

## ValueSet: Fall Risk Performance Tests ValueSet (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ValueSet/fall-risk-performance-tests-vs | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskPerformanceTestsVS |

 
Codes for objective physical performance tests used in fall risk assessment (tests a–c). 

 **References** 

* [Fall Risk Performance Test Observation](StructureDefinition-fall-risk-performance-observation.md)

### Logical Definition (CLD)

 

### Expansion

-------

 [Description of the above table(s)](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#terminology). 



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "fall-risk-performance-tests-vs",
  "url" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-performance-tests-vs",
  "version" : "0.1.0",
  "name" : "FallRiskPerformanceTestsVS",
  "title" : "Fall Risk Performance Tests ValueSet",
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
  "description" : "Codes for objective physical performance tests used in fall risk assessment (tests a–c).",
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
        "code" : "89423-8",
        "display" : "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
      },
      {
        "code" : "66247-8",
        "display" : "Sit to stand frequency in 30 seconds"
      }]
    },
    {
      "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "concept" : [{
        "code" : "balance-4stage",
        "display" : "4-Stage Balance Test"
      }]
    }]
  }
}

```
