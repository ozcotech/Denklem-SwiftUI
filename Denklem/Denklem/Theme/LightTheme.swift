//
//  LightTheme.swift
//  Denklem
//
//  Created by ozkan on 14.10.2024.
//

import SwiftUI

/// Light theme implementation
/// Only overrides color values — all other properties use ThemeProtocol defaults
@available(iOS 26.0, *)
struct LightTheme: ThemeProtocol {

    // MARK: - Colors

    var primary: Color { Color("AppPrimary") }
    var secondary: Color { Color("AppSecondary") }
    var background: Color { Color("AppBackground") }
    var surface: Color { Color("AppSurface") }
    var surfaceElevated: Color { Color("AppSurfaceElevated") }
    var textPrimary: Color { Color("AppTextPrimary") }
    var textSecondary: Color { Color("AppTextSecondary") }
    var textTertiary: Color { Color.gray.opacity(0.6) }
    var border: Color { Color("AppOutline") }
    var success: Color { Color("AppSuccess") }
    var warning: Color { Color("AppWarning") }
    var error: Color { Color("AppError") }
    var outline: Color { Color("AppOutline") }
    var fill: Color { Color("AppFill") }

    var cardMain: Color { Color("AppCardMain") }
    var cardSpecial: Color { Color("AppCardSpecial") }
    var cardOther: Color { Color("AppCardOther") }
}
