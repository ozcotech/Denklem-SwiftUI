//
//  ErrorBannerView.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import SwiftUI

// MARK: - Error Banner View
/// Shared error/warning message banner used across input screens
/// Displays an error icon with descriptive text on a tinted background
@available(iOS 26.0, *)
struct ErrorBannerView: View {
    @Environment(\.theme) var theme

    let message: String
    var showBorder: Bool = false

    var body: some View {
        HStack(spacing: theme.spacingS) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(theme.caption)
                .foregroundStyle(theme.error)

            Text(message)
                .font(theme.footnote)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.leading)
        }
        .padding(theme.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.error.opacity(0.1))
        }
        .overlay {
            if showBorder {
                RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                    .stroke(theme.error, lineWidth: theme.borderWidth)
            }
        }
    }
}
