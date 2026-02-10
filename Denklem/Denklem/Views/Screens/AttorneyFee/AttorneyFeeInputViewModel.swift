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
        if isMonetary && !hasAgreement {
            return LocalizationKeys.AttorneyFee.claimAmount.localized
        } else if isMonetary {
            return LocalizationKeys.AttorneyFee.agreementAmount.localized
        } else {
            return LocalizationKeys.AttorneyFee.selectCourt.localized
        }
    }

    /// Amount input placeholder text
    var amountPlaceholder: String {
        if hasAgreement {
            return LocalizationKeys.Input.Placeholder.amount.localized
        } else {
            return LocalizationKeys.Input.Placeholder.claimAmount.localized
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
        AmountFormatter.format(&amountText)
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
