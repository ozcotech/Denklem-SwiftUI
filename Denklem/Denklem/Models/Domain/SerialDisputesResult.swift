//
//  SerialDisputesResult.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import Foundation

// MARK: - Serial Disputes Input
/// Input model for serial disputes calculation
struct SerialDisputesInput: Equatable, Codable {
    /// Dispute type (commercial or non-commercial)
    let disputeType: SerialDisputesConstants.DisputeType
    /// Number of dispute files
    let fileCount: Int
    /// Tariff year (2025 or 2026)
    let tariffYear: Int

    // MARK: - Validation
    func validate() -> ValidationResult {
        // Validate file count minimum
        if fileCount < SerialDisputesConstants.Validation.minimumFileCount {
            return .failure(
                code: ValidationConstants.FileCount.validationErrorCode,
                message: LocalizationKeys.Validation.FileCount.min.localized
            )
        }

        // Validate file count maximum
        if fileCount > SerialDisputesConstants.Validation.maximumFileCount {
            return .failure(
                code: ValidationConstants.FileCount.validationErrorCode,
                message: LocalizationKeys.Validation.FileCount.max.localized
            )
        }

        // Validate tariff year
        if !SerialDisputesConstants.availableYears.contains(tariffYear) {
            return .failure(
                code: ValidationConstants.Year.invalidYearErrorCode,
                message: LocalizationKeys.Validation.invalidYear.localized
            )
        }

        return .success
    }
}

// MARK: - Serial Disputes Result
/// Result model for serial disputes calculation
struct SerialDisputesResult: Equatable, Codable {
    /// Total calculated fee (in Turkish Lira)
    let totalFee: Double
    /// Fee per file (in Turkish Lira)
    let feePerFile: Double
    /// Dispute type used for calculation
    let disputeType: SerialDisputesConstants.DisputeType
    /// Number of files used for calculation
    let fileCount: Int
    /// Tariff year used
    let tariffYear: Int

    /// Formatted total fee string (e.g., ₺37.500,00)
    var formattedTotalFee: String {
        return LocalizationHelper.formatCurrency(totalFee)
    }

    /// Formatted fee per file string (e.g., ₺7.500,00)
    var formattedFeePerFile: String {
        return LocalizationHelper.formatCurrency(feePerFile)
    }

    /// Calculation breakdown description
    var breakdownDescription: String {
        return "\(fileCount) x \(formattedFeePerFile) = \(formattedTotalFee)"
    }

    /// Legal reference text based on current locale
    var legalReference: String {
        let tariffName = LocalizationKeys.SerialDisputes.tariffName.localized
        let article = LocalizationKeys.SerialDisputes.legalArticle.localized
        return "\(tariffYear) \(tariffName) \(article)"
    }
}

// MARK: - Serial Disputes Result Builder
extension SerialDisputesResult {

    /// Create a result from input
    static func from(input: SerialDisputesInput) -> SerialDisputesResult {
        let tariff = SerialDisputesTariff(year: input.tariffYear)
        let feePerFile = tariff.getFeePerFile(for: input.disputeType)
        let totalFee = tariff.calculateTotalFee(
            fileCount: input.fileCount,
            disputeType: input.disputeType
        )

        return SerialDisputesResult(
            totalFee: totalFee,
            feePerFile: feePerFile,
            disputeType: input.disputeType,
            fileCount: input.fileCount,
            tariffYear: input.tariffYear
        )
    }
}
