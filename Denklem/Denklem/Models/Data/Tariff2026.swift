//
//  Tariff2026.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff 2026 Implementation
/// Implementation of TariffProtocol for 2026 tariff data
/// Official tariff rates and fees for 2026
struct Tariff2026: TariffProtocol {
    
    // MARK: - Basic Properties
    
    let year: Int = 2026
    
    let isFinalized: Bool = true
    
    // MARK: - Minimum Hours Multiplier
    
    let minimumHoursMultiplier: Int = 2
    
    // MARK: - Hourly Rates
    
    let hourlyRates: [String: Double] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: 1130.0,        
        DisputeConstants.DisputeTypeKeys.commercial: 1500.0,           
        DisputeConstants.DisputeTypeKeys.consumer: 1000.0,             
        DisputeConstants.DisputeTypeKeys.rent: 1170.0,                 
        DisputeConstants.DisputeTypeKeys.neighbor: 1000.0,             
        DisputeConstants.DisputeTypeKeys.condominium: 1000.0,          
        DisputeConstants.DisputeTypeKeys.family: 1000.00,               
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: 1170.0, 
        DisputeConstants.DisputeTypeKeys.other: 1000.0                 
    ]
    
    // MARK: - Fixed Fees
    
    /// Fixed fees by dispute type and party count ranges
    /// Array indices: [0: 2 parties, 1: 3-5 parties, 2: 6-10 parties, 3: 11+ parties]
    let fixedFees: [String: [Double]] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: [2260.0, 2460.0, 2560.0, 2660.0],    
        DisputeConstants.DisputeTypeKeys.commercial: [3000.0, 3200.0, 3300.0, 3400.0],        
        DisputeConstants.DisputeTypeKeys.consumer: [2000.0, 2200.0, 2300.0, 2400.0],          
        DisputeConstants.DisputeTypeKeys.rent: [2340.0, 2540.0, 2640.0, 2740.0],              
        DisputeConstants.DisputeTypeKeys.neighbor: [2340.0, 2540.0, 2640.0, 2740.0],          
        DisputeConstants.DisputeTypeKeys.condominium: [2340.0, 2540.0, 2640.0, 2740.0],       
        DisputeConstants.DisputeTypeKeys.family: [2000.0, 2200.0, 2300.0, 2400.0],            
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: [2340.0, 2540.0, 2640.0, 2740.0], 
        DisputeConstants.DisputeTypeKeys.other: [2000.0, 2200.0, 2300.0, 2400.0]             
    ]
    
    /// Party count thresholds for fee calculation
    let partyCountThresholds: [Int] = [2, 5, 10, Int.max]
    
    // MARK: - Minimum Fees
    
    let minimumFees: [String: Double] = [
        "general": 9000.0,     
        "commercial": 13000.0  
    ]
    
    // MARK: - Calculation Brackets
    
    /// Progressive calculation brackets for agreement cases
    /// Format: (upper limit, percentage rate)
    let brackets: [(limit: Double, rate: Double)] = [
        (600000.0, 0.06),       
        (1560000.0, 0.05),       
        (3120000.0, 0.04),      
        (6240000.0, 0.03),      
        (15600000.0, 0.02),      
        (28080000.0, 0.015),    
        (53040000.0, 0.01),     
        (Double.infinity, 0.005) 
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
        return hourlyRates[disputeType] ?? hourlyRates[DisputeConstants.DisputeTypeKeys.other] ?? 1000.0
    }
    

    
    func getMinimumFee(for disputeType: String) -> Double {
        // Commercial disputes use higher minimum
        if disputeType == DisputeConstants.DisputeTypeKeys.commercial ||
           disputeType == DisputeConstants.DisputeTypeKeys.partnershipDissolution {
            return minimumFees["commercial"] ?? 13000.0
        }
        
        // All other disputes use general minimum
        return minimumFees["general"] ?? 9000.0
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
    
    /// Creates a new Tariff2026 instance
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
