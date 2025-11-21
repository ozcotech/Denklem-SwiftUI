//
//  StartScreenViewModel.swift
//  Denklem
//
//  Created by ozkan on 14.11.2025.
//

import SwiftUI
import Combine

// MARK: - Start Screen ViewModel

/// ViewModel for StartScreen - manages tariff year selection and navigation
@available(iOS 26.0, *)
@MainActor
class StartScreenViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Currently selected tariff year
    @Published var selectedYear: TariffYear = .current
    
    /// Controls dropdown visibility for year selection
    @Published var isYearDropdownVisible: Bool = false
    
    /// Navigation flag for DisputeCategoryView
    @Published var navigateToDisputeCategory: Bool = false
    
    // MARK: - Private Properties
    
    /// Stores last selected year in UserDefaults
    @AppStorage(AppConstants.UserDefaultsKeys.lastUsedTariffYear) 
    private var lastUsedYear: Int = TariffYear.current.rawValue
    
    // MARK: - Initialization
    
    init() {
        loadLastUsedYear()
    }
    
    // MARK: - Public Methods
    
    /// Selects a tariff year and closes dropdown
    /// - Parameter year: TariffYear to select
    func selectYear(_ year: TariffYear) {
        selectedYear = year
        lastUsedYear = year.rawValue
        
        // Close dropdown with animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isYearDropdownVisible = false
        }
    }
    
    /// Toggles year dropdown visibility
    func toggleYearDropdown() {
        isYearDropdownVisible.toggle()
    }
    
    /// Triggers navigation to DisputeCategoryView
    func proceedToDisputeCategory() {
        // Validate year selection before navigation
        guard validateYearSelection() else {
            return
        }
        
        // Save selected year
        lastUsedYear = selectedYear.rawValue
        
        // Trigger navigation
        navigateToDisputeCategory = true
    }
    
    // MARK: - Private Methods
    
    /// Loads last used year from UserDefaults
    private func loadLastUsedYear() {
        // Try to load last used year
        if let savedYear = TariffYear(rawValue: lastUsedYear) {
            selectedYear = savedYear
        } else {
            // Fallback to current year if saved year is invalid
            selectedYear = .current
            lastUsedYear = TariffYear.current.rawValue
        }
    }
    
    /// Validates year selection before navigation
    /// - Returns: True if validation passes
    private func validateYearSelection() -> Bool {
        // Check if year is supported
        guard selectedYear.isSupported else {
            #if DEBUG
            print("⚠️ Selected year \(selectedYear.rawValue) is not supported")
            #endif
            return false
        }
        
        // Check if year is available
        guard TariffConstants.availableYears.contains(selectedYear.rawValue) else {
            #if DEBUG
            print("⚠️ Selected year \(selectedYear.rawValue) is not available")
            #endif
            return false
        }
        
        return true
    }
    
    /// Resets to default year
    func resetToDefaultYear() {
        selectYear(.default)
    }
}

// MARK: - StartScreenViewModel Extensions

@available(iOS 26.0, *)
extension StartScreenViewModel {
    
    // MARK: - Computed Properties
    
    /// Whether selected year is active
    var isSelectedYearActive: Bool {
        selectedYear.isActive
    }
    
    /// Whether selected year is finalized
    var isSelectedYearFinalized: Bool {
        selectedYear.isFinalized
    }
}

// MARK: - Debug Support

#if DEBUG
@available(iOS 26.0, *)
extension StartScreenViewModel {
    
    /// Creates a test instance with specific year
    static func testInstance(year: TariffYear = .current) -> StartScreenViewModel {
        let viewModel = StartScreenViewModel()
        viewModel.selectedYear = year
        return viewModel
    }
    
    /// Debug description
    var debugDescription: String {
        """
        StartScreenViewModel:
        - Selected Year: \(selectedYear.rawValue)
        - Is Dropdown Visible: \(isYearDropdownVisible)
        - Is Year Active: \(selectedYear.isActive)
        - Is Year Finalized: \(selectedYear.isFinalized)
        - Navigate to DisputeCategory: \(navigateToDisputeCategory)
        """
    }
}
#endif
