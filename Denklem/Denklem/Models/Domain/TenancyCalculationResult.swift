//
//  TenancyCalculationResult.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import Foundation

// MARK: - Tenancy Calculation Input
/// Input model for tenancy (eviction/determination) fee calculation
struct TenancyCalculationInput: Equatable {
    /// Calculation mode (attorney fee or mediation fee)
    let feeMode: TenancyCalculationConstants.TenancyFeeMode
    /// Selected tenancy types (eviction, determination, or both)
    let selectedTypes: Set<TenancyCalculationConstants.TenancyType>
    /// 1-year rent amount for eviction (nil if not selected)
    let evictionAmount: Double?
    /// 1-year rent difference for determination (nil if not selected)
    let determinationAmount: Double?
    /// Tariff year
    let tariffYear: TariffYear

    // MARK: - Validation

    func validate() -> ValidationResult {
        // Validate year
        guard TenancyCalculationConstants.isValidYear(tariffYear.rawValue) else {
            return .failure(
                code: ValidationConstants.Year.invalidYearErrorCode,
                message: LocalizationKeys.Validation.invalidYear.localized
            )
        }

        // At least one type must be selected
        guard !selectedTypes.isEmpty else {
            return .failure(
                code: ValidationConstants.Amount.invalidInputErrorCode,
                message: LocalizationKeys.RentSpecial.selectAtLeastOne.localized
            )
        }

        // Validate eviction amount if selected
        if selectedTypes.contains(.eviction) {
            guard let amount = evictionAmount, amount >= TenancyCalculationConstants.Validation.minimumAmount else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: LocalizationKeys.Validation.invalidAmount.localized
                )
            }
            let amountValidation = TenancyCalculationConstants.validateAmount(amount)
            if case .failure = amountValidation {
                return amountValidation
            }
        }

        // Validate determination amount if selected
        if selectedTypes.contains(.determination) {
            guard let amount = determinationAmount, amount >= TenancyCalculationConstants.Validation.minimumAmount else {
                return .failure(
                    code: ValidationConstants.Amount.invalidInputErrorCode,
                    message: LocalizationKeys.Validation.invalidAmount.localized
                )
            }
            let amountValidation = TenancyCalculationConstants.validateAmount(amount)
            if case .failure = amountValidation {
                return amountValidation
            }
        }

        return .success
    }
}

// MARK: - Tenancy Attorney Fee Result
/// Result model for tenancy attorney fee calculation (Article 9/1)
/// Fee is enforced to be at least Sulh Hukuk Mahkemesi minimum (Art. 9 last sentence)
struct TenancyAttorneyFeeResult: Equatable {
    /// Final attorney fee (after minimum enforcement)
    let fee: Double
    /// Eviction attorney fee (after minimum enforcement, nil if not selected)
    let evictionFee: Double?
    /// Determination attorney fee (after minimum enforcement, nil if not selected)
    let determinationFee: Double?
    /// Original calculated fee before minimum enforcement (nil if no minimum applied)
    let originalCalculatedFee: Double?
    /// Whether court minimum (Sulh Hukuk) was applied
    let isMinimumApplied: Bool
    /// Total input amount used for calculation
    let totalInputAmount: Double
    /// Individual eviction amount (nil if not selected)
    let evictionAmount: Double?
    /// Individual determination amount (nil if not selected)
    let determinationAmount: Double?
    /// Court minimum warnings
    let courtMinimumWarnings: [CourtMinimumWarning]
    /// Tariff year used
    let tariffYear: Int

    /// Formatted fee string
    var formattedFee: String {
        return LocalizationHelper.formatCurrency(fee)
    }

    /// Formatted total input amount
    var formattedTotalInputAmount: String {
        return LocalizationHelper.formatCurrency(totalInputAmount)
    }

    /// Legal reference text
    var legalReference: String {
        return LocalizationKeys.RentSpecial.attorneyFeeLegalReference.localized
    }
}

// MARK: - Court Minimum Warning
struct CourtMinimumWarning: Equatable, Identifiable {
    let courtType: TenancyCalculationConstants.TenancyCourtType
    let minimumFee: Double
    let warningMessage: String

    var id: String { courtType.rawValue }
}

// MARK: - Tenancy Mediation Fee Result
/// Result model for tenancy mediation fee calculation (Article 7/5)
/// Total fee is enforced to be at least the minimum per Article 7/7
struct TenancyMediationFeeResult: Equatable {
    /// Eviction mediation fee (nil if not selected)
    let evictionFee: Double?
    /// Determination mediation fee (nil if not selected)
    let determinationFee: Double?
    /// Total mediation fee (after minimum enforcement)
    let totalFee: Double
    /// Original calculated total before minimum enforcement (nil if no minimum applied)
    let originalCalculatedFee: Double?
    /// Whether minimum fee (Art. 7/7) was applied
    let isMinimumApplied: Bool
    /// Eviction input amount used (half of 1 year rent, nil if not selected)
    let evictionInputAmount: Double?
    /// Original eviction amount before halving (nil if not selected)
    let evictionOriginalAmount: Double?
    /// Determination input amount (nil if not selected)
    let determinationInputAmount: Double?
    /// Tariff year used
    let tariffYear: Int

    /// Formatted total fee
    var formattedTotalFee: String {
        return LocalizationHelper.formatCurrency(totalFee)
    }

    /// Formatted eviction fee (nil if not applicable)
    var formattedEvictionFee: String? {
        guard let fee = evictionFee else { return nil }
        return LocalizationHelper.formatCurrency(fee)
    }

    /// Formatted determination fee (nil if not applicable)
    var formattedDeterminationFee: String? {
        guard let fee = determinationFee else { return nil }
        return LocalizationHelper.formatCurrency(fee)
    }

    /// Whether both types were calculated
    var hasBothTypes: Bool {
        return evictionFee != nil && determinationFee != nil
    }

    /// Legal reference text
    var legalReference: String {
        return LocalizationKeys.RentSpecial.mediationFeeLegalReference.localized
    }
}
