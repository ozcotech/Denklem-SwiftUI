//
//  StartScreenView.swift
//  Denklem
//
//  Created by ozkan on 14.11.2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct StartScreenView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel = StartScreenViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Animation Properties
    
    @State private var arrowOffset: CGFloat = 0
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        // Content
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: theme.spacingXXL) {

                    // Header Section at top
                    headerSection

                    // Spacer pushes content to bottom
                    Spacer(minLength: 0)

                    // Primary Action Button
                    primaryActionButton
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.bottom, theme.spacingXXL * 1.6)
                .frame(minHeight: geometry.size.height)
                .frame(maxWidth: .infinity)
            }
            .scrollDisabled(true)
        }
        .background {
            // Background: Image first, then Gradient overlay on top
            ZStack {
                // Background Image
                Image("AppStartBackground")
                    .resizable()
                    .scaledToFill()

                // Gradient Overlay for readability
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.4),
                        Color.black.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            // Quick access: Navigate directly to DisputeTypeView with monetary dispute selected
            DisputeTypeView(selectedYear: viewModel.selectedYear, isMonetary: true)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingXS) {
            // App Title - LOCALIZED ✅
            Text(LocalizationKeys.AppInfo.name.localized)
                .font(theme.title2)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            // App Subtitle - LOCALIZED ✅
            Text(LocalizationKeys.AppInfo.tagline.localized)
                .font(theme.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingXL)
    }
    
    // MARK: - Primary Action Button

    private var primaryActionButton: some View {
        Button {
            viewModel.proceedToDisputeType()
        } label: {
            HStack(spacing: theme.spacingM) {
                Text(LocalizationKeys.Start.enterButton.localized)
                    .font(theme.headline)
                    .foregroundColor(.white)

                Image(systemName: "arrow.right")
                    .font(theme.headline)
                    .foregroundColor(.white)
                    .offset(x: arrowOffset)
            }
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeight)
        }
        .buttonStyle(.glass)
        .id(colorScheme) // Force re-render when theme changes
        .onAppear {
            startButtonAnimations()
        }
    }
    
    // MARK: - Animation Methods
    
    private func startButtonAnimations() {
        // Arrow bounce animation - subtle right movement
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
        ) {
            arrowOffset = 4
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode
            StartScreenView()
                .injectTheme(LightTheme())
                .previewDisplayName("Light Mode")
            
            // Dark Mode
            StartScreenView()
                .injectTheme(DarkTheme())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
