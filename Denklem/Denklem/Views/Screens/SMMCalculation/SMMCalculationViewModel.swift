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
    @Published var selectedCalculationType: SMMCalculationType = .vatIncludedWithholdingExcluded
    
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

        // Remove all formatting (keep only numbers and decimal separator)
        var cleaned = amountText.replacingOccurrences(of: groupingSeparator, with: "")

        // Allow only numbers and one decimal separator
        let allowedChars = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: decimalSeparator))
        cleaned = String(cleaned.unicodeScalars.filter { allowedChars.contains($0) })

        // Ensure only one decimal separator
        let parts = cleaned.components(separatedBy: decimalSeparator)
        if parts.count > 2 {
            cleaned = parts[0] + decimalSeparator + parts[1]
        }

        // If empty, clear
        guard !cleaned.isEmpty else {
            amountText = ""
            return
        }

        // Split into integer and decimal parts
        let components = cleaned.components(separatedBy: decimalSeparator)
        let integerPart = components[0]
        let decimalPart = components.count > 1 ? components[1] : ""

        // Format integer part with grouping separators
        if let number = Int(integerPart), number >= 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = locale
            formatter.groupingSeparator = groupingSeparator
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 0

            if let formatted = formatter.string(from: NSNumber(value: number)) {
                if decimalPart.isEmpty {
                    amountText = formatted
                } else {
                    let limitedDecimal = String(decimalPart.prefix(2))
                    amountText = formatted + decimalSeparator + limitedDecimal
                }
            }
        } else if cleaned == decimalSeparator {
            amountText = "0" + decimalSeparator
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
