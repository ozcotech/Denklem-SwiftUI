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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguageToggleButton()
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToAgreementStatus) {
            AgreementStatusView(selectedYear: viewModel.selectedYear, isMonetary: viewModel.isMonetary)
        }
        .navigationDestination(isPresented: $viewModel.navigateToDisputeType) {
            // Non-monetary disputes go directly to DisputeType (bypass AgreementStatus)
            // hasAgreement = false as per Tariff Article 7, Paragraph 1
            DisputeTypeView(selectedYear: viewModel.selectedYear, isMonetary: false, hasAgreement: false)
        }
        .navigationDestination(isPresented: $viewModel.navigateToTimeCalculation) {
            TimeCalculationView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToSMMCalculation) {
            // TODO: Navigate to SMMCalculationView
            Text("SMMCalculationView")
                .font(theme.title)
                .foregroundColor(theme.textPrimary)
        }
    }
    
    // MARK: - Main Categories Grid (2x2)
    
    private var mainCategoriesGrid: some View {
        VStack(spacing: theme.spacingM) {
            // Section Title
            Text(NSLocalizedString("dispute_category.main_categories", 
                                 tableName: nil,
                                 bundle: Bundle.localizedBundle,
                                 value: "Uyuşmazlık Kategorileri", 
                                 comment: ""))
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
                        GlassCategoryButton(
                            category: category,
                            theme: theme,
                            namespace: glassNamespace
                        ) {
                            viewModel.selectCategory(category)
                        }
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
                        GlassCategoryButton(
                            category: category,
                            theme: theme,
                            namespace: glassNamespace
                        ) {
                            viewModel.selectCategory(category)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Glass Category Button (Liquid Glass Style - Square Form)
/// Apple native Liquid Glass button with morphing transitions
/// Uses GlassEffectContainer for shared sampling region and performance
/// Interactive modifier enables: scaling, bouncing, shimmer, touch illumination

@available(iOS 26.0, *)
struct GlassCategoryButton: View {
    
    let category: DisputeCategoryType
    let theme: ThemeProtocol
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button {
            // Bouncy animation for premium feel
            withAnimation(.bouncy(duration: 0.35)) {
                action()
            }
        } label: {
            VStack(spacing: theme.spacingS) {
                // Icon - Square background with gradient
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    category.iconColor.opacity(0.3),
                                    category.iconColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.systemImage)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(category.iconColor)
                }
                
                // Text Content
                Text(category.displayName)
                    .font(theme.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(theme.spacingS)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.roundedRectangle(radius: 24))
        .glassEffectID(category.id, in: namespace)
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
