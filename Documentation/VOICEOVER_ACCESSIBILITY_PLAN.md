# VoiceOver Accessibility Implementation Plan

## Context
Denklem uygulamasında VoiceOver desteği neredeyse hiç yok. Tüm projede sadece 3 adet `.accessibilityLabel` mevcut (SMMCalculationView ve TimeCalculationView'daki dismiss butonlarında). Görme engelli avukat ve arabulucuların uygulamayı kullanabilmesi için kapsamlı VoiceOver desteği eklenmesi gerekiyor. Hedef: App Store'da "Supports VoiceOver" etiketi koyabilecek seviyeye ulaşmak.

---

## Apple VoiceOver Evaluation Criteria (Key Rules)

### VoiceOver-Specific
1. **All controls must have concise, accurate labels** — labels should make sense out of context
2. **Labels must NOT include control types** — "Unsubscribe" not "Unsubscribe checkbox" (traits handle that)
3. **Element type and status/value must be conveyed** via traits and accessibilityValue
4. **All visible text must be accessible** to VoiceOver
5. **Decorative images must be completely ignored** by VoiceOver
6. **Status banners and alerts** must be announced via AccessibilityNotification
7. **Navigation order must be logical** — no skipped items, no loops, no unexpected cursor resets
8. **Grouped elements** should read in intended order (combine related label+value pairs)
9. **Modal views** must trap VoiceOver focus — inactive background content must not be accessible
10. **Custom controls** (checkboxes, expand/collapse) must provide equivalent accessibility to native controls
11. **All common tasks completable** with VoiceOver only, without sighted assistance
12. **Screen changes** and new content must move VoiceOver cursor logically

### Broader Accessibility (Apple Guidelines)
13. **Dynamic Type**: Support text enlargement at least 200%. Use system text styles or @ScaledMetric for fixed sizes. Min font: 11pt iOS.
14. **Color contrast**: WCAG AA minimum — 4.5:1 for text up to 17pt, 3:1 for 18pt+ or bold text
15. **Don't convey info with color alone**: Use icons/shapes in addition to color for status
16. **Minimum control size**: 44×44pt (iOS recommended), 28×28pt absolute minimum. Already defined in `AppConstants.Accessibility`.
17. **Simple gestures**: Prefer system gestures over custom multi-finger gestures
18. **Reduce Motion**: Respond to `UIAccessibility.isReduceMotionEnabled` — reduce AnimatedSkyBackground and staggered reveal animations
19. **Full Keyboard Access**: Don't override system keyboard shortcuts
20. **Accessibility Nutrition Labels**: Evaluate for App Store Connect after implementation

---

## Approach
- **Step-by-step**: Each phase implemented separately, build & test with VoiceOver before proceeding
- Shared components first (highest impact — one fix propagates everywhere)
- All accessibility strings localized via existing LocalizationKeys system (TR, EN, SV)
- iOS 26 SwiftUI accessibility APIs only
- VoiceOver only — no accessibilityIdentifier (UI test IDs deferred to future)
- Test on physical device with VoiceOver (Simulator unreliable for glass effects)
- Labels: concise, no control type words, context-independent
- Hints: only when action isn't obvious from label alone

---

## Phase 0: Foundation — New Localization Keys

**File:** `Localization/LocalizationKeys.swift` — Add `Accessibility` struct inside `LocalizationKeys`

New keys needed (~50-60 keys across 3 languages):
- General: close, share, dismiss hint, calculate hint, recalculate hint, calculating status, error banner
- Year picker: hint, value template
- Expand/collapse: hint, expanded/collapsed state
- Checkboxes: toggle hint
- Survey: question counter, correct/wrong announcements
- Screen-specific hints for buttons and menus

**File:** `Localizable.xcstrings` — Add translations for all new keys (TR, EN, SV)

---

## Phase 1: Shared Components (8 files — highest impact)

### 1A. `DetailRow.swift`
```swift
.accessibilityElement(children: .combine)
```
Single line — makes every result sheet read "Label: Value" as one unit instead of two swipe targets. Apple criteria: "grouped elements should read in intended order."

### 1B. `CalculateButton.swift`
```swift
.accessibilityHint(LocalizationKeys.Accessibility.calculateButtonHint.localized)
.accessibilityValue(isCalculating ? LocalizationKeys.Accessibility.calculatingStatus.localized : "")
```
Apple criteria: "control status/value must be conveyed" — loading state needs to be announced.

### 1C. `RecalculateButton.swift`
```swift
.accessibilityHint(LocalizationKeys.Accessibility.recalculateButtonHint.localized)
```

### 1D. `ErrorBannerView.swift`
```swift
.accessibilityElement(children: .combine)
```
Plus on each screen where errorMessage changes:
```swift
.onChange(of: viewModel.errorMessage) { _, newValue in
    if let msg = newValue {
        AccessibilityNotification.Announcement(msg).post()
    }
}
```
Apple criteria: "Temporary status banners should be conveyed via AccessibilityNotification."

### 1E. `YearPickerSection.swift`
```swift
.accessibilityLabel(LocalizationKeys.Result.tariffYear.localized)
.accessibilityValue(selectedYear.displayName)
.accessibilityHint(LocalizationKeys.Accessibility.yearPickerHint.localized)
```

### 1F. `CommonSegmentedPicker.swift`
Add `accessibilityLabel` parameter to pass section title (e.g., "Dispute Subject", "Agreement Status"). Picker with empty label provides no context to VoiceOver user.

### 1G. `RectangleButton.swift` & `CapsuleButton.swift`
- Icon inside: `.accessibilityHidden(true)` (text conveys meaning, icon is decorative)
- Ensure `.accessibilityElement(children: .combine)` on HStack
- Apple criteria: "decorative images must be completely ignored"

### 1H. `AnimatedSkyBackground.swift`
```swift
.accessibilityHidden(true)
```
Purely decorative Canvas content — one line. Apple criteria: "decorative images ignored."

---

## Phase 2: Screen-by-Screen Implementation

### 2A. StartScreenView
- Background image: `.accessibilityHidden(true)`
- Gradient overlay: `.accessibilityHidden(true)`
- App title: `.accessibilityAddTraits(.isHeader)`
- Survey button (icon-only): `.accessibilityLabel("Survey")` + `.accessibilityHint("Opens legal quiz")`
- Enter button: `.accessibilityLabel` + `.accessibilityHint`
- Apple criteria: icon-only buttons MUST have labels

### 2B. DisputeCategoryView
- Main mediation fee button: `.accessibilityHint`
- Section titles: `.accessibilityAddTraits(.isHeader)`
- RectangleButtons: Inherit from Phase 1
- Animated background: Already hidden from Phase 1

### 2C. MediationFeeView
- Section labels: `.accessibilityAddTraits(.isHeader)`
- Segmented pickers: Pass label via CommonSegmentedPicker (Phase 1F)
- Dispute type Menu: `.accessibilityLabel` + `.accessibilityValue(selectedType)` + `.accessibilityHint`
- Amount TextField: `.accessibilityLabel(agreementAmount)` + `.accessibilityHint`
- Party Count TextField: `.accessibilityLabel(partyCount)` + `.accessibilityHint`
- Error announcement: `.onChange(of: errorMessage)` → `AccessibilityNotification.Announcement`
- Result announcement: `.onChange(of: showResult)` → announce fee amount
- Apple criteria: "text fields should have a label in addition to the text value"

### 2D. MediationFeeResultSheet (most complex)
- Share button: `.accessibilityLabel("Share")` + `.accessibilityHint("Exports calculation as text file")`
- Close button: `.accessibilityLabel("Done")` + `.accessibilityHint("Closes result")`
- Main fee card:
  - `.accessibilityElement(children: .combine)` — reads "Mediation Fee: ₺433.200,00"
  - `.accessibilityAddTraits(.isButton)` — indicates tappable
  - `.accessibilityHint("Tap to show or hide details")`
  - `.accessibilityValue(isExpanded ? "Expanded" : "Collapsed")`
- Card headers: `.accessibilityAddTraits(.isHeader)`
- DetailRows: Auto-combined from Phase 1
- Bracket step rows: `.accessibilityElement(children: .combine)`
- Info icon (info.circle.fill): `.accessibilityHidden(true)`
- Expand/collapse announcement:
  ```swift
  .onChange(of: isExpanded) { _, expanded in
      let msg = expanded ? "Details expanded" : "Details collapsed"
      AccessibilityNotification.Announcement(msg).post()
  }
  ```
- Apple criteria: "custom controls must provide equivalent accessibility to native controls"
- Sheet modal: SwiftUI `.sheet` already traps VoiceOver focus (✓)

### 2E. AttorneyFeeView + AttorneyFeeResultSheet
Same patterns as MediationFee. Court type picker menu gets `.accessibilityLabel` + `.accessibilityValue`.

### 2F. TenancySelectionView (custom checkboxes — critical)
Custom checkbox is a Button with checkmark.square.fill/square icon. Must behave like native toggle:
- Checkbox icon: `.accessibilityHidden(true)` — don't say "checkmark square fill"
- Checkbox button:
  - `.accessibilityLabel(type.displayName)` — e.g., "Eviction"
  - `.accessibilityAddTraits(isSelected ? [.isSelected] : [])` — VoiceOver says "selected" automatically
  - `.accessibilityHint("Double tap to toggle")`
  - NO "checkbox" or "selected" in the label text — traits handle it
- Conditional TextFields: `.accessibilityLabel`
- Two result sheets: Same pattern as MediationFeeResultSheet
- Apple criteria: "labels must NOT include control types — traits handle that"

### 2G. SerialDisputesSheet + ResultView
Standard input form pattern — labels, hints, values on fields and menus.

### 2H. ReinstatementSheet + ResultView
Same pattern. 3 TextFields for agreement, 1 for non-agreement — each gets label + hint.

### 2I. TimeCalculationView
- Date button: `.accessibilityLabel("Assignment Date")` + `.accessibilityValue(formattedDate)` + `.accessibilityHint("Opens date picker")`
- Result cards: `.accessibilityElement(children: .combine)` per dispute type
- Already has 2 `.accessibilityLabel` on dismiss buttons (keep)

### 2J. SMMCalculationView + ResultSheet
- Amount field + calculation type menu: labels + hints
- Result section headers: `.accessibilityAddTraits(.isHeader)`
- Already has 1 `.accessibilityLabel` on dismiss button (keep)

### 2K. LegislationView
- Search field: SwiftUI `searchable` handles accessibility natively (✓)
- Filter chips: `.accessibilityAddTraits(.isSelected)` when active
- Document cards: `.accessibilityElement(children: .combine)` + `.accessibilityHint("Opens document")`
- Chevron icons: `.accessibilityHidden(true)` — decorative navigation indicator
- Context menu: SwiftUI handles natively (✓)

### 2L. AboutView
- Settings pickers (language, theme): SwiftUI Picker handles natively (✓)
- Animation toggle: SwiftUI Toggle handles natively (✓)
- Section item rows: `.accessibilityElement(children: .combine)`
- Chevron icons: `.accessibilityHidden(true)`
- Popover triggers: `.accessibilityHint` where action isn't obvious
- Popovers: SwiftUI handles focus trapping natively (✓)

### 2M. SurveyView
- Question counter: `.accessibilityLabel("Question 1 of 2")` — meaningful label
- Option buttons: `.accessibilityLabel(optionLetter + ": " + title)` — e.g., "a: Correct answer"
- Answer feedback: `AccessibilityNotification.Announcement` (correct/wrong + explanation)
- Disabled options after answer: Traits auto-update for disabled buttons (✓)
- Thank you card: `.accessibilityElement(children: .combine)`
- Email button: Keep context menu accessible (SwiftUI handles ✓)

---

## Phase 3: LiquidGlassText Accessibility (safety net)
Currently unused, but if re-enabled: always pair with `.accessibilityLabel` since CoreText glyph paths are invisible to VoiceOver. Apple criteria: "all visible text must be accessible."

---

## Files to Modify

### New/Extended:
- `Localization/LocalizationKeys.swift` — Add Accessibility struct
- `Localizable.xcstrings` — Add ~50-60 keys × 3 languages

### Shared Components (8):
- `Views/Components/Common/DetailRow.swift`
- `Views/Components/Common/CalculateButton.swift`
- `Views/Components/Common/RecalculateButton.swift`
- `Views/Components/Common/ErrorBannerView.swift`
- `Views/Components/Common/YearPickerSection.swift`
- `Views/Components/Common/CommonSegmentedPicker.swift`
- `Views/Components/Common/RectangleButton.swift` & `CapsuleButton.swift`
- `Views/Components/Common/AnimatedSkyBackground.swift`

### Screens (~20):
- `Views/Screens/StartScreen/StartScreenView.swift`
- `Views/Screens/DisputeCategory/DisputeCategoryView.swift`
- `Views/Screens/MediationFee/MediationFeeView.swift`
- `Views/Screens/MediationFee/MediationFeeResultSheet.swift`
- `Views/Screens/AttorneyFee/AttorneyFeeView.swift`
- `Views/Screens/AttorneyFee/AttorneyFeeResultSheet.swift`
- `Views/Screens/TenancySpecial/TenancySelectionView.swift`
- `Views/Screens/TenancySpecial/TenancyAttorneyFeeResultSheet.swift`
- `Views/Screens/TenancySpecial/TenancyMediationFeeResultSheet.swift`
- `Views/Screens/SerialDisputes/SerialDisputesSheet.swift`
- `Views/Screens/SerialDisputes/SerialDisputesResultView.swift`
- `Views/Screens/Reinstatement/ReinstatementSheet.swift`
- `Views/Screens/Reinstatement/ReinstatementResultView.swift`
- `Views/Screens/TimeCalculation/TimeCalculationView.swift`
- `Views/Screens/SMMCalculation/SMMCalculationView.swift`
- `Views/Screens/Legislation/LegislationView.swift`
- `Views/Screens/About/AboutView.swift`
- `Views/Screens/Survey/SurveyView.swift`

---

## Testing Strategy (Per Phase)

### VoiceOver Testing Checklist (Apple Criteria Based):
1. **Navigate forward** through all elements (swipe right) — no skipped items, no loops
2. **Navigate backward** through all elements (swipe left) — same check
3. **Activate** every interactive element (double-tap) — same result as visual tap
4. **Labels are concise** — no "button", "checkbox" words in labels
5. **Status/value conveyed** — selected states, loading states, expanded/collapsed
6. **Decorative items hidden** — backgrounds, dividers, chevrons not announced
7. **Error announcements fire** — validation errors spoken automatically
8. **Modal focus trapped** — result sheets don't allow navigating to background
9. **Screen Curtain test** — complete full calculation flow with screen off
10. **All 3 languages** — test TR, EN, SV labels

### Tools:
- **Physical device** with VoiceOver (Settings > Accessibility > VoiceOver)
- **Accessibility Inspector** in Xcode (Xcode > Open Developer Tool > Accessibility Inspector)
- **Screen Curtain** (three-finger triple-tap) — final validation

### Final Validation:
Complete these tasks with VoiceOver only, Screen Curtain on:
1. Open app → navigate to Mediation Fee → calculate → read result → dismiss
2. Open Attorney Fee → select court type → calculate → share result
3. Open Tenancy → toggle checkboxes → enter amounts → calculate
4. Open Legislation → search → open document
5. Change language in Settings → verify labels update
6. Complete Survey quiz

---

## Apple Accessibility Reference Links
- VoiceOver: Supporting VoiceOver in your app
- Performing accessibility testing for your app
- VoiceOver evaluation criteria
- Accessibility Nutrition Labels (App Store Connect)
- Dynamic Type: Supporting Dynamic Type
- Color contrast: WCAG Level AA (4.5:1 / 3:1)
- Reduce Motion: UIAccessibility.isReduceMotionEnabled
