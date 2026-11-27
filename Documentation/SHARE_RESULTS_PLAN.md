# Share Button for All Result Screens

> **Branch:** `refactor/2027-prep` · **Requested:** 27 Nov 2026

## Finding

Only two result screens can be shared: Mediation Fee (since Feb 2026) and Consumer Dispute (since May 2026).
Git history shows the other screens **never** had a share button (nothing was deleted by the cleanup).

| Screen | Share before | Where the button goes |
|---|---|---|
| Mediation Fee (`MediationFeeResultSheet`) | ✅ | — (reference) |
| Consumer Dispute (`ConsumerDisputeResultSheet`) | ✅ | — |
| Attorney Fee (`AttorneyFeeResultSheet`) | ❌ | toolbar, leading |
| Tenancy – attorney fee (`TenancyAttorneyFeeResultSheet`) | ❌ | toolbar, leading |
| Tenancy – mediation fee (`TenancyMediationFeeResultSheet`) | ❌ | toolbar, leading |
| Serial Disputes (`SerialDisputesSheet` → `SerialDisputesResultView`) | ❌ | sheet toolbar, leading, only while the result is shown |
| Reinstatement (`ReinstatementSheet` → `ReinstatementResultView`) | ❌ | sheet toolbar, leading, only while the result is shown |

## Design (same as Mediation Fee)

- Toolbar button `square.and.arrow.up`, `theme.body`, `theme.textSecondary`,
  accessibility label/hint `Accessibility.share` / `Accessibility.shareHint`.
- `.sheet { ShareSheet(items: [fileURL]) }` sharing a `.txt` file.
- Text mirrors the screen line by line ("Label: value"), ends with `General.calculatedWithDenklem`.
  Only existing localization keys are used (tr/en/sv already present).
- New shared helper `Utils/ShareTextFile.swift` writes the temp file with an ASCII, date-based name
  (`Denklem_<Screen>_yyyy_MM_dd.txt`, see commit `82e461c` — Unicode names broke sharing). The two
  existing sheets use the same helper (same file names as before).
- Serial / Reinstatement: text is built in an extension of the result model next to its result view,
  so the parent sheet's toolbar can share it.

## Not changed

Calculations, on-screen layout, texts. Unit tests must stay green (23).

## Status

Done (27 Nov 2026): share button on Attorney Fee, Tenancy (attorney + mediation), Serial Disputes and
Reinstatement; Mediation Fee and Consumer Dispute moved to the shared `ShareTextFile` helper (same file
names). `ShareTextTests` added (file name ASCII/date based, serial + reinstatement texts). 26 unit tests +
UI launch test green. Manual check on device pending.
