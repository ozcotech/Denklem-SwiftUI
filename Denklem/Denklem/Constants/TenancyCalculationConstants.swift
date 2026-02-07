//
//  TenancyCalculationConstants.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import Foundation
import SwiftUI

// MARK: - Tenancy Calculation Constants
/// Constants for tenancy (eviction/determination) fee calculation
/// Legal basis: Attorney Fee Tariff Art. 9/1, Mediation Fee Tariff Art. 7/5
struct TenancyCalculationConstants {

    // MARK: - Tariff Year
    static let availableYears = [2025, 2026]
    static let currentYear = 2026
    static let defaultYear = 2026

    // MARK: - Tenancy Type
    enum TenancyType: String, CaseIterable, Identifiable {
        case eviction = "eviction"             // Tahliye
        case determination = "determination"   // Kira Tespiti

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .eviction:
                return LocalizationKeys.RentSpecial.eviction.localized
            case .determination:
                return LocalizationKeys.RentSpecial.determination.localized
            }
        }

        var inputDescription: String {
            switch self {
            case .eviction:
                return LocalizationKeys.RentSpecial.evictionDescription.localized
            case .determination:
                return LocalizationKeys.RentSpecial.determinationDescription.localized
            }
        }
    }

    // MARK: - Tenancy Fee Mode
    enum TenancyFeeMode: String, CaseIterable, Identifiable {
        case attorneyFee = "attorney_fee"       // Avukatlık Ücreti
        case mediationFee = "mediation_fee"     // Arabuluculuk Ücreti

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .attorneyFee:
                return LocalizationKeys.RentSpecial.attorneyFeeOption.localized
            case .mediationFee:
                return LocalizationKeys.RentSpecial.mediationFeeOption.localized
            }
        }

        var description: String {
            switch self {
            case .attorneyFee:
                return LocalizationKeys.RentSpecial.attorneyFeeOptionDescription.localized
            case .mediationFee:
                return LocalizationKeys.RentSpecial.mediationFeeOptionDescription.localized
            }
        }

        var systemImage: String {
            switch self {
            case .attorneyFee:
                return "person.circle.fill"
            case .mediationFee:
                return "building.2.crop.circle.fill"
            }
        }

        var iconColor: Color {
            switch self {
            case .attorneyFee:
                return .indigo
            case .mediationFee:
                return .teal
            }
        }
    }

    // MARK: - Court Minimum Fees (Attorney Fee - Tariff Part 2, Section 2)
    /// Minimum attorney fees by court type for tenancy cases
    enum TenancyCourtType: String, CaseIterable, Identifiable {
        case civilPeace = "civil_peace"         // Sulh Hukuk Mahkemesi
        case firstInstance = "first_instance"   // Asliye Mahkemesi
        case enforcement = "enforcement"        // İcra Mahkemesi

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .civilPeace:
                return LocalizationKeys.RentSpecial.courtCivilPeace.localized
            case .firstInstance:
                return LocalizationKeys.RentSpecial.courtFirstInstance.localized
            case .enforcement:
                return LocalizationKeys.RentSpecial.courtEnforcement.localized
            }
        }

        func minimumFee(for year: Int) -> Double {
            switch year {
            case 2025:
                switch self {
                case .civilPeace: return 18_000.0
                case .firstInstance: return 30_000.0
                case .enforcement: return 12_000.0
                }
            case 2026:
                switch self {
                case .civilPeace: return 30_000.0
                case .firstInstance: return 45_000.0
                case .enforcement: return 18_000.0
                }
            default:
                return minimumFee(for: 2026)
            }
        }

        /// Returns formatted warning message for this court type
        func warningMessage(for year: Int) -> String {
            let minFee = minimumFee(for: year)
            let formattedFee = LocalizationHelper.formatCurrency(minFee)
            return String(
                format: LocalizationKeys.RentSpecial.courtMinimumWarningFormat.localized,
                displayName,
                formattedFee
            )
        }
    }

    // MARK: - Mediation Minimum Fee (Art. 7/7)
    /// Minimum mediation fee when agreement is reached, regardless of agreement amount
    /// "Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, anlaşma bedeline
    /// bakılmaksızın arabuluculuk ücreti X TL'den az olamaz."
    struct MediationMinimumFee {
        static func minimumFee(for year: Int) -> Double {
            switch year {
            case 2025: return 6_000.0
            case 2026: return 9_000.0
            default: return 9_000.0
            }
        }
    }

    // MARK: - Validation
    struct Validation {
        static let minimumAmount: Double = 0.01
        static let maximumAmount: Double = 999_999_999.0
    }

    // MARK: - Currency Settings
    static let currencyCode = TariffConstants.currencyCode
    static let currencySymbol = TariffConstants.currencySymbol
    static let decimalPlaces = TariffConstants.decimalPlaces

    // MARK: - Display Settings
    static let showCalculationBreakdown = true
    static let showTariffReference = true
    static let showLegalReference = true
    static let showCourtMinimumWarnings = true
}

// MARK: - Tenancy Calculation Constants Extension
extension TenancyCalculationConstants {

    /// Validates if year is supported
    static func isValidYear(_ year: Int) -> Bool {
        return availableYears.contains(year)
    }

    /// Validates amount
    static func validateAmount(_ amount: Double) -> ValidationResult {
        if amount < Validation.minimumAmount {
            return .failure(
                code: ValidationConstants.Amount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.Amount.min.localized
            )
        }

        if amount > Validation.maximumAmount {
            return .failure(
                code: ValidationConstants.Amount.invalidInputErrorCode,
                message: LocalizationKeys.Validation.Amount.max.localized
            )
        }

        return .success
    }
}
