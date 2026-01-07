//
//  AgreementStatusViewModel.swift
//  Denklem
//
//  Created by ozkan on 05.01.2026.
//

import SwiftUI
import Combine

// MARK: - Agreement Status Type
/// Agreement status options for calculation routing
enum AgreementStatusType: String, CaseIterable, Identifiable {
    case agreed          // Anlaşma
    case notAgreed       // Anlaşmama
    
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
    
    /// Localized description
    var description: String {
        switch self {
        case .agreed:
            return LocalizationKeys.AgreementStatus.Description.agreed.localized
        case .notAgreed:
            return LocalizationKeys.AgreementStatus.Description.notAgreed.localized
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

// MARK: - Agreement Status ViewModel
/// ViewModel for AgreementStatusView - manages agreement status selection and navigation
@available(iOS 26.0, *)
@MainActor
final class AgreementStatusViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected tariff year from previous screen
    @Published var selectedYear: TariffYear
    
    /// Whether the dispute is monetary (from DisputeCategoryView)
    @Published var isMonetary: Bool
    
    /// Navigation flag for DisputeTypeView
    @Published var navigateToDisputeType: Bool = false
    
    /// Selected agreement status
    @Published var selectedStatus: AgreementStatusType?
    
    /// Whether options are expanded (for morphing animation)
    @Published var showOptions: Bool = false
    
    // MARK: - Computed Properties
    
    /// Available agreement status options
    var availableStatuses: [AgreementStatusType] {
        AgreementStatusType.allCases
    }
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.ScreenTitle.agreementStatus.localized
    }
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool) {
        self.selectedYear = selectedYear
        self.isMonetary = isMonetary
    }
    
    // MARK: - Public Methods
    
    /// Toggles the options visibility with animation
    func toggleOptions() {
        showOptions.toggle()
    }
    
    /// Selects an agreement status and navigates to DisputeTypeView
    /// - Parameter status: The agreement status to select
    func selectStatus(_ status: AgreementStatusType) {
    selectedStatus = status
    navigateToDisputeType = true
    }
    
    /// Validates status selection
    func validateSelection() -> Bool {
        return selectedStatus != nil
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension AgreementStatusViewModel {
    static var preview: AgreementStatusViewModel {
        AgreementStatusViewModel(selectedYear: .year2025, isMonetary: true)
    }
}
#endif
