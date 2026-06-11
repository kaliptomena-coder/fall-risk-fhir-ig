# Example – Fall Risk Score 20/34) - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Fall Risk Score 20/34)**

## Example Observation: Example – Fall Risk Score 20/34)

Profile: [Fall Risk Score Observation](StructureDefinition-fall-risk-score-observation.md)

**status**: Final

**category**: Survey

**code**: Fall Risk Score

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 11:00:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: 20 {score} (Details: UCUM code{score} = '{score}')

**interpretation**: Moderate fall risk threshold met

**hasMember**: 

* [Observation Worried about falling](Observation-obs-fear-of-falling.md)
* [Observation Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]](Observation-obs-tug-test.md)
* [Observation Sit to stand frequency in 30 seconds](Observation-obs-chair-stand.md)
* [Observation History of fall (situation)](Observation-obs-falls-history.md)
* [Observation Ability to perform activities of everyday life](Observation-obs-adl.md)
* [Observation Ability to walk (observable entity)](Observation-obs-walking.md)



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-fall-risk-score",
  "meta" : {
    "profile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-score-observation"]
  },
  "status" : "final",
  "category" : [{
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/observation-category",
      "code" : "survey",
      "display" : "Survey"
    }]
  }],
  "code" : {
    "coding" : [{
      "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "code" : "fall-risk-score",
      "display" : "Fall Risk Score"
    }]
  },
  "subject" : {
    "reference" : "Patient/example-patient"
  },
  "effectiveDateTime" : "2024-11-15T11:00:00+01:00",
  "performer" : [{
    "reference" : "Practitioner/example-practitioner"
  }],
  "valueQuantity" : {
    "value" : 20,
    "unit" : "{score}",
    "system" : "http://unitsofmeasure.org",
    "code" : "{score}"
  },
  "interpretation" : [{
    "coding" : [{
      "system" : "https://example.org/fhir/fall-risk/CodeSystem/fall-risk-codes",
      "code" : "score-moderate",
      "display" : "Moderate fall risk threshold met"
    }]
  }],
  "hasMember" : [{
    "reference" : "Observation/obs-fear-of-falling"
  },
  {
    "reference" : "Observation/obs-tug-test"
  },
  {
    "reference" : "Observation/obs-chair-stand"
  },
  {
    "reference" : "Observation/obs-falls-history"
  },
  {
    "reference" : "Observation/obs-adl"
  },
  {
    "reference" : "Observation/obs-walking"
  }]
}

```
