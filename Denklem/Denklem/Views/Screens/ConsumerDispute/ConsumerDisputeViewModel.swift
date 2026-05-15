//
//  ConsumerDisputeViewModel.swift
//  Denklem
//
//  Created by ozkan on 13.05.2026.
//
//  Calculation logic for the consumer dispute mediation fee feature.
//  Produces a ConsumerDisputeResult containing the total bracket fee, the
//  Ministry of Justice subsidy (73/A-3), and both legal interpretations (A & B).
//

import Foundation
import Combine

@available(iOS 26.0, *)
@MainActor
final class ConsumerDisputeViewModel: ObservableObject {

    // MARK: - Inputs

    /// Tariff year selected by the user
    @Published var selectedYear: TariffYear

    /// Settlement amount entered by the user (raw text from the input field)
    @Published var amountText: String = ""

    /// Who covers the mediation fee. Defaults to .consumer because the typical real-world
    /// scenario is the consumer initiating the application and bearing the cost.
    @Published var paymentResponsibility: PaymentResponsibility = .consumer

    // MARK: - Outputs

    /// Latest computed result. Reset whenever inputs change materially.
    @Published var calculationResult: ConsumerDisputeResult?

    /// Drives the result sheet presentation
    @Published var showResults: Bool = false

    /// True while calculate() is running (kept for parity with other VMs; calc is synchronous so flips briefly)
    @Published var isLoading: Bool = false

    /// User-facing validation/error message, displayed in an ErrorBanner
    @Published var errorMessage: String?

    // MARK: - Init

    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }

    // MARK: - Computed

    /// Available tariff years for the YearPicker
    var availableYears: [TariffYear] { TariffYear.allCases }

    /// Localized screen title
    var screenTitle: String {
        LocalizationKeys.DisputeCategory.consumerDispute.localized
    }

    /// Localized calculate button label
    var calculateButtonText: String {
        LocalizationKeys.General.calculate.localized
    }

    /// Whether the Calculate button should be enabled
    var canCalculate: Bool {
        parsedAmount != nil && !isLoading
    }

    /// Parsed numeric amount from `amountText`, respecting the user's current locale
    /// (TR uses "," as decimal separator, EN uses ".").
    private var parsedAmount: Double? {
        let locale = LocaleManager.shared.currentLocale
        let decimalSeparator = locale.decimalSeparator ?? ","
        let groupingSeparator = locale.groupingSeparator ?? "."

        let cleaned = amountText
            .replacingOccurrences(of: groupingSeparator, with: "")
            .replacingOccurrences(of: decimalSeparator, with: ".")

        guard let value = Double(cleaned), value >= ValidationConstants.Amount.minimum else {
            return nil
        }
        return value
    }

    // MARK: - Public API

    /// Runs the calculation and, on success, sets `calculationResult` and triggers the result sheet.
    func calculate() {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        guard let amount = parsedAmount else {
            errorMessage = LocalizationKeys.Validation.invalidAmount.localized
            return
        }

        let tariff = selectedYear.getTariffProtocol()
        let result = compute(amount: amount, tariff: tariff)

        calculationResult = result
        // showResults is flipped by the inline result card's tap gesture, matching the
        // MediationFee pattern — keeps the user in control of when the sheet appears.
    }

    /// Live-formats the amount input with locale-aware thousand separators while typing
    func formatAmountInput() {
        AmountFormatter.format(&amountText)
    }

    /// Clears inputs and any displayed result
    func reset() {
        amountText = ""
        paymentResponsibility = .consumer
        calculationResult = nil
        errorMessage = nil
        showResults = false
    }

    // MARK: - Calculation

    /// Builds the full ConsumerDisputeResult for an already-validated amount.
    /// Pure function; safe to call from previews/tests.
    private func compute(amount: Double, tariff: TariffProtocol) -> ConsumerDisputeResult {
        let consumerKey = DisputeConstants.DisputeTypeKeys.consumer

        // 1) Total mediation fee — Second Part bracket calculation on the settlement amount.
        //    partyCount is irrelevant for the bracket math (see CONSUMER_DISPUTE_CALCULATION_PLAN.md
        //    "Kararlar / 1"); we pass the statutory 2-party assumption used for the subsidy.
        let breakdown = tariff.calculateAgreementFeeWithBreakdown(
            disputeType: consumerKey,
            amount: amount,
            partyCount: 2
        )
        let totalFee = breakdown.fee

        // 2) Government subsidy ceiling under 6502/73A-3 — always 2 hourly rates,
        //    fixed at 1 consumer side + 1 seller side regardless of actual party count.
        let governmentPayment = tariff.getHourlyRate(for: consumerKey) * 2.0

        // 3) Equal-split reference shares (used by Interpretation B math)
        let consumerShare = totalFee / 2.0
        let sellerShare = totalFee / 2.0

        // 4) Both interpretations
        let interpretationA = computeInterpretationA(
            totalFee: totalFee,
            sellerShare: sellerShare,
            governmentPayment: governmentPayment
        )
        let interpretationB = computeInterpretationB(
            totalFee: totalFee,
            consumerShare: consumerShare,
            sellerShare: sellerShare,
            governmentPayment: governmentPayment
        )

        return ConsumerDisputeResult(
            agreementAmount: amount,
            tariffYear: selectedYear,
            paymentResponsibility: paymentResponsibility,
            totalFee: totalFee,
            governmentPayment: governmentPayment,
            consumerShareNormal: consumerShare,
            sellerShareNormal: sellerShare,
            interpretationA: interpretationA,
            interpretationB: interpretationB,
            bracketSteps: breakdown.bracketSteps,
            bracketTotal: breakdown.bracketTotal,
            minimumFee: breakdown.minimumFee,
            usedMinimumFee: breakdown.usedMinimumFee
        )
    }

    /// Interpretation A — broad / consumer-favourable.
    /// The consumer's own share obligation is treated as fully waived by 73/A-3.
    /// When the consumer is responsible, they only owe the seller's share; the government
    /// covers up to 2 hourly rates and the mediator may receive less than the total fee.
    private func computeInterpretationA(
        totalFee: Double,
        sellerShare: Double,
        governmentPayment: Double
    ) -> InterpretationResult {
        switch paymentResponsibility {
        case .consumer:
            return InterpretationResult(
                consumerPays: sellerShare,
                sellerPays: 0,
                governmentPays: governmentPayment,
                mediatorReceives: sellerShare + governmentPayment
            )
        case .equal:
            return InterpretationResult(
                consumerPays: 0,
                sellerPays: sellerShare,
                governmentPays: governmentPayment,
                mediatorReceives: sellerShare + governmentPayment
            )
        case .seller:
            // Seller pays everything → consumer has no obligation → 73/A-3 doesn't trigger.
            return InterpretationResult(
                consumerPays: 0,
                sellerPays: totalFee,
                governmentPays: 0,
                mediatorReceives: totalFee
            )
        }
    }

    /// Interpretation B — narrow / mediator-favourable.
    /// 73/A-3 only caps what the Ministry pays; the consumer still owes the remainder of their share.
    /// Endorsed by the Ministry's 2024 advisory opinion.
    private func computeInterpretationB(
        totalFee: Double,
        consumerShare: Double,
        sellerShare: Double,
        governmentPayment: Double
    ) -> InterpretationResult {
        switch paymentResponsibility {
        case .consumer:
            let consumerPays = max(0, totalFee - governmentPayment)
            return InterpretationResult(
                consumerPays: consumerPays,
                sellerPays: 0,
                governmentPays: governmentPayment,
                mediatorReceives: consumerPays + governmentPayment
            )
        case .equal:
            let consumerPays = max(0, consumerShare - governmentPayment)
            return InterpretationResult(
                consumerPays: consumerPays,
                sellerPays: sellerShare,
                governmentPays: governmentPayment,
                mediatorReceives: consumerPays + sellerShare + governmentPayment
            )
        case .seller:
            return InterpretationResult(
                consumerPays: 0,
                sellerPays: totalFee,
                governmentPays: 0,
                mediatorReceives: totalFee
            )
        }
    }

}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension ConsumerDisputeViewModel {
    static var preview: ConsumerDisputeViewModel {
        ConsumerDisputeViewModel(selectedYear: .year2026)
    }
}
#endif
