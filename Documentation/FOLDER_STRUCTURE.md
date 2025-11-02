# DENKLEM - Folder Structure

## 📁 Project Organization
DENKLEM follows a practical folder structure optimized for SwiftUI development, single-developer workflow, and AI-assisted code generation.

## 🏗️ Root Directory Structure

```
MediationCalculator/
├── 📱 App/
├── 📊 Models/
├── 🎨 Views/
├── 🔧 Services/
├── 👨‍💼 Managers/
├── 🎨 Theme/
├── 🌍 Localization/
├── 📋 Constants/
├── 🔗 Extensions/
├── 🛠️ Utils/
├── 📦 Resources/
└── 📄 Supporting Files/
```

## 📱 App Layer - Application Entry Point

**Purpose:** App initialization, main entry point, and core configuration  
**Location:** `App/`

```
App/
├── MediationCalculatorApp.swift
├── ContentView.swift
└── AppDelegate.swift
```

## 📊 Models Layer - Business Logic & Data

**Purpose:** Business entities, data models, and calculation logic  
**Location:** `Models/`

```
Models/
├── Domain/                        # Business entities
│   ├── DisputeType.swift          # Dispute type enum
│   ├── TariffYear.swift           # Tariff year enum
│   ├── MediationFee.swift         # Fee calculation result
│   └── CalculationResult.swift    # Complete calculation output
├── Data/                          # Data structures
│   ├── TariffProtocol.swift       # Tariff interface
│   ├── Tariff2025.swift           # 2025 tariff data
│   ├── Tariff2026.swift           # 2026 tariff data (future)
│   └── AboutData.swift            # App information data
└── Calculation/                   # Calculation engines
    ├── TariffCalculator.swift     # Main calculation logic
    ├── SMMCalculator.swift        # SMM calculation logic
    └── TimeCalculator.swift       # Time calculation logic
```

### File Responsibilities:
- **Domain/:** Pure business entities, no external dependencies
- **Data/:** Tariff data structures, protocol definitions
- **Calculation/:** Core calculation algorithms, business rules

## 🎨 Views Layer - UI Components & Screens

**Purpose:** SwiftUI views, ViewModels, and reusable UI components  
**Location:** `Views/`

```
Views/
├── Screens/                                # App screens (MVVM pattern)
│   ├── StartScreen/
│   │   ├── StartScreenView.swift           # Landing screen UI
│   │   └── StartScreenViewModel.swift      # Start screen logic
│   ├── DisputeCategory/
│   │   ├── DisputeCategoryView.swift       # Category selection UI
│   │   └── DisputeCategoryViewModel.swift  # Category logic
│   ├── AgreementStatus/
│   │   ├── AgreementStatusView.swift       # Agreement status UI
│   │   └── AgreementStatusViewModel.swift  # Agreement logic
│   ├── DisputeType/
│   │   ├── DisputeTypeView.swift           # Dispute type selection
│   │   └── DisputeTypeViewModel.swift      # Dispute type logic
│   ├── Input/
│   │   ├── InputView.swift                 # Input form UI
│   │   └── InputViewModel.swift            # Input validation logic
│   ├── Result/
│   │   ├── ResultView.swift                # Calculation result display
│   │   └── ResultViewModel.swift           # Result formatting logic
│   ├── TimeCalculation/
│   │   ├── TimeCalculationView.swift       # Time calculation UI
│   │   └── TimeCalculationViewModel.swift  # Time calc logic
│   ├── SMMCalculation/
│   │   ├── SMMCalculationView.swift        # SMM calculation UI
│   │   └── SMMCalculationViewModel.swift   # SMM calc logic
│   ├── About/
│   │   ├── AboutView.swift                 # About screen UI
│   │   └── AboutViewModel.swift            # About screen logic
│   └── Legislation/
│       ├── LegislationView.swift           # Legislation viewer
│       └── LegislationViewModel.swift      # Legislation logic
├── Components/                             # Reusable UI components
│   ├── Common/                             # General-purpose components
│   │   ├── ThemedButton.swift              # Standard app button
│   │   ├── ThemedCard.swift                # Standard app card
│   │   ├── ScreenHeader.swift              # Screen title header
│   │   ├── ScreenContainer.swift           # Screen wrapper
│   │   ├── AnimatedButton.swift            # Animated button variant
│   │   └── ScrollableToggleButton.swift    # Toggle button
│   ├── Navigation/                         # Navigation components
│   │   ├── CustomTabBar.swift              # Custom tab bar design
│   │   ├── TabBarView.swift                # Tab bar implementation
│   │   └── NavigationCoordinator.swift     # Navigation logic
│   └── Specialized/                        # Feature-specific components
│       ├── CurrencyInputField.swift        # Currency input field
│       ├── PartyCountStepper.swift         # Party count stepper
│       └── PDFViewer.swift                 # PDF document viewer
└── Modifiers/                              # SwiftUI view modifiers
    ├── ThemedViewModifier.swift            # Theme application modifier
    ├── KeyboardAdaptiveModifier.swift      # Keyboard handling
    └── SafeAreaModifier.swift              # Safe area management
```

### File Responsibilities:
- **Screens/:** Complete screen implementations with MVVM pattern
- **Components/Common/:** Reusable UI components for entire app
- **Components/Navigation/:** Navigation-specific UI components
- **Components/Specialized/:** Feature-specific UI components
- **Modifiers/:** SwiftUI view modifiers for common functionality

## 🔧 Services Layer - Business Services

**Purpose:** Business logic services, external integrations, and data operations  
**Location:** `Services/`

```
Services/
├── Navigation/                              # Navigation services
│   ├── NavigationManager.swift             # Navigation state management
│   ├── RouteManager.swift                  # Route definitions
│   └── DeepLinkHandler.swift               # Deep link handling
├── Calculation/                            # Calculation services
│   ├── MediationCalculationService.swift   # Main calculation service
│   ├── TariffService.swift                 # Tariff data service
│   └── ValidationService.swift             # Input validation service
├── Data/                                   # Data services
│   ├── UserDefaultsManager.swift           # User preferences
│   ├── FileManager+Extensions.swift        # File operations
│   └── ShareService.swift                  # Sharing functionality
└── External/                               # External integrations
    ├── AppStoreService.swift               # App Store interactions
    ├── EmailService.swift                  # Email sharing
    └── PDFService.swift                    # PDF generation
```

### File Responsibilities:
- **Navigation/:** Screen navigation, routing, deep linking
- **Calculation/:** Business calculation logic, validation
- **Data/:** Data persistence, file operations, sharing
- **External/:** Third-party integrations, external services

## 👨‍💼 Managers Layer - App State Management

**Purpose:** Global state management and cross-cutting concerns  
**Location:** `Managers/`

```
Managers/
├── ThemeManager.swift           # Theme and appearance management
├── LocalizationManager.swift    # Language and localization
├── TariffManager.swift          # Tariff data management
└── AppStateManager.swift        # Global app state
```


### File Responsibilities:
- **ThemeManager.swift:** Light/dark mode, theme switching
- **LocalizationManager.swift:** Language switching, localized strings
- **TariffManager.swift:** Current tariff selection, tariff switching
- **AppStateManager.swift:** Global app state, user sessions

## 🎨 Theme Layer - Design System

**Purpose:** App theming, design tokens, and visual consistency  
**Location:** `Theme/`

```
Theme/
├── ThemeProtocol.swift          # Theme interface with Liquid Glass support
├── LightTheme.swift            # Light mode implementation
├── DarkTheme.swift             # Dark mode implementation
└── LiquidGlass/                # Liquid Glass specific components
    ├── LiquidGlassStyles.swift # Button styles, view modifiers
    └── GlassShapes.swift       # Custom shapes (optional)
```


### File Responsibilities:
- **ThemeProtocol.swift:** Theme interface, color/font contracts
- **LightTheme.swift:** Light mode color scheme
- **DarkTheme.swift:** Dark mode color scheme  
- **LiquidGlass/:** Components and styles for Liquid Glass effect
    - **LiquidGlassStyles.swift:** Styles for buttons and views
    - **GlassShapes.swift:** Custom shapes for Liquid Glass effect (optional)
- **Colors.swift:** Semantic color definitions
- **Typography.swift:** Font styles, text formatting
- **Dimensions.swift:** Layout constants, spacing rules

## 🌍 Localization Layer - Internationalization

**Purpose:** Multi-language support and localized content  
**Location:** `Localization/`

```
Localization/
├── LocalizationKeys.swift       # String key definitions
├── tr.lproj/                    # Turkish localization
│   └── Localizable.strings      # Turkish strings
├── en.lproj/                    # English localization
│   └── Localizable.strings      # English strings
└── LocalizationHelper.swift     # Localization utilities
```

### File Responsibilities:
- **LocalizationKeys.swift:** Centralized string key definitions
- **tr.lproj/:** Turkish language strings
- **en.lproj/:** English language strings
- **LocalizationHelper.swift:** Localization utility functions

## 📋 Constants Layer - App Constants

**Purpose:** App-wide constants, configuration values  
**Location:** `Constants/`

```
Constants/
├── AppConstants.swift           # General app constants
├── LayoutConstants.swift        # UI layout constants
├── DisputeConstants.swift       # Dispute type constants
├── TariffConstants.swift        # Tariff-related constants
└── ValidationConstants.swift    # Validation rules
```

### File Responsibilities:
- **AppConstants.swift:** App name, version, general settings
- **LayoutConstants.swift:** Spacing, padding, sizing constants
- **DisputeConstants.swift:** Dispute type definitions, defaults
- **TariffConstants.swift:** Tariff years, rates, thresholds
- **ValidationConstants.swift:** Input validation rules, limits

## 🔗 Extensions Layer - Framework Extensions

**Purpose:** Framework extensions for enhanced functionality  
**Location:** `Extensions/`

```
Extensions/
├── Foundation/                              # Foundation framework extensions
│   ├── String+Extensions.swift              # String utilities
│   ├── Double+Extensions.swift              # Double formatting
│   ├── Int+Extensions.swift                 # Integer utilities
│   └── Date+Extensions.swift                # Date formatting
├── SwiftUI/                                 # SwiftUI framework extensions
│   ├── View+Extensions.swift                # View utilities
│   ├── Color+Extensions.swift               # Color utilities
│   ├── Font+Extensions.swift                # Font utilities
│   └── Animation+Extensions.swift           # Animation utilities
└── UIKit/                                   # UIKit framework extensions
    ├── UIApplication+Extensions.swift       # App utilities
    └── UIDevice+Extensions.swift            # Device utilities
```


### File Responsibilities:
- **Foundation/:** Basic data type extensions, utilities
- **SwiftUI/:** SwiftUI-specific extensions, view helpers
- **UIKit/:** UIKit bridging, device information

## 🛠️ Utils Layer - Utility Functions

**Purpose:** Helper functions, formatters, and utility classes  
**Location:** `Utils/`

```
Utils/
├── Formatters/                               # Data formatting utilities
│   ├── CurrencyFormatter.swift               # Currency formatting
│   ├── NumberFormatter+Extensions.swift      # Number formatting
│   └── DateFormatter+Extensions.swift        # Date formatting
├── Validation/                               # Input validation utilities
│   ├── InputValidator.swift                  # General input validation
│   ├── AmountValidator.swift                 # Amount validation
│   └── PartyCountValidator.swift             # Party count validation
└── Helpers/                                  # General helper functions
    ├── CalculationHelper.swift               # Calculation utilities
    ├── NavigationHelper.swift                # Navigation utilities
    └── KeyboardHelper.swift                  # Keyboard handling
```


### File Responsibilities:
- **Formatters/:** Data formatting, number/currency/date formatting
- **Validation/:** Input validation, business rule validation
- **Helpers/:** General utility functions, common operations

## 📦 Resources Layer - App Resources

**Purpose:** App assets, resources, and static content  
**Location:** `Resources/`

```
Resources/
├── Assets.xcassets/                    # App assets
│   ├── AppIcon.appiconset/             # App icon variants
│   ├── Colors/                         # Color assets
│   │   ├── PrimaryColor.colorset/      # Primary color
│   │   └── SecondaryColor.colorset/    # Secondary color
│   └── Images/                         # Image assets
│       ├── home-icon.imageset/         # Home tab icon
│       ├── legislation-icon.imageset/  # Legislation tab icon
│       └── info-icon.imageset/         # About tab icon
├── Fonts/                              # Custom fonts
│   └── CustomFonts.ttf                 # Custom font files
└── PDF/                                # PDF documents
    └── arabuluculuk-tarifesi-2025.pdf  # Tariff document
```

### File Responsibilities:
- **Assets.xcassets/:** App icons, colors, images
- **Fonts/:** Custom font files for typography
- **PDF/:** Static PDF documents, tariff references

## 📄 Supporting Files Layer - Project Configuration

**Purpose:** Project configuration, info files, and build settings  
**Location:** `Supporting Files/`

```
Supporting Files/
├── Info.plist                              # App configuration
├── MediationCalculator-Bridging-Header.h   # Objective-C bridge
└── LaunchScreen.storyboard                 # Launch screen
```

### File Responsibilities:
- **Info.plist:** App metadata, permissions, configuration
- **Bridging-Header.h:** Objective-C/Swift bridging if needed
- **LaunchScreen.storyboard:** App launch screen design

## 🎯 Folder Structure Benefits

### For Single Developer:
- **🔍 Easy Navigation:** Intuitive folder names, quick file location
- **📁 Logical Organization:** Related files grouped together
- **⚡ Fast Development:** Clear structure reduces decision fatigue
- **🧹 Maintenance:** Easy to update and refactor code

### For AI-Assisted Development:
- **📋 Clear Targets:** Specific folder paths for code generation
- **📝 Consistent Patterns:** Predictable file naming and location
- **🤖 Prompt Optimization:** Easy to specify exact file locations
- **🔄 Code Generation:** Structured approach for AI code creation

### For Code Quality:
- **🏗️ Separation of Concerns:** Each folder has single responsibility
- **🔗 Dependency Management:** Clear dependency directions
- **🧪 Testing:** Easy to locate and test specific components
- **📊 Code Review:** Structured approach for code organization

### For Future Scalability:
- **📈 Growth Support:** Easy to add new features and screens
- **🔧 Maintenance:** Clear structure for bug fixes and updates
- **👥 Team Expansion:** Easy onboarding for future developers
- **📱 Platform Extension:** Structure supports iPad, Mac expansion

## 🚀 Development Workflow

### Adding New Feature:
1. **Screen:** Create folder in `Views/Screens/[FeatureName]/`
2. **Business Logic:** Add service in `Services/[Category]/`
3. **Data Model:** Add entity in `Models/Domain/`
4. **UI Components:** Create in `Views/Components/[Category]/`
5. **Constants:** Add in `Constants/[FeatureName]Constants.swift`

### Adding New Screen:
1. **Create Folder:** `Views/Screens/[ScreenName]/`
2. **Add Files:** `[ScreenName]View.swift` + `[ScreenName]ViewModel.swift`
3. **Navigation:** Update `Services/Navigation/RouteManager.swift`
4. **Strings:** Add keys to `Localization/LocalizationKeys.swift`

### Adding New Service:
1. **Create File:** `Services/[Category]/[ServiceName].swift`
2. **Protocol:** Define protocol in same file
3. **Implementation:** Implement service class
4. **Dependency:** Register in manager or use direct instantiation

## 🤖 AI Development Guidelines

### File Creation Prompts:

#### SwiftUI Screen Creation:
```
"Create a new SwiftUI screen:

Location: Views/Screens/[ScreenName]/
Files: [ScreenName]View.swift and [ScreenName]ViewModel.swift
Pattern: MVVM with @StateObject and @EnvironmentObject
Include: Error handling, accessibility, theming"
```

#### Service Creation:
```
"Create a new service:

Location: Services/[Category]/
Pattern: Protocol-based with async/await
Include: Error handling, dependency injection
Testing: Include protocol for mocking"
```

#### Component Creation:
```
"Create a reusable SwiftUI component:

Location: Views/Components/[Category]/
Pattern: Configurable with @Binding properties
Include: Theming, accessibility, documentation
Usage: Include preview and usage examples"
```


## 📊 File Naming Conventions

### Views:
- **Screens:** `[ScreenName]View.swift` / `[ScreenName]ViewModel.swift`
- **Components:** `[ComponentName].swift` (e.g., `ThemedButton.swift`)
- **Modifiers:** `[ModifierName]Modifier.swift` (e.g., `ThemedViewModifier.swift`)

### Services:
- **Services:** `[ServiceName]Service.swift` (e.g., `ValidationService.swift`)
- **Managers:** `[ManagerName]Manager.swift` (e.g., `ThemeManager.swift`)
- **Protocols:** `[ProtocolName]Protocol.swift` (e.g., `TariffProtocol.swift`)

### Models:
- **Entities:** `[EntityName].swift` (e.g., `DisputeType.swift`)
- **Data Models:** `[ModelName].swift` (e.g., `Tariff2025.swift`)
- **Calculators:** `[CalculatorName]Calculator.swift` (e.g., `TariffCalculator.swift`)

### Extensions:
- **Extensions:** `[TypeName]+Extensions.swift` (e.g., `String+Extensions.swift`)
- **Categories:** `[FrameworkName]/[TypeName]+Extensions.swift`

### Constants:
- **Constants:** `[CategoryName]Constants.swift` (e.g., `AppConstants.swift`)
- **Keys:** `[CategoryName]Keys.swift` (e.g., `LocalizationKeys.swift`)

---

**Folder Structure Version:** 1.0  
**Last Updated:** July 2025  
**Project:** DENKLEM - Mediation Calculator SwiftUI  
**Architecture:** Practical SwiftUI Structure for Single Developer + AI-Assisted Development

