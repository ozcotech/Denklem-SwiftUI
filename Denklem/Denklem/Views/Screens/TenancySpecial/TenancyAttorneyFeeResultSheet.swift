//
//  TenancyAttorneyFeeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import SwiftUI

// MARK: - Tenancy Attorney Fee Result Sheet
/// Bottom sheet displaying tenancy attorney fee calculation result
/// Shows: main fee, calculation info (input amounts), court minimum warnings, legal reference
@available(iOS 26.0, *)
struct TenancyAttorneyFeeResultSheet: View {

    // MARK: - Properties

    let result: TenancyAttorneyFeeResult

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

                    // Main Fee Cards
                    mainFeeCards

                    // Calculation Info Card
                    calculationInfoCard

                    // Court Minimum Warnings Card
                    if !result.courtMinimumWarnings.isEmpty {
                        courtMinimumWarningsCard
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

    // MARK: - Main Fee Cards

    private var mainFeeCards: some View {
        VStack(spacing: theme.spacingM) {
            if let evictionFee = result.evictionFee {
                mainFeeCard(
                    title: "\(LocalizationKeys.RentSpecial.eviction.localized) \(LocalizationKeys.RentSpecial.calculatedAttorneyFee.localized)",
                    amount: LocalizationHelper.formatCurrency(evictionFee)
                )
            }

            if let determinationFee = result.determinationFee {
                mainFeeCard(
                    title: "\(LocalizationKeys.RentSpecial.determination.localized) \(LocalizationKeys.RentSpecial.calculatedAttorneyFee.localized)",
                    amount: LocalizationHelper.formatCurrency(determinationFee)
                )
            }

            if result.evictionFee == nil && result.determinationFee == nil {
                mainFeeCard(
                    title: LocalizationKeys.RentSpecial.calculatedAttorneyFee.localized,
                    amount: result.formattedFee
                )
            }
        }
    }

    private func mainFeeCard(title: String, amount: String) -> some View {
        VStack(spacing: theme.spacingM) {
            Text(title)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(amount)
                .font(.system(size: 36, weight: .bold, design: .rounded))
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

            // Eviction Amount (if selected)
            if let evictionAmount = result.evictionAmount {
                detailRow(
                    label: LocalizationKeys.RentSpecial.eviction.localized,
                    value: LocalizationHelper.formatCurrency(evictionAmount)
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Determination Amount (if selected)
            if let determinationAmount = result.determinationAmount {
                detailRow(
                    label: LocalizationKeys.RentSpecial.determination.localized,
                    value: LocalizationHelper.formatCurrency(determinationAmount)
                )

                Divider()
                    .background(theme.outline.opacity(0.2))
            }

            // Total Input Amount
            detailRow(
                label: LocalizationKeys.RentSpecial.inputAmount.localized,
                value: result.formattedTotalInputAmount
            )

            Divider()
                .background(theme.outline.opacity(0.2))

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

                    Text(LocalizationKeys.RentSpecial.attorneyMinimumApplied.localized)
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

    // MARK: - Court Minimum Warnings Card

    private var courtMinimumWarningsCard: some View {
        VStack(spacing: theme.spacingM) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(theme.headline)
                    .foregroundStyle(theme.warning)

                Text(LocalizationKeys.RentSpecial.courtMinimumWarningsTitle.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Divider()
                .background(theme.border)

            ForEach(result.courtMinimumWarnings) { warning in
                HStack(alignment: .top, spacing: theme.spacingS) {
                    Image(systemName: "info.circle")
                        .font(theme.footnote)
                        .foregroundStyle(theme.warning)

                    Text(warning.warningMessage)
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
        DetailRow(label: label, value: value)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct TenancyAttorneyFeeResultSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Both types selected
            TenancyAttorneyFeeResultSheet(result: TenancyAttorneyFeeResult(
                fee: 188_000,
                evictionFee: 156_000,
                determinationFee: 32_000,
                originalCalculatedFee: nil,
                isMinimumApplied: false,
                totalInputAmount: 1_200_000,
                evictionAmount: 1_000_000,
                determinationAmount: 200_000,
                courtMinimumWarnings: [
                    CourtMinimumWarning(
                        courtType: .civilPeace,
                        minimumFee: 30_000,
                        warningMessage: "Sulh Hukuk Mahkemesi asgari ücreti: 30.000 TL"
                    ),
                    CourtMinimumWarning(
                        courtType: .firstInstance,
                        minimumFee: 45_000,
                        warningMessage: "Asliye Mahkemesi asgari ücreti: 45.000 TL"
                    ),
                    CourtMinimumWarning(
                        courtType: .enforcement,
                        minimumFee: 18_000,
                        warningMessage: "İcra Mahkemesi asgari ücreti: 18.000 TL"
                    )
                ],
                tariffYear: 2026
            ))
            .injectTheme(LightTheme())
            .previewDisplayName("Both Types - Light")

            // Eviction only - minimum applied (88.90 TL → 30,000 TL)
            TenancyAttorneyFeeResultSheet(result: TenancyAttorneyFeeResult(
                fee: 30_000,
                evictionFee: 30_000,
                determinationFee: nil,
                originalCalculatedFee: 88.90,
                isMinimumApplied: true,
                totalInputAmount: 555,
                evictionAmount: 555,
                determinationAmount: nil,
                courtMinimumWarnings: [
                    CourtMinimumWarning(
                        courtType: .civilPeace,
                        minimumFee: 30_000,
                        warningMessage: "Sulh Hukuk Mahkemesi asgari ücreti: 30.000 TL"
                    )
                ],
                tariffYear: 2026
            ))
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Eviction Only - Dark")
        }
    }
}
