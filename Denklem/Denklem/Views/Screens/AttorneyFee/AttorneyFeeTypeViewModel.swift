//
//  AttorneyFeeTypeViewModel.swift
//  Denklem
//
//  Created by ozkan on 28.01.2026.
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

// MARK: - Attorney Fee Type ViewModel
/// ViewModel for AttorneyFeeTypeView - manages dispute type and agreement status selection
@available(iOS 26.0, *)
@MainActor
final class AttorneyFeeTypeViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Selected tariff year - defaults to current year (2026)
    @Published var selectedYear: TariffYear = .current

    /// Selected dispute type (Monetary/Non-Monetary) - defaults to monetary for faster user flow
    @Published var selectedDisputeType: AttorneyFeeDisputeType? = .monetary

    /// Selected agreement status (Agreement/No Agreement) - defaults to agreed for faster user flow
    @Published var selectedAgreementStatus: AttorneyFeeAgreementStatus? = .agreed

    /// Navigation flag for AttorneyFeeInputView
    @Published var navigateToInput: Bool = false

    /// Flag to show result sheet directly (for no agreement cases)
    @Published var showResultSheet: Bool = false

    /// Calculation result for no agreement cases (year-specific fixed fee)
    @Published var noAgreementResult: AttorneyFeeResult?

    // MARK: - Computed Properties

    /// Screen title
    var screenTitle: String {
        LocalizationKeys.AttorneyFee.typeScreenTitle.localized
    }

    /// Available tariff years for selection
    var availableYears: [TariffYear] {
        TariffYear.allCases
    }

    /// Whether the continue button should be enabled
    var canProceed: Bool {
        selectedDisputeType != nil && selectedAgreementStatus != nil
    }

    /// Whether parties have reached an agreement
    var hasAgreement: Bool {
        selectedAgreementStatus == .agreed
    }

    /// Whether the dispute is monetary
    var isMonetary: Bool {
        selectedDisputeType == .monetary
    }

    /// Returns the tariff year as Int for calculations
    var tariffYearInt: Int {
        selectedYear.rawValue
    }

    // MARK: - Initialization

    init() {}

    // MARK: - Public Methods

    /// Selects a dispute type
    /// - Parameter type: The dispute type to select
    func selectDisputeType(_ type: AttorneyFeeDisputeType) {
        selectedDisputeType = type
    }

    /// Selects an agreement status
    /// - Parameter status: The agreement status to select
    func selectAgreementStatus(_ status: AttorneyFeeAgreementStatus) {
        selectedAgreementStatus = status
    }

    /// Handles the continue button action
    /// Navigates to input view for agreement cases and monetary no-agreement cases
    /// Shows result sheet directly only for non-monetary no-agreement cases
    func handleContinue() {
        guard canProceed else { return }

        if hasAgreement {
            // Navigate to input view for amount/court selection
            navigateToInput = true
        } else if isMonetary {
            // Monetary + No Agreement: navigate to input view for claim amount
            // Per tariff Art.16/c: fee cannot exceed the claim amount
            navigateToInput = true
        } else {
            // Non-monetary + No Agreement: show fixed fee directly
            calculateNoAgreementResult()
            showResultSheet = true
        }
    }

    /// Resets selection state
    func resetSelection() {
        selectedDisputeType = nil
        selectedAgreementStatus = nil
        navigateToInput = false
        showResultSheet = false
        noAgreementResult = nil
    }

    // MARK: - Private Methods

    /// Calculates the result for non-monetary no agreement cases (year-specific fixed fee: 7.000 TL for 2025, 8.000 TL for 2026)
    /// Monetary no-agreement cases are now handled via InputView + AttorneyFeeCalculator
    private func calculateNoAgreementResult() {
        let breakdown = AttorneyFeeBreakdown(
            baseAmount: nil,
            thirdPartFee: nil,
            bonusAmount: nil,
            courtType: nil,
            isMinimumApplied: true,
            isMaximumApplied: false
        )

        // Use year-specific minimum fee
        let fee = AttorneyFeeConstants.minimumAttorneyFee(for: tariffYearInt)

        noAgreementResult = AttorneyFeeResult(
            fee: fee,
            calculationType: .nonMonetaryNoAgreement,
            breakdown: breakdown,
            warnings: [],
            tariffYear: tariffYearInt
        )
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension AttorneyFeeTypeViewModel {
    static var preview: AttorneyFeeTypeViewModel {
        let vm = AttorneyFeeTypeViewModel()
        vm.selectedDisputeType = .monetary
        vm.selectedAgreementStatus = .agreed
        return vm
    }

    static var noAgreementPreview: AttorneyFeeTypeViewModel {
        let vm = AttorneyFeeTypeViewModel()
        vm.selectedDisputeType = .nonMonetary
        vm.selectedAgreementStatus = .notAgreed
        return vm
    }
}
#endif
