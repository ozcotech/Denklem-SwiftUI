//
//  AboutView.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI

// MARK: - Disclaimer Anchor Preference

@available(iOS 26.0, *)
private struct DisclaimerAnchorKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

@available(iOS 26.0, *)
private struct SupportedLanguagesAnchorKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

// MARK: - About View
@available(iOS 26.0, *)
struct AboutView: View {

    // MARK: - Properties

    @StateObject private var viewModel = AboutViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme

    @State private var showingDisclaimerPopover: Bool = false
    @State private var showingSupportedLanguagesPopover: Bool = false

    // MARK: - Body

    var body: some View {
        // Observe language changes to trigger view refresh
        let _ = localeManager.refreshID

        ScrollView {
            VStack(spacing: theme.spacingM) {
                appHeaderSection

                // Settings Section (Language & Theme)
                settingsSection

                ForEach(viewModel.sections) { section in
                    AboutSectionView(
                        section: section,
                        onShowDisclaimer: {
                            showingSupportedLanguagesPopover = false
                            showingDisclaimerPopover = true
                        },
                        onShowSupportedLanguages: {
                            showingDisclaimerPopover = false
                            showingSupportedLanguagesPopover = true
                        },
                        onItemTap: { item in viewModel.handleAction(for: item) }
                    )
                }

                copyrightFooter
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.bottom, theme.spacingXXL)
        }
        .coordinateSpace(name: "about.scroll")
        .background(theme.background)
        .navigationTitle(LocalizationKeys.Settings.title.localized)
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: localeManager.refreshID) { _, _ in
            viewModel.loadSections()
        }
        .overlayPreferenceValue(DisclaimerAnchorKey.self) { anchor in
            GeometryReader { proxy in
                if let anchor, showingDisclaimerPopover {
                    let rect = proxy[anchor]
                    let maxWidth = max(260, min(420, proxy.size.width - (theme.spacingM * 2)))

                    ZStack {
                        // Tap outside to dismiss (no dimming, fully clear)
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { showingDisclaimerPopover = false }

                        // The actual glass popover (NO system popover chrome)
                        DisclaimerPopoverContent()
                            .frame(width: maxWidth)
                            .fixedSize(horizontal: false, vertical: true)
                            // place above the row; clamp so it stays on-screen
                            .position(
                                x: min(max(rect.midX, maxWidth / 2 + theme.spacingM),
                                       proxy.size.width - maxWidth / 2 - theme.spacingM),
                                y: max(theme.spacingM + 20, rect.minY - 72)
                            )
                            .onTapGesture { /* swallow taps */ }
                            .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .bottom)))
                    }
                    .animation(.easeInOut(duration: theme.fastAnimationDuration), value: showingDisclaimerPopover)
                }
            }
        }
        .overlayPreferenceValue(SupportedLanguagesAnchorKey.self) { anchor in
            GeometryReader { proxy in
                if let anchor, showingSupportedLanguagesPopover {
                    let rect = proxy[anchor]
                    let maxWidth = max(240, min(360, proxy.size.width - (theme.spacingM * 2)))

                    ZStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { showingSupportedLanguagesPopover = false }

                        SupportedLanguagesPopoverContent()
                            .frame(width: maxWidth)
                            .fixedSize(horizontal: false, vertical: true)
                            .position(
                                x: min(max(rect.midX, maxWidth / 2 + theme.spacingM),
                                       proxy.size.width - maxWidth / 2 - theme.spacingM),
                                y: max(theme.spacingM + 20, rect.minY - 72)
                            )
                            .onTapGesture { /* swallow taps */ }
                            .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .bottom)))
                    }
                    .animation(.easeInOut(duration: theme.fastAnimationDuration), value: showingSupportedLanguagesPopover)
                }
            }
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
        VStack(spacing: theme.spacingXS) {
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
                .foregroundStyle(theme.primary)
        }
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
        .padding(.top, theme.spacingS)
    }

    // MARK: - Settings Section

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            Text(LocalizationKeys.Settings.title.localized)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
                .padding(.leading, theme.spacingXS)

            VStack(spacing: 0) {
                // Language Toggle Row
                languageToggleRow

                Divider()
                    .padding(.horizontal, theme.spacingM)

                // Theme Picker Row
                themePickerRow
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusM))
        }
    }

    // MARK: - Language Picker Row

    private var languageToggleRow: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            HStack(spacing: theme.spacingM) {
                Image(systemName: "globe")
                    .font(theme.body)
                    .foregroundStyle(theme.primary)
                    .frame(width: 30)

                Text(LocalizationKeys.Settings.language.localized)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            Picker("", selection: Binding(
                get: { localeManager.currentLanguage },
                set: { localeManager.setLanguage($0) }
            )) {
                Text(LocalizationKeys.Language.turkish.localized).tag(SupportedLanguage.turkish)
                Text(LocalizationKeys.Language.english.localized).tag(SupportedLanguage.english)
                Text(LocalizationKeys.Language.swedish.localized).tag(SupportedLanguage.swedish)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, theme.spacingM)
        .padding(.vertical, theme.spacingM)
    }

    // MARK: - Theme Picker Row

    private var themePickerRow: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            // Label row
            HStack(spacing: theme.spacingM) {
                Image(systemName: "wand.and.sparkles")
                    .font(theme.body)
                    .foregroundStyle(theme.primary)
                    .frame(width: 30)

                Text(LocalizationKeys.Settings.appearance.localized)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)

                Spacer()
            }

            // Segmented picker (full width, centered)
            Picker("", selection: Binding(
                get: { themeManager.currentAppearanceMode },
                set: { themeManager.setAppearanceMode($0) }
            )) {
                Text(LocalizationKeys.Settings.light.localized).tag(AppearanceMode.light)
                Text(LocalizationKeys.Settings.dark.localized).tag(AppearanceMode.dark)
                Text(LocalizationKeys.Settings.system.localized).tag(AppearanceMode.system)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, theme.spacingM)
        .padding(.vertical, theme.spacingM)
    }
}

// MARK: - About Section View

@available(iOS 26.0, *)
struct AboutSectionView: View {

    let section: AboutScreenSection
    let onShowDisclaimer: () -> Void
    let onShowSupportedLanguages: () -> Void
    let onItemTap: (AboutSectionItem) -> Void

    @Environment(\.theme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingS) {
            Text(section.title)
                .font(theme.headline)
                .fontWeight(.semibold)
                .foregroundStyle(theme.textSecondary)
                .padding(.leading, theme.spacingXS)

            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                    AboutItemRow(
                        item: item,
                        onShowDisclaimer: onShowDisclaimer,
                        onShowSupportedLanguages: onShowSupportedLanguages,
                        action: { onItemTap(item) }
                    )

                    if index < section.items.count - 1 {
                        Divider()
                            .padding(.horizontal, theme.spacingM)
                    }
                }
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: theme.cornerRadiusM))
        }
    }
}

// MARK: - About Item Row

@available(iOS 26.0, *)
struct AboutItemRow: View {

    let item: AboutSectionItem
    let onShowDisclaimer: () -> Void
    let onShowSupportedLanguages: () -> Void
    let action: () -> Void

    @Environment(\.theme) var theme

    var body: some View {
        Button {
            if item.action == .showDisclaimer {
                onShowDisclaimer()
            } else if item.action == .showSupportedLanguages {
                onShowSupportedLanguages()
            } else {
                action()
            }
        } label: {
            HStack(spacing: theme.spacingM) {
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                        .font(theme.body)
                        .foregroundStyle(theme.primary)
                        .frame(width: 30)
                }

                Text(item.title)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)

                Spacer()

                if let value = item.value {
                    Text(value)
                        .font(theme.body)
                        .foregroundStyle(theme.textSecondary)
                        .lineLimit(2)
                }

                if item.action != nil && item.action != AboutSectionItem.AboutItemAction.none {
                    Image(systemName: "chevron.right")
                        .font(theme.caption)
                        .foregroundStyle(theme.textTertiary)
                }
            }
            .padding(.horizontal, theme.spacingM)
            .padding(.vertical, theme.spacingM)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(item.action == nil || item.action == AboutSectionItem.AboutItemAction.none)
        // Anchor only the disclaimer row so we can position the overlay correctly
        .anchorPreference(
            key: DisclaimerAnchorKey.self,
            value: .bounds
        ) { anchor in
            (item.action == .showDisclaimer) ? anchor : nil
        }
        .anchorPreference(
            key: SupportedLanguagesAnchorKey.self,
            value: .bounds
        ) { anchor in
            (item.action == .showSupportedLanguages) ? anchor : nil
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
            HStack(spacing: theme.spacingS) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(theme.title3)
                    .foregroundStyle(theme.warning)

                Text(LocalizationKeys.Legal.disclaimer.localized)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textPrimary)
            }

            ScrollView {
                Text(LocalizationKeys.Legal.disclaimerText.localized)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scrollContentBackground(.hidden)
            .frame(maxHeight: 420)
        }
        .padding(theme.spacingL)
        .background(.clear)
        // Use theme glass; system popover removed so this is now the only "background"
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28))
    }
}

@available(iOS 26.0, *)
struct SupportedLanguagesPopoverContent: View {

    @Environment(\.theme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacingM) {
            HStack(spacing: theme.spacingS) {
                Image(systemName: "globe")
                    .font(theme.title3)
                    .foregroundStyle(theme.primary)

                Text(LocalizationKeys.About.supportedLanguages.localized)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.textPrimary)
            }

            VStack(alignment: .leading, spacing: theme.spacingS) {
                ForEach(SupportedLanguage.allCases, id: \.self) { language in
                    Text("\(language.flagEmoji)  \(language.displayName) (\(language.shortName))")
                        .font(theme.body)
                        .foregroundStyle(theme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(theme.spacingL)
        .background(.clear)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
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
