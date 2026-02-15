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

    /// Categories that go in the 2-column grid (excludes full-width items)
    private var gridCategories: [DisputeCategoryType] {
        categories.filter { $0 != .aiChat }
    }

    /// Full-width category (AI Chat)
    private var fullWidthCategory: DisputeCategoryType? {
        categories.first { $0 == .aiChat }
    }

    var body: some View {
        VStack(spacing: theme.spacingS) {
            Text(title)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: theme.spacingS),
                    GridItem(.flexible(), spacing: theme.spacingS)
                ],
                spacing: theme.spacingS
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

            if let aiChat = fullWidthCategory {
                Button {
                    onCategoryTap(aiChat)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: aiChat.systemImage)
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(aiChat.iconColor)
                        Text(aiChat.displayName)
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
        .padding(.horizontal, theme.spacingS)
        .padding(.top, theme.spacingS)
        .padding(.bottom, theme.spacingL)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(cardColor)
        )
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }
}
