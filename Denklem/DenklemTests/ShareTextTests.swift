//
//  ShareTextTests.swift
//  DenklemTests
//
//  Created by ozkan on 27.11.2026.
//
//  Share button of result screens (Documentation/SHARE_RESULTS_PLAN.md):
//  the shared file has an ASCII, date-based name and the text carries the on-screen values.
//

import XCTest
@testable import Denklem

final class ShareTextTests: XCTestCase {

    func testShareTextFile_asciiDateBasedName() throws {
        let url = ShareTextFile.url(for: "Denklem ğüşıöç", name: "Denklem_SerialDisputes")
        let name = url.lastPathComponent

        XCTAssertNotNil(name.range(of: #"^Denklem_SerialDisputes_\d{4}_\d{2}_\d{2}\.txt$"#, options: .regularExpression), name)
        XCTAssertTrue(name.allSatisfy(\.isASCII), name)
        XCTAssertEqual(try String(contentsOf: url, encoding: .utf8), "Denklem ğüşıöç")
    }

    func testSerialDisputesShareText() {
        let result = SerialDisputesCalculator.calculate(disputeType: .commercial, fileCount: 10, tariffYear: .year2026)
        let text = result.shareText

        XCTAssertTrue(text.contains(result.formattedTotalFee), text)
        XCTAssertTrue(text.contains(result.formattedFeePerFile), text)
        XCTAssertTrue(text.contains("\(LocalizationKeys.SerialDisputes.fileCountLabel.localized): 10"), text)
        XCTAssertTrue(text.contains("2026"), text)
        XCTAssertTrue(text.hasSuffix(LocalizationKeys.General.calculatedWithDenklem.localized), text)
    }

    func testReinstatementShareText_agreedAndNotAgreed() {
        let agreed = ReinstatementCalculator.calculate(input: ReinstatementInput(
            agreementStatus: .agreed, tariffYear: .year2026, partyCount: 2,
            nonReinstatementCompensation: 100_000, idlePeriodWage: 60_000, otherRights: nil))
        XCTAssertTrue(agreed.shareText.contains(agreed.formattedTotalFee), agreed.shareText)
        XCTAssertTrue(agreed.shareText.contains(LocalizationKeys.Reinstatement.totalAmount.localized), agreed.shareText)

        let notAgreed = ReinstatementCalculator.calculate(input: ReinstatementInput(
            agreementStatus: .notAgreed, tariffYear: .year2026, partyCount: 2,
            nonReinstatementCompensation: nil, idlePeriodWage: nil, otherRights: nil))
        XCTAssertTrue(notAgreed.shareText.contains(notAgreed.formattedTotalFee), notAgreed.shareText)
        XCTAssertTrue(notAgreed.shareText.contains(LocalizationKeys.Reinstatement.noAgreementWarning.localized),
                      notAgreed.shareText)
    }
}
