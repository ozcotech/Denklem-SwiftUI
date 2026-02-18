//
//  MediationFeeViewModel.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI
import Combine

// MARK: - Agreement Selection Type
/// Agreement status options for mediation fee calculation
enum AgreementSelectionType: String, CaseIterable, Identifiable {
    case agreed          // Agreement reached
    case notAgreed       // Agreement not reached

    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .agreed:
            return LocalizationKeys.AgreementStatus.agreed.localized
        case .notAgreed:
            return LocalizationKeys.AgreementStatus.notAgreed.localized
        }
    }

    /// System image name
    var systemImage: String {
        switch self {
        case .agreed:
            return "checkmark"
        case .notAgreed:
            return "xmark"
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
enum MediationFeeFocusedField: Hashable {
    case amount
    case partyCount
}

// MARK: - Mediation Fee ViewModel
/// Unified ViewModel combining dispute type selection and input fields
/// Replaces DisputeTypeViewModel + InputViewModel
@available(iOS 26.0, *)
@MainActor
final class MediationFeeViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected tariff year
    @Published var selectedYear: TariffYear

    /// Whether the dispute is monetary
    @Published var isMonetary: Bool

    /// Selected agreement status (defaults to agreed for monetary disputes)
    @Published var selectedAgreement: AgreementSelectionType? = .agreed

    /// Selected dispute type from dropdown
    @Published var selectedDisputeType: DisputeType?

    /// Dispute amount input (for agreement cases)
    @Published var amountText: String = ""

    /// Party count input (for non-agreement cases)
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

    /// Whether parties have reached an agreement
    /// For non-monetary disputes, always false per Tariff Article 7, Paragraph 1
    var hasAgreement: Bool {
        if isMonetary {
            return selectedAgreement == .agreed
        }
        return false
    }

    /// Whether agreement selector should be visible
    var showAgreementSelector: Bool {
        return isMonetary
    }

    /// Whether amount input should be visible
    var showAmountInput: Bool {
        hasAgreement && selectedDisputeType != nil
    }

    /// Whether party count input should be visible
    var showPartyCountInput: Bool {
        !hasAgreement && selectedDisputeType != nil
    }

    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        guard selectedDisputeType != nil else { return false }
        if hasAgreement {
            return !amountText.isEmpty
        } else {
            return !partyCountText.isEmpty
        }
    }

    /// Available dispute types for selection
    var availableDisputeTypes: [DisputeType] {
        [
            .workerEmployer,
            .commercial,
            .consumer,
            .rent,
            .partnershipDissolution,
            .condominium,
            .neighbor,
            .agriculturalProduction,
            .family,
            .other
        ]
    }

    /// Available tariff years for selection
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.disputeType.localized
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

    // MARK: - Initialization

    init(selectedYear: TariffYear, isMonetary: Bool = true) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
    }

    /// Resets form fields when monetary/non-monetary mode changes
    func resetFormForModeChange() {
        selectedAgreement = isMonetary ? .agreed : nil
        selectedDisputeType = nil
        amountText = ""
        partyCountText = ""
        errorMessage = nil
        calculationResult = nil
        showResult = false
    }

    // MARK: - Public Methods

    /// Selects an agreement status and clears input when switching
    func selectAgreement(_ agreement: AgreementSelectionType) {
        let previousAgreement = selectedAgreement
        selectedAgreement = agreement

        // Clear input fields when switching agreement status
        if previousAgreement != agreement {
            amountText = ""
            partyCountText = ""
            errorMessage = nil
        }
    }

    /// Formats currency input as user types with locale-aware thousand separators and decimals
    func formatAmountInput() {
        AmountFormatter.format(&amountText)
    }

    /// Formats party count input as user types
    func formatPartyCountInput() {
        let filtered = partyCountText.filter { $0.isNumber }
        partyCountText = filtered
    }

    /// Performs calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true

        guard let selectedDisputeType else {
            isCalculating = false
            return
        }

        // Parse party count (only required for non-agreement cases)
        let partyCount: Int
        if hasAgreement {
            // Party count is irrelevant for agreement cases (Art. 7)
            partyCount = ValidationConstants.PartyCount.minimum
        } else {
            guard let parsed = Int(partyCountText), parsed >= ValidationConstants.PartyCount.minimum else {
                errorMessage = LocalizationKeys.Validation.invalidPartyCount.localized
                isCalculating = false
                return
            }
            partyCount = parsed
        }

        // Parse amount for agreement cases
        let amount: Double?
        if hasAgreement {
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
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension MediationFeeViewModel {
    static var preview: MediationFeeViewModel {
        MediationFeeViewModel(selectedYear: .year2026)
    }
}
#endif
