//
//  DenklemApp.swift
//  Denklem
//
//  Created by ozkan on 15.07.2025.
//

import SwiftUI

@main
@available(iOS 26.0, *)
struct DenklemApp: App {
    
    // MARK: - State Objects

    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var localeManager = LocaleManager.shared
    
    /// System color scheme to detect appearance changes
    @Environment(\.colorScheme) private var systemColorScheme
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .injectTheme(themeManager.currentTheme)
                .injectLocaleManager(localeManager)
                .environment(\.locale, localeManager.currentLocale)
                .preferredColorScheme(themeManager.colorScheme)
                .onChange(of: systemColorScheme) { _, newColorScheme in
                    themeManager.applySystemTheme(newColorScheme)
                }
        }
    }
}
