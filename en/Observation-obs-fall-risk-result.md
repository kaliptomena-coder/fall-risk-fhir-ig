# Example – Fall Risk Screening Result - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Fall Risk Screening Result**

## Example Observation: Example – Fall Risk Screening Result

Profile: [Fall Risk Observation](StructureDefinition-fall-risk-observation.md)

**status**: Final

**code**: At risk for falls

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 11:00:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: At moderate risk for fall (finding)

**derivedFrom**: [Observation Fall Risk Score](Observation-obs-fall-risk-score.md)



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-fall-risk-result",
  "meta" : {
    "profile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-observation"]
  },
  "status" : "final",
  "code" : {
    "coding" : [{
      "system" : "http://snomed.info/sct",
      "code" : "129839007",
      "display" : "At risk for falls"
    }]
  },
  "subject" : {
    "reference" : "Patient/example-patient"
  },
  "effectiveDateTime" : "2024-11-15T11:00:00+01:00",
  "performer" : [{
    "reference" : "Practitioner/example-practitioner"
  }],
  "valueCodeableConcept" : {
    "coding" : [{
      "system" : "http://snomed.info/sct",
      "code" : "332721351000132106",
      "display" : "At moderate risk for fall (finding)"
    }]
  },
  "derivedFrom" : [{
    "reference" : "Observation/obs-fall-risk-score"
  }]
}

```
