# Reinstatement Calculation - Implementation Skill

## Overview

This skill contains the implementation of **reinstatement** mediation fee calculation feature. Reinstatement is a special type of labor law dispute where an employee requests reinstatement after termination.

### Core Principles

- **Pattern:** Single sheet approach (SerialDisputes pattern)
- **Calculation:** Uses existing `TariffProtocol` methods, no new formulas
- **Tariff Years:** 2025 and 2026 (each year with different brackets and fees)
- **Dispute Type:** Worker-Employer (workerEmployer)

### Architecture Approach

```
DisputeCategoryView
    └── [Reinstatement Button]
            └── ReinstatementSheet (Single sheet)
                    ├── Agreement/No Agreement selection
                    ├── Conditional input fields
                    ├── Calculate button
                    └── Result view
```

---

## Calculation Logic

### 1. Agreement Status (Labor Courts Law Art. 3/13-2)

**Inputs:**
- Non-reinstatement compensation (required)
- Idle period wage (required)
- Other rights (optional)
- Party count (required)

**Formula:**
```swift
let totalAmount = compensation + idleWage + (otherRights ?? 0)
let fee = tariff.calculateAgreementFee(
    disputeType: DisputeConstants.DisputeTypeKeys.workerEmployer,
    amount: totalAmount,
    partyCount: partyCount
)
// Bracket calculation + minimum fee check (existing TariffProtocol method)
```

**Tariff Bracket Tiers:**

**2026:**
- First 600,000 TL: 6%
- Next 960,000 TL: 5%
- Next 1,560,000 TL: 4%
- Next 3,120,000 TL: 3%
- Next 9,360,000 TL: 2%
- Next 12,480,000 TL: 1.5%
- Next 24,960,000 TL: 1%
- Over 53,040,000 TL: 0.5%
- **Minimum:** 9,000 TL

**2025:**
- First 300,000 TL: 6%
- Next 480,000 TL: 5%
- Next 780,000 TL: 4%
- Next 3,120,000 TL: 3%
- Next 1,560,000 TL: 2%
- Next 6,240,000 TL: 1.5%
- Next 14,040,000 TL: 1%
- Over 26,520,000 TL: 0.5%
- **Minimum:** 6,000 TL

### 2. No Agreement Status (Labor Law Art. 20-2)

**Inputs:**
- Party count (required)

**Formula:**
```swift
let fee = tariff.calculateNonAgreementFee(
    disputeType: DisputeConstants.DisputeTypeKeys.workerEmployer,
    partyCount: partyCount
)
// Fixed fee × 2 (existing TariffProtocol method)
```

**Fixed Fees:**

**2026:**
- 2 parties: 2,260 × 2 = 4,520 TL
- 3-5 parties: 2,460 × 2 = 4,920 TL
- 6-10 parties: 2,560 × 2 = 5,120 TL
- 11+ parties: 2,660 × 2 = 5,320 TL

**2025:**
- 2 parties: 1,570 × 2 = 3,140 TL
- 3-5 parties: 1,650 × 2 = 3,300 TL
- 6-10 parties: 1,750 × 2 = 3,500 TL
- 11+ parties: 1,850 × 2 = 3,700 TL

---

## File Structure

### New Files to Create

```
Denklem/
├── Constants/
│   └── ReinstatementConstants.swift        [NEW]
│
├── Models/
│   ├── Domain/
│   │   └── ReinstatementResult.swift       [NEW]
│   └── Calculation/
│       └── ReinstatementCalculator.swift   [NEW]
│
└── Views/
    └── Screens/
        └── Reinstatement/                   [NEW FOLDER]
            ├── ReinstatementSheet.swift
            ├── ReinstatementViewModel.swift
            └── ReinstatementResultView.swift
```

### Files to Update

```
Denklem/
├── Views/
│   └── Screens/
│       └── DisputeCategory/
│           ├── DisputeCategoryView.swift          [UPDATE]
│           └── DisputeCategoryViewModel.swift     [UPDATE]
│
└── Localization/
    ├── LocalizationKeys.swift                     [UPDATE]
    └── Localizable.xcstrings                      [UPDATE]
```

---

## Implementation Details

### 1. ReinstatementConstants.swift

```swift
import SwiftUI

struct ReinstatementConstants {
    
    // MARK: - Validation
    struct Validation {
        static let minimumAmount: Double = 0.01
        static let maximumAmount: Double = 999_999_999.99
        static let minimumPartyCount: Int = 2
        static let maximumPartyCount: Int = 1000
    }
    
    // MARK: - Legal References
    struct LegalReferences {
        static let agreementArticle = "İş Mahkemeleri Kanunu m.3/13-2"
        static let noAgreementArticle = "İş Kanunu m.20-2"
        static let laborLawArticle = "İş Kanunu m.21/7"
        static let tariffSection = "Tarife İkinci Kısım"
    }
}
```

### 2. ReinstatementResult.swift

**Main Models:**

```swift
// MARK: - Agreement Status Enum
enum AgreementStatus: String, Codable, CaseIterable {
    case agreed = "agreed"
    case notAgreed = "notAgreed"
    
    var displayName: String {
        switch self {
        case .agreed:
            return NSLocalizedString(LocalizationKeys.Reinstatement.agreement, comment: "")
        case .notAgreed:
            return NSLocalizedString(LocalizationKeys.Reinstatement.noAgreement, comment: "")
        }
    }
}

// MARK: - Reinstatement Input
struct ReinstatementInput: Equatable, Codable {
    let agreementStatus: AgreementStatus
    let tariffYear: TariffYear
    let partyCount: Int
    
    // For agreement status
    let nonReinstatementCompensation: Double?  // Non-reinstatement compensation
    let idlePeriodWage: Double?                 // Idle period wage
    let otherRights: Double?                    // Other rights
    
    var totalAgreementAmount: Double? {
        guard agreementStatus == .agreed,
              let compensation = nonReinstatementCompensation,
              let wage = idlePeriodWage else { return nil }
        return compensation + wage + (otherRights ?? 0)
    }
    
    func validate() -> ValidationResult {
        // Party count validation
        let partyValidation = ValidationConstants.validatePartyCount(partyCount)
        if !partyValidation.isValid { return partyValidation }
        
        // Amount validation for agreement status
        if agreementStatus == .agreed {
            guard let compensation = nonReinstatementCompensation,
                  let wage = idlePeriodWage else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: NSLocalizedString(LocalizationKeys.Validation.requiredFieldsEmpty, comment: "")
                )
            }
            
            let compensationValidation = ValidationConstants.validateAmount(compensation)
            if !compensationValidation.isValid { return compensationValidation }
            
            let wageValidation = ValidationConstants.validateAmount(wage)
            if !wageValidation.isValid { return wageValidation }
            
            if let rights = otherRights {
                let rightsValidation = ValidationConstants.validateAmount(rights)
                if !rightsValidation.isValid { return rightsValidation }
            }
        }
        
        return .success
    }
}

// MARK: - Reinstatement Result
struct ReinstatementResult: Equatable, Codable {
    let totalFee: Double
    let agreementStatus: AgreementStatus
    let tariffYear: TariffYear
    let partyCount: Int
    let breakdown: ReinstatementBreakdown?
    
    var legalReference: String {
        switch agreementStatus {
        case .agreed:
            return ReinstatementConstants.LegalReferences.agreementArticle
        case .notAgreed:
            return ReinstatementConstants.LegalReferences.noAgreementArticle
        }
    }
}

// MARK: - Reinstatement Breakdown
struct ReinstatementBreakdown: Equatable, Codable {
    let nonReinstatementCompensation: Double
    let idlePeriodWage: Double
    let otherRights: Double
    let totalAmount: Double
    let bracketFee: Double
    let minimumFee: Double
    let isMinimumApplied: Bool
}
```

### 3. ReinstatementCalculator.swift

**Calculation Engine:**

```swift
import Foundation

struct ReinstatementCalculator {
    
    // MARK: - Main Calculation
    static func calculate(input: ReinstatementInput) -> ReinstatementResult {
        let tariff = TariffFactory.createTariff(for: input.tariffYear.rawValue)!
        
        let fee: Double
        let breakdown: ReinstatementBreakdown?
        
        if input.agreementStatus == .agreed {
            // Agreement: Bracket calculation
            let totalAmount = input.totalAgreementAmount!
            let bracketFee = tariff.calculateBracketFee(for: totalAmount)
            let minimumFee = tariff.getMinimumFee(for: DisputeConstants.DisputeTypeKeys.workerEmployer)
            
            fee = max(bracketFee, minimumFee)
            
            breakdown = ReinstatementBreakdown(
                nonReinstatementCompensation: input.nonReinstatementCompensation!,
                idlePeriodWage: input.idlePeriodWage!,
                otherRights: input.otherRights ?? 0,
                totalAmount: totalAmount,
                bracketFee: bracketFee,
                minimumFee: minimumFee,
                isMinimumApplied: minimumFee > bracketFee
            )
        } else {
            // No Agreement: Fixed fee × 2
            fee = tariff.calculateNonAgreementFee(
                disputeType: DisputeConstants.DisputeTypeKeys.workerEmployer,
                partyCount: input.partyCount
            )
            breakdown = nil
        }
        
        return ReinstatementResult(
            totalFee: fee,
            agreementStatus: input.agreementStatus,
            tariffYear: input.tariffYear,
            partyCount: input.partyCount,
            breakdown: breakdown
        )
    }
}
```

### 4. ReinstatementViewModel.swift

**State Management:**

```swift
@available(iOS 26.0, *)
@MainActor
final class ReinstatementViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var agreementStatus: AgreementStatus?
    @Published var partyCountText: String = ""
    
    // For agreement
    @Published var compensationText: String = ""
    @Published var idleWageText: String = ""
    @Published var otherRightsText: String = ""
    
    // Result
    @Published var result: ReinstatementResult?
    @Published var showResult: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let selectedYear: TariffYear
    
    // MARK: - Init
    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }
    
    // MARK: - Computed Properties
    var isCalculateButtonEnabled: Bool {
        guard let status = agreementStatus else { return false }
        
        let hasPartyCount = !partyCountText.isEmpty
        
        if status == .agreed {
            return hasPartyCount && 
                   !compensationText.isEmpty && 
                   !idleWageText.isEmpty
        } else {
            return hasPartyCount
        }
    }
    
    // MARK: - Calculate
    func calculate() {
        errorMessage = nil
        
        guard let status = agreementStatus,
              let partyCount = Int(partyCountText) else {
            errorMessage = NSLocalizedString(LocalizationKeys.Validation.invalidInput, comment: "")
            return
        }
        
        let compensation: Double? = status == .agreed ? Double(compensationText) : nil
        let wage: Double? = status == .agreed ? Double(idleWageText) : nil
        let rights: Double? = status == .agreed && !otherRightsText.isEmpty ? Double(otherRightsText) : nil
        
        let input = ReinstatementInput(
            agreementStatus: status,
            tariffYear: selectedYear,
            partyCount: partyCount,
            nonReinstatementCompensation: compensation,
            idlePeriodWage: wage,
            otherRights: rights
        )
        
        let validation = input.validate()
        if !validation.isValid {
            errorMessage = validation.message
            return
        }
        
        result = ReinstatementCalculator.calculate(input: input)
        showResult = true
    }
    
    // MARK: - Reset
    func reset() {
        agreementStatus = nil
        partyCountText = ""
        compensationText = ""
        idleWageText = ""
        otherRightsText = ""
        result = nil
        showResult = false
        errorMessage = nil
    }
}
```

### 5. ReinstatementSheet.swift

**Main Sheet View:**

```swift
@available(iOS 26.0, *)
struct ReinstatementSheet: View {
    @StateObject private var viewModel: ReinstatementViewModel
    @Environment(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    
    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: ReinstatementViewModel(selectedYear: selectedYear))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.colors.background.ignoresSafeArea()
                
                if viewModel.showResult, let result = viewModel.result {
                    ReinstatementResultView(
                        result: result,
                        onRecalculate: {
                            viewModel.reset()
                        }
                    )
                } else {
                    inputView
                }
            }
            .navigationTitle(NSLocalizedString(LocalizationKeys.Reinstatement.screenTitle, comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString(LocalizationKeys.Common.close, comment: "")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var inputView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Agreement status picker
                agreementStatusPicker
                
                // Conditional input fields
                if let status = viewModel.agreementStatus {
                    if status == .agreed {
                        agreementInputs
                    }
                    partyCountInput
                    
                    // Calculate button
                    calculateButton
                }
                
                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
    
    private var agreementStatusPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString(LocalizationKeys.Reinstatement.selectAgreementStatus, comment: ""))
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(AgreementStatus.allCases, id: \.self) { status in
                    Button(action: { viewModel.agreementStatus = status }) {
                        VStack(spacing: 8) {
                            Text(status.displayName)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            viewModel.agreementStatus == status ? 
                            theme.colors.primary : theme.colors.surface
                        )
                        .foregroundColor(
                            viewModel.agreementStatus == status ? 
                            .white : theme.colors.textPrimary
                        )
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var agreementInputs: some View {
        VStack(spacing: 16) {
            // Compensation
            CustomTextField(
                text: $viewModel.compensationText,
                placeholder: NSLocalizedString(LocalizationKeys.Reinstatement.compensationPlaceholder, comment: ""),
                keyboardType: .decimalPad
            )
            
            // Idle period wage
            CustomTextField(
                text: $viewModel.idleWageText,
                placeholder: NSLocalizedString(LocalizationKeys.Reinstatement.idleWagePlaceholder, comment: ""),
                keyboardType: .decimalPad
            )
            
            // Other rights (optional)
            CustomTextField(
                text: $viewModel.otherRightsText,
                placeholder: NSLocalizedString(LocalizationKeys.Reinstatement.otherRightsPlaceholder, comment: ""),
                keyboardType: .decimalPad
            )
        }
    }
    
    private var partyCountInput: some View {
        CustomTextField(
            text: $viewModel.partyCountText,
            placeholder: NSLocalizedString(LocalizationKeys.DisputeInput.partyCountPlaceholder, comment: ""),
            keyboardType: .numberPad
        )
    }
    
    private var calculateButton: some View {
        Button(action: { viewModel.calculate() }) {
            Text(NSLocalizedString(LocalizationKeys.Common.calculate, comment: ""))
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isCalculateButtonEnabled ? theme.colors.primary : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(!viewModel.isCalculateButtonEnabled)
    }
}
```

### 6. ReinstatementResultView.swift

**Result View:**

```swift
@available(iOS 26.0, *)
struct ReinstatementResultView: View {
    let result: ReinstatementResult
    let onRecalculate: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main fee card
                feeCard
                
                // Detail card (for agreement)
                if let breakdown = result.breakdown {
                    breakdownCard(breakdown)
                }
                
                // Legal reference card
                legalReferenceCard
                
                // Recalculate button
                Button(action: onRecalculate) {
                    Text(NSLocalizedString(LocalizationKeys.Common.recalculate, comment: ""))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.colors.secondary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
    
    private var feeCard: some View {
        VStack(spacing: 12) {
            Text(NSLocalizedString(LocalizationKeys.Reinstatement.resultTitle, comment: ""))
                .font(.headline)
            
            Text(LocalizationHelper.formatCurrency(result.totalFee))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(theme.colors.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(theme.colors.surface)
        .cornerRadius(16)
    }
    
    private func breakdownCard(_ breakdown: ReinstatementBreakdown) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString(LocalizationKeys.Reinstatement.breakdownTitle, comment: ""))
                .font(.headline)
            
            breakdownRow(
                title: NSLocalizedString(LocalizationKeys.Reinstatement.compensation, comment: ""),
                value: breakdown.nonReinstatementCompensation
            )
            
            breakdownRow(
                title: NSLocalizedString(LocalizationKeys.Reinstatement.idleWage, comment: ""),
                value: breakdown.idlePeriodWage
            )
            
            if breakdown.otherRights > 0 {
                breakdownRow(
                    title: NSLocalizedString(LocalizationKeys.Reinstatement.otherRights, comment: ""),
                    value: breakdown.otherRights
                )
            }
            
            Divider()
            
            breakdownRow(
                title: NSLocalizedString(LocalizationKeys.Reinstatement.totalAmount, comment: ""),
                value: breakdown.totalAmount,
                isBold: true
            )
            
            if breakdown.isMinimumApplied {
                Text(NSLocalizedString(LocalizationKeys.Reinstatement.minimumFeeApplied, comment: ""))
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(theme.colors.surface)
        .cornerRadius(16)
    }
    
    private func breakdownRow(title: String, value: Double, isBold: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(isBold ? .headline : .body)
            Spacer()
            Text(LocalizationHelper.formatCurrency(value))
                .font(isBold ? .headline : .body)
        }
    }
    
    private var legalReferenceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString(LocalizationKeys.Reinstatement.legalReference, comment: ""))
                .font(.caption)
                .foregroundColor(theme.colors.textSecondary)
            
            Text(result.legalReference)
                .font(.footnote)
                .foregroundColor(theme.colors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(theme.colors.surface.opacity(0.5))
        .cornerRadius(12)
    }
}
```

### 7. DisputeCategoryViewModel Update

```swift
// MARK: - Navigation Flags
@Published var showSerialDisputesSheet: Bool = false
@Published var showAttorneyFeeSheet: Bool = false
@Published var showReinstatementSheet: Bool = false  // [NEW]

// MARK: - selectCategory
func selectCategory(_ category: DisputeCategoryType) {
    resetNavigation()
    
    switch category {
    case .monetary:
        navigateToDisputeType(for: .monetary)
    case .nonMonetary:
        navigateToDisputeType(for: .nonMonetary)
    case .attorneyFee:
        showAttorneyFeeSheet = true
    case .serialDisputes:
        showSerialDisputesSheet = true
    case .reinstatement:
        showReinstatementSheet = true  // [NEW]
    }
}

// MARK: - resetNavigation
func resetNavigation() {
    showSerialDisputesSheet = false
    showAttorneyFeeSheet = false
    showReinstatementSheet = false  // [NEW]
    // ... other resets
}
```

### 8. DisputeCategoryView Update

```swift
var body: some View {
    // ... existing code
    .sheet(isPresented: $viewModel.showReinstatementSheet) {
        ReinstatementSheet(selectedYear: viewModel.selectedYear)
    }
}
```

### 9. LocalizationKeys Update

```swift
// MARK: - Reinstatement
struct Reinstatement {
    // Screen
    static let screenTitle = "reinstatement.screen_title"
    static let resultTitle = "reinstatement.result_title"
    
    // Agreement Status
    static let selectAgreementStatus = "reinstatement.select_agreement_status"
    static let agreement = "reinstatement.agreement"
    static let noAgreement = "reinstatement.no_agreement"
    static let agreementDescription = "reinstatement.agreement_description"
    static let noAgreementDescription = "reinstatement.no_agreement_description"
    
    // Inputs
    static let compensation = "reinstatement.compensation"
    static let compensationPlaceholder = "reinstatement.compensation_placeholder"
    static let compensationHint = "reinstatement.compensation_hint"
    static let idleWage = "reinstatement.idle_wage"
    static let idleWagePlaceholder = "reinstatement.idle_wage_placeholder"
    static let idleWageHint = "reinstatement.idle_wage_hint"
    static let otherRights = "reinstatement.other_rights"
    static let otherRightsPlaceholder = "reinstatement.other_rights_placeholder"
    static let otherRightsOptional = "reinstatement.other_rights_optional"
    
    // Result
    static let totalAmount = "reinstatement.total_amount"
    static let calculatedFee = "reinstatement.calculated_fee"
    static let minimumFeeApplied = "reinstatement.minimum_fee_applied"
    static let breakdownTitle = "reinstatement.breakdown_title"
    
    // Legal
    static let legalReference = "reinstatement.legal_reference"
    static let agreementLegalRef = "reinstatement.agreement_legal_ref"
    static let noAgreementLegalRef = "reinstatement.no_agreement_legal_ref"
    static let tariffSection = "reinstatement.tariff_section"
}
```

### 10. Localizable.xcstrings Update

**Translations to add:**

| Key | Turkish | English |
|-----|--------|---------|
| `reinstatement.screen_title` | İşe İade Hesaplama | Reinstatement Calculation |
| `reinstatement.result_title` | Hesaplama Sonucu | Calculation Result |
| `reinstatement.select_agreement_status` | Anlaşma Durumu | Agreement Status |
| `reinstatement.agreement` | Anlaşma Sağlandı | Agreement Reached |
| `reinstatement.no_agreement` | Anlaşma Sağlanamadı | No Agreement |
| `reinstatement.compensation` | İşe Başlatılmama Tazminatı | Non-Reinstatement Compensation |
| `reinstatement.compensation_placeholder` | Tazminat miktarını girin | Enter compensation amount |
| `reinstatement.idle_wage` | Boşta Geçen Süre Ücreti | Idle Period Wage |
| `reinstatement.idle_wage_placeholder` | Ücret miktarını girin | Enter wage amount |
| `reinstatement.other_rights` | Diğer Haklar | Other Rights |
| `reinstatement.other_rights_placeholder` | Varsa diğer hakları girin | Enter other rights if any |
| `reinstatement.other_rights_optional` | (İsteğe bağlı) | (Optional) |
| `reinstatement.total_amount` | Toplam Miktar | Total Amount |
| `reinstatement.calculated_fee` | Arabuluculuk Ücreti | Mediation Fee |
| `reinstatement.minimum_fee_applied` | Asgari ücret uygulandı | Minimum fee applied |
| `reinstatement.breakdown_title` | Hesaplama Detayları | Calculation Details |
| `reinstatement.legal_reference` | Yasal Dayanak | Legal Reference |
| `reinstatement.agreement_legal_ref` | İş Mahkemeleri Kanunu m.3/13-2 | Labor Courts Law Art. 3/13-2 |
| `reinstatement.no_agreement_legal_ref` | İş Kanunu m.20-2 | Labor Law Art. 20-2 |
| `reinstatement.tariff_section` | Tarife İkinci Kısım | Tariff Second Part |

---

## Implementation Order

### Stage 1: Core Structure
1. Create `ReinstatementConstants.swift`
2. Create `ReinstatementResult.swift` (all models)
3. Create `ReinstatementCalculator.swift`

### Stage 2: Localization
4. Update `LocalizationKeys.swift`
5. Update `Localizable.xcstrings`

### Stage 3: UI Layer
6. Create `Views/Screens/Reinstatement/` folder
7. Create `ReinstatementViewModel.swift`
8. Create `ReinstatementSheet.swift`
9. Create `ReinstatementResultView.swift`

### Stage 4: Integration
10. Update `DisputeCategoryViewModel.swift`
11. Update `DisputeCategoryView.swift`

### Stage 5: Testing
12. Calculation tests (for 2025 and 2026)
13. UI flow test

---

## Test Scenarios

### 2026 Year Tests

| # | Status | Inputs | Expected |
|---|--------|----------|----------|
| 1 | Agreement (Minimum) | 50K + 30K + 0 = 80K, 2 parties | 9,000 TL |
| 2 | Agreement (Normal) | 100K + 50K + 10K = 160K, 2 parties | 9,600 TL |
| 3 | Agreement (High) | 500K + 200K + 100K = 800K, 2 parties | 46,000 TL |
| 4 | No Agreement | 2 parties | 4,520 TL |
| 5 | No Agreement | 5 parties | 4,920 TL |

### 2025 Year Tests

| # | Status | Inputs | Expected |
|---|--------|----------|----------|
| 6 | Agreement (Minimum) | 50K + 30K + 0 = 80K, 2 parties | 6,000 TL |
| 7 | Agreement (Normal) | 100K + 50K + 10K = 160K, 2 parties | 9,600 TL |
| 8 | No Agreement | 2 parties | 3,140 TL |

---

## Critical Points

1. **Use Existing Methods**
   - `TariffProtocol.calculateBracketFee()` - for bracket calculation
   - `TariffProtocol.calculateNonAgreementFee()` - for no agreement
   - Do NOT write new formulas, use existing infrastructure

2. **Tariff Year Differences**
   - 2025: 6,000 TL minimum, different brackets
   - 2026: 9,000 TL minimum, different brackets
   - TariffFactory automatically selects the correct tariff

3. **UI Pattern**
   - Follow SerialDisputes pattern
   - Conditional display within single sheet
   - Use theme injection
   - Liquid Glass UI components

4. **Validation**
   - All inputs must be validated with ValidationConstants
   - 3 fields required for agreement status
   - Only party count for no agreement status

5. **iOS 26.0+ Requirement**
   - All views must be marked with `@available(iOS 26.0, *)`

---

## References

- **Legal:** Labor Courts Law Art. 3/13-2, Labor Law Art. 20-2, Art. 21/7
- **Pattern:** SerialDisputes implementation
- **Calculation:** Tariff2025.swift, Tariff2026.swift, TariffProtocol.swift
- **UI:** LiquidGlass components, Theme system
