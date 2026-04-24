Profile: FallRiskObservation
Parent: Observation
Id: fall-risk-observation

Title: "Fall Risk Observation"
Description: "Assessment of patient fall risk using standardized scoring"

* status = #final
* code = http://loinc.org#71802-3 "Fall risk screening"
* subject 1..1 MS
* effective[x] 1..1 MS
* value[x] 1..1 MS