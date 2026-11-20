//
//  LawDocumentView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Search Blocks

extension LawDocumentContent {

    /// All searchable text in display order (must mirror `LawDocumentView`)
    var searchBlocks: [DocumentSearchBlock] {
        articles.enumerated().flatMap { index, article in
            DocumentSearchBlock.article(index: index, title: article.title, paragraphs: article.paragraphs)
        }
    }
}

// MARK: - Law Document View
/// Displays the full law document content with native SwiftUI rendering
/// Shows articles as collapsible sections
@available(iOS 26.0, *)
struct LawDocumentView: View {

    // MARK: - Properties

    let content: LawDocumentContent

    @Environment(\.theme) var theme

    // MARK: - Body

    var body: some View {
        VStack(spacing: theme.spacingL) {
            // Law Info Header
            lawInfoHeader

            // Articles Section
            articlesSection
        }
    }

    // MARK: - Law Info Header

    private var lawInfoHeader: some View {
        VStack(spacing: theme.spacingXS) {
            Text("legislation.law.number".localized(String(content.lawNumber)))
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text("legislation.law.gazette".localized(content.gazetteDate, content.gazetteNumber))
                .font(theme.caption)
                .foregroundStyle(theme.primary)

            Text("legislation.law.acceptance".localized(content.acceptanceDate))
                .font(theme.caption)
                .foregroundStyle(theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingM)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.primary.opacity(0.05))
        )
    }

    // MARK: - Articles Section

    private var articlesSection: some View {
        VStack(spacing: 0) {
            DocumentSectionTitle(title: "legislation.law.section.articles".localized)

            VStack(spacing: 0) {
                ForEach(Array(content.articles.enumerated()), id: \.offset) { index, article in
                    DocumentArticleRow(
                        index: index,
                        number: article.number,
                        title: article.title,
                        paragraphs: article.paragraphs
                    )

                    if index < content.articles.count - 1 {
                        Divider()
                            .padding(.horizontal, theme.spacingM)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                    .fill(theme.surfaceElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                    .stroke(theme.border, lineWidth: 0.5)
            )
        }
    }
}
