//
//  AttorneyFeeTariffView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Block IDs

/// Search / scroll identifiers for attorney fee tariff tables
private enum AttorneyFeeBlockID {
    static func sectionTitle(_ section: Int) -> String { "fee-\(section)-title" }
    static func sectionSubtitle(_ section: Int) -> String { "fee-\(section)-subtitle" }
    static func itemDescription(_ section: Int, _ item: Int) -> String { "fee-\(section)-\(item)-desc" }
    static func itemAmount(_ section: Int, _ item: Int) -> String { "fee-\(section)-\(item)-amount" }
    static func footnote(_ section: Int) -> String { "fee-\(section)-footnote" }
    static let part3Title = "fee-part3-title"
    static let part3Subtitle = "fee-part3-subtitle"
    static func bracketDescription(_ bracket: Int) -> String { "fee-part3-\(bracket)-desc" }
    static func bracketRate(_ bracket: Int) -> String { "fee-part3-\(bracket)-rate" }
}

// MARK: - Search Blocks

extension AttorneyFeeTariffContent {

    /// All searchable text in display order (must mirror `AttorneyFeeTariffView`)
    var searchBlocks: [DocumentSearchBlock] {
        var blocks: [DocumentSearchBlock] = []

        for (index, article) in articles.enumerated() {
            blocks += DocumentSearchBlock.article(index: index, title: article.title, paragraphs: article.paragraphs)
        }

        for (sIndex, section) in tableSections.enumerated() {
            blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.sectionTitle(sIndex), groupID: nil, text: section.partTitle))
            blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.sectionSubtitle(sIndex), groupID: nil, text: section.subtitle))
            for (iIndex, item) in section.items.enumerated() {
                blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.itemDescription(sIndex, iIndex), groupID: nil, text: item.description))
                blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.itemAmount(sIndex, iIndex), groupID: nil, text: item.amount))
            }
            if let footnote = section.footnote {
                blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.footnote(sIndex), groupID: nil, text: "* \(footnote)"))
            }
        }

        blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.part3Title, groupID: nil, text: part3Title))
        blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.part3Subtitle, groupID: nil, text: part3Subtitle))
        for (bIndex, bracket) in part3Brackets.enumerated() {
            blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.bracketDescription(bIndex), groupID: nil, text: bracket.description))
            blocks.append(DocumentSearchBlock(id: AttorneyFeeBlockID.bracketRate(bIndex), groupID: nil, text: bracket.rate))
        }

        return blocks
    }
}

// MARK: - Attorney Fee Tariff View
/// Displays the full attorney fee tariff document content with native SwiftUI rendering
/// Shows articles as collapsible sections and fee tables as sectioned lists
@available(iOS 26.0, *)
struct AttorneyFeeTariffView: View {

    // MARK: - Properties

    let content: AttorneyFeeTariffContent

    @Environment(\.theme) var theme

    // MARK: - Body

    var body: some View {
        VStack(spacing: theme.spacingL) {
            // Gazette Info Header
            gazetteHeader

            // Articles Section
            articlesSection

            // Table Sections
            ForEach(Array(content.tableSections.enumerated()), id: \.offset) { index, section in
                AttorneyFeeTableSectionView(section: section, sectionIndex: index)
            }

            // Part 3 Brackets
            part3Section
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

    // MARK: - Part 3 Section

    private var part3Section: some View {
        VStack(spacing: theme.spacingS) {
            DocumentSectionTitle(title: content.part3Title, blockID: AttorneyFeeBlockID.part3Title)

            // Subtitle
            HighlightedText(text: content.part3Subtitle, blockID: AttorneyFeeBlockID.part3Subtitle)
                .font(theme.caption)
                .foregroundStyle(theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, theme.spacingXS)
                .textSelection(.enabled)

            VStack(spacing: 0) {
                // Header Row
                HStack {
                    Text(NSLocalizedString("legislation.attorney.bracket.tier", value: "Dilim", comment: ""))
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(NSLocalizedString("legislation.attorney.bracket.rate", value: "Oran", comment: ""))
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
                ForEach(Array(content.part3Brackets.enumerated()), id: \.offset) { index, bracket in
                    HStack {
                        HighlightedText(text: bracket.description, blockID: AttorneyFeeBlockID.bracketDescription(index))
                            .font(theme.caption)
                            .foregroundStyle(theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HighlightedText(text: bracket.rate, blockID: AttorneyFeeBlockID.bracketRate(index))
                            .font(theme.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.primary)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .textSelection(.enabled)
                    .padding(.horizontal, theme.spacingM)
                    .padding(.vertical, theme.spacingS)

                    if index < content.part3Brackets.count - 1 {
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

// MARK: - Table Section View

@available(iOS 26.0, *)
private struct AttorneyFeeTableSectionView: View {

    let section: AttorneyFeeTableSection
    let sectionIndex: Int

    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: theme.spacingS) {
            DocumentSectionTitle(title: section.partTitle, blockID: AttorneyFeeBlockID.sectionTitle(sectionIndex))

            // Section subtitle
            HighlightedText(text: section.subtitle, blockID: AttorneyFeeBlockID.sectionSubtitle(sectionIndex))
                .font(theme.caption)
                .foregroundStyle(theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, theme.spacingXS)
                .textSelection(.enabled)

            // Fee items
            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { index, item in
                    AttorneyFeeItemRow(item: item, sectionIndex: sectionIndex, itemIndex: index)

                    if index < section.items.count - 1 {
                        Divider()
                            .padding(.horizontal, theme.spacingM)
                    }
                }

                // Footnote
                if let footnote = section.footnote {
                    Divider()
                    HighlightedText(text: "* \(footnote)", blockID: AttorneyFeeBlockID.footnote(sectionIndex))
                        .font(theme.caption2)
                        .foregroundStyle(theme.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, theme.spacingM)
                        .padding(.vertical, theme.spacingS)
                        .textSelection(.enabled)
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

// MARK: - Fee Item Row

@available(iOS 26.0, *)
private struct AttorneyFeeItemRow: View {

    let item: AttorneyFeeItem
    let sectionIndex: Int
    let itemIndex: Int

    @Environment(\.theme) var theme

    var body: some View {
        HStack(alignment: .top, spacing: theme.spacingS) {
            // Number badge
            if item.number.isEmpty {
                // Continuation row (e.g., "Takip eden her saat için")
                Color.clear
                    .frame(width: 38)
            } else {
                Text(item.number)
                    .font(theme.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.primary)
                    .frame(width: 38, alignment: .leading)
            }

            // Description
            HighlightedText(text: item.description, blockID: AttorneyFeeBlockID.itemDescription(sectionIndex, itemIndex))
                .font(theme.caption)
                .foregroundStyle(item.number.isEmpty ? theme.textTertiary : theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            // Amount
            HighlightedText(text: item.amount, blockID: AttorneyFeeBlockID.itemAmount(sectionIndex, itemIndex))
                .font(theme.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primary)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: 70, alignment: .trailing)
        }
        .textSelection(.enabled)
        .padding(.horizontal, theme.spacingM)
        .padding(.vertical, theme.spacingS)
    }
}
