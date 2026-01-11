# 🧮 DENKLEM – Mediation Fee Calculator

**DENKLEM** (from Latin "aequare" = "to equalize") is a comprehensive **native iOS application** for calculating mediation fees according to Turkish law. Written from scratch with SwiftUI, the app performs calculations based on the 2025 and 2026 mediation fee tariffs.

The name "DENKLEM" reflects the concept of creating equality and balance between parties, which aligns perfectly with the essence of mediation: establishing balance and fair resolution between disputing parties.

> 🚀 **First Version Available on the App Store!**  
> Download now: [DENKLEM on App Store](https://apps.apple.com/us/app/denklem/id6746580824)

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
- **Bilingual Support**: Turkish and English (instant language switching)
- **Light/Dark Mode**: Automatic theme support
- **Liquid Glass UI**: Optional modern visual effects
- **Accessibility**: VoiceOver support coming in future updates

---

## 🚀 Key Features

### 💰 **Core Functionality - Fee Calculation**
- **2025 & 2026 Official Tariffs**: Based on current Turkish mediation fee tariff
- **Smart Calculation Engine**: Handles both monetary and non-monetary disputes
- **Dual Scenario Support**: Different calculations for agreement vs. non-agreement cases
- **Automatic Tariff Selection**: User selects tariff year at startup (2025 or 2026)

### 📱 **User Experience**
- **Intuitive Step-by-Step Flow**: Guided process from start to finish
- **Native iOS Navigation**: Swipe gestures and native transitions
- **Persistent Tab Bar**: Quick access to home, legislation, about, and language selection
- **Bilingual**: Complete Turkish and English localization
- **Modern Native Design**: Professional and user-friendly interface

### 🧮 **Additional Calculators**
- **Time Calculation**: Calculate mediation process durations
- **Freelance Receipt (SMM)**: Receipt calculations with tax deductions
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
Application entry point and tariff year selection:
- **2025 Tariff**: 2025 fee calculations
- **2026 Tariff**: 2026 current fee calculations
- **Modern Animations**: Logo and entrance animations

### **2. DisputeCategoryScreen (Dispute Category)**
Calculation type selection:
- **Main Categories**:
  - 💰 **Monetary**: Monetary disputes
  - 📄 **Non-Monetary**: Non-monetary disputes
- **Other Calculations**:
  - ⏰ **Time Calculation**: Mediation process durations
  - 📝 **SMM Calculation**: Freelance receipt calculator

### **3. AgreementStatusScreen (Agreement Status)**
Parties' agreement status:
- **Agreement**: Redirects to different calculation method
- **No Agreement**: Alternative calculation approach

### **4. DisputeTypeScreen (Dispute Type)**
Specific dispute type selection based on previous choices:
- Labor-Employer
- Commercial
- Consumer
- Rental
- Neighbor
- Condominium
- Family
- Partnership Dissolution
- Other

### **5. InputScreen (Information Entry)**
Enter required information:
- **In Agreement Case**: Agreement amount + number of parties
- **In Non-Agreement Case**: Only number of parties

### **6. ResultScreen (Result Screen)**
Comprehensive result display (as Sheet):
- **Main Fee**: Calculated mediation fee
- **Tax Information**: Withholding tax calculations when applicable
- **SMM Details**: Complete SMM breakdown for professional invoicing

### **7. Additional Screens**
- **TimeCalculationScreen**: Calculate mediation process durations
- **SmmCalculationScreen**: Detailed freelance receipt calculations
- **LegislationScreen**: Access current mediation legislation
- **AboutScreen**: App information and contact details

### **8. Tab Bar Navigation**
Tab bar accessible from any screen:
- 🏠 **Home**: Return to start screen
- 📚 **Legislation**: View legal legislation
- ℹ️ **About**: App information
- 🌍 **Language**: Turkish ↔ English (TR/EN)

---

## 📸 Screenshots

Below are screenshots hosted in the separate screenshots repository: https://github.com/ozcotech/Denklem-SwiftUI-screenshots

### Main Flow

Start Screen:
![Start Screen](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/home-screen.png)

Dispute Category:
![Dispute Category](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/dispute-category-screen-dark.png)

Dispute Type:
![Dispute Type](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/dispute-type-screen-2.png)

### Input & Result

Input Screen:
![Input Screen](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/inpute-screen-2.png)

Result Screen (1):
![Result Screen 1](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/result-screen-1.png)

Result Screen (2):
![Result Screen 2](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/result-screen-2.png)

### Time Calculation

Time Calculation (1):
![Time Calculation 1](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/timecalculation-screen-2.png)

Time Calculation (2):
![Time Calculation 2](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/time-calculation-screen-3.png)

### SMM Calculation

SMM Calculation (1):
![SMM Calculation 1](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/smmcalculation-screen-2.png)

SMM Calculation (2):
![SMM Calculation 2](https://raw.githubusercontent.com/ozcotech/Denklem-SwiftUI-screenshots/master/mix-theme/smm-calculation-screen-3.png)

> Images hosted in the `Denklem-SwiftUI-screenshots` repository. Links point to raw images on GitHub.

---

## 🎯 How It Works

### **Monetary Dispute - With Agreement:**
1. "Monetary" → "Agreement" → Select dispute type
2. Enter agreement amount and number of parties
3. Get calculated mediation fee + optional SMM receipt calculation

### **Non-Monetary or No Agreement:**
1. Select category → "No Agreement"
2. Enter only number of parties
3. Get fee calculation with automatic tax deductions

### **Additional Features:**
- **Tab Bar Navigation**: Always accessible home, legislation, and about sections
- **Native iOS Controls**: Natural iOS transitions and gestures
- **Quick Access**: Direct links to time and SMM calculators

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

- **Current Version**: 2.0.0
- **Supported Years**: 2025 and 2026 mediation tariffs
- **Platform**: iOS 26.0+
- **Languages**: Turkish (TR) and English (EN)
- **Last Update**: January 2026
- **Based on**: 2025 and 2026 official mediation fee tariffs

---

## 🧪 Development Setup

### **Requirements**
- macOS 14.0+ (Sonoma or later)
- Xcode 16.0+ (with iOS 26.0 SDK)
- iOS 26.0+ supported simulator or physical device
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
│   │   ├── DisputeCategory/
│   │   ├── AgreementStatus/
│   │   ├── DisputeType/
│   │   ├── Input/
│   │   ├── TimeCalculation/
│   │   ├── SMMCalculation/
│   │   ├── About/
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

## 🚀 Upcoming Features (v2.1+)

### **Planned Features**
- 🏢 **Attorney Fee Calculation**: Power of attorney fee calculation in mediation process
- 🏠 **Rental Disputes**: Special calculations for eviction and rent determination
- 👨‍⚖️ **Reinstatement Calculations**: Calculation module specific to reinstatement cases
- 📊 **Comparison Mode**: Side-by-side comparison of different scenarios
- 📤 **Advanced Export**: PDF reports and email sharing
- 🔔 **Tariff Notifications**: Push notifications for new tariff updates

### **Technical Improvements**
- ⚡ **Performance Improvements**: Faster calculations and animations
- 🧪 **Enhanced Test Coverage**: Target 95%+ test coverage
- 🌐 **Additional Languages**: More language support beyond English

---

## 📖 Documentation

See the `Documentation/` folder for detailed documentation:

- 📋 [PROJECT_OVERVIEW.md](Documentation/PROJECT_OVERVIEW.md) - Project overview
- 🏗️ [ARCHITECTURE_PLAN.md](Documentation/ARCHITECTURE_PLAN.md) - Architecture details
- 📁 [FOLDER_STRUCTURE.md](Documentation/FOLDER_STRUCTURE.md) - Folder structure
- 🔄 [SCREEN_FLOW.md](Documentation/SCREEN_FLOW.md) - Screen flows
- ✨ [FEATURES_BREAKDOWN.md](Documentation/FEATURES_BREAKDOWN.md) - Feature details
- 💻 [CODING_STANDARDS.md](Documentation/CODING_STANDARDS.md) - Coding standards
- 🧑‍⚖️ [ATTORNEY_FEE_CALCULATION_PLAN.md](Documentation/ATTORNEY_FEE_CALCULATION_PLAN.md) - Attorney fee planning

---

## 🤝 Contributing

This project is currently managed by a single developer. Please contact for suggestions and feedback.

---

## 👤 Author

**Özkan Cömert**

- 📧 Email: info@ozco.studio
- 🌐 Website: [https://ozco.studio](https://ozco.studio)
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
