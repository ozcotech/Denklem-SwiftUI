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
        // UIKit Appearance: Customize the selected segment tint color
        // SwiftUI's .pickerStyle(.segmented) lacks native customization options,
        // so UIKit appearance API is used. This is a global setting affecting all segmented controls.
        let segmentedControlAppearance = UISegmentedControl.appearance()
        segmentedControlAppearance.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.6)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]

        segmentedControlAppearance.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControlAppearance.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
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
