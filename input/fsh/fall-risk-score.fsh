Profile: FallRiskScoreObservation
Parent: Observation
Id: fall-risk-score-observation

Title: "Fall Risk Score Observation"
Description: "Aggregated fall risk score derived from multiple clinical factors"

* status = #final
* code = http://loinc.org#75218-8 "Fall risk total score"
* subject 1..1 MS
* effective[x] 1..1 MS
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.unit = "score"