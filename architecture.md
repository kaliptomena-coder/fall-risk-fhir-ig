# Architecture

This page explains the overall system architecture for the Fall Risk Assessment IG and how different FHIR resources fit together.

---

## System Overview Diagram

The diagram below shows the three-layer architecture: pre-existing EHR data is mined and transformed, active assessment data is collected, and everything flows into a scoring and classification step.

<div class="architecture-container">

<style>
  .architecture-container * { box-sizing: border-box; }
  .arch-wrap { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f9; padding: 20px; border-radius: 12px; font-size: 12px; color: #333; margin: 20px 0; }
  .arch-h2 { font-size: 16px; color: #1a237e; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
  .arch-sub { color: #666; font-size: 11px; margin-bottom: 20px; }
  .arch-grid { display: grid; grid-template-columns: 140px 1fr; gap: 15px; align-items: stretch; }
  .layer-label { background: #f0f2f5; display: flex; align-items: center; justify-content: center; text-align: center; font-weight: 800; font-size: 10px; color: #555; text-transform: uppercase; border-radius: 8px; padding: 10px; border: 1px solid #e0e0e0; }
  .arch-row { display: flex; gap: 12px; flex-wrap: wrap; align-items: stretch; }
  .arch-box { border-radius: 8px; padding: 12px; flex: 1; min-width: 200px; border: 2px solid; position: relative; }
  .arch-box-title { font-weight: 700; font-size: 11px; margin-bottom: 6px; display: block; text-decoration: underline; }
  .item-list { list-style: none; font-size: 10.5px; line-height: 1.7; padding: 0; margin: 0; }
  .item-list li { margin-bottom: 3px; display: flex; justify-content: space-between; flex-wrap: wrap; gap: 4px; }
  .source-tag { font-size: 8px; font-weight: 800; padding: 2px 5px; border-radius: 4px; text-transform: uppercase; white-space: nowrap; }
  .pre-existing { background: #e3f2fd; border-color: #2196f3; color: #0d47a1; }
  .manual { background: #f3e5f5; border-color: #9c27b0; color: #4a148c; }
  .performance { background: #e8f5e9; border-color: #4caf50; color: #1b5e20; }
  .logic { background: #fff3e0; border-color: #ff9800; color: #e65100; }
  .src-auto { background: #bbdefb; color: #1976d2; }
  .src-user { background: #e1bee7; color: #7b1fa2; }
  .arch-connector { grid-column: 1 / -1; display: flex; flex-direction: column; align-items: center; padding: 5px 0; }
  .arch-arrow { width: 2px; height: 20px; background: #ccc; position: relative; }
  .arch-arrow::after { content: ''; position: absolute; bottom: -5px; left: -4px; border-left: 5px solid transparent; border-right: 5px solid transparent; border-top: 6px solid #ccc; }
  .flow-label { font-size: 9px; font-weight: 700; color: #999; margin-top: 4px; }
  .code-pill { font-family: monospace; background: rgba(0,0,0,0.07); padding: 2px 5px; border-radius: 3px; font-size: 9px; display: inline-block; margin: 1px; }
  .mapping-table { margin-top: 20px; border-top: 1px solid #ddd; padding-top: 15px; }
  .vs-table { width: 100%; border-collapse: collapse; font-size: 10px; }
  .vs-table th { text-align: left; padding: 8px; background: #f8f9fa; border-bottom: 2px solid #dee2e6; }
  .vs-table td { padding: 8px; border-bottom: 1px solid #eee; }
  .core-highlight { background: #fff9c4; font-weight: 700; }
</style>

<div class="arch-wrap">
  <div class="arch-grid">

    <div class="layer-label">Pre-existing<br>EHR Data</div>
    <div class="arch-row">
      <div class="arch-box pre-existing">
        <span class="arch-box-title">Clinical Background Mining</span>
        <ul class="item-list">
          <li>3. Meds (Count &amp; High Risk) <span class="source-tag src-auto">MedicationStatement → Observation</span></li>
          <li>4. Comorbidities <span class="source-tag src-auto">Condition → Observation (count)</span></li>
          <li>5. Cognition (MMSE) <span class="source-tag src-auto">Observation.valueInteger</span></li>
          <li>6. Vision &amp; Hearing <span class="source-tag src-auto">Observation.valueCodeableConcept</span></li>
        </ul>
        <p style="font-size:9px;margin-top:8px;opacity:0.8;">* Pre-filled data transformed into standardized Observations via derivedFrom.</p>
      </div>
    </div>

    <div class="arch-connector"><div class="arch-arrow"></div><div class="flow-label">Context Injection</div></div>

    <div class="layer-label">Active<br>Assessment</div>
    <div class="arch-row">
      <div class="arch-box manual">
        <span class="arch-box-title">Manual Factors</span>
        <ul class="item-list">
          <li>1. Falls History <span class="source-tag src-user">QuestionnaireResponse</span></li>
          <li>2. Fear of Falling <span class="source-tag src-user">valueQuantity (%)</span></li>
          <li>7. Alcohol Use <span class="source-tag src-user">valueQuantity (units/wk)</span></li>
          <li>8. Physical Activity <span class="source-tag src-user">valueCodeableConcept</span></li>
          <li>9. ADL Independence <span class="source-tag src-user">valueCodeableConcept</span></li>
          <li>10. Walking Ability <span class="source-tag src-user">valueCodeableConcept</span></li>
        </ul>
      </div>
      <div class="arch-box performance">
        <span class="arch-box-title">Objective Measures</span>
        <ul class="item-list">
          <li>a. 30-sec Chair Stand Test <span class="code-pill">LOINC 82755-5</span> [UCUM: {reps}]</li>
          <li>b. 4-Stage Balance Test <span class="code-pill">LOINC 92631-9</span></li>
          <li>c. TUG Test <span class="code-pill">LOINC 80456-7</span> [UCUM: s]</li>
        </ul>
        <p style="font-size:9px;margin-top:6px;">Stored as <strong>Observation.valueQuantity</strong>. Linked to Score via <em>derivedFrom</em>.</p>
      </div>
    </div>

    <div class="arch-connector"><div class="arch-arrow"></div><div class="flow-label">Scoring Logic</div></div>

    <div class="layer-label">Risk Calculation<br>&amp; Synthesis</div>
    <div class="arch-row">
      <div class="arch-box logic">
        <span class="arch-box-title">FHIR RiskAssessment Logic</span>
        <p style="font-size:10.5px;line-height:1.6;">
          <strong>Step 1 – Factor Normalization:</strong><br>
          <span class="code-pill">QuestionnaireResponse</span> → <span class="code-pill">Observation</span> (derivedFrom)<br>
          All inputs converted to <span class="code-pill">Observation</span> resources.<br><br>
          <strong>Step 2 – Total Score:</strong><br>
          <span class="code-pill">Observation.valueQuantity</span> (0–30) | derivedFrom all factor Observations.<br><br>
          <strong>Step 3 – Risk Classification:</strong><br>
          <span class="code-pill">FallRiskObservation</span> basedOn score | outcome = Low / Moderate / High.<br><br>
          <strong>Step 4 – Problem List:</strong><br>
          <span class="code-pill">Condition</span> "At risk of falls" | evidence.detail → FallRiskObservation.
        </p>
        <div style="margin-top:10px;">
          <span class="code-pill">Observation (Score)</span> → <span class="code-pill">FallRiskObservation.derivedFrom</span> → <span class="code-pill">Condition.evidence</span>
        </div>
        <div style="margin-top:6px;">
          <span class="code-pill">Condition.code</span> ➔ <span class="code-pill">SNOMED 129839007</span>
        </div>
      </div>
    </div>

  </div><!-- /arch-grid -->

  <div class="mapping-table">
    <table class="vs-table">
      <thead>
        <tr>
          <th>Factor</th>
          <th>Sourcing Method</th>
          <th>FHIR Mapping Path</th>
          <th>Standard Code</th>
        </tr>
      </thead>
      <tbody>
        <tr class="core-highlight"><td>1. Falls History</td><td>Manual / Historical</td><td>QuestionnaireResponse → Observation.valueInteger</td><td>SNOMED 428807008</td></tr>
        <tr class="core-highlight"><td>2. Fear of Falling</td><td>Questionnaire</td><td>Observation.valueQuantity (%)</td><td>LOINC 95418-0</td></tr>
        <tr class="core-highlight"><td>3. Medications</td><td>Automated (EHR)</td><td>MedicationStatement → Observation (count)</td><td>ATC / RxNorm</td></tr>
        <tr class="core-highlight"><td>4. Diseases</td><td>Automated (EHR)</td><td>Condition → Observation (count)</td><td>ICD-10 / SNOMED</td></tr>
        <tr class="core-highlight"><td>5. Cognition</td><td>Automated / Manual</td><td>Observation.valueInteger</td><td>LOINC 72107-6</td></tr>
        <tr class="core-highlight"><td>6. Vision &amp; Hearing</td><td>Automated / Manual</td><td>Observation.valueCodeableConcept</td><td>SNOMED 397540003</td></tr>
        <tr><td>7. Alcohol Use</td><td>Manual</td><td>Observation.valueQuantity (units/wk)</td><td>LOINC 74013-4</td></tr>
        <tr><td>8. Physical Activity</td><td>Manual / Sensor</td><td>Observation.valueCodeableConcept</td><td>LOINC 80582-0</td></tr>
        <tr><td>9. ADL Independence</td><td>Manual</td><td>Observation.valueCodeableConcept</td><td>SNOMED 284545001</td></tr>
        <tr><td>10. Walking Ability</td><td>Manual Observation</td><td>Observation.valueCodeableConcept</td><td>SNOMED ValueSet</td></tr>
        <tr><td>a. 30-sec Chair Stand</td><td>Objective Test</td><td>Observation.valueQuantity {repetitions}</td><td>LOINC 82755-5</td></tr>
        <tr><td>b. 4-Stage Balance Test</td><td>Objective Test</td><td>Observation.valueCodeableConcept</td><td>LOINC 92631-9</td></tr>
        <tr><td>c. TUG Test</td><td>Objective Test</td><td>Observation.valueQuantity (s)</td><td>LOINC 80456-7</td></tr>
      </tbody>
    </table>
  </div>
</div><!-- /arch-wrap -->

</div>

---

## Key Design Decisions

### Why Observations for everything?

All 13 risk factors — whether from a questionnaire, an EHR record, or a physical test — are stored as **FHIR Observation** resources. This creates a uniform interface: the scoring algorithm doesn't need to know where data came from. It queries Observations.

### Why derivedFrom?

The `derivedFrom` link creates an auditable chain:

```
QuestionnaireResponse
    └─ derivedFrom ─→ FallRiskFactorObservation ("Fear of falling: 55%")
                          └─ hasMember ─→ FallRiskScoreObservation (18/30)
                                              └─ derivedFrom ─→ FallRiskObservation (Moderate)
                                                                      └─ evidence ─→ Condition ("At risk of fall")
```

If a clinician or auditor asks *"how did we get a Moderate risk classification?"*, they can follow the chain all the way back to every individual data point.

### Why not RiskAssessment resource?

The HL7 FHIR `RiskAssessment` resource is available but has limited tooling support and is less commonly indexed. Using a profiled `Observation` for the final classification is simpler, better supported by most FHIR servers, and still semantically correct. A future version of this IG may add a `RiskAssessment` layer on top.

### Color coding

| Color | Meaning |
|---|---|
| 🔵 Blue | Data sourced automatically from EHR records |
| 🟣 Purple | Data entered manually by clinician or patient |
| 🟢 Green | Objective physical performance test results |
| 🟠 Orange | Scoring and classification logic |
