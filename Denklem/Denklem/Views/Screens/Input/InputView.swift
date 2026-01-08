//
//  InputView.swift
//  Denklem
//
//  Created by ozkan on 06.01.2026.
//

import SwiftUI

// MARK: - Input View
/// Displays input fields for calculation based on agreement status
/// Shows amount + party count for agreement cases, only party count for non-agreement
@available(iOS 26.0, *)
struct InputView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: InputViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear, isMonetary: Bool, hasAgreement: Bool, selectedDisputeType: DisputeType) {
        _viewModel = StateObject(wrappedValue: InputViewModel(
            selectedYear: selectedYear,
            isMonetary: isMonetary,
            hasAgreement: hasAgreement,
            selectedDisputeType: selectedDisputeType
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
                    
                    // Input Fields Section
                    inputFieldsSection
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                    }
                    
                    // Calculate Button
                    calculateButton
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.bottom, theme.spacingXXL)
            }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguageToggleButton()
            }
        }
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.calculationResult {
                ResultSheet(result: result, theme: theme, isMonetary: viewModel.isMonetary)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingS) {
            // Dispute Type Badge
            Text(viewModel.selectedDisputeType.displayName)
                .font(theme.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
                .padding(.horizontal, theme.spacingM)
                .padding(.vertical, theme.spacingXS)
                .background {
                    Capsule()
                        .fill(theme.surfaceElevated.opacity(0.6))
                }
            
            // Agreement Status (only for monetary disputes)
            if viewModel.isMonetary {
                Text(viewModel.agreementStatusText)
                    .font(theme.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textSecondary)
            }
            
            // Selected Year
            Text(viewModel.selectedYearText)
                .font(theme.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingL)
    }
    
    // MARK: - Input Fields Section
    
    private var inputFieldsSection: some View {
        VStack(spacing: theme.spacingM) {
            // Amount Input (only for agreement cases)
            if viewModel.showAmountInput {
                amountInputField
            }
            
            // Party Count Input
            partyCountInputField
        }
    }
    
    // MARK: - Amount Input Field
    
    private var amountInputField: some View {
        TextField("", text: $viewModel.amountText)
            .font(theme.body)
            .fontWeight(.medium)
            .foregroundStyle(theme.textPrimary)
            .keyboardType(.decimalPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .padding(theme.spacingM)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.surfaceElevated)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary.opacity(0.03))
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.outline.opacity(0.15), lineWidth: 1)
            }
            .glassEffectID("amountInput", in: glassNamespace)
            .onChange(of: viewModel.amountText) { _, _ in
                viewModel.formatAmountInput()
            }
    }
    
    // MARK: - Party Count Input Field
    
    private var partyCountInputField: some View {
        TextField("", text: $viewModel.partyCountText)
            .font(theme.body)
            .fontWeight(.medium)
            .foregroundStyle(theme.textPrimary)
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .padding(theme.spacingM)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.surfaceElevated)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary.opacity(0.03))
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.outline.opacity(0.15), lineWidth: 1)
            }
            .glassEffectID("partyCountInput", in: glassNamespace)
            .onChange(of: viewModel.partyCountText) { _, _ in
                viewModel.formatPartyCountInput()
            }
    }
    
    // MARK: - Error Message View
    
    private func errorMessageView(_ message: String) -> some View {
        HStack(spacing: theme.spacingS) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(theme.caption)
                .foregroundStyle(theme.error)
            
            Text(message)
                .font(theme.footnote)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.leading)
        }
        .padding(theme.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.error.opacity(0.1))
        }
    }
    
    // MARK: - Calculate Button
    
    private var calculateButton: some View {
        Button {
            // Dismiss keyboard before calculating
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            viewModel.calculate()
        } label: {
            HStack(spacing: theme.spacingM) {
                Text(viewModel.calculateButtonText)
                    .font(theme.body)
                    .fontWeight(.semibold)
                
                if viewModel.isCalculating {
                    ProgressView()
                        .tint(theme.textPrimary)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(theme.body)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .buttonStyle(.glass)
        .tint(theme.primary)
        .glassEffectID("calculate", in: glassNamespace)
        .disabled(!viewModel.isCalculateButtonEnabled || viewModel.isCalculating)
        .opacity(viewModel.isCalculateButtonEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Result Sheet
/// Full screen sheet displaying calculation result
@available(iOS 26.0, *)
struct ResultSheet: View {
    
    let result: CalculationResult
    let theme: ThemeProtocol
    let isMonetary: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    
                    // Success Icon
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(theme.success)
                        .padding(.top, theme.spacingXL)
                    
                    // Main Fee Card
                    mainFeeCard
                    
                    // Details Card
                    detailsCard
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.bottom, theme.spacingXXL)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                }
            }
        }
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Main Fee Card
    
    private var mainFeeCard: some View {
        VStack(spacing: theme.spacingM) {
            Text(LocalizationKeys.Result.mediationFee.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
            
            Text(LocalizationHelper.formatCurrency(result.amount))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(theme.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.surfaceElevated)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.primary.opacity(0.2), lineWidth: 2)
        }
    }
    
    // MARK: - Details Card
    
    private var detailsCard: some View {
        VStack(spacing: theme.spacingM) {
            // Agreement Status - special text for non-monetary disputes
            if !isMonetary {
                detailRow(
                    label: LocalizationKeys.Result.disputeSubject.localized,
                    value: "Konusu Para Olmayan"
                )
            } else {
                detailRow(
                    label: LocalizationKeys.Result.agreementStatus.localized,
                    value: result.input.agreementStatus == .agreed ? LocalizationKeys.AgreementStatus.agreed.localized : LocalizationKeys.AgreementStatus.notAgreed.localized
                )
            }
            
            Divider()
                .background(theme.outline.opacity(0.2))
            
            // Dispute Type
            detailRow(
                label: LocalizationKeys.Result.disputeType.localized,
                value: result.disputeType.displayName
            )
            
            Divider()
                .background(theme.outline.opacity(0.2))
            
            // Tariff Year
            detailRow(
                label: LocalizationKeys.Result.tariffYear.localized,
                value: result.input.tariffYear.displayName
            )
            
            Divider()
                .background(theme.outline.opacity(0.2))
            
            // Party Count
            detailRow(
                label: LocalizationKeys.Result.partyCount.localized,
                value: "\(result.input.partyCount)"
            )
            
            // Amount (only for agreement cases with amount)
            if let amount = result.input.disputeAmount {
                Divider()
                    .background(theme.outline.opacity(0.2))
                
                detailRow(
                    label: LocalizationKeys.Input.agreementAmount.localized,
                    value: LocalizationHelper.formatCurrency(amount)
                )
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.surfaceElevated)
        }
    }
    
    // MARK: - Detail Row
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
        }
    }
    
    // MARK: - Private Methods (for future use)
    
    private func shareResult() {
        let text = """
        \(LocalizationKeys.Result.mediationFee.localized): \(LocalizationHelper.formatCurrency(result.amount))
        \(LocalizationKeys.Result.disputeType.localized): \(result.disputeType.displayName)
        \(LocalizationKeys.Result.tariffYear.localized): \(result.input.tariffYear.displayName)
        """
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                InputView(
                    selectedYear: .year2025,
                    isMonetary: true,
                    hasAgreement: true,
                    selectedDisputeType: .workerEmployer
                )
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Agreement - Light Mode")
            
            NavigationStack {
                InputView(
                    selectedYear: .year2025,
                    isMonetary: true,
                    hasAgreement: false,
                    selectedDisputeType: .commercial
                )
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Non-Agreement - Dark Mode")
        }
    }
}
