//
//  MediationFeeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI

// MARK: - Mediation Fee Result Sheet
/// Full screen sheet displaying mediation fee calculation result
@available(iOS 26.0, *)
struct MediationFeeResultSheet: View {

    let result: CalculationResult
    let theme: ThemeProtocol
    let isMonetary: Bool

    @Environment(\.dismiss) private var dismiss

    private var smmLegalPersonResultForFee: SMMPersonResult {
        let input = SMMCalculationInput(amount: result.amount, calculationType: .vatIncludedWithholdingIncluded)
        return SMMCalculator.calculateSMM(input: input).legalPersonResult
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {

                    // Main Fee Card
                    mainFeeCard

                    // Calculation Info Card
                    calculationInfoCard

                    // Calculation Method Card (only for agreement cases)
                    if result.input.agreementStatus == .agreed,
                       !result.mediationFee.calculationBreakdown.bracketSteps.isEmpty {
                        calculationMethodCard
                    }

                    // SMM Result Card (only for non-agreement cases)
                    if result.input.agreementStatus == .notAgreed {
                        smmResultCard
                    }
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.bottom, theme.spacingXXL)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                }
            }
        }
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Main Fee Card

    private var mainFeeCard: some View {
        VStack(spacing: theme.spacingM) {
            Text(LocalizationKeys.Result.mediationFee.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(LocalizationHelper.formatCurrency(result.amount))
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusXL)
                .fill(theme.surfaceElevated)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusXL)
                .stroke(theme.primary.opacity(0.2), lineWidth: 2)
        }
    }

    // MARK: - Calculation Info Card

    private var calculationInfoCard: some View {
        VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Text(LocalizationKeys.Result.calculationInfo.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            // Agreement Status - special text for non-monetary disputes
            if !isMonetary {
                detailRow(
                    label: LocalizationKeys.Result.disputeSubject.localized,
                    value: LocalizationKeys.Result.disputeSubjectNonMonetary.localized
                )
            } else {
                detailRow(
                    label: LocalizationKeys.Result.agreementStatus.localized,
                    value: result.input.agreementStatus == .agreed ? LocalizationKeys.AgreementStatus.agreed.localized : LocalizationKeys.AgreementStatus.notAgreed.localized
                )
            }

            Divider()
                .background(theme.outline.opacity(0.2))

            // Dispute Type
            detailRow(
                label: LocalizationKeys.Result.disputeType.localized,
                value: result.disputeType.displayName
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: result.input.tariffYear.displayName
            )

            // Party Count (only for non-agreement cases)
            if result.input.agreementStatus == .notAgreed {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.Result.partyCount.localized,
                    value: "\(result.input.partyCount)"
                )
            }

            // Amount (only for agreement cases with amount)
            if let amount = result.input.disputeAmount {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.Input.agreementAmount.localized,
                    value: LocalizationHelper.formatCurrency(amount)
                )
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Calculation Method Card

    private var calculationMethodCard: some View {
        let breakdown = result.mediationFee.calculationBreakdown

        return VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Text(LocalizationKeys.Result.calculationMethod.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            // Bracket Steps
            ForEach(Array(breakdown.bracketSteps.enumerated()), id: \.offset) { index, step in
                if index > 0 {
                    Divider()
                        .background(theme.outline.opacity(0.2))
                }

                bracketStepRow(step: step, index: index, isLast: step.bracketLimit == Double.infinity)
            }

            Divider()
                .background(theme.border)

            // Bracket Total
            if let bracketTotal = breakdown.bracketTotal {
                detailRow(
                    label: LocalizationKeys.Result.bracketTotal.localized,
                    value: LocalizationHelper.formatCurrency(bracketTotal)
                )
            }

            // Minimum Fee
            if let minimumFeeThreshold = breakdown.minimumFeeThreshold {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.Result.minimumFee.localized,
                    value: LocalizationHelper.formatCurrency(minimumFeeThreshold)
                )
            }

            Divider()
                .background(theme.border)

            // Result explanation
            HStack(spacing: theme.spacingXS) {
                Image(systemName: "info.circle.fill")
                    .font(theme.footnote)
                    .foregroundStyle(theme.primary)

                Text(breakdown.usedMinimumFee
                     ? LocalizationKeys.Result.minimumFeeApplied.localized
                     : LocalizationKeys.Result.bracketTotalApplied.localized)
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)

                Spacer()
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Bracket Step Row

    private func bracketStepRow(step: BracketBreakdownStep, index: Int, isLast: Bool) -> some View {
        let tierLabel: String = {
            if index == 0 {
                return "\(LocalizationKeys.Result.firstTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
            } else if isLast {
                return "\(LocalizationHelper.formatCurrency(step.bracketLowerBound)) \(LocalizationKeys.Result.aboveTier.localized)"
            } else {
                return "\(LocalizationKeys.Result.nextTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
            }
        }()

        return VStack(spacing: theme.spacingXS) {
            // Tier description
            HStack {
                Text(tierLabel)
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)

                Spacer()

                Text("× %\(LocalizationHelper.formatRate(step.rate))")
                    .font(theme.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)
            }

            // Calculated fee for this tier
            HStack {
                Spacer()

                Text(LocalizationHelper.formatCurrency(step.calculatedFee))
                    .font(theme.body)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textPrimary)
            }
        }
    }

    // MARK: - SMM Result Card

    private var smmResultCard: some View {
        VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Text(LocalizationKeys.Result.calculationResult.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            // SMM breakdown rows
            detailRow(
                label: LocalizationKeys.SMMResult.grossFee.localized,
                value: smmLegalPersonResultForFee.formattedBrutFee
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            detailRow(
                label: LocalizationKeys.SMMResult.withholding.localized,
                value: smmLegalPersonResultForFee.formattedStopaj
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            detailRow(
                label: LocalizationKeys.SMMResult.netFee.localized,
                value: smmLegalPersonResultForFee.formattedNetFee
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            detailRow(
                label: LocalizationKeys.SMMResult.vat.localized,
                value: smmLegalPersonResultForFee.formattedKdv
            )

            Divider()
                .background(theme.border)

            detailRow(
                label: LocalizationKeys.SMMResult.totalCollected.localized,
                value: smmLegalPersonResultForFee.formattedTahsilEdilecekTutar
            )
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Detail Row

    private func detailRow(label: String, value: String) -> some View {
        DetailRow(label: label, value: value)
    }
}
