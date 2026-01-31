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
    case tools
    case legislation
    case settings

    var id: String { rawValue }

    /// Localized title for the tab
    func title(currentLanguage: SupportedLanguage) -> String {
        switch self {
        case .home:
            return NSLocalizedString(LocalizationKeys.TabBar.home, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Home tab")
        case .tools:
            return NSLocalizedString(LocalizationKeys.TabBar.tools, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Tools tab")
        case .legislation:
            return NSLocalizedString(LocalizationKeys.TabBar.legislation, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Legislation tab")
        case .settings:
            return NSLocalizedString(LocalizationKeys.TabBar.settings, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "Settings tab")
        }
    }

    /// SF Symbol name for the tab icon (filled variant for iOS 26 Liquid Glass consistency)
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .tools:
            return "arrowshape.forward.circle.fill"
        case .legislation:
            return "books.vertical.fill"
        case .settings:
            return "gear.circle.fill"
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
                Label(TabItem.home.title(currentLanguage: localeManager.currentLanguage), systemImage: TabItem.home.systemImage)
            }

            // MARK: - Tools Tab
            Tab(value: .tools) {
                NavigationStack {
                    DisputeCategoryView(selectedYear: selectedYear)
                }
            } label: {
                Label(TabItem.tools.title(currentLanguage: localeManager.currentLanguage), systemImage: TabItem.tools.systemImage)
            }

            // MARK: - Legislation Tab
            Tab(value: .legislation) {
                NavigationStack {
                    LegislationView()
                }
            } label: {
                Label(TabItem.legislation.title(currentLanguage: localeManager.currentLanguage), systemImage: TabItem.legislation.systemImage)
            }

            // MARK: - Settings Tab
            Tab(value: .settings) {
                NavigationStack {
                    AboutView()
                }
            } label: {
                Label(TabItem.settings.title(currentLanguage: localeManager.currentLanguage), systemImage: TabItem.settings.systemImage)
            }
        }
        .tint(theme.primary)
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
