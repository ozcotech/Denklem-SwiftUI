# Denklem AI - Guided Chat Feature Implementation Plan

## Context

The Denklem app needs a chat-based calculation interface ("Denklem AI"). After evaluating two approaches:

1. **Free-text NLP** (original plan) — User types natural language, system parses with keyword dictionaries
2. **Guided Form Chat** (current plan) — Bot asks structured questions step-by-step, user responds with buttons or simple text

**Decision: Guided Form Chat** was chosen because:
- **Near-zero error rate** — User selects from predefined options, no parsing ambiguity
- **No Turkish NLP complexity** — Turkish suffix system (anlaştık/anlaşmadık/anlaşamamış...) makes rule-based NLP unreliable
- **Lower development cost** — No NLP parser, intent recognizer, or keyword dictionaries needed
- **Better first impression** — "Anlayamadım" errors on first use would drive users away
- **Expandable** — Free-text support can be layered on top later (Phase 2+)

### Critical Principle
The chat feature **NEVER** performs calculations. It only:
1. Collects structured parameters via guided questions
2. Calls **existing** calculators (`TariffCalculator`, `AttorneyFeeCalculator`)
3. Displays results in a conversational format

---

## Architecture: State Machine Chat

The chat is a **state machine** — each state represents a question, user input advances to the next state:

```
welcome → selectCalculationType → selectDisputeType → selectMonetaryType → selectAgreement → enterAmount/enterPartyCount → calculating → result → askAgain
```

### Chat Flow Example (Mediation Fee - Agreement)

```
Bot:  "Merhaba! Hesaplamaya başlayalım."
Bot:  "Hangi hesaplama türünü yapmak istersiniz?"
      [Arabuluculuk Ücreti] [Avukatlık Ücreti]
User: taps "Arabuluculuk Ücreti"

Bot:  "Uyuşmazlık türünüz hangisi?"
      [İş Hukuku] [Ticari] [Tüketici] [Kira] ...
User: taps "İş Hukuku"

Bot:  "Konusu para olan mı, para olmayan mı?"
      [Para Olan] [Para Olmayan]
User: taps "Para Olan"

Bot:  "Anlaşma sağlandı mı?"
      [Evet] [Hayır]
User: taps "Evet"

Bot:  "Anlaşma miktarını giriniz:"
User: types "250000"

Bot:  "Hesaplanıyor..."
Bot:  [Result Card] Arabuluculuk Ücreti: X TL
      (with breakdown details)

Bot:  "Yeni bir hesaplama yapmak ister misiniz?"
      [Evet] [Hayır]
```

---

## Navigation

Chat is accessed **only** from DisputeCategoryView (no new TabBar tab):
- **DisputeCategoryViewModel**: Change `.aiChat` from `showComingSoonPopover = true` to `navigateToGuidedChat = true`
- **DisputeCategoryView**: Add `.navigationDestination(isPresented:)` pointing to `GuidedChatView`
- **DisputeCategoryType.aiChat**: Update icon from "lock.fill" to chat icon, color from .red to .cyan

---

## File Structure

Following the app's MVVM pattern:

```
Denklem/Denklem/
├── Models/
│   └── Domain/
│       └── GuidedChatModels.swift          ← NEW: ChatMessage, ChatStep enum, ChatOption
│
├── Views/
│   ├── Screens/
│   │   └── GuidedChat/
│   │       ├── GuidedChatView.swift        ← NEW: Main chat UI
│   │       └── GuidedChatViewModel.swift   ← NEW: State machine logic + calculation routing
│   │
│   └── Components/
│       └── GuidedChat/
│           ├── ChatMessageBubble.swift     ← NEW: Message bubble (bot/user)
│           ├── ChatOptionButtons.swift     ← NEW: Tappable option buttons
│           └── ChatResultCard.swift        ← NEW: Calculation result card
│
├── Views/Screens/DisputeCategory/
│   ├── DisputeCategoryView.swift           ← MODIFY: Add navigationDestination for chat
│   └── DisputeCategoryViewModel.swift      ← MODIFY: Navigate to chat instead of coming soon
│
├── Constants/
│   └── LocalizationKeys.swift              ← MODIFY: Add GuidedChat keys
│
└── Localization/
    ├── tr.lproj/Localizable.strings        ← MODIFY: Add Turkish strings
    ├── en.lproj/Localizable.strings        ← MODIFY: Add English strings
    └── sv.lproj/Localizable.strings        ← MODIFY: Add Swedish strings
```

---

## Implementation Details

### 1. GuidedChatModels.swift — Domain Models

```swift
// Chat message model
struct ChatMessage: Identifiable {
    let id: UUID
    let role: ChatRole
    let content: String
    let options: [ChatOption]?           // Tappable buttons (nil for user messages)
    let resultCard: CalculationResult?   // Calculation result (nil for non-result messages)
    let timestamp: Date

    enum ChatRole { case bot, user }
}

// Tappable option button
struct ChatOption: Identifiable, Hashable {
    let id: UUID
    let label: String
    let value: String  // Internal value for state machine
}

// State machine steps
enum ChatStep {
    case welcome
    case selectCalculationType       // Mediation / Attorney
    case selectDisputeType           // 10 dispute types
    case selectMonetaryType          // Monetary / Non-monetary
    case selectAgreement             // Agreed / Not agreed
    case enterAmount                 // Free text input (amount)
    case enterPartyCount             // Free text input (party count)
    case calculating
    case result
    case askAgain
    case farewell
}
```

### 2. GuidedChatViewModel.swift — State Machine + Calculator Bridge

Key responsibilities:
- Manage `currentStep: ChatStep` state
- Append messages to `messages: [ChatMessage]` array
- On user selection → advance step, add bot question for next step
- On amount/partyCount input → validate, then call existing calculator
- Route to `TariffCalculator.calculateFee(input:)` or `AttorneyFeeCalculator.calculate(input:)`
- Format result as ChatMessage with resultCard

**Collected parameters during flow:**
```swift
@Published var selectedCalculationType: CalculationType?   // mediation or attorney
@Published var selectedDisputeType: DisputeType?
@Published var isMonetary: Bool = true
@Published var selectedAgreement: AgreementStatus?
@Published var amount: Double?
@Published var partyCount: Int?
@Published var selectedYear: TariffYear = .year2026
```

**Calculator routing** (reuses existing calculators — zero duplication):
```swift
func performCalculation() {
    // Mediation fee → CalculationInput.create() → TariffCalculator.calculateFee(input:)
    // Attorney fee → AttorneyFeeInput → AttorneyFeeCalculator.calculate(input:)
}
```

### 3. GuidedChatView.swift — Chat UI

- ScrollView with LazyVStack of ChatMessageBubble views
- ScrollViewReader to auto-scroll to latest message
- Text input bar at bottom (only visible when step requires text input: enterAmount, enterPartyCount)
- Theme + localeManager + glassEffect following app patterns
- `.scrollDismissesKeyboard(.interactively)`

### 4. ChatMessageBubble.swift — Message Bubbles

- Bot messages: left-aligned, glass effect
- User messages: right-aligned, tinted glass
- Option buttons rendered below bot message when `options` is not nil
- Result card rendered when `resultCard` is not nil

### 5. ChatOptionButtons.swift — Tappable Buttons

- Horizontal/vertical layout based on option count (2 options = horizontal, 3+ = vertical list)
- Glass effect styling
- Disabled after selection (greyed out, selected one highlighted)

### 6. ChatResultCard.swift — Result Display

- Reuses data from `CalculationResult` / `AttorneyFeeResult`
- Shows fee amount, breakdown, dispute type info
- Glass effect card matching app style
- Compact version of existing result sheets

---

## Scope

### Phase 1 (MVP)

Support **2 calculation types** in guided chat:
1. **Mediation Fee** (arabuluculuk ucreti) — monetary + non-monetary, agreement + non-agreement
2. **Attorney Fee** (avukatlik ucreti) — monetary + non-monetary, agreement types

### Phase 2 (Extended)
- Add **tenancy**, **reinstatement**, **SMM**, **serial disputes** calculation support
- Conversation history persistence
- "Clear Chat" / "New Calculation" actions

### Phase 3 (Optional — NLP Keyword Enhancement)
- Allow users to type freely instead of using buttons
- Rule-based keyword extraction for Turkish/English (e.g. "iş", "ticari", "anlaştık" → mapped to enums)
- Pattern matching for amounts (regex), dispute types, agreement status
- If parsing fails, gracefully fall back to guided questions

### Phase 4 (Optional — Claude API)
- For complex queries beyond guided/keyword patterns
- User toggle in Settings
- Fallback to offline when no internet

---

## Key Patterns to Follow

### Calculation Reuse
- ALWAYS call existing calculators: `TariffCalculator.calculateFee(input:)`
- NEVER duplicate calculation logic in chat code
- Use existing input types: `CalculationInput`, `AttorneyFeeInput`
- Use existing result types: `CalculationResult`, `AttorneyFeeResult`

### App Conventions
- `@available(iOS 26.0, *)` on all views
- `@MainActor final class GuidedChatViewModel: ObservableObject`
- `@ObservedObject private var localeManager = LocaleManager.shared` + `let _ = localeManager.refreshID`
- `@Environment(\.theme) var theme` for styling
- `.glassEffect()` and `.buttonStyle(.glass)` for Liquid Glass UI
- `LocalizationKeys` struct for all user-facing strings
- All user-facing text localized in tr/en/sv

---

## Files to Reference During Implementation

### Calculation Logic
- `/Models/Calculation/TariffCalculator.swift` — `static func calculateFee(input:) -> CalculationResult`
- `/Models/Calculation/AttorneyFeeCalculator.swift` — `static func calculate(input:) -> AttorneyFeeResult`

### Existing Models
- `/Models/Domain/CalculationResult.swift` — Input/Result structures to reuse
- `/Models/Domain/DisputeType.swift` — Dispute type enum with displayName
- `/Constants/TariffConstants.swift` — AgreementStatus, CalculationType enums
- `/Models/Domain/TariffYear.swift` — TariffYear enum

### UI Patterns
- `/Views/Screens/MediationFee/MediationFeeView.swift` — Glass effect UI reference
- `/Views/Screens/MediationFee/MediationFeeResultSheet.swift` — Result card display pattern
- `/Views/Screens/Survey/SurveyView.swift` — Card-by-card question flow reference

### Navigation
- `/Views/Screens/DisputeCategory/DisputeCategoryView.swift` — Navigation source
- `/Views/Screens/DisputeCategory/DisputeCategoryViewModel.swift` — .aiChat case to modify

### Localization
- `/Localization/LocalizationHelper.swift` — Formatting utilities (formatCurrency, formatDate)
- `/Localization/LocalizationKeys.swift` — Type-safe localization keys structure

---

## Implementation Order

1. **GuidedChatModels.swift** — ChatMessage, ChatStep, ChatOption
2. **GuidedChatViewModel.swift** — State machine + calculator routing
3. **ChatMessageBubble.swift** — Bot/user message bubbles
4. **ChatOptionButtons.swift** — Tappable option buttons
5. **ChatResultCard.swift** — Calculation result card
6. **GuidedChatView.swift** — Main chat screen (assembles components)
7. **DisputeCategoryView/ViewModel** — Navigate to chat instead of coming soon
8. **Localization** — Add all guided chat strings (tr/en/sv)

---

## Verification

- Build succeeds with no warnings
- DisputeCategory'deki Denklem AI butonu chat ekranina navigasyon yapar (coming soon yok)
- Complete mediation fee flow: welcome → calculation type → dispute type → monetary → agreement → amount → result
- Complete attorney fee flow: welcome → calculation type → agreement → amount → result
- Result values match manual calculation tool exactly (zero duplication)
- Language switching works (all chat messages update)
- Light/dark mode renders correctly
- Keyboard handling works for amount/party count input
- "Calculate again" flow restarts from selectCalculationType step

---

## Success Criteria

The guided chat feature is complete when:

1. **Functional**
   - User can complete a calculation through guided questions
   - All mediation + attorney fee scenarios produce correct results
   - Calculation results match manual tool exactly (100% accuracy)
   - "Calculate again" flow works without issues

2. **UX**
   - Messages display instantly (no network dependency)
   - UI matches app's Liquid Glass style
   - Scrolling, keyboard handling work smoothly
   - Works in light and dark mode
   - All text localized in Turkish, English, and Swedish

3. **Architecture**
   - Zero duplication of calculation logic
   - Follows MVVM pattern consistently
   - Code is maintainable and testable
   - Future free-text/API enhancements are straightforward to add
