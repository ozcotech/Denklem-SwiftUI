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
                    // Main Categories Grid (2x2)
                    mainCategoriesGrid

                    // Other Calculations Grid (2x1)
                    otherCalculationsGrid

                    Spacer()
                        .frame(height: theme.spacingXL)
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingXL)
            }
        }
        // Navigation bar title for Dispute Category screen ("Uyuşmazlık Kategorileri").
        // Do not confuse with DisputeCategory.title ("Kategori Seçin") used elsewhere.
        .navigationTitle(LocalizationKeys.DisputeCategory.mainCategories.localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            // Navigate to DisputeType with isMonetary flag
            // For monetary disputes, agreement selector will show in DisputeType
            // For non-monetary, hasAgreement = false per Tariff Article 7, Paragraph 1
            DisputeTypeView(
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
    }
    
    // MARK: - Main Categories Grid (2x2)
    
    private var mainCategoriesGrid: some View {
        VStack(spacing: theme.spacingM) {
            // Section Title
            Text(viewModel.mainCategoriesTitle)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 2x2 Grid with GlassEffectContainer for performance optimization
            GlassEffectContainer(spacing: theme.spacingM) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: theme.spacingM),
                        GridItem(.flexible(), spacing: theme.spacingM)
                    ],
                    spacing: theme.spacingM
                ) {
                    ForEach(viewModel.mainCategories) { category in
                        CapsuleButton(
                            systemImage: category.systemImage,
                            iconColor: category.iconColor,
                            text: category.displayName,
                            textColor: theme.textPrimary,
                            font: theme.footnote,
                            action: { viewModel.selectCategory(category) }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Other Calculations Grid (2x1)
    
    private var otherCalculationsGrid: some View {
        VStack(spacing: theme.spacingM) {
            // Section Title
            Text(viewModel.otherCalculationsTitle)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            // 2x1 Grid with GlassEffectContainer for performance optimization
            GlassEffectContainer(spacing: theme.spacingM) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: theme.spacingM),
                        GridItem(.flexible(), spacing: theme.spacingM)
                    ],
                    spacing: theme.spacingM
                ) {
                    ForEach(viewModel.otherCalculations) { category in
                        CapsuleButton(
                            systemImage: category.systemImage,
                            iconColor: category.iconColor,
                            text: category.displayName,
                            textColor: theme.textPrimary,
                            font: theme.footnote,
                            action: { viewModel.selectCategory(category) }
                        )
                    }
                }
            }
        }
    }
}


// MARK: - Preview

@available(iOS 26.0, *)
struct DisputeCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                DisputeCategoryView(selectedYear: .year2025)
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode - 2025")
            
            NavigationStack {
                DisputeCategoryView(selectedYear: .year2026)
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode - 2026")
        }
    }
}
