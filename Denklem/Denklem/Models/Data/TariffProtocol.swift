//
//  TariffProtocol.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff Protocol
/// Protocol defining the interface for tariff data structures
/// This protocol ensures consistent data access across different tariff years
protocol TariffProtocol {
    
    // MARK: - Basic Properties
    
    /// The year this tariff applies to
    var year: Int { get }
    
    /// Display name for this tariff year
    var displayName: String { get }
    
    /// Whether this tariff is currently active
    var isActive: Bool { get }
    
    /// Whether this tariff data is finalized (not placeholder)
    var isFinalized: Bool { get }
    
    // MARK: - Minimum Hours Multiplier
    
    /// Minimum hours multiplier for non-agreement cases (year-specific)
    var minimumHoursMultiplier: Int { get }
    
    // MARK: - Hourly Rates
    
    /// Hourly rates for different dispute types
    /// Key: DisputeTypeKeys (e.g., "worker_employer", "commercial")
    /// Value: Hourly rate in Turkish Lira
    var hourlyRates: [String: Double] { get }
    
    /// Returns hourly rate for specific dispute type
    /// - Parameter disputeType: Dispute type key from DisputeConstants.DisputeTypeKeys
    /// - Returns: Hourly rate in TL, or default rate if not found
    func getHourlyRate(for disputeType: String) -> Double
    
    // MARK: - Fixed Fees
    
    /// Fixed fees by party count thresholds for different dispute types
    /// Key: DisputeTypeKeys (e.g., "worker_employer", "commercial")
    /// Value: Array of fees for [2-4, 5-9, 10-999, 1000+] parties
    var fixedFees: [String: [Double]] { get }
    
    /// Party count thresholds for fixed fee calculation
    /// Default: [2, 5, 10, Int.max] representing ranges [2-4], [5-9], [10-999], [1000+]
    var partyCountThresholds: [Int] { get }
    
    /// Returns fixed fee for specific dispute type and party count
    /// - Parameters:
    ///   - disputeType: Dispute type key from DisputeConstants.DisputeTypeKeys
    ///   - partyCount: Number of parties in the dispute
    /// - Returns: Fixed fee in TL for the party count range
    func getFixedFee(for disputeType: String, partyCount: Int) -> Double
    
    // MARK: - Minimum Fees
    
    /// Minimum fees for different categories
    /// Key: Category ("general", "commercial")
    /// Value: Minimum fee in Turkish Lira
    var minimumFees: [String: Double] { get }
    
    /// Returns minimum fee for specific dispute type
    /// - Parameter disputeType: Dispute type key
    /// - Returns: Minimum fee in TL (general or commercial)
    func getMinimumFee(for disputeType: String) -> Double
    
    // MARK: - Bracket Calculation (Agreement Cases)
    
    /// Calculation brackets for monetary disputes with agreement
    /// Each bracket contains: (upper limit in TL, percentage rate)
    /// Used for progressive calculation based on dispute amount
    var brackets: [(limit: Double, rate: Double)] { get }
    
    /// Calculates fee using bracket system for agreement cases
    /// - Parameter amount: Dispute amount in Turkish Lira
    /// - Returns: Calculated fee based on progressive brackets
    func calculateBracketFee(for amount: Double) -> Double
    
    // MARK: - Validation & Support
    
    /// Validates if dispute type is supported in this tariff
    /// - Parameter disputeType: Dispute type key to validate
    /// - Returns: True if supported, false otherwise
    func supportsDisputeType(_ disputeType: String) -> Bool
    
    /// Returns all supported dispute types for this tariff
    /// - Returns: Array of dispute type keys supported by this tariff
    func getSupportedDisputeTypes() -> [String]
    
    // MARK: - Calculation Methods
    
    /// Calculates mediation fee for monetary disputes without agreement
    /// Uses hourly rate × minimum 2 hours, compared with fixed fee
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - partyCount: Number of parties
    /// - Returns: Higher of (hourly rate × 2) or fixed fee
    func calculateNonAgreementFee(disputeType: String, partyCount: Int) -> Double
    
    /// Calculates mediation fee for monetary disputes with agreement
    /// Uses bracket calculation or minimum fee, whichever is higher
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - amount: Dispute amount in TL
    ///   - partyCount: Number of parties (for minimum fee comparison)
    /// - Returns: Higher of bracket calculation or minimum fee
    func calculateAgreementFee(disputeType: String, amount: Double, partyCount: Int) -> Double
    
    /// Calculates mediation fee for non-monetary disputes
    /// Uses fixed fee based on party count
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - partyCount: Number of parties
    /// - Returns: Fixed fee for the dispute type and party count
    func calculateNonMonetaryFee(disputeType: String, partyCount: Int) -> Double
}

// MARK: - Tariff Protocol Default Implementation
extension TariffProtocol {
    
    // MARK: - Default Display Properties
    
    var displayName: String {
        return "\(year) Tarife"
    }
    
    var isActive: Bool {
        return year == TariffConstants.currentYear
    }
    
    // MARK: - Default Calculation Methods
    
    func getHourlyRate(for disputeType: String) -> Double {
        return hourlyRates[disputeType] ?? hourlyRates[DisputeConstants.DisputeTypeKeys.other] ?? 785.0
    }
    
    func getFixedFee(for disputeType: String, partyCount: Int) -> Double {
        guard let fees = fixedFees[disputeType] else {
            // Fallback to 'other' dispute type fees
            return fixedFees[DisputeConstants.DisputeTypeKeys.other]?.first ?? 1570.0
        }
        
        // Find the appropriate fee index based on party count
        let thresholds = partyCountThresholds
        for (index, threshold) in thresholds.enumerated() {
            if partyCount <= threshold {
                // Safe array access with bounds checking
                if index < fees.count {
                    return fees[index]
                } else {
                    // If index is out of bounds, return last available fee
                    return fees.last ?? 1570.0
                }
            }
        }
        
        // If no threshold matched, return last fee
        return fees.last ?? 1570.0
    }
    
    func getMinimumFee(for disputeType: String) -> Double {
        // Commercial disputes have higher minimum fee
        if disputeType == DisputeConstants.DisputeTypeKeys.commercial {
            return minimumFees["commercial"] ?? 9000.0
        }
        return minimumFees["general"] ?? 6000.0
    }
    
    func calculateBracketFee(for amount: Double) -> Double {
        var totalFee: Double = 0.0
        var remainingAmount = amount
        var previousLimit: Double = 0.0
        
        for bracket in brackets {
            let bracketLimit = bracket.limit
            let bracketRate = bracket.rate
            
            if remainingAmount <= 0 {
                break
            }
            
            let bracketAmount: Double
            if bracketLimit == Double.infinity {
                bracketAmount = remainingAmount
            } else {
                bracketAmount = min(remainingAmount, bracketLimit - previousLimit)
            }
            
            totalFee += bracketAmount * bracketRate
            remainingAmount -= bracketAmount
            previousLimit = bracketLimit
            
            if bracketLimit == Double.infinity {
                break
            }
        }
        
        return totalFee
    }
    
    func supportsDisputeType(_ disputeType: String) -> Bool {
        return hourlyRates.keys.contains(disputeType) && fixedFees.keys.contains(disputeType)
    }
    
    func getSupportedDisputeTypes() -> [String] {
        let hourlyRateTypes = Set(hourlyRates.keys)
        let fixedFeeTypes = Set(fixedFees.keys)
        return Array(hourlyRateTypes.intersection(fixedFeeTypes)).sorted()
    }
    
    // MARK: - Main Calculation Methods
    
    func calculateNonAgreementFee(disputeType: String, partyCount: Int) -> Double {
        // Non-agreement: Use fixed fee multiplied by minimum hours
        let fixedFee = getFixedFee(for: disputeType, partyCount: partyCount)
        return fixedFee * Double(minimumHoursMultiplier)
    }
    
    func calculateAgreementFee(disputeType: String, amount: Double, partyCount: Int) -> Double {
        let bracketFee = calculateBracketFee(for: amount)
        let minimumFee = getMinimumFee(for: disputeType)
        
        // Return the higher of bracket calculation or minimum fee
        return max(bracketFee, minimumFee)
    }
    
    func calculateNonMonetaryFee(disputeType: String, partyCount: Int) -> Double {
        // Non-monetary: Use fixed fee multiplied by minimum hours
        let fixedFee = getFixedFee(for: disputeType, partyCount: partyCount)
        return fixedFee * Double(minimumHoursMultiplier)
    }
}

// MARK: - Tariff Validation Protocol
/// Additional protocol for tariff data validation
protocol TariffValidationProtocol {
    
    /// Validates all tariff data for consistency
    /// - Returns: ValidationResult indicating success or failure with details
    func validateTariffData() -> ValidationResult
    
    /// Validates hourly rates are within expected ranges
    /// - Returns: ValidationResult for hourly rates
    func validateHourlyRates() -> ValidationResult
    
    /// Validates fixed fees are properly structured
    /// - Returns: ValidationResult for fixed fees
    func validateFixedFees() -> ValidationResult
    
    /// Validates minimum fees are reasonable
    /// - Returns: ValidationResult for minimum fees
    func validateMinimumFees() -> ValidationResult
    
    /// Validates bracket calculation setup
    /// - Returns: ValidationResult for brackets
    func validateBrackets() -> ValidationResult
    
    /// Validates calculation input for this tariff
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - amount: Dispute amount (optional)
    ///   - partyCount: Number of parties
    /// - Returns: Validation result with success or error details
    func validateCalculationInput(disputeType: String, amount: Double?, partyCount: Int) -> ValidationResult
}

// MARK: - Tariff Factory Protocol
/// Protocol for creating tariff instances
protocol TariffFactoryProtocol {
    
    /// Creates a tariff instance for the specified year
    /// - Parameter year: Tariff year to create
    /// - Returns: TariffProtocol instance or nil if year not supported
    static func createTariff(for year: Int) -> TariffProtocol?
    
    /// Returns all available tariff years
    /// - Returns: Array of available years
    static func getAvailableYears() -> [Int]
    
    /// Returns the current active tariff
    /// - Returns: Currently active TariffProtocol instance
    static func getCurrentTariff() -> TariffProtocol
    
    /// Validates if a year is supported
    /// - Parameter year: Year to validate
    /// - Returns: True if supported, false otherwise
    static func isYearSupported(_ year: Int) -> Bool
}

// MARK: - Tariff Factory Implementation
/// Concrete implementation of TariffFactoryProtocol for creating tariff instances
struct TariffFactory: TariffFactoryProtocol {
    
    /// Creates a tariff instance for the specified year
    /// - Parameter year: Tariff year to create (2025, 2026, etc.)
    /// - Returns: TariffProtocol instance or nil if year not supported
    static func createTariff(for year: Int) -> TariffProtocol? {
        switch year {
        case 2025:
            return Tariff2025()
        case 2026:
            return Tariff2026()
        default:
            return nil
        }
    }
    
    /// Returns all available tariff years from TariffConstants
    /// - Returns: Array of supported years [2025, 2026]
    static func getAvailableYears() -> [Int] {
        return TariffConstants.availableYears
    }
    
    /// Returns the current active tariff based on TariffConstants.currentYear
    /// - Returns: Currently active TariffProtocol instance (defaults to 2025 if creation fails)
    static func getCurrentTariff() -> TariffProtocol {
        return createTariff(for: TariffConstants.currentYear) ?? Tariff2025()
    }
    
    /// Validates if a year is supported by checking TariffConstants.availableYears
    /// - Parameter year: Year to validate
    /// - Returns: True if year is in availableYears array, false otherwise
    static func isYearSupported(_ year: Int) -> Bool {
        return TariffConstants.availableYears.contains(year)
    }
    
    // MARK: - Convenience Methods
    
    /// Returns all available tariff instances
    /// - Returns: Array of all available TariffProtocol instances
    static func getAllTariffs() -> [TariffProtocol] {
        return getAvailableYears().compactMap { createTariff(for: $0) }
    }
    
    /// Creates tariff with validation
    /// - Parameter year: Year to create tariff for
    /// - Returns: Result containing tariff or error
    static func createTariffWithValidation(for year: Int) -> Result<TariffProtocol, TariffFactoryError> {
        guard isYearSupported(year) else {
            return .failure(.unsupportedYear(year))
        }
        
        guard let tariff = createTariff(for: year) else {
            return .failure(.creationFailed(year))
        }
        
        return .success(tariff)
    }
}

// MARK: - Tariff Factory Error
/// Errors that can occur during tariff creation
enum TariffFactoryError: Error, LocalizedError {
    case unsupportedYear(Int)
    case creationFailed(Int)
    
    var errorDescription: String? {
        switch self {
        case .unsupportedYear(let year):
            return NSLocalizedString(LocalizationKeys.ErrorMessage.unsupportedYear, comment: "Unsupported year error") + ": \(year)"
        case .creationFailed(let year):
            return NSLocalizedString(LocalizationKeys.ErrorMessage.tariffCreationFailed, comment: "Tariff creation failed") + ": \(year)"
        }
    }
}
