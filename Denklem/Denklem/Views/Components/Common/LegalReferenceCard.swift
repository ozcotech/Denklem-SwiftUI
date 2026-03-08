//
//  LegalReferenceCard.swift
//  Denklem
//
//  Created by ozkan on 08.03.2026.
//

import SwiftUI

// MARK: - Legal Reference Card
/// Shared card displaying a legal reference text with a book icon
/// Used across all result sheets to show the applicable law/tariff reference
@available(iOS 26.0, *)
struct LegalReferenceCard: View {
    @Environment(\.theme) var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    let text: String

    var body: some View {
        VStack(spacing: theme.spacingS) {
            HStack(spacing: theme.spacingXS) {
                Image(systemName: "book.closed.fill")
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)
                    .accessibilityHidden(true)

                Text(text)
                    .font(theme.footnote)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingM)
        .glassEffect(isAnimatedBackground ? .clear : .regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusM))
        .accessibilityElement(children: .combine)
    }
}
