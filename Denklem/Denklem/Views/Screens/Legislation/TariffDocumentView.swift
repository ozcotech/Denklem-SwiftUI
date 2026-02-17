//
//  TariffDocumentView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Tariff Document View
/// Displays the full tariff document content with native SwiftUI rendering
/// Shows articles as collapsible sections and fee tables as grids
@available(iOS 26.0, *)
struct TariffDocumentView: View {

    // MARK: - Properties

    let content: TariffDocumentContent
    var searchText: String = ""

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
            SectionTitle(title: NSLocalizedString("legislation.section.articles", value: "Tarife Maddeleri", comment: ""))

            VStack(spacing: 0) {
                ForEach(Array(content.articles.enumerated()), id: \.offset) { index, article in
                    ArticleRow(article: article, searchText: searchText)

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
            SectionTitle(title: content.firstPartTitle)

            VStack(spacing: 0) {
                ForEach(Array(content.firstPartCategories.enumerated()), id: \.offset) { index, category in
                    FirstPartCategoryRow(category: category, searchText: searchText)

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
        let query = searchText.lowercased()
        return VStack(spacing: theme.spacingS) {
            SectionTitle(title: content.secondPartTitle)

            VStack(spacing: 0) {
                // Header Row
                HStack {
                    Text(NSLocalizedString("legislation.tariff.bracket.tier", value: "Dilim", comment: ""))
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(NSLocalizedString("legislation.tariff.bracket.single", value: "Tek", comment: ""))
                        .font(theme.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                        .frame(width: 50, alignment: .trailing)

                    Text(NSLocalizedString("legislation.tariff.bracket.multiple", value: "Çoklu", comment: ""))
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
                    let isMatch = !query.isEmpty && (
                        bracket.description.lowercased().contains(query) ||
                        bracket.singleRate.lowercased().contains(query) ||
                        bracket.multipleRate.lowercased().contains(query)
                    )

                    HStack {
                        Text(bracket.description)
                            .font(theme.caption)
                            .foregroundStyle(theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(bracket.singleRate)
                            .font(theme.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(theme.primary)
                            .frame(width: 50, alignment: .trailing)

                        Text(bracket.multipleRate)
                            .font(theme.caption)
                            .foregroundStyle(theme.textSecondary)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.vertical, theme.spacingS)
                    .background(isMatch ? theme.primary.opacity(0.06) : Color.clear)

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

// MARK: - Section Title

@available(iOS 26.0, *)
private struct SectionTitle: View {

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

// MARK: - Article Row

@available(iOS 26.0, *)
private struct ArticleRow: View {

    let article: TariffArticle
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
            // Tap header to expand/collapse
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

            // Expanded content
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
                            paragraphMatchesSearch(paragraph) ?
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

    private func paragraphMatchesSearch(_ paragraph: String) -> Bool {
        guard !searchText.isEmpty else { return false }
        return paragraph.lowercased().contains(searchText.lowercased())
    }
}

// MARK: - First Part Category Row

@available(iOS 26.0, *)
private struct FirstPartCategoryRow: View {

    let category: TariffFirstPartCategory
    var searchText: String = ""

    @State private var isExpanded = false
    @Environment(\.theme) var theme

    private var isMatch: Bool {
        guard !searchText.isEmpty else { return false }
        let q = searchText.lowercased()
        return category.title.lowercased().contains(q) ||
               category.tiers.contains {
                   $0.label.lowercased().contains(q) || $0.amount.lowercased().contains(q)
               }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tap header to expand/collapse
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("\(category.number).")
                        .font(theme.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.primary)
                        .frame(width: 24, alignment: .leading)

                    Text(category.title)
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

            // Expanded: fee tiers
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(category.tiers.enumerated()), id: \.offset) { index, tier in
                        let tierMatch = !searchText.isEmpty && (
                            tier.label.lowercased().contains(searchText.lowercased()) ||
                            tier.amount.lowercased().contains(searchText.lowercased())
                        )
                        HStack {
                            Text(tierPrefix(index))
                                .font(theme.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(theme.textTertiary)
                                .frame(width: 22, alignment: .leading)

                            Text(tier.label)
                                .font(theme.caption)
                                .foregroundStyle(theme.textSecondary)

                            Spacer()

                            Text(tier.amount)
                                .font(theme.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(theme.primary)
                        }
                        .padding(.horizontal, theme.spacingM)
                        .padding(.vertical, theme.spacingXS + 2)
                        .background(tierMatch ? theme.primary.opacity(0.06) : Color.clear)

                        if index < category.tiers.count - 1 {
                            Divider()
                                .padding(.leading, theme.spacingM + 22)
                        }
                    }
                }
                .padding(.bottom, theme.spacingS)
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

    private func tierPrefix(_ index: Int) -> String {
        let prefixes = ["aa)", "ab)", "ac)", "ad)"]
        return index < prefixes.count ? prefixes[index] : ""
    }
}
