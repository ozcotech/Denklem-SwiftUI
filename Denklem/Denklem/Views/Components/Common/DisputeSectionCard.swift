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
                ForEach(categories) { category in
                    RectangleButton(
                        systemImage: category.systemImage,
                        iconColor: category.iconColor,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusM,
                        action: { onCategoryTap(category) }
                    )
                }
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
