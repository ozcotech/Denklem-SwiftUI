//
//  AttorneyFeeTariff2025.swift
//  Denklem
//
//  Created by ozkan on 04.02.2026.
//

import Foundation

/// Data provider for 2025 Attorney Fee Tariff (Article 16)
/// All values are sourced from AttorneyFeeConstants
struct AttorneyFeeTariff2025 {
	// MARK: - Year
	static let year: Int = 2025

	// MARK: - Brackets (Progressive Calculation)
	/// Returns the progressive brackets for monetary disputes (amount, rate, cumulativeLimit)
	static var brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)] {
		AttorneyFeeConstants.MonetaryBrackets2025.brackets
	}

	// MARK: - Minimums & Thresholds
	static var minimumFee: Double { AttorneyFeeConstants.MonetaryBrackets2025.minimumFee }
	static var minimumThreshold: Double { AttorneyFeeConstants.MonetaryBrackets2025.minimumThreshold }
	static var minimumFeeWithMultiplier: Double { AttorneyFeeConstants.MonetaryBrackets2025.minimumFeeWithMultiplier }
	static var agreementMultiplier: Double { AttorneyFeeConstants.MonetaryBrackets2025.agreementMultiplier }

	// MARK: - Non-Monetary Fee
	static var nonMonetaryBaseFee: Double { AttorneyFeeConstants.NonMonetaryFee2025.baseFee }
	static var nonMonetaryAgreementMultiplier: Double { AttorneyFeeConstants.NonMonetaryFee2025.agreementMultiplier }

	// MARK: - Court Fees (for non-monetary disputes)
	struct CourtFees {
		static var civilPeace: Double { 18_000.0 }
		static var civilPeaceWithBonus: Double { 22_500.0 }
		static var firstInstance: Double { 30_000.0 }
		static var firstInstanceWithBonus: Double { 37_500.0 }
		static var consumer: Double { 15_000.0 }
		static var consumerWithBonus: Double { 18_750.0 }
		static var intellectualProperty: Double { 40_000.0 }
		static var intellectualPropertyWithBonus: Double { 50_000.0 }
	}

	// MARK: - Fixed Fee for No Agreement
	static var noAgreementFee: Double { AttorneyFeeConstants.MonetaryBrackets2025.minimumFee }

	// MARK: - Currency
	static var currencyCode: String { AttorneyFeeConstants.currencyCode }
	static var currencySymbol: String { AttorneyFeeConstants.currencySymbol }
	static var decimalPlaces: Int { AttorneyFeeConstants.decimalPlaces }

	// MARK: - Utility: All Data as Dictionary (for debugging, export, etc.)
	static func getTariffSummary() -> [String: Any] {
		return [
			"year": year,
			"brackets": brackets.map { ["limit": $0.limit, "rate": $0.rate, "cumulativeLimit": $0.cumulativeLimit] },
			"minimumFee": minimumFee,
			"minimumThreshold": minimumThreshold,
			"minimumFeeWithMultiplier": minimumFeeWithMultiplier,
			"agreementMultiplier": agreementMultiplier,
			"nonMonetaryBaseFee": nonMonetaryBaseFee,
			"nonMonetaryAgreementMultiplier": nonMonetaryAgreementMultiplier,
			"courtFees": [
				"civilPeace": CourtFees.civilPeace,
				"civilPeaceWithBonus": CourtFees.civilPeaceWithBonus,
				"firstInstance": CourtFees.firstInstance,
				"firstInstanceWithBonus": CourtFees.firstInstanceWithBonus,
				"consumer": CourtFees.consumer,
				"consumerWithBonus": CourtFees.consumerWithBonus,
				"intellectualProperty": CourtFees.intellectualProperty,
				"intellectualPropertyWithBonus": CourtFees.intellectualPropertyWithBonus
			],
			"noAgreementFee": noAgreementFee,
			"currencyCode": currencyCode,
			"currencySymbol": currencySymbol,
			"decimalPlaces": decimalPlaces
		]
	}
}
