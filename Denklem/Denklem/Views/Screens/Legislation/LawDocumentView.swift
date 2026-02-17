//
//  LawDocumentView.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import SwiftUI

// MARK: - Law Document View
/// Displays the full law document content with native SwiftUI rendering
/// Shows articles as collapsible sections
@available(iOS 26.0, *)
struct LawDocumentView: View {

    // MARK: - Properties

    let content: LawDocumentContent
    var searchText: String = ""

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
            LawSectionTitle(title: NSLocalizedString("legislation.law.section.articles", value: "Kanun Maddeleri", comment: ""))

            VStack(spacing: 0) {
                ForEach(Array(content.articles.enumerated()), id: \.offset) { index, article in
                    LawArticleRow(article: article, searchText: searchText)

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

// MARK: - Law Section Title

@available(iOS 26.0, *)
private struct LawSectionTitle: View {

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

// MARK: - Law Article Row

@available(iOS 26.0, *)
private struct LawArticleRow: View {

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
                        .frame(minWidth: 65, alignment: .leading)

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
