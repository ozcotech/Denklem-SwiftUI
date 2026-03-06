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
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ZStack {
            // Main Content
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    // Header Section
                    headerSection
                    
                    // Input Fields Section
                    inputFieldsSection
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                            .padding(.horizontal, theme.spacingM)
                    }
                    
                    // Calculate Button
                    calculateButton
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                }
            }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            hideKeyboard()
        }
        .animatedBackground()
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if let msg = newValue {
                AccessibilityNotification.Announcement(msg).post()
            }
        }
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.calculationResult {
                SMMResultSheet(result: result, theme: theme)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingS) {
            Text(LocalizationKeys.SMMCalculation.note.localized)
                .font(theme.footnote)
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
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(.horizontal, theme.spacingL)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect(isAnimatedBackground ? .clear : .regular)
                .accessibilityLabel(viewModel.amountLabel)
                .onChange(of: viewModel.amountText) { _, _ in
                    viewModel.formatAmountInput()
                }
        }
        .padding(.horizontal, theme.spacingM)
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
                        .font(theme.caption)
                        .foregroundStyle(theme.textSecondary)
                        .accessibilityHidden(true)
                }
                .padding(.horizontal, theme.spacingL)
                .frame(height: theme.buttonHeight)
                .glassEffect(isAnimatedBackground ? .clear : .regular)
            }
            .accessibilityLabel(viewModel.calculationTypeLabel)
            .accessibilityValue(viewModel.selectedCalculationType.displayName)
            .accessibilityHint(LocalizationKeys.Accessibility.calculationTypeMenuHint.localized)
        }
        .padding(.horizontal, theme.spacingM)
    }

    // MARK: - Error Message View
    
    private func errorMessageView(_ message: String) -> some View {
        ErrorBannerView(message: message, showBorder: true)
    }
    
    // MARK: - Calculate Button

    private var calculateButton: some View {
        CalculateButton(
            buttonText: viewModel.calculateButtonText,
            isCalculating: viewModel.isCalculating,
            isEnabled: viewModel.isCalculateButtonEnabled
        ) {
            hideKeyboard()
            viewModel.calculate()
        }
        .padding(.horizontal, theme.spacingM)
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

    @ObservedObject private var localeManager = LocaleManager.shared

    @Environment(\.isAnimatedBackground) private var isAnimatedBackground
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // Observe language changes to trigger view refresh while sheet is open
        let _ = localeManager.refreshID

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
                .padding(.horizontal, theme.spacingM)
                .padding(.top, theme.spacingM)
            }
            .animatedBackground()
            .navigationTitle(LocalizationKeys.SMMResult.title.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                    .accessibilityHint(LocalizationKeys.Accessibility.dismissHint.localized)
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
            Text(LocalizationKeys.SMMResult.calculatedFee.localized)
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
                    .accessibilityAddTraits(.isHeader)
                
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
            
        }
        .padding(theme.spacingL)
        .glassEffect(isAnimatedBackground ? .clear : .regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
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
        .accessibilityElement(children: .combine)
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
