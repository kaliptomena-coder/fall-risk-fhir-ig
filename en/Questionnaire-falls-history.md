# Falls Risk Assessment Questionnaire - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Falls Risk Assessment Questionnaire**

## Questionnaire: 

| | |
| :--- | :--- |
| *Official URL*:https://example.org/fhir/fall-risk/Questionnaire/falls-history | *Version*:0.1.0 |
| Active as of 2026-06-11 | *Computable Name*: |

*  [Tree view](#tabs-tree) 
*  [Sample Rendering](#tabs-sample) 
*  [Form Logic](#tabs-logic) 

### Test this Questionnaire

### Responses for this Questionnaire

* [A completed QuestionnaireResponse containing all 13 manual answers and clinical history entries recorded during the assessment.](QuestionnaireResponse-qr-falls-history.md)



## Resource Content

```json
{
  "resourceType" : "Questionnaire",
  "id" : "falls-history",
  "url" : "https://example.org/fhir/fall-risk/Questionnaire/falls-history",
  "version" : "0.1.0",
  "status" : "active",
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
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "item" : [{
    "linkId" : "falls-count",
    "code" : [{
      "system" : "http://snomed.info/sct",
      "code" : "428942009",
      "display" : "History of fall (situation)"
    }],
    "text" : "How many times have you fallen in the last 12 months?",
    "type" : "integer"
  },
  {
    "linkId" : "fear-of-falling",
    "code" : [{
      "system" : "http://loinc.org",
      "code" : "97878-3",
      "display" : "Worried about falling"
    }],
    "text" : "Are you worried about falling? (ABC scale)",
    "type" : "choice",
    "answerOption" : [{
      "valueCoding" : {
        "system" : "http://snomed.info/sct",
        "code" : "373066001",
        "display" : "Yes"
      }
    },
    {
      "valueCoding" : {
        "system" : "http://snomed.info/sct",
        "code" : "373067005",
        "display" : "No"
      }
    }]
  },
  {
    "linkId" : "adl-independence",
    "code" : [{
      "system" : "http://snomed.info/sct",
      "code" : "284545001",
      "display" : "Ability to perform activities of everyday life"
    }],
    "text" : "Activities of Daily Living (ADL): functional independence",
    "type" : "choice",
    "answerOption" : [{
      "valueString" : "Fully independent"
    },
    {
      "valueString" : "Slight assistance needed"
    },
    {
      "valueString" : "Moderate assistance needed"
    },
    {
      "valueString" : "Fully dependent"
    }]
  },
  {
    "linkId" : "walking-ability",
    "code" : [{
      "system" : "http://snomed.info/sct",
      "code" : "282097004",
      "display" : "Ability to walk (observable entity)"
    }],
    "text" : "Walking ability and use of walking aids",
    "type" : "choice",
    "answerOption" : [{
      "valueString" : "Independent"
    },
    {
      "valueString" : "With aids"
    }]
  },
  {
    "linkId" : "alcohol-use",
    "code" : [{
      "system" : "http://loinc.org",
      "code" : "74013-4",
      "display" : "Alcoholic drinks per day"
    }],
    "text" : "Alcohol use (units per week)",
    "type" : "quantity"
  },
  {
    "linkId" : "physical-activity",
    "code" : [{
      "system" : "http://loinc.org",
      "code" : "99285-9",
      "display" : "Current activity level"
    }],
    "text" : "Current physical activity level",
    "type" : "choice",
    "answerOption" : [{
      "valueString" : "Very active"
    },
    {
      "valueString" : "Moderately active"
    },
    {
      "valueString" : "Low activity"
    },
    {
      "valueString" : "Very low / sedentary"
    }]
  },
  {
    "linkId" : "tug-score",
    "code" : [{
      "system" : "http://loinc.org",
      "code" : "89423-8",
      "display" : "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
    }],
    "text" : "Timed Up & Go test result (seconds)",
    "type" : "decimal"
  },
  {
    "linkId" : "chair-stand-score",
    "code" : [{
      "system" : "http://loinc.org",
      "code" : "66247-8",
      "display" : "Sit to stand frequency in 30 seconds"
    }],
    "text" : "Sit to stand frequency in 30 seconds (repetitions)",
    "type" : "integer"
  },
  {
    "linkId" : "balance-4stage",
    "code" : [{
      "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "code" : "balance-4stage",
      "display" : "4-Stage Balance Test"
    }],
    "text" : "4-Stage Balance Test result (highest stage reached)",
    "type" : "choice",
    "answerOption" : [{
      "valueInteger" : 1
    },
    {
      "valueInteger" : 2
    },
    {
      "valueInteger" : 3
    },
    {
      "valueInteger" : 4
    }]
  },
  {
    "linkId" : "ehr-fallback-group",
    "text" : "Clinical History Data (EHR-derived)",
    "type" : "group",
    "item" : [{
      "linkId" : "medications",
      "code" : [{
        "system" : "http://loinc.org",
        "code" : "10160-0",
        "display" : "History of Medication use Narrative"
      }],
      "text" : "Total medication count (including FRIDs flag)",
      "type" : "string"
    },
    {
      "linkId" : "comorbidities",
      "code" : [{
        "system" : "http://snomed.info/sct",
        "code" : "446363004",
        "display" : "Adult comorbidity evaluation-27 score"
      }],
      "text" : "Number of active diagnoses (comorbidities)",
      "type" : "integer"
    },
    {
      "linkId" : "cognitive-status",
      "code" : [{
        "system" : "http://loinc.org",
        "code" : "72107-6",
        "display" : "Mini-Mental State Examination [MMSE]"
      }],
      "text" : "MMSE score",
      "type" : "integer"
    },
    {
      "linkId" : "vision-impairment",
      "code" : [{
        "system" : "http://snomed.info/sct",
        "code" : "397540003",
        "display" : "Visual impairment"
      }],
      "text" : "Vision or hearing impairment present?",
      "type" : "boolean"
    }]
  }]
}

```
