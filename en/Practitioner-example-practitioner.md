# Example Practitioner - Fall Risk Assessment Implementation Guide v0.1.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **Example Practitioner**

## Example Practitioner: Example Practitioner

**name**: Anna Huber 

### Qualifications

| | |
| :--- | :--- |
| - | **Code** |
| * | Physiotherapist (occupation) |



## Resource Content

```json
{
  "resourceType" : "Practitioner",
  "id" : "example-practitioner",
  "name" : [{
    "family" : "Huber",
    "given" : ["Anna"]
  }],
  "qualification" : [{
    "code" : {
      "coding" : [{
        "system" : "http://snomed.info/sct",
        "code" : "36682004",
        "display" : "Physiotherapist (occupation)"
      }]
    }
  }]
}

```
