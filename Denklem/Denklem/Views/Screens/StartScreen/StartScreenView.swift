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
    @Environment(\.theme) var theme
    
    // MARK: - Animation Properties
    
    @State private var arrowOffset: CGFloat = 0
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background Image
            Image("AppStartBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 20) // Modern iOS blur effect
            
            // Gradient Overlay for readability
            LinearGradient(
                colors: [
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: theme.spacingXXL) {
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                    
                    // Header Section
                    headerSection
                    
                    Spacer()
                        .frame(height: theme.spacingL)
                    
                    // Year Selection
                    yearSelectionSection
                    
                    // Primary Action Button
                    primaryActionButton
                    
                    Spacer()
                }
                .padding(.horizontal, theme.spacingXL)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeCategory) {
            // TODO: Navigate to DisputeCategoryView
            Text(LocalizationKeys.ScreenTitle.disputeCategoryComingSoon.localized)
                .font(theme.title)
                .foregroundColor(theme.textPrimary)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingL) {
            // App Logo
            Image(systemName: "scale.3d")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(theme.primary)
                .shadow(
                    color: theme.primary.opacity(0.3),
                    radius: 20,
                    x: 0,
                    y: 10
                )
            
            // App Title - LOCALIZED ✅
            Text(LocalizationKeys.AppInfo.name.localized)
                .font(theme.largeTitle)
                .foregroundColor(theme.textPrimary)
                .fontWeight(.bold)
            
            // App Subtitle - LOCALIZED ✅
            Text(LocalizationKeys.AppInfo.tagline.localized)
                .font(theme.headline)
                .foregroundColor(theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, theme.spacingL)
        }
    }
    
    // MARK: - Year Selection Section
    
    private var yearSelectionSection: some View {
        // Native Segmented Picker with custom height
        Picker("", selection: $viewModel.selectedYear) {
            ForEach(TariffYear.allCases, id: \.self) { year in
                Text(String(format: "%d", year.rawValue))
                    .font(.system(size: 18, weight: .semibold))
                    .tag(year)
            }
        }
        .pickerStyle(.segmented)
        .tint(theme.primary)
        .padding(.horizontal, theme.spacingXXL)
        .onAppear {
            // Set UISegmentedControl height via UIKit
            UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        .onChange(of: viewModel.selectedYear) { _, newYear in
            viewModel.selectYear(newYear)
        }
    }
    
    // MARK: - Primary Action Button
    
    private var primaryActionButton: some View {
        Button {
            viewModel.proceedToDisputeCategory()
        } label: {
            HStack(spacing: theme.spacingM) {
                Text(String(format: LocalizationKeys.Start.enterButtonWithYear.localized, viewModel.selectedYear.displayName))
                    .font(theme.headline)
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .offset(x: arrowOffset)
            }
            .padding(.horizontal, theme.spacingL)
            .frame(height: 50)
        }
        .buttonStyle(.glass)
        .padding(.horizontal, theme.spacingXXL)
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
