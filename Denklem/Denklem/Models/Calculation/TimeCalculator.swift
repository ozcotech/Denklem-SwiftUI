//
//  TimeCalculator.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - TimeCalculator
/// Calculator for time-based dispute deadlines in mediation processes
/// Provides deadline calculations based on dispute types and Turkish mediation law
final class TimeCalculator: ObservableObject {
    
    // MARK: - Properties
    @Published var disputeType: DisputeType = .commercial
    @Published var startDate: Date = Date()
    @Published var currentResult: TimeCalculationResult?
    @Published var validationState: ValidationResult = .success
    
    // MARK: - Private Properties
    private let validationConstants = ValidationConstants.TimeCalculation.self
    
    // MARK: - Initialization
    init() {
        // Initialize with current date
        startDate = Date()
    }
    
    // MARK: - Public Methods
    
    /// Calculates time-based deadlines for the given dispute type and start date
    /// - Returns: TimeCalculationResult containing deadline information
    func calculate() -> TimeCalculationResult {
        // Validate inputs first
        let validationResult = validateInputs()
        guard validationResult.isValid else {
            let errorResult = TimeCalculationResult(
                disputeType: disputeType,
                startDate: startDate,
                deadline: startDate,
                extendedDeadline: startDate,
                weekCount: 0,
                isValid: false,
                errorMessage: validationResult.errorMessage ?? "Validation failed"
            )
            currentResult = errorResult
            return errorResult
        }
        
        // Get week counts for dispute type (normal and extended)
        let (weekCount, extendedWeekCount) = getWeekCountsForDisputeType(disputeType)
        
        // Calculate deadline (weekCount weeks from start date)
        let calendar = Calendar.current
        guard let deadline = calendar.date(byAdding: .weekOfYear, value: weekCount, to: startDate),
              let extendedDeadline = calendar.date(byAdding: .weekOfYear, value: extendedWeekCount, to: startDate) else {
            let errorResult = TimeCalculationResult(
                disputeType: disputeType,
                startDate: startDate,
                deadline: startDate,
                extendedDeadline: startDate,
                weekCount: weekCount,
                isValid: false,
                errorMessage: LocalizationKeys.Error.calculationFailed.localized
            )
            currentResult = errorResult
            return errorResult
        }
        
        let result = TimeCalculationResult(
            disputeType: disputeType,
            startDate: startDate,
            deadline: deadline,
            extendedDeadline: extendedDeadline,
            weekCount: weekCount,
            isValid: true,
            errorMessage: nil
        )
        
        currentResult = result
        return result
    }
    
    /// Updates dispute type and recalculates if auto-calculation is enabled
    /// - Parameter newDisputeType: The new dispute type
    func updateDisputeType(_ newDisputeType: DisputeType) {
        disputeType = newDisputeType
        // Auto-calculate if needed (can be implemented later)
        // if autoCalculateEnabled { _ = calculate() }
    }
    
    /// Updates start date and recalculates if auto-calculation is enabled
    /// - Parameter newStartDate: The new start date
    func updateStartDate(_ newStartDate: Date) {
        startDate = newStartDate
        // Auto-calculate if needed (can be implemented later)
        // if autoCalculateEnabled { _ = calculate() }
    }
    
    /// Resets calculator to initial state
    func reset() {
        disputeType = .commercial
        startDate = Date()
        currentResult = nil
        validationState = .success
    }
    
    // MARK: - Private Methods
    
    /// Validates input parameters
    /// - Returns: ValidationResult indicating if inputs are valid
    private func validateInputs() -> ValidationResult {
        // Validate dispute type
        guard isDisputeTypeSupported(disputeType) else {
            return .failure(
                code: 1001,
                message: LocalizationKeys.Validation.invalidDisputeType.localized
            )
        }
        
        // Validate start date
        guard isStartDateValid(startDate) else {
            return .failure(
                code: 1002,
                message: "Start date is not within valid range"
            )
        }
        
        return .success
    }
    
    /// Checks if dispute type is supported for time calculations
    /// - Parameter disputeType: The dispute type to check
    /// - Returns: Boolean indicating support
    private func isDisputeTypeSupported(_ disputeType: DisputeType) -> Bool {
        let disputeKey = mapDisputeTypeToTimeCalculationKey(disputeType)
        return TariffConstants.timeCalculationDisputeTypes.keys.contains(disputeKey)
    }
    
    /// Validates if start date is within acceptable range
    /// - Parameter date: The date to validate
    /// - Returns: Boolean indicating validity
    private func isStartDateValid(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        // Check if date is not in the future beyond reasonable limit
        if let maxFutureDate = calendar.date(byAdding: .year, value: 1, to: now),
           date > maxFutureDate {
            return false
        }
        
        // Check if date is not too far in the past
        if let minPastDate = calendar.date(byAdding: .year, value: -10, to: now),
           date < minPastDate {
            return false
        }
        
        return true
    }
    
    /// Gets week count for specific dispute type
    /// - Parameter disputeType: The dispute type
    /// - Returns: Number of weeks for the dispute type
    private func getWeekCountForDisputeType(_ disputeType: DisputeType) -> Int {
        let disputeKey = mapDisputeTypeToTimeCalculationKey(disputeType)
        let weeks = TariffConstants.timeCalculationDisputeTypes[disputeKey] ?? [4, 5] // Default fallback
        return weeks[0] // Return normal deadline weeks
    }
    
    /// Gets both normal and extended week counts for specific dispute type
    /// - Parameter disputeType: The dispute type
    /// - Returns: Tuple containing (normal weeks, extended weeks)
    private func getWeekCountsForDisputeType(_ disputeType: DisputeType) -> (normal: Int, extended: Int) {
        let disputeKey = mapDisputeTypeToTimeCalculationKey(disputeType)
        let weeks = TariffConstants.timeCalculationDisputeTypes[disputeKey] ?? [4, 5] // Default fallback
        return (weeks[0], weeks[1])
    }
    
    /// Maps DisputeType enum to TariffConstants time calculation key
    /// - Parameter disputeType: The dispute type enum
    /// - Returns: String key for TariffConstants lookup
    private func mapDisputeTypeToTimeCalculationKey(_ disputeType: DisputeType) -> String {
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
            return "labor_law" // Family disputes use same timing as labor law
        case .partnershipDissolution:
            return "partnership_dissolution"
        case .other:
            return "labor_law" // Default to labor law timing
        }
    }
}

// MARK: - TimeCalculationResult
/// Result model for time calculation operations
struct TimeCalculationResult {
    let disputeType: DisputeType
    let startDate: Date
    let deadline: Date
    let extendedDeadline: Date
    let weekCount: Int
    let isValid: Bool
    let errorMessage: String?
    let calculationDate: Date
    
    // MARK: - Initialization
    init(disputeType: DisputeType, startDate: Date, deadline: Date, extendedDeadline: Date, weekCount: Int, isValid: Bool, errorMessage: String?) {
        self.disputeType = disputeType
        self.startDate = startDate
        self.deadline = deadline
        self.extendedDeadline = extendedDeadline
        self.weekCount = weekCount
        self.isValid = isValid
        self.errorMessage = errorMessage
        self.calculationDate = Date()
    }
    
    // MARK: - Computed Properties
    
    /// Formatted start date string
    var formattedStartDate: String {
        return LocalizationHelper.formatDate(startDate)
    }
    
    /// Formatted deadline string
    var formattedDeadline: String {
        return LocalizationHelper.formatDate(deadline)
    }
    
    /// Formatted extended deadline string
    var formattedExtendedDeadline: String {
        return LocalizationHelper.formatDate(extendedDeadline)
    }
    
    /// Formatted calculation date string
    var formattedCalculationDate: String {
        return LocalizationHelper.formatDate(calculationDate)
    }
    
    /// Localized dispute type name
    var localizedDisputeType: String {
        return disputeType.displayName
    }
    
    /// Week count description
    var weekDescription: String {
        if weekCount == 1 {
            return LocalizationKeys.TimeCalculation.Result.week.localized
        } else {
            return String(format: LocalizationKeys.TimeCalculation.Result.weeks.localized, weekCount)
        }
    }
    
    /// Days until deadline from current date
    var daysUntilDeadline: Int {
        let calendar = Calendar.current
        let now = Date()
        return calendar.dateComponents([.day], from: now, to: deadline).day ?? 0
    }
    
    /// Boolean indicating if deadline has passed
    var isDeadlinePassed: Bool {
        return Date() > deadline
    }
    
    /// Boolean indicating if extended deadline has passed
    var isExtendedDeadlinePassed: Bool {
        return Date() > extendedDeadline
    }
}

// MARK: - TimeCalculationResult Extensions
extension TimeCalculationResult: Equatable {
    static func == (lhs: TimeCalculationResult, rhs: TimeCalculationResult) -> Bool {
        return lhs.disputeType == rhs.disputeType &&
               lhs.startDate == rhs.startDate &&
               lhs.deadline == rhs.deadline &&
               lhs.weekCount == rhs.weekCount &&
               lhs.isValid == rhs.isValid
    }
}

extension TimeCalculationResult: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(disputeType)
        hasher.combine(startDate)
        hasher.combine(deadline)
        hasher.combine(weekCount)
        hasher.combine(isValid)
    }
}

// MARK: - TimeCalculationResult + Export
extension TimeCalculationResult {
    
    /// Exports calculation result as formatted text
    /// - Returns: Formatted string suitable for sharing
    func exportAsText() -> String {
        var result = ""
        result += "\(LocalizationKeys.TimeCalculation.disputeTypes.localized): \(localizedDisputeType)\n"
        result += "\(LocalizationKeys.Input.startDate.localized): \(formattedStartDate)\n"
        result += "\(LocalizationKeys.TimeCalculation.disputeTypeDuration.localized): \(weekDescription)\n"
        result += "\(LocalizationKeys.TimeCalculation.Result.deadline.localized): \(formattedDeadline)\n"
        result += "\(LocalizationKeys.TimeCalculation.Result.extendedDeadline.localized): \(formattedExtendedDeadline)\n"
        result += "\(LocalizationKeys.Result.calculationDate.localized): \(formattedCalculationDate)\n"
        
        if let error = errorMessage, !error.isEmpty {
            result += "\(LocalizationKeys.General.error.localized): \(error)\n"
        }
        
        return result
    }
    
    /// Exports calculation result as dictionary for JSON serialization
    /// - Returns: Dictionary representation
    func exportAsDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "disputeType": disputeType.rawValue,
            "startDate": ISO8601DateFormatter().string(from: startDate),
            "deadline": ISO8601DateFormatter().string(from: deadline),
            "extendedDeadline": ISO8601DateFormatter().string(from: extendedDeadline),
            "weekCount": weekCount,
            "isValid": isValid,
            "calculationDate": ISO8601DateFormatter().string(from: calculationDate),
            "daysUntilDeadline": daysUntilDeadline,
            "isDeadlinePassed": isDeadlinePassed
        ]
        
        if let error = errorMessage {
            dict["errorMessage"] = error
        }
        
        return dict
    }
}
