//
//  DenklemApp.swift
//  Denklem
//
//  Created by ozkan on 15.07.2025.
//

import SwiftUI
@available(iOS 26.0, *) 
@main
struct DenklemApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.theme, themeManager.currentTheme)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
