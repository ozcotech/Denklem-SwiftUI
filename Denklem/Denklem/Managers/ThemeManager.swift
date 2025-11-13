//
//  ThemeManager.swift
//  Denklem
//
//  Created by ozkan on 03.11.2025.
//

import SwiftUI
import Combine

// MARK: - Theme Manager

/// Manages app-wide theme state and persistence
/// Handles theme switching between light and dark modes
@available(iOS 26.0, *)
@MainActor
class ThemeManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current theme type (light or dark)
    @Published var currentThemeType: ThemeType = .light
    
    /// Stored theme preference
    @AppStorage("selectedTheme") private var storedTheme: String = ThemeType.light.rawValue
    
    // MARK: - Computed Properties
    
    /// Current theme instance
    var currentTheme: ThemeProtocol {
        currentThemeType.theme
    }
    
    /// Current color scheme for SwiftUI
    var colorScheme: ColorScheme {
        currentThemeType == .light ? .light : .dark
    }
    
    /// Check if dark mode is active
    var isDarkMode: Bool {
        currentThemeType == .dark
    }
    
    // MARK: - Initialization
    
    init() {
        // Load saved theme preference
        if let savedTheme = ThemeType(rawValue: storedTheme) {
            self.currentThemeType = savedTheme
        }
    }
    
    // MARK: - Public Methods
    
    /// Set a specific theme
    /// - Parameter themeType: The theme type to apply
    func setTheme(_ themeType: ThemeType) {
        currentThemeType = themeType
        storedTheme = themeType.rawValue
    }
    
    /// Toggle between light and dark themes
    func toggleTheme() {
        let newTheme: ThemeType = currentThemeType == .light ? .dark : .light
        setTheme(newTheme)
    }
    
    /// Apply system theme preference
    /// - Parameter colorScheme: The system color scheme
    func applySystemTheme(_ colorScheme: ColorScheme) {
        let themeType: ThemeType = colorScheme == .dark ? .dark : .light
        setTheme(themeType)
    }
}
