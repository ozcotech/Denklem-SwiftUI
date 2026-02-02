//
//  SerialDisputesCalculator.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import Foundation

// MARK: - Serial Disputes Calculator
/// Calculator for serial disputes mediation fee (Tariff Article 7/4)
struct SerialDisputesCalculator {

    // MARK: - Main Calculation Method

    /// Calculate serial disputes fee
    /// - Parameter input: SerialDisputesInput containing dispute type, file count, and tariff year
    /// - Returns: SerialDisputesResult with calculated fees
    static func calculate(input: SerialDisputesInput) -> SerialDisputesResult {
        // Get tariff for the specified year
        let tariff = SerialDisputesTariff(year: input.tariffYear)

        // Get fee per file based on dispute type
        let feePerFile = tariff.getFeePerFile(for: input.disputeType)

        // Calculate total fee: fileCount × feePerFile
        let totalFee = Double(input.fileCount) * feePerFile

        return SerialDisputesResult(
            totalFee: totalFee,
            feePerFile: feePerFile,
            disputeType: input.disputeType,
            fileCount: input.fileCount,
            tariffYear: input.tariffYear
        )
    }

    /// Calculate with validation
    /// - Parameter input: SerialDisputesInput to validate and calculate
    /// - Returns: Result containing either SerialDisputesResult or ValidationResult error
    static func calculateWithValidation(
        input: SerialDisputesInput
    ) -> Result<SerialDisputesResult, ValidationResult> {
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
extension SerialDisputesCalculator {

    /// Quick calculation without creating input object
    static func calculate(
        disputeType: SerialDisputesConstants.DisputeType,
        fileCount: Int,
        tariffYear: Int
    ) -> SerialDisputesResult {
        let input = SerialDisputesInput(
            disputeType: disputeType,
            fileCount: fileCount,
            tariffYear: tariffYear
        )
        return calculate(input: input)
    }

    /// Calculate using TariffYear enum
    static func calculate(
        disputeType: SerialDisputesConstants.DisputeType,
        fileCount: Int,
        tariffYear: TariffYear
    ) -> SerialDisputesResult {
        return calculate(
            disputeType: disputeType,
            fileCount: fileCount,
            tariffYear: tariffYear.rawValue
        )
    }
}

// MARK: - Preview & Testing Support
#if DEBUG
extension SerialDisputesCalculator {

    /// Sample calculations for preview
    static var sampleResults: [SerialDisputesResult] {
        return [
            // 2026 Commercial - 5 files
            calculate(disputeType: .commercial, fileCount: 5, tariffYear: 2026),
            // 2026 Non-Commercial - 5 files
            calculate(disputeType: .nonCommercial, fileCount: 5, tariffYear: 2026),
            // 2025 Commercial - 10 files
            calculate(disputeType: .commercial, fileCount: 10, tariffYear: 2025),
            // 2025 Non-Commercial - 30 files
            calculate(disputeType: .nonCommercial, fileCount: 30, tariffYear: 2025)
        ]
    }
}
#endif
