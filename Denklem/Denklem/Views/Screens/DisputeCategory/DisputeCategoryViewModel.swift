//
//  DisputeCategoryViewModel.swift
//  Denklem
//
//  Created by ozkan on 01.01.2026.
//

import SwiftUI
import Combine

// MARK: - Dispute Category Enum
/// Main dispute categories for calculation routing
enum DisputeCategoryType: String, CaseIterable, Identifiable {
    case monetary          // The subject is monetary (legacy, used in result sheets)
    case nonMonetary       // The subject is non-monetary (legacy, used in result sheets)
    case mediationFee      // Unified mediation fee button
    case timeCalculation   // Time calculation
    case smmCalculation    // SMM calculation
    case attorneyFee       // Attorney fee calculation (special)
    case rentSpecial       // Tenancy (eviction/determination)
    case reinstatement     // Reinstate Employee (İşe İade)
    case serialDisputes    // Serial disputes (Seri Uyuşmazlıklar)
    case aiChat            // AI Chat (Aktif Zeka)

    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .monetary:
            return LocalizationKeys.DisputeCategory.monetary.localized
        case .nonMonetary:
            return LocalizationKeys.DisputeCategory.nonMonetary.localized
        case .mediationFee:
            return LocalizationKeys.DisputeCategory.mediationFee.localized
        case .timeCalculation:
            return LocalizationKeys.DisputeCategory.timeCalculation.localized
        case .smmCalculation:
            return LocalizationKeys.DisputeCategory.smmCalculation.localized
        case .attorneyFee:
            return LocalizationKeys.DisputeCategory.attorneyFee.localized
        case .rentSpecial:
            return LocalizationKeys.DisputeCategory.rentSpecial.localized
        case .reinstatement:
            return LocalizationKeys.DisputeCategory.reinstatement.localized
        case .serialDisputes:
            return LocalizationKeys.DisputeCategory.serialDisputes.localized
        case .aiChat:
            return LocalizationKeys.DisputeCategory.aiChat.localized
        }
    }

    /// Localized description
    var description: String {
        switch self {
        case .monetary:
            return LocalizationKeys.DisputeCategory.monetaryDescription.localized
        case .nonMonetary:
            return LocalizationKeys.DisputeCategory.nonMonetaryDescription.localized
        case .mediationFee:
            return LocalizationKeys.DisputeCategory.mediationFeeDescription.localized
        case .timeCalculation:
            return LocalizationKeys.DisputeCategory.timeCalculationDescription.localized
        case .smmCalculation:
            return LocalizationKeys.DisputeCategory.smmCalculationDescription.localized
        case .attorneyFee:
            return LocalizationKeys.DisputeCategory.attorneyFeeDescription.localized
        case .rentSpecial:
            return LocalizationKeys.DisputeCategory.rentSpecialDescription.localized
        case .reinstatement:
            return LocalizationKeys.DisputeCategory.reinstatementDescription.localized
        case .serialDisputes:
            return LocalizationKeys.DisputeCategory.serialDisputesDescription.localized
        case .aiChat:
            return LocalizationKeys.DisputeCategory.aiChatDescription.localized
        }
    }

    /// System image name
    var systemImage: String {
        switch self {
        case .monetary:
            return "turkishlirasign.circle.fill"
        case .nonMonetary:
            return "document.circle.fill"
        case .mediationFee:
            return "plusminus.circle.fill"
        case .timeCalculation:
            return "calendar.circle.fill"
        case .smmCalculation:
            return "newspaper.circle.fill"
        case .attorneyFee:
            return "person.circle.fill"
        case .rentSpecial:
            return "building.2.crop.circle.fill"
        case .reinstatement:
            return "arrow.trianglehead.2.clockwise.rotate.90.circle"
        case .serialDisputes:
            return "rectangle.stack.fill"
        case .aiChat:
            return "lock.fill" // Placeholder - using lock to indicate "coming soon" status, as AI Chat is not yet available. Before icon was plus.circle.
        }
    }

    /// Icon color
    var iconColor: Color {
        switch self {
        case .monetary:
            return .green
        case .nonMonetary:
            return .blue
        case .mediationFee:
            return .blue
        case .timeCalculation:
            return .orange
        case .smmCalculation:
            return .purple
        case .attorneyFee:
            return .indigo
        case .rentSpecial:
            return .teal
        case .reinstatement:
            return .yellow
        case .serialDisputes:
            return .pink
        case .aiChat:
            return .red // Coming soon - using red for attention, before color was cyan.
        }
    }
}

// MARK: - Dispute Category ViewModel
/// ViewModel for DisputeCategoryView - manages category selection and navigation
@available(iOS 26.0, *)
@MainActor
final class DisputeCategoryViewModel: ObservableObject {

        // MARK: - Special Calculations Section
        @Published var navigateToAttorneyFee: Bool = false
        @Published var navigateToTenancySpecial: Bool = false
        @Published var showSerialDisputesSheet: Bool = false
        @Published var showReinstatementSheet: Bool = false
        @Published var showComingSoonPopover: Bool = false

        var specialCalculations: [DisputeCategoryType] {
            return [.rentSpecial, .attorneyFee, .reinstatement, .serialDisputes, .smmCalculation, .timeCalculation]
        }

        var specialCalculationsTitle: String {
            LocalizationKeys.DisputeCategory.specialCalculations.localized
        }
    
    // MARK: - Published Properties
    
    /// Selected tariff year from StartScreen
    @Published var selectedYear: TariffYear
    
    /// Navigation flags
    @Published var navigateToDisputeType: Bool = false
    @Published var navigateToTimeCalculation: Bool = false
    @Published var navigateToSMMCalculation: Bool = false
    
    /// Selected category for navigation
    @Published var selectedCategory: DisputeCategoryType?
    
    /// Is monetary dispute (determines if agreement selector shows in DisputeType)
    @Published var isMonetary: Bool = false
    
    // MARK: - Computed Properties
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.DisputeCategory.title.localized
    }

    /// Screen subtitle
    var screenSubtitle: String {
        LocalizationKeys.DisputeCategory.subtitle.localized
    }

    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }
    
    // MARK: - Public Methods
    
    /// Selects a dispute category and triggers navigation
    /// - Parameter category: The selected dispute category
    func selectCategory(_ category: DisputeCategoryType) {
        selectedCategory = category

        switch category {
        case .mediationFee:
            // Unified mediation fee - defaults to monetary, user picks via segmented picker
            navigateToDisputeType = true

        case .monetary:
            // Legacy - kept for compatibility
            isMonetary = true
            navigateToDisputeType = true

        case .nonMonetary:
            // Legacy - kept for compatibility
            isMonetary = false
            navigateToDisputeType = true

        case .timeCalculation:
            navigateToTimeCalculation = true
            
        case .smmCalculation:
            navigateToSMMCalculation = true
        case .attorneyFee:
            navigateToAttorneyFee = true
        case .serialDisputes:
            showSerialDisputesSheet = true
        case .reinstatement:
            showReinstatementSheet = true
        case .rentSpecial:
            navigateToTenancySpecial = true
        case .aiChat:
            showComingSoonPopover = true
        }
    }
    
    /// Returns category for index (for UI grid layout)
    /// - Parameter index: Index in the grid
    /// - Returns: Category at index or nil
    func category(at index: Int, in section: [DisputeCategoryType]) -> DisputeCategoryType? {
        guard index < section.count else { return nil }
        return section[index]
    }
    
    /// Resets navigation state
    func resetNavigation() {
        navigateToDisputeType = false
        navigateToTimeCalculation = false
        navigateToSMMCalculation = false
        navigateToAttorneyFee = false
        navigateToTenancySpecial = false
        showSerialDisputesSheet = false
        showReinstatementSheet = false
        selectedCategory = nil
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension DisputeCategoryViewModel {
    /// Creates a preview instance
    static var preview: DisputeCategoryViewModel {
        return DisputeCategoryViewModel(selectedYear: .year2025)
    }
}
#endif
