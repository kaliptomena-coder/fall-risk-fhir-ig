# Fall Risk Score Observation - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Score Observation**

## Resource Profile: Fall Risk Score Observation 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskScoreObservation |

 
An aggregated fall risk score (0–34) derived from individual Fall Risk Factor Observations and Fall Risk Performance Observations. The 'hasMember' element links to the contributing factors, ensuring full traceability of the clinical evidence. 

**Usages:**

* Refer to this Profile: [Fall Risk Observation](StructureDefinition-fall-risk-observation.md)
* Examples for this Profile: [Observation/obs-fall-risk-score](Observation-obs-fall-risk-score.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/resource/hl7.fhir.uv.fall-risk|current/StructureDefinition/StructureDefinition-fall-risk-score-observation.json)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots, and their representations](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](../StructureDefinition-fall-risk-score-observation.csv), [Excel](../StructureDefinition-fall-risk-score-observation.xlsx), [Schematron](../StructureDefinition-fall-risk-score-observation.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "fall-risk-score-observation",
  "url" : "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation",
  "version" : "0.1.0",
  "name" : "FallRiskScoreObservation",
  "title" : "Fall Risk Score Observation",
  "status" : "draft",
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
  "description" : "An aggregated fall risk score (0–34) derived from individual Fall Risk Factor Observations\nand Fall Risk Performance Observations.\nThe 'hasMember' element links to the contributing factors, ensuring full traceability\nof the clinical evidence.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "fhirVersion" : "4.0.1",
  "mapping" : [{
    "identity" : "workflow",
    "uri" : "http://hl7.org/fhir/workflow",
    "name" : "Workflow Pattern"
  },
  {
    "identity" : "sct-concept",
    "uri" : "http://snomed.info/conceptdomain",
    "name" : "SNOMED CT Concept Domain Binding"
  },
  {
    "identity" : "v2",
    "uri" : "http://hl7.org/v2",
    "name" : "HL7 v2 Mapping"
  },
  {
    "identity" : "rim",
    "uri" : "http://hl7.org/v3",
    "name" : "RIM Mapping"
  },
  {
    "identity" : "w5",
    "uri" : "http://hl7.org/fhir/fivews",
    "name" : "FiveWs Pattern Mapping"
  },
  {
    "identity" : "sct-attr",
    "uri" : "http://snomed.org/attributebinding",
    "name" : "SNOMED CT Attribute Binding"
  }],
  "kind" : "resource",
  "abstract" : false,
  "type" : "Observation",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Observation",
  "derivation" : "constraint",
  "differential" : {
    "element" : [{
      "id" : "Observation",
      "path" : "Observation"
    },
    {
      "id" : "Observation.identifier",
      "path" : "Observation.identifier",
      "mustSupport" : true
    },
    {
      "id" : "Observation.identifier.system",
      "path" : "Observation.identifier.system",
      "min" : 1
    },
    {
      "id" : "Observation.identifier.value",
      "path" : "Observation.identifier.value",
      "min" : 1
    },
    {
      "id" : "Observation.status",
      "path" : "Observation.status",
      "patternCode" : "final",
      "mustSupport" : true
    },
    {
      "id" : "Observation.category",
      "path" : "Observation.category",
      "min" : 1,
      "patternCodeableConcept" : {
        "coding" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/observation-category",
          "code" : "survey",
          "display" : "Survey"
        }]
      },
      "mustSupport" : true
    },
    {
      "id" : "Observation.code",
      "path" : "Observation.code",
      "patternCodeableConcept" : {
        "coding" : [{
          "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
          "code" : "fall-risk-score",
          "display" : "Fall Risk Score"
        }]
      },
      "mustSupport" : true
    },
    {
      "id" : "Observation.subject",
      "path" : "Observation.subject",
      "min" : 1,
      "type" : [{
        "code" : "Reference",
        "targetProfile" : ["http://hl7.org/fhir/StructureDefinition/Patient"]
      }],
      "mustSupport" : true
    },
    {
      "id" : "Observation.encounter",
      "path" : "Observation.encounter",
      "mustSupport" : true
    },
    {
      "id" : "Observation.effective[x]",
      "path" : "Observation.effective[x]",
      "min" : 1,
      "type" : [{
        "code" : "dateTime"
      }],
      "mustSupport" : true
    },
    {
      "id" : "Observation.issued",
      "path" : "Observation.issued",
      "mustSupport" : true
    },
    {
      "id" : "Observation.performer",
      "path" : "Observation.performer",
      "min" : 1,
      "mustSupport" : true
    },
    {
      "id" : "Observation.value[x]",
      "path" : "Observation.value[x]",
      "min" : 1,
      "type" : [{
        "code" : "Quantity"
      }],
      "mustSupport" : true
    },
    {
      "id" : "Observation.value[x].unit",
      "path" : "Observation.value[x].unit",
      "patternString" : "{score}"
    },
    {
      "id" : "Observation.value[x].system",
      "path" : "Observation.value[x].system",
      "patternUri" : "http://unitsofmeasure.org"
    },
    {
      "id" : "Observation.value[x].code",
      "path" : "Observation.value[x].code",
      "patternCode" : "{score}"
    },
    {
      "id" : "Observation.interpretation",
      "path" : "Observation.interpretation",
      "max" : "1",
      "mustSupport" : true,
      "binding" : {
        "strength" : "required",
        "valueSet" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-threshold-vs"
      }
    },
    {
      "id" : "Observation.device",
      "path" : "Observation.device",
      "type" : [{
        "code" : "Reference",
        "targetProfile" : ["http://hl7.org/fhir/StructureDefinition/Device"]
      }],
      "mustSupport" : true
    },
    {
      "id" : "Observation.hasMember",
      "path" : "Observation.hasMember",
      "type" : [{
        "code" : "Reference",
        "targetProfile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation",
        "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"]
      }],
      "mustSupport" : true
    }]
  }
}

```
