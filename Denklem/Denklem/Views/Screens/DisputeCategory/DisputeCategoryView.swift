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
                VStack(spacing: theme.spacingXL) {
                    mainCategoriesGrid
                    specialCalculationsGrid
                    otherCalculationsGrid
                    Spacer()
                        .frame(height: theme.spacingXL)
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingXL)
            }
        }
        // Navigation bar title for Tools screen ("Hesaplama Araçları" / "Calculation Tools")
        .navigationTitle(LocalizationKeys.Tools.title.localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            MediationFeeView(
                selectedYear: viewModel.selectedYear,
                isMonetary: viewModel.isMonetary
            )
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
    // MARK: - Special Calculations Card (Özel Hesaplamalar)

    private var specialCalculationsGrid: some View {
        VStack(spacing: theme.spacingS) {
            // Section Title
            Text(viewModel.specialCalculationsTitle)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 2x2 Grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: theme.spacingS),
                    GridItem(.flexible(), spacing: theme.spacingS)
                ],
                spacing: theme.spacingS
            ) {
                ForEach(viewModel.specialCalculations) { category in
                    RectangleButton(
                        systemImage: category.systemImage,
                        iconColor: category.iconColor,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusM,
                        action: { viewModel.selectCategory(category) }
                    )
                }
            }
        }
        .padding(.horizontal, theme.spacingS)
        .padding(.top, theme.spacingS)
        .padding(.bottom, theme.spacingL)
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }

    // MARK: - Main Categories Card (Uyuşmazlık Konusu)

    private var mainCategoriesGrid: some View {
        VStack(spacing: theme.spacingS) {
            // Section Title
            Text(viewModel.mainCategoriesTitle)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 2x2 Grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: theme.spacingS),
                    GridItem(.flexible(), spacing: theme.spacingS)
                ],
                spacing: theme.spacingS
            ) {
                ForEach(viewModel.mainCategories) { category in
                    RectangleButton(
                        systemImage: category.systemImage,
                        iconColor: category.iconColor,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusM,
                        action: { viewModel.selectCategory(category) }
                    )
                }
            }
        }
        .padding(.horizontal, theme.spacingS)
        .padding(.top, theme.spacingS)
        .padding(.bottom, theme.spacingL)
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }

    // MARK: - Other Calculations Card (Diğer Hesaplamalar)

    private var otherCalculationsGrid: some View {
        VStack(spacing: theme.spacingS) {
            // Section Title
            Text(viewModel.otherCalculationsTitle)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 2x2 Grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: theme.spacingS),
                    GridItem(.flexible(), spacing: theme.spacingS)
                ],
                spacing: theme.spacingS
            ) {
                ForEach(viewModel.otherCalculations) { category in
                    RectangleButton(
                        systemImage: category.systemImage,
                        iconColor: category.iconColor,
                        text: category.displayName,
                        textColor: theme.textPrimary,
                        font: theme.footnote,
                        cornerRadius: theme.cornerRadiusM,
                        action: { viewModel.selectCategory(category) }
                    )
                }
            }
        }
        .padding(.horizontal, theme.spacingS)
        .padding(.top, theme.spacingS)
        .padding(.bottom, theme.spacingL)
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
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
