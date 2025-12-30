# Denklem - AI Coding Assistant Instructions

## 🎯 Project Overview
Denklem is a **native SwiftUI mediation fee calculator** for Turkish tariffs (2025/2026). Built with iOS 26.0+ requirement, replacing a React Native app with emphasis on native performance and modern iOS features including Liquid Glass design system.

## 🏗️ Architecture Patterns

### Core Architecture: MVVM + Clean Architecture
- **Models/Domain/**: Pure business entities (e.g., `DisputeType`, `TariffYear`, `CalculationResult`)
- **Models/Data/**: Tariff data implementations (`Tariff2025`, `Tariff2026`) conforming to `TariffProtocol`
- **Models/Calculation/**: Pure calculation engines (`TariffCalculator`, `SMMCalculator`, `TimeCalculator`)
- **Views/Screens/[ScreenName]/**: Each screen has paired `View` + `ViewModel` files
- **Theme/**: Protocol-based theming (`ThemeProtocol`, `LightTheme`, `DarkTheme`)

### Key Data Flow Pattern
```swift
// Input → Validation → Calculation → Result
CalculationInput.create(...) // Factory method creates validated input
  → TariffCalculator.calculateFee(input: CalculationInput) 
  → CalculationResult (success/failure wrapper)
```

## 📝 Critical Conventions

### 1. **iOS 26.0+ Only** - All views must have `@available(iOS 26.0, *)`
```swift
@available(iOS 26.0, *)
struct MyView: View { }
```

### 2. **Theme Injection Pattern** (Required for all views)
```swift
@Environment(\.theme) var theme  // Access via environment
.injectTheme(themeManager.currentTheme)  // Inject at app root
```
All colors, fonts, spacing use `theme.*` properties, never hardcoded values.

### 3. **Localization - Zero Hardcoded Strings**
```swift
// ALWAYS use LocalizationKeys
Text(LocalizationKeys.AppInfo.name.localized)
// NEVER: Text("Denklem")
```
Keys defined in `LocalizationKeys.swift`, strings in `Localizable.xcstrings`.

### 4. **Constants-Driven Logic**
All business rules live in `Constants/`:
- `TariffConstants`: Tariff years, brackets, rates, fees
- `ValidationConstants`: Min/max values, error messages  
- `DisputeConstants`: Dispute type mappings

When implementing calculations or validation, **source values from Constants**, never hardcode.

### 5. **Validation Pattern**
```swift
// Domain models have .validate() methods returning ValidationResult
let validation = input.validate()
guard validation.isValid else {
    return CalculationResult.failure(...)
}
```

### 6. **File Naming Convention**
- Screens: `[Name]View.swift` + `[Name]ViewModel.swift` (paired files in same folder)
- Components: `ThemedButton.swift`, `CurrencyInputField.swift` (descriptive, no suffix)
- Services: `[Name]Service.swift`
- Extensions: `[OriginalType]+Extensions.swift`

### 7. **MVVM Screen Template**
Every screen follows this structure:
```swift
// [Name]View.swift
@available(iOS 26.0, *)
struct InputView: View {
    @StateObject private var viewModel = InputViewModel()
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: theme.spacingL) {
            headerSection
            contentSection
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View { }
    private var contentSection: some View { }
}
```

## 🔧 Developer Workflows

### Build & Run
- **Target:** iOS 26.0+ (Xcode simulator/device)
- **No external dependencies** - fully offline app
- **No network calls** - all data local

### Testing Approach
- Unit tests in `DenklemTests/`
- Focus on calculation accuracy in `TariffCalculator`, `SMMCalculator`, `TimeCalculator`
- Test tariff year switching (2025 ↔ 2026)

### Tariff Update Strategy (Critical Business Requirement)
**Goal:** <1 day turnaround for 2026 tariff updates in January 2026.
- Update `TariffConstants.Tariff2026` values
- Update `Tariff2026.swift` implementation
- All calculation logic is year-agnostic (uses `TariffProtocol`)

## 🎨 Design System

### Liquid Glass Theme (iOS 26.0+ Feature)
Located in `Theme/LiquidGlass/LiquidGlassStyles.swift`:
- Optional visual enhancements
- Always provide fallback for non-iOS 26 devices
- Use `theme.*` properties for consistency

### Component Hierarchy
- **Common Components** (`Views/Components/Common/`): `ThemedButton`, `ThemedCard`, `ScreenHeader`
- **Specialized Components** (`Views/Components/Specialized/`): `CurrencyInputField`, `PartyCountStepper`
- **Modifiers** (`Views/Modifiers/`): `ThemedViewModifier`, `KeyboardAdaptiveModifier`

## 📊 Navigation Flow
Linear flow with branching based on calculation type:
```
StartScreen (year selection: 2025/2026)
  → DisputeCategoryScreen (Parasal/Parasal Olmayan/Süre/SMM)
    → [Branches to appropriate input screen]
      → ResultScreen
```
Uses SwiftUI's `NavigationStack` (iOS 16+), not NavigationView.

## 🌍 Localization Details
- **Primary:** Turkish (TR)
- **Secondary:** English (EN)
- **Currency formatting:** Always use `LocalizationHelper.formatCurrency()` for Turkish Lira (₺)
- **Legal terminology:** Accurate translations critical for mediators/lawyers

## 🚨 Common Pitfalls to Avoid
1. **Never hardcode colors/fonts** - always use `theme.*`
2. **Never hardcode strings** - always use `LocalizationKeys.*`
3. **Never hardcode business values** - source from `*Constants.swift`
4. **Don't forget `@available(iOS 26.0, *)`** on all SwiftUI views/types
5. **Don't bypass validation** - use `CalculationInput.create()` factory pattern
6. **Don't use NavigationView** - use `NavigationStack` (iOS 16+)

## 📂 Key Files Reference
- **App entry:** `DenklemApp.swift` - theme initialization
- **Calculation engine:** `TariffCalculator.swift` - core fee logic
- **Domain models:** `Models/Domain/CalculationResult.swift` - input/output types
- **Theme system:** `Theme/ThemeProtocol.swift`, `Extensions/SwiftUI/ThemeEnvironment.swift`
- **Constants:** `Constants/TariffConstants.swift` - all tariff business rules
- **Localization:** `Localization/LocalizationKeys.swift`, `Localizable.xcstrings`

## 🎯 Code Generation Guidelines
When creating new features:
1. **Check existing patterns** in similar screens first
2. **Use theme system** for all UI styling
3. **Add localization keys** to `LocalizationKeys.swift` + `Localizable.xcstrings`
4. **Follow MVVM pairing** for screens (View + ViewModel in same folder)
5. **Write validation** for all user inputs using `ValidationResult` pattern
6. **Document with MARK comments** to organize code sections
