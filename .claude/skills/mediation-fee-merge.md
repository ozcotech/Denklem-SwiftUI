# Mediation Fee Button Merge - Implementation Skill

## Overview

This skill documents the merge of two separate mediation fee buttons ("Monetary Dispute" and "Non-Monetary Dispute") into a single unified "Mediation Fee" button on the DisputeCategoryView. A segmented picker was added to MediationFeeView so users can switch between monetary and non-monetary modes within the same screen.

### Core Principles

- **Pattern:** Unified single-button entry point with in-screen segmented picker
- **Calculation:** No changes to calculation logic — same `TariffCalculator.calculateFee()` and `CalculationInput.create()`
- **UI:** Full-width button style (same as Denklem AI button pattern)
- **Navigation:** DisputeCategoryView → MediationFeeView (segmented picker handles mode)

### Architecture

```
DisputeCategoryView
    └── [Arabuluculuk Ücreti] (full-width button)
            └── MediationFeeView
                    ├── Segmented Picker (Monetary / Non-Monetary)
                    ├── Year Picker (2025/2026)
                    ├── Agreement Selector (monetary only)
                    ├── Non-Monetary Info Note (non-monetary only)
                    ├── Dispute Type Dropdown Menu
                    ├── Amount Input (agreement) OR Party Count Input (non-agreement)
                    ├── Calculate Button
                    └── .sheet → MediationFeeResultSheet
```

---

## Modified Files

### 1. DisputeCategoryViewModel.swift
**File:** `Denklem/Denklem/Views/Screens/DisputeCategory/DisputeCategoryViewModel.swift`

- Added `.mediationFee` case to `DisputeCategoryType` enum
  - systemImage: `"plusminus.circle.fill"`
  - iconColor: `.blue`
  - displayName: `LocalizationKeys.DisputeCategory.mediationFee`
  - description: `LocalizationKeys.DisputeCategory.mediationFeeDescription`
- `.monetary` and `.nonMonetary` kept as legacy (used in result sheets)
- `mainCategories` → `[.mediationFee]` (single full-width button)
- `mainCategoriesTitle` → `LocalizationKeys.DisputeCategory.mediationFeeDescription` ("Arabuluculuk Ücreti Hesaplamaları")
- `selectCategory(.mediationFee)` → `navigateToDisputeType = true`

### 2. DisputeSectionCard.swift
**File:** `Denklem/Denklem/Views/Components/Common/DisputeSectionCard.swift`

- Added `fullWidthTypes: Set<DisputeCategoryType>` containing `.aiChat` and `.mediationFee`
- `gridCategories` filters out full-width types
- `fullWidthCategories` returns full-width types for ForEach rendering
- Full-width button style: `minHeight: 56`, icon size 40, `.buttonStyle(.glass(...))`

### 3. MediationFeeView.swift
**File:** `Denklem/Denklem/Views/Screens/MediationFee/MediationFeeView.swift`

- Removed `isMonetary` parameter from `init` — now `init(selectedYear:)`
- Added `monetaryPickerSection` at top of form:
  - Segmented picker with "Parasal Olan" / "Parasal Olmayan" labels
  - Uses `calculation_type.monetary` / `calculation_type.non_monetary` localization keys
  - `.pickerStyle(.segmented)` + `.controlSize(.large)`
  - Calls `viewModel.resetFormForModeChange()` on change
- Added section labels above each form section:
  - "Konu Seçimi" (`screen.title.subject_selection`) above monetary picker
  - "Anlaşma Durumu" (`screen.title.agreement_status`) above agreement picker
  - "Uyuşmazlık Türü" (`screen.title.dispute_type`) above dispute type menu
- Labels styled: `theme.footnote`, `.fontWeight(.medium)`, `theme.textSecondary`

### 4. MediationFeeViewModel.swift
**File:** `Denklem/Denklem/Views/Screens/MediationFee/MediationFeeViewModel.swift`

- `init(selectedYear:, isMonetary: Bool = true)` — defaults to monetary
- Added `resetFormForModeChange()` method:
  - Sets `selectedAgreement` to `.agreed` (monetary) or `nil` (non-monetary)
  - Clears `selectedDisputeType`, `amountText`, `partyCountText`
  - Clears `errorMessage`, `calculationResult`, `showResult`

### 5. DisputeCategoryView.swift
**File:** `Denklem/Denklem/Views/Screens/DisputeCategory/DisputeCategoryView.swift`

- Navigation: `MediationFeeView(selectedYear:)` (removed `isMonetary` parameter)
- Reduced card spacing: `spacingXL` → `spacingM`
- Reduced top padding: `spacingM` → `spacingXS`
- Reduced bottom spacer: `spacingXL` → `spacingM`

### 6. StartScreenView.swift
**File:** `Denklem/Denklem/Views/Screens/StartScreen/StartScreenView.swift`

- Updated `MediationFeeView(selectedYear:)` — removed `isMonetary` parameter

### 7. LocalizationKeys.swift
**File:** `Denklem/Denklem/Localization/LocalizationKeys.swift`

- Added `DisputeCategory.mediationFee` = `"dispute_category.mediation_fee"`
- Added `DisputeCategory.mediationFeeDescription` = `"dispute_category.mediation_fee.description"`
- Added `ScreenTitle.subjectSelection` = `"screen.title.subject_selection"`
- Reused existing keys: `ScreenTitle.agreementStatus`, `ScreenTitle.disputeType`, `CalculationType.monetary`, `CalculationType.nonMonetary`

### 8. Localizable.xcstrings
**File:** `Denklem/Localizable.xcstrings`

New keys added with TR/EN/SV translations:

| Key | Turkish | English | Swedish |
|-----|---------|---------|---------|
| `dispute_category.mediation_fee` | Arabuluculuk Ücreti | Mediation Fee | Medlingsarvode |
| `dispute_category.mediation_fee.description` | Arabuluculuk Ücreti Hesaplamaları | Mediation Fee Calculations | Beräkningar av medlingsarvode |
| `screen.title.subject_selection` | Konu Seçimi | Subject Selection | Ämnesval |

---

## Calculation Logic

**No changes made.** The existing calculation pipeline is fully preserved:

1. `MediationFeeViewModel.calculate()` — parses inputs, creates `CalculationInput`
2. `CalculationInput.create()` — validates and constructs input
3. `TariffCalculator.calculateFee(input:)` — performs bracket/fixed fee calculation
4. `MediationFeeResultSheet` — displays results

The `isMonetary` flag is now toggled via segmented picker instead of being passed from DisputeCategoryView.

---

## UI Patterns Used

- **Full-width button:** Same pattern as Denklem AI (`.aiChat`) in `DisputeSectionCard`
- **Segmented picker:** Standard `Picker` with `.pickerStyle(.segmented)` + `.controlSize(.large)` (same as TenancySelectionView pattern)
- **Section labels:** `theme.footnote`, `.fontWeight(.medium)`, `theme.textSecondary`, left-aligned
- **Form reset on mode change:** Clears all inputs when switching monetary/non-monetary

---

## Critical Points

1. **Legacy enum cases preserved** — `.monetary` and `.nonMonetary` are still in `DisputeCategoryType` because they may be referenced in result sheets and other calculation logic
2. **Default mode is monetary** — When user taps the button, "Parasal Olan" is pre-selected in the segmented picker
3. **Form state resets** on picker change to prevent stale data from previous mode
4. **`isMonetary` is now `@Published`** in the ViewModel, allowing the segmented picker to bind directly
