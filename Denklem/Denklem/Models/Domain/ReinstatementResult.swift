//
//  ReinstatementResult.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import Foundation

// MARK: - Reinstatement Input
/// Input model for reinstatement (işe iade) mediation fee calculation
struct ReinstatementInput: Equatable {
    /// Agreement status (agreed or not agreed)
    let agreementStatus: AgreementStatus
    /// Tariff year for calculation
    let tariffYear: TariffYear
    /// Number of parties in the dispute
    let partyCount: Int

    // MARK: - Agreement Case Fields (İş Mahkemeleri Kanunu m.3/13-2)
    /// İşe başlatılmama tazminatı (non-reinstatement compensation) - required for agreement
    let nonReinstatementCompensation: Double?
    /// Boşta geçen süre ücreti (idle period wage) - required for agreement
    let idlePeriodWage: Double?
    /// Diğer haklar (other rights) - optional for agreement
    let otherRights: Double?

    // MARK: - Computed Properties

    /// Total agreement amount (sum of all three components)
    /// Only applicable when agreementStatus == .agreed
    var totalAgreementAmount: Double? {
        guard agreementStatus == .agreed,
              let compensation = nonReinstatementCompensation,
              let wage = idlePeriodWage else {
            return nil
        }
        return compensation + wage + (otherRights ?? 0)
    }

    // MARK: - Validation

    /// Validates the input based on agreement status
    /// - Returns: ValidationResult with success or failure details
    func validate() -> ValidationResult {
        // Validate tariff year
        guard ReinstatementConstants.isValidYear(tariffYear.rawValue) else {
            return .failure(
                code: ValidationConstants.Year.invalidYearErrorCode,
                message: LocalizationKeys.Validation.invalidYear.localized
            )
        }

        // Validate party count
        let partyValidation = ReinstatementConstants.validatePartyCount(partyCount)
        if case .failure = partyValidation {
            return partyValidation
        }

        // Agreement-specific validation
        if agreementStatus == .agreed {
            // Validate non-reinstatement compensation (required)
            guard let compensation = nonReinstatementCompensation else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: LocalizationKeys.Validation.requiredField.localized
                )
            }
            let compensationValidation = ReinstatementConstants.validateAmount(compensation)
            if case .failure = compensationValidation {
                return compensationValidation
            }

            // Validate idle period wage (required)
            guard let wage = idlePeriodWage else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: LocalizationKeys.Validation.requiredField.localized
                )
            }
            let wageValidation = ReinstatementConstants.validateAmount(wage)
            if case .failure = wageValidation {
                return wageValidation
            }

            // Validate other rights (optional, but validate if provided)
            if let other = otherRights, other > 0 {
                let otherValidation = ReinstatementConstants.validateAmount(other)
                if case .failure = otherValidation {
                    return otherValidation
                }
            }
        }

        return .success
    }

    // MARK: - Factory Methods

    /// Creates input for agreement case
    static func agreement(
        tariffYear: TariffYear,
        partyCount: Int,
        nonReinstatementCompensation: Double,
        idlePeriodWage: Double,
        otherRights: Double? = nil
    ) -> ReinstatementInput {
        return ReinstatementInput(
            agreementStatus: .agreed,
            tariffYear: tariffYear,
            partyCount: partyCount,
            nonReinstatementCompensation: nonReinstatementCompensation,
            idlePeriodWage: idlePeriodWage,
            otherRights: otherRights
        )
    }

    /// Creates input for no agreement case
    static func noAgreement(
        tariffYear: TariffYear,
        partyCount: Int
    ) -> ReinstatementInput {
        return ReinstatementInput(
            agreementStatus: .notAgreed,
            tariffYear: tariffYear,
            partyCount: partyCount,
            nonReinstatementCompensation: nil,
            idlePeriodWage: nil,
            otherRights: nil
        )
    }
}

// MARK: - Reinstatement Breakdown
/// Detailed breakdown of reinstatement fee calculation for agreement case
struct ReinstatementBreakdown: Equatable {
    /// İşe başlatılmama tazminatı
    let nonReinstatementCompensation: Double
    /// Boşta geçen süre ücreti
    let idlePeriodWage: Double
    /// Diğer haklar (optional)
    let otherRights: Double?
    /// Total of all components
    let totalAmount: Double
    /// Bracket fee calculated from total
    let bracketFee: Double
    /// Whether minimum fee was applied
    let isMinimumApplied: Bool

    /// Formatted non-reinstatement compensation
    var formattedCompensation: String {
        return LocalizationHelper.formatCurrency(nonReinstatementCompensation)
    }

    /// Formatted idle period wage
    var formattedIdleWage: String {
        return LocalizationHelper.formatCurrency(idlePeriodWage)
    }

    /// Formatted other rights (nil if not provided)
    var formattedOtherRights: String? {
        guard let other = otherRights else { return nil }
        return LocalizationHelper.formatCurrency(other)
    }

    /// Formatted total amount
    var formattedTotalAmount: String {
        return LocalizationHelper.formatCurrency(totalAmount)
    }
}

// MARK: - Reinstatement Result
/// Result model for reinstatement mediation fee calculation
struct ReinstatementResult: Equatable {
    /// Total calculated fee (in Turkish Lira)
    let totalFee: Double
    /// Agreement status used for calculation
    let agreementStatus: AgreementStatus
    /// Tariff year used for calculation
    let tariffYear: TariffYear
    /// Number of parties
    let partyCount: Int
    /// Detailed breakdown (only for agreement case)
    let breakdown: ReinstatementBreakdown?
    /// Fixed fee used (only for no agreement case)
    let fixedFeeUsed: Double?

    // MARK: - Formatted Properties

    /// Formatted total fee string (e.g., ₺9.600,00)
    var formattedTotalFee: String {
        return LocalizationHelper.formatCurrency(totalFee)
    }

    /// Formatted fixed fee (for no agreement case)
    var formattedFixedFee: String? {
        guard let fixedFee = fixedFeeUsed else { return nil }
        return LocalizationHelper.formatCurrency(fixedFee)
    }

    // MARK: - Legal References

    /// Legal reference based on agreement status
    var legalReference: String {
        return ReinstatementConstants.getLegalReference(isAgreed: agreementStatus == .agreed)
    }

    /// Tariff section reference
    var tariffSectionReference: String {
        return ReinstatementConstants.getTariffSectionReference()
    }

    /// Combined legal reference with tariff year
    var fullLegalReference: String {
        return "\(tariffYear.rawValue) \(tariffSectionReference) - \(legalReference)"
    }

    // MARK: - Calculation Description

    /// Description of how the fee was calculated
    var calculationDescription: String {
        if agreementStatus == .agreed, let breakdown = breakdown {
            var description = """
            \(LocalizationKeys.Reinstatement.nonReinstatementCompensation.localized): \(breakdown.formattedCompensation)
            \(LocalizationKeys.Reinstatement.idlePeriodWage.localized): \(breakdown.formattedIdleWage)
            """

            if let otherRightsFormatted = breakdown.formattedOtherRights {
                description += "\n\(LocalizationKeys.Reinstatement.otherRights.localized): \(otherRightsFormatted)"
            }

            description += "\n\(LocalizationKeys.Reinstatement.totalAmount.localized): \(breakdown.formattedTotalAmount)"

            if breakdown.isMinimumApplied {
                description += "\n(\(LocalizationKeys.Reinstatement.minimumFeeApplied.localized))"
            }

            return description
        } else if let fixedFee = formattedFixedFee {
            let multiplierText = "× 2"
            return "\(fixedFee) \(multiplierText) = \(formattedTotalFee)"
        }

        return formattedTotalFee
    }
}

// MARK: - Reinstatement Result Builder
extension ReinstatementResult {

    /// Creates result for agreement case with breakdown
    static func agreed(
        totalFee: Double,
        tariffYear: TariffYear,
        partyCount: Int,
        breakdown: ReinstatementBreakdown
    ) -> ReinstatementResult {
        return ReinstatementResult(
            totalFee: totalFee,
            agreementStatus: .agreed,
            tariffYear: tariffYear,
            partyCount: partyCount,
            breakdown: breakdown,
            fixedFeeUsed: nil
        )
    }

    /// Creates result for no agreement case
    static func notAgreed(
        totalFee: Double,
        tariffYear: TariffYear,
        partyCount: Int,
        fixedFeeUsed: Double
    ) -> ReinstatementResult {
        return ReinstatementResult(
            totalFee: totalFee,
            agreementStatus: .notAgreed,
            tariffYear: tariffYear,
            partyCount: partyCount,
            breakdown: nil,
            fixedFeeUsed: fixedFeeUsed
        )
    }
}
