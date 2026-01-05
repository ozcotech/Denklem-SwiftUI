//
//  DisputeType.swift
//  Denklem
//
//  Created by ozkan on 22.07.2025.
//

import Foundation

// MARK: - Dispute Type
/// Domain model representing different types of mediation disputes
/// Provides type-safe access to dispute categories with domain logic and validation
enum DisputeType: String, CaseIterable, Identifiable, Hashable {
    case workerEmployer = "worker_employer"
    case commercial = "commercial"
    case consumer = "consumer"
    case rent = "rent"
    case neighbor = "neighbor"
    case condominium = "condominium"
    case family = "family"
    case partnershipDissolution = "partnership_dissolution"
    case agriculturalProduction = "agricultural_production"
    case other = "other"
    
    // MARK: - Identifiable Conformance
    
    var id: String { rawValue }
    
    // MARK: - Display Properties
    
    /// Localized display name for the dispute type
    var displayName: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "Worker-Employer dispute type")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "Commercial dispute type")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "Consumer dispute type")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "Rent dispute type")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "Neighbor dispute type")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "Condominium dispute type")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "Family dispute type")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "Partnership dissolution dispute type")
        case .agriculturalProduction:
            return NSLocalizedString(LocalizationKeys.TimeCalculation.agriculturalProduction, comment: "Agricultural production dispute type")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "Other dispute type")
        }
    }
    
    /// Localized description for the dispute type
    var description: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.workerEmployer, comment: "Worker-Employer description")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.commercial, comment: "Commercial description")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.consumer, comment: "Consumer description")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.rent, comment: "Rent description")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.neighbor, comment: "Neighbor description")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.condominium, comment: "Condominium description")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.family, comment: "Family description")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.partnershipDissolution, comment: "Partnership dissolution description")
        case .agriculturalProduction:
            return NSLocalizedString(LocalizationKeys.TimeCalculation.agriculturalProduction, comment: "Agricultural production description")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.other, comment: "Other description")
        }
    }
    
    // MARK: - Domain Logic Properties
    
    /// Category grouping for related dispute types
    var category: DisputeCategory {
        switch self {
        case .workerEmployer:
            return .workerEmployer
        case .commercial:
            return .commercial
        case .consumer:
            return .consumer
        case .rent:
            return .rent
        case .neighbor:
            return .neighbor
        case .condominium:
            return .condominium
        case .family:
            return .family
        case .partnershipDissolution:
            return .partnershipDissolution
        case .agriculturalProduction:
            return .other
        case .other:
            return .other
        }
    }
    
    /// Display priority for UI ordering (lower number = higher priority)
    var displayPriority: Int {
        switch self {
        case .workerEmployer: return 1
        case .commercial: return 2
        case .consumer: return 3
        case .rent: return 4
        case .family: return 5
        case .condominium: return 6
        case .neighbor: return 7
        case .partnershipDissolution: return 8
        case .agriculturalProduction: return 9
        case .other: return 10
        }
    }
    
    /// Whether this dispute type typically involves monetary amounts
    var requiresMonetaryAmount: Bool {
        switch self {
        case .commercial, .rent, .partnershipDissolution:
            return true
        case .workerEmployer, .consumer, .neighbor, .condominium, .family, .agriculturalProduction, .other:
            return false // Can be both monetary and non-monetary
        }
    }
    
    /// Whether this dispute type supports hourly rate calculation
    var supportsHourlyRate: Bool {
        return true // All dispute types support hourly rate calculation
    }
    
    /// Whether this dispute type supports fixed fee calculation
    var supportsFixedFee: Bool {
        return true // All dispute types support fixed fee calculation
    }
    
    /// Whether this dispute type supports bracket calculation for agreements
    var supportsBracketCalculation: Bool {
        return true // All dispute types support bracket calculation
    }
    
    // MARK: - Tariff Data Access
    
    /// Returns hourly rate for current tariff year
    /// - Parameter tariffYear: Year to get rate for (defaults to current year)
    /// - Returns: Hourly rate in Turkish Lira
    func getHourlyRate(for tariffYear: TariffYear = .current) -> Double {
        guard let tariff = TariffFactory.createTariff(for: tariffYear.rawValue) else {
            return getDefaultHourlyRate()
        }
        return tariff.getHourlyRate(for: self.rawValue)
    }
    
    /// Returns fixed fee for given party count and tariff year
    /// - Parameters:
    ///   - partyCount: Number of parties in the dispute
    ///   - tariffYear: Year to get rate for (defaults to current year)
    /// - Returns: Fixed fee in Turkish Lira
    func getFixedFee(partyCount: Int, for tariffYear: TariffYear = .current) -> Double {
        guard let tariff = TariffFactory.createTariff(for: tariffYear.rawValue) else {
            return getDefaultFixedFee(partyCount: partyCount)
        }
        return tariff.getFixedFee(for: self.rawValue, partyCount: partyCount)
    }
    
    /// Returns minimum fee for this dispute type and tariff year
    /// - Parameter tariffYear: Year to get rate for (defaults to current year)
    /// - Returns: Minimum fee in Turkish Lira
    func getMinimumFee(for tariffYear: TariffYear = .current) -> Double {
        guard let tariff = TariffFactory.createTariff(for: tariffYear.rawValue) else {
            return getDefaultMinimumFee()
        }
        return tariff.getMinimumFee(for: self.rawValue)
    }
    
    // MARK: - Validation Methods
    
    /// Validates if party count is appropriate for this dispute type
    /// - Parameter partyCount: Number of parties to validate
    /// - Returns: Validation result with success or error details
    func validatePartyCount(_ partyCount: Int) -> ValidationResult {
        return ValidationConstants.validatePartyCount(partyCount)
    }
    
    /// Validates if amount is appropriate for this dispute type
    /// - Parameter amount: Amount to validate (optional for non-monetary disputes)
    /// - Returns: Validation result with success or error details
    func validateAmount(_ amount: Double?) -> ValidationResult {
        // If dispute type requires monetary amount, amount cannot be nil
        if requiresMonetaryAmount && amount == nil {
            return .failure(
                code: AppConstants.ErrorCodes.validationError,
                message: NSLocalizedString(LocalizationKeys.Validation.requiredField, comment: "Required field")
            )
        }
        
        // If amount is provided, validate it
        if let amount = amount {
            return ValidationConstants.validateAmount(amount)
        }
        
        return .success
    }
    
    /// Comprehensive validation for dispute calculation input
    /// - Parameters:
    ///   - amount: Dispute amount (optional)
    ///   - partyCount: Number of parties
    /// - Returns: Combined validation result
    func validateCalculationInput(amount: Double?, partyCount: Int) -> ValidationResult {
        // Validate party count
        let partyValidation = validatePartyCount(partyCount)
        if !partyValidation.isValid {
            return partyValidation
        }
        
        // Validate amount
        let amountValidation = validateAmount(amount)
        if !amountValidation.isValid {
            return amountValidation
        }
        
        return .success
    }
    
    // MARK: - Factory Methods
    
    /// Creates DisputeType from raw string value
    /// - Parameter rawValue: String representation of dispute type
    /// - Returns: DisputeType enum case or nil if invalid
    static func from(_ rawValue: String) -> DisputeType? {
        return DisputeType(rawValue: rawValue)
    }
    
    /// Creates DisputeType from DisputeConstants key
    /// - Parameter key: Key from DisputeConstants.DisputeTypeKeys
    /// - Returns: DisputeType enum case or nil if invalid
    static func fromDisputeConstantsKey(_ key: String) -> DisputeType? {
        return DisputeType(rawValue: key)
    }
    
    /// Returns all dispute types ordered by display priority
    /// - Returns: Array of DisputeType cases sorted by priority
    static var orderedForDisplay: [DisputeType] {
        return DisputeType.allCases.sorted { $0.displayPriority < $1.displayPriority }
    }
    
    /// Returns dispute types filtered by category
    /// - Parameter category: Category to filter by
    /// - Returns: Array of DisputeType cases in the specified category
    static func disputeTypes(in category: DisputeCategory) -> [DisputeType] {
        return DisputeType.allCases.filter { $0.category == category }
    }
    
    // MARK: - Default Values (Fallback)
    
    /// Default hourly rate if tariff data is unavailable
    private func getDefaultHourlyRate() -> Double {
        switch self {
        case .commercial:
            return 1150.0 // Higher rate for commercial disputes
        case .partnershipDissolution:
            return 900.0
        case .rent, .neighbor, .condominium:
            return 835.0
        case .workerEmployer, .consumer, .family, .agriculturalProduction, .other:
            return 785.0 // Standard rate
        }
    }
    
    /// Default fixed fee if tariff data is unavailable
    private func getDefaultFixedFee(partyCount: Int) -> Double {
        let baseFee: Double
        switch self {
        case .commercial:
            baseFee = 2300.0
        case .partnershipDissolution:
            baseFee = 1800.0
        case .rent, .neighbor, .condominium:
            baseFee = 1670.0
        case .workerEmployer, .consumer, .family, .agriculturalProduction, .other:
            baseFee = 1570.0
        }
        
        // Adjust for party count (simplified logic)
        switch partyCount {
        case 2...4:
            return baseFee
        case 5...9:
            return baseFee + 50.0
        case 10...999:
            return baseFee + 150.0
        default:
            return baseFee + 250.0
        }
    }
    
    /// Default minimum fee if tariff data is unavailable
    private func getDefaultMinimumFee() -> Double {
        switch category {
        case .commercial:
            return 2300.0 // Higher minimum for commercial disputes
        default:
            return 1570.0 // Standard minimum
        }
    }
}

// MARK: - DisputeType Extensions

extension DisputeType {
    
    /// Returns formatted hourly rate as currency string
    /// - Parameter tariffYear: Year to get rate for
    /// - Returns: Formatted currency string (e.g., "₺1.150,00")
    func formattedHourlyRate(for tariffYear: TariffYear = .current) -> String {
        let rate = getHourlyRate(for: tariffYear)
        return LocalizationHelper.formatCurrency(rate)
    }
    
    /// Returns formatted fixed fee as currency string
    /// - Parameters:
    ///   - partyCount: Number of parties
    ///   - tariffYear: Year to get rate for
    /// - Returns: Formatted currency string
    func formattedFixedFee(partyCount: Int, for tariffYear: TariffYear = .current) -> String {
        let fee = getFixedFee(partyCount: partyCount, for: tariffYear)
        return LocalizationHelper.formatCurrency(fee)
    }
    
    /// Returns formatted minimum fee as currency string
    /// - Parameter tariffYear: Year to get rate for
    /// - Returns: Formatted currency string
    func formattedMinimumFee(for tariffYear: TariffYear = .current) -> String {
        let fee = getMinimumFee(for: tariffYear)
        return LocalizationHelper.formatCurrency(fee)
    }
    
    /// Returns comprehensive information about this dispute type
    /// - Parameter tariffYear: Year to get data for
    /// - Returns: Formatted string with all relevant information
    func getDetailedInfo(for tariffYear: TariffYear = .current) -> String {
        return """
        \(displayName)
        \(description)
        
        Saatlik Ücret: \(formattedHourlyRate(for: tariffYear))
        Minimum Ücret: \(formattedMinimumFee(for: tariffYear))
        Kategori: \(category.displayName)
        """
    }
}

// MARK: - Compatibility with String-based APIs

extension DisputeType {
    
    /// Maps to DisputeConstants key format
    var disputeConstantsKey: String {
        return rawValue
    }
    
    /// Maps to TariffConstants key format
    var tariffKey: String {
        return rawValue
    }
    
    /// Maps to LocalizationKeys format
    var localizationKey: String {
        return rawValue
    }
}

// MARK: - Collection Extensions

extension Collection where Element == DisputeType {
    
    /// Returns dispute types sorted by display priority
    var sortedByPriority: [DisputeType] {
        return sorted { $0.displayPriority < $1.displayPriority }
    }
    
    /// Returns dispute types grouped by category
    var groupedByCategory: [DisputeCategory: [DisputeType]] {
        return Dictionary(grouping: self) { $0.category }
    }
}

// MARK: - Debug Support

#if DEBUG
extension DisputeType {
    
    /// Debug description with all properties
    var debugDescription: String {
        return """
        DisputeType: \(rawValue)
        Display Name: \(displayName)
        Category: \(category.rawValue)
        Priority: \(displayPriority)
        Requires Amount: \(requiresMonetaryAmount)
        Supports Hourly: \(supportsHourlyRate)
        Supports Fixed: \(supportsFixedFee)
        Supports Bracket: \(supportsBracketCalculation)
        """
    }
    
    /// Validates all tariff data for this dispute type
    func validateTariffData() -> Bool {
        let currentRate = getHourlyRate()
        let currentFixed = getFixedFee(partyCount: 2)
        let currentMinimum = getMinimumFee()
        
        return currentRate > 0 && currentFixed > 0 && currentMinimum > 0
    }
}
#endif
