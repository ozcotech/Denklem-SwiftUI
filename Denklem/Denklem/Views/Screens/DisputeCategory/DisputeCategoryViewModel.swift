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
    case monetary          // The subject is monetary
    case nonMonetary       // The subject is non-monetary
    case timeCalculation   // Time calculation
    case smmCalculation    // SMM calculation
    case attorneyFee       // Attorney fee calculation (special)
    case rentSpecial       // Tenancy (eviction/determination) (future)
    
    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .monetary:
            return LocalizationKeys.DisputeCategory.monetary.localized
        case .nonMonetary:
            return LocalizationKeys.DisputeCategory.nonMonetary.localized
        case .timeCalculation:
            return LocalizationKeys.DisputeCategory.timeCalculation.localized
        case .smmCalculation:
            return LocalizationKeys.DisputeCategory.smmCalculation.localized
        case .attorneyFee:
            return LocalizationKeys.DisputeCategory.attorneyFee.localized
        case .rentSpecial:
            return LocalizationKeys.DisputeCategory.rentSpecial.localized
        }
    }

    /// Localized description
    var description: String {
        switch self {
        case .monetary:
            return LocalizationKeys.DisputeCategory.monetaryDescription.localized
        case .nonMonetary:
            return LocalizationKeys.DisputeCategory.nonMonetaryDescription.localized
        case .timeCalculation:
            return LocalizationKeys.DisputeCategory.timeCalculationDescription.localized
        case .smmCalculation:
            return LocalizationKeys.DisputeCategory.smmCalculationDescription.localized
        case .attorneyFee:
            return LocalizationKeys.DisputeCategory.attorneyFeeDescription.localized
        case .rentSpecial:
            return LocalizationKeys.DisputeCategory.rentSpecialDescription.localized
        }
    }

    /// System image name
    var systemImage: String {
        switch self {
        case .monetary:
            return "turkishlirasign.circle.fill"
        case .nonMonetary:
            return "document.circle.fill"
        case .timeCalculation:
            return "clock.circle.fill"
        case .smmCalculation:
            return "newspaper.circle.fill"
        case .attorneyFee:
            return "person.circle.fill"
        case .rentSpecial:
            return "building.2.crop.circle.fill"
        }
    }

    /// Icon color
    var iconColor: Color {
        switch self {
        case .monetary:
            return .green
        case .nonMonetary:
            return .blue
        case .timeCalculation:
            return .orange
        case .smmCalculation:
            return .purple
        case .attorneyFee:
            return .indigo
        case .rentSpecial:
            return .teal
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

        var specialCalculations: [DisputeCategoryType] {
            return [.rentSpecial, .attorneyFee] // .rentSpecial can be added in the future
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
    
    /// Main categories (monetary and non-monetary)
    var mainCategories: [DisputeCategoryType] {
        return [.nonMonetary, .monetary]
    }
    
    /// Other calculations (time and SMM)
    var otherCalculations: [DisputeCategoryType] {
        return [.smmCalculation, .timeCalculation]
    }
    
    /// Screen title
    var screenTitle: String {
        LocalizationKeys.DisputeCategory.title.localized
    }

    /// Screen subtitle
    var screenSubtitle: String {
        LocalizationKeys.DisputeCategory.subtitle.localized
    }

    /// Main categories section title
    var mainCategoriesTitle: String {
        LocalizationKeys.DisputeCategory.mainCategories.localized
    }

    /// Other calculations section title
    var otherCalculationsTitle: String {
        LocalizationKeys.DisputeCategory.otherCalculations.localized
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
        case .monetary:
            // Monetary disputes go to DisputeType where user will select agreement status
            isMonetary = true
            navigateToDisputeType = true
            
        case .nonMonetary:
            // Non-monetary disputes go directly to DisputeType
            // They are treated as non-agreement cases per Tariff Article 7, Paragraph 1
            isMonetary = false
            navigateToDisputeType = true
            
        case .timeCalculation:
            navigateToTimeCalculation = true
            
        case .smmCalculation:
            navigateToSMMCalculation = true
        case .attorneyFee:
            navigateToAttorneyFee = true
        case .rentSpecial:
            // Future: implement navigation
            // TODO: Temporary path - replace with proper navigation later
            navigateToAttorneyFee = true
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
