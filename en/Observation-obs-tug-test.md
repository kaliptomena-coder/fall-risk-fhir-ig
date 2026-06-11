# Example – TUG Test - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – TUG Test**

## Example Observation: Example – TUG Test

Profile: [Fall Risk Performance Test Observation](StructureDefinition-fall-risk-performance-observation.md)

**status**: Final

**category**: Exam

**code**: Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 10:45:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: 14.2 s (Details: UCUM codes = 's')



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-tug-test",
  "meta" : {
    "profile" : ["https://example.org/fhir/fall-risk/StructureDefinition/fall-risk-performance-observation"]
  },
  "status" : "final",
  "category" : [{
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/observation-category",
      "code" : "exam",
      "display" : "Exam"
    }]
  }],
  "code" : {
    "coding" : [{
      "system" : "http://loinc.org",
      "code" : "89423-8",
      "display" : "Time to rise from chair, walk 10 feet and back, and return to sitting [TUG]"
    }]
  },
  "subject" : {
    "reference" : "Patient/example-patient"
  },
  "effectiveDateTime" : "2024-11-15T10:45:00+01:00",
  "performer" : [{
    "reference" : "Practitioner/example-practitioner"
  }],
  "valueQuantity" : {
    "value" : 14.2,
    "unit" : "s",
    "system" : "http://unitsofmeasure.org",
    "code" : "s"
  }
}

```
