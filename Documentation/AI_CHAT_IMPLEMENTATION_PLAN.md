# AI Chat Feature Implementation Plan - Denklem App

## Context

The user wants to add an AI-powered chat interface to the Denklem legal fee calculator app. Currently, users navigate through multiple screens selecting dispute types, agreement status, and entering amounts to calculate fees. The new chat feature will allow users to type natural language queries like:

- **Turkish**: "İş uyuşmazlığında 350.000 TL'ye anlaştık, arabuluculuk ücretimiz ne kadar?"
- **English**: "We agreed on 350,000 TL in an employment dispute, what's the mediation fee?"

The AI should parse these queries, extract parameters, and call the **existing calculation functions** (not duplicate logic) to provide conversational responses with full calculation breakdowns.

### Why This Approach?

The app already has robust, tested calculation logic in:
- `TariffCalculator.calculateFee(input:)` for mediation fees
- `AttorneyFeeCalculator.calculate(input:)` for attorney fees
- `TenancyCalculator`, `ReinstatementCalculator`, etc.

The chat feature is **purely a natural language interface** to these existing calculators.

---

## Recommended Approach: Hybrid (Offline-First)

### Phase 1: Offline Rule-Based NLP (MVP)
- **No internet required**, zero ongoing costs
- Rule-based keyword extraction for Turkish/English
- Pattern matching for amounts, dispute types, dates
- Instant responses, complete privacy

### Phase 2: Optional Claude API Enhancement
- For complex queries beyond rule patterns
- Fallback to offline when no internet
- User toggle in Settings

### Justification:
1. **Privacy**: Legal data is sensitive - offline respects user privacy
2. **Cost**: No per-query API costs in MVP
3. **Reliability**: Works without internet (common in Turkish court environments)
4. **Performance**: Instant responses without network latency
5. **Gradual enhancement**: Can add AI later without breaking existing functionality

---

## Architecture Overview

### Data Flow Pipeline

```
User types natural language
    ↓
[ChatNLPParser] - Keyword extraction, tokenization
    ↓
[ChatIntentRecognizer] - Classify intent (mediation/attorney/tenancy/etc.)
    ↓
[ChatParameterExtractor] - Extract structured parameters
    ↓
[ChatCalculationBridge] - Route to EXISTING calculator
    ↓
TariffCalculator.calculateFee(input:) ← EXISTING CODE
    ↓
[ChatResponseGenerator] - Format conversational response
    ↓
ChatView displays result with glass effect UI
```

**Critical Principle**: The chat feature NEVER performs calculations. It only:
1. Parses text → structured parameters
2. Calls existing calculators
3. Formats responses conversationally

---

## File Structure

Following the app's MVVM pattern:

```
Denklem/
├── Models/
│   ├── Domain/
│   │   ├── ChatMessage.swift              ← NEW: Message model (id, role, content, timestamp, result)
│   │   ├── ChatIntent.swift               ← NEW: Parsed intent enum (calculateMediationFee, etc.)
│   │   └── ChatResponse.swift             ← NEW: Response model with suggestions
│   │
│   ├── Calculation/
│   │   └── ChatCalculationBridge.swift    ← NEW: Routes intents → existing calculators
│   │
│   └── NLP/
│       ├── ChatNLPParser.swift            ← NEW: Keyword extraction (Turkish/English)
│       ├── ChatParameterExtractor.swift   ← NEW: Extract amounts, dates, types
│       ├── ChatIntentRecognizer.swift     ← NEW: Intent classification
│       └── ChatResponseGenerator.swift    ← NEW: Conversational response formatting
│
├── Views/
│   ├── Screens/
│   │   └── Chat/
│   │       ├── ChatView.swift             ← NEW: Main chat UI (ScrollView + input bar)
│   │       ├── ChatViewModel.swift        ← NEW: Chat logic (@MainActor, @ObservableObject)
│   │       ├── ChatMessageRow.swift       ← NEW: Message bubble with glass effect
│   │       └── ChatInputBar.swift         ← NEW: Text input + send button
│   │
│   └── Components/
│       └── Chat/
│           ├── ChatResultCard.swift       ← NEW: Calculation result card
│           ├── ChatSuggestionButton.swift ← NEW: Quick action buttons
│           └── ChatTypingIndicator.swift  ← NEW: Animated "thinking..." indicator
│
├── Constants/
│   └── ChatConstants.swift                ← NEW: Keywords, regex patterns
│
├── Localization/
│   ├── LocalizationKeys.swift             ← MODIFY: Add Chat struct with keys
│   ├── tr.lproj/Localizable.strings       ← MODIFY: Add Turkish strings
│   └── en.lproj/Localizable.strings       ← MODIFY: Add English strings
│
└── Views/Components/Navigation/
    └── TabBarView.swift                   ← MODIFY: Add .chat tab
```

---

## Critical Implementation Details

### 1. ChatMessage Model

```swift
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let role: ChatRole              // .user or .assistant
    let content: String
    let timestamp: Date
    let calculationResult: Any?     // CalculationResult, AttorneyFeeResult, etc.
    let intent: ChatIntent?

    enum ChatRole: String, Codable {
        case user
        case assistant
    }
}
```

### 2. ChatIntent Enum

```swift
enum ChatIntent {
    case calculateMediationFee(
        disputeType: DisputeType?,
        agreementStatus: AgreementStatus?,
        amount: Double?,
        partyCount: Int?
    )
    case calculateAttorneyFee(
        isMonetary: Bool?,
        hasAgreement: Bool?,
        amount: Double?,
        courtType: AttorneyFeeConstants.CourtType?
    )
    case calculateTenancy(...)
    case calculateReinstatement(...)
    case greeting
    case unknown

    var confidence: ConfidenceLevel {
        // .high (all params), .medium (some missing), .low (unclear)
    }
}
```

### 3. ChatNLPParser - Keyword Extraction

**Turkish Keywords Map:**
```swift
private static let disputeTypeKeywords: [DisputeType: [String]] = [
    .workerEmployer: ["iş", "işçi", "işveren", "kıdem", "employment", "worker"],
    .commercial: ["ticari", "ticaret", "commercial", "business"],
    .consumer: ["tüketici", "consumer"],
    .rent: ["kira", "kiracı", "rent", "rental"],
    // ... all 10 dispute types
]

private static let agreementKeywords: [AgreementStatus: [String]] = [
    .agreed: ["anlaş", "anlaşma", "uzlaş", "agreed", "settlement"],
    .notAgreed: ["anlaşmad", "uzlaşmad", "no agreement"]
]
```

**Amount Extraction:**
- Regex: `(\d{1,3}(?:[.,]\d{3})*(?:[.,]\d+)?)`
- Handles: `350,000` / `350.000` / `350000` / `350.000,50`
- Normalizes Turkish format (dot = thousands, comma = decimal)

**Date Extraction:**
- Regex: `(202[0-9])`
- Defaults to current year if not found

### 4. ChatCalculationBridge - Router to Existing Calculators

```swift
struct ChatCalculationBridge {
    static func calculate(intent: ChatIntent) -> Result<Any, ChatError> {
        switch intent {
        case .calculateMediationFee(let disputeType, let agreementStatus, let amount, let partyCount):
            guard let disputeType, let agreementStatus else {
                return .failure(.missingParameters(["disputeType", "agreementStatus"]))
            }

            let calculationType: CalculationType = amount != nil ? .monetary : .nonMonetary

            // Create input using EXISTING CalculationInput model
            let input = CalculationInput(
                disputeType: disputeType,
                calculationType: calculationType,
                agreementStatus: agreementStatus,
                partyCount: partyCount ?? 2,
                tariffYear: .current,
                disputeAmount: amount
            )

            // Call EXISTING TariffCalculator
            let result = TariffCalculator.calculateFee(input: input)
            return result.isSuccess ? .success(result) : .failure(.calculationFailed(result.errorMessage ?? ""))

        case .calculateAttorneyFee(let isMonetary, let hasAgreement, let amount, let courtType):
            // Similar routing to AttorneyFeeCalculator.calculate()
            // ...
        }
    }
}
```

**Critical**: This bridge NEVER duplicates calculation logic - it only routes to existing calculators.

### 5. ChatResponseGenerator - Conversational Formatting

```swift
static func generateMediationResponse(_ result: CalculationResult, language: SupportedLanguage) -> ChatResponse {
    let fee = result.mediationFee
    let formattedFee = fee.formattedAmount  // Uses existing LocalizationHelper

    let message = language == .turkish
        ? "\(fee.disputeType.displayName) uyuşmazlığında \(fee.agreementStatus.displayName) durumunda arabuluculuk ücretiniz \(formattedFee)'dir."
        : "For \(fee.disputeType.displayName) dispute with \(fee.agreementStatus.displayName), your mediation fee is \(formattedFee)."

    return ChatResponse(
        message: message,
        calculationResult: result,
        suggestedActions: [.viewBreakdown, .shareResult]
    )
}
```

### 6. ChatView - iOS 26 Liquid Glass UI

```swift
@available(iOS 26.0, *)
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme

    var body: some View {
        let _ = localeManager.refreshID

        VStack(spacing: 0) {
            // Messages ScrollView
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: theme.spacingM) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageRow(message: message)
                                .id(message.id)
                        }

                        if viewModel.isProcessing {
                            ChatTypingIndicator()
                        }
                    }
                    .padding(.horizontal, theme.spacingL)
                }
                .onChange(of: viewModel.messages.count) {
                    scrollToBottom(proxy)
                }
            }

            // Input Bar
            ChatInputBar(text: $viewModel.inputText, onSend: viewModel.sendMessage)
                .padding(theme.spacingL)
                .glassEffect(in: Rectangle())
        }
        .background(theme.background.ignoresSafeArea())
        .navigationTitle(LocalizationKeys.Chat.title.localized)
    }
}
```

**Message Bubble Pattern:**
```swift
Text(message.content)
    .padding(theme.spacingM)
    .background(.clear)
    .glassEffect(
        message.role == .user ? theme.glassMedium : theme.glassClear,
        in: RoundedRectangle(cornerRadius: theme.cornerRadiusL)
    )
```

### 7. TabBar Integration

**Modify TabBarView.swift:**

```swift
// Add to TabItem enum (line 12)
enum TabItem: String, CaseIterable, Identifiable, Hashable {
    case home
    case tools
    case chat        // ← NEW
    case legislation
    case settings
}

// Add title/icon (lines 21-31, 34-45)
case .chat:
    return LocalizationKeys.TabBar.chat.localized  // "Sohbet" / "Chat"

case .chat:
    return "bubble.left.and.text.bubble.right.fill"

// Add Tab in body (after .tools, before .legislation)
Tab(value: .chat) {
    NavigationStack {
        ChatView()
    }
} label: {
    Label(TabItem.chat.title(currentLanguage: localeManager.currentLanguage),
          systemImage: TabItem.chat.systemImage)
}
```

---

## Implementation Phases

### Phase 1: MVP (Offline Rule-Based) - 2-3 weeks

#### Week 1: NLP Foundation
- [ ] Create `ChatMessage`, `ChatIntent`, `ChatResponse` models
- [ ] Implement `ChatNLPParser` with Turkish/English keyword dictionaries
- [ ] Implement `ChatParameterExtractor` (amount, date, type parsing)
- [ ] Write unit tests for 20+ sample queries

#### Week 2: Calculation Bridge & Response Generation
- [ ] Implement `ChatIntentRecognizer` (classify intent from tokens)
- [ ] Implement `ChatCalculationBridge` routing to existing calculators
- [ ] Implement `ChatResponseGenerator` for conversational formatting
- [ ] Test end-to-end: text → parameters → calculation → response

#### Week 3: UI Implementation & Integration
- [ ] Create `ChatView`, `ChatViewModel`, `ChatMessageRow`, `ChatInputBar`
- [ ] Add `.chat` tab to `TabBarView`
- [ ] Add localization strings (Turkish/English)
- [ ] Polish UI with glass effects, animations
- [ ] Manual testing with 50+ real-world queries

**Deliverables:**
- Working chat feature for **mediation** + **attorney fee** calculations
- Offline-only, instant responses
- Turkish + English support
- Glass effect UI matching app style

### Phase 2: Extended Features - 1-2 weeks
- [ ] Add **tenancy** + **reinstatement** calculation support
- [ ] Implement multi-turn conversations (ask follow-up questions for missing params)
- [ ] Add conversation history persistence (UserDefaults or Core Data)
- [ ] Add suggested action buttons ("Recalculate", "View Breakdown", "Share")
- [ ] Add "Clear Chat" / "New Calculation" actions

### Phase 3: Optional Claude API Integration - 1 week
- [ ] Integrate Claude API with Anthropic SDK
- [ ] Add Settings toggle: "AI-Powered Chat" (on/off)
- [ ] Implement fallback to offline when no internet
- [ ] Add disclaimer: "AI responses may vary"
- [ ] Token usage tracking and cost monitoring

---

## Localization Keys to Add

Add to `LocalizationKeys.swift`:

```swift
struct Chat {
    static let title = "chat.title"
    static let inputPlaceholder = "chat.input_placeholder"
    static let welcomeMessage = "chat.welcome_message"
    static let typingIndicator = "chat.typing"
    static let errorGeneric = "chat.error_generic"
    static let errorMissingParams = "chat.error_missing_params"
    static let suggestionRecalculate = "chat.suggestion_recalculate"
    static let suggestionViewBreakdown = "chat.suggestion_view_breakdown"
    static let suggestionOpenTools = "chat.suggestion_open_tools"
    static let clearChat = "chat.clear_chat"

    struct Samples {
        static let mediationAgreed = "chat.samples.mediation_agreed"
        static let attorneyFee = "chat.samples.attorney_fee"
        static let tenancy = "chat.samples.tenancy"
    }
}

struct TabBar {
    // Existing keys...
    static let chat = "tab_bar.chat"  // ← NEW
}
```

**Turkish strings:**
```
"chat.title" = "Sohbet";
"chat.input_placeholder" = "Mesajınızı yazın...";
"chat.welcome_message" = "Merhaba! 👋\n\nArabuluculuk ve avukatlık ücretleri hakkında sorularınızı sorun.\n\nÖrnek: 'İş uyuşmazlığında 350.000 TL'ye anlaştık, arabuluculuk ücretimiz ne kadar?'";
"tab_bar.chat" = "Sohbet";
```

**English strings:**
```
"chat.title" = "Chat";
"chat.input_placeholder" = "Type your message...";
"chat.welcome_message" = "Hello! 👋\n\nAsk me about mediation and attorney fees.\n\nExample: 'We agreed on 350,000 TL in an employment dispute, what's the mediation fee?'";
"tab_bar.chat" = "Chat";
```

---

## Critical Patterns to Follow

### 1. Calculation Reuse
- ✅ **ALWAYS** call existing calculators: `TariffCalculator.calculateFee(input:)`
- ❌ **NEVER** duplicate calculation logic in chat code
- ✅ Use existing input types: `CalculationInput`, `AttorneyFeeInput`
- ✅ Use existing result types: `CalculationResult`, `AttorneyFeeResult`

### 2. Type Safety
- ✅ Use `DisputeType`, `AgreementStatus`, `CalculationType` enums
- ❌ Never use raw strings for types
- ✅ Use `TariffYear.current` for default year

### 3. Localization
- ✅ Use `LocalizationKeys` struct + `.localized` extension
- ✅ Use `LocalizationHelper.formatCurrency()` for amounts
- ✅ Use `LocalizationHelper.formatDate()` for dates
- ✅ Get language from `UserDefaults` (not `Locale.current`)

### 4. ViewModel Pattern
- ✅ `@MainActor final class ChatViewModel: ObservableObject`
- ✅ `@Published` properties for reactive state
- ✅ Clear separation: VM = logic, View = UI

### 5. Glass Effect Styling
- ✅ Use `.glassEffect(in:)` for cards and input fields
- ✅ Use `@Environment(\.theme)` for colors/spacing
- ✅ Use `.buttonStyle(.glass)` for buttons

### 6. Turkish Character Handling
- ✅ Normalize text with `lowercased()` before keyword matching
- ✅ Handle Turkish characters: ı, ş, ğ, ü, ö, ç
- ✅ Support both Turkish and English keywords

---

## Sample Test Cases

| User Query (Turkish) | Expected Parameters | Expected Result |
|---------------------|-------------------|----------------|
| "İş uyuşmazlığında 350.000 TL'ye anlaştık, arabuluculuk ücretimiz ne kadar?" | disputeType: .workerEmployer, agreementStatus: .agreed, amount: 350000, calcType: mediation | 21,000 TL |
| "Ticari davada avukat ücreti?" | disputeType: .commercial, calcType: attorney, MISSING: isMonetary, hasAgreement | Ask follow-up questions |
| "Kira tahliye 600 bin TL" | calcType: tenancy, evictionAmount: 600000 | Calculate tenancy fee |
| "İşe iade anlaşması 150000" | calcType: reinstatement, agreementStatus: .agreed, amount: 150000 | Calculate reinstatement fee |

| User Query (English) | Expected Parameters | Expected Result |
|---------------------|-------------------|----------------|
| "We agreed on 350,000 TL in an employment dispute, what's the mediation fee?" | disputeType: .workerEmployer, agreementStatus: .agreed, amount: 350000, calcType: mediation | 21,000 TL |
| "Attorney fee for commercial case?" | disputeType: .commercial, calcType: attorney, MISSING: isMonetary, hasAgreement | Ask follow-up questions |

---

## Verification Steps

After implementation, verify:

### Unit Tests
- [ ] `ChatNLPParser` extracts amounts correctly (Turkish/English formats)
- [ ] `ChatNLPParser` identifies dispute types from keywords
- [ ] `ChatNLPParser` identifies agreement status from keywords
- [ ] `ChatIntentRecognizer` classifies intents correctly
- [ ] `ChatCalculationBridge` routes to correct calculator
- [ ] `ChatCalculationBridge` validates required parameters
- [ ] `ChatResponseGenerator` formats Turkish responses correctly
- [ ] `ChatResponseGenerator` formats English responses correctly

### Integration Tests
- [ ] End-to-end: "İş uyuşmazlığında 350.000 TL anlaştık" → correct fee displayed
- [ ] Multi-turn conversation: missing params triggers follow-up questions
- [ ] Language switching mid-conversation works
- [ ] Calculation results match manual calculation tool results

### UI Tests
- [ ] Messages scroll to bottom on new message
- [ ] Keyboard doesn't cover input bar
- [ ] Glass effect renders correctly in light/dark mode
- [ ] Typing indicator animates smoothly
- [ ] Suggested action buttons work
- [ ] Long messages wrap correctly
- [ ] TabBar chat icon displays correctly

### Manual Testing
- [ ] Test 50+ real-world queries in Turkish
- [ ] Test 20+ real-world queries in English
- [ ] Test typos and misspellings
- [ ] Test edge cases (very large amounts, unusual dispute types)
- [ ] Test on different screen sizes (iPhone SE, Pro Max, iPad)
- [ ] Test accessibility (VoiceOver, Dynamic Type)

---

## Files to Reference During Implementation

### Calculation Logic
- `/Models/Calculation/TariffCalculator.swift` - Line 17: `static func calculateFee(input:)` interface
- `/Models/Calculation/AttorneyFeeCalculator.swift` - Attorney fee calculation
- `/Models/Calculation/TenancyCalculator.swift` - Tenancy calculation
- `/Models/Calculation/ReinstatementCalculator.swift` - Reinstatement calculation

### Existing Models
- `/Models/Domain/CalculationResult.swift` - Input/Result structures to reuse
- `/Models/Domain/DisputeType.swift` - Dispute type enum with displayName
- `/Constants/TariffConstants.swift` - AgreementStatus, CalculationType enums
- `/Models/Domain/TariffYear.swift` - TariffYear enum with .current

### UI Patterns
- `/Views/Screens/MediationFee/MediationFeeView.swift` - Reference for glass effect UI
- `/Views/Screens/MediationFee/MediationFeeResultSheet.swift` - Result card display pattern
- `/Views/Components/Common/CalculateButton.swift` - Button styling reference

### Navigation
- `/Views/Components/Navigation/TabBarView.swift` - TabBar to modify (add .chat tab)

### Localization
- `/Localization/LocalizationHelper.swift` - Formatting utilities (formatCurrency, formatDate)
- `/Localization/LocalizationKeys.swift` - Type-safe localization keys structure

---

## Success Criteria

The AI chat feature is complete when:

1. **Functional**
   - User can type natural language query in Turkish or English
   - System correctly extracts parameters 80%+ of the time
   - Calculation results match manual tool exactly (100% accuracy)
   - Multi-turn conversation works for missing parameters

2. **UX**
   - Messages display in under 500ms (offline mode)
   - UI matches app's glass effect style
   - Scrolling, keyboard handling work smoothly
   - Works in light and dark mode

3. **Quality**
   - 50+ unit tests pass
   - All integration tests pass
   - No crashes or memory leaks
   - Localizes correctly in Turkish/English

4. **Architecture**
   - Zero duplication of calculation logic
   - Follows MVVM pattern consistently
   - Code is maintainable and testable
   - Future API integration is straightforward

---

## Future Enhancements (Phase 3+)

- **Voice Input**: Integrate Speech Recognition for hands-free queries
- **Multi-turn Context**: Remember conversation context across multiple calculations
- **Learning**: Track common queries to improve keyword dictionary
- **Export**: Share chat transcript as PDF or text
- **Templates**: Quick-fill buttons for common scenarios
- **Calculator Comparison**: "Show me attorney fee vs mediation fee for this case"
- **Historical Queries**: Search past conversations

---

## Conclusion

This plan provides a complete blueprint for implementing an AI chat feature that:

- **Leverages existing code** (no calculation duplication)
- **Works offline** (privacy, cost, reliability)
- **Follows app patterns** (MVVM, theme, localization)
- **Delivers incrementally** (MVP → Extended → Optional API)
- **Maintains quality** (tested, type-safe, maintainable)

The offline rule-based approach is sufficient for 80%+ of queries given the structured nature of legal fee calculations. The optional Claude API integration (Phase 3) adds flexibility for complex queries without compromising the core offline experience.

**Estimated effort**: 2-3 weeks for MVP, 4-5 weeks for full Phase 2 implementation.
