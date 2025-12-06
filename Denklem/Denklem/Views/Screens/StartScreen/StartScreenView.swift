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
        NavigationStack {
            ZStack {
                // Background
                theme.background
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
            .navigationDestination(isPresented: $viewModel.navigateToDisputeCategory) {
                // TODO: Navigate to DisputeCategoryView
                Text(LocalizationKeys.ScreenTitle.disputeCategoryComingSoon.localized)
                    .font(theme.title)
                    .foregroundColor(theme.textPrimary)
            }
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
        VStack(spacing: 0) {
            // Dropdown Button
            Button {
                withAnimation(.spring(response: theme.springResponse, dampingFraction: theme.springDamping)) {
                    viewModel.toggleYearDropdown()
                }
            } label: {
                HStack {
                    // LOCALIZED with format ✅
                    Text(String(format: LocalizationKeys.Start.tariffYearLabel.localized, viewModel.selectedYear.displayName))
                        .font(theme.body)
                        .foregroundColor(theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: viewModel.isYearDropdownVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(theme.textSecondary)
                        .font(.caption)
                }
                .padding(theme.spacingM)
            }
            .glassCard(theme: theme)
            
            // Dropdown Options
            if viewModel.isYearDropdownVisible {
                VStack(spacing: 0) {
                    ForEach(TariffYear.allCases, id: \.self) { year in
                        Button {
                            viewModel.selectYear(year)  
                        } label: {
                            HStack {
                                Text("\(year.rawValue)")
                                    .font(theme.body)
                                    .foregroundColor(theme.textPrimary)
                                
                                Spacer()
                                
                                if year == viewModel.selectedYear {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(theme.primary)
                                        .font(.headline)
                                }
                            }
                            .padding(theme.spacingM)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if year != TariffYear.allCases.last {
                            Divider()
                                .background(theme.outline)
                        }
                    }
                }
                .glassCard(theme: theme)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
            }
        }
        .padding(.horizontal, theme.spacingL)
    }
    
    // MARK: - Primary Action Button
    
    private var primaryActionButton: some View {
        Button {
            viewModel.proceedToDisputeCategory()
        } label: {
            HStack(spacing: theme.spacingM) {
                // LOCALIZED with format ✅
                Text(String(format: LocalizationKeys.Start.enterButtonWithYear.localized, viewModel.selectedYear.displayName))
                    .font(theme.headline)
                    .fontWeight(.semibold)
                
                // Animated Arrow
                Image(systemName: "arrow.right")
                    .font(.headline)
                    .offset(x: arrowOffset)
            }
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeightLarge)
        }
        .buttonStyle(.glassProminent(theme: theme))
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
