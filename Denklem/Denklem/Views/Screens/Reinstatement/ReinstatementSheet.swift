//
//  ReinstatementSheet.swift
//  Denklem
//
//  Created by ozkan on 03.02.2026.
//

import SwiftUI

// MARK: - Focused Field Enum
/// Tracks which input field is currently focused
enum ReinstatementFocusedField: Hashable {
    case compensation
    case idleWage
    case otherRights
    case partyCount
}

// MARK: - Reinstatement Sheet
/// Sheet view for reinstatement (işe iade) mediation fee calculation
/// Legal basis: Labor Courts Law Art. 3/13-2, Labor Law Art. 20-2, Art. 21/7
@available(iOS 26.0, *)
struct ReinstatementSheet: View {

    // MARK: - Properties

    @StateObject private var viewModel: ReinstatementViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Focus State
    @FocusState private var focusedField: ReinstatementFocusedField?

    // MARK: - Namespace for Morphing Transitions

    @Namespace private var glassNamespace

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: ReinstatementViewModel(selectedYear: selectedYear))
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
                    ReinstatementResultView(
                        result: result,
                        theme: theme,
                        onDismiss: { dismiss() },
                        onRecalculate: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.recalculate()
                            }
                        }
                    )
                } else {
                    // Input View
                    inputView
                }
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
        .onDisappear {
            focusedField = nil
        }
    }

    // MARK: - Input View

    private var inputView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: theme.spacingL) {

                    // Year Picker Section
                    yearPickerSection

                    // Agreement Status Segmented Picker
                    agreementStatusSection

                    // Conditional Input Fields
                    if viewModel.isAgreedCase {
                        agreementInputFieldsWithFocus
                    } else if viewModel.isNotAgreedCase {
                        noAgreementInputFieldsWithFocus
                    }

                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                    }

                    // Calculate Button (only show after agreement status selected)
                    if viewModel.isAgreementStatusSelected {
                        calculateButton
                            .id("calculateButton")
                    }
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.bottom, theme.spacingXXL)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: focusedField) { _, newValue in
                guard let field = newValue else { return }
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(field, anchor: .center)
                }
            }
        }
    }

    // MARK: - Year Picker Section

    private var yearPickerSection: some View {
        YearPickerSection(
            availableYears: viewModel.availableYears,
            selectedYear: viewModel.selectedYear,
            legalReferenceText: LocalizationKeys.Reinstatement.tariffSection.localized,
            showTopPadding: true,
            onYearSelected: { viewModel.selectedYear = $0 }
        )
    }

    // MARK: - Agreement Status Section (Segmented Picker)

    private var agreementStatusSection: some View {
        VStack(spacing: theme.spacingM) {
            // Uses CommonSegmentedPicker with optional enum selection.
            CommonSegmentedPicker(
                selection: .optional($viewModel.selectedAgreementStatus),
                options: [.agreed, .notAgreed]
            ) { status in
                Text(status.displayName)
            }
            .onChange(of: viewModel.selectedAgreementStatus) { _, newValue in
                if let status = newValue {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.selectAgreementStatus(status)
                    }
                }
            }

            // Helper text - shows selected status with color
            if let selected = viewModel.selectedAgreementStatus {
                HStack(spacing: theme.spacingXS) {
                    Image(systemName: selected == .agreed ? "checkmark" : "xmark")
                        .font(theme.footnote)
                        .fontWeight(.semibold)
                    Text(selected.displayName)
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(selected == .agreed ? theme.success : theme.error)
                .transition(.opacity.combined(with: .scale))
            } else {
                Text(LocalizationKeys.AgreementStatus.selectPrompt.localized)
                    .font(theme.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .transition(.opacity)
            }
        }
        .padding(.bottom, theme.spacingM)
        .id(localeManager.refreshID)
        .onAppear {
            // Auto-select first option if none selected (for better UX)
            if viewModel.selectedAgreementStatus == nil {
                viewModel.selectAgreementStatus(.agreed)
            }
        }
    }

    // MARK: - Agreement Input Fields (with Focus tracking)

    private var agreementInputFieldsWithFocus: some View {
        VStack(spacing: theme.spacingM) {
            // Compensation Input (İşe Başlatılmama Tazminatı)
            TextField(viewModel.compensationLabel, text: $viewModel.compensationText)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(theme.spacingM)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect()
                .glassEffectID("compensationInput", in: glassNamespace)
                .focused($focusedField, equals: .compensation)
                .id(ReinstatementFocusedField.compensation)
                .onChange(of: viewModel.compensationText) { _, newValue in
                    var value = newValue
                    viewModel.formatAmountInput(&value)
                    viewModel.compensationText = value
                }

            // Idle Wage Input (Boşta Geçen Süre Ücreti)
            TextField(viewModel.idleWageLabel, text: $viewModel.idleWageText)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(theme.spacingM)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect()
                .glassEffectID("idleWageInput", in: glassNamespace)
                .focused($focusedField, equals: .idleWage)
                .id(ReinstatementFocusedField.idleWage)
                .onChange(of: viewModel.idleWageText) { _, newValue in
                    var value = newValue
                    viewModel.formatAmountInput(&value)
                    viewModel.idleWageText = value
                }

            // Other Rights Input (Diğer Haklar)
            TextField(viewModel.otherRightsLabel, text: $viewModel.otherRightsText)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(theme.spacingM)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect()
                .glassEffectID("otherRightsInput", in: glassNamespace)
                .focused($focusedField, equals: .otherRights)
                .id(ReinstatementFocusedField.otherRights)
                .onChange(of: viewModel.otherRightsText) { _, newValue in
                    var value = newValue
                    viewModel.formatAmountInput(&value)
                    viewModel.otherRightsText = value
                }

        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - No Agreement Input Fields (with Focus tracking)

    private var noAgreementInputFieldsWithFocus: some View {
        VStack(spacing: theme.spacingM) {
            // Party Count Input (Taraf Sayısı)
            TextField(viewModel.partyCountLabel, text: $viewModel.partyCountText)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
                .keyboardType(.numberPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .padding(theme.spacingM)
                .frame(height: theme.buttonHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .glassEffect()
                .glassEffectID("partyCountInput", in: glassNamespace)
                .focused($focusedField, equals: .partyCount)
                .id(ReinstatementFocusedField.partyCount)
                .onChange(of: viewModel.partyCountText) { _, _ in
                    viewModel.formatPartyCountInput()
                }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
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
            focusedField = nil
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.calculate()
            }
        }
        .glassEffectID("calculate", in: glassNamespace)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct ReinstatementSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReinstatementSheet(selectedYear: .year2026)
                .injectTheme(LightTheme())
                .previewDisplayName("2026 - Light Mode")

            ReinstatementSheet(selectedYear: .year2025)
                .injectTheme(DarkTheme())
                .preferredColorScheme(.dark)
                .previewDisplayName("2025 - Dark Mode")
        }
    }
}
