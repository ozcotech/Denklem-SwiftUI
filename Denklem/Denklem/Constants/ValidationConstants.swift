//
//  ValidationConstants.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - Validation Constants
/// Input validation rules and error handling constants
struct ValidationConstants {
    
    // MARK: - Amount Validation
    struct Amount {
        static let minimum: Double = 0.01
        static let maximum: Double = 999_999_999.0
        
        static let allowNegative = false
        static let allowZero = false
        
        // Regex pattern (used by ReinstatementConstants)
        
        // Error codes
        static let invalidInputErrorCode = 1001
        static let validationErrorCode = 1005
    }
    
    // MARK: - Party Count Validation
    struct PartyCount {
        static let minimum = 2
        static let maximum = 1000

        // Regex pattern (used by ReinstatementConstants)
        static let pattern = "^[0-9]{1,4}$"

        // Error codes (used by ReinstatementConstants)
        static let invalidInputErrorCode = 1001
        static let validationErrorCode = 1005
    }

    // MARK: - File Count Validation (Serial Disputes)
    struct FileCount {
        // Error codes (used by SerialDisputesResult)
        static let validationErrorCode = 1005
    }
    
    // MARK: - SMM Calculation Validation
    struct SMMCalculation {
        static let minimumSMMAmount: Double = 0.0
        static let maximumSMMAmount: Double = 999_999_999.0
        
        static let validCalculationTypes: [String] = [
            DisputeConstants.SMMCalculationTypeKeys.vatIncludedWithholdingExcluded,
            DisputeConstants.SMMCalculationTypeKeys.vatExcludedWithholdingIncluded,
            DisputeConstants.SMMCalculationTypeKeys.vatIncludedWithholdingIncluded,
            DisputeConstants.SMMCalculationTypeKeys.vatExcludedWithholdingExcluded
        ]
    }
    
    // MARK: - Dispute Type Validation
    struct DisputeType {
        static let validDisputeTypes: [String] = [
            DisputeConstants.DisputeTypeKeys.workerEmployer,
            DisputeConstants.DisputeTypeKeys.commercial,
            DisputeConstants.DisputeTypeKeys.consumer,
            DisputeConstants.DisputeTypeKeys.rent,
            DisputeConstants.DisputeTypeKeys.neighbor,
            DisputeConstants.DisputeTypeKeys.condominium,
            DisputeConstants.DisputeTypeKeys.family,
            DisputeConstants.DisputeTypeKeys.partnershipDissolution,
            DisputeConstants.DisputeTypeKeys.agriculturalProduction,
            DisputeConstants.DisputeTypeKeys.other
        ]
        
        static let validAgreementStatuses = ["agreed", "not_agreed"]
        
        static let validCalculationTypes: [String] = [
            DisputeConstants.CalculationTypeKeys.monetary,
            DisputeConstants.CalculationTypeKeys.nonMonetary,
            DisputeConstants.CalculationTypeKeys.timeCalculation,
            DisputeConstants.CalculationTypeKeys.smmCalculation
        ]
        
        // Error codes
        static let invalidTypeErrorCode = 1006
        static let validationErrorCode = 1005
    }

    // MARK: - Year Validation
    struct Year {
        // Supported years come from TariffYear (single source of truth)
        
        // Error codes
        static let invalidYearErrorCode = 1007
        static let validationErrorCode = 1005
    }
}

// MARK: - Validation Methods Extension
extension ValidationConstants {
    
    // MARK: - Amount Validation
    
    /// Validates if amount is within allowed range
    static func validateAmount(_ amount: Double) -> ValidationResult {
        if amount < Amount.minimum {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.Amount.min)
            )
        }
        
        if amount > Amount.maximum {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.Amount.max)
            )
        }
        
        if !Amount.allowZero && amount == 0 {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        if !Amount.allowNegative && amount < 0 {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        return .success
    }
    
    // MARK: - Party Count Validation
    
    /// Validates if party count is within allowed range
    static func validatePartyCount(_ count: Int) -> ValidationResult {
        if count < PartyCount.minimum {
            return .failure(
                code: PartyCount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.PartyCount.min)
            )
        }
        
        if count > PartyCount.maximum {
            return .failure(
                code: PartyCount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.PartyCount.max)
            )
        }
        
        return .success
    }
    
    // MARK: - Year Validation
    
    /// Validates if year is supported
    static func validateYear(_ year: Int) -> ValidationResult {
        if TariffYear(rawValue: year) == nil {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Unsupported year: \(year)"
            )
        }
        
        return .success
    }
    
    // MARK: - Dispute Type Validation
    
    /// Validates if dispute type is supported
    static func validateDisputeType(_ disputeType: String) -> ValidationResult {
        if !DisputeType.validDisputeTypes.contains(disputeType) {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Invalid dispute type: \(disputeType)"
            )
        }
        
        return .success
    }
    
    /// Validates if agreement status is valid
    static func validateAgreementStatus(_ status: String) -> ValidationResult {
        if !DisputeType.validAgreementStatuses.contains(status) {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Invalid agreement status: \(status)"
            )
        }
        
        return .success
    }
    
    // MARK: - SMM Validation
    
    /// Validates SMM calculation type
    static func validateSMMCalculationType(_ type: String) -> ValidationResult {
        if !SMMCalculation.validCalculationTypes.contains(type) {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Invalid SMM calculation type: \(type)"
            )
        }
        
        return .success
    }
    
    /// Validates SMM amount
    static func validateSMMAmount(_ amount: Double) -> ValidationResult {
        if amount < SMMCalculation.minimumSMMAmount || amount > SMMCalculation.maximumSMMAmount {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        return .success
    }
}

// MARK: - Validation Result
enum ValidationResult: Error {
    case success
    case failure(code: Int, message: String)
    
    var isValid: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .success:
            return nil
        case .failure(_, let message):
            return message
        }
    }
    
    var localizedDescription: String {
        return errorMessage ?? "Unknown validation error"
    }
}
