//
//  AttorneyFeeInputViewModel.swift
//  Denklem
//
//  Created by ozkan on 28.01.2026.
//

import SwiftUI
import Combine

// MARK: - Attorney Fee Input ViewModel
/// ViewModel for AttorneyFeeInputView - manages input state and calculation
@available(iOS 26.0, *)
@MainActor
final class AttorneyFeeInputViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected tariff year
    let selectedYear: TariffYear

    /// Whether the dispute is monetary
    let isMonetary: Bool

    /// Whether parties have reached an agreement
    let hasAgreement: Bool

    /// Agreement amount input (for monetary disputes)
    @Published var amountText: String = ""

    /// Selected court type (for non-monetary disputes)
    @Published var selectedCourtType: AttorneyFeeConstants.CourtType?

    /// Show result sheet
    @Published var showResultSheet: Bool = false

    /// Calculation result
    @Published var calculationResult: AttorneyFeeResult?

    /// Error message if validation fails
    @Published var errorMessage: String?

    /// Loading state
    @Published var isCalculating: Bool = false

    // MARK: - Computed Properties

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.AttorneyFee.inputScreenTitle.localized
    }

    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        if isMonetary {
            return !amountText.isEmpty
        } else {
            return selectedCourtType != nil
        }
    }

    /// Available court types for selection
    var availableCourtTypes: [AttorneyFeeConstants.CourtType] {
        AttorneyFeeConstants.CourtType.allCases
    }

    /// Input section title
    var inputSectionTitle: String {
        if isMonetary {
            return LocalizationKeys.AttorneyFee.agreementAmount.localized
        } else {
            return LocalizationKeys.AttorneyFee.selectCourt.localized
        }
    }

    // MARK: - Initialization

    init(selectedYear: TariffYear, isMonetary: Bool, hasAgreement: Bool) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
        self.hasAgreement = hasAgreement
    }

    // MARK: - Public Methods

    /// Performs calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true

        // Parse amount for monetary disputes
        var agreementAmount: Double? = nil
        if isMonetary {
            let locale = LocaleManager.shared.currentLocale
            let decimalSeparator = locale.decimalSeparator ?? ","
            let groupingSeparator = locale.groupingSeparator ?? "."

            let cleanedAmount = amountText
                .replacingOccurrences(of: groupingSeparator, with: "")
                .replacingOccurrences(of: decimalSeparator, with: ".")

            guard let parsedAmount = Double(cleanedAmount),
                  parsedAmount >= AttorneyFeeConstants.minimumAmount else {
                errorMessage = LocalizationKeys.Validation.invalidAgreementAmount.localized
                isCalculating = false
                return
            }

            // Check maximum amount
            guard parsedAmount <= AttorneyFeeConstants.maximumAmount else {
                errorMessage = LocalizationKeys.Validation.Amount.max.localized
                isCalculating = false
                return
            }

            agreementAmount = parsedAmount
        }

        // Validate court type for non-monetary disputes
        if !isMonetary && selectedCourtType == nil {
            errorMessage = LocalizationKeys.Validation.missingCourtType.localized
            isCalculating = false
            return
        }

        // Create input
        let input = AttorneyFeeInput(
            isMonetary: isMonetary,
            hasAgreement: hasAgreement,
            agreementAmount: agreementAmount,
            courtType: selectedCourtType,
            tariffYear: selectedYear.rawValue
        )

        // Validate input
        let validation = input.validate()
        guard case .success = validation else {
            if case .failure(_, let message) = validation {
                errorMessage = message
            } else {
                errorMessage = LocalizationKeys.ErrorMessage.calculationFailed.localized
            }
            isCalculating = false
            return
        }

        // Perform calculation
        let result = AttorneyFeeCalculator.calculate(input: input)

        // Show result
        calculationResult = result
        isCalculating = false
        showResultSheet = true
    }

    /// Selects a court type
    /// - Parameter courtType: The court type to select
    func selectCourtType(_ courtType: AttorneyFeeConstants.CourtType) {
        selectedCourtType = courtType
    }

    /// Resets all inputs
    func reset() {
        amountText = ""
        selectedCourtType = nil
        calculationResult = nil
        errorMessage = nil
        showResultSheet = false
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
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension AttorneyFeeInputViewModel {
    static var monetaryPreview: AttorneyFeeInputViewModel {
        AttorneyFeeInputViewModel(selectedYear: .year2026, isMonetary: true, hasAgreement: true)
    }

    static var nonMonetaryPreview: AttorneyFeeInputViewModel {
        let vm = AttorneyFeeInputViewModel(selectedYear: .year2026, isMonetary: false, hasAgreement: true)
        vm.selectedCourtType = .civilPeace
        return vm
    }
}
#endif
