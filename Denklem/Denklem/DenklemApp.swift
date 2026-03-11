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

    // MARK: - Initialization

    init() {
        // UIKit Appearance: Segmented control font size
        // .controlSize(.regular) only affects height, not font — UIKit API required for font
        let segmented = UISegmentedControl.appearance()
        segmented.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
        segmented.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .semibold)], for: .selected)
    }

    // MARK: - State Objects

    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var localeManager = LocaleManager.shared
    
    /// System color scheme to detect appearance changes
    @Environment(\.colorScheme) private var systemColorScheme

    /// Animated background toggle state
    @AppStorage(AppConstants.UserDefaultsKeys.animatedBackground)
    private var isAnimatedBackground: Bool = false
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .injectTheme(themeManager.currentTheme)
                .injectLocaleManager(localeManager)
                .environment(\.locale, localeManager.currentLocale)
                .environment(\.isAnimatedBackground, isAnimatedBackground)
                .preferredColorScheme(themeManager.colorScheme)
                .onChange(of: systemColorScheme) { _, newColorScheme in
                    themeManager.applySystemTheme(newColorScheme)
                }
        }
    }
}
