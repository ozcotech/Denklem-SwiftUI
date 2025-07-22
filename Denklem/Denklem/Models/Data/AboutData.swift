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
        return NSLocalizedString(LocalizationKeys.AppInfo.name, comment: "App name")
    }
    
    /// Localized app tagline using LocalizationKeys
    static var localizedAppTagline: String {
        return NSLocalizedString(LocalizationKeys.AppInfo.tagline, comment: "App tagline")
    }
    
    /// Localized app description using LocalizationKeys
    static var localizedAppDescription: String {
        return NSLocalizedString(LocalizationKeys.AppInfo.description, comment: "App description")
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
    
    /// Localized contact information
    static var localizedContactInfo: String {
        return AppConstants.localizedContactInfo
    }
    
    // MARK: - Legal Information
    
    /// Copyright text with current year
    static var copyrightText: String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let copyrightKey = NSLocalizedString(LocalizationKeys.About.copyright, comment: "Copyright text")
        return "© \(currentYear) \(developerName). \(copyrightKey)"
    }
    
    /// Legal disclaimer for tariff calculations
    static func legalDisclaimer(for year: Int) -> String {
        let disclaimerKey = NSLocalizedString(LocalizationKeys.Legal.disclaimer, comment: "Legal disclaimer")
        let sourceKey = NSLocalizedString(LocalizationKeys.Legal.source, comment: "Legal source")
        return "\(disclaimerKey)\n\n\(sourceKey): \(AppConstants.legislationSource) (\(year))"
    }
    
    /// Privacy policy text key
    static var privacyPolicyKey: String {
        return NSLocalizedString(LocalizationKeys.Legal.privacyPolicy, comment: "Privacy policy")
    }
    
    /// Terms of use text key
    static var termsOfUseKey: String {
        return NSLocalizedString(LocalizationKeys.Legal.termsOfUse, comment: "Terms of use")
    }
    
    // MARK: - Feature Information
    
    /// Supported tariff years from TariffConstants
    static var supportedYears: [Int] {
        return TariffConstants.availableYears
    }
    
    /// Current tariff year from TariffConstants
    static var currentTariffYear: Int {
        return TariffConstants.currentYear
    }
    
    /// Number of supported dispute types from DisputeConstants
    static var supportedDisputeTypesCount: Int {
        return DisputeConstants.DisputeTypeKeys.allKeys.count
    }
    
    /// Supported dispute types list
    static var supportedDisputeTypes: [String] {
        return DisputeConstants.DisputeTypeKeys.allKeys
    }
    
    /// Supported languages from AppConstants
    static var supportedLanguages: [SupportedLanguage] {
        return SupportedLanguage.allCases
    }
    
    /// Supported language codes
    static var supportedLanguageCodes: [String] {
        return supportedLanguages.map { $0.code }
    }
    
    /// Number of supported calculation types
    static var supportedCalculationTypesCount: Int {
        return DisputeConstants.CalculationTypeKeys.allKeys.count
    }
    
    /// Feature flags summary
    static var enabledFeatures: [String] {
        var features: [String] = []
        
        if TariffConstants.smmCalculationEnabled {
            features.append("SMM Calculation")
        }
        
        if TariffConstants.timeCalculationEnabled {
            features.append("Time Calculation")
        }
        
        if AppConstants.enableAnalytics {
            features.append("Analytics")
        }
        
        if AppConstants.enableBetaFeatures {
            features.append("Beta Features")
        }
        
        return features
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
    
    /// Data source information for each tariff year
    static func getDataSource(for year: Int) -> DataSource {
        switch year {
        case 2025:
            return DataSource(
                year: 2025,
                isOfficial: true,
                source: legislationSource,
                url: legislationURL,
                lastUpdated: Date(), // Should be actual legislation date
                isFinalized: true
            )
        case 2026:
            return DataSource(
                year: 2026,
                isOfficial: false,
                source: "Estimated Data",
                url: legislationURL,
                lastUpdated: Date(),
                isFinalized: false
            )
        default:
            return DataSource(
                year: year,
                isOfficial: false,
                source: "Unknown",
                url: "",
                lastUpdated: Date(),
                isFinalized: false
            )
        }
    }
    
    /// All data sources
    static var allDataSources: [DataSource] {
        return supportedYears.map { getDataSource(for: $0) }
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
    
    /// iOS version requirement (from Bundle or default)
    static var minimumIOSVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "MinimumOSVersion") as? String ?? "16.0"
    }
    
    /// Target device families
    static var supportedDevices: [String] {
        return ["iPhone", "iPad"] // SwiftUI supports both
    }
    
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
                name: "OZCO Studio",
                description: "App development and design",
                type: .development
            )
        ]
    }
    
    /// Open source libraries (if any)
    static var openSourceLibraries: [OpenSourceLibrary] {
        return [] // Add any third-party libraries here
    }
    
    // MARK: - Localized Sections for About Screen
    
    /// About screen sections with localized content
    static var aboutSections: [AboutSection] {
        return [
            AboutSection(
                title: NSLocalizedString(LocalizationKeys.About.appInfo, comment: ""),
                items: [
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.version, comment: ""), value: fullVersionString),
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.developer, comment: ""), value: developerName),
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.company, comment: ""), value: companyName)
                ]
            ),
            AboutSection(
                title: NSLocalizedString(LocalizationKeys.About.features, comment: ""),
                items: [
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.supportedYears, comment: ""), value: supportedYears.map(String.init).joined(separator: ", ")),
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.disputeTypes, comment: ""), value: "\(supportedDisputeTypesCount)"),
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.languages, comment: ""), value: supportedLanguages.map(\.displayName).joined(separator: ", "))
                ]
            ),
            AboutSection(
                title: NSLocalizedString(LocalizationKeys.About.legal, comment: ""),
                items: [
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.dataSource, comment: ""), value: legislationSource),
                    AboutItem(label: NSLocalizedString(LocalizationKeys.About.copyright, comment: ""), value: copyrightText)
                ]
            )
        ]
    }
}

// MARK: - Supporting Data Models

/// Data source information for tariff data
struct DataSource {
    let year: Int
    let isOfficial: Bool
    let source: String
    let url: String
    let lastUpdated: Date
    let isFinalized: Bool
    
    var statusText: String {
        if isOfficial && isFinalized {
            return NSLocalizedString(LocalizationKeys.About.officialData, comment: "")
        } else if isFinalized {
            return NSLocalizedString(LocalizationKeys.About.finalizedData, comment: "")
        } else {
            return NSLocalizedString(LocalizationKeys.About.estimatedData, comment: "")
        }
    }
}

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

/// Open source library information
struct OpenSourceLibrary {
    let name: String
    let version: String
    let license: String
    let url: String
    let description: String
}

/// About screen section structure
struct AboutSection {
    let title: String
    let items: [AboutItem]
}

/// About screen item structure
struct AboutItem {
    let label: String
    let value: String
    let isAction: Bool
    let action: (() -> Void)?
    
    init(label: String, value: String, isAction: Bool = false, action: (() -> Void)? = nil) {
        self.label = label
        self.value = value
        self.isAction = isAction
        self.action = action
    }
}

// MARK: - AboutData Extension for Convenience Methods
extension AboutData {
    
    /// Returns formatted app information string
    static var formattedAppInfo: String {
        return """
        \(localizedAppName)
        \(localizedAppTagline)
        \(NSLocalizedString(LocalizationKeys.About.version, comment: "")): \(fullVersionString)
        \(NSLocalizedString(LocalizationKeys.About.developer, comment: "")): \(developerName)
        """
    }
    
    /// Returns formatted feature summary
    static var featureSummary: String {
        return """
        • \(supportedYears.count) \(NSLocalizedString(LocalizationKeys.About.tariffYears, comment: ""))
        • \(supportedDisputeTypesCount) \(NSLocalizedString(LocalizationKeys.About.disputeTypes, comment: ""))
        • \(supportedLanguages.count) \(NSLocalizedString(LocalizationKeys.About.languages, comment: ""))
        • \(supportedCalculationTypesCount) \(NSLocalizedString(LocalizationKeys.About.calculationTypes, comment: ""))
        """
    }
    
    /// Returns formatted technical information
    static var technicalInfo: String {
        return """
        \(NSLocalizedString(LocalizationKeys.About.bundleId, comment: "")): \(bundleIdentifier)
        \(NSLocalizedString(LocalizationKeys.About.minIOSVersion, comment: "")): \(minimumIOSVersion)
        \(NSLocalizedString(LocalizationKeys.About.buildConfig, comment: "")): \(buildConfiguration)
        """
    }
    
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
