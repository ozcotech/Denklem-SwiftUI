//
//  ReinstatementResultView.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import SwiftUI

// MARK: - Reinstatement Result View
/// View displaying reinstatement calculation result
/// Shown inline within ReinstatementSheet after calculation
@available(iOS 26.0, *)
struct ReinstatementResultView: View {

    // MARK: - Properties

    let result: ReinstatementResult
    let theme: ThemeProtocol
    let onDismiss: () -> Void
    let onRecalculate: () -> Void

    @ObservedObject private var localeManager = LocaleManager.shared

    // MARK: - Body

    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        ScrollView {
            VStack(spacing: theme.spacingL) {

                // Main Fee Card
                mainFeeCard

                // Details Card - conditional based on agreement status
                if result.agreementStatus == .agreed {
                    agreementDetailsCard
                } else {
                    noAgreementDetailsCard
                }

                // Warning Card (only for no agreement case)
                if result.agreementStatus == .notAgreed {
                    warningCard
                }

                // Legal Reference Card
                legalReferenceCard

                // Recalculate Button
                recalculateButton
            }
            .padding(.horizontal, theme.spacingL)
            .padding(.bottom, theme.spacingXXL)
        }
    }

    // MARK: - Main Fee Card

    private var mainFeeCard: some View {
        VStack(spacing: theme.spacingS) {
            Text(LocalizationKeys.Reinstatement.totalFee.localized)
                .font(theme.caption)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(result.formattedTotalFee)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primary)

            // Agreement Status Badge
            HStack(spacing: theme.spacingXS) {
                Image(systemName: result.agreementStatus == .agreed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(theme.caption)

                Text(result.agreementStatus.displayName)
                    .font(theme.caption)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingM)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surfaceElevated)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.primary.opacity(0.2), lineWidth: 2)
        }
    }

    // MARK: - Agreement Details Card

    private var agreementDetailsCard: some View {
        VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(theme.headline)
                    .foregroundStyle(theme.primary)

                Text(LocalizationKeys.Reinstatement.calculationBreakdown.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            if let breakdown = result.breakdown {
                // Non-Reinstatement Compensation
                detailRow(
                    label: LocalizationKeys.Reinstatement.nonReinstatementCompensation.localized,
                    value: breakdown.formattedCompensation
                )

                Divider()
                    .background(theme.outline.opacity(0.2))

                // Idle Period Wage
                detailRow(
                    label: LocalizationKeys.Reinstatement.idlePeriodWage.localized,
                    value: breakdown.formattedIdleWage
                )

                // Other Rights (if present)
                if let otherRights = breakdown.formattedOtherRights {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    detailRow(
                        label: LocalizationKeys.Reinstatement.otherRights.localized,
                        value: otherRights
                    )
                }

                Divider()
                    .background(theme.outline.opacity(0.2))

                // Total Amount
                detailRow(
                    label: LocalizationKeys.Reinstatement.totalAmount.localized,
                    value: breakdown.formattedTotalAmount,
                    isHighlighted: true
                )

                // Minimum Fee Note (if applied)
                if breakdown.isMinimumApplied {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    HStack(spacing: theme.spacingXS) {
                        Image(systemName: "info.circle")
                            .font(theme.caption)
                            .foregroundStyle(theme.warning)

                        Text(LocalizationKeys.Reinstatement.minimumFeeApplied.localized)
                            .font(theme.caption)
                            .foregroundStyle(theme.warning)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Divider()
                .background(theme.outline.opacity(0.2))

            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: "\(result.tariffYear.rawValue)"
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

    // MARK: - No Agreement Details Card

    private var noAgreementDetailsCard: some View {
        VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(theme.headline)
                    .foregroundStyle(theme.primary)

                Text(LocalizationKeys.Result.calculationInfo.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            // Fixed Fee Used
            if let fixedFee = result.formattedFixedFee {
                detailRow(
                    label: LocalizationKeys.Result.mediationFee.localized + " (x2)",
                    value: fixedFee
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Party Count
            detailRow(
                label: LocalizationKeys.Reinstatement.partyCount.localized,
                value: "\(result.partyCount)"
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: "\(result.tariffYear.rawValue)"
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

    // MARK: - Warning Card

    private var warningCard: some View {
        VStack(spacing: theme.spacingS) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(theme.subheadline)
                    .foregroundStyle(theme.warning)

                Text(LocalizationKeys.General.warning.localized)
                    .font(theme.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            HStack(alignment: .top, spacing: theme.spacingS) {
                Text(LocalizationKeys.Reinstatement.noAgreementWarning.localized)
                    .font(theme.caption)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
        }
        .padding(theme.spacingM)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.warning.opacity(0.1))
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
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

                Text(result.fullLegalReference)
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

    // MARK: - Recalculate Button

    private var recalculateButton: some View {
        RecalculateButton(action: onRecalculate)
    }

    // MARK: - Detail Row

    private func detailRow(label: String, value: String, isHighlighted: Bool = false) -> some View {
        DetailRow(label: label, value: value, isHighlighted: isHighlighted)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct ReinstatementResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Agreement Case - 2026
            NavigationStack {
                ReinstatementResultView(
                    result: ReinstatementResult.agreed(
                        totalFee: 9600,
                        tariffYear: .year2026,
                        partyCount: 2,
                        breakdown: ReinstatementBreakdown(
                            nonReinstatementCompensation: 100_000,
                            idlePeriodWage: 50_000,
                            otherRights: 10_000,
                            totalAmount: 160_000,
                            bracketFee: 9600,
                            isMinimumApplied: false
                        )
                    ),
                    theme: LightTheme(),
                    onDismiss: {},
                    onRecalculate: {}
                )
                .navigationTitle(LocalizationKeys.Reinstatement.resultTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Agreement 2026 - Light")

            // No Agreement Case - 2026
            NavigationStack {
                ReinstatementResultView(
                    result: ReinstatementResult.notAgreed(
                        totalFee: 4520,
                        tariffYear: .year2026,
                        partyCount: 2,
                        fixedFeeUsed: 2260
                    ),
                    theme: DarkTheme(),
                    onDismiss: {},
                    onRecalculate: {}
                )
                .navigationTitle(LocalizationKeys.Reinstatement.resultTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("No Agreement 2026 - Dark")

            // Agreement Case with Minimum Fee Applied
            NavigationStack {
                ReinstatementResultView(
                    result: ReinstatementResult.agreed(
                        totalFee: 9000,
                        tariffYear: .year2026,
                        partyCount: 2,
                        breakdown: ReinstatementBreakdown(
                            nonReinstatementCompensation: 50_000,
                            idlePeriodWage: 30_000,
                            otherRights: nil,
                            totalAmount: 80_000,
                            bracketFee: 4800,
                            isMinimumApplied: true
                        )
                    ),
                    theme: LightTheme(),
                    onDismiss: {},
                    onRecalculate: {}
                )
                .navigationTitle(LocalizationKeys.Reinstatement.resultTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Min Fee Applied - Light")
        }
    }
}
