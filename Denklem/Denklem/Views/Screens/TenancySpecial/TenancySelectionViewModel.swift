//
//  TenancySelectionViewModel.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import SwiftUI
import Combine

// MARK: - Tenancy Selection ViewModel
/// ViewModel for TenancySelectionView - unified screen with segmented picker
/// Combines attorney fee and mediation fee calculation in a single view
/// Legal basis: Attorney Fee Tariff Art. 9/1, Mediation Fee Tariff Art. 7/5
@available(iOS 26.0, *)
@MainActor
final class TenancySelectionViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected tariff year
    @Published var selectedYear: TariffYear

    /// Selected fee mode (segmented picker)
    @Published var selectedFeeMode: TenancyCalculationConstants.TenancyFeeMode = .attorneyFee

    /// Checkbox selections
    @Published var isEvictionSelected: Bool = true
    @Published var isDeterminationSelected: Bool = false

    /// Input texts
    @Published var evictionAmountText: String = ""
    @Published var determinationAmountText: String = ""

    /// Result states - Attorney Fee
    @Published var showAttorneyResultSheet: Bool = false
    @Published var attorneyCalculationResult: TenancyAttorneyFeeResult?

    /// Result states - Mediation Fee
    @Published var showMediationResultSheet: Bool = false
    @Published var mediationCalculationResult: TenancyMediationFeeResult?

    /// Error state
    @Published var errorMessage: String?

    /// Loading state
    @Published var isCalculating: Bool = false

    // MARK: - Computed Properties

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.RentSpecial.selectionScreenTitle.localized
    }

    /// Available tariff years for selection
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    /// Fee modes for segmented picker
    var feeModes: [TenancyCalculationConstants.TenancyFeeMode] {
        TenancyCalculationConstants.TenancyFeeMode.allCases
    }

    /// Calculate button label
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Whether at least one checkbox is selected
    var hasSelection: Bool {
        isEvictionSelected || isDeterminationSelected
    }

    /// Whether calculate button should be enabled
    var isCalculateButtonEnabled: Bool {
        guard hasSelection else { return false }

        if isEvictionSelected {
            guard let amount = parseAmount(evictionAmountText),
                  amount >= TenancyCalculationConstants.Validation.minimumAmount else {
                return false
            }
        }

        if isDeterminationSelected {
            guard let amount = parseAmount(determinationAmountText),
                  amount >= TenancyCalculationConstants.Validation.minimumAmount else {
                return false
            }
        }

        return true
    }

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }

    // MARK: - Public Methods

    /// Toggle eviction checkbox
    func toggleEviction() {
        isEvictionSelected.toggle()
        if !isEvictionSelected {
            evictionAmountText = ""
        }
        errorMessage = nil
    }

    /// Toggle determination checkbox
    func toggleDetermination() {
        isDeterminationSelected.toggle()
        if !isDeterminationSelected {
            determinationAmountText = ""
        }
        errorMessage = nil
    }

    /// Switch fee mode via segmented picker
    func switchFeeMode(_ mode: TenancyCalculationConstants.TenancyFeeMode) {
        selectedFeeMode = mode
        errorMessage = nil
    }

    /// Calculate fee based on selected mode
    func calculate() {
        errorMessage = nil
        isCalculating = true

        // Build selected types
        var selectedTypes: Set<TenancyCalculationConstants.TenancyType> = []
        if isEvictionSelected { selectedTypes.insert(.eviction) }
        if isDeterminationSelected { selectedTypes.insert(.determination) }

        // Parse amounts
        let evictionAmount = isEvictionSelected ? parseAmount(evictionAmountText) : nil
        let determinationAmount = isDeterminationSelected ? parseAmount(determinationAmountText) : nil

        // Create input
        let input = TenancyCalculationInput(
            feeMode: selectedFeeMode,
            selectedTypes: selectedTypes,
            evictionAmount: evictionAmount,
            determinationAmount: determinationAmount,
            tariffYear: selectedYear
        )

        // Calculate with validation
        let result = TenancyCalculator.calculateWithValidation(input: input)

        switch result {
        case .success(let value):
            switch selectedFeeMode {
            case .attorneyFee:
                if let attorneyResult = value as? TenancyAttorneyFeeResult {
                    attorneyCalculationResult = attorneyResult
                    showAttorneyResultSheet = true
                }
            case .mediationFee:
                if let mediationResult = value as? TenancyMediationFeeResult {
                    mediationCalculationResult = mediationResult
                    showMediationResultSheet = true
                }
            }
        case .failure(let validation):
            errorMessage = validation.errorMessage
        }

        isCalculating = false
    }

    // MARK: - Amount Formatting

    /// Format amount input with locale-aware thousand separators
    func formatAmountInput(_ text: inout String) {
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        // Allow only digits, dots, and commas
        let filtered = text.filter { $0.isNumber || $0 == "." || $0 == "," }

        // Split by decimal separator
        let parts = filtered.components(separatedBy: decimalSeparator)
        var integerPart = parts[0]
        let decimalPart = parts.count > 1 ? String(parts[1].prefix(2)) : nil

        // Remove all separators from integer part
        integerPart = integerPart.replacingOccurrences(of: groupingSeparator, with: "")
        integerPart = integerPart.replacingOccurrences(of: decimalSeparator, with: "")

        // Format integer part with grouping
        if let number = Int(integerPart) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = locale
            formatter.maximumFractionDigits = 0
            integerPart = formatter.string(from: NSNumber(value: number)) ?? integerPart
        }

        // Rebuild
        if let decimal = decimalPart {
            text = integerPart + decimalSeparator + decimal
        } else if filtered.hasSuffix(decimalSeparator) {
            text = integerPart + decimalSeparator
        } else {
            text = integerPart
        }
    }

    // MARK: - Private Methods

    /// Parse amount string to Double with locale awareness
    private func parseAmount(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }

        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        var cleaned = trimmed.replacingOccurrences(of: groupingSeparator, with: "")
        cleaned = cleaned.replacingOccurrences(of: decimalSeparator, with: ".")

        return Double(cleaned)
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension TenancySelectionViewModel {
    static var preview: TenancySelectionViewModel {
        let vm = TenancySelectionViewModel(selectedYear: .year2026)
        vm.isEvictionSelected = true
        vm.isDeterminationSelected = true
        vm.evictionAmountText = "1.000.000"
        vm.determinationAmountText = "200.000"
        return vm
    }
}
#endif
