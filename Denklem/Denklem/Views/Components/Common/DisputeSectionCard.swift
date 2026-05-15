//
//  DisputeSectionCard.swift
//  Denklem
//
//  Created by ozkan on 15.02.2026.
//

import SwiftUI

/// Reusable section that renders a 2-column category grid with full-width items.
@available(iOS 26.0, *)
struct DisputeSectionCard: View {
    @Environment(\.theme) private var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    let title: String
    let categories: [DisputeCategoryType]
    /// Extra shortcut row rendered below the grid. Independent from `categories` so a grid
    /// slot can be repurposed (e.g. SMM → Consumer Dispute) without losing direct SMM/Time access.
    /// Uses `capsuleSystemImage` so Time can show today's dynamic calendar icon.
    let shortcutCategories: [DisputeCategoryType]
    let cardColor: Color
    let onCategoryTap: (DisputeCategoryType) -> Void

    /// Full-width category types
    private static let fullWidthTypes: Set<DisputeCategoryType> = [.mediationFee]

    /// Categories that go in the 2-column grid (excludes full-width items)
    private var gridCategories: [DisputeCategoryType] {
        categories.filter { !Self.fullWidthTypes.contains($0) }
    }

    /// Full-width categories (AI Chat, Mediation Fee)
    private var fullWidthCategories: [DisputeCategoryType] {
        categories.filter { Self.fullWidthTypes.contains($0) }
    }

    var body: some View {
        VStack(spacing: theme.spacingM) {
            // 2-column grid — all categories as rectangle buttons
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: theme.spacingS),
                    GridItem(.flexible(), spacing: theme.spacingS)
                ],
                spacing: theme.spacingM
            ) {
                ForEach(gridCategories) { category in
                    RectangleButton(
                        systemImage: category.systemImage,
                        iconColor: theme.primary,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusXXL,
                        action: { onCategoryTap(category) }
                    )
                    .accessibilityHint(accessibilityHint(for: category))
                }
            }

            // Additional shortcut row — same rectangle style as the grid
            if !shortcutCategories.isEmpty {
                HStack(spacing: theme.spacingS) {
                    ForEach(shortcutCategories) { category in
                        RectangleButton(
                            systemImage: category.capsuleSystemImage,
                            iconColor: theme.primary,
                            text: category.displayName,
                            textColor: theme.textPrimary,
                            font: theme.footnote,
                            cornerRadius: theme.cornerRadiusXXL,
                            action: { onCategoryTap(category) }
                        )
                    }
                }
            }

            ForEach(fullWidthCategories) { category in
                Button {
                    onCategoryTap(category)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: category.systemImage)
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(category.iconColor)
                            .accessibilityHidden(true)
                        Text(category.displayName)
                            .font(theme.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .contentShape(Rectangle())
                }
                // Liquid Glass button style (clear when animated background is on)
                .buttonStyle(.glass(isAnimatedBackground ? .clear : .regular))
                .buttonBorderShape(.roundedRectangle(radius: theme.cornerRadiusXXL))
            }
        }
    }

    /// Returns the VoiceOver hint for a category. Most categories rely on their displayed
    /// text alone; only "special" buttons whose action isn't obvious from the label get a hint.
    private func accessibilityHint(for category: DisputeCategoryType) -> String {
        switch category {
        case .consumerDispute:
            return LocalizationKeys.Accessibility.consumerDisputeButtonHint.localized
        default:
            return ""
        }
    }
}
