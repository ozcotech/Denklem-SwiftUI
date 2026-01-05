//
//  LanguageToggleButton.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI

// MARK: - Language Toggle Button
/// A toolbar button that toggles between Turkish and English languages
/// Uses iOS 26 native Liquid Glass button style with circle shape
@available(iOS 26.0, *)
struct LanguageToggleButton: View {
    
    // MARK: - Properties
    
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    /// Animation state for toggle effect
    @State private var isAnimating: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Button {
            toggleLanguage()
        } label: {
            Text(localeManager.toggleTargetShortName)
                .font(.system(size: 14, weight: .bold))
                .contentTransition(.numericText())
                .foregroundStyle(theme.textPrimary)
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
    }
    
    // MARK: - Private Methods
    
    /// Toggles the language with animation
    private func toggleLanguage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
        }
        
        // Toggle language
        localeManager.toggleLanguage()
        
        // Reset animation state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = false
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        return NSLocalizedString(
            LocalizationKeys.Language.select,
            comment: "Language selection button"
        )
    }
    
    private var accessibilityHint: String {
        let targetLanguage = localeManager.currentLanguage.toggled.displayName
        return String(format: NSLocalizedString(
            "accessibility.switch_to_language",
            value: "Switch to %@",
            comment: "Accessibility hint for language toggle"
        ), targetLanguage)
    }
}

// MARK: - Language Toggle Button Style Variants

@available(iOS 26.0, *)
extension LanguageToggleButton {
    
    /// Creates a compact version with only the icon
    static func compact() -> some View {
        CompactLanguageToggleButton()
    }
    
    /// Creates an expanded version with full language name
    static func expanded() -> some View {
        ExpandedLanguageToggleButton()
    }
}

// MARK: - Compact Language Toggle Button

@available(iOS 26.0, *)
struct CompactLanguageToggleButton: View {
    
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    var body: some View {
        Button {
            localeManager.toggleLanguage()
        } label: {
            Image(systemName: "globe")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.primary)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .accessibilityLabel(NSLocalizedString(LocalizationKeys.Language.select, comment: ""))
    }
}

// MARK: - Expanded Language Toggle Button

@available(iOS 26.0, *)
struct ExpandedLanguageToggleButton: View {
    
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    
    var body: some View {
        Button {
            localeManager.toggleLanguage()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                    .font(.system(size: 16, weight: .medium))
                
                Text(localeManager.currentLanguage.toggled.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .contentTransition(.numericText())
            }
            .foregroundStyle(theme.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .accessibilityLabel(NSLocalizedString(LocalizationKeys.Language.select, comment: ""))
    }
}

// MARK: - Language Picker Sheet

@available(iOS 26.0, *)
struct LanguagePickerSheet: View {
    
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(SupportedLanguage.allCases) { language in
                    LanguageRow(
                        language: language,
                        isSelected: localeManager.isSelected(language)
                    ) {
                        localeManager.setLanguage(language)
                        dismiss()
                    }
                }
            }
            .navigationTitle(NSLocalizedString(LocalizationKeys.Language.title, comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(NSLocalizedString(LocalizationKeys.General.done, comment: "")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Language Row

@available(iOS 26.0, *)
struct LanguageRow: View {
    
    let language: SupportedLanguage
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(language.flagEmoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.body)
                        .foregroundStyle(theme.textPrimary)
                    
                    Text(language.localeIdentifier)
                        .font(.caption)
                        .foregroundStyle(theme.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(theme.primary)
                        .font(.title3)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct LanguageToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard Button
            VStack(spacing: 20) {
                LanguageToggleButton()
                
                LanguageToggleButton.compact()
                
                LanguageToggleButton.expanded()
            }
            .padding()
            .injectTheme(LightTheme())
            .injectLocaleManager()
            .previewDisplayName("All Variants")
            
            // In Navigation Bar
            NavigationStack {
                Text("Content")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            LanguageToggleButton()
                        }
                    }
            }
            .injectTheme(LightTheme())
            .injectLocaleManager()
            .previewDisplayName("In Toolbar")
            
            // Language Picker Sheet
            LanguagePickerSheet()
                .injectTheme(LightTheme())
                .injectLocaleManager()
                .previewDisplayName("Picker Sheet")
        }
    }
}
