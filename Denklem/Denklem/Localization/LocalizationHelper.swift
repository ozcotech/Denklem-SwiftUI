//
//  LocalizationHelper.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - Localization Helper
/// Helper utilities for localization, formatting, and internationalization
struct LocalizationHelper {
    
    // MARK: - Current Locale Properties
    
    /// Selected language code from UserDefaults (app's language, not device)
    /// Reads directly from UserDefaults to avoid MainActor requirement
    private static var selectedLanguageCode: String {
        return UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguage) ?? "tr"
    }
    
    /// Current locale based on app's selected language (not device locale)
    static var currentLocale: Locale {
        if let language = SupportedLanguage(rawValue: selectedLanguageCode) {
            return Locale(identifier: language.localeIdentifier)
        }
        return Locale(identifier: SupportedLanguage.turkish.localeIdentifier)
    }
    
    /// Current language code (e.g., "tr", "en") — based on app's selected language
    static var currentLanguageCode: String {
        return selectedLanguageCode
    }
    
    /// Current region code (e.g., "TR", "US") — based on app's selected language
    static var currentRegionCode: String {
        let region = currentLocale.region?.identifier
        return region ?? "TR"
    }
    
    /// Is current language right-to-left
    static var isRTLLanguage: Bool {
        if #available(iOS 16.0, *) {
            return Locale.Language(identifier: currentLanguageCode).characterDirection == .rightToLeft
        } else {
            return Locale.characterDirection(forLanguage: currentLanguageCode) == .rightToLeft
        }
    }
    
    /// Preferred languages array
    static var preferredLanguages: [String] {
        return Locale.preferredLanguages
    }
    
    // MARK: - Currency Formatting
    
    /// Formats currency using TariffConstants settings
    static func formatCurrency(_ amount: Double, currencyCode: String = "TRY", symbol: String = "₺") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = symbol
        formatter.locale = currentLocale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(symbol) \(amount)"
    }
    
    /// Formats currency without decimals for whole numbers
    static func formatCurrencyCompact(_ amount: Double, currencyCode: String = "TRY", symbol: String = "₺") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = symbol
        formatter.locale = currentLocale
        
        // Use compact notation for large numbers
        if amount >= 1_000_000 {
            formatter.numberStyle = .currencyAccounting
            let millions = amount / 1_000_000
            return String(format: "%.1fM %@", millions, symbol)
        } else if amount >= 1_000 {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(symbol) \(amount)"
    }
    
    /// Formats currency for display in results
    static func formatCurrencyForDisplay(_ amount: Double) -> String {
        return formatCurrency(amount)
    }
    
    /// Formats currency for export (CSV, PDF, etc.)
    static func formatCurrencyForExport(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX") // Consistent format for export
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? String(amount)
    }
    
    // MARK: - Number Formatting
    
    /// Formats numbers with locale-specific separators
    static func formatNumber(_ number: Double, minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = currentLocale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: NSNumber(value: number)) ?? String(number)
    }
    
    /// Formats a decimal rate (e.g., 0.06) as a plain number string (e.g., "6" or "1,5")
    /// Used for displaying bracket rates like "%6", "%1,5"
    static func formatRate(_ rate: Double) -> String {
        let percentage = rate * 100
        let formatter = NumberFormatter()
        formatter.locale = currentLocale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: percentage)) ?? "\(percentage)"
    }

    /// Formats percentage values
    static func formatPercentage(_ value: Double, minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = currentLocale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
    }
    
    // MARK: - Date Formatting
    
    /// Formats date using app's selected language locale
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }
    
    /// Formats date for export (consistent format)
    static func formatDateForExport(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        
        // Use TariffConstants export format logic
        if currentLanguageCode == SupportedLanguage.english.rawValue {
            formatter.dateFormat = "MM/dd/yyyy"  // American format
        } else {
            formatter.dateFormat = "dd.MM.yyyy"  // European/Turkish format
        }
        
        return formatter.string(from: date)
    }
    
    // MARK: - Localized String Helpers
    
    /// Gets localized string with type safety
    static func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    /// Gets localized string with format arguments
    static func localizedString(for key: String, arguments: CVarArg..., comment: String = "") -> String {
        let format = NSLocalizedString(key, comment: comment)
        return String(format: format, arguments: arguments)
    }
    
    /// Gets localized string using LocalizationKeys
    static func localizedString(for keyPath: String) -> String {
        return NSLocalizedString(keyPath, comment: "")
    }
    
    // MARK: - User Interface Helpers
    
    /// Returns appropriate decimal separator for current locale
    static var decimalSeparator: String {
        return currentLocale.decimalSeparator ?? ","
    }
    
    /// Returns appropriate thousands separator for current locale
    static var thousandsSeparator: String {
        return currentLocale.groupingSeparator ?? "."
    }
}

// MARK: - Localization Helper Extensions
extension LocalizationHelper {
    
    /// Returns localized app name
    static var localizedAppName: String {
        return NSLocalizedString(LocalizationKeys.AppInfo.name, comment: "App name")
    }
    
    /// Returns localized app tagline
    static var localizedAppTagline: String {
        return NSLocalizedString(LocalizationKeys.AppInfo.tagline, comment: "App tagline")
    }
}

// MARK: - Debug Helpers
#if DEBUG
extension LocalizationHelper {
    
    /// Prints current locale information for debugging
    static func printLocaleInfo() {
        print("=== Locale Information ===")
        print("Language Code: \(currentLanguageCode)")
        print("Region Code: \(currentRegionCode)")
        print("Locale Identifier: \(currentLocale.identifier)")
        print("Decimal Separator: \(decimalSeparator)")
        print("Thousands Separator: \(thousandsSeparator)")
        print("Is RTL: \(isRTLLanguage)")
        print("Preferred Languages: \(preferredLanguages)")
        print("=========================")
    }
    
    /// Tests number formatting with sample data
    static func testNumberFormatting() {
        let testNumber = 1234567.89
        print("=== Number Formatting Test ===")
        print("Original: \(testNumber)")
        print("Currency: \(formatCurrency(testNumber))")
        print("Currency Compact: \(formatCurrencyCompact(testNumber))")
        print("Number: \(formatNumber(testNumber))")
        print("Percentage: \(formatPercentage(0.15))")
        print("==============================")
    }
}
#endif
