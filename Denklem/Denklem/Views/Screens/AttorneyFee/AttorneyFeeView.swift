//
//  AttorneyFeeView.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI

// MARK: - Attorney Fee View
/// Unified screen for attorney fee calculation
/// Combines type selection (dispute type, agreement status) and input fields in a single screen
/// Replaces the previous AttorneyFeeTypeView → AttorneyFeeInputView two-screen flow
@available(iOS 26.0, *)
struct AttorneyFeeView: View {

    // MARK: - Properties

    @StateObject private var viewModel = AttorneyFeeViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    // MARK: - Focus & Scroll

    @FocusState private var focusedField: AttorneyFeeFocusedField?

    // MARK: - Fee Card Animation

    @State private var glowPhase = false
    @State private var nudgePhase = false

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

                        // Cable: Year → Dispute Type fork
                        CableConnector(mode: .fork(
                            leftActive: viewModel.isMonetary,
                            rightActive: !viewModel.isMonetary,
                            leftColor: theme.primary,
                            rightColor: theme.primary,
                            from: .center
                        ))

                        // Dispute Type Toggle Buttons
                        disputeTypeSection

                        // Cable: Dispute Type → Agreement
                        CableConnector(mode: .fork(
                            leftActive: viewModel.hasAgreement,
                            rightActive: !viewModel.hasAgreement,
                            leftColor: theme.success,
                            rightColor: theme.error,
                            from: viewModel.isMonetary ? .left : .right,
                            hideInactive: true
                        ))

                        // Agreement Status Toggle Buttons
                        agreementStatusSection

                        // Cable: Agreement → next input section (bend to center)
                        CableConnector(mode: .bend(
                            active: viewModel.showAmountInput || viewModel.showCourtTypePicker || viewModel.showCalculateOnly,
                            color: cableColor,
                            from: viewModel.hasAgreement ? .left : .right
                        ))

                        // Conditional Input Fields
                        if viewModel.showAmountInput {
                            amountInputField
                                .id("amountInput")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if viewModel.showCourtTypePicker {
                            courtTypePickerSection
                                .id("courtTypePicker")
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            ErrorBannerView(message: errorMessage)
                        }

                        // Cable: → Calculate Button
                        if viewModel.showCalculateButton {
                            CableConnector(mode: .straight(
                                active: viewModel.isCalculateButtonEnabled,
                                color: cableColor
                            ))

                            calculateButton
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        // Fee Result Card (shown after calculation)
                        if let result = viewModel.calculationResult {
                            CableConnector(mode: .straight(active: true, color: cableColor))

                            attorneyFeeCard(result: result)
                                .id("feeCard")
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.top, theme.spacingXS)
                    .padding(.bottom, theme.spacingXXL * 1.5)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: focusedField) { _, newValue in
                    guard newValue != nil else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo("amountInput", anchor: .center)
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDisputeType)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedAgreementStatus)
        .animation(.easeInOut(duration: 0.2), value: viewModel.showAmountInput)
        .animation(.easeInOut(duration: 0.2), value: viewModel.showCourtTypePicker)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showCalculateButton)
        .animation(.easeInOut(duration: 0.3), value: viewModel.calculationResult != nil)
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .animatedBackground()
        .sheet(isPresented: $viewModel.showResult, onDismiss: {
            focusedField = nil
        }) {
            if let result = viewModel.calculationResult {
                AttorneyFeeResultSheet(result: result)
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

    // MARK: - Cable Color

    private var cableColor: Color {
        switch viewModel.selectedAgreementStatus {
        case .agreed: return theme.success
        case .notAgreed: return theme.error
        case nil: return theme.textTertiary
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

    // MARK: - Dispute Type Section

    private var disputeTypeSection: some View {
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
                onLeftTap: { viewModel.selectedDisputeType = .monetary },
                onRightTap: { viewModel.selectedDisputeType = .nonMonetary }
            )
        }
    }

    // MARK: - Agreement Status Section

    private var agreementStatusSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingXS) {
            Text(LocalizationKeys.ScreenTitle.agreementStatus.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(LocalizationKeys.ScreenTitle.agreementStatus.localized)

            ToggleButtonPair(
                leftTitle: AttorneyFeeAgreementStatus.agreed.displayName,
                rightTitle: AttorneyFeeAgreementStatus.notAgreed.displayName,
                isLeftSelected: viewModel.hasAgreement,
                leftColor: theme.success,
                rightColor: theme.error,
                onLeftTap: { viewModel.selectedAgreementStatus = .agreed },
                onRightTap: { viewModel.selectedAgreementStatus = .notAgreed }
            )
        }
    }

    // MARK: - Amount Input Field

    private var amountInputField: some View {
        TextField(viewModel.amountPlaceholder, text: $viewModel.amountText)
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

    // MARK: - Court Type Dropdown Menu

    private var courtTypePickerSection: some View {
        Menu {
            ForEach(viewModel.availableCourtTypes) { courtType in
                Button {
                    viewModel.selectCourtType(courtType)
                } label: {
                    HStack {
                        Text("\(courtType.displayName) — \(LocalizationHelper.formatCurrency(courtType.feeWithBonus(for: viewModel.selectedYear.rawValue)))")
                        if viewModel.selectedCourtType == courtType {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: theme.spacingXS) {
                Text(viewModel.selectedCourtType?.displayName
                     ?? LocalizationKeys.AttorneyFee.selectCourt.localized)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.selectedCourtType != nil
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
        .accessibilityLabel(LocalizationKeys.AttorneyFee.courtType.localized)
        .accessibilityValue(viewModel.selectedCourtType?.displayName ?? LocalizationKeys.AttorneyFee.selectCourt.localized)
        .accessibilityHint(LocalizationKeys.Accessibility.courtTypeMenuHint.localized)
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

    // MARK: - Fee Result Card

    private func attorneyFeeCard(result: AttorneyFeeResult) -> some View {
        HStack {
            Spacer()

            VStack(spacing: theme.spacingXS) {
                Text(LocalizationKeys.DisputeCategory.attorneyFee.localized)
                    .font(theme.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)

                Text(LocalizationHelper.formatCurrency(result.fee))
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
struct AttorneyFeeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AttorneyFeeView()
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")

            NavigationStack {
                AttorneyFeeView()
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
