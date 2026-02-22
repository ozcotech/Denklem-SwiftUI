//
//  Bundle+Localization.swift
//  Denklem
//
//  Created by ozkan on 02.01.2026.
//

import Foundation

// MARK: - Bundle Extension for Runtime Language Switching
/// Provides a localized bundle that changes based on the user's selected language
/// This enables runtime language switching without restarting the app
/// Uses static caching to avoid redundant disk I/O on every .localized call
extension Bundle {
    
    // MARK: - Cache Storage
    
    /// Cached bundle instance — avoids ~470+ redundant Bundle creations per render cycle
    private static var _cachedBundle: Bundle?
    
    /// Language code the cached bundle was created for
    private static var _cachedLanguageCode: String?
    
    /// Returns a bundle for the currently selected language
    /// Falls back to main bundle if the language bundle is not found
    /// Uses UserDefaults directly to avoid MainActor requirement
    /// Caches result and only recreates when language changes
    static var localizedBundle: Bundle {
        let languageCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguage) ?? "en"
        
        // Return cached bundle if language hasn't changed
        if let cached = _cachedBundle, _cachedLanguageCode == languageCode {
            return cached
        }
        
        // Create and cache new bundle for the selected language
        let bundle: Bundle
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let localized = Bundle(path: path) {
            bundle = localized
        } else {
            bundle = Bundle.main
        }
        
        _cachedBundle = bundle
        _cachedLanguageCode = languageCode
        return bundle
    }
    
    /// Invalidates the cached bundle — call when language changes
    static func invalidateLocalizedBundleCache() {
        _cachedBundle = nil
        _cachedLanguageCode = nil
    }
}
