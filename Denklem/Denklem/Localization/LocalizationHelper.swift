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
    
    /// Current locale
    static var currentLocale: Locale {
        return Locale.current
    }
    
    /// Current language code (e.g., "tr", "en")
    static var currentLanguageCode: String {
        if #available(iOS 16.0, *) {
            return currentLocale.language.languageCode?.identifier ?? "tr"
        } else {
            return currentLocale.languageCode ?? "tr"
        }
    }
    
    /// Current region code (e.g., "TR", "US")
    static var currentRegionCode: String {
        if #available(iOS 16.0, *) {
            return currentLocale.region?.identifier ?? "TR"
        } else {
            return currentLocale.regionCode ?? "TR"
        }
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
    
    /// Formats integers with thousands separators
    static func formatInteger(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = currentLocale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)) ?? String(number)
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
    
    /// Formats date using locale-specific format
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
    
    /// Formats date and time
    static func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    /// Formats date for export (consistent format)
    static func formatDateForExport(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        
        // Use TariffConstants export format logic
        if currentLanguageCode == "en" {
            formatter.dateFormat = "MM/dd/yyyy"  // American format
        } else {
            formatter.dateFormat = "dd.MM.yyyy"  // European/Turkish format
        }
        
        return formatter.string(from: date)
    }
    
    /// Formats time only
    static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLocale
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    
    // MARK: - Pluralization Support
    
    /// Returns pluralized string based on count
    static func pluralize(_ baseKey: String, count: Int) -> String {
        // Try to get pluralized version first
        let pluralKey = count == 1 ? "\(baseKey).singular" : "\(baseKey).plural"
        let pluralString = NSLocalizedString(pluralKey, comment: "")
        
        // If pluralized version doesn't exist, use base key
        if pluralString == pluralKey {
            let baseString = NSLocalizedString(baseKey, comment: "")
            return String(format: baseString, count)
        }
        
        return String(format: pluralString, count)
    }
    
    /// Returns appropriate week/weeks text based on count
    static func formatWeeks(_ count: Int) -> String {
        if count == 1 {
            return "\(count) " + NSLocalizedString(LocalizationKeys.TimeCalculation.Result.week, comment: "")
        } else {
            return "\(count) " + NSLocalizedString(LocalizationKeys.TimeCalculation.Result.weeks, comment: "")
        }
    }
    
    /// Returns appropriate party count text
    static func formatPartyCount(_ count: Int) -> String {
        return pluralize(LocalizationKeys.Result.partyCount, count: count)
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
    
    // MARK: - Input Validation Helpers
    
    /// Validates if a string represents a valid number for current locale
    static func isValidNumber(_ text: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.locale = currentLocale
        formatter.numberStyle = .decimal
        
        return formatter.number(from: text) != nil
    }
    
    /// Converts localized number string to Double
    static func doubleFromLocalizedString(_ text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = currentLocale
        formatter.numberStyle = .decimal
        
        return formatter.number(from: text)?.doubleValue
    }
    
    /// Converts localized number string to Int
    static func intFromLocalizedString(_ text: String) -> Int? {
        let formatter = NumberFormatter()
        formatter.locale = currentLocale
        formatter.numberStyle = .decimal
        
        return formatter.number(from: text)?.intValue
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
    
    /// Returns layout direction for current locale
    static var layoutDirection: LayoutDirection {
        return isRTLLanguage ? .rightToLeft : .leftToRight
    }
    
    // MARK: - Export Helpers
    
    /// Formats data for CSV export
    static func formatForCSV(_ value: Any) -> String {
        switch value {
        case let doubleValue as Double:
            return formatCurrencyForExport(doubleValue)
        case let intValue as Int:
            return String(intValue)
        case let stringValue as String:
            return stringValue.replacingOccurrences(of: "\"", with: "\"\"")
        case let dateValue as Date:
            return formatDateForExport(dateValue)
        default:
            return String(describing: value)
        }
    }
    
    /// Creates localized file name for exports
    static func createLocalizedFileName(prefix: String, date: Date = Date()) -> String {
        let dateString = formatDateForExport(date).replacingOccurrences(of: "/", with: "-").replacingOccurrences(of: ".", with: "-")
        return "\(prefix)_\(dateString)"
    }
}

// MARK: - Layout Direction Enum
enum LayoutDirection {
    case leftToRight
    case rightToLeft
}

// MARK: - Localization Helper Extensions
extension LocalizationHelper {
    
    /// Detects if the app should use Turkish-specific formatting
    static var isTurkishLocale: Bool {
        return currentLanguageCode.lowercased() == "tr"
    }
    
    /// Detects if the app should use English-specific formatting
    static var isEnglishLocale: Bool {
        return currentLanguageCode.lowercased() == "en"
    }
    
    /// Returns currency symbol based on locale
    static var localizedCurrencySymbol: String {
        // Always use TRY symbol for this app
        return "₺"
    }
    
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
