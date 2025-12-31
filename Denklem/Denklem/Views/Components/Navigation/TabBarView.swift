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
    
    var id: String { rawValue }
    
    /// Localized title for the tab
    var title: String {
        switch self {
        case .home:
            return NSLocalizedString(LocalizationKeys.TabBar.home, comment: "Home tab")
        case .legislation:
            return NSLocalizedString(LocalizationKeys.TabBar.legislation, comment: "Legislation tab")
        case .about:
            return NSLocalizedString(LocalizationKeys.TabBar.about, comment: "About tab")
        }
    }
    
    /// SF Symbol name for the tab icon
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .legislation:
            return "doc.text.fill"
        case .about:
            return "info.circle.fill"
        }
    }
    
    /// SF Symbol name for unselected state
    var systemImageUnselected: String {
        switch self {
        case .home:
            return "house"
        case .legislation:
            return "doc.text"
        case .about:
            return "info.circle"
        }
    }
    
    /// Accessibility label for the tab
    var accessibilityLabel: String {
        return title
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
        TabView(selection: $selectedTab) {
            // MARK: - Home Tab
            Tab(value: .home) {
                NavigationStack {
                    StartScreenView()
                        .toolbar {
                            toolbarContent
                        }
                }
            } label: {
                Label(TabItem.home.title, systemImage: selectedTab == .home ? TabItem.home.systemImage : TabItem.home.systemImageUnselected)
            }
            
            // MARK: - Legislation Tab
            Tab(value: .legislation) {
                NavigationStack {
                    LegislationView()
                        .toolbar {
                            toolbarContent
                        }
                }
            } label: {
                Label(TabItem.legislation.title, systemImage: selectedTab == .legislation ? TabItem.legislation.systemImage : TabItem.legislation.systemImageUnselected)
            }
            
            // MARK: - About Tab
            Tab(value: .about) {
                NavigationStack {
                    AboutView()
                        .toolbar {
                            toolbarContent
                        }
                }
            } label: {
                Label(TabItem.about.title, systemImage: selectedTab == .about ? TabItem.about.systemImage : TabItem.about.systemImageUnselected)
            }
        }
        .tint(theme.primary)
    }
    
    // MARK: - Toolbar Content
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            LanguageToggleButton()
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
