//
//  ConsumerDisputeResult.swift
//  Denklem
//
//  Created by ozkan on 13.05.2026.
//
//  Domain models for consumer dispute mediation fee calculation.
//  Used by ConsumerDisputeViewModel and ConsumerDisputeResultSheet.
//
//  Legal references:
//  - 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu MADDE 7/2 and 18/A-12
//  - 6502 sayılı Tüketicinin Korunması Hakkında Kanun MADDE 73/A-3
//

import Foundation

// MARK: - Payment Responsibility
/// Who covers the mediation fee in a consumer dispute settlement
enum PaymentResponsibility: String, CaseIterable, Identifiable {
    case consumer   // The consumer (claimant) pays
    case equal      // Split equally between consumer and seller
    case seller     // The seller (counterparty) pays

    var id: String { rawValue }

    /// Localized display name
    var displayName: String {
        switch self {
        case .consumer:
            return LocalizationKeys.ConsumerDispute.payerConsumer.localized
        case .equal:
            return LocalizationKeys.ConsumerDispute.payerEqual.localized
        case .seller:
            return LocalizationKeys.ConsumerDispute.payerSeller.localized
        }
    }
}

// MARK: - Interpretation Result
/// Per-interpretation breakdown of who pays what in a consumer dispute.
/// Two interpretations (A: broad/consumer-favourable, B: narrow/mediator-favourable) are
/// computed in parallel and presented side by side.
struct InterpretationResult {
    /// Amount paid by the consumer out of pocket
    let consumerPays: Double
    /// Amount paid by the seller (counterparty)
    let sellerPays: Double
    /// Amount paid by the Ministry of Justice on behalf of the consumer (capped at 2 hourly rates)
    let governmentPays: Double
    /// Total amount the mediator actually receives (consumerPays + sellerPays + governmentPays)
    let mediatorReceives: Double
}

// MARK: - Consumer Dispute Result
/// Aggregated result for a consumer dispute mediation fee calculation.
/// Mirrors MediationFee but adds the 73/A-3 government subsidy and dual interpretation outputs.
struct ConsumerDisputeResult {

    // MARK: - Inputs (echoed back for the result sheet)

    /// The settlement amount the parties agreed on (TL)
    let agreementAmount: Double
    /// Tariff year used in the calculation
    let tariffYear: TariffYear
    /// Who took on responsibility for the mediation fee
    let paymentResponsibility: PaymentResponsibility

    // MARK: - Core Calculation

    /// Total mediation fee from the standard Second-Part bracket calculation (TL).
    /// Same value the regular MediationFee feature would produce for this amount.
    let totalFee: Double
    /// Government payment ceiling for the consumer side, fixed at 2 hourly rates × consumer hourly rate.
    /// Always assumes 2 parties (1 consumer side + 1 seller); not affected by actual party count.
    let governmentPayment: Double
    /// Consumer's share under an equal split (totalFee / 2). Reference value, used by Interpretation B.
    let consumerShareNormal: Double
    /// Seller's share under an equal split (totalFee / 2)
    let sellerShareNormal: Double

    // MARK: - Interpretations

    /// Interpretation A — broad / consumer-favourable.
    /// Under 73/A-3, the consumer's own share obligation is treated as fully waived
    /// (covered by the Ministry within the cap). Mediator may receive less than totalFee.
    let interpretationA: InterpretationResult

    /// Interpretation B — narrow / mediator-favourable.
    /// 73/A-3 only caps what the Ministry pays; the consumer still owes the remainder of their share.
    /// Endorsed by the Ministry's 2024 advisory opinion: a consumer who freely consents may pay the fee.
    let interpretationB: InterpretationResult

    // MARK: - Bracket Breakdown (for the calculation method card)

    /// Per-tier breakdown of the bracket fee calculation
    let bracketSteps: [BracketBreakdownStep]
    /// Sum of the bracket steps before the minimum-fee floor is applied
    let bracketTotal: Double
    /// The statutory minimum fee floor for this tariff year (9.000 TL for 2026)
    let minimumFee: Double
    /// True when the minimum fee floor was applied because the bracket total fell below it
    let usedMinimumFee: Bool
}
