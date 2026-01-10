//
//  DenklemTests.swift
//  DenklemTests
//
//  Created by ozkan on 15.07.2025.
//

import XCTest
@testable import Denklem

final class DenklemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSMM_vatIncluded_withholdingIncluded_legalPerson_math() throws {
        let input = SMMCalculationInput(amount: 4_520.00, calculationType: .vatIncludedWithholdingIncluded)
        let result = SMMCalculator.calculateSMM(input: input)

        let legal = result.legalPersonResult

        // Expected (20% VAT, 20% withholding)
        // Gross (VAT excluded) = 4520 / 1.2 = 3766.666...
        // VAT = 753.333...
        // Withholding = 753.333...
        // Net = 3013.333...
        // Collected from payer (VAT included minus withholding) = 3766.666...
        XCTAssertEqual(legal.brutFee, 3_766.6667, accuracy: 0.01)
        XCTAssertEqual(legal.kdv, 753.3333, accuracy: 0.01)
        XCTAssertEqual(legal.stopaj, 753.3333, accuracy: 0.01)
        XCTAssertEqual(legal.netFee, 3_013.3333, accuracy: 0.01)
        XCTAssertEqual(legal.tahsilEdilecekTutar, 3_766.6667, accuracy: 0.01)
    }

}
