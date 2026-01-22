//
//  AttorneyFeeCalculator.swift
//  Denklem
//
//  Created by ozkan on 21.01.2026.
//

import Foundation

/// Calculation engine for attorney fee based on 2026 tariff, dispute type, and agreement status
/// Uses AttorneyFeeConstants, AttorneyFeeTariff2026, and AttorneyFeeResult for all logic and validation
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

				// 1. Lower limit check (below 50,000 TL)
				if amount < AttorneyFeeTariff2026.minimumThreshold {
					let minFee = AttorneyFeeTariff2026.minimumFeeWithMultiplier
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
				let thirdPartFee = calculateThirdPartFee(amount: amount)
				let bonusAmount = thirdPartFee * (AttorneyFeeTariff2026.agreementMultiplier - 1.0)
				var calculatedFee = thirdPartFee * AttorneyFeeTariff2026.agreementMultiplier
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
				let fee = AttorneyFeeTariff2026.minimumFee
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
				let baseFee = court.fee
				let bonusAmount = baseFee * (AttorneyFeeTariff2026.nonMonetaryAgreementMultiplier - 1.0)
				let calculatedFee = baseFee * AttorneyFeeTariff2026.nonMonetaryAgreementMultiplier
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
				let fee = AttorneyFeeTariff2026.nonMonetaryBaseFee
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

	/// Calculates the third part fee (progressive brackets) for monetary disputes
	private static func calculateThirdPartFee(amount: Double) -> Double {
		var remaining = amount
		var total: Double = 0
		for bracket in AttorneyFeeTariff2026.brackets {
			let take = min(remaining, bracket.limit)
			total += take * bracket.rate
			remaining -= take
			if remaining <= 0 { break }
		}
		return total
	}
}
