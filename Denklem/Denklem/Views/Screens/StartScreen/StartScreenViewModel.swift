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
final class StartScreenViewModel: ObservableObject {
    
    // MARK: - Published Properties

    /// Tariff year for the quick-access mediation screen.
    /// Always the active tariff year — the start screen has no year picker, so a saved year
    /// (key "lastUsedTariffYear", app ≤ 2.6.1) would stay stuck after a new tariff year starts.
    @Published var selectedYear: TariffYear = .current

    /// Navigation flag for DisputeTypeView (quick access to monetary disputes)
    @Published var navigateToDisputeType: Bool = false

    /// Navigation flag for SurveyView
    @Published var navigateToSurvey: Bool = false
    
    // MARK: - Private Properties

    /// Tracks whether the survey has been completed
    @AppStorage(AppConstants.UserDefaultsKeys.surveyCompleted)
    var isSurveyCompleted: Bool = false

    // MARK: - Public Methods

    /// Selects a tariff year
    /// - Parameter year: TariffYear to select
    func selectYear(_ year: TariffYear) {
        selectedYear = year
    }
    
    /// Triggers navigation to DisputeTypeView (quick access to monetary disputes)
    func proceedToDisputeType() {
        // Validate year selection before navigation
        guard validateYearSelection() else {
            return
        }

        // Trigger navigation
        navigateToDisputeType = true
    }
    
    // MARK: - Private Methods

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
