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
    
    // MARK: - State for Date Picker Sheet
    
    @State private var showDatePicker = false
    
    // MARK: - Namespace for Morphing Transitions
    
    @Namespace private var glassNamespace
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            theme.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                VStack(spacing: theme.spacingXL) {
                    // Date Input Section - matches Calculate button width
                    dateInputSection
                        .padding(.horizontal, theme.spacingXXL)
                    
                    // Calculate Button - independent padding (matches StartScreen Enter button)
                    calculateButton
                        .padding(.horizontal, theme.spacingXXL)
                }
                
                Spacer()
            }
        }
        .navigationTitle(LocalizationKeys.ScreenTitle.timeCalculation.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LanguageToggleButton()
            }
        }
        .sheet(isPresented: $viewModel.showResults) {
            ResultsSheet(viewModel: viewModel, glassNamespace: glassNamespace)
        }
        .id(localeManager.refreshID) // Observe language changes without re-rendering DatePicker
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: theme.spacingS) {
            Image(systemName: "clock.fill")
                .font(.system(size: 60))
                .foregroundStyle(theme.primary)
                .padding(.bottom, theme.spacingS)
            
            Text(LocalizationKeys.TimeCalculation.disputeTypes.localized)
                .font(theme.title2)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacingL)
    }
    
    // MARK: - Date Input Section
    
    private var dateInputSection: some View {
        VStack(spacing: theme.spacingM) {
            // Section Title
            Text(LocalizationKeys.Input.assignmentDate.localized)
                .font(theme.headline)
                .foregroundStyle(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Date Selection Button with Glass Effect
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(theme.primary)
                    
                    Text(formattedDate)
                        .font(theme.body)
                        .foregroundStyle(theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(theme.textSecondary)
                }
                .padding(theme.spacingM)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
            .buttonStyle(.glass)
            .tint(theme.surface)
            .glassEffectID("dateSelector", in: glassNamespace)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $viewModel.startDate, glassNamespace: glassNamespace)
        }
    }
    
    // MARK: - Formatted Date String
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        // TR: dd.MM.yyyy / EN: MM/dd/yyyy
        formatter.locale = localeManager.currentLocale
        formatter.dateStyle = .medium
        return formatter.string(from: viewModel.startDate)
    }
    
    // MARK: - Calculate Button
    
    private var calculateButton: some View {
        Button {
            viewModel.calculate()
        } label: {
            HStack(spacing: theme.spacingM) {
                Text(LocalizationKeys.General.calculate.localized)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
            }
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .buttonStyle(.glass)
        .tint(theme.primary)
        .glassEffectID("calculate", in: glassNamespace)
        .disabled(viewModel.isLoading)
        .opacity(viewModel.isLoading ? 0.6 : 1.0)
    }
}

// MARK: - Results Sheet
/// Bottom sheet displaying calculation results
@available(iOS 26.0, *)
struct ResultsSheet: View {
    
    @ObservedObject var viewModel: TimeCalculationViewModel
    let glassNamespace: Namespace.ID
    
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
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
                                    theme: theme,
                                    namespace: glassNamespace
                                )
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: theme.spacingXXL)
                }
                .padding(.horizontal, theme.spacingL)
                .padding(.top, theme.spacingM)
            }
            .navigationTitle(LocalizationKeys.TimeCalculation.Result.processEndDates.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("✓")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(theme.textPrimary)
                            .frame(width: 30, height: 30)
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
                .font(.largeTitle)
                .foregroundStyle(theme.primary)
        }
        .padding(theme.spacingM)
        .glassEffect(.regular.interactive()) // Liquid Glass header card
    }
}

// MARK: - Dispute Type Result Card
/// Individual result card for each dispute type
@available(iOS 26.0, *)
struct DisputeTypeResultCard: View {
    
    let result: DisputeTypeResult
    let theme: ThemeProtocol
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingM) {
            // Dispute Type Title
            Text(result.localizedName)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textPrimary)
            
            Divider()
            
            // Normal Deadline (3rd or 6th week - Blue)
            DeadlineRow(
                label: result.normalWeekLabel,
                date: result.formattedNormalDeadline,
                color: .blue,
                theme: theme
            )
            
            // Extended Deadline (4th or 8th week - Soft Red)
            DeadlineRow(
                label: result.extendedWeekLabel,
                date: result.formattedExtendedDeadline,
                color: Color(red: 0.9, green: 0.3, blue: 0.4),
                theme: theme
            )
        }
        .padding(theme.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.outline, lineWidth: theme.borderWidth)
        )
        .glassEffectID(result.id.uuidString, in: namespace)
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
    }
}

// MARK: - Date Picker Sheet
/// Sheet displaying graphical date picker for date selection
@available(iOS 26.0, *)
struct DatePickerSheet: View {
    
    @Binding var selectedDate: Date
    let glassNamespace: Namespace.ID
    
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localeManager = LocaleManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: theme.spacingL) {
                // Date Picker
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(theme.primary)
                .padding(theme.spacingM)
                
                Spacer()
            }
            .padding(.horizontal, theme.spacingL)
            .padding(.top, theme.spacingM)
            .navigationTitle(LocalizationKeys.Input.assignmentDate.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("✓")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(theme.primary)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                }
            }
        }
        .presentationDetents([.medium])
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
