# DENKLEM - Coding Standards

## 📋 Overview
Simple, practical coding standards for DENKLEM mediation calculator. Focus on clean, maintainable SwiftUI code for single developer workflow.

## 🎯 Core Principles

### ✅ **Keep It Simple**
- Write clear, readable code
- Avoid over-engineering
- Use standard SwiftUI patterns
- Prefer simplicity over complexity

### ✅ **Consistency First**
- Follow established patterns
- Use consistent naming
- Maintain file structure
- Apply same formatting

### ✅ **AI-Friendly Code**
- Clear function names
- Consistent patterns
- Well-structured files
- Predictable organization

---

## 🏗️ PROJECT STRUCTURE

### File Organization
```
Views/Screens/[ScreenName]/
├── [ScreenName]View.swift
└── [ScreenName]ViewModel.swift

Views/Components/[Category]/
└── [ComponentName].swift

Services/[Category]/
└── [ServiceName]Service.swift
```

### Naming Conventions
```swift
// Screens
StartScreenView.swift
StartScreenViewModel.swift

// Components
ThemedButton.swift
CurrencyInputField.swift

// Services
TariffCalculationService.swift
ValidationService.swift

// Models
CalculationResult.swift
DisputeType.swift
```

---

## 💻 SWIFT & SWIFTUI STANDARDS

### Code Style
```swift
// Use 4 spaces for indentation
class TariffCalculator {
    func calculateFee(amount: Double) -> Double {
        return amount * 0.1
    }
}

// Line length: 100 characters max
let veryLongVariableName = someFunction(
    parameter1: value1,
    parameter2: value2
)
```

### SwiftUI Structure
```swift
// MVVM Pattern
struct InputView: View {
    @StateObject private var viewModel = InputViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection
            inputSection
            actionSection
        }
        .padding()
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        // Header implementation
    }
    
    private var inputSection: some View {
        // Input implementation
    }
    
    private var actionSection: some View {
        // Action implementation
    }
}
```

### State Management
```swift
// ViewModel pattern
class InputViewModel: ObservableObject {
    @Published var amount: Double = 0.0
    @Published var isValid: Bool = false
    @Published var errorMessage: String = ""
    
    func validateAmount() {
        isValid = amount > 0
        errorMessage = isValid ? "" : "Amount must be greater than 0"
    }
}
```

---

## 🔤 NAMING CONVENTIONS

### Variables & Properties
```swift
// camelCase for variables
var calculationResult: CalculationResult
var isCalculating: Bool
var totalAmount: Double

// Clear, descriptive names
var selectedTariffYear: TariffYear  // Good
var year: TariffYear                // Avoid
```

### Functions
```swift
// Verb-based function names
func calculateFee() -> Double
func validateInput() -> Bool
func showResult()

// Parameter names
func calculateFee(amount: Double, hasAgreement: Bool) -> Double
func navigate(to screen: Screen)
```

### Types & Enums
```swift
// PascalCase for types
struct CalculationResult {
    let totalFee: Double
    let baseFee: Double
}

// Descriptive enum cases
enum DisputeType: String, CaseIterable {
    case isciIsveren = "İşçi-İşveren"
    case ticari = "Ticari"
    case kira = "Kira"
}
```

---

## 📱 SWIFTUI PATTERNS

### View Structure
```swift
struct ContentView: View {
    // MARK: - Properties
    @State private var selectedTab: Tab = .home
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            homeTab
            legislationTab
            aboutTab
        }
    }
    
    // MARK: - View Components
    private var homeTab: some View {
        NavigationStack {
            HomeView()
        }
        .tabItem {
            Image(systemName: "house")
            Text("Ana Sayfa")
        }
        .tag(Tab.home)
    }
}
```

### State & Binding
```swift
// Use @State for local state
@State private var amount: Double = 0.0

// Use @Binding for parent-child communication
struct AmountInput: View {
    @Binding var amount: Double
}

// Use @StateObject for ViewModels
@StateObject private var viewModel = CalculationViewModel()

// Use @EnvironmentObject for shared state
@EnvironmentObject var themeManager: ThemeManager
```

### Modifiers Order
```swift
// Consistent modifier order
Text("Hello")
    .font(.title)
    .foregroundColor(.primary)
    .padding()
    .background(Color.blue)
    .cornerRadius(8)
    .shadow(radius: 4)
```

---

## 🔧 FUNCTIONS & METHODS

### Function Structure
```swift
// Single responsibility
func calculateMonetaryFee(amount: Double, hasAgreement: Bool) -> Double {
    let baseFee = getBaseFee(for: amount)
    let multiplier = hasAgreement ? 0.8 : 1.0
    return baseFee * multiplier
}

// Clear return types
func validateAmount(_ amount: Double) -> ValidationResult {
    guard amount > 0 else {
        return .invalid(.tooLow)
    }
    return .valid
}
```

### Error Handling
```swift
// Use Result type for operations that can fail
func calculateFee(amount: Double) -> Result<Double, CalculationError> {
    guard amount > 0 else {
        return .failure(.invalidAmount)
    }
    
    let fee = amount * 0.1
    return .success(fee)
}

// Custom error types
enum CalculationError: LocalizedError {
    case invalidAmount
    case missingData
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Amount must be greater than 0"
        case .missingData:
            return "Required data is missing"
        }
    }
}
```

---

## 📚 DOCUMENTATION

### Code Comments
```swift
// MARK: - Public Methods
/// Calculates mediation fee based on dispute amount
/// - Parameters:
///   - amount: The dispute amount in Turkish Lira
///   - hasAgreement: Whether parties have reached agreement
/// - Returns: Calculated fee amount
func calculateFee(amount: Double, hasAgreement: Bool) -> Double {
    // Implementation
}

// TODO: Add support for 2026 tariff rates
// FIXME: Handle edge case for zero amount
```

### File Headers
```swift
//
//  TariffCalculator.swift
//  DENKLEM
//
//  Created by [Developer] on [Date]
//  Mediation fee calculation logic
//

import Foundation

/// Service responsible for tariff-based fee calculations
class TariffCalculator {
    // Implementation
}
```

---

## 🧪 TESTING STANDARDS

### Unit Tests
```swift
// Test file naming: [ClassName]Tests.swift
class TariffCalculatorTests: XCTestCase {
    var calculator: TariffCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = TariffCalculator()
    }
    
    func testCalculateMonetaryFee() {
        // Arrange
        let amount = 10000.0
        let hasAgreement = true
        
        // Act
        let result = calculator.calculateFee(amount: amount, hasAgreement: hasAgreement)
        
        // Assert
        XCTAssertEqual(result, 800.0)
    }
}
```

### Test Organization
```swift
// MARK: - Monetary Calculations
func testValidMonetaryAmount() { }
func testInvalidMonetaryAmount() { }

// MARK: - Non-Monetary Calculations
func testValidPartyCount() { }
func testInvalidPartyCount() { }
```

---

## 🎨 UI STANDARDS

### Colors & Themes
```swift
// Use semantic colors
Color.primary
Color.secondary
Color.accentColor

// Theme-aware colors
struct AppColors {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let background = Color("BackgroundColor")
}
```

### Typography
```swift
// Consistent text styles
Text("Title")
    .font(.title2)
    .fontWeight(.semibold)

Text("Body")
    .font(.body)
    .foregroundColor(.secondary)

// Custom text styles
extension Font {
    static let appTitle = Font.system(size: 24, weight: .bold)
    static let appBody = Font.system(size: 16, weight: .regular)
}
```

### Layout & Spacing
```swift
// Consistent spacing
VStack(spacing: 16) {
    HeaderView()
    ContentView()
    FooterView()
}
.padding(.horizontal, 20)
.padding(.vertical, 16)

// Layout constants
struct LayoutConstants {
    static let defaultSpacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
    static let largeSpacing: CGFloat = 24
    static let defaultPadding: CGFloat = 20
}
```

---

## 🔄 VERSION CONTROL

### Git Commit Messages
```
# Format: [type]: [description]
feat: Add tariff year selection
fix: Correct calculation rounding error
docs: Update coding standards
refactor: Simplify validation logic
test: Add unit tests for calculator
```

### Branch Naming
```
# Feature branches
feature/tariff-year-selection
feature/pdf-export

# Bug fixes
fix/calculation-rounding
fix/validation-error

# Documentation
docs/coding-standards
docs/api-documentation
```

---

## 🚀 PERFORMANCE GUIDELINES

### SwiftUI Performance
```swift
// Use @State for simple values
@State private var amount: Double = 0.0

// Use @StateObject for complex objects
@StateObject private var viewModel = CalculationViewModel()

// Avoid heavy computations in body
var body: some View {
    VStack {
        expensiveView
    }
    .onAppear { viewModel.loadData() }
}

private var expensiveView: some View {
    // Computed once and cached
    Text(viewModel.formattedAmount)
}
```

### Memory Management
```swift
// Use weak references to avoid retain cycles
class CalculationService {
    weak var delegate: CalculationDelegate?
    
    func performCalculation() {
        // Implementation
    }
}
```

---

## 📱 ACCESSIBILITY

### Accessibility Labels
```swift
Button("Calculate") {
    calculate()
}
.accessibilityLabel("Calculate mediation fee")
.accessibilityHint("Tap to calculate fee based on entered amount")

TextField("Amount", text: $amountText)
    .accessibilityLabel("Dispute amount")
    .accessibilityValue("Current amount: \(formattedAmount)")
```

### VoiceOver Support
```swift
HStack {
    Text("Amount:")
    TextField("Enter amount", text: $amount)
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Enter dispute amount")
```

---

## 🌍 LOCALIZATION

### String Keys
```swift
// Consistent key naming
struct LocalizationKeys {
    static let calculate = "calculate"
    static let amount = "amount"
    static let result = "result"
    static let disputeType = "dispute_type"
}

// Usage
Text(LocalizationKeys.calculate)
    .localized()
```

### String Files
```swift
// tr.lproj/Localizable.strings
"calculate" = "Hesapla";
"amount" = "Miktar";
"result" = "Sonuç";

// en.lproj/Localizable.strings
"calculate" = "Calculate";
"amount" = "Amount";
"result" = "Result";
```

---

## 🔍 CODE REVIEW CHECKLIST

### Before Submitting
- [ ] Code follows naming conventions
- [ ] Functions have single responsibility
- [ ] Error handling is implemented
- [ ] UI components are accessible
- [ ] Tests are written and passing
- [ ] Documentation is updated

### Review Points
- [ ] Code is readable and maintainable
- [ ] SwiftUI patterns are followed
- [ ] Performance considerations addressed
- [ ] Accessibility requirements met
- [ ] Localization is complete

---

**Coding Standards Version:** 1.0  
**Last Updated:** July 2025  
**Focus:** Simple, maintainable SwiftUI code for single developer  
**Goal:** Clean, consistent, AI-friendly codebase
