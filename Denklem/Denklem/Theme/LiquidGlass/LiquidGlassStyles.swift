//
//  LiquidGlassStyles.swift
//  Denklem
//
//  Created by ozkan on 03.11.2025.
//

import SwiftUI

// MARK: - Button Styles

/// Glass button style with Liquid Glass effect
/// Applies standard glass appearance to buttons
@available(iOS 26.0, *)
struct GlassButtonStyle: ButtonStyle {
    let theme: ThemeProtocol
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: theme.buttonHeightLarge)
            .padding(.horizontal, theme.spacingL)
            .foregroundColor(theme.textPrimary)
            .background {
                Capsule()
                    .fill(.clear)
            }
            .glassEffect(theme.glassRegular, in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: theme.springResponse, dampingFraction: theme.springDamping), value: configuration.isPressed)
    }
}

/// Prominent glass button style for primary actions
/// Uses primary color tint for emphasis
@available(iOS 26.0, *)
struct GlassProminentButtonStyle: ButtonStyle {
    let theme: ThemeProtocol
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: theme.buttonHeightLarge)
            .padding(.horizontal, theme.spacingL)
            .foregroundColor(.white)
            .background {
                Capsule()
                    .fill(theme.primary)
            }
            .glassEffect(theme.glassRegular, in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: theme.springResponse, dampingFraction: theme.springDamping), value: configuration.isPressed)
    }
}

/// Clear glass button style for subtle actions
/// Minimal visual weight with clear glass effect
@available(iOS 26.0, *)
struct GlassClearButtonStyle: ButtonStyle {
    let theme: ThemeProtocol
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: theme.buttonHeight)
            .padding(.horizontal, theme.spacingM)
            .foregroundColor(theme.textSecondary)
            .background {
                Capsule()
                    .fill(.clear)
            }
            .glassEffect(theme.glassClear, in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: theme.springResponse, dampingFraction: theme.springDamping), value: configuration.isPressed)
    }
}

// MARK: - View Extensions

@available(iOS 26.0, *)
extension View {
    
    /// Applies a glass card effect with rounded corners
    /// - Parameter theme: The theme to use for styling
    /// - Returns: A view with glass card appearance
    func glassCard(theme: ThemeProtocol) -> some View {
        self
            .padding(theme.spacingL)
            .background {
                RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                    .fill(.clear)
            }
            .glassEffect(theme.glassRegular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }
    
    /// Applies a glass surface effect
    /// - Parameters:
    ///   - theme: The theme to use for styling
    ///   - cornerRadius: Custom corner radius (optional)
    /// - Returns: A view with glass surface appearance
    func glassSurface(theme: ThemeProtocol, cornerRadius: CGFloat? = nil) -> some View {
        let radius = cornerRadius ?? theme.cornerRadiusM
        return self
            .padding(theme.spacingM)
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.clear)
            }
            .glassEffect(theme.glassRegular, in: RoundedRectangle(cornerRadius: radius))
    }
    
    /// Applies a prominent glass effect with tint color
    /// - Parameters:
    ///   - theme: The theme to use for styling
    ///   - tintColor: The tint color for the glass effect
    /// - Returns: A view with prominent glass appearance
    func glassProminent(theme: ThemeProtocol, tintColor: Color) -> some View {
        self
            .padding(theme.spacingL)
            .background {
                RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                    .fill(tintColor.opacity(0.3))
                    .glassEffect(theme.glassRegular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))  
            }
    }
    
    /// Applies a glass button style with standard height
    /// - Parameter theme: The theme to use for styling
    /// - Returns: A view styled as a glass button
    func glassButton(theme: ThemeProtocol) -> some View {
        self
            .frame(height: theme.buttonHeightLarge)
            .padding(.horizontal, theme.spacingL)
            .background {
                Capsule()
                    .fill(.clear)
            }
            .glassEffect(theme.glassRegular, in: Capsule())
    }
    
    /// Applies a glass container effect for grouping content
    /// - Parameter theme: The theme to use for styling
    /// - Returns: A view with glass container appearance
    func glassContainer(theme: ThemeProtocol) -> some View {
        self
            .padding(theme.spacingXL)
            .background {
                RoundedRectangle(cornerRadius: theme.cornerRadiusXL)
                    .fill(.clear)
            }
            .glassEffect(theme.glassRegular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusXL))
    }
}

// MARK: - Helper Modifiers

/// Background modifier with glass effect
@available(iOS 26.0, *)
struct GlassBackgroundModifier: ViewModifier {
    let theme: ThemeProtocol
    let cornerRadius: CGFloat?
    
    func body(content: Content) -> some View {
        let radius = cornerRadius ?? theme.cornerRadiusM
        content
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.clear)
                    .glassEffect(theme.glassRegular, in: RoundedRectangle(cornerRadius: radius))
            }
    }
}

@available(iOS 26.0, *)
extension View {
    /// Applies a glass background with optional corner radius
    /// - Parameters:
    ///   - theme: The theme to use for styling
    ///   - cornerRadius: Custom corner radius (optional)
    /// - Returns: A view with glass background
    func glassBackground(theme: ThemeProtocol, cornerRadius: CGFloat? = nil) -> some View {
        self.modifier(GlassBackgroundModifier(theme: theme, cornerRadius: cornerRadius))
    }
}

// MARK: - Convenience Extensions

@available(iOS 26.0, *)
extension ButtonStyle where Self == GlassButtonStyle {
    /// Standard glass button style
    static func glass(theme: ThemeProtocol) -> GlassButtonStyle {
        GlassButtonStyle(theme: theme)
    }
}

@available(iOS 26.0, *)
extension ButtonStyle where Self == GlassProminentButtonStyle {
    /// Prominent glass button style for primary actions
    static func glassProminent(theme: ThemeProtocol) -> GlassProminentButtonStyle {
        GlassProminentButtonStyle(theme: theme)
    }
}

@available(iOS 26.0, *)
extension ButtonStyle where Self == GlassClearButtonStyle {
    /// Clear glass button style for subtle actions
    static func glassClear(theme: ThemeProtocol) -> GlassClearButtonStyle {
        GlassClearButtonStyle(theme: theme)
    }
}
