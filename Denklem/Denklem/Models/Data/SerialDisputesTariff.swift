//
//  SerialDisputesTariff.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import Foundation

// MARK: - Serial Disputes Tariff
/// Tariff data for serial disputes calculation (Article 7/4)
/// Fees come from the yearly tariff files (Tariff2025, Tariff2026, …) via TariffYear
struct SerialDisputesTariff {

    // MARK: - Properties
    let year: Int
    let commercialFeePerFile: Double
    let nonCommercialFeePerFile: Double
    let isFinalized: Bool

    // MARK: - Initialization

    /// Reads the Art. 7/4 fees from the tariff of the given year
    init(tariffYear: TariffYear) {
        let tariff = tariffYear.getTariffProtocol()
        self.year = tariffYear.rawValue
        self.commercialFeePerFile = tariff.serialCommercialFeePerFile
        self.nonCommercialFeePerFile = tariff.serialNonCommercialFeePerFile
        self.isFinalized = tariff.isFinalized
    }

    /// Returns nil for a year without a mediation tariff
    /// (instead of silently using another year's fees)
    init?(year: Int) {
        guard let tariffYear = TariffYear(rawValue: year) else { return nil }
        self.init(tariffYear: tariffYear)
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

    /// Create tariff for given TariffYear enum
    static func tariff(for tariffYear: TariffYear) -> SerialDisputesTariff {
        return SerialDisputesTariff(tariffYear: tariffYear)
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
               TariffYear(rawValue: year) != nil
    }
}
