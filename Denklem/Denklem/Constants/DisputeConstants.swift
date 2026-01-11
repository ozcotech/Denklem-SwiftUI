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
    
    // MARK: - Agreement Status Keys
    /// Raw string values for agreement statuses
    struct AgreementStatusKeys {
        static let agreed = "agreed"
        static let notAgreed = "not_agreed"
        
        /// All available agreement status keys
        static let allKeys = [agreed, notAgreed]
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
        
        /// Legacy Turkish keys for backward compatibility
        struct LegacyKeys {
            static let kdvDahilStopajYok = "kdv_dahil_stopaj_yok"
            static let kdvHaricStopajVar = "kdv_haric_stopaj_var"
            static let kdvDahilStopajVar = "kdv_dahil_stopaj_var"
            static let kdvHaricStopajYok = "kdv_haric_stopaj_yok"
        }
    }
    
    // MARK: - Time Calculation Dispute Type Keys
    /// Raw string values for time calculation dispute types
    struct TimeCalculationDisputeTypeKeys {
        static let laborLaw = "labor_law"
        static let commercialLaw = "commercial_law"
        static let consumerLaw = "consumer_law"
        static let rentalDisputes = "rental_disputes"
        static let partnershipDissolution = "partnership_dissolution"
        static let condominiumLaw = "condominium_law"
        static let neighborLaw = "neighbor_law"
        static let agriculturalProduction = "agricultural_production"
        
        /// All available time calculation dispute type keys
        static let allKeys = [
            laborLaw,
            commercialLaw,
            consumerLaw,
            rentalDisputes,
            partnershipDissolution,
            condominiumLaw,
            neighborLaw,
            agriculturalProduction
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
        
        /// Dispute types that have special minimum fees
        static let specialMinimumFees = [
            DisputeTypeKeys.commercial: "commercial"
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
        
        /// Dispute types that require minimum 2 hours for non-agreement cases
        static let minimumTwoHoursRequired = [
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
    
    // MARK: - Dispute Type Mapping
    /// Maps dispute type keywords to standard keys
    struct DisputeTypeMapping {
        
        /// Turkish keyword mappings
        static let turkishKeywords: [String: String] = [
            "işçi": DisputeTypeKeys.workerEmployer,
            "işveren": DisputeTypeKeys.workerEmployer,
            "iş": DisputeTypeKeys.workerEmployer,
            "ticari": DisputeTypeKeys.commercial,
            "ticaret": DisputeTypeKeys.commercial,
            "tüketici": DisputeTypeKeys.consumer,
            "kira": DisputeTypeKeys.rent,
            "kiracı": DisputeTypeKeys.rent,
            "kiralayan": DisputeTypeKeys.rent,
            "komşu": DisputeTypeKeys.neighbor,
            "kat": DisputeTypeKeys.condominium,
            "mülkiyet": DisputeTypeKeys.condominium,
            "aile": DisputeTypeKeys.family,
            "ortaklık": DisputeTypeKeys.partnershipDissolution,
            "ortaklığın": DisputeTypeKeys.partnershipDissolution,
            "giderilmesi": DisputeTypeKeys.partnershipDissolution
        ]
        
        /// English keyword mappings
        static let englishKeywords: [String: String] = [
            "worker": DisputeTypeKeys.workerEmployer,
            "employer": DisputeTypeKeys.workerEmployer,
            "labor": DisputeTypeKeys.workerEmployer,
            "employment": DisputeTypeKeys.workerEmployer,
            "commercial": DisputeTypeKeys.commercial,
            "business": DisputeTypeKeys.commercial,
            "trade": DisputeTypeKeys.commercial,
            "consumer": DisputeTypeKeys.consumer,
            "rent": DisputeTypeKeys.rent,
            "rental": DisputeTypeKeys.rent,
            "tenant": DisputeTypeKeys.rent,
            "neighbor": DisputeTypeKeys.neighbor,
            "neighbourhood": DisputeTypeKeys.neighbor,
            "condominium": DisputeTypeKeys.condominium,
            "condo": DisputeTypeKeys.condominium,
            "apartment": DisputeTypeKeys.condominium,
            "family": DisputeTypeKeys.family,
            "partnership": DisputeTypeKeys.partnershipDissolution,
            "dissolution": DisputeTypeKeys.partnershipDissolution
        ]
        
        /// Combined keyword mappings
        static let allKeywords: [String: String] = {
            var combined = turkishKeywords
            englishKeywords.forEach { combined[$0.key] = $0.value }
            return combined
        }()
    }
    
    // MARK: - Display Priorities
    /// Display order priorities for UI lists
    struct DisplayPriorities {
        
        /// Dispute types ordered by frequency of use
        static let disputeTypeOrder = [
            DisputeTypeKeys.commercial,
            DisputeTypeKeys.workerEmployer,
            DisputeTypeKeys.consumer,
            DisputeTypeKeys.rent,
            DisputeTypeKeys.neighbor,
            DisputeTypeKeys.condominium,
            DisputeTypeKeys.family,
            DisputeTypeKeys.partnershipDissolution,
            DisputeTypeKeys.agriculturalProduction,
            DisputeTypeKeys.other
        ]
        
        /// Calculation types ordered by frequency of use
        static let calculationTypeOrder = [
            CalculationTypeKeys.monetary,
            CalculationTypeKeys.nonMonetary,
            CalculationTypeKeys.smmCalculation,
            CalculationTypeKeys.timeCalculation
        ]
        
        /// SMM calculation types ordered by frequency of use
        static let smmCalculationTypeOrder = [
            SMMCalculationTypeKeys.vatIncludedWithholdingExcluded,
            SMMCalculationTypeKeys.vatExcludedWithholdingIncluded,
            SMMCalculationTypeKeys.vatIncludedWithholdingIncluded,
            SMMCalculationTypeKeys.vatExcludedWithholdingExcluded
        ]
    }
    
    // MARK: - Validation Rules
    /// Validation rules for dispute-related inputs
    struct ValidationRules {
        
        /// Maximum number of characters in dispute type selection
        static let maxSelectionLength = 50
        
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
    
    // MARK: - Default Values
    /// Default values for dispute-related inputs
    struct DefaultValues {
        static let disputeType = DisputeTypeKeys.other
        static let agreementStatus = AgreementStatusKeys.notAgreed
        static let calculationType = CalculationTypeKeys.monetary
        static let smmCalculationType = SMMCalculationTypeKeys.vatIncludedWithholdingExcluded
        static let timeCalculationDisputeType = TimeCalculationDisputeTypeKeys.commercialLaw
    }
}

// MARK: - Dispute Constants Extension
extension DisputeConstants {
    
    /// Returns localized display name for dispute type key
    static func getDisputeTypeDisplayName(for key: String) -> String {
        switch key {
        case DisputeTypeKeys.workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "")
        case DisputeTypeKeys.commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "")
        case DisputeTypeKeys.consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "")
        case DisputeTypeKeys.rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "")
        case DisputeTypeKeys.neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "")
        case DisputeTypeKeys.condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "")
        case DisputeTypeKeys.family:
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "")
        case DisputeTypeKeys.partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "")
        default:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "")
        }
    }
    
    /// Returns localized description for dispute type key
    static func getDisputeTypeDescription(for key: String) -> String {
        switch key {
        case DisputeTypeKeys.workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.workerEmployer, comment: "")
        case DisputeTypeKeys.commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.commercial, comment: "")
        case DisputeTypeKeys.consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.consumer, comment: "")
        case DisputeTypeKeys.rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.rent, comment: "")
        case DisputeTypeKeys.neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.neighbor, comment: "")
        case DisputeTypeKeys.condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.condominium, comment: "")
        case DisputeTypeKeys.family:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.family, comment: "")
        case DisputeTypeKeys.partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.partnershipDissolution, comment: "")
        default:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.other, comment: "")
        }
    }
    
    /// Maps text input to dispute type key using keywords
    static func mapTextToDisputeType(_ text: String) -> String {
        let lowercaseText = text.lowercased()
        
        // Check for direct keyword matches
        for (keyword, disputeType) in DisputeTypeMapping.allKeywords {
            if lowercaseText.contains(keyword.lowercased()) {
                return disputeType
            }
        }
        
        return DefaultValues.disputeType
    }
    
    /// Validates if dispute type key is valid
    static func isValidDisputeType(_ key: String) -> Bool {
        return DisputeTypeKeys.allKeys.contains(key)
    }
    
    /// Validates if agreement status key is valid
    static func isValidAgreementStatus(_ key: String) -> Bool {
        return AgreementStatusKeys.allKeys.contains(key)
    }
    
    /// Validates if calculation type key is valid
    static func isValidCalculationType(_ key: String) -> Bool {
        return CalculationTypeKeys.allKeys.contains(key)
    }
    
    /// Validates if SMM calculation type key is valid
    static func isValidSMMCalculationType(_ key: String) -> Bool {
        return SMMCalculationTypeKeys.allKeys.contains(key)
    }
    
    /// Returns dispute types ordered for display
    static func getOrderedDisputeTypes() -> [String] {
        return DisplayPriorities.disputeTypeOrder
    }
    
    /// Returns calculation types ordered for display
    static func getOrderedCalculationTypes() -> [String] {
        return DisplayPriorities.calculationTypeOrder
    }
    
    /// Returns SMM calculation types ordered for display
    static func getOrderedSMMCalculationTypes() -> [String] {
        return DisplayPriorities.smmCalculationTypeOrder
    }
    
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
