//
//  LightTheme.swift
//  Denklem
//
//  Created by ozkan on 14.10.2024.
//

import SwiftUI

/// Light theme implementation
/// Provides colors, typography, and dimensions for light mode with Liquid Glass support
@available(iOS 26.0, *)
struct LightTheme: ThemeProtocol {
    
    // MARK: - Colors
    
    var primary: Color {
        Color("AppPrimary")
    }
    
    var secondary: Color {
        Color("AppSecondary")
    }
    
    var background: Color {
        Color("AppBackground")
    }
    
    var surface: Color {
        Color("AppSurface")
    }
    
    var surfaceElevated: Color {
        Color("AppSurfaceElevated")
    }
    
    var textPrimary: Color {
        Color("AppTextPrimary")
    }
    
    var textSecondary: Color {
        Color("AppTextSecondary")
    }
    
    var success: Color {
        Color("AppSuccess")
    }
    
    var warning: Color {
        Color("AppWarning")
    }
    
    var error: Color {
        Color("AppError")
    }
    
    var outline: Color {
        Color("AppOutline")
    }
    
    var fill: Color {
        Color("AppFill")
    }
    
    // MARK: - Typography
    
    var largeTitle: Font {
        .system(size: 34, weight: .bold, design: .default)
    }
    
    var title: Font {
        .system(size: 28, weight: .bold, design: .default)
    }
    
    var title2: Font {
        .system(size: 22, weight: .bold, design: .default)
    }
    
    var title3: Font {
        .system(size: 20, weight: .semibold, design: .default)
    }
    
    var headline: Font {
        .system(size: 17, weight: .semibold, design: .default)
    }
    
    var body: Font {
        .system(size: 17, weight: .regular, design: .default)
    }
    
    var callout: Font {
        .system(size: 16, weight: .regular, design: .default)
    }
    
    var subheadline: Font {
        .system(size: 15, weight: .regular, design: .default)
    }
    
    var footnote: Font {
        .system(size: 13, weight: .regular, design: .default)
    }
    
    var caption: Font {
        .system(size: 12, weight: .regular, design: .default)
    }
    
    var caption2: Font {
        .system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Dimensions
    
    var spacingXS: CGFloat { 4 }
    var spacingS: CGFloat { 8 }
    var spacingM: CGFloat { 16 }
    var spacingL: CGFloat { 24 }
    var spacingXL: CGFloat { 32 }
    var spacingXXL: CGFloat { 48 }
    
    var cornerRadiusS: CGFloat { 8 }
    var cornerRadiusM: CGFloat { 12 }
    var cornerRadiusL: CGFloat { 16 }
    var cornerRadiusXL: CGFloat { 20 }
    
    var borderWidth: CGFloat { 1 }
    var borderWidthThick: CGFloat { 2 }
    
    var iconSize: CGFloat { 24 }
    var iconSizeLarge: CGFloat { 32 }
    
    var buttonHeight: CGFloat { 44 }
    var buttonHeightLarge: CGFloat { 56 }
    
    // MARK: - Liquid Glass
    
    var glassRegular: Glass {
        .regular
    }
    
    var glassProminent: Glass {
        .regular
    }
    
    var glassClear: Glass {
        .clear
    }
    
    // MARK: - Shapes
    
    func roundedRectangle(_ size: CornerRadiusSize) -> RoundedRectangle {
        let radius = size.value(from: self)
        return RoundedRectangle(cornerRadius: radius)
    }
    
    var capsuleShape: Capsule {
        Capsule()
    }
    
    // MARK: - Animations
    
    var animationDuration: Double { 0.3 }
    var fastAnimationDuration: Double { 0.2 }
    var slowAnimationDuration: Double { 0.5 }
    var springResponse: Double { 0.5 }
    var springDamping: Double { 0.7 }
}
