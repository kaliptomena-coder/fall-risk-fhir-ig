Instance: ExampleFallRiskBundle
InstanceOf: Bundle
Title: "Example – Complete Fall Risk Assessment Bundle"
Description: """
A Bundle containing all FHIR resources for a single fall risk assessment session.
This Bundle can be sent to any FHIR R4 server in one request.
"""
Usage: #example

* id = "fall-risk-bundle-example"
* type = #collection
* timestamp = "2024-11-15T11:00:00+01:00"

// ── Patient ────────────────────────────────────────────────────────
* entry[0].fullUrl = "https://example.org/fhir/Patient/example-patient"
* entry[0].resource = ExamplePatient

// ── Practitioner ───────────────────────────────────────────────────
* entry[1].fullUrl = "https://example.org/fhir/Practitioner/example-practitioner"
* entry[1].resource = ExamplePractitioner

// ── QuestionnaireResponse ──────────────────────────────────────────
* entry[2].fullUrl = "https://example.org/fhir/QuestionnaireResponse/qr-falls-history"
* entry[2].resource = ExampleFallsHistoryQR

// ── Factor Observations ────────────────────────────────────────────
* entry[3].fullUrl = "https://example.org/fhir/Observation/obs-falls-history"
* entry[3].resource = ExampleFallsHistoryObservation

* entry[4].fullUrl = "https://example.org/fhir/Observation/obs-fear-of-falling"
* entry[4].resource = ExampleFearOfFallingObservation

* entry[5].fullUrl = "https://example.org/fhir/Observation/obs-adl"
* entry[5].resource = ExampleADLObservation

* entry[6].fullUrl = "https://example.org/fhir/Observation/obs-walking"
* entry[6].resource = ExampleWalkingAbilityObservation

// ── Performance Observations ───────────────────────────────────────
* entry[7].fullUrl = "https://example.org/fhir/Observation/obs-tug-test"
* entry[7].resource = ExampleTUGObservation

* entry[8].fullUrl = "https://example.org/fhir/Observation/obs-chair-stand"
* entry[8].resource = ExampleChairStandObservation

// ── Score & Classification ─────────────────────────────────────────
* entry[9].fullUrl = "https://example.org/fhir/Observation/obs-fall-risk-score"
* entry[9].resource = ExampleFallRiskScore

* entry[10].fullUrl = "https://example.org/fhir/Observation/obs-fall-risk-result"
* entry[10].resource = ExampleFallRiskAssessment

// ── Condition ──────────────────────────────────────────────────────
* entry[11].fullUrl = "https://example.org/fhir/Condition/condition-fall-risk"
* entry[11].resource = ExampleFallRiskCondition