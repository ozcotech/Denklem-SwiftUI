//
//  YearPickerSection.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Year Picker Section
/// Shared tariff year picker dropdown used across input/selection screens
/// Displays an optional legal reference label above a capsule-styled year picker menu
@available(iOS 26.0, *)
struct YearPickerSection: View {
    @Environment(\.theme) var theme

    let availableYears: [TariffYear]
    let selectedYear: TariffYear
    var selectedDisplayText: String? = nil
    var legalReferenceText: String? = nil
    var showTopPadding: Bool = false
    let onYearSelected: (TariffYear) -> Void

    var body: some View {
        VStack(spacing: theme.spacingS) {
            if let refText = legalReferenceText {
                Text(refText)
                    .font(theme.caption)
                    .foregroundStyle(theme.textSecondary)
            }

            Menu {
                ForEach(availableYears) { year in
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
                .background {
                    Capsule()
                        .fill(theme.surfaceElevated.opacity(0.6))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, showTopPadding ? theme.spacingL : 0)
    }
}
