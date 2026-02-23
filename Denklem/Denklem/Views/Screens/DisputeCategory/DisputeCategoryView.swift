//
//  DisputeCategoryView.swift
//  Denklem
//
//  Created by ozkan on 01.01.2026.
//

import SwiftUI

// MARK: - Dispute Category View
/// Displays dispute category selection (Monetary, Non-Monetary, Time, SMM)
/// First screen after year selection in the calculation flow
/// Uses Apple native Liquid Glass with GlassEffectContainer for optimal performance
@available(iOS 26.0, *)
struct DisputeCategoryView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: DisputeCategoryViewModel
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Initialization
    
    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: DisputeCategoryViewModel(selectedYear: selectedYear))
    }
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        ZStack {
            // Background
            theme.background
                .ignoresSafeArea()

            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: theme.spacingM) {
                        Button {
                            viewModel.selectCategory(.mediationFee)
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: DisputeCategoryType.mediationFee.systemImage)
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(DisputeCategoryType.mediationFee.iconColor)
                                Text(DisputeCategoryType.mediationFee.displayName)
                                    .font(theme.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(theme.textPrimary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.glass(.clear.tint(theme.surface)))

                        DisputeSectionCard(
                            title: viewModel.specialCalculationsTitle,
                            categories: viewModel.specialCalculations,
                            cardColor: theme.cardSpecial,
                            onCategoryTap: viewModel.selectCategory
                        )
                    }
                    .padding(.horizontal, theme.spacingM)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        // Navigation bar title for Tools screen ("Hesaplama Araçları" / "Calculation Tools")
        .navigationTitle(LocalizationKeys.Tools.title.localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            MediationFeeView(selectedYear: viewModel.selectedYear)
        }
        .navigationDestination(isPresented: $viewModel.navigateToTimeCalculation) {
            TimeCalculationView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToSMMCalculation) {
            SMMCalculationView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToAttorneyFee) {
            AttorneyFeeView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToTenancySpecial) {
            TenancySelectionView(selectedYear: viewModel.selectedYear)
        }
        .sheet(isPresented: $viewModel.showSerialDisputesSheet) {
            SerialDisputesSheet(selectedYear: viewModel.selectedYear)
        }
        .sheet(isPresented: $viewModel.showReinstatementSheet) {
            ReinstatementSheet(selectedYear: viewModel.selectedYear)
        }
    }
}


// MARK: - Preview

@available(iOS 26.0, *)
struct DisputeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode
            NavigationStack {
                DisputeCategoryView(selectedYear: .year2025)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")

            // Dark Mode
            NavigationStack {
                DisputeCategoryView(selectedYear: .year2025)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
