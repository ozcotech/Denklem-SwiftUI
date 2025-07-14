# DENKLEM - Screen Flow

## 📱 Application Flow Overview
DENKLEM follows a linear navigation flow with branching paths based on user selections. The app uses a tab-based structure with calculation flows and information screens.

## 🎯 Main Navigation Structure

### Tab Bar Navigation
```
┌─────────────────────────────────────────────────────────────┐
│ [Ana Sayfa] [Mevzuat] [Dil: TR/EN] [Hakkında]               │
└─────────────────────────────────────────────────────────────┘
```

### Primary Calculation Flow
```
StartScreen
↓
[Giriş Button with Year Selection: 2025/2026]
DisputeCategoryScreen
↓
[Selection Based Routing]
├─ [Parasal] → AgreementStatusScreen
├─ [Parasal Olmayan] → DisputeTypeScreen
├─ [Süre Hesaplama] → TimeCalculationScreen
└─ [SMM Hesaplama] → SMMCalculationScreen
```

### Detailed Flow Diagram
```
┌─────────────────┐
│ StartScreen     │
│ (Welcome +      │
│  Year Selection)│
└─────────┬───────┘
          │
          [Select 2025/2026 + Giriş]
          ↓
┌─────────────────┐
│DisputeCategory  │
│ (Selection)     │
│ [Tariff: 2025/2026]
└─────┬───────────┘
      │
      ├─ [Parasal] ─────────────────→ ┌─────────────────┐
      │                               │AgreementStatus  │
      │                               │ (Anlaşma Var?)  │
      │                               └─────┬───────────┘
      │                                     │
      │                                     ├─ [Anlaşma Var] ──→  ┌─────────────────┐
      │                                     │                     │ InputScreen     │
      │                                     │                     │ (Amount Input)  │
      │                                     │                     └─────────────────┘
      │                                     │
      │                                     └─ [Anlaşma Yok] ──→ ┌─────────────────┐
      │                                                          │DisputeTypeScreen│
      │                                                          │ (Type Selection)│
      │                                                          └─────────────────┘
      │
      ├─ [Parasal Olmayan] ─────────────→ ┌─────────────────┐
      │                                   │DisputeTypeScreen│
      │                                   │ (Type Selection)│
      │                                   └─────┬───────────┘
      │                                         │
      │                                         ↓
      │                                  ┌─────────────────┐
      │                                  │ InputScreen     │
      │                                  │(Party Count)    │
      │                                  └─────────────────┘
      │
      ├─ [Süre Hesaplama] ──────────────→ ┌─────────────────┐
      │                                   │TimeCalculation  │
      │                                   │ (Time Input)    │
      │                                   └─────────────────┘
      │
      └─ [SMM Hesaplama] ───────────────→ ┌─────────────────┐
                                          │ SMMCalculation  │
                                          │ (SMM Input)     │
                                          └─────────────────┘
```


### Result Flow
```
All Input Screens
↓
[Hesapla Button]
┌─────────────────┐
│ ResultScreen    │
│ (Calculation    │
│ Results)        │
└─────┬───────────┘
      │
      ├─ [Paylaş] ──────────→ ShareSheet
      ├─ [PDF Export] ──────→ PDF Viewer
      └─ [Yeni Hesaplama] ──→ DisputeCategoryScreen
```


## 📱 Screen Details

### 1. StartScreen
**File:** `Views/Screens/StartScreen/StartScreenView.swift`
**Purpose:** Welcome screen and app entry point with year selection
**Layout:** 
- Logo display
- Welcome message
- Year selection dropdown button (2025/2026)
- Primary CTA button with selected year

**Navigation Actions:**
- **[Giriş - 2025]** → Navigate to DisputeCategoryScreen (with 2025 tariff)
- **[Giriş - 2026]** → Navigate to DisputeCategoryScreen (with 2026 tariff)

**UI Elements:**
- App logo (animated)
- Welcome text
- YearSelectionButton component (dropdown style like AgreementStatus)
- ThemedButton component with year indicator
- Background with overlay

**State Management:**
- Logo animation state
- Selected year state (2025/2026)
- Dropdown visibility state
- Loading state (if needed)

**Year Selection Implementation:**
```swift
@State private var selectedYear: TariffYear = .year2025
@State private var isYearDropdownVisible = false

// Dropdown button similar to AgreementStatus pattern
YearSelectionButton(
    selectedYear: $selectedYear,
    isDropdownVisible: $isYearDropdownVisible
)
```

### 2. DisputeCategoryScreen
**File:** `Views/Screens/DisputeCategory/DisputeCategoryView.swift`
**Purpose:** Main category selection for calculation type
**Layout:**
- Screen header
- Category selection buttons
- Navigation to specific flows

**Navigation Actions:**
- **[Parasal]** → Navigate to AgreementStatusScreen
- **[Parasal Olmayan]** → Navigate to DisputeTypeScreen
- **[Süre Hesaplama]** → Navigate to TimeCalculationScreen
- **[SMM Hesaplama]** → Navigate to SMMCalculationScreen

**UI Elements:**
- ScreenHeader component
- Four ThemedButton components
- Card-based layout
- Category descriptions

**State Management:**
- Selected category state
- Navigation readiness state

### 3. AgreementStatusScreen
**File:** `Views/Screens/AgreementStatus/AgreementStatusView.swift`
**Purpose:** Determine if there's an agreement in monetary disputes
**Layout:**
- Question header
- Two option buttons
- Navigation based on selection

**Navigation Actions:**
- **[Anlaşma Var]** → Navigate to InputScreen (amount input)
- **[Anlaşma Yok]** → Navigate to DisputeTypeScreen

**UI Elements:**
- Question text
- Two ThemedButton components
- Back navigation
- Progress indicator

**State Management:**
- Agreement status selection
- Navigation state

### 4. DisputeTypeScreen
**File:** `Views/Screens/DisputeType/DisputeTypeView.swift`
**Purpose:** Select specific dispute type for calculation
**Layout:**
- Dispute type list
- Selection interface
- Proceed button

**Navigation Actions:**
- **[Dispute Type Selected + Continue]** → Navigate to InputScreen

**UI Elements:**
- Dispute type list
- Selection indicators
- Continue button
- Back navigation

**State Management:**
- Selected dispute type
- List of available types
- Selection validation

### 5. InputScreen
**File:** `Views/Screens/Input/InputView.swift`
**Purpose:** Input screen for calculation parameters
**Layout:** Dynamic based on calculation type
- Amount input (monetary disputes)
- Party count input (non-monetary disputes)
- Validation feedback

**Navigation Actions:**
- **[Hesapla]** → Navigate to ResultScreen
- **[Back]** → Navigate to previous screen

**UI Elements:**
- CurrencyInputField (for monetary)
- PartyCountStepper (for non-monetary)
- Validation messages
- Calculate button

**State Management:**
- Input values
- Validation errors
- Calculation readiness

### 6. ResultScreen
**File:** `Views/Screens/Result/ResultView.swift`
**Purpose:** Display calculation results and actions
**Layout:**
- Result summary
- Fee breakdown
- Action buttons

**Navigation Actions:**
- **[Paylaş]** → Show ShareSheet
- **[PDF Export]** → Show PDF viewer
- **[Yeni Hesaplama]** → Navigate to DisputeCategoryScreen

**UI Elements:**
- Result summary card
- Fee breakdown table
- Action buttons
- Share functionality

**State Management:**
- Calculation results
- Export states
- Sharing states

### 7. TimeCalculationScreen
**File:** `Views/Screens/TimeCalculation/TimeCalculationView.swift`
**Purpose:** Calculate time-based mediation fees
**Layout:**
- Time input fields
- Time calculation parameters
- Calculate button

**Navigation Actions:**
- **[Hesapla]** → Navigate to ResultScreen
- **[Back]** → Navigate to DisputeCategoryScreen

**UI Elements:**
- Time input fields
- Parameter selection
- Calculate button
- Validation messages

**State Management:**
- Time values
- Calculation parameters
- Validation state

### 8. SMMCalculationScreen
**File:** `Views/Screens/SMMCalculation/SMMCalculationView.swift`
**Purpose:** Calculate SMM (Social Security Institution) related fees
**Layout:**
- SMM specific inputs
- Calculation parameters
- Calculate button

**Navigation Actions:**
- **[Hesapla]** → Navigate to ResultScreen
- **[Back]** → Navigate to DisputeCategoryScreen

**UI Elements:**
- SMM input fields
- Parameter selection
- Calculate button
- Help text

**State Management:**
- SMM values
- Calculation parameters
- Validation state

### 9. AboutScreen
**File:** `Views/Screens/About/AboutView.swift`
**Purpose:** App information and credits
**Layout:**
- App information
- Developer credits
- Version information

**Navigation Actions:**
- **[Email Contact]** → Open email client
- **[App Store Rating]** → Open App Store

**UI Elements:**
- App logo and info
- Contact information
- Version details
- External links

**State Management:**
- App version info
- Contact actions

### 10. LegislationScreen
**File:** `Views/Screens/Legislation/LegislationView.swift`
**Purpose:** Display legislation and tariff information
**Layout:**
- PDF viewer
- Legislation content
- Search functionality

**Navigation Actions:**
- **[PDF Actions]** → Share, print, etc.

**UI Elements:**
- PDFViewer component
- Search interface
- Navigation controls

**State Management:**
- PDF loading state
- Search state
- Navigation state

## 🔄 Navigation Flow Logic

### Conditional Navigation Rules

#### From DisputeCategory:
```swift
switch selectedCategory {
case .parasal:
    // Always go to AgreementStatus first
    navigate(to: .agreementStatus)
case .parasalOlmayan:
    // Skip agreement, go directly to DisputeType
    navigate(to: .disputeType)
case .sureHesaplama:
    // Direct to time calculation
    navigate(to: .timeCalculation)
case .smmHesaplama:
    // Direct to SMM calculation
    navigate(to: .smmCalculation)
}
```

#### From AgreementStatus:
```swift
switch agreementStatus {
case .anlasmaVar:
    // Amount input for agreed disputes
    navigate(to: .input(.amount))
case .anlasmaYok:
    // Need to select dispute type first
    navigate(to: .disputeType)
}
```

#### From DisputeType:
```swift
// Always go to input after type selection
navigate(to: .input(.partyCount))
```

### Back Navigation Logic

#### Navigation Stack Management:
```swift
// Back button behavior
switch currentScreen {
case .disputeCategory:
    // Go back to StartScreen
    navigate(to: .start)
case .agreementStatus:
    // Go back to DisputeCategory
    navigate(to: .disputeCategory)
case .disputeType:
    // Check previous screen
    if cameFromAgreementStatus {
        navigate(to: .agreementStatus)
    } else {
        navigate(to: .disputeCategory)
    }
case .input:
    // Go back to previous input screen
    navigateBack()
case .result:
    // Stay on result, use "Yeni Hesaplama"
    // Back button disabled or goes to input
}
```

## 📊 State Management Flow

### Global State (AppStateManager)
```swift
@Published var currentCalculationType: CalculationType?
@Published var currentDisputeType: DisputeType?
@Published var agreementStatus: AgreementStatus?
@Published var selectedTariffYear: TariffYear = .year2025
@Published var calculationResult: CalculationResult?
@Published var currentColorScheme: ColorScheme = .system
```

### Tariff Year Management
```swift
enum TariffYear: String, CaseIterable {
    case year2025 = "2025"
    case year2026 = "2026"
    
    var displayName: String {
        return self.rawValue
    }
    
    var tariffMultiplier: Double {
        switch self {
        case .year2025: return 1.0
        case .year2026: return 1.15 // Example multiplier
        }
    }
}
```

### Theme Management
```swift
class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme = .system
    
    init() {
        // Automatically follow system appearance
        self.colorScheme = .system
    }
    
    func updateColorScheme(to scheme: ColorScheme) {
        colorScheme = scheme
    }
}
```

### Screen-Specific State
```swift
// Each ViewModel manages its own state
class InputViewModel: ObservableObject {
    @Published var amount: Double = 0.0
    @Published var partyCount: Int = 2
    @Published var validationErrors: [ValidationError] = []
    @Published var isCalculating: Bool = false
}
```

### Navigation State
```swift
class NavigationManager: ObservableObject {
    @Published var currentScreen: Screen = .start
    @Published var navigationStack: [Screen] = []
    @Published var canGoBack: Bool = false
}
```

## 🎯 User Journey Examples

### Journey 1: Monetary Dispute with Agreement (2025 Tariff)
```
StartScreen → [Select 2025 + Giriş]
DisputeCategory → [Parasal]
AgreementStatus → [Anlaşma Var]
Input → [Enter Amount + Hesapla]
Result → [View Results with 2025 Tariff + Actions]
```

### Journey 2: Non-Monetary Dispute (2026 Tariff)
```
StartScreen → [Select 2026 + Giriş]
DisputeCategory → [Parasal Olmayan]
DisputeType → [Select Type]
Input → [Enter Party Count + Hesapla]
Result → [View Results with 2026 Tariff + Actions]
```

### Journey 3: Time Calculation (2025 Tariff)
```
StartScreen → [Select 2025 + Giriş]
DisputeCategory → [Süre Hesaplama]
TimeCalculation → [Enter Time + Hesapla]
Result → [View Results with 2025 Tariff + Actions]
```

## 🚀 Deep Linking Support

### URL Scheme Support
```
denklem://calculation?type=parasal&agreement=true&year=2025
denklem://calculation?type=parasal-olmayan&disputeType=isci-isveren&year=2026
denklem://calculation?type=sure&year=2025
denklem://calculation?type=smm&year=2026
```

### Deep Link Handling
```swift
// Handle incoming deep links with year support
func handleDeepLink(url: URL) {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else { return }
    
    // Parse year parameter
    let year = queryItems.first(where: { $0.name == "year" })?.value
    let tariffYear = TariffYear(rawValue: year ?? "2025") ?? .year2025
    
    // Set selected year in AppStateManager
    AppStateManager.shared.selectedTariffYear = tariffYear
    
    // Parse parameters and navigate directly
    navigateToCalculation(with: parameters)
}
```

## 🔧 Navigation Implementation

### SwiftUI Navigation Pattern
```swift
struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.navigationStack) {
            StartScreenView()
                .navigationDestination(for: Screen.self) { screen in
                    destinationView(for: screen)
                }
        }
        .preferredColorScheme(themeManager.colorScheme)
        .onAppear {
            // Automatically follow system appearance
            themeManager.updateColorScheme(to: .system)
        }
    }
    
    @ViewBuilder
    private func destinationView(for screen: Screen) -> some View {
        switch screen {
        case .start: StartScreenView()
        case .disputeCategory: DisputeCategoryView()
        case .agreementStatus: AgreementStatusView()
        case .disputeType: DisputeTypeView()
        case .input: InputView()
        case .result: ResultView()
        case .timeCalculation: TimeCalculationView()
        case .smmCalculation: SMMCalculationView()
        case .about: AboutView()
        case .legislation: LegislationView()
        }
    }
}
```

### Navigation Manager Implementation
```swift
class NavigationManager: ObservableObject {
    @Published var navigationStack: [Screen] = []
    @Published var currentScreen: Screen = .start
    
    func navigate(to screen: Screen) {
        navigationStack.append(screen)
        currentScreen = screen
    }
    
    func navigateBack() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
            currentScreen = navigationStack.last ?? .start
        }
    }
    
    func navigateToRoot() {
        navigationStack.removeAll()
        currentScreen = .start
    }
}
```

## 🧪 Testing Navigation Flow

### Navigation Testing Strategy
```swift
class NavigationFlowTests: XCTestCase {
    func testParasalCalculationFlow() {
        // Test complete flow for monetary disputes
        let flow = NavigationFlow()
        
        flow.start()
        flow.selectCategory(.parasal)
        flow.selectAgreementStatus(.anlasmaVar)
        flow.enterAmount(50000)
        flow.calculate()
        
        XCTAssertEqual(flow.currentScreen, .result)
        XCTAssertNotNil(flow.calculationResult)
    }
    
    func testBackNavigationFlow() {
        // Test back navigation behavior
        let flow = NavigationFlow()
        
        flow.navigateToInputScreen()
        flow.navigateBack()
        
        XCTAssertEqual(flow.currentScreen, .disputeType)
    }
}
```

## 📱 Responsive Flow Behavior

### iPhone vs iPad Adaptations
```swift
// Navigation adapts to screen size
var body: some View {
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad: Side-by-side layout possible
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
    } else {
        // iPhone: Stack navigation
        NavigationStack {
            ContentView()
        }
    }
}
```

### Accessibility Navigation
```swift
// VoiceOver navigation announcements
.accessibilityAction(.escape) {
    navigationManager.navigateBack()
}
.accessibilityAnnouncement("Navigated to \(screenTitle)")

// Voice Control support
.accessibilityLabel("Navigate to \(screenTitle)")
.accessibilityHint("Double tap to navigate")
.accessibilityAddTraits(.isButton)

// Voice Control custom commands
.accessibilityCustomAction(
    name: "Calculate",
    actionHandler: { calculateAction() }
)
.accessibilityCustomAction(
    name: "Go back",
    actionHandler: { navigationManager.navigateBack() }
)
```

## 🎯 Flow Optimization

### Performance Considerations
- **Lazy Loading:** Screens loaded only when needed
- **State Persistence:** Save navigation state for app restoration
- **Memory Management:** Deallocate unused screens
- **Animation Performance:** Smooth transitions between screens

### User Experience Enhancements
- **Progress Indicators:** Show progress through calculation flow
- **Breadcrumb Navigation:** Show current position in flow
- **Quick Actions:** Shortcuts for common calculations
- **Recent Calculations:** Quick access to previous results
- **Year Selection:** Dropdown year selection on start screen (2025/2026)
- **Dark Mode Support:** Automatic system appearance following
- **Tariff Awareness:** All calculations consider selected year tariff

### New Components Required
- **YearSelectionButton:** Dropdown component similar to AgreementStatus
- **TariffYearIndicator:** Shows selected year in navigation
- **ThemeAwareComponents:** All UI components support dark/light modes
- **CalculationEngine:** Updated to handle year-based tariff calculations
- **AccessibilityComponents:** VoiceOver and Voice Control optimized UI elements

### Accessibility Features
- **VoiceOver Support:** Full screen reader support with proper announcements
- **Voice Control Support:** Custom voice commands for navigation and actions
- **Dynamic Type:** Font size adaptation for accessibility
- **High Contrast:** Support for increased contrast modes
- **Reduced Motion:** Respect system animation preferences
- **Button Labels:** Clear and descriptive accessibility labels
- **Navigation Hints:** Helpful hints for complex interactions

---

**Screen Flow Version:** 1.1  
**Last Updated:** July 2025  
**Navigation Pattern:** SwiftUI NavigationStack with Manager Pattern  
**Deep Linking:** Supported for all calculation types with year parameters  
**Accessibility:** Full VoiceOver and Voice Control support with proper flow announcements  
**Theme Support:** Automatic dark/light mode following system preferences  
**Year Selection:** 2025/2026 tariff year selection on start screen