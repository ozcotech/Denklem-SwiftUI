//
//  AttorneyFeeConstants.swift
//  Denklem
//
//  Created by ozkan on 21.01.2026.
//

import Foundation

// MARK: - Attorney Fee Constants
/// Constants for attorney fee calculation (2026 tariff, Article 16)
struct AttorneyFeeConstants {
		// MARK: - Court Type Enum (for non-monetary disputes)
		enum CourtType: String, CaseIterable, Identifiable, Codable, Equatable {
			case civilPeace = "civil_peace"           // Sulh Hukuk
			case firstInstance = "first_instance"     // Asliye Mahkemeleri
			case consumer = "consumer"                // Tüketici Mahkemesi
			case intellectualProperty = "intellectual_property" // Fikri ve Sınai Haklar

			var id: String { rawValue }

			/// Display name (for UI, localization key can be used here)
			var displayName: String {
				switch self {
				case .civilPeace: return "Sulh Hukuk Mahkemesi"
				case .firstInstance: return "Asliye Mahkemesi"
				case .consumer: return "Tüketici Mahkemesi"
				case .intellectualProperty: return "Fikri ve Sınai Haklar Mahkemesi"
				}
			}

			/// Base fee for this court type (2026 tariff)
			var fee: Double {
				switch self {
				case .civilPeace: return 30_000.0
				case .firstInstance: return 45_000.0
				case .consumer: return 22_500.0
				case .intellectualProperty: return 55_000.0
				}
			}

			/// Fee with 1/4 bonus (for agreement)
			var feeWithBonus: Double {
				switch self {
				case .civilPeace: return 37_500.0
				case .firstInstance: return 56_250.0
				case .consumer: return 28_125.0
				case .intellectualProperty: return 68_750.0
				}
			}
		}
    
	// MARK: - Tariff Year
	static let availableYears = [2026] // Extendable for future years
	static let currentYear = 2026
	static let defaultYear = 2026

	// MARK: - Fee Types
	struct FeeType {
		static let monetaryAgreement = "monetary_agreement" // Monetary + Agreement
		static let nonMonetaryAgreement = "non_monetary_agreement" // Non-monetary + Agreement
		static let noAgreement = "no_agreement" // No agreement (all)
		static let noAgreementWithLawsuit = "no_agreement_with_lawsuit" // No agreement + Lawsuit (not applicable)
		static let allTypes = [monetaryAgreement, nonMonetaryAgreement, noAgreement, noAgreementWithLawsuit]
	}

	// MARK: - Calculation Brackets (2026)
	struct MonetaryBrackets {
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

	// MARK: - Non-Monetary Fee
	struct NonMonetaryFee {
		static let baseFee: Double = 8_000.0 // Fixed fee for non-monetary disputes
		static let agreementMultiplier: Double = 1.25 // Multiplier for agreement cases
	}

	// MARK: - General Fee Values
	static let minimumAttorneyFee: Double = 8_000.0 // Minimum attorney fee for all no agreement cases

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
