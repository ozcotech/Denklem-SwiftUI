//
//  Tariff2026.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff 2026 Implementation
/// Implementation of TariffProtocol for 2026 tariff data (PLACEHOLDER)
/// Uses estimated tariff rates and fees with 15% increase from 2025 values
/// WARNING: These are estimated values - will be updated when official 2026 tariff is published
struct Tariff2026: TariffProtocol {
    
    // MARK: - Basic Properties
    
    let year: Int = 2026
    
    let isFinalized: Bool = false  // ⚠️ IMPORTANT: These are estimated values!
    
    // MARK: - Minimum Hours Multiplier
    
    let minimumHoursMultiplier: Int = 2
    
    // MARK: - Hourly Rates (Estimated - 2025 × 1.15)
    
    let hourlyRates: [String: Double] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: 902.75,        // 785 × 1.15
        DisputeConstants.DisputeTypeKeys.commercial: 1322.5,           // 1150 × 1.15
        DisputeConstants.DisputeTypeKeys.consumer: 902.75,             // 785 × 1.15
        DisputeConstants.DisputeTypeKeys.rent: 960.25,                 // 835 × 1.15
        DisputeConstants.DisputeTypeKeys.neighbor: 960.25,             // 835 × 1.15
        DisputeConstants.DisputeTypeKeys.condominium: 960.25,          // 835 × 1.15
        DisputeConstants.DisputeTypeKeys.family: 902.75,               // 785 × 1.15
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: 1035.0, // 900 × 1.15
        DisputeConstants.DisputeTypeKeys.other: 902.75                 // 785 × 1.15
    ]
    
    // MARK: - Fixed Fees (Estimated - 2025 × 1.15)
    
    /// Fixed fees by dispute type and party count ranges (ESTIMATED VALUES)
    /// Array indices: [0: 2 parties, 1: 3-5 parties, 2: 6-10 parties, 3: 11+ parties]
    let fixedFees: [String: [Double]] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: [1805.5, 1897.5, 2012.5, 2127.5],    // [1570, 1650, 1750, 1850] × 1.15
        DisputeConstants.DisputeTypeKeys.commercial: [2645.0, 2702.5, 2817.5, 2932.5],        // [2300, 2350, 2450, 2550] × 1.15
        DisputeConstants.DisputeTypeKeys.consumer: [1805.5, 1897.5, 2012.5, 2127.5],          // [1570, 1650, 1750, 1850] × 1.15
        DisputeConstants.DisputeTypeKeys.rent: [1920.5, 2012.5, 2127.5, 2242.5],              // [1670, 1750, 1850, 1950] × 1.15
        DisputeConstants.DisputeTypeKeys.neighbor: [1920.5, 2012.5, 2127.5, 2242.5],          // [1670, 1750, 1850, 1950] × 1.15
        DisputeConstants.DisputeTypeKeys.condominium: [1920.5, 2012.5, 2127.5, 2242.5],       // [1670, 1750, 1850, 1950] × 1.15
        DisputeConstants.DisputeTypeKeys.family: [1805.5, 1897.5, 2012.5, 2127.5],            // [1570, 1650, 1750, 1850] × 1.15
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: [2070.0, 2300.0, 2415.0, 2530.0], // [1800, 2000, 2100, 2200] × 1.15
        DisputeConstants.DisputeTypeKeys.other: [1805.5, 1897.5, 2012.5, 2127.5]              // [1570, 1650, 1750, 1850] × 1.15
    ]
    
    /// Party count thresholds for fee calculation
    let partyCountThresholds: [Int] = [2, 5, 10, Int.max]
    
    // MARK: - Minimum Fees (Estimated - 2025 × 1.15)
    
    let minimumFees: [String: Double] = [
        "general": 6900.0,     // 6000 × 1.15 - General minimum fee (estimated)
        "commercial": 10350.0  // 9000 × 1.15 - Commercial minimum fee (estimated)
    ]
    
    // MARK: - Calculation Brackets (Estimated - 2025 × 1.15)
    
    /// Progressive calculation brackets for agreement cases (ESTIMATED VALUES)
    /// Format: (upper limit, percentage rate)
    let brackets: [(limit: Double, rate: Double)] = [
        (345000.0, 0.06),       // 300,000 × 1.15 = 345,000 TL: 6%
        (897000.0, 0.05),       // 780,000 × 1.15 = 897,000 TL: 5%
        (1794000.0, 0.04),      // 1,560,000 × 1.15 = 1,794,000 TL: 4%
        (5382000.0, 0.03),      // 4,680,000 × 1.15 = 5,382,000 TL: 3%
        (7176000.0, 0.02),      // 6,240,000 × 1.15 = 7,176,000 TL: 2%
        (14352000.0, 0.015),    // 12,480,000 × 1.15 = 14,352,000 TL: 1.5%
        (30498000.0, 0.01),     // 26,520,000 × 1.15 = 30,498,000 TL: 1%
        (Double.infinity, 0.005) // 30,498,001+ TL: 0.5%
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
        return hourlyRates[disputeType] ?? hourlyRates[DisputeConstants.DisputeTypeKeys.other] ?? 902.75
    }
    
    func getFixedFee(for disputeType: String, partyCount: Int) -> Double {
        // Get fees array for dispute type
        guard let fees = fixedFees[disputeType] else {
            // Fallback to 'other' type if not found
            guard let defaultFees = fixedFees[DisputeConstants.DisputeTypeKeys.other] else {
                return 1805.5 // Ultimate fallback (1570 × 1.15)
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
                return fees[safe: index] ?? fees.last ?? 1805.5
            }
        }
        return fees.last ?? 1805.5
    }
    
    func getMinimumFee(for disputeType: String) -> Double {
        // Commercial disputes use higher minimum
        if disputeType == DisputeConstants.DisputeTypeKeys.commercial ||
           disputeType == DisputeConstants.DisputeTypeKeys.partnershipDissolution {
            return minimumFees["commercial"] ?? 10350.0
        }
        
        // All other disputes use general minimum
        return minimumFees["general"] ?? 6900.0
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
        // Non-agreement: Use fixed fee multiplied by minimum hours
        let fixedFee = getFixedFee(for: disputeType, partyCount: partyCount)
        return fixedFee * Double(minimumHoursMultiplier)
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
        // For non-monetary disputes, use fixed fee based on party count (already selected by party count)
        let fixedFee = getFixedFee(for: disputeType, partyCount: partyCount)
        return fixedFee * Double(minimumHoursMultiplier)
    }
}

// MARK: - Array Safe Access Extension
private extension Array {
    /// Safe subscript access that returns nil if index is out of bounds
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Tariff 2026 Factory
extension Tariff2026 {
    
    /// Creates a new Tariff2026 instance with estimated values
    static func create() -> Tariff2026 {
        return Tariff2026()
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
    
    /// Returns a summary of the tariff data with estimation warning
    func getSummary() -> String {
        let supportedTypes = getSupportedDisputeTypes().count
        let minGeneralFee = minimumFees["general"] ?? 0.0
        let minCommercialFee = minimumFees["commercial"] ?? 0.0
        
        return """
        ⚠️ ESTIMATED TARIFF - NOT FINALIZED
        Tariff Year: \(year) (Placeholder)
        Supported Dispute Types: \(supportedTypes)
        General Minimum Fee: \(LocalizationHelper.formatCurrency(minGeneralFee)) (Est.)
        Commercial Minimum Fee: \(LocalizationHelper.formatCurrency(minCommercialFee)) (Est.)
        Bracket Count: \(brackets.count)
        Data Status: \(isFinalized ? "Finalized" : "Estimated (15% increase from 2025)")
        
        ⚠️ WARNING: These values are estimates based on 15% increase from 2025
        Official 2026 tariff will be published in January 2026
        """
    }
    
    /// Returns warning message for UI display
    func getEstimationWarning() -> String {
        return NSLocalizedString(LocalizationKeys.Validation.estimatedTariff, comment: "Estimated tariff warning")
    }
}

// MARK: - Tariff 2026 Validation Protocol Implementation
extension Tariff2026: TariffValidationProtocol {
    
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
