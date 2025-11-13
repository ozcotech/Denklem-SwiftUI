//
//  ContentView.swift
//  Denklem
//
//  Created by ozkan on 15.07.2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct ContentView: View {
    @Environment(\.theme) var theme  
    
    var body: some View {
        VStack(spacing: theme.spacingL) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(theme.primary)
            Text("Hello, world!")
                .font(theme.title)
                .foregroundColor(theme.textPrimary)
        }
        .padding(theme.spacingXL)
        .background(theme.background)
    }
}

// MARK: - Previews

@available(iOS 26.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode
            ContentView()
                .injectTheme(LightTheme())
                .previewDisplayName("Light Mode")
            
            // Dark Mode
            ContentView()
                .injectTheme(DarkTheme())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
