//
//  TariffCalculator.swift
//  Denklem
//
//  Created by ozkan on 22.07.2025.
//

import Foundation

/// Calculation engine for mediation fee based on tariff year, dispute type, and agreement status
/// Uses TariffConstants, DisputeConstants, and ValidationConstants for all logic and validation
struct TariffCalculator {
    
    /// Calculates mediation fee for given input
    /// - Parameter input: CalculationInput domain model
    /// - Returns: CalculationResult (success or failure)
    static func calculateFee(input: CalculationInput) -> CalculationResult {
        // Validate input first
        let validation = input.validate()
        guard validation.isValid else {
            return CalculationResult.failure(input: input, error: validation.errorMessage ?? "Invalid input")
        }
        
        // Get tariff year
        let year = input.tariffYear.rawValue
        let tariff: TariffProtocol
        switch year {
        case 2025:
            tariff = Tariff2025.create()
        case 2026:
            tariff = Tariff2026.create()
        default:
            return CalculationResult.failure(input: input, error: "Unsupported tariff year: \(year)")
        }
        
        // CalculationType
        let calculationType = input.calculationType
        let disputeTypeKey = input.disputeType.rawValue
        let agreementStatus = input.agreementStatus
        let partyCount = input.partyCount
        let disputeAmount = input.disputeAmount
        
        // Calculation logic
        var fee: Double = 0.0
        var breakdownSteps: [String] = []
        var usedMinimumFee = false
        var usedBracketCalculation = false
        var baseFee: Double = 0.0
        
        switch calculationType {
        case .monetary:
            if agreementStatus == .agreed {
                // Agreement: Bracket calculation with minimum fee check
                guard let amount = disputeAmount else {
                    return CalculationResult.failure(input: input, error: NSLocalizedString(LocalizationKeys.Validation.requiredField, comment: ""))
                }
                fee = tariff.calculateAgreementFee(disputeType: disputeTypeKey, amount: amount, partyCount: partyCount)
                // calculateAgreementFee already handles bracket vs minimum fee comparison
                usedMinimumFee = false // TODO: Get this info from tariff if needed
                usedBracketCalculation = false // TODO: Get this info from tariff if needed
                baseFee = fee
                breakdownSteps.append("Agreement case: Fee = \(fee)")
            } else {
                // No agreement: Fixed fee calculation
                fee = tariff.calculateNonAgreementFee(disputeType: disputeTypeKey, partyCount: partyCount)
                usedMinimumFee = false
                usedBracketCalculation = false
                baseFee = fee
                breakdownSteps.append("No agreement case: Fee = \(fee)")
            }
        case .nonMonetary:
            // Non-monetary: Fixed fee calculation
            fee = tariff.calculateNonMonetaryFee(disputeType: disputeTypeKey, partyCount: partyCount)
            usedMinimumFee = false
            usedBracketCalculation = false
            baseFee = fee
            breakdownSteps.append("Non-monetary case: Fee = \(fee)")
        case .timeCalculation:
            // Not implemented in this version
            return CalculationResult.failure(input: input, error: "Time calculation not implemented yet.")
        case .smmCalculation:
            // Not implemented in this version
            return CalculationResult.failure(input: input, error: "SMM calculation not implemented yet.")
        }
        
        // Build calculation breakdown
        let breakdown = CalculationBreakdown(
            steps: breakdownSteps,
            finalAmount: fee,
            details: [:],
            usedMinimumFee: usedMinimumFee,
            usedBracketSystem: usedBracketCalculation,
            hourlyRate: nil,
            fixedFee: nil,
            minimumFeeThreshold: nil
        )
        
        // Build MediationFee
        let mediationFee = MediationFee(
            amount: fee,
            disputeType: input.disputeType,
            tariffYear: input.tariffYear,
            calculationType: calculationType,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            disputeAmount: disputeAmount,
            calculationBreakdown: breakdown,
            usedMinimumFee: usedMinimumFee,
            usedBracketCalculation: usedBracketCalculation,
            baseFee: baseFee,
            appliedRate: nil
        )
        
        return CalculationResult.success(mediationFee: mediationFee, input: input)
    }
}
