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

    // MARK: - Focus & Scroll

    @FocusState private var focusedField: AttorneyFeeFocusedField?
    @Namespace private var glassNamespace

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

                        // Dispute Type Segmented Picker
                        disputeTypeSection

                        // Agreement Status Segmented Picker
                        agreementStatusSection

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

                        // Calculate Button
                        if viewModel.showCalculateButton {
                            calculateButton
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.top, theme.spacingXS)
                    .padding(.bottom, theme.spacingXXL)
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
            focusedField = nil
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDisputeType)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedAgreementStatus)
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.calculationResult {
                AttorneyFeeResultSheet(result: result)
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

    // MARK: - Dispute Type Section

    private var disputeTypeSection: some View {
        VStack(spacing: theme.spacingM) {
            // Uses CommonSegmentedPicker with optional enum selection.
            CommonSegmentedPicker(
                selection: .optional($viewModel.selectedDisputeType),
                options: AttorneyFeeDisputeType.allCases
            ) { type in
                Text(type.displayName)
            }

            // Selected type indicator
            if let selected = viewModel.selectedDisputeType {
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
            }
        }
        .id(localeManager.refreshID)
    }

    // MARK: - Agreement Status Section

    private var agreementStatusSection: some View {
        VStack(spacing: theme.spacingM) {
            // Uses CommonSegmentedPicker with optional enum selection.
            CommonSegmentedPicker(
                selection: .optional($viewModel.selectedAgreementStatus),
                options: AttorneyFeeAgreementStatus.allCases
            ) { status in
                Text(status.displayName)
            }

            // Selected status indicator
            if let selected = viewModel.selectedAgreementStatus {
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
            }
        }
        .id(localeManager.refreshID)
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
            .glassEffect()
            .glassEffectID("amountInput", in: glassNamespace)
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
            .glassEffect()
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
