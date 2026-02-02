//
//  SerialDisputesResultView.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import SwiftUI

// MARK: - Serial Disputes Result View
/// View displaying serial disputes calculation result
/// Shown inline within SerialDisputesSheet after calculation
@available(iOS 26.0, *)
struct SerialDisputesResultView: View {

    // MARK: - Properties

    let result: SerialDisputesResult
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

                // Details Card
                detailsCard

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
        VStack(spacing: theme.spacingM) {
            Text(LocalizationKeys.Result.mediationFee.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(result.formattedTotalFee)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primary)

            // Dispute Type Badge
            Text(result.disputeType.displayName)
                .font(theme.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
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

    // MARK: - Details Card

    private var detailsCard: some View {
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

            // Dispute Type
            detailRow(
                label: LocalizationKeys.SerialDisputes.disputeTypeLabel.localized,
                value: result.disputeType.displayName
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            // File Count
            detailRow(
                label: LocalizationKeys.SerialDisputes.fileCountLabel.localized,
                value: "\(result.fileCount)"
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            // Fee Per File
            detailRow(
                label: LocalizationKeys.SerialDisputes.feePerFile.localized,
                value: result.formattedFeePerFile
            )

            Divider()
                .background(theme.outline.opacity(0.2))

            // Tariff Year
            detailRow(
                label: LocalizationKeys.SerialDisputes.tariffYearLabel.localized,
                value: "\(result.tariffYear)"
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

    // MARK: - Recalculate Button

    private var recalculateButton: some View {
        Button {
            onRecalculate()
        } label: {
            HStack(spacing: theme.spacingS) {
                Image(systemName: "arrow.counterclockwise")
                    .font(theme.body)
                    .fontWeight(.semibold)
                Text(LocalizationKeys.General.recalculate.localized)
                    .font(theme.body)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeight)
        }
        .buttonStyle(.glass)
        .padding(.top, theme.spacingM)
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
struct SerialDisputesResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Commercial 2026
            NavigationStack {
                SerialDisputesResultView(
                    result: SerialDisputesResult(
                        totalFee: 37500,
                        feePerFile: 7500,
                        disputeType: .commercial,
                        fileCount: 5,
                        tariffYear: 2026
                    ),
                    theme: LightTheme(),
                    onDismiss: {},
                    onRecalculate: {}
                )
                .navigationTitle(LocalizationKeys.SerialDisputes.resultTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Commercial 2026 - Light")

            // Non-Commercial 2025
            NavigationStack {
                SerialDisputesResultView(
                    result: SerialDisputesResult(
                        totalFee: 120000,
                        feePerFile: 4000,
                        disputeType: .nonCommercial,
                        fileCount: 30,
                        tariffYear: 2025
                    ),
                    theme: DarkTheme(),
                    onDismiss: {},
                    onRecalculate: {}
                )
                .navigationTitle(LocalizationKeys.SerialDisputes.resultTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Non-Commercial 2025 - Dark")
        }
    }
}
