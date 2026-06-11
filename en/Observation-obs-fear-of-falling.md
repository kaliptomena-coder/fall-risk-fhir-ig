# Example – Fear of Falling - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Fear of Falling**

## Example Observation: Example – Fear of Falling

Profile: [Fall Risk Factor Observation](StructureDefinition-fall-risk-factor-observation.md)

**status**: Final

**category**: Survey

**code**: Worried about falling

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 10:30:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: Yes (qualifier value)



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-fear-of-falling",
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
      "system" : "http://loinc.org",
      "code" : "97878-3",
      "display" : "Worried about falling"
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
    "coding" : [{
      "system" : "http://snomed.info/sct",
      "code" : "373066001",
      "display" : "Yes (qualifier value)"
    }]
  }
}

```
