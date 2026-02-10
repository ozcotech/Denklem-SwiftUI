//
//  TenancyCalculator.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import Foundation

// MARK: - Tenancy Calculator
/// Calculator for tenancy (eviction/determination) fee calculation
/// Legal basis:
/// - Attorney Fee: Attorney Fee Tariff Art. 9/1 (Third Part brackets)
/// - Mediation Fee: Mediation Fee Tariff Art. 7/5 (Second Part brackets)
struct TenancyCalculator {

    // MARK: - Attorney Fee Calculation (Article 9/1)

    /// Calculate attorney fee for tenancy disputes
    /// Uses AttorneyFeeConstants.MonetaryBrackets (Third Part) brackets
    /// - When both eviction and determination selected: SUM amounts, calculate ONCE
    /// - Parameter input: TenancyCalculationInput with feeMode = .attorneyFee
    /// - Returns: TenancyAttorneyFeeResult
    static func calculateAttorneyFee(input: TenancyCalculationInput) -> TenancyAttorneyFeeResult {
        let year = input.tariffYear.rawValue

        // Calculate total input amount (sum if both selected)
        var totalAmount: Double = 0
        if input.selectedTypes.contains(.eviction), let eviction = input.evictionAmount {
            totalAmount += eviction
        }
        if input.selectedTypes.contains(.determination), let determination = input.determinationAmount {
            totalAmount += determination
        }

        // Calculate fee using Third Part brackets (progressive bracket calculation)
        let calculatedFee = calculateThirdPartFee(amount: totalAmount, year: year)

        // Apply Sulh Hukuk Mahkemesi minimum (Art. 9 last sentence)
        // Tenancy cases are typically heard in Sulh Hukuk Mahkemesi
        let sulhMinimum = TenancyCalculationConstants.TenancyCourtType.civilPeace.minimumFee(for: year)
        let isMinimumApplied = calculatedFee < sulhMinimum
        let finalFee = max(calculatedFee, sulhMinimum)

        // Generate court minimum warnings
        let courtMinimumWarnings = TenancyCalculationConstants.TenancyCourtType.allCases.map { courtType in
            CourtMinimumWarning(
                courtType: courtType,
                minimumFee: courtType.minimumFee(for: year),
                warningMessage: courtType.warningMessage(for: year)
            )
        }

        return TenancyAttorneyFeeResult(
            fee: finalFee,
            originalCalculatedFee: isMinimumApplied ? calculatedFee : nil,
            isMinimumApplied: isMinimumApplied,
            totalInputAmount: totalAmount,
            evictionAmount: input.selectedTypes.contains(.eviction) ? input.evictionAmount : nil,
            determinationAmount: input.selectedTypes.contains(.determination) ? input.determinationAmount : nil,
            courtMinimumWarnings: courtMinimumWarnings,
            tariffYear: year
        )
    }

    // MARK: - Mediation Fee Calculation (Article 7/5)

    /// Calculate mediation fee for tenancy disputes
    /// Uses TariffProtocol.calculateBracketFee() (Second Part) brackets
    /// - Eviction: HALF of 1-year rent amount
    /// - Determination: FULL 1-year rent difference
    /// - When both selected: Calculate SEPARATELY, then SUM results
    /// - Parameter input: TenancyCalculationInput with feeMode = .mediationFee
    /// - Returns: TenancyMediationFeeResult
    static func calculateMediationFee(input: TenancyCalculationInput) -> TenancyMediationFeeResult {
        let tariff = input.tariffYear.getTariffProtocol()
        let year = input.tariffYear.rawValue

        var evictionFee: Double?
        var determinationFee: Double?
        var evictionInputAmount: Double?
        var evictionOriginalAmount: Double?
        var determinationInputAmount: Double?

        // Eviction: HALF of 1-year rent
        if input.selectedTypes.contains(.eviction), let evictionAmount = input.evictionAmount {
            let evictionBase = evictionAmount / 2.0
            evictionOriginalAmount = evictionAmount
            evictionInputAmount = evictionBase
            evictionFee = tariff.calculateBracketFee(for: evictionBase)
        }

        // Determination: FULL 1-year rent difference
        if input.selectedTypes.contains(.determination), let determinationAmount = input.determinationAmount {
            determinationInputAmount = determinationAmount
            determinationFee = tariff.calculateBracketFee(for: determinationAmount)
        }

        // Total: sum of individual fees
        let calculatedTotal = (evictionFee ?? 0) + (determinationFee ?? 0)

        // Apply minimum fee per Article 7/7
        let minimumFee = TenancyCalculationConstants.MediationMinimumFee.minimumFee(for: year)
        let isMinimumApplied = calculatedTotal < minimumFee
        let finalTotal = max(calculatedTotal, minimumFee)

        return TenancyMediationFeeResult(
            evictionFee: evictionFee,
            determinationFee: determinationFee,
            totalFee: finalTotal,
            originalCalculatedFee: isMinimumApplied ? calculatedTotal : nil,
            isMinimumApplied: isMinimumApplied,
            evictionInputAmount: evictionInputAmount,
            evictionOriginalAmount: evictionOriginalAmount,
            determinationInputAmount: determinationInputAmount,
            tariffYear: year
        )
    }

    // MARK: - Calculation with Validation

    /// Calculate with input validation
    /// - Parameter input: TenancyCalculationInput to validate and calculate
    /// - Returns: Result containing either attorney/mediation result or ValidationResult error
    static func calculateWithValidation(
        input: TenancyCalculationInput
    ) -> Result<Any, ValidationResult> {
        // Validate input first
        let validation = input.validate()

        guard validation.isValid else {
            return .failure(validation)
        }

        // Calculate based on fee mode
        switch input.feeMode {
        case .attorneyFee:
            let result = calculateAttorneyFee(input: input)
            return .success(result)
        case .mediationFee:
            let result = calculateMediationFee(input: input)
            return .success(result)
        }
    }

    // MARK: - Private Helper Methods

    /// Calculate fee using Third Part brackets (AttorneyFeeConstants)
    /// Progressive bracket calculation: each bracket has a limit (bracket SIZE) and rate
    /// - Parameters:
    ///   - amount: Total amount to calculate fee for
    ///   - year: Tariff year (2025 or 2026)
    /// - Returns: Calculated fee
    private static func calculateThirdPartFee(amount: Double, year: Int) -> Double {
        return BracketCalculator.calculateFee(amount: amount, brackets: getBrackets(for: year))
    }

    /// Returns brackets for specific year from AttorneyFeeConstants
    private static func getBrackets(for year: Int) -> [(limit: Double, rate: Double, cumulativeLimit: Double)] {
        switch year {
        case 2025:
            return AttorneyFeeConstants.MonetaryBrackets2025.brackets
        case 2026:
            return AttorneyFeeConstants.MonetaryBrackets2026.brackets
        default:
            return AttorneyFeeConstants.MonetaryBrackets2026.brackets
        }
    }
}

// MARK: - Convenience Methods
extension TenancyCalculator {

    /// Quick attorney fee calculation
    static func calculateAttorneyFee(
        tariffYear: TariffYear,
        evictionAmount: Double? = nil,
        determinationAmount: Double? = nil
    ) -> TenancyAttorneyFeeResult {
        var selectedTypes: Set<TenancyCalculationConstants.TenancyType> = []
        if evictionAmount != nil { selectedTypes.insert(.eviction) }
        if determinationAmount != nil { selectedTypes.insert(.determination) }

        let input = TenancyCalculationInput(
            feeMode: .attorneyFee,
            selectedTypes: selectedTypes,
            evictionAmount: evictionAmount,
            determinationAmount: determinationAmount,
            tariffYear: tariffYear
        )
        return calculateAttorneyFee(input: input)
    }

    /// Quick mediation fee calculation
    static func calculateMediationFee(
        tariffYear: TariffYear,
        evictionAmount: Double? = nil,
        determinationAmount: Double? = nil
    ) -> TenancyMediationFeeResult {
        var selectedTypes: Set<TenancyCalculationConstants.TenancyType> = []
        if evictionAmount != nil { selectedTypes.insert(.eviction) }
        if determinationAmount != nil { selectedTypes.insert(.determination) }

        let input = TenancyCalculationInput(
            feeMode: .mediationFee,
            selectedTypes: selectedTypes,
            evictionAmount: evictionAmount,
            determinationAmount: determinationAmount,
            tariffYear: tariffYear
        )
        return calculateMediationFee(input: input)
    }
}

// MARK: - Preview & Testing Support
#if DEBUG
extension TenancyCalculator {

    /// Sample results for preview
    static var sampleAttorneyFeeResults: [TenancyAttorneyFeeResult] {
        return [
            // Test 1: Eviction only, 2026, 350K → 56,000 TL
            calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 350_000),
            // Test 2: Eviction only, 2026, 1M → 156,000 TL
            calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 1_000_000),
            // Test 3: Determination only, 2026, 500K → 80,000 TL
            calculateAttorneyFee(tariffYear: .year2026, determinationAmount: 500_000),
            // Test 4: Both, 2026, 1M + 200K → 186,000 TL
            calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 1_000_000, determinationAmount: 200_000),
            // Test 5: Eviction only, 2025, 1M → 152,000 TL
            calculateAttorneyFee(tariffYear: .year2025, evictionAmount: 1_000_000)
        ]
    }

    /// Sample mediation results for preview
    static var sampleMediationFeeResults: [TenancyMediationFeeResult] {
        return [
            // Test 6: Eviction only, 2026, rent=600K → base=300K → 18,000 TL
            calculateMediationFee(tariffYear: .year2026, evictionAmount: 600_000),
            // Test 7: Determination only, 2026, diff=600K → 36,000 TL
            calculateMediationFee(tariffYear: .year2026, determinationAmount: 600_000),
            // Test 8: Both, 2026, rent=600K, diff=600K → 18K+36K=54,000 TL
            calculateMediationFee(tariffYear: .year2026, evictionAmount: 600_000, determinationAmount: 600_000),
            // Test 9: Both, 2025, rent=400K, diff=400K → 12K+23K=35,000 TL
            calculateMediationFee(tariffYear: .year2025, evictionAmount: 400_000, determinationAmount: 400_000)
        ]
    }

    /// Test calculation verification
    static func verifySampleCalculations() -> [(description: String, passed: Bool)] {
        var results: [(String, Bool)] = []

        // Attorney Fee Tests
        // Test 1: Eviction only, 2026, 350K → bracket=56,000 but Sulh min=30K, so 56,000 TL
        let atty1 = calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 350_000)
        results.append(("Attorney: Eviction 350K 2026 = 56,000", abs(atty1.fee - 56_000) < 1))

        // Test 2: Eviction only, 2026, 1M → 156,000 TL
        let atty2 = calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 1_000_000)
        results.append(("Attorney: Eviction 1M 2026 = 156,000", abs(atty2.fee - 156_000) < 1))

        // Test 3: Determination only, 2026, 500K → 80,000 TL
        let atty3 = calculateAttorneyFee(tariffYear: .year2026, determinationAmount: 500_000)
        results.append(("Attorney: Determination 500K 2026 = 80,000", abs(atty3.fee - 80_000) < 1))

        // Test 4: Both, 2026, 1M + 200K = 1.2M → 186,000 TL
        let atty4 = calculateAttorneyFee(tariffYear: .year2026, evictionAmount: 1_000_000, determinationAmount: 200_000)
        results.append(("Attorney: Both 1M+200K 2026 = 186,000", abs(atty4.fee - 186_000) < 1))

        // Test 5: Eviction only, 2025, 1M → 152,000 TL
        let atty5 = calculateAttorneyFee(tariffYear: .year2025, evictionAmount: 1_000_000)
        results.append(("Attorney: Eviction 1M 2025 = 152,000", abs(atty5.fee - 152_000) < 1))

        // Mediation Fee Tests
        // Test 6: Eviction only, 2026, rent=600K → base=300K → 18,000 TL
        let med6 = calculateMediationFee(tariffYear: .year2026, evictionAmount: 600_000)
        results.append(("Mediation: Eviction 600K 2026 = 18,000", abs(med6.totalFee - 18_000) < 1))

        // Test 7: Determination only, 2026, diff=600K → 36,000 TL
        let med7 = calculateMediationFee(tariffYear: .year2026, determinationAmount: 600_000)
        results.append(("Mediation: Determination 600K 2026 = 36,000", abs(med7.totalFee - 36_000) < 1))

        // Test 8: Both, 2026, rent=600K, diff=600K → 18K+36K=54,000 TL
        let med8 = calculateMediationFee(tariffYear: .year2026, evictionAmount: 600_000, determinationAmount: 600_000)
        results.append(("Mediation: Both 600K+600K 2026 = 54,000", abs(med8.totalFee - 54_000) < 1))

        // Test 9: Both, 2025, rent=400K, diff=400K → 12K+23K=35,000 TL
        let med9 = calculateMediationFee(tariffYear: .year2025, evictionAmount: 400_000, determinationAmount: 400_000)
        results.append(("Mediation: Both 400K+400K 2025 = 35,000", abs(med9.totalFee - 35_000) < 1))

        return results
    }
}
#endif
