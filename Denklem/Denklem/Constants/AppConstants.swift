//
//  AppConstants.swift
//  Denklem
//
//  Created by ozkan on 15.07.2025.
//

import Foundation
import SwiftUI


// MARK: - App Constants
struct AppConstants {
    
    // MARK: - App Information
    static let appName = "DENKLEM"
    static let appDisplayName = "Denklem - Arabuluculuk Ücreti Hesaplama"
    static let appVersion = "2.0.0"
    static let buildNumber = "1"
    static var bundleIdentifier: String {
    return Bundle.main.bundleIdentifier ?? "unknown"
    }
    
    // MARK: - App Store Information
    static let appStoreID = "YOUR_APP_STORE_ID" // Will be updated after App Store submission
    static let appStoreURL = "https://apps.apple.com/app/id\(appStoreID)"
    static let appStoreReviewURL = "https://apps.apple.com/app/id\(appStoreID)?action=write-review"
    
    // MARK: - Developer Information
    static let developerName = "Özkan Cömert"
    static let developerEmail = "info@ozco.studio"
    static let companyName = "OZCO Studio"
    static let companyWebsite = "https://denklem.org"
    
    // MARK: - Legal Information
    static let legislationTitle = "Arabuluculuk Ücret Tarifesi"
    static let availableYears = [2025, 2026]
    static let currentYear = 2025
    static let defaultYear = 2025
    static let legislationSource = "Adalet Bakanlığı"
    static let legislationURL = "https://www.adalet.gov.tr"
    
    // MARK: - Feature Flags
    static let isDebugMode = true
    static let enableAnalytics = false
    static let enableCrashReporting = false
    static let enableBetaFeatures = false
    
    // MARK: - Default Values
    static let defaultLanguage: SupportedLanguage = .turkish
    static let defaultTheme = "system" // "light", "dark", "system"
    
    // MARK: - Animation & UI
    static let defaultAnimationDuration: Double = 0.3
    static let fastAnimationDuration: Double = 0.2
    static let slowAnimationDuration: Double = 0.5
    
    // MARK: - File Management
    static let documentsDirectory = "Documents"
    static let cacheDirectory = "Cache"
    static let temporaryDirectory = "tmp"
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let selectedLanguage = "selectedLanguage"
        static let selectedTheme = "selectedTheme"
        static let isFirstLaunch = "isFirstLaunch"
        static let lastUsedTariffYear = "lastUsedTariffYear"
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let calculationHistory = "calculationHistory"
        static let userPreferences = "userPreferences"
    }

    // MARK: - Calculation Limits
    static let maxCalculationAmount: Double = 10_000_000.0
    static let minCalculationAmount: Double = 1.0
    static let maxPartyCount = 1000
    static let minPartyCount = 2
    
    // MARK: - Notification Names
    struct NotificationNames {
        static let themeChanged = "themeChanged"
        static let languageChanged = "languageChanged"
        static let tariffYearChanged = "tariffYearChanged"
        static let calculationCompleted = "calculationCompleted"
    }
    
    // MARK: - Error Codes
    struct ErrorCodes {
        static let invalidInput = 1001
        static let calculationError = 1002
        static let fileError = 1004
        static let validationError = 1005
    }
    
    // MARK: - Accessibility
    struct Accessibility {
        static let buttonMinimumHeight: Double = 44.0
        static let minimumTouchTarget: Double = 44.0
        static let defaultFontSize: Double = 16.0
        static let largeFontSize: Double = 20.0
    }
    
    // MARK: - Debug & Development
    #if DEBUG
    static let isProductionBuild = false
    static let showDebugInfo = true
    static let enableTestData = true
    #else
    static let isProductionBuild = true
    static let showDebugInfo = false
    static let enableTestData = false
    #endif
}

// MARK: - App Constants Extension
extension AppConstants {
    
    /// Returns the current app version with build number
    static var fullVersion: String {
        return "\(appVersion) (\(buildNumber))"
    }
    
    /// Returns the app display name with version
    static var appNameWithVersion: String {
        return "\(appDisplayName) v\(appVersion)"
    }
    
    /// Returns the copyright string
    static var copyrightString: String {
        let currentYear = Calendar.current.component(.year, from: Date())
        return "© \(currentYear) \(companyName). " + NSLocalizedString("all_rights_reserved", comment: "All rights reserved")
    }
    
    /// Returns the legal disclaimer
    static var legalDisclaimer: String {
        return String(
            format: NSLocalizedString("legal_disclaimer", comment: "Legal disclaimer"),
            currentYear
        )
    }
    
    /// Returns the contact information
    static var contactInfo: String {
        return "İletişim: \(developerEmail)\nWeb: \(companyWebsite)"
    }
}

// MARK: - Language Support
enum SupportedLanguage: String, CaseIterable {
    case turkish = "tr"
    case english = "en"
    
    var displayName: String {
        switch self {
        case .turkish: return "Türkçe"
        case .english: return "English"
        }
    }
}
