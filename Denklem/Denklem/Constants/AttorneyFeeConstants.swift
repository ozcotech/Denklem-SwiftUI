//
//  AttorneyFeeConstants.swift
//  Denklem
//
//  Created by ozkan on 21.01.2026.
//

import Foundation

// MARK: - Attorney Fee Constants
/// Constants for attorney fee calculation (2025, 2026 & 2027 tariffs, Article 16)
struct AttorneyFeeConstants {
	// MARK: - Court Type Enum (for non-monetary disputes)
	enum CourtType: String, CaseIterable, Identifiable, Codable, Equatable {
		case civilPeace = "civil_peace"           // Sulh Hukuk
		case firstInstance = "first_instance"     // Asliye Hukuk Mahkemeleri
		case consumer = "consumer"                // Tüketici Mahkemesi
		case intellectualProperty = "intellectual_property" // Fikri ve Sınai Haklar

		var id: String { rawValue }

		/// Display name (for UI, localization key can be used here)
		var displayName: String {
			switch self {
			case .civilPeace: return LocalizationKeys.CourtType.civilPeace.localized
			case .firstInstance: return LocalizationKeys.CourtType.firstInstance.localized
			case .consumer: return LocalizationKeys.CourtType.consumer.localized
			case .intellectualProperty: return LocalizationKeys.CourtType.intellectualProperty.localized
			}
		}

		/// Base fee for this court type (year-specific)
		func fee(for year: Int) -> Double {
			switch year {
			case 2025:
				switch self {
				case .civilPeace: return 18_000.0
				case .firstInstance: return 30_000.0
				case .consumer: return 15_000.0
				case .intellectualProperty: return 40_000.0
				}
			case 2026:
				switch self {
				case .civilPeace: return 30_000.0
				case .firstInstance: return 45_000.0
				case .consumer: return 22_500.0
				case .intellectualProperty: return 55_000.0
				}
			case 2027:
				switch self {
				case .civilPeace: return 40_000.0
				case .firstInstance: return 62_000.0
				case .consumer: return 30_000.0
				case .intellectualProperty: return 70_000.0
				}
			default:
				// Unknown year: fall back to the most recent tariff
				return fee(for: AttorneyFeeTariffYear.latest.rawValue)
			}
		}

		/// Fee with 1/4 bonus (for agreement, year-specific)
		func feeWithBonus(for year: Int) -> Double {
			switch year {
			case 2025:
				switch self {
				case .civilPeace: return 22_500.0
				case .firstInstance: return 37_500.0
				case .consumer: return 18_750.0
				case .intellectualProperty: return 50_000.0
				}
			case 2026:
				switch self {
				case .civilPeace: return 37_500.0
				case .firstInstance: return 56_250.0
				case .consumer: return 28_125.0
				case .intellectualProperty: return 68_750.0
				}
			case 2027:
				switch self {
				case .civilPeace: return 50_000.0
				case .firstInstance: return 77_500.0
				case .consumer: return 37_500.0
				case .intellectualProperty: return 87_500.0
				}
			default:
				// Unknown year: fall back to the most recent tariff
				return feeWithBonus(for: AttorneyFeeTariffYear.latest.rawValue)
			}
		}
	}

	// MARK: - Tariff Year
	/// Attorney fee tariff years are independent of mediation `TariffYear`
	/// (see `AttorneyFeeTariffYear` — the default is the tariff in force today)
	static var availableYears: [Int] { AttorneyFeeTariffYear.allCases.map(\.rawValue) }

	// MARK: - Fee Types
	struct FeeType {
		static let monetaryAgreement = "monetary_agreement" // Monetary + Agreement
		static let nonMonetaryAgreement = "non_monetary_agreement" // Non-monetary + Agreement
		static let noAgreement = "no_agreement" // No agreement (all)
		static let noAgreementWithLawsuit = "no_agreement_with_lawsuit" // No agreement + Lawsuit (not applicable)
		static let allTypes = [monetaryAgreement, nonMonetaryAgreement, noAgreement, noAgreementWithLawsuit]
	}

	// MARK: - Calculation Brackets (2027)
	struct MonetaryBrackets2027 {
		/// Calculation brackets for monetary disputes (2027 tariff, Third Part)
		/// Each tuple: (bracketLimit, rate, cumulativeLimit)
		static let brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)] = [
			(800_000.0, 0.16, 800_000.0),           // First 800,000 TL at 16%
			(800_000.0, 0.15, 1_600_000.0),         // Next 800,000 TL at 15%
			(1_600_000.0, 0.14, 3_200_000.0),       // Next 1,600,000 TL at 14%
			(1_600_000.0, 0.13, 4_800_000.0),       // Next 1,600,000 TL at 13%
			(2_400_000.0, 0.11, 7_200_000.0),       // Next 2,400,000 TL at 11%
			(3_200_000.0, 0.08, 10_400_000.0),      // Next 3,200,000 TL at 8%
			(4_000_000.0, 0.05, 14_400_000.0),      // Next 4,000,000 TL at 5%
			(4_800_000.0, 0.03, 19_200_000.0),      // Next 4,800,000 TL at 3%
			(5_600_000.0, 0.02, 24_800_000.0),      // Next 5,600,000 TL at 2%
			(Double.infinity, 0.01, Double.infinity) // Above 24,800,000 TL at 1%
		]
		static let minimumFee: Double = 10_000.0 // Fixed fee for no agreement (Part 1, Ch. 1, row 6)
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
		static let minimumThreshold: Double = 62_500.0 // Art. 16/2-a threshold for fixed fee
		static let minimumFeeWithMultiplier: Double = 12_500.0 // 10,000 × 1.25 for agreements below threshold
	}

	// MARK: - Calculation Brackets (2026)
	struct MonetaryBrackets2026 {
		/// Calculation brackets for monetary disputes (2026 tariff, Article 16)
		/// Each tuple: (bracketLimit, rate, cumulativeLimit)
		static let brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)] = [
			(600_000.0, 0.16, 600_000.0),           // First 600,000 TL at 16%
			(600_000.0, 0.15, 1_200_000.0),         // Next 600,000 TL at 15%
			(1_200_000.0, 0.14, 2_400_000.0),       // Next 1,200,000 TL at 14%
			(1_200_000.0, 0.13, 3_600_000.0),       // Next 1,200,000 TL at 13%
			(1_800_000.0, 0.11, 5_400_000.0),       // Next 1,800,000 TL at 11%
			(2_400_000.0, 0.08, 7_800_000.0),       // Next 2,400,000 TL at 8%
			(3_000_000.0, 0.05, 10_800_000.0),      // Next 3,000,000 TL at 5%
			(3_600_000.0, 0.03, 14_400_000.0),      // Next 3,600,000 TL at 3%
			(4_200_000.0, 0.02, 18_600_000.0),      // Next 4,200,000 TL at 2%
			(Double.infinity, 0.01, Double.infinity) // Above 18,600,000 TL at 1%
		]
		static let minimumFee: Double = 8_000.0 // Fixed fee for no agreement
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
		static let minimumThreshold: Double = 50_000.0 // Minimum threshold for fixed fee
		static let minimumFeeWithMultiplier: Double = 10_000.0 // 8,000 × 1.25 for agreements below threshold
	}

	// MARK: - Calculation Brackets (2025)
	struct MonetaryBrackets2025 {
		/// Calculation brackets for monetary disputes (2025 tariff, Article 16)
		/// Each tuple: (bracketLimit, rate, cumulativeLimit)
		static let brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)] = [
			(400_000.0, 0.16, 400_000.0),           // First 400,000 TL at 16%
			(400_000.0, 0.15, 800_000.0),           // Next 400,000 TL at 15%
			(800_000.0, 0.14, 1_600_000.0),         // Next 800,000 TL at 14%
			(1_200_000.0, 0.11, 2_800_000.0),       // Next 1,200,000 TL at 11%
			(1_600_000.0, 0.08, 4_400_000.0),       // Next 1,600,000 TL at 8%
			(2_000_000.0, 0.05, 6_400_000.0),       // Next 2,000,000 TL at 5%
			(2_400_000.0, 0.03, 8_800_000.0),       // Next 2,400,000 TL at 3%
			(2_800_000.0, 0.02, 11_600_000.0),      // Next 2,800,000 TL at 2%
			(Double.infinity, 0.01, Double.infinity) // Above 11,600,000 TL at 1%
		]
		static let minimumFee: Double = 7_000.0 // Fixed fee for no agreement
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
		static let minimumThreshold: Double = 43_750.0 // Minimum threshold for fixed fee
		static let minimumFeeWithMultiplier: Double = 8_750.0 // 7,000 × 1.25 for agreements below threshold
	}

	// MARK: - Non-Monetary Fee (2027)
	struct NonMonetaryFee2027 {
		static let baseFee: Double = 10_000.0 // Fixed fee for non-monetary disputes
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
	}

	// MARK: - Non-Monetary Fee (2026)
	struct NonMonetaryFee2026 {
		static let baseFee: Double = 8_000.0 // Fixed fee for non-monetary disputes
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
	}

	// MARK: - Non-Monetary Fee (2025)
	struct NonMonetaryFee2025 {
		static let baseFee: Double = 7_000.0 // Fixed fee for non-monetary disputes
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
	}

	// MARK: - General Fee Values

	/// Returns the no-agreement fixed fee (Art. 16/2-c) for specific year
	static func minimumAttorneyFee(for year: Int) -> Double {
		switch year {
		case 2025: return MonetaryBrackets2025.minimumFee
		case 2026: return MonetaryBrackets2026.minimumFee
		case 2027: return MonetaryBrackets2027.minimumFee
		default: return minimumAttorneyFee(for: AttorneyFeeTariffYear.latest.rawValue)
		}
	}

	// MARK: - Currency Settings
	static let currencyCode = "TRY"
	static let currencySymbol = "₺"
	static let decimalPlaces = 2

	// MARK: - Validation
	static let minimumAmount: Double = 0.01
	static let maximumAmount: Double = 999_999_999.0

	// MARK: - Display Settings
	static let showCalculationBreakdown = true
	static let showTariffReference = true
}
