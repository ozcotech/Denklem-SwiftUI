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
    static let currentYear = 2025
    static let defaultYear = 2025
    
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
    
    // MARK: - 2025 Tariff Constants
    struct Tariff2025 {
        
        // MARK: - Minimum Hours Multiplier (for fee calculation)
        static let minimumHoursMultiplier = 2 // Non-agreement cases require minimum 2 hours
        // MARK: - Hourly Rates
        static let hourlyRates: [String: Double] = [
            "worker_employer": 785,
            "commercial": 1150,
            "consumer": 785,
            "rent": 835,
            "neighbor": 835,
            "condominium": 835,
            "family": 785,
            "other": 785,
            "partnership_dissolution": 900
        ]
        
        // MARK: - Party Count Thresholds
        static let partyCountThresholds = [2, 5, 10, Int.max]
        
        // MARK: - Fixed Fees by Party Count
        static let fixedFees: [String: [Double]] = [
            "worker_employer": [1570, 1650, 1750, 1850],
            "commercial": [2300, 2350, 2450, 2550],
            "consumer": [1570, 1650, 1750, 1850],
            "rent": [1670, 1750, 1850, 1950],
            "neighbor": [1670, 1750, 1850, 1950],
            "condominium": [1670, 1750, 1850, 1950],
            "family": [1570, 1650, 1750, 1850],
            "partnership_dissolution": [1800, 2000, 2100, 2200],
            "other": [1570, 1650, 1750, 1850]
        ]
        
        // MARK: - Minimum Fees
        static let minimumFees: [String: Double] = [
            "general": 6000,
            "commercial": 9000
        ]
        
        // MARK: - Bracket Calculation (for monetary disputes with agreement)
        static let brackets: [(limit: Double, rate: Double)] = [
            (300_000, 0.06),
            (780_000, 0.05),
            (1_560_000, 0.04),
            (4_680_000, 0.03),
            (6_240_000, 0.02),
            (12_480_000, 0.015),
            (26_520_000, 0.01),
            (Double.infinity, 0.005)
        ]
    }
    
    // MARK: - 2026 Tariff Constants (Placeholder - Will be updated in January 2026)
    struct Tariff2026 {
        // MARK: - Minimum Hours Multiplier (for fee calculation)
        static let minimumHoursMultiplier = 2 // Non-agreement cases require minimum 2 hours
        // TODO: These values are estimates with 15% increase
        // IMPORTANT: Update these values when official 2026 tariff is published in January 2026
        
        static let hourlyRates: [String: Double] = [
            "worker_employer": 785 * 1.15,
            "commercial": 1150 * 1.15,
            "consumer": 785 * 1.15,
            "rent": 835 * 1.15,
            "neighbor": 835 * 1.15,
            "condominium": 835 * 1.15,
            "family": 785 * 1.15,
            "other": 785 * 1.15,
            "partnership_dissolution": 900 * 1.15
        ]
        
        static let fixedFees: [String: [Double]] = [
            "worker_employer": [1570 * 1.15, 1650 * 1.15, 1750 * 1.15, 1850 * 1.15],
            "commercial": [2300 * 1.15, 2350 * 1.15, 2450 * 1.15, 2550 * 1.15],
            "consumer": [1570 * 1.15, 1650 * 1.15, 1750 * 1.15, 1850 * 1.15],
            "rent": [1670 * 1.15, 1750 * 1.15, 1850 * 1.15, 1950 * 1.15],
            "neighbor": [1670 * 1.15, 1750 * 1.15, 1850 * 1.15, 1950 * 1.15],
            "condominium": [1670 * 1.15, 1750 * 1.15, 1850 * 1.15, 1950 * 1.15],
            "family": [1570 * 1.15, 1650 * 1.15, 1750 * 1.15, 1850 * 1.15],
            "partnership_dissolution": [1800 * 1.15, 2000 * 1.15, 2100 * 1.15, 2200 * 1.15],
            "other": [1570 * 1.15, 1650 * 1.15, 1750 * 1.15, 1850 * 1.15]
        ]
        
        static let minimumFees: [String: Double] = [
            // TODO: Update with official 2026 values
            "general": 6000 * 1.15,
            "commercial": 9000 * 1.15
        ]
        
        static let brackets: [(limit: Double, rate: Double)] = [
            // TODO: Update with official 2026 values
            (300_000 * 1.15, 0.06),
            (780_000 * 1.15, 0.05),
            (1_560_000 * 1.15, 0.04),
            (4_680_000 * 1.15, 0.03),
            (6_240_000 * 1.15, 0.02),
            (12_480_000 * 1.15, 0.015),
            (26_520_000 * 1.15, 0.01),
            (Double.infinity, 0.005)
        ]
    }
    
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
        let locale = Locale.current
        if locale.identifier.hasPrefix("en") {
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
    
    /// Returns the appropriate tariff data for the given year
    static func getTariffData(for year: Int) -> (hourlyRates: [String: Double], fixedFees: [String: [Double]], minimumFees: [String: Double], brackets: [(limit: Double, rate: Double)]) {
        switch year {
        case 2025:
            return (Tariff2025.hourlyRates, Tariff2025.fixedFees, Tariff2025.minimumFees, Tariff2025.brackets)
        case 2026:
            return (Tariff2026.hourlyRates, Tariff2026.fixedFees, Tariff2026.minimumFees, Tariff2026.brackets)
        default:
            return (Tariff2025.hourlyRates, Tariff2025.fixedFees, Tariff2025.minimumFees, Tariff2025.brackets)
        }
    }
    
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
        case "worker_employer":
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "")
        case "commercial":
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "")
        case "consumer":
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "")
        case "rent":
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "")
        case "neighbor":
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "")
        case "condominium":
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "")
        case "family":
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "")
        case "partnership_dissolution":
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "")
        default:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "")
        }
    }
    
    /// Maps dispute type to tariff key
    static func mapDisputeTypeToTariffKey(_ disputeType: String?) -> String {
        guard let disputeType = disputeType else { return "other" }
        
        if disputeType.contains("Kira") || disputeType.contains("Rent") { return "rent" }
        if disputeType.contains("Komşu") || disputeType.contains("Neighbor") { return "neighbor" }
        if disputeType.contains("Kat Mülkiyeti") || disputeType.contains("Condominium") { return "condominium" }
        if disputeType.contains("Ortaklık") || disputeType.contains("Partnership") { return "partnership_dissolution" }
        if disputeType.contains("İşçi") || disputeType.contains("İşveren") || disputeType.contains("Worker") || disputeType.contains("Employer") { return "worker_employer" }
        if disputeType.contains("Ticari") || disputeType.contains("Commercial") { return "commercial" }
        if disputeType.contains("Tüketici") || disputeType.contains("Consumer") { return "consumer" }
        if disputeType.contains("Aile") || disputeType.contains("Family") { return "family" }
        
        return "other"
    }
}

// MARK: - Dispute Categories (Localized)
enum DisputeCategory: String, CaseIterable {
    case workerEmployer = "worker_employer"
    case commercial = "commercial"
    case consumer = "consumer"
    case rent = "rent"
    case neighbor = "neighbor"
    case condominium = "condominium"
    case family = "family"
    case partnershipDissolution = "partnership_dissolution"
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
            return NSLocalizedString(LocalizationKeys.AgreementStatus.agreed, comment: "")
        case .notAgreed:
            return NSLocalizedString(LocalizationKeys.AgreementStatus.notAgreed, comment: "")
        }
    }
    
    var description: String {
        switch self {
        case .agreed:
            return NSLocalizedString(LocalizationKeys.AgreementStatus.Description.agreed, comment: "")
        case .notAgreed:
            return NSLocalizedString(LocalizationKeys.AgreementStatus.Description.notAgreed, comment: "")
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
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.vatIncludedWithholdingExcluded, comment: "")
        case .vatExcludedWithholdingIncluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.vatExcludedWithholdingIncluded, comment: "")
        case .vatIncludedWithholdingIncluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.vatIncludedWithholdingIncluded, comment: "")
        case .vatExcludedWithholdingExcluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.vatExcludedWithholdingExcluded, comment: "")
        }
    }
    
    var description: String {
        switch self {
        case .vatIncludedWithholdingExcluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.Description.vatIncludedWithholdingExcluded, comment: "")
        case .vatExcludedWithholdingIncluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.Description.vatExcludedWithholdingIncluded, comment: "")
        case .vatIncludedWithholdingIncluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.Description.vatIncludedWithholdingIncluded, comment: "")
        case .vatExcludedWithholdingExcluded:
            return NSLocalizedString(LocalizationKeys.SMMCalculationType.Description.vatExcludedWithholdingExcluded, comment: "")
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
            return NSLocalizedString(LocalizationKeys.CalculationType.monetary, comment: "")
        case .nonMonetary:
            return NSLocalizedString(LocalizationKeys.CalculationType.nonMonetary, comment: "")
        case .timeCalculation:
            return NSLocalizedString(LocalizationKeys.CalculationType.timeCalculation, comment: "")
        case .smmCalculation:
            return NSLocalizedString(LocalizationKeys.CalculationType.smmCalculation, comment: "")
        }
    }
    
    var description: String {
        switch self {
        case .monetary:
            return NSLocalizedString(LocalizationKeys.CalculationType.Description.monetary, comment: "")
        case .nonMonetary:
            return NSLocalizedString(LocalizationKeys.CalculationType.Description.nonMonetary, comment: "")
        case .timeCalculation:
            return NSLocalizedString(LocalizationKeys.CalculationType.Description.timeCalculation, comment: "")
        case .smmCalculation:
            return NSLocalizedString(LocalizationKeys.CalculationType.Description.smmCalculation, comment: "")
        }
    }
}

// MARK: - SMM Result Table Labels (Localized)
struct SMMResultTableLabels {
    static let mediationFee = NSLocalizedString(LocalizationKeys.SMMResult.mediationFee, comment: "")
    static let gelirVergisiStopaji = NSLocalizedString(LocalizationKeys.SMMResult.incomeTaxWithholding, comment: "")
    static let netUcret = NSLocalizedString(LocalizationKeys.SMMResult.netFee, comment: "")
    static let kdv = NSLocalizedString(LocalizationKeys.SMMResult.vat, comment: "")
    static let tahsilEdilecek = NSLocalizedString(LocalizationKeys.SMMResult.collectedFee, comment: "")
    static let tuzelKisi = NSLocalizedString(LocalizationKeys.SMMResult.legalPerson, comment: "")
    static let gercekKisi = NSLocalizedString(LocalizationKeys.SMMResult.realPerson, comment: "")
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
