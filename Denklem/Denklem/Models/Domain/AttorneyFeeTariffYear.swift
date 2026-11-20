//
//  AttorneyFeeTariffYear.swift
//  Denklem
//
//  Created by ozkan on 20.11.2026.
//

import Foundation

// MARK: - Attorney Fee Tariff Year
/// Tariff years of the Avukatlık Asgari Ücret Tarifesi.
///
/// Kept separate from `TariffYear` (mediation tariff) because the two tariffs change on
/// different dates: the mediation tariff changes on 1 January, while the attorney fee tariff
/// is published in early November (or October) and is effective on publication.
/// Example: on 20 November 2026 the 2026 mediation tariff and the 2027 attorney tariff apply.
enum AttorneyFeeTariffYear: Int, CaseIterable, Identifiable, Hashable {
    case year2025 = 2025   // RG 3 Ekim 2024, Sayı 32681
    case year2026 = 2026   // RG 4 Kasım 2025, Sayı 33067
    case year2027 = 2027   // RG 3 Kasım 2026, Sayı 33419

    var id: Int { rawValue }

    /// Display name for pickers
    var displayName: String { String(rawValue) }

    // MARK: - Effective Date

    /// Turkish time zone — tariffs enter into force at the start of the publication day
    private static let turkeyTimeZone = TimeZone(identifier: "Europe/Istanbul") ?? .current

    /// Date the tariff entered into force (each tariff is effective on its publication date)
    var effectiveDate: Date {
        switch self {
        case .year2025: return Self.makeDate(year: 2024, month: 10, day: 3)
        case .year2026: return Self.makeDate(year: 2025, month: 11, day: 4)
        case .year2027: return Self.makeDate(year: 2026, month: 11, day: 3)
        }
    }

    // MARK: - Current Year

    /// Tariff in force today
    static var current: AttorneyFeeTariffYear {
        inForce(on: Date())
    }

    /// Tariff in force on a given date (latest tariff whose effective date has passed)
    static func inForce(on date: Date) -> AttorneyFeeTariffYear {
        allCases.last { $0.effectiveDate <= date } ?? allCases[0]
    }

    /// Most recent tariff known to the app (fallback for unknown years)
    static var latest: AttorneyFeeTariffYear {
        allCases[allCases.count - 1]
    }

    // MARK: - Helpers

    private static func makeDate(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = turkeyTimeZone
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date.distantPast
    }
}
