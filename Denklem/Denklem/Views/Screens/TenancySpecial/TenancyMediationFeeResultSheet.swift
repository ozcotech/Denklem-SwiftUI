//
//  TenancyMediationFeeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import SwiftUI

// MARK: - Tenancy Mediation Fee Result Sheet
/// Bottom sheet displaying tenancy mediation fee calculation result
/// If both types: shows eviction fee, determination fee, and total
/// If single type: shows just the fee
/// Eviction note: user entered full rent, app used half for calculation
@available(iOS 26.0, *)
struct TenancyMediationFeeResultSheet: View {

    // MARK: - Properties

    let result: TenancyMediationFeeResult

    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localeManager = LocaleManager.shared

    // MARK: - Body

    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {

                    // Main Fee Card
                    mainFeeCard

                    // Fee Breakdown Card (if both types)
                    if result.hasBothTypes {
                        feeBreakdownCard
                    }

                    // Calculation Info Card
                    calculationInfoCard

                    // Legal Reference Card
                    legalReferenceCard
                }
                .padding(.horizontal, theme.spacingL)
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
            Text(result.hasBothTypes
                 ? LocalizationKeys.RentSpecial.totalMediationFee.localized
                 : LocalizationKeys.Result.mediationFee.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(result.formattedTotalFee)
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

    // MARK: - Fee Breakdown Card

    private var feeBreakdownCard: some View {
        VStack(spacing: theme.spacingM) {
            // Eviction Fee
            if let formattedEvictionFee = result.formattedEvictionFee {
                detailRow(
                    label: LocalizationKeys.RentSpecial.evictionMediationFee.localized,
                    value: formattedEvictionFee
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Determination Fee
            if let formattedDeterminationFee = result.formattedDeterminationFee {
                detailRow(
                    label: LocalizationKeys.RentSpecial.determinationMediationFee.localized,
                    value: formattedDeterminationFee
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

            // Eviction info (if selected)
            if let evictionOriginalAmount = result.evictionOriginalAmount,
               let evictionInputAmount = result.evictionInputAmount {
                // Original amount entered by user
                detailRow(
                    label: LocalizationKeys.RentSpecial.evictionOriginalAmount.localized,
                    value: LocalizationHelper.formatCurrency(evictionOriginalAmount)
                )

                Divider()
                    .background(theme.outline.opacity(0.2))

                // Calculation base (half)
                detailRow(
                    label: LocalizationKeys.RentSpecial.evictionCalculationBase.localized,
                    value: LocalizationHelper.formatCurrency(evictionInputAmount)
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Determination info (if selected)
            if let determinationInputAmount = result.determinationInputAmount {
                detailRow(
                    label: LocalizationKeys.RentSpecial.determination.localized,
                    value: LocalizationHelper.formatCurrency(determinationInputAmount)
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: "\(result.tariffYear)"
            )

            // Minimum Fee Applied indicator
            if result.isMinimumApplied {
                Divider()
                    .background(theme.outline.opacity(0.2))

                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(theme.footnote)
                        .foregroundStyle(theme.primary)

                    Text(LocalizationKeys.RentSpecial.mediationMinimumApplied.localized)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)

                    Spacer()
                }
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

    // MARK: - Legal Reference Card

    private var legalReferenceCard: some View {
        VStack(spacing: theme.spacingS) {
            HStack(spacing: theme.spacingXS) {
                Image(systemName: "book.closed.fill")
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)

                Text(result.legalReference)
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingM)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.surfaceElevated.opacity(0.5))
        }
    }

    // MARK: - Detail Row

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)

            Spacer()

            Text(value)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct TenancyMediationFeeResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Both types selected - no minimum applied
            TenancyMediationFeeResultSheet(result: TenancyMediationFeeResult(
                evictionFee: 18_000,
                determinationFee: 36_000,
                totalFee: 54_000,
                originalCalculatedFee: nil,
                isMinimumApplied: false,
                evictionInputAmount: 300_000,
                evictionOriginalAmount: 600_000,
                determinationInputAmount: 600_000,
                tariffYear: 2026
            ))
            .injectTheme(LightTheme())
            .previewDisplayName("Both Types - Light")

            // Eviction only - minimum applied (small amount → 9,000 TL)
            TenancyMediationFeeResultSheet(result: TenancyMediationFeeResult(
                evictionFee: 600,
                determinationFee: nil,
                totalFee: 9_000,
                originalCalculatedFee: 600,
                isMinimumApplied: true,
                evictionInputAmount: 10_000,
                evictionOriginalAmount: 20_000,
                determinationInputAmount: nil,
                tariffYear: 2026
            ))
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Minimum Applied - Dark")

            // Determination only
            TenancyMediationFeeResultSheet(result: TenancyMediationFeeResult(
                evictionFee: nil,
                determinationFee: 36_000,
                totalFee: 36_000,
                originalCalculatedFee: nil,
                isMinimumApplied: false,
                evictionInputAmount: nil,
                evictionOriginalAmount: nil,
                determinationInputAmount: 600_000,
                tariffYear: 2026
            ))
            .injectTheme(LightTheme())
            .previewDisplayName("Determination Only - Light")
        }
    }
}
