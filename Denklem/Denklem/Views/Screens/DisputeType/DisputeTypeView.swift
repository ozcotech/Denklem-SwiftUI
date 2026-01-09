//
//  DisputeTypeView.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI

// MARK: - Dispute Type View
/// Displays dispute type selection with Liquid Glass buttons
/// For monetary disputes, shows agreement selector at the top
/// User must select agreement status (if monetary) and dispute type to proceed
@available(iOS 26.0, *)
struct DisputeTypeView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: DisputeTypeViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool) {
        _viewModel = StateObject(wrappedValue: DisputeTypeViewModel(
            selectedYear: selectedYear,
            isMonetary: isMonetary
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ZStack {
            // Background
            theme.background
                .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    
                    // Agreement Status Selector (only for monetary disputes)
                    if viewModel.showAgreementSelector {
                        agreementSelectorSection
                    }
                    
                    // Dispute Type Buttons
                    disputeTypeButtonsSection
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingL)
                .padding(.bottom, theme.spacingXXL)
            }
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToInput) {
            if let disputeType = viewModel.selectedDisputeType {
                InputView(
                    selectedYear: viewModel.selectedYear,
                    isMonetary: viewModel.isMonetary,
                    hasAgreement: viewModel.hasAgreement,
                    selectedDisputeType: disputeType
                )
            }
        }
    }
    
    // MARK: - Agreement Selector Section
    
    private var agreementSelectorSection: some View {
        VStack(spacing: theme.spacingM) {
            GlassEffectContainer(spacing: 0) {
                ZStack {
                    // Agreed button (checkmark) - morphs from center
                    if viewModel.showAgreementOptions {
                        VStack(spacing: theme.spacingS) {
                            Button {
                                withAnimation(.bouncy(duration: 0.35)) {
                                    viewModel.selectAgreement(.agreed)
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
                    // Shows selected state or question mark
                    Button {
                        withAnimation(.bouncy(duration: 0.4)) {
                            viewModel.toggleAgreementOptions()
                        }
                    } label: {
                        Group {
                            if viewModel.showAgreementOptions {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(theme.textPrimary.opacity(0.8))
                            } else if let selected = viewModel.selectedAgreement {
                                Image(systemName: selected.systemImage)
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(selected.iconColor)
                            } else {
                                Image(systemName: "questionmark")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(theme.textPrimary.opacity(0.8))
                            }
                        }
                        .frame(width: 72, height: 72)
                        .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .glassEffectID("toggle", in: glassNamespace)
                    
                    // Not Agreed button (xmark) - morphs from center
                    if viewModel.showAgreementOptions {
                        VStack(spacing: theme.spacingS) {
                            Button {
                                withAnimation(.bouncy(duration: 0.35)) {
                                    viewModel.selectAgreement(.notAgreed)
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
            
            // Helper text - shows prompt or selected status
            if !viewModel.showAgreementOptions {
                if let selected = viewModel.selectedAgreement {
                    Text(selected.displayName)
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(selected.iconColor)
                        .transition(.opacity)
                } else {
                    Text(LocalizationKeys.AgreementStatus.tapToSelect.localized)
                        .font(theme.subheadline)
                        .foregroundStyle(theme.textSecondary)
                        .transition(.opacity)
                }
            }
        }
        .padding(.bottom, theme.spacingM)
    }
    
    // MARK: - Dispute Type Buttons Section
    
    private var disputeTypeButtonsSection: some View {
        let columns = [
            GridItem(.flexible(), spacing: theme.spacingM),
            GridItem(.flexible(), spacing: theme.spacingM)
        ]
        
        return VStack(spacing: theme.spacingM) {
            LazyVGrid(columns: columns, spacing: theme.spacingM) {
                ForEach(viewModel.availableDisputeTypes) { disputeType in
                    DisputeTypeButton(
                        disputeType: disputeType,
                        theme: theme,
                        isEnabled: viewModel.areDisputeTypesEnabled
                    ) {
                        viewModel.selectDisputeType(disputeType)
                    }
                }
            }
        }
    }
}

// MARK: - Dispute Type Button
/// Individual button for dispute type selection with Liquid Glass styling
@available(iOS 26.0, *)
struct DisputeTypeButton: View {
    
    let disputeType: DisputeType
    let theme: ThemeProtocol
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(disputeType.displayName)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(isEnabled ? theme.textPrimary : theme.textSecondary.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .padding(.horizontal, theme.spacingXS)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.roundedRectangle(radius: 16))
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct DisputeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                DisputeTypeView(selectedYear: .year2025, isMonetary: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Monetary - Light Mode")
            
            NavigationStack {
                DisputeTypeView(selectedYear: .year2025, isMonetary: false)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Non-Monetary - Light Mode")
            
            NavigationStack {
                DisputeTypeView(selectedYear: .year2025, isMonetary: true)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Monetary - Dark Mode")
        }
    }
}
