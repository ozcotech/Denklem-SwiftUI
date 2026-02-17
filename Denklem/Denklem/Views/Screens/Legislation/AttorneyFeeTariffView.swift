//
//  AttorneyFeeTariffView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Attorney Fee Tariff View
/// Displays the full attorney fee tariff document content with native SwiftUI rendering
/// Shows articles as collapsible sections and fee tables as sectioned lists
@available(iOS 26.0, *)
struct AttorneyFeeTariffView: View {

    // MARK: - Properties

    let content: AttorneyFeeTariffContent
    var searchText: String = ""

    @Environment(\.theme) var theme

    // MARK: - Body

    var body: some View {
        VStack(spacing: theme.spacingL) {
            // Gazette Info Header
            gazetteHeader

            // Articles Section
            articlesSection

            // Table Sections
            ForEach(Array(content.tableSections.enumerated()), id: \.offset) { _, section in
                AttorneyFeeTableSectionView(section: section, searchText: searchText)
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
            AttorneyFeeDocSectionTitle(
                title: NSLocalizedString("legislation.section.articles", value: "Tarife Maddeleri", comment: "")
            )

            VStack(spacing: 0) {
                ForEach(Array(content.articles.enumerated()), id: \.offset) { index, article in
                    AttorneyFeeArticleRow(article: article, searchText: searchText)

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
        let query = searchText.lowercased()
        return VStack(spacing: theme.spacingS) {
            AttorneyFeeDocSectionTitle(title: content.part3Title)

            // Subtitle
            Text(content.part3Subtitle)
                .font(theme.caption)
                .foregroundStyle(theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, theme.spacingXS)

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
                    let isMatch = !query.isEmpty && (
                        bracket.description.lowercased().contains(query) ||
                        bracket.rate.lowercased().contains(query)
                    )

                    HStack {
                        Text(bracket.description)
                            .font(theme.caption)
                            .foregroundStyle(theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(bracket.rate)
                            .font(theme.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.primary)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.vertical, theme.spacingS)
                    .background(isMatch ? theme.primary.opacity(0.06) : Color.clear)

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
    var searchText: String = ""

    @Environment(\.theme) var theme

    private var isMatch: Bool {
        guard !searchText.isEmpty else { return false }
        let q = searchText.lowercased()
        return section.subtitle.lowercased().contains(q) ||
            section.items.contains {
                $0.description.lowercased().contains(q) ||
                $0.amount.lowercased().contains(q)
            }
    }

    var body: some View {
        VStack(spacing: theme.spacingS) {
            AttorneyFeeDocSectionTitle(title: section.partTitle)

            // Section subtitle
            Text(section.subtitle)
                .font(theme.caption)
                .foregroundStyle(theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, theme.spacingXS)

            // Fee items
            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { index, item in
                    AttorneyFeeItemRow(item: item, searchText: searchText)

                    if index < section.items.count - 1 {
                        Divider()
                            .padding(.horizontal, theme.spacingM)
                    }
                }

                // Footnote
                if let footnote = section.footnote {
                    Divider()
                    Text("* \(footnote)")
                        .font(theme.caption2)
                        .foregroundStyle(theme.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, theme.spacingM)
                        .padding(.vertical, theme.spacingS)
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
    var searchText: String = ""

    @Environment(\.theme) var theme

    private var isMatch: Bool {
        guard !searchText.isEmpty else { return false }
        let q = searchText.lowercased()
        return item.description.lowercased().contains(q) || item.amount.lowercased().contains(q)
    }

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
            Text(item.description)
                .font(theme.caption)
                .foregroundStyle(item.number.isEmpty ? theme.textTertiary : theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            // Amount
            Text(item.amount)
                .font(theme.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primary)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minWidth: 70, alignment: .trailing)
        }
        .padding(.horizontal, theme.spacingM)
        .padding(.vertical, theme.spacingS)
        .background(isMatch ? theme.primary.opacity(0.06) : Color.clear)
    }
}

// MARK: - Article Row

@available(iOS 26.0, *)
private struct AttorneyFeeArticleRow: View {

    let article: LawArticle
    var searchText: String = ""

    @State private var isExpanded = false
    @Environment(\.theme) var theme

    private var isMatch: Bool {
        guard !searchText.isEmpty else { return false }
        let q = searchText.lowercased()
        return article.title.lowercased().contains(q) ||
               article.paragraphs.joined(separator: " ").lowercased().contains(q)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Madde \(article.number)")
                        .font(theme.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.primary)
                        .frame(width: 65, alignment: .leading)

                    Text(article.title)
                        .font(theme.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)
                        .lineLimit(isExpanded ? nil : 1)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    if isMatch && !isExpanded {
                        Image(systemName: "magnifyingglass")
                            .font(theme.caption2)
                            .foregroundStyle(theme.primary)
                    }

                    Image(systemName: "chevron.right")
                        .font(theme.caption2)
                        .foregroundStyle(theme.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.vertical, theme.spacingS + 2)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(isMatch && !isExpanded ? theme.primary.opacity(0.06) : Color.clear)

            if isExpanded {
                VStack(alignment: .leading, spacing: theme.spacingS) {
                    ForEach(Array(article.paragraphs.enumerated()), id: \.offset) { index, paragraph in
                        HStack(alignment: .top, spacing: theme.spacingXS) {
                            Text("(\(index + 1))")
                                .font(theme.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(theme.primary)
                                .frame(width: 24, alignment: .leading)

                            Text(paragraph)
                                .font(theme.caption)
                                .foregroundStyle(theme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, theme.spacingXS)
                        .background(
                            paragraph.lowercased().contains(searchText.lowercased()) && !searchText.isEmpty ?
                                theme.primary.opacity(0.06) : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.bottom, theme.spacingM)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: searchText) { _, newValue in
            if !newValue.isEmpty && isMatch {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded = true }
            } else if !newValue.isEmpty && !isMatch {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded = false }
            } else if newValue.isEmpty {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded = false }
            }
        }
    }
}

// MARK: - Section Title

@available(iOS 26.0, *)
private struct AttorneyFeeDocSectionTitle: View {

    let title: String

    @Environment(\.theme) var theme

    var body: some View {
        Text(title)
            .font(theme.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, theme.spacingS)
    }
}
