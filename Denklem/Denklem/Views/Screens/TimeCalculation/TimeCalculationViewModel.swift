//
//  TimeCalculationViewModel.swift
//  Denklem
//
//  Created by ozkan on 03.01.2026.
//

import SwiftUI
import Combine

// MARK: - Time Calculation ViewModel
/// ViewModel for TimeCalculationView - manages time calculation logic
@available(iOS 26.0, *)
@MainActor
final class TimeCalculationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Selected start date for calculation
    @Published var startDate: Date = Date()
    
    /// Calculation results for all dispute types
    @Published var results: [DisputeTypeResult] = []
    
    /// Loading state
    @Published var isLoading: Bool = false
    
    /// Show results sheet
    @Published var showResults: Bool = false
    
    /// Error message if calculation fails
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let calculator = TimeCalculator()
    
    // MARK: - Initialization
    
    init() {
        // Default to current date
        startDate = Date()
    }
    
    // MARK: - Public Methods
    
    /// Performs time calculation for all dispute types
    func calculate() {
        isLoading = true
        errorMessage = nil
        results = []
        
        // Calculate for all available dispute types
        let disputeTypes: [DisputeType] = [
            .workerEmployer,
            .commercial,
            .consumer,
            .rent,
            .partnershipDissolution,
            .condominium,
            .neighbor,
            .agriculturalProduction
        ]
        
        var calculatedResults: [DisputeTypeResult] = []
        
        for disputeType in disputeTypes {
            calculator.updateDisputeType(disputeType)
            calculator.updateStartDate(startDate)
            
            let result = calculator.calculate()
            
            if result.isValid {
                calculatedResults.append(
                    DisputeTypeResult(
                        disputeType: disputeType,
                        normalWeeks: result.weekCount,
                        normalDeadline: result.deadline,
                        extendedWeeks: getExtendedWeeks(for: disputeType),
                        extendedDeadline: result.extendedDeadline
                    )
                )
            }
        }
        
        results = calculatedResults
        isLoading = false
        
        if !results.isEmpty {
            withAnimation(.bouncy(duration: 0.4)) {
                showResults = true
            }
        } else {
            errorMessage = "Hesaplama başarısız oldu"
        }
    }
    
    /// Updates start date
    func updateStartDate(_ date: Date) {
        startDate = date
    }
    
    /// Resets calculation
    func reset() {
        startDate = Date()
        results = []
        showResults = false
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    /// Gets extended week count for dispute type
    private func getExtendedWeeks(for disputeType: DisputeType) -> Int {
        let key = mapDisputeTypeToKey(disputeType)
        let weeks = TariffConstants.timeCalculationDisputeTypes[key] ?? [4, 5]
        return weeks[1] // Extended weeks
    }
    
    /// Maps DisputeType to TariffConstants key
    private func mapDisputeTypeToKey(_ disputeType: DisputeType) -> String {
        switch disputeType {
        case .workerEmployer:
            return "labor_law"
        case .commercial:
            return "commercial_law"
        case .consumer:
            return "consumer_law"
        case .rent:
            return "rental_disputes"
        case .neighbor:
            return "neighbor_law"
        case .condominium:
            return "condominium_law"
        case .family:
            return "labor_law"
        case .partnershipDissolution:
            return "partnership_dissolution"
        case .agriculturalProduction:
            return "agricultural_production"
        case .other:
            return "labor_law"
        }
    }
}

// MARK: - Dispute Type Result Model
/// Result model for a single dispute type time calculation
struct DisputeTypeResult: Identifiable {
    let id = UUID()
    let disputeType: DisputeType
    let normalWeeks: Int
    let normalDeadline: Date
    let extendedWeeks: Int
    let extendedDeadline: Date
    
    /// Localized dispute type name - uses TimeCalculation specific keys
    var localizedName: String {
        switch disputeType {
        case .workerEmployer:
            return LocalizationKeys.TimeCalculation.laborLaw.localized
        case .commercial:
            return LocalizationKeys.TimeCalculation.commercialLaw.localized
        case .consumer:
            return LocalizationKeys.TimeCalculation.consumerLaw.localized
        case .rent:
            return LocalizationKeys.TimeCalculation.rentalDisputes.localized
        case .partnershipDissolution:
            return LocalizationKeys.TimeCalculation.partnershipDissolution.localized
        case .condominium:
            return LocalizationKeys.TimeCalculation.condominiumLaw.localized
        case .neighbor:
            return LocalizationKeys.TimeCalculation.neighborLaw.localized
        case .agriculturalProduction:
            return LocalizationKeys.TimeCalculation.agriculturalProduction.localized
        default:
            return disputeType.displayName
        }
    }
    
    /// Formatted normal deadline string
    var formattedNormalDeadline: String {
        return LocalizationHelper.formatDate(normalDeadline)
    }
    
    /// Formatted extended deadline string
    var formattedExtendedDeadline: String {
        return LocalizationHelper.formatDate(extendedDeadline)
    }
    
    /// Normal week label (e.g., "3. Hafta" or "3rd Week")
    var normalWeekLabel: String {
        return "\(normalWeeks). " + (normalWeeks == 1 ? LocalizationKeys.TimeCalculation.Result.week.localized : LocalizationKeys.TimeCalculation.Result.weeks.localized)
    }
    
    /// Extended week label (e.g., "4. Hafta" or "4th Week")
    var extendedWeekLabel: String {
        return "\(extendedWeeks). " + (extendedWeeks == 1 ? LocalizationKeys.TimeCalculation.Result.week.localized : LocalizationKeys.TimeCalculation.Result.weeks.localized)
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension TimeCalculationViewModel {
    /// Creates a preview instance with sample data
    static var preview: TimeCalculationViewModel {
        let viewModel = TimeCalculationViewModel()
        viewModel.calculate()
        return viewModel
    }
}
#endif
