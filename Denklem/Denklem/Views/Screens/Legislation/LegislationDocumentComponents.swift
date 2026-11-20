//
//  LegislationDocumentComponents.swift
//  Denklem
//
//  Created by ozkan on 20.11.2026.
//

import SwiftUI
import UIKit

// MARK: - Search Model

/// A searchable unit of text inside a legislation document (paragraph, title, table cell...)
struct DocumentSearchBlock {
    /// Stable identifier, also used as the scroll target of the rendered text
    let id: String
    /// Collapsible container (article / category) that must be open to show this block
    let groupID: String?
    let text: String
}

/// A single search hit inside a document
struct DocumentSearchMatch: Equatable {
    let blockID: String
    let groupID: String?
    /// Index of the occurrence within its block
    let localIndex: Int
}

/// Search state shared with every text view of the open document
struct DocumentSearchContext: Equatable {
    var query: String = ""
    var activeMatch: DocumentSearchMatch?

    var isSearching: Bool { DocumentSearch.normalizedQuery(query) != nil }

    /// Returns the active occurrence index if the active match lives in the given block
    func activeIndex(in blockID: String) -> Int? {
        guard let activeMatch, activeMatch.blockID == blockID else { return nil }
        return activeMatch.localIndex
    }
}

extension EnvironmentValues {
    /// Find-in-document state, injected by `DocumentDetailSheet`
    @Entry var documentSearch = DocumentSearchContext()
}

// MARK: - Search Matching

/// Text matching used by the legislation document viewer
enum DocumentSearch {

    /// Trimmed query, or nil when there is nothing to search for
    static func normalizedQuery(_ query: String) -> String? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    /// Folds the dotless "ı" to "i" so "danistay" also finds "Danıştay".
    /// Both characters are a single UTF-16 unit, so ranges stay valid for the original text.
    private static func fold(_ text: String) -> String {
        text.replacingOccurrences(of: "ı", with: "i")
    }

    /// All occurrences of `query` in `text` (case and diacritic insensitive: "icra" → "İcra", "ucret" → "Ücret")
    static func ranges(of query: String, in text: String) -> [NSRange] {
        guard let needle = normalizedQuery(query).map(fold) else { return [] }
        let haystack = fold(text) as NSString
        var result: [NSRange] = []
        var searchRange = NSRange(location: 0, length: haystack.length)

        while searchRange.length > 0 {
            let found = haystack.range(
                of: needle,
                options: [.caseInsensitive, .diacriticInsensitive],
                range: searchRange
            )
            guard found.location != NSNotFound, found.length > 0 else { break }
            result.append(found)
            let next = found.location + found.length
            searchRange = NSRange(location: next, length: haystack.length - next)
        }
        return result
    }

    /// All matches of `query` across `blocks`, in display order
    static func matches(of query: String, in blocks: [DocumentSearchBlock]) -> [DocumentSearchMatch] {
        guard normalizedQuery(query) != nil else { return [] }
        return blocks.flatMap { block in
            ranges(of: query, in: block.text).indices.map {
                DocumentSearchMatch(blockID: block.id, groupID: block.groupID, localIndex: $0)
            }
        }
    }

    /// Total number of occurrences of `query` in `texts`
    static func count(of query: String, in texts: [String]) -> Int {
        texts.reduce(0) { $0 + ranges(of: query, in: $1).count }
    }
}

// MARK: - Block IDs

/// Identifiers shared by all article-based documents
enum DocumentBlockID {
    static func article(_ index: Int) -> String { "article-\(index)" }
    static func articleTitle(_ index: Int) -> String { "article-\(index)-title" }
    static func articleParagraph(_ index: Int, _ paragraph: Int) -> String { "article-\(index)-p\(paragraph)" }
}

extension DocumentSearchBlock {
    /// Search blocks of one article (title + paragraphs), grouped under the article row
    static func article(index: Int, title: String, paragraphs: [String]) -> [DocumentSearchBlock] {
        let group = DocumentBlockID.article(index)
        var blocks = [DocumentSearchBlock(id: DocumentBlockID.articleTitle(index), groupID: group, text: title)]
        for (pIndex, paragraph) in paragraphs.enumerated() {
            blocks.append(DocumentSearchBlock(id: DocumentBlockID.articleParagraph(index, pIndex), groupID: group, text: paragraph))
        }
        return blocks
    }
}

// MARK: - Highlight Colors

/// Find-in-page style colors (readable in light and dark mode)
private enum DocumentHighlight {
    static let match = UIColor.systemYellow.withAlphaComponent(0.35)
    static let active = UIColor.systemYellow.withAlphaComponent(0.9)
    static let activeText = UIColor.black
}

// MARK: - Highlighted Text

/// SwiftUI `Text` that marks the current search query inside `text`
/// Also acts as the scroll target for its block
@available(iOS 26.0, *)
struct HighlightedText: View {

    let text: String
    let blockID: String

    @Environment(\.documentSearch) private var search

    var body: some View {
        Text(attributedText)
            .id(blockID)
    }

    private var attributedText: AttributedString {
        var attributed = AttributedString(text)
        guard search.isSearching else { return attributed }

        let activeIndex = search.activeIndex(in: blockID)
        for (index, nsRange) in DocumentSearch.ranges(of: search.query, in: text).enumerated() {
            guard let range = Range(nsRange, in: text),
                  let lower = AttributedString.Index(range.lowerBound, within: attributed),
                  let upper = AttributedString.Index(range.upperBound, within: attributed) else { continue }

            let isActive = index == activeIndex
            attributed[lower..<upper].backgroundColor = Color(isActive ? DocumentHighlight.active : DocumentHighlight.match)
            if isActive {
                attributed[lower..<upper].foregroundColor = Color(DocumentHighlight.activeText)
            }
        }
        return attributed
    }
}

// MARK: - Selectable Text

/// Paragraph text that supports native range selection (word, sentence, any part)
/// with the system Copy / Look Up / Translate / Share menu, plus search highlighting
@available(iOS 26.0, *)
struct SelectableText: View {

    let text: String
    let blockID: String
    var fontSize: CGFloat = 12
    var textColor: Color

    @Environment(\.documentSearch) private var search
    @Environment(\.theme) private var theme

    var body: some View {
        SelectableTextView(attributedText: attributedText, tintColor: UIColor(theme.primary))
            .id(blockID)
    }

    private var attributedText: NSAttributedString {
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor(textColor)
            ]
        )
        guard search.isSearching else { return attributed }

        let activeIndex = search.activeIndex(in: blockID)
        for (index, range) in DocumentSearch.ranges(of: search.query, in: text).enumerated() {
            if index == activeIndex {
                attributed.addAttributes([
                    .backgroundColor: DocumentHighlight.active,
                    .foregroundColor: DocumentHighlight.activeText
                ], range: range)
            } else {
                attributed.addAttribute(.backgroundColor, value: DocumentHighlight.match, range: range)
            }
        }
        return attributed
    }
}

/// Non-editable, non-scrolling `UITextView` sized by SwiftUI
private struct SelectableTextView: UIViewRepresentable {

    let attributedText: NSAttributedString
    let tintColor: UIColor

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = []
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.tintColor = tintColor
        // Only replace the text when it changed, so an active selection is not lost
        if !textView.attributedText.isEqual(to: attributedText) {
            textView.attributedText = attributedText
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        if let width = proposal.width, width.isFinite {
            let fitting = uiView.sizeThatFits(CGSize(width: max(width, 1), height: .greatestFiniteMagnitude))
            return CGSize(width: width, height: ceil(fitting.height))
        }
        // Unconstrained width: natural (single line) size
        let natural = uiView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude))
        return CGSize(width: ceil(natural.width), height: ceil(natural.height))
    }
}

// MARK: - Section Title

/// Bold section title used inside document views
@available(iOS 26.0, *)
struct DocumentSectionTitle: View {

    let title: String
    /// Search block ID; nil for static UI titles that are not part of the document text
    var blockID: String?

    @Environment(\.theme) private var theme

    var body: some View {
        Group {
            if let blockID {
                HighlightedText(text: title, blockID: blockID)
            } else {
                Text(title)
            }
        }
        .font(theme.subheadline)
        .fontWeight(.bold)
        .foregroundStyle(theme.textPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, theme.spacingS)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Collapsible Row

/// Expandable row used for articles and fee categories.
/// Opens itself when the active search match is inside it and closes again
/// when the match moves on — unless the user opened it manually.
@available(iOS 26.0, *)
struct DocumentCollapsibleRow<Header: View, Content: View>: View {

    let groupID: String
    /// Number of search matches inside the row (shown as a badge while collapsed)
    let matchCount: Int
    @ViewBuilder let header: (_ isExpanded: Bool) -> Header
    @ViewBuilder let content: () -> Content

    @State private var isExpanded = false
    @State private var openedBySearch = false
    @Environment(\.documentSearch) private var search
    @Environment(\.theme) private var theme

    private var containsActiveMatch: Bool {
        search.activeMatch?.groupID == groupID
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                openedBySearch = false
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
                let message = isExpanded
                    ? LocalizationKeys.Accessibility.detailsExpanded.localized
                    : LocalizationKeys.Accessibility.detailsCollapsed.localized
                AccessibilityNotification.Announcement(message).post()
            } label: {
                HStack {
                    header(isExpanded)

                    Spacer(minLength: theme.spacingXS)

                    if matchCount > 0 && !isExpanded {
                        matchBadge
                    }

                    Image(systemName: "chevron.right")
                        .font(theme.caption2)
                        .foregroundStyle(theme.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .accessibilityHidden(true)
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.vertical, theme.spacingS + 2)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(isExpanded ? LocalizationKeys.Accessibility.expanded.localized : LocalizationKeys.Accessibility.collapsed.localized)
            .accessibilityHint(LocalizationKeys.Accessibility.expandCollapseHint.localized)

            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: containsActiveMatch, initial: true) { _, contains in
            if contains && !isExpanded {
                // Opened without animation so the scroll target exists right away
                isExpanded = true
                openedBySearch = true
            } else if !contains && openedBySearch {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded = false
                }
                openedBySearch = false
            }
        }
    }

    private var matchBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "magnifyingglass")
            Text(verbatim: String(matchCount))
        }
        .font(theme.caption2)
        .fontWeight(.semibold)
        .foregroundStyle(theme.primary)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Capsule().fill(theme.primary.opacity(0.1)))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LocalizationKeys.Accessibility.searchMatchCount.localized(matchCount))
    }
}

// MARK: - Article Row

/// Article (madde) row shared by tariff, attorney fee tariff and law documents.
/// Paragraph text is selectable; the whole article can be copied with one tap.
@available(iOS 26.0, *)
struct DocumentArticleRow: View {

    let index: Int
    let number: String
    let title: String
    let paragraphs: [String]

    @State private var didCopy = false
    @Environment(\.documentSearch) private var search
    @Environment(\.theme) private var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    private var matchCount: Int {
        guard search.isSearching else { return 0 }
        return DocumentSearch.count(of: search.query, in: [title] + paragraphs)
    }

    var body: some View {
        DocumentCollapsibleRow(groupID: DocumentBlockID.article(index), matchCount: matchCount) { isExpanded in
            Text("Madde \(number)")
                .font(theme.caption)
                .fontWeight(.bold)
                .foregroundStyle(theme.primary)
                .frame(minWidth: 65, alignment: .leading)

            HighlightedText(text: title, blockID: DocumentBlockID.articleTitle(index))
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .lineLimit(isExpanded ? nil : 1)
                .multilineTextAlignment(.leading)
        } content: {
            VStack(alignment: .leading, spacing: theme.spacingS) {
                ForEach(Array(paragraphs.enumerated()), id: \.offset) { pIndex, paragraph in
                    HStack(alignment: .top, spacing: theme.spacingXS) {
                        Text("(\(pIndex + 1))")
                            .font(theme.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(theme.primary)
                            .frame(width: 24, alignment: .leading)

                        SelectableText(
                            text: paragraph,
                            blockID: DocumentBlockID.articleParagraph(index, pIndex),
                            textColor: theme.textSecondary
                        )
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, theme.spacingXS)
                }

                copyButton
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.bottom, theme.spacingM)
        }
    }

    // MARK: Copy Article

    private var copyButton: some View {
        HStack {
            Spacer()

            Button {
                UIPasteboard.general.string = plainText
                didCopy = true
                AccessibilityNotification.Announcement(LocalizationKeys.Legislation.articleCopied.localized).post()
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1.5))
                    didCopy = false
                }
            } label: {
                Label(
                    didCopy ? LocalizationKeys.Legislation.articleCopied.localized : LocalizationKeys.Legislation.copyArticle.localized,
                    systemImage: didCopy ? "checkmark" : "doc.on.doc"
                )
                .font(theme.caption)
                .fontWeight(.medium)
                .foregroundStyle(theme.primary)
                .contentTransition(.symbolEffect(.replace))
                .contentShape(Rectangle())
            }
            .buttonStyle(.glass(isAnimatedBackground ? .clear : .regular))
            .controlSize(.small)
        }
        .padding(.top, theme.spacingXS)
    }

    /// Article as plain text: "MADDE 1 – Title" followed by numbered paragraphs
    private var plainText: String {
        var text = "MADDE \(number) – \(title)\n"
        for (pIndex, paragraph) in paragraphs.enumerated() {
            text += "\n(\(pIndex + 1)) \(paragraph)\n"
        }
        return text
    }
}

// MARK: - Search Navigator

/// Find bar shown while searching: result counter with previous / next buttons
@available(iOS 26.0, *)
struct DocumentSearchNavigator: View {

    /// Zero-based index of the active match
    let currentIndex: Int
    let total: Int
    let onPrevious: () -> Void
    let onNext: () -> Void

    @Environment(\.theme) private var theme
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    var body: some View {
        HStack(spacing: theme.spacingS) {
            Group {
                if total == 0 {
                    Text(LocalizationKeys.Legislation.searchNoResults.localized)
                } else {
                    Text(verbatim: "\(currentIndex + 1) / \(total)")
                        .monospacedDigit()
                        .accessibilityLabel(LocalizationKeys.Accessibility.searchResultPosition.localized(currentIndex + 1, total))
                }
            }
            .font(theme.footnote)
            .fontWeight(.medium)
            .foregroundStyle(theme.textSecondary)
            .padding(.leading, theme.spacingS)

            navigationButton(systemImage: "chevron.up", label: LocalizationKeys.Accessibility.previousResult.localized, action: onPrevious)
            navigationButton(systemImage: "chevron.down", label: LocalizationKeys.Accessibility.nextResult.localized, action: onNext)
        }
        .padding(.horizontal, theme.spacingS)
        .padding(.vertical, theme.spacingXS)
        .glassEffect(isAnimatedBackground ? .clear : .regular, in: Capsule())
    }

    private func navigationButton(systemImage: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(theme.body)
                .fontWeight(.semibold)
                .foregroundStyle(total > 1 ? theme.primary : theme.textTertiary)
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(total < 2)
        .accessibilityLabel(label)
    }
}
