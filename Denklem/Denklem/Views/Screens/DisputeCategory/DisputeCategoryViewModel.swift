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
    
    var id: String { rawValue }
    
    /// Localized display name
    var displayName: String {
        switch self {
        case .monetary:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.monetary, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .nonMonetary:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.nonMonetary, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .timeCalculation:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.timeCalculation, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .smmCalculation:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.smmCalculation, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        }
    }
    
    /// Localized description
    var description: String {
        switch self {
        case .monetary:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.monetaryDescription, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .nonMonetary:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.nonMonetaryDescription, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .timeCalculation:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.timeCalculationDescription, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        case .smmCalculation:
            return NSLocalizedString(LocalizationKeys.DisputeCategory.smmCalculationDescription, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        }
    }
    
    /// System image name
    var systemImage: String {
        switch self {
        case .monetary:
            return "dollarsign.circle.fill"
        case .nonMonetary:
            return "doc.text.fill"
        case .timeCalculation:
            return "clock.fill"
        case .smmCalculation:
            return "doc.badge.gearshape.fill"
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
        }
    }
}

// MARK: - Dispute Category ViewModel
/// ViewModel for DisputeCategoryView - manages category selection and navigation
@available(iOS 26.0, *)
@MainActor
final class DisputeCategoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected tariff year from StartScreen
    @Published var selectedYear: TariffYear
    
    /// Navigation flags
    @Published var navigateToDisputeType: Bool = false
    @Published var navigateToTimeCalculation: Bool = false
    @Published var navigateToSMMCalculation: Bool = false
    
    /// Selected category for navigation
    @Published var selectedCategory: DisputeCategoryType?
    
    /// Is monetary dispute (for DisputeTypeView parameter)
    @Published var isMonetary: Bool = false
    
    // MARK: - Computed Properties
    
    /// Main categories (monetary and non-monetary)
    var mainCategories: [DisputeCategoryType] {
        return [.monetary, .nonMonetary]
    }
    
    /// Other calculations (time and SMM)
    var otherCalculations: [DisputeCategoryType] {
        return [.timeCalculation, .smmCalculation]
    }
    
    /// Screen title
    var screenTitle: String {
        return NSLocalizedString(LocalizationKeys.DisputeCategory.title, comment: "")
    }
    
    /// Screen subtitle
    var screenSubtitle: String {
        return NSLocalizedString(LocalizationKeys.DisputeCategory.subtitle, comment: "")
    }
    
    /// Other calculations section title
    var otherCalculationsTitle: String {
        return NSLocalizedString(LocalizationKeys.DisputeCategory.otherCalculations, comment: "")
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
            isMonetary = true
            navigateToDisputeType = true
            
        case .nonMonetary:
            isMonetary = false
            navigateToDisputeType = true
            
        case .timeCalculation:
            navigateToTimeCalculation = true
            
        case .smmCalculation:
            navigateToSMMCalculation = true
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
