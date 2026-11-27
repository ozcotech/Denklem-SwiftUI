//
//  CalculationLockTests.swift
//  DenklemTests
//
//  Created by ozkan on 25.11.2026.
//
//  Locks the calculation results of the live app before the 2027 preparation refactor
//  (Documentation/CODE_CLEANUP_2027_PREP_PLAN.md). Every refactor step must keep these green.
//
//  Expected values are derived from the official tariff tables in Documentation/
//  (2025_/2026_ARABULUCULUK_UCRET_TARIFESI.md, 20xx_AVUKATLIK_ASGARI_UCRET_TARIFESI.md),
//  not copied from the code under test. SMM and time tests lock the current behaviour.
//
//  When the 2027 mediation tariff is added, extend the tables below with 2027 values
//  and update `testTariffYears_supportedYears`.
//

import XCTest
@testable import Denklem

final class CalculationLockTests: XCTestCase {

    /// Monetary comparisons tolerate floating point noise only (1 kuruş)
    private let accuracy = 0.01

    // MARK: - Official Tariff Tables (Part 1)

    /// Party counts probed and the tariff tier they fall into
    /// Tiers: [0] 2 parties (per-party rate × 2), [1] 3-5, [2] 6-10, [3] 11+
    private let partyProbes: [(parties: Int, tier: Int)] = [
        (2, 0), (3, 1), (5, 1), (6, 2), (10, 2), (11, 3), (1000, 3)
    ]

    /// 2026 tariff, Part 1 hourly rate for 2 parties (per party) — RG 26.12.2025 / 33119
    private let hourlyRates2026: [DisputeType: Double] = [
        .family: 1_000, .commercial: 1_500, .workerEmployer: 1_130, .consumer: 1_000,
        .rent: 1_170, .neighbor: 1_170, .condominium: 1_170, .partnershipDissolution: 1_170,
        .agriculturalProduction: 1_000, // not listed → "Diğer" (Art. 8)
        .other: 1_000
    ]

    /// 2026 tariff, Part 1 hourly fee per tier (tier 0 = 2 × per-party rate)
    private let tierFees2026: [DisputeType: [Double]] = [
        .family: [2_000, 2_200, 2_300, 2_400],
        .commercial: [3_000, 3_200, 3_300, 3_400],
        .workerEmployer: [2_260, 2_460, 2_560, 2_660],
        .consumer: [2_000, 2_200, 2_300, 2_400],
        .rent: [2_340, 2_540, 2_640, 2_740],
        .neighbor: [2_340, 2_540, 2_640, 2_740],
        .condominium: [2_340, 2_540, 2_640, 2_740],
        .partnershipDissolution: [2_340, 2_540, 2_640, 2_740],
        .agriculturalProduction: [2_000, 2_200, 2_300, 2_400],
        .other: [2_000, 2_200, 2_300, 2_400]
    ]

    /// 2025 tariff, Part 1 hourly rate for 2 parties (per party)
    private let hourlyRates2025: [DisputeType: Double] = [
        .family: 785, .commercial: 1_150, .workerEmployer: 785, .consumer: 785,
        .rent: 835, .neighbor: 835, .condominium: 835, .partnershipDissolution: 900,
        .agriculturalProduction: 785, // not listed → "Diğer" (Art. 8)
        .other: 785
    ]

    /// 2025 tariff, Part 1 hourly fee per tier (tier 0 = 2 × per-party rate)
    private let tierFees2025: [DisputeType: [Double]] = [
        .family: [1_570, 1_650, 1_750, 1_850],
        .commercial: [2_300, 2_350, 2_450, 2_550],
        .workerEmployer: [1_570, 1_650, 1_750, 1_850],
        .consumer: [1_570, 1_650, 1_750, 1_850],
        .rent: [1_670, 1_750, 1_850, 1_950],
        .neighbor: [1_670, 1_750, 1_850, 1_950],
        .condominium: [1_670, 1_750, 1_850, 1_950],
        .partnershipDissolution: [1_800, 2_000, 2_100, 2_200],
        .agriculturalProduction: [1_570, 1_650, 1_750, 1_850],
        .other: [1_570, 1_650, 1_750, 1_850]
    ]

    // MARK: - Helpers

    /// Runs the mediation fee calculation exactly like `MediationFeeViewModel.calculate()`:
    /// agreement → monetary + amount (party count irrelevant, Art. 7), otherwise → party count.
    private func mediationFee(
        _ year: TariffYear,
        _ type: DisputeType,
        agreementAmount: Double? = nil,
        parties: Int = 2,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> MediationFee? {
        let hasAgreement = agreementAmount != nil
        let inputResult = CalculationInput.create(
            disputeType: type,
            calculationType: hasAgreement ? .monetary : .nonMonetary,
            agreementStatus: hasAgreement ? .agreed : .notAgreed,
            partyCount: hasAgreement ? ValidationConstants.PartyCount.minimum : parties,
            tariffYear: year,
            disputeAmount: agreementAmount
        )
        guard case .success(let input) = inputResult else {
            XCTFail("Input rejected for \(year) \(type)", file: file, line: line)
            return nil
        }
        let result = TariffCalculator.calculateFee(input: input)
        XCTAssertTrue(result.isSuccess, "Calculation failed for \(year) \(type)", file: file, line: line)
        return result.isSuccess ? result.mediationFee : nil
    }

    private func attorneyFee(
        _ year: Int,
        monetary: Bool = true,
        agreed: Bool = true,
        amount: Double? = nil,
        court: AttorneyFeeConstants.CourtType? = nil
    ) -> Double {
        AttorneyFeeCalculator.calculate(input: AttorneyFeeInput(
            isMonetary: monetary,
            hasAgreement: agreed,
            agreementAmount: amount,
            courtType: court,
            tariffYear: year
        )).fee
    }

    // MARK: - Supported Years

    func testTariffYears_supportedYears() {
        // Update this list when the 2027 mediation tariff is added
        XCTAssertEqual(TariffYear.allCases.map(\.rawValue), [2025, 2026])

        for year in [2025, 2026] {
            XCTAssertNotNil(TariffFactory.createTariff(for: year), "factory \(year)")
            XCTAssertTrue(ValidationConstants.validateYear(year).isValid, "validation \(year)")
            XCTAssertTrue(TenancyCalculationConstants.isValidYear(year), "tenancy \(year)")
            XCTAssertTrue(ReinstatementConstants.isValidYear(year), "reinstatement \(year)")
            XCTAssertTrue(
                SerialDisputesInput(disputeType: .commercial, fileCount: 10, tariffYear: year).validate().isValid,
                "serial \(year)"
            )
        }

        for year in [2024, 2027] {
            XCTAssertNil(TariffFactory.createTariff(for: year), "factory \(year)")
            XCTAssertFalse(ValidationConstants.validateYear(year).isValid, "validation \(year)")
            XCTAssertFalse(TenancyCalculationConstants.isValidYear(year), "tenancy \(year)")
            XCTAssertFalse(ReinstatementConstants.isValidYear(year), "reinstatement \(year)")
            XCTAssertFalse(
                SerialDisputesInput(disputeType: .commercial, fileCount: 10, tariffYear: year).validate().isValid,
                "serial \(year)"
            )
        }

        for tariffYear in TariffYear.allCases {
            XCTAssertEqual(tariffYear.getTariffProtocol().year, tariffYear.rawValue)
        }
    }

    func testTariffYears_currentYearFollowsCalendar() {
        // The mediation tariff changes on 1 January: the active year is the calendar year,
        // or the latest known tariff if the calendar year has no tariff yet.
        let calendarYear = Calendar.current.component(.year, from: Date())
        let expected = TariffYear(rawValue: calendarYear) ?? TariffYear.allCases.last!
        XCTAssertEqual(TariffYear.current, expected)

        // Every "current year" constant must agree with TariffYear.current
        XCTAssertEqual(TariffConstants.currentYear, TariffYear.current.rawValue)
    }

    /// The start screen "Enter" button must open the mediation screen with the current tariff year,
    /// even when an older app version saved a year on the device (key "lastUsedTariffYear", ≤ 2.6.1).
    @MainActor
    func testStartScreen_opensWithCurrentYear_ignoringSavedYear() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("StartScreenViewModel requires iOS 26") }
        let key = "lastUsedTariffYear"
        let defaults = UserDefaults.standard
        let original = defaults.object(forKey: key)
        defer {
            if let original { defaults.set(original, forKey: key) } else { defaults.removeObject(forKey: key) }
        }

        defaults.set(2025, forKey: key)
        XCTAssertEqual(startScreenYear(), TariffYear.current)
    }

    @available(iOS 26.0, *)
    @MainActor
    private func startScreenYear() -> TariffYear {
        StartScreenViewModel().selectedYear
    }

    // MARK: - Tariff Data (Part 1)

    func testTariffData2026_hourlyRatesAndPartyTiers() {
        assertPartOne(TariffYear.year2026.getTariffProtocol(), hourly: hourlyRates2026, tiers: tierFees2026)
    }

    func testTariffData2025_hourlyRatesAndPartyTiers() {
        assertPartOne(TariffYear.year2025.getTariffProtocol(), hourly: hourlyRates2025, tiers: tierFees2025)
    }

    /// Every tariff year must define all dispute types, all four party tiers, both minimum fees,
    /// the serial dispute fees and well-formed brackets. A missing entry would otherwise fall back
    /// silently to a hard-coded value in TariffProtocol (e.g. 1.000 / 2.000 / 9.000 / 13.000 TL).
    func testTariffData_completeForEveryYear() {
        for year in TariffYear.allCases {
            let tariff = year.getTariffProtocol()
            XCTAssertEqual(tariff.year, year.rawValue, "\(year)")
            for type in DisputeType.allCases {
                XCTAssertNotNil(tariff.hourlyRates[type.rawValue], "\(year) hourly rate \(type)")
                XCTAssertEqual(tariff.fixedFees[type.rawValue]?.count, 4, "\(year) party tiers \(type)")
            }
            XCTAssertEqual(tariff.partyCountThresholds, [2, 5, 10, Int.max], "\(year) party thresholds")
            XCTAssertNotNil(tariff.minimumFees["general"], "\(year) general minimum (Art. 7/7)")
            XCTAssertNotNil(tariff.minimumFees["commercial"], "\(year) commercial minimum (Art. 7/6)")
            XCTAssertGreaterThan(tariff.serialCommercialFeePerFile, 0, "\(year) serial commercial (Art. 7/4)")
            XCTAssertGreaterThan(tariff.serialNonCommercialFeePerFile, 0, "\(year) serial other (Art. 7/4)")

            // Brackets use cumulative upper limits: strictly increasing, last one open-ended
            let limits = tariff.brackets.map(\.limit)
            XCTAssertEqual(limits.last, .infinity, "\(year) last bracket")
            XCTAssertEqual(limits, limits.sorted(), "\(year) bracket order")
            XCTAssertEqual(Set(limits).count, limits.count, "\(year) duplicate bracket limit")
        }
    }

    private func assertPartOne(
        _ tariff: TariffProtocol,
        hourly: [DisputeType: Double],
        tiers: [DisputeType: [Double]],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(tariff.minimumHoursMultiplier, 2, "\(tariff.year) hours", file: file, line: line)
        XCTAssertEqual(hourly.count, DisputeType.allCases.count, "table must cover every dispute type", file: file, line: line)

        for type in DisputeType.allCases {
            let key = type.rawValue
            XCTAssertEqual(tariff.getHourlyRate(for: key), hourly[type] ?? -1, accuracy: accuracy,
                           "\(tariff.year) \(key) hourly", file: file, line: line)
            for probe in partyProbes {
                let expected = tiers[type]?[probe.tier] ?? -1
                XCTAssertEqual(tariff.getFixedFee(for: key, partyCount: probe.parties), expected, accuracy: accuracy,
                               "\(tariff.year) \(key) \(probe.parties) parties", file: file, line: line)
                // Non-agreement / non-monetary = 2 hours (minimum hours multiplier)
                XCTAssertEqual(tariff.calculateNonAgreementFee(disputeType: key, partyCount: probe.parties),
                               expected * 2, accuracy: accuracy, file: file, line: line)
                XCTAssertEqual(tariff.calculateNonMonetaryFee(disputeType: key, partyCount: probe.parties),
                               expected * 2, accuracy: accuracy, file: file, line: line)
            }
        }
    }

    // MARK: - Tariff Data (Minimum Fees, Art. 7/6 & 7/7)

    func testMinimumFees() {
        let higherMinimum: Set<DisputeType> = [.commercial, .partnershipDissolution]
        let expected: [(TariffYear, general: Double, higher: Double)] = [
            (.year2025, 6_000, 9_000),
            (.year2026, 9_000, 13_000)
        ]
        for (year, general, higher) in expected {
            let tariff = year.getTariffProtocol()
            for type in DisputeType.allCases {
                let want = higherMinimum.contains(type) ? higher : general
                XCTAssertEqual(tariff.getMinimumFee(for: type.rawValue), want, accuracy: accuracy, "\(year) \(type)")
            }
        }
    }

    // MARK: - Tariff Data (Part 2 Brackets)

    func testBrackets2026_boundaries() {
        let tariff = TariffYear.year2026.getTariffProtocol()
        let cases: [(amount: Double, fee: Double)] = [
            (600_000, 36_000), (1_000_000, 56_000), (1_560_000, 84_000), (3_120_000, 146_400),
            (6_240_000, 240_000), (15_600_000, 427_200), (28_080_000, 614_400),
            (53_040_000, 864_000), (60_000_000, 898_800)
        ]
        for c in cases {
            XCTAssertEqual(tariff.calculateBracketFee(for: c.amount), c.fee, accuracy: accuracy, "2026 \(c.amount)")
        }
    }

    func testBrackets2025_boundaries() {
        let tariff = TariffYear.year2025.getTariffProtocol()
        let cases: [(amount: Double, fee: Double)] = [
            (300_000, 18_000), (500_000, 28_000), (780_000, 42_000), (1_000_000, 50_800),
            (1_560_000, 73_200), (3_120_000, 120_000), (7_800_000, 213_600),
            (14_040_000, 307_200), (26_520_000, 432_000), (30_000_000, 449_400)
        ]
        for c in cases {
            XCTAssertEqual(tariff.calculateBracketFee(for: c.amount), c.fee, accuracy: accuracy, "2025 \(c.amount)")
        }
    }

    // MARK: - Mediation Fee (TariffCalculator, main screen)

    func testMediationFee2026() {
        // Agreement: bracket vs minimum (higher wins)
        assertFee(mediationFee(.year2026, .workerEmployer, agreementAmount: 100_000), 9_000, usedMinimum: true)
        assertFee(mediationFee(.year2026, .workerEmployer, agreementAmount: 500_000), 30_000, usedMinimum: false)
        assertFee(mediationFee(.year2026, .commercial, agreementAmount: 150_000), 13_000, usedMinimum: true)
        assertFee(mediationFee(.year2026, .partnershipDissolution, agreementAmount: 150_000), 13_000, usedMinimum: true)
        assertFee(mediationFee(.year2026, .commercial, agreementAmount: 1_000_000), 56_000, usedMinimum: false)
        // Bracket equals the minimum exactly → minimum flag stays false
        assertFee(mediationFee(.year2026, .rent, agreementAmount: 150_000), 9_000, usedMinimum: false)

        // No agreement / non-monetary: tier fee × 2 hours
        assertFee(mediationFee(.year2026, .workerEmployer, parties: 2), 4_520)
        assertFee(mediationFee(.year2026, .commercial, parties: 3), 6_400)
        assertFee(mediationFee(.year2026, .consumer, parties: 7), 4_600)
        assertFee(mediationFee(.year2026, .rent, parties: 12), 5_480)
        assertFee(mediationFee(.year2026, .family, parties: 2), 4_000)
        assertFee(mediationFee(.year2026, .other, parties: 11), 4_800)
    }

    func testMediationFee2025() {
        assertFee(mediationFee(.year2025, .workerEmployer, agreementAmount: 50_000), 6_000, usedMinimum: true)
        assertFee(mediationFee(.year2025, .commercial, agreementAmount: 100_000), 9_000, usedMinimum: true)
        assertFee(mediationFee(.year2025, .partnershipDissolution, agreementAmount: 120_000), 9_000, usedMinimum: true)
        assertFee(mediationFee(.year2025, .workerEmployer, agreementAmount: 1_000_000), 50_800, usedMinimum: false)

        assertFee(mediationFee(.year2025, .workerEmployer, parties: 2), 3_140)
        assertFee(mediationFee(.year2025, .partnershipDissolution, parties: 4), 4_000)
        assertFee(mediationFee(.year2025, .rent, parties: 6), 3_700)
        assertFee(mediationFee(.year2025, .family, parties: 3), 3_300)
    }

    private func assertFee(
        _ fee: MediationFee?,
        _ expected: Double,
        usedMinimum: Bool? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let fee else { return } // failure already reported by the helper
        XCTAssertEqual(fee.amount, expected, accuracy: accuracy, file: file, line: line)
        if let usedMinimum {
            XCTAssertEqual(fee.usedMinimumFee, usedMinimum, "minimum flag", file: file, line: line)
        }
    }

    // MARK: - Tenancy (Art. 7/5 mediation, Art. 9/1 attorney)

    func testTenancyMediationFee() {
        // Eviction: half of the yearly rent; determination: full yearly difference; each separately, then summed
        let eviction2026 = TenancyCalculator.calculateMediationFee(tariffYear: .year2026, evictionAmount: 600_000)
        XCTAssertEqual(eviction2026.totalFee, 18_000, accuracy: accuracy)
        XCTAssertFalse(eviction2026.isMinimumApplied)

        let determination2026 = TenancyCalculator.calculateMediationFee(tariffYear: .year2026, determinationAmount: 600_000)
        XCTAssertEqual(determination2026.totalFee, 36_000, accuracy: accuracy)

        let both2026 = TenancyCalculator.calculateMediationFee(
            tariffYear: .year2026, evictionAmount: 600_000, determinationAmount: 600_000)
        XCTAssertEqual(both2026.evictionFee ?? -1, 18_000, accuracy: accuracy)
        XCTAssertEqual(both2026.determinationFee ?? -1, 36_000, accuracy: accuracy)
        XCTAssertEqual(both2026.totalFee, 54_000, accuracy: accuracy)

        // Art. 7/7 minimum applies to the total
        let small2026 = TenancyCalculator.calculateMediationFee(tariffYear: .year2026, evictionAmount: 100_000)
        XCTAssertEqual(small2026.totalFee, 9_000, accuracy: accuracy)
        XCTAssertTrue(small2026.isMinimumApplied)

        let exactMinimum2026 = TenancyCalculator.calculateMediationFee(
            tariffYear: .year2026, evictionAmount: 100_000, determinationAmount: 100_000)
        XCTAssertEqual(exactMinimum2026.totalFee, 9_000, accuracy: accuracy)
        XCTAssertFalse(exactMinimum2026.isMinimumApplied)

        let both2025 = TenancyCalculator.calculateMediationFee(
            tariffYear: .year2025, evictionAmount: 400_000, determinationAmount: 400_000)
        XCTAssertEqual(both2025.totalFee, 35_000, accuracy: accuracy)

        let small2025 = TenancyCalculator.calculateMediationFee(tariffYear: .year2025, evictionAmount: 100_000)
        XCTAssertEqual(small2025.totalFee, 6_000, accuracy: accuracy)
        XCTAssertTrue(small2025.isMinimumApplied)
    }

    func testTenancyAttorneyFee() {
        // Third Part brackets, each claim separately, Sulh Hukuk minimum per claim
        let cases: [(AttorneyFeeTariffYear, eviction: Double?, determination: Double?, fee: Double)] = [
            (.year2025, 1_000_000, nil, 152_000),
            (.year2025, 100_000, nil, 18_000),       // 16.000 < Sulh 18.000
            (.year2026, 1_000_000, nil, 156_000),
            (.year2026, 100_000, nil, 30_000),       // 16.000 < Sulh 30.000
            (.year2026, 1_000_000, 200_000, 188_000),
            (.year2027, 1_000_000, nil, 158_000),
            (.year2027, 200_000, nil, 40_000)        // 32.000 < Sulh 40.000
        ]
        for c in cases {
            let result = TenancyCalculator.calculateAttorneyFee(
                tariffYear: c.0, evictionAmount: c.eviction, determinationAmount: c.determination)
            XCTAssertEqual(result.fee, c.fee, accuracy: accuracy, "\(c.0) \(String(describing: c.eviction))")
        }
    }

    // MARK: - Reinstatement (İşe İade)

    func testReinstatement() {
        func fee(_ year: TariffYear, agreed: Bool, parties: Int = 2,
                 compensation: Double? = nil, wage: Double? = nil, other: Double? = nil) -> Double {
            ReinstatementCalculator.calculate(input: ReinstatementInput(
                agreementStatus: agreed ? .agreed : .notAgreed,
                tariffYear: year,
                partyCount: parties,
                nonReinstatementCompensation: compensation,
                idlePeriodWage: wage,
                otherRights: other
            )).totalFee
        }
        // Agreement: compensation + idle wage + other rights → Part 2 brackets vs worker-employer minimum
        XCTAssertEqual(fee(.year2026, agreed: true, compensation: 100_000, wage: 60_000), 9_600, accuracy: accuracy)
        XCTAssertEqual(fee(.year2026, agreed: true, compensation: 50_000, wage: 50_000, other: 20_000), 9_000, accuracy: accuracy)
        XCTAssertEqual(fee(.year2025, agreed: true, compensation: 50_000, wage: 20_000), 6_000, accuracy: accuracy)
        XCTAssertEqual(fee(.year2025, agreed: true, compensation: 300_000, wage: 200_000), 28_000, accuracy: accuracy)
        // No agreement: worker-employer tier fee × 2 hours
        XCTAssertEqual(fee(.year2026, agreed: false, parties: 2), 4_520, accuracy: accuracy)
        XCTAssertEqual(fee(.year2026, agreed: false, parties: 4), 4_920, accuracy: accuracy)
        XCTAssertEqual(fee(.year2025, agreed: false, parties: 2), 3_140, accuracy: accuracy)
        XCTAssertEqual(fee(.year2025, agreed: false, parties: 8), 3_500, accuracy: accuracy)
    }

    // MARK: - Serial Disputes (Art. 7/4)

    func testSerialDisputes() {
        let cases: [(TariffYear, SerialDisputesConstants.DisputeType, files: Int, perFile: Double, total: Double)] = [
            (.year2026, .commercial, 10, 7_500, 75_000),
            (.year2026, .nonCommercial, 10, 6_000, 60_000),
            (.year2025, .commercial, 10, 5_000, 50_000),
            (.year2025, .nonCommercial, 12, 4_000, 48_000)
        ]
        for c in cases {
            let result = SerialDisputesCalculator.calculate(disputeType: c.1, fileCount: c.files, tariffYear: c.0)
            XCTAssertEqual(result.feePerFile, c.perFile, accuracy: accuracy, "\(c.0) \(c.1)")
            XCTAssertEqual(result.totalFee, c.total, accuracy: accuracy, "\(c.0) \(c.1)")
        }
    }

    // MARK: - Consumer Dispute (6502 Art. 73/A-3)

    @MainActor
    func testConsumerDispute_totalFeeAndStatePayment() throws {
        guard #available(iOS 26.0, *) else { throw XCTSkip("ConsumerDisputeViewModel requires iOS 26") }
        let cases: [(TariffYear, amount: String, total: Double, state: Double, usedMinimum: Bool)] = [
            (.year2026, "500000", 30_000, 2_000, false), // state pays 2 × consumer hourly rate
            (.year2026, "50000", 9_000, 2_000, true),
            (.year2025, "500000", 28_000, 1_570, false)
        ]
        for c in cases {
            let result = try XCTUnwrap(consumerResult(c.0, amount: c.amount), "\(c.0) \(c.amount)")
            XCTAssertEqual(result.totalFee, c.total, accuracy: accuracy, "\(c.0) \(c.amount)")
            XCTAssertEqual(result.governmentPayment, c.state, accuracy: accuracy, "\(c.0) \(c.amount)")
            XCTAssertEqual(result.usedMinimumFee, c.usedMinimum, "\(c.0) \(c.amount)")
        }
    }

    @available(iOS 26.0, *)
    @MainActor
    private func consumerResult(_ year: TariffYear, amount: String) -> ConsumerDisputeResult? {
        let viewModel = ConsumerDisputeViewModel(selectedYear: year)
        viewModel.amountText = amount
        viewModel.calculate()
        return viewModel.calculationResult
    }

    // MARK: - Attorney Fee (Art. 16, independent attorney tariff years)

    func testAttorneyFee() {
        // Monetary + agreement: Third Part × 1.25, fixed fee × 1.25 below the threshold
        XCTAssertEqual(attorneyFee(2025, amount: 1_000_000), 190_000, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2026, amount: 1_000_000), 195_000, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2027, amount: 1_000_000), 197_500, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2025, amount: 45_000), 9_000, accuracy: accuracy)   // above 43.750 threshold
        XCTAssertEqual(attorneyFee(2026, amount: 45_000), 10_000, accuracy: accuracy)  // below 50.000
        XCTAssertEqual(attorneyFee(2027, amount: 45_000), 12_500, accuracy: accuracy)  // below 62.500
        // No agreement: fixed fee
        XCTAssertEqual(attorneyFee(2025, agreed: false, amount: 100_000), 7_000, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2026, agreed: false, amount: 100_000), 8_000, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2027, agreed: false, amount: 100_000), 10_000, accuracy: accuracy)
        // Non-monetary + agreement: court fee × 1.25
        XCTAssertEqual(attorneyFee(2025, monetary: false, court: .civilPeace), 22_500, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2026, monetary: false, court: .civilPeace), 37_500, accuracy: accuracy)
        XCTAssertEqual(attorneyFee(2027, monetary: false, court: .civilPeace), 50_000, accuracy: accuracy)
    }

    // MARK: - SMM (current behaviour, rates live in TariffConstants)

    func testSMM_ratesAndAllScenarios() {
        XCTAssertEqual(TariffConstants.kdvRate, 0.20, accuracy: 0.000_001)
        XCTAssertEqual(TariffConstants.stopajRate, 0.20, accuracy: 0.000_001)

        // (type, person, brut, kdv, stopaj, net, collected) for an entered amount of 10.000 TL
        let cases: [(SMMCalculationType, legal: Bool, brut: Double, kdv: Double, stopaj: Double, net: Double, collected: Double)] = [
            (.vatIncludedWithholdingExcluded, false, 8_333.333, 1_666.667, 0, 8_333.333, 10_000),
            (.vatIncludedWithholdingExcluded, true, 10_000, 2_000, 2_000, 8_000, 10_000),
            (.vatExcludedWithholdingIncluded, false, 10_000, 2_000, 0, 10_000, 12_000),
            (.vatExcludedWithholdingIncluded, true, 10_000, 2_000, 2_000, 8_000, 10_000),
            (.vatIncludedWithholdingIncluded, false, 8_333.333, 1_666.667, 0, 8_333.333, 10_000),
            (.vatIncludedWithholdingIncluded, true, 8_333.333, 1_666.667, 1_666.667, 6_666.667, 8_333.333),
            (.vatExcludedWithholdingExcluded, false, 10_000, 2_000, 0, 10_000, 12_000),
            (.vatExcludedWithholdingExcluded, true, 12_500, 2_500, 2_500, 10_000, 12_500)
        ]
        for c in cases {
            let result = SMMCalculator.calculateSMM(input: SMMCalculationInput(amount: 10_000, calculationType: c.0))
            let person = c.legal ? result.legalPersonResult : result.realPersonResult
            let label = "\(c.0) \(c.legal ? "legal" : "real")"
            XCTAssertEqual(person.brutFee, c.brut, accuracy: accuracy, label)
            XCTAssertEqual(person.kdv, c.kdv, accuracy: accuracy, label)
            XCTAssertEqual(person.stopaj, c.stopaj, accuracy: accuracy, label)
            XCTAssertEqual(person.netFee, c.net, accuracy: accuracy, label)
            XCTAssertEqual(person.tahsilEdilecekTutar, c.collected, accuracy: accuracy, label)
        }
    }

    // MARK: - Time Calculation (current behaviour, weeks live in TariffConstants)

    func testTimeCalculation_weekCounts() throws {
        let expectedWeeks: [DisputeType: (normal: Int, extended: Int)] = [
            .workerEmployer: (3, 4), .commercial: (6, 8), .consumer: (3, 4), .rent: (3, 4),
            .neighbor: (3, 4), .condominium: (3, 4), .family: (3, 4), .partnershipDissolution: (3, 4),
            .agriculturalProduction: (2, 3), .other: (3, 4)
        ]
        XCTAssertEqual(expectedWeeks.count, DisputeType.allCases.count, "table must cover every dispute type")

        var components = DateComponents()
        components.year = 2026; components.month = 11; components.day = 2; components.hour = 12
        let start = try XCTUnwrap(Calendar.current.date(from: components))

        for type in DisputeType.allCases {
            let calculator = TimeCalculator()
            calculator.disputeType = type
            calculator.startDate = start
            let result = calculator.calculate()
            let weeks = try XCTUnwrap(expectedWeeks[type])

            XCTAssertTrue(result.isValid, "\(type)")
            XCTAssertEqual(result.weekCount, weeks.normal, "\(type)")
            XCTAssertEqual(Calendar.current.dateComponents([.day], from: start, to: result.deadline).day,
                           weeks.normal * 7, "\(type) deadline")
            XCTAssertEqual(Calendar.current.dateComponents([.day], from: start, to: result.extendedDeadline).day,
                           weeks.extended * 7, "\(type) extended deadline")
        }
    }

    // MARK: - Legislation Documents (attorney fee tariffs shown in the app)

    /// Each in-app attorney fee tariff (one file per year) keeps its official structure
    func testAttorneyTariffDocuments_structure() throws {
        let expected: [(year: Int, gazette: String, brackets: Int)] = [
            (2025, "Resmî Gazete: 3 Ekim 2024, Sayı: 32681", 9),
            (2026, "Resmî Gazete: 4 Kasım 2025, Sayı: 33067", 10),
            (2027, "Resmî Gazete: 3 Kasım 2026, Sayı: 33419", 10)
        ]
        for e in expected {
            let document = try XCTUnwrap(AttorneyFeeTariffContent.content(for: e.year), "\(e.year)")
            XCTAssertEqual(document.year, e.year)
            XCTAssertEqual(document.gazetteInfo, e.gazette, "\(e.year)")
            XCTAssertEqual(document.articles.count, 24, "\(e.year) articles (Madde 1–24)")
            XCTAssertEqual(document.tableSections.count, 6, "\(e.year) annex table sections")
            XCTAssertEqual(document.part3Brackets.count, e.brackets, "\(e.year) third part brackets")
        }
        XCTAssertNil(AttorneyFeeTariffContent.content(for: 2024))
    }
}
