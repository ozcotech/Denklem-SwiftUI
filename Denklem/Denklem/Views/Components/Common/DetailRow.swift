//
//  DetailRow.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Detail Row
/// Shared label-value row used in result/detail screens
/// Displays a label on the left and a value on the right with consistent styling
@available(iOS 26.0, *)
struct DetailRow: View {
    @Environment(\.theme) var theme

    let label: String
    let value: String
    var isHighlighted: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? theme.headline : theme.body)
                .fontWeight(isHighlighted ? .bold : .medium)
                .foregroundStyle(isHighlighted ? theme.primary : theme.textPrimary)
        }
    }
}
