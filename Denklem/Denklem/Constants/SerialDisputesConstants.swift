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

    // MARK: - Tariff Year & Fees
    // Supported years come from TariffYear (single source of truth).
    // Fees per file (Art. 7/4) live in the yearly tariff files: serialCommercialFeePerFile /
    // serialNonCommercialFeePerFile in Tariff2025, Tariff2026, …

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
    /// Returns localized legal article reference
    static var legalArticle: String {
        LocalizationKeys.SerialDisputes.legalArticle.localized
    }
}
