//
//  TariffYear.swift
//  Denklem
//
//  Created by ozkan on 22.07.2025.
//

import Foundation

// MARK: - Tariff Year
/// Domain model representing different tariff years with their properties and business logic
/// Provides type-safe access to tariff years with validation and data access methods
enum TariffYear: Int, CaseIterable, Identifiable, Hashable {
    case year2025 = 2025
    case year2026 = 2026
    
    // MARK: - Identifiable Conformance
    
    var id: Int { rawValue }
    
    // MARK: - Static Properties
    
    /// Current active tariff year (automatically determined based on current date)
    static var current: TariffYear {
        let currentYear = Calendar.current.component(.year, from: Date())
        return TariffYear(rawValue: currentYear) ?? .year2026
    }
    
    /// Default tariff year for calculations
    static var `default`: TariffYear {
        return .year2025
    }
    
    /// All available tariff years ordered chronologically
    static var availableYears: [TariffYear] {
        return TariffYear.allCases.sorted { $0.rawValue < $1.rawValue }
    }
    
    /// All available years as integers
    static var availableYearValues: [Int] {
        return availableYears.map { $0.rawValue }
    }
    
    // MARK: - Display Properties
    
    /// Display name for the tariff year
    var displayName: String {
        switch self {
        case .year2025:
            return "2025"
        case .year2026:
            return "2026"
        }
    }
    
    /// Full display name with context
    var fullDisplayName: String {
        switch self {
        case .year2025:
            return NSLocalizedString("tariff_year.2025", value: "2025 Tarifesi", comment: "2025 Tariff year")
        case .year2026:
            return NSLocalizedString("tariff_year.2026", value: "2026 Tarifesi", comment: "2026 Tariff year")
        }
    }
    
    /// Description for the tariff year
    var description: String {
        switch self {
        case .year2025:
            return NSLocalizedString("tariff_year.2025.description", value: "2025 yılı resmi arabuluculuk tarifeleri", comment: "2025 official mediation tariffs")
        case .year2026:
            return NSLocalizedString("tariff_year.2026.description", value: "2026 yılı resmi arabuluculuk tarifeleri", comment: "2026 official mediation tariffs")
        }
    }
    
    // MARK: - Business Logic Properties
    
    /// Whether this tariff year is currently active
    var isActive: Bool {
        return self == TariffYear.current
    }
    
    /// Whether this tariff year is finalized (not estimated)
    var isFinalized: Bool {
        switch self {
        case .year2025:
            return true
        case .year2026:
            return true  // Official 2026 tariff
        }
    }
    
    /// Whether this tariff year is supported for calculations
    var isSupported: Bool {
        return TariffConstants.availableYears.contains(self.rawValue)
    }
    
    /// Whether this is a future tariff year
    var isFuture: Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        return self.rawValue > currentYear
    }
    
    /// Whether this is a past tariff year
    var isPast: Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        return self.rawValue < currentYear
    }
    
    /// Status icon for UI display
    var statusIcon: String {
        if !isFinalized {
            return "exclamationmark.triangle"
        } else if isActive {
            return "checkmark.circle.fill"
        } else {
            return "clock"
        }
    }
    
    /// Status color for UI display
    var statusColor: String {
        if !isFinalized {
            return "orange"
        } else if isActive {
            return "green"
        } else {
            return "gray"
        }
    }
    
    // MARK: - Tariff Data Access
    
    /// Returns the appropriate tariff protocol implementation for this year
    /// - Returns: TariffProtocol implementation for this year
    func getTariffProtocol() -> TariffProtocol {
        if let tariff = TariffFactory.createTariff(for: self.rawValue) {
            return tariff
        }
        
        // Fallback to default year if creation fails
        if let defaultTariff = TariffFactory.createTariff(for: TariffYear.default.rawValue) {
            return defaultTariff
        }
        
        // Final fallback - should not happen in normal operation
        return Tariff2025.create()
    }
    
    /// Returns hourly rate for specific dispute type
    /// - Parameter disputeType: Dispute type to get rate for
    /// - Returns: Hourly rate in Turkish Lira
    func getHourlyRate(for disputeType: String) -> Double {
        let tariff = getTariffProtocol()
        return tariff.getHourlyRate(for: disputeType)
    }
    
    /// Returns fixed fee for specific dispute type and party count
    /// - Parameters:
    ///   - disputeType: Dispute type to get fee for
    ///   - partyCount: Number of parties in the dispute
    /// - Returns: Fixed fee in Turkish Lira
    func getFixedFee(for disputeType: String, partyCount: Int) -> Double {
        let tariff = getTariffProtocol()
        return tariff.getFixedFee(for: disputeType, partyCount: partyCount)
    }
    
    /// Returns minimum fee for specific dispute type
    /// - Parameter disputeType: Dispute type to get minimum fee for
    /// - Returns: Minimum fee in Turkish Lira
    func getMinimumFee(for disputeType: String) -> Double {
        let tariff = getTariffProtocol()
        return tariff.getMinimumFee(for: disputeType)
    }
    
    /// Calculates non-agreement fee for specific dispute type and party count
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - partyCount: Number of parties
    /// - Returns: Calculated fee in Turkish Lira
    func calculateNonAgreementFee(disputeType: String, partyCount: Int) -> Double {
        let tariff = getTariffProtocol()
        return tariff.calculateNonAgreementFee(disputeType: disputeType, partyCount: partyCount)
    }
    
    /// Calculates agreement fee for specific dispute type, amount, and party count
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - amount: Dispute amount
    ///   - partyCount: Number of parties
    /// - Returns: Calculated fee in Turkish Lira
    func calculateAgreementFee(disputeType: String, amount: Double, partyCount: Int) -> Double {
        let tariff = getTariffProtocol()
        return tariff.calculateAgreementFee(disputeType: disputeType, amount: amount, partyCount: partyCount)
    }
    
    /// Calculates non-monetary fee for specific dispute type and party count
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - partyCount: Number of parties
    /// - Returns: Calculated fee in Turkish Lira
    func calculateNonMonetaryFee(disputeType: String, partyCount: Int) -> Double {
        let tariff = getTariffProtocol()
        return tariff.calculateNonMonetaryFee(disputeType: disputeType, partyCount: partyCount)
    }
    
    // MARK: - Validation Methods
    
    /// Validates if this tariff year supports the given dispute type
    /// - Parameter disputeType: Dispute type to validate
    /// - Returns: Validation result with success or error details
    func validateDisputeType(_ disputeType: String) -> ValidationResult {
        let tariff = getTariffProtocol()
        
        guard tariff.supportsDisputeType(disputeType) else {
            return .failure(
                code: ValidationConstants.DisputeType.validationErrorCode,
                message: NSLocalizedString("validation.dispute_type_not_supported_in_year", 
                                         value: "Dispute type not supported in tariff year", 
                                         comment: "validation message")
            )
        }
        
        return .success
    }
    
    /// Validates calculation input for this tariff year
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - amount: Dispute amount (optional)
    ///   - partyCount: Number of parties
    /// - Returns: Validation result with success or error details
    func validateCalculationInput(disputeType: String, amount: Double?, partyCount: Int) -> ValidationResult {
        let tariff = getTariffProtocol()
        
        // Basic validation using standard protocol methods
        guard tariff.supportsDisputeType(disputeType) else {
            return .failure(
                code: ValidationConstants.DisputeType.validationErrorCode,
                message: "Dispute type not supported in this tariff year"
            )
        }
        
        // Validate party count using ValidationConstants
        if partyCount < TariffConstants.minimumPartyCount || partyCount > TariffConstants.maximumPartyCount {
            return .failure(
                code: ValidationConstants.PartyCount.validationErrorCode,
                message: "Invalid party count"
            )
        }
        
        // Validate amount if provided using ValidationConstants
        if let amount = amount {
            if amount < TariffConstants.minimumAmount || amount > TariffConstants.maximumAmount {
                return .failure(
                    code: ValidationConstants.Amount.validationErrorCode,
                    message: "Invalid amount"
                )
            }
        }
        
        return .success
    }
    
    /// Validates if this tariff year is available for calculations
    /// - Returns: Validation result with success or error details
    func validateAvailability() -> ValidationResult {
        guard isSupported else {
            return .failure(
                code: ValidationConstants.Year.validationErrorCode,
                message: NSLocalizedString("validation.year_not_supported", 
                                         value: "Year not supported",
                                         comment: "validation message")
            )
        }
        
        return .success
    }
    
    // MARK: - Factory Methods
    
    /// Creates TariffYear from integer value
    /// - Parameter year: Year as integer
    /// - Returns: TariffYear enum case or nil if invalid
    static func from(_ year: Int) -> TariffYear? {
        return TariffYear(rawValue: year)
    }
    
    /// Creates TariffYear from string value
    /// - Parameter yearString: Year as string
    /// - Returns: TariffYear enum case or nil if invalid
    static func from(_ yearString: String) -> TariffYear? {
        guard let year = Int(yearString) else { return nil }
        return TariffYear(rawValue: year)
    }
    
    /// Returns the most recent available tariff year
    /// - Returns: Most recent TariffYear
    static var latest: TariffYear {
        return availableYears.last ?? .default
    }
    
    /// Returns the earliest available tariff year
    /// - Returns: Earliest TariffYear
    static var earliest: TariffYear {
        return availableYears.first ?? .default
    }
}

// MARK: - TariffYear Comparable

extension TariffYear: Comparable {
    static func < (lhs: TariffYear, rhs: TariffYear) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - TariffYear Extensions

extension TariffYear {
    
    /// Returns warning message if tariff is not finalized
    var warningMessage: String? {
        guard !isFinalized else { return nil }
        
        return NSLocalizedString("tariff_year.warning.estimated", 
                                value: "⚠️ Bu tarife tahmini değerlerdir, resmi değildir", 
                                comment: "Estimated tariff warning")
    }
    
    /// Returns status message for UI display
    var statusMessage: String {
        if !isFinalized {
            return NSLocalizedString("tariff_year.status.estimated", 
                                    value: "Tahmini", 
                                    comment: "Estimated status")
        } else if isActive {
            return NSLocalizedString("tariff_year.status.current", 
                                    value: "Geçerli", 
                                    comment: "Current status")
        } else if isFuture {
            return NSLocalizedString("tariff_year.status.future", 
                                    value: "Gelecek", 
                                    comment: "Future status")
        } else {
            return NSLocalizedString("tariff_year.status.past", 
                                    value: "Geçmiş", 
                                    comment: "Past status")
        }
    }
    
    /// Returns formatted year for display
    var formattedYear: String {
        return "\(rawValue)"
    }
    
    /// Returns year with currency symbol
    var yearWithCurrency: String {
        return "\(rawValue) (\(TariffConstants.currencySymbol))"
    }
}

// MARK: - Collection Extensions

extension Collection where Element == TariffYear {
    
    /// Returns years ordered chronologically
    var chronological: [TariffYear] {
        return sorted { $0.rawValue < $1.rawValue }
    }
    
    /// Returns years ordered reverse chronologically
    var reverseChronological: [TariffYear] {
        return sorted { $0.rawValue > $1.rawValue }
    }
    
    /// Returns only finalized tariff years
    var finalizedOnly: [TariffYear] {
        return filter { $0.isFinalized }
    }
    
    /// Returns only estimated tariff years
    var estimatedOnly: [TariffYear] {
        return filter { !$0.isFinalized }
    }
    
    /// Returns only supported tariff years
    var supportedOnly: [TariffYear] {
        return filter { $0.isSupported }
    }
}

// MARK: - Compatibility with Integer APIs

extension TariffYear {
    
    /// Converts to TariffConstants year format
    var toTariffConstantsYear: Int {
        return rawValue
    }
    
    /// Converts to string for API compatibility
    var toString: String {
        return String(rawValue)
    }
    
    /// Creates from TariffConstants available years
    static func fromTariffConstants(_ year: Int) -> TariffYear? {
        guard TariffConstants.availableYears.contains(year) else { return nil }
        return TariffYear(rawValue: year)
    }
}

// MARK: - Debug Support

#if DEBUG
extension TariffYear {
    
    /// Debug description for development
    var debugDescription: String {
        var details = [
            "Year: \(rawValue)",
            "Active: \(isActive)",
            "Finalized: \(isFinalized)",
            "Supported: \(isSupported)",
            "Status: \(statusMessage)"
        ]
        
        if let warning = warningMessage {
            details.append("Warning: \(warning)")
        }
        
        return "TariffYear(\(details.joined(separator: ", ")))"
    }
    
    /// Test data for development
    static var testData: [TariffYear] {
        return TariffYear.allCases
    }
    
    /// Sample calculation for testing
    func sampleCalculation() -> String {
        let disputeType = DisputeConstants.DisputeTypeKeys.commercial
        let partyCount = 3
        let amount = 50000.0
        
        let nonAgreementFee = calculateNonAgreementFee(disputeType: disputeType, partyCount: partyCount)
        let agreementFee = calculateAgreementFee(disputeType: disputeType, amount: amount, partyCount: partyCount)
        
        return """
        Sample Calculation for \(displayName):
        - Dispute Type: Commercial
        - Party Count: \(partyCount)
        - Amount: \(amount) TL
        - Non-Agreement Fee: \(nonAgreementFee) TL
        - Agreement Fee: \(agreementFee) TL
        """
    }
}
#endif
