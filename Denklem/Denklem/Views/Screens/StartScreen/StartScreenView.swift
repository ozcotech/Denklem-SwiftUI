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
    
    // MARK: - Animation Properties
    
    @State private var arrowOffset: CGFloat = 0
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
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
            VStack(spacing: theme.spacingXXL) {
                
                // Header Section at top
                headerSection
                
                // Spacer pushes content to bottom
                Spacer()
                
                // Year Selection
                yearSelectionSection
                
                // Primary Action Button
                primaryActionButton
            }
            .padding(.horizontal, theme.spacingXL)
            .padding(.bottom, theme.spacingXXL)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeCategory) {
            DisputeCategoryView(selectedYear: viewModel.selectedYear)
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
    
    // MARK: - Year Selection Section
    
    private var yearSelectionSection: some View {
        // Native Segmented Picker with custom height
        Picker("", selection: $viewModel.selectedYear) {
            ForEach(TariffYear.allCases, id: \.self) { year in
                Text(String(format: "%d", year.rawValue))
                    .font(.system(size: 18, weight: .regular))
                    .tag(year)
            }
        }
        .pickerStyle(.segmented)
        .tint(theme.primary)
        .scaleEffect(y: 1.4) 
        .padding(.horizontal, theme.spacingXXL)
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
            .frame(maxWidth: .infinity)
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
