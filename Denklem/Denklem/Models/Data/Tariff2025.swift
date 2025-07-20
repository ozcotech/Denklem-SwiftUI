//
//  Tariff2025.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff 2025 Implementation
/// Implementation of TariffProtocol for 2025 tariff data
/// Uses actual tariff rates and fees from TariffConstants.Tariff2025
struct Tariff2025: TariffProtocol {
    
    // MARK: - Basic Properties
    
    let year: Int = 2025
    
    let isFinalized: Bool = true
    
    // MARK: - Hourly Rates (from TariffConstants.Tariff2025)
    
    let hourlyRates: [String: Double] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: 785.0,
        DisputeConstants.DisputeTypeKeys.commercial: 1150.0,
        DisputeConstants.DisputeTypeKeys.consumer: 785.0,
        DisputeConstants.DisputeTypeKeys.rent: 835.0,
        DisputeConstants.DisputeTypeKeys.neighbor: 835.0,
        DisputeConstants.DisputeTypeKeys.condominium: 835.0,
        DisputeConstants.DisputeTypeKeys.family: 785.0,
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: 900.0,
        DisputeConstants.DisputeTypeKeys.other: 785.0
    ]
    
    // MARK: - Fixed Fees (from TariffConstants.Tariff2025)
    
    /// Fixed fees by dispute type and party count ranges
    /// Array indices: [0: 2-4 parties, 1: 5-9 parties, 2: 10-999 parties, 3: 1000+ parties]
    let fixedFees: [String: [Double]] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.commercial: [2300.0, 2350.0, 2450.0, 2550.0],
        DisputeConstants.DisputeTypeKeys.consumer: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.rent: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.neighbor: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.condominium: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.family: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: [1800.0, 2000.0, 2100.0, 2200.0],
        DisputeConstants.DisputeTypeKeys.other: [1570.0, 1650.0, 1750.0, 1850.0]
    ]
    
    /// Party count thresholds for fee calculation
    let partyCountThresholds: [Int] = [2, 5, 10, Int.max]
    
    // MARK: - Minimum Fees (from TariffConstants.Tariff2025)
    
    let minimumFees: [String: Double] = [
        "general": 6000.0,    // General minimum fee for most dispute types
        "commercial": 9000.0  // Higher minimum for commercial disputes
    ]
    
    // MARK: - Calculation Brackets (from TariffConstants.Tariff2025)
    
    /// Progressive calculation brackets for agreement cases
    /// Format: (upper limit, percentage rate)
    let brackets: [(limit: Double, rate: Double)] = [
        (300000.0, 0.06),       // 0-300,000 TL: 6%
        (780000.0, 0.05),       // 300,001-780,000 TL: 5%
        (1560000.0, 0.04),      // 780,001-1,560,000 TL: 4%
        (4680000.0, 0.03),      // 1,560,001-4,680,000 TL: 3%
        (6240000.0, 0.02),      // 4,680,001-6,240,000 TL: 2%
        (12480000.0, 0.015),    // 6,240,001-12,480,000 TL: 1.5%
        (26520000.0, 0.01),     // 12,480,001-26,520,000 TL: 1%
        (Double.infinity, 0.005) // 26,520,001+ TL: 0.5%
    ]
    
    // MARK: - Validation & Support Methods
    
    func supportsDisputeType(_ disputeType: String) -> Bool {
        return hourlyRates.keys.contains(disputeType) && fixedFees.keys.contains(disputeType)
    }
    
    func getSupportedDisputeTypes() -> [String] {
        return Array(hourlyRates.keys).sorted()
    }
    
    // MARK: - Fee Calculation Methods
    
    func getHourlyRate(for disputeType: String) -> Double {
        return hourlyRates[disputeType] ?? hourlyRates[DisputeConstants.DisputeTypeKeys.other] ?? 785.0
    }
    
    func getFixedFee(for disputeType: String, partyCount: Int) -> Double {
        // Get fees array for dispute type
        guard let fees = fixedFees[disputeType] else {
            // Fallback to 'other' type if not found
            guard let defaultFees = fixedFees[DisputeConstants.DisputeTypeKeys.other] else {
                return 1570.0 // Ultimate fallback
            }
            return getFixedFeeFromArray(defaultFees, partyCount: partyCount)
        }
        
        return getFixedFeeFromArray(fees, partyCount: partyCount)
    }
    
    /// Helper method to get fee from fees array based on party count
    private func getFixedFeeFromArray(_ fees: [Double], partyCount: Int) -> Double {
        // Determine fee index based on party count thresholds
        for (index, threshold) in partyCountThresholds.enumerated() {
            if partyCount < threshold {
                return fees[safe: index] ?? fees.last ?? 1570.0
            }
        }
        return fees.last ?? 1570.0
    }
    
    func getMinimumFee(for disputeType: String) -> Double {
        // Commercial disputes use higher minimum
        if disputeType == DisputeConstants.DisputeTypeKeys.commercial ||
           disputeType == DisputeConstants.DisputeTypeKeys.partnershipDissolution {
            return minimumFees["commercial"] ?? 9000.0
        }
        
        // All other disputes use general minimum
        return minimumFees["general"] ?? 6000.0
    }
    
    func calculateBracketFee(for amount: Double) -> Double {
        var totalFee: Double = 0.0
        var remainingAmount = amount
        var previousLimit: Double = 0.0
        
        for bracket in brackets {
            let bracketAmount = min(remainingAmount, bracket.limit - previousLimit)
            
            if bracketAmount <= 0 {
                break
            }
            
            totalFee += bracketAmount * bracket.rate
            remainingAmount -= bracketAmount
            previousLimit = bracket.limit
            
            if remainingAmount <= 0 {
                break
            }
        }
        
        return totalFee
    }
    
    // MARK: - Main Calculation Methods
    
    func calculateNonAgreementFee(disputeType: String, partyCount: Int) -> Double {
        // Calculate hourly fee (minimum 2 hours as per TariffConstants)
        let hourlyRate = getHourlyRate(for: disputeType)
        let minimumHoursFee = hourlyRate * Double(TariffConstants.minimumHoursMultiplier)
        
        // Calculate fixed fee based on party count
        let fixedFee = getFixedFee(for: disputeType, partyCount: partyCount)
        
        // Return the higher of the two
        return max(minimumHoursFee, fixedFee)
    }
    
    func calculateAgreementFee(disputeType: String, amount: Double, partyCount: Int) -> Double {
        // Calculate bracket-based fee
        let bracketFee = calculateBracketFee(for: amount)
        
        // Get minimum fee for this dispute type
        let minimumFee = getMinimumFee(for: disputeType)
        
        // Return the higher of bracket calculation or minimum fee
        return max(bracketFee, minimumFee)
    }
    
    func calculateNonMonetaryFee(disputeType: String, partyCount: Int) -> Double {
        // For non-monetary disputes, use fixed fee based on party count
        return getFixedFee(for: disputeType, partyCount: partyCount)
    }
}

// MARK: - Array Safe Access Extension
private extension Array {
    /// Safe subscript access that returns nil if index is out of bounds
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Tariff 2025 Factory
extension Tariff2025 {
    
    /// Creates a new Tariff2025 instance
    static func create() -> Tariff2025 {
        return Tariff2025()
    }
    
    /// Validates the tariff data integrity
    func validateData() -> Bool {
        // Check if all dispute types have both hourly rates and fixed fees
        let disputeTypes = DisputeConstants.DisputeTypeKeys.allKeys
        
        for disputeType in disputeTypes {
            guard hourlyRates[disputeType] != nil,
                  fixedFees[disputeType] != nil else {
                return false
            }
        }
        
        // Check if brackets are properly ordered
        var previousLimit: Double = 0.0
        for bracket in brackets {
            if bracket.limit <= previousLimit {
                return false
            }
            previousLimit = bracket.limit
        }
        
        return true
    }
    
    /// Returns a summary of the tariff data
    func getSummary() -> String {
        let supportedTypes = getSupportedDisputeTypes().count
        let minGeneralFee = minimumFees["general"] ?? 0.0
        let minCommercialFee = minimumFees["commercial"] ?? 0.0
        
        return """
        Tariff Year: \(year)
        Supported Dispute Types: \(supportedTypes)
        General Minimum Fee: \(LocalizationHelper.formatCurrency(minGeneralFee))
        Commercial Minimum Fee: \(LocalizationHelper.formatCurrency(minCommercialFee))
        Bracket Count: \(brackets.count)
        Data Status: \(isFinalized ? "Finalized" : "Draft")
        """
    }
}

// MARK: - Tariff 2025 Validation Protocol Implementation
extension Tariff2025: TariffValidationProtocol {
    
    func validateTariffData() -> ValidationResult {
        // Validate all components
        let hourlyValidation = validateHourlyRates()
        if !hourlyValidation.isValid { return hourlyValidation }
        
        let fixedValidation = validateFixedFees()
        if !fixedValidation.isValid { return fixedValidation }
        
        let minimumValidation = validateMinimumFees()
        if !minimumValidation.isValid { return minimumValidation }
        
        let bracketsValidation = validateBrackets()
        if !bracketsValidation.isValid { return bracketsValidation }
        
        return .success
    }
    
    func validateHourlyRates() -> ValidationResult {
        // Check if all rates are positive
        for (disputeType, rate) in hourlyRates {
            guard rate > 0 else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: "Invalid hourly rate for \(disputeType): \(rate)"
                )
            }
        }
        return .success
    }
    
    func validateFixedFees() -> ValidationResult {
        // Check if all fixed fees are positive
        for (disputeType, fees) in fixedFees {
            for (index, fee) in fees.enumerated() {
                guard fee > 0 else {
                    return .failure(
                        code: ValidationConstants.Amount.invalidInputErrorCode,
                        message: "Invalid fixed fee for \(disputeType) at index \(index): \(fee)"
                    )
                }
            }
        }
        return .success
    }
    
    func validateMinimumFees() -> ValidationResult {
        // Check if minimum fees are positive
        for (category, fee) in minimumFees {
            guard fee > 0 else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: "Invalid minimum fee for \(category): \(fee)"
                )
            }
        }
        return .success
    }
    
    func validateBrackets() -> ValidationResult {
        // Check if brackets are properly ordered
        var previousLimit: Double = 0.0
        for bracket in brackets {
            if bracket.limit <= previousLimit && bracket.limit != Double.infinity {
                return .failure(
                    code: ValidationConstants.Amount.validationErrorCode,
                    message: "Invalid bracket order: \(bracket.limit) <= \(previousLimit)"
                )
            }
            guard bracket.rate > 0 else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: "Invalid bracket rate: \(bracket.rate)"
                )
            }
            previousLimit = bracket.limit
        }
        return .success
    }
    
    func validateCalculationInput(disputeType: String, amount: Double?, partyCount: Int) -> ValidationResult {
        // Validate dispute type
        guard supportsDisputeType(disputeType) else {
            return .failure(
                code: ValidationConstants.DisputeType.invalidTypeErrorCode,
                message: NSLocalizedString(LocalizationKeys.Validation.invalidDisputeType, comment: "")
            )
        }
        
        // Validate party count
        let partyValidation = ValidationConstants.validatePartyCount(partyCount)
        if !partyValidation.isValid {
            return partyValidation
        }
        
        // Validate amount if provided
        if let amount = amount {
            let amountValidation = ValidationConstants.validateAmount(amount)
            if !amountValidation.isValid {
                return amountValidation
            }
        }
        
        return .success
    }
    
    func validateYear() -> ValidationResult {
        guard TariffConstants.availableYears.contains(year) else {
            return .failure(
                code: ValidationConstants.Year.invalidYearErrorCode,
                message: "Year \(year) is not supported"
            )
        }
        return .success
    }
}

// MARK: - Tariff 2025 Comparison Protocol Implementation
extension Tariff2025: TariffComparisonProtocol {
    
    func compareTo(_ other: TariffProtocol) -> TariffComparison {
        let comparison = TariffComparison(
            baseTariff: self,
            comparedTariff: other,
            comparisonDate: Date()
        )
        return comparison
    }
    
    func calculatePercentageChange(from other: TariffProtocol) -> [String: Double] {
        var changes: [String: Double] = [:]
        
        for disputeType in getSupportedDisputeTypes() {
            let ourRate = getHourlyRate(for: disputeType)
            let otherRate = other.getHourlyRate(for: disputeType)
            
            if otherRate > 0 {
                changes[disputeType] = ((ourRate - otherRate) / otherRate) * 100.0
            }
        }
        
        return changes
    }
    
    func calculateDifference(from other: TariffProtocol, disputeType: String, amount: Double?, partyCount: Int) -> Double {
        let ourFee: Double
        let otherFee: Double
        
        if let amount = amount {
            // Agreement case
            ourFee = calculateAgreementFee(disputeType: disputeType, amount: amount, partyCount: partyCount)
            otherFee = other.calculateAgreementFee(disputeType: disputeType, amount: amount, partyCount: partyCount)
        } else {
            // Non-agreement case
            ourFee = calculateNonAgreementFee(disputeType: disputeType, partyCount: partyCount)
            otherFee = other.calculateNonAgreementFee(disputeType: disputeType, partyCount: partyCount)
        }
        
        return ourFee - otherFee
    }
    
    func getPercentageChange(from other: TariffProtocol, disputeType: String, amount: Double?, partyCount: Int) -> Double {
        let difference = calculateDifference(from: other, disputeType: disputeType, amount: amount, partyCount: partyCount)
        let otherFee: Double
        
        if let amount = amount {
            otherFee = other.calculateAgreementFee(disputeType: disputeType, amount: amount, partyCount: partyCount)
        } else {
            otherFee = other.calculateNonAgreementFee(disputeType: disputeType, partyCount: partyCount)
        }
        
        guard otherFee > 0 else { return 0.0 }
        return (difference / otherFee) * 100.0
    }
}
