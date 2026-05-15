//
//  ConsumerDisputeView.swift
//  Denklem
//
//  Created by ozkan on 13.05.2026.
//
//  Input screen for the Consumer Dispute mediation fee calculation.
//  Year + Settlement amount + Payment responsibility (3-way Menu) → Calculate → Result Sheet.
//

import SwiftUI

@available(iOS 26.0, *)
struct ConsumerDisputeView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ConsumerDisputeViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    @FocusState private var amountFieldFocused: Bool

    // MARK: - Init

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: ConsumerDisputeViewModel(selectedYear: selectedYear))
    }

    // MARK: - Body

    var body: some View {
        let _ = localeManager.refreshID

        ScrollView {
            VStack(spacing: theme.spacingL) {
                yearPickerSection
                amountInputSection
                payerMenuSection

                if let message = viewModel.errorMessage {
                    ErrorBannerView(message: message)
                }

                calculateButton

                if let result = viewModel.calculationResult {
                    inlineResultCard(result: result)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.top, theme.spacingM)
            .padding(.bottom, theme.spacingXXL)
        }
        .scrollDismissesKeyboard(.interactively)
        .contentShape(Rectangle())
        .onTapGesture { amountFieldFocused = false }
        .animation(.easeInOut(duration: 0.3), value: viewModel.calculationResult != nil)
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .animatedBackground()
        .sheet(isPresented: $viewModel.showResults) {
            if let result = viewModel.calculationResult {
                ConsumerDisputeResultSheet(result: result)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if let msg = newValue {
                AccessibilityNotification.Announcement(msg).post()
            }
        }
        .onChange(of: viewModel.calculationResult != nil) { _, hasResult in
            // Announce the freshly-calculated total so VoiceOver users don't have to
            // hunt for the inline result card that just slid in below the Calculate button.
            // (Result is always cleared to nil before any recalculation, so this fires on every fresh calc.)
            if hasResult, let result = viewModel.calculationResult {
                let msg = "\(LocalizationKeys.Result.mediationFee.localized): \(LocalizationHelper.formatCurrency(result.totalFee))"
                AccessibilityNotification.Announcement(msg).post()
            }
        }
        .onDisappear { amountFieldFocused = false }
    }

    // MARK: - Year Picker

    private var yearPickerSection: some View {
        YearPickerSection(
            availableYears: viewModel.availableYears,
            selectedYear: viewModel.selectedYear,
            onYearSelected: { newYear in
                viewModel.selectedYear = newYear
                // Recalculation requires a re-tap; clear stale result so it doesn't mislead.
                viewModel.calculationResult = nil
            }
        )
    }

    // MARK: - Amount Input Section

    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingXS) {
            Text(LocalizationKeys.ConsumerDispute.agreementAmountLabel.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)

            TextField(
                LocalizationKeys.Input.Placeholder.amount.localized,
                text: $viewModel.amountText
            )
            .font(theme.body)
            .fontWeight(.medium)
            .foregroundStyle(theme.textPrimary)
            .keyboardType(.decimalPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .focused($amountFieldFocused)
            .padding(theme.spacingM)
            .frame(height: theme.buttonHeight)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .glassEffect(isAnimatedBackground ? .clear : .regular)
            .accessibilityLabel(LocalizationKeys.ConsumerDispute.agreementAmountLabel.localized)
            .accessibilityHint(LocalizationKeys.Accessibility.amountFieldHint.localized)
            .onChange(of: viewModel.amountText) { _, _ in
                viewModel.formatAmountInput()
                // Editing invalidates any previous result; clear it so the inline card doesn't lie.
                if viewModel.calculationResult != nil {
                    viewModel.calculationResult = nil
                }
            }
        }
    }

    // MARK: - Payer Menu Section

    private var payerMenuSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingXS) {
            Text(LocalizationKeys.ConsumerDispute.payerLabel.localized)
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textSecondary)
                .accessibilityAddTraits(.isHeader)

            Menu {
                ForEach(PaymentResponsibility.allCases) { option in
                    Button {
                        viewModel.paymentResponsibility = option
                        // Switching the payer changes the result; clear the stale inline card.
                        viewModel.calculationResult = nil
                    } label: {
                        HStack {
                            Text(option.displayName)
                            if viewModel.paymentResponsibility == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: theme.spacingXS) {
                    Text(viewModel.paymentResponsibility.displayName)
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.primary)

                    Spacer()

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(theme.primary)
                        .accessibilityHidden(true)
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.vertical, theme.spacingM)
                .frame(maxWidth: .infinity)
                .frame(height: theme.buttonHeight)
                .contentShape(Rectangle())
                .glassEffect(isAnimatedBackground ? .clear : .regular)
            }
            .accessibilityLabel(LocalizationKeys.ConsumerDispute.payerLabel.localized)
            .accessibilityValue(viewModel.paymentResponsibility.displayName)
            .accessibilityHint(LocalizationKeys.Accessibility.consumerDisputePayerMenuHint.localized)
        }
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        CalculateButton(
            buttonText: viewModel.calculateButtonText,
            isCalculating: viewModel.isLoading,
            isEnabled: viewModel.canCalculate
        ) {
            amountFieldFocused = false
            viewModel.calculate()
        }
    }

    // MARK: - Inline Result Card

    @State private var nudgePhase = false
    @State private var glowPhase = false

    private func inlineResultCard(result: ConsumerDisputeResult) -> some View {
        HStack {
            Spacer()

            VStack(spacing: theme.spacingXS) {
                Text(LocalizationKeys.Result.mediationFee.localized)
                    .font(theme.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)

                Text(LocalizationHelper.formatCurrency(result.totalFee))
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
                .accessibilityHidden(true)
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
            viewModel.showResults = true
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(LocalizationKeys.Accessibility.expandCollapseHint.localized)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview("Light") {
    NavigationStack {
        ConsumerDisputeView(selectedYear: .year2026)
    }
    .injectTheme(LightTheme())
}

@available(iOS 26.0, *)
#Preview("Dark") {
    NavigationStack {
        ConsumerDisputeView(selectedYear: .year2026)
    }
    .injectTheme(DarkTheme())
    .preferredColorScheme(.dark)
}
