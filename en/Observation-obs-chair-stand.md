# Example – Sit to Stand (30 s) - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Sit to Stand (30 s)**

## Example Observation: Example – Sit to Stand (30 s)

Profile: [Fall Risk Performance Test Observation](StructureDefinition-fall-risk-performance-observation.md)

**status**: Final

**category**: Exam

**code**: Sit to stand frequency in 30 seconds

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**effective**: 2024-11-15 10:50:00+0100

**performer**: [Practitioner Anna Huber ](Practitioner-example-practitioner.md)

**value**: 8 {count} (Details: UCUM code{count} = '{count}')



## Resource Content

```json
{
  "resourceType" : "Observation",
  "id" : "obs-chair-stand",
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
      "code" : "66247-8",
      "display" : "Sit to stand frequency in 30 seconds"
    }]
  },
  "subject" : {
    "reference" : "Patient/example-patient"
  },
  "effectiveDateTime" : "2024-11-15T10:50:00+01:00",
  "performer" : [{
    "reference" : "Practitioner/example-practitioner"
  }],
  "valueQuantity" : {
    "value" : 8,
    "unit" : "{count}",
    "system" : "http://unitsofmeasure.org",
    "code" : "{count}"
  }
}

```
