# Code Cleanup & 2027 Mediation Tariff Preparation

> **Branch:** `refactor/2027-prep` (created 25 Nov 2026 from `master` @ `7c69063`)
> **Merge:** deferred — possibly together with the 2027 mediation tariff (expected late Dec 2026, effective 1 Jan 2027)
> **Rule:** no visible change — every 2025/2026 calculation must produce exactly the same result.

## Why

The app is live on the App Store. When the 2027 mediation tariff is published, adding it must be
a "fill in the numbers, build, test" job. Today that is risky:

| Risk | Where |
|------|-------|
| `[2025, 2026]` repeated in 6 files; 4 different "current year" definitions | TariffConstants, ValidationConstants, ReinstatementConstants, SerialDisputesConstants, TenancyCalculationConstants, AppConstants |
| `TariffConstants.currentYear = 2026` is hard-coded → after 1 Jan 2027 the app would still call 2026 "active" | TariffConstants |
| Unknown year silently falls back to 2026 values (no error) | SerialDisputesTariff, SerialDisputesConstants, TenancyCalculationConstants.MediationMinimumFee, AboutData |
| Serial dispute fees live outside the tariff files | SerialDisputesConstants.Fees2025/Fees2026 |
| Tenancy minimum fee duplicates `minimumFees["general"]` of the tariff files | TenancyCalculationConstants.MediationMinimumFee |
| No automated tests for any mediation calculation (only 1 SMM test) | DenklemTests |
| ~145 unused declarations in Constants/Models | see step 4 |

## Things that must NOT change

- `TariffConstants` also holds **live** values: `kdvRate`, `stopajRate` (SMM) and
  `timeCalculationDisputeTypes` (time calculation weeks). Only unreferenced declarations are removed.
- Views, localization (`Localizable.xcstrings`, `LocalizationKeys`), attorney fee year logic (`AttorneyFeeTariffYear`).
- `#if DEBUG` sample/verification helpers stay (they document expected values).
- The user's uncommitted `MARKETING_VERSION` change in `project.pbxproj` is never committed on this branch.

## Steps (stop for review after each)

### Step 0 – Lock current results with unit tests
`DenklemTests/CalculationLockTests.swift`: expected values are derived from the official tariff tables
(Documentation/2025_*, 2026_*), not copied from code output.

| Area | Locked |
|------|--------|
| Tariff data | hourly rate + 4 party tiers + non-agreement fee for all 10 dispute types, both years; minimum fees; brackets |
| Mediation fee (`TariffCalculator`) | agreement (bracket vs minimum), non-agreement, non-monetary |
| Tenancy | mediation (½ rent, difference, sum, Art. 7/7 minimum) + attorney |
| Reinstatement | agreement + non-agreement |
| Serial disputes | commercial / non-commercial per file |
| Consumer | total fee + state payment (2 × hourly rate) |
| Attorney fee | 2025 / 2026 / 2027 key values |
| SMM / Time | tax rates and week counts (live values in TariffConstants) |
| Years | available years, factory support, `TariffYear.current` behaviour |

Run: `xcodebuild test -scheme Denklem -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4'`

### Step 1 – Single source of truth for mediation tariff years
`TariffYear.allCases` becomes the only list; all other lists/`isValidYear` derive from it.
`TariffConstants.currentYear` derives from `TariffYear.current` (date based; today still 2026).

### Step 2 – Remove silent fallbacks
Year-dependent switches move from `Int` to `TariffYear` (exhaustive → compiler lists every place when
`.year2027` is added). Dictionary look-ups in `TariffProtocol` keep their runtime behaviour but get a
DEBUG-only assertion when a key is missing.

### Step 3 – Move fees into the tariff files
- Serial dispute fee per file → `TariffProtocol` requirement, implemented in `Tariff2025` / `Tariff2026`.
- Tenancy minimum → use `tariff.getMinimumFee(for: rent)`; delete the duplicate.

### Step 4 – Delete unused code in Constants/Models
Iterative: delete only declarations with zero references, rebuild, re-run tests, repeat.

## Status

| Step | Status |
|------|--------|
| 0 | done (25 Nov 2026) — 17 lock tests + 3 existing tests green; mutation check: 5 deliberate 1-TL errors → 6 failing tests, all caught |
| 1 | done (25 Nov 2026) — `TariffYear` is the only year list; `TariffConstants.currentYear` follows `TariffYear.current`; 5 duplicated lists + 8 unused year constants removed; start screen no longer reads the saved year (`lastUsedTariffYear`), test added first (red → green); 21 tests green |
| 2+3 | done (25 Nov 2026, merged) — `TariffYear.getTariffProtocol()` is the only year → tariff mapping (exhaustive switch, no 2025 fallback); `TariffCalculator` uses it; serial fees are `TariffProtocol` requirements in Tariff2025/2026; tenancy minimum = tariff general minimum; completeness test added; 22 tests green. Probe: adding `case year2027` gives exactly 5 compile errors, all in TariffYear.swift |
| 4 | done (25 Nov 2026) — 155 unused declarations removed from Constants/Models in 3 passes (19 files, 1,235 lines deleted, 0 added); exact ranges from `swiftc -dump-parse`, locals and `#if DEBUG` untouched; empty sections/blocks tidied; 22 tests green. 2027 probe now: 4 compile errors |

## Checklist when the 2027 mediation tariff is published

1. `Documentation/2027_ARABULUCULUK_UCRET_TARIFESI.md` from the Official Gazette PDF.
2. `Models/Data/Tariff2027.swift` (copy of Tariff2026): hourly rates, party tiers, minimum fees (Art. 7/6, 7/7),
   serial fees (Art. 7/4), cumulative brackets. Missing protocol fields do not compile.
3. `TariffYear`: add `case year2027 = 2027` → fix the 4 compile errors (name, description, finalized,
   tariff file).
4. Localization: `tariff_year.2027.description` (en/sv/tr).
5. `CalculationLockTests`: add 2027 tables/boundaries from the official PDF, update `testTariffYears_supportedYears`.
6. Legislation viewer: `TariffDocumentContent.content2027` + `LegislationViewModel` entry.
7. Run tests; default year switches to 2027 automatically on 1 Jan 2027.

### Issue found and fixed in step 0 (pre-existing since 14 Jan 2026)

The project was created on 15 Jul 2025 with Xcode's default deployment target iOS 18.5 for every target.
Commit `cad0548` (14 Jan 2026) raised only the **app** target to iOS 26.0; `DenklemTests` stayed at 18.5,
so the test target could not import the app module and ⌘U failed to compile (the old SMM test included).
Fix: `DenklemTests` Debug/Release `IPHONEOS_DEPLOYMENT_TARGET` 18.5 → 26.0 (same minimum as the app).
App target, project-level setting and UI test target unchanged. Tests now run from Xcode (⌘U) or:

```bash
xcodebuild test -scheme Denklem \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -only-testing:DenklemTests
```
