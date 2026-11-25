//
//  DisputeConstants.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - Dispute Constants
/// Constants for dispute types, categories, and related configurations
struct DisputeConstants {
    
    // MARK: - Dispute Type Keys
    /// Raw string values for dispute types (used in TariffConstants)
    struct DisputeTypeKeys {
        static let workerEmployer = "worker_employer"
        static let commercial = "commercial"
        static let consumer = "consumer"
        static let rent = "rent"
        static let neighbor = "neighbor"
        static let condominium = "condominium"
        static let family = "family"
        static let partnershipDissolution = "partnership_dissolution"
        static let agriculturalProduction = "agricultural_production"
        static let other = "other"
        
        /// All available dispute type keys
        static let allKeys = [
            workerEmployer,
            commercial,
            consumer,
            rent,
            neighbor,
            condominium,
            family,
            partnershipDissolution,
            agriculturalProduction,
            other
        ]
    }
    
    // MARK: - Calculation Type Keys
    /// Raw string values for calculation types
    struct CalculationTypeKeys {
        static let monetary = "monetary"
        static let nonMonetary = "non_monetary"
        static let timeCalculation = "time_calculation"
        static let smmCalculation = "smm_calculation"
        
        /// All available calculation type keys
        static let allKeys = [monetary, nonMonetary, timeCalculation, smmCalculation]
    }
    
    // MARK: - SMM Calculation Type Keys
    /// Raw string values for SMM calculation types
    struct SMMCalculationTypeKeys {
        static let vatIncludedWithholdingExcluded = "vat_included_withholding_excluded"
        static let vatExcludedWithholdingIncluded = "vat_excluded_withholding_included"
        static let vatIncludedWithholdingIncluded = "vat_included_withholding_included"
        static let vatExcludedWithholdingExcluded = "vat_excluded_withholding_excluded"
        
        /// All available SMM calculation type keys
        static let allKeys = [
            vatIncludedWithholdingExcluded,
            vatExcludedWithholdingIncluded,
            vatIncludedWithholdingIncluded,
            vatExcludedWithholdingExcluded
        ]
    }
    
    // MARK: - Dispute Type Configurations
    /// Configuration settings for each dispute type
    struct DisputeTypeConfigs {
        
        /// Dispute types that support hourly rate calculation
        static let hourlyRateSupported = [
            DisputeTypeKeys.workerEmployer,
            DisputeTypeKeys.commercial,
            DisputeTypeKeys.consumer,
            DisputeTypeKeys.rent,
            DisputeTypeKeys.neighbor,
            DisputeTypeKeys.condominium,
            DisputeTypeKeys.family,
            DisputeTypeKeys.partnershipDissolution,
            DisputeTypeKeys.agriculturalProduction,
            DisputeTypeKeys.other
        ]
        
        /// Dispute types that support fixed fee calculation
        static let fixedFeeSupported = [
            DisputeTypeKeys.workerEmployer,
            DisputeTypeKeys.commercial,
            DisputeTypeKeys.consumer,
            DisputeTypeKeys.rent,
            DisputeTypeKeys.neighbor,
            DisputeTypeKeys.condominium,
            DisputeTypeKeys.family,
            DisputeTypeKeys.partnershipDissolution,
            DisputeTypeKeys.agriculturalProduction,
            DisputeTypeKeys.other
        ]
        
        /// Dispute types that support bracket calculation (for agreements)
        static let bracketCalculationSupported = [
            DisputeTypeKeys.workerEmployer,
            DisputeTypeKeys.commercial,
            DisputeTypeKeys.consumer,
            DisputeTypeKeys.rent,
            DisputeTypeKeys.neighbor,
            DisputeTypeKeys.condominium,
            DisputeTypeKeys.family,
            DisputeTypeKeys.partnershipDissolution,
            DisputeTypeKeys.agriculturalProduction,
            DisputeTypeKeys.other
        ]
    }
    
    // MARK: - Validation Rules
    /// Validation rules for dispute-related inputs
    struct ValidationRules {
        
        /// Required fields for each calculation type
        static let requiredFields: [String: [String]] = [
            CalculationTypeKeys.monetary: ["amount", "partyCount", "disputeType", "agreementStatus"],
            CalculationTypeKeys.nonMonetary: ["partyCount", "disputeType"],
            CalculationTypeKeys.timeCalculation: ["disputeType", "startDate"],
            CalculationTypeKeys.smmCalculation: ["mediationFee", "calculationType"]
        ]
        
        /// Optional fields for each calculation type
        static let optionalFields: [String: [String]] = [
            CalculationTypeKeys.monetary: ["calculationDate"],
            CalculationTypeKeys.nonMonetary: ["calculationDate"],
            CalculationTypeKeys.timeCalculation: ["extendedWeeks"],
            CalculationTypeKeys.smmCalculation: ["calculationDate"]
        ]
    }
}

// MARK: - Dispute Constants Extension
extension DisputeConstants {
    
    /// Checks if dispute type supports hourly rate calculation
    static func supportsHourlyRate(_ disputeType: String) -> Bool {
        return DisputeTypeConfigs.hourlyRateSupported.contains(disputeType)
    }
    
    /// Checks if dispute type supports fixed fee calculation
    static func supportsFixedFee(_ disputeType: String) -> Bool {
        return DisputeTypeConfigs.fixedFeeSupported.contains(disputeType)
    }
    
    /// Checks if dispute type supports bracket calculation
    static func supportsBracketCalculation(_ disputeType: String) -> Bool {
        return DisputeTypeConfigs.bracketCalculationSupported.contains(disputeType)
    }
    
    /// Gets required fields for calculation type
    static func getRequiredFields(for calculationType: String) -> [String] {
        return ValidationRules.requiredFields[calculationType] ?? []
    }
    
    /// Gets optional fields for calculation type
    static func getOptionalFields(for calculationType: String) -> [String] {
        return ValidationRules.optionalFields[calculationType] ?? []
    }
}
