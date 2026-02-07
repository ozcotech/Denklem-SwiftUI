//
//  MediationFee.swift
//  Denklem
//
//  Created by ozkan on 22.07.2025.
//

import Foundation

// MARK: - Type Aliases for MediationFee

/// Type alias for calculation types from TariffConstants
typealias MediationFeeCalculationType = CalculationType

/// Type alias for agreement status from TariffConstants  
typealias MediationFeeAgreementStatus = AgreementStatus

// MARK: - MediationFee Extensions for Type Aliases

extension CalculationType {
    /// Whether this calculation type requires dispute amount
    var requiresDisputeAmount: Bool {
        switch self {
        case .monetary, .smmCalculation:
            return true
        case .nonMonetary, .timeCalculation:
            return false
        }
    }
}

// MARK: - Mediation Fee
/// Domain model representing a calculated mediation fee
/// Encapsulates fee amount, calculation details, and formatted display values
struct MediationFee {
    
    // MARK: - Core Properties
    
    /// The calculated fee amount in Turkish Lira
    let amount: Double
    
    /// Currency code (from TariffConstants.currencyCode)
    let currency: String
    
    /// Dispute type used in calculation
    let disputeType: DisputeType
    
    /// Tariff year used in calculation
    let tariffYear: TariffYear
    
    // MARK: - Calculation Context
    
    /// Type of calculation performed
    let calculationType: CalculationType
    
    /// Agreement status in the dispute
    let agreementStatus: AgreementStatus
    
    /// Number of parties in the dispute
    let partyCount: Int
    
    /// Dispute amount (optional, for monetary disputes)
    let disputeAmount: Double?
    
    /// Timestamp when fee was calculated
    let calculationDate: Date
    
    // MARK: - Calculation Details
    
    /// Detailed breakdown of calculation steps
    let calculationBreakdown: CalculationBreakdown
    
    /// Whether the calculation used minimum fee rule
    let usedMinimumFee: Bool
    
    /// Whether the calculation used bracket system
    let usedBracketCalculation: Bool
    
    /// Base fee before any adjustments
    let baseFee: Double
    
    /// Applied rate or multiplier (if any)
    let appliedRate: Double?
    
    // MARK: - Computed Properties
    
    /// Formatted amount with currency symbol
    var formattedAmount: String {
        return LocalizationHelper.formatCurrencyForDisplay(amount)
    }
    
    /// Formatted amount for export/CSV
    var formattedAmountForExport: String {
        return LocalizationHelper.formatCurrencyForExport(amount)
    }
    
    /// Compact formatted amount (no decimals for whole numbers)
    var formattedAmountCompact: String {
        return LocalizationHelper.formatCurrencyCompact(amount)
    }
    
    /// Detailed description of the fee calculation
    var detailedDescription: String {
        var description = ""
        
        // Basic info
        description += "\(disputeType.displayName) - \(agreementStatus.displayName)\n"
        description += "\(NSLocalizedString(LocalizationKeys.Result.partyCount, comment: "")): \(partyCount)\n"
        
        // Amount if monetary
        if let disputeAmount = disputeAmount {
            description += "\(NSLocalizedString(LocalizationKeys.General.calculate, comment: "")): \(LocalizationHelper.formatCurrencyForDisplay(disputeAmount))\n"
        }
        
        // Calculation type
        description += "\(NSLocalizedString(LocalizationKeys.General.calculate, comment: "")): \(calculationType.displayName)\n"
        
        // Tariff year
        description += "\(NSLocalizedString(LocalizationKeys.General.calculate, comment: "")): \(tariffYear.displayName)\n"
        
        // Final fee
        description += "\(NSLocalizedString(LocalizationKeys.General.calculate, comment: "")): \(formattedAmount)"
        
        return description
    }
    
    /// Short summary for quick display
    var summary: String {
        return "\(formattedAmount) - \(disputeType.displayName)"
    }
    
    /// Validation status
    var isValid: Bool {
        return amount > 0 && 
               amount <= TariffConstants.maximumAmount &&
               partyCount >= TariffConstants.minimumPartyCount &&
               partyCount <= TariffConstants.maximumPartyCount
    }
    
    // MARK: - Initializers
    
    /// Main initializer for MediationFee
    /// - Parameters:
    ///   - amount: Calculated fee amount
    ///   - disputeType: Type of dispute
    ///   - tariffYear: Tariff year used
    ///   - calculationType: Type of calculation
    ///   - agreementStatus: Agreement status
    ///   - partyCount: Number of parties
    ///   - disputeAmount: Dispute amount (optional)
    ///   - calculationBreakdown: Detailed calculation steps
    ///   - usedMinimumFee: Whether minimum fee was applied
    ///   - usedBracketCalculation: Whether bracket calculation was used
    ///   - baseFee: Base fee before adjustments
    ///   - appliedRate: Applied rate or multiplier
    init(amount: Double,
         disputeType: DisputeType,
         tariffYear: TariffYear,
         calculationType: CalculationType,
         agreementStatus: AgreementStatus,
         partyCount: Int,
         disputeAmount: Double? = nil,
         calculationBreakdown: CalculationBreakdown,
         usedMinimumFee: Bool = false,
         usedBracketCalculation: Bool = false,
         baseFee: Double,
         appliedRate: Double? = nil) {
        
        self.amount = amount
        self.currency = TariffConstants.currencyCode
        self.disputeType = disputeType
        self.tariffYear = tariffYear
        self.calculationType = calculationType
        self.agreementStatus = agreementStatus
        self.partyCount = partyCount
        self.disputeAmount = disputeAmount
        self.calculationDate = Date()
        self.calculationBreakdown = calculationBreakdown
        self.usedMinimumFee = usedMinimumFee
        self.usedBracketCalculation = usedBracketCalculation
        self.baseFee = baseFee
        self.appliedRate = appliedRate
    }
    
    /// Convenience initializer for simple fee calculations
    /// - Parameters:
    ///   - amount: Calculated fee amount
    ///   - disputeType: Type of dispute
    ///   - tariffYear: Tariff year used
    ///   - calculationType: Type of calculation
    ///   - agreementStatus: Agreement status
    ///   - partyCount: Number of parties
    init(amount: Double,
         disputeType: DisputeType,
         tariffYear: TariffYear,
         calculationType: CalculationType,
         agreementStatus: AgreementStatus,
         partyCount: Int) {
        
        let breakdown = CalculationBreakdown(
            steps: ["Basic calculation performed"],
            finalAmount: amount
        )
        
        self.init(
            amount: amount,
            disputeType: disputeType,
            tariffYear: tariffYear,
            calculationType: calculationType,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            calculationBreakdown: breakdown,
            baseFee: amount
        )
    }
}

// MARK: - Bracket Breakdown Step
/// Represents a single step in the bracket fee calculation
struct BracketBreakdownStep {
    /// The amount within this bracket tier
    let tierAmount: Double
    /// The rate applied to this tier (e.g., 0.06 for 6%)
    let rate: Double
    /// The fee calculated for this tier
    let calculatedFee: Double
    /// The cumulative upper limit of this bracket
    let bracketLimit: Double
    /// The lower bound of this bracket
    let bracketLowerBound: Double
}

// MARK: - Calculation Breakdown
/// Detailed breakdown of fee calculation steps
struct CalculationBreakdown {
    
    /// Step-by-step calculation description
    let steps: [String]
    
    /// Final calculated amount
    let finalAmount: Double
    
    /// Additional calculation details
    let details: [String: Any]
    
    /// Whether calculation used minimum fee rule
    let usedMinimumFee: Bool
    
    /// Whether calculation used bracket system
    let usedBracketSystem: Bool
    
    /// Hourly rate used (if applicable)
    let hourlyRate: Double?
    
    /// Fixed fee used (if applicable)
    let fixedFee: Double?

    /// Minimum fee threshold (if applicable)
    let minimumFeeThreshold: Double?

    /// Bracket breakdown steps (for agreement cases)
    let bracketSteps: [BracketBreakdownStep]

    /// Bracket total before minimum fee comparison
    let bracketTotal: Double?

    // MARK: - Initializers

    init(steps: [String],
         finalAmount: Double,
         details: [String: Any] = [:],
         usedMinimumFee: Bool = false,
         usedBracketSystem: Bool = false,
         hourlyRate: Double? = nil,
         fixedFee: Double? = nil,
         minimumFeeThreshold: Double? = nil,
         bracketSteps: [BracketBreakdownStep] = [],
         bracketTotal: Double? = nil) {

        self.steps = steps
        self.finalAmount = finalAmount
        self.details = details
        self.usedMinimumFee = usedMinimumFee
        self.usedBracketSystem = usedBracketSystem
        self.hourlyRate = hourlyRate
        self.fixedFee = fixedFee
        self.minimumFeeThreshold = minimumFeeThreshold
        self.bracketSteps = bracketSteps
        self.bracketTotal = bracketTotal
    }
    
    /// Formatted breakdown for display
    var formattedBreakdown: String {
        var result = ""
        
        for (index, step) in steps.enumerated() {
            result += "\(index + 1). \(step)\n"
        }
        
        if usedMinimumFee {
            result += "\n• \(NSLocalizedString(LocalizationKeys.General.info, comment: ""))"
        }
        
        if usedBracketSystem {
            result += "\n• \(NSLocalizedString(LocalizationKeys.General.info, comment: ""))"
        }
        
        return result
    }
}

// MARK: - MediationFee Extensions

extension MediationFee {
    
    // MARK: - Validation Methods
    
    /// Validates the mediation fee using ValidationConstants
    /// - Returns: ValidationResult with success or error details
    func validate() -> ValidationResult {
        var errors: [String] = []
        
        // Validate amount
        if amount <= 0 {
            errors.append(NSLocalizedString(LocalizationKeys.General.error, comment: ""))
        }
        
        if amount > TariffConstants.maximumAmount {
            errors.append(NSLocalizedString(LocalizationKeys.General.error, comment: ""))
        }
        
        // Validate party count
        if !TariffConstants.isValidPartyCount(partyCount) {
            errors.append(TariffConstants.getPartyCountValidationError(for: partyCount))
        }
        
        // Validate dispute amount if required
        if calculationType.requiresDisputeAmount && disputeAmount == nil {
            errors.append(NSLocalizedString(LocalizationKeys.General.error, comment: ""))
        }
        
        if let disputeAmount = disputeAmount, !TariffConstants.isValidAmount(disputeAmount) {
            errors.append(TariffConstants.getAmountValidationError(for: disputeAmount))
        }
        
        // Return validation result
        if errors.isEmpty {
            return ValidationResult.success
        } else {
            return ValidationResult.failure(code: 1001, message: errors.joined(separator: ", "))
        }
    }
    
    // MARK: - Comparison Methods
    
    /// Compares this fee with another for sorting
    /// - Parameter other: Other MediationFee to compare
    /// - Returns: Comparison result
    func compare(with other: MediationFee) -> ComparisonResult {
        if amount < other.amount {
            return .orderedAscending
        } else if amount > other.amount {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
    
    // MARK: - Export Methods
    
    /// Returns fee data for CSV export
    /// - Returns: Dictionary with exportable data
    func toExportData() -> [String: Any] {
        var data: [String: Any] = [
            "amount": formattedAmountForExport,
            "currency": currency,
            "disputeType": disputeType.displayName,
            "tariffYear": tariffYear.rawValue,
            "calculationType": calculationType.displayName,
            "agreementStatus": agreementStatus.displayName,
            "partyCount": partyCount,
            "calculationDate": LocalizationHelper.formatDateForExport(calculationDate),
            "usedMinimumFee": usedMinimumFee,
            "usedBracketCalculation": usedBracketCalculation,
            "baseFee": LocalizationHelper.formatCurrencyForExport(baseFee)
        ]
        
        if let disputeAmount = disputeAmount {
            data["disputeAmount"] = LocalizationHelper.formatCurrencyForExport(disputeAmount)
        }
        
        if let appliedRate = appliedRate {
            data["appliedRate"] = LocalizationHelper.formatPercentage(appliedRate)
        }
        
        return data
    }
    
    /// Returns JSON representation
    /// - Returns: JSON data
    func toJSON() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return try? encoder.encode(self)
    }
}

// MARK: - MediationFee Codable
extension MediationFee: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case disputeType
        case tariffYear
        case calculationType
        case agreementStatus
        case partyCount
        case disputeAmount
        case calculationDate
        case calculationBreakdown
        case usedMinimumFee
        case usedBracketCalculation
        case baseFee
        case appliedRate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(Double.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
        
        // Decode DisputeType from string
        let disputeTypeString = try container.decode(String.self, forKey: .disputeType)
        disputeType = DisputeType(rawValue: disputeTypeString) ?? .other
        
        // Decode TariffYear from int
        let tariffYearInt = try container.decode(Int.self, forKey: .tariffYear)
        tariffYear = TariffYear(rawValue: tariffYearInt) ?? .year2025
        
        // Decode CalculationType from string
        let calculationTypeString = try container.decode(String.self, forKey: .calculationType)
        calculationType = CalculationType(rawValue: calculationTypeString) ?? .monetary
        
        // Decode AgreementStatus from string
        let agreementStatusString = try container.decode(String.self, forKey: .agreementStatus)
        agreementStatus = AgreementStatus(rawValue: agreementStatusString) ?? .notAgreed
        
        partyCount = try container.decode(Int.self, forKey: .partyCount)
        disputeAmount = try container.decodeIfPresent(Double.self, forKey: .disputeAmount)
        calculationDate = try container.decode(Date.self, forKey: .calculationDate)
        calculationBreakdown = try container.decode(CalculationBreakdown.self, forKey: .calculationBreakdown)
        usedMinimumFee = try container.decode(Bool.self, forKey: .usedMinimumFee)
        usedBracketCalculation = try container.decode(Bool.self, forKey: .usedBracketCalculation)
        baseFee = try container.decode(Double.self, forKey: .baseFee)
        appliedRate = try container.decodeIfPresent(Double.self, forKey: .appliedRate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(disputeType.rawValue, forKey: .disputeType)
        try container.encode(tariffYear.rawValue, forKey: .tariffYear)
        try container.encode(calculationType.rawValue, forKey: .calculationType)
        try container.encode(agreementStatus.rawValue, forKey: .agreementStatus)
        try container.encode(partyCount, forKey: .partyCount)
        try container.encodeIfPresent(disputeAmount, forKey: .disputeAmount)
        try container.encode(calculationDate, forKey: .calculationDate)
        try container.encode(calculationBreakdown, forKey: .calculationBreakdown)
        try container.encode(usedMinimumFee, forKey: .usedMinimumFee)
        try container.encode(usedBracketCalculation, forKey: .usedBracketCalculation)
        try container.encode(baseFee, forKey: .baseFee)
        try container.encodeIfPresent(appliedRate, forKey: .appliedRate)
    }
}

// MARK: - BracketBreakdownStep Codable
extension BracketBreakdownStep: Codable {}

// MARK: - CalculationBreakdown Codable
extension CalculationBreakdown: Codable {

    private enum CodingKeys: String, CodingKey {
        case steps
        case finalAmount
        case usedMinimumFee
        case usedBracketSystem
        case hourlyRate
        case fixedFee
        case minimumFeeThreshold
        case bracketSteps
        case bracketTotal
    }

    // Custom encoding/decoding for details dictionary
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        steps = try container.decode([String].self, forKey: .steps)
        finalAmount = try container.decode(Double.self, forKey: .finalAmount)
        usedMinimumFee = try container.decodeIfPresent(Bool.self, forKey: .usedMinimumFee) ?? false
        usedBracketSystem = try container.decodeIfPresent(Bool.self, forKey: .usedBracketSystem) ?? false
        hourlyRate = try container.decodeIfPresent(Double.self, forKey: .hourlyRate)
        fixedFee = try container.decodeIfPresent(Double.self, forKey: .fixedFee)
        minimumFeeThreshold = try container.decodeIfPresent(Double.self, forKey: .minimumFeeThreshold)
        bracketSteps = try container.decodeIfPresent([BracketBreakdownStep].self, forKey: .bracketSteps) ?? []
        bracketTotal = try container.decodeIfPresent(Double.self, forKey: .bracketTotal)

        // Initialize details as empty for now
        details = [:]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(steps, forKey: .steps)
        try container.encode(finalAmount, forKey: .finalAmount)
        try container.encode(usedMinimumFee, forKey: .usedMinimumFee)
        try container.encode(usedBracketSystem, forKey: .usedBracketSystem)
        try container.encodeIfPresent(hourlyRate, forKey: .hourlyRate)
        try container.encodeIfPresent(fixedFee, forKey: .fixedFee)
        try container.encodeIfPresent(minimumFeeThreshold, forKey: .minimumFeeThreshold)
        try container.encode(bracketSteps, forKey: .bracketSteps)
        try container.encodeIfPresent(bracketTotal, forKey: .bracketTotal)
    }
}

// MARK: - MediationFee Factory
extension MediationFee {
    
    /// Creates MediationFee from calculation result
    /// - Parameters:
    ///   - amount: Calculated amount
    ///   - disputeType: Dispute type
    ///   - tariffYear: Tariff year
    ///   - calculationType: Calculation type
    ///   - agreementStatus: Agreement status
    ///   - partyCount: Party count
    ///   - disputeAmount: Dispute amount (optional)
    ///   - breakdown: Calculation breakdown
    /// - Returns: Configured MediationFee instance
    static func create(
        amount: Double,
        disputeType: DisputeType,
        tariffYear: TariffYear,
        calculationType: CalculationType,
        agreementStatus: AgreementStatus,
        partyCount: Int,
        disputeAmount: Double? = nil,
        breakdown: CalculationBreakdown? = nil
    ) -> MediationFee {
        
        let defaultBreakdown = breakdown ?? CalculationBreakdown(
            steps: [NSLocalizedString(LocalizationKeys.General.calculate, comment: "")],
            finalAmount: amount
        )
        
        return MediationFee(
            amount: amount,
            disputeType: disputeType,
            tariffYear: tariffYear,
            calculationType: calculationType,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            disputeAmount: disputeAmount,
            calculationBreakdown: defaultBreakdown,
            baseFee: amount
        )
    }
}
