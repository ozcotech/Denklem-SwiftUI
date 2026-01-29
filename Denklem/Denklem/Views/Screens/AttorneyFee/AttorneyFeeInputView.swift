//
//  AttorneyFeeInputView.swift
//  Denklem
//
//  Created by ozkan on 28.01.2026.
//

import SwiftUI

// MARK: - Attorney Fee Input View
/// Displays input fields for attorney fee calculation
/// Shows amount input for monetary disputes, court type picker for non-monetary disputes
@available(iOS 26.0, *)
struct AttorneyFeeInputView: View {

    // MARK: - Properties

    @StateObject private var viewModel: AttorneyFeeInputViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Namespace for Morphing Transitions

    @Namespace private var glassNamespace

    // MARK: - Initialization

    init(isMonetary: Bool, hasAgreement: Bool) {
        _viewModel = StateObject(wrappedValue: AttorneyFeeInputViewModel(
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

                    // Input Section
                    inputSection

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
        .sheet(isPresented: $viewModel.showResultSheet) {
            if let result = viewModel.calculationResult {
                AttorneyFeeResultSheet(result: result)
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: theme.spacingS) {
            // Dispute Type Badge
            HStack(spacing: theme.spacingXS) {
                Image(systemName: viewModel.isMonetary ? "turkishlirasign.circle.fill" : "doc.text.fill")
                    .font(.system(size: 14, weight: .semibold))
                Text(viewModel.isMonetary
                     ? LocalizationKeys.AttorneyFee.monetaryType.localized
                     : LocalizationKeys.AttorneyFee.nonMonetaryType.localized)
                    .font(theme.footnote)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(viewModel.isMonetary ? .green : .blue)
            .padding(.horizontal, theme.spacingM)
            .padding(.vertical, theme.spacingXS)
            .background {
                Capsule()
                    .fill(theme.surfaceElevated.opacity(0.6))
            }

            // Agreement Status Badge
            HStack(spacing: theme.spacingXS) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                Text(LocalizationKeys.AttorneyFee.agreed.localized)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.green)

            // Tariff Year
            Text("\(AttorneyFeeConstants.currentYear)")
                .font(theme.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, theme.spacingL)
    }

    // MARK: - Input Section

    private var inputSection: some View {
        VStack(spacing: theme.spacingM) {
            // Section Title
            Text(viewModel.inputSectionTitle)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Input Field based on dispute type
            if viewModel.isMonetary {
                amountInputField
            } else {
                courtTypePickerSection
            }
        }
    }

    // MARK: - Amount Input Field

    private var amountInputField: some View {
        TextField(LocalizationKeys.Input.Placeholder.amount.localized, text: $viewModel.amountText)
            .font(theme.body)
            .fontWeight(.medium)
            .foregroundStyle(theme.textPrimary)
            .keyboardType(.decimalPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .padding(theme.spacingM)
            .frame(height: 50)
            .glassEffect()
            .glassEffectID("amountInput", in: glassNamespace)
            .onChange(of: viewModel.amountText) { _, _ in
                viewModel.formatAmountInput()
            }
    }

    // MARK: - Court Type Picker Section

    private var courtTypePickerSection: some View {
        VStack(spacing: theme.spacingM) {
            ForEach(viewModel.availableCourtTypes) { courtType in
                CourtTypeButton(
                    courtType: courtType,
                    isSelected: viewModel.selectedCourtType == courtType,
                    theme: theme
                ) {
                    viewModel.selectCourtType(courtType)
                }
            }
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
        .padding(.top, theme.spacingL)
    }
}

// MARK: - Court Type Button

@available(iOS 26.0, *)
struct CourtTypeButton: View {

    let courtType: AttorneyFeeConstants.CourtType
    let isSelected: Bool
    let theme: ThemeProtocol
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: theme.spacingM) {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected ? .green : theme.textSecondary)

                // Court type info
                VStack(alignment: .leading, spacing: theme.spacingXS) {
                    Text(courtType.displayName)
                        .font(theme.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)

                    Text(LocalizationHelper.formatCurrency(courtType.feeWithBonus))
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)
                }

                Spacer()
            }
            .padding(theme.spacingM)
            .frame(maxWidth: .infinity)
            .glassEffect()
        }
        .buttonStyle(.plain)
        .tint(isSelected ? theme.primary : nil)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct AttorneyFeeInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AttorneyFeeInputView(isMonetary: true, hasAgreement: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Monetary - Light Mode")

            NavigationStack {
                AttorneyFeeInputView(isMonetary: false, hasAgreement: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Non-Monetary - Light Mode")

            NavigationStack {
                AttorneyFeeInputView(isMonetary: true, hasAgreement: true)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Monetary - Dark Mode")
        }
    }
}
