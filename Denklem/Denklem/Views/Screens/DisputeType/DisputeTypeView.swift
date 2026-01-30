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
                VStack(spacing: theme.spacingS) {
                    
                    // Agreement Status Selector (always reserve space for consistent layout)
                    if viewModel.showAgreementSelector {
                        agreementSelectorSection
                    } else {
                        // Non-monetary dispute info text
                        nonMonetaryInfoSection
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
    
    // MARK: - Non-Monetary Info Section
    
    private var nonMonetaryInfoSection: some View {
        VStack(spacing: theme.spacingS) {
            Text(LocalizationKeys.DisputeType.nonMonetaryNote.localized)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.horizontal, theme.spacingS)
                .padding(.top, theme.spacingS)

                .frame(minHeight: 130)
        }
    }
    
    // MARK: - Agreement Selector Section
    
    private var agreementSelectorSection: some View {
        VStack(spacing: theme.spacingM) {
            // Agreement Segmented Picker - Native style
            Picker("", selection: $viewModel.selectedAgreement) {
                ForEach(AgreementSelectionType.allCases) { agreement in
                    Text(agreement.displayName)
                        .tag(agreement as AgreementSelectionType?)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(.large)
            .tint(viewModel.selectedAgreement == .agreed ? theme.success : theme.error)

            // Helper text - shows selected status with color
            if let selected = viewModel.selectedAgreement {
                HStack(spacing: theme.spacingXS) {
                    Image(systemName: selected.systemImage)
                        .font(theme.footnote)
                        .fontWeight(.semibold)
                    Text(selected.displayName)
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(selected.iconColor)
                .transition(.opacity.combined(with: .scale))
            } else {
                Text(LocalizationKeys.AgreementStatus.selectPrompt.localized)
                    .font(theme.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .transition(.opacity)
            }
        }
        .padding(.bottom, theme.spacingM)
        .id(localeManager.refreshID) // Force refresh when language changes
        .onAppear {
            // Auto-select first option if none selected (for better UX)
            if viewModel.selectedAgreement == nil {
                viewModel.selectAgreement(.agreed)
            }
        }
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
        CapsuleButton(
            systemImage: "", // No icon for dispute type buttons
            iconColor: .clear, // No icon color
            text: disputeType.displayName,
            textColor: isEnabled ? theme.textPrimary : theme.textSecondary.opacity(0.5),
            font: theme.callout,
            action: action
        )
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
