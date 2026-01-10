//
//  ValidationConstants.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - Validation Constants
/// Input validation rules, regex patterns, and error handling constants
struct ValidationConstants {
    
    // MARK: - Amount Validation
    struct Amount {
        // From TariffConstants
        static let minimum: Double = 0.01
        static let maximum: Double = 999_999_999.0
        static let defaultValue: Double = 10_000.0
        
        // Decimal places
        static let maxDecimalPlaces = 2
        static let allowNegative = false
        static let allowZero = false
        
        // Regex patterns for amount validation
        static let turkishAmountPattern = "^[0-9]{1,9}([,][0-9]{1,2})?$"  // 1.234.567,89
        static let englishAmountPattern = "^[0-9,]{1,12}([.][0-9]{1,2})?$" // 1,234,567.89
        static let basicNumberPattern = "^[0-9]+([.,][0-9]{1,2})?$"        // Basic pattern
        
        // Error codes from AppConstants
        static let invalidInputErrorCode = 1001
        static let validationErrorCode = 1005
    }
    
    // MARK: - Party Count Validation
    struct PartyCount {
        // From TariffConstants
        static let minimum = 2
        static let maximum = 1000
        static let defaultValue = 2
        
        // Regex pattern for party count
        static let pattern = "^[0-9]{1,4}$"  // 1-4 digits
        
        // Error codes
        static let invalidInputErrorCode = 1001
        static let validationErrorCode = 1005
    }
    
    // MARK: - Date Validation
    struct Date {
        // Date formats from LocalizationHelper
        static let turkishDateFormat = "dd.MM.yyyy"
        static let englishDateFormat = "MM/dd/yyyy"
        static let exportDateFormat = "yyyy-MM-dd"
        static let timeFormat = "HH:mm"
        
        // Date range validation
        static let minimumYear = 2025
        static let maximumYear = 2030
        
        // Regex patterns
        static let turkishDatePattern = "^(0[1-9]|[12][0-9]|3[01])\\.(0[1-9]|1[0-2])\\.(20[2-9][0-9])$"
        static let englishDatePattern = "^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/(20[2-9][0-9])$"
        static let timePattern = "^([01][0-9]|2[0-3]):([0-5][0-9])$"
    }
    
    // MARK: - Text Input Validation
    struct TextInput {
        // General text limits
        static let maxNameLength = 100
        static let maxDescriptionLength = 500
        static let maxCommentLength = 1000
        
        // Email validation
        static let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        static let maxEmailLength = 254
        
        // URL validation
        static let urlPattern = "^https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/.*)?$"
        static let maxURLLength = 2048
        
        // Phone number validation
        static let turkishPhonePattern = "^(\\+90|0)?[0-9]{10}$"
        static let internationalPhonePattern = "^\\+[1-9][0-9]{6,14}$"
        
        // Character restrictions
        static let allowedNameCharacters = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZabcçdefgğhıijklmnoöprsştuüvyz "
        static let numericCharacters = "0123456789"
        static let decimalCharacters = "0123456789.,"
    }
    
    // MARK: - File Validation
    struct File {
        // Export file settings
        static let maxExportRows = 10000
        static let maxFileNameLength = 100
        static let allowedExportFormats = ["csv", "pdf", "txt"]
        
        // File name patterns
        static let fileNamePattern = "^[A-Za-z0-9._-]+$"
        static let exportFileNamePattern = "^[A-Za-z0-9._-]{1,100}\\.(csv|pdf|txt)$"
        
        // File size limits (in bytes)
        static let maxExportFileSize = 10 * 1024 * 1024  // 10 MB
    }
    
    // MARK: - Currency Validation
    struct Currency {
        // From TariffConstants
        static let supportedCurrencyCode = "TRY"
        static let supportedCurrencySymbol = "₺"
        static let decimalPlaces = 2
        
        // Currency formatting validation
        static let currencyPattern = "^[0-9]{1,9}([.,][0-9]{1,2})?\\s*[₺]?$"
        static let currencySymbolPattern = "^.*[₺].*$"
    }
    
    // MARK: - SMM Calculation Validation
    struct SMMCalculation {
        // SMM rates from TariffConstants
        static let kdvRate: Double = 0.20
        static let stopajRate: Double = 0.20
        
        // SMM amount limits
        static let minimumSMMAmount: Double = 0.0
        static let maximumSMMAmount: Double = 999_999_999.0
        
        // Valid SMM calculation types (from TariffConstants enum)
        static let validCalculationTypes: [String] = [
            DisputeConstants.SMMCalculationTypeKeys.vatIncludedWithholdingExcluded,
            DisputeConstants.SMMCalculationTypeKeys.vatExcludedWithholdingIncluded,
            DisputeConstants.SMMCalculationTypeKeys.vatIncludedWithholdingIncluded,
            DisputeConstants.SMMCalculationTypeKeys.vatExcludedWithholdingExcluded
        ]
    }
    
    // MARK: - Dispute Type Validation
    struct DisputeType {
        // Valid dispute types from TariffConstants enum
        static let validDisputeTypes: [String] = [
            DisputeConstants.DisputeTypeKeys.workerEmployer,
            DisputeConstants.DisputeTypeKeys.commercial,
            DisputeConstants.DisputeTypeKeys.consumer,
            DisputeConstants.DisputeTypeKeys.rent,
            DisputeConstants.DisputeTypeKeys.neighbor,
            DisputeConstants.DisputeTypeKeys.condominium,
            DisputeConstants.DisputeTypeKeys.family,
            DisputeConstants.DisputeTypeKeys.partnershipDissolution,
            DisputeConstants.DisputeTypeKeys.other
        ]
        
        // Valid agreement statuses
        static let validAgreementStatuses = ["agreed", "not_agreed"]
        
        // Valid calculation types
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

    // MARK: - Time Calculation Validation
    struct TimeCalculation {
        // Valid time calculation dispute types from TariffConstants
        static let validTimeDisputeTypes: [String] = [
            "labor_law",
            "commercial_law",
            "consumer_law",
            "rental_disputes",
            "partnership_dissolution",
            "condominium_law",
            "neighbor_law",
            "agricultural_production"
        ]

        // Time limits
        static let minimumWeeks = 1
        static let maximumWeeks = 52
        static let defaultWeeks = 4

        // Week calculation patterns
        static let weekPattern = "^[1-9][0-9]?$"  // 1-99 weeks
    }
    
    // MARK: - Language Validation
    struct Language {
        // Supported languages from AppConstants
        static let supportedLanguages = ["tr", "en"]
        static let defaultLanguage = "tr"
        
        // Language code validation
        static let languageCodePattern = "^[a-z]{2}$"
        static let localePattern = "^[a-z]{2}(_[A-Z]{2})?$"
    }
    
    // MARK: - Year Validation
    struct Year {
        // Available years from TariffConstants and AppConstants
        static let availableYears = [2025, 2026]
        static let currentYear = 2025
        static let defaultYear = 2025
        
        // Year validation
        static let minimumYear = 2025
        static let maximumYear = 2030
        static let yearPattern = "^20[2-3][0-9]$"  // 2020-2039
        
        // Error codes
        static let invalidYearErrorCode = 1007
        static let validationErrorCode = 1005
    }
}

// MARK: - Validation Methods Extension
extension ValidationConstants {
    
    // MARK: - Amount Validation Methods
    
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
    
    /// Validates amount string format based on current locale
    static func validateAmountFormat(_ amountString: String) -> ValidationResult {
        let pattern = LocalizationHelper.isTurkishLocale ? Amount.turkishAmountPattern : Amount.englishAmountPattern
        
        if !amountString.matches(pattern: pattern) {
            return .failure(
                code: Amount.invalidInputErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        return .success
    }
    
    // MARK: - Party Count Validation Methods
    
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
    
    /// Validates party count string format
    static func validatePartyCountFormat(_ countString: String) -> ValidationResult {
        if !countString.matches(pattern: PartyCount.pattern) {
            return .failure(
                code: PartyCount.invalidInputErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidPartyCount)
            )
        }
        
        return .success
    }
    
    // MARK: - Date Validation Methods
    
    /// Validates date format based on current locale
    static func validateDateFormat(_ dateString: String) -> ValidationResult {
        let pattern = LocalizationHelper.isTurkishLocale ? Date.turkishDatePattern : Date.englishDatePattern
        
        if !dateString.matches(pattern: pattern) {
            return .failure(
                code: Amount.invalidInputErrorCode,
                message: "Invalid date format"
            )
        }
        
        return .success
    }
    
    /// Validates if year is supported
    static func validateYear(_ year: Int) -> ValidationResult {
        if !Year.availableYears.contains(year) {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Unsupported year: \(year)"
            )
        }
        
        return .success
    }
    
    // MARK: - Dispute Type Validation Methods
    
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
    
    // MARK: - SMM Calculation Validation Methods
    
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
    
    // MARK: - Text Input Validation Methods
    
    /// Validates email format
    static func validateEmail(_ email: String) -> ValidationResult {
        if email.count > TextInput.maxEmailLength {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Email too long"
            )
        }
        
        if !email.matches(pattern: TextInput.emailPattern) {
            return .failure(
                code: Amount.invalidInputErrorCode,
                message: "Invalid email format"
            )
        }
        
        return .success
    }
    
    /// Validates required field
    static func validateRequiredField(_ text: String) -> ValidationResult {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(
                code: Amount.validationErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.requiredField)
            )
        }
        
        return .success
    }
    
    // MARK: - Language Validation Methods
    
    /// Validates language code
    static func validateLanguageCode(_ code: String) -> ValidationResult {
        if !Language.supportedLanguages.contains(code) {
            return .failure(
                code: Amount.validationErrorCode,
                message: "Unsupported language: \(code)"
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
    
    var errorCode: Int? {
        switch self {
        case .success:
            return nil
        case .failure(let code, _):
            return code
        }
    }
    
    var localizedDescription: String {
        return errorMessage ?? "Unknown validation error"
    }
}

// MARK: - String Extension for Regex Validation
extension String {
    
    /// Checks if string matches the given regex pattern
    func matches(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    /// Validates string against pattern and returns result
    func validate(against pattern: String, errorMessage: String) -> ValidationResult {
        if matches(pattern: pattern) {
            return .success
        } else {
            return .failure(code: ValidationConstants.Amount.invalidInputErrorCode, message: errorMessage)
        }
    }
    
    /// Removes non-numeric characters for amount parsing
    func numericOnly() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    /// Removes non-decimal characters for amount parsing
    func decimalOnly() -> String {
        let allowedCharacters = CharacterSet(charactersIn: ValidationConstants.TextInput.decimalCharacters)
        return self.components(separatedBy: allowedCharacters.inverted).joined()
    }
}

// MARK: - Validation Helper Functions
extension ValidationConstants {
    
    /// Comprehensive input validation for mediation fee calculation
    static func validateMediationInput(
        amount: String,
        partyCount: String,
        disputeType: String,
        agreementStatus: String,
        year: Int
    ) -> ValidationResult {
        
        // Validate amount format
        let amountFormatResult = validateAmountFormat(amount)
        if !amountFormatResult.isValid {
            return amountFormatResult
        }
        
        // Convert and validate amount value
        guard let amountValue = LocalizationHelper.doubleFromLocalizedString(amount) else {
            return .failure(
                code: Amount.invalidInputErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        let amountValueResult = validateAmount(amountValue)
        if !amountValueResult.isValid {
            return amountValueResult
        }
        
        // Validate party count format
        let partyCountFormatResult = validatePartyCountFormat(partyCount)
        if !partyCountFormatResult.isValid {
            return partyCountFormatResult
        }
        
        // Convert and validate party count value
        guard let partyCountValue = Int(partyCount) else {
            return .failure(
                code: PartyCount.invalidInputErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidPartyCount)
            )
        }
        
        let partyCountValueResult = validatePartyCount(partyCountValue)
        if !partyCountValueResult.isValid {
            return partyCountValueResult
        }
        
        // Validate dispute type
        let disputeTypeResult = validateDisputeType(disputeType)
        if !disputeTypeResult.isValid {
            return disputeTypeResult
        }
        
        // Validate agreement status
        let agreementStatusResult = validateAgreementStatus(agreementStatus)
        if !agreementStatusResult.isValid {
            return agreementStatusResult
        }
        
        // Validate year
        let yearResult = validateYear(year)
        if !yearResult.isValid {
            return yearResult
        }
        
        return .success
    }
    
    /// Validates SMM calculation input
    static func validateSMMInput(
        mediationFee: String,
        calculationType: String
    ) -> ValidationResult {
        
        // Validate mediation fee format
        let feeFormatResult = validateAmountFormat(mediationFee)
        if !feeFormatResult.isValid {
            return feeFormatResult
        }
        
        // Convert and validate mediation fee value
        guard let feeValue = LocalizationHelper.doubleFromLocalizedString(mediationFee) else {
            return .failure(
                code: Amount.invalidInputErrorCode,
                message: LocalizationHelper.localizedString(for: LocalizationKeys.Validation.invalidAmount)
            )
        }
        
        let feeValueResult = validateSMMAmount(feeValue)
        if !feeValueResult.isValid {
            return feeValueResult
        }
        
        // Validate calculation type
        let calculationTypeResult = validateSMMCalculationType(calculationType)
        if !calculationTypeResult.isValid {
            return calculationTypeResult
        }
        
        return .success
    }
}
