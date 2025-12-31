//
//  ThemeProtocol.swift
//  Denklem
//
//  Created by ozkan on 09.10.2025.
//

import SwiftUI

/// Protocol defining the theme interface for the app
/// Supports both Light and Dark modes with Liquid Glass design
@available(iOS 26.0, *)
protocol ThemeProtocol {
    // MARK: - Colors
    
    /// Primary brand color - used for main actions and highlights
    var primary: Color { get }
    
    /// Secondary brand color - used for supporting elements
    var secondary: Color { get }
    
    /// Background color for main views
    var background: Color { get }
    
    /// Surface color for cards and elevated elements
    var surface: Color { get }
    
    /// Elevated surface color for layered components
    var surfaceElevated: Color { get }
    
    /// Primary text color - main content
    var textPrimary: Color { get }
    
    /// Secondary text color - supporting content
    var textSecondary: Color { get }
    
    /// Tertiary text color - hints and disabled text
    var textTertiary: Color { get }
    
    /// Border color for dividers and outlines
    var border: Color { get }
    
    /// Success state color - positive feedback
    var success: Color { get }
    
    /// Warning state color - caution feedback
    var warning: Color { get }
    
    /// Error state color - negative feedback
    var error: Color { get }
    
    /// Outline color for borders and dividers
    var outline: Color { get }
    
    /// Fill color for subtle backgrounds
    var fill: Color { get }
    
    // MARK: - Typography
    
    /// Large title font - main headings (34pt)
    var largeTitle: Font { get }
    
    /// Title font - section headings (28pt)
    var title: Font { get }
    
    /// Title 2 font - subsection headings (22pt)
    var title2: Font { get }
    
    /// Title 3 font - card headings (20pt)
    var title3: Font { get }
    
    /// Headline font - emphasized text (17pt semibold)
    var headline: Font { get }
    
    /// Body font - main content (17pt)
    var body: Font { get }
    
    /// Callout font - supporting content (16pt)
    var callout: Font { get }
    
    /// Subheadline font - metadata (15pt)
    var subheadline: Font { get }
    
    /// Footnote font - minor details (13pt)
    var footnote: Font { get }
    
    /// Caption font - labels and hints (12pt)
    var caption: Font { get }
    
    /// Caption 2 font - smallest text (11pt)
    var caption2: Font { get }
    
    // MARK: - Dimensions
    
    /// Extra small spacing (4pt)
    var spacingXS: CGFloat { get }
    
    /// Small spacing (8pt)
    var spacingS: CGFloat { get }
    
    /// Medium spacing (16pt)
    var spacingM: CGFloat { get }
    
    /// Large spacing (24pt)
    var spacingL: CGFloat { get }
    
    /// Extra large spacing (32pt)
    var spacingXL: CGFloat { get }
    
    /// Extra extra large spacing (48pt)
    var spacingXXL: CGFloat { get }
    
    /// Small corner radius (8pt)
    var cornerRadiusS: CGFloat { get }
    
    /// Medium corner radius (12pt)
    var cornerRadiusM: CGFloat { get }
    
    /// Large corner radius (16pt)
    var cornerRadiusL: CGFloat { get }
    
    /// Extra large corner radius (20pt)
    var cornerRadiusXL: CGFloat { get }
    
    /// Standard border width (1pt)
    var borderWidth: CGFloat { get }
    
    /// Thick border width (2pt)
    var borderWidthThick: CGFloat { get }
    
    /// Standard icon size (24pt)
    var iconSize: CGFloat { get }
    
    /// Large icon size (32pt)
    var iconSizeLarge: CGFloat { get }
    
    /// Standard button height (44pt) - iOS minimum touch target
    var buttonHeight: CGFloat { get }
    
    /// Large button height (56pt) - iOS 26 extra-large control
    var buttonHeightLarge: CGFloat { get }
    
    // MARK: - Liquid Glass
    
    /// Default glass variant for standard controls
    var glassRegular: Glass { get }
    
    /// Prominent glass effect for primary actions
    var glassProminentEffect: Glass { get } 

    /// Clear glass variant for subtle elements
    var glassClear: Glass { get }
    
    // MARK: - Shapes
    
    /// Returns a rounded rectangle with specified corner radius size
    func roundedRectangle(_ size: CornerRadiusSize) -> RoundedRectangle
    
    /// Capsule shape for pills and buttons
    var capsuleShape: Capsule { get }
    
    // MARK: - Animations
    
    /// Standard animation duration (0.3s)
    var animationDuration: Double { get }
    
    /// Fast animation duration (0.2s)
    var fastAnimationDuration: Double { get }
    
    /// Slow animation duration (0.5s)
    var slowAnimationDuration: Double { get }
    
    /// Spring animation response (0.5)
    var springResponse: Double { get }
    
    /// Spring animation damping (0.7)
    var springDamping: Double { get }
}

// MARK: - Supporting Types

/// Corner radius size categories
enum CornerRadiusSize {
    case small      // 8pt
    case medium     // 12pt
    case large      // 16pt
    case extraLarge // 20pt
    
    @available(iOS 26.0, *)
    func value(from theme: ThemeProtocol) -> CGFloat {
        switch self {
        case .small: return theme.cornerRadiusS
        case .medium: return theme.cornerRadiusM
        case .large: return theme.cornerRadiusL
        case .extraLarge: return theme.cornerRadiusXL
        }
    }
}

// MARK: - Theme Type Enum

/// Available theme types
enum ThemeType: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    /// Returns the corresponding theme instance
    @available(iOS 26.0, *)
    var theme: ThemeProtocol {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
    
    /// Display name for the theme
    var displayName: String {
        return rawValue
    }
}
