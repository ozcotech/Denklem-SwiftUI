//
//  ReinstatementViewModel.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import SwiftUI
import Combine

// MARK: - Reinstatement ViewModel
/// ViewModel for ReinstatementSheet - manages input state and calculation
/// Legal basis: Labor Courts Law Art. 3/13-2, Labor Law Art. 20-2, Art. 21/7
@available(iOS 26.0, *)
@MainActor
final class ReinstatementViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected agreement status (nil = not selected yet)
    @Published var selectedAgreementStatus: AgreementStatus?

    /// Non-reinstatement compensation input (İşe başlatılmama tazminatı)
    @Published var compensationText: String = ""

    /// Idle period wage input (Boşta geçen süre ücreti)
    @Published var idleWageText: String = ""

    /// Other rights input (Diğer haklar - optional)
    @Published var otherRightsText: String = ""

    /// Party count input
    @Published var partyCountText: String = ""

    /// Selected tariff year
    @Published var selectedYear: TariffYear

    /// Show result view
    @Published var showResult: Bool = false

    /// Calculation result
    @Published var calculationResult: ReinstatementResult?

    /// Error message if validation fails
    @Published var errorMessage: String?

    /// Loading state
    @Published var isCalculating: Bool = false

    // MARK: - Computed Properties - Localized Strings

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.Reinstatement.screenTitle.localized
    }

    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Agreement status section title
    var agreementStatusSectionTitle: String {
        LocalizationKeys.Reinstatement.selectAgreementStatus.localized
    }

    /// Compensation field label
    var compensationLabel: String {
        LocalizationKeys.Reinstatement.nonReinstatementCompensation.localized
    }

    /// Compensation hint
    var compensationHint: String {
        LocalizationKeys.Reinstatement.nonReinstatementCompensationHint.localized
    }

    /// Idle wage field label
    var idleWageLabel: String {
        LocalizationKeys.Reinstatement.idlePeriodWage.localized
    }

    /// Idle wage hint
    var idleWageHint: String {
        LocalizationKeys.Reinstatement.idlePeriodWageHint.localized
    }

    /// Other rights field label
    var otherRightsLabel: String {
        LocalizationKeys.Reinstatement.otherRightsTotal.localized
    }

    /// Other rights hint
    var otherRightsHint: String {
        LocalizationKeys.Reinstatement.otherRightsHint.localized
    }

    /// Party count field label
    var partyCountLabel: String {
        LocalizationKeys.Reinstatement.partyCount.localized
    }

    /// Party count hint
    var partyCountHint: String {
        LocalizationKeys.Reinstatement.partyCountHint.localized
    }

    // MARK: - Computed Properties - Validation

    /// Whether agreement status is selected
    var isAgreementStatusSelected: Bool {
        selectedAgreementStatus != nil
    }

    /// Whether it's an agreement case
    var isAgreedCase: Bool {
        selectedAgreementStatus == .agreed
    }

    /// Whether it's a no agreement case
    var isNotAgreedCase: Bool {
        selectedAgreementStatus == .notAgreed
    }

    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        guard let agreementStatus = selectedAgreementStatus else { return false }

        if agreementStatus == .agreed {
            // Agreement case needs compensation and idle wage (party count not needed)
            guard let compensation = parseAmount(compensationText),
                  compensation >= ReinstatementConstants.Validation.minimumAmount,
                  let idleWage = parseAmount(idleWageText),
                  idleWage >= ReinstatementConstants.Validation.minimumAmount else {
                return false
            }
        } else {
            // Non-agreement case needs party count
            guard let partyCount = Int(partyCountText),
                  partyCount >= ReinstatementConstants.Validation.minimumPartyCount else {
                return false
            }
        }

        return true
    }

    /// Available tariff years
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }

    // MARK: - Public Methods

    /// Selects agreement status and resets inputs
    func selectAgreementStatus(_ status: AgreementStatus) {
        selectedAgreementStatus = status
        errorMessage = nil

        // Reset calculation result when changing status
        calculationResult = nil
        showResult = false
    }

    /// Performs calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true

        guard let agreementStatus = selectedAgreementStatus else {
            errorMessage = LocalizationKeys.AgreementStatus.selectPrompt.localized
            isCalculating = false
            return
        }

        // Create input based on agreement status
        let input: ReinstatementInput

        if agreementStatus == .agreed {
            // Parse amounts for agreement case (party count not needed)
            guard let compensation = parseAmount(compensationText) else {
                errorMessage = LocalizationKeys.Validation.invalidAmount.localized
                isCalculating = false
                return
            }

            guard let idleWage = parseAmount(idleWageText) else {
                errorMessage = LocalizationKeys.Validation.invalidAmount.localized
                isCalculating = false
                return
            }

            let otherRights = parseAmount(otherRightsText)

            input = ReinstatementInput.agreement(
                tariffYear: selectedYear,
                partyCount: ReinstatementConstants.Validation.minimumPartyCount,
                nonReinstatementCompensation: compensation,
                idlePeriodWage: idleWage,
                otherRights: otherRights
            )
        } else {
            // No agreement case - party count required
            guard let partyCount = Int(partyCountText) else {
                errorMessage = LocalizationKeys.Validation.invalidPartyCount.localized
                isCalculating = false
                return
            }

            input = ReinstatementInput.noAgreement(
                tariffYear: selectedYear,
                partyCount: partyCount
            )
        }

        // Validate and calculate
        let validationResult = ReinstatementCalculator.calculateWithValidation(input: input)

        switch validationResult {
        case .success(let result):
            calculationResult = result
            isCalculating = false
            showResult = true

        case .failure(let validation):
            errorMessage = validation.errorMessage ?? LocalizationKeys.ErrorMessage.calculationFailed.localized
            isCalculating = false
        }
    }

    /// Resets all inputs and state
    func reset() {
        selectedAgreementStatus = nil
        compensationText = ""
        idleWageText = ""
        otherRightsText = ""
        partyCountText = ""
        calculationResult = nil
        errorMessage = nil
        showResult = false
    }

    /// Resets for recalculation (keeps agreement status)
    func recalculate() {
        showResult = false
        calculationResult = nil
        errorMessage = nil
    }

    // MARK: - Input Formatting

    /// Formats currency input as user types with locale-aware thousand separators and decimals
    func formatAmountInput(_ text: inout String) {
        // Get locale separators
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        // Step 1: Keep only digits, dots, and commas
        var cleaned = String(text.unicodeScalars.filter {
            CharacterSet.decimalDigits.contains($0) || $0 == "." || $0 == ","
        })

        // Step 2: Find ONLY the locale's decimal separator - not just any separator
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
            text = ""
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
                if text != newValue {
                    text = newValue
                }
            }
        } else if cleaned == decimalSeparator {
            // If user just types decimal separator
            let newValue = "0" + decimalSeparator
            if text != newValue {
                text = newValue
            }
        }
    }

    /// Formats party count input - only allows numeric characters
    func formatPartyCountInput() {
        let cleaned = partyCountText.filter { $0.isNumber }
        let limited = String(cleaned.prefix(4))

        if partyCountText != limited {
            partyCountText = limited
        }
    }

    // MARK: - Private Methods

    /// Parses amount string to Double with locale awareness
    private func parseAmount(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }

        // Remove formatting and parse with locale awareness
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        let cleanedAmount = trimmed
            .replacingOccurrences(of: groupingSeparator, with: "")
            .replacingOccurrences(of: decimalSeparator, with: ".")

        return Double(cleanedAmount)
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension ReinstatementViewModel {

    /// Creates a preview instance for 2026
    static var preview2026: ReinstatementViewModel {
        ReinstatementViewModel(selectedYear: .year2026)
    }

    /// Creates a preview instance for 2025
    static var preview2025: ReinstatementViewModel {
        ReinstatementViewModel(selectedYear: .year2025)
    }

    /// Creates a preview instance with agreement status selected
    static var previewAgreed: ReinstatementViewModel {
        let vm = ReinstatementViewModel(selectedYear: .year2026)
        vm.selectedAgreementStatus = .agreed
        vm.compensationText = "100000"
        vm.idleWageText = "50000"
        vm.otherRightsText = "10000"
        vm.partyCountText = "2"
        return vm
    }

    /// Creates a preview instance for no agreement
    static var previewNotAgreed: ReinstatementViewModel {
        let vm = ReinstatementViewModel(selectedYear: .year2026)
        vm.selectedAgreementStatus = .notAgreed
        vm.partyCountText = "2"
        return vm
    }

    /// Creates a preview instance with agreement result
    static var previewWithAgreementResult: ReinstatementViewModel {
        let vm = ReinstatementViewModel(selectedYear: .year2026)
        vm.selectedAgreementStatus = .agreed
        vm.compensationText = "100000"
        vm.idleWageText = "50000"
        vm.otherRightsText = "10000"
        vm.partyCountText = "2"
        vm.calculationResult = ReinstatementCalculator.calculateAgreed(
            tariffYear: .year2026,
            partyCount: 2,
            nonReinstatementCompensation: 100_000,
            idlePeriodWage: 50_000,
            otherRights: 10_000
        )
        vm.showResult = true
        return vm
    }

    /// Creates a preview instance with no agreement result
    static var previewWithNoAgreementResult: ReinstatementViewModel {
        let vm = ReinstatementViewModel(selectedYear: .year2026)
        vm.selectedAgreementStatus = .notAgreed
        vm.partyCountText = "2"
        vm.calculationResult = ReinstatementCalculator.calculateNotAgreed(
            tariffYear: .year2026,
            partyCount: 2
        )
        vm.showResult = true
        return vm
    }
}
#endif
