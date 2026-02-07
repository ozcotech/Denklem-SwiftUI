# Tenancy (Kira Tahliye/Tespit) Calculation - Implementation Skill

## Overview

This skill contains the implementation of **tenancy (eviction/determination)** fee calculation feature. Tenancy is a special type of dispute where:
- **Eviction (Tahliye):** Cases related to tenant eviction
- **Determination (Kira Tespiti):** Cases related to court-determined rent amount

This feature has **two calculation modes:**
1. **Attorney Fee** (Avukatlık Ücreti) - Article 9/1
2. **Mediation Fee** (Arabuluculuk Ücreti) - Article 7/5

### Core Principles

- **Pattern:** NavigationStack push approach (AttorneyFee pattern)
- **Calculation:** Uses existing `AttorneyFeeConstants` brackets for attorney fee, `TariffProtocol.calculateBracketFee()` for mediation fee
- **Tariff Years:** 2025 and 2026
- **Selection:** Checkbox multi-select (Eviction and/or Determination)

### Architecture Approach

```
DisputeCategoryView
    └── [Tenancy Button] (NavigationStack push)
            └── TenancySelectionView (choose mode)
                    ├── Attorney Fee → TenancyAttorneyFeeView → ResultSheet
                    └── Mediation Fee → TenancyMediationFeeView → ResultSheet
```

---

## Calculation Logic

### 1. Attorney Fee (Article 9/1)

**Uses Third Part brackets from `AttorneyFeeConstants.MonetaryBrackets2025/2026`**

**Inputs:**
- Checkbox selection: Eviction and/or Determination
- Eviction: 1-year rent amount (if selected)
- Determination: 1-year rent difference (if selected)

**Formula:**
```swift
// If both selected: SUM amounts, calculate ONCE
var totalAmount: Double = 0
if evictionSelected { totalAmount += evictionAmount }
if determinationSelected { totalAmount += determinationAmount }

let brackets = year == 2025
    ? AttorneyFeeConstants.MonetaryBrackets2025.brackets
    : AttorneyFeeConstants.MonetaryBrackets2026.brackets

var remaining = totalAmount
var fee: Double = 0
for bracket in brackets {
    let take = min(remaining, bracket.limit)
    fee += take * bracket.rate
    remaining -= take
    if remaining <= 0 { break }
}
```

**2026 Brackets (Third Part):**
- First 600,000 TL: 16%
- Next 600,000 TL: 15%
- Next 1,200,000 TL: 14%
- Next 1,200,000 TL: 13%
- Next 1,800,000 TL: 11%
- Next 2,400,000 TL: 8%
- Next 3,000,000 TL: 5%
- Next 3,600,000 TL: 3%
- Next 4,200,000 TL: 2%
- Over 18,600,000 TL: 1%

**2025 Brackets (Third Part):**
- First 400,000 TL: 16%
- Next 400,000 TL: 15%
- Next 800,000 TL: 14%
- Next 1,200,000 TL: 11%
- Next 1,600,000 TL: 8%
- Next 2,000,000 TL: 5%
- Next 2,400,000 TL: 3%
- Next 2,800,000 TL: 2%
- Over 11,600,000 TL: 1%

**Court Minimum (Art. 9 last sentence - enforced for Sulh Hukuk):**
- Tenancy cases are typically heard in Sulh Hukuk Mahkemesi
- If calculated fee < Sulh Hukuk minimum → apply minimum
- 2026: 30,000 TL | 2025: 18,000 TL

**Court Minimum Warnings (informational for all courts):**

| Court | 2026 | 2025 |
|-------|------|------|
| Sulh Hukuk Mahkemesi | 30,000 TL | 18,000 TL |
| Asliye Mahkemesi | 45,000 TL | 30,000 TL |
| İcra Mahkemesi | 18,000 TL | 12,000 TL |

### 2. Mediation Fee (Article 7/5)

**Uses Second Part brackets from `TariffProtocol.calculateBracketFee()`**

**Inputs:**
- Checkbox selection: Eviction and/or Determination
- Eviction: 1-year rent amount (app takes HALF for calculation)
- Determination: 1-year rent difference (FULL amount used)

**Formula:**
```swift
let tariff = tariffYear.getTariffProtocol()

// Eviction: HALF of 1-year rent
if evictionSelected {
    let evictionBase = evictionAmount / 2.0
    evictionFee = tariff.calculateBracketFee(for: evictionBase)
}

// Determination: FULL 1-year rent difference
if determinationSelected {
    determinationFee = tariff.calculateBracketFee(for: determinationAmount)
}

// If both: calculate SEPARATELY, then sum
totalFee = (evictionFee ?? 0) + (determinationFee ?? 0)
```

**Mediation Minimum Fee (Art. 7/7):**
- If agreement is reached, mediation fee cannot be less than minimum
- 2026: 9,000 TL | 2025: 6,000 TL
- Applied to totalFee after calculation

**CRITICAL DIFFERENCE:**
- Attorney fee: SUM first, then ONE calculation, enforce Sulh Hukuk minimum
- Mediation fee: Calculate EACH separately, then SUM results, enforce Art. 7/7 minimum

---

## File Structure

All paths relative to `Denklem/Denklem/`:

### New Files (11 files)

| # | File Path | Purpose |
|---|-----------|---------|
| 1 | `Constants/TenancyCalculationConstants.swift` | Court minimums, enums, validation |
| 2 | `Models/Domain/TenancyCalculationResult.swift` | Input, Result, Breakdown models |
| 3 | `Models/Calculation/TenancyCalculator.swift` | Attorney + Mediation fee calculators |
| 4 | `Views/Screens/TenancySpecial/TenancySelectionView.swift` | Mode selection screen |
| 5 | `Views/Screens/TenancySpecial/TenancySelectionViewModel.swift` | Selection ViewModel |
| 6 | `Views/Screens/TenancySpecial/TenancyAttorneyFeeView.swift` | Attorney fee input view |
| 7 | `Views/Screens/TenancySpecial/TenancyAttorneyFeeViewModel.swift` | Attorney fee ViewModel |
| 8 | `Views/Screens/TenancySpecial/TenancyMediationFeeView.swift` | Mediation fee input view |
| 9 | `Views/Screens/TenancySpecial/TenancyMediationFeeViewModel.swift` | Mediation fee ViewModel |
| 10 | `Views/Screens/TenancySpecial/TenancyAttorneyFeeResultSheet.swift` | Attorney fee result sheet |
| 11 | `Views/Screens/TenancySpecial/TenancyMediationFeeResultSheet.swift` | Mediation fee result sheet |

### Modified Files (3 files)

| # | File Path | Change |
|---|-----------|--------|
| 12 | `Views/Screens/DisputeCategory/DisputeCategoryViewModel.swift` | Add `navigateToTenancySpecial` flag, update `selectCategory(.rentSpecial)` |
| 13 | `Views/Screens/DisputeCategory/DisputeCategoryView.swift` | Add `.navigationDestination` for tenancy |
| 14 | `Localization/LocalizationKeys.swift` | Add `RentSpecial` struct with all keys |

### Localization Files (1 file)

| # | File Path | Change |
|---|-----------|--------|
| 15 | `Localizable.xcstrings` | Add TR/EN translations for all new keys |

---

## Implementation Steps

### Step 1: Create Constants File

**File:** `Constants/TenancyCalculationConstants.swift`

Key contents:
- `RentType` enum: `.eviction`, `.determination` with localized displayName
- `RentFeeMode` enum: `.attorneyFee`, `.mediationFee` with displayName, systemImage
- `RentCourtType` enum: `.civilPeace`, `.firstInstance`, `.enforcement` with `minimumFee(for year:)` and `warningMessage(for year:)`
- `Validation` struct: minimumAmount (0.01), maximumAmount (999_999_999)
- `validateAmount()` method

### Step 2: Create Domain Models

**File:** `Models/Domain/TenancyCalculationResult.swift`

Key contents:
- `TenancyCalculationInput`: feeMode, selectedTypes (Set), evictionAmount?, determinationAmount?, tariffYear + validate()
- `TenancyAttorneyFeeResult`: fee, totalInputAmount, courtMinimumWarnings, tariffYear + formattedFee
- `CourtMinimumWarning`: courtType, minimumFee, warningMessage (Identifiable)
- `TenancyMediationFeeResult`: evictionFee?, determinationFee?, totalFee, evictionOriginalAmount?, tariffYear + formattedFees, hasBothTypes

### Step 3: Create Calculator

**File:** `Models/Calculation/TenancyCalculator.swift`

Key contents:
```swift
struct TenancyCalculator {
    static func calculateAttorneyFee(input:) -> TenancyAttorneyFeeResult
    static func calculateMediationFee(input:) -> TenancyMediationFeeResult
    static func calculateWithValidation(input:) -> Result<...>
    private static func calculateThirdPartFee(amount:, year:) -> Double
}
```

Attorney fee uses `AttorneyFeeConstants.MonetaryBrackets2025/2026.brackets` (incremental style: limit is bracket SIZE).
Mediation fee uses `TariffProtocol.calculateBracketFee()` (cumulative style: limit is upper BOUND).

### Step 4: Update Localization

**File:** `Localization/LocalizationKeys.swift` - Add `RentSpecial` struct
**File:** `Localizable.xcstrings` - Add TR/EN translations

### Step 5: Update Navigation

**File:** `DisputeCategoryViewModel.swift`:
- Add `@Published var navigateToTenancySpecial: Bool = false`
- Change `.rentSpecial` case from coming soon to `navigateToTenancySpecial = true`
- Add `navigateToTenancySpecial = false` to `resetNavigation()`

**File:** `DisputeCategoryView.swift`:
- Add `.navigationDestination(isPresented: $viewModel.navigateToTenancySpecial)` with `TenancySelectionView`

### Step 6: Create Selection View

**File:** `TenancySelectionView.swift` + `TenancySelectionViewModel.swift`

Pattern: Similar to `AttorneyFeeTypeView` but with two large buttons instead of segmented pickers.
- Year picker dropdown at top
- "Avukatlık Ücreti" button with icon and description
- "Arabuluculuk Ücreti" button with icon and description
- NavigationStack push for both paths

### Step 7: Create Attorney Fee Input View

**File:** `TenancyAttorneyFeeView.swift` + `TenancyAttorneyFeeViewModel.swift`

Pattern: New checkbox pattern based on `CourtTypeButton` from AttorneyFeeInputView.

UI elements:
1. Year picker dropdown
2. Tahliye checkbox (toggle) with description
3. Tespit checkbox (toggle) with description
4. Conditional input fields (shown when checkbox is checked)
5. Calculate button
6. Result via `.sheet()`

ViewModel properties:
- `isEvictionSelected: Bool`, `isDeterminationSelected: Bool`
- `evictionAmountText: String`, `determinationAmountText: String`
- `showResultSheet: Bool`, `calculationResult: TenancyAttorneyFeeResult?`
- `isCalculateButtonEnabled` computed (at least one selected + amounts valid)
- `formatAmountInput()` reused from ReinstatementViewModel pattern
- `parseAmount()` for locale-aware parsing

### Step 8: Create Mediation Fee Input View

**File:** `TenancyMediationFeeView.swift` + `TenancyMediationFeeViewModel.swift`

Same checkbox pattern as attorney fee. Key differences:
- Eviction label: "1 Yıllık Kira Bedeli Tutarını Giriniz" (user enters full amount, app halves it)
- Determination label: "1 Yıllık Kira Bedeli Farkını Giriniz"

### Step 9: Create Result Sheets

**File:** `TenancyAttorneyFeeResultSheet.swift`

Pattern: Follow `AttorneyFeeResultSheet`:
- Main fee card (large, prominent)
- Calculation info card (input amount, tariff year)
- **Court minimum warnings card** (unique to tenancy) - list all 3 courts with minimums
- Legal reference card (Article 9/1)
- `.presentationDetents([.large])`, `.presentationDragIndicator(.visible)`

**File:** `TenancyMediationFeeResultSheet.swift`

Pattern: Follow `AttorneyFeeResultSheet` but with breakdown:
- If only one type: show single fee
- If both types: show eviction fee, determination fee, and total
- Legal reference card (Article 7/5)

---

## Checkbox Component Pattern (New)

Based on `CourtTypeButton` from `AttorneyFeeInputView.swift`:

```swift
@available(iOS 26.0, *)
struct TenancyTypeCheckbox: View {
    let rentType: TenancyCalculationConstants.RentType
    let isSelected: Bool
    let theme: ThemeProtocol
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: theme.spacingM) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(theme.title3)
                    .foregroundStyle(isSelected ? theme.success : theme.textSecondary)

                VStack(alignment: .leading, spacing: theme.spacingXS) {
                    Text(rentType.displayName)
                        .font(theme.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)

                    Text(rentType.inputDescription)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)
                }

                Spacer()
            }
            .padding(theme.spacingM)
            .frame(maxWidth: .infinity)
            .glassEffect()
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
```

---

## Key Code Patterns to Follow

| Pattern | Source File | Applies To |
|---------|-----------|------------|
| `@available(iOS 26.0, *)` | Every view | All new views |
| `@StateObject` for ViewModel | `ReinstatementSheet.swift:27` | All new views |
| `@ObservedObject private var localeManager = LocaleManager.shared` | Every view | All new views |
| `let _ = localeManager.refreshID` at top of body | Every view body | All new view bodies |
| `@Environment(\.theme) var theme` | Every view | All new views |
| `@MainActor final class ViewModel: ObservableObject` | `ReinstatementViewModel.swift:16` | All ViewModels |
| Year picker via `Menu` | `ReinstatementSheet.swift:141-183` | Selection, Input views |
| `formatAmountInput()` | `ReinstatementViewModel.swift:260-352` | Input ViewModels |
| `.glassEffect()` on inputs | `ReinstatementSheet.swift:251` | All input fields |
| `.buttonStyle(.glass)` on buttons | `ReinstatementSheet.swift:404` | Calculate buttons |
| `.presentationBackground(.clear)` | `AttorneyFeeResultSheet.swift:64` | Result sheets |

---

## Test Cases

### Attorney Fee

| # | Scenario | Year | Input | Expected |
|---|----------|------|-------|----------|
| 1 | Eviction only | 2026 | 350K | 56,000 TL |
| 2 | Eviction only | 2026 | 1M | 156,000 TL |
| 3 | Determination only | 2026 | 500K | 80,000 TL |
| 4 | Both | 2026 | 1M + 200K | 186,000 TL |
| 5 | Eviction only | 2025 | 1M | 152,000 TL |

### Mediation Fee

| # | Scenario | Year | Input | Expected |
|---|----------|------|-------|----------|
| 6 | Eviction only | 2026 | rent=600K→base=300K | 18,000 TL |
| 7 | Determination only | 2026 | diff=600K | 36,000 TL |
| 8 | Both | 2026 | rent=600K, diff=600K | 18K+36K=54,000 TL |
| 9 | Both | 2025 | rent=400K, diff=400K | 12K+23K=35,000 TL |

---

## Reference Documentation

See: `Documentation/TENANCY_CALCULATION_PLAN.md`
