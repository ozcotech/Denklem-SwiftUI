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
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    // MARK: - Focus & Scroll

    @FocusState private var focusedField: MediationFeeFocusedField?
    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: MediationFeeViewModel(
            selectedYear: selectedYear
        ))
    }

    // MARK: - Body

    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        ZStack {
            // Content
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: theme.spacingXS) {

                        // Year Picker
                        yearPickerSection

                        // Cable: Year → Monetary/Non-Monetary fork
                        CableConnector(mode: .fork(
                            leftActive: viewModel.isMonetary,
                            rightActive: !viewModel.isMonetary,
                            leftColor: theme.primary,
                            rightColor: theme.primary,
                            from: .center
                        ))

                        // Monetary / Non-Monetary Toggle Buttons
                        monetaryPickerSection

                        // Cable: Monetary → Agreement/Non-Agreement OR Non-Monetary → Dispute Type
                        if viewModel.showAgreementSelector {
                            // Fork from monetary button (left) to agreement/non-agreement buttons
                            // hideInactive: only show the active branch cable
                            CableConnector(mode: .fork(
                                leftActive: viewModel.selectedAgreement == .agreed,
                                rightActive: viewModel.selectedAgreement == .notAgreed,
                                leftColor: theme.success,
                                rightColor: theme.error,
                                from: .left,
                                hideInactive: true
                            ))

                            agreementSelectorSection

                            // L-shaped cable from selected agreement button to center (dispute type)
                            CableConnector(mode: .bend(
                                active: viewModel.selectedAgreement != nil,
                                color: cableColor,
                                from: viewModel.selectedAgreement == .notAgreed ? .right : .left
                            ))
                        } else {
                            // Bend from non-monetary button (right) to center
                            CableConnector(mode: .bend(
                                active: true,
                                color: theme.primary,
                                from: .right
                            ))

                            // Hide info text and extra cable once dispute type is selected
                            if viewModel.selectedDisputeType == nil {
                                nonMonetaryInfoSection
                                    .transition(.opacity.combined(with: .move(edge: .top)))

                                CableConnector(mode: .straight(
                                    active: false,
                                    color: cableColor
                                ))
                            }
                        }

                        // Dispute Type Dropdown
                        disputeTypeMenuSection
                            .id("disputeTypeMenu")

                        // Input Fields (conditional)
                        if viewModel.showAmountInput {
                            CableConnector(mode: .straight(active: true, color: cableColor))

                            amountInputField
                                .id("amountInput")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if viewModel.showPartyCountInput {
                            CableConnector(mode: .straight(active: true, color: cableColor))

                            partyCountInputField
                                .id("partyCountInput")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            ErrorBannerView(message: errorMessage)
                        }

                        // Cable: → Calculate Button
                        CableConnector(mode: .straight(
                            active: viewModel.isCalculateButtonEnabled,
                            color: cableColor
                        ))

                        // Calculate Button
                        calculateButton

                        // Fee Result Card (shown after calculation)
                        if let result = viewModel.calculationResult {
                            CableConnector(mode: .straight(active: true, color: cableColor))

                            mediationFeeCard(result: result)
                                .id("feeCard")
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.top, theme.spacingXS)
                    .padding(.bottom, theme.spacingXXL)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: focusedField) { _, newValue in
                    guard let newValue else { return }
                    // Clear previous result when user starts editing
                    viewModel.calculationResult = nil
                    glowPhase = false
                    nudgePhase = false
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
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isMonetary)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedAgreement)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDisputeType != nil)
        .animation(.easeInOut(duration: 0.2), value: viewModel.hasAgreement)
        .animation(.easeInOut(duration: 0.3), value: viewModel.calculationResult != nil)
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .animatedBackground()
        .sheet(isPresented: $viewModel.showResult, onDismiss: {
            focusedField = nil
        }) {
            if let result = viewModel.calculationResult {
                MediationFeeResultSheet(result: result, theme: theme, isMonetary: viewModel.isMonetary)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if let msg = newValue {
                AccessibilityNotification.Announcement(msg).post()
            }
        }
        .onDisappear {
            focusedField = nil
        }
    }

    // MARK: - Monetary Picker Section

    private var monetaryPickerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingXS) {
            Text(LocalizationKeys.ScreenTitle.subjectSelection.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(LocalizationKeys.ScreenTitle.subjectSelection.localized)

            ToggleButtonPair(
                leftTitle: LocalizationKeys.CalculationType.monetary.localized,
                rightTitle: LocalizationKeys.CalculationType.nonMonetary.localized,
                isLeftSelected: viewModel.isMonetary,
                onLeftTap: { viewModel.isMonetary = true },
                onRightTap: { viewModel.isMonetary = false }
            )
            .onChange(of: viewModel.isMonetary) { _, _ in
                viewModel.resetFormForModeChange()
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
        VStack(spacing: theme.spacingXS) {
            Text(LocalizationKeys.ScreenTitle.agreementStatus.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(LocalizationKeys.ScreenTitle.agreementStatus.localized)
                .frame(maxWidth: .infinity, alignment: .leading)

            ToggleButtonPair(
                leftTitle: AgreementSelectionType.agreed.displayName,
                rightTitle: AgreementSelectionType.notAgreed.displayName,
                isLeftSelected: viewModel.selectedAgreement == .agreed,
                leftColor: theme.success,
                rightColor: theme.error,
                onLeftTap: { viewModel.selectedAgreement = .agreed },
                onRightTap: { viewModel.selectedAgreement = .notAgreed }
            )
        }
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
        VStack(alignment: .leading, spacing: theme.spacingXS) {
            Text(LocalizationKeys.ScreenTitle.disputeType.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(LocalizationKeys.ScreenTitle.disputeType.localized)

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
            .glassEffect(isAnimatedBackground ? .clear : .regular)
        }
        .accessibilityLabel(LocalizationKeys.ScreenTitle.disputeType.localized)
        .accessibilityValue(viewModel.selectedDisputeType?.displayName ?? LocalizationKeys.DisputeType.selectPrompt.localized)
        .accessibilityHint(LocalizationKeys.Accessibility.disputeTypeMenuHint.localized)
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
            .glassEffect(isAnimatedBackground ? .clear : .regular)
            .accessibilityLabel(LocalizationKeys.Input.agreementAmount.localized)
            .accessibilityHint(LocalizationKeys.Accessibility.amountFieldHint.localized)
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
            .glassEffect(isAnimatedBackground ? .clear : .regular)
            .accessibilityLabel(LocalizationKeys.Input.Placeholder.partyCount.localized)
            .accessibilityHint(LocalizationKeys.Accessibility.partyCountFieldHint.localized)
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
    }

    // MARK: - Cable Color

    private var cableColor: Color {
        guard viewModel.isMonetary else { return theme.primary }
        switch viewModel.selectedAgreement {
        case .agreed: return theme.success
        case .notAgreed: return theme.error
        case nil: return theme.textTertiary
        }
    }

    // MARK: - Mediation Fee Card

    @State private var glowPhase = false
    @State private var nudgePhase = false

    private func mediationFeeCard(result: CalculationResult) -> some View {
        HStack {
            Spacer()

            VStack(spacing: theme.spacingXS) {
                Text(LocalizationKeys.Result.mediationFee.localized)
                    .font(theme.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)

                Text(LocalizationHelper.formatCurrency(result.amount))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(theme.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(theme.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
                .offset(x: nudgePhase ? 3 : 0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: nudgePhase)
        }
        .padding(.vertical, theme.spacingM)
        .padding(.horizontal, theme.spacingL)
        .contentShape(Capsule())
        .glassEffect(isAnimatedBackground ? .clear : .regular)
        .shadow(color: theme.primary.opacity(glowPhase ? 0.4 : 0.1), radius: glowPhase ? 12 : 4)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowPhase = true
            }
            nudgePhase = true
        }
        .onTapGesture {
            viewModel.showResult = true
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(LocalizationKeys.Accessibility.expandCollapseHint.localized)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct MediationFeeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                MediationFeeView(selectedYear: .year2026)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light")

            NavigationStack {
                MediationFeeView(selectedYear: .year2026)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark")
        }
    }
}
