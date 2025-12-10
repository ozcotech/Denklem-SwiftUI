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
    
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            StartScreenView()  
                .injectTheme(themeManager.currentTheme)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
