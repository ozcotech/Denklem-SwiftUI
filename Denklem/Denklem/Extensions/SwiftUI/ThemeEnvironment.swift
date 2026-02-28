//
//  ThemeEnvironment.swift
//  Denklem
//
//  Created by ozkan on 03.11.2025.
//

import SwiftUI

// MARK: - Theme Environment Key

/// Environment key for theme injection
/// Allows theme to be accessed throughout the view hierarchy using @Environment
@available(iOS 26.0, *)
private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeProtocol = LightTheme()
}

// MARK: - Environment Values Extension

@available(iOS 26.0, *)
extension EnvironmentValues {
    /// Access the current theme from the environment
    /// Usage: @Environment(\.theme) var theme
    var theme: ThemeProtocol {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Animated Background Environment Key

/// Environment key for animated background state
/// Allows views to check if animated sky background is enabled
/// Usage: @Environment(\.isAnimatedBackground) var isAnimatedBackground
@available(iOS 26.0, *)
private struct AnimatedBackgroundKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

@available(iOS 26.0, *)
extension EnvironmentValues {
    var isAnimatedBackground: Bool {
        get { self[AnimatedBackgroundKey.self] }
        set { self[AnimatedBackgroundKey.self] = newValue }
    }
}

// MARK: - View Extension for Theme Injection

@available(iOS 26.0, *)
extension View {
    /// Injects theme into the view hierarchy
    /// - Parameter theme: The theme to inject
    /// - Returns: View with theme injected
    func injectTheme(_ theme: ThemeProtocol) -> some View {
        self.environment(\.theme, theme)
    }
    
    /// Convenience method to inject theme based on color scheme
    /// - Parameter colorScheme: The color scheme to use
    /// - Returns: View with appropriate theme injected
    func injectTheme(for colorScheme: ColorScheme) -> some View {
        let theme: ThemeProtocol = colorScheme == .dark ? DarkTheme() : LightTheme()
        return self.environment(\.theme, theme)
    }
}
