//
//  AmountFormatter.swift
//  Denklem
//
//  Created by ozkan on 10.02.2026.
//

import Foundation

// MARK: - Amount Formatter
/// Shared utility for locale-aware currency input formatting
/// Used by all ViewModel's that accept monetary amount input
/// Handles thousand grouping separators and decimal separator detection
@MainActor
enum AmountFormatter {

    // MARK: - Public API

    /// Formats a currency input string in-place with locale-aware thousand separators and decimals
    /// - Parameter text: The input text to format (modified in-place)
    /// - Parameter locale: The locale to use for formatting (defaults to app's current locale)
    static func format(_ text: inout String, locale: Locale? = nil) {
        let resolvedLocale = locale ?? LocaleManager.shared.currentLocale
        let decimalSeparator = resolvedLocale.decimalSeparator ?? ","
        let groupingSeparator = resolvedLocale.groupingSeparator ?? "."

        // Step 1: Keep only digits, dots, and commas
        var cleaned = String(text.unicodeScalars.filter {
            CharacterSet.decimalDigits.contains($0) || $0 == "." || $0 == ","
        })

        // Step 2: Find ONLY the locale's decimal separator - not just any separator
        // This fixes the bug where grouping separator was being treated as decimal
        let decimalSepChar = Character(decimalSeparator)
        let decimalSepIndex = cleaned.lastIndex(of: decimalSepChar)

        // Step 3: Check if the locale's decimal separator exists and has 0-2 digits after it
        var integerPart = ""
        var decimalPart = ""
        var hasDecimal = false

        if let sepIndex = decimalSepIndex {
            let afterSep = String(cleaned[cleaned.index(after: sepIndex)...])
            // Only treat as decimal if there are 0-2 digits after the LOCALE's decimal separator
            if afterSep.count <= 2 {
                hasDecimal = true
                integerPart = String(cleaned[..<sepIndex])
                decimalPart = afterSep
            } else {
                // More than 2 digits - this is not a decimal separator
                integerPart = cleaned
            }
        } else {
            integerPart = cleaned
        }

        // Step 4: Remove ALL separators from integer part (both are grouping separators now)
        integerPart = integerPart.replacingOccurrences(of: ".", with: "")
        integerPart = integerPart.replacingOccurrences(of: ",", with: "")

        // Step 5: Rebuild cleaned string
        if hasDecimal {
            cleaned = integerPart + decimalSeparator + decimalPart
        } else {
            cleaned = integerPart
        }

        // If empty, clear
        guard !cleaned.isEmpty else {
            text = ""
            return
        }

        let hasTrailingDecimalSeparator = cleaned.hasSuffix(decimalSeparator)

        // Split into integer and decimal parts for formatting
        let components = cleaned.components(separatedBy: decimalSeparator)
        let finalIntegerPart = components[0]
        let finalDecimalPart = components.count > 1 ? components[1] : ""

        // Format integer part with grouping separators
        if !finalIntegerPart.isEmpty, let number = Double(finalIntegerPart), number >= 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = resolvedLocale
            formatter.groupingSeparator = groupingSeparator
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 0

            if let formatted = formatter.string(from: NSNumber(value: number)) {
                let newValue: String
                if !finalDecimalPart.isEmpty {
                    // Limit decimal part to 2 digits
                    let limitedDecimal = String(finalDecimalPart.prefix(2))
                    newValue = formatted + decimalSeparator + limitedDecimal
                } else if hasTrailingDecimalSeparator {
                    newValue = formatted + decimalSeparator
                } else {
                    newValue = formatted
                }

                // Only update if value actually changed
                if text != newValue {
                    text = newValue
                }
            }
        } else if cleaned == decimalSeparator {
            // If user just types decimal separator
            let newValue = "0" + decimalSeparator
            if text != newValue {
                text = newValue
            }
        }
    }
}
