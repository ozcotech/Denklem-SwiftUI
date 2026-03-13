//
//  FeeResultCard.swift
//  Denklem
//
//  Created by ozkan on 08.03.2026.
//

import SwiftUI

// MARK: - Fee Result Card
/// Shared card displaying a fee title and formatted amount
/// Used across all result sheets and inline result previews
/// Supports an optional badge via ViewBuilder for extra context (e.g. dispute type, agreement status)
@available(iOS 26.0, *)
struct FeeResultCard<Badge: View>: View {
    @Environment(\.theme) var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    let title: String
    let formattedAmount: String
    let amountFontSize: CGFloat
    let showShadow: Bool
    let badge: Badge

    init(
        title: String,
        formattedAmount: String,
        amountFontSize: CGFloat = 40,
        showShadow: Bool = false,
        @ViewBuilder badge: () -> Badge
    ) {
        self.title = title
        self.formattedAmount = formattedAmount
        self.amountFontSize = amountFontSize
        self.showShadow = showShadow
        self.badge = badge()
    }

    var body: some View {
        VStack(spacing: theme.spacingM) {
            Text(title)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text(formattedAmount)
                .font(.system(size: amountFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primary)

            badge
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingL)
        .glassEffect(isAnimatedBackground ? .clear : .regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusXL))
        .shadow(color: showShadow ? theme.primary.opacity(0.25) : .clear, radius: showShadow ? 6 : 0)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Convenience Init (No Badge)

@available(iOS 26.0, *)
extension FeeResultCard where Badge == EmptyView {
    init(
        title: String,
        formattedAmount: String,
        amountFontSize: CGFloat = 40,
        showShadow: Bool = false
    ) {
        self.init(
            title: title,
            formattedAmount: formattedAmount,
            amountFontSize: amountFontSize,
            showShadow: showShadow
        ) {
            EmptyView()
        }
    }
}
