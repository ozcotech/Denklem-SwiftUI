//
//  SerialDisputesSheet.swift
//  Denklem
//
//  Created by ozkan on 31.01.2026.
//

import SwiftUI

// MARK: - Serial Disputes Sheet
/// Sheet view for serial disputes calculation
/// Displays year picker, dispute type picker, file count input, and calculation result
@available(iOS 26.0, *)
struct SerialDisputesSheet: View {

    // MARK: - Properties

    @StateObject private var viewModel: SerialDisputesViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Namespace for Morphing Transitions

    @Namespace private var glassNamespace

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: SerialDisputesViewModel(selectedYear: selectedYear))
    }

    // MARK: - Body

    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        NavigationStack {
            ZStack {
                // Background
                theme.background
                    .ignoresSafeArea()

                // Content
                if viewModel.showResult, let result = viewModel.calculationResult {
                    // Result View
                    SerialDisputesResultView(
                        result: result,
                        theme: theme,
                        onDismiss: { dismiss() },
                        onRecalculate: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.reset()
                            }
                        }
                    )
                } else {
                    // Input View
                    inputView
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle(viewModel.screenTitle)
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
                }
            }
        }
    }

    // MARK: - Input View

    private var inputView: some View {
        ScrollView {
            VStack(spacing: theme.spacingL) {

                // Year Picker Section
                yearPickerSection

                // Dispute Type Picker Section
                disputeTypePickerSection

                // File Count Section
                fileCountSection

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    errorMessageView(errorMessage)
                }

                // Calculate Button
                calculateButton
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.bottom, theme.spacingXXL)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Year Picker Section

    private var yearPickerSection: some View {
        YearPickerSection(
            availableYears: viewModel.availableYears,
            selectedYear: viewModel.selectedYear,
            selectedDisplayText: viewModel.currentYearDisplay,
            legalReferenceText: LocalizationKeys.SerialDisputes.legalArticle.localized,
            showTopPadding: false,
            onYearSelected: { viewModel.selectedYear = $0 }
        )
    }

    // MARK: - Dispute Type Picker Section

    private var disputeTypePickerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            // Section Title
            Text(viewModel.disputeTypeSectionTitle)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            // Dispute Type Dropdown
            Menu {
                ForEach(viewModel.availableDisputeTypes) { disputeType in
                    Button {
                        viewModel.selectedDisputeType = disputeType
                    } label: {
                        HStack {
                            Text(disputeType.displayName)
                            if viewModel.selectedDisputeType == disputeType {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedDisputeType.displayName)
                        .font(theme.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(theme.caption)
                        .foregroundStyle(theme.textSecondary)
                }
                .padding(.horizontal, theme.spacingL)
                .frame(height: theme.buttonHeight)
                .glassEffect()
            }
        }
    }

    // MARK: - File Count Section

    private var fileCountSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            // Section Title
            Text(viewModel.fileCountSectionTitle)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)

            // File Count Input
            TextField(viewModel.fileCountPlaceholder, text: $viewModel.fileCountText)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.numberPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(.horizontal, theme.spacingL)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect()
                .glassEffectID("fileCountInput", in: glassNamespace)
                .onChange(of: viewModel.fileCountText) { _, _ in
                    viewModel.formatFileCountInput()
                }
        }
    }

    // MARK: - Error Message View

    private func errorMessageView(_ message: String) -> some View {
        ErrorBannerView(message: message)
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        CalculateButton(
            buttonText: viewModel.calculateButtonText,
            isCalculating: viewModel.isCalculating,
            isEnabled: viewModel.isCalculateButtonEnabled
        ) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.calculate()
            }
        }
        .glassEffectID("calculate", in: glassNamespace)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct SerialDisputesSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SerialDisputesSheet(selectedYear: .year2026)
                .injectTheme(LightTheme())
                .previewDisplayName("2026 - Light Mode")

            SerialDisputesSheet(selectedYear: .year2025)
                .injectTheme(DarkTheme())
                .preferredColorScheme(.dark)
                .previewDisplayName("2025 - Dark Mode")
        }
    }
}
