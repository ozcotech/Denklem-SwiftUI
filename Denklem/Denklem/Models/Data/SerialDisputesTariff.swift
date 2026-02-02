//
//  SerialDisputesTariff.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import Foundation

// MARK: - Serial Disputes Tariff
/// Tariff data for serial disputes calculation (Article 7/4)
/// Supports both 2025 and 2026 tariff years
struct SerialDisputesTariff {

    // MARK: - Properties
    let year: Int
    let commercialFeePerFile: Double
    let nonCommercialFeePerFile: Double
    let isFinalized: Bool

    // MARK: - Initialization
    init(year: Int) {
        self.year = year

        switch year {
        case 2026:
            self.commercialFeePerFile = SerialDisputesConstants.Fees2026.commercialFeePerFile
            self.nonCommercialFeePerFile = SerialDisputesConstants.Fees2026.nonCommercialFeePerFile
            self.isFinalized = true
        case 2025:
            self.commercialFeePerFile = SerialDisputesConstants.Fees2025.commercialFeePerFile
            self.nonCommercialFeePerFile = SerialDisputesConstants.Fees2025.nonCommercialFeePerFile
            self.isFinalized = true
        default:
            // Default to 2026
            self.commercialFeePerFile = SerialDisputesConstants.Fees2026.commercialFeePerFile
            self.nonCommercialFeePerFile = SerialDisputesConstants.Fees2026.nonCommercialFeePerFile
            self.isFinalized = true
        }
    }

    // MARK: - Fee Retrieval

    /// Get fee per file for given dispute type
    func getFeePerFile(for disputeType: SerialDisputesConstants.DisputeType) -> Double {
        switch disputeType {
        case .commercial:
            return commercialFeePerFile
        case .nonCommercial:
            return nonCommercialFeePerFile
        }
    }

    /// Calculate total fee for given file count and dispute type
    func calculateTotalFee(
        fileCount: Int,
        disputeType: SerialDisputesConstants.DisputeType
    ) -> Double {
        let feePerFile = getFeePerFile(for: disputeType)
        return Double(fileCount) * feePerFile
    }
}

// MARK: - Factory Methods
extension SerialDisputesTariff {

    /// Create tariff for 2026
    static func tariff2026() -> SerialDisputesTariff {
        return SerialDisputesTariff(year: 2026)
    }

    /// Create tariff for 2025
    static func tariff2025() -> SerialDisputesTariff {
        return SerialDisputesTariff(year: 2025)
    }

    /// Create tariff for given TariffYear enum
    static func tariff(for tariffYear: TariffYear) -> SerialDisputesTariff {
        return SerialDisputesTariff(year: tariffYear.rawValue)
    }
}

// MARK: - Summary & Validation
extension SerialDisputesTariff {

    /// Returns a summary of the tariff data
    /// Note: This method uses hardcoded Turkish strings for debug purposes only.
    /// It is not intended for user-facing UI and does not require localization.
    func getSummary() -> String {
        return """
        Seri Uyuşmazlık Tarifesi - \(year)
        ────────────────────────
        Ticari Uyuşmazlıklar: \(LocalizationHelper.formatCurrency(commercialFeePerFile)) / dosya
        Ticari Harici: \(LocalizationHelper.formatCurrency(nonCommercialFeePerFile)) / dosya
        Durum: \(isFinalized ? "Kesinleşmiş" : "Taslak")
        """
    }

    /// Validate tariff data integrity
    func validateData() -> Bool {
        return commercialFeePerFile > 0 &&
               nonCommercialFeePerFile > 0 &&
               SerialDisputesConstants.availableYears.contains(year)
    }
}
