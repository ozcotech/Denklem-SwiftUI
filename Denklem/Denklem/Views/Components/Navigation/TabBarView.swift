//
//  TabBarView.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI

// MARK: - Tab Items
/// Enum representing available tabs in the app
enum TabItem: String, CaseIterable, Identifiable, Hashable {
    case home
    case legislation
    case about
    case language
    
    var id: String { rawValue }
    
    /// Localized title for the tab
    func title(currentLanguage: SupportedLanguage) -> String {
        switch self {
        case .home:
            return NSLocalizedString(LocalizationKeys.TabBar.home, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Home tab")
        case .legislation:
            return NSLocalizedString(LocalizationKeys.TabBar.legislation, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Legislation tab")
        case .about:
            return NSLocalizedString(LocalizationKeys.TabBar.about, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "About tab")
        case .language:
            // Show opposite language code as toggle indicator
            return currentLanguage == .turkish ? "EN" : "TR"
        }
    }
    
    /// SF Symbol name for the tab icon
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .legislation:
            return "books.vertical.fill"
        case .about:
            return "info.square.fill"
        case .language:
            return "globe"
        }
    }
    
    /// SF Symbol name for unselected state
    var systemImageUnselected: String {
        switch self {
        case .home:
            return "house"
        case .legislation:
            return "books.vertical"
        case .about:
            return "info.square"
        case .language:
            return "globe"
        }
    }
    
    /// Accessibility label for the tab
    func accessibilityLabel(currentLanguage: SupportedLanguage) -> String {
        return title(currentLanguage: currentLanguage)
    }
}

// MARK: - Tab Bar View
/// Main tab bar view using iOS 26 native TabView with Liquid Glass effect
@available(iOS 26.0, *)
struct TabBarView: View {
    
    // MARK: - Properties
    
    @StateObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    /// Currently selected tab
    @State private var selectedTab: TabItem = .home
    
    /// Previous tab before language toggle (to return after language change)
    @State private var previousTab: TabItem = .home
    
    /// Selected tariff year (passed from StartScreen or managed here)
    @State private var selectedYear: TariffYear = .current
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        TabView(selection: $selectedTab) {
            // MARK: - Home Tab
            Tab(value: .home) {
                NavigationStack {
                    StartScreenView()
                }
            } label: {
                Label(TabItem.home.title(currentLanguage: localeManager.currentLanguage), systemImage: selectedTab == .home ? TabItem.home.systemImage : TabItem.home.systemImageUnselected)
            }
            
            // MARK: - Legislation Tab
            Tab(value: .legislation) {
                NavigationStack {
                    LegislationView()
                }
            } label: {
                Label(TabItem.legislation.title(currentLanguage: localeManager.currentLanguage), systemImage: selectedTab == .legislation ? TabItem.legislation.systemImage : TabItem.legislation.systemImageUnselected)
            }
            
            // MARK: - About Tab
            Tab(value: .about) {
                NavigationStack {
                    AboutView()
                }
            } label: {
                Label(TabItem.about.title(currentLanguage: localeManager.currentLanguage), systemImage: selectedTab == .about ? TabItem.about.systemImage : TabItem.about.systemImageUnselected)
            }
            
            // MARK: - Language Tab
            Tab(value: .language) {
                // Empty view - language toggle happens on tap
                Color.clear
                    .onAppear {
                        // Toggle language and return to previous tab
                        localeManager.toggleLanguage()
                        // Return to the tab we were on before clicking language
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            selectedTab = previousTab
                        }
                    }
            } label: {
                Label(TabItem.language.title(currentLanguage: localeManager.currentLanguage), systemImage: TabItem.language.systemImage)
            }
        }
        .tint(theme.primary)
        .onChange(of: selectedTab) { oldValue, newValue in
            // Store the previous tab before switching to language tab
            if newValue == .language {
                previousTab = oldValue
            }
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode
            TabBarView()
                .injectTheme(LightTheme())
                .injectLocaleManager()
                .previewDisplayName("Light Mode")
            
            // Dark Mode
            TabBarView()
                .injectTheme(DarkTheme())
                .injectLocaleManager()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
