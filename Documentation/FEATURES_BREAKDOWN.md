# DENKLEM - Features Breakdown

## 📋 Overview
This document provides a comprehensive breakdown of all features in DENKLEM, organized by priority, implementation complexity, and user value. Each feature includes detailed specifications, acceptance criteria, and development notes.

## 🎯 Feature Categories

### 🔥 Core Features (MVP)
Essential features required for basic app functionality and App Store release.

### ⚡ Enhanced Features (Phase 2)
Features that improve user experience and differentiate from competitors.

### 🚀 Advanced Features (Phase 3)
Premium features for power users and future iOS versions.

### 🌟 Future Features (Backlog)
Features planned for future releases and updates.

---

## 🔥 CORE FEATURES (MVP)

### CF-001: Tariff Year Selection
**Priority:** P0 - Critical
**Status:** ⏳ Pending
**Complexity:** Low
**Files:** `Views/Screens/StartScreen/`, `Managers/TariffManager.swift`

#### Description
Users can select between 2025 and 2026 tariff years on the start screen before beginning calculations.

#### User Story
As a user, I want to select the tariff year (2025/2026) so that I can calculate fees based on the correct tariff rates.

#### Acceptance Criteria
- [ ] Dropdown selection on StartScreen shows 2025/2026 options
- [ ] Selected year is displayed in button text: "Giriş - 2025"
- [ ] Year selection persists throughout calculation flow
- [ ] All calculations use selected year's tariff rates
- [ ] Default selection is current year (2025 until Jan 2026)

#### Technical Implementation
```swift
// TariffYear enum with rates
enum TariffYear: String, CaseIterable {
    case year2025 = "2025"
    case year2026 = "2026"
    
    var baseFee: Double {
        switch self {
        case .year2025: return 100.0
        case .year2026: return 115.0
        }
    }
}

// StartScreen year selection
@State private var selectedYear: TariffYear = .year2025
@State private var isYearDropdownVisible = false

Dependencies

TariffManager implementation
Tariff2025 and Tariff2026 data models
YearSelectionButton component
CF-002: Monetary Dispute Calculation
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Views/Screens/Input/, Models/Calculation/TariffCalculator.swift

Description
Calculate mediation fees for monetary disputes based on dispute amount and agreement status.

User Story
As a user, I want to calculate mediation fees for monetary disputes
so that I can determine the exact fee amount for my case.

Acceptance Criteria
<input disabled="" type="checkbox"> Input screen accepts currency amounts up to 999,999,999 TL
<input disabled="" type="checkbox"> Amount validation prevents invalid inputs
<input disabled="" type="checkbox"> Calculation considers agreement status (agreed/disagreed)
<input disabled="" type="checkbox"> Result shows base fee + percentage fee breakdown
<input disabled="" type="checkbox"> Calculation uses selected tariff year rates
<input disabled="" type="checkbox"> Currency formatting displays proper Turkish Lira format
Technical Implementation

// Input validation
struct AmountValidator {
    static let maxAmount: Double = 999_999_999
    static let minAmount: Double = 0.01
    
    static func validate(_ amount: Double) -> ValidationResult {
        guard amount >= minAmount else {
            return .invalid(.tooLow)
        }
        guard amount <= maxAmount else {
            return .invalid(.tooHigh)
        }
        return .valid
    }
}

// Calculation logic
class TariffCalculator {
    func calculateMonetaryFee(
        amount: Double,
        hasAgreement: Bool,
        tariffYear: TariffYear
    ) -> CalculationResult {
        // Implementation
    }
}

Dependencies

CurrencyInputField component
AmountValidator utility
TariffCalculator service
CalculationResult model

CF-003: Non-Monetary Dispute Calculation
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Views/Screens/DisputeType/, Models/Calculation/TariffCalculator.swift

Description
Calculate mediation fees for non-monetary disputes based on dispute type and party count.

User Story
As a user, I want to calculate mediation fees for non-monetary disputes
so that I can determine fees for cases without monetary value.

Acceptance Criteria
<input disabled="" type="checkbox"> Dispute type selection from predefined list
<input disabled="" type="checkbox"> Party count input (2-10 parties)
<input disabled="" type="checkbox"> Fixed fee calculation based on dispute type
<input disabled="" type="checkbox"> Party count affects total calculation
<input disabled="" type="checkbox"> Result shows fee breakdown by party
<input disabled="" type="checkbox"> Calculation uses selected tariff year rates
Technical Implementation

// Dispute types
enum DisputeType: String, CaseIterable {
    case isciIsveren = "İşçi-İşveren"
    case ticari = "Ticari"
    case kira = "Kira"
    case sigorta = "Sigorta"
    
    func baseFee(for year: TariffYear) -> Double {
        switch (self, year) {
        case (.isciIsveren, .year2025): return 150.0
        case (.isciIsveren, .year2026): return 172.5
        case (.ticari, .year2025): return 200.0
        case (.ticari, .year2026): return 230.0
        case (.kira, .year2025): return 175.0
        case (.kira, .year2026): return 201.25
        case (.sigorta, .year2025): return 160.0
        case (.sigorta, .year2026): return 184.0
        }
    }
}

// Party count stepper
struct PartyCountStepper: View {
    @Binding var count: Int
    let range: ClosedRange<Int> = 2...10
}

Dependencies
DisputeTypeScreen implementation
PartyCountStepper component
DisputeType enum
TariffCalculator service

CF-004: Time-Based Calculation
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Views/Screens/TimeCalculation/, Models/Calculation/TimeCalculator.swift

Description
Calculate time-based fees for mediation sessions and administrative work.

User Story
As a user, I want to calculate time-based mediation fees
so that I can bill for actual time spent on mediation.

Acceptance Criteria
<input disabled="" type="checkbox"> Time input in hours and minutes
<input disabled="" type="checkbox"> Hourly rate based on selected tariff year
<input disabled="" type="checkbox"> Minimum billing time (e.g., 1 hour)
<input disabled="" type="checkbox"> Overtime rates for extended sessions
<input disabled="" type="checkbox"> Result shows time breakdown and total fee
<input disabled="" type="checkbox"> Validation prevents invalid time entries
Technical Implementation

// Time calculation model
struct TimeCalculation {
    let hours: Int
    let minutes: Int
    let tariffYear: TariffYear
    
    var totalMinutes: Int {
        hours * 60 + minutes
    }
    
    var billableHours: Double {
        max(1.0, Double(totalMinutes) / 60.0)
    }
}

// Time calculator
class TimeCalculator {
    func calculateTimeFee(
        hours: Int,
        minutes: Int,
        tariffYear: TariffYear
    ) -> CalculationResult {
        // Implementation
    }
}

Dependencies
TimeCalculationScreen implementation
TimeCalculator service
Time input components
Validation utilities

CF-005: SMM Calculation
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Views/Screens/SMMCalculation/, Models/Calculation/SMMCalculator.swift

Description
Calculate fees related to Social Security Institution (SMM) disputes and procedures.

User Story
As a user, I want to calculate SMM-related mediation fees
so that I can handle social security disputes properly.

Acceptance Criteria
<input disabled="" type="checkbox"> SMM-specific input fields
<input disabled="" type="checkbox"> Calculation based on SMM parameters
<input disabled="" type="checkbox"> Special rates for SMM disputes
<input disabled="" type="checkbox"> Result shows SMM fee breakdown
<input disabled="" type="checkbox"> Validation for SMM-specific rules
<input disabled="" type="checkbox"> Help text for SMM calculations
Technical Implementation

// SMM calculation parameters
struct SMMParameters {
    let disputeAmount: Double?
    let procedureType: SMMProcedureType
    let participantCount: Int
    let tariffYear: TariffYear
}

// SMM calculator
class SMMCalculator {
    func calculateSMMFee(
        parameters: SMMParameters
    ) -> CalculationResult {
        // Implementation
    }
}

Dependencies
SMMCalculationScreen implementation
SMMCalculator service
SMM-specific models
Help text system

CF-006: Calculation Results Display
Priority: P0 - Critical Status: ⏳ Pending Complexity: Low Files: Views/Screens/Result/, Models/Domain/CalculationResult.swift

Description
Display detailed calculation results with fee breakdown and action buttons.

User Story

As a user, I want to see detailed calculation results
so that I can understand how the fee was calculated.

Acceptance Criteria
<input disabled="" type="checkbox"> Result summary card with total fee
<input disabled="" type="checkbox"> Detailed fee breakdown table
<input disabled="" type="checkbox"> Calculation parameters display
<input disabled="" type="checkbox"> Action buttons: Share, PDF Export, New Calculation
<input disabled="" type="checkbox"> Currency formatting in Turkish Lira
<input disabled="" type="checkbox"> Clear visual hierarchy
Technical Implementation

// Result model
struct CalculationResult {
    let totalFee: Double
    let baseFee: Double
    let percentageFee: Double
    let additionalFees: [AdditionalFee]
    let parameters: CalculationParameters
    let tariffYear: TariffYear
    let calculationDate: Date
}

// Result display components
struct ResultSummaryCard: View {
    let result: CalculationResult
}

struct FeeBreakdownTable: View {
    let result: CalculationResult
}

Dependencies
ResultScreen implementation
CalculationResult model
Currency formatting utilities
Action button components

CF-007: Multi-Language Support (Turkish/English)
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Localization/, Managers/LocalizationManager.swift

Description
Complete app localization in Turkish and English with dynamic language switching.

User Story

As a user, I want to use the app in Turkish or English
so that I can understand the interface in my preferred language.

Acceptance Criteria
<input disabled="" type="checkbox"> All UI text localized in Turkish and English
<input disabled="" type="checkbox"> Language selection in tab bar
<input disabled="" type="checkbox"> Dynamic language switching without app restart
<input disabled="" type="checkbox"> Localized number and currency formatting
<input disabled="" type="checkbox"> Legal terminology correctly translated
<input disabled="" type="checkbox"> Default language based on system settings
Technical Implementation

// Localization keys
struct LocalizationKeys {
    static let welcome = "welcome"
    static let calculate = "calculate"
    static let result = "result"
    // ... all keys
}

// Localization manager
class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language = .turkish
    
    func localizedString(for key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
    
    func switchLanguage(to language: Language) {
        currentLanguage = language
        // Update app language
    }
}

Dependencies
Localization files (tr.lproj, en.lproj)
LocalizationManager implementation
Language switching UI
Localized formatting utilities

CF-008: Basic Navigation & Tab Bar
Priority: P0 - Critical Status: ⏳ Pending Complexity: Low Files: Views/Components/Navigation/, Services/Navigation/

Description
Tab-based navigation with calculation flow, legislation, language selection, and about screens.

User Story

As a user, I want to navigate easily between app sections
so that I can access different features quickly.

Acceptance Criteria
<input disabled="" type="checkbox"> Tab bar with 4 tabs: Ana Sayfa, Mevzuat, Dil, Hakkında
<input disabled="" type="checkbox"> Smooth navigation between screens
<input disabled="" type="checkbox"> Back button functionality
<input disabled="" type="checkbox"> Navigation state persistence
<input disabled="" type="checkbox"> Tab icons and labels
<input disabled="" type="checkbox"> Active tab highlighting
Technical Implementation

// Tab selection
enum TabSelection: String, CaseIterable {
    case home = "Ana Sayfa"
    case legislation = "Mevzuat"
    case language = "Dil"
    case about = "Hakkında"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .legislation: return "doc.text"
        case .language: return "globe"
        case .about: return "info.circle"
        }
    }
}

// Custom tab bar
struct CustomTabBar: View {
    @Binding var selectedTab: TabSelection
}

Dependencies
NavigationManager implementation
CustomTabBar component
Tab icons and assets
Navigation coordinator

CF-009: Input Validation
Priority: P0 - Critical Status: ⏳ Pending Complexity: Medium Files: Utils/Validation/, Services/Calculation/ValidationService.swift

Description
Comprehensive input validation for all calculation types with user-friendly error messages.

User Story

As a user, I want to receive clear feedback on invalid inputs
so that I can correct them and proceed with calculations.

Acceptance Criteria
<input disabled="" type="checkbox"> Real-time validation feedback
<input disabled="" type="checkbox"> Clear error messages in both languages
<input disabled="" type="checkbox"> Input field highlighting for errors
<input disabled="" type="checkbox"> Validation for amount, party count, time inputs
<input disabled="" type="checkbox"> Business rule validation
<input disabled="" type="checkbox"> Form submission prevention with invalid inputs
Technical Implementation

// Validation service
class ValidationService {
    func validateAmount(_ amount: Double) -> ValidationResult {
        // Amount validation logic
    }
    
    func validatePartyCount(_ count: Int) -> ValidationResult {
        // Party count validation logic
    }
    
    func validateTimeInput(hours: Int, minutes: Int) -> ValidationResult {
        // Time validation logic
    }
}

// Validation result
enum ValidationResult {
    case valid
    case invalid(ValidationError)
}

enum ValidationError: LocalizedError {
    case amountTooLow
    case amountTooHigh
    case invalidPartyCount
    case invalidTimeInput
    
    var errorDescription: String? {
        // Localized error messages
    }
}

Dependencies
ValidationService implementation
Input validator utilities
Error message localization
UI validation feedback

CF-010: Basic Theming (Light/Dark Mode)
Priority: P0 - Critical Status: ⏳ Pending Complexity: Low Files: Theme/, Managers/ThemeManager.swift

Description
Automatic light/dark mode support following system appearance settings.

User Story

As a user, I want the app to automatically adapt to system appearance
so that it's comfortable to use in different lighting conditions.


Acceptance Criteria
<input disabled="" type="checkbox"> Automatic system appearance following
<input disabled="" type="checkbox"> Light and dark theme definitions
<input disabled="" type="checkbox"> All UI components theme-aware
<input disabled="" type="checkbox"> Smooth theme transitions
<input disabled="" type="checkbox"> Theme consistency across screens
<input disabled="" type="checkbox"> Accessibility compliance in both modes
Technical Implementation

// Theme protocol
protocol ThemeProtocol {
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var cardColor: Color { get }
}

// Theme manager
class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeProtocol = LightTheme()
    
    init() {
        // Follow system appearance
        updateTheme()
    }
    
    private func updateTheme() {
        // Update based on system appearance
    }
}

Dependencies
ThemeProtocol definition
Light/Dark theme implementations
ThemeManager singleton
Theme-aware UI components

⚡ ENHANCED FEATURES (Phase 2)
EF-001: PDF Export Functionality
Priority: P1 - High Status: 🔄 Planning Complexity: High Files: Services/External/PDFService.swift, Views/Components/Specialized/PDFViewer.swift

Description
Export calculation results as PDF documents with professional formatting.

User Story
As a user, I want to export calculation results as PDF
so that I can share them with clients or keep records.

Acceptance Criteria
<input disabled="" type="checkbox"> PDF generation from calculation results
<input disabled="" type="checkbox"> Professional PDF formatting with logo
<input disabled="" type="checkbox"> Include calculation parameters and breakdown
<input disabled="" type="checkbox"> PDF sharing via system share sheet
<input disabled="" type="checkbox"> PDF preview before export
<input disabled="" type="checkbox"> Multiple PDF templates
Technical Implementation

// PDF service
class PDFService {
    func generatePDF(from result: CalculationResult) async throws -> Data {
        // PDF generation logic
    }
    
    func createPDFDocument(result: CalculationResult) -> PDFDocument {
        // PDF document creation
    }
}

// PDF viewer
struct PDFViewer: View {
    let pdfData: Data
    @State private var pdfDocument: PDFDocument?
}

Dependencies
PDFKit framework
PDF templates
Sharing functionality
Professional formatting

EF-003: Enhanced Input Components
Priority: P1 - High Status: 🔄 Planning Complexity: Medium Files: Views/Components/Specialized/

Description
Advanced input components with better UX, formatting, and validation.

User Story
As a user, I want intuitive input controls
so that I can enter calculation parameters easily and accurately.

Acceptance Criteria
<input disabled="" type="checkbox"> Currency input with real-time formatting
<input disabled="" type="checkbox"> Number pad optimization for numeric inputs
<input disabled="" type="checkbox"> Stepper controls with haptic feedback
<input disabled="" type="checkbox"> Input masks and constraints
<input disabled="" type="checkbox"> Auto-completion for common values
<input disabled="" type="checkbox"> Voice input support
Technical Implementation

// Enhanced currency input
struct CurrencyInputField: View {
    @Binding var amount: Double
    @State private var textValue: String = ""
    private let formatter = CurrencyFormatter()
    
    var body: some View {
        TextField("Amount", text: $textValue)
            .keyboardType(.decimalPad)
            .onChange(of: textValue) { newValue in
                amount = formatter.doubleValue(from: newValue)
            }
    }
}

// Enhanced stepper
struct PartyCountStepper: View {
    @Binding var count: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Button("-") { decrementCount() }
            Text("\(count)")
            Button("+") { incrementCount() }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Party count: \(count)")
    }
}

Dependencies
Custom input components
Formatting utilities
Accessibility support
Haptic feedback

EF-004: Legislation PDF Viewer
Priority: P1 - High Status: 🔄 Planning Complexity: Medium Files: Views/Screens/Legislation/, Services/External/PDFService.swift

Description
Built-in PDF viewer for legislation and tariff documents with search functionality.

User Story

As a user, I want to view legislation documents within the app
so that I can reference legal requirements while calculating fees.

Acceptance Criteria
<input disabled="" type="checkbox"> PDF viewer with zoom and navigation
<input disabled="" type="checkbox"> Search functionality within PDF
<input disabled="" type="checkbox"> Bookmark important sections
<input disabled="" type="checkbox"> Annotation support
<input disabled="" type="checkbox"> Print PDF functionality
<input disabled="" type="checkbox"> Share PDF sections
Technical Implementation

// PDF viewer
struct PDFViewer: View {
    let pdfURL: URL
    @State private var pdfDocument: PDFDocument?
    @State private var searchText: String = ""
    @State private var currentPage: Int = 0
    
    var body: some View {
        VStack {
            PDFSearchBar(searchText: $searchText)
            PDFViewRepresentable(
                document: pdfDocument,
                currentPage: $currentPage
            )
            PDFNavigationControls(
                currentPage: $currentPage,
                totalPages: pdfDocument?.pageCount ?? 0
            )
        }
    }
}

Dependencies
PDFKit framework
Search implementation
Navigation controls
PDF annotation support

EF-005: Advanced Animations
Priority: P2 - Medium Status: 🔄 Planning Complexity: Medium Files: Views/Modifiers/, Extensions/SwiftUI/

Description
Enhanced animations and transitions for better user experience.

User Story
As a user, I want smooth and engaging animations
so that the app feels modern and responsive.

Acceptance Criteria
<input disabled="" type="checkbox"> Screen transition animations
<input disabled="" type="checkbox"> Button press animations
<input disabled="" type="checkbox"> Loading animations
<input disabled="" type="checkbox"> Result reveal animations
<input disabled="" type="checkbox"> Gesture-based animations
<input disabled="" type="checkbox"> Performance optimization
Technical Implementation

// Animation extensions
extension View {
    func slideTransition() -> some View {
        transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
    }
    
    func bounceAnimation() -> some View {
        modifier(BounceAnimationModifier())
    }
}

// Custom animation modifier
struct BounceAnimationModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.spring(response: 0.5), value: isAnimating)
    }
}

Dependencies
SwiftUI animations
Custom transitions
Performance optimization
Accessibility considerations

🚀 ADVANCED FEATURES (Phase 3)
AF-001: iOS 26+ Liquid Glass Effects
Priority: P2 - Medium Status: 🔮 Future Complexity: High Files: Theme/, Views/Components/

Description
Implementation of iOS 26+ Liquid Glass visual effects for modern appearance.

User Story
As a user, I want to experience cutting-edge iOS design
so that the app feels contemporary and premium.

Acceptance Criteria
<input disabled="" type="checkbox"> Liquid Glass effects on supported devices
<input disabled="" type="checkbox"> Graceful fallback for older iOS versions
<input disabled="" type="checkbox"> Performance optimization
<input disabled="" type="checkbox"> Accessibility compliance
<input disabled="" type="checkbox"> Battery efficiency consideration
Technical Implementation

// Liquid Glass modifier (iOS 26+)
struct LiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .liquidGlassEffect()
        } else {
            content
                .background(.regularMaterial)
        }
    }
}

// Adaptive components
struct AdaptiveCard: View {
    let content: () -> Content
    
    var body: some View {
        content()
            .modifier(LiquidGlassModifier())
    }
}

Dependencies
iOS 26+ framework
Fallback implementations
Performance monitoring
Design system updates

### AF-002: Enhanced Accessibility
**Priority:** P2 - Medium  
**Status:** 🔮 Future  
**Complexity:** Medium  
**Files:** `Services/Accessibility/`, `Views/Components/`

#### Description
Enhanced accessibility features for better VoiceOver and Voice Control support.

#### User Story
As a user with accessibility needs, I want optimized accessibility features
so that I can use the app efficiently with assistive technologies.

#### Acceptance Criteria
- [ ] Enhanced VoiceOver announcements
- [ ] Optimized Voice Control labels
- [ ] Custom accessibility actions
- [ ] Improved navigation hints
- [ ] Better accessibility element grouping
- [ ] Dynamic type support enhancement

#### Technical Implementation
```swift
// Enhanced accessibility extensions
extension View {
    func enhancedAccessibility(
        label: String,
        hint: String? = nil,
        customActions: [AccessibilityCustomAction] = []
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityCustomActions(customActions)
    }
}

// Custom accessibility actions
struct AccessibilityActionProvider {
    static func createCalculateAction(
        handler: @escaping () -> Void
    ) -> AccessibilityCustomAction {
        AccessibilityCustomAction(
            name: "Calculate",
            handler: handler
        )
    }
    
    static func createNavigateBackAction(
        handler: @escaping () -> Void
    ) -> AccessibilityCustomAction {
        AccessibilityCustomAction(
            name: "Go back",
            handler: handler
        )
    }
}
```

#### Dependencies
- iOS Accessibility framework
- VoiceOver optimization
- Voice Control optimization
- Dynamic type support

---

**Features Breakdown Version:** 1.0  
**Last Updated:** July 2025  
**Total Core Features:** 10  
**Total Enhanced Features:** 5  
**Total Advanced Features:** 2  
**Focus:** Simple, efficient mediation fee calculation without data persistence





