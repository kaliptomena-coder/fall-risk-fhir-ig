# Example – Condition: At Risk of Falls - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example – Condition: At Risk of Falls**

## Example Condition: Example – Condition: At Risk of Falls

**clinicalStatus**: Active

**verificationStatus**: Confirmed

**category**: Problem List Item

**code**: At risk for falls

**subject**: [Maria Mueller Female, DoB: 1946-03-12](Patient-example-patient.md)

**onset**: 2024-11-15

### Evidences

| | |
| :--- | :--- |
| - | **Detail** |
| * | [Observation At risk for falls](Observation-obs-fall-risk-result.md) |



## Resource Content

```json
{
  "resourceType" : "Condition",
  "id" : "condition-fall-risk",
  "clinicalStatus" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/condition-clinical",
      "code" : "active"
    }]
  },
  "verificationStatus" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/condition-ver-status",
      "code" : "confirmed"
    }]
  },
  "category" : [{
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/condition-category",
      "code" : "problem-list-item"
    }]
  }],
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
  "onsetDateTime" : "2024-11-15",
  "evidence" : [{
    "detail" : [{
      "reference" : "Observation/obs-fall-risk-result"
    }]
  }]
}

```
