//
//  DisputeTypeViewModel.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI
import Combine

// MARK: - Agreement Selection Type
/// Agreement status options for calculation (moved from AgreementStatusViewModel)
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

// MARK: - Dispute Type ViewModel
/// ViewModel for DisputeTypeView - manages agreement status and dispute type selection
@available(iOS 26.0, *)
@MainActor
final class DisputeTypeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected tariff year from previous screens
    @Published var selectedYear: TariffYear
    
    /// Whether the dispute is monetary (determines if agreement selector is shown)
    @Published var isMonetary: Bool
    
    /// Selected agreement status (nil until user makes a selection for monetary disputes)
    @Published var selectedAgreement: AgreementSelectionType?
    
    /// Navigation flag for InputView
    @Published var navigateToInput: Bool = false
    
    /// Selected dispute type
    @Published var selectedDisputeType: DisputeType?
    
    // MARK: - Computed Properties
    
    /// Whether parties have reached an agreement
    /// For non-monetary disputes, always false per Tariff Article 7, Paragraph 1
    var hasAgreement: Bool {
        if isMonetary {
            return selectedAgreement == .agreed
        }
        return false
    }
    
    /// Whether dispute type buttons should be enabled
    /// For monetary disputes: enabled only after agreement selection
    /// For non-monetary disputes: always enabled
    var areDisputeTypesEnabled: Bool {
        if isMonetary {
            return selectedAgreement != nil
        }
        return true
    }
    
    /// Whether agreement selector should be visible
    var showAgreementSelector: Bool {
        return isMonetary
    }
    
    /// Available dispute types for selection
    /// Returns 10 dispute types for mediation fee calculation
    var availableDisputeTypes: [DisputeType] {
        [
            .rent,
            .workerEmployer,
            .condominium,
            .commercial,
            .neighbor,
            .consumer,
            .family,
            .partnershipDissolution,
            .agriculturalProduction,
            .other
        ]
    }
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.disputeType.localized
    }
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
    }
    
    // MARK: - Public Methods
    
    /// Selects an agreement status
    /// - Parameter agreement: The agreement status to select
    func selectAgreement(_ agreement: AgreementSelectionType) {
        selectedAgreement = agreement
    }
    
    /// Selects a dispute type and navigates to InputView
    /// - Parameter disputeType: The dispute type to select
    func selectDisputeType(_ disputeType: DisputeType) {
        guard areDisputeTypesEnabled else { return }
        selectedDisputeType = disputeType
        navigateToInput = true
    }
    
    /// Validates dispute type selection
    func validateSelection() -> Bool {
        if isMonetary && selectedAgreement == nil {
            return false
        }
        return selectedDisputeType != nil
    }
    
    /// Resets selection state
    func resetSelection() {
        selectedAgreement = nil
        selectedDisputeType = nil
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension DisputeTypeViewModel {
    static var preview: DisputeTypeViewModel {
        DisputeTypeViewModel(selectedYear: .year2025, isMonetary: true)
    }
    
    static var nonMonetaryPreview: DisputeTypeViewModel {
        DisputeTypeViewModel(selectedYear: .year2025, isMonetary: false)
    }
}
#endif
