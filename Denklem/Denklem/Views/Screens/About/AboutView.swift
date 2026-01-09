//
//  AboutView.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI

// MARK: - About View
/// Displays app information, developer details, and support options
@available(iOS 26.0, *)
struct AboutView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = AboutViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    // MARK: - Body
    
    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID
        
        ScrollView {
            VStack(spacing: theme.spacingL) {
                // App Header
                appHeaderSection
                
                // Sections
                ForEach(viewModel.sections) { section in
                    AboutSectionView(section: section) { item in
                        viewModel.handleAction(for: item)
                    }
                }
                
                // Copyright Footer
                copyrightFooter
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.top, theme.spacingM)
            .padding(.bottom, theme.spacingXXL)
        }
        .background(theme.background)
        .navigationTitle(LocalizationKeys.ScreenTitle.about.localized)
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: localeManager.refreshID) { _, _ in
            viewModel.loadSections()
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.getShareItems())
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
    
    // MARK: - App Header Section
    
    private var appHeaderSection: some View {
        VStack(spacing: theme.spacingM) {
            // App Name
            Text(viewModel.appName)
                .font(theme.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(theme.textPrimary)
            
            // App Tagline
            Text(LocalizationKeys.AppInfo.tagline.localized)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
            
            // Version Badge
            Text("v\(viewModel.appVersion)")
                .font(theme.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(theme.primary.opacity(0.1))
                )
                .foregroundStyle(theme.primary)
        }
        .padding(.vertical, theme.spacingL)
    }
    
    // MARK: - Copyright Footer
    
    private var copyrightFooter: some View {
        VStack(spacing: theme.spacingS) {
            Text(viewModel.copyrightText)
                .font(theme.caption)
                .foregroundStyle(theme.textTertiary)
            
            Text("about.made_with_love".localized)
                .font(theme.caption)
                .foregroundStyle(theme.textTertiary)
        }
        .multilineTextAlignment(.center)
        .padding(.top, theme.spacingL)
    }
}

// MARK: - About Section View

@available(iOS 26.0, *)
struct AboutSectionView: View {
    
    let section: AboutScreenSection
    let onItemTap: (AboutSectionItem) -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            // Section Header
            Text(section.title)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
                .padding(.leading, theme.spacingXS)
            
            // Section Items
            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                    AboutItemRow(item: item) {
                        onItemTap(item)
                    }
                    
                    if index < section.items.count - 1 {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.border, lineWidth: 0.5)
            )
        }
    }
}

// MARK: - About Item Row

@available(iOS 26.0, *)
struct AboutItemRow: View {
    
    let item: AboutSectionItem
    let action: () -> Void
    
    @Environment(\.theme) var theme
    @State private var showingDisclaimer = false
    
    var body: some View {
        Button(action: {
            if item.action == .showDisclaimer {
                showingDisclaimer = true
            } else {
                action()
            }
        }) {
            HStack(spacing: theme.spacingM) {
                // Icon
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                        .font(.body)
                        .foregroundStyle(theme.primary)
                        .frame(width: 30)
                }
                
                // Title
                Text(item.title)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)
                
                Spacer()
                
                // Value or Chevron
                if let value = item.value {
                    Text(value)
                        .font(theme.body)
                        .foregroundStyle(theme.textSecondary)
                        .lineLimit(1)
                }
                
                if item.action != nil && item.action != AboutSectionItem.AboutItemAction.none {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(theme.textTertiary)
                }
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.vertical, theme.spacingM)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(item.action == nil || item.action == AboutSectionItem.AboutItemAction.none)
        .popover(isPresented: $showingDisclaimer, arrowEdge: .bottom) {
            DisclaimerPopoverContent()
                .presentationCompactAdaptation(.popover)
                .presentationBackground { Color.clear }
        }
    }
}

// MARK: - Share Sheet

@available(iOS 26.0, *)
struct ShareSheet: UIViewControllerRepresentable {
    
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Disclaimer Popover Content

@available(iOS 26.0, *)
struct DisclaimerPopoverContent: View {
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingM) {
            // Header
            HStack(spacing: theme.spacingS) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(theme.warning)
                
                Text(LocalizationKeys.Legal.disclaimer.localized)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textPrimary)
            }
            .padding(.bottom, theme.spacingXS)
            
            // Disclaimer Text
            ScrollView {
                Text(LocalizationKeys.Legal.disclaimerText.localized)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scrollContentBackground(.hidden)
            .frame(maxHeight: 500)
        }
        .padding(theme.spacingL)
        .frame(width: 380)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AboutView()
            }
            .injectTheme(LightTheme())
            .previewDisplayName("Light Mode")
            
            NavigationStack {
                AboutView()
            }
            .injectTheme(DarkTheme())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
