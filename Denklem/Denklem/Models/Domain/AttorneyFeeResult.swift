//
//  AttorneyFeeResult.swift
//  Denklem
//
//  Created by ozkan on 21.01.2026.
//

import Foundation

// MARK: - Attorney Fee Input
/// Input model for attorney fee calculation
struct AttorneyFeeInput: Equatable, Codable {
	/// Whether the dispute is monetary (true) or non-monetary (false)
	let isMonetary: Bool
	/// Whether there is an agreement (true) or not (false)
	let hasAgreement: Bool
	/// Agreement amount (for monetary disputes, optional)
	let agreementAmount: Double?
	/// Selected court type (for non-monetary disputes, optional)
let courtType: AttorneyFeeConstants.CourtType?
	/// Tariff year (default: 2026)
	let tariffYear: Int

	// MARK: - Validation
	func validate() -> ValidationResult {
		// Validate monetary amount if required
		if isMonetary && hasAgreement {
			guard let amount = agreementAmount, amount >= AttorneyFeeConstants.minimumAmount else {
				return .failure(code: 1, message: LocalizationKeys.Validation.invalidAgreementAmount.localized)
			}
		}
		// Validate court type if required
		if !isMonetary && hasAgreement {
			guard courtType != nil else {
				return .failure(code: 2, message: LocalizationKeys.Validation.missingCourtType.localized)
			}
		}
		return .success
	}
}

// MARK: - Attorney Fee Result
/// Result model for attorney fee calculation
struct AttorneyFeeResult: Equatable, Codable {
	/// Calculated fee amount (in Turkish Lira)
	let fee: Double
	/// Calculation type (monetary_agreement, non_monetary_no_agreement, etc.)
	let calculationType: AttorneyFeeCalculationType
	/// Detailed breakdown of calculation
	let breakdown: AttorneyFeeBreakdown
	/// Warnings or info messages (e.g., fee exceeds claim)
	let warnings: [String]
	/// Tariff year used
	let tariffYear: Int

	/// Legal reference text with dynamic tariff year
	var legalReference: String {
		let format = LocalizationKeys.AttorneyFee.legalReferenceFormat.localized
		return String(format: format, tariffYear)
	}
}

// MARK: - Attorney Fee Breakdown
/// Detailed breakdown of attorney fee calculation
struct AttorneyFeeBreakdown: Equatable, Codable {
	/// Base amount used for calculation (e.g., agreement amount or court fee)
	let baseAmount: Double?
	/// Calculated third part fee (before bonus, for monetary agreement)
	let thirdPartFee: Double?
	/// Bonus amount (1/4 extra, if applied)
	let bonusAmount: Double?
	/// Selected court type (for non-monetary agreement)
let courtType: AttorneyFeeConstants.CourtType?
	/// Whether minimum fee rule was applied
	let isMinimumApplied: Bool
	/// Whether maximum (claim limit) rule was applied
	let isMaximumApplied: Bool
}

// MARK: - Attorney Fee Calculation Type
/// Calculation type for attorney fee
enum AttorneyFeeCalculationType: String, Codable, CaseIterable {
	case monetaryAgreement = "monetary_agreement"
	case monetaryNoAgreement = "monetary_no_agreement"
	case nonMonetaryAgreement = "non_monetary_agreement"
	case nonMonetaryNoAgreement = "non_monetary_no_agreement"
}
