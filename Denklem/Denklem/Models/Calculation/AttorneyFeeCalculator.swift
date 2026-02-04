//
//  AttorneyFeeCalculator.swift
//  Denklem
//
//  Created by ozkan on 21.01.2026.
//

import Foundation

/// Calculation engine for attorney fee based on tariff year, dispute type, and agreement status
/// Supports 2025 and 2026 tariffs
/// Uses AttorneyFeeConstants, AttorneyFeeTariff2025/2026, and AttorneyFeeResult for all logic and validation
struct AttorneyFeeCalculator {

	/// Calculates attorney fee for given input
	/// - Parameter input: AttorneyFeeInput domain model
	/// - Returns: AttorneyFeeResult (success or failure)
	static func calculate(input: AttorneyFeeInput) -> AttorneyFeeResult {
		// Validate input first
		let validation = input.validate()
		guard case .success = validation else {
			let errorMessage: String
			switch validation {
			case .failure(_, let message): errorMessage = message
			default: errorMessage = LocalizationKeys.ErrorMessage.unknown.localized
			}
			return AttorneyFeeResult(
				fee: 0,
				calculationType: .monetaryNoAgreement,
				breakdown: AttorneyFeeBreakdown(baseAmount: nil, thirdPartFee: nil, bonusAmount: nil, courtType: input.courtType, isMinimumApplied: false, isMaximumApplied: false),
				warnings: [errorMessage],
				tariffYear: input.tariffYear
			)
		}

		let isMonetary = input.isMonetary
		let hasAgreement = input.hasAgreement
		let agreementAmount = input.agreementAmount
		let courtType = input.courtType
		let year = input.tariffYear
		var warnings: [String] = []

		// Get year-specific tariff values
		let tariff = getTariffValues(for: year)

		// Calculation branches
		if isMonetary {
			if hasAgreement {
				// Monetary + Agreement
				guard let amount = agreementAmount else {
					return AttorneyFeeResult(
						fee: 0,
						calculationType: .monetaryAgreement,
						breakdown: AttorneyFeeBreakdown(baseAmount: nil, thirdPartFee: nil, bonusAmount: nil, courtType: nil, isMinimumApplied: false, isMaximumApplied: false),
						warnings: [LocalizationKeys.Validation.invalidAgreementAmount.localized],
						tariffYear: year
					)
				}

				// 1. Lower limit check (below threshold - 50,000 TL for 2026, 43,750 TL for 2025)
				if amount < tariff.minimumThreshold {
					let minFee = tariff.minimumFeeWithMultiplier
					let isMaxApplied = minFee > amount
					let finalFee = isMaxApplied ? amount : minFee
					if isMaxApplied {
						warnings.append(LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized)
					}
					return AttorneyFeeResult(
						fee: finalFee,
						calculationType: .monetaryAgreement,
						breakdown: AttorneyFeeBreakdown(
							baseAmount: amount,
							thirdPartFee: nil,
							bonusAmount: nil,
							courtType: nil,
							isMinimumApplied: true,
							isMaximumApplied: isMaxApplied
						),
						warnings: warnings,
						tariffYear: year
					)
				}

				// 2. Progressive bracket calculation (third part)
				let thirdPartFee = calculateThirdPartFee(amount: amount, year: year)
				let bonusAmount = thirdPartFee * (tariff.agreementMultiplier - 1.0)
				var calculatedFee = thirdPartFee * tariff.agreementMultiplier
				let isMinimumApplied = false
				var isMaximumApplied = false

				// 3. Result cannot exceed agreement amount
				if calculatedFee > amount {
					calculatedFee = amount
					isMaximumApplied = true
					warnings.append(LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized)
				}

				return AttorneyFeeResult(
					fee: calculatedFee,
					calculationType: .monetaryAgreement,
					breakdown: AttorneyFeeBreakdown(
						baseAmount: amount,
						thirdPartFee: thirdPartFee,
						bonusAmount: bonusAmount,
						courtType: nil,
						isMinimumApplied: isMinimumApplied,
						isMaximumApplied: isMaximumApplied
					),
					warnings: warnings,
					tariffYear: year
				)
			} else {
				// Monetary + No Agreement
				let fee = tariff.minimumFee
				warnings.append(LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized)
				return AttorneyFeeResult(
					fee: fee,
					calculationType: .monetaryNoAgreement,
					breakdown: AttorneyFeeBreakdown(
						baseAmount: nil,
						thirdPartFee: nil,
						bonusAmount: nil,
						courtType: nil,
						isMinimumApplied: true,
						isMaximumApplied: false
					),
					warnings: warnings,
					tariffYear: year
				)
			}
		} else {
			if hasAgreement {
				// Non-monetary + Agreement
				guard let court = courtType else {
					return AttorneyFeeResult(
						fee: 0,
						calculationType: .nonMonetaryAgreement,
						breakdown: AttorneyFeeBreakdown(baseAmount: nil, thirdPartFee: nil, bonusAmount: nil, courtType: nil, isMinimumApplied: false, isMaximumApplied: false),
						warnings: [LocalizationKeys.Validation.missingCourtType.localized],
						tariffYear: year
					)
				}
				// Use year-specific court fee
				let baseFee = court.fee(for: year)
				let bonusAmount = baseFee * (tariff.nonMonetaryAgreementMultiplier - 1.0)
				let calculatedFee = baseFee * tariff.nonMonetaryAgreementMultiplier
				return AttorneyFeeResult(
					fee: calculatedFee,
					calculationType: .nonMonetaryAgreement,
					breakdown: AttorneyFeeBreakdown(
						baseAmount: baseFee,
						thirdPartFee: nil,
						bonusAmount: bonusAmount,
						courtType: court,
						isMinimumApplied: false,
						isMaximumApplied: false
					),
					warnings: warnings,
					tariffYear: year
				)
			} else {
				// Non-monetary + No Agreement
				let fee = tariff.nonMonetaryBaseFee
				warnings.append(LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized)
				return AttorneyFeeResult(
					fee: fee,
					calculationType: .nonMonetaryNoAgreement,
					breakdown: AttorneyFeeBreakdown(
						baseAmount: nil,
						thirdPartFee: nil,
						bonusAmount: nil,
						courtType: courtType,
						isMinimumApplied: true,
						isMaximumApplied: false
					),
					warnings: warnings,
					tariffYear: year
				)
			}
		}
	}

	// MARK: - Private Helper Methods

	/// Returns tariff values for specific year
	private static func getTariffValues(for year: Int) -> TariffValues {
		switch year {
		case 2025:
			return TariffValues(
				minimumFee: AttorneyFeeTariff2025.minimumFee,
				minimumThreshold: AttorneyFeeTariff2025.minimumThreshold,
				minimumFeeWithMultiplier: AttorneyFeeTariff2025.minimumFeeWithMultiplier,
				agreementMultiplier: AttorneyFeeTariff2025.agreementMultiplier,
				nonMonetaryBaseFee: AttorneyFeeTariff2025.nonMonetaryBaseFee,
				nonMonetaryAgreementMultiplier: AttorneyFeeTariff2025.nonMonetaryAgreementMultiplier
			)
		case 2026:
			return TariffValues(
				minimumFee: AttorneyFeeTariff2026.minimumFee,
				minimumThreshold: AttorneyFeeTariff2026.minimumThreshold,
				minimumFeeWithMultiplier: AttorneyFeeTariff2026.minimumFeeWithMultiplier,
				agreementMultiplier: AttorneyFeeTariff2026.agreementMultiplier,
				nonMonetaryBaseFee: AttorneyFeeTariff2026.nonMonetaryBaseFee,
				nonMonetaryAgreementMultiplier: AttorneyFeeTariff2026.nonMonetaryAgreementMultiplier
			)
		default:
			// Default to 2026
			return getTariffValues(for: 2026)
		}
	}

	/// Returns brackets for specific year
	private static func getBrackets(for year: Int) -> [(limit: Double, rate: Double, cumulativeLimit: Double)] {
		switch year {
		case 2025:
			return AttorneyFeeTariff2025.brackets
		case 2026:
			return AttorneyFeeTariff2026.brackets
		default:
			return AttorneyFeeTariff2026.brackets
		}
	}

	/// Calculates the third part fee (progressive brackets) for monetary disputes
	private static func calculateThirdPartFee(amount: Double, year: Int) -> Double {
		var remaining = amount
		var total: Double = 0
		let brackets = getBrackets(for: year)
		for bracket in brackets {
			let take = min(remaining, bracket.limit)
			total += take * bracket.rate
			remaining -= take
			if remaining <= 0 { break }
		}
		return total
	}
}

// MARK: - Tariff Values Helper Struct
/// Helper struct to hold tariff values for a specific year
private struct TariffValues {
	let minimumFee: Double
	let minimumThreshold: Double
	let minimumFeeWithMultiplier: Double
	let agreementMultiplier: Double
	let nonMonetaryBaseFee: Double
	let nonMonetaryAgreementMultiplier: Double
}
