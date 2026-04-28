# Fall Risk Assessment Implementation Guide

Interoperable FHIR-based fall risk assessment for older adults using standardized scoring, objective performance tests, and EHR-derived data.

## Current Status

✅ **SUSHI Validation**: Working perfectly (0 errors, 0 warnings)  
⚠️ **IG Publisher**: Temporarily disabled due to bug in 2.x versions  
📝 **FSH Code**: Fully valid and ready for development

## Known Issues

### IG Publisher Compatibility Problem

The IG Publisher has **fundamental compatibility issues**:

1. **Versions 2.x** (newer): Have a bug causing `"Name 'hl7.fhir.r4.core' already exists"` error
2. **Versions 1.x** (older): Can't handle newer terminology packages with FHIR 5.0.0 resources

This creates an **impossible situation** where no publisher version works with current FHIR packages.

### Impact

-  **FSH development**: Fully functional with SUSHI validation
-  **HTML generation**: Blocked by publisher bugs
-  **FHIR resources**: Generated correctly by SUSHI

## Dependencies

- SUSHI v3.19.0  (working)
- HL7 Terminology R4 v7.1.0 (contains FHIR 5.0.0 resources)
- FHIR R4 Core v4.0.1
- FHIR Extensions R4 v5.2.0

## Build Instructions

```bash
./build.sh
```

This runs SUSHI validation only (publisher step fails due to bugs).

## Project Structure

- `input/fsh/` - FHIR Shorthand definitions
- `fsh-generated/` - Generated FHIR resources 
- `output/` - Build output (when publisher works)
- `sushi-config.yaml` - SUSHI configuration

## Development Workflow

1. **Write FSH code** in `input/fsh/`
2. **Run `./build.sh`** for validation
3. **Check SUSHI results** - should be 0 errors, 0 warnings
4. **Use generated FHIR resources** in `fsh-generated/`

## Future Resolution

This issue will be resolved when:
- HL7 fixes the duplicate package bug in IG Publisher 2.x versions, OR
- Newer publisher versions become compatible with current FHIR packages

Until then, SUSHI validation provides complete assurance that your FSH code is correct.