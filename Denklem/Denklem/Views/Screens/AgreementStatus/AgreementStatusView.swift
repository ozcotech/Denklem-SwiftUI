//
//  AgreementStatusView.swift
//  Denklem
//
//  Created by ozkan on 05.01.2026.
//

import SwiftUI

// MARK: - Agreement Status View
/// Displays agreement status selection (Agreed / Not Agreed)
/// Uses Apple native Liquid Glass with GlassEffectContainer for interactive cards
@available(iOS 26.0, *)
struct AgreementStatusView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: AgreementStatusViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool) {
        _viewModel = StateObject(wrappedValue: AgreementStatusViewModel(selectedYear: selectedYear, isMonetary: isMonetary))
    }
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ZStack {
            // Background
            theme.background
                .ignoresSafeArea()
            
            // Content - Fixed layout, no scrolling
            VStack(spacing: theme.spacingXL) {
                
                // Header at top
                headerSection
                
                // Push cards to center
                Spacer()
                
                // Agreement Status Cards with Liquid Glass
                statusCardsSection
                
                Spacer()
            }
            .padding(.horizontal, theme.spacingL)
            .padding(.bottom, theme.spacingXXL)
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguageToggleButton()
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            // TODO: Navigate to DisputeTypeView when implemented
            Text(verbatim: "DisputeTypeView - isMonetary: \(String(viewModel.isMonetary)), hasAgreement: \(String(viewModel.selectedStatus == .agreed))")
                .font(theme.title)
                .foregroundColor(theme.textPrimary)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingXS) {
            Text(viewModel.screenTitle)
                .font(theme.title2)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingXL)
    }
    
    // MARK: - Status Cards Section (Morphing Animation)
    
    private var statusCardsSection: some View {
        VStack(spacing: theme.spacingM) {
            GlassEffectContainer(spacing: 0) {
                ZStack {
                    // Agreed button (checkmark) - morphs from center
                    if viewModel.showOptions {
                        VStack(spacing: theme.spacingS) {
                            Button {
                                withAnimation(.bouncy(duration: 0.35)) {
                                    viewModel.selectStatus(.agreed)
                                }
                            } label: {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(.green)
                                    .frame(width: 64, height: 64)
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .tint(.green.opacity(0.3))
                            .glassEffectID("agreed", in: glassNamespace)
                            
                            Text(LocalizationKeys.AgreementStatus.agreed.localized)
                                .font(theme.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(theme.textSecondary)
                        }
                        .offset(x: -100)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Toggle button (always visible) - center
                    Button {
                        withAnimation(.bouncy(duration: 0.4)) {
                            viewModel.toggleOptions()
                        }
                    } label: {
                        Image(systemName: viewModel.showOptions ? "xmark" : "questionmark")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(theme.textPrimary.opacity(0.8))
                            .frame(width: 72, height: 72)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("toggle", in: glassNamespace)
                    
                    // Not Agreed button (xmark) - morphs from center
                    if viewModel.showOptions {
                        VStack(spacing: theme.spacingS) {
                            Button {
                                withAnimation(.bouncy(duration: 0.35)) {
                                    viewModel.selectStatus(.notAgreed)
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(.red)
                                    .frame(width: 64, height: 64)
                            }
                            .buttonStyle(.glass)
                            .buttonBorderShape(.circle)
                            .tint(.red.opacity(0.3))
                            .glassEffectID("notAgreed", in: glassNamespace)
                            
                            Text(LocalizationKeys.AgreementStatus.notAgreed.localized)
                                .font(theme.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(theme.textSecondary)
                        }
                        .offset(x: 100)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
            }
            
            // Helper text
            if !viewModel.showOptions {
                Text(LocalizationKeys.AgreementStatus.tapToSelect.localized)
                    .font(theme.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct AgreementStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AgreementStatusView(selectedYear: .year2025, isMonetary: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                AgreementStatusView(selectedYear: .year2025, isMonetary: true)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
