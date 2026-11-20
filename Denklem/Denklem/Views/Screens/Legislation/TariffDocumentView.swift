//
//  TariffDocumentView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Block IDs

/// Search / scroll identifiers for mediation tariff tables
private enum TariffBlockID {
    static let firstPartTitle = "mediation-first-title"
    static func category(_ category: Int) -> String { "mediation-category-\(category)" }
    static func categoryTitle(_ category: Int) -> String { "mediation-category-\(category)-title" }
    static func tierLabel(_ category: Int, _ tier: Int) -> String { "mediation-category-\(category)-\(tier)-label" }
    static func tierAmount(_ category: Int, _ tier: Int) -> String { "mediation-category-\(category)-\(tier)-amount" }
    static let secondPartTitle = "mediation-second-title"
    static func bracketDescription(_ bracket: Int) -> String { "mediation-bracket-\(bracket)-desc" }
    static func bracketSingle(_ bracket: Int) -> String { "mediation-bracket-\(bracket)-single" }
    static func bracketMultiple(_ bracket: Int) -> String { "mediation-bracket-\(bracket)-multiple" }
}

// MARK: - Search Blocks

extension TariffDocumentContent {

    /// All searchable text in display order (must mirror `TariffDocumentView`)
    var searchBlocks: [DocumentSearchBlock] {
        var blocks: [DocumentSearchBlock] = []

        for (index, article) in articles.enumerated() {
            blocks += DocumentSearchBlock.article(index: index, title: article.title, paragraphs: article.paragraphs)
        }

        blocks.append(DocumentSearchBlock(id: TariffBlockID.firstPartTitle, groupID: nil, text: firstPartTitle))
        for (cIndex, category) in firstPartCategories.enumerated() {
            let group = TariffBlockID.category(cIndex)
            blocks.append(DocumentSearchBlock(id: TariffBlockID.categoryTitle(cIndex), groupID: group, text: category.title))
            for (tIndex, tier) in category.tiers.enumerated() {
                blocks.append(DocumentSearchBlock(id: TariffBlockID.tierLabel(cIndex, tIndex), groupID: group, text: tier.label))
                blocks.append(DocumentSearchBlock(id: TariffBlockID.tierAmount(cIndex, tIndex), groupID: group, text: tier.amount))
            }
        }

        blocks.append(DocumentSearchBlock(id: TariffBlockID.secondPartTitle, groupID: nil, text: secondPartTitle))
        for (bIndex, bracket) in secondPartBrackets.enumerated() {
            blocks.append(DocumentSearchBlock(id: TariffBlockID.bracketDescription(bIndex), groupID: nil, text: bracket.description))
            blocks.append(DocumentSearchBlock(id: TariffBlockID.bracketSingle(bIndex), groupID: nil, text: bracket.singleRate))
            blocks.append(DocumentSearchBlock(id: TariffBlockID.bracketMultiple(bIndex), groupID: nil, text: bracket.multipleRate))
        }

        return blocks
    }
}

// MARK: - Tariff Document View
/// Displays the full tariff document content with native SwiftUI rendering
/// Shows articles as collapsible sections and fee tables as grids
@available(iOS 26.0, *)
struct TariffDocumentView: View {

    // MARK: - Properties

    let content: TariffDocumentContent

    @Environment(\.theme) var theme

    // MARK: - Body

    var body: some View {
        VStack(spacing: theme.spacingL) {
            // Gazette Info Header
            gazetteHeader

            // Articles Section
            articlesSection

            // First Part Table
            firstPartSection

            // Second Part Table
            secondPartSection
        }
    }

    // MARK: - Gazette Header

    private var gazetteHeader: some View {
        VStack(spacing: theme.spacingXS) {
            Text(content.gazetteInfo)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            Text("legislation.tariff.effectiveDate".localized(content.effectiveDate))
                .font(theme.caption)
                .foregroundStyle(theme.primary)
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
            DocumentSectionTitle(title: "legislation.section.articles".localized)

            VStack(spacing: 0) {
                ForEach(Array(content.articles.enumerated()), id: \.offset) { index, article in
                    DocumentArticleRow(
                        index: index,
                        number: String(article.number),
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

    // MARK: - First Part Section

    private var firstPartSection: some View {
        VStack(spacing: 0) {
            DocumentSectionTitle(title: content.firstPartTitle, blockID: TariffBlockID.firstPartTitle)

            VStack(spacing: 0) {
                ForEach(Array(content.firstPartCategories.enumerated()), id: \.offset) { index, category in
                    FirstPartCategoryRow(category: category, categoryIndex: index)

                    if index < content.firstPartCategories.count - 1 {
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

    // MARK: - Second Part Section

    private var secondPartSection: some View {
        VStack(spacing: theme.spacingS) {
            DocumentSectionTitle(title: content.secondPartTitle, blockID: TariffBlockID.secondPartTitle)

            VStack(spacing: 0) {
                // Header Row
                HStack {
                    // Use `.localized` (Bundle.localizedBundle) so LocaleManager's runtime
                    // language switch is respected — NSLocalizedString() reads Bundle.main and
                    // ignores it, which is why these headers used to stay English.
                    Text("legislation.tariff.bracket.tier".localized)
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("legislation.tariff.bracket.single".localized)
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(width: 50, alignment: .trailing)

                    Text("legislation.tariff.bracket.multiple".localized)
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(width: 50, alignment: .trailing)
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.vertical, theme.spacingS)
                .background(theme.surface)

                Divider()

                // Bracket Rows
                ForEach(Array(content.secondPartBrackets.enumerated()), id: \.offset) { index, bracket in
                    HStack {
                        HighlightedText(text: bracket.description, blockID: TariffBlockID.bracketDescription(index))
                            .font(theme.caption)
                            .foregroundStyle(theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HighlightedText(text: bracket.singleRate, blockID: TariffBlockID.bracketSingle(index))
                            .font(theme.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(theme.primary)
                            .frame(width: 50, alignment: .trailing)

                        HighlightedText(text: bracket.multipleRate, blockID: TariffBlockID.bracketMultiple(index))
                            .font(theme.caption)
                            .foregroundStyle(theme.textSecondary)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .textSelection(.enabled)
                    .padding(.horizontal, theme.spacingM)
                    .padding(.vertical, theme.spacingS)

                    if index < content.secondPartBrackets.count - 1 {
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

// MARK: - First Part Category Row

@available(iOS 26.0, *)
private struct FirstPartCategoryRow: View {

    let category: TariffFirstPartCategory
    let categoryIndex: Int

    @Environment(\.documentSearch) private var search
    @Environment(\.theme) var theme

    private var matchCount: Int {
        guard search.isSearching else { return 0 }
        let texts = [category.title] + category.tiers.flatMap { [$0.label, $0.amount] }
        return DocumentSearch.count(of: search.query, in: texts)
    }

    var body: some View {
        DocumentCollapsibleRow(groupID: TariffBlockID.category(categoryIndex), matchCount: matchCount) { isExpanded in
            Text("\(category.number).")
                .font(theme.caption)
                .fontWeight(.bold)
                .foregroundStyle(theme.primary)
                .frame(width: 24, alignment: .leading)

            HighlightedText(text: category.title, blockID: TariffBlockID.categoryTitle(categoryIndex))
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .lineLimit(isExpanded ? nil : 1)
                .multilineTextAlignment(.leading)
        } content: {
            // Fee tiers
            VStack(spacing: 0) {
                ForEach(Array(category.tiers.enumerated()), id: \.offset) { index, tier in
                    HStack {
                        Text(tierPrefix(index))
                            .font(theme.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(theme.textTertiary)
                            .frame(width: 22, alignment: .leading)

                        HighlightedText(text: tier.label, blockID: TariffBlockID.tierLabel(categoryIndex, index))
                            .font(theme.caption)
                            .foregroundStyle(theme.textSecondary)

                        Spacer()

                        HighlightedText(text: tier.amount, blockID: TariffBlockID.tierAmount(categoryIndex, index))
                            .font(theme.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.primary)
                    }
                    .textSelection(.enabled)
                    .padding(.horizontal, theme.spacingM)
                    .padding(.vertical, theme.spacingXS + 2)

                    if index < category.tiers.count - 1 {
                        Divider()
                            .padding(.leading, theme.spacingM + 22)
                    }
                }
            }
            .padding(.bottom, theme.spacingS)
        }
    }

    private func tierPrefix(_ index: Int) -> String {
        let prefixes = ["aa)", "ab)", "ac)", "ad)"]
        return index < prefixes.count ? prefixes[index] : ""
    }
}
