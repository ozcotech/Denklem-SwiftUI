//
//  LegislationView.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI

// MARK: - Legislation View
/// Displays legislation documents related to mediation
/// Provides access to tariff documents, laws, and regulations
@available(iOS 26.0, *)
struct LegislationView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = LegislationViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ScrollView {
            VStack(spacing: theme.spacingL) {
                // Header Section
                headerSection
                
                // Filter Section
                filterSection
                
                // Documents List
                documentsSection
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.top, theme.spacingM)
            .padding(.bottom, theme.spacingXXL)
        }
        .background(theme.background)
        .navigationTitle(LocalizationKeys.Legislation.title.localized)
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            prompt: Text(LocalizationKeys.Legislation.searchPrompt.localized)
        )
        .refreshable {
            viewModel.loadDocuments()
        }
        .sheet(isPresented: $viewModel.showPDFViewer) {
            if let document = viewModel.selectedDocument {
                DocumentDetailSheet(document: document)
            }
        }
        .alert(
            LocalizationKeys.General.error.localized,
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button(LocalizationKeys.General.ok.localized, role: .cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            Text(LocalizationKeys.Legislation.subtitle.localized)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, theme.spacingS)
    }
    
    // MARK: - Filter Section
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacingS) {
                // All filter
                FilterChip(
                    title: LocalizationKeys.Legislation.filterAll.localized,
                    isSelected: viewModel.selectedFilter == nil
                ) {
                    viewModel.selectedFilter = nil
                }
                
                // Type filters
                ForEach(LegislationDocument.DocumentType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.displayName,
                        systemImage: type.systemImage,
                        isSelected: viewModel.selectedFilter == type
                    ) {
                        viewModel.selectedFilter = type
                    }
                }
            }
            .padding(.horizontal, theme.spacingXS)
        }
    }
    
    // MARK: - Documents Section
    
    private var documentsSection: some View {
        LazyVStack(spacing: theme.spacingM, pinnedViews: [.sectionHeaders]) {
            ForEach(viewModel.sortedYears, id: \.self) { year in
                Section {
                    ForEach(viewModel.documentsByYear[year] ?? []) { document in
                        DocumentCard(document: document) {
                            viewModel.selectDocument(document)
                        } onOpenInSafari: {
                            viewModel.openInSafari(document)
                        }
                    }
                } header: {
                    YearSectionHeader(year: year)
                }
            }
        }
    }
}

// MARK: - Filter Chip

@available(iOS 26.0, *)
struct FilterChip: View {
    
    let title: String
    var systemImage: String?
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: theme.spacingXS) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(theme.caption)
                }

                Text(title)
                    .font(theme.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.vertical, theme.spacingS)
            .background(
                Capsule()
                    .fill(isSelected ? theme.primary.opacity(0.15) : theme.surface)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? theme.primary : theme.border, lineWidth: 1)
            )
            .foregroundStyle(isSelected ? theme.primary : theme.textSecondary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Year Section Header

@available(iOS 26.0, *)
struct YearSectionHeader: View {
    
    let year: Int
    
    @Environment(\.theme) var theme
    
    var body: some View {
        HStack {
            Text(String(year))
                .font(theme.headline)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
            
            Spacer()
        }
        .padding(.vertical, theme.spacingS)
        .padding(.horizontal, theme.spacingXS)
        .background(theme.background)
    }
}

// MARK: - Document Card

@available(iOS 26.0, *)
struct DocumentCard: View {
    
    let document: LegislationDocument
    let onTap: () -> Void
    let onOpenInSafari: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: theme.spacingM) {
                // Document Icon
                ZStack {
                    RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                        .fill(theme.primary.opacity(0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: document.type.systemImage)
                        .font(theme.title2)
                        .foregroundStyle(theme.primary)
                }

                // Document Info
                VStack(alignment: .leading, spacing: theme.spacingXS) {
                    Text(document.title)
                        .font(theme.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(document.subtitle)
                        .font(theme.caption)
                        .foregroundStyle(theme.textSecondary)
                        .lineLimit(1)
                    
                    // Tags
                    HStack(spacing: theme.spacingS) {
                        DocumentTag(
                            text: document.type.displayName,
                            color: theme.primary
                        )
                        
                        if document.isOfficial {
                            DocumentTag(
                                text: LocalizationKeys.Legislation.tagOfficial.localized,
                                color: theme.success
                            )
                        }
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(theme.caption)
                    .foregroundStyle(theme.textTertiary)
            }
            .padding(theme.spacingM)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                    .fill(theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                    .stroke(theme.border, lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            if document.url != nil {
                Button {
                    onOpenInSafari()
                } label: {
                    Label(
                        LocalizationKeys.Legislation.openInSafari.localized,
                        systemImage: "safari"
                    )
                }
            }
            
            Button {
                // Share action
            } label: {
                Label(LocalizationKeys.General.share.localized, systemImage: "square.and.arrow.up")
            }
        }
    }
}

// MARK: - Document Tag

@available(iOS 26.0, *)
struct DocumentTag: View {

    let text: String
    let color: Color

    @Environment(\.theme) var theme

    var body: some View {
        Text(text)
            .font(theme.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, theme.spacingS)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(color.opacity(0.1))
            )
            .foregroundStyle(color)
    }
}

// MARK: - Document Detail Sheet

@available(iOS 26.0, *)
struct DocumentDetailSheet: View {
    
    let document: LegislationDocument
    
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {
                    // Document Header
                    documentHeader
                    
                    // Document Info
                    documentInfo
                    
                    // Actions
                    actionButtons
                }
                .padding(theme.spacingM)
            }
            .background(theme.background)
            .navigationTitle(document.type.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.title2)
                            .foregroundStyle(theme.textSecondary)
                    }
                }
            }
        }
    }
    
    private var documentHeader: some View {
        VStack(spacing: theme.spacingM) {
            ZStack {
                Circle()
                    .fill(theme.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: document.type.systemImage)
                    .font(theme.largeTitle)
                    .foregroundStyle(theme.primary)
            }
            
            Text(document.title)
                .font(theme.title3)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(document.subtitle)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
        }
        .padding(.vertical, theme.spacingM)
    }
    
    private var documentInfo: some View {
        VStack(spacing: theme.spacingS) {
            InfoRow(
                label: LocalizationKeys.Legislation.infoYear.localized,
                value: String(document.year)
            )
            InfoRow(
                label: LocalizationKeys.Legislation.infoType.localized,
                value: document.type.displayName
            )
            InfoRow(
                label: LocalizationKeys.Legislation.infoStatus.localized,
                value: document.isOfficial ? 
                    LocalizationKeys.Legislation.statusOfficial.localized :
                    LocalizationKeys.Legislation.statusDraft.localized
            )
        }
        .padding(theme.spacingM)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadiusM)
                .fill(theme.surface)
        )
    }

    private var actionButtons: some View {
        VStack(spacing: theme.spacingM) {
            if let urlString = document.url, let url = URL(string: urlString) {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Label(
                        LocalizationKeys.Legislation.openDocument.localized,
                        systemImage: "doc.text"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.glass)
            }
        }
    }
}

// MARK: - Info Row

@available(iOS 26.0, *)
struct InfoRow: View {
    
    let label: String
    let value: String
    
    @Environment(\.theme) var theme
    
    var body: some View {
        HStack {
            Text(label)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(theme.body)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct LegislationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                LegislationView()
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                LegislationView()
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
