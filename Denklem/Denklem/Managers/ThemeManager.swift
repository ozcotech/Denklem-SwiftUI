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
/// Automatically follows system appearance by default
@available(iOS 26.0, *)
@MainActor
class ThemeManager: ObservableObject {

    // MARK: - Singleton

    /// Shared instance for app-wide access
    static let shared = ThemeManager()

    // MARK: - Published Properties

    /// Current theme type (light or dark)
    @Published var currentThemeType: ThemeType = .light
    
    /// Whether to follow system appearance automatically
    @AppStorage("followSystemTheme") private var followSystemTheme: Bool = true
    
    /// Stored manual theme preference (used when followSystemTheme is false)
    @AppStorage("selectedTheme") private var storedTheme: String = ThemeType.light.rawValue
    
    // MARK: - Computed Properties
    
    /// Current theme instance
    var currentTheme: ThemeProtocol {
        currentThemeType.theme
    }
    
    /// Current color scheme for SwiftUI - nil means follow system
    var colorScheme: ColorScheme? {
        followSystemTheme ? nil : (currentThemeType == .light ? .light : .dark)
    }
    
    /// Check if dark mode is active
    var isDarkMode: Bool {
        currentThemeType == .dark
    }
    
    /// Check if following system theme
    var isFollowingSystem: Bool {
        followSystemTheme
    }

    /// Current appearance mode (light, dark, or system)
    var currentAppearanceMode: AppearanceMode {
        if followSystemTheme {
            return .system
        } else {
            return currentThemeType == .light ? .light : .dark
        }
    }

    // MARK: - Initialization
    
    init() {
        // If following system, detect current system appearance
        if followSystemTheme {
            let systemIsDark = UITraitCollection.current.userInterfaceStyle == .dark
            self.currentThemeType = systemIsDark ? .dark : .light
        } else {
            // Load saved manual theme preference
            if let savedTheme = ThemeType(rawValue: storedTheme) {
                self.currentThemeType = savedTheme
            }
        }
        
        // Listen for system appearance changes
        setupSystemAppearanceObserver()
    }
    
    // MARK: - Private Methods
    
    /// Sets up observer for system appearance changes
    private func setupSystemAppearanceObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateThemeIfFollowingSystem()
            }
        }
    }
    
    /// Updates theme based on system appearance if following system
    private func updateThemeIfFollowingSystem() {
        guard followSystemTheme else { return }
        let systemIsDark = UITraitCollection.current.userInterfaceStyle == .dark
        let newTheme: ThemeType = systemIsDark ? .dark : .light
        if currentThemeType != newTheme {
            currentThemeType = newTheme
        }
    }
    
    // MARK: - Public Methods
    
    /// Set a specific theme (disables follow system)
    /// - Parameter themeType: The theme type to apply
    func setTheme(_ themeType: ThemeType) {
        followSystemTheme = false
        currentThemeType = themeType
        storedTheme = themeType.rawValue
    }
    
    /// Toggle between light and dark themes (disables follow system)
    func toggleTheme() {
        let newTheme: ThemeType = currentThemeType == .light ? .dark : .light
        setTheme(newTheme)
    }
    
    /// Enable following system theme
    func enableFollowSystemTheme() {
        followSystemTheme = true
        updateThemeIfFollowingSystem()
    }

    /// Set appearance mode (light, dark, or system)
    /// - Parameter mode: The appearance mode to apply
    func setAppearanceMode(_ mode: AppearanceMode) {
        switch mode {
        case .light:
            setTheme(.light)
        case .dark:
            setTheme(.dark)
        case .system:
            enableFollowSystemTheme()
        }
    }

    /// Apply system theme preference
    /// - Parameter colorScheme: The system color scheme
    func applySystemTheme(_ colorScheme: ColorScheme) {
        guard followSystemTheme else { return }
        let themeType: ThemeType = colorScheme == .dark ? .dark : .light
        currentThemeType = themeType
    }
}
