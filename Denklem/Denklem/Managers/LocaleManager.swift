//
//  LocaleManager.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI
import Combine

// MARK: - Locale Manager
/// Manages app-wide locale and language settings
/// Provides centralized language switching with persistence
@MainActor
final class LocaleManager: ObservableObject {
    
    // MARK: - Singleton
    
    /// Shared instance for app-wide access
    static let shared = LocaleManager()
    
    // MARK: - Published Properties
    
    /// Current selected language
    @Published private(set) var currentLanguage: SupportedLanguage {
        didSet {
            saveLanguagePreference()
            updateLocale()
        }
    }
    
    /// Current locale based on selected language
    @Published private(set) var currentLocale: Locale
    
    /// Whether a language change requires app restart
    @Published private(set) var requiresRestart: Bool = false
    
    // MARK: - Private Properties
    
    /// UserDefaults key for language preference
    private let languagePreferenceKey = AppConstants.UserDefaultsKeys.selectedLanguage
    
    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    private init() {
        // Load saved language or detect from system
        let savedLanguage = Self.loadSavedLanguage()
        self.currentLanguage = savedLanguage
        self.currentLocale = Locale(identifier: savedLanguage.localeIdentifier)
        
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    /// Sets the current language
    /// - Parameter language: The language to set
    func setLanguage(_ language: SupportedLanguage) {
        guard language != currentLanguage else { return }
        
        currentLanguage = language
        requiresRestart = true
    }
    
    /// Toggles between available languages
    func toggleLanguage() {
        setLanguage(currentLanguage.toggled)
    }
    
    /// Returns localized string for the current language
    /// - Parameters:
    ///   - key: Localization key
    ///   - comment: Comment for translators
    /// - Returns: Localized string
    func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    /// Checks if a specific language is currently selected
    /// - Parameter language: Language to check
    /// - Returns: True if the language is currently selected
    func isSelected(_ language: SupportedLanguage) -> Bool {
        return currentLanguage == language
    }
    
    /// Returns the display name for the current language
    var currentLanguageDisplayName: String {
        return currentLanguage.displayName
    }
    
    /// Returns the short name for the current language (for toggle button)
    var currentLanguageShortName: String {
        return currentLanguage.shortName
    }
    
    /// Returns the opposite language short name (for toggle button label)
    var toggleTargetShortName: String {
        return currentLanguage.toggled.shortName
    }
    
    /// Resets language to system default
    func resetToSystemLanguage() {
        let systemLanguage = Self.detectSystemLanguage()
        setLanguage(systemLanguage)
    }
    
    // MARK: - Private Methods
    
    /// Sets up Combine bindings
    private func setupBindings() {
        // Monitor language changes for any additional side effects
        $currentLanguage
            .dropFirst()
            .sink { [weak self] (_: SupportedLanguage) in
                self?.notifyLanguageChange()
            }
            .store(in: &cancellables)
    }
    
    /// Saves language preference to UserDefaults
    private func saveLanguagePreference() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languagePreferenceKey)
        UserDefaults.standard.synchronize()
        
        // Also update Apple's preferred language array
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
    }
    
    /// Updates the current locale based on selected language
    private func updateLocale() {
        currentLocale = Locale(identifier: currentLanguage.localeIdentifier)
    }
    
    /// Notifies the system about language change
    private func notifyLanguageChange() {
        // Post notification for any observers
        NotificationCenter.default.post(
            name: .languageDidChange,
            object: nil,
            userInfo: ["language": currentLanguage]
        )
    }
    
    /// Loads saved language from UserDefaults
    /// - Returns: Saved language or system-detected language
    private static func loadSavedLanguage() -> SupportedLanguage {
        if let savedCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguage),
           let language = SupportedLanguage(rawValue: savedCode) {
            return language
        }
        
        return detectSystemLanguage()
    }
    
    /// Detects system language
    /// - Returns: System language if supported, otherwise default
    private static func detectSystemLanguage() -> SupportedLanguage {
        let preferredLanguages = Locale.preferredLanguages
        
        for preferredLanguage in preferredLanguages {
            let languageCode = String(preferredLanguage.prefix(2)).lowercased()
            if let language = SupportedLanguage(rawValue: languageCode) {
                return language
            }
        }
        
        return .turkish
    }
}

// MARK: - Notification Names

extension Notification.Name {
    /// Posted when the app language changes
    static let languageDidChange = Notification.Name("com.denklem.languageDidChange")
}

// MARK: - Environment Key

/// Environment key for accessing LocaleManager
/// MainActor isolated to satisfy Swift 6 concurrency requirements
@MainActor
private struct LocaleManagerKey: @preconcurrency EnvironmentKey {
    static var defaultValue: LocaleManager {
        LocaleManager.shared
    }
}

extension EnvironmentValues {
    /// Access to LocaleManager through environment
    var localeManager: LocaleManager {
        get { self[LocaleManagerKey.self] }
        set { self[LocaleManagerKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Injects LocaleManager into the environment
    /// - Parameter localeManager: LocaleManager instance to inject
    /// - Returns: Modified view with LocaleManager in environment
    @MainActor
    func injectLocaleManager(_ localeManager: LocaleManager) -> some View {
        self.environment(\.localeManager, localeManager)
    }
    
    /// Injects the shared LocaleManager into the environment
    /// - Returns: Modified view with LocaleManager in environment
    @MainActor
    func injectLocaleManager() -> some View {
        self.environment(\.localeManager, LocaleManager.shared)
    }
}

// MARK: - Debug Support

#if DEBUG
extension LocaleManager {
    /// Debug description for development
    var debugDescription: String {
        return """
        LocaleManager Debug:
        - Current Language: \(currentLanguage.displayName) (\(currentLanguage.rawValue))
        - Current Locale: \(currentLocale.identifier)
        - Requires Restart: \(requiresRestart)
        - Available Languages: \(SupportedLanguage.allCases.map { $0.displayName }.joined(separator: ", "))
        """
    }
    
    /// Prints debug info to console
    func printDebugInfo() {
        print(debugDescription)
    }
}
#endif
