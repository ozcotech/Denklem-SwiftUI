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
    static let availableYears = [2025, 2026]
    static let currentYear = 2026
    static let defaultYear = currentYear
    
    // MARK: - Amount Limits
    static let minimumAmount: Double = 0.01
    static let maximumAmount: Double = 999_999_999.0
    static let defaultAmount: Double = 10_000.0
    
    // MARK: - Party Count Limits
    static let minimumPartyCount = 2
    static let maximumPartyCount = 1000  // Synced with validation messages
    static let defaultPartyCount = 2
    
    // MARK: - SMM Calculation Constants
    static let kdvRate: Double = 0.20
    static let stopajRate: Double = 0.20
    static let smmCalculationEnabled = true
    
    // MARK: - Time Calculation Constants
    static let timeCalculationEnabled = true
    
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
    
    // MARK: - Validation Rules
    static let allowZeroAmount = false
    static let allowNegativeAmount = false
    static let roundToNearestTen = false
    
    // MARK: - Display Settings
    static let showDetailedCalculation = true
    static let showStepByStepBreakdown = true
    static let showFormulas = false
    
    // MARK: - Export Settings
    static let exportCurrency = currencyCode
    static var exportDateFormat: String {
        let langCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguage) ?? "tr"
        if langCode == "en" {
            return "MM/dd/yyyy"  // American format: 07/15/2025
        } else {
            return "dd.MM.yyyy"  // European/Turkish format: 15.07.2025
        }
    }
    static let exportTimeFormat = "HH:mm"
    
    // MARK: - Error Handling
    static let maxRetryAttempts = 3
    static let calculationTimeout: TimeInterval = 10.0
    
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
    
    /// Returns the current tariff year as string
    static var currentYearString: String {
        return String(currentYear)
    }
    
    /// Returns available years as string array
    static var availableYearsString: [String] {
        return availableYears.map { String($0) }
    }
    
    /// Returns formatted currency symbol with code using LocalizationHelper
    static var currencyDisplay: String {
        return LocalizationHelper.localizedCurrencySymbol
    }
    
    /// Returns maximum amount formatted using LocalizationHelper
    static var formattedMaxAmount: String {
        return LocalizationHelper.formatCurrency(maximumAmount)
    }
    
    /// Returns minimum amount formatted using LocalizationHelper
    static var formattedMinAmount: String {
        return LocalizationHelper.formatCurrency(minimumAmount)
    }
    
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
    
    /// Maps dispute type key to localized display name using LocalizationKeys
    static func getLocalizedDisputeTypeName(for key: String) -> String {
        switch key {
        case DisputeConstants.DisputeTypeKeys.workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "")
        case DisputeConstants.DisputeTypeKeys.commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "")
        case DisputeConstants.DisputeTypeKeys.consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "")
        case DisputeConstants.DisputeTypeKeys.rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "")
        case DisputeConstants.DisputeTypeKeys.neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "")
        case DisputeConstants.DisputeTypeKeys.condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "")
        case DisputeConstants.DisputeTypeKeys.family:
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "")
        case DisputeConstants.DisputeTypeKeys.partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "")
        case DisputeConstants.DisputeTypeKeys.agriculturalProduction:
            return NSLocalizedString(LocalizationKeys.DisputeType.agriculturalProduction, comment: "")
        default:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "")
        }
    }
    
    /// Maps dispute type to tariff key
    static func mapDisputeTypeToTariffKey(_ disputeType: String?) -> String {
        guard let disputeType = disputeType else { return DisputeConstants.DisputeTypeKeys.other }
        
        // Direct key match first
        if DisputeConstants.DisputeTypeKeys.allKeys.contains(disputeType) {
            return disputeType
        }
        
        // Fallback string matching
        if disputeType.contains("Kira") || disputeType.contains("Rent") {
            return DisputeConstants.DisputeTypeKeys.rent
        }
        if disputeType.contains("Komşu") || disputeType.contains("Neighbor") {
            return DisputeConstants.DisputeTypeKeys.neighbor
        }
        if disputeType.contains("Kat Mülkiyeti") || disputeType.contains("Condominium") {
            return DisputeConstants.DisputeTypeKeys.condominium
        }
        if disputeType.contains("Ortaklık") || disputeType.contains("Partnership") {
            return DisputeConstants.DisputeTypeKeys.partnershipDissolution
        }
        if disputeType.contains("Tarımsal") || disputeType.contains("Tarım") || disputeType.contains("Agricultural") {
            return DisputeConstants.DisputeTypeKeys.agriculturalProduction
        }
        if disputeType.contains("İşçi") || disputeType.contains("İşveren") || disputeType.contains("Worker") || disputeType.contains("Employer") {
            return DisputeConstants.DisputeTypeKeys.workerEmployer
        }
        if disputeType.contains("Ticari") || disputeType.contains("Commercial") {
            return DisputeConstants.DisputeTypeKeys.commercial
        }
        if disputeType.contains("Tüketici") || disputeType.contains("Consumer") {
            return DisputeConstants.DisputeTypeKeys.consumer
        }
        if disputeType.contains("Aile") || disputeType.contains("Family") {
            return DisputeConstants.DisputeTypeKeys.family
        }
        
        return DisputeConstants.DisputeTypeKeys.other
    }
}

// MARK: - Legacy Dispute Type Enum (For Backward Compatibility)
// Note: Use Models/Domain/DisputeType for new code
enum LegacyDisputeType: String, CaseIterable {
    case workerEmployer = "worker_employer"
    case commercial = "commercial"
    case consumer = "consumer"
    case rent = "rent"
    case neighbor = "neighbor"
    case condominium = "condominium"
    case family = "family"
    case partnershipDissolution = "partnership_dissolution"
    case agriculturalProduction = "agricultural_production"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "")
        case .agriculturalProduction:
            return NSLocalizedString(LocalizationKeys.DisputeType.agriculturalProduction, comment: "")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "")
        }
    }
    
    var description: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.workerEmployer, comment: "")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.commercial, comment: "")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.consumer, comment: "")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.rent, comment: "")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.neighbor, comment: "")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.condominium, comment: "")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.family, comment: "")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.partnershipDissolution, comment: "")
        case .agriculturalProduction:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.agriculturalProduction, comment: "")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.other, comment: "")
        }
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
    static func fromLegacyKey(_ key: String) -> SMMCalculationType? {
        switch key {
        case "kdv_dahil_stopaj_yok":
            return .vatIncludedWithholdingExcluded
        case "kdv_haric_stopaj_var":
            return .vatExcludedWithholdingIncluded
        case "kdv_dahil_stopaj_var":
            return .vatIncludedWithholdingIncluded
        case "kdv_haric_stopaj_yok":
            return .vatExcludedWithholdingExcluded
        default:
            return nil
        }
    }
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

// MARK: - SMM Result Table Labels (Localized)
struct SMMResultTableLabels {
    static var mediationFee: String { LocalizationKeys.SMMResult.grossFee.localized }
    static var gelirVergisiStopaji: String { LocalizationKeys.SMMResult.withholding.localized }
    static var netUcret: String { LocalizationKeys.SMMResult.netFee.localized }
    static var kdv: String { LocalizationKeys.SMMResult.vat.localized }
    static var tahsilEdilecek: String { LocalizationKeys.SMMResult.totalCollected.localized }
    static var tuzelKisi: String { LocalizationKeys.SMMResult.legalPerson.localized }
    static var gercekKisi: String { LocalizationKeys.SMMResult.realPerson.localized }
}

// MARK: - SMM Result Models
struct SMMResult {
    let rows: [SMMResultRow]
}

struct SMMResultRow {
    let label: String
    let tuzelKisiAmount: Double?
    let gercekKisiAmount: Double?
}

// MARK: - SMM Input Model
struct SMMInput {
    let mediationFee: Double
    let calculationType: SMMCalculationType
}
