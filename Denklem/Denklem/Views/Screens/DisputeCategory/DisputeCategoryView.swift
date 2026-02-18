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
                    .buttonBorderShape(.roundedRectangle(radius: theme.cornerRadiusXL))

                    DisputeSectionCard(
                        title: viewModel.specialCalculationsTitle,
                        categories: viewModel.specialCalculations,
                        cardColor: theme.cardSpecial,
                        onCategoryTap: viewModel.selectCategory
                    )

                    DisputeSectionCard(
                        title: viewModel.otherCalculationsTitle,
                        categories: viewModel.otherCalculations,
                        cardColor: theme.cardOther,
                        onCategoryTap: viewModel.selectCategory
                    )

                    Spacer()
                        .frame(height: theme.spacingM)
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingXS)
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
        .overlay {
            // Coming Soon Popover
            if viewModel.showComingSoonPopover {
                comingSoonOverlay
            }
        }
        .onChange(of: viewModel.showComingSoonPopover) { _, newValue in
            if newValue {
                // Auto-dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        viewModel.showComingSoonPopover = false
                    }
                }
            }
        }
    }

    // MARK: - Coming Soon Overlay

    private var comingSoonOverlay: some View {
        ZStack {
            // Tap outside to dismiss
            theme.textPrimary.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        viewModel.showComingSoonPopover = false
                    }
                }

            // Coming Soon Content
            VStack(spacing: theme.spacingM) {
                Image(systemName: "hammer.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.primary)

                Text(LocalizationKeys.General.comingSoon.localized)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)

                Text(LocalizationKeys.General.comingSoonMessage.localized)
                    .font(theme.body)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(theme.spacingXL)
            .frame(maxWidth: 300)
            .background(.clear)
            .glassEffect(theme.glassClear, in: RoundedRectangle(cornerRadius: 24))
            .transition(
                .blurReplace
                .combined(with: .scale(0.85))
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.showComingSoonPopover)
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
