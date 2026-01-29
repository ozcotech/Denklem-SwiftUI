# Feature Implementation Skill - Attorney Fee Calculator

## Purpose
This skill guides the implementation of the Attorney Fee calculation feature for the Denklem app. Use this as a reference when coding the remaining view files.

## Current Status
**Completed:**
- AttorneyFeeConstants.swift
- AttorneyFeeTariff2026.swift
- AttorneyFeeResult.swift
- AttorneyFeeCalculator.swift
- LocalizationKeys.swift (updated)
- Localizable.xcstrings (updated)
- DisputeCategoryViewModel.swift (updated)
- DisputeCategoryView.swift (updated)

**To Be Implemented:**
- AttorneyFeeTypeView.swift
- AttorneyFeeTypeViewModel.swift
- AttorneyFeeInputView.swift
- AttorneyFeeInputViewModel.swift
- AttorneyFeeResultSheet.swift

---

## Critical Requirements

### 1. iOS 26.0+ Availability
Every SwiftUI view and type MUST have:
```swift
@available(iOS 26.0, *)
```

### 2. Theme Injection
All views MUST use theme from environment:
```swift
@Environment(\.theme) var theme
```
Use `theme.*` for all colors, fonts, spacing. Never hardcode.

### 3. Localization
Zero hardcoded strings. Always use:
```swift
Text(LocalizationKeys.AttorneyFee.someKey.localized)
```

### 4. MVVM Pattern
Each screen has paired View + ViewModel:
```swift
// View
@available(iOS 26.0, *)
struct AttorneyFeeTypeView: View {
    @StateObject private var viewModel = AttorneyFeeTypeViewModel()
    @Environment(\.theme) var theme

    var body: some View { ... }
}

// ViewModel
@available(iOS 26.0, *)
class AttorneyFeeTypeViewModel: ObservableObject {
    @Published var selectedType: AttorneyFeeDisputeType?
    @Published var selectedAgreement: AttorneyFeeAgreementStatus?
    // ...
}
```

---

## User Flow Reference

```
DisputeCategoryView
    └── [Avukatlık Ücreti]
            ↓
    AttorneyFeeTypeView (Select: Parasal/Parasal Olmayan + Anlaşma/Anlaşmama)
            ↓
    ┌───────┴───────┐
    │               │
[Anlaşma]    [Anlaşmama]
    ↓               ↓
AttorneyFeeInputView    AttorneyFeeResultSheet (Direct: 8.000 TL)
    ↓
AttorneyFeeResultSheet
```

---

## File Implementation Guide

### AttorneyFeeTypeView.swift
**Purpose:** Single screen for dispute type + agreement status selection

**Key Elements:**
- Two segmented/toggle selections (Parasal/Parasal Olmayan, Anlaşma/Anlaşmama)
- "Devam Et" button (enabled when both selections made)
- Navigation to InputView or direct ResultSheet based on selection

**Navigation Logic:**
```swift
if hasAgreement {
    // Navigate to AttorneyFeeInputView
} else {
    // Show AttorneyFeeResultSheet directly (8.000 TL fixed)
}
```

### AttorneyFeeTypeViewModel.swift
**Purpose:** Manage type selection state and navigation

**Properties:**
```swift
@Published var selectedDisputeType: AttorneyFeeDisputeType? // .monetary / .nonMonetary
@Published var selectedAgreementStatus: AttorneyFeeAgreementStatus? // .agreed / .notAgreed
@Published var navigateToInput: Bool = false
@Published var showResultSheet: Bool = false

var canProceed: Bool {
    selectedDisputeType != nil && selectedAgreementStatus != nil
}
```

### AttorneyFeeInputView.swift
**Purpose:** Input screen (amount OR court selection based on dispute type)

**Monetary (Anlaşma):** CurrencyInputField for agreement amount
**Non-Monetary (Anlaşma):** Court type picker (Sulh Hukuk, Asliye, Tüketici, Fikri Sınai)

**Key Elements:**
- Conditional UI based on `isMonetary`
- "Hesapla" button
- Input validation
- Show AttorneyFeeResultSheet on calculate

### AttorneyFeeInputViewModel.swift
**Purpose:** Manage input state and calculation

**Properties:**
```swift
@Published var agreementAmount: Double = 0
@Published var selectedCourtType: CourtType?
@Published var showResultSheet: Bool = false
@Published var calculationResult: AttorneyFeeResult?

let isMonetary: Bool
let hasAgreement: Bool
```

**Methods:**
```swift
func calculate() {
    let input = AttorneyFeeInput(
        isMonetary: isMonetary,
        hasAgreement: hasAgreement,
        agreementAmount: isMonetary ? agreementAmount : nil,
        courtType: !isMonetary ? selectedCourtType : nil
    )
    calculationResult = AttorneyFeeCalculator.calculate(input: input)
    showResultSheet = true
}
```

### AttorneyFeeResultSheet.swift
**Purpose:** Bottom sheet displaying calculation result

**Key Elements:**
- Large fee display (formatted currency)
- Calculation breakdown details
- Warning messages (if any)
- Legal reference text
- "Kapat" button

---

## UI Component References

Use existing app components for consistency:

| Need | Use Component |
|------|---------------|
| Currency input | `CurrencyInputField` |
| Primary button | `ThemedButton` |
| Card container | `ThemedCard` or `.glassCard(theme:)` |
| Screen header | `ScreenHeader` |
| Segmented control | Native `Picker` with `.segmented` style |

---

## Validation Rules

**Monetary Amount:**
- Min: 0.01 TL
- Max: 999,999,999 TL
- Required for monetary + agreement

**Court Type:**
- Required for non-monetary + agreement
- One of: civilPeace, firstInstance, consumer, intellectualProperty

**Fee Limits:**
- Fee cannot exceed agreement amount
- Minimum fee: 10.000 TL (for amounts < 50.000 TL with agreement)
- No agreement fee: 8.000 TL (fixed)

---

## Localization Keys Reference

```swift
LocalizationKeys.AttorneyFee.typeScreenTitle      // "Uyuşmazlık Türü"
LocalizationKeys.AttorneyFee.monetaryType         // "Parasal Uyuşmazlık"
LocalizationKeys.AttorneyFee.nonMonetaryType      // "Parasal Olmayan"
LocalizationKeys.AttorneyFee.agreed               // "Anlaşma"
LocalizationKeys.AttorneyFee.notAgreed            // "Anlaşmama"
LocalizationKeys.AttorneyFee.agreementAmount      // "Anlaşma Miktarı"
LocalizationKeys.AttorneyFee.selectCourt          // "Mahkeme Seçin"
LocalizationKeys.AttorneyFee.calculatedFee        // "Hesaplanan Ücret"
LocalizationKeys.AttorneyFee.feeExceedsAmountWarning
LocalizationKeys.AttorneyFee.legalReference
```

---

## Quick Checklist

Before completing each file:
- [ ] `@available(iOS 26.0, *)` added
- [ ] `@Environment(\.theme) var theme` used
- [ ] All strings use LocalizationKeys
- [ ] Colors/spacing from theme
- [ ] MARK comments for sections
- [ ] Navigation works correctly
- [ ] Validation implemented
- [ ] Follows existing app patterns

---

## Reference Files

Look at these existing files for patterns:
- `Views/Screens/Input/InputView.swift` - Input screen pattern
- `Views/Screens/Result/ResultView.swift` - Result display pattern
- `Views/Screens/AgreementStatus/AgreementStatusView.swift` - Selection pattern
- `Views/Components/Specialized/CurrencyInputField.swift` - Currency input
