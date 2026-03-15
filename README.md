# 🧮 DENKLEM – Mediation Fee Calculator

**DENKLEM** (from Latin "aequare" = "to equalize") is a comprehensive **native iOS application** for calculating mediation fees according to Turkish law. Written from scratch with SwiftUI, the app performs calculations based on the 2025 and 2026 mediation fee tariffs.

The name "DENKLEM" reflects the concept of creating equality and balance between parties, which aligns perfectly with the essence of mediation: establishing balance and fair resolution between disputing parties.

> 🚀 **First Version Available on the App Store!**
> Download now: [DENKLEM on App Store](https://apps.apple.com/us/app/denklem/id6746580824)

> [![Built with Claude](https://img.shields.io/badge/Built%20with-Claude%20by%20Anthropic-D97757?style=for-the-badge&logo=anthropic&logoColor=white)](https://claude.ai)
>
> This entire project was developed with the support of [Claude](https://claude.ai) by Anthropic — from architecture decisions to code implementation, testing strategies, and accessibility improvements.

---

## ✨ Why SwiftUI Version?

### 🎯 **Native Performance**
- **Faster**: 60% faster calculations compared to the React Native version
- **Low Memory Usage**: Average memory consumption below 50MB
- **Smooth Animations**: Consistent 60fps performance
- **Instant Launch**: App startup time under 2 seconds

### 🌟 **Modern iOS Features**
- **Liquid Glass Design**: Modern glass effects for iOS 26.0+
- **Native Components**: Fully SwiftUI and native iOS APIs
- **Future-Ready**: Optimized for iOS 26.0+
- **Offline-First**: Works completely offline

### 🎨 **Enhanced User Experience**
- **Trilingual Support**: Turkish, English, and Swedish (instant language switching)
- **Light/Dark Mode**: Automatic theme support
- **Liquid Glass UI**: Optional modern visual effects
- **Animated Background**: Optional animated sky background
- **Accessibility**: Full VoiceOver support

---

## 🚀 Key Features

### 💰 **Core Functionality - Fee Calculation**
- **2025 & 2026 Official Tariffs**: Based on current Turkish mediation fee tariff
- **Smart Calculation Engine**: Handles both monetary and non-monetary disputes
- **Dual Scenario Support**: Different calculations for agreement vs. non-agreement cases
- **Per-Screen Tariff Selection**: Each calculation screen has its own year picker (2026 selected by default)

### 📱 **User Experience**
- **Intuitive Step-by-Step Flow**: Guided process from start to finish
- **Cable Connector System**: Visual cable guides showing calculation flow paths
- **Native iOS Navigation**: Swipe gestures and native transitions
- **Persistent Tab Bar**: Quick access to home, calculations, legislation, and settings
- **Trilingual**: Complete Turkish, English, and Swedish localization
- **Modern Native Design**: Professional and user-friendly interface

### 🧮 **Additional Calculators**
- **Time Calculation**: Calculate mediation process durations
- **Freelance Receipt (SMM)**: Receipt calculations with tax deductions
- **Attorney Fee Calculation**: Power of attorney fee calculations in mediation process
- **Reinstatement Disputes**: Calculations for reinstatement cases
- **Serial Disputes**: Special calculations for serial dispute cases
- **Tenancy Disputes**: Special calculations for eviction and rent determination disputes (attorney + mediation fees)
- **Comprehensive Results**: Detailed explanations with tax implications

### 🔧 **Technical Features**
- **iOS 26.0+ Minimum**: Optimized for latest iOS features
- **Native SwiftUI**: Fully developed with Swift and SwiftUI
- **Offline Capability**: No internet required for calculations
- **Real-Time Updates**: Instant calculation results
- **Responsive Design**: Optimized for all iPhone screen sizes

### 🎨 **Design System**
- **Liquid Glass Theme**: Modern glass effect styles for iOS 26.0+
- **Theme Support**: Automatic Light and Dark mode switching
- **Consistent Components**: Standard UI components throughout the app
- **Customizable Colors**: Theme-based color system

---

## 📱 User Journey & Screens

### **1. StartScreen (Welcome Screen)**
Application entry point:
- **Mini Quiz**: Quick legal knowledge survey
- **Entry Button**: Direct navigation to calculations screen
- **Logo**: App branding

### **2. CalculationsScreen (Calculations)**
Central hub for all calculation types with categorized buttons:
- **General Calculation**:
  - 🧮 **Mediation Fee**: General mediation fee calculation
- **Special Calculations**:
  - 🏠 **Tenancy Disputes**: Eviction and rent determination
  - 👨‍⚖️ **Reinstatement**: Reinstatement dispute cases
  - 🏢 **Attorney Fee**: Power of attorney fee in mediation
  - 📋 **Serial Disputes**: Serial dispute cases
- **Other Calculations**:
  - 📝 **SMM Calculation**: Freelance receipt calculator
  - ⏰ **Time Calculation**: Mediation process durations

### **3. MediationFeeScreen (Unified Calculation)**
Single-screen mediation fee calculation with cable connector visual guides:
- **Year Selection**: Dropdown picker for 2025/2026 tariff (2026 default)
- **Agreement Status**: Toggle buttons (monetary disputes only)
- **Dispute Type**: Dropdown menu with 10 dispute types
- **Cable Connectors**: Visual circuit-board cables guiding users through the calculation flow
- **Input Fields**: Agreement amount (agreed) or party count (not agreed)
- **Inline Result Card**: Calculation results displayed directly on screen
- **Detailed View**: Tap result card to open full result sheet

### **4. ResultScreen (Result Screen)**
Comprehensive result display (as Sheet):
- **Main Fee**: Calculated mediation fee
- **Tax Information**: Withholding tax calculations when applicable
- **SMM Details**: Complete SMM breakdown for professional invoicing

### **5. Additional Screens**
- **TimeCalculationScreen**: Calculate mediation process durations
- **SmmCalculationScreen**: Detailed freelance receipt calculations
- **LegislationScreen**: Access current mediation legislation
- **SettingsScreen**: Language, theme, animated background, and about information

### **6. Tab Bar Navigation**
Tab bar accessible from any screen:
- 🏠 **Home**: Return to start screen
- 🧮 **Calculations**: Access all calculation types (general, special, and other calculators)
- 📚 **Legislation**: View legal legislation
- ⚙️ **Settings**: Language selection (Turkish ↔ English ↔ Swedish), theme preferences (Light/Dark), animated background toggle, and about information

---

## 📸 Screenshots

Below are screenshots hosted in the separate screenshots repository: [Denklem Screenshots Repository](https://github.com/ozcotech/Denklem-SwiftUI-screenshots)

### Main Flow Screenshots

<table>
  <tr>
    <td align="center" width="25%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/start-screen.png" width="200" alt="Start Screen">
      <br><strong>Start Screen</strong>
    </td>
    <td align="center" width="25%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/calculations-screen.png" width="200" alt="Calculations Screen">
      <br><strong>Calculations Screen</strong>
    </td>
    <td align="center" width="25%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/dispute-type-screen-1.png" width="200" alt="Dispute Type 1">
      <br><strong>Dispute Type 1</strong>
    </td>
    <td align="center" width="25%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/dispute-type-screen-2.png" width="200" alt="Dispute Type 2">
      <br><strong>Dispute Type 2</strong>
    </td>
  </tr>
</table>

### Input & Results Screenshots

<table>
  <tr>
    <td align="center" width="50%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/result-screen.png" width="200" alt="Result Screen">
      <br><strong>Result Screen</strong>
    </td>
    <td align="center" width="50%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/result-screen-light.png" width="200" alt="Result Screen Light">
      <br><strong>Result Screen Light</strong>
    </td>
  </tr>
</table>

### Additional Calculators Screenshots

<table>
  <tr>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/attorney-fee-screen.png" width="200" alt="Attorney Fee">
      <br><strong>Attorney Fee</strong>
    </td>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/legislation-screen.png" width="200" alt="Legislation">
      <br><strong>Legislation</strong>
    </td>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/settings-screen.png" width="200" alt="Settings">
      <br><strong>Settings</strong>
    </td>
  </tr>
</table>

> Images hosted in the `Denklem-SwiftUI-screenshots` repository. Links point to raw images on GitHub.

---

## 🎯 How It Works

### **Monetary Dispute - With Agreement:**
1. Calculations → Mediation Fee → Select year → "Monetary" → "Agreement" → Select dispute type
2. Follow cable connector guides → Enter agreement amount
3. View inline result card → Tap for detailed breakdown

### **Monetary Dispute - No Agreement:**
1. Calculations → Mediation Fee → Select year → "Monetary" → "No Agreement" → Select dispute type
2. Follow cable connector guides → Enter number of parties
3. View inline result card → Tap for detailed breakdown with SMM

### **Non-Monetary Dispute:**
1. Calculations → Mediation Fee → Select year → "Non-Monetary" → Select dispute type
2. Follow cable connector guides → Enter number of parties
3. View inline result card → Tap for detailed breakdown

### **Additional Features:**
- **Tab Bar Navigation**: Always accessible home, calculations, legislation, and settings
- **Cable Connector Guides**: Visual flow indicators on calculation screens
- **Native iOS Controls**: Natural iOS transitions and gestures

---

## 🛠️ Tech Stack

### **Core Framework**
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming
- **iOS 26.0+**: Minimum supported version

### **Architecture**
- **MVVM Pattern**: Model-View-ViewModel architecture
- **Clean Architecture**: Layered architecture structure
- **Protocol-Oriented**: Protocol-based design

### **UI & Design**
- **Liquid Glass Theme**: Modern glass effect design (iOS 26+)
- **Custom Components**: Custom UI components
- **Theme Manager**: Dynamic theme management
- **Localization Manager**: Multi-language support

### **Data & Calculation**
- **Local Storage**: Lightweight data storage with UserDefaults
- **Pure Swift Calculations**: Calculation engines without dependencies
- **Validation Engine**: Input validation system

---

## 📅 Version Information

- **Current Version**: 2.5.6
- **Supported Years**: 2025 and 2026 mediation tariffs
- **Platform**: iOS 26.0+ / iPadOS 26.0+
- **Languages**: Turkish (TR), English (EN), and Swedish (SV)
- **Last Update**: March 2026
- **Based on**: 2025 and 2026 official mediation fee tariffs

---

## 🧪 Development Setup

### **Requirements**
- macOS 26.0+ (a Mac with Apple M1 chip or later)
- Xcode 26.0+
- iOS 26.0+ / iPadOS 26.0+
- Git

### **Installation Steps**

```bash
# Clone the repository
git clone https://github.com/ozcotech/Denklem-SwiftUI.git
cd Denklem-SwiftUI

# Open with Xcode
open Denklem.xcodeproj

# Or from Xcode:
# File → Open → Select Denklem.xcodeproj
```

### **Running**

1. Open project in Xcode
2. Select `Denklem` as target
3. Choose simulator or physical device (iOS 26.0+)
4. Run with Command + R

### **Build & Test**

```bash
# Run test suite
Command + U (in Xcode)

# Or from terminal:
xcodebuild test -scheme Denklem -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

---

## 📂 Project Structure

```
Denklem/
├── App/
│   └── DenklemApp.swift          # Application entry point
│
├── Models/
│   ├── Domain/                   # Business logic models
│   ├── Data/                     # Tariff data structures
│   └── Calculation/              # Calculation engines
│
├── Views/
│   ├── Screens/                  # Screen views and ViewModels
│   │   ├── StartScreen/
│   │   ├── Calculations/
│   │   ├── MediationFee/         # Unified mediation fee calculation
│   │   ├── AttorneyFee/
│   │   ├── Reinstatement/
│   │   ├── SerialDisputes/
│   │   ├── TenancySpecial/
│   │   ├── TimeCalculation/
│   │   ├── SMMCalculation/
│   │   ├── Survey/
│   │   ├── Settings/
│   │   └── Legislation/
│   ├── Components/               # Reusable components
│   └── Modifiers/                # SwiftUI view modifiers
│
├── Theme/                        # Theme system
│   ├── ThemeProtocol.swift
│   ├── LightTheme.swift
│   ├── DarkTheme.swift
│   └── LiquidGlass/              # Liquid Glass styles
│
├── Localization/                 # Multi-language support
│   ├── LocalizationKeys.swift
│   ├── LocalizationHelper.swift
│   └── Localizable.xcstrings
│
├── Constants/                    # Constants
│   ├── AppConstants.swift
│   ├── TariffConstants.swift
│   ├── DisputeConstants.swift
│   └── ValidationConstants.swift
│
├── Managers/                     # Managers
│   ├── ThemeManager.swift
│   └── LocaleManager.swift
│
├── Extensions/                   # Extensions
│   ├── Foundation/
│   ├── SwiftUI/
│   └── UIKit/
│
└── Resources/                    # Resources
    └── Assets.xcassets/
```

---

## 🎨 Design Features

### **Liquid Glass Effect (iOS 26.0+)**
```swift
// Using Liquid Glass
GlassEffectContainer(spacing: theme.spacingM) {
    // Content
}
.liquidGlassEffect()
.interactive()  // Touch illumination
```

### **Theme System**
```swift
// Using theme
@Environment(\.theme) var theme

Text("Title")
    .font(theme.title)
    .foregroundStyle(theme.textPrimary)
    .padding(theme.spacingM)
```

### **Localization**
```swift
// Multi-language support
Text(LocalizationKeys.Home.welcome.localized)

// Dynamic language switching
LocaleManager.shared.setLanguage(.english)
```

---

## 🤝 Contributing

This project is currently managed by a single developer. Please contact for suggestions and feedback.

---

## 👤 Author

**Özkan Cömert**

- 🌐 Denklem: [https://denklem.org](https://denklem.org)

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- Apple - For SwiftUI framework and development tools
- iOS development community - For open source contributions
- GitHub - For hosting and collaboration platform

---

## 🔄 Version History

### v2.5.6 (March 2026) - Toggle Buttons, Cable Connectors & Accessibility
- 🔘 **Toggle Button Design**: New toggle button pairs for mediation and attorney fee screens (replaces segmented pickers)
- 🔌 **Cable Connector System**: Visual circuit-board cables showing calculation flow paths
- 📊 **Inline Results**: Calculation results now displayed directly on screen with tap-to-expand detail view
- ♿ **VoiceOver Accessibility**: Full VoiceOver support across all screens and shared components
- 🇸🇪 **Swedish Localization**: Added Swedish language support
- 📤 **Text Export**: Share calculation results with detailed mediation fee breakdown as text file

### v2.4.3 (February 2026) - Tenancy & Unified Mediation Fee Screen
- 🏠 **Tenancy Disputes (Kira Tahliye/Tespit)**: Special calculation module for eviction and rent determination disputes
  - Attorney fee calculation with Sulh Hukuk minimum enforcement
  - Mediation fee calculation with Art. 7/7 minimum enforcement
  - Unified screen with segmented picker (Attorney | Mediation)
- 🔄 **Unified Mediation Fee Screen**: Merged DisputeTypeView + InputView into single MediationFeeView
  - Dropdown menu for dispute type selection (replaces 10-button grid)
  - Year picker, agreement selector, and input fields in one screen
  - Streamlined 2-step flow (DisputeCategoryView → MediationFeeView)
- 📊 **Survey Feature**: 2-question legal mini quiz with thank you card
- ⚡ **Performance**: Cached Bundle.localizedBundle, removed dead code, shared theme defaults

### v2.3.0 (February 2026) - Special Calculators & Navigation Update
- 🏢 **Attorney Fee Calculation**: New power of attorney fee calculator added for mediation process
- 📋 **Serial Dispute Calculation**: New serial dispute calculator module added
- 👨‍⚖️ **Reinstatement Disputes**: New calculation module for reinstatement cases
- 📱 **Tab Bar Navigation Overhaul**:
  - Previous tabs: Home, Legislation, About, Language button
  - New tabs: Home, Calculations, Legislation, Settings
  - Direct entry button on home screen for faster calculations
  - Language and theme preferences moved to Settings
  - About section integrated into Settings
- 🧮 **Calculations Screen Enhancement**:
  - General mediation fee calculations
  - Special calculations category (Attorney Fee, Serial Disputes, Reinstatement)
  - Other calculations category (Time Calculator, SMM Calculator)
- ⚡ **Improved User Experience**: Direct access from home screen to dispute type selection for faster workflow

### v2.0.0 (January 2026) - SwiftUI Native Rewrite
- ✨ Completely rewritten with SwiftUI
- 🎯 iOS 26.0+ minimum requirement
- 📅 2025 and 2026 tariff support
- 🎨 Liquid Glass modern design system
- 🌍 Turkish and English language support
- ⚡ Native performance optimizations
- 🌓 Light/Dark mode automatic theme
- 📱 Tab bar navigation system
- 🧮 Enhanced calculation engines

### v1.x (2025) - React Native Version
- 📱 First version with React Native
- 📅 2025 tariff support
- 🇹🇷 Turkish only
- 📊 Basic calculation features

---

<div align="center">

**Made with ❤️ in Türkiye**

Developed to simplify mediation processes
</div>
