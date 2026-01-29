//
//  SMMCalculationViewModel.swift
//  Denklem
//
//  Created by ozkan on 09.01.2026.
//

import SwiftUI
import Combine

// MARK: - SMM Calculation ViewModel
/// ViewModel for SMMCalculationView - manages SMM receipt calculation
@available(iOS 26.0, *)
@MainActor
final class SMMCalculationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// SMM amount input
    @Published var amountText: String = ""
    
    /// Selected calculation type
    @Published var selectedCalculationType: SMMCalculationType = .vatIncludedWithholdingIncluded
    
    /// Show result sheet
    @Published var showResult: Bool = false
    
    /// Calculation result
    @Published var calculationResult: SMMCalculationResult?
    
    /// Error message if calculation fails
    @Published var errorMessage: String?
    
    /// Loading state
    @Published var isCalculating: Bool = false
    
    // MARK: - Computed Properties
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.smmCalculation.localized
    }
    
    /// Amount input label
    var amountLabel: String {
        LocalizationKeys.Input.agreementAmount.localized
    }
    
    /// Calculation type label
    var calculationTypeLabel: String {
        LocalizationKeys.ScreenTitle.smmCalculation.localized
    }
    
    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }
    
    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        !amountText.isEmpty
    }
    
    // MARK: - Public Methods
    
    /// Performs SMM calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true
        
        // Parse amount (locale-aware)
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        let cleanedAmount = amountText
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: groupingSeparator, with: "")
            .replacingOccurrences(of: decimalSeparator, with: ".")

        guard let amount = Double(cleanedAmount) else {
            errorMessage = LocalizationKeys.Validation.invalidAmount.localized
            isCalculating = false
            return
        }
        
        // Validate amount
        let amountValidation = ValidationConstants.validateSMMAmount(amount)
        guard amountValidation.isValid else {
            errorMessage = amountValidation.errorMessage
            isCalculating = false
            return
        }
        
        // Create calculation input
        let input = SMMCalculationInput(
            amount: amount,
            calculationType: selectedCalculationType
        )
        
        // Validate input
        let validation = input.validate()
        guard validation.isValid else {
            errorMessage = validation.errorMessage
            isCalculating = false
            return
        }
        
        // Perform calculation
        let result = SMMCalculator.calculateSMM(input: input)
        
        // Check result
        isCalculating = false
        
        if result.isSuccess {
            calculationResult = result
            showResult = true
        } else {
            errorMessage = result.errorMessage ?? LocalizationKeys.Error.calculationFailed.localized
        }
    }
    
    /// Resets all inputs
    func reset() {
        amountText = ""
        selectedCalculationType = .vatIncludedWithholdingExcluded
        calculationResult = nil
        errorMessage = nil
        showResult = false
    }
    
    /// Formats currency input as user types
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
            let newValue = "0" + decimalSeparator
            if amountText != newValue {
                amountText = newValue
            }
        }
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension SMMCalculationViewModel {
    static var preview: SMMCalculationViewModel {
        let vm = SMMCalculationViewModel()
        vm.amountText = "10 000"
        return vm
    }
}
#endif
