//
//  YearPickerSection.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Year Picker Option
/// A year type that can be shown in `YearPickerSection`
/// (mediation `TariffYear` or `AttorneyFeeTariffYear`)
protocol YearPickerOption: Hashable, Identifiable {
    var displayName: String { get }
    /// Year value, used to list the newest year first
    var rawValue: Int { get }
}

extension TariffYear: YearPickerOption {}
extension AttorneyFeeTariffYear: YearPickerOption {}

// MARK: - Year Picker Section
/// Shared tariff year picker dropdown used across input/selection screens
/// Displays an optional legal reference label above a capsule-styled year picker menu
@available(iOS 26.0, *)
struct YearPickerSection<Year: YearPickerOption>: View {
    @Environment(\.theme) var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    let availableYears: [Year]
    let selectedYear: Year
    var selectedDisplayText: String? = nil
    var legalReferenceText: String? = nil
    var showTopPadding: Bool = false
    let onYearSelected: (Year) -> Void

    var body: some View {
        VStack(spacing: theme.spacingS) {
            if let refText = legalReferenceText {
                Text(refText)
                    .font(theme.caption)
                    .foregroundStyle(theme.textSecondary)
            }

            Menu {
                // Newest year first (e.g. 2027, 2026, 2025)
                ForEach(availableYears.sorted { $0.rawValue > $1.rawValue }) { year in
                    Button {
                        onYearSelected(year)
                    } label: {
                        HStack {
                            Text(year.displayName)
                            if selectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: theme.spacingXS) {
                    Text(selectedDisplayText ?? selectedYear.displayName)
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.primary)

                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(theme.primary)
                }
                .padding(.horizontal, theme.spacingS)
                .padding(.vertical, theme.spacingXS)
                .glassEffect(isAnimatedBackground ? .clear : .regular, in: Capsule())
            }
            .accessibilityLabel(LocalizationKeys.Result.tariffYear.localized)
            .accessibilityValue(selectedDisplayText ?? selectedYear.displayName)
            .accessibilityHint(LocalizationKeys.Accessibility.yearPickerHint.localized)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, showTopPadding ? theme.spacingL : 0)
    }
}
