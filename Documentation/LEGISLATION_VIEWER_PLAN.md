# Legislation Viewer – 2025/2027 Attorney Tariffs, Text Selection & Find-in-Document

## Goals

1. Add the **2025** and **2027** Avukatlık Asgari Ücret Tarifesi to the Legislation screen (in-app content, like 2026).
2. Allow **selecting any part of an article's text** (word, sentence, paragraph) and copying a whole article.
3. Replace the "expand every matching article" search with a **find-in-document** experience:
   only the matched words are highlighted, results can be stepped through (`2 / 14  ˄ ˅`),
   and only the article containing the current result is opened.

## Findings (before)

| Area | Problem |
|------|---------|
| Content | `AttorneyFeeTariffContent.content(for:)` only returns 2026 |
| 2026 content | Three table rows abbreviated vs. official text (2.1/1, 1.2/6, 2.2/18c) |
| Selection | Paragraphs are plain SwiftUI `Text` → nothing can be selected on iOS |
| Search | Every matching article auto-expands; whole paragraph gets a faint background, the word itself is not marked |
| Search | `lowercased().contains()` fails on Turkish capitals: "icra" ≠ "İcra", "ucret" ≠ "Ücret" |
| Code | `ArticleRow`, `AttorneyFeeArticleRow`, `LawArticleRow` are three copies of the same view |

## Design

### Content
- `AttorneyFeeTariffContent2025.swift`, `AttorneyFeeTariffContent2027.swift` (separate files, generated from the verified `Documentation/*_AVUKATLIK_ASGARI_UCRET_TARIFESI.md`).
- `content(for:)` → 2025 / 2026 / 2027.
- `LegislationViewModel` gets two new `.attorneyTariff` documents (year 2027 and 2025).

### Shared components (`LegislationDocumentComponents.swift`)
- `DocumentSearch` – matching helper: case + diacritic insensitive, `ı`→`i` folding (length preserving, so `NSRange`s stay valid).
- `DocumentSearchBlock` / `DocumentSearchMatch` – every searchable text unit has a stable block ID; a match = (blockID, groupID, local index).
- `EnvironmentValues.documentSearch` – query + active match, read by every text view (no parameter threading).
- `SelectableText` – `UITextView` wrapper (non-editable, non-scrolling) → native range selection, Copy / Look Up / Translate / Share, match highlighting.
- `HighlightedText` – SwiftUI `Text` with `AttributedString` highlights (titles, table cells).
- `DocumentCollapsibleRow` – one implementation of the expandable row; opens itself when the active match is inside it and closes again when the match moves on (unless the user opened it).
- `DocumentArticleRow` – article row used by all three document views; includes "Copy Article".
- `DocumentSearchNavigator` – bottom bar: result counter + previous / next.

### Search flow (`DocumentDetailSheet`)
1. Query changes → matches recomputed from the content's `searchBlocks` (display order).
2. First match becomes active → its group expands → `ScrollViewReader` scrolls to the block.
3. ˄ / ˅ or keyboard *Search* key → previous / next match (wraps around).
4. Collapsed rows that contain matches show a small badge with the match count.

### Highlight colours
- All matches: yellow @ 35 %.
- Current match: yellow @ 90 % with black text (readable in light and dark mode).

## Localization (en / sv / tr)
- `legislation.attorney_tariff.2025.title/subtitle`, `legislation.attorney_tariff.2027.title/subtitle`
- `legislation.article.copy`, `legislation.article.copied`
- `legislation.document.search.no_results`
- `a11y.label.previous_result`, `a11y.label.next_result`, `a11y.label.search_result_position`, `a11y.label.search_match_count`

## Out of scope (later)
- Using 2025 / 2027 values in the attorney fee **calculation** (separate step).
