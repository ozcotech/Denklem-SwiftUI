//
//  SerialDisputesConstants.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import SwiftUI

// MARK: - Serial Disputes Constants
/// Constants for serial disputes calculation (Tariff Article 7/4)
struct SerialDisputesConstants {

    // MARK: - Dispute Type Enum
    enum DisputeType: String, CaseIterable, Identifiable, Codable, Equatable {
        case commercial = "commercial"              // Commercial Disputes
        case nonCommercial = "non_commercial"       // Non-Commercial Disputes

        var id: String { rawValue }

        /// Display name (localized)
        var displayName: String {
            switch self {
            case .commercial:
                return LocalizationKeys.SerialDisputes.commercialDispute.localized
            case .nonCommercial:
                return LocalizationKeys.SerialDisputes.nonCommercialDispute.localized
            }
        }

        /// Icon color for UI
        var iconColor: Color {
            switch self {
            case .commercial:
                return .blue
            case .nonCommercial:
                return .green
            }
        }

        /// System image for UI
        var systemImage: String {
            switch self {
            case .commercial:
                return "building.2.fill"
            case .nonCommercial:
                return "person.3.fill"
            }
        }
    }

    // MARK: - Tariff Year
    static let availableYears = [2025, 2026]
    static let currentYear = 2026
    static let defaultYear = 2026

    // MARK: - Fee Values (2026)
    struct Fees2026 {
        static let year: Int = 2026
        static let commercialFeePerFile: Double = 7_500.0
        static let nonCommercialFeePerFile: Double = 6_000.0
    }

    // MARK: - Fee Values (2025)
    struct Fees2025 {
        static let year: Int = 2025
        static let commercialFeePerFile: Double = 5_000.0
        static let nonCommercialFeePerFile: Double = 4_000.0
    }

    // MARK: - Validation
    struct Validation {
        static let minimumFileCount: Int = 1
        static let maximumFileCount: Int = 1000
        static let defaultFileCount: Int = 10
        static let fileCountPattern = "^[0-9]{1,4}$"
    }

    // MARK: - Currency Settings
    static let currencyCode = "TRY" // Turkish Lira
    static let currencySymbol = "₺"
    static let decimalPlaces = 2

    // MARK: - Display Settings
    static let showCalculationBreakdown = true
    static let showTariffReference = true

    // MARK: - Legal Reference
    static let legalArticle = "Madde 7/4"
    static let legalArticleEN = "Article 7/4"
}

// MARK: - Fee Retrieval Extension
extension SerialDisputesConstants {

    /// Get fee per file for given dispute type and year
    static func getFeePerFile(for disputeType: DisputeType, year: Int) -> Double {
        switch year {
        case 2026:
            return disputeType == .commercial ?
                Fees2026.commercialFeePerFile :
                Fees2026.nonCommercialFeePerFile
        case 2025:
            return disputeType == .commercial ?
                Fees2025.commercialFeePerFile :
                Fees2025.nonCommercialFeePerFile
        default:
            // Default to current year
            return disputeType == .commercial ?
                Fees2026.commercialFeePerFile :
                Fees2026.nonCommercialFeePerFile
        }
    }

    /// Get all fees for a given year
    static func getAllFees(for year: Int) -> (commercial: Double, nonCommercial: Double) {
        switch year {
        case 2026:
            return (Fees2026.commercialFeePerFile, Fees2026.nonCommercialFeePerFile)
        case 2025:
            return (Fees2025.commercialFeePerFile, Fees2025.nonCommercialFeePerFile)
        default:
            return (Fees2026.commercialFeePerFile, Fees2026.nonCommercialFeePerFile)
        }
    }
}
