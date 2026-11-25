//
//  TariffConstants.swift
//  Denklem
//
//  Created by ozkan on 15.07.2025.
//

import Foundation

// MARK: - Tariff Constants
struct TariffConstants {
    
    // MARK: - Tariff Years
    // Single source of truth: TariffYear. Adding a TariffYear case updates these values.
    static var availableYears: [Int] { TariffYear.allCases.map(\.rawValue) }
    /// Active mediation tariff year (date based, see TariffYear.current)
    static var currentYear: Int { TariffYear.current.rawValue }
    
    // MARK: - Amount Limits
    static let minimumAmount: Double = 0.01
    static let maximumAmount: Double = 999_999_999.0
    
    // MARK: - Party Count Limits
    static let minimumPartyCount = 2
    static let maximumPartyCount = 1000  // Synced with validation messages
    static let defaultPartyCount = 2
    
    // MARK: - SMM Calculation Constants
    static let kdvRate: Double = 0.20
    static let stopajRate: Double = 0.20
    
    // MARK: - Time Calculation Dispute Types
    static let timeCalculationDisputeTypes: [String: [Int]] = [
        "labor_law": [3, 4],
        "commercial_law": [6, 8],
        "consumer_law": [3, 4],
        "rental_disputes": [3, 4],
        "partnership_dissolution": [3, 4],
        "condominium_law": [3, 4],
        "neighbor_law": [3, 4],
        "agricultural_production": [2, 3]
    ]
    
    // MARK: - Currency Settings
    static let currencyCode = "TRY"
    static let currencySymbol = "₺"
    static let decimalPlaces = 2
    
    // MARK: - Debug Settings
    #if DEBUG
    static let enableDebugCalculation = true
    static let showCalculationLogs = true
    static let enableTestData = true
    #else
    static let enableDebugCalculation = false
    static let showCalculationLogs = false
    static let enableTestData = false
    #endif
}

// MARK: - Tariff Constants Extension
extension TariffConstants {
    
    /// Validates if amount is within allowed range
    static func isValidAmount(_ amount: Double) -> Bool {
        return amount >= minimumAmount && amount <= maximumAmount
    }
    
    /// Validates if party count is within allowed range
    static func isValidPartyCount(_ count: Int) -> Bool {
        return count >= minimumPartyCount && count <= maximumPartyCount
    }
    
    /// Validates if year is supported
    static func isValidYear(_ year: Int) -> Bool {
        return availableYears.contains(year)
    }
    
    /// Returns error message for invalid amount using LocalizationKeys
    static func getAmountValidationError(for amount: Double) -> String {
        if amount < minimumAmount {
            return NSLocalizedString(LocalizationKeys.Validation.Amount.min, comment: "Minimum amount error")
        } else if amount > maximumAmount {
            return NSLocalizedString(LocalizationKeys.Validation.Amount.max, comment: "Maximum amount error")
        }
        return ""
    }
    
    /// Returns error message for invalid party count using LocalizationKeys
    static func getPartyCountValidationError(for count: Int) -> String {
        if count < minimumPartyCount {
            return NSLocalizedString(LocalizationKeys.Validation.PartyCount.min, comment: "Minimum party count error")
        } else if count > maximumPartyCount {
            return NSLocalizedString(LocalizationKeys.Validation.PartyCount.max, comment: "Maximum party count error")
        }
        return ""
    }
}

// MARK: - Agreement Status (Localized)
enum AgreementStatus: String, CaseIterable {
    case agreed = "agreed"
    case notAgreed = "not_agreed"
    
    var displayName: String {
        switch self {
        case .agreed:
            return LocalizationKeys.AgreementStatus.agreed.localized
        case .notAgreed:
            return LocalizationKeys.AgreementStatus.notAgreed.localized
        }
    }
    
    var description: String {
        switch self {
        case .agreed:
            return LocalizationKeys.AgreementStatus.Description.agreed.localized
        case .notAgreed:
            return LocalizationKeys.AgreementStatus.Description.notAgreed.localized
        }
    }
}

// MARK: - SMM Calculation Types (Localized)
enum SMMCalculationType: String, CaseIterable {
    case vatIncludedWithholdingExcluded = "vat_included_withholding_excluded"
    case vatExcludedWithholdingIncluded = "vat_excluded_withholding_included"
    case vatIncludedWithholdingIncluded = "vat_included_withholding_included"
    case vatExcludedWithholdingExcluded = "vat_excluded_withholding_excluded"
    
    var displayName: String {
        switch self {
        case .vatIncludedWithholdingExcluded:
            return LocalizationKeys.SMMCalculationType.vatIncludedWithholdingExcluded.localized
        case .vatExcludedWithholdingIncluded:
            return LocalizationKeys.SMMCalculationType.vatExcludedWithholdingIncluded.localized
        case .vatIncludedWithholdingIncluded:
            return LocalizationKeys.SMMCalculationType.vatIncludedWithholdingIncluded.localized
        case .vatExcludedWithholdingExcluded:
            return LocalizationKeys.SMMCalculationType.vatExcludedWithholdingExcluded.localized
        }
    }
    
    var description: String {
        switch self {
        case .vatIncludedWithholdingExcluded:
            return LocalizationKeys.SMMCalculationType.Description.vatIncludedWithholdingExcluded.localized
        case .vatExcludedWithholdingIncluded:
            return LocalizationKeys.SMMCalculationType.Description.vatExcludedWithholdingIncluded.localized
        case .vatIncludedWithholdingIncluded:
            return LocalizationKeys.SMMCalculationType.Description.vatIncludedWithholdingIncluded.localized
        case .vatExcludedWithholdingExcluded:
            return LocalizationKeys.SMMCalculationType.Description.vatExcludedWithholdingExcluded.localized
        }
    }
    
    // Legacy support - maps old Turkish keys to new English keys
}

// MARK: - Calculation Types (Localized)
enum CalculationType: String, CaseIterable {
    case monetary = "monetary"
    case nonMonetary = "non_monetary"
    case timeCalculation = "time_calculation"
    case smmCalculation = "smm_calculation"
    
    var displayName: String {
        switch self {
        case .monetary:
            return LocalizationKeys.CalculationType.monetary.localized
        case .nonMonetary:
            return LocalizationKeys.CalculationType.nonMonetary.localized
        case .timeCalculation:
            return LocalizationKeys.CalculationType.timeCalculation.localized
        case .smmCalculation:
            return LocalizationKeys.CalculationType.smmCalculation.localized
        }
    }
    
    var description: String {
        switch self {
        case .monetary:
            return LocalizationKeys.CalculationType.Description.monetary.localized
        case .nonMonetary:
            return LocalizationKeys.CalculationType.Description.nonMonetary.localized
        case .timeCalculation:
            return LocalizationKeys.CalculationType.Description.timeCalculation.localized
        case .smmCalculation:
            return LocalizationKeys.CalculationType.Description.smmCalculation.localized
        }
    }
}

// MARK: - SMM Result Models
struct SMMResult {
    let rows: [SMMResultRow]
}

struct SMMResultRow {
    let label: String
}
