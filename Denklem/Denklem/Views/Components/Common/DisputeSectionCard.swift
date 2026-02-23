//
//  DisputeSectionCard.swift
//  Denklem
//
//  Created by ozkan on 15.02.2026.
//

import SwiftUI

/// Reusable section card that renders a title and 2-column category grid.
@available(iOS 26.0, *)
struct DisputeSectionCard: View {
    @Environment(\.theme) private var theme

    let title: String
    let categories: [DisputeCategoryType]
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
                        iconColor: category.iconColor,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusXL,
                        action: { onCategoryTap(category) }
                    )
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
                        Text(category.displayName)
                            .font(theme.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass(.clear.tint(theme.surface)))
                .buttonBorderShape(.roundedRectangle(radius: theme.cornerRadiusXL))
            }
        }
        .padding(.horizontal, theme.spacingXS)
        .padding(.vertical, theme.spacingS)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(cardColor)
        )
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }
}
