# Fall Risk Observation - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Fall Risk Observation**

## Resource Profile: Fall Risk Observation 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation | *Version*:0.1.0 |
| Draft as of 2026-06-11 | *Computable Name*:FallRiskObservation |

 
The outcome of a fall risk screening episode, capturing the overall risk classification (Low / Moderate / High) and referencing the aggregated score Observation. 

**Usages:**

* Examples for this Profile: [Observation/obs-fall-risk-result](Observation-obs-fall-risk-result.md)

You can also check for [usages in the FHIR IG Statistics](https://packages2.fhir.org/xig/resource/hl7.fhir.uv.fall-risk|current/StructureDefinition/StructureDefinition-fall-risk-observation.json)

### Formal Views of Profile Content

 [Description of Profiles, Differentials, Snapshots, and their representations](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

 

Other representations of profile: [CSV](../StructureDefinition-fall-risk-observation.csv), [Excel](../StructureDefinition-fall-risk-observation.xlsx), [Schematron](../StructureDefinition-fall-risk-observation.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "fall-risk-observation",
  "url" : "https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation",
  "version" : "0.1.0",
  "name" : "FallRiskObservation",
  "title" : "Fall Risk Observation",
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
  "description" : "The outcome of a fall risk screening episode, capturing the overall risk classification\n(Low / Moderate / High) and referencing the aggregated score Observation.",
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
      "id" : "Observation.code",
      "path" : "Observation.code",
      "patternCodeableConcept" : {
        "coding" : [{
          "system" : "http://snomed.info/sct",
          "code" : "129839007",
          "display" : "At risk for falls"
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
        "code" : "CodeableConcept"
      }],
      "mustSupport" : true,
      "binding" : {
        "strength" : "required",
        "valueSet" : "https://example.org/fhir/fall-risk/ValueSet/fall-risk-category-vs"
      }
    },
    {
      "id" : "Observation.derivedFrom",
      "path" : "Observation.derivedFrom",
      "min" : 1,
      "type" : [{
        "code" : "Reference",
        "targetProfile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"]
      }],
      "mustSupport" : true
    }]
  }
}

```
