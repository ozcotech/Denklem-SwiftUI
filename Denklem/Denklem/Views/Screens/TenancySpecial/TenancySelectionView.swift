//
//  TenancySelectionView.swift
//  Denklem
//
//  Created by ozkan on 06.02.2026.
//

import SwiftUI

// MARK: - Focused Field Enum
enum TenancySelectionFocusedField: Hashable {
    case evictionAmount
    case determinationAmount
}

// MARK: - Tenancy Selection View
/// Unified screen for tenancy fee calculation with segmented picker
/// Combines attorney fee and mediation fee calculation in a single view
/// Segmented picker switches between Attorney Fee / Mediation Fee modes
@available(iOS 26.0, *)
struct TenancySelectionView: View {

    // MARK: - Properties

    @StateObject private var viewModel: TenancySelectionViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Focus State
    @FocusState private var focusedField: TenancySelectionFocusedField?

    // MARK: - Initialization

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: TenancySelectionViewModel(selectedYear: selectedYear))
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

                        // Segmented Picker
                        feeModePicker

                        // Eviction Checkbox + Input
                        evictionSection

                        // Determination Checkbox + Input
                        determinationSection

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            errorMessageView(errorMessage)
                        }

                        // Calculate Button
                        calculateButton
                            .id("calculateButton")
                    }
                    .padding(.horizontal, theme.spacingL)
                    .padding(.top, theme.spacingS)
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
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showAttorneyResultSheet) {
            if let result = viewModel.attorneyCalculationResult {
                TenancyAttorneyFeeResultSheet(result: result)
            }
        }
        .sheet(isPresented: $viewModel.showMediationResultSheet) {
            if let result = viewModel.mediationCalculationResult {
                TenancyMediationFeeResultSheet(result: result)
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }

    // MARK: - Year Picker Section

    private var yearPickerSection: some View {
        VStack(spacing: theme.spacingS) {
            Menu {
                ForEach(viewModel.availableYears) { year in
                    Button {
                        viewModel.selectedYear = year
                    } label: {
                        HStack {
                            Text(year.displayName)
                            if viewModel.selectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: theme.spacingXS) {
                    Text("\(viewModel.selectedYear.rawValue)")
                        .font(theme.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.primary)

                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(theme.primary)
                }
                .padding(.horizontal, theme.spacingS)
                .padding(.vertical, theme.spacingXS)
                .background {
                    Capsule()
                        .fill(theme.surfaceElevated.opacity(0.6))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Fee Mode Segmented Picker

    private var feeModePicker: some View {
        Picker("", selection: $viewModel.selectedFeeMode) {
            Text(LocalizationKeys.RentSpecial.pickerAttorneyFee.localized)
                .tag(TenancyCalculationConstants.TenancyFeeMode.attorneyFee)
            Text(LocalizationKeys.RentSpecial.pickerMediationFee.localized)
                .tag(TenancyCalculationConstants.TenancyFeeMode.mediationFee)
        }
        .pickerStyle(.segmented)
        .controlSize(.large)
        .onChange(of: viewModel.selectedFeeMode) { _, newValue in
            viewModel.switchFeeMode(newValue)
        }
    }

    // MARK: - Eviction Section

    private var evictionSection: some View {
        VStack(spacing: theme.spacingS) {
            // Checkbox
            tenancyTypeCheckbox(
                type: .eviction,
                isSelected: viewModel.isEvictionSelected,
                action: { viewModel.toggleEviction() }
            )

            // Conditional Input
            if viewModel.isEvictionSelected {
                TextField(
                    LocalizationKeys.RentSpecial.evictionAmountLabel.localized,
                    text: $viewModel.evictionAmountText
                )
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
                .focused($focusedField, equals: .evictionAmount)
                .id(TenancySelectionFocusedField.evictionAmount)
                .onChange(of: viewModel.evictionAmountText) { _, newValue in
                    var value = newValue
                    viewModel.formatAmountInput(&value)
                    viewModel.evictionAmountText = value
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isEvictionSelected)
    }

    // MARK: - Determination Section

    private var determinationSection: some View {
        VStack(spacing: theme.spacingS) {
            // Checkbox
            tenancyTypeCheckbox(
                type: .determination,
                isSelected: viewModel.isDeterminationSelected,
                action: { viewModel.toggleDetermination() }
            )

            // Conditional Input
            if viewModel.isDeterminationSelected {
                TextField(
                    LocalizationKeys.RentSpecial.determinationAmountLabel.localized,
                    text: $viewModel.determinationAmountText
                )
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
                .focused($focusedField, equals: .determinationAmount)
                .id(TenancySelectionFocusedField.determinationAmount)
                .onChange(of: viewModel.determinationAmountText) { _, newValue in
                    var value = newValue
                    viewModel.formatAmountInput(&value)
                    viewModel.determinationAmountText = value
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isDeterminationSelected)
    }

    // MARK: - Checkbox Component

    private func tenancyTypeCheckbox(
        type: TenancyCalculationConstants.TenancyType,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacingM) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(theme.title3)
                    .foregroundStyle(isSelected ? theme.success : theme.textSecondary)

                VStack(alignment: .leading, spacing: theme.spacingXS) {
                    Text(type.displayName)
                        .font(theme.body)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)

                    Text(type.inputDescription)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)
                }

                Spacer()
            }
            .padding(theme.spacingM)
            .frame(maxWidth: .infinity)
            .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusM))
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    // MARK: - Error Message

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
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.error.opacity(0.1))
        }
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        Button {
            focusedField = nil
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.calculate()
            }
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
            .frame(height: theme.buttonHeight)
        }
        .buttonStyle(.glass)
        .tint(theme.primary)
        .disabled(!viewModel.isCalculateButtonEnabled || viewModel.isCalculating)
        .opacity(viewModel.isCalculateButtonEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct TenancySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                TenancySelectionView(selectedYear: .year2026)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")

            NavigationStack {
                TenancySelectionView(selectedYear: .year2026)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
