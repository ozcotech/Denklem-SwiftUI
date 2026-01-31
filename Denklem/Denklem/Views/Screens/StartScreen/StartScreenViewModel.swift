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

    /// Navigation flag for DisputeTypeView (quick access to monetary disputes)
    @Published var navigateToDisputeType: Bool = false
    
    // MARK: - Private Properties
    
    /// Stores last selected year in UserDefaults
    @AppStorage(AppConstants.UserDefaultsKeys.lastUsedTariffYear) 
    private var lastUsedYear: Int = TariffYear.current.rawValue
    
    // MARK: - Initialization
    
    init() {
        loadLastUsedYear()
    }
    
    // MARK: - Public Methods
    
    /// Selects a tariff year
    /// - Parameter year: TariffYear to select
    func selectYear(_ year: TariffYear) {
        selectedYear = year
        lastUsedYear = year.rawValue
    }
    
    /// Triggers navigation to DisputeTypeView (quick access to monetary disputes)
    func proceedToDisputeType() {
        // Validate year selection before navigation
        guard validateYearSelection() else {
            return
        }

        // Save selected year
        lastUsedYear = selectedYear.rawValue

        // Trigger navigation
        navigateToDisputeType = true
    }
    
    // MARK: - Private Methods
    
    /// Loads last used year from UserDefaults
    private func loadLastUsedYear() {
        if let savedYear = TariffYear(rawValue: lastUsedYear) {
            selectedYear = savedYear
        } else {
            selectedYear = .current
            lastUsedYear = TariffYear.current.rawValue
        }
    }
    
    /// Validates year selection before navigation
    /// - Returns: True if validation passes
    private func validateYearSelection() -> Bool {
        guard selectedYear.isSupported else {
            return false
        }
        
        guard TariffConstants.availableYears.contains(selectedYear.rawValue) else {
            return false
        }
        
        return true
    }
}
