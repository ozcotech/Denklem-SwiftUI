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
                .padding(.horizontal, theme.spacingM)
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
        .toolbar(.hidden, for: .navigationBar)
        // Survey button: Not a toolbar item — toolbar applies opaque glass in light theme.
        // Placed as overlay with .glass(.clear) + .buttonBorderShape(.circle) for a
        // theme-independent transparent circular button (like iOS lock screen buttons).
        .overlay(alignment: .topTrailing) {
            if !viewModel.isSurveyCompleted {
                Button {
                    viewModel.navigateToSurvey = true
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.glass(.clear))
                .buttonBorderShape(.circle)
                .padding(.trailing, theme.spacingM)
                .padding(.top, theme.spacingXS)
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            // Quick access: Navigate directly to MediationFeeView
            MediationFeeView(selectedYear: viewModel.selectedYear)
        }
        .navigationDestination(isPresented: $viewModel.navigateToSurvey) {
            SurveyView()
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
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                    .animation(
                        .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                        value: arrowOffset
                    )
            }
            .frame(maxWidth: .infinity, minHeight: theme.buttonHeightLarge)
            .contentShape(Rectangle())
        }
        .buttonStyle(.glass(.clear))
        .frame(maxWidth: .infinity)
        .onAppear {
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
