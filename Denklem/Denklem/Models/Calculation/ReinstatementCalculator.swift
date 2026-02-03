//
//  ReinstatementCalculator.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import Foundation

// MARK: - Reinstatement Calculator
/// Calculator for reinstatement (işe iade) mediation fee calculation
/// Legal basis: Labor Courts Law Art. 3/13-2, Labor Law Art. 20-2, Art. 21/7
struct ReinstatementCalculator {

    // MARK: - Main Calculation Method

    /// Calculate reinstatement mediation fee
    /// - Parameter input: ReinstatementInput containing agreement status, amounts, and tariff year
    /// - Returns: ReinstatementResult with calculated fee and breakdown
    static func calculate(input: ReinstatementInput) -> ReinstatementResult {
        // Get tariff protocol for the specified year
        let tariff = input.tariffYear.getTariffProtocol()
        let disputeType = ReinstatementConstants.disputeType

        if input.agreementStatus == .agreed {
            return calculateAgreedCase(input: input, tariff: tariff, disputeType: disputeType)
        } else {
            return calculateNotAgreedCase(input: input, tariff: tariff, disputeType: disputeType)
        }
    }

    // MARK: - Agreement Case Calculation

    /// Calculate fee for agreement case (İş Mahkemeleri Kanunu m.3/13-2)
    /// Uses bracket calculation (Tariff Part 2)
    private static func calculateAgreedCase(
        input: ReinstatementInput,
        tariff: TariffProtocol,
        disputeType: String
    ) -> ReinstatementResult {
        // Get the total agreement amount
        let compensation = input.nonReinstatementCompensation ?? 0
        let idleWage = input.idlePeriodWage ?? 0
        let otherRights = input.otherRights
        let totalAmount = compensation + idleWage + (otherRights ?? 0)

        // Calculate bracket fee using existing tariff method
        let calculatedFee = tariff.calculateAgreementFee(
            disputeType: disputeType,
            amount: totalAmount,
            partyCount: input.partyCount
        )

        // Get minimum fee to check if it was applied
        let minimumFee = tariff.getMinimumFee(for: disputeType)
        let bracketFee = tariff.calculateBracketFee(for: totalAmount)
        let isMinimumApplied = bracketFee < minimumFee

        // Create breakdown
        let breakdown = ReinstatementBreakdown(
            nonReinstatementCompensation: compensation,
            idlePeriodWage: idleWage,
            otherRights: otherRights,
            totalAmount: totalAmount,
            bracketFee: bracketFee,
            isMinimumApplied: isMinimumApplied
        )

        return ReinstatementResult.agreed(
            totalFee: calculatedFee,
            tariffYear: input.tariffYear,
            partyCount: input.partyCount,
            breakdown: breakdown
        )
    }

    // MARK: - No Agreement Case Calculation

    /// Calculate fee for no agreement case (İş Kanunu m.20-2)
    /// Uses fixed fee × 2 (minimumHoursMultiplier)
    private static func calculateNotAgreedCase(
        input: ReinstatementInput,
        tariff: TariffProtocol,
        disputeType: String
    ) -> ReinstatementResult {
        // Calculate non-agreement fee using existing tariff method
        let calculatedFee = tariff.calculateNonAgreementFee(
            disputeType: disputeType,
            partyCount: input.partyCount
        )

        // Get the fixed fee used for calculation
        let fixedFee = tariff.getFixedFee(for: disputeType, partyCount: input.partyCount)

        return ReinstatementResult.notAgreed(
            totalFee: calculatedFee,
            tariffYear: input.tariffYear,
            partyCount: input.partyCount,
            fixedFeeUsed: fixedFee
        )
    }

    // MARK: - Calculation with Validation

    /// Calculate with input validation
    /// - Parameter input: ReinstatementInput to validate and calculate
    /// - Returns: Result containing either ReinstatementResult or ValidationResult error
    static func calculateWithValidation(
        input: ReinstatementInput
    ) -> Result<ReinstatementResult, ValidationResult> {
        // Validate input first
        let validation = input.validate()

        guard validation.isValid else {
            return .failure(validation)
        }

        // Calculate and return result
        let result = calculate(input: input)
        return .success(result)
    }
}

// MARK: - Convenience Methods
extension ReinstatementCalculator {

    /// Quick calculation for agreement case
    static func calculateAgreed(
        tariffYear: TariffYear,
        partyCount: Int,
        nonReinstatementCompensation: Double,
        idlePeriodWage: Double,
        otherRights: Double? = nil
    ) -> ReinstatementResult {
        let input = ReinstatementInput.agreement(
            tariffYear: tariffYear,
            partyCount: partyCount,
            nonReinstatementCompensation: nonReinstatementCompensation,
            idlePeriodWage: idlePeriodWage,
            otherRights: otherRights
        )
        return calculate(input: input)
    }

    /// Quick calculation for no agreement case
    static func calculateNotAgreed(
        tariffYear: TariffYear,
        partyCount: Int
    ) -> ReinstatementResult {
        let input = ReinstatementInput.noAgreement(
            tariffYear: tariffYear,
            partyCount: partyCount
        )
        return calculate(input: input)
    }
}

// MARK: - Preview & Testing Support
#if DEBUG
extension ReinstatementCalculator {

    /// Sample results for preview
    static var sampleResults: [ReinstatementResult] {
        return [
            // 2026 Agreement - Basic case
            calculateAgreed(
                tariffYear: .year2026,
                partyCount: 2,
                nonReinstatementCompensation: 100_000,
                idlePeriodWage: 50_000,
                otherRights: 10_000
            ),
            // 2026 Agreement - Without other rights
            calculateAgreed(
                tariffYear: .year2026,
                partyCount: 2,
                nonReinstatementCompensation: 80_000,
                idlePeriodWage: 40_000
            ),
            // 2026 No Agreement
            calculateNotAgreed(
                tariffYear: .year2026,
                partyCount: 2
            ),
            // 2025 Agreement
            calculateAgreed(
                tariffYear: .year2025,
                partyCount: 2,
                nonReinstatementCompensation: 100_000,
                idlePeriodWage: 50_000,
                otherRights: 10_000
            ),
            // 2025 No Agreement
            calculateNotAgreed(
                tariffYear: .year2025,
                partyCount: 2
            )
        ]
    }

    /// Test calculation verification
    static func verifySampleCalculations() -> [(description: String, passed: Bool)] {
        var results: [(String, Bool)] = []

        // Test 1: 2026 Agreement with 160,000 TL total
        let test1 = calculateAgreed(
            tariffYear: .year2026,
            partyCount: 2,
            nonReinstatementCompensation: 100_000,
            idlePeriodWage: 50_000,
            otherRights: 10_000
        )
        // 160,000 TL × 6% = 9,600 TL (above minimum 9,000 TL)
        let expected1 = 9_600.0
        results.append(("2026 Agreement 160K TL", abs(test1.totalFee - expected1) < 1))

        // Test 2: 2026 No Agreement with 2 parties
        let test2 = calculateNotAgreed(
            tariffYear: .year2026,
            partyCount: 2
        )
        // Fixed fee 2,260 TL × 2 = 4,520 TL
        let expected2 = 4_520.0
        results.append(("2026 No Agreement 2 parties", abs(test2.totalFee - expected2) < 1))

        // Test 3: 2025 No Agreement with 2 parties
        let test3 = calculateNotAgreed(
            tariffYear: .year2025,
            partyCount: 2
        )
        // Fixed fee 1,600 TL × 2 = 3,200 TL
        let expected3 = 3_200.0
        results.append(("2025 No Agreement 2 parties", abs(test3.totalFee - expected3) < 1))

        return results
    }
}
#endif
