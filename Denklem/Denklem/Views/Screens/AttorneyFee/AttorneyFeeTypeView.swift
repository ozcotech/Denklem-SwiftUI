//
//  AttorneyFeeTypeView.swift
//  Denklem
//
//  Created by ozkan on 28.01.2026.
//

import SwiftUI

// MARK: - Attorney Fee Type View
/// Displays dispute type and agreement status selection for attorney fee calculation
/// User must select both options to proceed
@available(iOS 26.0, *)
struct AttorneyFeeTypeView: View {

    // MARK: - Properties

    @StateObject private var viewModel = AttorneyFeeTypeViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

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
                VStack(spacing: theme.spacingXL) {
                    // Dispute Type Section
                    disputeTypeSection

                    // Agreement Status Section
                    agreementStatusSection

                    // Continue Button
                    continueButtonSection
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingL)
                .padding(.bottom, theme.spacingXXL)
            }
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToInput) {
            AttorneyFeeInputView(
                isMonetary: viewModel.isMonetary,
                hasAgreement: viewModel.hasAgreement
            )
        }
        .sheet(isPresented: $viewModel.showResultSheet) {
            if let result = viewModel.noAgreementResult {
                AttorneyFeeResultSheet(result: result)
            }
        }
    }

    // MARK: - Dispute Type Section

    private var disputeTypeSection: some View {
        VStack(spacing: theme.spacingM) {
            // Section Header
            Text(LocalizationKeys.General.disputeSubject.localized)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Dispute Type Segmented Picker
            Picker("", selection: $viewModel.selectedDisputeType) {
                ForEach(AttorneyFeeDisputeType.allCases) { type in
                    Text(type.displayName)
                        .tag(type as AttorneyFeeDisputeType?)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(.large)

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
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDisputeType)
    }

    // MARK: - Agreement Status Section

    private var agreementStatusSection: some View {
        VStack(spacing: theme.spacingM) {
            // Section Header
            Text(LocalizationKeys.AttorneyFee.agreementScreenTitle.localized)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Agreement Status Segmented Picker
            Picker("", selection: $viewModel.selectedAgreementStatus) {
                ForEach(AttorneyFeeAgreementStatus.allCases) { status in
                    Text(status.displayName)
                        .tag(status as AttorneyFeeAgreementStatus?)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(.large)

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
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedAgreementStatus)
    }

    // MARK: - Continue Button Section

    private var continueButtonSection: some View {
        VStack(spacing: theme.spacingM) {
            // Continue Button
            Button {
                viewModel.handleContinue()
            } label: {
                HStack(spacing: theme.spacingS) {
                    Text(LocalizationKeys.General.next.localized)
                        .font(theme.headline)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .font(theme.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(viewModel.canProceed ? theme.textPrimary : theme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, theme.spacingM)
            }
            .buttonStyle(.glass)
            .disabled(!viewModel.canProceed)
            .opacity(viewModel.canProceed ? 1.0 : 0.5)
        }
        .padding(.top, theme.spacingL)
    }

}

// MARK: - Preview

@available(iOS 26.0, *)
struct AttorneyFeeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AttorneyFeeTypeView()
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")

            NavigationStack {
                AttorneyFeeTypeView()
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
