# Example – Walking Ability - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Walking Ability**

## Example Observation: Example – Walking Ability

Profile: [Fall Risk Factor Observation](StructureDefinition-fall-risk-factor-observation.md)

**status**: Final

**category**: Survey

**code**: Ability to walk (observable entity)

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 10:30:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: WITH_AID

**derivedFrom**: [Response to Questionnaire '->Questionnaire[https://example.org/fhir/fall-risk/Questionnaire/falls-history|0.1.0]' about '->Maria Mueller Female, DoB: 1946-03-12'](QuestionnaireResponse-qr-falls-history.md)



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-walking",
  "meta" : {
    "profile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-factor-observation"]
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
      "system" : "http://snomed.info/sct",
      "code" : "282097004",
      "display" : "Ability to walk (observable entity)"
    }]
  },
  "subject" : {
    "reference" : "Patient/example-patient"
  },
  "effectiveDateTime" : "2024-11-15T10:30:00+01:00",
  "performer" : [{
    "reference" : "Practitioner/example-practitioner"
  }],
  "valueCodeableConcept" : {
    "text" : "WITH_AID"
  },
  "derivedFrom" : [{
    "reference" : "QuestionnaireResponse/qr-falls-history"
  }]
}

```
