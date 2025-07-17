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
    static let minimumHoursMultiplier = 2 // Non-agreement cases require minimum 2 hours
    
    // MARK: - 2025 Tariff Constants
    struct Tariff2025 {
        
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
        "agricultural_production": [2, 3, 4]
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
    
    /// Returns formatted currency symbol with code
    static var currencyDisplay: String {
        return "\(currencySymbol) (\(currencyCode))"
    }
    
    /// Returns maximum amount formatted as currency
    static var formattedMaxAmount: String {
        return String(format: "%.0f %@", maximumAmount, currencySymbol)
    }
    
    /// Returns minimum amount formatted as currency
    static var formattedMinAmount: String {
        return String(format: "%.2f %@", minimumAmount, currencySymbol)
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
    
    /// Returns error message for invalid amount
    static func getAmountValidationError(for amount: Double) -> String {
        if amount < minimumAmount {
            return NSLocalizedString("validation.amount.min", comment: "Minimum amount error")
        } else if amount > maximumAmount {
            return NSLocalizedString("validation.amount.max", comment: "Maximum amount error")
        }
        return ""
    }
    
    /// Returns error message for invalid party count
    static func getPartyCountValidationError(for count: Int) -> String {
        if count < minimumPartyCount {
            return NSLocalizedString("validation.party_count.min", comment: "Minimum party count error")
        } else if count > maximumPartyCount {
            return NSLocalizedString("validation.party_count.max", comment: "Maximum party count error")
        }
        return ""
    }
    
    /// Maps dispute type key to localized display name
    static func getLocalizedDisputeTypeName(for key: String) -> String {
        return NSLocalizedString("dispute_type.\(key)", comment: "Dispute type name")
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
        return NSLocalizedString("dispute_type.\(self.rawValue)", comment: "Dispute category name")
    }
    
    var description: String {
        return NSLocalizedString("dispute_type.\(self.rawValue).description", comment: "Dispute category description")
    }
}

// MARK: - Agreement Status (Localized)
enum AgreementStatus: String, CaseIterable {
    case agreed = "agreed"
    case notAgreed = "not_agreed"
    
    var displayName: String {
        return NSLocalizedString("agreement_status.\(self.rawValue)", comment: "Agreement status name")
    }
    
    var description: String {
        return NSLocalizedString("agreement_status.\(self.rawValue).description", comment: "Agreement status description")
    }
}

// MARK: - SMM Calculation Types (Localized)
enum SMMCalculationType: String, CaseIterable {
    case vatIncludedWithholdingExcluded = "vat_included_withholding_excluded"
    case vatExcludedWithholdingIncluded = "vat_excluded_withholding_included"
    case vatIncludedWithholdingIncluded = "vat_included_withholding_included"
    case vatExcludedWithholdingExcluded = "vat_excluded_withholding_excluded"
    
    var displayName: String {
        return NSLocalizedString("smm_calculation_type.\(self.rawValue)", comment: "SMM calculation type name")
    }
    
    var description: String {
        return NSLocalizedString("smm_calculation_type.\(self.rawValue).description", comment: "SMM calculation type description")
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
        return NSLocalizedString("calculation_type.\(self.rawValue)", comment: "Calculation type name")
    }
    
    var description: String {
        return NSLocalizedString("calculation_type.\(self.rawValue).description", comment: "Calculation type description")
    }
}

// MARK: - SMM Result Table Labels (Localized)
struct SMMResultTableLabels {
    static let mediationFee = NSLocalizedString("smm_result.mediation_fee", comment: "Mediation fee label")
    static let gelirVergisiStopaji = NSLocalizedString("smm_result.income_tax_withholding", comment: "Income tax withholding label")
    static let netUcret = NSLocalizedString("smm_result.net_fee", comment: "Net fee label")
    static let kdv = NSLocalizedString("smm_result.vat", comment: "VAT label")
    static let tahsilEdilecek = NSLocalizedString("smm_result.collected_fee", comment: "Collected fee label")
    static let tuzelKisi = NSLocalizedString("smm_result.legal_person", comment: "Legal person label")
    static let gercekKisi = NSLocalizedString("smm_result.real_person", comment: "Real person label")
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
