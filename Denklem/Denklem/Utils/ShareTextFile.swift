//
//  ShareTextFile.swift
//  Denklem
//
//  Created by ozkan on 27.11.2026.
//

import Foundation

// MARK: - Share Text File
/// Writes a calculation summary to a temporary `.txt` file for the share sheet.
/// File names are ASCII and date based on purpose: Unicode file names broke sharing on iOS
/// (commit 82e461c). Used by every result screen with a share button.
enum ShareTextFile {

    /// - Parameters:
    ///   - text: Plain-text summary of the result
    ///   - name: File name prefix, e.g. "Denklem" or "Denklem_SerialDisputes"
    /// - Returns: URL of the written file, e.g. `Denklem_SerialDisputes_2026_11_27.txt`
    static func url(for text: String, name: String) -> URL {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")   // ASCII digits, Gregorian calendar
        formatter.dateFormat = "yyyy_MM_dd"
        let fileName = "\(name)_\(formatter.string(from: Date()))"

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).txt")
        try? text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
