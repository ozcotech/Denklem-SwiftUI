//
//  RecalculateButton.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Recalculate Button
/// Shared recalculate button used in result screens
/// Displays a refresh icon with localized "Recalculate" text
@available(iOS 26.0, *)
struct RecalculateButton: View {
    @Environment(\.theme) var theme

    let action: () -> Void

    var body: some View {
        Button {
            action()
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
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusXXL)
                .fill(.clear)
        )
        .glassEffect(theme.glassClear, in: RoundedRectangle(cornerRadius: theme.cornerRadiusXXL))
        .padding(.top, theme.spacingM)
    }
}
