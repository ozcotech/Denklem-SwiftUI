//
//  SerialDisputesViewModel.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import SwiftUI
import Combine

// MARK: - Serial Disputes ViewModel
/// ViewModel for SerialDisputesSheet - manages input state and calculation
@available(iOS 26.0, *)
@MainActor
final class SerialDisputesViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected dispute type (commercial or non-commercial)
    @Published var selectedDisputeType: SerialDisputesConstants.DisputeType = .commercial

    /// File count input
    @Published var fileCountText: String = ""

    /// Show result view
    @Published var showResult: Bool = false

    /// Calculation result
    @Published var calculationResult: SerialDisputesResult?

    /// Error message if validation fails
    @Published var errorMessage: String?

    /// Loading state
    @Published var isCalculating: Bool = false

    // MARK: - Published Properties (continued)

    /// Selected tariff year (can be changed via dropdown)
    @Published var selectedYear: TariffYear

    // MARK: - Computed Properties

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.SerialDisputes.screenTitle.localized
    }

    /// Calculate button text
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Whether calculate button is enabled
    var isCalculateButtonEnabled: Bool {
        guard let fileCount = Int(fileCountText) else { return false }
        return fileCount >= SerialDisputesConstants.Validation.minimumFileCount
    }

    /// Available dispute types for selection
    var availableDisputeTypes: [SerialDisputesConstants.DisputeType] {
        SerialDisputesConstants.DisputeType.allCases
    }

    /// Available tariff years for selection
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    /// Dispute type section title
    var disputeTypeSectionTitle: String {
        LocalizationKeys.SerialDisputes.selectDisputeType.localized
    }

    /// File count section title
    var fileCountSectionTitle: String {
        LocalizationKeys.SerialDisputes.fileCount.localized
    }

    /// File count placeholder
    var fileCountPlaceholder: String {
        LocalizationKeys.SerialDisputes.fileCountPlaceholder.localized
    }

    /// File count hint
    var fileCountHint: String {
        LocalizationKeys.SerialDisputes.fileCountHint.localized
    }

    /// Current year display
    var currentYearDisplay: String {
        selectedYear.displayName
    }

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }

    // MARK: - Public Methods

    /// Performs calculation and shows result
    func calculate() {
        // Clear previous error
        errorMessage = nil
        isCalculating = true

        // Parse file count
        guard let fileCount = Int(fileCountText) else {
            errorMessage = LocalizationKeys.Validation.invalidFileCount.localized
            isCalculating = false
            return
        }

        // Create input
        let input = SerialDisputesInput(
            disputeType: selectedDisputeType,
            fileCount: fileCount,
            tariffYear: selectedYear.rawValue
        )

        // Validate input
        let validationResult = SerialDisputesCalculator.calculateWithValidation(input: input)

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

    /// Selects a dispute type
    /// - Parameter disputeType: The dispute type to select
    func selectDisputeType(_ disputeType: SerialDisputesConstants.DisputeType) {
        selectedDisputeType = disputeType
    }

    /// Resets all inputs
    func reset() {
        fileCountText = ""
        selectedDisputeType = .commercial
        calculationResult = nil
        errorMessage = nil
        showResult = false
    }

    /// Formats file count input - only allows numeric characters
    func formatFileCountInput() {
        // Keep only digits
        let cleaned = fileCountText.filter { $0.isNumber }

        // Limit to maximum allowed digits (4 digits for max 1000)
        let limited = String(cleaned.prefix(4))

        // Update if changed
        if fileCountText != limited {
            fileCountText = limited
        }
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension SerialDisputesViewModel {
    /// Creates a preview instance for 2026
    static var preview2026: SerialDisputesViewModel {
        SerialDisputesViewModel(selectedYear: .year2026)
    }

    /// Creates a preview instance for 2025
    static var preview2025: SerialDisputesViewModel {
        SerialDisputesViewModel(selectedYear: .year2025)
    }

    /// Creates a preview instance with sample data
    static var previewWithData: SerialDisputesViewModel {
        let vm = SerialDisputesViewModel(selectedYear: .year2026)
        vm.selectedDisputeType = .commercial
        vm.fileCountText = "5"
        return vm
    }

    /// Creates a preview instance with result
    static var previewWithResult: SerialDisputesViewModel {
        let vm = SerialDisputesViewModel(selectedYear: .year2026)
        vm.selectedDisputeType = .commercial
        vm.fileCountText = "5"
        vm.calculationResult = SerialDisputesCalculator.calculate(
            disputeType: .commercial,
            fileCount: 5,
            tariffYear: .year2026
        )
        vm.showResult = true
        return vm
    }
}
#endif
