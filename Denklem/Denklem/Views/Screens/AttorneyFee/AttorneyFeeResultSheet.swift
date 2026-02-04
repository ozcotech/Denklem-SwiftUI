//
//  AttorneyFeeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 28.01.2026.
//

import SwiftUI

// MARK: - Attorney Fee Result Sheet
/// Bottom sheet displaying attorney fee calculation result
@available(iOS 26.0, *)
struct AttorneyFeeResultSheet: View {

    // MARK: - Properties

    let result: AttorneyFeeResult

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

                    // Calculation Info Card
                    calculationInfoCard

                    // Warnings Card (if any)
                    if !result.warnings.isEmpty {
                        warningsCard
                    }

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
            Text(LocalizationKeys.AttorneyFee.calculatedFee.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(result.formattedFee)
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

            // Calculation Type
            detailRow(
                label: LocalizationKeys.Calculation.typeHeader.localized,
                value: calculationTypeDisplayName
            )

            // Base Amount (if available)
            if let baseAmount = result.breakdown.baseAmount {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: result.breakdown.courtType != nil
                        ? LocalizationKeys.AttorneyFee.flatFee.localized
                        : LocalizationKeys.AttorneyFee.agreementAmount.localized,
                    value: LocalizationHelper.formatCurrency(baseAmount)
                )
            }

            // Court Type (if available)
            if let courtType = result.breakdown.courtType {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.AttorneyFee.courtType.localized,
                    value: courtType.displayName
                )
            }

            // Third Part Fee (if available)
            if let thirdPartFee = result.breakdown.thirdPartFee {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.AttorneyFee.thirdPartFee.localized,
                    value: LocalizationHelper.formatCurrency(thirdPartFee)
                )
            }

            // Bonus Amount (if available)
            if let bonusAmount = result.breakdown.bonusAmount {
                Divider()
                    .background(theme.outline.opacity(0.2))

                detailRow(
                    label: LocalizationKeys.AttorneyFee.bonusAmount.localized,
                    value: LocalizationHelper.formatCurrency(bonusAmount)
                )
            }

            Divider()
                .background(theme.outline.opacity(0.2))

            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: "\(result.tariffYear)"
            )

            // Minimum Fee Applied indicator
            if result.breakdown.isMinimumApplied {
                Divider()
                    .background(theme.outline.opacity(0.2))

                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(theme.footnote)
                        .foregroundStyle(theme.primary)

                    Text(LocalizationKeys.AttorneyFee.minimumFeeApplied.localized)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)

                    Spacer()
                }
            }

            // Maximum Fee Applied indicator
            if result.breakdown.isMaximumApplied {
                Divider()
                    .background(theme.outline.opacity(0.2))

                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(theme.footnote)
                        .foregroundStyle(theme.warning)

                    Text(LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized)
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

    // MARK: - Warnings Card

    private var warningsCard: some View {
        VStack(spacing: theme.spacingM) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(theme.headline)
                    .foregroundStyle(theme.warning)

                Text(LocalizationKeys.General.warning.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            ForEach(result.warnings, id: \.self) { warning in
                HStack(alignment: .top, spacing: theme.spacingS) {
                    Image(systemName: "info.circle")
                        .font(theme.footnote)
                        .foregroundStyle(theme.warning)

                    Text(warning)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.warning.opacity(0.1))
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.warning.opacity(0.3), lineWidth: 1)
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

    // MARK: - Computed Properties

    private var calculationTypeDisplayName: String {
        switch result.calculationType {
        case .monetaryAgreement:
            return "\(LocalizationKeys.AttorneyFee.monetaryType.localized) + \(LocalizationKeys.AttorneyFee.agreed.localized)"
        case .monetaryNoAgreement:
            return "\(LocalizationKeys.AttorneyFee.monetaryType.localized) + \(LocalizationKeys.AttorneyFee.notAgreed.localized)"
        case .nonMonetaryAgreement:
            return "\(LocalizationKeys.AttorneyFee.nonMonetaryType.localized) + \(LocalizationKeys.AttorneyFee.agreed.localized)"
        case .nonMonetaryNoAgreement:
            return "\(LocalizationKeys.AttorneyFee.nonMonetaryType.localized) + \(LocalizationKeys.AttorneyFee.notAgreed.localized)"
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct AttorneyFeeResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Monetary Agreement Result
            AttorneyFeeResultSheet(result: AttorneyFeeResult(
                fee: 20000,
                calculationType: .monetaryAgreement,
                breakdown: AttorneyFeeBreakdown(
                    baseAmount: 100000,
                    thirdPartFee: 16000,
                    bonusAmount: 4000,
                    courtType: nil,
                    isMinimumApplied: false,
                    isMaximumApplied: false
                ),
                warnings: [],
                tariffYear: 2026
            ))
            .injectTheme(LightTheme())
            .previewDisplayName("Monetary Agreement - Light")

            // Non-Monetary Agreement Result
            AttorneyFeeResultSheet(result: AttorneyFeeResult(
                fee: 37500,
                calculationType: .nonMonetaryAgreement,
                breakdown: AttorneyFeeBreakdown(
                    baseAmount: 30000,
                    thirdPartFee: nil,
                    bonusAmount: 7500,
                    courtType: .civilPeace,
                    isMinimumApplied: false,
                    isMaximumApplied: false
                ),
                warnings: [],
                tariffYear: 2026
            ))
            .injectTheme(LightTheme())
            .previewDisplayName("Non-Monetary Agreement - Light")

            // No Agreement Result with Warning
            AttorneyFeeResultSheet(result: AttorneyFeeResult(
                fee: 8000,
                calculationType: .monetaryNoAgreement,
                breakdown: AttorneyFeeBreakdown(
                    baseAmount: nil,
                    thirdPartFee: nil,
                    bonusAmount: nil,
                    courtType: nil,
                    isMinimumApplied: true,
                    isMaximumApplied: false
                ),
                warnings: [LocalizationKeys.AttorneyFee.feeExceedsAmountWarning.localized],
                tariffYear: 2026
            ))
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("No Agreement - Dark")
        }
    }
}
