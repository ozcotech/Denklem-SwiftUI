//
//  TimeCalculationView.swift
//  Denklem
//
//  Created by ozkan on 03.01.2026.
//

import SwiftUI

// MARK: - Time Calculation View
/// Displays time calculation interface with date picker and results
/// Uses Apple native Liquid Glass with GlassEffectContainer for optimal performance
@available(iOS 26.0, *)
struct TimeCalculationView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = TimeCalculationViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    // MARK: - Body

    var body: some View {
        VStack(spacing: theme.spacingL) {
            // Graphical Date Picker (inline — full calendar visible)
            DatePicker(
                "",
                selection: $viewModel.startDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(theme.primary)
            .padding(.horizontal, theme.spacingM)

            // Calculate Button
            CalculateButton(
                buttonText: LocalizationKeys.General.calculate.localized,
                isCalculating: viewModel.isLoading,
                isEnabled: !viewModel.isLoading
            ) {
                viewModel.calculate()
            }
            .padding(.horizontal, theme.spacingM)

            Spacer()
        }
        .padding(.top, theme.spacingM)
        .navigationTitle(LocalizationKeys.ScreenTitle.timeCalculation.localized)
        .navigationBarTitleDisplayMode(.inline)
        .animatedBackground()
        .sheet(isPresented: $viewModel.showResults) {
            ResultsSheet(viewModel: viewModel)
        }
        .id(localeManager.refreshID)
    }
}

// MARK: - Results Sheet
/// Bottom sheet displaying calculation results
@available(iOS 26.0, *)
struct ResultsSheet: View {
    
    @ObservedObject var viewModel: TimeCalculationViewModel

    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    // Results Header
                    resultsHeader
                    
                    // Results Grid with GlassEffectContainer
                    GlassEffectContainer(spacing: theme.spacingM) {
                        LazyVStack(spacing: theme.spacingM) {
                            ForEach(viewModel.results) { result in
                                DisputeTypeResultCard(
                                    result: result,
                                    theme: theme
                                )
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.top, theme.spacingM)
            }
            .navigationTitle(LocalizationKeys.TimeCalculation.Result.processEndDates.localized)
            .navigationBarTitleDisplayMode(.inline)
            .animatedBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                }
            }
        }
        .presentationBackground(.clear) // Transparent sheet background
        .presentationBackgroundInteraction(.enabled) // Allow interaction through glass
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Results Header
    
    private var resultsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacingXS) {
                Text(LocalizationKeys.Input.assignmentDate.localized)
                    .font(theme.caption)
                    .foregroundStyle(theme.textSecondary)

                Text(LocalizationHelper.formatDate(viewModel.startDate))
                    .font(theme.headline)
                    .foregroundStyle(theme.textPrimary)
            }

            Spacer()

            Image(systemName: "clock.badge.checkmark.fill")
                .font(theme.largeTitle)
                .foregroundStyle(theme.primary)
                .accessibilityHidden(true)
        }
        .padding(theme.spacingM)
        .glassEffect(isAnimatedBackground ? .clear.interactive() : .regular.interactive())
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Dispute Type Result Card
/// Individual result card for each dispute type
@available(iOS 26.0, *)
struct DisputeTypeResultCard: View {
    
    let result: DisputeTypeResult
    let theme: ThemeProtocol

    @Environment(\.isAnimatedBackground) private var isAnimatedBackground

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingM) {
            // Dispute Type Title
            Text(result.localizedName)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
                .accessibilityAddTraits(.isHeader)
            
            Divider()
            
            // Normal Deadline (3rd or 6th week - Blue)
            DeadlineRow(
                label: result.normalWeekLabel,
                date: result.formattedNormalDeadline,
                color: theme.primary,
                theme: theme
            )
            
            // Extended Deadline (4th or 8th week - Soft Red)
            DeadlineRow(
                label: result.extendedWeekLabel,
                date: result.formattedExtendedDeadline,
                color: theme.error,
                theme: theme
            )
        }
        .padding(theme.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(isAnimatedBackground ? .clear : .regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }
}

// MARK: - Deadline Row
/// Row displaying week label and deadline date
@available(iOS 26.0, *)
struct DeadlineRow: View {
    
    let label: String
    let date: String
    let color: Color
    let theme: ThemeProtocol
    
    var body: some View {
        HStack {
            // Week Label
            HStack(spacing: theme.spacingXS) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(color)
                    .accessibilityHidden(true)

                Text(label)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)
            }
            
            Spacer()
            
            // Date - with fixed width for alignment
            Text(date)
                .font(theme.callout)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, theme.spacingS)
                .padding(.vertical, theme.spacingXS)
                .background(
                    Capsule()
                        .fill(color.opacity(0.15))
                )
                .frame(maxWidth: 180) // Fixed max width for consistent alignment
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Time Calculation Sheet
/// Sheet with graphical date picker + calculate button (presented from DisputeCategoryView)
@available(iOS 26.0, *)
struct TimeCalculationSheet: View {

    @StateObject private var viewModel = TimeCalculationViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: theme.spacingL) {
                // Graphical Date Picker
                DatePicker(
                    "",
                    selection: $viewModel.startDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(theme.primary)
                .padding(.horizontal, theme.spacingM)

                // Calculate Button
                CalculateButton(
                    buttonText: LocalizationKeys.General.calculate.localized,
                    isCalculating: viewModel.isLoading,
                    isEnabled: !viewModel.isLoading
                ) {
                    viewModel.calculate()
                }
                .padding(.horizontal, theme.spacingM)

                Spacer()
            }
            .padding(.top, theme.spacingM)
            .navigationTitle(LocalizationKeys.ScreenTitle.timeCalculation.localized)
            .navigationBarTitleDisplayMode(.inline)
            .animatedBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                }
            }
            .sheet(isPresented: $viewModel.showResults) {
                ResultsSheet(viewModel: viewModel)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .id(localeManager.refreshID)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct TimeCalculationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                TimeCalculationView()
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                TimeCalculationView()
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
