# Fall Risk Category ValueSet - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Category ValueSet**

## ValueSet: Fall Risk Category ValueSet (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/ValueSet/fall-risk-category-vs | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskCategoryVS |

 
Risk classification outcomes for fall risk assessment using SNOMED qualifier values. 

 **References** 

* [Fall Risk Observation](StructureDefinition-fall-risk-observation.md)

### Logical Definition (CLD)

 

### Expansion

-------

 [Description of the above table(s)](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#terminology). 



## Resource Content

```json
{
  "resourceType" : "ValueSet",
  "id" : "fall-risk-category-vs",
  "url" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-category-vs",
  "version" : "0.1.0",
  "name" : "FallRiskCategoryVS",
  "title" : "Fall Risk Category ValueSet",
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
  "description" : "Risk classification outcomes for fall risk assessment using SNOMED qualifier values.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "compose" : {
    "include" : [{
      "system" : "http://snomed.info/sct",
      "concept" : [{
        "code" : "439430008",
        "display" : "Low risk (qualifier value)"
      },
      {
        "code" : "332721351000132106",
        "display" : "Moderate risk (qualifier value)"
      },
      {
        "code" : "455201601000132100",
        "display" : "High risk (qualifier value)"
      }]
    }]
  }
}

```
