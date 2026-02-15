//
//  MediationFeeView.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI

// MARK: - Mediation Fee View
/// Unified screen for mediation fee calculation
/// Combines dispute type selection (dropdown) and input fields in a single screen
/// Replaces the previous DisputeTypeView → InputView two-screen flow
@available(iOS 26.0, *)
struct MediationFeeView: View {

    // MARK: - Properties

    @StateObject private var viewModel: MediationFeeViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Focus & Scroll

    @FocusState private var focusedField: MediationFeeFocusedField?
    @Namespace private var glassNamespace

    // MARK: - Initialization

    init(selectedYear: TariffYear, isMonetary: Bool) {
        _viewModel = StateObject(wrappedValue: MediationFeeViewModel(
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
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: theme.spacingL) {

                        // Year Picker
                        yearPickerSection

                        // Agreement Selector (monetary only)
                        if viewModel.showAgreementSelector {
                            agreementSelectorSection
                        } else {
                            nonMonetaryInfoSection
                        }

                        // Dispute Type Dropdown
                        disputeTypeMenuSection
                            .id("disputeTypeMenu")

                        // Input Fields (conditional)
                        if viewModel.showAmountInput {
                            amountInputField
                                .id("amountInput")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if viewModel.showPartyCountInput {
                            partyCountInputField
                                .id("partyCountInput")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            ErrorBannerView(message: errorMessage)
                        }

                        // Calculate Button
                        calculateButton
                    }
                    .padding(.horizontal, theme.spacingL)
                    .padding(.top, theme.spacingXS)
                    .padding(.bottom, theme.spacingXXL)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: focusedField) { _, newValue in
                    guard let newValue else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        switch newValue {
                        case .amount:
                            proxy.scrollTo("amountInput", anchor: .center)
                        case .partyCount:
                            proxy.scrollTo("partyCountInput", anchor: .center)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDisputeType != nil)
        .animation(.easeInOut(duration: 0.2), value: viewModel.hasAgreement)
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.calculationResult {
                MediationFeeResultSheet(result: result, theme: theme, isMonetary: viewModel.isMonetary)
            }
        }
    }

    // MARK: - Year Picker Section

    private var yearPickerSection: some View {
        YearPickerSection(
            availableYears: viewModel.availableYears,
            selectedYear: viewModel.selectedYear,
            onYearSelected: { viewModel.selectedYear = $0 }
        )
    }

    // MARK: - Agreement Selector Section

    private var agreementSelectorSection: some View {
        VStack(spacing: theme.spacingM) {
            // Uses CommonSegmentedPicker with optional enum selection and dynamic tint.
            CommonSegmentedPicker(
                selection: .optional($viewModel.selectedAgreement),
                options: AgreementSelectionType.allCases,
                tint: viewModel.selectedAgreement == .agreed ? theme.success : theme.error
            ) { agreement in
                Text(agreement.displayName)
            }

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
        .id(localeManager.refreshID)
    }

    // MARK: - Non-Monetary Info Section

    private var nonMonetaryInfoSection: some View {
        Text(LocalizationKeys.DisputeType.nonMonetaryNote.localized)
            .font(theme.footnote)
            .foregroundStyle(theme.textSecondary)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
            .padding(.horizontal, theme.spacingS)
    }

    // MARK: - Dispute Type Menu Section

    private var disputeTypeMenuSection: some View {
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
            HStack(spacing: theme.spacingXS) {
                Text(viewModel.selectedDisputeType?.displayName
                     ?? LocalizationKeys.DisputeType.selectPrompt.localized)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.selectedDisputeType != nil
                                     ? theme.primary : theme.textSecondary)

                Spacer()

                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2)
                    .foregroundStyle(theme.primary)
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.vertical, theme.spacingM)
            .frame(maxWidth: .infinity)
            .frame(height: theme.buttonHeight)
            .contentShape(Rectangle())
            .glassEffect()
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
            .focused($focusedField, equals: .amount)
            .padding(theme.spacingM)
            .frame(height: theme.buttonHeight)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .glassEffect()
            .glassEffectID("amountInput", in: glassNamespace)
            .onChange(of: viewModel.amountText) { _, _ in
                viewModel.formatAmountInput()
            }
    }

    // MARK: - Party Count Input Field

    private var partyCountInputField: some View {
        TextField(LocalizationKeys.Input.Placeholder.partyCount.localized, text: $viewModel.partyCountText)
            .font(theme.body)
            .fontWeight(.medium)
            .foregroundStyle(theme.textPrimary)
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .focused($focusedField, equals: .partyCount)
            .padding(theme.spacingM)
            .frame(height: theme.buttonHeight)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .glassEffect()
            .glassEffectID("partyCountInput", in: glassNamespace)
            .onChange(of: viewModel.partyCountText) { _, _ in
                viewModel.formatPartyCountInput()
            }
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        CalculateButton(
            buttonText: viewModel.calculateButtonText,
            isCalculating: viewModel.isCalculating,
            isEnabled: viewModel.isCalculateButtonEnabled
        ) {
            focusedField = nil
            viewModel.calculate()
        }
        .glassEffectID("calculate", in: glassNamespace)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct MediationFeeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                MediationFeeView(selectedYear: .year2026, isMonetary: true)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Monetary - Light")

            NavigationStack {
                MediationFeeView(selectedYear: .year2026, isMonetary: false)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Non-Monetary - Light")

            NavigationStack {
                MediationFeeView(selectedYear: .year2026, isMonetary: true)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Monetary - Dark")
        }
    }
}
