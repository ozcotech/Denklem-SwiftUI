//
//  DisputeTypeView.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI

// MARK: - Dispute Type View
/// Displays dispute type selection with Liquid Glass buttons
/// User must select a dispute type to proceed with calculation
@available(iOS 26.0, *)
struct DisputeTypeView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: DisputeTypeViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool, hasAgreement: Bool) {
        _viewModel = StateObject(wrappedValue: DisputeTypeViewModel(
            selectedYear: selectedYear,
            isMonetary: isMonetary,
            hasAgreement: hasAgreement
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
                    
                    // Header Section
                    headerSection
                    
                    // Dispute Type Buttons
                    disputeTypeButtonsSection
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.bottom, theme.spacingXXL)
            }
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguageToggleButton()
            }
        }
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
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingXS) {
            Text(viewModel.screenTitle)
                .font(theme.title2)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(LocalizationKeys.DisputeType.Description.other.localized)
                .font(theme.subheadline)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
                .opacity(0) // Hidden but maintains spacing consistency
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingL)
    }
    
    // MARK: - Dispute Type Buttons Section
    
    private var disputeTypeButtonsSection: some View {
        let columns = [
            GridItem(.flexible(), spacing: theme.spacingM),
            GridItem(.flexible(), spacing: theme.spacingM)
        ]
        
        return LazyVGrid(columns: columns, spacing: theme.spacingM) {
            ForEach(viewModel.availableDisputeTypes) { disputeType in
                DisputeTypeButton(
                    disputeType: disputeType,
                    theme: theme
                ) {
                    viewModel.selectDisputeType(disputeType)
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(disputeType.displayName)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .padding(.horizontal, theme.spacingXS)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.roundedRectangle(radius: 16))
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct DisputeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                DisputeTypeView(selectedYear: .year2025, isMonetary: true, hasAgreement: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                DisputeTypeView(selectedYear: .year2025, isMonetary: false, hasAgreement: false)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
