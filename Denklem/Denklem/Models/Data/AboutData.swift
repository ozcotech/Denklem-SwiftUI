//
//  AboutData.swift
//  Denklem
//
//  Created by ozkan on 21.07.2025.
//

import Foundation
import SwiftUI

// MARK: - About Data
/// Central data source for app information, metadata, and about screen content
/// Combines static data from AppConstants with dynamic Bundle information
struct AboutData {
    
    // MARK: - App Information
    
    /// App name from Bundle or AppConstants fallback
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
               Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ??
               AppConstants.appName
    }
    
    /// App version from Bundle or AppConstants fallback
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ??
               AppConstants.appVersion
    }
    
    /// Build number from Bundle or AppConstants fallback
    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ??
               AppConstants.buildNumber
    }
    
    /// Bundle identifier
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? AppConstants.bundleIdentifier
    }
    
    /// Full version string (version + build)
    static var fullVersionString: String {
        return "\(appVersion) (\(buildNumber))"
    }
    
    /// Localized app name using LocalizationKeys
    static var localizedAppName: String {
        LocalizationKeys.AppInfo.name.localized
    }

    /// Localized app tagline using LocalizationKeys
    static var localizedAppTagline: String {
        LocalizationKeys.AppInfo.tagline.localized
    }

    /// Localized app description using LocalizationKeys
    static var localizedAppDescription: String {
        LocalizationKeys.AppInfo.description.localized
    }
    
    // MARK: - Developer Information
    
    /// Developer name from AppConstants
    static let developerName = AppConstants.developerName
    
    /// Developer email from AppConstants
    static let developerEmail = AppConstants.developerEmail
    
    /// Company name from AppConstants
    static let companyName = AppConstants.companyName
    
    /// Company website from AppConstants
    static let companyWebsite = AppConstants.companyWebsite
    
    /// GitHub repository URL from AppConstants
    static let githubURL = AppConstants.githubURL
    
    /// Localized contact information
    static var localizedContactInfo: String {
        return AppConstants.localizedContactInfo
    }
    
    // MARK: - Legal Information
    
    /// Copyright text with current year
    static var copyrightText: String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let copyrightKey = LocalizationKeys.About.copyright.localized
        return "© \(currentYear) \(developerName). \(copyrightKey)"
    }
    
    /// Legal disclaimer for tariff calculations
    static func legalDisclaimer(for year: Int) -> String {
        let disclaimerKey = LocalizationKeys.Legal.disclaimer.localized
        let sourceKey = LocalizationKeys.Legal.source.localized
        return "\(disclaimerKey)\n\n\(sourceKey): \(AppConstants.legislationSource) (\(year))"
    }
    
    // MARK: - Feature Information
    
    /// Supported tariff years from TariffConstants
    static var supportedYears: [Int] {
        return TariffConstants.availableYears
    }
    
    /// Supported languages from AppConstants
    static var supportedLanguages: [SupportedLanguage] {
        return SupportedLanguage.allCases
    }
    
    // MARK: - Data Sources & References
    
    /// Official legislation source
    static var legislationSource: String {
        return AppConstants.legislationSource
    }
    
    /// Official legislation URL
    static var legislationURL: String {
        return AppConstants.legislationURL
    }
    
    /// Legislation title
    static var legislationTitle: String {
        return AppConstants.legislationTitle
    }
    
    // MARK: - App Store Information
    
    /// App Store ID from AppConstants
    static var appStoreID: String {
        return AppConstants.appStoreID
    }
    
    /// App Store URL
    static var appStoreURL: String {
        return AppConstants.appStoreURL
    }
    
    /// App Store review URL
    static var appStoreReviewURL: String {
        return AppConstants.appStoreReviewURL
    }
    
    // MARK: - Technical Information
    
    /// Build configuration
    static var buildConfiguration: String {
        #if DEBUG
        return "Debug"
        #else
        return "Release"
        #endif
    }
    
    /// Compilation date
    static var compilationDate: Date {
        return Date() // This would be set during build process
    }
    
    // MARK: - Usage Statistics (Mock Data)
    
    /// App launch count (would be stored in UserDefaults)
    static var appLaunchCount: Int {
        return UserDefaults.standard.integer(forKey: "AppLaunchCount")
    }
    
    /// First launch date (would be stored in UserDefaults)
    static var firstLaunchDate: Date? {
        return UserDefaults.standard.object(forKey: "FirstLaunchDate") as? Date
    }
    
    /// Last calculation date (would be stored in UserDefaults)
    static var lastCalculationDate: Date? {
        return UserDefaults.standard.object(forKey: "LastCalculationDate") as? Date
    }
    
    // MARK: - Credits & Acknowledgments
    
    /// App credits
    static var credits: [Credit] {
        return [
            Credit(
                name: "SwiftUI Framework",
                description: "Apple's declarative UI framework",
                type: .framework
            ),
            Credit(
                name: "Turkish Ministry of Justice",
                description: "Official mediation tariff source",
                type: .dataSource
            ),
            Credit(
                name: "Özkan Cömert",
                description: "App development and design",
                type: .development
            )
        ]
    }
}

// MARK: - Supporting Data Models

/// Credit information for acknowledgments
struct Credit {
    let name: String
    let description: String
    let type: CreditType
    
    enum CreditType {
        case framework
        case dataSource
        case development
        case design
        case testing
        case translation
    }
}

// MARK: - AboutData Extension for Convenience Methods
extension AboutData {
    
    /// Validates app data integrity
    static func validateData() -> Bool {
        // Basic validation checks
        guard !appName.isEmpty,
              !appVersion.isEmpty,
              !buildNumber.isEmpty,
              !developerName.isEmpty,
              !supportedYears.isEmpty else {
            return false
        }
        
        return true
    }
    
    /// Returns debug information (Debug builds only)
    #if DEBUG
    static var debugInfo: String {
        return """
        DEBUG BUILD INFORMATION:
        Bundle ID: \(bundleIdentifier)
        Build: \(buildConfiguration)
        Compilation: \(compilationDate)
        Launch Count: \(appLaunchCount)
        First Launch: \(firstLaunchDate?.description ?? "Never")
        Last Calculation: \(lastCalculationDate?.description ?? "Never")
        """
    }
    #endif
}
