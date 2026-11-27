//
//  AttorneyFeeTariffContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - Attorney Fee Tariff Content Models

/// A single fee row in a tariff table (e.g., "İlk 600.000,00 TL için → %16")
struct AttorneyFeeItem {
    let number: String      // "1", "2a", "5b", "" (for continuation rows)
    let description: String
    let amount: String      // e.g., "4.000,00 TL" or "Üçüncü kısma göre belirlenir"
}

/// A section/chapter in the attorney fee tariff appendix
struct AttorneyFeeTableSection {
    let partTitle: String       // e.g., "BİRİNCİ KISIM – BİRİNCİ BÖLÜM"
    let subtitle: String        // e.g., "Dava ve Takiplerin Dışındaki..."
    let items: [AttorneyFeeItem]
    let footnote: String?
}

/// A bracket row in the third part percentage table
struct AttorneyFeeBracket {
    let number: Int
    let description: String     // e.g., "İlk 600.000,00 TL için"
    let rate: String            // e.g., "%16"
}

/// Complete attorney fee minimum tariff content
struct AttorneyFeeTariffContent {
    let year: Int
    let gazetteInfo: String
    let effectiveDate: String
    let articles: [LawArticle]
    let tableSections: [AttorneyFeeTableSection]
    let part3Title: String
    let part3Subtitle: String
    let part3Brackets: [AttorneyFeeBracket]
}

// MARK: - Factory

extension AttorneyFeeTariffContent {

    /// Returns attorney fee tariff content for the given year
    static func content(for year: Int) -> AttorneyFeeTariffContent? {
        switch year {
        case 2025: return Self.content2025
        case 2026: return Self.content2026
        case 2027: return Self.content2027
        default: return nil
        }
    }

    /// Converts the entire tariff content to a plain text string for sharing
    func toPlainText() -> String {
        var text = ""

        text += "\(year) Yılı Avukatlık Asgari Ücret Tarifesi\n"
        text += "\(gazetteInfo)\n"
        text += "Yürürlük Tarihi: \(effectiveDate)\n\n"

        for article in articles {
            text += "MADDE \(article.number) – \(article.title)\n\n"
            for (index, paragraph) in article.paragraphs.enumerated() {
                text += "(\(index + 1)) \(paragraph)\n\n"
            }
        }

        for section in tableSections {
            text += "\(section.partTitle)\n"
            text += "\(section.subtitle)\n\n"
            for item in section.items {
                let num = item.number.isEmpty ? "   " : "\(item.number)."
                text += "\(num) \(item.description): \(item.amount)\n"
            }
            if let footnote = section.footnote {
                text += "\n* \(footnote)\n"
            }
            text += "\n"
        }

        text += "\(part3Title)\n\(part3Subtitle)\n\n"
        for bracket in part3Brackets {
            text += "\(bracket.number). \(bracket.description): \(bracket.rate)\n"
        }

        return text
    }
}
