//
//  ReinstatementConstants.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import Foundation

// MARK: - Reinstatement Constants
/// Constants for reinstatement (işe iade) mediation fee calculation
/// Legal basis: Labor Courts Law Art. 3/13-2, Labor Law Art. 20-2, Art. 21/7
struct ReinstatementConstants {
    
    // MARK: - Tariff Year
    static let availableYears = [2025, 2026]
    static let currentYear = 2026
    static let defaultYear = 2026
    
    // MARK: - Dispute Type
    /// Reinstatement uses worker-employer dispute type for calculations
    static let disputeType = DisputeConstants.DisputeTypeKeys.workerEmployer
    
    // MARK: - Validation
    struct Validation {
        // Amount validation (for agreement case)
        static let minimumAmount: Double = 0.01
        static let maximumAmount: Double = 999_999_999.0
        
        // Party count validation
        static let minimumPartyCount: Int = 2
        static let maximumPartyCount: Int = 1000
        static let defaultPartyCount: Int = 2
        
        // Regex patterns (reuse from ValidationConstants)
        static let amountPattern = ValidationConstants.Amount.basicNumberPattern
        static let partyCountPattern = ValidationConstants.PartyCount.pattern
    }
    
    // MARK: - Input Fields
    struct InputFields {
        /// Required fields for agreement case
        static let agreementRequired = [
            "nonReinstatementCompensation",  // İşe başlatılmama tazminatı
            "idlePeriodWage",                 // Boşta geçen süre ücreti
            "partyCount"                      // Taraf sayısı
        ]
        
        /// Optional fields for agreement case
        static let agreementOptional = [
            "otherRights"                     // Diğer haklar
        ]
        
        /// Required fields for no agreement case
        static let noAgreementRequired = [
            "partyCount"                      // Taraf sayısı
        ]
    }
    
    // MARK: - Legal Reference Keys
    /// Localization keys for legal references (use with .localized)
    struct LegalReferenceKeys {
        // Agreement case - Labor Courts Law Art. 3/13-2
        static let agreementArticle = LocalizationKeys.Reinstatement.legalAgreementArticle
        
        // No agreement case - Labor Law Art. 20-2
        static let noAgreementArticle = LocalizationKeys.Reinstatement.legalNoAgreementArticle
        
        // Additional reference - Labor Law Art. 21/7
        static let laborLawArticle = LocalizationKeys.Reinstatement.legalLaborLawArticle
        
        // Tariff section - Tariff Second Part
        static let tariffSection = LocalizationKeys.Reinstatement.tariffSection
    }
    
    // MARK: - Currency Settings
    static let currencyCode = TariffConstants.currencyCode
    static let currencySymbol = TariffConstants.currencySymbol
    static let decimalPlaces = TariffConstants.decimalPlaces
    
    // MARK: - Display Settings
    static let showCalculationBreakdown = true
    static let showTariffReference = true
    static let showLegalReference = true
    static let showMinimumFeeNote = true
}

// MARK: - Reinstatement Constants Extension
extension ReinstatementConstants {
    
    /// Returns localized legal reference based on agreement status
    /// - Parameter isAgreed: Whether parties reached agreement
    /// - Returns: Localized legal reference string
    static func getLegalReference(isAgreed: Bool) -> String {
        if isAgreed {
            return LegalReferenceKeys.agreementArticle.localized
        } else {
            return LegalReferenceKeys.noAgreementArticle.localized
        }
    }
    
    /// Returns localized tariff section reference
    /// - Returns: Localized tariff section string
    static func getTariffSectionReference() -> String {
        return LegalReferenceKeys.tariffSection.localized
    }
    
    /// Validates if year is supported for reinstatement calculation
    /// - Parameter year: Year to validate
    /// - Returns: True if year is supported
    static func isValidYear(_ year: Int) -> Bool {
        return availableYears.contains(year)
    }
    
    /// Validates amount for agreement case
    /// - Parameter amount: Amount to validate
    /// - Returns: ValidationResult
    static func validateAmount(_ amount: Double) -> ValidationResult {
        if amount < Validation.minimumAmount {
            return .failure(
                code: ValidationConstants.Amount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.Amount.min.localized
            )
        }
        
        if amount > Validation.maximumAmount {
            return .failure(
                code: ValidationConstants.Amount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.Amount.max.localized
            )
        }
        
        return .success
    }
    
    /// Validates party count
    /// - Parameter count: Party count to validate
    /// - Returns: ValidationResult
    static func validatePartyCount(_ count: Int) -> ValidationResult {
        if count < Validation.minimumPartyCount {
            return .failure(
                code: ValidationConstants.PartyCount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.PartyCount.min.localized
            )
        }
        
        if count > Validation.maximumPartyCount {
            return .failure(
                code: ValidationConstants.PartyCount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.PartyCount.max.localized
            )
        }
        
        return .success
    }
    
    /// Returns required input fields based on agreement status
    /// - Parameter isAgreed: Whether parties reached agreement
    /// - Returns: Array of required field names
    static func getRequiredFields(isAgreed: Bool) -> [String] {
        return isAgreed ? InputFields.agreementRequired : InputFields.noAgreementRequired
    }
    
    /// Returns optional input fields based on agreement status
    /// - Parameter isAgreed: Whether parties reached agreement
    /// - Returns: Array of optional field names
    static func getOptionalFields(isAgreed: Bool) -> [String] {
        return isAgreed ? InputFields.agreementOptional : []
    }
}
