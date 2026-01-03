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
    
    // MARK: - 2025 Tariff Constants (Official)
    struct Tariff2025 {
        
        // MARK: - Minimum Hours Multiplier
        static let minimumHoursMultiplier = 2
        
        // MARK: - Hourly Rates (Official 2025 Rates)
        static let hourlyRates: [String: Double] = [
            DisputeConstants.DisputeTypeKeys.workerEmployer: 785.0,
            DisputeConstants.DisputeTypeKeys.commercial: 1150.0,
            DisputeConstants.DisputeTypeKeys.consumer: 785.0,
            DisputeConstants.DisputeTypeKeys.rent: 835.0,
            DisputeConstants.DisputeTypeKeys.neighbor: 835.0,
            DisputeConstants.DisputeTypeKeys.condominium: 835.0,
            DisputeConstants.DisputeTypeKeys.family: 785.0,
            DisputeConstants.DisputeTypeKeys.partnershipDissolution: 900.0,
            DisputeConstants.DisputeTypeKeys.other: 785.0
        ]
        
        // MARK: - Party Count Thresholds
        static let partyCountThresholds = [2, 5, 10, Int.max]
        
        // MARK: - Fixed Fees by Party Count (Official 2025 Fees)
        static let fixedFees: [String: [Double]] = [
            DisputeConstants.DisputeTypeKeys.workerEmployer: [1570.0, 1650.0, 1750.0, 1850.0],
            DisputeConstants.DisputeTypeKeys.commercial: [2300.0, 2350.0, 2450.0, 2550.0],
            DisputeConstants.DisputeTypeKeys.consumer: [1570.0, 1650.0, 1750.0, 1850.0],
            DisputeConstants.DisputeTypeKeys.rent: [1670.0, 1750.0, 1850.0, 1950.0],
            DisputeConstants.DisputeTypeKeys.neighbor: [1670.0, 1750.0, 1850.0, 1950.0],
            DisputeConstants.DisputeTypeKeys.condominium: [1670.0, 1750.0, 1850.0, 1950.0],
            DisputeConstants.DisputeTypeKeys.family: [1570.0, 1650.0, 1750.0, 1850.0],
            DisputeConstants.DisputeTypeKeys.partnershipDissolution: [1800.0, 2000.0, 2100.0, 2200.0],
            DisputeConstants.DisputeTypeKeys.other: [1570.0, 1650.0, 1750.0, 1850.0]
        ]
        
        // MARK: - Minimum Fees (Official 2025)
        static let minimumFees: [String: Double] = [
            "general": 6000.0,
            "commercial": 9000.0
        ]
        
        // MARK: - Bracket Calculation (Official 2025)
        static let brackets: [(limit: Double, rate: Double)] = [
            (300_000.0, 0.06),
            (780_000.0, 0.05),
            (1_560_000.0, 0.04),
            (4_680_000.0, 0.03),
            (6_240_000.0, 0.02),
            (12_480_000.0, 0.015),
            (26_520_000.0, 0.01),
            (Double.infinity, 0.005)
        ]
    }
    
    // MARK: - 2026 Tariff Constants (Official - Updated)
    struct Tariff2026 {
        
        // MARK: - Minimum Hours Multiplier
        static let minimumHoursMultiplier = 2
        
        // MARK: - Hourly Rates (Official 2026 Rates)
        static let hourlyRates: [String: Double] = [
            DisputeConstants.DisputeTypeKeys.workerEmployer: 1130.0,
            DisputeConstants.DisputeTypeKeys.commercial: 1500.0,
            DisputeConstants.DisputeTypeKeys.consumer: 1000.0,
            DisputeConstants.DisputeTypeKeys.rent: 1170.0,
            DisputeConstants.DisputeTypeKeys.neighbor: 1000.0,
            DisputeConstants.DisputeTypeKeys.condominium: 1000.0,
            DisputeConstants.DisputeTypeKeys.family: 1000.0,
            DisputeConstants.DisputeTypeKeys.partnershipDissolution: 1170.0,
            DisputeConstants.DisputeTypeKeys.other: 1000.0
        ]
        
        // MARK: - Party Count Thresholds
        static let partyCountThresholds = [2, 5, 10, Int.max]
        
        // MARK: - Fixed Fees by Party Count (Official 2026 Fees)
        static let fixedFees: [String: [Double]] = [
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
        
        // MARK: - Minimum Fees (Official 2026)
        static let minimumFees: [String: Double] = [
            "general": 9000.0,
            "commercial": 13000.0
        ]
        
        // MARK: - Bracket Calculation (Official 2026)
        static let brackets: [(limit: Double, rate: Double)] = [
            (600_000.0, 0.06),
            (1_560_000.0, 0.05),
            (3_120_000.0, 0.04),
            (6_240_000.0, 0.03),
            (15_600_000.0, 0.02),
            (28_080_000.0, 0.015),
            (53_040_000.0, 0.01),
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
