# VoiceOver Accessibility - Implementation Skill

## Overview

This skill provides the reference patterns and rules for implementing VoiceOver accessibility across all screens in the Denklem app. Follow these patterns exactly when adding accessibility to any view file.

### Target
- App Store "Supports VoiceOver" label compliance
- All common tasks completable with VoiceOver only, without sighted assistance

### Platform
- iOS 26.0+ SwiftUI accessibility APIs only
- 3 languages: Turkish (TR), English (EN), Swedish (SV)
- Localization via existing `LocalizationKeys` system

---

## Apple VoiceOver Evaluation Rules (Must Follow)

1. **All controls must have concise, accurate labels** — labels must make sense out of context
2. **Labels must NOT include control types** — say "Eviction" not "Eviction checkbox" (VoiceOver adds "checkbox" from traits)
3. **Labels must NOT include states** — say "Eviction" not "Eviction, selected" (VoiceOver adds "selected" from traits)
4. **Element type and status/value must be conveyed** via `.accessibilityAddTraits` and `.accessibilityValue`
5. **All visible text must be accessible** to VoiceOver
6. **Decorative images must be completely ignored** — use `.accessibilityHidden(true)`
7. **Status banners and alerts** must be announced via `AccessibilityNotification.Announcement`
8. **Navigation order must be logical** — no skipped items, no loops, no unexpected cursor resets
9. **Grouped elements** should read in intended order — use `.accessibilityElement(children: .combine)`
10. **Modal views** must trap VoiceOver focus — SwiftUI `.sheet` does this automatically
11. **Custom controls** must provide equivalent accessibility to native controls
12. **Screen changes** and new content must move VoiceOver cursor logically

---

## Project-Specific Patterns

### Localization
All accessibility strings must be localized. Use the `LocalizationKeys.Accessibility` struct:

```swift
// Key naming convention
"a11y.general.close"              // General keys
"a11y.general.share"
"a11y.hint.calculate"             // Hints
"a11y.hint.dismiss"
"a11y.value.expanded"             // Values
"a11y.value.collapsed"
"a11y.announce.error"             // Announcements
"a11y.announce.result_loaded"

// Usage
.accessibilityLabel(LocalizationKeys.Accessibility.close.localized)
.accessibilityHint(LocalizationKeys.Accessibility.calculateHint.localized)
```

### Theme Reference
- `@Environment(\.theme) var theme` — for font/color references only, not for accessibility
- `@Environment(\.isAnimatedBackground) var isAnimatedBackground` — decorative, always hidden

### Locale
- `@ObservedObject private var localeManager = LocaleManager.shared`
- `let _ = localeManager.refreshID` — accessibility labels auto-refresh with language change

---

## Code Templates by Element Type

### 1. Icon-Only Buttons (toolbar buttons, icon actions)
```swift
// BEFORE (no accessibility):
Button {
    dismiss()
} label: {
    Image(systemName: "checkmark")
        .font(theme.body)
        .foregroundStyle(theme.textSecondary)
}

// AFTER (with accessibility):
Button {
    dismiss()
} label: {
    Image(systemName: "checkmark")
        .font(theme.body)
        .foregroundStyle(theme.textSecondary)
}
.accessibilityLabel(LocalizationKeys.General.done.localized)
.accessibilityHint(LocalizationKeys.Accessibility.dismissHint.localized)
```

### 2. Text Buttons (CalculateButton, CapsuleButton)
```swift
// SwiftUI Button with Text label — VoiceOver reads the text automatically
// Only add hint if action isn't obvious from label alone
Button(action: { }) {
    Text(LocalizationKeys.General.calculate.localized)
}
.accessibilityHint(LocalizationKeys.Accessibility.calculateHint.localized)
```

### 3. Buttons with Icon + Text (RectangleButton)
```swift
// Combine children so VoiceOver reads as one element
// Hide icon since text conveys meaning
HStack {
    Image(systemName: icon)
        .accessibilityHidden(true)
    Text(title)
}
.accessibilityElement(children: .combine)
```

### 4. TextField / Input Fields
```swift
// TextField placeholder is NOT enough for VoiceOver
// Always add explicit label
TextField(placeholder, text: $text)
    .accessibilityLabel(LocalizationKeys.Input.agreementAmount.localized)
    .accessibilityHint(LocalizationKeys.Accessibility.amountFieldHint.localized)
```

### 5. Segmented Picker (CommonSegmentedPicker)
```swift
// Pass meaningful label — empty label provides no context
Picker(sectionTitle, selection: $selection) {
    ForEach(options) { option in
        Text(option.displayName).tag(option)
    }
}
.pickerStyle(.segmented)
// SwiftUI handles segmented picker accessibility natively when label is provided
```

### 6. Menu / Dropdown
```swift
Menu {
    ForEach(options) { option in
        Button(option.displayName) { select(option) }
    }
} label: {
    Text(selectedOption?.displayName ?? "Select...")
}
.accessibilityLabel(LocalizationKeys.Result.disputeType.localized)
.accessibilityValue(selectedOption?.displayName ?? LocalizationKeys.DisputeType.selectPrompt.localized)
.accessibilityHint(LocalizationKeys.Accessibility.disputeTypeMenuHint.localized)
```

### 7. DetailRow (Label-Value Pair)
```swift
// Combine so VoiceOver reads "Dispute Type: Worker-Employer" as one swipe target
HStack {
    Text(label)
    Spacer()
    Text(value)
}
.accessibilityElement(children: .combine)
```

### 8. Section Headers
```swift
Text(LocalizationKeys.Result.calculationInfo.localized)
    .font(theme.headline)
    .accessibilityAddTraits(.isHeader)
```

### 9. Custom Checkbox (Tenancy pattern)
```swift
// Custom checkbox = Button with checkmark.square.fill/square icon
// Must behave like native toggle for VoiceOver
Button(action: { toggle() }) {
    HStack {
        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .accessibilityHidden(true) // Hide icon — traits convey state
        Text(type.displayName)
    }
}
.accessibilityLabel(type.displayName) // Just the name, NO "checkbox" or "selected"
.accessibilityAddTraits(isSelected ? [.isSelected] : [])
.accessibilityRemoveTraits(isSelected ? [] : [.isSelected])
.accessibilityHint(LocalizationKeys.Accessibility.checkboxHint.localized)
```

### 10. Expand/Collapse Card (Result sheets)
```swift
// Main fee card — tappable to expand/collapse details
VStack {
    Text(feeLabel)
    Text(feeAmount)
}
.accessibilityElement(children: .combine)
.accessibilityAddTraits(.isButton)
.accessibilityHint(LocalizationKeys.Accessibility.mainFeeCardHint.localized)
.accessibilityValue(isExpanded
    ? LocalizationKeys.Accessibility.expanded.localized
    : LocalizationKeys.Accessibility.collapsed.localized)

// Announce state change
.onChange(of: isExpanded) { _, expanded in
    let msg = expanded
        ? LocalizationKeys.Accessibility.detailsExpanded.localized
        : LocalizationKeys.Accessibility.detailsCollapsed.localized
    AccessibilityNotification.Announcement(msg).post()
}
```

### 11. Error Banner Announcement
```swift
// On EVERY screen that shows errors, add this to the view body:
.onChange(of: viewModel.errorMessage) { _, newValue in
    if let msg = newValue {
        AccessibilityNotification.Announcement(msg).post()
    }
}
```

### 12. Result Loaded Announcement
```swift
// When result sheet appears, announce the main result
.onChange(of: viewModel.showResult) { _, isShowing in
    if isShowing, let result = viewModel.calculationResult {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let announcement = "\(LocalizationKeys.Result.mediationFee.localized): \(LocalizationHelper.formatCurrency(result.amount))"
            AccessibilityNotification.Announcement(announcement).post()
        }
    }
}
```

### 13. Decorative Elements — Always Hide
```swift
// Animated background
AnimatedSkyBackground()
    .accessibilityHidden(true)

// Background images
Image("AppStartBackground")
    .accessibilityHidden(true)

// Gradient overlays
LinearGradient(...)
    .accessibilityHidden(true)

// Chevron indicators in list rows
Image(systemName: "chevron.right")
    .accessibilityHidden(true)

// Decorative dividers — SwiftUI Divider() is already ignored by VoiceOver (✓)

// Info icons where text provides the context
Image(systemName: "info.circle.fill")
    .accessibilityHidden(true)
```

### 14. Loading State on Buttons
```swift
// When button shows ProgressView (loading), update accessibility
.accessibilityValue(isCalculating
    ? LocalizationKeys.Accessibility.calculatingStatus.localized
    : "")
```

---

## What NOT to Do

### Wrong: Control type in label
```swift
// ❌ WRONG — VoiceOver will say "Eviction checkbox, checkbox" (redundant)
.accessibilityLabel("Eviction checkbox")

// ✅ CORRECT — VoiceOver says "Eviction, checkbox" (traits add "checkbox")
.accessibilityLabel("Eviction")
.accessibilityAddTraits(isSelected ? [.isSelected] : [])
```

### Wrong: State in label
```swift
// ❌ WRONG — VoiceOver will say "Eviction selected, selected" (redundant)
.accessibilityLabel("Eviction selected")

// ✅ CORRECT — Let traits handle state
.accessibilityLabel("Eviction")
.accessibilityAddTraits(isSelected ? [.isSelected] : [])
```

### Wrong: Verbose hints
```swift
// ❌ WRONG — Too verbose, sounds like a tutorial
.accessibilityHint("Press this button to start the mediation fee calculation process")

// ✅ CORRECT — Concise
.accessibilityHint("Calculates the mediation fee")
```

### Wrong: Label doesn't make sense alone
```swift
// ❌ WRONG — "Click here" is meaningless out of context
.accessibilityLabel("Click here")

// ✅ CORRECT — Clear even without surrounding context
.accessibilityLabel("Calculate")
```

### Wrong: Forgetting to hide decorative elements
```swift
// ❌ WRONG — VoiceOver reads "checkmark square fill" for checkbox icon
Image(systemName: "checkmark.square.fill")

// ✅ CORRECT — Icon hidden, state conveyed via traits
Image(systemName: "checkmark.square.fill")
    .accessibilityHidden(true)
```

### Wrong: Not announcing dynamic changes
```swift
// ❌ WRONG — Error appears but VoiceOver user doesn't know
if let error = viewModel.errorMessage {
    ErrorBannerView(message: error)
}

// ✅ CORRECT — Error announced when it appears
if let error = viewModel.errorMessage {
    ErrorBannerView(message: error)
}
.onChange(of: viewModel.errorMessage) { _, msg in
    if let msg { AccessibilityNotification.Announcement(msg).post() }
}
```

---

## SwiftUI Accessibility API Quick Reference (iOS 26)

| API | Purpose | Example |
|-----|---------|---------|
| `.accessibilityLabel(_:)` | What VoiceOver reads for the element | "Share", "Done", "Mediation Fee" |
| `.accessibilityHint(_:)` | Additional context for the action | "Opens date picker", "Calculates fee" |
| `.accessibilityValue(_:)` | Current value/state | "2026", "Expanded", "₺433.200" |
| `.accessibilityAddTraits(_:)` | Element type/behavior | `.isButton`, `.isHeader`, `.isSelected` |
| `.accessibilityRemoveTraits(_:)` | Remove default traits | Remove `.isSelected` when unchecked |
| `.accessibilityHidden(_:)` | Hide from VoiceOver | Decorative images, icons, backgrounds |
| `.accessibilityElement(children:)` | Group/ignore children | `.combine` for DetailRow, `.ignore` for decorative containers |
| `AccessibilityNotification.Announcement(_:).post()` | Announce dynamic changes | Errors, results, state changes |
| `AccessibilityNotification.LayoutChanged(_:).post()` | Layout changed | When expand/collapse changes visible content |

---

## Files Reference

### Shared Components (modify first — propagates everywhere):
- `Views/Components/Common/DetailRow.swift`
- `Views/Components/Common/CalculateButton.swift`
- `Views/Components/Common/RecalculateButton.swift`
- `Views/Components/Common/ErrorBannerView.swift`
- `Views/Components/Common/YearPickerSection.swift`
- `Views/Components/Common/CommonSegmentedPicker.swift`
- `Views/Components/Common/RectangleButton.swift`
- `Views/Components/Common/CapsuleButton.swift`
- `Views/Components/Common/AnimatedSkyBackground.swift`

### Screens (modify second):
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

### Localization:
- `Localization/LocalizationKeys.swift` — Add `Accessibility` struct
- `Localizable.xcstrings` — Add translations (TR, EN, SV)
