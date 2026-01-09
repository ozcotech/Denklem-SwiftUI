//
//  SMMCalculationView.swift
//  Denklem
//
//  Created by ozkan on 09.01.2026.
//

import SwiftUI

// MARK: - SMM Calculation View
/// Displays SMM (Freelance Receipt) calculation interface
/// Allows users to calculate fees for different VAT and withholding tax scenarios
@available(iOS 26.0, *)
struct SMMCalculationView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = SMMCalculationViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ZStack {
            // Background
            theme.background
                .ignoresSafeArea()
            
            // Main Content
            ScrollView {
                VStack(spacing: theme.spacingXL) {
                    // Header Section
                    headerSection
                    
                    // Input Fields Section
                    inputFieldsSection
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                    }
                    
                    // Calculate Button
                    calculateButton
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                }
                .padding(.horizontal, theme.spacingL)
            }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            hideKeyboard()
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.calculationResult {
                SMMResultSheet(result: result, theme: theme, glassNamespace: glassNamespace)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingS) {
            Text(LocalizationKeys.DisputeCategory.smmCalculation.localized)
                .font(theme.title2)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
            
            Text(LocalizationKeys.DisputeCategory.smmCalculationDescription.localized)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingL)
    }
    
    // MARK: - Input Fields Section
    
    private var inputFieldsSection: some View {
        VStack(spacing: theme.spacingM) {
            // Amount Input Field
            amountInputField
            
            // Calculation Type Picker
            calculationTypePicker
        }
    }
    
    // MARK: - Amount Input Field
    
    private var amountInputField: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            Text(viewModel.amountLabel)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
            
            TextField(LocalizationKeys.Input.Placeholder.amount.localized, text: $viewModel.amountText)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.numberPad)
                .padding(theme.spacingM)
                .background {
                    RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                        .fill(theme.surface)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                        .stroke(theme.border, lineWidth: theme.borderWidth)
                }
                .onChange(of: viewModel.amountText) { _, _ in
                    viewModel.formatAmountInput()
                }
        }
    }
    
    // MARK: - Calculation Type Picker
    
    private var calculationTypePicker: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            Text(viewModel.calculationTypeLabel)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
            
            Menu {
                ForEach(SMMCalculationType.allCases, id: \.self) { type in
                    Button {
                        viewModel.selectedCalculationType = type
                    } label: {
                        HStack {
                            Text(type.displayName)
                            if viewModel.selectedCalculationType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCalculationType.displayName)
                        .font(theme.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(theme.textSecondary)
                }
                .padding(theme.spacingM)
                .background {
                    RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                        .fill(theme.surface)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                        .stroke(theme.border, lineWidth: theme.borderWidth)
                }
            }
        }
    }
    
    // MARK: - Error Message View
    
    private func errorMessageView(_ message: String) -> some View {
        HStack(spacing: theme.spacingS) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(theme.error)
            
            Text(message)
                .font(theme.footnote)
                .foregroundStyle(theme.error)
        }
        .padding(theme.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.error.opacity(0.1))
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .stroke(theme.error, lineWidth: theme.borderWidth)
        }
    }
    
    // MARK: - Calculate Button
    
    private var calculateButton: some View {
        Button {
            hideKeyboard()
            viewModel.calculate()
        } label: {
            HStack(spacing: theme.spacingM) {
                if viewModel.isCalculating {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "function")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(viewModel.calculateButtonText)
                        .font(theme.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeightLarge)
        }
        .buttonStyle(.glass)
        .tint(theme.primary)
        .glassEffectID("calculate", in: glassNamespace)
        .disabled(!viewModel.isCalculateButtonEnabled || viewModel.isCalculating)
        .opacity(viewModel.isCalculateButtonEnabled ? 1.0 : 0.5)
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - SMM Result Sheet
/// Full screen sheet displaying SMM calculation results
@available(iOS 26.0, *)
struct SMMResultSheet: View {
    
    let result: SMMCalculationResult
    let theme: ThemeProtocol
    let glassNamespace: Namespace.ID
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    // Header
                    resultHeaderSection
                    
                    // Real Person Result
                    personResultCard(result: result.realPersonResult, breakdown: result.breakdown.realPersonBreakdown)
                    
                    // Legal Person Result
                    personResultCard(result: result.legalPersonResult, breakdown: result.breakdown.legalPersonBreakdown)
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingM)
            }
            .background(theme.background)
            .navigationTitle(LocalizationKeys.SMMResult.title.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("✓")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(theme.textPrimary)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                }
            }
        }
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Result Header Section
    
    private var resultHeaderSection: some View {
        VStack(spacing: theme.spacingS) {
            Text(LocalizationKeys.Input.agreementAmount.localized)
                .font(theme.subheadline)
                .foregroundStyle(theme.textSecondary)
            
            Text(LocalizationHelper.formatCurrency(result.input.amount))
                .font(theme.title2)
                .fontWeight(.bold)
                .foregroundStyle(theme.primary)
            
            Text(result.input.calculationType.displayName)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacingM)
    }
    
    // MARK: - Person Result Card
    
    private func personResultCard(result: SMMPersonResult, breakdown: SMMPersonBreakdown) -> some View {
        VStack(spacing: theme.spacingM) {
            // Card Header
            HStack {
                Text(result.personType.displayName)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)
                
                Spacer()
            }
            
            Divider()
                .background(theme.border)
            
            // Result Rows
            resultRow(
                label: LocalizationKeys.SMMResult.grossFee.localized,
                value: result.formattedBrutFee,
                isHighlighted: false
            )
            
            resultRow(
                label: LocalizationKeys.SMMResult.withholding.localized,
                value: result.formattedStopaj,
                isHighlighted: false
            )
            
            resultRow(
                label: LocalizationKeys.SMMResult.netFee.localized,
                value: result.formattedNetFee,
                isHighlighted: false
            )
            
            resultRow(
                label: LocalizationKeys.SMMResult.vat.localized,
                value: result.formattedKdv,
                isHighlighted: false
            )
            
            Divider()
                .background(theme.border)
            
            resultRow(
                label: LocalizationKeys.SMMResult.totalCollected.localized,
                value: result.formattedTahsilEdilecekTutar,
                isHighlighted: true
            )
            
            // Calculation Steps
            if !breakdown.steps.isEmpty {
                Divider()
                    .background(theme.border)
                
                VStack(alignment: .leading, spacing: theme.spacingS) {
                    Text(LocalizationKeys.Result.calculationSteps.localized)
                        .font(theme.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.textSecondary)
                    
                    ForEach(Array(breakdown.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: theme.spacingS) {
                            Text("\(index + 1).")
                                .font(theme.caption)
                                .foregroundStyle(theme.textTertiary)
                            
                            Text(step)
                                .font(theme.caption)
                                .foregroundStyle(theme.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }
    
    // MARK: - Result Row
    
    private func resultRow(label: String, value: String, isHighlighted: Bool) -> some View {
        HStack {
            Text(label)
                .font(isHighlighted ? theme.headline : theme.body)
                .fontWeight(isHighlighted ? .semibold : .regular)
                .foregroundStyle(isHighlighted ? theme.primary : theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? theme.headline : theme.body)
                .fontWeight(isHighlighted ? .bold : .medium)
                .foregroundStyle(isHighlighted ? theme.primary : theme.textPrimary)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct SMMCalculationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                SMMCalculationView()
            }
            .injectTheme(LightTheme())
            .injectLocaleManager()
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                SMMCalculationView()
            }
            .injectTheme(DarkTheme())
            .injectLocaleManager()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
