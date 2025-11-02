# DENKLEM - Technical Architecture Plan

## 🏗️ Architecture Overview
DENKLEM uses Clean Architecture principles with MVVM-C pattern to ensure maintainability, testability, and scalability for future iOS versions.

## 📊 Architecture Layers

### 1. Application Layer (App Entry Point)
**Purpose:** App initialization, main entry point, and core app configuration  
**Location:** `App/`

```
App/
├── MediationCalculatorApp.swift
├── ContentView.swift
└── AppDelegate.swift
```

### 2. Models Layer (Domain & Data Models)
**Purpose:** Business entities, data models, and calculation logic  
**Location:** `Models/`

```
Models/
├── Domain/
│   ├── DisputeType.swift
│   ├── TariffYear.swift
│   ├── MediationFee.swift
│   └── CalculationResult.swift
├── Data/
│   ├── TariffProtocol.swift
│   ├── Tariff2025.swift
│   ├── Tariff2026.swift
│   └── AboutData.swift
└── Calculation/
    ├── TariffCalculator.swift
    ├── SMMCalculator.swift
    └── TimeCalculator.swift
```

### 3. Views Layer (UI & ViewModels)
**Purpose:** SwiftUI views, ViewModels, and UI components  
**Location:** `Views/`

```
Views/
├── Screens/
│   ├── StartScreen/
│   │   ├── StartScreenView.swift
│   │   └── StartScreenViewModel.swift
│   ├── DisputeCategory/
│   │   ├── DisputeCategoryView.swift
│   │   └── DisputeCategoryViewModel.swift
│   ├── AgreementStatus/
│   │   ├── AgreementStatusView.swift
│   │   └── AgreementStatusViewModel.swift
│   ├── DisputeType/
│   │   ├── DisputeTypeView.swift
│   │   └── DisputeTypeViewModel.swift
│   ├── Input/
│   │   ├── InputView.swift
│   │   └── InputViewModel.swift
│   ├── Result/
│   │   ├── ResultView.swift
│   │   └── ResultViewModel.swift
│   ├── TimeCalculation/
│   │   ├── TimeCalculationView.swift
│   │   └── TimeCalculationViewModel.swift
│   ├── SMMCalculation/
│   │   ├── SMMCalculationView.swift
│   │   └── SMMCalculationViewModel.swift
│   ├── About/
│   │   ├── AboutView.swift
│   │   └── AboutViewModel.swift
│   └── Legislation/
│       ├── LegislationView.swift
│       └── LegislationViewModel.swift
├── Components/
│   ├── Common/
│   │   ├── ThemedButton.swift
│   │   ├── ThemedCard.swift
│   │   ├── ScreenHeader.swift
│   │   ├── ScreenContainer.swift
│   │   ├── AnimatedButton.swift
│   │   └── ScrollableToggleButton.swift
│   ├── Navigation/
│   │   ├── CustomTabBar.swift
│   │   ├── TabBarView.swift
│   │   └── NavigationCoordinator.swift
│   └── Specialized/
│       ├── CurrencyInputField.swift
│       ├── PartyCountStepper.swift
│       └── PDFViewer.swift
└── Modifiers/
    ├── ThemedViewModifier.swift
    ├── KeyboardAdaptiveModifier.swift
    └── SafeAreaModifier.swift
```

### 4. Services Layer (Business Logic & External Services)
**Purpose:** Business services, external integrations, and data management  
**Location:** `Services/`

```
Services/
├── Navigation/
│   ├── NavigationManager.swift
│   ├── RouteManager.swift
│   └── DeepLinkHandler.swift
├── Calculation/
│   ├── MediationCalculationService.swift
│   ├── TariffService.swift
│   └── ValidationService.swift
├── Data/
│   ├── UserDefaultsManager.swift
│   ├── FileManager+Extensions.swift
│   └── ShareService.swift
└── External/
    ├── AppStoreService.swift
    ├── EmailService.swift
    └── PDFService.swift
```

### 5. Managers Layer (App State & Cross-cutting Concerns)
**Purpose:** Application state management and cross-cutting functionalities  
**Location:** `Managers/`

```
Managers/
├── ThemeManager.swift
├── LocalizationManager.swift
├── TariffManager.swift
└── AppStateManager.swift
```

### 6. Infrastructure Layer (Theme, Localization & Resources)
**Purpose:** Theming, internationalization, constants, extensions, and utilities  
**Location:** Multiple directories

```
Theme/
├── ThemeProtocol.swift
├── LightTheme.swift
├── DarkTheme.swift
└── LiquidGlass/
    ├── LiquidGlassStyles.swift
    └── GlassShapes.swift

Localization/
├── LocalizationKeys.swift
├── tr.lproj/
│   └── Localizable.strings
├── en.lproj/
│   └── Localizable.strings
└── LocalizationHelper.swift

Constants/
├── AppConstants.swift
├── LayoutConstants.swift
├── DisputeConstants.swift
├── TariffConstants.swift
└── ValidationConstants.swift

Extensions/
├── Foundation/
│   ├── String+Extensions.swift
│   ├── Double+Extensions.swift
│   ├── Int+Extensions.swift
│   └── Date+Extensions.swift
├── SwiftUI/
│   ├── View+Extensions.swift
│   ├── Color+Extensions.swift
│   ├── Font+Extensions.swift
│   └── Animation+Extensions.swift
└── UIKit/
    ├── UIApplication+Extensions.swift
    └── UIDevice+Extensions.swift

Utils/
├── Formatters/
│   ├── CurrencyFormatter.swift
│   ├── NumberFormatter+Extensions.swift
│   └── DateFormatter+Extensions.swift
├── Validation/
│   ├── InputValidator.swift
│   ├── AmountValidator.swift
│   └── PartyCountValidator.swift
└── Helpers/
    ├── CalculationHelper.swift
    ├── NavigationHelper.swift
    └── KeyboardHelper.swift
```

### 7. Resources Layer (Assets & Supporting Files)
**Purpose:** App resources, assets, and configuration files  
**Location:** `Resources/` & `Supporting Files/`

```
Resources/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   ├── Colors/
│   │   ├── PrimaryColor.colorset/
│   │   └── SecondaryColor.colorset/
│   └── Images/
│       ├── home-icon.imageset/
│       ├── legislation-icon.imageset/
│       └── info-icon.imageset/
├── Fonts/
│   └── CustomFonts.ttf
└── PDF/
    └── arabuluculuk-tarifesi-2025.pdf

Supporting Files/
├── Info.plist
├── MediationCalculator-Bridging-Header.h
└── LaunchScreen.storyboard
```


## 🎯 Design Patterns

### MVVM (Model-View-ViewModel)
```swift
// View
struct StartScreenView: View {
    @StateObject private var viewModel = StartScreenViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScreenContainer {
            // SwiftUI View Implementation
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// ViewModel
class StartScreenViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let calculationService: MediationCalculationService
    private let navigationManager: NavigationManager
    
    init(calculationService: MediationCalculationService = MediationCalculationService(),
         navigationManager: NavigationManager = NavigationManager.shared) {
        self.calculationService = calculationService
        self.navigationManager = navigationManager
    }
    
    func onAppear() {
        // View appearance logic
    }
}

// Model
struct MediationFee {
    let amount: Double
    let currency: String
    let tariffYear: TariffYear
    let disputeType: DisputeType
}
```

### Service Layer Pattern

```swift
// Calculation Service
class MediationCalculationService: ObservableObject {
    private let tariffManager: TariffManager
    private let validationService: ValidationService
    
    init(tariffManager: TariffManager = TariffManager.shared,
         validationService: ValidationService = ValidationService()) {
        self.tariffManager = tariffManager
        self.validationService = validationService
    }
    
    func calculateMediationFee(amount: Double, disputeType: DisputeType) async throws -> CalculationResult {
        // Calculation logic
    }
}

// Navigation Service
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    @Published var currentTab: TabSelection = .home
    @Published var navigationStack: [RouteDestination] = []
    
    func navigate(to destination: RouteDestination) {
        navigationStack.append(destination)
    }
}
```

### Manager Pattern

```swift
// Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var currentTheme: ThemeProtocol = LightTheme()
    @Published var isDarkMode: Bool = false
    
    func toggleTheme() {
        isDarkMode.toggle()
        currentTheme = isDarkMode ? DarkTheme() : LightTheme()
    }
}

// Tariff Manager
class TariffManager: ObservableObject {
    static let shared = TariffManager()
    @Published var currentTariffYear: TariffYear = .year2025
    
    private var tariff2025: Tariff2025 = Tariff2025()
    private var tariff2026: Tariff2026 = Tariff2026()
    
    func getCurrentTariff() -> TariffProtocol {
        switch currentTariffYear {
        case .year2025:
            return tariff2025
        case .year2026:
            return tariff2026
        }
    }
}
```

### Protocol-Based Architecture

```swift
// Tariff Protocol
protocol TariffProtocol {
    var year: Int { get }
    var baseFee: Double { get }
    var percentageRates: [DisputeType: Double] { get }
    
    func calculateFee(for amount: Double, disputeType: DisputeType) -> Double
}

// Theme Protocol
protocol ThemeProtocol {
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var cardBackgroundColor: Color { get }
}
```

## 🔄 Data Flow Architecture

### Simplified Data Flow
```
User Input → View → ViewModel → Service → Manager → Model
                ↓         ↓        ↓         ↓
            UI Updates ← ← ← ← ← ← ← ← ← ← ← ← ←
```

### State Management

```swift
// App State Manager
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    @Published var currentTariffYear: TariffYear = .year2025
    @Published var selectedLanguage: String = "tr"
    @Published var isCalculating: Bool = false
    @Published var lastCalculationResult: CalculationResult?
    
    private init() {}
}

// View-Specific State (ViewModel)
class DisputeCategoryViewModel: ObservableObject {
    @Published var selectedCategory: DisputeCategory?
    @Published var isNavigationReady: Bool = false
    @Published var validationErrors: [ValidationError] = []
    
    private let validationService: ValidationService
    
    init(validationService: ValidationService = ValidationService()) {
        self.validationService = validationService
    }
}
```

## 🎨 SwiftUI Architecture Patterns

### Component Hierarchy

```swift
// Atomic Components (Common)
struct ThemedButton: View { /* Implementation */ }
struct ThemedCard: View { /* Implementation */ }
struct AnimatedButton: View { /* Implementation */ }

// Specialized Components
struct CurrencyInputField: View {
    @Binding var amount: Double
    let formatter: CurrencyFormatter
    
    var body: some View {
        TextField("Amount", value: $amount, formatter: formatter.numberFormatter)
            .themedTextField()
    }
}

struct PartyCountStepper: View {
    @Binding var count: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        Stepper("Party Count: \(count)", value: $count, in: range)
            .themedStepper()
    }
}

// Screen Components
struct InputView: View {
    @StateObject private var viewModel = InputViewModel()
    
    var body: some View {
        ScreenContainer {
            VStack {
                CurrencyInputField(amount: $viewModel.amount, formatter: CurrencyFormatter())
                PartyCountStepper(count: $viewModel.partyCount, range: 1...10)
                ThemedButton("Calculate") {
                    viewModel.calculate()
                }
            }
        }
    }
}
```

### Environment Objects & Managers

```swift
// App Level
@main
struct MediationCalculatorApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var appStateManager = AppStateManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(appStateManager)
                .environmentObject(localizationManager)
        }
    }
}

// View Level
struct InputView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appStateManager: AppStateManager
    @StateObject private var viewModel = InputViewModel()
    
    var body: some View {
        // Use environment objects for theme and app state
    }
}
```

### View Modifiers

```swift
// Themed View Modifier
struct ThemedViewModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(themeManager.currentTheme.textColor)
            .background(themeManager.currentTheme.backgroundColor)
    }
}

// Keyboard Adaptive Modifier
struct KeyboardAdaptiveModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                // Handle keyboard appearance
            }
    }
}

// Extension for easy usage
extension View {
    func themed() -> some View {
        modifier(ThemedViewModifier())
    }
    
    func keyboardAdaptive() -> some View {
        modifier(KeyboardAdaptiveModifier())
    }
}
```

## 🧪 Testing Architecture

### Testing Strategy

```
Unit Tests (70%)
├── Models Tests
│   ├── Domain Model Tests
│   ├── Calculation Logic Tests
│   └── Data Model Tests
├── Services Tests
│   ├── Calculation Service Tests
│   ├── Navigation Service Tests
│   └── Validation Service Tests
├── Managers Tests
│   ├── Theme Manager Tests
│   ├── Tariff Manager Tests
│   └── App State Manager Tests
└── ViewModels Tests
    ├── Screen ViewModel Tests
    ├── Input Validation Tests
    └── State Management Tests

Integration Tests (20%)
├── Service Integration Tests
├── Manager Integration Tests
└── End-to-End Flow Tests

UI Tests (10%)
├── Critical User Journeys
├── Navigation Flow Tests
├── Accessibility Tests
└── Theme Switching Tests
```

### Mock Strategy

```swift
// Protocol-based mocking for services
protocol MediationCalculationServiceProtocol {
    func calculateMediationFee(amount: Double, disputeType: DisputeType) async throws -> CalculationResult
}

class MockMediationCalculationService: MediationCalculationServiceProtocol {
    var mockResult: CalculationResult?
    var shouldThrowError: Bool = false
    
    func calculateMediationFee(amount: Double, disputeType: DisputeType) async throws -> CalculationResult {
        if shouldThrowError {
            throw ValidationError.invalidAmount
        }
        return mockResult ?? CalculationResult.mock
    }
}

// ViewModel testing with dependency injection
class InputViewModelTests: XCTestCase {
    var sut: InputViewModel!
    var mockCalculationService: MockMediationCalculationService!
    
    override func setUp() {
        super.setUp()
        mockCalculationService = MockMediationCalculationService()
        sut = InputViewModel(calculationService: mockCalculationService)
    }
    
    func testCalculateSuccess() async {
        // Test implementation
        mockCalculationService.mockResult = CalculationResult.mock
        await sut.calculate()
        XCTAssertNotNil(sut.calculationResult)
    }
}
```

## 🚀 Performance Optimization

### Service-Based Async Operations

```swift
class MediationCalculationService {
    func calculateMediationFee(amount: Double, disputeType: DisputeType) async throws -> CalculationResult {
        // Async calculation logic
        let tariff = await TariffManager.shared.getCurrentTariff()
        let calculator = TariffCalculator(tariff: tariff)
        let result = try calculator.calculate(amount: amount, disputeType: disputeType)
        return result
    }
}

class PDFService {
    func generatePDF(for result: CalculationResult) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // PDF generation logic
                continuation.resume(returning: pdfData)
            }
        }
    }
}
```

### Memory Management

```swift
// Manager-based singleton pattern with proper lifecycle
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    @Published var navigationStack: [RouteDestination] = []
    
    private init() {}
    
    func navigate(to destination: RouteDestination) {
        navigationStack.append(destination)
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
    
    deinit {
        // Cleanup if needed
    }
}

// Weak references in delegates
protocol NavigationDelegate: AnyObject {
    func didNavigate(to destination: RouteDestination)
}

class ScreenViewModel: ObservableObject {
    weak var navigationDelegate: NavigationDelegate?
    
    func navigateNext() {
        navigationDelegate?.didNavigate(to: .nextScreen)
    }
}
```

## 🔧 Build Configuration

### Environment-Based Configuration

```swift
// App Constants
struct AppConstants {
    static let appName = "DENKLEM"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    static let websiteURL = "https://denklem.org"
    
    #if DEBUG
    static let isDebugMode = true
    static let enableDetailedLogging = true
    #else
    static let isDebugMode = false
    static let enableDetailedLogging = false
    #endif
}

// Tariff Constants
struct TariffConstants {
    static let defaultTariffYear: TariffYear = .year2025
    static let supportedYears: [TariffYear] = [.year2025, .year2026]
    static let baseFee2025: Double = 100.0
    static let baseFee2026: Double = 110.0
}

// Layout Constants
struct LayoutConstants {
    static let screenPadding: CGFloat = 16
    static let cardCornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 50
    static let animationDuration: Double = 0.3
}
```

### Feature Flags

```swift
struct FeatureFlags {
    // UI Features
    static let enableDarkMode = true
    static let enableAnimations = true
    static let enableLiquidGlass = true  // iOS 26+
    static let enableHapticFeedback = true
    
    // Calculation Features
    static let enableAdvancedCalculations = false
    static let enableTimeCalculations = true
    static let enableSMMCalculations = true
    
    // Debug Features
    static let enableLogging = AppConstants.isDebugMode
    static let enablePerformanceMonitoring = AppConstants.isDebugMode
    static let showDebugInfo = AppConstants.isDebugMode
}
```

## 🤖 AI Development Guidelines

### Code Generation Templates

#### SwiftUI View Template
```
"Generate a SwiftUI view following the project structure:
- Location: Views/Screens/[ScreenName]/
- View: [ScreenName]View.swift
- ViewModel: [ScreenName]ViewModel.swift
- Use @StateObject for ViewModel
- Use @EnvironmentObject for managers
- Include proper error handling
- Add accessibility support
- Follow ThemedViewModifier pattern"
```

#### Service Class Template
```
"Generate a service class following the project structure:
- Location: Services/[Category]/
- Use protocol-based architecture
- Include async/await patterns
- Add proper error handling
- Use dependency injection
- Include unit test mock protocols"
```

#### Manager Class Template
```
"Generate a manager class following the project structure:
- Location: Managers/
- Use singleton pattern with static shared instance
- Inherit from ObservableObject
- Use @Published for state properties
- Include proper initialization
- Add documentation comments"
```

### Code Standards
- **Views:** Pure SwiftUI with @StateObject ViewModels and @EnvironmentObject managers
- **ViewModels:** ObservableObject with @Published properties and service dependencies
- **Services:** Protocol-based with async/await patterns and dependency injection
- **Managers:** Singleton pattern with ObservableObject and shared instances
- **Models:** Struct-based with Codable conformance where needed
- **Extensions:** Categorized by Framework (Foundation, SwiftUI, UIKit)
- **Utils:** Helper classes with static methods and formatter utilities

### Architecture Guidelines
- **Separation of Concerns:** Each layer has clear responsibilities
- **Protocol-Oriented:** Use protocols for testability and flexibility
- **State Management:** Centralized in managers, local in ViewModels
- **Navigation:** Manager-based with environment object pattern
- **Theming:** Protocol-based with environment object propagation
- **Localization:** Key-based with manager-driven language switching

## 🎯 Architecture Benefits

### Code Organization
- **Layer Separation:** Clear distinction between Views, Models, Services, and Managers
- **File Structure:** Intuitive folder organization matching feature boundaries
- **Dependency Flow:** Unidirectional dependencies from UI to Services to Models
- **Protocol Adoption:** Interface-based design for better testability

### Maintainability
- **Single Responsibility:** Each class/struct has one clear purpose
- **Modular Design:** Features can be developed and tested independently
- **Consistent Patterns:** MVVM, Service Layer, and Manager patterns throughout
- **Documentation:** Clear naming conventions and architectural guidelines

### Testability
- **Protocol-Based:** Easy to mock services and managers for testing
- **Dependency Injection:** Services injected into ViewModels for testing
- **State Isolation:** ViewModels manage local state, Managers handle global state
- **Async Testing:** Service layer supports async/await testing patterns

### Performance
- **Lazy Loading:** Views and services loaded on demand
- **State Management:** Efficient @Published property updates
- **Memory Efficiency:** Proper singleton usage and weak references
- **Smooth UI:** SwiftUI optimizations with proper state management

### Scalability
- **Feature Addition:** Easy to add new screens following established patterns
- **Service Extension:** New calculation types can be added through protocols
- **Manager Expansion:** Global state can be extended through existing managers
- **Component Reuse:** UI components designed for maximum reusability

### Future-Readiness
- **iOS Version Support:** Architecture supports multiple iOS versions
- **Internationalization:** Built-in localization management system
- **Accessibility:** Consistent accessibility implementation across views
- **Theme Support:** Dynamic theming with protocol-based design

---

**Architecture Version:** 2.0  
**Last Updated:** July 2025  
**Next Review:** December 2025  
**Project Structure:** MediationCalculator SwiftUI Implementation

----

## 🌊 Liquid Glass Architecture (iOS 26+)

### Glass Effect Components
```swift
// LiquidGlassStyles.swift - Button styles
extension ButtonStyle where Self == GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
}

// View extensions for glass effects
extension View {
    func glassCard(theme: ThemeProtocol) -> some View {
        // Implementation
    }
}
```
