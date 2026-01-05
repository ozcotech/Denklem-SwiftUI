//
//  DisputeTypeViewModel.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI
import Combine

// MARK: - Dispute Type ViewModel
/// ViewModel for DisputeTypeView - manages dispute type selection and navigation
@available(iOS 26.0, *)
@MainActor
final class DisputeTypeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected tariff year from previous screens
    @Published var selectedYear: TariffYear
    
    /// Whether the dispute is monetary (from DisputeCategoryView)
    @Published var isMonetary: Bool
    
    /// Whether parties have reached an agreement (from AgreementStatusView)
    @Published var hasAgreement: Bool
    
    /// Navigation flag for InputView
    @Published var navigateToInput: Bool = false
    
    /// Selected dispute type
    @Published var selectedDisputeType: DisputeType?
    
    // MARK: - Computed Properties
    
    /// Available dispute types for selection
    /// Returns 9 main dispute types (excludes agriculturalProduction which is time-specific)
    var availableDisputeTypes: [DisputeType] {
        [
            .workerEmployer,
            .commercial,
            .consumer,
            .rent,
            .neighbor,
            .condominium,
            .family,
            .partnershipDissolution,
            .other
        ]
    }
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.disputeType.localized
    }
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool, hasAgreement: Bool) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
        self.hasAgreement = hasAgreement
    }
    
    // MARK: - Public Methods
    
    /// Selects a dispute type and navigates to InputView
    /// - Parameter disputeType: The dispute type to select
    func selectDisputeType(_ disputeType: DisputeType) {
        selectedDisputeType = disputeType
        // Small delay to show selection before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigateToInput = true
        }
    }
    
    /// Validates dispute type selection
    func validateSelection() -> Bool {
        return selectedDisputeType != nil
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension DisputeTypeViewModel {
    static var preview: DisputeTypeViewModel {
        DisputeTypeViewModel(selectedYear: .year2025, isMonetary: true, hasAgreement: true)
    }
}
#endif
