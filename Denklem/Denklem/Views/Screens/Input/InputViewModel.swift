//
//  InputViewModel.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI
import Combine

// MARK: - Input ViewModel
/// ViewModel for InputView - manages user input and calculation
@available(iOS 26.0, *)
@MainActor
final class InputViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected tariff year from previous screens
    @Published var selectedYear: TariffYear
    
    /// Whether the dispute is monetary (from DisputeCategoryView)
    @Published var isMonetary: Bool
    
    /// Whether parties have reached an agreement (from AgreementStatusView)
    @Published var hasAgreement: Bool
    
    /// Selected dispute type (from DisputeTypeView)
    @Published var selectedDisputeType: DisputeType
    
    /// Dispute amount input (for agreement cases)
    @Published var amountText: String = ""
    
    /// Party count input
    @Published var partyCountText: String = ""
    
    /// Show result sheet
    @Published var showResult: Bool = false
    
    /// Calculation result
    @Published var calculationResult: CalculationResult?
    
    /// Error message if calculation fails
    @Published var errorMessage: String?
    
    /// Loading state
    @Published var isCalculating: Bool = false
    
    // MARK: - Computed Properties
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.input.localized
    }

    /// Amount input label
    var amountLabel: String {
        LocalizationKeys.Input.agreementAmount.localized
    }

    /// Party count input label
    var partyCountLabel: String {
        LocalizationKeys.Input.partyCount.localized
    }

    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Agreement status display text
    var agreementStatusText: String {
        hasAgreement ? LocalizationKeys.AgreementStatus.agreed.localized : LocalizationKeys.AgreementStatus.notAgreed.localized
    }
    
    /// Selected year display text
    var selectedYearText: String {
        selectedYear.displayName
    }
    
    /// Whether amount input should be visible (only for agreement cases)
    var showAmountInput: Bool {
        hasAgreement
    }
    
    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        if hasAgreement {
            return !amountText.isEmpty && !partyCountText.isEmpty
        } else {
            return !partyCountText.isEmpty
        }
    }
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool, hasAgreement: Bool, selectedDisputeType: DisputeType) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
        self.hasAgreement = hasAgreement
        self.selectedDisputeType = selectedDisputeType
    }
    
    // MARK: - Public Methods
    
    /// Performs calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true
        
        // Parse inputs
        guard let partyCount = Int(partyCountText), partyCount >= ValidationConstants.PartyCount.minimum else {
            errorMessage = LocalizationKeys.Validation.invalidPartyCount.localized
            isCalculating = false
            return
        }
        
        // Parse amount for agreement cases
        let amount: Double?
        if hasAgreement {
            // Remove formatting and parse with locale awareness
            let locale = LocaleManager.shared.currentLocale
            let decimalSeparator = locale.decimalSeparator ?? ","
            let groupingSeparator = locale.groupingSeparator ?? "."
            
            let cleanedAmount = amountText
                .replacingOccurrences(of: groupingSeparator, with: "")
                .replacingOccurrences(of: decimalSeparator, with: ".")
            
            guard let parsedAmount = Double(cleanedAmount),
                  parsedAmount >= ValidationConstants.Amount.minimum else {
                errorMessage = LocalizationKeys.Validation.invalidAmount.localized
                isCalculating = false
                return
            }
            amount = parsedAmount
        } else {
            amount = nil
        }
        
        // Create calculation input
        let calculationType: CalculationType = hasAgreement ? .monetary : .nonMonetary
        let agreementStatus: AgreementStatus = hasAgreement ? .agreed : .notAgreed
        
        let inputResult = CalculationInput.create(
            disputeType: selectedDisputeType,
            calculationType: calculationType,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            tariffYear: selectedYear,
            disputeAmount: amount
        )
        
        // Handle input creation result
        let input: CalculationInput
        switch inputResult {
        case .success(let validInput):
            input = validInput
        case .failure(let validationError):
            errorMessage = validationError.errorMessage ?? LocalizationKeys.ErrorMessage.calculationFailed.localized
            isCalculating = false
            return
        }
        
        // Perform calculation
        let result = TariffCalculator.calculateFee(input: input)
        
        // Handle result
        if result.isSuccess {
            calculationResult = result
            isCalculating = false
            showResult = true
        } else {
            errorMessage = result.errorMessage ?? LocalizationKeys.ErrorMessage.calculationFailed.localized
            isCalculating = false
        }
    }
    
    /// Resets all inputs
    func reset() {
        amountText = ""
        partyCountText = ""
        calculationResult = nil
        errorMessage = nil
        showResult = false
    }
    
    /// Formats currency input as user types with locale-aware thousand separators and decimals
    func formatAmountInput() {
        // Get locale separators
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        // Step 1: Keep only digits, dots, and commas
        var cleaned = String(amountText.unicodeScalars.filter {
            CharacterSet.decimalDigits.contains($0) || $0 == "." || $0 == ","
        })

        // Step 2: Find ONLY the locale's decimal separator - not just any separator
        // This fixes the bug where grouping separator was being treated as decimal
        let decimalSepChar = Character(decimalSeparator)
        let decimalSepIndex = cleaned.lastIndex(of: decimalSepChar)

        // Step 3: Check if the locale's decimal separator exists and has 0-2 digits after it
        var integerPart = ""
        var decimalPart = ""
        var hasDecimal = false

        if let sepIndex = decimalSepIndex {
            let afterSep = String(cleaned[cleaned.index(after: sepIndex)...])
            // Only treat as decimal if there are 0-2 digits after the LOCALE's decimal separator
            if afterSep.count <= 2 {
                hasDecimal = true
                integerPart = String(cleaned[..<sepIndex])
                decimalPart = afterSep
            } else {
                // More than 2 digits - this is not a decimal separator
                integerPart = cleaned
            }
        } else {
            integerPart = cleaned
        }

        // Step 4: Remove ALL separators from integer part (both are grouping separators now)
        integerPart = integerPart.replacingOccurrences(of: ".", with: "")
        integerPart = integerPart.replacingOccurrences(of: ",", with: "")

        // Step 5: Rebuild cleaned string
        if hasDecimal {
            cleaned = integerPart + decimalSeparator + decimalPart
        } else {
            cleaned = integerPart
        }
        
        // If empty, clear
        guard !cleaned.isEmpty else {
            amountText = ""
            return
        }
        
        let hasTrailingDecimalSeparator = cleaned.hasSuffix(decimalSeparator)

        // Split into integer and decimal parts for formatting
        let components = cleaned.components(separatedBy: decimalSeparator)
        let finalIntegerPart = components[0]
        let finalDecimalPart = components.count > 1 ? components[1] : ""
        
        // Format integer part with grouping separators
        if !finalIntegerPart.isEmpty, let number = Double(finalIntegerPart), number >= 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = locale
            formatter.groupingSeparator = groupingSeparator
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 0
            
            if let formatted = formatter.string(from: NSNumber(value: number)) {
                let newValue: String
                if !finalDecimalPart.isEmpty {
                    // Limit decimal part to 2 digits
                    let limitedDecimal = String(finalDecimalPart.prefix(2))
                    newValue = formatted + decimalSeparator + limitedDecimal
                } else if hasTrailingDecimalSeparator {
                    newValue = formatted + decimalSeparator
                } else {
                    newValue = formatted
                }
                
                // Only update if value actually changed
                if amountText != newValue {
                    amountText = newValue
                }
            }
        } else if cleaned == decimalSeparator {
            // If user just types decimal separator
            let newValue = "0" + decimalSeparator
            if amountText != newValue {
                amountText = newValue
            }
        }
    }
    
    /// Formats party count input as user types
    func formatPartyCountInput() {
        // Remove non-numeric characters
        let filtered = partyCountText.filter { $0.isNumber }
        partyCountText = filtered
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension InputViewModel {
    static var previewAgreement: InputViewModel {
        InputViewModel(
            selectedYear: .year2025,
            isMonetary: true,
            hasAgreement: true,
            selectedDisputeType: .workerEmployer
        )
    }
    
    static var previewNonAgreement: InputViewModel {
        InputViewModel(
            selectedYear: .year2025,
            isMonetary: true,
            hasAgreement: false,
            selectedDisputeType: .commercial
        )
    }
}
#endif
