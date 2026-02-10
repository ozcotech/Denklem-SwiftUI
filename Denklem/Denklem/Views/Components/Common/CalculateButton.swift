//
//  CalculateButton.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Calculate Button
/// Shared calculate/submit button used across input screens
/// Displays button text with a progress indicator or arrow icon
/// Apply `.glassEffectID()` and additional modifiers at the call site as needed
@available(iOS 26.0, *)
struct CalculateButton: View {
    @Environment(\.theme) var theme

    let buttonText: String
    let isCalculating: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: theme.spacingM) {
                Text(buttonText)
                    .font(theme.body)
                    .fontWeight(.semibold)

                if isCalculating {
                    ProgressView()
                        .tint(theme.textPrimary)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(theme.body)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeight)
        }
        .buttonStyle(.glass)
        .tint(theme.primary)
        .disabled(!isEnabled || isCalculating)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}
