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
extension Bundle {
    
    /// Returns a bundle for the currently selected language
    /// Falls back to main bundle if the language bundle is not found
    /// Uses UserDefaults directly to avoid MainActor requirement
    static var localizedBundle: Bundle {
        // Read language code directly from UserDefaults to avoid MainActor isolation
        let languageCode = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguage) ?? "tr"
        
        // Try to find the bundle for the selected language
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            // Fallback to main bundle if language bundle not found
            return Bundle.main
        }
        
        return bundle
    }
}
