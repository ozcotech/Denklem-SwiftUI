//
//  AttorneyFeeViewModel.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI
import Combine

// MARK: - Attorney Fee Dispute Type
/// Dispute type options for attorney fee calculation
enum AttorneyFeeDisputeType: String, CaseIterable, Identifiable {
    case monetary           // Dispute with monetary subject
    case nonMonetary        // Dispute with non-monetary subject

    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .monetary:
            return LocalizationKeys.AttorneyFee.monetaryType.localized
        case .nonMonetary:
            return LocalizationKeys.AttorneyFee.nonMonetaryType.localized
        }
    }

    /// System image name
    var systemImage: String {
        switch self {
        case .monetary:
            return "turkishlirasign.circle.fill"
        case .nonMonetary:
            return "doc.text.fill"
        }
    }

    /// Icon color
    var iconColor: Color {
        switch self {
        case .monetary:
            return .green
        case .nonMonetary:
            return .blue
        }
    }
}

// MARK: - Attorney Fee Agreement Status
/// Agreement status options for attorney fee calculation
enum AttorneyFeeAgreementStatus: String, CaseIterable, Identifiable {
    case agreed             // Agreement
    case notAgreed          // No agreement

    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .agreed:
            return LocalizationKeys.AttorneyFee.agreed.localized
        case .notAgreed:
            return LocalizationKeys.AttorneyFee.notAgreed.localized
        }
    }

    /// System image name
    var systemImage: String {
        switch self {
        case .agreed:
            return "checkmark.circle.fill"
        case .notAgreed:
            return "xmark.circle.fill"
        }
    }

    /// Icon color
    var iconColor: Color {
        switch self {
        case .agreed:
            return .green
        case .notAgreed:
            return .red
        }
    }
}

// MARK: - Focus Field
/// Focus field enum for keyboard handling
enum AttorneyFeeFocusedField: Hashable {
    case amount
}

// MARK: - Attorney Fee ViewModel
/// Unified ViewModel combining type selection and input fields
/// Replaces AttorneyFeeTypeViewModel + AttorneyFeeInputViewModel
@available(iOS 26.0, *)
@MainActor
final class AttorneyFeeViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected tariff year
    @Published var selectedYear: TariffYear = .current

    /// Selected dispute type (Monetary/Non-Monetary)
    @Published var selectedDisputeType: AttorneyFeeDisputeType? = .monetary

    /// Selected agreement status (Agreement/No Agreement)
    @Published var selectedAgreementStatus: AttorneyFeeAgreementStatus? = .agreed

    /// Amount input (agreement amount or claim amount)
    @Published var amountText: String = ""

    /// Selected court type (for non-monetary agreement)
    @Published var selectedCourtType: AttorneyFeeConstants.CourtType?

    /// Show result sheet
    @Published var showResult: Bool = false

    /// Calculation result
    @Published var calculationResult: AttorneyFeeResult?

    /// Error message if calculation fails
    @Published var errorMessage: String?

    /// Loading state
    @Published var isCalculating: Bool = false

    // MARK: - Computed Properties

    /// Whether the dispute is monetary
    var isMonetary: Bool {
        selectedDisputeType == .monetary
    }

    /// Whether parties have reached an agreement
    var hasAgreement: Bool {
        selectedAgreementStatus == .agreed
    }

    /// Whether amount input should be visible (monetary disputes only)
    var showAmountInput: Bool {
        isMonetary && selectedDisputeType != nil && selectedAgreementStatus != nil
    }

    /// Whether court type picker should be visible (non-monetary + agreement)
    var showCourtTypePicker: Bool {
        !isMonetary && hasAgreement && selectedDisputeType != nil && selectedAgreementStatus != nil
    }

    /// Whether only the calculate button is needed (non-monetary + no agreement = fixed fee)
    var showCalculateOnly: Bool {
        !isMonetary && !hasAgreement && selectedDisputeType != nil && selectedAgreementStatus != nil
    }

    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        guard selectedDisputeType != nil, selectedAgreementStatus != nil else { return false }

        if isMonetary {
            // Monetary: always needs amount (agreement or claim)
            return !amountText.isEmpty
        } else if hasAgreement {
            // Non-monetary + agreement: needs court type
            return selectedCourtType != nil
        } else {
            // Non-monetary + no agreement: always enabled (fixed fee)
            return true
        }
    }

    /// Whether calculate button should be visible
    var showCalculateButton: Bool {
        selectedDisputeType != nil && selectedAgreementStatus != nil
    }

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.AttorneyFee.typeScreenTitle.localized
    }

    /// Available tariff years
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    /// Available court types
    var availableCourtTypes: [AttorneyFeeConstants.CourtType] {
        AttorneyFeeConstants.CourtType.allCases
    }

    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Amount input placeholder text
    var amountPlaceholder: String {
        if hasAgreement {
            return LocalizationKeys.Input.Placeholder.amount.localized
        } else {
            return LocalizationKeys.Input.Placeholder.claimAmount.localized
        }
    }

    /// Returns the tariff year as Int for calculations
    var tariffYearInt: Int {
        selectedYear.rawValue
    }

    // MARK: - Initialization

    init() {}

    // MARK: - Public Methods

    /// Formats currency input as user types
    func formatAmountInput() {
        AmountFormatter.format(&amountText)
    }

    /// Selects a court type
    func selectCourtType(_ courtType: AttorneyFeeConstants.CourtType) {
        selectedCourtType = courtType
    }

    /// Performs calculation and shows result
    func calculate() {
        errorMessage = nil
        isCalculating = true

        guard selectedDisputeType != nil, selectedAgreementStatus != nil else {
            isCalculating = false
            return
        }

        if !isMonetary && !hasAgreement {
            // Non-monetary + No Agreement: fixed fee (no input needed)
            calculateNoAgreementFixedFee()
            return
        }

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

            guard parsedAmount <= AttorneyFeeConstants.maximumAmount else {
                errorMessage = LocalizationKeys.Validation.Amount.max.localized
                isCalculating = false
                return
            }

            agreementAmount = parsedAmount
        }

        // Validate court type for non-monetary agreement
        if !isMonetary && hasAgreement && selectedCourtType == nil {
            errorMessage = LocalizationKeys.Validation.missingCourtType.localized
            isCalculating = false
            return
        }

        // Create input and calculate
        let input = AttorneyFeeInput(
            isMonetary: isMonetary,
            hasAgreement: hasAgreement,
            agreementAmount: agreementAmount,
            courtType: selectedCourtType,
            tariffYear: tariffYearInt
        )

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

        let result = AttorneyFeeCalculator.calculate(input: input)
        calculationResult = result
        isCalculating = false
        showResult = true
    }

    /// Resets all inputs
    func reset() {
        amountText = ""
        selectedCourtType = nil
        calculationResult = nil
        errorMessage = nil
        showResult = false
    }

    // MARK: - Private Methods

    /// Calculates fixed fee for non-monetary no-agreement cases
    private func calculateNoAgreementFixedFee() {
        let breakdown = AttorneyFeeBreakdown(
            baseAmount: nil,
            thirdPartFee: nil,
            bonusAmount: nil,
            courtType: nil,
            isMinimumApplied: true,
            isMaximumApplied: false
        )

        let fee = AttorneyFeeConstants.minimumAttorneyFee(for: tariffYearInt)

        calculationResult = AttorneyFeeResult(
            fee: fee,
            calculationType: .nonMonetaryNoAgreement,
            breakdown: breakdown,
            warnings: [],
            tariffYear: tariffYearInt
        )
        isCalculating = false
        showResult = true
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension AttorneyFeeViewModel {
    static var preview: AttorneyFeeViewModel {
        let vm = AttorneyFeeViewModel()
        vm.selectedDisputeType = .monetary
        vm.selectedAgreementStatus = .agreed
        return vm
    }
}
#endif
